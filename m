Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6129BC43219
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 02:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347925AbiCXC7F (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 22:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347905AbiCXC7C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 22:59:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57ABD939E7;
        Wed, 23 Mar 2022 19:57:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBDCBB8222E;
        Thu, 24 Mar 2022 02:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043D1C340F4;
        Thu, 24 Mar 2022 02:57:28 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nXDfD-007FLG-3b;
        Wed, 23 Mar 2022 22:57:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     williskung@google.com, kaleshsingh@google.com,
        linux-rt-users@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 06/12] trace-cmd analyze: Add tracing of tasks and their states
Date:   Wed, 23 Mar 2022 22:57:20 -0400
Message-Id: <20220324025726.1727204-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324025726.1727204-1-rostedt@goodmis.org>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If sched_switch is found and has the prev_state field, then record them
and keep track of the time the task was in the state, the number of times
it was scheduled out of the state, and print the total time, average time,
and number of times the task was scheduled out of that state. Also show
the time stamp of where the longest time it went into that state.

Currently the only states that are supported are "preempted" (which was in
state running), "blocked" (state uninterruptible), "sleeping" (state
interruptible), and "other" (all other states).

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-analyze.c | 143 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 139 insertions(+), 4 deletions(-)

diff --git a/tracecmd/trace-analyze.c b/tracecmd/trace-analyze.c
index 56123f9b4f86..ee4f71a7da26 100644
--- a/tracecmd/trace-analyze.c
+++ b/tracecmd/trace-analyze.c
@@ -31,6 +31,7 @@ struct analysis_data {
 	unsigned long long	last_ts;
 	struct tep_event	*switch_event;
 	struct tep_format_field	*prev_comm;
+	struct tep_format_field	*prev_state;
 	struct tep_format_field	*next_comm;
 	struct tep_format_field	*next_pid;
 	struct cpu_data		*cpu_data;
@@ -40,12 +41,25 @@ struct analysis_data {
 	int			cpus;
 };
 
+struct sched_timings {
+	unsigned long long	last;
+	unsigned long long	total;
+	unsigned long long	nr;
+	unsigned long long	longest;
+	unsigned long long	longest_ts;
+};
+
 struct task_item {
 	unsigned long long	runtime;
 	unsigned long long	start_ts;
+	struct sched_timings	preempt;
+	struct sched_timings	sleep;
+	struct sched_timings	blocked;
+	struct sched_timings	other;
 	char			*comm;
 	struct trace_hash_item	hash;
 	int			pid;
+	int			last_state;
 };
 
 struct task_cpu_item {
@@ -132,6 +146,7 @@ static struct task_item *get_task(struct cpu_data *cpu_data, int pid)
 		hash->key = find_pid;
 		cpu_data->data->nr_tasks++;
 		trace_hash_add(&cpu_data->data->tasks, hash);
+		task->last_state = -1;
 	}
 
 	return task_from_hash(hash);
@@ -157,6 +172,19 @@ static struct task_cpu_item *get_cpu_task(struct cpu_data *cpu_data, int pid)
 	return task_cpu_from_hash(hash);
 };
 
