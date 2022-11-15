Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C14C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 05:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiKOFCR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 00:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiKOFCR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 00:02:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6082B2666
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 21:02:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E557D61487
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 05:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083DFC433D6
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 05:02:14 +0000 (UTC)
Date:   Tue, 15 Nov 2022 00:02:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add unit tests for the follow functions
Message-ID: <20221115000256.5a0c89d8@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add unit tests for tracefs_follow_events() and
tracefs_follow_missed_events().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 136 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 2c9b267ea427..805cc3b9f975 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -605,6 +605,141 @@ static void test_trace_cpu_read(void)
 	test_instance_trace_cpu_read(test_instance);
 }
 
+struct follow_data {
+	struct tep_event *sched_switch;
+	struct tep_event *sched_waking;
+	struct tep_event *function;
+	int missed;
+};
+
+static int switch_callback(struct tep_event *event, struct tep_record *record,
+			   int cpu, void *data)
+{
+	struct follow_data *fdata = data;
+
+	CU_TEST(cpu == record->cpu);
+	CU_TEST(event->id == fdata->sched_switch->id);
+	return 0;
+}
+
+static int waking_callback(struct tep_event *event, struct tep_record *record,
+			   int cpu, void *data)
+{
+	struct follow_data *fdata = data;
+
+	CU_TEST(cpu == record->cpu);
+	CU_TEST(event->id == fdata->sched_waking->id);
+	return 0;
+}
+
+static int function_callback(struct tep_event *event, struct tep_record *record,
+			     int cpu, void *data)
+{
+	struct follow_data *fdata = data;
+
+	CU_TEST(cpu == record->cpu);
+	CU_TEST(event->id == fdata->function->id);
+	return 0;
+}
+
+static int missed_callback(struct tep_event *event, struct tep_record *record,
+			     int cpu, void *data)
+{
+	struct follow_data *fdata = data;
+
+	fdata->missed = record->missed_events;
+	return 0;
+}
+
+static int all_callback(struct tep_event *event, struct tep_record *record,
+			int cpu, void *data)
+{
+	struct follow_data *fdata = data;
+
+	CU_TEST(fdata->missed == record->missed_events);
+	fdata->missed = 0;
+	return 0;
+}
+
+static void *stop_thread(void *arg)
+{
+	struct tracefs_instance *instance = arg;
+
+	sleep(1);
+	tracefs_iterate_stop(instance);
+	return NULL;
+}
+
+static void test_instance_follow_events(struct tracefs_instance *instance)
+{
+	struct follow_data fdata;
+	struct tep_handle *tep;
+	pthread_t thread;
+	int ret;
+
+	memset(&fdata, 0, sizeof(fdata));
+
+	tep = tracefs_local_events(NULL);
+	CU_TEST(tep != NULL);
+	if (!tep)
+		return;
+
+	fdata.sched_switch = tep_find_event_by_name(tep, "sched", "sched_switch");
+	CU_TEST(fdata.sched_switch != NULL);
+	if (!fdata.sched_switch)
+		return;
+
+	fdata.sched_waking = tep_find_event_by_name(tep, "sched", "sched_waking");
+	CU_TEST(fdata.sched_waking != NULL);
+	if (!fdata.sched_waking)
+		return;
+
+	fdata.function = tep_find_event_by_name(tep, "ftrace", "function");
+	CU_TEST(fdata.function != NULL);
+	if (!fdata.function)
+		return;
+
+	ret = tracefs_follow_event(tep, instance, "sched", "sched_switch",
+				   switch_callback, &fdata);
+	CU_TEST(ret == 0);
+
+	ret = tracefs_follow_event(tep, instance, "sched", "sched_waking",
+				   waking_callback, &fdata);
+	CU_TEST(ret == 0);
+
+	ret = tracefs_follow_event(tep, instance, "ftrace", "function",
+				   function_callback, &fdata);
+	CU_TEST(ret == 0);
+
+	ret = tracefs_follow_missed_events(instance, missed_callback, &fdata);
+	CU_TEST(ret == 0);
+
+	ret = tracefs_event_enable(instance, "sched", "sched_switch");
+	CU_TEST(ret == 0);
+
+	ret = tracefs_event_enable(instance, "sched", "sched_waking");
+	CU_TEST(ret == 0);
+
+	ret = tracefs_tracer_set(instance, TRACEFS_TRACER_FUNCTION);
+	CU_TEST(ret == 0);
+
+	pthread_create(&thread, NULL, stop_thread, instance);
+
+	ret = tracefs_iterate_raw_events(tep, instance, NULL, 0, all_callback, &fdata);
+	CU_TEST(ret == 0);
+
+	pthread_join(thread, NULL);
+
+	tracefs_tracer_clear(instance);
+	tracefs_event_disable(instance, NULL, NULL); 
+}
+
+static void test_follow_events(void)
+{
+	test_instance_follow_events(NULL);
+	test_instance_follow_events(test_instance);
+}
+
 static int read_trace_cpu_file(struct test_cpu_data *data)
 {
 	unsigned long long ts;
@@ -2113,6 +2248,7 @@ void test_tracefs_lib(void)
 		fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACEFS_SUITE);
 		return;
 	}
+	CU_add_test(suite, "Follow events", test_follow_events);
 	CU_add_test(suite, "trace cpu read",
 		    test_trace_cpu_read);
 	CU_add_test(suite, "trace cpu pipe",
-- 
2.35.1

