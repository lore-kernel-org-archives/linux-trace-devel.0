Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CF7C433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Mar 2021 14:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB55A64E07
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Mar 2021 14:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhCAOjo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Mar 2021 09:39:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:60540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235225AbhCAOjl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Mar 2021 09:39:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69F106146D;
        Mon,  1 Mar 2021 14:38:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lGjhJ-001PtI-Bv; Mon, 01 Mar 2021 09:38:57 -0500
Message-ID: <20210301143857.244340263@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 01 Mar 2021 09:37:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 4/8] trace-cmd: Move the output state updates into the functions that
 change the state
References: <20210301143724.540985351@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

It makes more sense to have the functions that change the state of the
descriptor to change the value that stores the state. This makes it more
robust in case these functions are called by something other than
create_file_fd(). That way the state changes with the update, and this
removes the dependency on create_file_fd with the state changes.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-output.c | 97 ++++++++++++++++++++++++------------
 1 file changed, 65 insertions(+), 32 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 917d20cfcfd6..6d504cbaf133 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -297,6 +297,33 @@ int tracecmd_ftrace_enable(int set)
 	return ret;
 }
 
+static int check_out_state(struct tracecmd_output *handle, int new_state)
+{
+	if (!handle)
+		return -1;
+
+	switch (new_state) {
+	case TRACECMD_FILE_HEADERS:
+	case TRACECMD_FILE_FTRACE_EVENTS:
+	case TRACECMD_FILE_ALL_EVENTS:
+	case TRACECMD_FILE_KALLSYMS:
+	case TRACECMD_FILE_PRINTK:
+	case TRACECMD_FILE_CMD_LINES:
+	case TRACECMD_FILE_CPU_COUNT:
+	case TRACECMD_FILE_OPTIONS:
+		if (handle->file_state == (new_state - 1))
+			return 0;
+		break;
+	case TRACECMD_FILE_CPU_LATENCY:
+	case TRACECMD_FILE_CPU_FLYRECORD:
+		if (handle->file_state == TRACECMD_FILE_OPTIONS)
+			return 0;
+		break;
+	}
+
+	return -1;
+}
+
 static int read_header_files(struct tracecmd_output *handle)
 {
 	tsize_t size, check_size, endian8;
@@ -305,6 +332,12 @@ static int read_header_files(struct tracecmd_output *handle)
 	int fd;
 	int ret;
 
+	if (check_out_state(handle, TRACECMD_FILE_HEADERS) < 0) {
+		warning("Cannot read header files, unexpected state 0x%X",
+			handle->file_state);
+		return -1;
+	}
+
 	path = get_tracing_file(handle, "events/header_page");
 	if (!path)
 		return -1;
@@ -373,6 +406,9 @@ static int read_header_files(struct tracecmd_output *handle)
 		return -1;
 	}
 	put_tracing_file(path);
+
+	handle->file_state = TRACECMD_FILE_HEADERS;
+
 	return 0;
 
  out_close:
@@ -609,12 +645,20 @@ static int read_ftrace_files(struct tracecmd_output *handle)
 	struct tracecmd_event_list list = { .glob = "ftrace/*" };
 	int ret;
 
+	if (check_out_state(handle, TRACECMD_FILE_FTRACE_EVENTS) < 0) {
+		warning("Cannot read ftrace files, unexpected state 0x%X",
+			handle->file_state);
+		return -1;
+	}
+
 	create_event_list_item(handle, &systems, &list);
 
 	ret = copy_event_system(handle, systems);
 
 	free_list_events(systems);
 
+	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
+
 	return ret;
 }
 
@@ -642,6 +686,11 @@ static int read_event_files(struct tracecmd_output *handle,
 	int endian4;
 	int ret;
 
+	if (check_out_state(handle, TRACECMD_FILE_ALL_EVENTS) < 0) {
+		warning("Cannot read event files, unexpected state 0x%X",
+			handle->file_state);
+		return -1;
+	}
 	/*
 	 * If any of the list is the special keyword "all" then
 	 * just do all files.
@@ -674,6 +723,7 @@ static int read_event_files(struct tracecmd_output *handle,
 		ret = copy_event_system(handle, slist);
 	}
 
+	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
  out_free:
 	free_list_events(systems);
 
@@ -728,6 +778,12 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
 	struct stat st;
 	int ret;
 
+	if (check_out_state(handle, TRACECMD_FILE_KALLSYMS) < 0) {
+		warning("Cannot read kallsyms, unexpected state 0x%X",
+			handle->file_state);
+		return -1;
+	}
+
 	if (kallsyms)
 		path = kallsyms;
 
@@ -755,6 +811,8 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
 	}
 	set_proc_kptr_restrict(1);
 
+	handle->file_state = TRACECMD_FILE_KALLSYMS;
+
 	return 0;
 }
 
@@ -765,6 +823,12 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	char *path;
 	int ret;
 
+	if (check_out_state(handle, TRACECMD_FILE_PRINTK) < 0) {
+		warning("Cannot read printk, unexpected state 0x%X",
+			handle->file_state);
+		return -1;
+	}
+
 	path = get_tracing_file(handle, "printk_formats");
 	if (!path)
 		return -1;
@@ -790,6 +854,7 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	}
 
  out:
+	handle->file_state = TRACECMD_FILE_PRINTK;
 	put_tracing_file(path);
 	return 0;
  fail:
@@ -836,33 +901,6 @@ out_free:
 	return ret;
 }
 
-static int check_out_state(struct tracecmd_output *handle, int new_state)
-{
-	if (!handle)
-		return -1;
-
-	switch (new_state) {
-	case TRACECMD_FILE_HEADERS:
-	case TRACECMD_FILE_FTRACE_EVENTS:
-	case TRACECMD_FILE_ALL_EVENTS:
-	case TRACECMD_FILE_KALLSYMS:
-	case TRACECMD_FILE_PRINTK:
-	case TRACECMD_FILE_CMD_LINES:
-	case TRACECMD_FILE_CPU_COUNT:
-	case TRACECMD_FILE_OPTIONS:
-		if (handle->file_state == (new_state - 1))
-			return 0;
-		break;
-	case TRACECMD_FILE_CPU_LATENCY:
-	case TRACECMD_FILE_CPU_FLYRECORD:
-		if (handle->file_state == TRACECMD_FILE_OPTIONS)
-			return 0;
-		break;
-	}
-
-	return -1;
-}
-
 static struct tracecmd_output *
 create_file_fd(int fd, struct tracecmd_input *ihandle,
 	       const char *tracing_dir,
@@ -939,23 +977,18 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 
 	if (read_header_files(handle))
 		goto out_free;
-	handle->file_state = TRACECMD_FILE_HEADERS;
 
 	if (read_ftrace_files(handle))
 		goto out_free;
-	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
 
 	if (read_event_files(handle, list))
 		goto out_free;
-	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
 
 	if (read_proc_kallsyms(handle, kallsyms))
 		goto out_free;
-	handle->file_state = TRACECMD_FILE_KALLSYMS;
 
 	if (read_ftrace_printk(handle))
 		goto out_free;
-	handle->file_state = TRACECMD_FILE_PRINTK;
 
 	return handle;
 
-- 
2.30.0


