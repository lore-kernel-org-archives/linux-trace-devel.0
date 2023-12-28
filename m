Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BF310A05
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61586C433C9;
	Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIyKp-00000000EJx-1D2E;
	Thu, 28 Dec 2023 16:54:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 21/22] libtracefs: Add PID filtering API
Date: Thu, 28 Dec 2023 16:52:16 -0500
Message-ID: <20231228215433.54854-22-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231228215433.54854-1-rostedt@goodmis.org>
References: <20231228215433.54854-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add an API that sets and clears PID filtering for functions and events.

   tracefs_filter_pid_function()
   tracefs_filter_pid_events()
   tracefs_filter_pid_function_clear()
   tracefs_filter_pid_events_clear()

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-filter-pid.txt | 181 +++++++++++++++++
 Documentation/libtracefs.txt            |   8 +
 include/tracefs.h                       |   7 +
 src/tracefs-filter.c                    | 132 ++++++++++++
 utest/tracefs-utest.c                   | 257 +++++++++++++++++++++++-
 5 files changed, 577 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/libtracefs-filter-pid.txt

diff --git a/Documentation/libtracefs-filter-pid.txt b/Documentation/libtracefs-filter-pid.txt
new file mode 100644
index 000000000000..fa56b0222df0
--- /dev/null
+++ b/Documentation/libtracefs-filter-pid.txt
@@ -0,0 +1,181 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_filter_pid_function, tracefs_filter_pid_events, tracefs_filter_pid_function_clear, tracefs_filter_pid_events_clear -
+Add and remove PID filtering for functions and events
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int *tracefs_filter_pid_function*(struct tracefs_instance pass:[*]_instance,_ int _pid_,
+				bool _reset_, bool _notrace_);
+int *tracefs_filter_pid_function_clear*(struct tracefs_instance pass:[*]_instance_, bool _notrace_);
+int *tracefs_filter_pid_events*(struct tracefs_instance pass:[*]_instance_, int _pid_,
+			     bool _reset_, bool _notrace_);
+int *tracefs_filter_pid_events_clear*(struct tracefs_instance pass:[*]_instance_, bool _notrace_);
+--
+
+DESCRIPTION
+-----------
+Both events and functions can be filtered by PID, but they are done separately.
+PID filtering for functions affect the function and function_graph tracer, where
+as PID filtering for events affect all events such as _sched_switch_ and _sched_waking_.
+If the *TRACEFS_OPTION_FUNCTION_FORK* is enabled (see *tracefs_option_enable*(3)),
+any PID that is set as part of the function PID filtering will automatically
+have its children added when they are spawned, as well as the PID removed when
+they exit. If the *TRACEFS_OPTION_EVENT_FORK* is set, the same is true for
+event PID filtering. This also includes the _notrace_ option where the child
+threads and processes of PIDs that are labled as notrace will also not be
+traced.
+
+The *tracefs_filter_pid_function()* affects function PID filtering and *tracefs_filter_pid_events()*
+affects the PID event filtering. For both functions, they add a _pid_ to be filtered in the given _instance_.
+If _reset_ is true, then any PIDs already being filtered will be removed, otherwise
+the _pid_ is simply added to the filtering. If _notrace_ is true, then the PID
+is added to the list of PIDs that are not to be traced. Note, that _reset_ only affects
+the list associated with _notrace_. That is, if both _reset_ and _notrace_ are true,
+then it will not affect PIDs that are to be traced. Same is if _reset_ is true and _notrace_
+is false, it will not affect PIDs that are not to be traced.
+
+The *tracefs_filter_pid_function_clear()* affects function PID filtering and
+*tracefs_filter_pid_events_clear()* affects the PID event filtering. For both
+functions it will clear all the PIDs that are being filtered for the given
+filter. If _notrace_ is true it clears all the PIDs that are not to be traced
+otherwise if it is false, it clears all the PIDs that are to be traced.
+
+RETURN VALUE
+------------
+All the functions return 0 on success and -1 on error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <stdio.h>
+#include <ctype.h>
+#include <tracefs.h>
+
+static void usage(char **argv)
+{
+	fprintf(stderr, "usage: %s [-e|-f][-c|-n] pid [pid ...]\n", argv[0]);
+	fprintf(stderr, "   -e enable event filter\n");
+	fprintf(stderr, "   -f enable function filter\n");
+	fprintf(stderr, "     (default is both, function and event)\n");
+	fprintf(stderr, "   -c clear the filter\n");
+	fprintf(stderr, "   -n notrace filter\n");
+	exit(-1);
+}
+
+int main (int argc, char **argv)
+{
+	bool events = false;
+	bool funcs = false;
+	bool neg = false;
+	bool clear = false;
+	bool reset = true;
+	int i;
+
+	for (i = 1; i < argc && argv[i][0] == '-'; i++) {
+		char *arg = argv[i];
+		int c;
+		for (c = 1; arg[c]; c++) {
+			switch (arg[c]) {
+			case 'e': events = true; break;
+			case 'f': funcs = true; break;
+			case 'n': neg = true; break;
+			case 'c': clear = true; break;
+			default:
+				usage(argv);
+			}
+		}
+		if (c == 1)
+			usage(argv);
+	}
+
+	if (i == argc && !clear)
+		usage(argv);
+
+	if (!events && !funcs) {
+		events = true;
+		funcs = true;
+	}
+
+	if (clear) {
+		if (events)
+			tracefs_filter_pid_events_clear(NULL, neg);
+		if (funcs)
+			tracefs_filter_pid_function_clear(NULL, neg);
+		exit(0);
+	}
+
+	for (; i < argc; i++) {
+		int pid = atoi(argv[i]);
+
+		if (events)
+			tracefs_filter_pid_events(NULL, pid, reset, neg);
+		if (funcs)
+			tracefs_filter_pid_function(NULL, pid, reset, neg);
+
+		reset = false;
+	}
+
+	exit(0);
+}
+
+--
+
+FILES
+-----
+[verse]
+--
+*tracefs.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracefs*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1),
+*tracefs_hist_alloc*(3),
+*tracefs_hist_alloc_2d*(3),
+*tracefs_hist_alloc_nd*(3),
+*tracefs_hist_free*(3),
+*tracefs_hist_add_key*(3),
+*tracefs_hist_add_value*(3),
+*tracefs_hist_add_name*(3),
+*tracefs_hist_start*(3),
+*tracefs_hist_destory*(3),
+*tracefs_hist_add_sort_key*(3),
+*tracefs_hist_sort_key_direction*(3)
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracefs is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2023 Google, LLC. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 1962b3b34622..3e73f12de2b5 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -107,6 +107,14 @@ Function filters:
 	int *tracefs_function_notrace*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_filter_, const char pass:[*]_module_, int _flags_);
 	int *tracefs_filter_functions*(const char pass:[*]_filter_, const char pass:[*]_module_, char pass:[*]pass:[*]pass:[*]_list_);
 
