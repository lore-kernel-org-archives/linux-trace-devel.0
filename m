Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E62B15B13D
	for <linux-trace-devel@vger.kernel.org>; Fri, 25 Oct 2024 07:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729842127; cv=none; b=nJvjoUt3PN51NJsFSQqjZNS9JXm8ospiQCY9HW8F9FJy4TQ5fiuCnEeX6grRo4JxEx04wyM4ZJoejBvCTTAUmd0dMI4ZG3fOMn4vGB5+f7RLzdtrKnxZFIgFlP5saZxvrQqDZJpgTzbIQ5zx4735fPmTeF4Y+CIqovUMf1LIzEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729842127; c=relaxed/simple;
	bh=gqvqTnn5bpS+zGyakPzTPbVBJLTBuLNBlc+n0Jg1g3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlYumykU6WAP5M4ycX8viMDmbxEieRcD43+VW1Q4BO8eMK3CgwQdfgcZwBUa+A7v/Cq7EugAaVitfypnt9gHge8Yg5Njjf7aNYtMKBHhURkETrTVUHMQ0GEfKtS9q+i/WsMZA30vMpNvH70x8Ia7BK1GLpMorskj0cvDXsXLfY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DE9C4CEC3;
	Fri, 25 Oct 2024 07:42:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1t4Ey8-00000004r2h-46t6;
	Fri, 25 Oct 2024 03:42:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/4] libtraceeval task-eval: Add wake up latency
