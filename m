Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A673041AB4
	for <linux-trace-devel@vger.kernel.org>; Fri,  6 Oct 2023 20:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14144C433C7;
	Fri,  6 Oct 2023 20:11:03 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qorBH-005oRf-2P;
	Fri, 06 Oct 2023 16:12:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 1/3] libtraceeval: Add man pages for traceeval_delta init/start/stop functions
Date: Fri,  6 Oct 2023 16:12:12 -0400
Message-Id: <20231006201214.1385447-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006201214.1385447-1-rostedt@goodmis.org>
References: <20231006201214.1385447-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add man pages for:

 traceeval_delta_init()
 traceeval_delta_init_size()
 traceeval_delta_release()
 traceeval_delta_start()
 traceeval_delta_start_size()
 traceeval_delta_stop()
 traceeval_delta_stop_size()
 traceeval_delta_continue()
 traceeval_delta_continue_size()

Link: https://lore.kernel.org/linux-trace-devel/20231006185405.1379249-2-rostedt@goodmis.org

Cc: Ross Zwisler <zwisler@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceeval-delta-init.txt | 346 ++++++++++++++++++++++
 Documentation/libtraceeval.txt            |  29 ++
 check-manpages.sh                         |   2 +-
 3 files changed, 376 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/libtraceeval-delta-init.txt

diff --git a/Documentation/libtraceeval-delta-init.txt b/Documentation/libtraceeval-delta-init.txt
new file mode 100644
index 000000000000..9d37035dcd60
--- /dev/null
+++ b/Documentation/libtraceeval-delta-init.txt
@@ -0,0 +1,346 @@
+libtraceeval(3)
+===============
+
+NAME
+----
+traceeval_delta_init, traceeval_delta_init_size, traceeval_delta_release,
+traceeval_delta_start, traceeval_delta_start_size, traceeval_delta_stop,
+traceeval_delta_stop_size, traceeval_delta_continue, traceeval_delta_continue_size
+- Create and start/stop a traceeval_delta instance
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <traceeval.h>*
+
+struct traceeval_delta pass:[*]*traceeval_delta_init*(struct traceeval_type pass:[*]_keys_,
+					     struct traceeval_type pass:[*]_vals_);
+struct traceeval_delta pass:[*]*traceeval_delta_init_size*(struct traceeval_type pass:[*]_keys_,
+						  struct traceeval_type pass:[*]_vals_,
+						  size_t _nr_keys_, size_t _nr_vals_);
+void *traceeval_delta_release*(struct traceeval_delta pass:[*]tdelta);
+
+int *traceeval_delta_start*(struct traceeval_delta pass:[*]_tdelta_,
+			  const struct traceeval_data pass:[*]_keys_,
+			  unsigned long long _timestamp_);
+int *traceeval_delta_start_size*(struct traceeval_delta pass:[*]_tdelta_,
+			       const struct traceeval_data pass:[*]keys, size_t _nr_keys_,
+			       unsigned long long _timestamp_);
+
+int *traceeval_delta_stop*(struct traceeval_delta pass:[*]_tdelta_,
+			 const struct traceeval_data pass:[*]_keys_,
+			 unsigned long long _timestamp_);
+int *traceeval_delta_stop_size*(struct traceeval_delta pass:[*]_tdelta_,
+			      const struct traceeval_data pass:[*]_keys_, size_t _nr_keys_,
+			      unsigned long long _timestamp_);
+
+int *traceeval_delta_continue*(struct traceeval_delta pass:[*]_tdelta_,
+			     const struct traceeval_data pass:[*]_keys_,
+			     unsigned long long _timestamp_);
+int *traceeval_delta_continue_size*(struct traceeval_delta pass:[*]_tdelta_,
+				  const struct traceeval_data pass:[*]keys, size_t _nr_keys_,
+				  unsigned long long _timestamp_);
+--
+
+DESCRIPTION
+-----------
+The traceeval handles mapping keys and values for various events. One common use case
+is to attach two traceevals together via the same keys, and to have one of the values
+be a timestamp. The first event would record the current timestamp and the second
+event would query the traceeval that is used by the first event using the current
+keys to retrieve the timestamp of the event that matches the second event. This
+timestamp would be used to calculate the delta between the current timestamp, and that
+would be saved in another traceeval to record the deltas. This delta value would be
+tagged as a TRACEEVAL_FL_STAT to keep track of the maximum and mimimum deltas along
+with the timestamp of where those occurred.
+
+Since the above is very common, the traceeval_delta is used to facilitate this approach.
+Instead of having two traceevals to handle this situation, a single traceeval_delta
+can be used.
+
+The *traceeval_delta_init()* takes the _keys_ and _vals_ just like *traceeval_init*(3)
+does. The difference is that this function will add two additional values to hold
+a timestamp and the delta. The _keys_ must be something that can match the two events
+that are to be timed. The _vals_ is optional and can accept NULL. If _vals_ is used
+it can be returned by *traceeval_delta_query*(3) and from *traceeval_iterator_query*(3).
+
+The _keys_ and _vals_ passed to *traceeval_delta_init()* must be a static array. If
+dynamically sized arrays are to be required, then *traceeval_delta_init_size()* can be
+used and the caller can pass in _nr_keys_ to denote how many _keys_ are being passed in
+as well as _nr_vals_ to denote how many _vals_ are passed in (0 for NULL).
+
+The *traceeval_delta_release()* frees all the resources of a traceeval_delta created
+by *traceeval_delta_init()* or *traceeval_delta_init_size()*.
+
+The traceeval_delta is for timing between two events, and only the _keys_ and _timestamp_ need
+to be used to do so. When the starting event is found, a call to *traceeval_delta_start()*
+is done passing in the _keys_ that differentiate the event and will map to the stopping event,
+and the _timestamp_ to start the timings. This will be saved in the _tdelta_ that was created
+by one of the *traceeval_delta_init()* functions.
+
+When an ending event is found and a delta is to be recorded from the starting event,
+*traceeval_delta_stop()* is used. Passing the _keys_ that match the starting event
+and a _timestamp_ to calculate the delta, where this timestamp will subtract
+the timestamp passed to *traceeval_delta_start()* or *traceeval_delta_continue()*
+to create the delta between the two and save that in the given _tdelta_.
+
+There's some cases where there may be more than one starting event, and the first
+starting event is to be required for starting the timings and any new starting event
+that happens before an ending event occurs should be ignored. In this case,
+*traceeval_delta_continue()* is used. It acts the same as *traceeval_delta_start()*
+except that if the matching _keys_ have not encountered a *traceeval_delta_stop()*
+since a previous *traceeval_delta_start()* or *traceeval_delta_continue()* then
+the _tdelta_ will not be updated.
+
+To describe one use case for this, if the runtime of a CPU is being recorded,
+and anytime a task is scheduled on the CPU, it is considered a starting event,
+but the delta should be only used when the CPU switches from idle to running a task,
+*traceeval_delta_continue()* can be used whenever a task is scheduled on the CPU
+and *traceeval_delta_stop()* can be used when the CPU goes idle. Only the first
+occurrence of a task scheduling on the CPU will start the timing. If a task
+is scheduled on the CPU when another task was already running, no update should
+be made. If *traceeval_delta_start()* is used, the timestamp of the start event
+will be that of the time the new task came onto the CPU preempting the previous
+task and that would only show the runtime of the last task and not how long the
+CPU itself was running tasks.
+
+The *traceeval_delta_continue()* _keys_ must be a static array, if a dynamic array
+is required then *traceveal_delta_continue_size()* is to be used to specify the
+size of _keys_ with _nr_keys_.
+
+RETURN VALUE
+------------
+The *traceeval_delta_init()* and *traceeval_delta_init_size()* both return a descriptor
+to the traceeval_delta or NULL on error.
+
+The *traceeval_delta_start()*, *traceeval_delta_start_size()*, *traceeval_delta_stop()*,
+*traceeval_delta_stop_size()*, traceeval_delta_continue()* and *traceeval_delta_continue_size()*
+all return 0 on success and -1 on error.
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
index 173b1ddb3df8..4d23ba0c5928 100644
--- a/Documentation/libtraceeval.txt
+++ b/Documentation/libtraceeval.txt
@@ -74,6 +74,35 @@ Functions to manage statistics of values of a traceeval:
 	unsigned long long *traceeval_stat_min_timestamp*(struct traceeval_stat pass:[*]_stat_, unsigned long long pass:[*]ts);
 	unsigned long long *traceeval_stat_total*(struct traceeval_stat pass:[*]_stat_);
 	unsigned long long *traceeval_stat_count*(struct traceeval_stat pass:[*]_stat_);