+PID filters:
+	int *tracefs_filter_pid_function*(struct tracefs_instance pass:[*]_instance,_ int _pid_,
+				bool _reset_, bool _notrace_);
+	int *tracefs_filter_pid_function_clear*(struct tracefs_instance pass:[*]_instance_, bool _notrace_);
+	int *tracefs_filter_pid_events*(struct tracefs_instance pass:[*]_instance_, int _pid_,
+				bool _reset_, bool _notrace_);
+	int *tracefs_filter_pid_events_clear*(struct tracefs_instance pass:[*]_instance_, bool _notrace_);
+
 Trace helper functions:
 	void *tracefs_list_free*(char pass:[*]pass:[*]_list_);
 	char pass:[**]*tracefs_list_add*(char **_list_, const char *_string_);
diff --git a/include/tracefs.h b/include/tracefs.h
index c66bfd2edf0b..d91ab1d943eb 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -269,6 +269,13 @@ enum {
 	TRACEFS_FL_FUTURE	= (1 << 2),
 };
 
+int tracefs_filter_pid_function(struct tracefs_instance *instance, int pid,
+				bool reset, bool notrace);
+int tracefs_filter_pid_function_clear(struct tracefs_instance *instance, bool notrace);
+int tracefs_filter_pid_events(struct tracefs_instance *instance, int pid,
+			     bool reset, bool notrace);
+int tracefs_filter_pid_events_clear(struct tracefs_instance *instance, bool notrace);
+
 int tracefs_function_filter(struct tracefs_instance *instance, const char *filter,
 			    const char *module, unsigned int flags);
 int tracefs_function_notrace(struct tracefs_instance *instance, const char *filter,
diff --git a/src/tracefs-filter.c b/src/tracefs-filter.c
index 3628eaed202f..afe3338c0bd8 100644
--- a/src/tracefs-filter.c
+++ b/src/tracefs-filter.c
@@ -801,6 +801,138 @@ int tracefs_event_filter_clear(struct tracefs_instance *instance,
 					"filter", "0");
 }
 