Date: Fri, 25 Oct 2024 03:40:44 -0400
Message-ID: <20241025074247.1157166-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241025074247.1157166-1-rostedt@goodmis.org>
References: <20241025074247.1157166-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add logic to keep track of the wake up latency if the sched_waking event
is recorded.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 238 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 222 insertions(+), 16 deletions(-)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index 178936dec686..7b709f715332 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -92,7 +92,8 @@ enum sched_state {
 	IDLE,
 	ZOMBIE,
 	EXITED,
-	OTHER
+	OTHER,
+	WAKEUP,
 };
 
 /*
@@ -222,6 +223,68 @@ static void insert_cpu_data(struct traceeval *teval, int cpu, int state,
 	traceeval_insert(teval, keys, vals);
 }
 
+/*
+ * When tracking tasks and threads wake up timings.
+ */
+static struct traceeval_type wakeup_delta_keys[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "PID",
+	},
+};
+
+/*
+ * When finishing the timings of the task being woken up.
+ */
+static struct traceeval_type wakeup_delta_vals[] = {
+	{
+		.type = TRACEEVAL_TYPE_STRING,
+		.name = "COMM",
+	},
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "Prio",
+	},
+};
+
+static void start_wakeup_data(struct traceeval *teval, int pid,
+			      const char *comm, int prio, unsigned long long ts)
+{
+	struct traceeval_data keys[1];
+	struct traceeval_data vals[2];
+
+	TRACEEVAL_SET_NUMBER(keys[0], pid);
+
+	TRACEEVAL_SET_CSTRING(vals[0], comm);
+	TRACEEVAL_SET_NUMBER(vals[1], prio);
+
+	traceeval_delta_start(teval, keys, vals, ts);
+}
+
+static int stop_wakeup_data(struct traceeval *teval, int pid,
+			    const char **comm, int *prio, unsigned long long ts,
+			    unsigned long long *delta)
+{
+	const struct traceeval_data *results;
+	struct traceeval_data keys[1];
+	int ret;
+
+	TRACEEVAL_SET_NUMBER(keys[0], pid);
+
+	ret = traceeval_delta_stop(teval, keys, &results, ts, delta, NULL);
+	if (ret < 1)
+		return ret;
+
+	if (comm)
+		*comm = results[0].string;
+
+	if (prio)
+		*prio = results[1].number;
+
+	traceeval_results_release(teval, results);
+	return 1;
+}
+
 /*
  * When tracking tasks and threads, remember the task id (PID)
  * when scheduling out (for sleep state) or in (for running state).
@@ -405,11 +468,11 @@ static struct traceeval_type thread_keys[] = {
 	},
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "Schedule state",
+		.name = "Prio",
 	},
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "Prio",
+		.name = "Schedule state",
 	},
 };
 
@@ -432,8 +495,64 @@ static void insert_thread_data(struct traceeval *teval,
 	struct traceeval_data vals[1];
 
 	TRACEEVAL_SET_NUMBER(keys[0], tid);
-	TRACEEVAL_SET_NUMBER(keys[1], state);
-	TRACEEVAL_SET_NUMBER(keys[2], prio);
+	TRACEEVAL_SET_NUMBER(keys[1], prio);
+	TRACEEVAL_SET_NUMBER(keys[2], state);
+
+	TRACEEVAL_SET_DELTA(vals[0], delta, timestamp);
+
+	traceeval_insert(teval, keys, vals);
+}
+
+static struct traceeval_type wakeup_task_keys[] = {
+	{
+		.type = TRACEEVAL_TYPE_STRING,
+		.name = "COMM"
+	},
+};
+
+static struct traceeval_type wakeup_thread_keys[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "PID"
+	},
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "Prio"
+	},
+};
+
+static struct traceeval_type wakeup_vals[] = {
+	{
+		.type = TRACEEVAL_TYPE_DELTA,
+		.name = DELTA_NAME,
+	},
+};
+
+static void insert_wakeup_task_data(struct traceeval *teval,
+				    const char *comm,
+				    unsigned long long delta,
+				    unsigned long long timestamp)
+{
+	struct traceeval_data keys[1];
+	struct traceeval_data vals[1];
+
+	TRACEEVAL_SET_CSTRING(keys[0], comm);
+
+	TRACEEVAL_SET_DELTA(vals[0], delta, timestamp);
+
+	traceeval_insert(teval, keys, vals);
+}
+
+static void insert_wakeup_thread_data(struct traceeval *teval,
+				      int tid, int prio,
+				      unsigned long long delta,
+				      unsigned long long timestamp)
+{
+	struct traceeval_data keys[2];
+	struct traceeval_data vals[1];
+
+	TRACEEVAL_SET_NUMBER(keys[0], tid);
+	TRACEEVAL_SET_NUMBER(keys[1], prio);
 
 	TRACEEVAL_SET_DELTA(vals[0], delta, timestamp);
 
@@ -443,11 +562,13 @@ static void insert_thread_data(struct traceeval *teval,
 struct process_data {
 	struct traceeval	*teval_cpus;
 	struct traceeval	*teval_threads;
+	struct traceeval	*teval_wakeup;
 };
 
 struct task_data {
 	struct traceeval	*teval_cpus;
 	struct traceeval	*teval_tasks;
+	struct traceeval	*teval_wakeup;
 	unsigned long long	last_ts;
 	char			*comm;
 };
@@ -468,6 +589,7 @@ static void release_data(const struct traceeval_type *type,
 	pdata = data->pointer;
 	traceeval_release(pdata->teval_cpus);
 	traceeval_release(pdata->teval_threads);
+	traceeval_release(pdata->teval_wakeup);
 	free(pdata);
 	data->pointer = NULL;
 }
@@ -481,6 +603,10 @@ static void init_process_data(struct process_data *pdata)
 	pdata->teval_threads = traceeval_init(thread_keys, thread_vals);
 	if (!pdata->teval_threads)
 		pdie("Creating trace eval threads");
+
+	pdata->teval_wakeup = traceeval_init(wakeup_thread_keys, wakeup_vals);
+	if (!pdata->teval_wakeup)
+		pdie("Creating trace eval wakeup");
 }
 
 void set_process_data(struct task_data *tdata, const char *comm, void *data)
@@ -576,6 +702,7 @@ static void update_thread(struct task_data *tdata, int pid, const char *comm,
 			  unsigned long long ts)
 {
 	struct process_data *pdata;
+	int ret;
 
 	pdata = get_process_data(tdata, comm);
 
@@ -583,6 +710,12 @@ static void update_thread(struct task_data *tdata, int pid, const char *comm,
 
 	/* Also update the process */
 	insert_task_data(tdata->teval_tasks, comm, state, pdata, delta, ts);
