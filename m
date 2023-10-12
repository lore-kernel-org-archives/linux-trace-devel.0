Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B1C362
	for <linux-trace-devel@vger.kernel.org>; Thu, 12 Oct 2023 02:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDB1C433C9;
	Thu, 12 Oct 2023 02:36:50 +0000 (UTC)
Date: Wed, 11 Oct 2023 22:38:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>, Stevie Alvarez 
 <stevie.6strings@gmail.com>
Subject: [PATCH] libtraceeval: Simplify and correct man page example code
Message-ID: <20231011223814.1fada6a1@gandalf.local.home>
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

I pulled out each of the man page examples and compiled them as well as
ran them under valgrind and such. I restructured them to be a bit simpler
as well.

Also, I removed code examples that use STAT and TIMESTAMP flags. I'm
thinking of removing them (at least reserving them) and keeping them out
of the API before release. That's because the TRACEEVAL_TYPE_DELTA appears
to be all that is needed (for now).

Note, these flags are still explained. If I do remove them, the commit that
removes them will then remove the comments about them in the man pages.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceeval-insert.txt   |  25 +-
 Documentation/libtraceeval-iterator.txt | 585 +++++++++++-------------
 Documentation/libtraceeval-stat.txt     |  91 ++--
 3 files changed, 316 insertions(+), 385 deletions(-)

diff --git a/Documentation/libtraceeval-insert.txt b/Documentation/libtraceeval-insert.txt
index 138c3d2fd0b8..ce8048b418da 100644
--- a/Documentation/libtraceeval-insert.txt
+++ b/Documentation/libtraceeval-insert.txt
@@ -157,6 +157,8 @@ EXAMPLE
 #include <tracefs.h>
 #include <traceeval.h>
 
