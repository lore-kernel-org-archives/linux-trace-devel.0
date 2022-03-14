Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31869C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Mar 2022 17:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235730AbiCNRLJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 13:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiCNRLI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 13:11:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB593DDF6
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 10:09:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1184560F0F
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 17:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D6FC340E9
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Mar 2022 17:09:57 +0000 (UTC)
Date:   Mon, 14 Mar 2022 13:09:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd report: Add --cpus option
Message-ID: <20220314130955.420df3ef@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the option --cpus to trace-cmd report to list the CPUs with data in
the trace file and then exit.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../trace-cmd/trace-cmd-report.1.txt          |  3 ++
 tracecmd/trace-read.c                         | 28 +++++++++++++++++++
 tracecmd/trace-usage.c                        |  1 +
 3 files changed, 32 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
index 18e1c5cd0700..aad8ab5125b0 100644
--- a/Documentation/trace-cmd/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-report.1.txt
@@ -251,6 +251,9 @@ OPTIONS
     Example:  "--cpu 0,3" - show events from CPUs 0 and 3
               "--cpu 2-4" - show events from CPUs 2, 3 and 4
 
+*--cpus*::
+    List the CPUs that have data in the trace file then exit.
+
 *--stat*::
     If the trace.dat file recorded the final stats (outputed at the end of record)
     the *--stat* option can be used to retrieve them.
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 24177c44e09b..df559d2af47e 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1542,6 +1542,7 @@ enum {
 	OPT_kallsyms	= 253,
 	OPT_events	= 254,
 	OPT_cpu		= 255,
+	OPT_cpus	= 256,
 };
 
 void trace_report (int argc, char **argv)
@@ -1569,6 +1570,7 @@ void trace_report (int argc, char **argv)
 	int show_uname = 0;
 	int show_version = 0;
 	int show_events = 0;
+	int show_cpus = 0;
 	int print_events = 0;
 	int nanosec = 0;
 	int no_date = 0;
@@ -1595,6 +1597,7 @@ void trace_report (int argc, char **argv)
 		int option_index = 0;
 		static struct option long_options[] = {
 			{"cpu", required_argument, NULL, OPT_cpu},
+			{"cpus", no_argument, NULL, OPT_cpus},
 			{"events", no_argument, NULL, OPT_events},
 			{"event", required_argument, NULL, OPT_event},
 			{"filter-test", no_argument, NULL, 'T'},
@@ -1724,6 +1727,9 @@ void trace_report (int argc, char **argv)
 		case OPT_cpu:
 			parse_cpulist(optarg);
 			break;
+		case OPT_cpus:
+			show_cpus = 1;
+			break;
 		case OPT_events:
 			print_events = 1;
 			break;
@@ -1916,10 +1922,32 @@ void trace_report (int argc, char **argv)
 			return;
 		}
 
+		if (show_cpus) {
+			int cpus;
+			int ret;
+			int i;
+
+			if (!tracecmd_is_buffer_instance(handle)) {
+				ret = tracecmd_init_data(handle);
+				if (ret < 0)
+					die("failed to init data");
+			}
+			cpus = tracecmd_cpus(handle);
+			printf("List of CPUs in %s with data:\n", inputs->file);
+			for (i = 0; i < cpus; i++) {
+				if (tracecmd_read_cpu_first(handle, i))
+					printf("  %d\n", i);
+			}
+			continue;
+		}
+
 		set_event_flags(pevent, nohandler_events, TEP_EVENT_FL_NOHANDLE);
 		set_event_flags(pevent, raw_events, TEP_EVENT_FL_PRINTRAW);
 	}
 
+	if (show_cpus)
+		return;
+
 	otype = OUTPUT_NORMAL;
 
 	if (tracecmd_get_flags(handle) & TRACECMD_FL_RAW_TS) {
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 5e96ca44e9b3..ea7d510d1060 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -227,6 +227,7 @@ static struct usage_help usage_help[] = {
 		"          -O plugin option -O [plugin:]var[=val]\n"
 		"          --cpu <cpu1,cpu2,...> - filter events according to the given cpu list.\n"
 		"                                  A range of CPUs can be specified using 'cpuX-cpuY' notation.\n"
+		"          --cpus - List the CPUs that have content in it then exit.\n"
 		"          --check-events return whether all event formats can be parsed\n"
 		"          --stat - show the buffer stats that were reported at the end of the record.\n"
 		"          --uname - show uname of the record, if it was saved\n"
-- 
2.35.1

