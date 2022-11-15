Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F13C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 04:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiKOEDz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 23:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237247AbiKOEDm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 23:03:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B2411A0F
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Nov 2022 20:03:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E640B8167D
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 04:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDEBC433D6;
        Tue, 15 Nov 2022 04:03:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ounBK-00AIC6-0c;
        Mon, 14 Nov 2022 23:04:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 4/4] libtracefs: Add tracefs_follow_missed_events() API
Date:   Mon, 14 Nov 2022 23:04:17 -0500
Message-Id: <20221115040417.2453172-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221115040417.2453172-1-rostedt@goodmis.org>
References: <20221115040417.2453172-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the function tracefs_follow_missed_events() to allow applications to
have callback when events are dropped due to overrun of the ring buffer.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-iterator.txt | 52 +++++++++++++---
 Documentation/libtracefs.txt          |  5 ++
 include/tracefs-local.h               |  2 +
 include/tracefs.h                     |  5 ++
 src/tracefs-events.c                  | 89 +++++++++++++++++++++++++++
 5 files changed, 146 insertions(+), 7 deletions(-)

diff --git a/Documentation/libtracefs-iterator.txt b/Documentation/libtracefs-iterator.txt
index f53991f5cebe..c640e7f10e44 100644
--- a/Documentation/libtracefs-iterator.txt
+++ b/Documentation/libtracefs-iterator.txt
@@ -23,6 +23,11 @@ int *tracefs_follow_event*(struct tep_handle pass:[*]_tep_, struct tracefs_insta
 					  struct tep_record pass:[*],
 					  int, void pass:[*]),
 			  void pass:[*]_callback_data_):
+int *tracefs_follow_missed_event*(struct tracefs_instance pass:[*]_instance_,
+			  int (pass:[*]_callback_)(struct tep_event pass:[*],
+					  struct tep_record pass:[*],
+					  int, void pass:[*]),
+			  void pass:[*]_callback_data_):
 --
 
 DESCRIPTION
@@ -57,6 +62,12 @@ will be passed to the _callback_ as well. Note, if it returns something other
 than 0, it will stop the loop before the _callback_ of *tracefs_iterate_raw_events()*
 is called.
 
+The *tracefs_follow_missed_events()* will call the _callback_ when missed
+events are detected. It will set the _record_ parameter of the callback to the
+record that came after the missed events and _event_ will be of the type of
+event _record_ is. _cpu_ will be set to the CPU that missed the events, and
+_callback_data_ will be the content that was passed in to the function.
+
 RETURN VALUE
 ------------
 The *tracefs_iterate_raw_events()* function returns -1 in case of an error or
@@ -69,19 +80,22 @@ EXAMPLE
 #include <unistd.h>
 #include <tracefs.h>
 #include <stdbool.h>
+#include <signal.h>
 
 struct my_struct {
 	bool		stopped;
 };
 
+#define MAX_COUNT 500000
+static int counter;
+
 static int callback(struct tep_event *event, struct tep_record *record,
 		    int cpu, void *data)
 {
 	struct my_struct *my_data = data;
 	static struct trace_seq seq;
-	static int counter;
 
-	if (counter++ > 10000) {
+	if (counter++ > MAX_COUNT) {
 		my_data->stopped = true;
 		return 1;
 	}
@@ -124,28 +138,52 @@ static int sched_callback(struct tep_event *event, struct tep_record *record,
 	return 0;
 }
 
+static int missed_callback(struct tep_event *event, struct tep_record *record,
+			   int cpu, void *data)
+{
+	printf("OOPS! cpu %d dropped ", cpu);
+	if (record->missed_events > 0)
+		printf("%lld ", record->missed_events);
+	printf("events\n");
+	return 0;
+}
+
+static struct tracefs_instance *instance;
+static struct my_struct my_data;
+
+static void sig(int s)
+{
+	tracefs_iterate_stop(instance);
+	my_data.stopped = true;
+}
+
 int main (int argc, char **argv, char **env)
 {
 	struct tep_handle *tep;
-	struct tracefs_instance *instance;
-	struct my_struct my_data = { .stopped = false };
 	int this_pid = getpid();
 
 	instance = tracefs_instance_create("my-buffer");
 	if (!instance)
 		return -1;
 
-	tracefs_event_enable(instance, "sched", NULL);
+	signal(SIGINT, sig);
+
+	tracefs_event_enable(instance, NULL, NULL);
 	sleep(1);
 	tracefs_event_disable(instance, NULL, NULL);
 	tep = tracefs_local_events(NULL);
 	tep_load_plugins(tep);
+	tracefs_follow_missed_events(instance, missed_callback, NULL);
 	tracefs_follow_event(tep, instance, "sched", "sched_switch", sched_callback, &this_pid);
 	tracefs_iterate_raw_events(tep, instance, NULL, 0, callback, &my_data);
 	tracefs_instance_destroy(instance);
 
-	if (my_data.stopped)
-		printf("stopped!\n");
+	if (my_data.stopped) {
+		if (counter > MAX_COUNT)
+			printf("Finished max count\n");
+		else
+			printf("Finished via signal\n");
+	}
 
 	return 0;
 }
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index e4178062d319..42815b0cb434 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -66,6 +66,11 @@ Trace events:
 						  struct tep_record pass:[*],
 						  int, void pass:[*]),
 				  void pass:[*]_callback_data_):
