Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A6243AB0
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Oct 2023 23:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BAAC433C7;
	Thu,  5 Oct 2023 23:23:41 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qoXi7-005VCa-2v;
	Thu, 05 Oct 2023 19:24:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/5] libtraceeval: Add man pages for the traceeval iterator functions
Date: Thu,  5 Oct 2023 19:24:49 -0400
Message-Id: <20231005232450.1311519-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231005232450.1311519-1-rostedt@goodmis.org>
References: <20231005232450.1311519-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add man pages for:

 traceeval_iterator_get()
 traceeval_iterator_put()
 traceeval_iterator_sort()
 traceeval_iterator_sort_custom()
 traceeval_iterator_next()
 traceeval_iterator_query()
 traceeval_iterator_results_release()
 traceeval_iterator_stat()
 traceeval_iterator_remove()

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceeval-iterator.txt | 1072 +++++++++++++++++++++++
 Documentation/libtraceeval.txt          |   17 +
 2 files changed, 1089 insertions(+)
 create mode 100644 Documentation/libtraceeval-iterator.txt

diff --git a/Documentation/libtraceeval-iterator.txt b/Documentation/libtraceeval-iterator.txt
new file mode 100644
index 000000000000..8be1eb368365
--- /dev/null
+++ b/Documentation/libtraceeval-iterator.txt
@@ -0,0 +1,1072 @@
+libtraceeval(3)
+===============
+
+NAME
+----
+traceeval_iterator_get, traceeval_iterator_put, traceeval_iterator_sort, traceeval_iterator_sort_custom,
+traceeval_iterator_next, traceeval_iterator_query, traceeval_iterator_results_release, traceeval_iterator_stat,
+traceeval_iterator_remove - Operations to iterate over the elements of a traceeval
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <traceeval.h>*
+
+struct traceeval_iterator pass:[*]*traceeval_iterator_get*(struct traceeval pass:[*]_teval_);
+void *traceeval_iterator_put*(struct traceeval_iterator pass:[*]_iter_);
+int *traceeval_iterator_sort*(struct traceeval_iterator pass:[*]_iter_, const char pass:[*]_sort_field_,
+			    int _level_, bool _ascending_);
+int *traceeval_iterator_sort_custom*(struct traceeval_iterator pass:[*]_iter_,
+				   traceeval_cmp_fn _sort_fn_, void pass:[*]_data_);
+int *traceeval_iterator_next*(struct traceeval_iterator pass:[*]_iter_,
+			    const struct traceeval_data pass:[**]_keys_);
+int *traceeval_iterator_query*(struct traceeval_iterator pass:[*]_iter_,
+			     const struct traceeval_data pass:[**]_results_);
+void *traceeval_iterator_results_release*(struct traceeval_iterator pass:[*]_iter_,
+					const struct traceeval_data pass:[*]_results_);
+struct traceeval_stat pass:[*]*traceeval_iterator_stat*(struct traceeval_iterator pass:[*]_iter_,
+					       struct traceeval_type pass:[*]_type_);
+int *traceeval_iterator_remove*(struct traceeval_iterator pass:[*]_iter_);
+--
+
+DESCRIPTION
+-----------
+The traceeval utility facilitates the collection of data as a tool iterates over
+trace events. The traceeval_iterator is a means to read the data that was collected.
+
+The *traceeval_iterator_get()* takes a _teval_ descriptor of the traceeval that is
+to be extracted and returns a struct traceeval_iterator descriptor that can be
+used to iterate over the events of the traceeval.
+
+When the iterator is no longer required, *traceeval_iterator_put()* is used to
+release any of the allocated memory of the _iter_ traceeval_iterator.
+
+Before iterating, the data may be sorted using *traceeval_iterator_sort()*.
+This will sort how the elements will be iterated over via the given _iter_ iterator.
+The _sort_field_ is a string that matches the .name element of a struct traceeval_type 
+for either keys or vals that were passed into the *traceeval_init*(3) for the given
+traceeval passed to *traceeval_iterator_get()*. The _level_ is the sorting priority
+of this field, where 0 is the highest priority (sort this field first), 1 is the
+next priority (sort this field for elements that have matching fields of level 0),
+2 is the next priority and so on. This function should be called for each level.
+If a level is skipped, it may cause an error with *traceeval_iterator_next()*.
+
+If a custom sort needs to be done (one that is not simply following the fields)
+then *traceeval_iterator_sort_custom()* may be used. This takes a parameter
+_sort_fn_ that is a function of type traceeval_cmp_fn to sort. The _data_ parameter
+is used to pass data to the _sort_fn_.
+
+[verse]
+--
+typedef  int (*traceeval_cmp_fn)(struct traceeval *teval,
+				const struct traceeval_data *Akeys,
+				const struct traceeval_data *Avals,
+				const struct traceeval_data *Bkeys,
+				const struct traceeval_data *Bvals,
+				void *data);
+--
+
+The compare function passed to *traceeval_iterator_sort_custom()* takes a _teval_ that
+holds the traceeval passed to *traceeval_iterator_get()*. Then the _Akeys_ and _Avals_ of one element
+and the _Bkeys_ and _Bvals_ of another element to use for comapring the two. The _data_ is a pointer
+to the data that was passed into *traceeval_iterator_sort_custom()*. This function should return
+less than zero if Akeys and Avals is less than Bkeys and Bvals, 0 if they are equal, and greater than zero
+if greater than.
+
+The *traceeval_iterator_next()* is used to do the iteration over the traceeval passed
+to *traceeval_iterator_get()* in the sorted order defined with *traceeval_iterator_sort()*.
+If the _iter_ was not sorted, the order will be somewhat random, but all the elements
+will still be convered just once. For each iteration, _keys_ will be assigned the
+struct traceeval_data keys of the next element. If an element is found, this will return
+1.
+
+Inside the *traceeval_iterator_next()* loop, the values of the element returned by
+the keys can be quickly retrieved with *traceeval_iterator_query()*. This will
+place the values in _results_, which when finished with should call *traceeval_iterator_results_release()*
+on.
+
+
+The *traceeval_iterator_stat()* will quickly return the stats of one of the current
+element's fields (if it as desginated as a stat field). See *traceeval_stat*(3).
+
+The *traceeval_iterator_remove()* is a safe way to remove an element from the traceeval
+that was passed to *traceeval_iterator_get()*. It will remove the current element
+returned by *traceeveal_iterator_next()* from the traceeval of _iter_.
+
+RETURN VALUE
+------------
+The *traceeval_iterator_get()* returns a traceeval_iterator descriptor that will iterate
+over the given _teval_ on success, and NULL on error.
+
+The *traceeval_iterator_sort()* and traceeval_iterator_sort_custom()* return 0 on success and -1 or error.
+
+The *traceeval_iterator_next()* returns 1 when it reads a new element from the traceeval and places the element's
+keys into _keys_. It returns 0 when there's no more elements to read and -1 on error.
+
+The *traceeval_iterator_query()* returns 1 if it successfully reads the current element from the
+*traceeval_iterator_next()* and places the values in _results_. It returns 0 if there are no more elements,
+and -1 on error.
+
+The *traceeval_iterator_stat()* returns a descriptor for the current element's given _field_ on success and
+NULL if there are no current elements or the _field_ is not a valid stat type.
+
+The *traceeval_iterator_remove()* returns 1 if the current element was successfully removed, or 0
+if there was no element (called before *traceeval_iterator_next()*).
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdarg.h>
+#include <getopt.h>
+#include <errno.h>
+#include <trace-cmd.h>
+#include <traceeval.h>
+
+static char *argv0;
+
+static char *get_this_name(void)
+{
+	static char *this_name;
+	char *arg;
+	char *p;
+
+	if (this_name)
+		return this_name;
+
+	arg = argv0;
+	p = arg+strlen(arg);
+
+	while (p >= arg && *p != '/')
+		p--;
+	p++;
+
+	this_name = p;
+	return p;
+}
+
+static void usage(void)
+{
+	char *p = get_this_name();
+
+	printf("usage: %s [-c comm] trace.dat\n"
+	       "\n"
+	       "  Run this after running: trace-cmd record -e sched\n"
+	       "\n"
+	       "  Do some work and then hit Ctrl^C to stop the recording.\n"
+	       "  Run this on the resulting trace.dat file\n"
+	       "\n"
+	       "-c comm - to look at only a specific process called 'comm'\n"
+	       "\n",p);
+	exit(-1);
+}
+
+static void __vdie(const char *fmt, va_list ap, int err)
+{
+	int ret = errno;
+	char *p = get_this_name();
+
+	if (err && errno)
+		perror(p);
+	else
+		ret = -1;
+
+	fprintf(stderr, "  ");
+	vfprintf(stderr, fmt, ap);
+
+	fprintf(stderr, "\n");
+	exit(ret);
+}
+
+void die(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__vdie(fmt, ap, 0);
+	va_end(ap);
+}
+
+void pdie(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__vdie(fmt, ap, 1);
+	va_end(ap);
+}
+
+static struct traceeval_type cpu_keys[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "CPU",
+	},
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "Schedule state",
+	},
+};
+
+static struct traceeval_type process_keys[] = {
+	{
+		.type = TRACEEVAL_TYPE_STRING,
+		.name = "COMM"
+	},
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "Schedule state"
+	},
+};
+
+static struct traceeval_type process_data_vals[] = {
+	{
+		.type = TRACEEVAL_TYPE_POINTER,
+		.name = "data",
+	},
+};
+
+static struct traceeval_type thread_keys[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "TID",
+	},
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "Schedule state",
+	},
+};
+
+static struct traceeval_type timestamp_vals[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER_64,
+		.name = "Timestamp",
+		.flags = TRACEEVAL_FL_TIMESTAMP,
+	},
+};
+
+static struct traceeval_type delta_vals[] = {
+	{
+		.type	= TRACEEVAL_TYPE_NUMBER_64,
+		.name	= "delta",
+		.flags = TRACEEVAL_FL_STAT,
+	},
+};
+
+enum sched_state {
+	RUNNING,
+	BLOCKED,
+	PREEMPT,
+	SLEEP,
+	IDLE,
+	OTHER
+};
+
+struct teval_pair {
+	struct traceeval	*start;
+	struct traceeval	*stop;
+};
+
+struct process_data {
+	struct teval_pair	teval_cpus;
+	struct teval_pair	teval_threads;
+	char			*comm;
+	int			state;
+};
+
+struct task_data {
+	struct teval_pair	teval_cpus;
+	struct teval_pair	teval_processes;
+	struct traceeval	*teval_processes_data;
+	char			*comm;
+};
+
+enum command {
+	START,
+	STOP
+};
+
+static void update_process(struct task_data *tdata, const char *comm,
+			   enum sched_state state, enum command cmd,
+			   unsigned long long ts)
+{
+	struct traceeval_data keys[] = {
+		DEFINE_TRACEEVAL_CSTRING(	comm	),
+		DEFINE_TRACEEVAL_NUMBER(	state	),
+	};
+	struct traceeval_data vals[] = {
+		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
+	};
+	struct traceeval_data new_vals[1] = { };
+	const struct traceeval_data *results;
+	int ret;
+
+	switch (cmd) {
+	case START:
+		ret = traceeval_insert(tdata->teval_processes.start, keys, vals);
+		if (ret < 0)
+			pdie("Could not start process");
+		return;
+	case STOP:
+		ret = traceeval_query(tdata->teval_processes.start, keys, &results);
+		if (ret < 0)
+			pdie("Could not query start process");
+		if (ret == 0)
+			return;
+		if (!results[0].number_64)
+			break;
+
+		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
+
+		ret = traceeval_insert(tdata->teval_processes.stop, keys, new_vals);
+		if (ret < 0)
+			pdie("Could not stop process");
+
+		/* Reset the start */
+		TRACEEVAL_SET_NUMBER_64(new_vals[0], 0);
+
+		ret = traceeval_insert(tdata->teval_processes.start, keys, new_vals);
+		if (ret < 0)
+			pdie("Could not start CPU");
+		break;
+	}
+	traceeval_results_release(tdata->teval_processes.start, results);
+}
+
+static void start_process(struct task_data *tdata, const char *comm,
+			   enum sched_state state, unsigned long long ts)
+{
+	update_process(tdata, comm, state, START, ts);
+}
+
+static void stop_process(struct task_data *tdata, const char *comm,
+			   enum sched_state state, unsigned long long ts)
+{
+	update_process(tdata, comm, state, STOP, ts);
+}
+
+static struct process_data *
+get_process_data(struct task_data *tdata, const char *comm)
+{
+	struct traceeval_data keys[] = {
+		DEFINE_TRACEEVAL_CSTRING(	comm	),
+		DEFINE_TRACEEVAL_NUMBER(	RUNNING	),
+	};
+	const struct traceeval_data *results;
+	void *data;
+	int ret;
+
+	ret = traceeval_query(tdata->teval_processes_data, keys, &results);
+	if (ret < 0)
+		pdie("Could not query process data");
+	if (ret == 0)
+		return NULL;
+
+	data = results[0].pointer;
+	traceeval_results_release(tdata->teval_processes_data, results);
+	return data;
+}
+
+void set_process_data(struct task_data *tdata, const char *comm, void *data)
+{
+	struct traceeval_data keys[] = {
+		DEFINE_TRACEEVAL_CSTRING(	comm	),
+		DEFINE_TRACEEVAL_NUMBER(	RUNNING	),
+	};
+	struct traceeval_data new_vals[1] = { };
+	const struct traceeval_data *results;
+	int ret;
+
+	ret = traceeval_query(tdata->teval_processes_data, keys, &results);
+	if (ret > 0)
+		goto out; /* It already exists ? */
+	if (ret < 0)
+		pdie("Could not query process data");
+
+	TRACEEVAL_SET_POINTER(new_vals[0], data);
+	ret = traceeval_insert(tdata->teval_processes_data, keys, new_vals);
+	if (ret < 0)
+		pdie("Failed to set process data");
+
+ out:
+	traceeval_results_release(tdata->teval_processes_data, results);
+}
+
+static void update_cpu(struct teval_pair *teval_pair, int cpu,
+		       enum sched_state state, enum command cmd,
+		       unsigned long long ts)
+{
+	const struct traceeval_data *results;
+	struct traceeval_data keys[] = {
+		DEFINE_TRACEEVAL_NUMBER(	cpu	),
+		DEFINE_TRACEEVAL_NUMBER(	state	),
+	};
+	struct traceeval_data vals[] = {
+		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
+	};
+	struct traceeval_data new_vals[1] = { };
+	int ret;
+
+	switch (cmd) {
+	case START:
+		/* Only set if the timestamp is zero (or doesn't exist) */
+		ret = traceeval_query(teval_pair->start, keys, &results);
+		if (ret > 0) {
+			if (results[0].number_64)
+				break;
+		}
+		if (ret < 0)
+			pdie("Could not query cpu start data");
+		ret = traceeval_insert(teval_pair->start, keys, vals);
+		if (ret < 0)
+			pdie("Could not start CPU");
+		break;
+	case STOP:
+		ret = traceeval_query(teval_pair->start, keys, &results);
+		if (ret < 0)
+			pdie("Could not query cpu stop data");
+		if (ret == 0)
+			return;
+
+		if (!results[0].number_64)
+			break;
+
+		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
+
+		ret = traceeval_insert(teval_pair->stop, keys, new_vals);
+		if (ret < 0)
+			pdie("Could not stop CPU");
+
+		/* Reset the start */
+		TRACEEVAL_SET_NUMBER_64(new_vals[0], 0);
+		ret = traceeval_insert(teval_pair->start, keys, new_vals);
+		if (ret < 0)
+			pdie("Could not start CPU");
+
+		break;
+		default:
+			return;
+	}
+	traceeval_results_release(teval_pair->start, results);
+}
+
+static void start_cpu(struct teval_pair *teval_pair, int cpu,
+		      enum sched_state state,  unsigned long long ts)
+{
+	update_cpu(teval_pair, cpu, state, START, ts);
+}
+
+static void stop_cpu(struct teval_pair *teval_pair, int cpu,
+		     enum sched_state state, unsigned long long ts)
+{
+	update_cpu(teval_pair, cpu, state, STOP, ts);
+}
+
+static void update_thread(struct process_data *pdata, int tid,
+			  enum sched_state state, enum command cmd,
+			  unsigned long long ts)
+{
+	const struct traceeval_data *results;
+	struct traceeval_data keys[] = {
+		DEFINE_TRACEEVAL_NUMBER(	tid	),
+		DEFINE_TRACEEVAL_NUMBER(	state	),
+	};
+	struct traceeval_data vals[] = {
+		DEFINE_TRACEEVAL_NUMBER_64(	ts	),
+	};
+	struct traceeval_data new_vals[1] = { };
+	int ret;
+
+	switch (cmd) {
+	case START:
+		ret = traceeval_insert(pdata->teval_threads.start, keys, vals);
+		if (ret < 0)
+			pdie("Could not start thread");
+		return;
+	case STOP:
+		ret = traceeval_query(pdata->teval_threads.start, keys, &results);
+		if (ret < 0)
+			pdie("Could not query thread start");
+		if (ret == 0)
+			return;
+
+		TRACEEVAL_SET_NUMBER_64(new_vals[0], ts - results[0].number_64);
+
+		ret = traceeval_insert(pdata->teval_threads.stop, keys, new_vals);
+		traceeval_results_release(pdata->teval_threads.start, results);
+		if (ret < 0)
+			pdie("Could not stop thread");
+		return;
+	}
+}
+
+static void start_thread(struct process_data *pdata, int tid,
+			   enum sched_state state, unsigned long long ts)
+{
+	update_thread(pdata, tid, state, START, ts);
+}
+
+static void stop_thread(struct process_data *pdata, int tid,
+			enum sched_state state, unsigned long long ts)
+{
+	update_thread(pdata, tid, state, STOP, ts);
+}
+
+static struct tep_format_field *get_field(struct tep_event *event, const char *name)
+{
+	static struct tep_format_field *field;
+
+	field = tep_find_field(event, name);
+	if (!field)
+		die("Could not find field %s for %s",
+		    name, event->name);
+
+	return field;
+}
+
+static void init_process_data(struct process_data *pdata)
+{
+
+	pdata->teval_cpus.start = traceeval_init(cpu_keys, timestamp_vals);
+	if (!pdata->teval_cpus.start)
+		pdie("Creating trace eval cpus start");
+	pdata->teval_cpus.stop = traceeval_init(cpu_keys, delta_vals);
+	if (!pdata->teval_cpus.stop)
+		pdie("Creating trace eval cpus");
+
+	pdata->teval_threads.start = traceeval_init(thread_keys, timestamp_vals);
+	if (!pdata->teval_threads.start)
+		pdie("Creating trace eval threads start");
+
+	pdata->teval_threads.stop = traceeval_init(thread_keys, delta_vals);
+	if (!pdata->teval_threads.stop)
+		pdie("Creating trace eval threads");
+}
+
+static struct process_data *alloc_pdata(struct task_data *tdata, const char *comm)
+{
+	struct process_data *pdata;
+
+	pdata = calloc(1, sizeof(*pdata));
+	if (!pdata)
+		pdie("Allocating process data");
+	init_process_data(pdata);
+	set_process_data(tdata, comm, pdata);
+
+	return pdata;
+}
+
+static void sched_out(struct task_data *tdata, const char *comm,
+		      struct tep_event *event,
+		      struct tep_record *record, struct tep_format_field *prev_pid,
+		      struct tep_format_field *prev_state)
+{
+	struct process_data *pdata;
+	unsigned long long val;
+	int pid;
+	int ret;
+
+	ret = tep_read_number_field(prev_pid, record->data, &val);
+	if (ret < 0)
+		die("Could not read sched_switch next_pid for record");
+
+	/* Ignore the idle task */
+	pid = val;
+	if (!pid) {
+		/* Record the runtime for the process CPUs */
+		stop_cpu(&tdata->teval_cpus, record->cpu, IDLE, record->ts);
+		return;
+	}
+
+	/* The process is scheduling out. Stop the run time. */
+	update_process(tdata, comm, RUNNING, STOP, record->ts);
+
+	/* Get the process data from the process running state */
+	pdata = get_process_data(tdata, comm);
+	if (!pdata)
+		pdata = alloc_pdata(tdata, comm);
+
+	ret = tep_read_number_field(prev_state, record->data, &val);
+	if (ret < 0)
+		die("Could not read sched_switch next_pid for record");
+	val &= 3;
+	/*
+	 * Save the state the process is exiting with. Will need this
+	 * when scheduled back in.
+	 */
+	if (!val)
+		pdata->state = PREEMPT;
+	else if (val & 1)
+		pdata->state = SLEEP;
+	else if (val & 2)
+		pdata->state = BLOCKED;
+
+	/* Record the state timings for the process */
+	start_process(tdata, comm, pdata->state, record->ts);
+
+	/* Record the state timings for the individual thread */
+	stop_thread(pdata, pid, RUNNING, record->ts);
+
+	/* Record the state timings for the individual thread */
+	start_thread(pdata, pid, pdata->state, record->ts);
+
+	/* Record the runtime for the process CPUs */
+	stop_cpu(&pdata->teval_cpus, record->cpu, RUNNING, record->ts);
+
+	/* Record the runtime for the all CPUs */
+	stop_cpu(&tdata->teval_cpus, record->cpu, RUNNING, record->ts);
+}
+
+static void sched_in(struct task_data *tdata, const char *comm,
+		     struct tep_event *event,
+		     struct tep_record *record, struct tep_format_field *next_pid)
+{
+	struct process_data *pdata;
+	unsigned long long val;
+	bool is_new = false;
+	int ret;
+	int pid;
+
+	ret = tep_read_number_field(next_pid, record->data, &val);
+	if (ret < 0)
+		die("Could not read sched_switch next_pid for record");
+	pid = val;
+
+	/* Ignore the idle task */
+	if (!pid) {
+		/* Record the runtime for the process CPUs */
+		start_cpu(&tdata->teval_cpus, record->cpu, IDLE, record->ts);
+		return;
+	}
+
+	/* Start recording the running time of this process */
+	start_process(tdata, comm, RUNNING, record->ts);
+
+	pdata = get_process_data(tdata, comm);
+
+	/* Start recording the running time of process CPUs */
+	start_cpu(&tdata->teval_cpus, record->cpu, RUNNING, record->ts);
+
+	/* If there was no pdata, then this process did not go through sched out */
+	if (!pdata) {
+		pdata = alloc_pdata(tdata, comm);
+		is_new = true;
+	}
+
+	/* Record the state timings for the individual thread */
+	start_thread(pdata, pid, RUNNING, record->ts);
+
+	/* Start recording the running time of process CPUs */
+	start_cpu(&pdata->teval_cpus, record->cpu, RUNNING, record->ts);
+
+	/* If it was just created, there's nothing to stop */
+	if (is_new)
+		return;
+
+	/* Stop recording the thread time for its scheduled out state */
+	stop_thread(pdata, val, pdata->state, record->ts);
+
+	/* Stop recording the process time for its scheduled out state */
+	stop_process(tdata, comm, pdata->state, record->ts);
+}
+
+static int switch_func(struct tracecmd_input *handle, struct tep_event *event,
+		       struct tep_record *record, int cpu, void *data)
+{
+	static struct tep_format_field *prev_comm;
+	static struct tep_format_field *prev_pid;
+	static struct tep_format_field *prev_state;
+	static struct tep_format_field *next_comm;
+	static struct tep_format_field *next_pid;
+	struct task_data *tdata = data;
+	const char *comm;
+
+	if (!next_comm) {
+		prev_comm = get_field(event, "prev_comm");
+		prev_pid = get_field(event, "prev_pid");
+		prev_state = get_field(event, "prev_state");
+
+		next_comm = get_field(event, "next_comm");
+		next_pid = get_field(event, "next_pid");
+	}
+
+	comm = record->data + prev_comm->offset;
+	if (!tdata->comm || strcmp(comm, tdata->comm) == 0)
+		sched_out(tdata, comm, event, record, prev_pid, prev_state);
+
+	comm = record->data + next_comm->offset;
+	if (!tdata->comm || strcmp(comm, tdata->comm) == 0)
+		sched_in(tdata, comm, event, record, next_pid);
+
+	return 0;
+}
+
+static void print_microseconds(int idx, unsigned long long nsecs)
+{
+	unsigned long long usecs;
+
+	usecs = nsecs / 1000;
+	if (!nsecs || usecs)
+		printf("%*lld\n", idx, usecs);
+	else
+		printf("%*d.%03lld\n", idx, 0, nsecs);
+}
+
+/*
+ * Sort all the processes by the RUNNING state.
+ *  If A and B have the same COMM, then sort by state.
+ *  else
+ *    Find the RUNNNIG state for A and B
+ *    If the RUNNING state does not exist, it's considered -1
+ *  If RUNNING is equal, then sort by COMM.
+ */
+static int compare_pdata(struct traceeval *teval_data,
+				const struct traceeval_data *Akeys,
+				const struct traceeval_data *Avals,
+				const struct traceeval_data *Bkeys,
+				const struct traceeval_data *Bvals,
+				void *data)
+{
+	struct traceeval *teval = data; /* The deltas are here */
+	struct traceeval_data keysA[] = {
+		DEFINE_TRACEEVAL_CSTRING(	Akeys[0].cstring	),
+		DEFINE_TRACEEVAL_NUMBER(	RUNNING			), };
+	struct traceeval_data keysB[] = {
+		DEFINE_TRACEEVAL_CSTRING(	Bkeys[0].cstring	),
+		DEFINE_TRACEEVAL_NUMBER(	RUNNING			), };
+	struct traceeval_stat *statA;
+	struct traceeval_stat *statB;
+	unsigned long long totalA = -1;
+	unsigned long long totalB = -1;
+
+	/* First check if we are on the same task */
+	if (strcmp(Akeys[0].cstring, Bkeys[0].cstring) == 0) {
+		/* Sort decending */
+		if (Bkeys[1].number > Akeys[1].number)
+			return -1;
+		return Bkeys[1].number != Akeys[1].number;
+	}
+
+	/* Get the RUNNING values for both processes */
+	statA = traceeval_stat(teval, keysA, delta_vals[0].name);
+	if (statA)
+		totalA = traceeval_stat_total(statA);
+
+	statB = traceeval_stat(teval, keysB, delta_vals[0].name);
+	if (statB)
+		totalB = traceeval_stat_total(statB);
+
+	if (totalB < totalA)
+		return -1;
+	if (totalB > totalA)
+		return 1;
+
+	return strcmp(Bkeys[0].cstring, Akeys[0].cstring);
+}
+
+static void display_cpus(struct traceeval *teval)
+{
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
+	const struct traceeval_data *keys;
+	struct traceeval_stat *stat;
+	int last_cpu = -1;
+
+	if (!iter)
+		pdie("Could not get iterator?");
+
+	printf("\n");
+
+	traceeval_iterator_sort(iter, cpu_keys[0].name, 0, true);
+	traceeval_iterator_sort(iter, cpu_keys[1].name, 1, true);
+
+	while (traceeval_iterator_next(iter, &keys) > 0) {
+		int state = keys[1].number;
+		int cpu = keys[0].number;
+
+		stat = traceeval_iterator_stat(iter, delta_vals[0].name);
+		if (!stat)
+			continue; // die?
+
+		if (last_cpu != cpu)
+			printf("    CPU [%d]:\n", cpu);
+
+		switch (state) {
+		case RUNNING:
+			printf("       Running: ");
+			break;
+		case IDLE:
+			printf("          Idle: ");
+			break;
+		case BLOCKED:
+		case PREEMPT:
+		case SLEEP:
+		case OTHER:
+			printf("         \?\?(%d): ", state);
+			break;
+		}
+		printf(" time (us):");
+		print_microseconds(12, traceeval_stat_total(stat));
+
+		last_cpu = cpu;
+	}
+
+	if (last_cpu < 0)
+		die("No result for CPUs\n");
+
+}
+
+static void display_state_times(int state, unsigned long long total)
+{
+	switch (state) {
+	case RUNNING:
+		printf("      Total run time (us):");
+		print_microseconds(14, total);
+		break;
+	case BLOCKED:
+		printf("      Total blocked time (us):");
+		print_microseconds(10, total);
+		break;
+	case PREEMPT:
+		printf("      Total preempt time (us):");
+		print_microseconds(10, total);
+		break;
+	case SLEEP:
+		printf("      Total sleep time (us):");
+		print_microseconds(12, total);
+	}
+}
+
+static void display_threads(struct traceeval *teval)
+{
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
+	const struct traceeval_data *keys;
+	struct traceeval_stat *stat;
+	int last_tid = -1;
+
+	traceeval_iterator_sort(iter, thread_keys[0].name, 0, true);
+	traceeval_iterator_sort(iter, thread_keys[1].name, 1, true);
+
+	while (traceeval_iterator_next(iter, &keys) > 0) {
+		int state = keys[1].number;
+		int tid = keys[0].number;
+
+		stat = traceeval_iterator_stat(iter, delta_vals[0].name);
+		if (!stat)
+			continue; // die?
+
+		if (last_tid != keys[0].number)
+			printf("\n    thread id: %d\n", tid);
+
+		last_tid = tid;
+
+		display_state_times(state, traceeval_stat_total(stat));
+	}
+
+	if (last_tid < 0)
+		die("No result for threads\n");
+
+}
+
+static void display_process(struct process_data *pdata)
+{
+	display_threads(pdata->teval_threads.stop);
+	display_cpus(pdata->teval_cpus.stop);
+	printf("\n");
+}
+
+static void display_process_stats(struct traceeval *teval,
+				  struct process_data *pdata, const char *comm)
+{
+	struct traceeval_stat *stat;
+	unsigned long long delta;
+	struct traceeval_data keys[] = {
+		DEFINE_TRACEEVAL_CSTRING(	comm		),
+		DEFINE_TRACEEVAL_NUMBER(	RUNNING		),
+	};
+
+	for (int i = 0; i < OTHER; i++) {
+		TRACEEVAL_SET_NUMBER(keys[1], i);
+
+		delta = 0;
+		stat = traceeval_stat(teval, keys, delta_vals[0].name);
+		if (stat)
+			delta = traceeval_stat_total(stat);
+		display_state_times(i, delta);
+	}
+}
+
+static void display_processes(struct traceeval *teval,
+			      struct traceeval *teval_data)
+{
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval_data);
+	const struct traceeval_data *keys;
+	int ret;
+
+	traceeval_iterator_sort_custom(iter, compare_pdata, teval);
+
+	while (traceeval_iterator_next(iter, &keys) > 0) {
+		const struct traceeval_data *results;
+		struct process_data *pdata = NULL;
+		const char *comm = keys[0].cstring;
+
+		ret = traceeval_iterator_query(iter, &results);
+		if (ret < 0)
+			pdie("Could not query iterator");
+		if (ret < 1)
+			continue; /* ?? */
+
+		pdata = results[0].pointer;
+		traceeval_results_release(teval_data, results);
+
+		printf("Task: %s\n", comm);
+
+		display_process_stats(teval, pdata, comm);
+		if (pdata)
+			display_process(pdata);
+	}
+}
+
+static void display(struct task_data *tdata)
+{
+	struct traceeval *teval = tdata->teval_cpus.stop;
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
+	const struct traceeval_data *keys;
+	struct traceeval_stat *stat;
+	unsigned long long total_time = 0;
+	unsigned long long idle_time = 0;
+
+	if (tdata->comm) {
+		return display_processes(tdata->teval_processes.stop,
+					 tdata->teval_processes_data);
+	}
+
+	printf("Total:\n");
+
+	if (!iter)
+		pdie("No cpus?");
+
+	while (traceeval_iterator_next(iter, &keys) > 0) {
+		int state = keys[1].number;
+
+		stat = traceeval_iterator_stat(iter, delta_vals[0].name);
+		if (!stat)
+			continue;
+
+		switch (state) {
+		case RUNNING:
+			total_time += traceeval_stat_total(stat);
+			break;
+		case IDLE:
+			idle_time += traceeval_stat_total(stat);
+			break;
+		default:
+			die("Invalid CPU state: %d\n", state);
+		}
+	}
+
+	printf("  Total  run time (us):");
+	print_microseconds(16, total_time);
+	printf("  Total idle time (us):");
+	print_microseconds(16, idle_time);
+
+	display_cpus(tdata->teval_cpus.stop);
+
+	printf("\n");
+	display_processes(tdata->teval_processes.stop, tdata->teval_processes_data);
+}
+
+static void free_tdata(struct task_data *tdata)
+{
+}
+
+int main (int argc, char **argv)
+{
+	struct tracecmd_input *handle;
+	struct task_data data;
+	int c;
+
+	memset(&data, 0, sizeof(data));
+
+	argv0 = argv[0];
+
+	while ((c = getopt(argc, argv, "c:h")) >= 0) {
+		switch (c) {
+		case 'c':
+			data.comm = optarg;
+			break;
+		case 'h':
+		default:
+			usage();
+		}
+	}
+
+	argc -= optind;
+	argv += optind;
+
+	if (argc < 1)
+		usage();
+
+	handle = tracecmd_open(argv[0], TRACECMD_FL_LOAD_NO_PLUGINS);
+	if (!handle)
+		pdie("Error opening %s", argv[0]);
+
+	data.teval_processes.start = traceeval_init(process_keys, timestamp_vals);
+	if (!data.teval_processes.start)
+		pdie("Creating trace eval start");
+	data.teval_processes_data = traceeval_init(process_keys, process_data_vals);
+	if (!data.teval_processes_data)
+		pdie("Creating trace eval data");
+	data.teval_processes.stop = traceeval_init(process_keys, delta_vals);
+	if (!data.teval_processes.stop)
+		pdie("Creating trace eval");
+
+	data.teval_cpus.start = traceeval_init(cpu_keys, timestamp_vals);
+	if (!data.teval_cpus.start)
+		pdie("Creating trace eval");
+	data.teval_cpus.stop = traceeval_init(cpu_keys, delta_vals);
+	if (!data.teval_cpus.stop)
+		pdie("Creating trace eval");
+
+	tracecmd_follow_event(handle, "sched", "sched_switch", switch_func, &data);
+
+	tracecmd_iterate_events(handle, NULL, 0, NULL, NULL);
+
+	display(&data);
+
+	free_tdata(&data);
+
+	return 0;
+}
+--
+
+FILES
+-----
+[verse]
+--
+*traceval.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceeval*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+*libtraceeval*(3)
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceeval*.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceeval is licensed under MIT.
+
diff --git a/Documentation/libtraceeval.txt b/Documentation/libtraceeval.txt
index 9f753aaadf12..fc7c621878ac 100644
--- a/Documentation/libtraceeval.txt
+++ b/Documentation/libtraceeval.txt
@@ -41,6 +41,23 @@ Inserting and removing elements from the traceeval:
 			       const struct traceeval_data pass:[**]_results_);
 
 	size_t *traceeval_count*(struct traceeval pass:[*]_teval_);
