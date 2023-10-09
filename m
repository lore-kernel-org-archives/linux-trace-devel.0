Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F8B7484
	for <linux-trace-devel@vger.kernel.org>; Mon,  9 Oct 2023 02:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22672C433C7;
	Mon,  9 Oct 2023 02:52:38 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qpgP5-006cYx-2f;
	Sun, 08 Oct 2023 22:53:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 1/2] libtraceeval: Add traceeval_delta_start/continue/stop() API
Date: Sun,  8 Oct 2023 22:53:53 -0400
Message-Id: <20231009025354.1577934-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231009025354.1577934-1-rostedt@goodmis.org>
References: <20231009025354.1577934-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The first iteration of libtraceeval sought out to facilitate timings
between events. For instance, the time between waking up and scheduling in
of a task (the wake up latency). But that code API quickly became
unusable, as there were several use cases that did not need the timings,
and it was awkward using it.

The libtraceeval was redesigned to be simple histograms that could be
queried for the last instance, and easily have them be joined. This worked
well.

Now we can come up with a new helper that automatically combines two
histograms to create that original idea of easily recording the delta
between events. This new is traceeval_delta_create().

This attaches another light weight traceeval that is made up of
two extra values:

 1. A timestamp value
 2. A delta value

This adds the following features:

 * traceeval_delta_start() - that takes a timestamp that will be recorded
         in the extra timestamp value field.

 * traceeval_delta_stop() - that takes another timestamp and will
         calculate the delta from the matching timestamp that was record
         by traceeval_delta_start() and save that into the delta field.

 * traceeval_delta_continue() - This is pretty much the same as
         traceeval_delta_start(), but if a traceeval_delta_stop() has not
         been called for the given instance represented by the keys since
         the last traceeval_delta_start() or traceeval_delta_continue()
         then it will simply drop the event. This is used for cases that
         There could be many starts, but only the first one counts (as a
         new call to traceeval_delta_start() will reset the timestamp).

The start function may also take values that will be returned to the stop
function so that it can be used together to insert into the main
traceeval.

The two sample programs, task-eval.c and wakeup-lat.c were updated to use
this and it greatly simplifies the code.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval.h |  53 ++++
 samples/task-eval.c | 587 +++++++++++++++++++-------------------------
 samples/wake-lat.c  |  61 ++---
 src/Makefile        |   1 +
 src/delta.c         | 338 +++++++++++++++++++++++++
 src/eval-local.h    |  20 ++
 src/histograms.c    | 127 +++++-----
 7 files changed, 765 insertions(+), 422 deletions(-)
 create mode 100644 src/delta.c

diff --git a/include/traceeval.h b/include/traceeval.h
index 80d2ee1ee14f..3055b561b42f 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -265,6 +265,59 @@ void traceeval_results_release(struct traceeval *teval,
 
 size_t traceeval_count(struct traceeval *teval);
 
+#define traceeval_delta_create(teval, keys, vals)			\
+	traceeval_delta_create_size(teval, keys, vals,			\
+				  TRACEEVAL_ARRAY_SIZE(keys),		\
+				  TRACEEVAL_ARRAY_SIZE(vals))
+
+#define traceeval_delta_create_size(teval, keys, vals, nr_keys, nr_vals) \
+	traceeval_delta_create_data_size(teval, keys, vals, nr_keys, nr_vals, \
+				       sizeof(struct traceeval_type),	\
+				       sizeof(struct traceeval_data))
+
+int traceeval_delta_create_data_size(struct traceeval *teval,
+				     struct traceeval_type *keys,
+				     struct traceeval_type *vals,
+				     size_t nr_keys, size_t nr_vals,
+				     size_t sizeof_type,
+				     size_t sizeof_data);
+
+int traceeval_delta_start_size(struct traceeval *teval,
+			       const struct traceeval_data *keys, size_t nr_keys,
+			       const struct traceeval_data *vals, size_t nr_vals,
+			       unsigned long long timestamp);
+
+#define traceeval_delta_start(teval, keys, vals, timestamp)		\
+	traceeval_delta_start_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), \
+				   vals, TRACEEVAL_ARRAY_SIZE(vals), timestamp)
+
+int traceeval_delta_query_size(struct traceeval *teval,
+			       const struct traceeval_data *keys,
+			       size_t nr_keys, const struct traceeval_data **results);
+
+#define traceeval_delta_query(teval, keys, results)			\
+	traceeval_delta_query_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), results)
+
+int traceeval_delta_continue_size(struct traceeval *teval,
+				  const struct traceeval_data *keys, size_t nr_keys,
+				  const struct traceeval_data *vals, size_t nr_vals,
+				  unsigned long long timestamp);
+
+#define traceeval_delta_continue(teval, keys, vals, timestamp)		\
+	traceeval_delta_continue_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), \
+				      vals, TRACEEVAL_ARRAY_SIZE(vals), timestamp)
+
+int traceeval_delta_stop_size(struct traceeval *teval,
+			      const struct traceeval_data *keys, size_t nr_keys,
+			      const struct traceeval_data **results,
+			      unsigned long long timestamp,
+			      unsigned long long *delta,
+			      unsigned long long *start_timestamp);
+
+#define traceeval_delta_stop(teval, keys, results, timestamp, delta, start_ts)		\
+	traceeval_delta_stop_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), \
+				  results, timestamp, delta, start_ts)
+
 #define traceeval_stat(teval, keys, val_name)				\
 	traceeval_stat_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), val_name)
 
diff --git a/samples/task-eval.c b/samples/task-eval.c
index ac00e2aeb813..f5f16071efac 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -80,6 +80,13 @@ void pdie(const char *fmt, ...)
 	va_end(ap);
 }
 
+static struct traceeval_type cpu_delta_keys[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "CPU",
+	},
+};
+
 static struct traceeval_type cpu_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -91,6 +98,20 @@ static struct traceeval_type cpu_keys[] = {
 	},
 };
 
+static struct traceeval_type process_delta_keys[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "PID",
+	},
+};
+
+static struct traceeval_type delta_vals[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "Schedule state"
+	},
+};
+
 static struct traceeval_type process_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_STRING,
@@ -102,11 +123,15 @@ static struct traceeval_type process_keys[] = {
 	},
 };
 
-static struct traceeval_type process_data_vals[] = {
+static struct traceeval_type process_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_POINTER,
 		.name = "data",
 	},
+	{
+		.type = TRACEEVAL_TYPE_DELTA,
+		.name = "delta",
+	},
 };
 
 static struct traceeval_type thread_keys[] = {
@@ -120,18 +145,10 @@ static struct traceeval_type thread_keys[] = {
 	},
 };
 
-static struct traceeval_type timestamp_vals[] = {
+static struct traceeval_type delta_type[] = {
 	{
-		.type = TRACEEVAL_TYPE_NUMBER_64,
-		.name = "Timestamp",
-		.flags = TRACEEVAL_FL_TIMESTAMP,
-	},
-};
-
-static struct traceeval_type delta_vals[] = {
-	{
-		.type	= TRACEEVAL_TYPE_DELTA,
-		.name	= "delta",
+		.type = TRACEEVAL_TYPE_DELTA,
+		.name = "delta",
 	},
 };
 
@@ -144,22 +161,14 @@ enum sched_state {
 	OTHER
 };
 
-struct teval_pair {
-	struct traceeval	*start;
-	struct traceeval	*stop;
-};
-
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
+	struct traceeval	*teval_cpus;
+	struct traceeval	*teval_tasks;
 	char			*comm;
 };
 
@@ -168,63 +177,55 @@ enum command {
 	STOP
 };
 
