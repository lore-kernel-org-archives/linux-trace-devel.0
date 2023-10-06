Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D25139B
	for <linux-trace-devel@vger.kernel.org>; Fri,  6 Oct 2023 02:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17041C433C8;
	Fri,  6 Oct 2023 02:25:56 +0000 (UTC)
Date: Thu, 5 Oct 2023 22:27:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>, Stevie Alvarez 
 <stevie.6strings@gmail.com>
Subject: [PATCH] libtraceeval: Add traceeval_data_start/continue/stop() API
Message-ID: <20231005222705.09a69c6e@gandalf.local.home>
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

The first iteration of libtraceeval sought out to facilitate timings
between events. For instance, the time between waking up and scheduling in
of a task (the wake up latency). But that code API quickly became
unusable, as there were several use cases that did not need the timings,
and it was awkward using it.

The libtraceeval was redesigned to be simple histograms that could be
queried for the last instance, and easily have them be joined. This worked
well.

Now we can come up with a new descriptor that automatically combines two
histograms to create that original idea of easily recording the delta
between events. This new descriptor is called a traceeval_delta.

A traceeval_delta is simply a traceeval with two extra values.

 1. A timestamp value
 2. A delta value

It has the same type of APIs as a traceeval has:

 * traceeval_delta_init()
 * traceeval_delta_release()
 * traceeval_delta_insert()
 * traceeval_delta_query()

But now has:

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

Some extra functions are added like traceeval_delta_teval_get() to get
the traceeval descriptor that it uses. traceeval_delta_stat() returns the
traceeval_delta_stat for the delta value, and
traceeval_iterator_delta_stat() does the same thing but for the iterator
instance.

The two sample programs, task-eval.c and wakeup-lat.c were updated to use
this and it greatly simplifies the code.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval.h |  78 +++++++++
 samples/task-eval.c | 221 +++++++----------------
 samples/wake-lat.c  |  70 ++------
 src/Makefile        |   1 +
 src/delta.c         | 418 ++++++++++++++++++++++++++++++++++++++++++++
 src/eval-local.h    |  15 ++
 src/histograms.c    | 159 +++++++++--------
 7 files changed, 678 insertions(+), 284 deletions(-)
 create mode 100644 src/delta.c

diff --git a/include/traceeval.h b/include/traceeval.h
index d8095ba5c1a1..f332aec289fc 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -234,6 +234,83 @@ void traceeval_results_release(struct traceeval *teval,
 
 size_t traceeval_count(struct traceeval *teval);
 
+struct traceeval_delta;
+
+#define traceeval_delta_init(keys, vals)				\
+	traceeval_delta_init_size(keys, vals,				\
+				  TRACEEVAL_ARRAY_SIZE(keys),		\
+				  TRACEEVAL_ARRAY_SIZE(vals))
+
+#define traceeval_delta_init_size(keys, vals, nr_keys, nr_vals)		\
+	traceeval_delta_init_data_size(keys, vals, nr_keys, nr_vals,	\
+				       sizeof(struct traceeval_type),	\
+				       sizeof(struct traceeval_data))
+
+struct traceeval_delta *traceeval_delta_init_data_size(struct traceeval_type *keys,
+						       struct traceeval_type *vals,
+						       size_t nr_keys, size_t nr_vals,
+						       size_t sizeof_type,
+						       size_t sizeof_data);
+
+void traceeval_delta_release(struct traceeval_delta *tdelta);
+
+int traceeval_delta_insert_size(struct traceeval_delta *tdelta,
+				const struct traceeval_data *keys, size_t nr_keys,
+				const struct traceeval_data *vals, size_t nr_vals);
+
+#define traceeval_delta_insert(teval, keys, vals)			\
+	traceeval_delta_insert_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), \
+				    vals, TRACEEVAL_ARRAY_SIZE(vals))
+
+#define traceeval_delta_remove(teval, keys)				\
+	traceeval_delta_remove_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys))
+
+int traceeval_delta_remove_size(struct traceeval_delta *tdelta,
+				const struct traceeval_data *keys, size_t nr_keys);
+
+int traceeval_delta_query_size(struct traceeval_delta *tdelta,
+			       const struct traceeval_data *keys,
+			       size_t nr_keys, const struct traceeval_data **results);
+
+#define traceeval_delta_query(teval, keys, results)			\
+	traceeval_delta_query_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), results)
+
+int traceeval_delta_start_size(struct traceeval_delta *tdelta,
+			       const struct traceeval_data *keys, size_t nr_keys,
+			       unsigned long long timestamp);
+
+#define traceeval_delta_start(teval, keys, timestamp)			\
+	traceeval_delta_start_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), timestamp)
+
+int traceeval_delta_continue_size(struct traceeval_delta *tdelta,
+				  const struct traceeval_data *keys, size_t nr_keys,
+				  unsigned long long timestamp);
+
+#define traceeval_delta_continue(teval, keys, timestamp)		\
+	traceeval_delta_continue_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), timestamp)
+
+int traceeval_delta_stop_size(struct traceeval_delta *tdelta,
+			      const struct traceeval_data *keys, size_t nr_keys,
+			      unsigned long long timestamp);
+
+#define traceeval_delta_stop(teval, keys, timestamp)			\
+	traceeval_delta_stop_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), timestamp)
+
+void traceeval_delta_results_release(struct traceeval_delta *tdelta,
+				     const struct traceeval_data *results);
+
+#define traceeval_delta_stat(teval, keys)				\
+	traceeval_delta_stat_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys))
+
+struct traceeval_stat *traceeval_delta_stat_size(struct traceeval_delta *tdelta,
+						 const struct traceeval_data *keys,
+						 size_t nr_keys);
+
+struct traceeval *traceeval_delta_teval_get(struct traceeval_delta *tdelta);
+
+void traceeval_delta_teval_put(struct traceeval_delta *tdelta,
+			       struct traceeval *teval);
+
 #define traceeval_stat(teval, keys, val_name)				\
 	traceeval_stat_size(teval, keys, TRACEEVAL_ARRAY_SIZE(keys), val_name)
 
@@ -265,6 +342,7 @@ void traceeval_iterator_results_release(struct traceeval_iterator *iter,
 					const struct traceeval_data *results);
 struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
 					       const char *val_name);
+struct traceeval_stat *traceeval_iterator_delta_stat(struct traceeval_iterator *iter);
 int traceeval_iterator_remove(struct traceeval_iterator *iter);
 
 #endif /* __LIBTRACEEVAL_HIST_H__ */