+
+Functions for iterating over the elements of the libtraceeval:
+	struct traceeval_iterator pass:[*]*traceeval_iterator_get*(struct traceeval pass:[*]_teval_);
+	void *traceeval_iterator_put*(struct traceeval_iterator pass:[*]_iter_);
+	int *traceeval_iterator_sort*(struct traceeval_iterator pass:[*]_iter_, const char pass:[*]_sort_field_,
+			    int _level_, bool _ascending_);
+	int *traceeval_iterator_sort_custom*(struct traceeval_iterator pass:[*]_iter_,
+				   traceeval_cmp_fn _sort_fn_, void pass:[*]_data_);
+	int *traceeval_iterator_next*(struct traceeval_iterator pass:[*]_iter_,
+			    const struct traceeval_data pass:[**]_keys_);
+	int *traceeval_iterator_query*(struct traceeval_iterator pass:[*]_iter_,
+			     const struct traceeval_data pass:[**]_results_);
+	void *traceeval_iterator_results_release*(struct traceeval_iterator pass:[*]_iter_,
+					const struct traceeval_data pass:[*]_results_);
+	struct traceeval_stat pass:[*]*traceeval_iterator_stat*(struct traceeval_iterator pass:[*]_iter_,
+					       struct traceeval_type pass:[*]_type_);
+	int *traceeval_iterator_remove*(struct traceeval_iterator pass:[*]_iter_);
 --
 
 DESCRIPTION
-- 
2.40.1

