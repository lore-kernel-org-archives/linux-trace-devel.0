Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44276C4332B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Mar 2021 14:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23EAB64DBA
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Mar 2021 14:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235441AbhCAOkX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Mar 2021 09:40:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236449AbhCAOkW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Mar 2021 09:40:22 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFEA564E31;
        Mon,  1 Mar 2021 14:38:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lGjhJ-001PvE-VD; Mon, 01 Mar 2021 09:38:57 -0500
Message-ID: <20210301143857.841258346@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 01 Mar 2021 09:37:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 8/8] trace-cmd input: Add validation updates to the copy of a handle
References: <20210301143724.540985351@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When copying the input handle the file descriptor is changed. Change its
state along with that.

Currently the tracecmd_copy_headers() restores the original state, but does
not restore the file descriptor. That may need to change.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 52 +++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 53c2722f46e7..15d6d2b3ca43 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3491,12 +3491,14 @@ static int copy_header_files(struct tracecmd_input *handle, int fd)
 {
 	unsigned long long size;
 
-	/* The input handle has to have at least read the headers */
 	if (handle->file_state < TRACECMD_FILE_HEADERS)
 		return -1;
 
 	lseek64(handle->fd, handle->header_files_start, SEEK_SET);
 
+	/* Now that the file handle has moved, change its state */
+	handle->file_state = TRACECMD_FILE_HEADERS;
+
 	/* "header_page"  */
 	if (read_copy_data(handle, 12, fd) < 0)
 		return -1;
@@ -3526,8 +3528,7 @@ static int copy_ftrace_files(struct tracecmd_input *handle, int fd)
 	unsigned int count;
 	unsigned int i;
 
-	/* The input handle has to have at least read the ftrace events */
-	if (handle->file_state < TRACECMD_FILE_FTRACE_EVENTS)
+	if (handle->file_state != TRACECMD_FILE_FTRACE_EVENTS - 1)
 		return -1;
 
 	if (read_copy_size4(handle, fd, &count) < 0)
@@ -3542,6 +3543,8 @@ static int copy_ftrace_files(struct tracecmd_input *handle, int fd)
 			return -1;
 	}
 
+	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
+
 	return 0;
 }
 
@@ -3553,8 +3556,7 @@ static int copy_event_files(struct tracecmd_input *handle, int fd)
 	unsigned int count;
 	unsigned int i,x;
 
-	/* The input handle has to have at least read all its events */
-	if (handle->file_state < TRACECMD_FILE_ALL_EVENTS)
+	if (handle->file_state != TRACECMD_FILE_ALL_EVENTS - 1)
 		return -1;
 
 	if (read_copy_size4(handle, fd, &systems) < 0)
@@ -3582,6 +3584,8 @@ static int copy_event_files(struct tracecmd_input *handle, int fd)
 		}
 	}
 
+	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+
 	return 0;
 }
 
@@ -3589,8 +3593,7 @@ static int copy_proc_kallsyms(struct tracecmd_input *handle, int fd)
 {
 	unsigned int size;
 
-	/* The input handle has to have at least has kallsyms */
-	if (handle->file_state < TRACECMD_FILE_KALLSYMS)
+	if (handle->file_state != TRACECMD_FILE_KALLSYMS - 1)
 		return -1;
 
 	if (read_copy_size4(handle, fd, &size) < 0)
@@ -3601,6 +3604,8 @@ static int copy_proc_kallsyms(struct tracecmd_input *handle, int fd)
 	if (read_copy_data(handle, size, fd) < 0)
 		return -1;
 
+	handle->file_state = TRACECMD_FILE_KALLSYMS;
+
 	return 0;
 }
 
@@ -3608,8 +3613,7 @@ static int copy_ftrace_printk(struct tracecmd_input *handle, int fd)
 {
 	unsigned int size;
 
-	/* The input handle has to have at least has printk stored */
-	if (handle->file_state < TRACECMD_FILE_PRINTK)
+	if (handle->file_state != TRACECMD_FILE_PRINTK - 1)
 		return -1;
 
 	if (read_copy_size4(handle, fd, &size) < 0)
@@ -3620,6 +3624,8 @@ static int copy_ftrace_printk(struct tracecmd_input *handle, int fd)
 	if (read_copy_data(handle, size, fd) < 0)
 		return -1;
 
+	handle->file_state = TRACECMD_FILE_PRINTK;
+
 	return 0;
 }
 
@@ -3627,8 +3633,7 @@ static int copy_command_lines(struct tracecmd_input *handle, int fd)
 {
 	unsigned long long size;
 
-	/* The input handle has to have at least read the cmdlines */
-	if (handle->file_state < TRACECMD_FILE_CMD_LINES)
+	if (handle->file_state != TRACECMD_FILE_CMD_LINES - 1)
 		return -1;
 
 	if (read_copy_size8(handle, fd, &size) < 0)
@@ -3639,38 +3644,47 @@ static int copy_command_lines(struct tracecmd_input *handle, int fd)
 	if (read_copy_data(handle, size, fd) < 0)
 		return -1;
 
+	handle->file_state = TRACECMD_FILE_CMD_LINES;
+
 	return 0;
 }
 
 int tracecmd_copy_headers(struct tracecmd_input *handle, int fd)
 {
+	int save_state = handle->file_state;
 	int ret;
 
+	/* Make sure that the input handle is up to cmd lines */
+	if (handle->file_state < TRACECMD_FILE_CMD_LINES)
+		return -1;
+
 	ret = copy_header_files(handle, fd);
 	if (ret < 0)
-		return -1;
+		goto out;
 
 	ret = copy_ftrace_files(handle, fd);
 	if (ret < 0)
-		return -1;
+		goto out;
 
 	ret = copy_event_files(handle, fd);
 	if (ret < 0)
-		return -1;
+		goto out;
 
 	ret = copy_proc_kallsyms(handle, fd);
 	if (ret < 0)
-		return -1;
+		goto out;
 
 	ret = copy_ftrace_printk(handle, fd);
 	if (ret < 0)
-		return -1;
+		goto out;
 
 	ret = copy_command_lines(handle, fd);
-	if (ret < 0)
-		return -1;
 
-	return 0;
+ out:
+	/* Restore the handle back to its original state */
+	handle->file_state = save_state;
+
+	return ret < 0 ? -1 : 0;
 }
 
 /**
-- 
2.30.0


