Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA4D3C43217
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 03:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiKODqe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 22:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbiKODqc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 22:46:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD59C1A3B2
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 19:46:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66A5961527
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 03:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3F5C43470;
        Tue, 15 Nov 2022 03:46:29 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oumum-00AGhx-1f;
        Mon, 14 Nov 2022 22:47:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/4] libtracefs: Add tracefs_follow_event() API
Date:   Mon, 14 Nov 2022 22:47:11 -0500
Message-Id: <20221115034712.2447458-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221115034712.2447458-1-rostedt@goodmis.org>
References: <20221115034712.2447458-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add tracefs_follow_event() API that allows to only receive a callback for
a specific event.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-iterator.txt | 130 ++++++++++++++++++--------
 include/tracefs-local.h               |  10 ++
 include/tracefs.h                     |   6 ++
 src/tracefs-events.c                  | 101 +++++++++++++++++++-
 4 files changed, 204 insertions(+), 43 deletions(-)

diff --git a/Documentation/libtracefs-iterator.txt b/Documentation/libtracefs-iterator.txt
index 5cdf31e3c090..95ff1894d074 100644
--- a/Documentation/libtracefs-iterator.txt
+++ b/Documentation/libtracefs-iterator.txt
@@ -2,7 +2,7 @@ libtracefs(3)
 =============
 
 NAME
-tracefs_iterate_raw_events, tracefs_iterate_stop - Iterate over events in the ring buffer
+tracefs_iterate_raw_events, tracefs_iterate_stop, tracefs_follow_event - Iterate over events in the ring buffer
 
 SYNOPSIS
 --------
@@ -16,6 +16,13 @@ int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs
 				 void pass:[*]_callback_context_);
 void *tracefs_iterate_stop*(struct tracefs_instance pass:[*]_instance_);
 
+int *tracefs_follow_event*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_,
+			  const char pass:[*]_system_, const char pass:[*]_event_name_,
+			  int (pass:[*]_callback_)(struct tep_event pass:[*],
+					  struct tep_record pass:[*],
+					  int, void pass:[*]),
+			  void pass:[*]_callback_data_):
+
 --
 
 DESCRIPTION
@@ -42,6 +49,14 @@ to halt. This can be called from either a callback that is called by
 the iterator (even though a return of non-zero will stop it), or from another
 thread.
 
+The *tracefs_follow_event()* is used with *tracefs_iterate_raw_events()* but
+intead of the callback being called for every event, it is only called for the
+specified _system_ / _event_name_ given to the function. The _callback_ is the
+same as for *tracefs_iterate_raw_events()*, and the passed in _callback_context_
+will be passed to the _callback_ as well. Note, if it returns something other
+than 0, it will stop the loop before the _callback_ of *tracefs_iterate_raw_events()*
+is called.
+
 RETURN VALUE
 ------------
 The *tracefs_iterate_raw_events()* function returns -1 in case of an error or
@@ -51,56 +66,89 @@ EXAMPLE
 -------
 [source,c]
 --
+#include <unistd.h>
 #include <tracefs.h>
+#include <stdbool.h>
 
-char **systems = tracefs_event_systems(NULL);
-
-	if (systems) {
-		int i = 0;
-		/* Got registered trace systems from the top trace instance */
-		while (systems[i]) {
-			char **events = tracefs_system_events(NULL, systems[i]);
-			if (events) {
-				/* Got registered events in system[i] from the top trace instance */
-				int j = 0;
-
-				while (events[j]) {
-					/* Got event[j] in system[i] from the top trace instance */
-					j++;
-				}
-				tracefs_list_free(events);
-			}
-			i++;
-		}
-		tracefs_list_free(systems);
-	}
-....
-static int records_walk(struct tep_event *tep, struct tep_record *record, int cpu, void *context)
+struct my_struct {
+	bool		stopped;
+};
+
+static int callback(struct tep_event *event, struct tep_record *record,
+		    int cpu, void *data)
 {
-	/* Got recorded event on cpu */
+	struct my_struct *my_data = data;
+	static struct trace_seq seq;
+	static int counter;
+
+	if (counter++ > 10000) {
+		my_data->stopped = true;
+		return 1;
+	}
+
+	if (!seq.buffer)
+		trace_seq_init(&seq);
+
+	tep_print_event(event->tep, &seq, record, "%16s-%-5d [%03d] %6.1000d %s: %s\n",
+			TEP_PRINT_COMM, TEP_PRINT_PID, TEP_PRINT_CPU,
+			TEP_PRINT_TIME, TEP_PRINT_NAME, TEP_PRINT_INFO);
+	trace_seq_terminate(&seq);
+	trace_seq_do_printf(&seq);
+	trace_seq_reset(&seq);
 	return 0;
 }
