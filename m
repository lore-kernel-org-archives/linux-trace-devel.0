Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbeACRxg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:36 -0500
Message-Id: <20180103175334.859984736@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 01/38] trace-cmd recorder: Check if pipe_size was modified by
 fcntl(F_GETPIPE_SZ)
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-trace-cmd-recorder-Check-if-pipe_size-was-modified-b.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If fcntl() does not support F_GETPIPE_SZ, it may still return success, but
not modify the page_size variable that was passed to it. Initialize the
page_size variable to zero, and if it is not modified by fcntl() then set it
to page_size as well.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 trace-recorder.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/trace-recorder.c b/trace-recorder.c
index 08bd90528b7a..75290285d82f 100644
--- a/trace-recorder.c
+++ b/trace-recorder.c
@@ -121,7 +121,7 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 {
 	struct tracecmd_recorder *recorder;
 	char *path = NULL;
-	int pipe_size;
+	int pipe_size = 0;
 	int ret;
 
 	recorder = malloc(sizeof(*recorder));
@@ -183,9 +183,10 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 		/*
 		 * F_GETPIPE_SZ was introduced in 2.6.35, ftrace was introduced
 		 * in 2.6.31. If we are running on an older kernel, just fall
-		 * back to using page_size for splice().
+		 * back to using page_size for splice(). It could also return
+		 * success, but not modify pipe_size.
 		 */
-		if (ret < 0)
+		if (ret < 0 || !pipe_size)
 			pipe_size = recorder->page_size;
 
 		recorder->pipe_size = pipe_size;
-- 
2.13.2