+#define DELTA_NAME "delta"
+
 struct data {
 	struct traceeval		*teval_wakeup;
 	struct traceeval		*teval_sched;
@@ -172,7 +174,6 @@ struct traceeval_type wakeup_keys[] = {
 struct traceeval_type wakeup_vals[] = {
 	{
 		.name		= "timestamp",
-		.flags		= TRACEEVAL_FL_TIMESTAMP,
 		.type		= TRACEEVAL_TYPE_NUMBER_64,
 	}
 };
@@ -190,14 +191,8 @@ struct traceeval_type sched_keys[] = {
 
 struct traceeval_type sched_vals[] = {
 	{
-		.name		= "timestamp",
-		.flags		= TRACEEVAL_FL_TIMESTAMP,
-		.type		= TRACEEVAL_TYPE_NUMBER_64,
-	},
-	{
-		.name		= "delta",
-		.flags		= TRACEEVAL_FL_STAT,
-		.type		= TRACEEVAL_TYPE_NUMBER_64,
+		.name		= DELTA_NAME,
+		.type		= TRACEEVAL_TYPE_DELTA,
 	}
 };
 
@@ -234,7 +229,7 @@ static int sched_callback(struct tep_event *event, struct tep_record *record, in
 	long pid;
 	struct traceeval_data wakeup_keys[1];
 	struct traceeval_data keys[2];
-	struct traceeval_data vals[2];
+	struct traceeval_data vals[1];
 	const struct traceeval_data *results;
 
 	if (!next_pid_field) {
@@ -253,11 +248,10 @@ static int sched_callback(struct tep_event *event, struct tep_record *record, in
 	delta = record->ts - results[0].number_64;
 	traceeval_results_release(data->teval_wakeup, results);
 
-	TRACEEVAL_SET_CSTRING(keys[0], record->data + next_comm_field->offset);
+	TRACEEVAL_SET_CSTRING(keys[0], (char *)record->data + next_comm_field->offset);
 	TRACEEVAL_SET_NUMBER(keys[1], pid);
 
-	TRACEEVAL_SET_NUMBER_64(vals[0], record->ts);
-	TRACEEVAL_SET_NUMBER_64(vals[1], delta);
+	TRACEEVAL_SET_DELTA(vals[0], delta, record->ts);
 
 	traceeval_insert(data->teval_sched, keys, vals);
 
@@ -292,7 +286,7 @@ static void show_latency(struct data *data)
 	while (traceeval_iterator_next(iter, &keys) > 0) {
 		struct traceeval_stat *stat;
 
-		stat = traceeval_iterator_stat(iter, sched_vals[1].name);
+		stat = traceeval_iterator_stat(iter, DELTA_NAME);
 		if (!stat)
 			continue;
 
@@ -356,6 +350,9 @@ int main (int argc, char **argv)
 
 	show_latency(&data);
 
+	traceeval_release(data.teval_wakeup);
+	traceeval_release(data.teval_sched);
+
 	return 0;
 }
 --
diff --git a/Documentation/libtraceeval-iterator.txt b/Documentation/libtraceeval-iterator.txt
index 9c03b5855749..d095e37fb1ec 100644
--- a/Documentation/libtraceeval-iterator.txt
+++ b/Documentation/libtraceeval-iterator.txt
@@ -132,6 +132,15 @@ and idle.
 #include <trace-cmd.h>
 #include <traceeval.h>
 
+enum sched_state {
+	RUNNING,
+	BLOCKED,
+	PREEMPT,
+	SLEEP,
+	IDLE,
+	OTHER
+};
+
 static struct traceeval_type cpu_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -143,7 +152,56 @@ static struct traceeval_type cpu_keys[] = {
 	},
 };
 
-static struct traceeval_type process_keys[] = {
+static void add_cpu_data(struct traceeval *teval, int cpu, int state,
+			 unsigned long long delta, unsigned long long ts)
+{
+	struct traceeval_data keys[2];
+	struct traceeval_data vals[1];
+
+	TRACEEVAL_SET_NUMBER(keys[0], cpu);
+	TRACEEVAL_SET_NUMBER(keys[1], state);
+
+	TRACEEVAL_SET_DELTA(vals[0], delta, ts);
+
+	traceeval_insert(teval, keys, vals);
+}
+
+static struct traceeval_type cpu_delta_keys[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "CPU",
+	},
+};
+
+static void start_cpu_data(struct traceeval *teval, int cpu, unsigned long long ts)
+{
+	struct traceeval_data keys[1];
+
+	TRACEEVAL_SET_NUMBER(keys[0], cpu);
+
+	traceeval_delta_start(teval, keys, NULL, ts);
+}
+
+static void continue_cpu_data(struct traceeval *teval, int cpu, unsigned long long ts)
+{
+	struct traceeval_data keys[1];
+
+	TRACEEVAL_SET_NUMBER(keys[0], cpu);
+
+	traceeval_delta_continue(teval, keys, NULL, ts);
+}
+
+static int stop_cpu_data(struct traceeval *teval, int cpu, unsigned long long ts,
+			 unsigned long long *delta)
+{
+	struct traceeval_data keys[1];
+
+	TRACEEVAL_SET_NUMBER(keys[0], cpu);
+
+	return traceeval_delta_stop(teval, keys, NULL, ts, delta, NULL);
+}
+
+static struct traceeval_type task_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_STRING,
 		.name = "COMM"
@@ -154,122 +212,160 @@ static struct traceeval_type process_keys[] = {
 	},
 };
 
-static struct traceeval_type process_data_vals[] = {
+static void release_pdata(const struct traceeval_type *type,
+			  struct traceeval_data *data);
+
+static int copy_pdata(const struct traceeval_type *type,
+		     struct traceeval_data *dst,
+		     const struct traceeval_data *src)
+{
+	/* This prevents the release function getting called */
+	*dst = *src;
+	return 0;
+}
+
+static struct traceeval_type task_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_POINTER,
 		.name = "data",
+		.copy = copy_pdata,
+		.release = release_pdata,
+	},
+	{
+		.type = TRACEEVAL_TYPE_DELTA,
+		.name = "delta",
 	},
 };
 
-static struct traceeval_type thread_keys[] = {
+static void add_task_data(struct traceeval *teval, const char *comm,
+			  int state, void *pdata,
+			  unsigned long long delta, unsigned long long ts)
+{
+	struct traceeval_data keys[2];
+	struct traceeval_data vals[2];
+
+	TRACEEVAL_SET_CSTRING(keys[0], comm);
+	TRACEEVAL_SET_NUMBER(keys[1], state);
+
+	/* Only save pdata for the running event (no duplicates) */
+	if (state != RUNNING)
+		pdata = NULL;
+
+	TRACEEVAL_SET_POINTER(vals[0], pdata);
+	TRACEEVAL_SET_DELTA(vals[1], delta, ts);
+
+	traceeval_insert(teval, keys, vals);
+}
+
+static struct traceeval_type task_delta_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "TID",
+		.name = "PID"
 	},
+};
+
+static struct traceeval_type task_delta_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "Schedule state",
+		.name = "Schedule state"
 	},
 };
 
