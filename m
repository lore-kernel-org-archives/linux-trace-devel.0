Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22E6CA4A
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349F4C433CC;
	Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qqPrt-007ZT6-2C;
	Tue, 10 Oct 2023 23:26:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 07/11] libtraceeval task-eval: Add more comments
Date: Tue, 10 Oct 2023 23:25:23 -0400
Message-ID: <20231011032640.1804571-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231011032640.1804571-1-rostedt@goodmis.org>
References: <20231011032640.1804571-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add more comments explaining what is going on in task-eval.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 74 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index 4a500227cf11..aa61ec38244f 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -84,6 +84,11 @@ void pdie(const char *fmt, ...)
 /* Used for stats */
 #define DELTA_NAME		"delta"
 
+/*
+ * Keep track of when a CPU is running tasks and when it is
+ * idle. Use the CPU number to match the timings in the
+ * sched_switch event.
+ */
 static struct traceeval_type cpu_delta_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -96,6 +101,12 @@ static void assign_cpu_delta_keys(struct traceeval_data keys[1], int cpu)
 	TRACEEVAL_SET_NUMBER(keys[0], cpu);
 }
 
+/*
+ * When scheduling, record the state the CPU was in.
+ * It only cares about IDLE vs RUNNING. If the idle task is being
+ * scheduled in, mark it the staet as IDLE, otherwise mark it
+ * as RUNNING.
+ */
 static struct traceeval_type cpu_delta_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -108,6 +119,9 @@ static void assign_cpu_delta_vals(struct traceeval_data vals[1], int state)
 	TRACEEVAL_SET_NUMBER(vals[0], state);
 }
 
+/*
+ * The output will show all the CPUs and their IDLE vs RUNNING states.
+ */
 static struct traceeval_type cpu_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -125,6 +139,10 @@ static void assign_cpu_keys(struct traceeval_data keys[2], int cpu, int state)
 	TRACEEVAL_SET_NUMBER(keys[1], state);
 }
 
+/*
+ * The mapping of CPU and state will track the timings of how long the
+ * CPU was in that state.
+ */
 static struct traceeval_type cpu_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_DELTA,
@@ -139,6 +157,10 @@ static void assign_cpu_vals(struct traceeval_data vals[1],
 	TRACEEVAL_SET_DELTA(vals[0], delta, timestamp);
 }
 
+/*
+ * When tracking tasks and threads, remember the task id (PID)
+ * when scheduling out (for sleep state) or in (for running state).
+ */
 static struct traceeval_type task_delta_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -151,6 +173,11 @@ static void assign_task_delta_keys(struct traceeval_data keys[1], int pid)
 	TRACEEVAL_SET_NUMBER(keys[0], pid);
 }
 
+/*
+ * When finishing the timings, will need the name of the task, the
+ * state it was in:  (RUNNING, PREEMPTED, BLOCKED, IDLE, or other)
+ * and the priority it had. This will be saved for the output.
+ */
 static struct traceeval_type task_delta_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -174,6 +201,12 @@ static void assign_task_delta_vals(struct traceeval_data vals[3],
 	TRACEEVAL_SET_NUMBER(vals[2], prio);
 }
 
+/*
+ * Will output all the processes by their names. This means the two
+ * tasks with the same name will be grouped together (even though they
+ * may not be threads). The tasks will also be broken up by what state
+ * they were in: RUNNING, BLOCKED, PREEMPTED, SLEEPING.
+ */
 static struct traceeval_type task_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_STRING,
@@ -192,6 +225,14 @@ static void assign_task_keys(struct traceeval_data keys[2],
 	TRACEEVAL_SET_NUMBER(keys[1], state);
 }
 
+/*
+ * For each state the process is in, record the time delta for
+ * that state. Also, only for the RUNNING state, this will
+ * daisy chain another traceeval for each thread. That is,
+ * for each unique thread id (PID), there will be a traceeval
+ * histogram of those threads denoted by the teval_thread, and
+ * that will be saved in the "data" field.
+ */
 static struct traceeval_type task_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_POINTER,
