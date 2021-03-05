Return-Path: <SRS0=uRrw=ID=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 793B6C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 23:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F02D6509E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 23:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCEXAW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 18:00:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230084AbhCEW7t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 17:59:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A04B76509F
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Mar 2021 22:59:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lIJQC-0020Ct-N3
        for linux-trace-devel@vger.kernel.org; Fri, 05 Mar 2021 17:59:48 -0500
Message-ID: <20210305225948.592306106@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 05 Mar 2021 17:52:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 9/9 v2] trace-cmd: Have tracecmd_copy_headers() have a start and stop state
References: <20210305225223.794554327@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Now that TRACECMD_FILE_* states are exported, and tracecmd_read_headers()
can bring a handle up to a given state and stop, change
tracecmd_copy_headers() to use this information and allow a copy of one
handle to a file descriptor to start at any given state, and stop at
another.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |   4 +-
 lib/trace-cmd/trace-input.c                   | 109 ++++++++++++++----
 lib/trace-cmd/trace-output.c                  |   4 +-
 3 files changed, 92 insertions(+), 25 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index bd14caff93ac..322cdb1eb223 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -159,7 +159,9 @@ int tracecmd_get_parsing_failures(struct tracecmd_input *handle);
 int tracecmd_long_size(struct tracecmd_input *handle);
 int tracecmd_page_size(struct tracecmd_input *handle);
 int tracecmd_cpus(struct tracecmd_input *handle);
-int tracecmd_copy_headers(struct tracecmd_input *handle, int fd);
+int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
+			  enum tracecmd_file_states start_state,
+			  enum tracecmd_file_states end_state);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 24b3aa4001d3..add48f811ac6 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3528,14 +3528,9 @@ static int copy_header_files(struct tracecmd_input *handle, int fd)
 {
 	unsigned long long size;
 
-	if (handle->file_state < TRACECMD_FILE_HEADERS)
+	if (handle->file_state != TRACECMD_FILE_HEADERS - 1)
 		return -1;
 
-	lseek64(handle->fd, handle->header_files_start, SEEK_SET);
-
-	/* Now that the file handle has moved, change its state */
-	handle->file_state = TRACECMD_FILE_HEADERS;
-
 	/* "header_page"  */
 	if (read_copy_data(handle, 12, fd) < 0)
 		return -1;
@@ -3556,6 +3551,8 @@ static int copy_header_files(struct tracecmd_input *handle, int fd)
 	if (read_copy_data(handle, size, fd) < 0)
 		return -1;
 
+	handle->file_state = TRACECMD_FILE_HEADERS;
+
 	return 0;
 }
 
@@ -3686,35 +3683,101 @@ static int copy_command_lines(struct tracecmd_input *handle, int fd)
 	return 0;
 }
 
-int tracecmd_copy_headers(struct tracecmd_input *handle, int fd)
+/**
+ * tracecmd_copy_headers - Copy headers from a tracecmd_input handle to a file descriptor
+ * @handle: input handle for the trace.dat file to copy from.
+ * @fd: The file descriptor to copy to.
+ * @start_state: The file state to start copying from (zero for the beginnig)
+ * @end_state: The file state to stop at (zero for up to cmdlines)
+ *
+ * This is used to copy trace header data of a trace.dat file to a
+ * file descriptor. Using @start_state and @end_state it may be used
+ * multiple times against the input handle.
+ *
+ * NOTE: The input handle is also modified, and ends at the end
+ *       state as well.
+ */
+int tracecmd_copy_headers(struct tracecmd_input *handle, int fd,
+			  enum tracecmd_file_states start_state,
+			  enum tracecmd_file_states end_state)
 {
 	int ret;
 
-	/* Make sure that the input handle is up to cmd lines */
-	if (handle->file_state < TRACECMD_FILE_CMD_LINES)
+	if (!start_state)
+		start_state = TRACECMD_FILE_HEADERS;
+	if (!end_state)
+		end_state = TRACECMD_FILE_CMD_LINES;
+
+	if (start_state > end_state)
 		return -1;
 
-	ret = copy_header_files(handle, fd);
-	if (ret < 0)
-		goto out;
+	if (end_state < TRACECMD_FILE_HEADERS)
+		return 0;
 
-	ret = copy_ftrace_files(handle, fd);
-	if (ret < 0)
-		goto out;
+	if (handle->file_state >= start_state) {
+		/* Set the handle to just before the start state */
+		lseek64(handle->fd, handle->header_files_start, SEEK_SET);
+		/* Now that the file handle has moved, change its state */
+		handle->file_state = TRACECMD_FILE_INIT;
+	}
 
-	ret = copy_event_files(handle, fd);
+	/* Try to bring the input up to the start state - 1 */
+	ret = tracecmd_read_headers(handle, start_state - 1);
 	if (ret < 0)
 		goto out;
 
-	ret = copy_proc_kallsyms(handle, fd);
-	if (ret < 0)
-		goto out;
+	switch (start_state) {
+	case TRACECMD_FILE_HEADERS:
+		ret = copy_header_files(handle, fd);
+		if (ret < 0)
+			goto out;
 
-	ret = copy_ftrace_printk(handle, fd);
-	if (ret < 0)
-		goto out;
+		/* fallthrough */
+	case TRACECMD_FILE_FTRACE_EVENTS:
+		/* handle's state is now updating with the copies */
+		if (end_state <= handle->file_state)
+			return 0;
+
+		ret = copy_ftrace_files(handle, fd);
+		if (ret < 0)
+			goto out;
+
+		/* fallthrough */
+	case TRACECMD_FILE_ALL_EVENTS:
+		if (end_state <= handle->file_state)
+			return 0;
+
+		ret = copy_event_files(handle, fd);
+		if (ret < 0)
+			goto out;
 
-	ret = copy_command_lines(handle, fd);
+		/* fallthrough */
+	case TRACECMD_FILE_KALLSYMS:
+		if (end_state <= handle->file_state)
+			return 0;
+
+		ret = copy_proc_kallsyms(handle, fd);
+		if (ret < 0)
+			goto out;
+
+		/* fallthrough */
+	case TRACECMD_FILE_PRINTK:
+		if (end_state <= handle->file_state)
+			return 0;
+
+		ret = copy_ftrace_printk(handle, fd);
+		if (ret < 0)
+			goto out;
+
+		/* fallthrough */
+	case TRACECMD_FILE_CMD_LINES:
+		if (end_state <= handle->file_state)
+			return 0;
+
+		ret = copy_command_lines(handle, fd);
+	default:
+		break;
+	}
 
  out:
 	return ret < 0 ? -1 : 0;
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a26fd8537a1d..54ddcb547828 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1655,9 +1655,11 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 	if (!handle)
 		return NULL;
 
-	if (tracecmd_copy_headers(ihandle, handle->fd) < 0)
+	if (tracecmd_copy_headers(ihandle, handle->fd, 0, 0) < 0)
 		goto out_free;
 
+	handle->file_state = tracecmd_get_file_state(ihandle);
+
 	/* The file is all ready to have cpu data attached */
 	return handle;
 
-- 
2.30.0


