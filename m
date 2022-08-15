Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6087C19F2C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Aug 2022 05:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiHPFMN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Aug 2022 01:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbiHPFL6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Aug 2022 01:11:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2235C3CBD5
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Aug 2022 14:18:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB69361073
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Aug 2022 21:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EB4C433C1
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Aug 2022 21:18:51 +0000 (UTC)
Date:   Mon, 15 Aug 2022 17:18:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record/agent: Add --notimeout option
Message-ID: <20220815171858.6f6c1263@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add an option to not timeout, but will still fork. This is for using
with gdb on one end, and have the other end using the notimeout option,
but still doing the forking and other code that --debug disables on the
other end.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  3 +++
 lib/trace-cmd/trace-msg.c                     |  2 +-
 lib/trace-cmd/trace-util.c                    | 25 +++++++++++++++++++
 tracecmd/trace-agent.c                        | 11 +++++---
 tracecmd/trace-record.c                       |  7 +++++-
 5 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index d73a51914c42..ef35c370c34e 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -51,6 +51,9 @@ void tracecmd_record_ref(struct tep_record *record);
 void tracecmd_set_debug(bool set_debug);
 bool tracecmd_get_debug(void);
 
+void tracecmd_set_notimeout(bool set_notimeout);
+bool tracecmd_get_notimeout(void);
+
 bool tracecmd_is_version_supported(unsigned int version);
 int tracecmd_default_file_version(void);
 
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 342d03e44f21..0b2de7101575 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -461,7 +461,7 @@ static int tracecmd_msg_recv_wait(int fd, struct tracecmd_msg *msg)
 
 	pfd.fd = fd;
 	pfd.events = POLLIN;
-	ret = poll(&pfd, 1, tracecmd_get_debug() ? -1 : msg_wait_to);
+	ret = poll(&pfd, 1, tracecmd_get_notimeout() ? -1 : msg_wait_to);
 	if (ret < 0)
 		return -errno;
 	else if (ret == 0)
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 9564c81a5c99..108e20cf4b7d 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -30,6 +30,7 @@
 #define PROC_STACK_FILE "/proc/sys/kernel/stack_tracer_enabled"
 
 static bool debug;
+static bool notimeout;
 static int log_level = TEP_LOG_INFO;
 static FILE *logfp;
 
@@ -110,6 +111,30 @@ bool tracecmd_get_debug(void)
 	return debug;
 }
 
+/**
+ * tracecmd_set_notimeout - Do not timeout waiting for responses
+ * @set_notimeout: True or false to set notimeout mode.
+ *
+ * If @set_notimeout is true, then the library will not fail waiting for
+ * responses. This is useful when running the code under gdb.
+ * Note, if debug is set, then this makes no difference as it will always
+ * not timeout.
+ */
+void tracecmd_set_notimeout(bool set_notimeout)
+{
+	notimeout = set_notimeout;
+}
+
+/**
+ * tracecmd_get_notimeout - Get setting of notimeout of tracecmd library
+ * Returns true, if the tracecmd library has notimeout set.
+ *
+ */
+bool tracecmd_get_notimeout(void)
+{
+	return notimeout || debug;
+}
+
 void tracecmd_parse_cmdlines(struct tep_handle *pevent,
 			     char *file, int size __maybe_unused)
 {
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 23483295ed5a..b6b44f58f95a 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -391,7 +391,8 @@ busy:
 
 enum {
 	OPT_verbose	= 254,
-	DO_DEBUG	= 255
+	OPT_debug	= 255,
+	OPT_notimeout	= 256,
 };
 
 void trace_agent(int argc, char **argv)
@@ -413,7 +414,8 @@ void trace_agent(int argc, char **argv)
 		static struct option long_options[] = {
 			{"port", required_argument, NULL, 'p'},
 			{"help", no_argument, NULL, '?'},
-			{"debug", no_argument, NULL, DO_DEBUG},
+			{"debug", no_argument, NULL, OPT_debug},
+			{"notimeout", no_argument, NULL, OPT_notimeout},
 			{"verbose", optional_argument, NULL, OPT_verbose},
 			{NULL, 0, NULL, 0}
 		};
@@ -445,9 +447,12 @@ void trace_agent(int argc, char **argv)
 				die("Failed to allocate guest instance");
 
 			break;
-		case DO_DEBUG:
+		case OPT_debug:
 			tracecmd_set_debug(true);
 			break;
+		case OPT_notimeout:
+			tracecmd_set_notimeout(true);
+			break;
 		case OPT_verbose:
 			if (trace_set_verbose(optarg) < 0)
 				die("invalid verbose level %s", optarg);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3442e9b30023..cd1e3ddd7bb0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5738,7 +5738,8 @@ enum {
 	OPT_poll		= 259,
 	OPT_name		= 260,
 	OPT_proxy		= 261,
-	OPT_temp		= 262
+	OPT_temp		= 262,
+	OPT_notimeout		= 264,
 };
 
 void trace_stop(int argc, char **argv)
@@ -6149,6 +6150,7 @@ static void parse_record_options(int argc,
 			{"cmdlines-size", required_argument, NULL, OPT_cmdlines_size},
 			{"no-filter", no_argument, NULL, OPT_no_filter},
 			{"debug", no_argument, NULL, OPT_debug},
+			{"notimeout", no_argument, NULL, OPT_notimeout},
 			{"quiet", no_argument, NULL, OPT_quiet},
 			{"help", no_argument, NULL, '?'},
 			{"proc-map", no_argument, NULL, OPT_procmap},
@@ -6617,6 +6619,9 @@ static void parse_record_options(int argc,
 		case OPT_debug:
 			tracecmd_set_debug(true);
 			break;
+		case OPT_notimeout:
+			tracecmd_set_notimeout(true);
+			break;
 		case OPT_module:
 			check_instance_die(ctx->instance, "--module");
 			if (ctx->instance->filter_mod)
-- 
2.35.1