+static int write_pid_file(struct tracefs_instance *instance, const char *file,
+		      int pid, bool reset)
+{
+	char buf[64];
+	int ret;
+
+	sprintf(buf, "%d", pid);
+
+	if (reset)
+		ret = tracefs_instance_file_write(instance, file, buf);
+	else
+		ret = tracefs_instance_file_append(instance, file, buf);
+
+	return ret < 0 ? -1 : 0;
+}
+
+/**
+ * tracefs_filter_pid_function - set function tracing to filter the pid
+ * @instance: The instance to set the filter to
+ * @pid: The pid to filter on
+ * @reset: If set, it will clear out all other pids being filtered
+ * @notrace: If set, it will filter all but this pid
+ *
+ * Set the function tracing to trace or avoid tracing a given @pid.
+ * If @notrace is set, then it will avoid tracing the @pid.
+ * If @reset is set, it will clear the filter as well.
+ *
+ * Note, @reset only resets what pids will be traced, or what pids will
+ *   not be traced. That is, if both @reset and @notrace is set, then
+ *   it will not affect pids that are being traced. It will only clear
+ *   the pids that are not being traced. To do both, The
+ *   tracefs_filter_pid_function_clear() needs to be called with the
+ *   inverse of @notrace.
+ *
+ * Returns -1 on error, 0 on success.
+ */
+int tracefs_filter_pid_function(struct tracefs_instance *instance, int pid,
+				bool reset, bool notrace)
+{
+	const char *file;
+
+	if (notrace)
+		file = "set_ftrace_notrace_pid";
+	else
+		file = "set_ftrace_pid";
+
+	return write_pid_file(instance, file, pid, reset);
+}
+
+/**
+ * tracefs_filter_pid_function_clear - reset pid function filtering
+ * @instance: The instance to reset function filtering
+ * @notrace: If set, it will filter reset the pids that are not to be traced
+ *
+ * This will clear the function filtering on pids. If @notrace is set,
+ * it will clear the filtering on what pids should not be traced.
+ *
+ * Returns -1 on error, 0 on success.
+ */
+int tracefs_filter_pid_function_clear(struct tracefs_instance *instance, bool notrace)
+{
+	const char *file;
+	int ret;
+
+	if (notrace)
+		file = "set_ftrace_notrace_pid";
+	else
+		file = "set_ftrace_pid";
+
+	ret = tracefs_instance_file_write(instance, file, "");
+
+	return ret < 0 ? -1 : 0;
+}
+
+/**
+ * tracefs_filter_pid_events - set event filtering to a specific pid
+ * @instance: The instance to set the filter to
+ * @pid: The pid to filter on
+ * @reset: If set, it will clear out all other pids being filtered
+ * @notrace: If set, it will filter all but this pid
+ *
+ * Set the event filtering to trace or avoid tracing a given @pid.
+ * If @notrace is set, then it will avoid tracing the @pid.
+ * If @reset is set, it will clear the filter as well.
+ *
+ * Note, @reset only resets what pids will be traced, or what pids will
+ *   not be traced. That is, if both @reset and @notrace is set, then
+ *   it will not affect pids that are being traced. It will only clear
+ *   the pids that are not being traced. To do both, The
+ *   tracefs_filter_pid_events_clear() needs to be called with the
+ *   inverse of @notrace.
+ *
+ * Returns -1 on error, 0 on success.
+ */
+int tracefs_filter_pid_events(struct tracefs_instance *instance, int pid,
+			     bool reset, bool notrace)
+{
+	const char *file;
+
+	if (notrace)
+		file = "set_event_notrace_pid";
+	else
+		file = "set_event_pid";
+
+	return write_pid_file(instance, file, pid, reset);
+}
+
+/**
+ * tracefs_filter_pid_events_clear - reset pid events filtering
+ * @instance: The instance to reset function filtering
+ * @notrace: If set, it will filter reset the pids that are not to be traced
+ *
+ * This will clear the function filtering on pids. If @notrace is set,
+ * it will clear the filtering on what pids should not be traced.
+ *
+ * Returns -1 on error, 0 on success.
+ */
+int tracefs_filter_pid_events_clear(struct tracefs_instance *instance, bool notrace)
+{
+	const char *file;
+	int ret;
+
+	if (notrace)
+		file = "set_event_notrace_pid";
+	else
+		file = "set_event_pid";
+
+	ret = tracefs_instance_file_write(instance, file, "");
+
+	return ret < 0 ? -1 : 0;
+}
+
 /** Deprecated **/
 int tracefs_event_append_filter(struct tep_event *event, char **filter,
 				enum tracefs_filter type,
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index a94a1f28258a..658e8c149a0f 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -16,12 +16,15 @@
 #include <pthread.h>
 
 #include <sys/mount.h>
+#include <sys/syscall.h>
 
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
 
 #include "tracefs.h"
 
+#define gettid() syscall(__NR_gettid)
+
 #define TRACEFS_SUITE		"tracefs library"
 #define TEST_INSTANCE_NAME	"cunit_test_iter"
 #define TEST_TRACE_DIR		"/tmp/trace_utest.XXXXXX"
@@ -438,6 +441,248 @@ static void test_trace_sql(void)
 	test_instance_trace_sql(test_instance);
 }
 
