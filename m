Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750AE10A07
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F102C43391;
	Thu, 28 Dec 2023 21:53:45 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIyKo-00000000EJ7-3wv8;
	Thu, 28 Dec 2023 16:54:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 08/22] libtracefs: Add API to remove followers from an instance or toplevel
Date: Thu, 28 Dec 2023 16:52:03 -0500
Message-ID: <20231228215433.54854-9-rostedt@goodmis.org>
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

Add the APIs:

 tracefs_follow_event_clear()
 tracefs_follow_missed_events_clear()

When adding some more tracefs unit tests, the follower callbacks were being
called unexpectedly and causing failures and crashes, as the data used by
the callbacks was already freed by the time it hit the other test.

Add a way to remove the followers and do so in the unit tests.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-iterator.txt |  30 +++-
 include/tracefs.h                     |   4 +
 src/tracefs-events.c                  | 103 ++++++++++++
 utest/tracefs-utest.c                 | 230 ++++++++++++++++++++++++++
 4 files changed, 366 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-iterator.txt b/Documentation/libtracefs-iterator.txt
index b971bd0e10c5..c2b2be3f4c5c 100644
--- a/Documentation/libtracefs-iterator.txt
+++ b/Documentation/libtracefs-iterator.txt
@@ -3,7 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_iterate_raw_events, tracefs_iterate_stop, tracefs_follow_event, tracefs_follow_missed_events - Iterate over events in the ring buffer
+tracefs_iterate_raw_events, tracefs_iterate_stop, tracefs_follow_event, tracefs_follow_missed_events,
+tracefs_follow_event_clear, tracefs_follow_missed_events_clear - Iterate over events in the ring buffer
 
 SYNOPSIS
 --------
@@ -28,6 +29,10 @@ int *tracefs_follow_missed_events*(struct tracefs_instance pass:[*]_instance_,
 					  struct tep_record pass:[*],
 					  int, void pass:[*]),
 			  void pass:[*]_callback_data_);
+
+int *tracefs_follow_event_clear*(struct tracefs_instance pass:[*]_instance_,
+			  const char pass:[*]_system_, const char pass:[*]_event_name_);
+int *tracefs_follow_missed_events_clear*(struct tracefs_instance pass:[*]_instance_);
 --
 
 DESCRIPTION
@@ -68,11 +73,24 @@ record that came after the missed events and _event_ will be of the type of
 event _record_ is. _cpu_ will be set to the CPU that missed the events, and
 _callback_data_ will be the content that was passed in to the function.
 
+The *tracefs_follow_event_clear()* will remove followers from _instance_ that
+match _system_ and _event_name_. If _system_ and _event_name_ are both NULL,
+then it will remove all event followers associated to _instance_. If just _system_
+is NULL, then it will remove all followers that follow events that match _event_name_. If just _event_name_
+is NULL, then it will remove all followers that are attached to events that are
+apart of a system that matches _system_.
+
+The *tracefs_follow_missed_events_clear()* will remove all followers for missed
+events.
+
 RETURN VALUE
 ------------
 The *tracefs_iterate_raw_events()* function returns -1 in case of an error or
 0 otherwise.
 
+Both *tracefs_follow_event_clear()* and *tracefs_follow_missed_events_clear()* return
+0 on success and -1 on error, or if it found no followers that match and should be removed.
+
 EXAMPLE
 -------
 [source,c]
@@ -176,7 +194,17 @@ int main (int argc, char **argv, char **env)
 	tracefs_follow_missed_events(instance, missed_callback, NULL);
 	tracefs_follow_event(tep, instance, "sched", "sched_switch", sched_callback, &this_pid);
 	tracefs_iterate_raw_events(tep, instance, NULL, 0, callback, &my_data);
+
+	/* Note, the clear here is to show how to clear all followers
+	 * in case tracefs_iterate_raw_events() is called again, but
+	 * does not want to include the followers. It's not needed
+	 * here because tracefs_instance_free() will clean them up.
+	 */
+	tracefs_follow_event_clear(instance, NULL, NULL);
+	tracefs_follow_missed_events_clear(instance);
+
 	tracefs_instance_destroy(instance);
+	tracefs_instance_free(instance);
 
 	if (my_data.stopped) {
 		if (counter > MAX_COUNT)
diff --git a/include/tracefs.h b/include/tracefs.h
index 90df00f531ea..25429a30c028 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -138,6 +138,10 @@ int tracefs_follow_missed_events(struct tracefs_instance *instance,
 						 struct tep_record *,
 						 int, void *),
 				 void *callback_data);