-...
-struct tep_handle *tep = tracefs_local_events(NULL);
 
-	if (!tep) {
-		/* Failed to initialise tep handler with local events */
-		...
+static int sched_callback(struct tep_event *event, struct tep_record *record,
+			  int cpu, void *data)
+{
+	static struct tep_format_field *prev_pid;
+	static struct tep_format_field *next_pid;
+	unsigned long long pid;
+	int this_pid = *(int *)data;
+
+	if (!prev_pid) {
+		prev_pid = tep_find_field(event, "prev_pid");
+		next_pid = tep_find_field(event, "next_pid");
+		if (!prev_pid || !next_pid) {
+			fprintf(stderr, "No pid fields??\n");
+			return -1;
+		}
 	}
 
-	errno = 0;
-	ret = tracefs_event_enable(NULL, "sched", NULL);
-	if (ret < 0 && !errno)
-		printf("Could not find 'sched' events\n");
-	tracefs_event_enable(NULL, "irq", "irq_handler_\(enter\|exit\)");
+	tep_read_number_field(prev_pid, record->data, &pid);
+	if (pid == this_pid)
+		printf("WE ARE LEAVING!\n");
+	tep_read_number_field(next_pid, record->data, &pid);
+	if (pid == this_pid)
+		printf("WE ARE ARRIVING!\n");
+	return 0;
+}
 
-	if (tracefs_iterate_raw_events(tep, NULL, NULL, 0, records_walk, NULL) < 0) {
-		/* Error walking through the recorded raw events */
-	}
+int main (int argc, char **argv, char **env)
+{
+	struct tep_handle *tep;
+	struct tracefs_instance *instance;
+	struct my_struct my_data = { .stopped = false };
+	int this_pid = getpid();
+
+	instance = tracefs_instance_create("my-buffer");
+	if (!instance)
+		return -1;
+
+	tracefs_event_enable(instance, "sched", NULL);
+	sleep(1);
+	tracefs_event_disable(instance, NULL, NULL);
+	tep = tracefs_local_events(NULL);
+	tep_load_plugins(tep);
+	tracefs_follow_event(tep, instance, "sched", "sched_switch", sched_callback, &this_pid);
+	tracefs_iterate_raw_events(tep, instance, NULL, 0, callback, &my_data);
+	tracefs_instance_destroy(instance);
+
+	if (my_data.stopped)
+		printf("stopped!\n");
 
-	/* Disable all events */
-	tracefs_event_disable(NULL, NULL, NULL);
-	tep_free(tep);
+	return 0;
+}
 --
 FILES
 -----
diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 1286cbf800a2..4c636be8a1fe 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -23,9 +23,18 @@ struct tracefs_options_mask {
 	unsigned long long	mask;
 };
 
+struct follow_event {
+	struct tep_event	*event;
+	void			*callback_data;
+	int (*callback)(struct tep_event *,
+			struct tep_record *,
+			int, void *);
+};
+
 struct tracefs_instance {
 	struct tracefs_options_mask	supported_opts;
 	struct tracefs_options_mask	enabled_opts;
+	struct follow_event		*followers;
 	char				*trace_dir;
 	char				*name;
 	pthread_mutex_t			lock;
@@ -35,6 +44,7 @@ struct tracefs_instance {
 	int				ftrace_notrace_fd;
 	int				ftrace_marker_fd;
 	int				ftrace_marker_raw_fd;
+	int				nr_followers;
 	bool				pipe_keep_going;
 	bool				iterate_keep_going;
 };
diff --git a/include/tracefs.h b/include/tracefs.h
index 10f84a25c31e..cb64e098883a 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -126,6 +126,12 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 						int, void *),
 				void *callback_context);
 void tracefs_iterate_stop(struct tracefs_instance *instance);
