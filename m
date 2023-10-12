Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750A620E5
	for <linux-trace-devel@vger.kernel.org>; Thu, 12 Oct 2023 16:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F261C433C8;
	Thu, 12 Oct 2023 16:38:51 +0000 (UTC)
Date: Thu, 12 Oct 2023 12:40:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval task-eval: Simplify logic by adding more
 helper functions
Message-ID: <20231012124016.26ea05fb@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Instead of trying to keep track of all the traceeval_data array sizes in
the code. Add wrappers that assign each of the various traceevals.

 insert_cpu_data()
 start_cpu_data()
 continue_cpu_data()
 stop_cpu_data()
 cpu_last_state()

 insert_task_data()
 start_task_data()
 stop_task_data()
 task_data_exists()

 insert_thread_data()

The above functions handle the traceveal logic with the keys and the vals
and only the necessary data is passed to them. This makes it much easier
to handle the logic in the main code.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 391 +++++++++++++++++++++++---------------------
 1 file changed, 204 insertions(+), 187 deletions(-)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index 199c3b5dd926..e355d0755b8a 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -84,6 +84,17 @@ void pdie(const char *fmt, ...)
 /* Used for stats */
 #define DELTA_NAME		"delta"
 
+enum sched_state {
+	RUNNING,
+	BLOCKED,
+	PREEMPT,
+	SLEEP,
+	IDLE,
+	ZOMBIE,
+	EXITED,
+	OTHER
+};
+
 /*
  * Keep track of when a CPU is running tasks and when it is
  * idle. Use the CPU number to match the timings in the
@@ -96,11 +107,6 @@ static struct traceeval_type cpu_delta_keys[] = {
 	},
 };
 
-static void assign_cpu_delta_keys(struct traceeval_data keys[1], int cpu)
-{
-	TRACEEVAL_SET_NUMBER(keys[0], cpu);
-}
-
 /*
  * When scheduling, record the state the CPU was in.
  * It only cares about IDLE vs RUNNING. If the idle task is being
@@ -114,9 +120,67 @@ static struct traceeval_type cpu_delta_vals[] = {
 	},
 };
 
-static void assign_cpu_delta_vals(struct traceeval_data vals[1], int state)
+static void start_cpu_data(struct traceeval *teval, int cpu, int state,
+			   unsigned long long ts)
+{
+	struct traceeval_data keys[1];
+	struct traceeval_data vals[1];
+
+	TRACEEVAL_SET_NUMBER(keys[0], cpu);
+	TRACEEVAL_SET_NUMBER(vals[0], state);
+
+	traceeval_delta_start(teval, keys, vals, ts);
+}
+
+static void continue_cpu_data(struct traceeval *teval, int cpu, int state,
+			      unsigned long long ts)
 {
+	struct traceeval_data keys[1];
+	struct traceeval_data vals[1];
+
+	TRACEEVAL_SET_NUMBER(keys[0], cpu);
 	TRACEEVAL_SET_NUMBER(vals[0], state);
+
+	traceeval_delta_continue(teval, keys, vals, ts);
+}
+
+static int stop_cpu_data(struct traceeval *teval, int cpu, int *state,
+			 unsigned long long ts,
+			 unsigned long long *delta)
+{
+	const struct traceeval_data *results;
+	struct traceeval_data keys[1];
+	int ret;
+
+	TRACEEVAL_SET_NUMBER(keys[0], cpu);
+
+	ret = traceeval_delta_stop(teval, keys, &results, ts, delta, NULL);
+	if (ret < 1)
+		return ret;
+
+	if (state)
+		*state = results[0].number;
+
+	traceeval_results_release(teval, results);
+	return 1;
+}
+
+int cpu_last_state(struct traceeval *teval, int cpu, int *state)
+{
+	const struct traceeval_data *results;
+	struct traceeval_data keys[1];
+	int ret;
+
+	TRACEEVAL_SET_NUMBER(keys[0], cpu);
+
+	ret = traceeval_delta_query(teval, keys, &results);
+	if (ret < 1)
+		return ret;
+
+	*state = results[0].number;
+
+	traceeval_results_release(teval, results);
+	return 1;
 }
 
 /*
@@ -133,12 +197,6 @@ static struct traceeval_type cpu_keys[] = {
 	},
 };
 
-static void assign_cpu_keys(struct traceeval_data keys[2], int cpu, int state)
-{
-	TRACEEVAL_SET_NUMBER(keys[0], cpu);
-	TRACEEVAL_SET_NUMBER(keys[1], state);
-}
-
 /*
  * The mapping of CPU and state will track the timings of how long the
  * CPU was in that state.
@@ -150,11 +208,18 @@ static struct traceeval_type cpu_vals[] = {
 	},
 };
 
-static void assign_cpu_vals(struct traceeval_data vals[1],
-			    unsigned long long delta,
-			    unsigned long long timestamp)
+static void insert_cpu_data(struct traceeval *teval, int cpu, int state,
+			    unsigned long long delta, unsigned long long ts)
 {
-	TRACEEVAL_SET_DELTA(vals[0], delta, timestamp);
+	struct traceeval_data keys[2];
+	struct traceeval_data vals[1];
+
+	TRACEEVAL_SET_NUMBER(keys[0], cpu);
+	TRACEEVAL_SET_NUMBER(keys[1], state);
+
+	TRACEEVAL_SET_DELTA(vals[0], delta, ts);
+
+	traceeval_insert(teval, keys, vals);
 }
 
 /*
@@ -168,11 +233,6 @@ static struct traceeval_type task_delta_keys[] = {
 	},
 };
 
-static void assign_task_delta_keys(struct traceeval_data keys[1], int pid)
-{
-	TRACEEVAL_SET_NUMBER(keys[0], pid);
-}
-
 /*
  * When finishing the timings, will need the name of the task, the
  * state it was in:  (RUNNING, PREEMPTED, BLOCKED, IDLE, or other)
@@ -193,12 +253,46 @@ static struct traceeval_type task_delta_vals[] = {
 	},
 };
 
-static void assign_task_delta_vals(struct traceeval_data vals[3],
-				   int state, const char *comm, int prio)
+static void start_task_data(struct traceeval *teval, int pid, int state,
+			    const char *comm, int prio, unsigned long long ts)
 {
+	struct traceeval_data keys[1];
+	struct traceeval_data vals[3];
+
+	TRACEEVAL_SET_NUMBER(keys[0], pid);
+
 	TRACEEVAL_SET_NUMBER(vals[0], state);
 	TRACEEVAL_SET_CSTRING(vals[1], comm);
 	TRACEEVAL_SET_NUMBER(vals[2], prio);
+
+	traceeval_delta_start(teval, keys, vals, ts);
+}
+
+static int stop_task_data(struct traceeval *teval, int pid, int *state,
+			  const char **comm, int *prio, unsigned long long ts,
+			  unsigned long long *delta, unsigned long long *save_ts)
+{
+	const struct traceeval_data *results;
+	struct traceeval_data keys[1];
+	int ret;
+
+	TRACEEVAL_SET_NUMBER(keys[0], pid);
+
+	ret = traceeval_delta_stop(teval, keys, &results, ts, delta, save_ts);
+	if (ret < 1)
+		return ret;
+
+	if (state)
+		*state = results[0].number;
+
+	if (comm)
+		*comm = results[1].string;
+
+	if (prio)
+		*prio = results[2].number;
+
+	traceeval_results_release(teval, results);
+	return 1;
 }
 
 /*
@@ -218,13 +312,6 @@ static struct traceeval_type task_keys[] = {
 	},
 };
 
-static void assign_task_keys(struct traceeval_data keys[2],
-			     const char *comm, int state)
-{
-	TRACEEVAL_SET_CSTRING(keys[0], comm);
-	TRACEEVAL_SET_NUMBER(keys[1], state);
-}
-
 static void release_data(const struct traceeval_type *type,
 			  struct traceeval_data *data);
 
@@ -260,12 +347,49 @@ static struct traceeval_type task_vals[] = {
 	},
 };
 
-static void assign_task_vals(struct traceeval_data vals[2],
-			     void *data, unsigned long long delta,
+static int insert_task_data(struct traceeval *teval, const char *comm,
+			     int state, void *data, unsigned long long delta,
 			     unsigned long long timestamp)
 {
+	struct traceeval_data keys[2];
+	struct traceeval_data vals[2];
+
+	TRACEEVAL_SET_CSTRING(keys[0], comm);
+	TRACEEVAL_SET_NUMBER(keys[1], state);
+
+	/*
+	 * Can not have data stored more than once, only save it for
+	 * the RUNNING state.
+	 */
+	if (state != RUNNING)
+		data = NULL;
+
 	TRACEEVAL_SET_POINTER(vals[0], data);
 	TRACEEVAL_SET_DELTA(vals[1], delta, timestamp);
