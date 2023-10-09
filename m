Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED635696
	for <linux-trace-devel@vger.kernel.org>; Mon,  9 Oct 2023 02:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249BEC433C9;
	Mon,  9 Oct 2023 02:52:38 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qpgP5-006cZ0-2l;
	Sun, 08 Oct 2023 22:53:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 2/2] libtraceeval: Add traceeval_iterator_delta_start_get()
Date: Sun,  8 Oct 2023 22:53:54 -0400
Message-Id: <20231009025354.1577934-3-rostedt@goodmis.org>
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

Add APIs:

  traceeval_iterator_delta_start_get()
  traceeval_iterator_delta_stop()

After analysing events, there may be dangling deltas. That is, there may
be elements in a traceeval_delta that had a traceeval_delta_start() but no
matching traceeval_delta_stop(). Create an iterator that allows the
developer to find all these dangling elements.

 iter = traceeval_iterator_delta_start_get(teval);

Will return an iterator that will iterate over all the elements in the
delta that was started by not stopped.

 while (traceeval_iterator_next(iter, &keys) > 0) {

   traceeval_iterator_delta(stop, &results, ts, &delta, &start_ts);

Will iterator over all the dangling events, where the
traceeval_iterator_next() will get the keys of the dangling event and
traceeval_iterator_delta_stop() will retrieve the values, and the
"start_ts" that hold the timestamp of the traceeval_delta_start() and
passing in the last timestamp will also calculate the "delta".

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval.h |   6 ++
 samples/task-eval.c | 144 +++++++++++++++++++++++++++++++++-----------
 src/delta.c         |  93 ++++++++++++++++++++++++++++
 src/eval-local.h    |   1 +
 src/histograms.c    |  10 ++-
 5 files changed, 219 insertions(+), 35 deletions(-)

diff --git a/include/traceeval.h b/include/traceeval.h
index 3055b561b42f..2b4082e8dfcb 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -336,6 +336,7 @@ unsigned long long traceeval_stat_min_timestamp(struct traceeval_stat *stat,
 						unsigned long long *ts);
 
 struct traceeval_iterator *traceeval_iterator_get(struct traceeval *teval);
+struct traceeval_iterator *traceeval_iterator_delta_start_get(struct traceeval *teval);
 void traceeval_iterator_put(struct traceeval_iterator *iter);
 int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_field,
 			    int level, bool ascending);
@@ -349,6 +350,11 @@ void traceeval_iterator_results_release(struct traceeval_iterator *iter,
 					const struct traceeval_data *results);
 struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
 					       const char *val_name);
+int traceeval_iterator_delta_stop(struct traceeval_iterator *iter,
+				  const struct traceeval_data **results,
+				  unsigned long long timestamp,
+				  unsigned long long *delta,
+				  unsigned long long *start_ts);
 int traceeval_iterator_remove(struct traceeval_iterator *iter);
 
 #endif /* __LIBTRACEEVAL_HIST_H__ */
diff --git a/samples/task-eval.c b/samples/task-eval.c
index f5f16071efac..9c3bc7c6ef1e 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -105,6 +105,17 @@ static struct traceeval_type process_delta_keys[] = {
 	},
 };
 
+static struct traceeval_type process_delta_vals[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "Schedule state"
+	},
+	{
+		.type = TRACEEVAL_TYPE_STRING,
+		.name = "COMM",
+	},
+};
+
 static struct traceeval_type delta_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -169,6 +180,7 @@ struct process_data {
 struct task_data {
 	struct traceeval	*teval_cpus;
 	struct traceeval	*teval_tasks;
+	unsigned long long	last_ts;
 	char			*comm;
 };
 
@@ -250,11 +262,24 @@ get_process_data(struct task_data *tdata, const char *comm)
 	return data;
 }
 