@@ -211,6 +252,12 @@ static void assign_task_vals(struct traceeval_data vals[2],
 	TRACEEVAL_SET_DELTA(vals[1], delta, timestamp);
 }
 
+/*
+ * Each recorded process will have a traceeval to save all the
+ * threads within it. The threads will be mapped by their TID (PID)
+ * the state they were in: RUNNING, BLOCKED, PREEMPTED, SLEEPING
+ * and their priority.
+ */
 static struct traceeval_type thread_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -234,6 +281,9 @@ static void assign_thread_keys(struct traceeval_data keys[3],
 	TRACEEVAL_SET_NUMBER(keys[2], prio);
 }
 
+/*
+ * Save the timings of the thread/state/prio keys.
+ */
 static struct traceeval_type thread_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_DELTA,
@@ -326,6 +376,12 @@ static struct process_data *alloc_pdata(struct task_data *tdata, const char *com
 	return pdata;
 }
 
+/*
+ * Each process will have a traceeval for all their threads. The
+ * thread traceeval descriptor will be saved in the process/RUNNING
+ * field. If a process is never running, then it will not have any
+ * threads!
+ */
 static struct process_data *
 get_process_data(struct task_data *tdata, const char *comm)
 {
@@ -360,6 +416,10 @@ static void update_cpu_data(struct task_data *tdata, int cpu, int state,
 	traceeval_insert(tdata->teval_cpus, cpu_keys, vals);
 }
 
+/*
+ * When a CPU is scheduling in idle, record the running state,
+ * and start the idle timings.
+ */
 static void update_cpu_to_idle(struct task_data *tdata, struct tep_record *record)
 {
 
@@ -387,6 +447,10 @@ static void update_cpu_to_idle(struct task_data *tdata, struct tep_record *recor
 			      record->ts);
 }
 
+/*
+ * When a CPU is scheduling a task, if idle is scheduling out, stop
+ * the idle timings and start or continue the running timings.
+ */
 static void update_cpu_to_running(struct task_data *tdata, struct tep_record *record)
 {
 	struct traceeval_data delta_keys[1];
@@ -465,6 +529,7 @@ static void start_running_thread(struct task_data *tdata,
 		traceeval_results_release(tdata->teval_tasks, results);
 	}
 
+	/* This task is running, so start timing the running portion */
 	assign_task_delta_vals(vals, RUNNING, comm, prio);
 
 	traceeval_delta_start(tdata->teval_tasks, delta_keys, vals, record->ts);
@@ -524,6 +589,7 @@ static void sched_out(struct task_data *tdata, const char *comm,
 		die("Could not read sched_switch next_pid for record");
 	state = get_stop_state(val);
 
+	/* Stop the RUNNING timings of the tasks that is scheduling out */
 	assign_task_delta_keys(delta_keys, pid);
 
 	ret = traceeval_delta_stop(tdata->teval_tasks, delta_keys, &results,
@@ -539,10 +605,12 @@ static void sched_out(struct task_data *tdata, const char *comm,
 	if (ret <= 0)
 		return;
 
+	/* What is scheduling out should be considered "running" */
 	if (old_state != RUNNING)
 		die("Not running %d from %lld to %lld",
 		    old_state, val, record->ts);
 
+	/* Now start the "running" timings of the task scheduling in */
 	assign_task_keys(task_keys, comm, RUNNING);
 
 	pdata = get_process_data(tdata, comm);
@@ -551,6 +619,7 @@ static void sched_out(struct task_data *tdata, const char *comm,
 
 	traceeval_insert(tdata->teval_tasks, task_keys, task_vals);
 
+	/* Update the individual thread as well */
 	assign_thread_keys(thread_keys, pid, RUNNING, prio);
 	assign_thread_vals(vals, delta, record->ts);
 
@@ -964,6 +1033,11 @@ static void free_tdata(struct task_data *tdata)
 {
 }
 
+/*
+ * When the trace ended, there was likely tasks still running on
+ * the CPU (or sleeping). Just stop all the timings and put them
+ * into the database as well.
+ */
 static void finish_leftovers(struct task_data *data)
 {
 	const struct traceeval_data *results;
-- 
2.42.0

