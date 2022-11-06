Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A23C433FE
	for <linux-trace-devel@archiver.kernel.org>; Sun,  6 Nov 2022 19:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiKFTor (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 6 Nov 2022 14:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiKFTop (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 6 Nov 2022 14:44:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D169810FDD
        for <linux-trace-devel@vger.kernel.org>; Sun,  6 Nov 2022 11:44:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 764A660D24
        for <linux-trace-devel@vger.kernel.org>; Sun,  6 Nov 2022 19:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBD0C433C1
        for <linux-trace-devel@vger.kernel.org>; Sun,  6 Nov 2022 19:44:42 +0000 (UTC)
Date:   Sun, 6 Nov 2022 14:44:41 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Add tracecmd_follow_missed_events() API
Message-ID: <20221106144441.1fb08fd5@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the function tracecmd_follow_missed_events() to let applications add
a hook for when any events are missed. The callback will be called even
if filtering is enabled.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../libtracecmd/libtracecmd-iterate.txt       | 38 ++++++++-
 Documentation/libtracecmd/libtracecmd.txt     |  6 ++
 include/trace-cmd/trace-cmd.h                 |  7 ++
 lib/trace-cmd/trace-input.c                   | 80 +++++++++++++++++++
 4 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracecmd/libtracecmd-iterate.txt b/Documentation/libtracecmd/libtracecmd-iterate.txt
index c0a99f30..5c1eece0 100644
--- a/Documentation/libtracecmd/libtracecmd-iterate.txt
+++ b/Documentation/libtracecmd/libtracecmd-iterate.txt
@@ -4,7 +4,7 @@ libtracecmd(3)
 NAME
 ----
 tracecmd_iterate_events, tracecmd_iterate_events_multi, tracecmd_follow_event,
-tracecmd_filter_add - Read events from a trace file
+tracecmd_follow_missed_events, tracecmd_filter_add - Read events from a trace file
 
 SYNOPSIS
 --------
@@ -31,6 +31,12 @@ int *tracecmd_follow_event*(struct tracecmd_input pass:[*]_handle_,
 					  struct tep_record pass:[*],
 					  int, void pass:[*]),
 			  void pass:[*]_callback_data_);
+int *tracecmd_follow_missed_events*(struct tracecmd_input pass:[*]_handle_,
+				   int (pass:[*]_callback_)(struct tracecmd_input pass:[*],
+						   struct tep_event pass:[*],
+						   struct tep_record pass:[*],
+						   int, void pass:[*]),
+				   void pass:[*]_callback_data_);
 struct tracecmd_filter pass:[*]*tracecmd_filter_add*(struct tracecmd_input *_handle_,
 					    const char pass:[*]_filter_str_, bool _neg_);
 --
@@ -80,6 +86,9 @@ event is on.
 The *tracecmd_follow_event()* function will attach to a trace file descriptor _handle_
 and call the _callback_ when the event described by _system_ and _name_ matches an event
 in the iteration of *tracecmd_iterate_events()* or *tracecmd_iterate_events_multi()*.
+Note, the _cpu_ is the nth CPU for both *tracecmd_iterate_events()* and
+*tracecmd_iterate_events_multi()*. If the actual CPU of the _record_ is needed, use
+_record_->cpu.
 For *tracecmd_iterate_events_multi()*, the _callback_ is only called if the _handle_
 matches the current trace file descriptor within _handles_. The _callback_data_ is
 passed as the last parameter to the _callback()_ function. Note, this _callback()_
@@ -90,6 +99,21 @@ The _callback()_ prototype for *tracecmd_follow_event()_ is:
 int _callback()_(struct tracecmd_input pass:[*]_handle_, struct tep_event pass:[*]_event,
 		 struct tep_record pass:[*]_record_, int _cpu_, void pass:[*]_data_);
 
+The *tracecmd_follow_missed_events()* function will attach to a trace file descriptor
+_handle_ and call the _callback_ when missed events are detected. The _event_ will
+hold the type of event that the _record_ is. The _record_ will hold the information
+of the missed events. The _cpu_ is the nth CPU for both *tracecmd_iterate_events()*
+and *tracecmd_iterate_events_multi()*. If the CPU that the missed events are for is
+needed, use _record_->cpu. If _record_->missed_events is a positive number, then it
+holds the number of missed events since the last event on its CPU, otherwise it
+will be negative, and that will mean that the number of missed events is unknown but
+missed events exist since the last event on the CPU.
+The _callback_ and _callback_data_ is the same format as *tracecmd_follow_event()* above.
+The missed events _callback_ is called before any of the other _callbacks_ and any
+filters that were added by *tracecmd_filter_add()* are ignored.
+If _callback_ returns a non zero, it will stop the iterator before it calls any of the
+other iterator callbacks for the given record.
+
 The *tracecmd_filter_add()* function, adds a filter to _handle_ that affects
 both *tracecmd_iterate_events()* and *tracecmd_iterate_events_multi()*.
 The _filter_str_ is a character string defining a filter in a format that
@@ -148,6 +172,17 @@ static int print_event(struct tracecmd_input *handle, struct tep_event *event,
 	return print_events(handle, record, cpu, data);
 }
 
+static int missed_events(struct tracecmd_input *handle, struct tep_event *event,
+			 struct tep_record *record, int cpu, void *data)
+{
+	if (record->missed_events > 0)
+		printf("CPU [%03d] has %d missed events\n",
+			 record->cpu, record->missed_events);
+	else
+		printf("CPU [%03d] has missed events\n", record->cpu);
+	return 0;
+}
+
 static void usage(const char *argv0)
 {
 	printf("usage: [-c cpu][-f filter][-e event] %s trace.dat [trace.dat ...]\n",
@@ -218,6 +253,7 @@ int main(int argc, char **argv)
 				exit(-1);
 			}
 		}
+		tracecmd_follow_missed_events(handles[nr_handles], missed_events, NULL);
 		nr_handles++;
 	}
 