+static void update_sched_timings (struct sched_timings *time, unsigned long long ts)
+{
+	unsigned long long delta;
+
+	delta = ts - time->last;
+	time->total += delta;
+	if (delta > time->longest) {
+		time->longest = delta;
+		time->longest_ts = time->last;
+	}
+	time->nr++;
+}
+
 /* Update times for a task scheduling off the CPU */
 static void update_cpu_task_times(struct cpu_data *cpu_data,
 				  struct task_cpu_item *cpu_task,
@@ -265,6 +293,7 @@ static void process_switch(struct analysis_data *data,
 	struct cpu_data *cpu_data = &data->cpu_data[record->cpu];
 	struct task_cpu_item *cpu_task;
 	struct task_item *task;
+	unsigned long long val;
 	const char *comm;
 
 	cpu_task = get_cpu_task(cpu_data, pid);
@@ -273,9 +302,29 @@ static void process_switch(struct analysis_data *data,
 	update_cpu_task_times(cpu_data, cpu_task, record->ts);
 
 	/* Fill in missing comms */
-	if (pid && data->prev_comm && !task->comm) {
-		comm = (char *)(record->data + data->prev_comm->offset);
-		task->comm = strdup(comm);
+	if (pid) {
+		if (data->prev_state) {
+			tep_read_number_field(data->prev_state, record->data, &val);
+			switch (val & 0x1f) {
+			case 0:
+				task->preempt.last = record->ts;
+				break;
+			case 0x1:
+				task->sleep.last = record->ts;
+				break;
+			case 0x2:
+				task->blocked.last = record->ts;
+				break;
+			default:
+				task->other.last = record->ts;
+			}
+			task->last_state = val & 0x1f;
+		}
+
+		if (data->prev_comm && !task->comm) {
+			comm = (char *)(record->data + data->prev_comm->offset);
+			task->comm = strdup(comm);
+		}
 	}
 
 	if (data->next_pid) {
@@ -288,6 +337,24 @@ static void process_switch(struct analysis_data *data,
 		task->start_ts = record->ts;
 		cpu_data->current_pid = pid;
 
+		switch (task->last_state) {
+		case -1:
+			/* First time seen */
+			break;
+		case 0:
+			update_sched_timings(&task->preempt, record->ts);
+			break;
+		case 0x1:
+			update_sched_timings(&task->sleep, record->ts);
+			break;
+		case 0x2:
+			update_sched_timings(&task->blocked, record->ts);
+			break;
+		default:
+			update_sched_timings(&task->other, record->ts);
+		}
+		task->last_state = val & 0x1f;
+
 		/* Fill in missing comms */
 		if (pid && data->next_comm && !task->comm) {
 			comm = (char *)(record->data + data->next_comm->offset);
@@ -343,6 +410,17 @@ static int cmp_cpu_tasks(const void *A, const void *B)
 	return (*a)->runtime < (*b)->runtime;
 }
 
+static int cmp_task_pids(const void *A, const void *B)
+{
+	struct task_item * const *a = A;
+	struct task_item * const *b = B;
+
+	if ((*a)->pid < (*b)->pid)
+		return -1;
+
+	return (*a)->pid > (*b)->pid;
+}
+
 static void print_time(unsigned long long ts, char delim)
 {
 	unsigned long long secs;
@@ -374,6 +452,34 @@ static void print_time(unsigned long long ts, char delim)
 	}
 }
 
+static void print_sched_timings(const char *label, struct sched_timings *time)
+{
+	unsigned long long avg;
+	int n;
+
+	if (!time->nr)
+		return;
+
+	printf("%s:\t", label);
+	print_time(time->total, 0);
+	n = printf(" (%llu)", time->nr);
+	if (n < 8)
+		printf("%*.s", 8 - n, "");
+	avg = time->total / time->nr;
+	print_time(avg, 0);
+	if (time_in_nsecs)
+		printf(" ");
+	else
+		printf("    ");
+	print_time(time->longest, 0);
+	if (time_in_nsecs)
+		printf(" ");
+	else
+		printf("    ");
+	print_time(time->longest_ts, 0);
+	printf("\n");
+}
+
 static void print_cpu_data(struct tep_handle *tep, struct cpu_data *cpu_data)
 {
 	unsigned long long total_time;
@@ -435,6 +541,27 @@ static void print_cpu_data(struct tep_handle *tep, struct cpu_data *cpu_data)
 	free(cpu_tasks);
 }
 
+static void print_task(struct tep_handle *tep, struct task_item *task)
+{
+	const char *a = "";
+
+	if (time_in_nsecs)
+		a = "   ";
+
+	printf("\nTask: %d : %s:\n",
+	       task->pid , task->comm ? : tep_data_comm_from_pid(tep, task->pid));
+	printf("Runtime: ");
+	print_time(task->runtime, '_');
+	printf("\nType                 Total    %s(cnt)       Avg              Longest       Where\n",
+		a);
+	printf("----                 -----    %s-----       ---              -------       -----\n",
+		a);
+	print_sched_timings("Preempted", &task->preempt);
+	print_sched_timings("Blocked", &task->blocked);
+	print_sched_timings("Sleeping", &task->sleep);
+	print_sched_timings("Other", &task->other);
+}
+
 static void print_total(struct tep_handle *tep, struct analysis_data *data)
 {
 	unsigned long long total_time;
@@ -502,7 +629,6 @@ static void print_total(struct tep_handle *tep, struct analysis_data *data)
 		print_time(tasks[i]->runtime, '_');
 		printf(" (%%%lld)\n", (tasks[i]->runtime * 100) / total_time);
 	}
-	free(tasks);
 
 	printf("\n");
 
@@ -511,6 +637,14 @@ static void print_total(struct tep_handle *tep, struct analysis_data *data)
 			continue;
 		print_cpu_data(tep, &data->cpu_data[i]);
 	}
+
+	qsort(tasks, nr_tasks, sizeof(*tasks), cmp_task_pids);
+
+	printf("\n");
+	for (i = 0; i < nr_tasks; i++) {
+		print_task(tep, tasks[i]);
+	}
+	free(tasks);
 }
 
 static void free_tasks(struct trace_hash *hash)
@@ -581,6 +715,7 @@ static void do_trace_analyze(struct tracecmd_input *handle)
 		data.next_pid = tep_find_field(data.switch_event, "next_pid");
 		data.next_comm = tep_find_field(data.switch_event, "next_comm");
 		data.prev_comm = tep_find_field(data.switch_event, "prev_comm");
+		data.prev_state = tep_find_field(data.switch_event, "prev_state");
 	}
 
 	do {
-- 
2.35.1

