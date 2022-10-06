Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE9EC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 Oct 2022 23:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiJFXGV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 19:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiJFXGU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 19:06:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B848FB14E9
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Oct 2022 16:06:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEE9BB821B0
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Oct 2022 23:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36436C433C1
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Oct 2022 23:06:15 +0000 (UTC)
Date:   Thu, 6 Oct 2022 19:06:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Only set trace-cmd log level
Message-ID: <20221006190621.46bbb606@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Have tracecmd_set_loglevel() only for trace-cmd and not touch libtracefs
and libtraceevent log levels. Let the application handle this instead.

Update the trace-cmd code to keep the same reporting.

Move the updates of libtracefs and libtraceevent log levels from the
library into the application.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-util.c     |  4 +---
 tracecmd/include/trace-local.h |  1 +
 tracecmd/trace-cmd.c           | 11 +++++++++--
 tracecmd/trace-read.c          |  2 ++
 4 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 108e20cf4b7d..fc61f9d1111b 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -31,7 +31,7 @@
 
 static bool debug;
 static bool notimeout;
-static int log_level = TEP_LOG_INFO;
+static int log_level = TEP_LOG_WARNING;
 static FILE *logfp;
 
 const static struct {
@@ -393,8 +393,6 @@ trace_load_plugins(struct tep_handle *tep, int flags)
 void tracecmd_set_loglevel(enum tep_loglevel level)
 {
 	log_level = level;
-	tracefs_set_loglevel(level);
-	tep_set_loglevel(level);
 }
 
 void __weak tracecmd_warning(const char *fmt, ...)
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index a48a14a5a387..023afb3baad1 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -40,6 +40,7 @@ void usage(char **argv);
 extern int silence_warnings;
 extern int show_status;
 
+void trace_set_loglevel(int level);
 int trace_set_verbose(char *level);
 
 enum port_type {
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 69800d26c5ee..9646921ca268 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -76,6 +76,13 @@ static struct trace_log_severity {
 	{ .id = TEP_LOG_ALL, .name = "all" },
 };
 
+void trace_set_loglevel(int level)
+{
+	tracecmd_set_loglevel(level);
+	tracefs_set_loglevel(level);
+	tep_set_loglevel(level);
+}
+
 int trace_set_verbose(char *level)
 {
 	int id;
@@ -89,7 +96,7 @@ int trace_set_verbose(char *level)
 		if (id >= TEP_LOG_NONE) {
 			if (id > TEP_LOG_ALL)
 				id = TEP_LOG_ALL;
-			tracecmd_set_loglevel(id);
+			trace_set_loglevel(id);
 			return 0;
 		}
 	} else {
@@ -98,7 +105,7 @@ int trace_set_verbose(char *level)
 
 		for (i = 0; i < size; i++) {
 			if (!strncmp(level, log_severity[i].name, strlen(log_severity[i].name))) {
-				tracecmd_set_loglevel(log_severity[i].id);
+				trace_set_loglevel(log_severity[i].id);
 				return 0;
 			}
 		}
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index b8931cf95543..d51e3371456f 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1565,6 +1565,8 @@ void trace_report (int argc, char **argv)
 
 	signal(SIGINT, sig_end);
 
+	trace_set_loglevel(TEP_LOG_INFO);
+
 	for (;;) {
 		int option_index = 0;
 		static struct option long_options[] = {
-- 
2.35.1