+int tracefs_follow_event_clear(struct tracefs_instance *instance,
+			  const char *system, const char *event_name);
+int tracefs_follow_missed_events_clear(struct tracefs_instance *instance);
+
 
 char *tracefs_event_get_file(struct tracefs_instance *instance,
 			     const char *system, const char *event,
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index c6b1d7637e72..2e87f9aa3af7 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -392,6 +392,109 @@ int tracefs_follow_event(struct tep_handle *tep, struct tracefs_instance *instan
 	return 0;
 }
 
+/**
+ * tracefs_follow_event_clear - Remove callbacks for specific events for iterators
+ * @instance: The instance to follow
+ * @system: The system of the event to remove (NULL for all)
+ * @event_name: The name of the event to remove (NULL for all)
+ *
+ * This removes all callbacks from an instance that matches a specific
+ * event. If @event_name is NULL, then it removes all followers that match
+ * @system. If @system is NULL, then it removes all followers that match
+ * @event_name. If both @system and @event_name are NULL then it removes all
+ * followers for all events.
+ *
+ * Returns 0 on success and -1 on error (which includes no followers found)
+ */
+int tracefs_follow_event_clear(struct tracefs_instance *instance,
+			       const char *system, const char *event_name)
+{
+	struct follow_event **followers;
+	struct follow_event *follower;
+	int *nr_followers;
+	int nr;
+	int i, n;
+
+	if (instance) {
+		followers = &instance->followers;
+		nr_followers = &instance->nr_followers;
+	} else {
+		followers = &root_followers;
+		nr_followers = &nr_root_followers;
+	}
+
+	if (!*nr_followers)
+		return -1;
+
+	/* If both system and event_name are NULL just remove all */
+	if (!system && !event_name) {
+		free(*followers);
+		*followers = NULL;
+		*nr_followers = 0;
+		return 0;
+	}
+
+	nr = *nr_followers;
+	follower = *followers;
+
+	for (i = 0, n = 0; i < nr; i++) {
+		if (event_name && strcmp(event_name, follower[n].event->name) != 0) {
+			n++;
+			continue;
+		}
+		if (system && strcmp(system, follower[n].event->system) != 0) {
+			n++;
+			continue;
+		}
+		/* If there are no more after this, continue to increment i */
+		if (i == nr - 1)
+			continue;
+		/* Remove this follower */
+		memmove(&follower[n], &follower[n + 1],
+			sizeof(*follower) * (nr - (n + 1)));
+	}
+
+	/* Did we find anything? */
+	if (n == i)
+		return -1;
+
+	/* NULL out the rest */
+	memset(&follower[n], 0, (sizeof(*follower)) * (nr - n));
+	*nr_followers = n;
+
+	return 0;
+}
+
+/**
+ * tracefs_follow_missed_events_clear - Remove callbacks for missed events
+ * @instance: The instance to remove missed callback followers
+ *
+ * This removes all callbacks from an instance that are for missed events.
+ *
+ * Returns 0 on success and -1 on error (which includes no followers found)
+ */
+int tracefs_follow_missed_events_clear(struct tracefs_instance *instance)
+{
+	struct follow_event **followers;
+	int *nr_followers;
+
+	if (instance) {
+		followers = &instance->missed_followers;
+		nr_followers = &instance->nr_missed_followers;
+	} else {
+		followers = &root_missed_followers;
+		nr_followers = &nr_root_missed_followers;
+	}
+
+	if (!*nr_followers)
+		return -1;
+
+	free(*followers);
+	*followers = NULL;
+	*nr_followers = 0;
+	return 0;
+}
+
 static bool top_iterate_keep_going;
 
 /*
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 183f37cd133a..492e5c05551f 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -63,6 +63,16 @@ static struct test_sample test_array[TEST_ARRAY_SIZE];
 static int test_found;
 static unsigned long long last_ts;
 
+static void msleep(int ms)
+{
+	struct timespec tspec;
+
+	/* Sleep for 1ms */
+	tspec.tv_sec = 0;
+	tspec.tv_nsec = 1000000 * ms;
+	nanosleep(&tspec, NULL);
+}
+
 static int test_callback(struct tep_event *event, struct tep_record *record,
 			  int cpu, void *context)
 {
@@ -608,10 +618,23 @@ static void test_trace_cpu_read(void)
 struct follow_data {
 	struct tep_event *sched_switch;
 	struct tep_event *sched_waking;
+	struct tep_event *getppid;
 	struct tep_event *function;
 	int missed;
+	int switch_hit;
+	int waking_hit;
+	int getppid_hit;
+	int missed_hit;
 };
 
+static void clear_hits(struct follow_data *fdata)
+{
+	fdata->switch_hit = 0;
+	fdata->waking_hit = 0;
+	fdata->getppid_hit = 0;
+	fdata->missed_hit = 0;
+}
+
 static int switch_callback(struct tep_event *event, struct tep_record *record,
 			   int cpu, void *data)
 {
@@ -619,6 +642,7 @@ static int switch_callback(struct tep_event *event, struct tep_record *record,
 
 	CU_TEST(cpu == record->cpu);
 	CU_TEST(event->id == fdata->sched_switch->id);
+	fdata->switch_hit++;
 	return 0;
 }
 
@@ -629,6 +653,18 @@ static int waking_callback(struct tep_event *event, struct tep_record *record,
 
 	CU_TEST(cpu == record->cpu);
 	CU_TEST(event->id == fdata->sched_waking->id);
+	fdata->waking_hit++;
+	return 0;
+}
+
+static int getppid_callback(struct tep_event *event, struct tep_record *record,
+			    int cpu, void *data)
+{
+	struct follow_data *fdata = data;
+
+	CU_TEST(cpu == record->cpu);
+	CU_TEST(event->id == fdata->getppid->id);
+	fdata->getppid_hit++;
 	return 0;
 }
 
@@ -648,6 +684,7 @@ static int missed_callback(struct tep_event *event, struct tep_record *record,
 	struct follow_data *fdata = data;
 
 	fdata->missed = record->missed_events;
+	fdata->missed_hit++;
 	return 0;
 }
 
@@ -725,6 +762,11 @@ static void test_instance_follow_events(struct tracefs_instance *instance)
 	ret = tracefs_iterate_raw_events(tep, instance, NULL, 0, all_callback, &fdata);
 	CU_TEST(ret == 0);
 
+	ret = tracefs_follow_event_clear(instance, NULL, NULL);
+	CU_TEST(ret == 0);
+	ret = tracefs_follow_missed_events_clear(instance);
+	CU_TEST(ret == 0);
+
 	pthread_join(thread, NULL);
 
 	tracefs_tracer_clear(instance);
@@ -737,6 +779,193 @@ static void test_follow_events(void)
 	test_instance_follow_events(test_instance);
 }
 
+static void test_instance_follow_events_clear(struct tracefs_instance *instance)
+{
+	struct follow_data fdata;
+	struct tep_handle *tep;
+	char **list;
+	int ret;
+
+	memset(&fdata, 0, sizeof(fdata));
+
+	tep = test_tep;
+
+	fdata.sched_switch = tep_find_event_by_name(tep, "sched", "sched_switch");
+	CU_TEST(fdata.sched_switch != NULL);
+	if (!fdata.sched_switch)
+		return;
+
+	fdata.sched_waking = tep_find_event_by_name(tep, "sched", "sched_waking");
+	CU_TEST(fdata.sched_waking != NULL);
+	if (!fdata.sched_waking)
+		return;
+
+	fdata.getppid = tep_find_event_by_name(tep, EVENT_SYSTEM, EVENT_NAME);
+	CU_TEST(fdata.getppid != NULL);
+	if (!fdata.getppid)
+		return;
+
+	ret = tracefs_follow_event(tep, instance, "sched", "sched_switch",
+				   switch_callback, &fdata);
+	CU_TEST(ret == 0);
+
+	ret = tracefs_follow_event(tep, instance, "sched", "sched_waking",
+				   waking_callback, &fdata);
+	CU_TEST(ret == 0);
+
+	ret = tracefs_follow_event(tep, instance, EVENT_SYSTEM, EVENT_NAME,
+				   getppid_callback, &fdata);
+	CU_TEST(ret == 0);
+
+	ret = tracefs_follow_missed_events(instance, missed_callback, &fdata);
+	CU_TEST(ret == 0);
+
+	ret = tracefs_event_enable(instance, "sched", "sched_switch");
+	CU_TEST(ret == 0);
+
+	ret = tracefs_event_enable(instance, "sched", "sched_waking");
+	CU_TEST(ret == 0);
+
+	ret = tracefs_event_enable(instance, EVENT_SYSTEM, EVENT_NAME);
+	CU_TEST(ret == 0);
+
+	tracefs_trace_on(instance);
+	call_getppid(100);
+	msleep(100);
+	tracefs_trace_off(instance);
+
+	ret = tracefs_iterate_raw_events(tep, instance, NULL, 0, NULL, &fdata);
+	CU_TEST(ret == 0);
+
+	/* Make sure all are hit */
+	CU_TEST(fdata.switch_hit > 0);
+	CU_TEST(fdata.waking_hit > 0);
+	CU_TEST(fdata.getppid_hit == 100);
+	/* No missed events */
+	CU_TEST(fdata.missed_hit == 0);
+	clear_hits(&fdata);
+
+
+
+	/* Disable getppid and do the same thing */
+	ret = tracefs_follow_event_clear(instance, EVENT_SYSTEM, EVENT_NAME);
+	CU_TEST(ret == 0);
+
+	tracefs_trace_on(instance);
+	call_getppid(100);
+	msleep(100);
+	tracefs_trace_off(instance);
+
+	ret = tracefs_iterate_raw_events(tep, instance, NULL, 0, NULL, &fdata);
+	CU_TEST(ret == 0);
+
+	/* All but getppid should be hit */
+	CU_TEST(fdata.switch_hit > 0);
+	CU_TEST(fdata.waking_hit > 0);
+	CU_TEST(fdata.getppid_hit == 0);
+	/* No missed events */
+	CU_TEST(fdata.missed_hit == 0);
+	clear_hits(&fdata);
+
+
+
+	/* Add function and remove sched */
+	ret = tracefs_follow_event(tep, instance, "ftrace", "function",
+				   function_callback, &fdata);
+	CU_TEST(ret == 0);
+	ret = tracefs_follow_event_clear(instance, "sched", NULL);
+	CU_TEST(ret == 0);
+
+	tracefs_trace_on(instance);
+	call_getppid(100);
+	msleep(100);
+	tracefs_trace_off(instance);
+
+	ret = tracefs_iterate_raw_events(tep, instance, NULL, 0, NULL, &fdata);
+	CU_TEST(ret == 0);
+
+	/* Nothing should have been hit */
+	CU_TEST(fdata.switch_hit == 0);
+	CU_TEST(fdata.waking_hit == 0);
+	CU_TEST(fdata.getppid_hit == 0);
+	/* No missed events */
+	CU_TEST(fdata.missed_hit == 0);
+	clear_hits(&fdata);
+
+
+	/* Enable function tracing and see if we missed hits */
+	ret = tracefs_tracer_set(instance, TRACEFS_TRACER_FUNCTION);
+	CU_TEST(ret == 0);
+
+	fdata.function = tep_find_event_by_name(tep, "ftrace", "function");
+	CU_TEST(fdata.function != NULL);
+	if (!fdata.function)
+		return;
+
+	tracefs_trace_on(instance);
+	call_getppid(100);
+	/* Stir the kernel a bit */
+	list = tracefs_event_systems(NULL);
+	tracefs_list_free(list);
+	sleep(1);
+	tracefs_trace_off(instance);
+
+	ret = tracefs_iterate_raw_events(tep, instance, NULL, 0, NULL, &fdata);
+	CU_TEST(ret == 0);
+
+	/* Nothing should have been hit */
+	CU_TEST(fdata.switch_hit == 0);
+	CU_TEST(fdata.waking_hit == 0);
+	CU_TEST(fdata.getppid_hit == 0);
+	/* We should have missed events! */
+	CU_TEST(fdata.missed_hit > 0);
+	clear_hits(&fdata);
+
+
+	/* Now remove missed events follower */
+	ret = tracefs_follow_missed_events_clear(instance);
+	CU_TEST(ret == 0);
+
+	tracefs_trace_on(instance);
+	call_getppid(100);
+	sleep(1);
+	tracefs_trace_off(instance);
+
+	ret = tracefs_iterate_raw_events(tep, instance, NULL, 0, NULL, &fdata);
+	CU_TEST(ret == 0);
+
+	/* Nothing should have been hit */
+	CU_TEST(fdata.switch_hit == 0);
+	CU_TEST(fdata.waking_hit == 0);
+	CU_TEST(fdata.getppid_hit == 0);
+	/* No missed events either */
+	CU_TEST(fdata.missed_hit == 0);
+	clear_hits(&fdata);
+
+	/* Turn everything off */
+	tracefs_tracer_clear(instance);
+	tracefs_event_disable(instance, NULL, NULL);
+
+	tracefs_trace_on(instance);
+
+	/* Clear the function follower */
+	ret = tracefs_follow_event_clear(instance, NULL, "function");
+
+	/* Should not have any more followers */
+	ret = tracefs_follow_event_clear(instance, NULL, NULL);
+	CU_TEST(ret != 0);
+
+	/* Nor missed event followers */
+	ret = tracefs_follow_missed_events_clear(instance);
+	CU_TEST(ret != 0);
+}
+
+static void test_follow_events_clear(void)
+{
+	test_instance_follow_events_clear(NULL);
+	test_instance_follow_events_clear(test_instance);
+}
+
 extern char *find_tracing_dir(bool debugfs, bool mount);
 static void test_mounting(void)
 {
@@ -2570,6 +2799,7 @@ void test_tracefs_lib(void)
 
 	/* Follow events test must be after the iterate raw events above */
 	CU_add_test(suite, "Follow events", test_follow_events);
+	CU_add_test(suite, "Follow events clear", test_follow_events_clear);
 
 	CU_add_test(suite, "tracefs_tracers API",
 		    test_tracers);
-- 
2.42.0