+
+	return traceeval_insert(teval, keys, vals);
+}
+
+static bool task_data_exists(struct traceeval *teval, const char *comm, void **data)
+{
+	const struct traceeval_data *results;
+	struct traceeval_data keys[] = {
+		DEFINE_TRACEEVAL_CSTRING(	comm	),
+		DEFINE_TRACEEVAL_NUMBER(	RUNNING	),
+	};
+	int ret;
+
+	ret = traceeval_query(teval, keys, &results);
+	if (ret > 0) {
+		if (data)
+			*data = results[0].pointer;
+		traceeval_results_release(teval, results);
+		return true;
+	}
+	if (ret < 0)
+		pdie("Could not query process data");
+
+	return false;
 }
 
 /*
@@ -289,14 +413,6 @@ static struct traceeval_type thread_keys[] = {
 	},
 };
 
-static void assign_thread_keys(struct traceeval_data keys[3],
-				int tid, int state, int prio)
-{
-	TRACEEVAL_SET_NUMBER(keys[0], tid);
-	TRACEEVAL_SET_NUMBER(keys[1], state);
-	TRACEEVAL_SET_NUMBER(keys[2], prio);
-}
-
 /*
  * Save the timings of the thread/state/prio keys.
  */
@@ -307,23 +423,22 @@ static struct traceeval_type thread_vals[] = {
 	},
 };
 