+static void update_cpu_data(struct task_data *tdata, int cpu, int state,
+			    unsigned long long delta, unsigned long long ts)
+{
+	struct traceeval_data cpu_keys[2];
+	struct traceeval_data vals[1];
+
+	TRACEEVAL_SET_NUMBER(cpu_keys[0], cpu);
+	TRACEEVAL_SET_NUMBER(cpu_keys[1], state);
+
+	TRACEEVAL_SET_DELTA(vals[0], delta, ts);
+
+	traceeval_insert(tdata->teval_cpus, cpu_keys, vals);
+}
+
 static void update_cpu_to_idle(struct task_data *tdata, struct tep_record *record)
 {
 
 	struct traceeval_data delta_keys[1];
-	struct traceeval_data cpu_keys[2];
 	struct traceeval_data vals[1];
 	const struct traceeval_data *results;
 	unsigned long long delta;
@@ -267,12 +292,8 @@ static void update_cpu_to_idle(struct task_data *tdata, struct tep_record *recor
 				   record->ts, &delta, NULL);
 
 	if (ret > 0) {
-		TRACEEVAL_SET_NUMBER(cpu_keys[0], record->cpu);
-		TRACEEVAL_SET_NUMBER(cpu_keys[1], results[0].number);
-
-		TRACEEVAL_SET_DELTA(vals[0], delta, record->ts);
-
-		traceeval_insert(tdata->teval_cpus, cpu_keys, vals);
+		update_cpu_data(tdata, record->cpu, results[0].number,
+				delta, record->ts);
 		traceeval_results_release(tdata->teval_cpus, results);
 	}
 
@@ -313,13 +334,40 @@ static void update_cpu_to_running(struct task_data *tdata, struct tep_record *re
 				 record->ts);
 }
 
+static void update_thread(struct task_data *tdata, int pid, const char *comm,
+			  enum sched_state state, unsigned long long delta,
+			  unsigned long long ts)
+{
+		struct traceeval_data keys[2];
+		struct traceeval_data pvals[2];
+		struct traceeval_data vals[1];
+		struct process_data *pdata;
+
+		pdata = get_process_data(tdata, comm);
+
+		TRACEEVAL_SET_NUMBER(keys[0], pid);
+		TRACEEVAL_SET_NUMBER(keys[1], state);
+
+		TRACEEVAL_SET_DELTA(vals[0], delta, ts);
+
+		traceeval_insert(pdata->teval_threads, keys, vals);
+
+		/* Also update the process */
+		TRACEEVAL_SET_CSTRING(keys[0], comm);
+
+		TRACEEVAL_SET_POINTER(pvals[0], pdata);
+		TRACEEVAL_SET_DELTA(pvals[1], delta, ts);
+
+		traceeval_insert(tdata->teval_tasks, keys, pvals);
+}
+
 static void start_running_thread(struct task_data *tdata,
 				 struct tep_record *record,
 				 const char *comm, int pid)
 {
 	const struct traceeval_data *results;
 	struct traceeval_data delta_keys[1];
-	struct traceeval_data vals[1];
+	struct traceeval_data vals[2];
 	unsigned long long delta;
 	unsigned long long val;
 	int ret;
@@ -331,34 +379,15 @@ static void start_running_thread(struct task_data *tdata,
 				   &results, record->ts, &delta, &val);
 	if (ret > 0) {
 		enum sched_state state = results[0].number;
-		struct traceeval_data keys[2];
-		struct traceeval_data pvals[2];
-		struct process_data *pdata;
-
-		traceeval_results_release(tdata->teval_tasks, results);
-
-		pdata = get_process_data(tdata, comm);
-
-		TRACEEVAL_SET_NUMBER(keys[0], pid);
-		TRACEEVAL_SET_NUMBER(keys[1], state);
 
 		if (state == RUNNING)
 			die("State %d is running! %lld -> %lld", pid, val, record->ts);
-
-		TRACEEVAL_SET_DELTA(vals[0], delta, record->ts);
-
-		traceeval_insert(pdata->teval_threads, keys, vals);
-
-		/* Also update the process */
-		TRACEEVAL_SET_CSTRING(keys[0], comm);
-
-		TRACEEVAL_SET_POINTER(pvals[0], pdata);
-		TRACEEVAL_SET_DELTA(pvals[1], delta, record->ts);
-
-		traceeval_insert(tdata->teval_tasks, keys, pvals);
+		update_thread(tdata, pid, comm, state, delta, record->ts);
+		traceeval_results_release(tdata->teval_tasks, results);
 	}
 
 	TRACEEVAL_SET_NUMBER(vals[0], RUNNING);
+	TRACEEVAL_SET_CSTRING(vals[1], comm);
 
 	traceeval_delta_start(tdata->teval_tasks, delta_keys, vals, record->ts);
 }
