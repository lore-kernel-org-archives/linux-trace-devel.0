Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702D87494
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A813C433CA;
	Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qqPrt-007ZSo-1q;
	Tue, 10 Oct 2023 23:26:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 03/11] libtraceeval task-eval: Add tracking of priority
Date: Tue, 10 Oct 2023 23:25:19 -0400
Message-ID: <20231011032640.1804571-4-rostedt@goodmis.org>
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

Have the sample code of task-eval also keep track of the priority of a
task. If the priority is less than 120 (not SCHED_OTHER), then split it up
in the output.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 105 ++++++++++++++++++++++++++++++++------------
 1 file changed, 76 insertions(+), 29 deletions(-)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index 11ea73ce8da0..ad3e2424acc8 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -159,13 +159,18 @@ static struct traceeval_type task_delta_vals[] = {
 		.type = TRACEEVAL_TYPE_STRING,
 		.name = "COMM",
 	},
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "Prio",
+	},
 };
 
-static void assign_task_delta_vals(struct traceeval_data vals[2],
-				   int state, const char *comm)
+static void assign_task_delta_vals(struct traceeval_data vals[3],
+				   int state, const char *comm, int prio)
 {
 	TRACEEVAL_SET_NUMBER(vals[0], state);
 	TRACEEVAL_SET_CSTRING(vals[1], comm);
+	TRACEEVAL_SET_NUMBER(vals[2], prio);
 }
 
 static struct traceeval_type task_keys[] = {
@@ -214,13 +219,18 @@ static struct traceeval_type thread_keys[] = {
 		.type = TRACEEVAL_TYPE_NUMBER,
 		.name = "Schedule state",
 	},
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "Prio",
+	},
 };
 
-static void assign_thread_keys(struct traceeval_data keys[2],
-				int tid, int state)
+static void assign_thread_keys(struct traceeval_data keys[3],
+				int tid, int state, int prio)
 {
 	TRACEEVAL_SET_NUMBER(keys[0], tid);
 	TRACEEVAL_SET_NUMBER(keys[1], state);
+	TRACEEVAL_SET_NUMBER(keys[2], prio);
 }
 
 static struct traceeval_type thread_vals[] = {
@@ -404,35 +414,36 @@ static void update_cpu_to_running(struct task_data *tdata, struct tep_record *re
 }
 
 static void update_thread(struct task_data *tdata, int pid, const char *comm,
-			  enum sched_state state, unsigned long long delta,
+			  enum sched_state state, int prio, unsigned long long delta,
 			  unsigned long long ts)
 {
-		struct traceeval_data keys[2];
+		struct traceeval_data task_keys[2];
+		struct traceeval_data thread_keys[3];
 		struct traceeval_data pvals[2];
 		struct traceeval_data vals[1];
 		struct process_data *pdata;
 
 		pdata = get_process_data(tdata, comm);
 
-		assign_thread_keys(keys, pid, state);
+		assign_thread_keys(thread_keys, pid, state, prio);
 		assign_thread_vals(vals, delta, ts);
 
-		traceeval_insert(pdata->teval_threads, keys, vals);
+		traceeval_insert(pdata->teval_threads, thread_keys, vals);
 
 		/* Also update the process */
-		assign_task_keys(keys, comm, state);
+		assign_task_keys(task_keys, comm, state);
 		assign_task_vals(pvals, pdata, delta, ts);
 
-		traceeval_insert(tdata->teval_tasks, keys, pvals);
+		traceeval_insert(tdata->teval_tasks, task_keys, pvals);
 }
 
 static void start_running_thread(struct task_data *tdata,
 				 struct tep_record *record,
-				 const char *comm, int pid)
+				 const char *comm, int pid, int prio)
 {
 	const struct traceeval_data *results;
 	struct traceeval_data delta_keys[1];
-	struct traceeval_data vals[2];
+	struct traceeval_data vals[3];
 	unsigned long long delta;
 	unsigned long long val;
 	int ret;
@@ -447,11 +458,11 @@ static void start_running_thread(struct task_data *tdata,
 
 		if (state == RUNNING)
 			die("State %d is running! %lld -> %lld", pid, val, record->ts);
-		update_thread(tdata, pid, comm, state, delta, record->ts);
+		update_thread(tdata, pid, comm, state, prio, delta, record->ts);
 		traceeval_results_release(tdata->teval_tasks, results);
 	}
 
-	assign_task_delta_vals(vals, RUNNING, comm);
+	assign_task_delta_vals(vals, RUNNING, comm, prio);
 
 	traceeval_delta_start(tdata->teval_tasks, delta_keys, vals, record->ts);
 }
