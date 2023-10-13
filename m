Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B32A380
	for <linux-trace-devel@vger.kernel.org>; Fri, 13 Oct 2023 00:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE867C433C7;
	Fri, 13 Oct 2023 00:48:59 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qr6Nm-008Upl-1R;
	Thu, 12 Oct 2023 20:50:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtraceeval: Add man pages for libtraceeval_delta retrieving of deltas
Date: Thu, 12 Oct 2023 20:49:28 -0400
Message-ID: <20231013005025.2025080-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231013005025.2025080-1-rostedt@goodmis.org>
References: <20231013005025.2025080-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add man pages for:

 traceeval_delta_stat()
 traceeval_delta_stat_size()
 traceeval_delta_teval_get()
 traceeval_delta_teval_put()
 traceeval_iterator_delta_stat()

Link: https://lore.kernel.org/linux-trace-devel/20231006185405.1379249-4-rostedt@goodmis.org
Link: https://lore.kernel.org/linux-trace-devel/20231006201214.1385447-4-rostedt@goodmis.org

Cc: Ross Zwisler <zwisler@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceeval-delta-rest.txt | 292 ++++++++++++++++++++++
 Documentation/libtraceeval.txt            |  14 ++
 2 files changed, 306 insertions(+)
 create mode 100644 Documentation/libtraceeval-delta-rest.txt