+
+Handling delta times between events:
+	struct traceeval_delta pass:[*]*traceeval_delta_init*(struct traceeval_type pass:[*]_keys_,
+					     struct traceeval_type pass:[*]_vals_);
+	struct traceeval_delta pass:[*]*traceeval_delta_init_size*(struct traceeval_type pass:[*]_keys_,
+						  struct traceeval_type pass:[*]_vals_,
+						  size_t _nr_keys_, size_t _nr_vals_);
+	void *traceeval_delta_release*(struct traceeval_delta pass:[*]tdelta);
+
+	int *traceeval_delta_start*(struct traceeval_delta pass:[*]_tdelta_,
+			  const struct traceeval_data pass:[*]_keys_,
+			  unsigned long long _timestamp_);
+	int *traceeval_delta_start_size*(struct traceeval_delta pass:[*]_tdelta_,
+			       const struct traceeval_data pass:[*]keys, size_t _nr_keys_,
+			       unsigned long long _timestamp_);
+
+	int *traceeval_delta_stop*(struct traceeval_delta pass:[*]_tdelta_,
+			 const struct traceeval_data pass:[*]_keys_,
+			 unsigned long long _timestamp_);
+	int *traceeval_delta_stop_size*(struct traceeval_delta pass:[*]_tdelta_,
+			      const struct traceeval_data pass:[*]_keys_, size_t _nr_keys_,
+			      unsigned long long _timestamp_);
+
+	int *traceeval_delta_continue*(struct traceeval_delta pass:[*]_tdelta_,
+			     const struct traceeval_data pass:[*]_keys_,
+			     unsigned long long _timestamp_);
+	int *traceeval_delta_continue_size*(struct traceeval_delta pass:[*]_tdelta_,
+				  const struct traceeval_data pass:[*]keys, size_t _nr_keys_,
+				  unsigned long long _timestamp_);
 --
 
 DESCRIPTION
diff --git a/check-manpages.sh b/check-manpages.sh
index 07acc12ecbc4..b62406cce242 100755
--- a/check-manpages.sh
+++ b/check-manpages.sh
@@ -45,7 +45,7 @@ for man in ${MAIN}-*.txt; do
 done
 
 # traceeval_init_data_size is not deprecated, but users shouldn't be using it directly.
-DEPRECATED="*traceeval_init_data_size*"
+DEPRECATED="*traceeval_init_data_size* *traceeval_delta_init_data_size*"
 
 last=""
 sed -ne 's/^[a-z].*[ \*]\([a-z_][a-z_]*\)(.*/\1/p' -e 's/^\([a-z_][a-z_]*\)(.*/\1/p' ../include/traceeval.h | while read f; do
-- 
2.40.1

