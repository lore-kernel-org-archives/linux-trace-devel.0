Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD292C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Mar 2022 21:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240243AbiCNVU6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 17:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238389AbiCNVU5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 17:20:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2706813D02
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 14:19:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA15CB81038
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 21:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520ACC340E9
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 21:19:44 +0000 (UTC)
Date:   Mon, 14 Mar 2022 17:19:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record: Add --name option to name unnamed guests
Message-ID: <20220314171942.5b53f9e8@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When using the vsocket port number to connect to a guest agent (-A @3:823)
the file that is created is called "unknown". This is not very
informative, and if you have more than one guest, it can cause confusion.

Add a "--name" option that allows the user to name the guest that it
connects with. The --name option takes one parameter (the name to call the
guest), and must be after a -A option.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../trace-cmd/trace-cmd-record.1.txt          |  5 +++++
 tracecmd/trace-record.c                       | 22 +++++++++++++++++--
 tracecmd/trace-usage.c                        |  1 +
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index b36204741578..426e856bf74a 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -367,6 +367,11 @@ OPTIONS
     Traces are extracted by busy waiting, which will hog the CPUs, so only use
     when really needed.
 
+*--name*::
+    Give a specific name for the current agent being processed. Used after *-A* to
+    give the guest being traced a name. Useful when using the vsocket ID instead of
+    a name of the guest.
+
 *--verbose*[='level']::
      Set the log level. Supported log levels are "none", "critical", "error", "warning",
      "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8d9cbac23088..c3e52a48fa07 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5805,6 +5805,7 @@ enum {
 	OPT_nofifos		= 257,
 	OPT_cmdlines_size	= 258,
 	OPT_poll		= 259,
+	OPT_name		= 260,
 };
 
 void trace_stop(int argc, char **argv)
@@ -6222,6 +6223,7 @@ static void parse_record_options(int argc,
 			{"fork", no_argument, NULL, OPT_fork},
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
 			{"poll", no_argument, NULL, OPT_poll},
+			{"name", required_argument, NULL, OPT_name},
 			{"verbose", optional_argument, NULL, OPT_verbose},
 			{"compression", required_argument, NULL, OPT_compression},
 			{"file-version", required_argument, NULL, OPT_file_ver},
@@ -6240,7 +6242,7 @@ static void parse_record_options(int argc,
 		 * If the current instance is to record a guest, then save
 		 * all the arguments for this instance.
 		 */
-		if (c != 'B' && c != 'A' && is_guest(ctx->instance)) {
+		if (c != 'B' && c != 'A' && c != OPT_name && is_guest(ctx->instance)) {
 			add_arg(ctx->instance, c, opts, long_options, optarg);
 			if (c == 'C')
 				ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
@@ -6301,6 +6303,17 @@ static void parse_record_options(int argc,
 			add_trigger(event, optarg);
 			break;
 
+		case OPT_name:
+			if (!ctx->instance)
+				die("No instance defined for name option\n");
+			if (!is_guest(ctx->instance))
+				die("  --name is only used for -A options\n");
+			free(ctx->instance->name);
+			ctx->instance->name = strdup(optarg);
+			if (!ctx->instance->name)
+				die("Failed to allocate name");
+			break;
+
 		case 'A': {
 			char *name = NULL;
 			int cid = -1, port = -1;
@@ -6316,8 +6329,13 @@ static void parse_record_options(int argc,
 			if (!name || !*name) {
 				ret = asprintf(&name, "unnamed-%d", name_counter++);
 				if (ret < 0)
-					die("Failed to allocate guest name");
+					name = NULL;
+			} else {
+				/* Needs to be allocate */
+				name = strdup(name);
 			}
+			if (!name)
+				die("Failed to allocate guest name");
 
 			ctx->instance = allocate_instance(name);
 			ctx->instance->flags |= BUFFER_FL_GUEST;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index ea7d510d1060..3eb32eba6185 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -69,6 +69,7 @@ static struct usage_help usage_help[] = {
 		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
 		"                                                         at the beginnig and at the end of the trace\n"
 		"          --poll don't block while reading from the trace buffer\n"
+		"          --name used with -A to give the agent a specific name\n"
 		"          --file-version set the desired trace file version\n"
 		"          --compression compress the trace output file, one of these strings can be passed:\n"
 		"                            any  - auto select the best available compression algorithm\n"
-- 
2.35.1

