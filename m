Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B885110948
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 20:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5046FC433BB;
	Thu, 28 Dec 2023 20:36:26 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIx80-00000000Du2-0X9t;
	Thu, 28 Dec 2023 15:37:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 23/23] libtracefs: Add updating and reading snapshot buffers
Date: Thu, 28 Dec 2023 15:35:45 -0500
Message-ID: <20231228203714.53294-24-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231228203714.53294-1-rostedt@goodmis.org>
References: <20231228203714.53294-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the API:

  tracefs_cpu_snapshot_open()

That will read the snapshot_raw file just like tracefs_cpu_open() does to
the trace_pipe_raw file, except the blocking will block only if empty and
until another snapshot occurs.

Add blocking and see if a snapshot will unblock it!

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-cpu-open.txt |  16 +++-
 Documentation/libtracefs-iterator.txt |  10 ++-
 Documentation/libtracefs.txt          |   6 ++
 include/tracefs.h                     |  13 ++++
 src/tracefs-events.c                  |  97 +++++++++++++++++-------
 src/tracefs-record.c                  | 102 ++++++++++++++++++++++----
 utest/tracefs-utest.c                 |  42 +++++++++--
 7 files changed, 237 insertions(+), 49 deletions(-)

diff --git a/Documentation/libtracefs-cpu-open.txt b/Documentation/libtracefs-cpu-open.txt
index c5a900a06e8e..46667e83f7ff 100644
--- a/Documentation/libtracefs-cpu-open.txt
+++ b/Documentation/libtracefs-cpu-open.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_cpu_open, tracefs_cpu_close, tracefs_cpu_alloc_fd, tracefs_cpu_free_fd - Opening trace_pipe_raw data for reading
+tracefs_cpu_open, tracefs_cpu_close, tracefs_cpu_alloc_fd, tracefs_cpu_free_fd, tracefs_cpu_snapshot_open - Opening trace_pipe_raw data for reading
 
 SYNOPSIS
 --------
@@ -17,6 +17,9 @@ void *tracefs_cpu_close*(struct tracefs_cpu pass:[*]_tcpu_);
 
 struct tracefs_cpu pass:[*]*tracefs_cpu_alloc_fd*(int _fd_, int _subbuf_size_, bool _nonblock_);
 void *tracefs_cpu_free_fd*(struct tracefs_cpu pass:[*]_tcpu_);
+
+struct tracefs_cpu pass:[*]*tracefs_cpu_snapshot-open*(struct tracefs_instance pass:[*]_instance_,
+					     int _cpu_, bool _nonblock_);
 --
 
 DESCRIPTION
@@ -47,10 +50,17 @@ the file descriptor passed in. Note that *tracefs_cpu_free_fd()* should not be u
 on the descriptor returned by *tracefs_cpu_open()* as it will not close the file descriptor
 created by it.
 
+The *tracefs_cpu_snapshot_open()* is similar to *tracefs_cpu_open()* except that it
+opens the snapshot buffer (see *tracefs_snapshot_snap*(3)). The snapshot buffer
+does not have a writer to it, it is only created by a snapshot action that swaps
+the current ring buffer with the snapshot buffer. The _nonblock_, when false, acts a little
+differently here too. Reads are not affected by the "buffer_percent" file. If the
+snapshot buffer is empty, it will block until a new snapshot happens.
+
 RETURN VALUE
 ------------
-The *tracefs_cpu_open()* returns a struct tracefs_cpu descriptor that can be
-used by the other functions or NULL on error.
+The *tracefs_cpu_open()* and *tracefs_cpu_snapshot_open() both return a struct
+tracefs_cpu descriptor that can be used by the other functions or NULL on error.
 
 The *tracefs_cpu_alloc_fd()* returns a struct tracefs_cpu descriptor that can
 be used by the *tracefs_cpu_read*(3) related functions, where the descriptor
diff --git a/Documentation/libtracefs-iterator.txt b/Documentation/libtracefs-iterator.txt
index c2b2be3f4c5c..b62f66aa2419 100644
--- a/Documentation/libtracefs-iterator.txt
+++ b/Documentation/libtracefs-iterator.txt
@@ -4,7 +4,7 @@ libtracefs(3)
 NAME
 ----
 tracefs_iterate_raw_events, tracefs_iterate_stop, tracefs_follow_event, tracefs_follow_missed_events,
