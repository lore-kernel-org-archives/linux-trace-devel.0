Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDAD225D3
	for <linux-trace-devel@vger.kernel.org>; Thu, 19 Oct 2023 15:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E40C433C7;
	Thu, 19 Oct 2023 15:30:10 +0000 (UTC)
Date: Thu, 19 Oct 2023 11:30:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH] libtraceeval: Add traceeval_type_index() API
Message-ID: <20231019113008.4699da30@gandalf.local.home>
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

Add a way to get the index of a traceeval_type from its name. This makes
indexing the elements more robust and less error prone. By adding a way to
index the names via variables, keys can be added and rearranged without
worrying about the other accesses in the program being affected.

The new functions are:

   traceeval_type_index()
   traceeval_type_index_size()

The use case can by:

static struct traceeval_type keys[] = {
	{
		.type = TRACEEVAL_TYPE_NUMBER,
		.name = "PID"
	}
};

static ssize_t MY_KEY;

static void init_keys(void)
{
	MY_KEY = traceeval_type_index("PID", keys);
}

static void insert_data(struct traceeval *teval, int data)
{
	struct traceeval_data keys[TRACEEVAL_ARRAY_SIZE(keys)];

	TRACEEVAL_SET_NUMBER(keys[MY_KEY], data);

	traceeval_insert(teval, keys, NULL);
}

Using this method keeps from having to constantly tinker with hardcoded
index numbers when adding or rearranging keys and values.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceeval-init.txt |  52 ++++--
 Documentation/libtraceeval.txt      |   4 +
 include/traceeval.h                 |  15 ++
 samples/task-eval.c                 | 241 ++++++++++++++++++----------
 4 files changed, 217 insertions(+), 95 deletions(-)

diff --git a/Documentation/libtraceeval-init.txt b/Documentation/libtraceeval-init.txt
index 1c09cee319c8..10a2729372bb 100644
--- a/Documentation/libtraceeval-init.txt
+++ b/Documentation/libtraceeval-init.txt
@@ -3,7 +3,8 @@ libtraceeval(3)
 
 NAME
 ----
-traceeval_init, traceeval_init_size, traceeval_release - Create a trace evaluation helper mechanism.
+traceeval_init, traceeval_init_size, traceeval_release, traceeval_type_index, traceeval_type_index_size
+- Create a trace evaluation helper mechanism.
 
 SYNOPSIS
 --------
@@ -15,6 +16,8 @@ struct traceeval pass:[*]*traceeval_init*(struct traceeval_type pass:[*]_keys_,
 struct traceeval pass:[*]*traceeval_init_size*(struct traceeval_type pass:[*]_keys_, struct traceeval_type pass:[*]_vals_,
 				       int _nr_keys_, int _nr_vals_);
 void *traceeval_release*(struct traceeval pass:[*]_teval_);
+ssize_t *traceeval_type_index*(const char pass:[*]_name_, struct traceeval_type pass:*]_type_);
+ssize_t *traceeval_type_index_size*(const char pass:[*]_name_, struct traceeval_type pass:*]_type_, size_t nr_types);
 --
 
 DESCRIPTION
@@ -164,11 +167,22 @@ requires static size arrays is because it is really just a macro that calles
 The *traceeval_release()* function releases and frees all the resources of
 a traceeval returned by *traceeval_init()* and *traceeval_init_size()*.
 
+The *traceeval_type_index()* is a helper function that is used to find the
+index of a traceeval_type _type_ by its given _name_. If the name is not found, it returns
+-1. This is handy to not have to remember which index belongs to which field.
+By creating variables to hold the indexes, the variables can be used instead.
+The *traceeval_type_index()* requires that _type_ is a static array. If a dynamic
+array is required, then *traceeval_type_index_size()* can be used where _nr_types_
+is the size of the _type_ array.
+
 RETURN VALUE
 ------------
 The *traceeval_init()* and *traceeval_init_size()* both return a descriptor
 to the traceeval or NULL on error.
 
+The *traceeval_type_index()* and *traceeval_type_index_size()* return the index
+of the given _name_ in _type_ or -1 if not found.
+
 EXAMPLE
 -------
 [source,c]
@@ -202,13 +216,29 @@ struct traceeval_type sched_keys[] = {
 	},
 };
 
