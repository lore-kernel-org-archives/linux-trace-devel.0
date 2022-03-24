Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E5EEC4167B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 02:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347893AbiCXC7B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 22:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347892AbiCXC7A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 22:59:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A933A939F0;
        Wed, 23 Mar 2022 19:57:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24B8E619B2;
        Thu, 24 Mar 2022 02:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F646C340F7;
        Thu, 24 Mar 2022 02:57:28 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nXDfD-007FLK-4T;
        Wed, 23 Mar 2022 22:57:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     williskung@google.com, kaleshsingh@google.com,
        linux-rt-users@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 07/12] trace-cmd analyze: Add "idleness"
Date:   Wed, 23 Mar 2022 22:57:21 -0400
Message-Id: <20220324025726.1727204-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324025726.1727204-1-rostedt@goodmis.org>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Report the "idleness" of a CPU. How long it was idle, the longest time it
was idle, the average time it is idle, the number of times it was idle,
and where the longest time it was idle.

Note, anytime there is an event, the CPU is considered "not idle", that
is, it was woken up.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-analyze.c | 87 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 77 insertions(+), 10 deletions(-)

diff --git a/tracecmd/trace-analyze.c b/tracecmd/trace-analyze.c
index ee4f71a7da26..de776b76c343 100644
--- a/tracecmd/trace-analyze.c
+++ b/tracecmd/trace-analyze.c
@@ -14,16 +14,19 @@
 static bool time_in_nsecs;
 
 struct analysis_data;
