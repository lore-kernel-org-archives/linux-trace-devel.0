Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A1A3C39
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EE1C433C9;
	Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qqPrt-007ZSl-1k;
	Tue, 10 Oct 2023 23:26:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 02/11] libtraceeval task-eval: Use "assign_*keys/vals()" helper functions
Date: Tue, 10 Oct 2023 23:25:18 -0400
Message-ID: <20231011032640.1804571-3-rostedt@goodmis.org>
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

Assigning the keys and values at each location for the traceevals has
become error prone, and a lot of cut and pasting. Instead, create helper
functions to do this instead, and it simplifies the code as well as making
it less error prone.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 122 +++++++++++++++++++++++++++++++-------------
 1 file changed, 86 insertions(+), 36 deletions(-)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index 3d748d16ee57..11ea73ce8da0 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -90,6 +90,11 @@ static struct traceeval_type cpu_delta_keys[] = {
 	},
 };
 
+static void assign_cpu_delta_keys(struct traceeval_data keys[1], int cpu)
+{
+	TRACEEVAL_SET_NUMBER(keys[0], cpu);
+}
+
 static struct traceeval_type cpu_delta_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -97,6 +102,11 @@ static struct traceeval_type cpu_delta_vals[] = {
 	},
 };
 
+static void assign_cpu_delta_vals(struct traceeval_data vals[1], int state)
+{
+	TRACEEVAL_SET_NUMBER(vals[0], state);
+}
+
 static struct traceeval_type cpu_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -108,6 +118,12 @@ static struct traceeval_type cpu_keys[] = {
 	},
 };
 
+static void assign_cpu_keys(struct traceeval_data keys[2], int cpu, int state)
+{
+	TRACEEVAL_SET_NUMBER(keys[0], cpu);
+	TRACEEVAL_SET_NUMBER(keys[1], state);
+}
+
 static struct traceeval_type cpu_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_DELTA,
@@ -115,6 +131,13 @@ static struct traceeval_type cpu_vals[] = {
 	},
 };
 
+static void assign_cpu_vals(struct traceeval_data vals[1],
+			    unsigned long long delta,
+			    unsigned long long timestamp)
+{
+	TRACEEVAL_SET_DELTA(vals[0], delta, timestamp);
+}
+
 static struct traceeval_type task_delta_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -122,6 +145,11 @@ static struct traceeval_type task_delta_keys[] = {
 	},
 };
 
+static void assign_task_delta_keys(struct traceeval_data keys[1], int pid)
+{
+	TRACEEVAL_SET_NUMBER(keys[0], pid);
+}
+
 static struct traceeval_type task_delta_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -133,6 +161,13 @@ static struct traceeval_type task_delta_vals[] = {
 	},
 };
 
+static void assign_task_delta_vals(struct traceeval_data vals[2],
+				   int state, const char *comm)
+{
+	TRACEEVAL_SET_NUMBER(vals[0], state);
+	TRACEEVAL_SET_CSTRING(vals[1], comm);
+}
+
 static struct traceeval_type task_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_STRING,
@@ -144,6 +179,13 @@ static struct traceeval_type task_keys[] = {
 	},
 };
 
+static void assign_task_keys(struct traceeval_data keys[2],
+			     const char *comm, int state)
+{
+	TRACEEVAL_SET_CSTRING(keys[0], comm);
+	TRACEEVAL_SET_NUMBER(keys[1], state);
+}
+
 static struct traceeval_type task_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_POINTER,
@@ -155,6 +197,14 @@ static struct traceeval_type task_vals[] = {
 	},
 };
 
+static void assign_task_vals(struct traceeval_data vals[2],
+			     void *data, unsigned long long delta,
+			     unsigned long long timestamp)
+{
+	TRACEEVAL_SET_POINTER(vals[0], data);
+	TRACEEVAL_SET_DELTA(vals[1], delta, timestamp);
+}
+
 static struct traceeval_type thread_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -166,6 +216,13 @@ static struct traceeval_type thread_keys[] = {
 	},
 };
 
+static void assign_thread_keys(struct traceeval_data keys[2],
+				int tid, int state)
+{
+	TRACEEVAL_SET_NUMBER(keys[0], tid);
+	TRACEEVAL_SET_NUMBER(keys[1], state);
+}
+
 static struct traceeval_type thread_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_DELTA,