+int tracefs_follow_event(struct tep_handle *tep, struct tracefs_instance *instance,
+			  const char *system, const char *event_name,
+			  int (*callback)(struct tep_event *,
+					  struct tep_record *,
+					  int, void *),
+			  void *callback_data);
 
 char *tracefs_event_get_file(struct tracefs_instance *instance,
 			     const char *system, const char *event,
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 592b1a01fea4..abd97da8abbd 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -20,6 +20,9 @@
 #include "tracefs.h"
 #include "tracefs-local.h"
 
+static struct follow_event *root_followers;
+static int nr_root_followers;
+
 struct cpu_iterate {
 	struct tracefs_cpu *tcpu;
 	struct tep_record record;
@@ -117,7 +120,36 @@ int read_next_record(struct tep_handle *tep, struct cpu_iterate *cpu)
 	return -1;
 }
 
-static int read_cpu_pages(struct tep_handle *tep, struct cpu_iterate *cpus, int count,
+static int call_followers(struct tracefs_instance *instance,
+			  struct tep_event *event, struct tep_record *record, int cpu)
+{
+	struct follow_event *followers;
+	int nr_followers;
+	int ret = 0;
+	int i;
+
+	if (instance) {
+		followers = instance->followers;
+		nr_followers = instance->nr_followers;
+	} else {
+		followers = root_followers;
+		nr_followers = nr_root_followers;
+	}
+
+	if (!followers)
+		return 0;
+
+	for (i = 0; i < nr_followers; i++) {
+		if (followers[i].event == event)
+			ret |= followers[i].callback(event, record,
+						     cpu, followers[i].callback_data);
+	}
+
+	return ret;
+}
+
+static int read_cpu_pages(struct tep_handle *tep, struct tracefs_instance *instance,
+			  struct cpu_iterate *cpus, int count,
 			  int (*callback)(struct tep_event *,
 					  struct tep_record *,
 					  int, void *),
@@ -143,6 +175,8 @@ static int read_cpu_pages(struct tep_handle *tep, struct cpu_iterate *cpus, int
 				j = i;
 		}
 		if (j < count) {
+			if (call_followers(instance, cpus[j].event, &cpus[j].record, cpus[j].cpu))
+				break;
 			if (callback(cpus[j].event, &cpus[j].record, cpus[j].cpu, callback_context))
 				break;
 			cpus[j].event = NULL;
@@ -205,6 +239,69 @@ static int open_cpu_files(struct tracefs_instance *instance, cpu_set_t *cpus,
 	return -1;
 }
 
+/**
+ * tracefs_follow_event - Add callback for specific events for iterators
+ * @tep: a handle to the trace event parser context
+ * @instance: The instance to follow
+ * @system: The system of the event to track
+ * @event_name: The name of the event to track
+ * @callback: The function to call when the event is hit in an iterator
+ * @callback_data: The data to pass to @callback
+ *
+ * This attaches a callback to an @instance or the root instance if @instance
+ * is NULL, where if tracefs_iterate_raw_events() is called, that if the specified
+ * event is hit, it will call @callback, with the following parameters:
+ *  @event: The event pointer that was found by @system and @event_name.
+ *  @record; The event instance of @event.
+ *  @cpu: The cpu that the event happened on.
+ *  @callback_data: The same as @callback_data passed to the function.
+ *
+ * Returns 0 on success and -1 on error.
+ */
+int tracefs_follow_event(struct tep_handle *tep, struct tracefs_instance *instance,
+			  const char *system, const char *event_name,
+			  int (*callback)(struct tep_event *,
+					  struct tep_record *,
+					  int, void *),
+			  void *callback_data)
+{
+	struct follow_event **followers;
+	struct follow_event *follower;
+	struct follow_event follow;
+	int *nr_followers;
+
+	if (!tep) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	follow.event = tep_find_event_by_name(tep, system, event_name);
+	if (!follow.event) {
+		errno = ENOENT;
+		return -1;
+	}
+
+	follow.callback = callback;
+	follow.callback_data = callback_data;
+
+	if (instance) {
+		followers = &instance->followers;
+		nr_followers = &instance->nr_followers;
+	} else {
+		followers = &root_followers;
+		nr_followers = &nr_root_followers;
+	}
+	follower = realloc(*followers, sizeof(*follower) *
+			    ((*nr_followers) + 1));
+	if (!follower)
+		return -1;
+
+	*followers = follower;
+	follower[(*nr_followers)++] = follow;
+
+	return 0;
+}
+
 static bool top_iterate_keep_going;
 
 /*
@@ -247,7 +344,7 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
 	ret = open_cpu_files(instance, cpus, cpu_size, &all_cpus, &count);
 	if (ret < 0)
 		goto out;
-	ret = read_cpu_pages(tep, all_cpus, count,
+	ret = read_cpu_pages(tep, instance, all_cpus, count,
 			     callback, callback_context,
 			     keep_going);
 
-- 
2.35.1