-static struct traceeval_type timestamp_vals[] = {
+static void start_task_data(struct traceeval *teval, int pid,
+			    int state, unsigned long long ts)
+{
+	struct traceeval_data keys[1];
+	struct traceeval_data vals[1];
+
+	TRACEEVAL_SET_NUMBER(keys[0], pid);
+
+	TRACEEVAL_SET_NUMBER(vals[0], state);
+
+	traceeval_delta_start(teval, keys, vals, ts);
+}
+
+static int stop_task_data(struct traceeval *teval, int pid, unsigned long long ts,
+			 unsigned long long *delta, int *state)
+{
+	struct traceeval_data keys[1];
+	const struct traceeval_data *results;
+	int ret;
+
+	TRACEEVAL_SET_NUMBER(keys[0], pid);
+
+	ret = traceeval_delta_stop(teval, keys, &results, ts, delta, NULL);
+	if (ret < 1)
+		return ret;
+
+	if (state)
+		*state = results[0].number;
+
+	traceeval_results_release(teval, results);
+
+	return ret;
+}
+
+static struct traceeval_type thread_keys[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "TID",
+	},
 	{
-		.type = TRACEEVAL_TYPE_NUMBER_64,
-		.name = "Timestamp",
-		.flags = TRACEEVAL_FL_TIMESTAMP,
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "Schedule state",
 	},
 };
 
 static struct traceeval_type delta_vals[] = {
 	{
-		.type	= TRACEEVAL_TYPE_NUMBER_64,
+		.type	= TRACEEVAL_TYPE_DELTA,
 		.name	= "delta",
-		.flags = TRACEEVAL_FL_STAT,
 	},
 };
 
-enum sched_state {
-	RUNNING,
-	BLOCKED,
-	PREEMPT,
-	SLEEP,
-	IDLE,
-	OTHER
-};
+static void add_thread_data(struct traceeval *teval, int pid, int state,
+			    unsigned long long delta, unsigned long long ts)
+{
+	struct traceeval_data keys[2];
+	struct traceeval_data vals[1];
 
-struct teval_pair {
-	struct traceeval	*start;
-	struct traceeval	*stop;
-};
+	TRACEEVAL_SET_NUMBER(keys[0], pid);
+	TRACEEVAL_SET_NUMBER(keys[1], state);
+
+	TRACEEVAL_SET_DELTA(vals[0], delta, ts);
+
+	traceeval_insert(teval, keys, vals);
+}
 
 struct process_data {
-	struct teval_pair	teval_cpus;
-	struct teval_pair	teval_threads;
-	char			*comm;
-	int			state;
+	struct traceeval	*teval_cpus;
+	struct traceeval	*teval_threads;
 };
 
 struct task_data {
-	struct teval_pair	teval_cpus;
-	struct teval_pair	teval_processes;
-	struct traceeval	*teval_processes_data;
-	char			*comm;
-};
-
-enum command {
-	START,
-	STOP
+	struct traceeval	*teval_cpus;
+	struct traceeval	*teval_tasks;
+	const char		*comm;
 };
 
-static void update_process(struct task_data *tdata, const char *comm,
-			   enum sched_state state, enum command cmd,
-			   unsigned long long ts)
+static void init_process_data(struct process_data *pdata)
 {
-	struct traceeval_data keys[] = {
-		DEFINE_TRACEEVAL_CSTRING(	comm	),
-		DEFINE_TRACEEVAL_NUMBER(	state	),
-	};
-	struct traceeval_data vals[] = {
-		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
-	};
-	struct traceeval_data new_vals[1] = { };
-	const struct traceeval_data *results;
-	int ret;
-
-	switch (cmd) {
-	case START:
-		ret = traceeval_insert(tdata->teval_processes.start, keys, vals);
-		return;
-	case STOP:
-		ret = traceeval_query(tdata->teval_processes.start, keys, &results);
-		if (ret == 0)
-			return;
-		if (!results[0].number_64)
-			break;
-
-		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
 
-		ret = traceeval_insert(tdata->teval_processes.stop, keys, new_vals);
+	pdata->teval_cpus = traceeval_init(cpu_keys, delta_vals);
+	traceeval_delta_create(pdata->teval_cpus, cpu_delta_keys, NULL);
 
-		/* Reset the start */
-		TRACEEVAL_SET_NUMBER_64(new_vals[0], 0);
-
-		ret = traceeval_insert(tdata->teval_processes.start, keys, new_vals);
-		break;
-	}
-	traceeval_results_release(tdata->teval_processes.start, results);
+	pdata->teval_threads = traceeval_init(thread_keys, delta_vals);
 }
 
-static void start_process(struct task_data *tdata, const char *comm,
-			   enum sched_state state, unsigned long long ts)
+static struct process_data *alloc_pdata(struct task_data *tdata, const char *comm)
 {
-	update_process(tdata, comm, state, START, ts);
-}
+	struct process_data *pdata;
 
-static void stop_process(struct task_data *tdata, const char *comm,
-			   enum sched_state state, unsigned long long ts)
-{
-	update_process(tdata, comm, state, STOP, ts);
+	pdata = calloc(1, sizeof(*pdata));
+	init_process_data(pdata);
+	add_task_data(tdata->teval_tasks, comm, RUNNING, pdata, 0, 0);
+
+	return pdata;
 }
 
 static struct process_data *
