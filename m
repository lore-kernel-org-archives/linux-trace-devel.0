Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4146C71156
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Dec 2020 18:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B92E2222E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Dec 2020 18:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392279AbgLAShi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Dec 2020 13:37:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392287AbgLAShi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Dec 2020 13:37:38 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40EAB2151B
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Dec 2020 18:36:57 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kkAWG-002SUX-46
        for linux-trace-devel@vger.kernel.org; Tue, 01 Dec 2020 13:36:56 -0500
Message-ID: <20201201183656.012642117@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 01 Dec 2020 13:36:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] trace-cmd: Add --ts-check option to report
References: <20201201183604.562747692@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a --ts-check option to trace-cmd report that will make sure that the
timestamps do not go backwards, and will print out an error message if they
do.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/trace-cmd-report.1.txt |  4 ++++
 tracecmd/trace-read.c                | 27 ++++++++++++++++++++++++++-
 tracecmd/trace-usage.c               |  1 +
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace-cmd-report.1.txt b/Documentation/trace-cmd-report.1.txt
index 864eb2d71f6a..de616cf4b47a 100644
--- a/Documentation/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd-report.1.txt
@@ -305,6 +305,10 @@ OPTIONS
      Show the time differences between events. The difference will appear in
      parenthesis just after the timestamp.
 
+*--ts-check*::
+     Make sure no timestamp goes backwards, and if it does, print out a warning
+     message of the fact.
+
 EXAMPLES
 --------
 
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index e18110745d37..8932c18db25b 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -99,6 +99,7 @@ static int no_irqs;
 static int no_softirqs;
 
 static int tsdiff;
+static int tscheck;
 
 static int latency_format;
 static bool raw_format;
@@ -1192,6 +1193,7 @@ enum output_type {
 static void read_data_info(struct list_head *handle_list, enum output_type otype,
 			   int global)
 {
+	unsigned long long *last_timestamp;
 	struct handle_list *handles;
 	struct handle_list *last_handle;
 	struct tep_record *record;
@@ -1216,6 +1218,10 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		print_handle_file(handles);
 		printf("cpus=%d\n", cpus);
 
+		last_timestamp = calloc(cpus, sizeof(*last_timestamp));
+		if (!last_timestamp)
+			die("allocating timestamps");
+
 		/* Latency trace is just all ASCII */
 		if (ret > 0) {
 			if (multi_inputs)
@@ -1286,6 +1292,8 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 
 		list_for_each_entry(handles, handle_list, list) {
 			record = get_next_record(handles);
+			if (!record)
+				continue;
 			if (!last_record ||
 			    (record && record->ts < last_record->ts)) {
 				last_record = record;
@@ -1293,12 +1301,24 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 			}
 		}
 		if (last_record) {
+			int cpu = last_record->cpu;
+			if (cpu >= cpus)
+				die("cpu %d creater than %d\n", cpu, cpus);
+			if (tscheck && last_timestamp[cpu] > last_record->ts)
+				errno = 0;
+				warning("WARNING: Record on cpu %d went backwards: %lld to %lld delta: -%lld\n",
+					cpu, last_timestamp[cpu],
+					last_record->ts,
+					last_timestamp[cpu] - last_record->ts);
+			last_timestamp[cpu] = last_record->ts;
 			print_handle_file(last_handle);
 			trace_show_data(last_handle->handle, last_record);
 			free_handle_record(last_handle);
 		}
 	} while (last_record);
 
+	free(last_timestamp);
+
 	if (profile)
 		do_trace_profile();
 
@@ -1463,7 +1483,8 @@ static void add_hook(const char *arg)
 }
 
 enum {
-	OPT_version	= 238,
+	OPT_version	= 237,
+	OPT_tscheck	= 238,
 	OPT_tsdiff	= 239,
 	OPT_ts2secs	= 240,
 	OPT_tsoffset	= 241,
@@ -1550,6 +1571,7 @@ void trace_report (int argc, char **argv)
 			{"ts-offset", required_argument, NULL, OPT_tsoffset},
 			{"ts2secs", required_argument, NULL, OPT_ts2secs},
 			{"ts-diff", no_argument, NULL, OPT_tsdiff},
+			{"ts-check", no_argument, NULL, OPT_tscheck},
 			{"help", no_argument, NULL, '?'},
 			{NULL, 0, NULL, 0}
 		};
@@ -1719,6 +1741,9 @@ void trace_report (int argc, char **argv)
 		case OPT_tsdiff:
 			tsdiff = 1;
 			break;
+		case OPT_tscheck:
+			tscheck = 1;
+			break;
 		default:
 			usage(argv);
 		}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 5d73c5982984..0a338ed7d19c 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -229,6 +229,7 @@ static struct usage_help usage_help[] = {
 		"                     Affects the previous data file, unless there was no\n"
 		"                     previous data file, in which case it becomes default\n"
 		"          --ts-diff Show the delta timestamp between events.\n"
+		"          --ts-check Check to make sure no time stamp on any CPU goes backwards.\n"
 	},
 	{
 		"stream",
-- 
2.28.0