diff --git a/Documentation/libtracecmd/libtracecmd.txt b/Documentation/libtracecmd/libtracecmd.txt
index b1e07df5..a820ed32 100644
--- a/Documentation/libtracecmd/libtracecmd.txt
+++ b/Documentation/libtracecmd/libtracecmd.txt
@@ -47,6 +47,12 @@ Iterating over events in a trace file:
 						  struct tep_record pass:[*],
 						  int, void pass:[*]),
 				  void pass:[*]_callback_data_);
+	int *tracecmd_follow_missed_events*(struct tracecmd_input pass:[*]_handle_,
+					   int (pass:[*]_callback_)(struct tracecmd_input pass:[*],
+							   struct tep_event pass:[*],
+							   struct tep_record pass:[*],
+							   int, void pass:[*]),
+					   void pass:[*]_callback_data_);
 	struct tracecmd_filter pass:[*]*tracecmd_filter_add*(struct tracecmd_input *_handle_,
 						    const char pass:[*]_filter_str_, bool _neg_);
 
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index c34503ac..61ab4f03 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -63,6 +63,13 @@ int tracecmd_follow_event(struct tracecmd_input *handle,
 					  int, void *),
 			  void *callback_data);
 
+int tracecmd_follow_missed_events(struct tracecmd_input *handle,
+				  int (*callback)(struct tracecmd_input *handle,
+						  struct tep_event *,
+						  struct tep_record *,
+						  int, void *),
+				  void *callback_data);
+
 int tracecmd_iterate_events(struct tracecmd_input *handle,
 			    cpu_set_t *cpus, int cpu_size,
 			    int (*callback)(struct tracecmd_input *handle,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 6a8ca2e8..aa54e7fa 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -171,6 +171,7 @@ struct tracecmd_input {
 	struct tracecmd_input	*parent;
 	struct tracecmd_filter	*filter;
 	struct follow_event	*followers;
+	struct follow_event	*missed_followers;
 	struct tracecmd_cpu_map *map;
 	unsigned long		file_state;
 	unsigned long long	trace_id;
@@ -185,6 +186,7 @@ struct tracecmd_input {
 	int			start_cpu;
 	int			ref;
 	int			nr_followers;
+	int			nr_missed_followers;
 	int			nr_buffers;	/* buffer instances */
 	bool			use_trace_clock;
 	bool			read_page;
@@ -2626,6 +2628,57 @@ int tracecmd_follow_event(struct tracecmd_input *handle,
 	return 0;
 }
 
+/**
+ * tracecmd_follow_missed_events - Add callback for missed events for iterators
+ * @handle: The handle to get a callback from
+ * @callback: The function to call when missed events is detected
+ * @callback_data: The data to pass to @callback
+ *
+ * This attaches a callback to @handle where if tracecmd_iterate_events()
+ * or tracecmd_iterate_events_multi() is called, that if missed events
+ * is detected, it will call @callback, with the following parameters:
+ *  @handle: Same handle as passed to this function.
+ *  @event: The event pointer of the record with the missing events
+ *  @record; The event instance of @event.
+ *  @cpu: The cpu that the event happened on.
+ *  @callback_data: The same as @callback_data passed to the function.
+ *
+ * Note that when used with tracecmd_iterate_events_multi() that @cpu
+ * may be the nth CPU of all handles it is processing, so if the CPU
+ * that the @record is on is desired, then use @record->cpu.
+ *
+ * If the count of missing events is available, @record->missed_events
+ * will have a positive number holding the number of missed events since
+ * the last event on the same CPU, or just -1 if that number is unknown
+ * but missed events did happen.
+ *
+ * Returns 0 on success and -1 on error.
+ */
+int tracecmd_follow_missed_events(struct tracecmd_input *handle,
+				  int (*callback)(struct tracecmd_input *handle,
+						  struct tep_event *,
+						  struct tep_record *,
+						  int, void *),
+				  void *callback_data)
+{
+	struct follow_event *followers;
+	struct follow_event follow;
+
+	follow.event = NULL;
+	follow.callback = callback;
+	follow.callback_data = callback_data;
+
+	followers = realloc(handle->missed_followers, sizeof(*followers) *
+			    (handle->nr_missed_followers + 1));
+	if (!followers)
+		return -1;
+
+	handle->missed_followers = followers;
+	followers[handle->nr_missed_followers++] = follow;
+
+	return 0;
+}
+
 static int call_followers(struct tracecmd_input *handle,
 			  struct tep_record *record, int cpu)
 {
@@ -2648,6 +2701,27 @@ static int call_followers(struct tracecmd_input *handle,
 	return ret;
 }
 
+static int call_missed_events(struct tracecmd_input *handle,
+			      struct tep_record *record, int cpu)
+{
+	struct tep_handle *tep = tracecmd_get_tep(handle);
+	struct follow_event *followers = handle->missed_followers;
+	struct tep_event *event;
+	int ret = 0;
+	int i;
+
+	event = tep_find_event_by_record(tep, record);
+	if (!event)
+		return -1;
+
+	for (i = 0; i < handle->nr_missed_followers; i++) {
+		ret |= followers[i].callback(handle, event, record,
+					     cpu, followers[i].callback_data);
+	}
+
+	return ret;
+}
+
 static int call_callbacks(struct tracecmd_input *handle, struct tep_record *record,
 			  int next_cpu,
 			  int (*callback)(struct tracecmd_input *handle,
@@ -2660,6 +2734,12 @@ static int call_callbacks(struct tracecmd_input *handle, struct tep_record *reco
 	if (!record)
 		return 0;
 
+	if (record->missed_events)
+		ret = call_missed_events(handle, record, next_cpu);
+
+	if (ret)
+		return ret;
+
 	if (!handle->filter ||
 	    tracecmd_filter_match(handle->filter, record) == TRACECMD_FILTER_MATCH) {
 		if (handle->nr_followers)
-- 
2.35.1

