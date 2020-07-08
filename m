Return-Path: <SRS0=gJTR=AT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC93DC433E5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jul 2020 20:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAE0E20772
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jul 2020 20:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgGHUaU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jul 2020 16:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgGHUaU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jul 2020 16:30:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34CED207BB;
        Wed,  8 Jul 2020 20:30:19 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jtGht-004NN5-0P; Wed, 08 Jul 2020 16:30:17 -0400
Message-ID: <20200708203016.862989574@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 08 Jul 2020 16:28:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 1/5] trace-cmd: Fix trace-cmd report -t to show full timestamp
References: <20200708202850.764168067@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

The -t wasn't printing the full nanosecond time stamp as it is described in
the man pages. Instead it was still printing just microsecond precision.

Before the patch:

  # trace-cmd report -t
         kworker/5:1H-887   [005] 14943901.178049: sched_stat_runtime:   comm=kworker/5:1H pid=887 runtime=13436 [ns] vruntime=1660916130854173 [ns]
         kworker/5:1H-887   [005] 14943901.178066: sched_switch:         kworker/5:1H:887 [100] W ==> swapper/5:0 [120]
                sleep-25090 [002] 14943901.178089: sched_waking:         comm=migration/2 pid=22 prio=0 target_cpu=002
                sleep-25090 [002] 14943901.178091: sched_wakeup:         migration/2:22 [0] success=1 CPU:002
                sleep-25090 [002] 14943901.178092: sched_stat_runtime:   comm=trace-cmd pid=25090 runtime=221204 [ns] vruntime=20995297524016 [ns]
                sleep-25090 [002] 14943901.178094: sched_switch:         trace-cmd:25090 [120] R ==> migration/2:22 [0]
          migration/2-22    [002] 14943901.178097: sched_migrate_task:   comm=trace-cmd pid=25090 prio=120 orig_cpu=2 dest_cpu=17
          migration/2-22    [002] 14943901.178101: sched_wake_idle_without_ipi: cpu=17
          migration/2-22    [002] 14943901.178103: sched_switch:         migration/2:22 [0] S ==> swapper/2:0 [120]

After the patch:

  # trace-cmd report -t
         kworker/5:1H-887   [005] 14943901.178048648 sched_stat_runtime:   comm=kworker/5:1H pid=887 runtime=13436 [ns] vruntime=1660916130854173 [ns]
         kworker/5:1H-887   [005] 14943901.178065741 sched_switch:         kworker/5:1H:887 [100] W ==> swapper/5:0 [120]
                sleep-25090 [002] 14943901.178088505 sched_waking:         comm=migration/2 pid=22 prio=0 target_cpu=002
                sleep-25090 [002] 14943901.178090827 sched_wakeup:         migration/2:22 [0] success=1 CPU:002
                sleep-25090 [002] 14943901.178091660 sched_stat_runtime:   comm=trace-cmd pid=25090 runtime=221204 [ns] vruntime=20995297524016 [ns]
                sleep-25090 [002] 14943901.178093512 sched_switch:         trace-cmd:25090 [120] R ==> migration/2:22 [0]
          migration/2-22    [002] 14943901.178097240 sched_migrate_task:   comm=trace-cmd pid=25090 prio=120 orig_cpu=2 dest_cpu=17
          migration/2-22    [002] 14943901.178101255 sched_wake_idle_without_ipi: cpu=17
          migration/2-22    [002] 14943901.178103431 sched_switch:         migration/2:22 [0] S ==> swapper/2:0 [120]

Link: https://lore.kernel.org/linux-trace-devel/20200706151404.25603-1-tz.stoyanov@gmail.com

Fixes: 150d479b623a ("libtraceevent, perf tools: Changes in tep_print_event_* APIs")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
[ Finished the patch from Steven ]
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index c1f840d560f2..2ab89ab57c6e 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -141,13 +141,38 @@ static void print_event_name(struct trace_seq *s, struct tep_event *event)
 		trace_seq_printf(s, "%.*s", 20 - len, spaces);
 }
 
+enum time_fmt {
+	TIME_FMT_LAT		= 1,
+	TIME_FMT_NORMAL		= 2,
+};
+
+static const char *time_format(struct tracecmd_input *handle, enum time_fmt tf)
+{
+	struct tep_handle *tep = tracecmd_get_pevent(handle);
+
+	switch (tf) {
+	case TIME_FMT_LAT:
+		if (latency_format)
+			return "%8.8s-%-5d %3d";
+		return "%16s-%-5d [%03d]";
+	default:
+		if (tracecmd_get_flags(handle) & TRACECMD_FL_IN_USECS) {
+			if (tep_test_flag(tep, TEP_NSEC_OUTPUT))
+				return " %9.1d:";
+			else
+				return " %6.1000d:";
+		} else
+			return "%12d:";
+	}
+}
+
 static void print_event(struct trace_seq *s, struct tracecmd_input *handle,
 			struct tep_record *record)
 {
 	struct tep_handle *tep = tracecmd_get_pevent(handle);
 	struct tep_event *event;
-	const char *lfmt = latency_format ? "%8.8s-%-5d %3d" : "%16s-%-5d [%03d]";
-	const char *tfmt = tracecmd_get_flags(handle) & TRACECMD_FL_IN_USECS ? " %6.1000d:" : "%12d:";
+	const char *lfmt = time_format(handle, TIME_FMT_LAT);
+	const char *tfmt = time_format(handle, TIME_FMT_NORMAL);
 
 	event = tep_find_event_by_record(tep, record);
 	tep_print_event(tep, s, record, lfmt, TEP_PRINT_COMM,
@@ -781,7 +806,7 @@ static void finish_wakeup(void)
 void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 {
 	tracecmd_show_data_func func = tracecmd_get_show_data_func(handle);
-	const char *tfmt = tracecmd_get_flags(handle) & TRACECMD_FL_IN_USECS ? " %6.1000d:" : "%12d:";
+	const char *tfmt = time_format(handle, TIME_FMT_NORMAL);
 	struct tep_handle *pevent;
 	struct tep_event *event;
 	struct trace_seq s;
-- 
2.26.2