-tracefs_follow_event_clear, tracefs_follow_missed_events_clear - Iterate over events in the ring buffer
+tracefs_follow_event_clear, tracefs_follow_missed_events_clear, tracefs_iterate_snapshot_events - Iterate over events in the ring buffer
 
 SYNOPSIS
 --------
@@ -33,6 +33,11 @@ int *tracefs_follow_missed_events*(struct tracefs_instance pass:[*]_instance_,
 int *tracefs_follow_event_clear*(struct tracefs_instance pass:[*]_instance_,
 			  const char pass:[*]_system_, const char pass:[*]_event_name_);
 int *tracefs_follow_missed_events_clear*(struct tracefs_instance pass:[*]_instance_);
+
+int *tracefs_iterate_snapshot_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_,
+				 cpu_set_t pass:[*]_cpus_, int _cpu_size_,
+				 int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]),
+				 void pass:[*]_callback_context_);
 --
 
 DESCRIPTION
@@ -54,6 +59,9 @@ record is; The record representing the event; The CPU that the event
 occurred on; and a pointer to user specified _callback_context_. If the _callback_
 returns non-zero, the iteration stops.
 
+The *tracefs_iterate_snapshot_events()* works the same as *tracefs_iterate_raw_events()*
+except that it works on the snapshot buffer.
+
 Use *tracefs_iterate_stop()* to force a executing *tracefs_iterate_raw_events()*
 to halt. This can be called from either a callback that is called by
 the iterator (even though a return of non-zero will stop it), or from another
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 6f26d7f1bdbb..8dc3ba7386e3 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -94,6 +94,12 @@ Trace events:
 	bool *tracefs_event_file_exists*(struct tracefs_instance pass:[*]_instance_, const char pass:[*]_system_, const char pass:[*]_event_,
 			       const char pass:[*]_file_);
 