+	int *tracefs_follow_missed_event*(struct tracefs_instance pass:[*]_instance_,
+				  int (pass:[*]_callback_)(struct tep_event pass:[*],
+						  struct tep_record pass:[*],
+						  int, void pass:[*]),
+				  void pass:[*]_callback_data_):
 	struct tep_handle pass:[*]*tracefs_local_events*(const char pass:[*]_tracing_dir_);
 	struct tep_handle pass:[*]*tracefs_local_events_system*(const char pass:[*]_tracing_dir_, const char pass:[*] const pass:[*]_sys_names_);
 	int *tracefs_fill_local_events*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_, int pass:[*]_parsing_failures_);
diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 4c636be8a1fe..2007d26361cb 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -35,6 +35,7 @@ struct tracefs_instance {
 	struct tracefs_options_mask	supported_opts;
 	struct tracefs_options_mask	enabled_opts;
 	struct follow_event		*followers;
+	struct follow_event		*missed_followers;
 	char				*trace_dir;
 	char				*name;
 	pthread_mutex_t			lock;
@@ -45,6 +46,7 @@ struct tracefs_instance {
 	int				ftrace_marker_fd;
 	int				ftrace_marker_raw_fd;
 	int				nr_followers;
+	int				nr_missed_followers;
 	bool				pipe_keep_going;
 	bool				iterate_keep_going;
 };
diff --git a/include/tracefs.h b/include/tracefs.h
index cb64e098883a..3547b5a348aa 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -132,6 +132,11 @@ int tracefs_follow_event(struct tep_handle *tep, struct tracefs_instance *instan
 					  struct tep_record *,
 					  int, void *),
 			  void *callback_data);
+int tracefs_follow_missed_events(struct tracefs_instance *instance,
+				 int (*callback)(struct tep_event *,
+						 struct tep_record *,
+						 int, void *),
+				 void *callback_data);
 
 char *tracefs_event_get_file(struct tracefs_instance *instance,
 			     const char *system, const char *event,
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index abd97da8abbd..e92663656688 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -23,6 +23,9 @@
 static struct follow_event *root_followers;
 static int nr_root_followers;
 
+static struct follow_event *root_missed_followers;
+static int nr_root_missed_followers;
+
 struct cpu_iterate {
 	struct tracefs_cpu *tcpu;
 	struct tep_record record;
@@ -120,6 +123,87 @@ int read_next_record(struct tep_handle *tep, struct cpu_iterate *cpu)
 	return -1;
 }
 
+/**
+ * tracefs_follow_missed_events - Add callback for missed events for iterators
+ * @instance: The instance to follow
+ * @callback: The function to call when missed events is detected
+ * @callback_data: The data to pass to @callback
+ *
+ * This attaches a callback to an @instance or the root instance if @instance
+ * is NULL, where if tracefs_iterate_raw_events() is called, that if missed
+ * events are detected, it will call @callback, with the following parameters:
+ *  @event: The event pointer of the record with the missing events
+ *  @record; The event instance of @event.
+ *  @cpu: The cpu that the event happened on.
+ *  @callback_data: The same as @callback_data passed to the function.
+ *
+ * If the count of missing events is available, @record->missed_events
+ * will have a positive number holding the number of missed events since
+ * the last event on the same CPU, or just -1 if that number is unknown
+ * but missed events did happen.
+ *
+ * Returns 0 on success and -1 on error.
+ */
+int tracefs_follow_missed_events(struct tracefs_instance *instance,
+				 int (*callback)(struct tep_event *,
+						 struct tep_record *,
+						 int, void *),
+				 void *callback_data)
+{
+	struct follow_event **followers;
+	struct follow_event *follower;
+	struct follow_event follow;
+	int *nr_followers;
+
+	follow.event = NULL;
+	follow.callback = callback;
+	follow.callback_data = callback_data;
+
+	if (instance) {
+		followers = &instance->missed_followers;
+		nr_followers = &instance->nr_missed_followers;
+	} else {
+		followers = &root_missed_followers;
+		nr_followers = &nr_root_missed_followers;
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
+static int call_missed_events(struct tracefs_instance *instance,
+			      struct tep_event *event, struct tep_record *record, int cpu)
+{
+	struct follow_event *followers;
+	int nr_followers;
+	int ret = 0;
+	int i;
+
+	if (instance) {
+		followers = instance->missed_followers;
+		nr_followers = instance->nr_missed_followers;
+	} else {
+		followers = root_missed_followers;
+		nr_followers = nr_root_missed_followers;
+	}
+
+	if (!followers)
+		return 0;
+
+	for (i = 0; i < nr_followers; i++) {
+		ret |= followers[i].callback(event, record,
+					     cpu, followers[i].callback_data);
+	}
+
+	return ret;
+}
+
 static int call_followers(struct tracefs_instance *instance,
 			  struct tep_event *event, struct tep_record *record, int cpu)
 {
@@ -128,6 +212,11 @@ static int call_followers(struct tracefs_instance *instance,
 	int ret = 0;
 	int i;
 
+	if (record->missed_events)
+		ret = call_missed_events(instance, event, record, cpu);
+	if (ret)
+		return ret;
+
 	if (instance) {
 		followers = instance->followers;
 		nr_followers = instance->nr_followers;
-- 
2.35.1