+struct task_item;
 
 struct cpu_data {
 	unsigned long long	start_ts;
 	unsigned long long	last_ts;
+	struct task_item	*idle_task;
 	struct analysis_data	*data;
 	struct trace_hash	tasks;
 	int			nr_tasks;
 	int			cpu;
 	int			current_pid;
 	int			first_pid;
+	bool			last_idle;
 };
 
 struct analysis_data {
@@ -185,6 +188,31 @@ static void update_sched_timings (struct sched_timings *time, unsigned long long
 	time->nr++;
 }
 
+static void update_idle_task(struct cpu_data *cpu_data, struct task_item *task,
+			     unsigned long long ts)
+{
+	if (!cpu_data->idle_task) {
+		if (task && task->pid <= 0) {
+			cpu_data->idle_task = task;
+			task->other.last = ts;
+			cpu_data->last_idle = true;
+		}
+		return;
+	}
+	if (!task || task->pid > 0) {
+		if (cpu_data->last_idle)
+			update_sched_timings(&cpu_data->idle_task->other, ts);
+
+		cpu_data->last_idle = false;
+		return;
+	}
+	if (cpu_data->last_idle)
+		update_sched_timings(&task->other, ts);
+
+	cpu_data->last_idle = true;
+	task->other.last = ts;
+}
+
 /* Update times for a task scheduling off the CPU */
 static void update_cpu_task_times(struct cpu_data *cpu_data,
 				  struct task_cpu_item *cpu_task,
@@ -203,6 +231,8 @@ static void update_cpu_task_times(struct cpu_data *cpu_data,
 	if (ts < task->start_ts)
 		return;
 
+	update_idle_task(cpu_data, task, ts);
+
 	delta = ts - task->start_ts;
 	task->runtime += delta;
 	cpu_task->runtime += delta;
@@ -227,6 +257,8 @@ static void update_pid(struct cpu_data *cpu_data,
 	cpu_task = get_cpu_task(cpu_data, pid);
 	task = cpu_task->task;
 
+	update_idle_task(cpu_data, task, record->ts);
+
 	if (record->ts < cpu_data->last_ts) {
 		tracecmd_warning("task %d start time %llu greater than CPU time %llu",
 				 pid, record->ts, cpu_data->last_ts);
@@ -258,6 +290,7 @@ static void update_cpu_times(struct cpu_data *cpu_data,
 		cpu_task = get_cpu_task(cpu_data, pid);
 		task = cpu_task->task;
 		task->start_ts = record->ts;
+		update_idle_task(cpu_data, task, record->ts);
 		if (record->ts < cpu_data->data->start_ts)
 			cpu_data->data->start_ts = record->ts;
 		return;
@@ -268,6 +301,8 @@ static void update_cpu_times(struct cpu_data *cpu_data,
 		return;
 	}
 
+	update_idle_task(cpu_data, !pid ? cpu_data->idle_task : NULL, record->ts);
+
 	cpu_data->last_ts = record->ts;
 }
 
@@ -283,6 +318,17 @@ static void update_first_pid(struct cpu_data *cpu_data)
 	delta = cpu_data->start_ts - start_ts;
 	task->runtime += delta;
 	cpu_task->runtime += delta;
+
+	/* Handle idle timings if it was the first task */
+	if (task->pid <= 0) {
+		task->other.total += delta;
+		if (delta > task->other.longest) {
+			task->other.longest = delta;
+			task->other.longest_ts = cpu_data->start_ts;
+		}
+		task->other.nr++;
+	}
+
 	cpu_data->start_ts = start_ts;
 }
 
@@ -337,6 +383,8 @@ static void process_switch(struct analysis_data *data,
 		task->start_ts = record->ts;
 		cpu_data->current_pid = pid;
 
+		update_idle_task(cpu_data, task, record->ts);
+
 		switch (task->last_state) {
 		case -1:
 			/* First time seen */
@@ -452,6 +500,27 @@ static void print_time(unsigned long long ts, char delim)
 	}
 }
 
+static void print_timings_title(const char *label)
+{
+	const char *a = "";
+	int len;
+	int i;
+
+	if (time_in_nsecs)
+		a = "   ";
+
+	len = snprintf(NULL, 0, "%s", label);
+
+	printf("%s%*sTotal    %s(cnt)       Avg              Longest       Where\n",
+		label, 21 - len, "", a);
+
+	for (i = 0; i < len; i++)
+		printf("-");
+
+	printf("%*s-----    %s-----       ---              -------       -----\n",
+		21 - len, "", a);
+}
+
 static void print_sched_timings(const char *label, struct sched_timings *time)
 {
 	unsigned long long avg;
@@ -460,7 +529,10 @@ static void print_sched_timings(const char *label, struct sched_timings *time)
 	if (!time->nr)
 		return;
 
-	printf("%s:\t", label);
+	if (label)
+		printf("%s:%*s", label, 15 - (int)strlen(label), "");
+	else
+		printf("\t\t");
 	print_time(time->total, 0);
 	n = printf(" (%llu)", time->nr);
 	if (n < 8)
@@ -519,6 +591,8 @@ static void print_cpu_data(struct tep_handle *tep, struct cpu_data *cpu_data)
 		printf("idle:\t");
 		print_time(idle_task->runtime, '_');
 		printf(" (%%%lld)\n", (idle_task->runtime * 100) / total_time);
+		print_timings_title("Idleness");
+		print_sched_timings(NULL, &idle_task->other);
 	} else {
 		printf("Never idle!\n");
 	}
@@ -543,19 +617,12 @@ static void print_cpu_data(struct tep_handle *tep, struct cpu_data *cpu_data)
 
 static void print_task(struct tep_handle *tep, struct task_item *task)
 {
-	const char *a = "";
-
-	if (time_in_nsecs)
-		a = "   ";
-
 	printf("\nTask: %d : %s:\n",
 	       task->pid , task->comm ? : tep_data_comm_from_pid(tep, task->pid));
 	printf("Runtime: ");
 	print_time(task->runtime, '_');
-	printf("\nType                 Total    %s(cnt)       Avg              Longest       Where\n",
-		a);
-	printf("----                 -----    %s-----       ---              -------       -----\n",
-		a);
+	printf("\n");
+	print_timings_title("Type");
 	print_sched_timings("Preempted", &task->preempt);
 	print_sched_timings("Blocked", &task->blocked);
 	print_sched_timings("Sleeping", &task->sleep);
-- 
2.35.1

