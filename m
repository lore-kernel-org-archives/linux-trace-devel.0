Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0EBC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jun 2022 01:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378469AbiFHBST (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 21:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1844303AbiFHAMR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 20:12:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768C217F820
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Jun 2022 13:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 681DBB823EA
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Jun 2022 20:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09C7C385A5;
        Tue,  7 Jun 2022 20:33:35 +0000 (UTC)
Date:   Tue, 7 Jun 2022 16:33:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] trace-cmd record: Add --temp option to store temp files
Message-ID: <20220607163334.289f2e41@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a --temp option to trace-cmd record that lets the user specify where
the temporary files will be recorded to. Instead of using the location of
the trace.dat file to store the temporary files that are recorded by
splice, they are recorded in the directory specified by --temp.

Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213661
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../trace-cmd/trace-cmd-record.1.txt          |  8 +++++
 tracecmd/include/trace-local.h                |  2 ++
 tracecmd/trace-record.c                       | 36 +++++++++++++++++--
 tracecmd/trace-usage.c                        |  1 +
 4 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 75e241c53222..af3e776b1dce 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -344,6 +344,14 @@ OPTIONS
     any events (like sched_switch), unless they are specifically specified
     on the command line (i.e. -p function -e sched_switch -e sched_wakeup)
 
+*--temp* 'directory'::
+    When *trace-cmd* is recording the trace, it records the per CPU data into
+    a separate file for each CPU. At the end of the trace, these files are
+    concatenated onto the final trace.dat file. If the final file is on a network
+    file system, it may not be appropriate to copy these temp files into the
+    same location. *--temp* can be used to tell *trace-cmd* where those temp
+    files should be created.
+
 *--ts-offset offset*::
     Add an offset for the timestamp in the trace.dat file. This will add a
     offset option into the trace.dat file such that a trace-cmd report will
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 3d025f86fb19..a48a14a5a387 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -232,6 +232,8 @@ struct buffer_instance {
 	unsigned long long	trace_id;
 	char			*cpumask;
 	char			*output_file;
+	const char		*temp_dir;
+	char			*temp_file;
 	struct event_list	*events;
 	struct event_list	**event_next;
 	bool			delete;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 169836bd493c..2406489abcdb 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -195,6 +195,7 @@ struct common_record_context {
 	enum trace_cmd curr_cmd;
 	struct buffer_instance *instance;
 	const char *output;
+	const char *temp;
 	char *date2ts;
 	char *user;
 	const char *clock;
@@ -526,6 +527,23 @@ static char *get_temp_file(struct buffer_instance *instance, int cpu)
 	char *file = NULL;
 	int size;
 
+	if (instance->temp_dir) {
+		if (!instance->temp_file) {
+			const char *f = output_file + strlen(output_file) - 1;;
+			int ret;
+
+			for (; f > output_file && *f != '/'; f--)
+				;
+			if (*f == '/')
+				f++;
+			ret = asprintf(&instance->temp_file, "%s/%s",
+				       instance->temp_dir, f);
+			if (ret < 0)
+				die("Failed to create temp file");
+		}
+		output_file = instance->temp_file;
+	}
+
 	name = tracefs_instance_get_name(instance->tracefs);
 	if (name) {
 		size = snprintf(file, 0, "%s.%s.cpu%d", output_file, name, cpu);
@@ -570,10 +588,15 @@ static void put_temp_file(char *file)
 
 static void delete_temp_file(struct buffer_instance *instance, int cpu)
 {
-	const char *output_file = instance->output_file;
+	const char *output_file;
 	const char *name;
 	char file[PATH_MAX];
 
+	if (instance->temp_file)
+		output_file = instance->temp_file;
+	else
+		output_file = instance->output_file;
+
 	name = tracefs_instance_get_name(instance->tracefs);
 	if (name)
 		snprintf(file, PATH_MAX, "%s.%s.cpu%d", output_file, name, cpu);
@@ -5714,7 +5737,8 @@ enum {
 	OPT_cmdlines_size	= 258,
 	OPT_poll		= 259,
 	OPT_name		= 260,
-	OPT_proxy		= 261
+	OPT_proxy		= 261,
+	OPT_temp		= 262
 };
 
 void trace_stop(int argc, char **argv)
@@ -6139,6 +6163,7 @@ static void parse_record_options(int argc,
 			{"compression", required_argument, NULL, OPT_compression},
 			{"file-version", required_argument, NULL, OPT_file_ver},
 			{"proxy", required_argument, NULL, OPT_proxy},
+			{"temp", required_argument, NULL, OPT_temp},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6411,6 +6436,11 @@ static void parse_record_options(int argc,
 				}
 			}
 			break;
+		case OPT_temp:
+			if (ctx->temp)
+				die("Only one temp directory can be listed");
+			ctx->temp = optarg;
+			break;
 		case 'O':
 			check_instance_die(ctx->instance, "-O");
 			option = optarg;
@@ -6873,6 +6903,8 @@ static void record_trace(int argc, char **argv,
 
 	/* Save the state of tracing_on before starting */
 	for_all_instances(instance) {
+		if (ctx->temp)
+			instance->temp_dir = ctx->temp;
 		instance->output_file = strdup(ctx->output);
 		if (!instance->output_file)
 			die("Failed to allocate output file name for instance");
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 2cfa64f5aa0c..de556848ead7 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -53,6 +53,7 @@ static struct usage_help usage_help[] = {
 		"          -q print no output to the screen\n"
 		"          -G when profiling, set soft and hard irqs as global\n"
 		"          --quiet print no output to the screen\n"
+		"          --temp specify a directory to store the temp files used to create trace.dat\n"
 		"          --module filter module name\n"
 		"          --by-comm used with --profile, merge events for related comms\n"
 		"          --profile enable tracing options needed for report --profile\n"
-- 
2.35.1