-static void assign_thread_vals(struct traceeval_data vals[1],
+static void insert_thread_data(struct traceeval *teval, 
+			       int tid, int state, int prio,
 			       unsigned long long delta,
 			       unsigned long long timestamp)
 {
+	struct traceeval_data keys[3];
+	struct traceeval_data vals[1];
+
+	TRACEEVAL_SET_NUMBER(keys[0], tid);
+	TRACEEVAL_SET_NUMBER(keys[1], state);
+	TRACEEVAL_SET_NUMBER(keys[2], prio);
+
 	TRACEEVAL_SET_DELTA(vals[0], delta, timestamp);
-}
 
-enum sched_state {
-	RUNNING,
-	BLOCKED,
-	PREEMPT,
-	SLEEP,
-	IDLE,
-	ZOMBIE,
-	EXITED,
-	OTHER
-};
+	traceeval_insert(teval, keys, vals);
+}
 
 struct process_data {
 	struct traceeval	*teval_cpus;
@@ -370,25 +485,12 @@ static void init_process_data(struct process_data *pdata)
 
 void set_process_data(struct task_data *tdata, const char *comm, void *data)
 {
-	struct traceeval_data keys[] = {
-		DEFINE_TRACEEVAL_CSTRING(	comm	),
-		DEFINE_TRACEEVAL_NUMBER(	RUNNING	),
-	};
-	struct traceeval_data new_vals[2] = { };
-	const struct traceeval_data *results;
 	int ret;
 
-	ret = traceeval_query(tdata->teval_tasks, keys, &results);
-	if (ret > 0) {
-		traceeval_results_release(tdata->teval_tasks, results);
-		return; /* It already exists ? */
-	}
-	if (ret < 0)
-		pdie("Could not query process data");
-
-	assign_task_vals(new_vals, data, 0, 0);
+	if (task_data_exists(tdata->teval_tasks, comm, NULL))
+		return;
 
-	ret = traceeval_insert(tdata->teval_tasks, keys, new_vals);
+	ret = insert_task_data(tdata->teval_tasks, comm, RUNNING, data, 0, 0);
 	if (ret < 0)
 		pdie("Failed to set process data");
 }
@@ -415,66 +517,33 @@ static struct process_data *alloc_pdata(struct task_data *tdata, const char *com
 static struct process_data *
 get_process_data(struct task_data *tdata, const char *comm)
 {
-	struct traceeval_data keys[] = {
-		DEFINE_TRACEEVAL_CSTRING(	comm	),
-		DEFINE_TRACEEVAL_NUMBER(	RUNNING	),
-	};
-	const struct traceeval_data *results;
 	void *data;
-	int ret;
 
-	ret = traceeval_query(tdata->teval_tasks, keys, &results);
-	if (ret < 0)
-		pdie("Could not query process data");
-	if (ret == 0)
+	if (!task_data_exists(tdata->teval_tasks, comm, &data))
 		return alloc_pdata(tdata, comm);
 
-	data = results[0].pointer;
-	traceeval_results_release(tdata->teval_tasks, results);
 	return data;
 }
 
-static void update_cpu_data(struct task_data *tdata, int cpu, int state,
-			    unsigned long long delta, unsigned long long ts)
-{
-	struct traceeval_data cpu_keys[2];
-	struct traceeval_data vals[1];
-
-	assign_cpu_keys(cpu_keys, cpu, state);
-	assign_cpu_vals(vals, delta, ts);
-
-	traceeval_insert(tdata->teval_cpus, cpu_keys, vals);
-}
-
 /*
  * When a CPU is scheduling in idle, record the running state,
  * and start the idle timings.
  */
 static void update_cpu_to_idle(struct task_data *tdata, struct tep_record *record)
 {
-
-	struct traceeval_data delta_keys[1];
-	struct traceeval_data vals[1];
-	const struct traceeval_data *results;
 	unsigned long long delta;
+	int state;
 	int ret;
 
 	/* Finish previous run */
-	assign_cpu_delta_keys(delta_keys, record->cpu);
-
-	ret = traceeval_delta_stop(tdata->teval_cpus, delta_keys, &results,
-				   record->ts, &delta, NULL);
-
-	if (ret > 0) {
-		update_cpu_data(tdata, record->cpu, results[0].number,
+	ret = stop_cpu_data(tdata->teval_cpus, record->cpu, &state,
+			    record->ts, &delta);
+	if (ret > 0)
+		insert_cpu_data(tdata->teval_cpus, record->cpu, state,
 				delta, record->ts);
-		traceeval_results_release(tdata->teval_cpus, results);
-	}
 
 	/* Start the next state */
-	assign_cpu_delta_vals(vals, IDLE);
-	traceeval_delta_start(tdata->teval_cpus, delta_keys, vals,
-			      record->ts);
+	start_cpu_data(tdata->teval_cpus, record->cpu, IDLE, record->ts);
 }
 
 /*
@@ -483,90 +552,58 @@ static void update_cpu_to_idle(struct task_data *tdata, struct tep_record *recor
  */
 static void update_cpu_to_running(struct task_data *tdata, struct tep_record *record)
 {
-	struct traceeval_data delta_keys[1];
-	struct traceeval_data cpu_keys[2];
-	struct traceeval_data vals[1];
-	const struct traceeval_data *results;
 	unsigned long long delta;
+	int state;
 	int ret;
 
-	assign_cpu_delta_keys(delta_keys, record->cpu);
-
 	/* Test if the CPU was idle */
-	ret = traceeval_delta_query(tdata->teval_cpus, delta_keys, &results);
-	if (ret > 0 && results[0].number == IDLE) {
+	ret = cpu_last_state(tdata->teval_cpus, record->cpu, &state);
+	if (ret > 0 && state == IDLE) {
 		/* Coming from idle */
-		traceeval_delta_stop(tdata->teval_cpus, delta_keys, NULL,
-				     record->ts, &delta, NULL);
+		stop_cpu_data(tdata->teval_cpus, record->cpu, NULL,
+				    record->ts, &delta);
+
 		/* Update the idle teval */
-		assign_cpu_keys(cpu_keys, record->cpu, IDLE);
-		assign_cpu_vals(vals, delta, record->ts);
-		traceeval_insert(tdata->teval_cpus, cpu_keys, vals);
+		insert_cpu_data(tdata->teval_cpus, record->cpu, IDLE, delta, record->ts);
 	}
 
 	/* Continue with the CPU running */
-	assign_cpu_delta_vals(vals, RUNNING);
-	traceeval_delta_continue(tdata->teval_cpus, delta_keys, vals,
-				 record->ts);
+	continue_cpu_data(tdata->teval_cpus, record->cpu, RUNNING, record->ts);
 }
 
 static void update_thread(struct task_data *tdata, int pid, const char *comm,
 			  enum sched_state state, int prio, unsigned long long delta,
 			  unsigned long long ts)
 {
-		struct traceeval_data task_keys[2];
-		struct traceeval_data thread_keys[3];
-		struct traceeval_data pvals[2];
-		struct traceeval_data vals[1];
-		struct process_data *pdata;
-
-		pdata = get_process_data(tdata, comm);
-
-		assign_thread_keys(thread_keys, pid, state, prio);
-		assign_thread_vals(vals, delta, ts);
-
-		traceeval_insert(pdata->teval_threads, thread_keys, vals);
+	struct process_data *pdata;
 
-		/* Only the RUNNING state keeps pdata */
-		if (state != RUNNING)
-			pdata = NULL;
+	pdata = get_process_data(tdata, comm);
 
-		/* Also update the process */
-		assign_task_keys(task_keys, comm, state);
-		assign_task_vals(pvals, pdata, delta, ts);
+	insert_thread_data(pdata->teval_threads, pid, state, prio, delta, ts);
 
-		traceeval_insert(tdata->teval_tasks, task_keys, pvals);
+	/* Also update the process */
+	insert_task_data(tdata->teval_tasks, comm, state, pdata, delta, ts);
 }
 
 static void start_running_thread(struct task_data *tdata,
 				 struct tep_record *record,
 				 const char *comm, int pid, int prio)
 {
-	const struct traceeval_data *results;
-	struct traceeval_data delta_keys[1];
-	struct traceeval_data vals[3];
 	unsigned long long delta;
 	unsigned long long val;
+	int state;
 	int ret;
 
-	assign_task_delta_keys(delta_keys, pid);
-
-	/* Find the previous stop state of this task */
-	ret = traceeval_delta_stop(tdata->teval_tasks, delta_keys,
-				   &results, record->ts, &delta, &val);
+	ret = stop_task_data(tdata->teval_tasks, pid, &state,
+			     NULL, NULL, record->ts, &delta, &val);
 	if (ret > 0) {
-		enum sched_state state = results[0].number;
-
 		if (state == RUNNING)
 			die("State %d is running! %lld -> %lld", pid, val, record->ts);
 		update_thread(tdata, pid, comm, state, prio, delta, record->ts);
-		traceeval_results_release(tdata->teval_tasks, results);
 	}
 
 	/* This task is running, so start timing the running portion */
-	assign_task_delta_vals(vals, RUNNING, comm, prio);
-
-	traceeval_delta_start(tdata->teval_tasks, delta_keys, vals, record->ts);
+	start_task_data(tdata->teval_tasks, pid, RUNNING, comm, prio, record->ts);
 }
 
 static int get_stop_state(unsigned long long val)
@@ -588,14 +625,7 @@ static void sched_out(struct task_data *tdata, const char *comm,
 		      struct tep_format_field *prev_state,
 		      struct tep_format_field *prev_prio)
 {
-	struct traceeval_data delta_keys[1];
-	struct traceeval_data task_keys[2];
-	struct traceeval_data task_delta_vals[3];
-	struct traceeval_data task_vals[2];
-	struct traceeval_data thread_keys[3];
-	struct traceeval_data vals[1];
 	struct process_data *pdata;
-	const struct traceeval_data *results;
 	unsigned long long delta;
 	unsigned long long val;
 	int state;
@@ -624,18 +654,12 @@ static void sched_out(struct task_data *tdata, const char *comm,
 	state = get_stop_state(val);
 
 	/* Stop the RUNNING timings of the tasks that is scheduling out */
-	assign_task_delta_keys(delta_keys, pid);
-
-	ret = traceeval_delta_stop(tdata->teval_tasks, delta_keys, &results,
-				   record->ts, &delta, &val);
+	ret = stop_task_data(tdata->teval_tasks, pid, &old_state, NULL, NULL,
+			     record->ts, &delta, &val);
 
-	assign_task_delta_vals(task_delta_vals, state, comm, prio);
+	/* Start timing the task while it's off the CPU */
+	start_task_data(tdata->teval_tasks, pid, state, comm, prio, record->ts);
 
-	if (ret > 0)
-		old_state = results[0].number;
-
-	/* Start recording why this task is off the CPU */
-	traceeval_delta_start(tdata->teval_tasks, delta_keys, task_delta_vals, record->ts);
 	if (ret <= 0)
 		return;
 
@@ -644,24 +668,16 @@ static void sched_out(struct task_data *tdata, const char *comm,
 		die("Not running %d from %lld to %lld",
 		    old_state, val, record->ts);
 
-	/* Now start the "running" timings of the task scheduling in */
-	assign_task_keys(task_keys, comm, RUNNING);
+	/* Now add the "running" timing of the thread that scheduled out */
 
 	pdata = get_process_data(tdata, comm);
 
-	assign_task_vals(task_vals, pdata, delta, record->ts);
-
-	traceeval_insert(tdata->teval_tasks, task_keys, task_vals);
+	insert_task_data(tdata->teval_tasks, comm, RUNNING, pdata, delta, record->ts);
 
 	/* Update the individual thread as well */
-	assign_thread_keys(thread_keys, pid, RUNNING, prio);
-	assign_thread_vals(vals, delta, record->ts);
-
-	traceeval_insert(pdata->teval_threads, thread_keys, vals);
-
-	assign_cpu_keys(task_keys, record->cpu, RUNNING);
 
-	traceeval_insert(pdata->teval_cpus, task_keys, vals);
+	insert_thread_data(pdata->teval_threads, pid, RUNNING, prio, delta, record->ts);
+	insert_cpu_data(pdata->teval_threads, record->cpu, RUNNING, delta, record->ts);
 }
 
 static void sched_in(struct task_data *tdata, const char *comm,
@@ -1136,8 +1152,9 @@ static void finish_leftovers(struct task_data *data)
 	while (traceeval_iterator_next(iter, &keys) > 0) {
 		traceeval_iterator_delta_stop(iter, &results, data->last_ts,
 					      &delta, NULL);
-		update_cpu_data(data, keys[0].number, results[0].number,
+		insert_cpu_data(data->teval_cpus, keys[0].number, results[0].number,
 				delta, data->last_ts);
+		traceeval_iterator_results_release(iter, results);
 	}
 	traceeval_iterator_put(iter);
 
-- 
2.42.0

