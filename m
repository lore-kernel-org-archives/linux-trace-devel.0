Return-Path: <SRS0=gJTR=AT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D791C433E4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jul 2020 20:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 829B42080D
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jul 2020 20:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgGHUaU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jul 2020 16:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgGHUaS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jul 2020 16:30:18 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83A362078A
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jul 2020 20:30:18 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jtGht-004NPA-Ih
        for linux-trace-devel@vger.kernel.org; Wed, 08 Jul 2020 16:30:17 -0400
Message-ID: <20200708203017.461261635@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 08 Jul 2020 16:28:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/5] trace-cmd: Print raw hex for flags when trace-cmd report -R
References: <20200708202850.764168067@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When the '-R' raw flag is specified on the command line for trace-cmd
report, show the latency flags as a raw hex number. This is useful for
seeing exactly what was saved in the flags field.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204703
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-read.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 2ab89ab57c6e..e18110745d37 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -101,6 +101,7 @@ static int no_softirqs;
 static int tsdiff;
 
 static int latency_format;
+static bool raw_format;
 static const char *format_type = TEP_PRINT_INFO;
 
 static struct tep_format_field *wakeup_task;
@@ -807,6 +808,7 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 {
 	tracecmd_show_data_func func = tracecmd_get_show_data_func(handle);
 	const char *tfmt = time_format(handle, TIME_FMT_NORMAL);
+	const char *cfmt = latency_format ? "%8.8s-%-5d %3d" : "%16s-%-5d [%03d]";
 	struct tep_handle *pevent;
 	struct tep_event *event;
 	struct trace_seq s;
@@ -847,17 +849,20 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 		}
 	}
 
-	if (latency_format)
-		tep_print_event(pevent, &s, record, "%8.8s-%-5d %3d%s",
-				TEP_PRINT_COMM,
-				TEP_PRINT_PID,
-				TEP_PRINT_CPU,
-				TEP_PRINT_LATENCY);
-	else
-		tep_print_event(pevent, &s, record, "%16s-%-5d [%03d]",
-				TEP_PRINT_COMM,
-				TEP_PRINT_PID,
-				TEP_PRINT_CPU);
+	tep_print_event(pevent, &s, record, cfmt,
+			TEP_PRINT_COMM,
+			TEP_PRINT_PID,
+			TEP_PRINT_CPU);
+
+	if (latency_format) {
+		if (raw_format)
+			trace_seq_printf(&s, "-0x%x",
+					 tep_data_flags(pevent, record));
+		else
+			tep_print_event(pevent, &s, record, "%s",
+					TEP_PRINT_LATENCY);
+	}
+
 	tep_print_event(pevent, &s, record, tfmt, TEP_PRINT_TIME);
 
 	if (tsdiff) {
@@ -1506,7 +1511,6 @@ void trace_report (int argc, char **argv)
 	int nanosec = 0;
 	int no_date = 0;
 	int global = 0;
-	int raw = 0;
 	int neg = 0;
 	int ret = 0;
 	int check_event_parsing = 0;
@@ -1618,7 +1622,7 @@ void trace_report (int argc, char **argv)
 			global = 1;
 			break;
 		case 'R':
-			raw = 1;
+			raw_format = true;
 			break;
 		case 'r':
 			*raw_ptr = malloc(sizeof(struct event_str));
@@ -1769,7 +1773,7 @@ void trace_report (int argc, char **argv)
 		if (nanosec)
 			tep_set_flag(pevent, TEP_NSEC_OUTPUT);
 
-		if (raw)
+		if (raw_format)
 			format_type = TEP_PRINT_INFO_RAW;
 
 		if (test_filters_mode)
-- 
2.26.2