-static void update_process(struct task_data *tdata, const char *comm,
-			   enum sched_state state, enum command cmd,
-			   unsigned long long ts)
+static void init_process_data(struct process_data *pdata)
+{
+	pdata->teval_cpus = traceeval_init(cpu_keys, delta_type);
+	if (!pdata->teval_cpus)
+		pdie("Creating trace eval cpus");
+
+	pdata->teval_threads = traceeval_init(thread_keys, delta_type);
+	if (!pdata->teval_threads)
+		pdie("Creating trace eval threads");
+}
+
+void set_process_data(struct task_data *tdata, const char *comm, void *data)
 {
 	struct traceeval_data keys[] = {
 		DEFINE_TRACEEVAL_CSTRING(	comm	),
-		DEFINE_TRACEEVAL_NUMBER(	state	),
-	};
-	struct traceeval_data vals[] = {
-		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
+		DEFINE_TRACEEVAL_NUMBER(	RUNNING	),
 	};
-	struct traceeval_data new_vals[1] = { };
+	struct traceeval_data new_vals[2] = { };
 	const struct traceeval_data *results;
 	int ret;
 
-	switch (cmd) {
-	case START:
-		ret = traceeval_insert(tdata->teval_processes.start, keys, vals);
-		if (ret < 0)
-			pdie("Could not start process");
-		return;
-	case STOP:
-		ret = traceeval_query(tdata->teval_processes.start, keys, &results);
-		if (ret < 0)
-			pdie("Could not query start process");
-		if (ret == 0)
-			return;
-		if (!results[0].number_64)
-			break;
-
-		TRACEEVAL_SET_DELTA(new_vals[0], ts - results[0].number_64, ts);
+	ret = traceeval_query(tdata->teval_tasks, keys, &results);
+	if (ret > 0)
+		goto out; /* It already exists ? */
+	if (ret < 0)
+		pdie("Could not query process data");
 
-		ret = traceeval_insert(tdata->teval_processes.stop, keys, new_vals);
-		if (ret < 0)
-			pdie("Could not stop process");
+	TRACEEVAL_SET_POINTER(new_vals[0], data);
+	TRACEEVAL_SET_DELTA(new_vals[1], 0, 0);
 
-		/* Reset the start */
-		TRACEEVAL_SET_NUMBER_64(new_vals[0], 0);
+	ret = traceeval_insert(tdata->teval_tasks, keys, new_vals);
+	if (ret < 0)
+		pdie("Failed to set process data");
 
-		ret = traceeval_insert(tdata->teval_processes.start, keys, new_vals);
-		if (ret < 0)
-			pdie("Could not start CPU");
-		break;
-	}
-	traceeval_results_release(tdata->teval_processes.start, results);
+ out:
+	traceeval_results_release(tdata->teval_tasks, results);
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
+	if (!pdata)
+		pdie("Allocating process data");
+	init_process_data(pdata);
+	set_process_data(tdata, comm, pdata);
+
+	return pdata;
 }
 
 static struct process_data *
@@ -238,204 +239,137 @@ get_process_data(struct task_data *tdata, const char *comm)
 	void *data;
 	int ret;
 
-	ret = traceeval_query(tdata->teval_processes_data, keys, &results);
+	ret = traceeval_query(tdata->teval_tasks, keys, &results);
 	if (ret < 0)
 		pdie("Could not query process data");
 	if (ret == 0)
-		return NULL;
+		return alloc_pdata(tdata, comm);
 
 	data = results[0].pointer;
-	traceeval_results_release(tdata->teval_processes_data, results);
+	traceeval_results_release(tdata->teval_tasks, results);
 	return data;
 }
 
-void set_process_data(struct task_data *tdata, const char *comm, void *data)
+static void update_cpu_to_idle(struct task_data *tdata, struct tep_record *record)
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
-	if (ret < 0)
-		pdie("Could not query process data");
 