diff --git a/samples/task-eval.c b/samples/task-eval.c
index 3808212e2e84..bbb9b2a9db6a 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -120,22 +120,6 @@ static struct traceeval_type thread_keys[] = {
 	},
 };
 
-static struct traceeval_type timestamp_vals[] = {
-	{
-		.type = TRACEEVAL_TYPE_NUMBER_64,
-		.name = "Timestamp",
-		.flags = TRACEEVAL_FL_TIMESTAMP,
-	},
-};
-
-static struct traceeval_type delta_vals[] = {
-	{
-		.type	= TRACEEVAL_TYPE_NUMBER_64,
-		.name	= "delta",
-		.flags = TRACEEVAL_FL_STAT,
-	},
-};
-
 enum sched_state {
 	RUNNING,
 	BLOCKED,
@@ -145,21 +129,16 @@ enum sched_state {
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
+	struct traceeval_delta	*teval_cpus;
+	struct traceeval_delta	*teval_threads;
 	char			*comm;
 	int			state;
 };
 
 struct task_data {
-	struct teval_pair	teval_cpus;
-	struct teval_pair	teval_processes;
+	struct traceeval_delta	*teval_cpus;
+	struct traceeval_delta	*teval_processes;
 	struct traceeval	*teval_processes_data;
 	char			*comm;
 };
@@ -177,43 +156,20 @@ static void update_process(struct task_data *tdata, const char *comm,
 		DEFINE_TRACEEVAL_CSTRING(	comm	),
 		DEFINE_TRACEEVAL_NUMBER(	state	),
 	};
-	struct traceeval_data vals[] = {
-		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
-	};
-	struct traceeval_data new_vals[1] = { };
-	const struct traceeval_data *results;
 	int ret;
 
 	switch (cmd) {
 	case START:
-		ret = traceeval_insert(tdata->teval_processes.start, keys, vals);
+		ret = traceeval_delta_start(tdata->teval_processes, keys, ts);
 		if (ret < 0)
 			pdie("Could not start process");
 		return;
 	case STOP:
-		ret = traceeval_query(tdata->teval_processes.start, keys, &results);
-		if (ret < 0)
-			pdie("Could not query start process");
-		if (ret == 0)
-			return;
-		if (!results[0].number_64)
-			break;
-
-		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
-
-		ret = traceeval_insert(tdata->teval_processes.stop, keys, new_vals);
-		if (ret < 0)
-			pdie("Could not stop process");
-
-		/* Reset the start */
-		TRACEEVAL_SET_NUMBER_64(new_vals[0], 0);
-
-		ret = traceeval_insert(tdata->teval_processes.start, keys, new_vals);
+		ret = traceeval_delta_stop(tdata->teval_processes, keys, ts);
 		if (ret < 0)
 			pdie("Could not start CPU");
 		break;
 	}
-	traceeval_results_release(tdata->teval_processes.start, results);
 }
 
 static void start_process(struct task_data *tdata, const char *comm,
@@ -275,108 +231,62 @@ void set_process_data(struct task_data *tdata, const char *comm, void *data)
 	traceeval_results_release(tdata->teval_processes_data, results);
 }
 