diff --git a/Documentation/libtraceeval-delta-rest.txt b/Documentation/libtraceeval-delta-rest.txt
new file mode 100644
index 000000000000..05cf262a665b
--- /dev/null
+++ b/Documentation/libtraceeval-delta-rest.txt
@@ -0,0 +1,292 @@
+libtraceeval(3)
+===============
+
+NAME
+----
+traceeval_delta_query, traceeval_delta_query_size, traceeval_iterator_delta_start_get,
+traceeval_iterator_delta_stop - Miscellaneous traceeval delta functions
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <traceeval.h>*
+
+int *traceeval_delta_query*(struct traceeval pass:[*]_teval_, const struct traceeval_data pass:[*]_keys_,
+			    const struct traceeval_data pass:[**]_results_);
+int *traceeval_delta_query_size*(struct traceeval pass:[*]_teval_, const struct traceeval_data pass:[*]_keys_,
+				 size_t _nr_keys_, const struct traceeval_data pass:[**]_results_);
+
+struct traceeval_iterator pass:[*]*traceeval_iterator_delta_start_get*(struct traceeval pass:[*]_teval_);
+int *traceeval_iterator_delta_stop*(struct traceeval_iterator pass:[*]_iter_,
+				  const struct traceeval_data pass:[**]_results_,
+				  unsigned long long _timestamp_,
+				  unsigned long long pass:[*]_delta_,
+				  unsigned long long pass:[*]_start_ts_);
+--
+
+DESCRIPTION
+-----------
+The traceeval_delta functions are used to record the time deltas between events.
+These are some more functions that can be useful with the traceeval_delta that
+is stored in a traceveal.
+
+The *traceeval_delta_query()* is used to be able to find a previous element that was started
+with either *traceeval_delta_start*(3) or *traceeval_delta_continue*(3). It returns the
+values just like *traceeval_delta_stop*(3) would do except that it does not modify the
+state of the delta information. That is, it will not affect the timings that are currently
+being processed. It looks at the _teval_ delta data and searches for an element that
+matches _keys_ in from a *traceveal_delta_start/continue*(3). If it finds one, then it
+fills in _results_ with the values that were passed to the start function and also includes
+the timestamp of the start if _timestamp_ is not NULL.
+
+Note that *traceeval_delta_query()* 
+
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
+#include <trace-cmd.h>
+#include <traceeval.h>
+
+static struct traceeval_type task_types[] = {
+	{
+		.name		= "COMM",
+		.type		= TRACEEVAL_TYPE_STRING,
+	},
+	{
+		.name		= "PID",
+		.type		= TRACEEVAL_TYPE_NUMBER,
+	}
+};
+
+static struct traceeval_type cpu_types[] = {
+	{
+		.name		= "CPU",
+		.type		= TRACEEVAL_TYPE_NUMBER,
+	}
+};
+
+struct data {
+	struct traceeval_delta		*tdelta_tasks;
+	struct traceeval_delta		*tdelta_cpus;
+};
+
+static struct tep_format_field *get_field(struct tep_event *event, const char *name)
+{
+	static struct tep_format_field *field;
+
+	field = tep_find_field(event, name);
+	if (!field) {
+		fprintf(stderr, "Could not find field %s for %s", name, event->name);
+		exit(-1);
+	}
+
+	return field;
+}
+
+static int switch_func(struct tracecmd_input *handle, struct tep_event *event,
+		       struct tep_record *record, int cpu, void *d)
+{
+	static struct tep_format_field *prev_comm;
+	static struct tep_format_field *prev_pid;
+	static struct tep_format_field *next_comm;
+	static struct tep_format_field *next_pid;
+	struct traceeval_data task_keys[2];
+	struct traceeval_data cpu_keys[1];
+	struct data *data = d;
+	unsigned long long val;
+	const char *comm;
+
+	if (!next_comm) {
+		prev_comm = get_field(event, "prev_comm");
+		prev_pid = get_field(event, "prev_pid");
+
+		next_comm = get_field(event, "next_comm");
+		next_pid = get_field(event, "next_pid");
+	}
+
+	comm = record->data + prev_comm->offset;
+	tep_read_number_field(prev_pid, record->data, &val);
+
+	TRACEEVAL_SET_CSTRING(task_keys[0], comm);
+	TRACEEVAL_SET_NUMBER(task_keys[1], val);
+
+	if (val)
+		traceeval_delta_stop(data->tdelta_tasks, task_keys, record->ts);
+
+	comm = record->data + next_comm->offset;
+	tep_read_number_field(next_pid, record->data, &val);
+
+	TRACEEVAL_SET_CSTRING(task_keys[0], comm);
+	TRACEEVAL_SET_NUMBER(task_keys[1], val);
+
+	TRACEEVAL_SET_NUMBER(cpu_keys[0], record->cpu);
+
+	if (val) {
+		if (traceeval_delta_start(data->tdelta_tasks, task_keys, record->ts) < 0)
+			printf("FAILED\n");
+		traceeval_delta_continue(data->tdelta_cpus, cpu_keys, record->ts);
+	} else {
+		traceeval_delta_stop(data->tdelta_cpus, cpu_keys, record->ts);
+	}
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
+		printf("%*lld", idx, usecs);
+	else
+		printf("%*d.%03lld", idx, 0, nsecs);
+}
+
+static void print_stat(struct traceeval_stat *stat)
+{
+	unsigned long long total;
+	unsigned long long cnt;
+	unsigned long long ts;
+
+	printf("\tmax: ");
+	print_microseconds(12, traceeval_stat_max_timestamp(stat, &ts));
+	printf("  timestamp: ");
+	print_microseconds(10, ts);
+	printf("\n\tmin: ");
+	print_microseconds(12, traceeval_stat_min_timestamp(stat, &ts));
+	printf("  timestamp: ");
+	print_microseconds(10, ts);
+	printf("\n\ttotal: ");
+	total = traceeval_stat_total(stat);
+	print_microseconds(10, total);
+	cnt = traceeval_stat_count(stat);
+	printf("\n\tcount: %*lld\n", 10, cnt);
+	printf("\taverage:");
+	print_microseconds(9, cnt ? total / cnt : 0);
+	printf("\n");
+}
+
+static void display_cpus(struct traceeval_delta *tdelta)
+{
+	struct traceeval *teval = traceeval_delta_teval_get(tdelta);
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
+	const struct traceeval_data *keys;
+
+	printf("\n");
+
+	traceeval_iterator_sort(iter, cpu_types[0].name, 0, true);
+
+	while (traceeval_iterator_next(iter, &keys) > 0) {
+		struct traceeval_stat *stat;
+
+		stat = traceeval_iterator_delta_stat(iter);
+
+		printf("CPU [%zd]:\n", keys[0].number);
+		print_stat(stat);
+	}
+	traceeval_delta_teval_put(teval);
+}
+
+static void display_tasks(struct traceeval_delta *tdelta)
+{
+	struct traceeval *teval = traceeval_delta_teval_get(tdelta);
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
+	const struct traceeval_data *keys;
+
+	printf("\n");
+
+	traceeval_iterator_sort(iter, task_types[0].name, 0, true);
+	traceeval_iterator_sort(iter, task_types[1].name, 1, true);
+
+	while (traceeval_iterator_next(iter, &keys) > 0) {
+		struct traceeval_stat *stat;
+
+		stat = traceeval_iterator_delta_stat(iter);
+
+		printf("Task %s [%zd]:\n", keys[0].cstring, keys[1].number);
+		print_stat(stat);
+	}
+
+	traceeval_delta_teval_put(teval);
+};
+
+int main (int argc, char **argv)
+{
+	struct tracecmd_input *handle;
+	struct data data;
+
+	if (argc < 2) {
+		printf("Need to pass trace.dat file to this\n");
+		exit(-1);
+	}
+
+	handle = tracecmd_open(argv[1], TRACECMD_FL_LOAD_NO_PLUGINS);
+
+	data.tdelta_tasks = traceeval_delta_init(task_types, NULL);
+	data.tdelta_cpus = traceeval_delta_init(cpu_types, NULL);
+
+	tracecmd_follow_event(handle, "sched", "sched_switch", switch_func, &data);
+	tracecmd_iterate_events(handle, NULL, 0, NULL, NULL);
+
+	display_cpus(data.tdelta_cpus);
+	display_tasks(data.tdelta_tasks);
+
+	traceeval_delta_release(data.tdelta_cpus);
+	traceeval_delta_release(data.tdelta_tasks);
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
index e856d1152594..a8644b3b3c74 100644
--- a/Documentation/libtraceeval.txt
+++ b/Documentation/libtraceeval.txt
@@ -116,6 +116,20 @@ Handling delta times between events:
 				  const struct traceeval_data pass:[*]keys, size_t _nr_keys_,
 				  const struct traceeval_data pass:[*]_vals_, size_t _nr_vals_,
 				  unsigned long long _timestamp_);
+
+Handling reading the deltas of a traceeval_delta:
+	struct traceeval_stat pass:[*]*traceeval_delta_stat*(struct traceeval_delta pass:[*]_tdelta_,
+						 const struct traceeval_data pass:[*]_keys_)
+	struct traceeval_stat pass:[*]*traceeval_delta_stat_size*(struct traceeval_delta pass:[*]_tdelta_,
+						 const struct traceeval_data pass:[*]_keys_,
+						 size_t _nr_keys_);
+
+	struct traceeval pass:[*]*traceeval_delta_teval_get*(struct traceeval_delta pass:[*]_tdelta_);
+
+	void *traceeval_delta_teval_put*(struct traceeval_delta pass:[*]_tdelta_,
+			       struct traceeval pass:[*]_teval_);
+
+	struct traceeval_stat pass:[*]*traceeval_iterator_delta_stat*(struct traceeval_iterator pass:[*]_iter_);
 --
 
 DESCRIPTION
-- 
2.42.0

