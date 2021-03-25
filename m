Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1276BC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 19:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB12661A31
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 19:11:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhCYTKc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 15:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229592AbhCYTKD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 15:10:03 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BFEE61A28
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 19:10:02 +0000 (UTC)
Date:   Thu, 25 Mar 2021 15:10:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Use open() and not fopen() for
 set_plugin_instance()
Message-ID: <20210325151000.76f836e1@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

After hitting an error in writing to the "current_tracer" file that was not
reported by trace-cmd, it was due to the use of fopen(). Unless otherwise
specified, fwrite() will buffer writes, which can hide errors when writing
to the file.

Instead use open() and write() where the return gives an immediate result of
success or failure. There's no real reason to use fopen() anyway, as the
writes are rather trivial.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a0eb0385..4b57236b 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -1653,16 +1653,17 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
 static void
 set_plugin_instance(struct buffer_instance *instance, const char *name)
 {
-	FILE *fp;
 	char *path;
 	char zero = '0';
+	int ret;
+	int fd;
 
 	if (is_guest(instance))
 		return;
 
 	path = tracefs_instance_get_file(instance->tracefs, "current_tracer");
-	fp = fopen(path, "w");
-	if (!fp) {
+	fd = open(path, O_WRONLY);
+	if (fd < 0) {
 		/*
 		 * Legacy kernels do not have current_tracer file, and they
 		 * always use nop. So, it doesn't need to try to change the
@@ -1672,12 +1673,15 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 			tracefs_put_tracing_file(path);
 			return;
 		}
-		die("writing to '%s'", path);
+		die("Opening '%s'", path);
 	}
-	tracefs_put_tracing_file(path);
+	ret = write(fd, name, strlen(name));
+	close(fd);
 
-	fwrite(name, 1, strlen(name), fp);
-	fclose(fp);
+	if (ret < 0)
+		die("writing to '%s'", path); 
+
+	tracefs_put_tracing_file(path);
 
 	if (strncmp(name, "function", 8) != 0)
 		return;
@@ -1685,12 +1689,12 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 	/* Make sure func_stack_trace option is disabled */
 	/* First try instance file, then top level */
 	path = tracefs_instance_get_file(instance->tracefs, "options/func_stack_trace");
-	fp = fopen(path, "w");
-	if (!fp) {
+	fd = open(path, O_WRONLY);
+	if (fd < 0) {
 		tracefs_put_tracing_file(path);
 		path = tracefs_get_tracing_file("options/func_stack_trace");
-		fp = fopen(path, "w");
-		if (!fp) {
+		fd = open(path, O_WRONLY);
+		if (fd < 0) {
 			tracefs_put_tracing_file(path);
 			return;
 		}
@@ -1701,8 +1705,8 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
 	 */
 	add_reset_file(path, "0", RESET_HIGH_PRIO);
 	tracefs_put_tracing_file(path);
-	fwrite(&zero, 1, 1, fp);
-	fclose(fp);
+	write(fd, &zero, 1);
+	close(fd);
 }
 
 static void set_plugin(const char *name)
-- 
2.25.4

