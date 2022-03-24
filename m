Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FE9C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 02:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347928AbiCXC7H (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 22:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347914AbiCXC7D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 22:59:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F276939F2;
        Wed, 23 Mar 2022 19:57:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8A37B8222A;
        Thu, 24 Mar 2022 02:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E60CC340F8;
        Thu, 24 Mar 2022 02:57:28 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nXDfD-007FLS-5v;
        Wed, 23 Mar 2022 22:57:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     williskung@google.com, kaleshsingh@google.com,
        linux-rt-users@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 09/12] trace-cmd analyze: Add wake up latency timings
Date:   Wed, 23 Mar 2022 22:57:23 -0400
Message-Id: <20220324025726.1727204-10-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324025726.1727204-1-rostedt@goodmis.org>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the sched_waking (or sched_wakeup) event is found, then use it to time
the wake up latency for each task.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-analyze.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/tracecmd/trace-analyze.c b/tracecmd/trace-analyze.c
index 4db93367727b..7cf63923b962 100644
--- a/tracecmd/trace-analyze.c
+++ b/tracecmd/trace-analyze.c
@@ -33,10 +33,12 @@ struct analysis_data {
 	unsigned long long	start_ts;
 	unsigned long long	last_ts;
 	struct tep_event	*switch_event;
+	struct tep_event	*wakeup_event;
 	struct tep_format_field	*prev_comm;
 	struct tep_format_field	*prev_state;
 	struct tep_format_field	*next_comm;
 	struct tep_format_field	*next_pid;
+	struct tep_format_field	*wakeup_pid;
 	struct cpu_data		*cpu_data;
 	struct trace_hash	tasks;
 	int			nr_tasks;
@@ -60,11 +62,13 @@ struct task_item {
 	struct sched_timings	sleep;
 	struct sched_timings	blocked;
 	struct sched_timings	other;
+	struct sched_timings	wakeup;
 	char			*comm;
 	struct trace_hash_item	hash;
 	int			pid;
 	int			last_cpu;
 	int			last_state;
+	bool			woken;
 };
 
 struct task_cpu_item {
@@ -420,9 +424,31 @@ static void process_switch(struct analysis_data *data,
 			comm = (char *)(record->data + data->next_comm->offset);
 			task->comm = strdup(comm);
 		}
+
+		if (task->woken)
+			update_sched_timings(&task->wakeup, record->ts);
+		task->woken = false;
 	}
 }
 
+static void process_wakeup(struct analysis_data *data,
+			   struct tep_handle *tep,
+			   struct tep_record *record)
+{
+	struct cpu_data *cpu_data = &data->cpu_data[record->cpu];
+	struct task_cpu_item *cpu_task;
+	struct task_item *task;
+	unsigned long long val;
+	int pid;
+
+	tep_read_number_field(data->wakeup_pid, record->data, &val);
+	pid = val;
+	cpu_task = get_cpu_task(cpu_data, pid);
+	task = cpu_task->task;
+	task->wakeup.last = record->ts;
+	task->woken = true;
+}
+
 static bool match_type(int type, struct tep_event *event)
 {
 	return event && type == event->id;
@@ -446,6 +472,9 @@ static void process_cpu(struct analysis_data *data,
 	type = tep_data_type(tep, record);
 	if (match_type(type, data->switch_event))
 		process_switch(data, tep, pid, record);
+
+	else if (match_type(type, data->wakeup_event))
+		process_wakeup(data, tep, record);
 }
 
 static int cmp_tasks(const void *A, const void *B)
@@ -637,6 +666,7 @@ static void print_task(struct tep_handle *tep, struct task_item *task)
 	if (task->migrated)
 		printf("Migrated:\t%llu\n", task->migrated);
 	print_timings_title("Type");
+	print_sched_timings("Wakeup", &task->wakeup);
 	print_sched_timings("Preempted", &task->preempt);
 	print_sched_timings("Blocked", &task->blocked);
 	print_sched_timings("Sleeping", &task->sleep);
@@ -788,6 +818,9 @@ static void do_trace_analyze(struct tracecmd_input *handle)
 	trace_hash_init(&data.tasks, 128);
 
 	data.switch_event = tep_find_event_by_name(tep, "sched", "sched_switch");
+	data.wakeup_event = tep_find_event_by_name(tep, "sched", "sched_waking");
+	if (!data.wakeup_event)
+		data.wakeup_event = tep_find_event_by_name(tep, "sched", "sched_wakeup");
 
 	/* Set to a very large number */
 	data.start_ts = -1ULL;
@@ -799,6 +832,12 @@ static void do_trace_analyze(struct tracecmd_input *handle)
 		data.prev_state = tep_find_field(data.switch_event, "prev_state");
 	}
 
+	if (data.wakeup_event) {
+		data.wakeup_pid = tep_find_field(data.wakeup_event, "pid");
+		if (!data.wakeup_pid)
+			data.wakeup_event = NULL;
+	}
+
 	do {
 		record = tracecmd_read_next_data(handle, NULL);
 		if (record)
-- 
2.35.1