+static void call_getppid(int cnt)
+{
+	int i;
+
+	for (i = 0; i < cnt; i++)
+		getppid();
+}
+
+struct check_data {
+	int	this_pid;
+	int	other_pid;
+	bool	trace_this;
+	bool	trace_other;
+	bool	trace_all;
+	bool	hit;
+	int (*filter_clear)(struct tracefs_instance *instance, bool notrace);
+};
+
+static int check_callback(struct tep_event *event, struct tep_record *record,
+			  int cpu, void *data)
+{
+	struct check_data *cdata = data;
+	int pid;
+
+	cdata->hit = true;
+
+	pid = tep_data_pid(event->tep, record);
+
+	if (pid == cdata->this_pid) {
+		CU_TEST(cdata->trace_this);
+		return cdata->trace_this ? 0 : -1;
+	}
+
+	if (pid == cdata->other_pid) {
+		CU_TEST(cdata->trace_other);
+		return cdata->trace_other ? 0 : -1;
+	}
+
+	CU_TEST(cdata->trace_all);
+	if (!cdata->trace_all) {
+		printf(" (Traced %d but should not have", pid);
+		if (cdata->trace_this)
+			printf(", this_pid:%d", cdata->this_pid);
+		if (cdata->trace_other)
+			printf(", other_pid:%d", cdata->other_pid);
+		printf(") ");
+	}
+
+	return cdata->trace_all ? 0 : -1;
+}
+
+static int check_filtered_pid(struct tep_handle *tep, struct tracefs_instance *instance,
+			      struct check_data *cdata)
+{
+	int ret;
+
+	cdata->hit = false;
+	ret = tracefs_iterate_raw_events(tep, instance, NULL, 0, check_callback, cdata);
+
+	tracefs_instance_clear(instance);
+
+	cdata->filter_clear(instance, false);
+	cdata->filter_clear(instance, true);
+
+	return ret;
+}
+
+struct spin_data {
+	bool	stop;
+	bool	done;
+	int	tid;
+};
+
+static void *trace_spin_thread(void *arg)
+{
+	struct spin_data *data = arg;
+
+	data->tid = gettid();
+	pthread_barrier_wait(&trace_barrier);
+
+	while (!data->done) {
+		pthread_barrier_wait(&trace_barrier);
+		while (!data->stop && !data->done)
+			getppid();
+		pthread_barrier_wait(&trace_barrier);
+	}
+
+	return NULL;
+}
+
+static void run_test(struct tracefs_instance *instance, struct tep_handle *tep,
+		     struct spin_data *data, struct check_data *cdata)
+{
+	tracefs_trace_on(instance);
+
+	/* Run a little */
+	call_getppid(1000);
+
+	/* Start the spinner */
+	data->stop = false;
+	pthread_barrier_wait(&trace_barrier);
+
+	/* Allow the other threads run */
+	msleep(100);
+
+	/* Stop the spinners */
+	data->stop = true;
+	pthread_barrier_wait(&trace_barrier);
+	/* Run a little more  */
+	call_getppid(10);
+	tracefs_trace_off(instance);
+
+	check_filtered_pid(tep, instance, cdata);
+}
+
+
+static void test_instance_pid_filter(struct tracefs_instance *instance,
+				     int (*filter_pid)(struct tracefs_instance *instance,
+						       int pid, bool reset, bool notrace),
+				     int (*filter_clear)(struct tracefs_instance *instance,
+							 bool notrace))
+{
+	struct tep_handle *tep = test_tep;
+	struct check_data cdata;
+	struct spin_data data = { };
+	pthread_t thread1;
+	pthread_t thread2;
+	int this_pid = getpid();
+
+	pthread_barrier_init(&trace_barrier, NULL, 3);
+
+	/* create two spinners, one will be used for tracing */
+	pthread_create(&thread1, NULL, trace_spin_thread, &data);
+	pthread_create(&thread2, NULL, trace_spin_thread, &data);
+
+	pthread_barrier_wait(&trace_barrier);
+
+	cdata.this_pid = this_pid;
+	cdata.other_pid = data.tid;
+	cdata.filter_clear = filter_clear;
+
+	/* Test 1 */
+	cdata.trace_this = true;
+	cdata.trace_other = false;
+	cdata.trace_all = false;
+
+	/* Add the thread, but then reset it out */
+	filter_pid(instance, data.tid, true, false);
+	filter_pid(instance, this_pid, true, false);
+
+	/* Only this thread should be traced */
+	run_test(instance, tep, &data, &cdata);
+	CU_TEST(cdata.hit);
+
+
+	/* Test 2 */
+	cdata.trace_this = true;
+	cdata.trace_other = true;
+	cdata.trace_all = false;
+
+	/* Add the thread, but then reset it out */
+	filter_pid(instance, data.tid, true, false);
+	filter_pid(instance, this_pid, false, false);
+
+	/* Only this thread should be traced */
+	run_test(instance, tep, &data, &cdata);
+	CU_TEST(cdata.hit);
+
+
+	/* Test 3 */
+	cdata.trace_this = false;
+	cdata.trace_other = true;
+	cdata.trace_all = true;
+
+	/* Add the thread, but then reset it out */
+	filter_pid(instance, data.tid, true, true);
+	filter_pid(instance, this_pid, true, true);
+
+	/* Only this thread should be traced */
+	run_test(instance, tep, &data, &cdata);
+	CU_TEST(cdata.hit);
+
+
+	/* Test 4 */
+	cdata.trace_this = false;
+	cdata.trace_other = false;
+	cdata.trace_all = true;
+
+	/* Add the thread, but then reset it out */
+	filter_pid(instance, data.tid, true, true);
+	filter_pid(instance, this_pid, false, true);
+
+	/* Only this thread should be traced */
+	run_test(instance, tep, &data, &cdata);
+	CU_TEST(cdata.hit);
+
+	/* exit out */
+	data.done = true;
+	pthread_barrier_wait(&trace_barrier);
+	pthread_barrier_wait(&trace_barrier);
+
+	pthread_join(thread1, NULL);
+	pthread_join(thread2, NULL);
+}
+
+static void test_function_pid_filter(struct tracefs_instance *instance)
+{
+	tracefs_trace_off(instance);
+	tracefs_instance_clear(instance);
+	tracefs_tracer_set(instance, TRACEFS_TRACER_FUNCTION);
+	test_instance_pid_filter(instance,
+				 tracefs_filter_pid_function,
+				 tracefs_filter_pid_function_clear);
+	tracefs_tracer_clear(instance);
+	tracefs_trace_on(instance);
+}
+
+static void test_trace_function_pid_filter(void)
+{
+	test_function_pid_filter(NULL);
+	test_function_pid_filter(test_instance);
+}
+
+static void test_events_pid_filter(struct tracefs_instance *instance)
+{
+	tracefs_trace_off(instance);
+	tracefs_instance_clear(instance);
+	tracefs_event_enable(instance, "syscalls", NULL);
+	tracefs_event_enable(instance, "raw_syscalls", NULL);
+	test_instance_pid_filter(instance,
+				 tracefs_filter_pid_events,
+				 tracefs_filter_pid_events_clear);
+	tracefs_event_disable(instance, NULL, NULL);
+	tracefs_trace_on(instance);
+}
+
+static void test_trace_events_pid_filter(void)
+{
+	test_events_pid_filter(NULL);
+	test_events_pid_filter(test_instance);
+}
+
 struct test_cpu_data {
 	struct tracefs_instance		*instance;
 	struct tracefs_cpu		*tcpu;
@@ -593,14 +838,6 @@ static void reset_trace_cpu(struct test_cpu_data *data, bool nonblock)
 	CU_TEST(data->tcpu != NULL);
 }
 
-static void call_getppid(int cnt)
-{
-	int i;
-
-	for (i = 0; i < cnt; i++)
-		getppid();
-}
-
 static void test_cpu_read(struct test_cpu_data *data, int expect)
 {
 	struct tracefs_cpu *tcpu = data->tcpu;
@@ -2965,6 +3202,10 @@ void test_tracefs_lib(void)
 		    test_trace_cpu_read_buf_percent);
 	CU_add_test(suite, "trace cpu pipe",
 		    test_trace_cpu_pipe);
+	CU_add_test(suite, "trace pid events filter",
+		    test_trace_events_pid_filter);
+	CU_add_test(suite, "trace pid function filter",
+		    test_trace_function_pid_filter);
 	CU_add_test(suite, "trace sql",
 		    test_trace_sql);
 	CU_add_test(suite, "tracing file / directory APIs",
-- 
2.42.0