+static ssize_t SCHED_COMM;
+static ssize_t SCHED_PID;
+static ssize_t SCHED_STATE;
+
+static void init_indexes(void)
+{
+	SCHED_COMM = traceeval_type_index("COMM", sched_keys);
+	SCHED_PID = traceeval_type_index("PID", sched_keys);
+	SCHED_STATE = traceeval_type_index("State", sched_keys);
+
+	if (SCHED_COMM < 0 || SCHED_PID < 0 || SCHED_STATE < 0) {
+		printf("Had a typo in assiging indexes\n");
+		exit(-1);
+	}
+}
+
 static int sched_callback(struct tep_event *event, struct tep_record *record,
 			  int cpu, void *data)
 {
 	static struct tep_format_field *pid_field;
 	static struct tep_format_field *comm_field;
 	static struct tep_format_field *state_field;
-	struct traceeval_data keys[3];
+	struct traceeval_data keys[TRACEEVAL_ARRAY_SIZE(sched_keys)];
 	struct traceeval *teval = data;
 	unsigned long long val;
 	char *comm;
@@ -232,9 +262,9 @@ static int sched_callback(struct tep_event *event, struct tep_record *record,
 
 	comm = record->data + comm_field->offset;
 
-	TRACEEVAL_SET_STRING(keys[0], comm);
-	TRACEEVAL_SET_NUMBER(keys[1], pid);
-	TRACEEVAL_SET_NUMBER(keys[2], state);
+	TRACEEVAL_SET_STRING(keys[SCHED_COMM], comm);
+	TRACEEVAL_SET_NUMBER(keys[SCHED_PID], pid);
+	TRACEEVAL_SET_NUMBER(keys[SCHED_STATE], state);
 
 	traceeval_insert(teval, keys, NULL);
 
@@ -243,7 +273,7 @@ static int sched_callback(struct tep_event *event, struct tep_record *record,
 
 static char *get_state(int state)
 {
-	switch (state & 7) {
+	switch (state & 0x1ff) {
 	case 0:
 		return "R";
 	case 1:
@@ -260,17 +290,17 @@ static void display_teval(struct traceeval *teval)
 	const struct traceeval_data *keys;
 
 	/* Sort comms first. */
-	traceeval_iterator_sort(iter, sched_keys[0].name, 0, true);
+	traceeval_iterator_sort(iter, sched_keys[SCHED_COMM].name, 0, true);
 	/* Sort pids next */
-	traceeval_iterator_sort(iter, sched_keys[1].name, 1, true);
+	traceeval_iterator_sort(iter, sched_keys[SCHED_PID].name, 1, true);
 	/* Sort state last */
-	traceeval_iterator_sort(iter, sched_keys[2].name, 2, true);
+	traceeval_iterator_sort(iter, sched_keys[SCHED_STATE].name, 2, true);
 
 	while (traceeval_iterator_next(iter, &keys) > 0) {
 		ssize_t hits = traceeval_hitcount_size(teval, keys, TRACEEVAL_ARRAY_SIZE(sched_keys));
 
 		printf("%s [%ld] %s: %zd\n",
-		       keys[0].string, keys[1].number, get_state(keys[2].number), hits);
+		       keys[SCHED_COMM].string, keys[SCHED_PID].number, get_state(keys[SCHED_STATE].number), hits);
 	}
 	traceeval_iterator_put(iter);
 }
@@ -289,6 +319,8 @@ int main (int argc, char **argv)
 	bool finished = false;
 	int ret;
 
+	init_indexes();
+
 	teval = traceeval_init(sched_keys, NULL);
 	if (!teval)
 		pdie("Creating traceeval");
diff --git a/Documentation/libtraceeval.txt b/Documentation/libtraceeval.txt
index e65ebd270445..d6f90244320e 100644
--- a/Documentation/libtraceeval.txt
+++ b/Documentation/libtraceeval.txt
@@ -17,6 +17,10 @@ Creating and releasing the traceeval resources:
 				       int _nr_keys_, int _nr_vals_);
 	void *traceeval_release*(struct traceeval pass:[*]_teval_);
 
+Helper functions for indexing the traceeval_type and traceveal_data elements:
+	ssize_t *traceeval_type_index*(const char pass:[*]_name_, struct traceeval_type pass:*]_type_);
+	ssize_t *traceeval_type_index_size*(const char pass:[*]_name_, struct traceeval_type pass:*]_type_, size_t nr_types);
+
 Inserting and removing elements from the traceeval:
 	int *traceeval_insert*(struct traceeval pass:[*]_teval_,
 			  const struct traceeval_data pass:[*]_keys_,
diff --git a/include/traceeval.h b/include/traceeval.h
index 99b3f7b86915..84625709a81d 100644
--- a/include/traceeval.h
+++ b/include/traceeval.h
@@ -11,6 +11,7 @@
 #include <stdlib.h>
 #include <stddef.h>
 #include <stdarg.h>
+#include <string.h>
 #include <stdbool.h>
 
 /* Data definition interfaces */
@@ -224,6 +225,20 @@ struct traceeval_type {
 	traceeval_data_hash_fn		hash;
 };
 
+#define traceeval_type_index(name, type)					\
+	traceeval_type_index_size(name, type, TRACEEVAL_ARRAY_SIZE(type))
+
+static inline ssize_t traceeval_type_index_size(const char *name,
+						struct traceeval_type *type,
+						size_t size)
+{
+	for (size_t i = 0; i < size; i++) {
+		if (strcmp(type[i].name, name) == 0)
+			return i;
+	}
+	return -1;
+}
+
 /* Statistics about a given entry element */
 struct traceeval_stat;
 
diff --git a/samples/task-eval.c b/samples/task-eval.c
index 6ae361196486..7f438d8a5cf4 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -121,14 +121,17 @@ static struct traceeval_type cpu_delta_vals[] = {
 	},
 };
 
+static ssize_t CPU_DELTA_KEY;
+static ssize_t CPU_DELTA_STATE;
+
 static void start_cpu_data(struct traceeval *teval, int cpu, int state,
 			   unsigned long long ts)
 {
-	struct traceeval_data keys[1];
-	struct traceeval_data vals[1];
+	struct traceeval_data keys[TRACEEVAL_ARRAY_SIZE(cpu_delta_keys)];
+	struct traceeval_data vals[TRACEEVAL_ARRAY_SIZE(cpu_delta_vals)];
 
-	TRACEEVAL_SET_NUMBER(keys[0], cpu);
-	TRACEEVAL_SET_NUMBER(vals[0], state);
+	TRACEEVAL_SET_NUMBER(keys[CPU_DELTA_KEY], cpu);
+	TRACEEVAL_SET_NUMBER(vals[CPU_DELTA_STATE], state);
 
 	traceeval_delta_start(teval, keys, vals, ts);
 }
@@ -136,11 +139,11 @@ static void start_cpu_data(struct traceeval *teval, int cpu, int state,
 static void continue_cpu_data(struct traceeval *teval, int cpu, int state,
 			      unsigned long long ts)
 {
-	struct traceeval_data keys[1];
-	struct traceeval_data vals[1];
+	struct traceeval_data keys[TRACEEVAL_ARRAY_SIZE(cpu_delta_keys)];
+	struct traceeval_data vals[TRACEEVAL_ARRAY_SIZE(cpu_delta_vals)];
 
-	TRACEEVAL_SET_NUMBER(keys[0], cpu);
-	TRACEEVAL_SET_NUMBER(vals[0], state);
+	TRACEEVAL_SET_NUMBER(keys[CPU_DELTA_KEY], cpu);
+	TRACEEVAL_SET_NUMBER(vals[CPU_DELTA_STATE], state);
 
 	traceeval_delta_continue(teval, keys, vals, ts);
 }
@@ -149,18 +152,18 @@ static int stop_cpu_data(struct traceeval *teval, int cpu, int *state,
 			 unsigned long long ts,
 			 unsigned long long *delta)
 {
+	struct traceeval_data keys[TRACEEVAL_ARRAY_SIZE(cpu_delta_keys)];
 	const struct traceeval_data *results;
-	struct traceeval_data keys[1];
 	int ret;
 
-	TRACEEVAL_SET_NUMBER(keys[0], cpu);
+	TRACEEVAL_SET_NUMBER(keys[CPU_DELTA_KEY], cpu);
 
 	ret = traceeval_delta_stop(teval, keys, &results, ts, delta, NULL);
 	if (ret < 1)
 		return ret;
 
 	if (state)
-		*state = results[0].number;
+		*state = results[CPU_DELTA_STATE].number;
 
 	traceeval_results_release(teval, results);
 	return 1;
@@ -168,17 +171,17 @@ static int stop_cpu_data(struct traceeval *teval, int cpu, int *state,
 
 int cpu_last_state(struct traceeval *teval, int cpu, int *state)
 {
+	struct traceeval_data keys[TRACEEVAL_ARRAY_SIZE(cpu_delta_keys)];
 	const struct traceeval_data *results;
-	struct traceeval_data keys[1];
 	int ret;
 
-	TRACEEVAL_SET_NUMBER(keys[0], cpu);
+	TRACEEVAL_SET_NUMBER(keys[CPU_DELTA_KEY], cpu);
 
 	ret = traceeval_delta_query(teval, keys, &results);
 	if (ret < 1)
 		return ret;
 
-	*state = results[0].number;
+	*state = results[CPU_DELTA_STATE].number;
 
 	traceeval_results_release(teval, results);
 	return 1;
@@ -209,16 +212,20 @@ static struct traceeval_type cpu_vals[] = {
 	},
 };
 
+static ssize_t CPU_KEY;
+static ssize_t CPU_STATE;
+static ssize_t CPU_DELTA;
+
 static void insert_cpu_data(struct traceeval *teval, int cpu, int state,
 			    unsigned long long delta, unsigned long long ts)
 {
-	struct traceeval_data keys[2];
-	struct traceeval_data vals[1];
+	struct traceeval_data keys[TRACEEVAL_ARRAY_SIZE(cpu_keys)];
+	struct traceeval_data vals[TRACEEVAL_ARRAY_SIZE(cpu_vals)];
 
-	TRACEEVAL_SET_NUMBER(keys[0], cpu);
-	TRACEEVAL_SET_NUMBER(keys[1], state);
+	TRACEEVAL_SET_NUMBER(keys[CPU_KEY], cpu);
+	TRACEEVAL_SET_NUMBER(keys[CPU_STATE], state);
 
-	TRACEEVAL_SET_DELTA(vals[0], delta, ts);
+	TRACEEVAL_SET_DELTA(vals[CPU_DELTA], delta, ts);
 
 	traceeval_insert(teval, keys, vals);
 }
@@ -247,16 +254,20 @@ static struct traceeval_type wakeup_delta_vals[] = {
 	},
 };
 
+static ssize_t WAKEUP_DELTA_PID;
+static ssize_t WAKEUP_DELTA_COMM;
+static ssize_t WAKEUP_DELTA_PRIO;
+
 static void start_wakeup_data(struct traceeval *teval, int pid,
 			      const char *comm, int prio, unsigned long long ts)
 {
-	struct traceeval_data keys[1];
-	struct traceeval_data vals[2];
+	struct traceeval_data keys[TRACEEVAL_ARRAY_SIZE(wakeup_delta_keys)];
+	struct traceeval_data vals[TRACEEVAL_ARRAY_SIZE(wakeup_delta_vals)];
 
-	TRACEEVAL_SET_NUMBER(keys[0], pid);
+	TRACEEVAL_SET_NUMBER(keys[WAKEUP_DELTA_PID], pid);
 
-	TRACEEVAL_SET_CSTRING(vals[0], comm);
-	TRACEEVAL_SET_NUMBER(vals[1], prio);
+	TRACEEVAL_SET_CSTRING(vals[WAKEUP_DELTA_COMM], comm);
+	TRACEEVAL_SET_NUMBER(vals[WAKEUP_DELTA_PRIO], prio);
 
 	traceeval_delta_start(teval, keys, vals, ts);
 }
@@ -265,21 +276,21 @@ static int stop_wakeup_data(struct traceeval *teval, int pid,
 			    const char **comm, int *prio, unsigned long long ts,
 			    unsigned long long *delta)
 {
+	struct traceeval_data keys[TRACEEVAL_ARRAY_SIZE(wakeup_delta_keys)];
 	const struct traceeval_data *results;
-	struct traceeval_data keys[1];
 	int ret;
 
-	TRACEEVAL_SET_NUMBER(keys[0], pid);
+	TRACEEVAL_SET_NUMBER(keys[WAKEUP_DELTA_PID], pid);
 
 	ret = traceeval_delta_stop(teval, keys, &results, ts, delta, NULL);
 	if (ret < 1)
 		return ret;
 
 	if (comm)
-		*comm = results[0].string;
+		*comm = results[WAKEUP_DELTA_COMM].string;
 
 	if (prio)
-		*prio = results[1].number;
+		*prio = results[WAKEUP_DELTA_PRIO].number;
 
 	traceeval_results_release(teval, results);
 	return 1;
@@ -316,17 +327,22 @@ static struct traceeval_type task_delta_vals[] = {
 	},
 };
 
+static ssize_t TASK_DELTA_PID;
+static ssize_t TASK_DELTA_STATE;
+static ssize_t TASK_DELTA_COMM;
+static ssize_t TASK_DELTA_PRIO;
+
 static void start_task_data(struct traceeval *teval, int pid, int state,
 			    const char *comm, int prio, unsigned long long ts)
 {
-	struct traceeval_data keys[1];
-	struct traceeval_data vals[3];
+	struct traceeval_data keys[TRACEEVAL_ARRAY_SIZE(task_delta_keys)];
+	struct traceeval_data vals[TRACEEVAL_ARRAY_SIZE(task_delta_vals)];
 
-	TRACEEVAL_SET_NUMBER(keys[0], pid);
+	TRACEEVAL_SET_NUMBER(keys[TASK_DELTA_PID], pid);
 
-	TRACEEVAL_SET_NUMBER(vals[0], state);
-	TRACEEVAL_SET_CSTRING(vals[1], comm);
-	TRACEEVAL_SET_NUMBER(vals[2], prio);
+	TRACEEVAL_SET_NUMBER(vals[TASK_DELTA_STATE], state);
+	TRACEEVAL_SET_CSTRING(vals[TASK_DELTA_COMM], comm);
+	TRACEEVAL_SET_NUMBER(vals[TASK_DELTA_PRIO], prio);
 
 	traceeval_delta_start(teval, keys, vals, ts);
 }
@@ -335,24 +351,24 @@ static int stop_task_data(struct traceeval *teval, int pid, int *state,
 			  const char **comm, int *prio, unsigned long long ts,
 			  unsigned long long *delta, unsigned long long *save_ts)
 {
+	struct traceeval_data keys[TRACEEVAL_ARRAY_SIZE(task_delta_keys)];
 	const struct traceeval_data *results;
-	struct traceeval_data keys[1];
 	int ret;
 
-	TRACEEVAL_SET_NUMBER(keys[0], pid);
+	TRACEEVAL_SET_NUMBER(keys[TASK_DELTA_PID], pid);
 
 	ret = traceeval_delta_stop(teval, keys, &results, ts, delta, save_ts);
 	if (ret < 1)
 		return ret;
 
 	if (state)
-		*state = results[0].number;
+		*state = results[TASK_DELTA_STATE].number;
 
 	if (comm)
-		*comm = results[1].string;
+		*comm = results[TASK_DELTA_COMM].string;
 
 	if (prio)
-		*prio = results[2].number;
+		*prio = results[TASK_DELTA_PRIO].number;
 
 	traceeval_results_release(teval, results);
 	return 1;
@@ -410,15 +426,20 @@ static struct traceeval_type task_vals[] = {
 	},
 };
 
+static ssize_t TASK_COMM;
+static ssize_t TASK_STATE;
+static ssize_t TASK_DATA;
+static ssize_t TASK_DELTA;
+
 static int insert_task_data(struct traceeval *teval, const char *comm,
 			     int state, void *data, unsigned long long delta,
 			     unsigned long long timestamp)
 {
-	struct traceeval_data keys[2];
-	struct traceeval_data vals[2];
+	struct traceeval_data keys[TRACEEVAL_ARRAY_SIZE(task_keys)];
+	struct traceeval_data vals[TRACEEVAL_ARRAY_SIZE(task_vals)];
 
-	TRACEEVAL_SET_CSTRING(keys[0], comm);
-	TRACEEVAL_SET_NUMBER(keys[1], state);
+	TRACEEVAL_SET_CSTRING(keys[TASK_COMM], comm);
+	TRACEEVAL_SET_NUMBER(keys[TASK_STATE], state);
 
 	/*
 	 * Can not have data stored more than once, only save it for
@@ -427,8 +448,8 @@ static int insert_task_data(struct traceeval *teval, const char *comm,
 	if (state != RUNNING)
 		data = NULL;
 
-	TRACEEVAL_SET_POINTER(vals[0], data);
-	TRACEEVAL_SET_DELTA(vals[1], delta, timestamp);
+	TRACEEVAL_SET_POINTER(vals[TASK_DATA], data);
+	TRACEEVAL_SET_DELTA(vals[TASK_DELTA], delta, timestamp);
 
 	return traceeval_insert(teval, keys, vals);
 }
@@ -486,19 +507,24 @@ static struct traceeval_type thread_vals[] = {
 	},
 };
 
+static ssize_t THREAD_TID;
+static ssize_t THREAD_PRIO;
+static ssize_t THREAD_STATE;
+static ssize_t THREAD_DELTA;
+
 static void insert_thread_data(struct traceeval *teval, 
 			       int tid, int state, int prio,
 			       unsigned long long delta,
 			       unsigned long long timestamp)
 {
-	struct traceeval_data keys[3];
-	struct traceeval_data vals[1];
+	struct traceeval_data keys[TRACEEVAL_ARRAY_SIZE(thread_keys)];
+	struct traceeval_data vals[TRACEEVAL_ARRAY_SIZE(thread_vals)];
 
-	TRACEEVAL_SET_NUMBER(keys[0], tid);
-	TRACEEVAL_SET_NUMBER(keys[1], prio);
-	TRACEEVAL_SET_NUMBER(keys[2], state);
+	TRACEEVAL_SET_NUMBER(keys[THREAD_TID], tid);
+	TRACEEVAL_SET_NUMBER(keys[THREAD_PRIO], prio);
+	TRACEEVAL_SET_NUMBER(keys[THREAD_STATE], state);
 
-	TRACEEVAL_SET_DELTA(vals[0], delta, timestamp);
+	TRACEEVAL_SET_DELTA(vals[THREAD_DELTA], delta, timestamp);
 
 	traceeval_insert(teval, keys, vals);
 }
@@ -528,17 +554,60 @@ static struct traceeval_type wakeup_vals[] = {
 	},
 };
 
+static ssize_t WAKEUP_TASK_COMM;
+static ssize_t WAKEUP_THREAD_PID;
+static ssize_t WAKEUP_THREAD_PRIO;
+static ssize_t WAKEUP_DELTA;
+
+#define assign_type(type, name, array) \
+	if ((type = traceeval_type_index(name, array)) < 0)	\
+		die("Invalid index %s for %s", name, #type);
+
+static void init_indexes(void)
+{
+	assign_type(CPU_DELTA_KEY, "CPU", cpu_delta_keys);
+	assign_type(CPU_DELTA_STATE, "Schedule state", cpu_delta_vals);
+
+	assign_type(CPU_KEY, "CPU", cpu_keys);
+	assign_type(CPU_STATE, "Schedule state", cpu_keys);
+	assign_type(CPU_DELTA, DELTA_NAME, cpu_vals);
+
+	assign_type(WAKEUP_DELTA_PID, "PID", wakeup_delta_keys);
+	assign_type(WAKEUP_DELTA_COMM, "COMM", wakeup_delta_vals);
+	assign_type(WAKEUP_DELTA_PRIO, "Prio", wakeup_delta_vals);
+
+	assign_type(TASK_DELTA_PID, "PID", task_delta_keys);
+	assign_type(TASK_DELTA_STATE, "Schedule state", task_delta_vals);
+	assign_type(TASK_DELTA_COMM, "COMM", task_delta_vals);
+	assign_type(TASK_DELTA_PRIO, "Prio", task_delta_vals);
+
+	assign_type(TASK_COMM, "COMM", task_keys);
+	assign_type(TASK_STATE, "Schedule state", task_keys);
+	assign_type(TASK_DATA, "data", task_vals);
+	assign_type(TASK_DELTA, DELTA_NAME, task_vals);
+
+	assign_type(THREAD_TID, "TID", thread_keys);
+	assign_type(THREAD_PRIO, "Prio", thread_keys);
+	assign_type(THREAD_STATE, "Schedule state", thread_keys);
+	assign_type(THREAD_DELTA, DELTA_NAME, thread_vals);
+
+	assign_type(WAKEUP_TASK_COMM, "COMM", wakeup_task_keys);
+	assign_type(WAKEUP_THREAD_PID, "PID", wakeup_thread_keys);
+	assign_type(WAKEUP_THREAD_PRIO, "Prio", wakeup_thread_keys);
+	assign_type(WAKEUP_DELTA, DELTA_NAME, wakeup_vals)
+}
+
 static void insert_wakeup_task_data(struct traceeval *teval, 
 				    const char *comm,
 				    unsigned long long delta,
 				    unsigned long long timestamp)
 {
-	struct traceeval_data keys[1];
-	struct traceeval_data vals[1];
+	struct traceeval_data keys[TRACEEVAL_ARRAY_SIZE(wakeup_task_keys)];
+	struct traceeval_data vals[TRACEEVAL_ARRAY_SIZE(wakeup_vals)];
 
-	TRACEEVAL_SET_CSTRING(keys[0], comm);
+	TRACEEVAL_SET_CSTRING(keys[WAKEUP_TASK_COMM], comm);
 
-	TRACEEVAL_SET_DELTA(vals[0], delta, timestamp);
+	TRACEEVAL_SET_DELTA(vals[WAKEUP_DELTA], delta, timestamp);
 
 	traceeval_insert(teval, keys, vals);
 }
@@ -548,13 +617,13 @@ static void insert_wakeup_thread_data(struct traceeval *teval,
 				      unsigned long long delta,
 				      unsigned long long timestamp)
 {
-	struct traceeval_data keys[2];
-	struct traceeval_data vals[1];
+	struct traceeval_data keys[TRACEEVAL_ARRAY_SIZE(wakeup_thread_keys)];
+	struct traceeval_data vals[TRACEEVAL_ARRAY_SIZE(wakeup_vals)];
 
-	TRACEEVAL_SET_NUMBER(keys[0], tid);
-	TRACEEVAL_SET_NUMBER(keys[1], prio);
+	TRACEEVAL_SET_NUMBER(keys[WAKEUP_THREAD_PID], tid);
+	TRACEEVAL_SET_NUMBER(keys[WAKEUP_THREAD_PRIO], prio);
 
-	TRACEEVAL_SET_DELTA(vals[0], delta, timestamp);
+	TRACEEVAL_SET_DELTA(vals[WAKEUP_DELTA], delta, timestamp);
 
 	traceeval_insert(teval, keys, vals);
 }
@@ -968,22 +1037,22 @@ static int compare_pdata(struct traceeval *teval,
 				void *data)
 {
 	struct traceeval_data keysA[] = {
-		DEFINE_TRACEEVAL_CSTRING(	Akeys[0].cstring	),
-		DEFINE_TRACEEVAL_NUMBER(	RUNNING			), };
+		DEFINE_TRACEEVAL_CSTRING(	Akeys[TASK_COMM].cstring	),
+		DEFINE_TRACEEVAL_NUMBER(	RUNNING				), };
 	struct traceeval_data keysB[] = {
-		DEFINE_TRACEEVAL_CSTRING(	Bkeys[0].cstring	),
-		DEFINE_TRACEEVAL_NUMBER(	RUNNING			), };
+		DEFINE_TRACEEVAL_CSTRING(	Bkeys[TASK_COMM].cstring	),
+		DEFINE_TRACEEVAL_NUMBER(	RUNNING				), };
 	struct traceeval_stat *statA;
 	struct traceeval_stat *statB;
 	unsigned long long totalA = -1;
 	unsigned long long totalB = -1;
 
 	/* First check if we are on the same task */
-	if (strcmp(Akeys[0].cstring, Bkeys[0].cstring) == 0) {
+	if (strcmp(Akeys[TASK_COMM].cstring, Bkeys[TASK_COMM].cstring) == 0) {
 		/* Sort decending */
-		if (Bkeys[1].number > Akeys[1].number)
+		if (Bkeys[TASK_STATE].number > Akeys[TASK_STATE].number)
 			return -1;
-		return Bkeys[1].number != Akeys[1].number;
+		return Bkeys[TASK_STATE].number != Akeys[TASK_STATE].number;
 	}
 
 	/* Get the RUNNING values for both processes */
@@ -1000,7 +1069,7 @@ static int compare_pdata(struct traceeval *teval,
 	if (totalB > totalA)
 		return 1;
 
-	return strcmp(Bkeys[0].cstring, Akeys[0].cstring);
+	return strcmp(Bkeys[TASK_COMM].cstring, Akeys[TASK_COMM].cstring);
 }
 
 static void display_cpus(struct traceeval *teval)
@@ -1016,12 +1085,12 @@ static void display_cpus(struct traceeval *teval)
 
 	printf("\n");
 
-	traceeval_iterator_sort(iter, cpu_keys[0].name, 0, true);
-	traceeval_iterator_sort(iter, cpu_keys[1].name, 1, true);
+	traceeval_iterator_sort(iter, cpu_keys[CPU_KEY].name, 0, true);
+	traceeval_iterator_sort(iter, cpu_keys[CPU_STATE].name, 1, true);
 
 	while (traceeval_iterator_next(iter, &keys) > 0) {
-		int state = keys[1].number;
-		int cpu = keys[0].number;
+		int state = keys[CPU_STATE].number;
+		int cpu = keys[CPU_KEY].number;
 
 		stat = traceeval_iterator_stat(iter, DELTA_NAME);
 		if (!stat)
@@ -1140,18 +1209,18 @@ static void display_threads(struct traceeval *teval, struct traceeval *wake_teva
 	int last_prio = -1;
 
 	/* PID */
-	traceeval_iterator_sort(iter, thread_keys[0].name, 0, true);
+	traceeval_iterator_sort(iter, thread_keys[THREAD_TID].name, 0, true);
 
 	/* PRIO */
-	traceeval_iterator_sort(iter, thread_keys[1].name, 1, true);
+	traceeval_iterator_sort(iter, thread_keys[THREAD_PRIO].name, 1, true);
 
 	/* STATE */
-	traceeval_iterator_sort(iter, thread_keys[2].name, 2, true);
+	traceeval_iterator_sort(iter, thread_keys[THREAD_STATE].name, 2, true);
 
 	while (traceeval_iterator_next(iter, &keys) > 0) {
-		int tid = keys[0].number;
-		int prio = keys[1].number;
-		int state = keys[2].number;
+		int tid = keys[THREAD_TID].number;
+		int prio = keys[THREAD_PRIO].number;
+		int state = keys[THREAD_STATE].number;
 
 		stat = traceeval_iterator_stat(iter, DELTA_NAME);
 		if (!stat)
@@ -1228,7 +1297,7 @@ static void display_processes(struct traceeval *teval, struct traceeval *wake_te
 	while (traceeval_iterator_next(iter, &keys) > 0) {
 		const struct traceeval_data *results;
 		struct process_data *pdata = NULL;
-		const char *comm = keys[0].cstring;
+		const char *comm = keys[TASK_COMM].cstring;
 
 		if (strcmp(comm, last_comm) == 0)
 			continue;
@@ -1241,7 +1310,7 @@ static void display_processes(struct traceeval *teval, struct traceeval *wake_te
 		if (ret < 1)
 			continue; /* ?? */
 
-		pdata = results[0].pointer;
+		pdata = results[TASK_DATA].pointer;
 		traceeval_results_release(teval, results);
 
 		printf("Task: %s\n", comm);
@@ -1274,7 +1343,7 @@ static void display(struct task_data *tdata)
 		pdie("No cpus?");
 
 	while (traceeval_iterator_next(iter, &keys) > 0) {
-		int state = keys[1].number;
+		int state = keys[CPU_STATE].number;
 
 		stat = traceeval_iterator_stat(iter, DELTA_NAME);
 		if (!stat)
@@ -1336,11 +1405,11 @@ static void finish_leftovers(struct task_data *data)
 		traceeval_iterator_delta_stop(iter, &results, data->last_ts,
 					      &delta, NULL);
 
-		pid = keys[0].number;
+		pid = keys[TASK_DELTA_PID].number;
 
-		state = results[0].number;
-		comm = results[1].cstring;
-		prio = results[2].number;
+		state = results[TASK_DELTA_STATE].number;
+		comm = results[TASK_DELTA_COMM].cstring;
+		prio = results[TASK_DELTA_PRIO].number;
 
 		update_thread(data, pid, comm, state, prio, delta, data->last_ts);
 	}
@@ -1398,6 +1467,8 @@ int main (int argc, char **argv)
 	if (argc < 1)
 		usage();
 
+	init_indexes();
+
 	handle = tracecmd_open(argv[0], TRACECMD_FL_LOAD_NO_PLUGINS);
 	if (!handle)
 		pdie("Error opening %s", argv[0]);
-- 
2.42.0