-static void update_cpu(struct teval_pair *teval_pair, int cpu,
+static void update_cpu(struct traceeval_delta *tdelta, int cpu,
 		       enum sched_state state, enum command cmd,
 		       unsigned long long ts)
 {
-	const struct traceeval_data *results;
 	struct traceeval_data keys[] = {
 		DEFINE_TRACEEVAL_NUMBER(	cpu	),
 		DEFINE_TRACEEVAL_NUMBER(	state	),
 	};
-	struct traceeval_data vals[] = {
-		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
-	};
-	struct traceeval_data new_vals[1] = { };
 	int ret;
 
 	switch (cmd) {
 	case START:
-		/* Only set if the timestamp is zero (or doesn't exist) */
-		ret = traceeval_query(teval_pair->start, keys, &results);
-		if (ret > 0) {
-			if (results[0].number_64)
-				break;
-		}
-		if (ret < 0)
-			pdie("Could not query cpu start data");
-		ret = traceeval_insert(teval_pair->start, keys, vals);
+		ret = traceeval_delta_continue(tdelta, keys, ts);
 		if (ret < 0)
 			pdie("Could not start CPU");
 		break;
 	case STOP:
-		ret = traceeval_query(teval_pair->start, keys, &results);
-		if (ret < 0)
-			pdie("Could not query cpu stop data");
-		if (ret == 0)
-			return;
-
-		if (!results[0].number_64)
-			break;
-
-		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
-
-		ret = traceeval_insert(teval_pair->stop, keys, new_vals);
+		ret = traceeval_delta_stop(tdelta, keys, ts);
 		if (ret < 0)
 			pdie("Could not stop CPU");
-
-		/* Reset the start */
-		TRACEEVAL_SET_NUMBER_64(new_vals[0], 0);
-		ret = traceeval_insert(teval_pair->start, keys, new_vals);
-		if (ret < 0)
-			pdie("Could not start CPU");
-
 		break;
-		default:
-			return;
+	default:
+		return;
 	}
-	traceeval_results_release(teval_pair->start, results);
 }
 
-static void start_cpu(struct teval_pair *teval_pair, int cpu,
+static void start_cpu(struct traceeval_delta *tdelta, int cpu,
 		      enum sched_state state,  unsigned long long ts)
 {
-	update_cpu(teval_pair, cpu, state, START, ts);
+	update_cpu(tdelta, cpu, state, START, ts);
 }
 
-static void stop_cpu(struct teval_pair *teval_pair, int cpu,
+static void stop_cpu(struct traceeval_delta *tdelta, int cpu,
 		     enum sched_state state, unsigned long long ts)
 {
-	update_cpu(teval_pair, cpu, state, STOP, ts);
+	update_cpu(tdelta, cpu, state, STOP, ts);
 }
 
 static void update_thread(struct process_data *pdata, int tid,
 			  enum sched_state state, enum command cmd,
 			  unsigned long long ts)
 {
-	const struct traceeval_data *results;
 	struct traceeval_data keys[] = {
 		DEFINE_TRACEEVAL_NUMBER(	tid	),
 		DEFINE_TRACEEVAL_NUMBER(	state	),
 	};
-	struct traceeval_data vals[] = {
-		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
-	};
-	struct traceeval_data new_vals[1] = { };
 	int ret;
 
 	switch (cmd) {
 	case START:
-		ret = traceeval_insert(pdata->teval_threads.start, keys, vals);
+		ret = traceeval_delta_start(pdata->teval_threads, keys, ts);
 		if (ret < 0)
 			pdie("Could not start thread");
 		return;
 	case STOP:
-		ret = traceeval_query(pdata->teval_threads.start, keys, &results);
-		if (ret < 0)
-			pdie("Could not query thread start");
-		if (ret == 0)
-			return;
-
-		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
-
-		ret = traceeval_insert(pdata->teval_threads.stop, keys, new_vals);
-		traceeval_results_release(pdata->teval_threads.start, results);
+		ret = traceeval_delta_stop(pdata->teval_threads, keys, ts);
 		if (ret < 0)
 			pdie("Could not stop thread");
 		return;
@@ -409,20 +319,12 @@ static struct tep_format_field *get_field(struct tep_event *event, const char *n
 
 static void init_process_data(struct process_data *pdata)
 {
-
-	pdata->teval_cpus.start = traceeval_init(cpu_keys, timestamp_vals);
-	if (!pdata->teval_cpus.start)
-		pdie("Creating trace eval cpus start");
-	pdata->teval_cpus.stop = traceeval_init(cpu_keys, delta_vals);
-	if (!pdata->teval_cpus.stop)
+	pdata->teval_cpus = traceeval_delta_init(cpu_keys, NULL);
+	if (!pdata->teval_cpus)
 		pdie("Creating trace eval cpus");
 
-	pdata->teval_threads.start = traceeval_init(thread_keys, timestamp_vals);
-	if (!pdata->teval_threads.start)
-		pdie("Creating trace eval threads start");
-
-	pdata->teval_threads.stop = traceeval_init(thread_keys, delta_vals);
-	if (!pdata->teval_threads.stop)
+	pdata->teval_threads = traceeval_delta_init(thread_keys, NULL);
+	if (!pdata->teval_threads)
 		pdie("Creating trace eval threads");
 }
 
@@ -457,7 +359,7 @@ static void sched_out(struct task_data *tdata, const char *comm,
 	pid = val;
 	if (!pid) {
 		/* Record the runtime for the process CPUs */
-		stop_cpu(&tdata->teval_cpus, record->cpu, IDLE, record->ts);
+		stop_cpu(tdata->teval_cpus, record->cpu, IDLE, record->ts);
 		return;
 	}
 
@@ -494,10 +396,10 @@ static void sched_out(struct task_data *tdata, const char *comm,
 	start_thread(pdata, pid, pdata->state, record->ts);
 
 	/* Record the runtime for the process CPUs */
-	stop_cpu(&pdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	stop_cpu(pdata->teval_cpus, record->cpu, RUNNING, record->ts);
 
 	/* Record the runtime for the all CPUs */
-	stop_cpu(&tdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	stop_cpu(tdata->teval_cpus, record->cpu, RUNNING, record->ts);
 }
 
 static void sched_in(struct task_data *tdata, const char *comm,
@@ -518,7 +420,7 @@ static void sched_in(struct task_data *tdata, const char *comm,
 	/* Ignore the idle task */
 	if (!pid) {
 		/* Record the runtime for the process CPUs */
-		start_cpu(&tdata->teval_cpus, record->cpu, IDLE, record->ts);
+		start_cpu(tdata->teval_cpus, record->cpu, IDLE, record->ts);
 		return;
 	}
 
@@ -528,7 +430,7 @@ static void sched_in(struct task_data *tdata, const char *comm,
 	pdata = get_process_data(tdata, comm);
 
 	/* Start recording the running time of process CPUs */
-	start_cpu(&tdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	start_cpu(tdata->teval_cpus, record->cpu, RUNNING, record->ts);
 
 	/* If there was no pdata, then this process did not go through sched out */
 	if (!pdata) {
@@ -540,7 +442,7 @@ static void sched_in(struct task_data *tdata, const char *comm,
 	start_thread(pdata, pid, RUNNING, record->ts);
 
 	/* Start recording the running time of process CPUs */
-	start_cpu(&pdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	start_cpu(pdata->teval_cpus, record->cpu, RUNNING, record->ts);
 
 	/* If it was just created, there's nothing to stop */
 	if (is_new)
@@ -603,14 +505,14 @@ static void print_microseconds(int idx, unsigned long long nsecs)
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
+	struct traceeval_delta *tdelta = data;
 	struct traceeval_data keysA[] = {
 		DEFINE_TRACEEVAL_CSTRING(	Akeys[0].cstring	),
 		DEFINE_TRACEEVAL_NUMBER(	RUNNING			), };
@@ -631,11 +533,11 @@ static int compare_pdata(struct traceeval *teval_data,
 	}
 
 	/* Get the RUNNING values for both processes */
-	statA = traceeval_stat(teval, keysA, delta_vals[0].name);
+	statA = traceeval_delta_stat(tdelta, keysA);
 	if (statA)
 		totalA = traceeval_stat_total(statA);
 
-	statB = traceeval_stat(teval, keysB, delta_vals[0].name);
+	statB = traceeval_delta_stat(tdelta, keysB);
 	if (statB)
 		totalB = traceeval_stat_total(statB);
 
@@ -647,8 +549,9 @@ static int compare_pdata(struct traceeval *teval_data,
 	return strcmp(Bkeys[0].cstring, Akeys[0].cstring);
 }
 
-static void display_cpus(struct traceeval *teval)
+static void display_cpus(struct traceeval_delta *tdelta)
 {
+	struct traceeval *teval = traceeval_delta_teval_get(tdelta);
 	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
 	const struct traceeval_data *keys;
 	struct traceeval_stat *stat;
@@ -666,7 +569,7 @@ static void display_cpus(struct traceeval *teval)
 		int state = keys[1].number;
 		int cpu = keys[0].number;
 
-		stat = traceeval_iterator_stat(iter, delta_vals[0].name);
+		stat = traceeval_iterator_delta_stat(iter);
 		if (!stat)
 			continue; // die?
 
@@ -696,6 +599,7 @@ static void display_cpus(struct traceeval *teval)
 	if (last_cpu < 0)
 		die("No result for CPUs\n");
 
+	traceeval_delta_teval_put(tdelta, teval);
 }
 
 static void display_state_times(int state, unsigned long long total)
@@ -719,8 +623,9 @@ static void display_state_times(int state, unsigned long long total)
 	}
 }
 
-static void display_threads(struct traceeval *teval)
+static void display_threads(struct traceeval_delta *tdelta)
 {
+	struct traceeval *teval = traceeval_delta_teval_get(tdelta);
 	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
 	const struct traceeval_data *keys;
 	struct traceeval_stat *stat;
@@ -733,7 +638,7 @@ static void display_threads(struct traceeval *teval)
 		int state = keys[1].number;
 		int tid = keys[0].number;
 
-		stat = traceeval_iterator_stat(iter, delta_vals[0].name);
+		stat = traceeval_iterator_delta_stat(iter);
 		if (!stat)
 			continue; // die?
 
@@ -748,16 +653,17 @@ static void display_threads(struct traceeval *teval)
 	if (last_tid < 0)
 		die("No result for threads\n");
 
+	traceeval_delta_teval_put(tdelta, teval);
 }
 
 static void display_process(struct process_data *pdata)
 {
-	display_threads(pdata->teval_threads.stop);
-	display_cpus(pdata->teval_cpus.stop);
+	display_threads(pdata->teval_threads);
+	display_cpus(pdata->teval_cpus);
 	printf("\n");
 }
 
-static void display_process_stats(struct traceeval *teval,
+static void display_process_stats(struct traceeval_delta *tdelta,
 				  struct process_data *pdata, const char *comm)
 {
 	struct traceeval_stat *stat;
@@ -771,21 +677,22 @@ static void display_process_stats(struct traceeval *teval,
 		TRACEEVAL_SET_NUMBER(keys[1], i);
 
 		delta = 0;
-		stat = traceeval_stat(teval, keys, delta_vals[0].name);
+		stat = traceeval_delta_stat(tdelta, keys);
 		if (stat)
 			delta = traceeval_stat_total(stat);
 		display_state_times(i, delta);
 	}
 }
 
-static void display_processes(struct traceeval *teval,
+static void display_processes(struct traceeval_delta *tdelta,
 			      struct traceeval *teval_data)
 {
+	struct traceeval *teval = traceeval_delta_teval_get(tdelta);
 	struct traceeval_iterator *iter = traceeval_iterator_get(teval_data);
 	const struct traceeval_data *keys;
 	int ret;
 
-	traceeval_iterator_sort_custom(iter, compare_pdata, teval);
+	traceeval_iterator_sort_custom(iter, compare_pdata, tdelta);
 
 	while (traceeval_iterator_next(iter, &keys) > 0) {
 		const struct traceeval_data *results;
@@ -799,19 +706,21 @@ static void display_processes(struct traceeval *teval,
 			continue; /* ?? */
 
 		pdata = results[0].pointer;
-		traceeval_results_release(teval_data, results);
+		traceeval_results_release(teval, results);
 
 		printf("Task: %s\n", comm);
 
-		display_process_stats(teval, pdata, comm);
+		display_process_stats(tdelta, pdata, comm);
 		if (pdata)
 			display_process(pdata);
 	}
+
+	traceeval_delta_teval_put(tdelta, teval);
 }
 
 static void display(struct task_data *tdata)
 {
-	struct traceeval *teval = tdata->teval_cpus.stop;
+	struct traceeval *teval = traceeval_delta_teval_get(tdata->teval_cpus);
 	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
 	const struct traceeval_data *keys;
 	struct traceeval_stat *stat;
@@ -819,7 +728,7 @@ static void display(struct task_data *tdata)
 	unsigned long long idle_time = 0;
 
 	if (tdata->comm) {
-		return display_processes(tdata->teval_processes.stop,
+		return display_processes(tdata->teval_processes,
 					 tdata->teval_processes_data);
 	}
 
@@ -831,7 +740,7 @@ static void display(struct task_data *tdata)
 	while (traceeval_iterator_next(iter, &keys) > 0) {
 		int state = keys[1].number;
 
-		stat = traceeval_iterator_stat(iter, delta_vals[0].name);
+		stat = traceeval_iterator_delta_stat(iter);
 		if (!stat)
 			continue;
 
@@ -852,10 +761,12 @@ static void display(struct task_data *tdata)
 	printf("  Total idle time (us):");
 	print_microseconds(16, idle_time);
 
-	display_cpus(tdata->teval_cpus.stop);
+	display_cpus(tdata->teval_cpus);
 
 	printf("\n");
-	display_processes(tdata->teval_processes.stop, tdata->teval_processes_data);
+	display_processes(tdata->teval_processes, tdata->teval_processes_data);
+
+	traceeval_delta_teval_put(tdata->teval_cpus, teval);
 }
 
 static void free_tdata(struct task_data *tdata)
@@ -893,21 +804,15 @@ int main (int argc, char **argv)
 	if (!handle)
 		pdie("Error opening %s", argv[0]);
 
-	data.teval_processes.start = traceeval_init(process_keys, timestamp_vals);
-	if (!data.teval_processes.start)
-		pdie("Creating trace eval start");
+	data.teval_processes = traceeval_delta_init(process_keys, NULL);
+	if (!data.teval_processes)
+		pdie("Creating trace eval processes");
 	data.teval_processes_data = traceeval_init(process_keys, process_data_vals);
 	if (!data.teval_processes_data)
-		pdie("Creating trace eval data");
-	data.teval_processes.stop = traceeval_init(process_keys, delta_vals);
-	if (!data.teval_processes.stop)
-		pdie("Creating trace eval");
+		pdie("Creating trace eval processe data");
 
-	data.teval_cpus.start = traceeval_init(cpu_keys, timestamp_vals);
-	if (!data.teval_cpus.start)
-		pdie("Creating trace eval");
-	data.teval_cpus.stop = traceeval_init(cpu_keys, delta_vals);
-	if (!data.teval_cpus.stop)
+	data.teval_cpus = traceeval_delta_init(cpu_keys, NULL);
+	if (!data.teval_cpus)
 		pdie("Creating trace eval");
 
 	tracecmd_follow_event(handle, "sched", "sched_switch", switch_func, &data);
diff --git a/samples/wake-lat.c b/samples/wake-lat.c
index 0a6fcc909fba..8dc49e0b4064 100644
--- a/samples/wake-lat.c
+++ b/samples/wake-lat.c
@@ -4,26 +4,10 @@
 #include <traceeval.h>
 
 struct data {
-	struct traceeval		*teval_wakeup;
-	struct traceeval		*teval_sched;
+	struct traceeval_delta		*tdelta;
 };
 
 struct traceeval_type wakeup_keys[] = {
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
-
-struct traceeval_type sched_keys[] = {
 	{
 		.name		= "COMM",
 		.type		= TRACEEVAL_TYPE_STRING,
@@ -34,39 +18,28 @@ struct traceeval_type sched_keys[] = {
 	}
 };
 
-struct traceeval_type sched_vals[] = {
-	{
-		.name		= "timestamp",
-		.flags		= TRACEEVAL_FL_TIMESTAMP,
-		.type		= TRACEEVAL_TYPE_NUMBER_64,
-	},
-	{
-		.name		= "delta",
-		.flags		= TRACEEVAL_FL_STAT,
-		.type		= TRACEEVAL_TYPE_NUMBER_64,
-	}
-};
-
 static int wakeup_callback(struct tracecmd_input *handle, struct tep_event *event,
 			   struct tep_record *record, int cpu, void *d)
 {
+	static struct tep_format_field *comm_field;
 	static struct tep_format_field *pid_field;
 	struct data *data = d;
 	unsigned long long val;
 	long pid;
-	struct traceeval_data keys[1];
-	struct traceeval_data vals[1];
+	struct traceeval_data keys[2];
 
-	if (!pid_field)
+	if (!pid_field) {
 		pid_field = tep_find_field(event, "pid");
+		comm_field = tep_find_field(event, "comm");
+	}
 
 	tep_read_number_field(pid_field, record->data, &val);
 	pid = val;
 
-	TRACEEVAL_SET_NUMBER(keys[0], pid);
-	TRACEEVAL_SET_NUMBER_64(vals[0], record->ts);
+	TRACEEVAL_SET_CSTRING(keys[0], record->data + comm_field->offset);
+	TRACEEVAL_SET_NUMBER(keys[1], pid);
 
-	traceeval_insert(data->teval_wakeup, keys, vals);
+	traceeval_delta_start(data->tdelta, keys, record->ts);
 
 	return 0;
 }
@@ -77,13 +50,9 @@ static int sched_callback(struct tracecmd_input *handle, struct tep_event *event
 	static struct tep_format_field *next_pid_field;
 	static struct tep_format_field *next_comm_field;
 	struct data *data = d;
-	unsigned long long delta;
 	unsigned long long val;
 	long pid;
-	struct traceeval_data wakeup_keys[1];
 	struct traceeval_data keys[2];
-	struct traceeval_data vals[2];
-	const struct traceeval_data *results;
 
 	if (!next_pid_field) {
 		next_pid_field = tep_find_field(event, "next_pid");
@@ -93,28 +62,18 @@ static int sched_callback(struct tracecmd_input *handle, struct tep_event *event
 	tep_read_number_field(next_pid_field, record->data, &val);
 	pid = val;
 
-	TRACEEVAL_SET_NUMBER(wakeup_keys[0], pid);
-
-	if (traceeval_query(data->teval_wakeup, wakeup_keys, &results) <= 0)
-		return 0;
-
-	delta = record->ts - results[0].number_64;
-	traceeval_results_release(data->teval_wakeup, results);
-
 	TRACEEVAL_SET_CSTRING(keys[0], record->data + next_comm_field->offset);
 	TRACEEVAL_SET_NUMBER(keys[1], pid);
 
-	TRACEEVAL_SET_NUMBER_64(vals[0], record->ts);
-	TRACEEVAL_SET_NUMBER_64(vals[1], delta);
-
-	traceeval_insert(data->teval_sched, keys, vals);
+	traceeval_delta_stop(data->tdelta, keys, record->ts);
 
 	return 0;
 }
 
 static void show_latency(struct data *data)
 {
-	struct traceeval_iterator *iter = traceeval_iterator_get(data->teval_sched);
+	struct traceeval *teval = traceeval_delta_teval_get(data->tdelta);
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
 	const struct traceeval_data *keys;
 
 	printf("\n");
@@ -123,7 +82,7 @@ static void show_latency(struct data *data)
 		unsigned long long val;
 		unsigned long long ts;
 
-		stat = traceeval_iterator_stat(iter, sched_vals[1].name);
+		stat = traceeval_iterator_delta_stat(iter);
 		if (!stat)
 			continue;
 
@@ -151,8 +110,7 @@ int main (int argc, char **argv)
 		exit(-1);
 	}
 
-	data.teval_wakeup = traceeval_init(wakeup_keys, wakeup_vals);
-	data.teval_sched = traceeval_init(sched_keys, sched_vals);
+	data.tdelta = traceeval_delta_init(wakeup_keys, NULL);
 
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
index 000000000000..ee042a222ea5
--- /dev/null
+++ b/src/delta.c
@@ -0,0 +1,418 @@
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
+enum {
+	DELTA_SUB		= 1,
+	TIMESTAMP_SUB		= 2,
+};
+
+#define OFFSET_ADD		TIMESTAMP_SUB
+
+#define TEVAL_DELTA_IDX(teval)		((teval)->nr_val_types - DELTA_SUB)
+#define TEVAL_TIMESTAMP_IDX(teval)	((teval)->nr_val_types - TIMESTAMP_SUB)
+
+/* Get to the delta value */
+#define TEVAL_DELTA(teval, val)		(val)[TEVAL_DELTA_IDX(teval)].number_64
+
+/* Get to the timestamp value */
+#define TEVAL_TIMESTAMP(teval, val)	(val)[TEVAL_TIMESTAMP_IDX(teval)].number_64
+
+#define TEVAL_TIMESTAMP_NAME	"__TRACEEVAL_TIMESTAMP__"
+#define TEVAL_DELTA_NAME	"__TRACEEVAL_DELTA__"
+
+/**
+ * traceeval_delta_init_data_size - create a traceeval_delta descriptor
+ * @keys: Defines the keys to differentiate traceeval entries
+ * @vals: Defines values attached to entries differentiated by @keys.
+ * @nr_keys: The number of @keys passed in
+ * @nr_vals: The number of @vals passed in
+ * @sizeof_type: The size of struct traceeval_type
+ * @sizeof_data: The size of struct traceeval_data
+ *
+ * This works similar to a normal traceeval type, but it adds a way to have
+ * a start and stop to the traceeval so that it takes care of the calculations
+ * of the timestamps.
+ *
+ * Returns a pointer to a newly allocated traceeval_delta descriptor (that
+ * must be freed with traceeval_delta_release() on success, or NULL on error.
+ */
+struct traceeval_delta *traceeval_delta_init_data_size(struct traceeval_type *keys,
+						       struct traceeval_type *vals,
+						       size_t nr_keys,
+						       size_t nr_vals,
+						       size_t sizeof_type,
+						       size_t sizeof_data)
+{
+	struct traceeval_type *delta_vals;
+	struct traceeval_type *val;
+	struct traceeval_delta *tdelta;
+	int i;
+
+	tdelta = calloc(1, sizeof(*tdelta));
+	if (!tdelta)
+		return NULL;
+
+	if (vals) {
+		for (i = 0; i < nr_vals && vals[i].type != TRACEEVAL_TYPE_NONE; i++)
+			;
+		nr_vals = i;
+	} else {
+		nr_vals = 0;
+	}
+
+	/* Copy the vals and add the TIMESTAMP and a delta at the end */
+	delta_vals = calloc(nr_vals + 2, sizeof(*delta_vals));
+	if (!delta_vals)
+		goto fail;
+
+	for (i = 0; i < nr_vals; i++)
+		delta_vals[i] = vals[i];
+
+	/* Append the timestamp and delta values */
+	val = &delta_vals[nr_vals++];
+	val->name = TEVAL_TIMESTAMP_NAME;
+	val->type = TRACEEVAL_TYPE_NUMBER_64;
+	val->flags = TRACEEVAL_FL_TIMESTAMP;
+
+	val = &delta_vals[nr_vals++];
+	val->name = TEVAL_DELTA_NAME;
+	val->type = TRACEEVAL_TYPE_NUMBER_64;
+	val->flags = TRACEEVAL_FL_STAT;
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
+	return tdelta;
+ fail:
+	free(tdelta);
+	return NULL;
+}
+
+/**
+ * traceeval_delta_release - release the resources of a traceeval_delta
+ * @tdelta: The traceeval_delta descriptor to release
+ *
+ * Frees all the resources created by traceeval_delta_init().
+ */
+void traceeval_delta_release(struct traceeval_delta *tdelta)
+{
+	if (!tdelta)
+		return;
+
+	traceeval_release(tdelta->teval);
+	free(tdelta);
+}
+
+/**
+ * traceeval_delta_insert_size - Insert a new item in a traceeval_delta
+ * @tdelta: The traceeval_delta descriptor
+ * @keys: The keys that are unique for the instance to insert
+ * @nr_keys: The number of @keys
+ * @vals: The values of the instance for the given @keys to insert
+ * @nr_vals: The number of @vals.
+ *
+ * This is just like traceeval_insert() but for a traceeval_delta descriptor.
+ *
+ * Returns 0 on success, and -1 on error.
+ */
+int traceeval_delta_insert_size(struct traceeval_delta *tdelta,
+				const struct traceeval_data *keys, size_t nr_keys,
+				const struct traceeval_data *vals, size_t nr_vals)
+{
+	struct traceeval *teval = tdelta->teval;
+
+	if (nr_keys != teval->nr_key_types ||
+	    nr_vals + OFFSET_ADD != teval->nr_val_types)
+		return -1;
+
+	return _teval_insert(teval, keys, nr_keys, vals, nr_vals);
+}
+
+/**
+ * traceeval_delta_remove - Remove an instance from a traceeval_delta
+ * @tdelta: The traceeval_delta descriptor
+ * @keys: The keys to find the matching element to remove
+ * @nr_keys: The number of @keys
+ *
+ * Returns 1 if it found and removed an item,
+ *         0 if it did not find an time matching @keys
+ *        -1 if there was an error.
+ */
+int traceeval_delta_remove_size(struct traceeval_delta *tdelta,
+				const struct traceeval_data *keys,
+				size_t nr_keys)
+{
+	return traceeval_remove_size(tdelta->teval, keys, nr_keys);
+}
+
+/*
+ * traceeval_delta_query - find the last instance defined by the keys
+ * @tdelta: The descriptor to search from
+ * @keys: A list of data to look for
+ * @results: A pointer to where to place the results (if found)
+ *
+ * This does a lookup for an instance within the traceeval_delta.
+ * The @keys is an array defined by the keys declared in traceeval_delta_init().
+ * The @keys will return an item that had the same keys when it was
+ * inserted by traceeval_delta_insert(). The @keys here follow the same rules
+ * as the keys for traceeval_delta_insert().
+ *
+ * Note, when the caller is done with @results, it must call
+ * traceeval_delta_results_release() on it.
+ *
+ * Returns 1 if found, 0 if not found, and -1 on error.
+ */
+int traceeval_delta_query_size(struct traceeval_delta *tdelta,
+			       const struct traceeval_data *keys,
+			       size_t nr_keys, const struct traceeval_data **results)
+{
+	return traceeval_query_size(tdelta->teval, keys, nr_keys, results);
+}
+
+static int delta_start(struct traceeval_delta *tdelta,
+		       const struct traceeval_data *keys, size_t nr_keys,
+		       unsigned long long timestamp, bool cont)
+{
+	struct traceeval *teval = tdelta->teval;
+	struct entry *entry;
+	size_t nr_vals;
+	int ret;
+
+	ret = _teval_get_entry(teval, keys, &entry);
+	if (ret < 0)
+		return ret;
+
+	if (ret) {
+		if (!cont || !TEVAL_TIMESTAMP(teval, entry->vals))
+			TEVAL_TIMESTAMP(teval, entry->vals) = timestamp;
+		return 1;
+	} else {
+		struct traceeval_data vals[teval->nr_val_types] = {};
+		int i;
+
+		for (i = 0; i < teval->nr_val_types; i++)
+			vals[i].type = teval->val_types[i].type;
+
+		TEVAL_TIMESTAMP(teval, vals) = timestamp;
+
+		/* Do not touch delta, otherwise the stats will be updated */
+		nr_vals = teval->nr_val_types - 1;
+		return _teval_insert(teval, keys, teval->nr_key_types,
+				     vals, nr_vals);
+	}
+}
+
+/*
+ * traceeval_delta_start - start the timings of a traceeval_delta
+ * @tdelta: The traceeval_delta descriptor
+ * @keys: The keys of the instance to start the timing for
+ * @nr_keys: The number of @keys
+ * @timestamp: The timestamp for the start of this instance
+ *
+ * The traceeval_delta is used to add start and stop times for the objects
+ * in the traceeval. This function denotes that the instance represented by
+ * @keys is in the process of "starting". The @timestamp is the start time.
+ * This should be matched by a corresponding traceeval_delta_stop().
+ *
+ * Returns 0 on succes and -1 on error.
+ */
+int traceeval_delta_start_size(struct traceeval_delta *tdelta,
+			       const struct traceeval_data *keys, size_t nr_keys,
+			       unsigned long long timestamp)
+{
+	return delta_start(tdelta, keys, nr_keys, timestamp, false);
+}
+
+/*
+ * traceeval_delta_continue - continue the timings of a traceeval_delta
+ * @tdelta: The traceeval_delta descriptor
+ * @keys: The keys of the instance to continue the timing for
+ * @nr_keys: The number of @keys
+ * @timestamp: The timestamp for the start of this instance
+ *
+ * This acts similar to traceeval_delta_start() except that if this is called
+ * between a traceeval_delta_start() and a traceeval_delta_stop(), it will
+ * not doing anything. There's times that multiple starts may happen, and only
+ * the first one should be used. In that case, traceeval_delta_continue() will
+ * update the timings on the first run, and will not do any update until
+ * a traceeval_delta_stop() is executed on the given @keys.
+ *
+ * Returns 0 on succes and -1 on error.
+ */
+int traceeval_delta_continue_size(struct traceeval_delta *tdelta,
+				  const struct traceeval_data *keys, size_t nr_keys,
+				  unsigned long long timestamp)
+{
+	return delta_start(tdelta, keys, nr_keys, timestamp, true);
+}
+
+/*
+ * traceeval_delta_stop - stop the timings of a traceeval_delta
+ * @tdelta: The traceeval_delta descriptor
+ * @keys: The keys of the instance to stop the timing for
+ * @nr_keys: The number of @keys
+ * @timestamp: The timestamp for the stop of this instance
+ *
+ * The traceeval_delta is used to add start and stop times for the objects
+ * in the traceeval. This function denotes that the instance represented by
+ * @keys is in the process of "stopping". The @timestamp is the stop time.
+ * This function does not do anything if there was no matching
+ * traceeval_delta_start() or traceeval_delta_continue() for the given @keys.
+ * If there was, then it will take the @timestamp and subtract it from the
+ * saved timestamp of the traceeval_delta_start/continue(), and record the
+ * resulting delta with the given traceeval_stat information.
+ *
+ * Returns 0 on succes and -1 on error.
+ */
+int traceeval_delta_stop_size(struct traceeval_delta *tdelta,
+			      const struct traceeval_data *keys, size_t nr_keys,
+			      unsigned long long timestamp)
+{
+	struct traceeval *teval = tdelta->teval;
+	struct traceeval_type *type;
+	struct traceeval_stat *stat;
+	unsigned long long delta;
+	unsigned long long ts;
+	struct entry *entry;
+	int ret;
+
+	ret = _teval_get_entry(teval, keys, &entry);
+	if (ret <= 0)
+		return ret;
+
+	ts = TEVAL_TIMESTAMP(teval, entry->vals);
+	if (!ts)
+		return 0;
+
+	delta = timestamp - ts;
+	TEVAL_DELTA(teval, entry->vals) = delta;
+	TEVAL_TIMESTAMP(teval, entry->vals) = 0;
+
+	type = &teval->val_types[TEVAL_DELTA_IDX(teval)];
+	stat = &entry->val_stats[TEVAL_DELTA_IDX(teval)];
+	_teval_update_stat(type, stat, delta, ts);
+
+	return 1;
+}
+
+/**
+ * traceeval_delta_stat - return a traceveal_stat for the delta
+ * @tdelta: The traceeval_delta descriptor
+ * @keys: The keys for the instance to find the stat for
+ * @nr_keys: The number of @keys
+ *
+ * Find the traceeval_stat that represents the delta of the given instance
+ * found by @keys. The returned stat contains the maximum, minimum, total,
+ * and count of the saved delta of the given instance, as well as the
+ * timestamps of the maximum and minimum values.
+ *
+ * Returns the descriptor for the traceeval_stat for the delta of the given
+ *   instance represented by @keys, or NULL on error or no instance is found.
+ */
+struct traceeval_stat *traceeval_delta_stat_size(struct traceeval_delta *tdelta,
+						 const struct traceeval_data *keys,
+						 size_t nr_keys)
+{
+	struct traceeval *teval = tdelta->teval;
+	struct entry *entry;
+	int ret;
+
+	if (teval->nr_key_types != nr_keys)
+		return NULL;
+
+	ret = _teval_get_entry(teval, keys, &entry);
+	if (ret <= 0)
+		return NULL;
+
+	return &entry->val_stats[TEVAL_DELTA_IDX(teval)];
+}
+
+/**
+ * traceeval_iterator_delta_stat - find the traceeval_stat for an iterator
+ * @iter: An iterator descriptor on a traceeval_delta traceeval
+ *
+ * If an iterator is created from a traceeval that was returned by
+ * traceeval_delta_teval_get(), then the traceeval_stat for the delta value
+ * can be quickly retrieved by this function.
+ *
+ * Returns the traceeval_stat for the delta value of the current element of
+ *    the iterator @iter, or NULL on error or the traceeval for the @iter
+ *    was not from a traceeval_delta element.
+ */
+struct traceeval_stat *traceeval_iterator_delta_stat(struct traceeval_iterator *iter)
+{
+	struct entry *entry;
+
+	if (!(iter->teval->flags & TEVAL_FL_DELTA))
+		return NULL;
+
+	if (iter->next < 1 || iter->next > iter->nr_entries)
+		return NULL;
+
+	entry = iter->entries[iter->next - 1];
+	return entry ? &entry->val_stats[TEVAL_DELTA_IDX(iter->teval)] : NULL;
+}
+
+/**
+ * traceeval_delta_teval_get - get the traceeval of a given traceeval_delta
+ * @tdelta: The traceeval_delta descriptor
+ *
+ * As traceeval_delta is just a defined traceeval instance, this function
+ * can be used to retrieve the internal traceeval descriptor of @tdelta.
+ * This can then be used for an iterator.
+ *
+ * Returns the traceeval descriptor for a traceeval_delta.
+ *   Should call traceeval_delta_teval_put() when finished.
+ */
+struct traceeval *traceeval_delta_teval_get(struct traceeval_delta *tdelta)
+{
+	return tdelta->teval;
+}
+
+/**
+ * traceeval_delta_teval_put - put back a traceeval for a traceeval_delta
+ * @tdelta: The traceeval_delta descriptor that the @teval came from
+ * @teval: The traceeval descriptor of a traceeval_delta
+ *
+ * Currentyl this does not do anything but it may in the future.
+ */
+void traceeval_delta_teval_put(struct traceeval_delta *tdelta,
+			       struct traceeval *teval)
+{
+	/* TBD */
+}
+
+/**
+ * traceeval_delta_results_release - release the results
+ * @tdelta: The traceeval_delta that the @results came from
+ * @results: The results to release
+ *
+ * This should be called to release any resources from a
+ * traceeval_delta_query().
+ */
+void traceeval_delta_results_release(struct traceeval_delta *tdelta,
+				     const struct traceeval_data *results)
+{
+}
diff --git a/src/eval-local.h b/src/eval-local.h
index fabb1a06e7df..9804fbd34e29 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -63,11 +63,16 @@ struct entry {
 	struct traceeval_stat	*val_stats;
 };
 
+enum {
+	TEVAL_FL_DELTA		= (1 << 0),
+};
+
 /* Histogram */
 struct traceeval {
 	struct traceeval_type		*key_types;
 	struct traceeval_type		*val_types;
 	struct hash_table		*hist;
+	unsigned int			flags;
 	ssize_t				nr_key_types;
 	ssize_t				nr_val_types;
 	size_t				update_counter;
@@ -89,6 +94,12 @@ struct traceeval_iterator {
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
@@ -117,6 +128,10 @@ static inline unsigned long long hash_string(const char *str)
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
index 0cf52225a03a..6efe984993af 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -490,8 +490,8 @@ static unsigned make_hash(struct traceeval *teval, const struct traceeval_data *
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
@@ -525,6 +525,43 @@ static int get_entry(struct traceeval *teval, const struct traceeval_data *keys,
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
@@ -614,36 +651,7 @@ static int copy_traceeval_data(struct traceeval_type *type,
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
@@ -679,7 +687,8 @@ static void data_release_and_free(size_t size, struct traceeval_data **data,
  *
  * Returns 1 on success, -1 on error.
  */
-static int dup_traceeval_data_set(size_t size, struct traceeval_type *type,
+static int dup_traceeval_data_set(size_t alloc_size, size_t copy_size,
+				  struct traceeval_type *type,
 				  struct traceeval_stat *stats,
 				  const struct traceeval_data *orig,
 				  struct traceeval_data **copy,
@@ -688,14 +697,14 @@ static int dup_traceeval_data_set(size_t size, struct traceeval_type *type,
 	size_t i;
 
 	*copy = NULL;
-	if (!size)
+	if (!alloc_size)
 		return 1;
 
-	*copy = calloc(size, sizeof(**copy));
+	*copy = calloc(alloc_size, sizeof(**copy));
 	if (!*copy)
 		return -1;
 
-	for (i = 0; i < size; i++) {
+	for (i = 0; i < copy_size; i++) {
 		if (copy_traceeval_data(type + i, stats ? stats + i : NULL,
 					 (*copy) + i, orig + i, ts))
 			goto fail;
@@ -739,7 +748,7 @@ int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *k
 		return -1;
 
 	/* find key and copy its corresponding value pair */
-	if ((check = get_entry(teval, keys, &entry)) < 1)
+	if ((check = _teval_get_entry(teval, keys, &entry)) < 1)
 		return check;
 
 	*results = entry->vals;
@@ -794,11 +803,12 @@ static unsigned long long get_timestamp(struct traceeval *teval,
 /*
  * Create a new entry in @teval with respect to @keys and @vals.
  *
- * Returns 0 on success, -1 on error.
+ * Returns 0 on success, -1 on error
  */
 static int create_entry(struct traceeval *teval,
 			const struct traceeval_data *keys,
-			const struct traceeval_data *vals)
+			const struct traceeval_data *vals,
+			size_t nr_vals)
 {
 	struct traceeval_data *new_keys;
 	struct traceeval_data *new_vals;
@@ -816,12 +826,12 @@ static int create_entry(struct traceeval *teval,
 	ts = get_timestamp(teval, vals);
 
 	/* copy keys */
-	if (dup_traceeval_data_set(teval->nr_key_types, teval->key_types,
-				   NULL, keys, &new_keys, 0) == -1)
+	if (dup_traceeval_data_set(teval->nr_key_types, teval->nr_key_types,
+				   teval->key_types, NULL, keys, &new_keys, 0) == -1)
 		goto fail_stats;
 
 	/* copy vals */
-	if (dup_traceeval_data_set(teval->nr_val_types, teval->val_types,
+	if (dup_traceeval_data_set(teval->nr_val_types, nr_vals, teval->val_types,
 				   entry->val_stats, vals, &new_vals, ts) == -1)
 		goto fail;
 
@@ -852,34 +862,36 @@ fail_entry:
  * Return 0 on success, -1 on error.
  */
 static int update_entry(struct traceeval *teval, struct entry *entry,
-			const struct traceeval_data *vals)
+			const struct traceeval_data *vals, size_t nr_vals)
 {
 	struct traceeval_stat *stats = entry->val_stats;
 	struct traceeval_type *types = teval->val_types;
 	struct traceeval_data *copy = entry->vals;
 	struct traceeval_data old[teval->nr_val_types];
 	unsigned long long ts;
-	size_t size = teval->nr_val_types;
 	ssize_t i;
 
-	if (!size)
+	if (!nr_vals)
 		return 0;
 
 	ts = get_timestamp(teval, vals);
 
-	for (i = 0; i < teval->nr_val_types; i++) {
+	if (teval->nr_val_types < nr_vals)
+		return -1;
+
+	for (i = 0; i < nr_vals; i++) {
 		if (vals[i].type != teval->val_types[i].type)
 			return -1;
 	}
 
-	for (i = 0; i < size; i++) {
+	for (i = 0; i < nr_vals; i++) {
 		old[i] = copy[i];
 
 		if (copy_traceeval_data(types + i, stats + i,
 					copy + i, vals + i, ts))
 			goto fail;
 	}
-	data_release(size, old, types);
+	data_release(nr_vals, old, types);
 	return 0;
  fail:
 	/* Free the new values that were added */
@@ -925,7 +937,7 @@ struct traceeval_stat *traceeval_stat_size(struct traceeval *teval,
 	if (!is_stat_type(type))
 		return NULL;
 
-	ret = get_entry(teval, keys, &entry);
+	ret = _teval_get_entry(teval, keys, &entry);
 	if (ret <= 0)
 		return NULL;
 
@@ -1008,6 +1020,32 @@ unsigned long long traceeval_stat_count(struct traceeval_stat *stat)
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
+		return create_entry(teval, keys, vals, nr_vals);
+	else
+		return update_entry(teval, entry, vals, nr_vals);
+}
+
 /*
  * traceeval_insert - insert an item into the traceeval descriptor
  * @teval: The descriptor to insert into
@@ -1043,29 +1081,10 @@ int traceeval_insert_size(struct traceeval *teval,
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
@@ -1092,7 +1111,7 @@ int traceeval_remove_size(struct traceeval *teval,
 		return -1;
 
 	entry = NULL;
-	check = get_entry(teval, keys, &entry);
+	check = _teval_get_entry(teval, keys, &entry);
 
 	if (check < 1)
 		return check;
-- 
2.40.1