+Snapshot buffer:
+	int *tracefs_iterate_snapshot_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_,
+				 cpu_set_t pass:[*]_cpus_, int _cpu_size_,
+				 int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]),
+				 void pass:[*]_callback_context_);
+
 Event filters:
 	int *tracefs_filter_string_append*(struct tep_event pass:[*]_event_, char pass:[**]_filter_,
 					 struct tracefs_filter _type_, const char pass:[*]_field_,
diff --git a/include/tracefs.h b/include/tracefs.h
index da9d3f70d1a1..8569171247b7 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -680,6 +680,19 @@ struct kbuffer *tracefs_cpu_flush_buf(struct tracefs_cpu *tcpu);
 int tracefs_cpu_flush_write(struct tracefs_cpu *tcpu, int wfd);
 int tracefs_cpu_pipe(struct tracefs_cpu *tcpu, int wfd, bool nonblock);
 
+struct tracefs_cpu *
+tracefs_cpu_snapshot_open(struct tracefs_instance *instance, int cpu, bool nonblock);
+int tracefs_iterate_snapshot_events(struct tep_handle *tep,
+				    struct tracefs_instance *instance,
+				    cpu_set_t *cpus, int cpu_size,
+				    int (*callback)(struct tep_event *,
+						    struct tep_record *,
+						    int, void *),
+				    void *callback_context);
+int tracefs_snapshot_snap(struct tracefs_instance *instance);
+int tracefs_snapshot_clear(struct tracefs_instance *instance);
+int tracefs_snapshot_free(struct tracefs_instance *instance);
+
 /* Memory mapping of ring buffer */
 bool tracefs_cpu_is_mapped(struct tracefs_cpu *tcpu);
 int tracefs_cpu_map(struct tracefs_cpu *tcpu);
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 413c2df19998..3c844b0ab408 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -280,7 +280,8 @@ static int read_cpu_pages(struct tep_handle *tep, struct tracefs_instance *insta
 }
 
 static int open_cpu_files(struct tracefs_instance *instance, cpu_set_t *cpus,
-			  int cpu_size, struct cpu_iterate **all_cpus, int *count)
+			  int cpu_size, struct cpu_iterate **all_cpus, int *count,
+			  bool snapshot)
 {
 	struct tracefs_cpu *tcpu;
 	struct cpu_iterate *tmp;
@@ -294,7 +295,10 @@ static int open_cpu_files(struct tracefs_instance *instance, cpu_set_t *cpus,
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		if (cpus && !CPU_ISSET_S(cpu, cpu_size, cpus))
 			continue;
-		tcpu = tracefs_cpu_open(instance, cpu, true);
+		if (snapshot)
+			tcpu = tracefs_cpu_snapshot_open(instance, cpu, true);
+		else
+			tcpu = tracefs_cpu_open(instance, cpu, true);
 		tmp = realloc(*all_cpus, (i + 1) * sizeof(*tmp));
 		if (!tmp) {
 			i--;
@@ -497,30 +501,13 @@ int tracefs_follow_missed_events_clear(struct tracefs_instance *instance)
 
 static bool top_iterate_keep_going;
 
-/*
- * tracefs_iterate_raw_events - Iterate through events in trace_pipe_raw,
- *				per CPU trace buffers
- * @tep: a handle to the trace event parser context
- * @instance: ftrace instance, can be NULL for the top instance
- * @cpus: Iterate only through the buffers of CPUs, set in the mask.
- *	  If NULL, iterate through all CPUs.
- * @cpu_size: size of @cpus set
- * @callback: A user function, called for each record from the file
- * @callback_context: A custom context, passed to the user callback function
- *
- * If the @callback returns non-zero, the iteration stops - in that case all
- * records from the current page will be lost from future reads
- * The events are iterated in sorted order, oldest first.
- *
- * Returns -1 in case of an error, or 0 otherwise
- */
-int tracefs_iterate_raw_events(struct tep_handle *tep,
-				struct tracefs_instance *instance,
-				cpu_set_t *cpus, int cpu_size,
-				int (*callback)(struct tep_event *,
-						struct tep_record *,
+static int iterate_events(struct tep_handle *tep,
+			  struct tracefs_instance *instance,
+			  cpu_set_t *cpus, int cpu_size,
+			  int (*callback)(struct tep_event *,
+					  struct tep_record *,
 						int, void *),
-				void *callback_context)
+			  void *callback_context, bool snapshot)
 {
 	bool *keep_going = instance ? &instance->iterate_keep_going :
 				      &top_iterate_keep_going;
@@ -542,7 +529,7 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 	if (!callback && !followers)
 		return -1;
 
-	ret = open_cpu_files(instance, cpus, cpu_size, &all_cpus, &count);
+	ret = open_cpu_files(instance, cpus, cpu_size, &all_cpus, &count, snapshot);
 	if (ret < 0)
 		goto out;
 	ret = read_cpu_pages(tep, instance, all_cpus, count,
@@ -562,6 +549,64 @@ out:
 	return ret;
 }
 
+/*
+ * tracefs_iterate_raw_events - Iterate through events in trace_pipe_raw,
+ *				per CPU trace buffers
+ * @tep: a handle to the trace event parser context
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @cpus: Iterate only through the buffers of CPUs, set in the mask.
+ *	  If NULL, iterate through all CPUs.
+ * @cpu_size: size of @cpus set
+ * @callback: A user function, called for each record from the file
+ * @callback_context: A custom context, passed to the user callback function
+ *
+ * If the @callback returns non-zero, the iteration stops - in that case all
+ * records from the current page will be lost from future reads
+ * The events are iterated in sorted order, oldest first.
+ *
+ * Returns -1 in case of an error, or 0 otherwise
+ */
+int tracefs_iterate_raw_events(struct tep_handle *tep,
+				struct tracefs_instance *instance,
+				cpu_set_t *cpus, int cpu_size,
+				int (*callback)(struct tep_event *,
+						struct tep_record *,
+						int, void *),
+				void *callback_context)
+{
+	return iterate_events(tep, instance, cpus, cpu_size, callback,
+			      callback_context, false);
+}
+
+/*
+ * tracefs_iterate_snapshot_events - Iterate through events in snapshot_raw,
+ *				per CPU trace buffers
+ * @tep: a handle to the trace event parser context
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @cpus: Iterate only through the buffers of CPUs, set in the mask.
+ *	  If NULL, iterate through all CPUs.
+ * @cpu_size: size of @cpus set
+ * @callback: A user function, called for each record from the file
+ * @callback_context: A custom context, passed to the user callback function
+ *
+ * If the @callback returns non-zero, the iteration stops - in that case all
+ * records from the current page will be lost from future reads
+ * The events are iterated in sorted order, oldest first.
+ *
+ * Returns -1 in case of an error, or 0 otherwise
+ */
+int tracefs_iterate_snapshot_events(struct tep_handle *tep,
+				    struct tracefs_instance *instance,
+				    cpu_set_t *cpus, int cpu_size,
+				    int (*callback)(struct tep_event *,
+						    struct tep_record *,
+						    int, void *),
+				    void *callback_context)
+{
+	return iterate_events(tep, instance, cpus, cpu_size, callback,
+			      callback_context, true);
+}
+
 /**
  * tracefs_iterate_stop - stop the iteration over the raw events.
  * @instance: ftrace instance, can be NULL for top tracing instance.
diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index fcef89e527aa..f51e18420bc7 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -93,19 +93,8 @@ tracefs_cpu_alloc_fd(int fd, int subbuf_size, bool nonblock)
 	return NULL;
 }
 
-/**
- * tracefs_cpu_open - open an instance raw trace file
- * @instance: the instance (NULL for toplevel) of the cpu raw file to open
- * @cpu: The CPU that the raw trace file is associated with
- * @nonblock: If true, the file will be opened in O_NONBLOCK mode
- *
- * Return a descriptor that can read the tracefs trace_pipe_raw file
- * for a give @cpu in a given @instance.
- *
- * Returns NULL on error.
- */
-struct tracefs_cpu *
-tracefs_cpu_open(struct tracefs_instance *instance, int cpu, bool nonblock)
+static struct tracefs_cpu *cpu_open(struct tracefs_instance *instance,
+				    const char *path_fmt, int cpu, bool nonblock)
 {
 	struct tracefs_cpu *tcpu;
 	struct tep_handle *tep;
@@ -119,7 +108,7 @@ tracefs_cpu_open(struct tracefs_instance *instance, int cpu, bool nonblock)
 	if (nonblock)
 		mode |= O_NONBLOCK;
 
-	sprintf(path, "per_cpu/cpu%d/trace_pipe_raw", cpu);
+	sprintf(path, path_fmt, cpu);
 
 	fd = tracefs_instance_file_open(instance, path, mode);
 	if (fd < 0)
@@ -156,6 +145,91 @@ tracefs_cpu_open(struct tracefs_instance *instance, int cpu, bool nonblock)
 	return NULL;
 }
 
+/**
+ * tracefs_cpu_open - open an instance raw trace file
+ * @instance: the instance (NULL for toplevel) of the cpu raw file to open
+ * @cpu: The CPU that the raw trace file is associated with
+ * @nonblock: If true, the file will be opened in O_NONBLOCK mode
+ *
+ * Return a descriptor that can read the tracefs trace_pipe_raw file
+ * for a give @cpu in a given @instance.
+ *
+ * Returns NULL on error.
+ */
+struct tracefs_cpu *
+tracefs_cpu_open(struct tracefs_instance *instance, int cpu, bool nonblock)
+{
+	return cpu_open(instance, "per_cpu/cpu%d/trace_pipe_raw", cpu, nonblock);
+}
+
+/**
+ * tracefs_cpu_snapshot_open - open an instance snapshot raw trace file
+ * @instance: the instance (NULL for toplevel) of the cpu raw file to open
+ * @cpu: The CPU that the raw trace file is associated with
+ * @nonblock: If true, the file will be opened in O_NONBLOCK mode
+ *
+ * Return a descriptor that can read the tracefs snapshot_raw file
+ * for a give @cpu in a given @instance.
+ *
+ * In nonblock mode, it will block if the snapshot is empty and wake up
+ * when there's a new snapshot.
+ *
+ * Returns NULL on error.
+ */
+struct tracefs_cpu *
+tracefs_cpu_snapshot_open(struct tracefs_instance *instance, int cpu, bool nonblock)
+{
+	return cpu_open(instance, "per_cpu/cpu%d/snapshot_raw", cpu, nonblock);
+}
+
+/**
+ * tracefs_snapshot_snap - takes a snapshot (allocates if necessary)
+ * @instance: The instance to take a snapshot on
+ *
+ * Takes a snapshot of the current ring buffer.
+ *
+ * Returns 0 on success, -1 on error.
+ */
+int tracefs_snapshot_snap(struct tracefs_instance *instance)
+{
+	int ret;
+
+	ret = tracefs_instance_file_write(instance, "snapshot", "1");
+	return ret < 0 ? -1 : 0;
+}
+
+/**
+ * tracefs_snapshot_clear - clears the snapshot
+ * @instance: The instance to clear the snapshot
+ *
+ * Clears the snapshot buffer for the @instance.
+ *
+ * Returns 0 on success, -1 on error.
+ */
+int tracefs_snapshot_clear(struct tracefs_instance *instance)
+{
+	int ret;
+
+	ret = tracefs_instance_file_write(instance, "snapshot", "2");
+	return ret < 0 ? -1 : 0;
+}
+
+/**
+ * tracefs_snapshot_free - frees the snapshot
+ * @instance: The instance to free the snapshot
+ *
+ * Frees the snapshot for the given @instance.
+ *
+ * Returns 0 on success, -1 on error.
+ */
+int tracefs_snapshot_free(struct tracefs_instance *instance)
+{
+	int ret;
+
+	ret = tracefs_instance_file_write(instance, "snapshot", "0");
+	return ret < 0 ? -1 : 0;
+}
+
 /**
  * tracefs_cpu_open_mapped - open an instance raw trace file and map it
  * @instance: the instance (NULL for toplevel) of the cpu raw file to open
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 658e8c149a0f..f338a9153c0a 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -181,7 +181,7 @@ static void test_iter_write(struct tracefs_instance *instance)
 }
 
 
-static void iter_raw_events_on_cpu(struct tracefs_instance *instance, int cpu)
+static void iter_raw_events_on_cpu(struct tracefs_instance *instance, int cpu, bool snapshot)
 {
 	int cpus = sysconf(_SC_NPROCESSORS_CONF);
 	cpu_set_t *cpuset = NULL;
@@ -190,6 +190,9 @@ static void iter_raw_events_on_cpu(struct tracefs_instance *instance, int cpu)
 	int ret;
 	int i;
 
+	if (snapshot)
+		tracefs_instance_clear(instance);
+
 	if (cpu >= 0) {
 		cpuset = CPU_ALLOC(cpus);
 		cpu_size = CPU_ALLOC_SIZE(cpus);
@@ -199,8 +202,15 @@ static void iter_raw_events_on_cpu(struct tracefs_instance *instance, int cpu)
 	test_found = 0;
 	last_ts = 0;
 	test_iter_write(instance);
-	ret = tracefs_iterate_raw_events(test_tep, instance, cpuset, cpu_size,
-					 test_callback, &cpu);
+
+	if (snapshot) {
+		tracefs_snapshot_snap(instance);
+		ret = tracefs_iterate_snapshot_events(test_tep, instance, cpuset, cpu_size,
+						      test_callback, &cpu);
+	} else {
+		ret = tracefs_iterate_raw_events(test_tep, instance, cpuset, cpu_size,
+						 test_callback, &cpu);
+	}
 	CU_TEST(ret == 0);
 	if (cpu < 0) {
 		CU_TEST(test_found == TEST_ARRAY_SIZE);
@@ -234,16 +244,35 @@ static void test_instance_iter_raw_events(struct tracefs_instance *instance)
 	ret = tracefs_iterate_raw_events(test_tep, instance, NULL, 0, NULL, NULL);
 	CU_TEST(ret < 0);
 
-	iter_raw_events_on_cpu(instance, -1);
+	iter_raw_events_on_cpu(instance, -1, false);
 	for (i = 0; i < cpus; i++)
-		iter_raw_events_on_cpu(instance, i);
+		iter_raw_events_on_cpu(instance, i, false);
 }
 
 static void test_iter_raw_events(void)
 {
+	test_instance_iter_raw_events(NULL);
 	test_instance_iter_raw_events(test_instance);
 }
 
+static void test_instance_iter_snapshot_events(struct tracefs_instance *instance)
+{
+	int cpus = sysconf(_SC_NPROCESSORS_CONF);
+	int i;
+
+	iter_raw_events_on_cpu(instance, -1, true);
+	for (i = 0; i < cpus; i++)
+		iter_raw_events_on_cpu(instance, i, true);
+	tracefs_snapshot_free(instance);
+}
+
+static void test_iter_snapshot_events(void)
+{
+	test_instance_iter_snapshot_events(NULL);
+	test_instance_iter_snapshot_events(test_instance);
+}
+
+
 #define RAND_STR_SIZE 20
 #define RAND_ASCII "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
 static const char *get_rand_str(void)
@@ -3218,6 +3247,9 @@ void test_tracefs_lib(void)
 		    test_instance_reset);
 	CU_add_test(suite, "systems and events APIs",
 		    test_system_event);
+	CU_add_test(suite, "tracefs_iterate_snapshot_events API",
+		    test_iter_snapshot_events);
+
 	CU_add_test(suite, "tracefs_iterate_raw_events API",
 		    test_iter_raw_events);
 
-- 
2.42.0