@@ -409,13 +438,14 @@ static void sched_out(struct task_data *tdata, const char *comm,
 	ret = traceeval_delta_stop(tdata->teval_tasks, delta_keys, &results,
 				   record->ts, &delta, &val);
 
-	TRACEEVAL_SET_NUMBER(vals[0], state);
+	TRACEEVAL_SET_NUMBER(task_vals[0], state);
+	TRACEEVAL_SET_CSTRING(task_vals[1], comm);
 
 	if (ret > 0)
 		old_state = results[0].number;
 
 	/* Start recording why this task is off the CPU */
-	traceeval_delta_start(tdata->teval_tasks, delta_keys, vals, record->ts);
+	traceeval_delta_start(tdata->teval_tasks, delta_keys, task_vals, record->ts);
 	if (ret <= 0)
 		return;
 
@@ -790,6 +820,50 @@ static void free_tdata(struct task_data *tdata)
 {
 }
 
+static void finish_leftovers(struct task_data *data)
+{
+	const struct traceeval_data *results;
+	const struct traceeval_data *keys;
+	struct traceeval_iterator *iter;
+	unsigned long long delta;
+	enum sched_state state;
+	const char *comm;
+	int pid;
+
+	iter = traceeval_iterator_delta_start_get(data->teval_tasks);
+	while (traceeval_iterator_next(iter, &keys) > 0) {
+		traceeval_iterator_delta_stop(iter, &results, data->last_ts,
+					      &delta, NULL);
+
+		pid = keys[0].number;
+
+		state = results[0].number;
+		comm = results[1].cstring;
+
+		update_thread(data, pid, comm, state, delta, data->last_ts);
+	}
+	traceeval_iterator_put(iter);
+
+	iter = traceeval_iterator_delta_start_get(data->teval_cpus);
+	while (traceeval_iterator_next(iter, &keys) > 0) {
+		traceeval_iterator_delta_stop(iter, &results, data->last_ts,
+					      &delta, NULL);
+		update_cpu_data(data, keys[0].number, results[0].number,
+				delta, data->last_ts);
+	}
+	traceeval_iterator_put(iter);
+
+}
+
+static int event_callback(struct tracecmd_input *handle,
+			  struct tep_record *record, int cpu, void *d)
+{
+	struct task_data *data = d;
+
+	data->last_ts = record->ts;
+	return 0;
+}
+
 int main (int argc, char **argv)
 {
 	struct tracecmd_input *handle;
@@ -826,7 +900,7 @@ int main (int argc, char **argv)
 		pdie("Creating trace eval processe data");
 
 	if (traceeval_delta_create(data.teval_tasks, process_delta_keys,
-				   delta_vals) < 0)
+				   process_delta_vals) < 0)
 		pdie("Creating trace delta threads");
 
 	data.teval_cpus = traceeval_init(cpu_keys, delta_type);
@@ -838,7 +912,9 @@ int main (int argc, char **argv)
 
 	tracecmd_follow_event(handle, "sched", "sched_switch", switch_func, &data);
 
-	tracecmd_iterate_events(handle, NULL, 0, NULL, NULL);
+	tracecmd_iterate_events(handle, NULL, 0, event_callback, &data);
+
+	finish_leftovers(&data);
 
 	display(&data);
 
diff --git a/src/delta.c b/src/delta.c
index e97aa0c1851b..99c86122d83f 100644
--- a/src/delta.c
+++ b/src/delta.c
@@ -336,3 +336,96 @@ int traceeval_delta_stop_size(struct traceeval *teval,
 
 	return 1;
 }
