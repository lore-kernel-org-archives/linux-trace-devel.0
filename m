Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4BAC4167E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 02:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347910AbiCXC7D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 22:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347899AbiCXC7B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 22:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1375D939E7;
        Wed, 23 Mar 2022 19:57:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E12A619BA;
        Thu, 24 Mar 2022 02:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFACC340FB;
        Thu, 24 Mar 2022 02:57:28 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nXDfD-007FLa-7c;
        Wed, 23 Mar 2022 22:57:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     williskung@google.com, kaleshsingh@google.com,
        linux-rt-users@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 11/12] trace-cmd analyze: Account for dropped events
Date:   Wed, 23 Mar 2022 22:57:25 -0400
Message-Id: <20220324025726.1727204-12-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324025726.1727204-1-rostedt@goodmis.org>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the trace.dat file contains dropped events due to the reader not being
able to keep up with the writer, account for it. Update the CPUs where
there are dropped events and tag the tasks that are on those CPUs.

Add to the output the fact that events were dropped.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-analyze.c | 87 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 84 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-analyze.c b/tracecmd/trace-analyze.c
index 2603c360c404..2f1b2720810e 100644
--- a/tracecmd/trace-analyze.c
+++ b/tracecmd/trace-analyze.c
@@ -19,6 +19,8 @@ struct task_item;
 struct cpu_data {
 	unsigned long long	start_ts;
 	unsigned long long	last_ts;
+	unsigned long long	missed_events;
+	unsigned long long	unknown_missed_events;
 	struct task_item	*idle_task;
 	struct analysis_data	*data;
 	struct trace_hash	tasks;
@@ -27,6 +29,7 @@ struct cpu_data {
 	int			current_pid;
 	int			first_pid;
 	bool			last_idle;
+	bool			keep_start;
 };
 
 struct analysis_data {
@@ -45,6 +48,7 @@ struct analysis_data {
 	int			nr_tasks;
 	int			allocated_cpus;
 	int			cpus;
+	bool			missed_events;
 };
 
 struct sched_timings {
@@ -71,6 +75,7 @@ struct task_item {
 	int			last_cpu;
 	int			last_state;
 	bool			woken;
+	bool			dropped_events;
 };
 
 struct task_cpu_item {
@@ -306,6 +311,9 @@ static void update_cpu_times(struct cpu_data *cpu_data,
 		update_idle_task(cpu_data, task, record->ts);
 		if (record->ts < cpu_data->data->start_ts)
 			cpu_data->data->start_ts = record->ts;
+		/* If we lost events before here, keep the current start time */
+		if (record->missed_events)
+			cpu_data->keep_start = true;
 		return;
 	}
 
@@ -326,6 +334,10 @@ static void update_first_pid(struct cpu_data *cpu_data)
 	unsigned long long start_ts = cpu_data->data->start_ts;
 	unsigned long long delta;
 
+	/* If the CPU started with dropped events, do not update */
+	if (cpu_data->keep_start)
+		return;
+
 	cpu_task = get_cpu_task(cpu_data, cpu_data->first_pid);
 	task = cpu_task->task;
 	delta = cpu_data->start_ts - start_ts;
@@ -464,6 +476,50 @@ static void process_page_fault(struct analysis_data *data,
 	task->faulted++;
 }
 
+static void handle_missed_events(struct analysis_data *data,
+				 struct tep_record *record)
+{
+	struct trace_hash_item **bucket;
+	struct trace_hash_item *item;
+	struct task_cpu_item *cpu_task;
+	struct cpu_data *cpu_data;
+	struct task_item *task;
+	long long missed_events = record->missed_events;
+	int cpu;
+
+	/* If this is the first event for the CPU do nothing here */
+	if (record->cpu >= data->allocated_cpus ||
+	    !data->cpu_data[record->cpu].data)
+		return;
+
+	data->missed_events = true;
+
+	cpu_data = &data->cpu_data[record->cpu];
+	cpu = cpu_data->cpu;
+
+	if (missed_events > 0)
+		cpu_data->missed_events += missed_events;
+	else
+		cpu_data->unknown_missed_events++;
+
+	/* Need to reset all timings */
+	trace_hash_for_each_bucket(bucket, &cpu_data->tasks) {
+		trace_hash_for_each_item(item, bucket) {
+			cpu_task = task_cpu_from_hash(item);
+			task = cpu_task->task;
+			if (task->last_cpu != cpu)
+				continue;
+			task->preempt.last = record->ts;
+			task->sleep.last = record->ts;
+			task->blocked.last = record->ts;
+			task->other.last = record->ts;
+			task->woken = false;
+			task->last_state = -1;
+			task->dropped_events = true;
+		}
+	}
+}
+
 static bool match_type(int type, struct tep_event *event)
 {
 	return event && type == event->id;
@@ -477,6 +533,9 @@ static void process_cpu(struct analysis_data *data,
 	int type;
 	int pid;
 
+	if (record->missed_events)
+		handle_missed_events(data, record);
+
 	pid = tep_data_pid(tep, record);
 	if (pid < 0) /* Warn? */
 		return;
@@ -624,12 +683,29 @@ static void print_cpu_data(struct tep_handle *tep, struct cpu_data *cpu_data)
 	int nr_tasks;
 	int i = 0;
 
-	data = cpu_data->data;
-	total_time = data->last_ts - data->start_ts;
-
 	printf("\nCPU %d\n", cpu_data->cpu);
 	printf("-------\n");
 
+	if (cpu_data->missed_events || cpu_data->unknown_missed_events) {
+		printf("Missed: %llu events", cpu_data->missed_events);
+		if (cpu_data->unknown_missed_events)
+			printf(" + %llu drops of unknown events",
+			       cpu_data->unknown_missed_events);
+		printf("\n");
+	}
+
+	data = cpu_data->data;
+
+	if (cpu_data->keep_start) {
+		total_time = data->last_ts - cpu_data->start_ts;
+		printf("[ Events dropped before start of this CPU ]\n");
+		printf("Total time: ");
+		print_time(total_time, '_');
+		printf("\n");
+	} else {
+		total_time = data->last_ts - data->start_ts;
+	}
+
 	cpu_tasks = malloc(sizeof(*cpu_tasks) * cpu_data->nr_tasks);
 
 	if (!cpu_tasks)
@@ -678,6 +754,8 @@ static void print_task(struct tep_handle *tep, struct task_item *task)
 {
 	printf("\nTask: %d : %s:\n",
 	       task->pid , task->comm ? : tep_data_comm_from_pid(tep, task->pid));
+	if (task->dropped_events)
+		printf("[ Events dropped for this task's CPU, may be missing data ]\n");
 	printf("Runtime:    ");
 	print_time(task->runtime, '_');
 	printf("\n");
@@ -706,6 +784,9 @@ static void print_total(struct tep_handle *tep, struct analysis_data *data)
 	int cpu;
 	int i = 0;
 
+	if (data->missed_events)
+		printf("\n[ Missed events, some data may be missing ]\n");
+
 	total_time = data->last_ts - data->start_ts;
 	printf("\nTotal time: ");
 	print_time(total_time, '_');
-- 
2.35.1