@@ -173,6 +230,13 @@ static struct traceeval_type thread_vals[] = {
 	},
 };
 
+static void assign_thread_vals(struct traceeval_data vals[1],
+			       unsigned long long delta,
+			       unsigned long long timestamp)
+{
+	TRACEEVAL_SET_DELTA(vals[0], delta, timestamp);
+}
+
 enum sched_state {
 	RUNNING,
 	BLOCKED,
@@ -226,8 +290,7 @@ void set_process_data(struct task_data *tdata, const char *comm, void *data)
 	if (ret < 0)
 		pdie("Could not query process data");
 
-	TRACEEVAL_SET_POINTER(new_vals[0], data);
-	TRACEEVAL_SET_DELTA(new_vals[1], 0, 0);
+	assign_task_vals(new_vals, data, 0, 0);
 
 	ret = traceeval_insert(tdata->teval_tasks, keys, new_vals);
 	if (ret < 0)
@@ -278,10 +341,8 @@ static void update_cpu_data(struct task_data *tdata, int cpu, int state,
 	struct traceeval_data cpu_keys[2];
 	struct traceeval_data vals[1];
 
-	TRACEEVAL_SET_NUMBER(cpu_keys[0], cpu);
-	TRACEEVAL_SET_NUMBER(cpu_keys[1], state);
-
-	TRACEEVAL_SET_DELTA(vals[0], delta, ts);
+	assign_cpu_keys(cpu_keys, cpu, state);
+	assign_cpu_vals(vals, delta, ts);
 
 	traceeval_insert(tdata->teval_cpus, cpu_keys, vals);
 }
@@ -296,7 +357,7 @@ static void update_cpu_to_idle(struct task_data *tdata, struct tep_record *recor
 	int ret;
 
 	/* Finish previous run */
-	TRACEEVAL_SET_NUMBER(delta_keys[0], record->cpu);
+	assign_cpu_delta_keys(delta_keys, record->cpu);
 
 	ret = traceeval_delta_stop(tdata->teval_cpus, delta_keys, &results,
 				   record->ts, &delta, NULL);
@@ -308,7 +369,7 @@ static void update_cpu_to_idle(struct task_data *tdata, struct tep_record *recor
 	}
 
 	/* Start the next state */
-	TRACEEVAL_SET_NUMBER(vals[0], IDLE);
+	assign_cpu_delta_vals(vals, IDLE);
 	traceeval_delta_start(tdata->teval_cpus, delta_keys, vals,
 			      record->ts);
 }
@@ -322,9 +383,7 @@ static void update_cpu_to_running(struct task_data *tdata, struct tep_record *re
 	unsigned long long delta;
 	int ret;
 
-	/* Initialize the delta and cpu keys to point to this CPU */
-	TRACEEVAL_SET_NUMBER(delta_keys[0], record->cpu);
-	TRACEEVAL_SET_NUMBER(cpu_keys[0], record->cpu);
+	assign_cpu_delta_keys(delta_keys, record->cpu);
 
 	/* Test if the CPU was idle */
 	ret = traceeval_delta_query(tdata->teval_cpus, delta_keys, &results);
@@ -333,13 +392,13 @@ static void update_cpu_to_running(struct task_data *tdata, struct tep_record *re
 		traceeval_delta_stop(tdata->teval_cpus, delta_keys, NULL,
 				     record->ts, &delta, NULL);
 		/* Update the idle teval */
-		TRACEEVAL_SET_NUMBER(cpu_keys[1], IDLE);
-		TRACEEVAL_SET_DELTA(vals[0], delta, record->ts);
+		assign_cpu_keys(cpu_keys, record->cpu, IDLE);
+		assign_cpu_vals(vals, delta, record->ts);
 		traceeval_insert(tdata->teval_cpus, cpu_keys, vals);
 	}
 
 	/* Continue with the CPU running */
-	TRACEEVAL_SET_NUMBER(vals[0], RUNNING);
+	assign_cpu_delta_vals(vals, RUNNING);
 	traceeval_delta_continue(tdata->teval_cpus, delta_keys, vals,
 				 record->ts);
 }
@@ -355,18 +414,14 @@ static void update_thread(struct task_data *tdata, int pid, const char *comm,
 
 		pdata = get_process_data(tdata, comm);
 
-		TRACEEVAL_SET_NUMBER(keys[0], pid);
-		TRACEEVAL_SET_NUMBER(keys[1], state);
-
-		TRACEEVAL_SET_DELTA(vals[0], delta, ts);
+		assign_thread_keys(keys, pid, state);
+		assign_thread_vals(vals, delta, ts);
 
 		traceeval_insert(pdata->teval_threads, keys, vals);
 
 		/* Also update the process */
-		TRACEEVAL_SET_CSTRING(keys[0], comm);
-
-		TRACEEVAL_SET_POINTER(pvals[0], pdata);
-		TRACEEVAL_SET_DELTA(pvals[1], delta, ts);
+		assign_task_keys(keys, comm, state);
+		assign_task_vals(pvals, pdata, delta, ts);
 
 		traceeval_insert(tdata->teval_tasks, keys, pvals);
 }
@@ -382,7 +437,7 @@ static void start_running_thread(struct task_data *tdata,
 	unsigned long long val;
 	int ret;
 
-	TRACEEVAL_SET_NUMBER(delta_keys[0], pid);
+	assign_task_delta_keys(delta_keys, pid);
 
 	/* Find the previous stop state of this task */
 	ret = traceeval_delta_stop(tdata->teval_tasks, delta_keys,
@@ -396,8 +451,7 @@ static void start_running_thread(struct task_data *tdata,
 		traceeval_results_release(tdata->teval_tasks, results);
 	}
 
-	TRACEEVAL_SET_NUMBER(vals[0], RUNNING);
-	TRACEEVAL_SET_CSTRING(vals[1], comm);
+	assign_task_delta_vals(vals, RUNNING, comm);
 
 	traceeval_delta_start(tdata->teval_tasks, delta_keys, vals, record->ts);
 }
@@ -443,13 +497,12 @@ static void sched_out(struct task_data *tdata, const char *comm,
 		die("Could not read sched_switch next_pid for record");
 	state = get_stop_state(val);
 
-	TRACEEVAL_SET_NUMBER(delta_keys[0], pid);
+	assign_task_delta_keys(delta_keys, pid);
 
 	ret = traceeval_delta_stop(tdata->teval_tasks, delta_keys, &results,
 				   record->ts, &delta, &val);
 
-	TRACEEVAL_SET_NUMBER(task_vals[0], state);
-	TRACEEVAL_SET_CSTRING(task_vals[1], comm);
+	assign_task_delta_vals(task_vals, state, comm);
 
 	if (ret > 0)
 		old_state = results[0].number;
@@ -463,23 +516,20 @@ static void sched_out(struct task_data *tdata, const char *comm,
 		die("Not running %d from %lld to %lld",
 		    old_state, val, record->ts);
 
-	TRACEEVAL_SET_CSTRING(task_keys[0], comm);
-	TRACEEVAL_SET_NUMBER(task_keys[1], RUNNING);
+	assign_task_keys(task_keys, comm, RUNNING);
 
 	pdata = get_process_data(tdata, comm);
 
-	TRACEEVAL_SET_POINTER(task_vals[0], pdata);
-	TRACEEVAL_SET_DELTA(task_vals[1], delta, record->ts);
+	assign_task_vals(task_vals, pdata, delta, record->ts);
 
 	traceeval_insert(tdata->teval_tasks, task_keys, task_vals);
 
-	TRACEEVAL_SET_NUMBER(task_keys[0], pid);
-
-	TRACEEVAL_SET_DELTA(vals[0], delta, record->ts);
+	assign_thread_keys(task_keys, pid, RUNNING);
+	assign_thread_vals(vals, delta, record->ts);
 
 	traceeval_insert(pdata->teval_threads, task_keys, vals);
 
-	TRACEEVAL_SET_NUMBER(task_keys[0], record->cpu);
+	assign_cpu_keys(task_keys, record->cpu, RUNNING);
 
 	traceeval_insert(pdata->teval_cpus, task_keys, vals);
 }
-- 
2.42.0