+
+	ret = stop_wakeup_data(tdata->teval_wakeup, pid, &comm, &prio, ts, &delta);
+	if (ret < 1)
+		return;
+	insert_wakeup_task_data(tdata->teval_wakeup, comm, delta, ts);
+	insert_wakeup_thread_data(pdata->teval_wakeup, pid, prio, delta, ts);
 }
 
 static void start_running_thread(struct task_data *tdata,
@@ -660,6 +793,12 @@ static void sched_out(struct task_data *tdata, const char *comm,
 	/* Start timing the task while it's off the CPU */
 	start_task_data(tdata->teval_tasks, pid, state, comm, prio, record->ts);
 
+	/*
+	 * If a wakeup happened when the task was running, do not record
+	 * the wakeup latency.
+	 */
+	stop_wakeup_data(tdata->teval_wakeup, pid, NULL, NULL, record->ts, NULL);
+
 	if (ret <= 0)
 		return;
 
@@ -759,6 +898,43 @@ static int switch_func(struct tracecmd_input *handle, struct tep_event *event,
 	return 0;
 }
 
+static int wakeup_func(struct tracecmd_input *handle, struct tep_event *event,
+		       struct tep_record *record, int cpu, void *data)
+{
+	static struct tep_format_field *comm_field;
+	static struct tep_format_field *pid_field;
+	static struct tep_format_field *prio_field;
+	struct task_data *tdata = data;
+	unsigned long long val;
+	const char *comm;
+	int prio;
+	int pid;
+	int ret;
+
+	if (!comm_field) {
+		comm_field = get_field(event, "comm");
+		pid_field = get_field(event, "pid");
+		prio_field = get_field(event, "prio");
+	}
+
+	comm = record->data + comm_field->offset;
+	if (tdata->comm && strcmp(comm, tdata->comm) != 0)
+		return 0;
+
+	ret = tep_read_number_field(pid_field, record->data, &val);
+	if (ret < 0)
+		die("Could not read sched_switch pid for record");
+	pid = val;
+
+	ret = tep_read_number_field(prio_field, record->data, &val);
+	if (ret < 0)
+		die("Could not read sched_switch prio for record");
+	prio = val;
+
+	start_wakeup_data(tdata->teval_wakeup, pid, comm, prio, record->ts);
+	return 0;
+}
+
 static void print_microseconds(int idx, unsigned long long nsecs)
 {
 	unsigned long long usecs;
@@ -947,10 +1123,15 @@ static void display_state_times(int state, struct traceeval_stat *stat)
 	case SLEEP:
 		printf("      Total sleep time (us):");
 		print_stats(12, stat);
+		break;
+	case WAKEUP:
+		printf("      Total wakeup time (us):");
+		print_stats(11, stat);
+		break;
 	}
 }
 
-static void display_threads(struct traceeval *teval)
+static void display_threads(struct traceeval *teval, struct traceeval *wake_teval)
 {
 	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
 	const struct traceeval_data *keys;
@@ -962,15 +1143,15 @@ static void display_threads(struct traceeval *teval)
 	traceeval_iterator_sort(iter, thread_keys[0].name, 0, true);
 
 	/* PRIO */
-	traceeval_iterator_sort(iter, thread_keys[2].name, 1, true);
+	traceeval_iterator_sort(iter, thread_keys[1].name, 1, true);
 
 	/* STATE */
-	traceeval_iterator_sort(iter, thread_keys[1].name, 2, true);
+	traceeval_iterator_sort(iter, thread_keys[2].name, 2, true);
 
 	while (traceeval_iterator_next(iter, &keys) > 0) {
 		int tid = keys[0].number;
-		int state = keys[1].number;
-		int prio = keys[2].number;
+		int prio = keys[1].number;
+		int state = keys[2].number;
 
 		stat = traceeval_iterator_stat(iter, DELTA_NAME);
 		if (!stat)
@@ -987,6 +1168,14 @@ static void display_threads(struct traceeval *teval)
 		last_prio = prio;
 
 		display_state_times(state, stat);
+
+		if (state != RUNNING)
+			continue;
+
+		stat = traceeval_stat_size(wake_teval, keys, 2, DELTA_NAME);
+		if (!stat)
+			continue;
+		display_state_times(WAKEUP, stat);
 	}
 
 	traceeval_iterator_put(iter);
@@ -997,12 +1186,12 @@ static void display_threads(struct traceeval *teval)
 
 static void display_process(struct process_data *pdata)
 {
-	display_threads(pdata->teval_threads);
+	display_threads(pdata->teval_threads, pdata->teval_wakeup);
 	display_cpus(pdata->teval_cpus);
 	printf("\n");
 }
 
-static void display_process_stats(struct traceeval *teval,
+static void display_process_stats(struct traceeval *teval, struct traceeval *wake_teval,
 				  struct process_data *pdata, const char *comm)
 {
 	struct traceeval_stat *stat;
@@ -1016,10 +1205,18 @@ static void display_process_stats(struct traceeval *teval,
 
 		stat = traceeval_stat(teval, keys, DELTA_NAME);
 		display_state_times(i, stat);
+
+		if (i != RUNNING)
+			continue;
+
+		stat = traceeval_stat_size(wake_teval, keys, 1, DELTA_NAME);
+		if (!stat)
+			continue;
+		display_state_times(WAKEUP, stat);
 	}
 }
 
-static void display_processes(struct traceeval *teval)
+static void display_processes(struct traceeval *teval, struct traceeval *wake_teval)
 {
 	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
 	const struct traceeval_data *keys;
@@ -1049,7 +1246,7 @@ static void display_processes(struct traceeval *teval)
 
 		printf("Task: %s\n", comm);
 
-		display_process_stats(teval, pdata, comm);
+		display_process_stats(teval, wake_teval, pdata, comm);
 		if (pdata)
 			display_process(pdata);
 	}
@@ -1066,7 +1263,7 @@ static void display(struct task_data *tdata)
 	unsigned long long idle_time = 0;
 
 	if (tdata->comm) {
-		return display_processes(tdata->teval_tasks);
+		return display_processes(tdata->teval_tasks, tdata->teval_wakeup);
 	}
 
 	iter = traceeval_iterator_get(teval);
@@ -1105,7 +1302,7 @@ static void display(struct task_data *tdata)
 	display_cpus(tdata->teval_cpus);
 
 	printf("\n");
-	display_processes(tdata->teval_tasks);
+	display_processes(tdata->teval_tasks, tdata->teval_wakeup);
 }
 
 static void free_tdata(struct task_data *tdata)
@@ -1115,6 +1312,7 @@ static void free_tdata(struct task_data *tdata)
 
 	traceeval_release(tdata->teval_cpus);
 	traceeval_release(tdata->teval_tasks);
+	traceeval_release(tdata->teval_wakeup);
 }
 
 /*
@@ -1237,7 +1435,15 @@ int main (int argc, char **argv)
 	if (traceeval_delta_create(data.teval_cpus, cpu_delta_keys, cpu_delta_vals) < 0)
 		pdie("Creating trace delta cpus");
 
+	data.teval_wakeup = traceeval_init(wakeup_task_keys, wakeup_vals);
+	if (!data.teval_wakeup)
+		pdie("Creating trace eval wakeup");
+
+	if (traceeval_delta_create(data.teval_wakeup, wakeup_delta_keys, wakeup_delta_vals) < 0)
+		pdie("Creating trace delta wakeup");
+
 	tracecmd_follow_event(handle, "sched", "sched_switch", switch_func, &data);
+	tracecmd_follow_event(handle, "sched", "sched_waking", wakeup_func, &data);
 
 	tracecmd_iterate_events(handle, NULL, 0, event_callback, &data);
 
-- 
2.45.2