@@ -283,174 +379,24 @@ get_process_data(struct task_data *tdata, const char *comm)
 	void *data;
 	int ret;
 
-	ret = traceeval_query(tdata->teval_processes_data, keys, &results);
+	ret = traceeval_query(tdata->teval_tasks, keys, &results);
 	if (ret == 0)
-		return NULL;
+		return alloc_pdata(tdata, comm);
 
 	data = results[0].pointer;
-	traceeval_results_release(tdata->teval_processes_data, results);
+	traceeval_results_release(tdata->teval_tasks, results);
 	return data;
 }
 
-void set_process_data(struct task_data *tdata, const char *comm, void *data)
+static enum sched_state get_state(unsigned long long val)
 {
-	struct traceeval_data keys[] = {
-		DEFINE_TRACEEVAL_CSTRING(	comm	),
-		DEFINE_TRACEEVAL_NUMBER(	RUNNING	),
-	};
-	struct traceeval_data new_vals[1] = { };
-	const struct traceeval_data *results;
-	int ret;
-
-	ret = traceeval_query(tdata->teval_processes_data, keys, &results);
-	if (ret > 0)
-		goto out; /* It already exists ? */
-
-	TRACEEVAL_SET_POINTER(new_vals[0], data);
-	ret = traceeval_insert(tdata->teval_processes_data, keys, new_vals);
-
- out:
-	traceeval_results_release(tdata->teval_processes_data, results);
-}
-
-static void update_cpu(struct teval_pair *teval_pair, int cpu,
-		       enum sched_state state, enum command cmd,
-		       unsigned long long ts)
-{
-	const struct traceeval_data *results;
-	struct traceeval_data keys[] = {
-		DEFINE_TRACEEVAL_NUMBER(	cpu	),
-		DEFINE_TRACEEVAL_NUMBER(	state	),
-	};
-	struct traceeval_data vals[] = {
-		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
-	};
-	struct traceeval_data new_vals[1] = { };
-	int ret;
-
-	switch (cmd) {
-	case START:
-		/* Only set if the timestamp is zero (or doesn't exist) */
-		ret = traceeval_query(teval_pair->start, keys, &results);
-		if (ret > 0) {
-			if (results[0].number_64)
-				break;
-		}
-		ret = traceeval_insert(teval_pair->start, keys, vals);
-		break;
-	case STOP:
-		ret = traceeval_query(teval_pair->start, keys, &results);
-		if (ret == 0)
-			return;
-
-		if (!results[0].number_64)
-			break;
-
-		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
-
-		ret = traceeval_insert(teval_pair->stop, keys, new_vals);
-
-		/* Reset the start */
-		TRACEEVAL_SET_NUMBER_64(new_vals[0], 0);
-		ret = traceeval_insert(teval_pair->start, keys, new_vals);
-
-		break;
-		default:
-			return;
-	}
-	traceeval_results_release(teval_pair->start, results);
-}
-
-static void start_cpu(struct teval_pair *teval_pair, int cpu,
-		      enum sched_state state,  unsigned long long ts)
-{
-	update_cpu(teval_pair, cpu, state, START, ts);
-}
-
-static void stop_cpu(struct teval_pair *teval_pair, int cpu,
-		     enum sched_state state, unsigned long long ts)
-{
-	update_cpu(teval_pair, cpu, state, STOP, ts);
-}
-
-static void update_thread(struct process_data *pdata, int tid,
-			  enum sched_state state, enum command cmd,
-			  unsigned long long ts)
-{
-	const struct traceeval_data *results;
-	struct traceeval_data keys[] = {
-		DEFINE_TRACEEVAL_NUMBER(	tid	),
-		DEFINE_TRACEEVAL_NUMBER(	state	),
-	};
-	struct traceeval_data vals[] = {
-		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
-	};
-	struct traceeval_data new_vals[1] = { };
-	int ret;
-
-	switch (cmd) {
-	case START:
-		ret = traceeval_insert(pdata->teval_threads.start, keys, vals);
-		return;
-	case STOP:
-		ret = traceeval_query(pdata->teval_threads.start, keys, &results);
-		if (ret == 0)
-			return;
-
-		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
-
-		ret = traceeval_insert(pdata->teval_threads.stop, keys, new_vals);
-		traceeval_results_release(pdata->teval_threads.start, results);
-		return;
-	}
-}
-
-static void start_thread(struct process_data *pdata, int tid,
-			   enum sched_state state, unsigned long long ts)
-{
-	update_thread(pdata, tid, state, START, ts);
-}
-
-static void stop_thread(struct process_data *pdata, int tid,
-			enum sched_state state, unsigned long long ts)
-{
-	update_thread(pdata, tid, state, STOP, ts);
-}
-
-static struct tep_format_field *get_field(struct tep_event *event, const char *name)
-{
-	static struct tep_format_field *field;
-
-	field = tep_find_field(event, name);
-	if (!field) {
-		fprintf(stderr, "Could not find field %s for %s",
-			name, event->name);
-		exit(-1);
-	}
-
-	return field;
-}
-
-static void init_process_data(struct process_data *pdata)
-{
-
-	pdata->teval_cpus.start = traceeval_init(cpu_keys, timestamp_vals);
-	pdata->teval_cpus.stop = traceeval_init(cpu_keys, delta_vals);
-
-	pdata->teval_threads.start = traceeval_init(thread_keys, timestamp_vals);
-
-	pdata->teval_threads.stop = traceeval_init(thread_keys, delta_vals);
-}
-
-static struct process_data *alloc_pdata(struct task_data *tdata, const char *comm)
-{
-	struct process_data *pdata;
-
-	pdata = calloc(1, sizeof(*pdata));
-	init_process_data(pdata);
-	set_process_data(tdata, comm, pdata);
-
-	return pdata;
+	if (val & 1)
+		return SLEEP;
+	if (val & 2)
+		return BLOCKED;
+	if (val & 0xfff)
+		return OTHER;
+	return PREEMPT;
 }
 
 static void sched_out(struct task_data *tdata, const char *comm,
@@ -459,54 +405,41 @@ static void sched_out(struct task_data *tdata, const char *comm,
 		      struct tep_format_field *prev_state)
 {
 	struct process_data *pdata;
+	unsigned long long delta;
 	unsigned long long val;
+	int state;
 	int pid;
+	int ret;
 
 	tep_read_number_field(prev_pid, record->data, &val);
 
 	/* Ignore the idle task */
 	pid = val;
 	if (!pid) {
-		/* Record the runtime for the process CPUs */
-		stop_cpu(&tdata->teval_cpus, record->cpu, IDLE, record->ts);
+		/* Coming from idle */
+		ret = stop_cpu_data(tdata->teval_cpus, record->cpu, record->ts, &delta);
+		if (ret > 0)
+			add_cpu_data(tdata->teval_cpus, record->cpu, IDLE, delta,
+				     record->ts);
 		return;
 	}
 
-	/* The process is scheduling out. Stop the run time. */
-	update_process(tdata, comm, RUNNING, STOP, record->ts);
-
-	/* Get the process data from the process running state */
+	/* Get the process data for this task */
 	pdata = get_process_data(tdata, comm);
-	if (!pdata)
-		pdata = alloc_pdata(tdata, comm);
+
+	ret = stop_task_data(tdata->teval_tasks, pid, record->ts, &delta, NULL);
+
+	if (ret > 0) {
+		/* Record the running state */
+		add_task_data(tdata->teval_tasks, comm, RUNNING, pdata, delta, record->ts);
+		add_thread_data(pdata->teval_threads, pid, RUNNING, delta, record->ts);
+	}
 
 	tep_read_number_field(prev_state, record->data, &val);
-	val &= 3;
-	/*
-	 * Save the state the process is exiting with. Will need this
-	 * when scheduled back in.
-	 */
-	if (!val)
-		pdata->state = PREEMPT;
-	else if (val & 1)
-		pdata->state = SLEEP;
-	else if (val & 2)
-		pdata->state = BLOCKED;
-
-	/* Record the state timings for the process */
-	start_process(tdata, comm, pdata->state, record->ts);
-
-	/* Record the state timings for the individual thread */
-	stop_thread(pdata, pid, RUNNING, record->ts);
-
-	/* Record the state timings for the individual thread */
-	start_thread(pdata, pid, pdata->state, record->ts);
-
-	/* Record the runtime for the process CPUs */
-	stop_cpu(&pdata->teval_cpus, record->cpu, RUNNING, record->ts);
-
-	/* Record the runtime for the all CPUs */
-	stop_cpu(&tdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	state = get_state(val);
+
+	/* Start the off-cpu time and record the state */
+	start_task_data(tdata->teval_tasks, pid, state, record->ts);
 }
 
 static void sched_in(struct task_data *tdata, const char *comm,
@@ -514,49 +447,58 @@ static void sched_in(struct task_data *tdata, const char *comm,
 		     struct tep_record *record, struct tep_format_field *next_pid)
 {
 	struct process_data *pdata;
+	unsigned long long delta;
 	unsigned long long val;
-	bool is_new = false;
+	int state;
 	int pid;
+	int ret;
 
 	tep_read_number_field(next_pid, record->data, &val);
 	pid = val;
 
 	/* Ignore the idle task */
 	if (!pid) {
-		/* Record the runtime for the process CPUs */
-		start_cpu(&tdata->teval_cpus, record->cpu, IDLE, record->ts);
+
+		/* Going to idle, get the time the CPU was running */
+		ret = stop_cpu_data(tdata->teval_cpus, record->cpu, record->ts, &delta);
+		if (ret > 0)
+			add_cpu_data(tdata->teval_cpus, record->cpu, RUNNING,
+				     delta, record->ts);
+
+		/* Start recording the time the CPU is idle */
+		start_cpu_data(tdata->teval_cpus, record->cpu, record->ts);
 		return;
 	}
 
-	/* Start recording the running time of this process */
-	start_process(tdata, comm, RUNNING, record->ts);
+	/* Continue the CPU as running */
+	continue_cpu_data(tdata->teval_cpus, record->cpu, record->ts);
 
 	pdata = get_process_data(tdata, comm);
 
-	/* Start recording the running time of process CPUs */
-	start_cpu(&tdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	/* Record the time the task was off the CPU and why */
+	ret = stop_task_data(tdata->teval_tasks, pid, record->ts, &delta, &state);
 
-	/* If there was no pdata, then this process did not go through sched out */
-	if (!pdata) {
-		pdata = alloc_pdata(tdata, comm);
-		is_new = true;
+	if (ret > 0) {
+		add_task_data(tdata->teval_tasks, comm, state, pdata, delta, record->ts);
+		add_thread_data(pdata->teval_threads, pid, state, delta, record->ts);
 	}
 
-	/* Record the state timings for the individual thread */
-	start_thread(pdata, pid, RUNNING, record->ts);
-
-	/* Start recording the running time of process CPUs */
-	start_cpu(&pdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	/* Start recording the running of this task */
+	start_task_data(tdata->teval_tasks, pid, RUNNING, record->ts);
+}
 
-	/* If it was just created, there's nothing to stop */
-	if (is_new)
-		return;
+static struct tep_format_field *get_field(struct tep_event *event, const char *name)
+{
+	static struct tep_format_field *field;
 
-	/* Stop recording the thread time for its scheduled out state */
-	stop_thread(pdata, val, pdata->state, record->ts);
+	field = tep_find_field(event, name);
+	if (!field) {
+		fprintf(stderr, "Could not find field %s for %s",
+			name, event->name);
+		exit(-1);
+	}
 
-	/* Stop recording the process time for its scheduled out state */
-	stop_process(tdata, comm, pdata->state, record->ts);
+	return field;
 }
 
 static int switch_func(struct tracecmd_input *handle, struct tep_event *event,
@@ -747,8 +689,8 @@ static void display_threads(struct traceeval *teval)
 
 static void display_process(struct process_data *pdata)
 {
-	display_threads(pdata->teval_threads.stop);
-	display_cpus(pdata->teval_cpus.stop);
+	display_threads(pdata->teval_threads);
+	display_cpus(pdata->teval_cpus);
 	printf("\n");
 }
 
@@ -773,10 +715,9 @@ static void display_process_stats(struct traceeval *teval,
 	}
 }
 
-static void display_processes(struct traceeval *teval,
-			      struct traceeval *teval_data)
+static void display_processes(struct traceeval *teval)
 {
-	struct traceeval_iterator *iter = traceeval_iterator_get(teval_data);
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
 	const struct traceeval_data *keys;
 
 	traceeval_iterator_sort_custom(iter, compare_pdata, teval);
@@ -788,7 +729,7 @@ static void display_processes(struct traceeval *teval,
 
 		traceeval_iterator_query(iter, &results);
 		pdata = results[0].pointer;
-		traceeval_results_release(teval_data, results);
+		traceeval_results_release(teval, results);
 
 		if (!pdata)
 			continue;
@@ -804,17 +745,15 @@ static void display_processes(struct traceeval *teval,
 
 static void display(struct task_data *tdata)
 {
-	struct traceeval *teval = tdata->teval_cpus.stop;
+	struct traceeval *teval = tdata->teval_cpus;
 	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
 	const struct traceeval_data *keys;
 	struct traceeval_stat *stat;
 	unsigned long long total_time = 0;
 	unsigned long long idle_time = 0;
 
-	if (tdata->comm) {
-		return display_processes(tdata->teval_processes.stop,
-					 tdata->teval_processes_data);
-	}
+	if (tdata->comm)
+		return display_processes(tdata->teval_tasks);
 
 	printf("Total:\n");
 
@@ -843,14 +782,30 @@ static void display(struct task_data *tdata)
 	printf("  Total idle time (us):");
 	print_microseconds(16, idle_time);
 
-	display_cpus(tdata->teval_cpus.stop);
+	display_cpus(tdata->teval_cpus);
 
 	printf("\n");
-	display_processes(tdata->teval_processes.stop, tdata->teval_processes_data);
+	display_processes(tdata->teval_tasks);
+}
+
+static void release_pdata(const struct traceeval_type *type,
+			  struct traceeval_data *data)
+{
+	struct process_data *pdata;
+
+	if (!data || !data->pointer)
+		return;
+
+	pdata = data->pointer;
+	traceeval_release(pdata->teval_cpus);
+	traceeval_release(pdata->teval_threads);
+	free(pdata);
 }
 
 static void free_tdata(struct task_data *tdata)
 {
+	traceeval_release(tdata->teval_tasks);
+	traceeval_release(tdata->teval_cpus);
 }
 
 int main (int argc, char **argv)
@@ -858,6 +813,8 @@ int main (int argc, char **argv)
 	struct tracecmd_input *handle;
 	struct task_data data;
 
+	traceeval_set_log_level(TEVAL_WARN);
+
 	memset(&data, 0, sizeof(data));
 
 	if (argc < 2) {
@@ -871,13 +828,11 @@ int main (int argc, char **argv)
 		exit(-1);
 	}
 
-	data.teval_processes.start = traceeval_init(process_keys, timestamp_vals);
-	data.teval_processes_data = traceeval_init(process_keys, process_data_vals);
-	data.teval_processes.stop = traceeval_init(process_keys, delta_vals);
-
+	data.teval_tasks = traceeval_init(task_keys, task_vals);
+	traceeval_delta_create(data.teval_tasks, task_delta_keys, task_delta_vals);
 
-	data.teval_cpus.start = traceeval_init(cpu_keys, timestamp_vals);
-	data.teval_cpus.stop = traceeval_init(cpu_keys, delta_vals);
+	data.teval_cpus = traceeval_init(cpu_keys, delta_vals);
+	traceeval_delta_create(data.teval_cpus, cpu_delta_keys, NULL);
 
 	tracecmd_follow_event(handle, "sched", "sched_switch", switch_func, &data);
 
diff --git a/Documentation/libtraceeval-stat.txt b/Documentation/libtraceeval-stat.txt
index f44c94ad17f6..98861fe0273d 100644
--- a/Documentation/libtraceeval-stat.txt
+++ b/Documentation/libtraceeval-stat.txt
@@ -109,25 +109,7 @@ EXAMPLE
 #include <trace-cmd.h>
 #include <traceeval.h>
 
-struct data {
-	struct traceeval		*teval_wakeup;
-	struct traceeval		*teval_sched;
-};
-
-struct traceeval_type wakeup_keys[] = {
-	{
-		.name		= "PID",
-		.type		= TRACEEVAL_TYPE_NUMBER,
-	}
-};
-
-struct traceeval_type wakeup_vals[] = {
-	{
-		.name		= "timestamp",
-		.flags		= TRACEEVAL_FL_TIMESTAMP,
-		.type		= TRACEEVAL_TYPE_NUMBER_64,
-	}
-};
+#define DELTA_NAME "delta"
 
 struct traceeval_type sched_keys[] = {
 	{
@@ -142,26 +124,27 @@ struct traceeval_type sched_keys[] = {
 
 struct traceeval_type sched_vals[] = {
 	{
-		.name		= "timestamp",
-		.flags		= TRACEEVAL_FL_TIMESTAMP,
-		.type		= TRACEEVAL_TYPE_NUMBER_64,
-	},
+		.name		= DELTA_NAME,
+		.type		= TRACEEVAL_TYPE_DELTA,
+	}
+};
+
+struct traceeval_type delta_keys[] = {
 	{
-		.name		= "delta",
-		.flags		= TRACEEVAL_FL_STAT,
-		.type		= TRACEEVAL_TYPE_NUMBER_64,
+		.name		= "PID",
+		.type		= TRACEEVAL_TYPE_NUMBER,
 	}
 };
 
+
 static int wakeup_callback(struct tracecmd_input *handle, struct tep_event *event,
-			   struct tep_record *record, int cpu, void *d)
+			   struct tep_record *record, int cpu, void *data)
 {
 	static struct tep_format_field *pid_field;
-	struct data *data = d;
+	struct traceeval_data keys[1];
+	struct traceeval *teval = data;
 	unsigned long long val;
 	long pid;
-	struct traceeval_data keys[1];
-	struct traceeval_data vals[1];
 
 	if (!pid_field)
 		pid_field = tep_find_field(event, "pid");
@@ -170,26 +153,24 @@ static int wakeup_callback(struct tracecmd_input *handle, struct tep_event *even
 	pid = val;
 
 	TRACEEVAL_SET_NUMBER(keys[0], pid);
-	TRACEEVAL_SET_NUMBER_64(vals[0], record->ts);
 
-	traceeval_insert(data->teval_wakeup, keys, vals);
+	traceeval_delta_start(teval, keys, NULL, record->ts);
 
 	return 0;
 }
 
 static int sched_callback(struct tracecmd_input *handle, struct tep_event *event,
-			   struct tep_record *record, int cpu, void *d)
+			   struct tep_record *record, int cpu, void *data)
 {
 	static struct tep_format_field *next_pid_field;
 	static struct tep_format_field *next_comm_field;
-	struct data *data = d;
+	struct traceeval_data delta_keys[1];
+	struct traceeval_data keys[2];
+	struct traceeval_data vals[1];
+	struct traceeval *teval = data;
 	unsigned long long delta;
 	unsigned long long val;
 	long pid;
-	struct traceeval_data wakeup_keys[1];
-	struct traceeval_data keys[2];
-	struct traceeval_data vals[2];
-	const struct traceeval_data *results;
 
 	if (!next_pid_field) {
 		next_pid_field = tep_find_field(event, "next_pid");
@@ -199,28 +180,24 @@ static int sched_callback(struct tracecmd_input *handle, struct tep_event *event
 	tep_read_number_field(next_pid_field, record->data, &val);
 	pid = val;
 
-	TRACEEVAL_SET_NUMBER(wakeup_keys[0], pid);
+	TRACEEVAL_SET_NUMBER(delta_keys[0], pid);
 
-	if (traceeval_query(data->teval_wakeup, wakeup_keys, &results) <= 0)
+	if (traceeval_delta_stop(teval, delta_keys, NULL, record->ts, &delta, NULL) < 1)
 		return 0;
 
-	delta = record->ts - results[0].number_64;
-	traceeval_results_release(data->teval_wakeup, results);
-
-	TRACEEVAL_SET_CSTRING(keys[0], record->data + next_comm_field->offset);
+	TRACEEVAL_SET_CSTRING(keys[0], (char *)record->data + next_comm_field->offset);
 	TRACEEVAL_SET_NUMBER(keys[1], pid);
 
-	TRACEEVAL_SET_NUMBER_64(vals[0], record->ts);
-	TRACEEVAL_SET_NUMBER_64(vals[1], delta);
+	TRACEEVAL_SET_DELTA(vals[0], delta, record->ts);
 
-	traceeval_insert(data->teval_sched, keys, vals);
+	traceeval_insert(teval, keys, vals);
 
 	return 0;
 }
 
-static void show_latency(struct data *data)
+static void show_latency(struct traceeval *teval)
 {
-	struct traceeval_iterator *iter = traceeval_iterator_get(data->teval_sched);
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
 	const struct traceeval_data *keys;
 
 	printf("\n");
@@ -229,7 +206,7 @@ static void show_latency(struct data *data)
 		unsigned long long val;
 		unsigned long long ts;
 
-		stat = traceeval_iterator_stat(iter, sched_vals[1].name);
+		stat = traceeval_iterator_stat(iter, DELTA_NAME);
 		if (!stat)
 			continue;
 
@@ -251,15 +228,15 @@ static void show_latency(struct data *data)
 int main (int argc, char **argv)
 {
 	struct tracecmd_input *handle;
-	struct data data;
+	struct traceeval *teval;
 
 	if (argc < 2) {
 		printf("usage: wake-lat trace.dat\n");
 		exit(-1);
 	}
 
-	data.teval_wakeup = traceeval_init(wakeup_keys, wakeup_vals);
-	data.teval_sched = traceeval_init(sched_keys, sched_vals);
+	teval = traceeval_init(sched_keys, sched_vals);
+	traceeval_delta_create(teval, delta_keys, NULL);
 
 	handle = tracecmd_open(argv[1], TRACECMD_FL_LOAD_NO_PLUGINS);
 	if (!handle) {
@@ -267,12 +244,14 @@ int main (int argc, char **argv)
 		exit(-1);
 	}
 
-	tracecmd_follow_event(handle, "sched", "sched_waking", wakeup_callback, &data);
-	tracecmd_follow_event(handle, "sched", "sched_switch", sched_callback, &data);
+	tracecmd_follow_event(handle, "sched", "sched_waking", wakeup_callback, teval);
+	tracecmd_follow_event(handle, "sched", "sched_switch", sched_callback, teval);
 
 	tracecmd_iterate_events(handle, NULL, 0, NULL, NULL);
 
-	show_latency(&data);
+	show_latency(teval);
+
+	traceeval_release(teval);
 
 	return 0;
 }
-- 
2.42.0