@@ -468,11 +479,14 @@ static int get_stop_state(unsigned long long val)
 static void sched_out(struct task_data *tdata, const char *comm,
 		      struct tep_event *event,
 		      struct tep_record *record, struct tep_format_field *prev_pid,
-		      struct tep_format_field *prev_state)
+		      struct tep_format_field *prev_state,
+		      struct tep_format_field *prev_prio)
 {
 	struct traceeval_data delta_keys[1];
 	struct traceeval_data task_keys[2];
+	struct traceeval_data task_delta_vals[3];
 	struct traceeval_data task_vals[2];
+	struct traceeval_data thread_keys[3];
 	struct traceeval_data vals[1];
 	struct process_data *pdata;
 	const struct traceeval_data *results;
@@ -480,6 +494,7 @@ static void sched_out(struct task_data *tdata, const char *comm,
 	unsigned long long val;
 	int state;
 	int old_state;
+	int prio;
 	int pid;
 	int ret;
 
@@ -492,6 +507,11 @@ static void sched_out(struct task_data *tdata, const char *comm,
 	if (!pid)
 		return;
 
+	ret = tep_read_number_field(prev_prio, record->data, &val);
+	if (ret < 0)
+		die("Could not read sched_switch prev_prio for record");
+	prio = val;
+
 	ret = tep_read_number_field(prev_state, record->data, &val);
 	if (ret < 0)
 		die("Could not read sched_switch next_pid for record");
@@ -502,13 +522,13 @@ static void sched_out(struct task_data *tdata, const char *comm,
 	ret = traceeval_delta_stop(tdata->teval_tasks, delta_keys, &results,
 				   record->ts, &delta, &val);
 
-	assign_task_delta_vals(task_vals, state, comm);
+	assign_task_delta_vals(task_delta_vals, state, comm, prio);
 
 	if (ret > 0)
 		old_state = results[0].number;
 
 	/* Start recording why this task is off the CPU */
-	traceeval_delta_start(tdata->teval_tasks, delta_keys, task_vals, record->ts);
+	traceeval_delta_start(tdata->teval_tasks, delta_keys, task_delta_vals, record->ts);
 	if (ret <= 0)
 		return;
 
@@ -524,10 +544,10 @@ static void sched_out(struct task_data *tdata, const char *comm,
 
 	traceeval_insert(tdata->teval_tasks, task_keys, task_vals);
 
-	assign_thread_keys(task_keys, pid, RUNNING);
+	assign_thread_keys(thread_keys, pid, RUNNING, prio);
 	assign_thread_vals(vals, delta, record->ts);
 
-	traceeval_insert(pdata->teval_threads, task_keys, vals);
+	traceeval_insert(pdata->teval_threads, thread_keys, vals);
 
 	assign_cpu_keys(task_keys, record->cpu, RUNNING);
 
@@ -536,11 +556,14 @@ static void sched_out(struct task_data *tdata, const char *comm,
 
 static void sched_in(struct task_data *tdata, const char *comm,
 		     struct tep_event *event,
-		     struct tep_record *record, struct tep_format_field *next_pid)
+		     struct tep_record *record,
+		     struct tep_format_field *next_pid,
+		     struct tep_format_field *next_prio)
 {
 	unsigned long long val;
-	int ret;
+	int prio;
 	int pid;
+	int ret;
 
 	ret = tep_read_number_field(next_pid, record->data, &val);
 	if (ret < 0)
@@ -553,9 +576,14 @@ static void sched_in(struct task_data *tdata, const char *comm,
 		return;
 	}
 
+	ret = tep_read_number_field(next_prio, record->data, &val);
+	if (ret < 0)
+		die("Could not read sched_switch next_prio for record");
+	prio = val;
+
 	/* Continue measuring CPU running time */
 	update_cpu_to_running(tdata, record);
-	start_running_thread(tdata, record, comm, pid);
+	start_running_thread(tdata, record, comm, pid, prio);
 }
 
 static struct tep_format_field *get_field(struct tep_event *event, const char *name)
@@ -576,8 +604,10 @@ static int switch_func(struct tracecmd_input *handle, struct tep_event *event,
 	static struct tep_format_field *prev_comm;
 	static struct tep_format_field *prev_pid;
 	static struct tep_format_field *prev_state;
+	static struct tep_format_field *prev_prio;
 	static struct tep_format_field *next_comm;
 	static struct tep_format_field *next_pid;
+	static struct tep_format_field *next_prio;
 	struct task_data *tdata = data;
 	const char *comm;
 
@@ -585,18 +615,20 @@ static int switch_func(struct tracecmd_input *handle, struct tep_event *event,
 		prev_comm = get_field(event, "prev_comm");
 		prev_pid = get_field(event, "prev_pid");
 		prev_state = get_field(event, "prev_state");
+		prev_prio = get_field(event, "prev_prio");
 
 		next_comm = get_field(event, "next_comm");
 		next_pid = get_field(event, "next_pid");
+		next_prio = get_field(event, "next_prio");
 	}
 
 	comm = record->data + prev_comm->offset;
 	if (!tdata->comm || strcmp(comm, tdata->comm) == 0)
-		sched_out(tdata, comm, event, record, prev_pid, prev_state);
+		sched_out(tdata, comm, event, record, prev_pid, prev_state, prev_prio);
 
 	comm = record->data + next_comm->offset;
 	if (!tdata->comm || strcmp(comm, tdata->comm) == 0)
-		sched_in(tdata, comm, event, record, next_pid);
+		sched_in(tdata, comm, event, record, next_pid, next_prio);
 
 	return 0;
 }
@@ -740,22 +772,35 @@ static void display_threads(struct traceeval *teval)
 	const struct traceeval_data *keys;
 	struct traceeval_stat *stat;
 	int last_tid = -1;
+	int last_prio = -1;
 
+	/* PID */
 	traceeval_iterator_sort(iter, thread_keys[0].name, 0, true);
-	traceeval_iterator_sort(iter, thread_keys[1].name, 1, true);
+
+	/* PRIO */
+	traceeval_iterator_sort(iter, thread_keys[2].name, 1, true);
+
+	/* STATE */
+	traceeval_iterator_sort(iter, thread_keys[1].name, 2, true);
 
 	while (traceeval_iterator_next(iter, &keys) > 0) {
-		int state = keys[1].number;
 		int tid = keys[0].number;
+		int state = keys[1].number;
+		int prio = keys[2].number;
 
 		stat = traceeval_iterator_stat(iter, DELTA_NAME);
 		if (!stat)
 			continue; // die?
 
-		if (last_tid != keys[0].number)
-			printf("\n    thread id: %d\n", tid);
+		if (last_tid != tid || last_prio != prio) {
+			if (prio < 120)
+				printf("\n    thread id: %d [ prio: %d ]\n", tid, prio);
+			else
+				printf("\n    thread id: %d\n", tid);
+		}
 
 		last_tid = tid;
+		last_prio = prio;
 
 		display_state_times(state, traceeval_stat_total(stat));
 	}
@@ -888,6 +933,7 @@ static void finish_leftovers(struct task_data *data)
 	unsigned long long delta;
 	enum sched_state state;
 	const char *comm;
+	int prio;
 	int pid;
 
 	iter = traceeval_iterator_delta_start_get(data->teval_tasks);
@@ -899,8 +945,9 @@ static void finish_leftovers(struct task_data *data)
 
 		state = results[0].number;
 		comm = results[1].cstring;
+		prio = results[2].number;
 
-		update_thread(data, pid, comm, state, delta, data->last_ts);
+		update_thread(data, pid, comm, state, prio, delta, data->last_ts);
 	}
 	traceeval_iterator_put(iter);
 
-- 
2.42.0