+
+static int create_delta_iter_array(struct traceeval_iterator *iter)
+{
+	struct traceeval *teval = iter->teval;
+	struct hash_table *hist = teval->hist;
+	struct hash_iter *hiter;
+	struct hash_item *item;
+	size_t ts_idx = teval->nr_val_types - 1;
+	size_t idx = 0;
+	int i;
+
+	iter->nr_entries = hash_nr_items(hist);
+	iter->entries = calloc(iter->nr_entries, sizeof(*iter->entries));
+	if (!iter->entries)
+		return -1;
+
+	for (i = 0, hiter = hash_iter_start(hist); (item = hash_iter_next(hiter)); i++) {
+		struct entry *entry = container_of(item, struct entry, hash);
+
+		/* Only add entries where the timestamp is non zero */
+		if (!entry->vals[ts_idx].number_64)
+			continue;
+
+		iter->entries[idx++] = entry;
+	}
+
+	iter->nr_entries = idx;
+
+	/* No sorting for this */
+	iter->no_sort = true;
+
+	return 0;
+}
+
+/**
+ * traceeval_iterator_delta_start_get - return iterator on delta start
+ * @teval: traceeval to get the delta iterator from
+ *
+ * This is used to find any element of a traceeval_delta that had
+ * a traceeval_delta_start() or traceeval_delta_continue() called on
+ * it without a traceeval_delta_stop(). That is, any "hanging" elements.
+ */
+struct traceeval_iterator *traceeval_iterator_delta_start_get(struct traceeval *teval)
+{
+	struct traceeval_iterator *iter;
+	int ret;
+
+	if (!teval->tdelta)
+		return NULL;
+
+	iter = calloc(1, sizeof(*iter));
+	if (!iter)
+		return NULL;
+
+	iter->teval = teval->tdelta->teval;
+
+	ret = create_delta_iter_array(iter);
+
+	if (ret < 0) {
+		free(iter);
+		iter = NULL;
+	}
+
+	return iter;
+}
+
+int traceeval_iterator_delta_stop(struct traceeval_iterator *iter,
+				  const struct traceeval_data **results,
+				  unsigned long long timestamp,
+				  unsigned long long *delta,
+				  unsigned long long *start_ts)
+{
+	unsigned long long ts;
+	struct entry *entry;
+
+	if (iter->next < 1 || iter->next > iter->nr_entries)
+		return -1;
+
+	entry = iter->entries[iter->next - 1];
+
+	if (results)
+		*results = entry->vals;
+
+	ts = entry->vals[iter->teval->nr_val_types - 1].number_64;
+
+	if (delta)
+		*delta = timestamp - ts;
+
+	if (start_ts)
+		*start_ts = ts;
+
+	return 1;
+}
diff --git a/src/eval-local.h b/src/eval-local.h
index a455daf39733..b0de30c713b4 100644
--- a/src/eval-local.h
+++ b/src/eval-local.h
@@ -95,6 +95,7 @@ struct traceeval_iterator {
 	size_t				nr_sort;
 	size_t				next;
 	bool				needs_sort;
+	bool				no_sort;
 };
 
 extern int _teval_get_entry(struct traceeval *teval, const struct traceeval_data *keys,
diff --git a/src/histograms.c b/src/histograms.c
index 0377be00d1c1..480b78da606b 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -1299,6 +1299,10 @@ int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_fi
 	struct traceeval_type *type;
 	int num_levels = level + 1;
 
+	/* delta iterators are not to be sorted */
+	if (iter->no_sort)
+		return -1;
+
 	type = find_sort_type(iter->teval, sort_field);
 	if (!type)
 		return -1;
@@ -1445,6 +1449,10 @@ int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
 		.data = data
 	};
 
+	/* delta iterators are not to be sorted */
+	if (iter->no_sort)
+		return -1;
+
 	if (check_update(iter) < 0)
 		return -1;
 
@@ -1473,7 +1481,7 @@ int traceeval_iterator_next(struct traceeval_iterator *iter,
 	struct entry *entry;
 	int ret;
 
-	if (iter->needs_sort) {
+	if (iter->needs_sort && !iter->no_sort) {
 		ret = sort_iter(iter);
 		if (ret < 0)
 			return ret;
-- 
2.40.1