-	TRACEEVAL_SET_POINTER(new_vals[0], data);
-	ret = traceeval_insert(tdata->teval_processes_data, keys, new_vals);
-	if (ret < 0)
-		pdie("Failed to set process data");
-
- out:
-	traceeval_results_release(tdata->teval_processes_data, results);
-}
-
-static void update_cpu(struct teval_pair *teval_pair, int cpu,
-		       enum sched_state state, enum command cmd,
-		       unsigned long long ts)
-{
+	struct traceeval_data delta_keys[1];
+	struct traceeval_data cpu_keys[2];
+	struct traceeval_data vals[1];
 	const struct traceeval_data *results;
-	struct traceeval_data keys[] = {
-		DEFINE_TRACEEVAL_NUMBER(	cpu	),
-		DEFINE_TRACEEVAL_NUMBER(	state	),
-	};
-	struct traceeval_data vals[] = {
-		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
-	};
-	struct traceeval_data new_vals[1] = { };
+	unsigned long long delta;
 	int ret;
 
-	switch (cmd) {
-	case START:
-		/* Only set if the timestamp is zero (or doesn't exist) */
-		ret = traceeval_query(teval_pair->start, keys, &results);
-		if (ret > 0) {
-			if (results[0].number_64)
-				break;
-		}
-		if (ret < 0)
-			pdie("Could not query cpu start data");
-		ret = traceeval_insert(teval_pair->start, keys, vals);
-		if (ret < 0)
-			pdie("Could not start CPU");
-		break;
-	case STOP:
-		ret = traceeval_query(teval_pair->start, keys, &results);
-		if (ret < 0)
-			pdie("Could not query cpu stop data");
-		if (ret == 0)
-			return;
-
-		if (!results[0].number_64)
-			break;
+	/* Finish previous run */
+	TRACEEVAL_SET_NUMBER(delta_keys[0], record->cpu);
 
-		TRACEEVAL_SET_DELTA(new_vals[0], ts - results[0].number_64, ts);
+	ret = traceeval_delta_stop(tdata->teval_cpus, delta_keys, &results,
+				   record->ts, &delta, NULL);
 
-		ret = traceeval_insert(teval_pair->stop, keys, new_vals);
-		if (ret < 0)
-			pdie("Could not stop CPU");
+	if (ret > 0) {
+		TRACEEVAL_SET_NUMBER(cpu_keys[0], record->cpu);
+		TRACEEVAL_SET_NUMBER(cpu_keys[1], results[0].number);
 
-		/* Reset the start */
-		TRACEEVAL_SET_NUMBER_64(new_vals[0], 0);
-		ret = traceeval_insert(teval_pair->start, keys, new_vals);
-		if (ret < 0)
-			pdie("Could not start CPU");
+		TRACEEVAL_SET_DELTA(vals[0], delta, record->ts);
 
-		break;
-		default:
-			return;
+		traceeval_insert(tdata->teval_cpus, cpu_keys, vals);
+		traceeval_results_release(tdata->teval_cpus, results);
 	}
-	traceeval_results_release(teval_pair->start, results);
-}
 
-static void start_cpu(struct teval_pair *teval_pair, int cpu,
-		      enum sched_state state,  unsigned long long ts)
-{
-	update_cpu(teval_pair, cpu, state, START, ts);
+	/* Start the next state */
+	TRACEEVAL_SET_NUMBER(vals[0], IDLE);
+	traceeval_delta_start(tdata->teval_cpus, delta_keys, vals,
+			      record->ts);
 }
 
-static void stop_cpu(struct teval_pair *teval_pair, int cpu,
-		     enum sched_state state, unsigned long long ts)
+static void update_cpu_to_running(struct task_data *tdata, struct tep_record *record)
 {
-	update_cpu(teval_pair, cpu, state, STOP, ts);
+	struct traceeval_data delta_keys[1];
+	struct traceeval_data cpu_keys[2];
+	struct traceeval_data vals[1];
+	const struct traceeval_data *results;
+	unsigned long long delta;
+	int ret;
+
+	/* Initialize the delta and cpu keys to point to this CPU */
+	TRACEEVAL_SET_NUMBER(delta_keys[0], record->cpu);
+	TRACEEVAL_SET_NUMBER(cpu_keys[0], record->cpu);
+
+	/* Test if the CPU was idle */
+	ret = traceeval_delta_query(tdata->teval_cpus, delta_keys, &results);
+	if (ret > 0 && results[0].number == IDLE) {
+		/* Coming from idle */
+		traceeval_delta_stop(tdata->teval_cpus, delta_keys, NULL,
+				     record->ts, &delta, NULL);
+		/* Update the idle teval */
+		TRACEEVAL_SET_NUMBER(cpu_keys[1], IDLE);
+		TRACEEVAL_SET_DELTA(vals[0], delta, record->ts);
+		traceeval_insert(tdata->teval_cpus, cpu_keys, vals);
+	}
+
+	/* Continue with the CPU running */
+	TRACEEVAL_SET_NUMBER(vals[0], RUNNING);
+	traceeval_delta_continue(tdata->teval_cpus, delta_keys, vals,
+				 record->ts);
 }
 
-static void update_thread(struct process_data *pdata, int tid,
-			  enum sched_state state, enum command cmd,
-			  unsigned long long ts)
+static void start_running_thread(struct task_data *tdata,
+				 struct tep_record *record,
+				 const char *comm, int pid)
 {
 	const struct traceeval_data *results;
-	struct traceeval_data keys[] = {
-		DEFINE_TRACEEVAL_NUMBER(	tid	),
-		DEFINE_TRACEEVAL_NUMBER(	state	),
-	};
-	struct traceeval_data vals[] = {
-		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
-	};
-	struct traceeval_data new_vals[1] = { };
+	struct traceeval_data delta_keys[1];
+	struct traceeval_data vals[1];
+	unsigned long long delta;
+	unsigned long long val;
 	int ret;
 
-	switch (cmd) {
-	case START:
-		ret = traceeval_insert(pdata->teval_threads.start, keys, vals);
-		if (ret < 0)
-			pdie("Could not start thread");
-		return;
-	case STOP:
-		ret = traceeval_query(pdata->teval_threads.start, keys, &results);
-		if (ret < 0)
-			pdie("Could not query thread start");
-		if (ret == 0)
-			return;
+	TRACEEVAL_SET_NUMBER(delta_keys[0], pid);
 
-		TRACEEVAL_SET_DELTA(new_vals[0], ts - results[0].number_64, ts);
+	/* Find the previous stop state of this task */
+	ret = traceeval_delta_stop(tdata->teval_tasks, delta_keys,
+				   &results, record->ts, &delta, &val);
+	if (ret > 0) {
+		enum sched_state state = results[0].number;
+		struct traceeval_data keys[2];
+		struct traceeval_data pvals[2];
+		struct process_data *pdata;
 
-		ret = traceeval_insert(pdata->teval_threads.stop, keys, new_vals);
-		traceeval_results_release(pdata->teval_threads.start, results);
-		if (ret < 0)
-			pdie("Could not stop thread");
-		return;
-	}
-}
+		traceeval_results_release(tdata->teval_tasks, results);
 
-static void start_thread(struct process_data *pdata, int tid,
-			   enum sched_state state, unsigned long long ts)
-{
-	update_thread(pdata, tid, state, START, ts);
-}
+		pdata = get_process_data(tdata, comm);
 
-static void stop_thread(struct process_data *pdata, int tid,
-			enum sched_state state, unsigned long long ts)
-{
-	update_thread(pdata, tid, state, STOP, ts);
-}
+		TRACEEVAL_SET_NUMBER(keys[0], pid);
+		TRACEEVAL_SET_NUMBER(keys[1], state);
 
-static struct tep_format_field *get_field(struct tep_event *event, const char *name)
-{
-	static struct tep_format_field *field;
+		if (state == RUNNING)
+			die("State %d is running! %lld -> %lld", pid, val, record->ts);
 
-	field = tep_find_field(event, name);
-	if (!field)
-		die("Could not find field %s for %s",
-		    name, event->name);
+		TRACEEVAL_SET_DELTA(vals[0], delta, record->ts);
 
-	return field;
-}
+		traceeval_insert(pdata->teval_threads, keys, vals);
 
-static void init_process_data(struct process_data *pdata)
-{
+		/* Also update the process */
+		TRACEEVAL_SET_CSTRING(keys[0], comm);
 
-	pdata->teval_cpus.start = traceeval_init(cpu_keys, timestamp_vals);
-	if (!pdata->teval_cpus.start)
-		pdie("Creating trace eval cpus start");
-	pdata->teval_cpus.stop = traceeval_init(cpu_keys, delta_vals);
-	if (!pdata->teval_cpus.stop)
-		pdie("Creating trace eval cpus");
+		TRACEEVAL_SET_POINTER(pvals[0], pdata);
+		TRACEEVAL_SET_DELTA(pvals[1], delta, record->ts);
 
-	pdata->teval_threads.start = traceeval_init(thread_keys, timestamp_vals);
-	if (!pdata->teval_threads.start)
-		pdie("Creating trace eval threads start");
+		traceeval_insert(tdata->teval_tasks, keys, pvals);
+	}
 
-	pdata->teval_threads.stop = traceeval_init(thread_keys, delta_vals);
-	if (!pdata->teval_threads.stop)
-		pdie("Creating trace eval threads");
+	TRACEEVAL_SET_NUMBER(vals[0], RUNNING);
+
+	traceeval_delta_start(tdata->teval_tasks, delta_keys, vals, record->ts);
 }
 
-static struct process_data *alloc_pdata(struct task_data *tdata, const char *comm)
+static int get_stop_state(unsigned long long val)
 {
-	struct process_data *pdata;
-
-	pdata = calloc(1, sizeof(*pdata));
-	if (!pdata)
-		pdie("Allocating process data");
-	init_process_data(pdata);
-	set_process_data(tdata, comm, pdata);
-
-	return pdata;
+	if (val & 1)
+		return SLEEP;
+	if (val & 2)
+		return BLOCKED;
+	return PREEMPT;
 }
 
 static void sched_out(struct task_data *tdata, const char *comm,
@@ -443,69 +377,78 @@ static void sched_out(struct task_data *tdata, const char *comm,
 		      struct tep_record *record, struct tep_format_field *prev_pid,
 		      struct tep_format_field *prev_state)
 {
+	struct traceeval_data delta_keys[1];
+	struct traceeval_data task_keys[2];
+	struct traceeval_data task_vals[2];
+	struct traceeval_data vals[1];
 	struct process_data *pdata;
+	const struct traceeval_data *results;
+	unsigned long long delta;
 	unsigned long long val;
+	int state;
+	int old_state;
 	int pid;
 	int ret;
 
 	ret = tep_read_number_field(prev_pid, record->data, &val);
 	if (ret < 0)
 		die("Could not read sched_switch next_pid for record");
-
-	/* Ignore the idle task */
 	pid = val;
-	if (!pid) {
-		/* Record the runtime for the process CPUs */
-		stop_cpu(&tdata->teval_cpus, record->cpu, IDLE, record->ts);
-		return;
-	}
-
-	/* The process is scheduling out. Stop the run time. */
-	update_process(tdata, comm, RUNNING, STOP, record->ts);
 
-	/* Get the process data from the process running state */
-	pdata = get_process_data(tdata, comm);
-	if (!pdata)
-		pdata = alloc_pdata(tdata, comm);
+	/* Idle is handled by sched_in() */
+	if (!pid)
+		return;
 
 	ret = tep_read_number_field(prev_state, record->data, &val);
 	if (ret < 0)
 		die("Could not read sched_switch next_pid for record");
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
+	state = get_stop_state(val);
+
+	TRACEEVAL_SET_NUMBER(delta_keys[0], pid);
+
+	ret = traceeval_delta_stop(tdata->teval_tasks, delta_keys, &results,
+				   record->ts, &delta, &val);
+
+	TRACEEVAL_SET_NUMBER(vals[0], state);
+
+	if (ret > 0)
+		old_state = results[0].number;
+
+	/* Start recording why this task is off the CPU */
+	traceeval_delta_start(tdata->teval_tasks, delta_keys, vals, record->ts);
+	if (ret <= 0)
+		return;
+
+	if (old_state != RUNNING)
+		die("Not running %d from %lld to %lld",
+		    old_state, val, record->ts);
+
+	TRACEEVAL_SET_CSTRING(task_keys[0], comm);
+	TRACEEVAL_SET_NUMBER(task_keys[1], RUNNING);
+
+	pdata = get_process_data(tdata, comm);
+
+	TRACEEVAL_SET_POINTER(task_vals[0], pdata);
+	TRACEEVAL_SET_DELTA(task_vals[1], delta, record->ts);
+
+	traceeval_insert(tdata->teval_tasks, task_keys, task_vals);
+
+	TRACEEVAL_SET_NUMBER(task_keys[0], pid);
+
+	TRACEEVAL_SET_DELTA(vals[0], delta, record->ts);
+
+	traceeval_insert(pdata->teval_threads, task_keys, vals);
+
+	TRACEEVAL_SET_NUMBER(task_keys[0], record->cpu);
+
+	traceeval_insert(pdata->teval_cpus, task_keys, vals);
 }
 
 static void sched_in(struct task_data *tdata, const char *comm,
 		     struct tep_event *event,
 		     struct tep_record *record, struct tep_format_field *next_pid)
 {
-	struct process_data *pdata;
 	unsigned long long val;
-	bool is_new = false;
 	int ret;
 	int pid;
 
@@ -514,42 +457,27 @@ static void sched_in(struct task_data *tdata, const char *comm,
 		die("Could not read sched_switch next_pid for record");
 	pid = val;
 
-	/* Ignore the idle task */
+	/* Idle task */
 	if (!pid) {
-		/* Record the runtime for the process CPUs */
-		start_cpu(&tdata->teval_cpus, record->cpu, IDLE, record->ts);
+		update_cpu_to_idle(tdata, record);
 		return;
 	}
 
-	/* Start recording the running time of this process */
-	start_process(tdata, comm, RUNNING, record->ts);
-
-	pdata = get_process_data(tdata, comm);
-
-	/* Start recording the running time of process CPUs */
-	start_cpu(&tdata->teval_cpus, record->cpu, RUNNING, record->ts);
-
-	/* If there was no pdata, then this process did not go through sched out */
-	if (!pdata) {
-		pdata = alloc_pdata(tdata, comm);
-		is_new = true;
-	}
-
-	/* Record the state timings for the individual thread */
-	start_thread(pdata, pid, RUNNING, record->ts);
-
-	/* Start recording the running time of process CPUs */
-	start_cpu(&pdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	/* Continue measuring CPU running time */
+	update_cpu_to_running(tdata, record);
+	start_running_thread(tdata, record, comm, pid);
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
+	if (!field)
+		die("Could not find field %s for %s",
+		    name, event->name);
 
-	/* Stop recording the process time for its scheduled out state */
-	stop_process(tdata, comm, pdata->state, record->ts);
+	return field;
 }
 
 static int switch_func(struct tracecmd_input *handle, struct tep_event *event,
@@ -602,14 +530,13 @@ static void print_microseconds(int idx, unsigned long long nsecs)
  *    If the RUNNING state does not exist, it's considered -1
  *  If RUNNING is equal, then sort by COMM.
  */
-static int compare_pdata(struct traceeval *teval_data,
+static int compare_pdata(struct traceeval *teval,
 				const struct traceeval_data *Akeys,
 				const struct traceeval_data *Avals,
 				const struct traceeval_data *Bkeys,
 				const struct traceeval_data *Bvals,
 				void *data)
 {
-	struct traceeval *teval = data; /* The deltas are here */
 	struct traceeval_data keysA[] = {
 		DEFINE_TRACEEVAL_CSTRING(	Akeys[0].cstring	),
 		DEFINE_TRACEEVAL_NUMBER(	RUNNING			), };
@@ -630,11 +557,11 @@ static int compare_pdata(struct traceeval *teval_data,
 	}
 
 	/* Get the RUNNING values for both processes */
-	statA = traceeval_stat(teval, keysA, delta_vals[0].name);
+	statA = traceeval_stat(teval, keysA, delta_type[0].name);
 	if (statA)
 		totalA = traceeval_stat_total(statA);
 
-	statB = traceeval_stat(teval, keysB, delta_vals[0].name);
+	statB = traceeval_stat(teval, keysB, delta_type[0].name);
 	if (statB)
 		totalB = traceeval_stat_total(statB);
 
@@ -665,7 +592,7 @@ static void display_cpus(struct traceeval *teval)
 		int state = keys[1].number;
 		int cpu = keys[0].number;
 
-		stat = traceeval_iterator_stat(iter, delta_vals[0].name);
+		stat = traceeval_iterator_stat(iter, delta_type[0].name);
 		if (!stat)
 			continue; // die?
 
@@ -694,7 +621,6 @@ static void display_cpus(struct traceeval *teval)
 
 	if (last_cpu < 0)
 		die("No result for CPUs\n");
-
 }
 
 static void display_state_times(int state, unsigned long long total)
@@ -732,7 +658,7 @@ static void display_threads(struct traceeval *teval)
 		int state = keys[1].number;
 		int tid = keys[0].number;
 
-		stat = traceeval_iterator_stat(iter, delta_vals[0].name);
+		stat = traceeval_iterator_stat(iter, delta_type[0].name);
 		if (!stat)
 			continue; // die?
 
@@ -746,13 +672,12 @@ static void display_threads(struct traceeval *teval)
 
 	if (last_tid < 0)
 		die("No result for threads\n");
-
 }
 
 static void display_process(struct process_data *pdata)
 {
-	display_threads(pdata->teval_threads.stop);
-	display_cpus(pdata->teval_cpus.stop);
+	display_threads(pdata->teval_threads);
+	display_cpus(pdata->teval_cpus);
 	printf("\n");
 }
 
@@ -770,27 +695,32 @@ static void display_process_stats(struct traceeval *teval,
 		TRACEEVAL_SET_NUMBER(keys[1], i);
 
 		delta = 0;
-		stat = traceeval_stat(teval, keys, delta_vals[0].name);
+		stat = traceeval_stat(teval, keys, delta_type[0].name);
 		if (stat)
 			delta = traceeval_stat_total(stat);
 		display_state_times(i, delta);
 	}
 }
 
-static void display_processes(struct traceeval *teval,
-			      struct traceeval *teval_data)
+static void display_processes(struct traceeval *teval)
 {
-	struct traceeval_iterator *iter = traceeval_iterator_get(teval_data);
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
 	const struct traceeval_data *keys;
+	const char *last_comm = "";
 	int ret;
 
-	traceeval_iterator_sort_custom(iter, compare_pdata, teval);
+	traceeval_iterator_sort_custom(iter, compare_pdata, NULL);
 
 	while (traceeval_iterator_next(iter, &keys) > 0) {
 		const struct traceeval_data *results;
 		struct process_data *pdata = NULL;
 		const char *comm = keys[0].cstring;
 
+		if (strcmp(comm, last_comm) == 0)
+			continue;
+
+		last_comm = comm;
+
 		ret = traceeval_iterator_query(iter, &results);
 		if (ret < 0)
 			pdie("Could not query iterator");
@@ -798,7 +728,7 @@ static void display_processes(struct traceeval *teval,
 			continue; /* ?? */
 
 		pdata = results[0].pointer;
-		traceeval_results_release(teval_data, results);
+		traceeval_results_release(teval, results);
 
 		printf("Task: %s\n", comm);
 
@@ -810,7 +740,7 @@ static void display_processes(struct traceeval *teval,
 
 static void display(struct task_data *tdata)
 {
-	struct traceeval *teval = tdata->teval_cpus.stop;
+	struct traceeval *teval = tdata->teval_cpus;
 	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
 	const struct traceeval_data *keys;
 	struct traceeval_stat *stat;
@@ -818,8 +748,7 @@ static void display(struct task_data *tdata)
 	unsigned long long idle_time = 0;
 
 	if (tdata->comm) {
-		return display_processes(tdata->teval_processes.stop,
-					 tdata->teval_processes_data);
+		return display_processes(tdata->teval_tasks);
 	}
 
 	printf("Total:\n");
@@ -830,7 +759,7 @@ static void display(struct task_data *tdata)
 	while (traceeval_iterator_next(iter, &keys) > 0) {
 		int state = keys[1].number;
 
-		stat = traceeval_iterator_stat(iter, delta_vals[0].name);
+		stat = traceeval_iterator_stat(iter, delta_type[0].name);
 		if (!stat)
 			continue;
 
@@ -851,10 +780,10 @@ static void display(struct task_data *tdata)
 	printf("  Total idle time (us):");
 	print_microseconds(16, idle_time);
 
-	display_cpus(tdata->teval_cpus.stop);
+	display_cpus(tdata->teval_cpus);
 
 	printf("\n");
-	display_processes(tdata->teval_processes.stop, tdata->teval_processes_data);
+	display_processes(tdata->teval_tasks);
 }
 
 static void free_tdata(struct task_data *tdata)
@@ -892,23 +821,21 @@ int main (int argc, char **argv)
 	if (!handle)
 		pdie("Error opening %s", argv[0]);
 
-	data.teval_processes.start = traceeval_init(process_keys, timestamp_vals);
-	if (!data.teval_processes.start)
-		pdie("Creating trace eval start");
-	data.teval_processes_data = traceeval_init(process_keys, process_data_vals);
-	if (!data.teval_processes_data)
-		pdie("Creating trace eval data");
-	data.teval_processes.stop = traceeval_init(process_keys, delta_vals);
-	if (!data.teval_processes.stop)
-		pdie("Creating trace eval");
+	data.teval_tasks = traceeval_init(process_keys, process_vals);
+	if (!data.teval_tasks)
+		pdie("Creating trace eval processe data");
 
-	data.teval_cpus.start = traceeval_init(cpu_keys, timestamp_vals);
-	if (!data.teval_cpus.start)
-		pdie("Creating trace eval");
-	data.teval_cpus.stop = traceeval_init(cpu_keys, delta_vals);
-	if (!data.teval_cpus.stop)
+	if (traceeval_delta_create(data.teval_tasks, process_delta_keys,
+				   delta_vals) < 0)
+		pdie("Creating trace delta threads");
+
+	data.teval_cpus = traceeval_init(cpu_keys, delta_type);
+	if (!data.teval_cpus)
 		pdie("Creating trace eval");
 
+	if (traceeval_delta_create(data.teval_cpus, cpu_delta_keys, delta_vals) < 0)
+		pdie("Creating trace delta cpus");
+
 	tracecmd_follow_event(handle, "sched", "sched_switch", switch_func, &data);
 
 	tracecmd_iterate_events(handle, NULL, 0, NULL, NULL);
diff --git a/samples/wake-lat.c b/samples/wake-lat.c
index 1436dbda0874..656b76a26636 100644
--- a/samples/wake-lat.c
+++ b/samples/wake-lat.c
@@ -4,25 +4,16 @@
 #include <traceeval.h>
 
 struct data {
-	struct traceeval		*teval_wakeup;
-	struct traceeval		*teval_sched;
+	struct traceeval		*teval;
 };
 
-struct traceeval_type wakeup_keys[] = {
+struct traceeval_type delta_keys[] = {
 	{
 		.name		= "PID",
 		.type		= TRACEEVAL_TYPE_NUMBER,
 	}
 };
 
-struct traceeval_type wakeup_vals[] = {
-	{
-		.name		= "timestamp",
-		.flags		= TRACEEVAL_FL_TIMESTAMP,
-		.type		= TRACEEVAL_TYPE_NUMBER_64,
-	}
-};
-
 struct traceeval_type sched_keys[] = {
 	{
 		.name		= "COMM",
@@ -45,22 +36,21 @@ static int wakeup_callback(struct tracecmd_input *handle, struct tep_event *even
 			   struct tep_record *record, int cpu, void *d)
 {
 	static struct tep_format_field *pid_field;
+	struct traceeval_data keys[1];
 	struct data *data = d;
 	unsigned long long val;
 	long pid;
-	struct traceeval_data keys[1];
-	struct traceeval_data vals[1];
 
-	if (!pid_field)
+	if (!pid_field) {
 		pid_field = tep_find_field(event, "pid");
+	}
 
 	tep_read_number_field(pid_field, record->data, &val);
 	pid = val;
 
 	TRACEEVAL_SET_NUMBER(keys[0], pid);
-	TRACEEVAL_SET_NUMBER_64(vals[0], record->ts);
 
-	traceeval_insert(data->teval_wakeup, keys, vals);
+	traceeval_delta_start(data->teval, keys, NULL, record->ts);
 
 	return 0;
 }
@@ -71,14 +61,13 @@ static int sched_callback(struct tracecmd_input *handle, struct tep_event *event
 	static struct tep_format_field *next_pid_field;
 	static struct tep_format_field *next_comm_field;
 	struct data *data = d;
-	unsigned long long delta;
-	unsigned long long val;
-	long pid;
-	struct traceeval_data wakeup_keys[1];
-	struct traceeval_data keys[2];
+	struct traceeval_data delta_keys[1];
+	struct traceeval_data sched_keys[2];
 	struct traceeval_data vals[1];
-	const struct traceeval_data *results;
+	unsigned long long val;
 	const char *comm;
+	long pid;
+	int ret;
 
 	if (!next_pid_field) {
 		next_pid_field = tep_find_field(event, "next_pid");
@@ -88,28 +77,25 @@ static int sched_callback(struct tracecmd_input *handle, struct tep_event *event
 	tep_read_number_field(next_pid_field, record->data, &val);
 	pid = val;
 
-	TRACEEVAL_SET_NUMBER(wakeup_keys[0], pid);
+	comm = (char *)record->data + next_comm_field->offset;
 
-	if (traceeval_query(data->teval_wakeup, wakeup_keys, &results) <= 0)
+	TRACEEVAL_SET_NUMBER(delta_keys[0], pid);
+	ret = traceeval_delta_stop(data->teval, delta_keys, NULL, record->ts, &val, NULL);
+	if (ret <= 0)
 		return 0;
 
-	delta = record->ts - results[0].number_64;
-	traceeval_results_release(data->teval_wakeup, results);
+	TRACEEVAL_SET_CSTRING(sched_keys[0],comm);
+	TRACEEVAL_SET_NUMBER(sched_keys[1], pid);
 
-	comm = (char *)record->data + next_comm_field->offset;
-	TRACEEVAL_SET_CSTRING(keys[0],comm);
-	TRACEEVAL_SET_NUMBER(keys[1], pid);
-
-	TRACEEVAL_SET_DELTA(vals[0], delta, record->ts);
-
-	traceeval_insert(data->teval_sched, keys, vals);
+	TRACEEVAL_SET_DELTA(vals[0], val, record->ts);
+	traceeval_insert(data->teval, sched_keys, vals);
 
 	return 0;
 }
 
 static void show_latency(struct data *data)
 {
-	struct traceeval_iterator *iter = traceeval_iterator_get(data->teval_sched);
+	struct traceeval_iterator *iter = traceeval_iterator_get(data->teval);
 	const struct traceeval_data *keys;
 
 	printf("\n");
@@ -147,8 +133,11 @@ int main (int argc, char **argv)
 		exit(-1);
 	}
 
-	data.teval_wakeup = traceeval_init(wakeup_keys, wakeup_vals);
-	data.teval_sched = traceeval_init(sched_keys, sched_vals);
+	data.teval = traceeval_init(sched_keys, sched_vals);
+	if (traceeval_delta_create(data.teval, delta_keys, NULL) < 0) {
+		perror("Failed to create traceeval delta");
+		exit(-1);
+	}
 
 	handle = tracecmd_open(argv[1], TRACECMD_FL_LOAD_NO_PLUGINS);
 	if (!handle) {
diff --git a/src/Makefile b/src/Makefile
index 168d90a67cab..6f790b21bae4 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -4,6 +4,7 @@ include $(src)/scripts/utils.mk
 
 OBJS =
 OBJS += histograms.o
+OBJS += delta.o
 OBJS += hash.o
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
diff --git a/src/delta.c b/src/delta.c
new file mode 100644
index 000000000000..e97aa0c1851b
--- /dev/null
+++ b/src/delta.c
@@ -0,0 +1,338 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
+ */
+
+#include <stdbool.h>
+#include <string.h>
+#include <stdarg.h>
+#include <stdio.h>
+
+#include <traceeval.h>
+#include "eval-local.h"
+
+struct traceeval_delta {
+	struct traceeval		*teval;
+};
+
+#define TEVAL_TIMESTAMP_IDX(teval)         ((teval)->nr_val_types - 1)
+
+/* Get to the saved timestamp value */
+#define TEVAL_TIMESTAMP(teval, val)                (val)[TEVAL_TIMESTAMP_IDX(teval)].number_64
+
+#define TEVAL_TIMESTAMP_NAME	"__TRACEEVAL_DELTA_TIMESTAMP__"
+
+/**
+ * traceeval_delta_create_data_size - create a delta for a teval
+ * @teval: The traceeval to create a delta query for
+ * @keys: Defines the keys to differentiate traceeval delta entries
+ * @vals: Defines values attached to entries differentiated by @keys.
+ * @nr_keys: The number of @keys passed in
+ * @nr_vals: The number of @vals passed in
+ * @sizeof_type: The size of struct traceeval_type
+ * @sizeof_data: The size of struct traceeval_data
+ *
+ * This adds a specialized internal traceeval descriptor to @teval.
+ * This descriptor is used to find the start and stop timings between
+ * two events. The @keys are used to map the start and stop events.
+ * The @keys should be something that is in both events to tell that
+ * they are related. Note the @keys here are not related to the keys
+ * that created the traceeval in traceeval_init().
+ *
+ * The @vals is used to store information from the start event that can
+ * then be used at the stop event and returned in the traceeval_delta_stop().
+ *
+ * Returns 0 on success and -1 on error.
+ */
+int traceeval_delta_create_data_size(struct traceeval *teval,
+				     struct traceeval_type *keys,
+				     struct traceeval_type *vals,
+				     size_t nr_keys,
+				     size_t nr_vals,
+				     size_t sizeof_type,
+				     size_t sizeof_data)
+{
+	struct traceeval_type *delta_vals;
+	struct traceeval_type *val;
+	struct traceeval_delta *tdelta;
+	int i;
+
+	/* Only one can exist */
+	if (teval->tdelta)
+		return -1;
+
+	tdelta = calloc(1, sizeof(*tdelta));
+	if (!tdelta)
+		return -1;
+
+	if (vals) {
+		for (i = 0; i < nr_vals && vals[i].type != TRACEEVAL_TYPE_NONE; i++)
+			;
+		nr_vals = i;
+	} else {
+		nr_vals = 0;
+	}
+
+	/* Copy the vals and add the save timestamp at the end */
+	delta_vals = calloc(nr_vals + 1, sizeof(*delta_vals));
+	if (!delta_vals)
+		goto fail;
+
+	for (i = 0; i < nr_vals; i++)
+		delta_vals[i] = vals[i];
+
+	/* Append the delta value */
+	val = &delta_vals[nr_vals++];
+	val->name = TEVAL_TIMESTAMP_NAME;
+	val->type = TRACEEVAL_TYPE_NUMBER_64;
+
+	tdelta->teval = traceeval_init_data_size(keys, delta_vals, nr_keys,
+						 nr_vals, sizeof_type,
+						 sizeof_data);
+	/* The delta_vals are no longer needed */
+	free(delta_vals);
+
+	if (!tdelta->teval)
+		goto fail;
+
+	tdelta->teval->flags |= TEVAL_FL_DELTA;
+
+	teval->tdelta = tdelta;
+
+	return 0;
+ fail:
+	free(tdelta);
+	return -1;
+}
+
+/*
+ * __delta_release - release the resources of a traceeval_delta
+ * @tdelta: The traceeval_delta descriptor to release
+ *
+ * Frees all the resources created by traceeval_delta_create().
+ */
+__hidden void __delta_release(struct traceeval_delta *tdelta)
+{
+	if (!tdelta)
+		return;
+
+	traceeval_release(tdelta->teval);
+	free(tdelta);
+}
+
+/**
+ * traceeval_delta_remove - Remove an instance from a traceeval_delta
+ * @teval: The traceeval descriptor
+ * @keys: The keys to find the matching element to remove
+ * @nr_keys: The number of @keys
+ *
+ * Returns 1 if it found and removed an item,
+ *         0 if it did not find an time matching @keys
+ *        -1 if there was an error.
+ */
+int traceeval_delta_remove_size(struct traceeval *teval,
+				const struct traceeval_data *keys,
+				size_t nr_keys)
+{
+	if (!teval->tdelta)
+		return -1;
+	return traceeval_remove_size(teval->tdelta->teval, keys, nr_keys);
+}
+
+/*
+ * traceeval_delta_query - find the last instance defined by the keys
+ * @teval: The traceeval descriptor to search the traceeval_delta from
+ * @keys: A list of data to look for
+ * @results: A pointer to where to place the results (if found)
+ *
+ * This does a lookup for an instance within the traceeval_delta.
+ * The @keys is an array defined by the keys declared in traceeval_delta_init().
+ * The @keys will return an item that had the same keys when it was
+ * inserted by traceeval_delta_start().
+ *
+ * The @results will hold the vals passed to the last traceeval_delta_start()
+ * for the given @keys if found, or undefined if not.
+ *
+ * Note, when the caller is done with @results, it must call
+ * traceeval_results_release() on it.
+ *
+ * Returns 1 if found, 0 if not found, and -1 on error.
+ */
+int traceeval_delta_query_size(struct traceeval *teval,
+			       const struct traceeval_data *keys,
+			       size_t nr_keys, const struct traceeval_data **results)
+{
+	if (!teval->tdelta)
+		return -1;
+	return traceeval_query_size(teval->tdelta->teval, keys,
+				    nr_keys, results);
+}
+
+static int delta_start(struct traceeval *teval,
+		       const struct traceeval_data *keys, size_t nr_keys,
+		       const struct traceeval_data *vals, size_t nr_vals,
+		       unsigned long long timestamp, bool cont)
+{
+	struct entry *entry;
+	int ret;
+	int i;
+
+	if (!teval->tdelta)
+		return -1;
+
+	teval = teval->tdelta->teval;
+
+	if (nr_keys != teval->nr_key_types ||
+	    nr_vals != teval->nr_val_types - 1)
+		return -1;
+
+	ret = _teval_get_entry(teval, keys, &entry);
+	if (ret < 0)
+		return ret;
+
+	if (ret) {
+		if (cont && TEVAL_TIMESTAMP(teval, entry->vals))
+			return 0;
+
+		for (i = 0; i < nr_vals; i++)
+			entry->vals[i] = vals[i];
+
+		TRACEEVAL_SET_NUMBER_64(entry->vals[i], timestamp);
+
+		return 0;
+	} else {
+		struct traceeval_data new_vals[teval->nr_val_types] = {};
+
+		for (i = 0; i < nr_vals; i++)
+			new_vals[i] = vals[i];
+
+		TRACEEVAL_SET_NUMBER_64(new_vals[i], timestamp);
+
+		return _teval_insert(teval, keys, teval->nr_key_types,
+				     new_vals, teval->nr_val_types);
+	}
+}
+
+/*
+ * traceeval_delta_start - start the timings of a traceeval_delta
+ * @teval: The traceeval descriptor
+ * @keys: The keys of the instance to start the timing for
+ * @nr_keys: The number of @keys
+ * @vals: Values to save to pass to traceeval_delta_stop()
+ * @nr_vals: The number of @vals
+ * @timestamp: The timestamp for the start of this instance
+ *
+ * The traceeval_delta is used to add start and stop times for the objects
+ * in the traceeval. This function denotes that the instance represented by
+ * @keys is in the process of "starting". The @timestamp is the start time.
+ * This should be matched by a corresponding traceeval_delta_stop().
+ *
+ * The @vals will be saved for the matching @keys and returned in the
+ * results of a traceeval_delta_stop().
+ *
+ * Returns 0 on succes and -1 on error.
+ */
+int traceeval_delta_start_size(struct traceeval *teval,
+			       const struct traceeval_data *keys, size_t nr_keys,
+			       const struct traceeval_data *vals, size_t nr_vals,
+			       unsigned long long timestamp)
+{
+	return delta_start(teval, keys, nr_keys, vals, nr_vals,
+			   timestamp, false);
+}
+
+/*
+ * traceeval_delta_continue - continue the timings of a traceeval_delta
+ * @teval: The traceeval descriptor
+ * @keys: The keys of the instance to continue the timing for
+ * @nr_keys: The number of @keys
+ * @vals: Values to save to pass to traceeval_delta_stop()
+ * @nr_vals: The number of @vals
+ * @timestamp: The timestamp for the start of this instance
+ *
+ * This acts similar to traceeval_delta_start() except that if this is called
+ * between a traceeval_delta_start() and a traceeval_delta_stop(), it will
+ * not doing anything. There's times that multiple starts may happen, and only
+ * the first one should be used. In that case, traceeval_delta_continue() will
+ * update the timings on the first run, and will not do any update until
+ * a traceeval_delta_stop() is executed on the given @keys.
+ *
+ * Note that even the @vals are ignored if this is called between the
+ * traceeval_delta_start/continue() and a traceeval_delta_stop().
+ *
+ * Returns 0 on succes and -1 on error.
+ */
+int traceeval_delta_continue_size(struct traceeval *teval,
+				  const struct traceeval_data *keys, size_t nr_keys,
+				  const struct traceeval_data *vals, size_t nr_vals,
+				  unsigned long long timestamp)
+{
+	return delta_start(teval, keys, nr_keys, vals, nr_vals, timestamp, true);
+}
+
+/*
+ * traceeval_delta_stop - stop the timings of a traceeval_delta
+ * @teval: The traceeval descriptor
+ * @keys: The keys of the instance to stop the timing for
+ * @nr_keys: The number of @keys
+ * @results: A pointer to place the passed in vals of start (or NULL)
+ * @timestamp: The timestamp for the stop of this instance
+ * @delta: Retruns the calculated delta from the previous timestamp
+ * @stop_ts: Returns the timestamp of the matching start
+ *
+ * The traceeval_delta is used to add start and stop times for the objects
+ * in the traceeval. This function denotes that the instance represented by
+ * @keys is in the process of "stopping". The @timestamp is the stop time.
+ * This function does not do anything if there was no matching
+ * traceeval_delta_start() or traceeval_delta_continue() for the given @keys.
+ * If there is a match, then it will take the @timestamp and subtract it
+ * from the saved timestamp of the traceeval_delta_start/continue(),
+ * and record the resulting delta with the given traceeval_stat information.
+ *
+ * If @results is not NULL then it will be assigned to the vals passed to
+ * traceeval_delta_start/continue().
+ *
+ * If @start_ts is not NULL, then it will get assigned to the timestamp
+ * passed to the matching tarceeval_delta_start/continue().
+ *
+ * Returns 1 if updated, 0 if not found, and -1 on error.
+ */
+int traceeval_delta_stop_size(struct traceeval *teval,
+			      const struct traceeval_data *keys, size_t nr_keys,
+			      const struct traceeval_data **results,
+			      unsigned long long timestamp,
+			      unsigned long long *delta,
+			      unsigned long long *start_ts)
+
+{
+	unsigned long long ts;
+	struct entry *entry;
+	int ret;
+
+	if (!teval->tdelta)
+		return -1;
+
+	teval = teval->tdelta->teval;
+
+	ret = _teval_get_entry(teval, keys, &entry);
+	if (ret <= 0)
+		return ret;
+
+	ts = TEVAL_TIMESTAMP(teval, entry->vals);
+	if (!ts)
+		return 0;
+
+	if (results)
+		*results = entry->vals;
+
+	if (delta)
+		*delta = timestamp - ts;
+
+	if (start_ts)
+		*start_ts = ts;
+
+	/* Clear the saved timestamp to allow continue to work again */
+	TEVAL_TIMESTAMP(teval, entry->vals) = 0;
+
+	return 1;
+}
diff --git a/src/eval-local.h b/src/eval-local.h
index fabb1a06e7df..a455daf39733 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -63,11 +63,19 @@ struct entry {
 	struct traceeval_stat	*val_stats;
 };
 
+enum {
+	TEVAL_FL_DELTA		= (1 << 0),
+};
+
+struct traceeval_delta;
+
 /* Histogram */
 struct traceeval {
 	struct traceeval_type		*key_types;
 	struct traceeval_type		*val_types;
 	struct hash_table		*hist;
+	struct traceeval_delta		*tdelta;
+	unsigned int			flags;
 	ssize_t				nr_key_types;
 	ssize_t				nr_val_types;
 	size_t				update_counter;
@@ -89,6 +97,12 @@ struct traceeval_iterator {
 	bool				needs_sort;
 };
 
+extern int _teval_get_entry(struct traceeval *teval, const struct traceeval_data *keys,
+			    struct entry **result);
+
+extern void _teval_update_stat(struct traceeval_type *type, struct traceeval_stat *stat,
+			       unsigned long long val, unsigned long long ts);
+
 extern struct hash_table *hash_alloc(void);
 extern void hash_free(struct hash_table *hash);
 extern void hash_add(struct hash_table *hash, struct hash_item *item, unsigned key);
@@ -100,6 +114,8 @@ extern struct hash_item *hash_iter_next(struct hash_iter *iter);
 extern struct hash_iter *hash_iter_bucket(struct hash_table *hash, unsigned key);
 extern struct hash_item *hash_iter_bucket_next(struct hash_iter *iter);
 
+extern void __delta_release(struct traceeval_delta *tdelta);
+
 static inline size_t hash_nr_items(struct hash_table *hash)
 {
 	return hash->nr_items;
@@ -117,6 +133,10 @@ static inline unsigned long long hash_string(const char *str)
 	return key;
 }
 
+int _teval_insert(struct traceeval *teval,
+		  const struct traceeval_data *keys, size_t nr_keys,
+		  const struct traceeval_data *vals, size_t nr_vals);
+
  /*
  * This is a quick hashing function adapted from Donald E. Knuth's 32
  * bit multiplicative hash. See The Art of Computer Programming (TAOCP).
diff --git a/src/histograms.c b/src/histograms.c
index ea938cee9254..0377be00d1c1 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -498,8 +498,8 @@ static unsigned make_hash(struct traceeval *teval, const struct traceeval_data *
  *
  * Returns 1 on success, 0 if no match found, -1 on error.
  */
-static int get_entry(struct traceeval *teval, const struct traceeval_data *keys,
-		     struct entry **result)
+__hidden int _teval_get_entry(struct traceeval *teval, const struct traceeval_data *keys,
+			      struct entry **result)
 {
 	struct hash_table *hist = teval->hist;
 	struct entry *entry = NULL;
@@ -533,6 +533,43 @@ static int get_entry(struct traceeval *teval, const struct traceeval_data *keys,
 	return check;
 }
 
+__hidden void _teval_update_stat(struct traceeval_type *type,
+				 struct traceeval_stat *stat,
+				 unsigned long long val,
+				 unsigned long long ts)
+{
+	if (!stat->count++) {
+		stat->max = val;
+		stat->min = val;
+		stat->max_ts = ts;
+		stat->min_ts = ts;
+		stat->total = val;
+		return;
+	}
+
+	if (type->flags & TRACEEVAL_FL_SIGNED) {
+		if ((long long)stat->max < (long long)val) {
+			stat->max = val;
+			stat->max_ts = ts;
+		}
+		if ((long long)stat->min > (long long)val) {
+			stat->min = val;
+			stat->min_ts = ts;
+		}
+		stat->total += (long long)val;
+	} else {
+		if (stat->max < val) {
+			stat->max_ts = ts;
+			stat->max = val;
+		}
+		if (stat->min > val) {
+			stat->min = val;
+			stat->min_ts = ts;
+		}
+		stat->total += val;
+	}
+}
+
 static bool is_stat_type(struct traceeval_type *type)
 {
 	/* Only value numbers have stats */
@@ -632,36 +669,7 @@ static int copy_traceeval_data(struct traceeval_type *type,
 	if (!stat || !is_stat_type(type))
 		return 0;
 
-	if (!stat->count++) {
-		stat->max = val;
-		stat->min = val;
-		stat->max_ts = ts;
-		stat->min_ts = ts;
-		stat->total = val;
-		return 0;
-	}
-
-	if (type->flags & TRACEEVAL_FL_SIGNED) {
-		if ((long long)stat->max < (long long)val) {
-			stat->max = val;
-			stat->max_ts = ts;
-		}
-		if ((long long)stat->min > (long long)val) {
-			stat->min = val;
-			stat->min_ts = ts;
-		}
-		stat->total += (long long)val;
-	} else {
-		if (stat->max < val) {
-			stat->max_ts = ts;
-			stat->max = val;
-		}
-		if (stat->min > val) {
-			stat->min = val;
-			stat->min_ts = ts;
-		}
-		stat->total += val;
-	}
+	_teval_update_stat(type, stat, val, ts);
 
 	return 0;
 }
@@ -757,7 +765,7 @@ int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *k
 		return -1;
 
 	/* find key and copy its corresponding value pair */
-	if ((check = get_entry(teval, keys, &entry)) < 1)
+	if ((check = _teval_get_entry(teval, keys, &entry)) < 1)
 		return check;
 
 	*results = entry->vals;
@@ -812,7 +820,7 @@ static unsigned long long get_timestamp(struct traceeval *teval,
 /*
  * Create a new entry in @teval with respect to @keys and @vals.
  *
- * Returns 0 on success, -1 on error.
+ * Returns 0 on success, -1 on error
  */
 static int create_entry(struct traceeval *teval,
 			const struct traceeval_data *keys,
@@ -943,7 +951,7 @@ struct traceeval_stat *traceeval_stat_size(struct traceeval *teval,
 	if (!is_stat_type(type))
 		return NULL;
 
-	ret = get_entry(teval, keys, &entry);
+	ret = _teval_get_entry(teval, keys, &entry);
 	if (ret <= 0)
 		return NULL;
 
@@ -1026,6 +1034,32 @@ unsigned long long traceeval_stat_count(struct traceeval_stat *stat)
 	return stat->count;
 }
 
+__hidden int _teval_insert(struct traceeval *teval,
+			   const struct traceeval_data *keys, size_t nr_keys,
+			   const struct traceeval_data *vals, size_t nr_vals)
+{
+	struct entry *entry;
+	int check;
+	int i;
+
+	entry = NULL;
+	check = _teval_get_entry(teval, keys, &entry);
+
+	for (i = 0; i < nr_vals; i++) {
+		if (vals[i].type != teval->val_types[i].type)
+			return -1;
+	}
+
+	if (check == -1)
+		return check;
+
+	/* insert key-value pair */
+	if (check == 0)
+		return create_entry(teval, keys, vals);
+	else
+		return update_entry(teval, entry, vals);
+}
+
 /*
  * traceeval_insert - insert an item into the traceeval descriptor
  * @teval: The descriptor to insert into
@@ -1061,29 +1095,10 @@ int traceeval_insert_size(struct traceeval *teval,
 			  const struct traceeval_data *keys, size_t nr_keys,
 			  const struct traceeval_data *vals, size_t nr_vals)
 {
-	struct entry *entry;
-	int check;
-	int i;
-
 	if (nr_keys != teval->nr_key_types || nr_vals != teval->nr_val_types)
 		return -1;
 
-	entry = NULL;
-	check = get_entry(teval, keys, &entry);
-
-	for (i = 0; i < teval->nr_val_types; i++) {
-		if (vals[i].type != teval->val_types[i].type)
-			return -1;
-	}
-
-	if (check == -1)
-		return check;
-
-	/* insert key-value pair */
-	if (check == 0)
-		return create_entry(teval, keys, vals);
-	else
-		return update_entry(teval, entry, vals);
+	return _teval_insert(teval, keys, nr_keys, vals, nr_vals);
 }
 
 /**
@@ -1110,7 +1125,7 @@ int traceeval_remove_size(struct traceeval *teval,
 		return -1;
 
 	entry = NULL;
-	check = get_entry(teval, keys, &entry);
+	check = _teval_get_entry(teval, keys, &entry);
 
 	if (check < 1)
 		return check;
-- 
2.40.1

