Return-Path: <SRS0=yn/p=LE=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f49.google.com ([209.85.221.49]:35192 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbeHUQyM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Aug 2018 12:54:12 -0400
Received: by mail-wr1-f49.google.com with SMTP id j26-v6so53036wre.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Aug 2018 06:33:59 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/24] tools lib traceevent: Rename pevent_find_* APIs
Date: Tue, 21 Aug 2018 16:33:24 +0300
Message-Id: <20180821133328.3249-21-tz.stoyanov@gmail.com>
In-Reply-To: <20180821133328.3249-1-tz.stoyanov@gmail.com>
References: <20180821133328.3249-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_find_function, pevent_find_function_address,
pevent_find_event_by_name, pevent_find_event_by_record

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180808180702.966965051@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h |  8 ++++----
 kernel-shark/trace-capture.c     |  2 +-
 kernel-shark/trace-filter.c      |  2 +-
 kernel-shark/trace-graph.c       | 32 ++++++++++++++++----------------
 kernel-shark/trace-view-store.c  |  6 +++---
 lib/trace-cmd/trace-blk-hack.c   |  6 +++---
 lib/trace-cmd/trace-ftrace.c     | 16 ++++++++--------
 lib/traceevent/event-parse.c     | 24 ++++++++++++------------
 lib/traceevent/parse-filter.c    | 10 +++++-----
 plugins/plugin_function.c        |  6 +++---
 plugins/plugin_kmem.c            |  4 ++--
 python/ctracecmd.i               |  2 +-
 tracecmd/trace-hist.c            | 10 +++++-----
 tracecmd/trace-mem.c             |  4 ++--
 tracecmd/trace-profile.c         | 10 +++++-----
 tracecmd/trace-read.c            | 14 +++++++-------
 16 files changed, 78 insertions(+), 78 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index e1628f5..87777c2 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -678,9 +678,9 @@ struct format_field *tep_find_common_field(struct event_format *event, const cha
 struct format_field *tep_find_field(struct event_format *event, const char *name);
 struct format_field *tep_find_any_field(struct event_format *event, const char *name);
 
-const char *pevent_find_function(struct tep_handle *pevent, unsigned long long addr);
+const char *tep_find_function(struct tep_handle *pevent, unsigned long long addr);
 unsigned long long
-pevent_find_function_address(struct tep_handle *pevent, unsigned long long addr);
+tep_find_function_address(struct tep_handle *pevent, unsigned long long addr);
 unsigned long long tep_read_number(struct tep_handle *pevent, const void *ptr, int size);
 int tep_read_number_field(struct format_field *field, const void *data,
 			  unsigned long long *value);
@@ -688,10 +688,10 @@ int tep_read_number_field(struct format_field *field, const void *data,
 struct event_format *tep_find_event(struct tep_handle *pevent, int id);
 
 struct event_format *
-pevent_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *name);
+tep_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *name);
 
 struct event_format *
-pevent_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
+tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
 
 void tep_data_lat_fmt(struct tep_handle *pevent,
 		      struct trace_seq *s, struct tep_record *record);
diff --git a/kernel-shark/trace-capture.c b/kernel-shark/trace-capture.c
index 27cea40..4bfec6a 100644
--- a/kernel-shark/trace-capture.c
+++ b/kernel-shark/trace-capture.c
@@ -841,7 +841,7 @@ static int load_events(struct trace_capture *cap,
 			continue;
 		event_name = tracecmd_xml_node_value(handle, event_node);
 
-		event = pevent_find_event_by_name(pevent, system, event_name);
+		event = tep_find_event_by_name(pevent, system, event_name);
 
 		if (!event)
 			continue;
diff --git a/kernel-shark/trace-filter.c b/kernel-shark/trace-filter.c
index b762d97..d9b1563 100644
--- a/kernel-shark/trace-filter.c
+++ b/kernel-shark/trace-filter.c
@@ -194,7 +194,7 @@ static void update_field_combo(struct tep_handle *pevent,
 		return;
 
 	if (event_name) {
-		event = pevent_find_event_by_name(pevent, system, event_name);
+		event = tep_find_event_by_name(pevent, system, event_name);
 		if (!event)
 			return;
 	} else {
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index b6890e9..808b2f3 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -1016,8 +1016,8 @@ int trace_graph_check_sched_wakeup(struct graph_info *ginfo,
 
 		found = FALSE;
 
-		event = pevent_find_event_by_name(ginfo->pevent,
-						  NULL, "sched_wakeup");
+		event = tep_find_event_by_name(ginfo->pevent,
+					       NULL, "sched_wakeup");
 		if (event) {
 			found = TRUE;
 			ginfo->event_wakeup_id = event->id;
@@ -1026,8 +1026,8 @@ int trace_graph_check_sched_wakeup(struct graph_info *ginfo,
 		}
 
 
-		event = pevent_find_event_by_name(ginfo->pevent,
-						  NULL, "sched_wakeup_new");
+		event = tep_find_event_by_name(ginfo->pevent,
+					       NULL, "sched_wakeup_new");
 		if (event) {
 			found = TRUE;
 			ginfo->event_wakeup_new_id = event->id;
@@ -1086,8 +1086,8 @@ int trace_graph_check_sched_switch(struct graph_info *ginfo,
 	}
 
 	if (ginfo->event_sched_switch_id < 0) {
-		event = pevent_find_event_by_name(ginfo->pevent,
-						  NULL, "sched_switch");
+		event = tep_find_event_by_name(ginfo->pevent,
+					       NULL, "sched_switch");
 		if (!event)
 			return 0;
 
@@ -1096,8 +1096,8 @@ int trace_graph_check_sched_switch(struct graph_info *ginfo,
 		ginfo->event_pid_field = tep_find_field(event, "next_pid");
 		ginfo->event_comm_field = tep_find_field(event, "next_comm");
 
-		event = pevent_find_event_by_name(ginfo->pevent,
-						  "ftrace", "context_switch");
+		event = tep_find_event_by_name(ginfo->pevent,
+					       "ftrace", "context_switch");
 		if (event) {
 			ginfo->ftrace_sched_switch_id = event->id;
 			ginfo->ftrace_pid_field = tep_find_field(event, "next_pid");
@@ -1164,32 +1164,32 @@ trace_graph_check_irq(struct graph_info *ginfo,
 		gint soft_irq_entry_len = 0;
 		gint soft_irq_exit_len = 0;
 
-		event = pevent_find_event_by_name(ginfo->pevent,
-						  NULL, "irq_handler_exit");
+		event = tep_find_event_by_name(ginfo->pevent,
+					       NULL, "irq_handler_exit");
 		if (event)
 			enter_id(&ginfo->hard_irq_exit_ids, event->id,
 				 &hard_irq_exit_len);
 		else
 			ginfo->hard_irq_exit_ids = null_int_array;
 
-		event = pevent_find_event_by_name(ginfo->pevent,
-						  NULL, "irq_handler_entry");
+		event = tep_find_event_by_name(ginfo->pevent,
+					       NULL, "irq_handler_entry");
 		if (event)
 			enter_id(&ginfo->hard_irq_entry_ids, event->id,
 				 &hard_irq_entry_len);
 		else
 			ginfo->hard_irq_entry_ids = null_int_array;
 
-		event = pevent_find_event_by_name(ginfo->pevent,
-						  NULL, "softirq_exit");
+		event = tep_find_event_by_name(ginfo->pevent,
+					       NULL, "softirq_exit");
 		if (event)
 			enter_id(&ginfo->soft_irq_exit_ids, event->id,
 				 &soft_irq_exit_len);
 		else
 			ginfo->soft_irq_exit_ids = null_int_array;
 
-		event = pevent_find_event_by_name(ginfo->pevent,
-						  NULL, "softirq_entry");
+		event = tep_find_event_by_name(ginfo->pevent,
+					       NULL, "softirq_entry");
 		if (event)
 			enter_id(&ginfo->soft_irq_entry_ids, event->id,
 				 &soft_irq_entry_len);
diff --git a/kernel-shark/trace-view-store.c b/kernel-shark/trace-view-store.c
index 92ddf7e..a798804 100644
--- a/kernel-shark/trace-view-store.c
+++ b/kernel-shark/trace-view-store.c
@@ -1227,20 +1227,20 @@ static void update_filter_tasks(TraceViewStore *store)
 
 	if (!store->sched_switch_event) {
 		store->sched_switch_event =
-			pevent_find_event_by_name(pevent, "sched", "sched_switch");
+			tep_find_event_by_name(pevent, "sched", "sched_switch");
 		if (store->sched_switch_event)
 			store->sched_switch_next_field =
 				tep_find_any_field(store->sched_switch_event,
 						      "next_pid");
 		store->sched_wakeup_event =
-			pevent_find_event_by_name(pevent, "sched", "sched_wakeup");
+			tep_find_event_by_name(pevent, "sched", "sched_wakeup");
 		if (store->sched_wakeup_event)
 			store->sched_wakeup_pid_field =
 				tep_find_any_field(store->sched_wakeup_event,
 						      "pid");
 
 		store->sched_wakeup_new_event =
-			pevent_find_event_by_name(pevent, "sched", "sched_wakeup_new");
+			tep_find_event_by_name(pevent, "sched", "sched_wakeup_new");
 		if (store->sched_wakeup_new_event)
 			store->sched_wakeup_new_pid_field =
 				tep_find_any_field(store->sched_wakeup_new_event,
diff --git a/lib/trace-cmd/trace-blk-hack.c b/lib/trace-cmd/trace-blk-hack.c
index 2883c68..dbeedab 100644
--- a/lib/trace-cmd/trace-blk-hack.c
+++ b/lib/trace-cmd/trace-blk-hack.c
@@ -48,7 +48,7 @@ int tracecmd_blk_hack(struct tracecmd_input *handle)
 	 */
 
 	/* It was originally behind the "power" event */
-	event = pevent_find_event_by_name(pevent, "ftrace", "power");
+	event = tep_find_event_by_name(pevent, "ftrace", "power");
 	if (event) {
 		id = event->id + 1;
 		goto found;
@@ -58,7 +58,7 @@ int tracecmd_blk_hack(struct tracecmd_input *handle)
 	 * But the power tracer is now in perf.
 	 * Then it was after kmem_free
 	 */
-	event = pevent_find_event_by_name(pevent, "ftrace", "kmem_free");
+	event = tep_find_event_by_name(pevent, "ftrace", "kmem_free");
 	if (event) {
 		id = event->id + 1;
 		goto found;
@@ -68,7 +68,7 @@ int tracecmd_blk_hack(struct tracecmd_input *handle)
 	 * But that then went away.
 	 * Currently it should be behind the user stack.
 	 */
-	event = pevent_find_event_by_name(pevent, "ftrace", "user_stack");
+	event = tep_find_event_by_name(pevent, "ftrace", "user_stack");
 	if (event) {
 		id = event->id + 1;
 		goto found;
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 05e1200..09fd40f 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -47,7 +47,7 @@ static int find_ret_event(struct tracecmd_ftrace *finfo, struct tep_handle *peve
 	struct event_format *event;
 
 	/* Store the func ret id and event for later use */
-	event = pevent_find_event_by_name(pevent, "ftrace", "funcgraph_exit");
+	event = tep_find_event_by_name(pevent, "ftrace", "funcgraph_exit");
 	if (!event)
 		return -1;
 
@@ -72,7 +72,7 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	if (tep_get_field_val(s, event, "ip", record, &function, 1))
 		return trace_seq_putc(s, '!');
 
-	func = pevent_find_function(pevent, function);
+	func = tep_find_function(pevent, function);
 	if (func)
 		trace_seq_printf(s, "%s <-- ", func);
 	else
@@ -81,7 +81,7 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	if (tep_get_field_val(s, event, "parent_ip", record, &function, 1))
 		return trace_seq_putc(s, '!');
 
-	func = pevent_find_function(pevent, function);
+	func = tep_find_function(pevent, function);
 	if (func)
 		trace_seq_printf(s, "%s", func);
 	else
@@ -223,7 +223,7 @@ print_graph_entry_leaf(struct trace_seq *s,
 
 	if (tep_get_field_val(s, event, "func", record, &val, 1))
 		return trace_seq_putc(s, '!');
-	func = pevent_find_function(pevent, val);
+	func = tep_find_function(pevent, val);
 
 	if (func)
 		ret = trace_seq_printf(s, "%s();", func);
@@ -263,7 +263,7 @@ static int print_graph_nested(struct trace_seq *s,
 	if (tep_get_field_val(s, event, "func", record, &val, 1))
 		return trace_seq_putc(s, '!');
 
-	func = pevent_find_function(pevent, val);
+	func = tep_find_function(pevent, val);
 
 	if (func)
 		ret = trace_seq_printf(s, "%s() {", func);
@@ -349,7 +349,7 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 	if (fgraph_tail->set) {
 		if (tep_get_field_val(s, event, "func", record, &val, 0))
 			return 0;
-		func = pevent_find_function(event->pevent, val);
+		func = tep_find_function(event->pevent, val);
 		if (!func)
 			return 0;
 		trace_seq_printf(s, " /* %s */", func);
@@ -389,7 +389,7 @@ trace_stack_handler(struct trace_seq *s, struct tep_record *record,
 		    ((int)addr == -1))
 			break;
 
-		func = pevent_find_function(event->pevent, addr);
+		func = tep_find_function(event->pevent, addr);
 		if (func)
 			trace_seq_printf(s, "=> %s (%llx)\n", func, addr);
 		else
@@ -436,7 +436,7 @@ int tracecmd_ftrace_overrides(struct tracecmd_input *handle,
 	trace_util_add_options("ftrace", trace_ftrace_options);
 
 	/* Store the func ret id and event for later use */
-	event = pevent_find_event_by_name(pevent, "ftrace", "funcgraph_exit");
+	event = tep_find_event_by_name(pevent, "ftrace", "funcgraph_exit");
 	if (!event)
 		return 0;
 
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 63c3e76..5d2f738 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -489,7 +489,7 @@ find_func(struct tep_handle *pevent, unsigned long long addr)
 }
 
 /**
- * pevent_find_function - find a function by a given address
+ * tep_find_function - find a function by a given address
  * @pevent: handle for the pevent
  * @addr: the address to find the function with
  *
@@ -497,7 +497,7 @@ find_func(struct tep_handle *pevent, unsigned long long addr)
  * address. Note, the address does not have to be exact, it
  * will select the function that would contain the address.
  */
-const char *pevent_find_function(struct tep_handle *pevent, unsigned long long addr)
+const char *tep_find_function(struct tep_handle *pevent, unsigned long long addr)
 {
 	struct func_map *map;
 
@@ -509,16 +509,16 @@ const char *pevent_find_function(struct tep_handle *pevent, unsigned long long a
 }
 
 /**
- * pevent_find_function_address - find a function address by a given address
+ * tep_find_function_address - find a function address by a given address
  * @pevent: handle for the pevent
  * @addr: the address to find the function with
  *
  * Returns the address the function starts at. This can be used in
- * conjunction with pevent_find_function to print both the function
+ * conjunction with tep_find_function to print both the function
  * name and the function offset.
  */
 unsigned long long
-pevent_find_function_address(struct tep_handle *pevent, unsigned long long addr)
+tep_find_function_address(struct tep_handle *pevent, unsigned long long addr)
 {
 	struct func_map *map;
 
@@ -3484,7 +3484,7 @@ struct event_format *tep_find_event(struct tep_handle *pevent, int id)
 }
 
 /**
- * pevent_find_event_by_name - find an event by given name
+ * tep_find_event_by_name - find an event by given name
  * @pevent: a handle to the pevent
  * @sys: the system name to search for
  * @name: the name of the event to search for
@@ -3493,8 +3493,8 @@ struct event_format *tep_find_event(struct tep_handle *pevent, int id)
  * @sys. If @sys is NULL the first event with @name is returned.
  */
 struct event_format *
-pevent_find_event_by_name(struct tep_handle *pevent,
-			  const char *sys, const char *name)
+tep_find_event_by_name(struct tep_handle *pevent,
+		       const char *sys, const char *name)
 {
 	struct event_format *event;
 	int i;
@@ -5419,7 +5419,7 @@ static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
 }
 
 /**
- * pevent_find_event_by_record - return the event from a given record
+ * tep_find_event_by_record - return the event from a given record
  * @pevent: a handle to the pevent
  * @record: The record to get the event from
  *
@@ -5427,7 +5427,7 @@ static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
  * is found.
  */
 struct event_format *
-pevent_find_event_by_record(struct tep_handle *pevent, struct tep_record *record)
+tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record)
 {
 	int type;
 
@@ -5550,7 +5550,7 @@ void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
 {
 	struct event_format *event;
 
-	event = pevent_find_event_by_record(pevent, record);
+	event = tep_find_event_by_record(pevent, record);
 	if (!event) {
 		int i;
 		int type = trace_parse_common_type(pevent, record->data);
@@ -6593,7 +6593,7 @@ static struct event_format *pevent_search_event(struct tep_handle *pevent, int i
 		if (sys_name && (strcmp(sys_name, event->system) != 0))
 			return NULL;
 	} else {
-		event = pevent_find_event_by_name(pevent, sys_name, event_name);
+		event = tep_find_event_by_name(pevent, sys_name, event_name);
 		if (!event)
 			return NULL;
 	}
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index 4cc539c..a1d0e3a 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -1464,7 +1464,7 @@ static int copy_filter_type(struct event_filter *filter,
 	/* Can't assume that the pevent's are the same */
 	sys = filter_type->event->system;
 	name = filter_type->event->name;
-	event = pevent_find_event_by_name(filter->pevent, sys, name);
+	event = tep_find_event_by_name(filter->pevent, sys, name);
 	if (!event)
 		return -1;
 
@@ -1564,9 +1564,9 @@ int tep_update_trivial(struct event_filter *dest, struct event_filter *source,
 
 		if (src_pevent != dest_pevent) {
 			/* do a look up */
-			event = pevent_find_event_by_name(src_pevent,
-							  event->system,
-							  event->name);
+			event = tep_find_event_by_name(src_pevent,
+						       event->system,
+						       event->name);
 			if (!event)
 				return -1;
 		}
@@ -1895,7 +1895,7 @@ static const char *get_field_str(struct filter_arg *arg, struct tep_record *reco
 
 		if (arg->str.field->flags & (FIELD_IS_POINTER | FIELD_IS_LONG))
 			/* convert to a kernel symbol */
-			val = pevent_find_function(pevent, addr);
+			val = tep_find_function(pevent, addr);
 
 		if (val == NULL) {
 			/* just use the hex of the string name */
diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index 0e1f13a..9efa01c 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -122,7 +122,7 @@ static void show_function(struct trace_seq *s, struct tep_handle *pevent,
 
 	trace_seq_printf(s, "%s", func);
 	if (ftrace_offset->set) {
-		offset = pevent_find_function_address(pevent, function);
+		offset = tep_find_function_address(pevent, function);
 		trace_seq_printf(s, "+0x%x ", (int)(function - offset));
 	}
 }
@@ -140,12 +140,12 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	if (tep_get_field_val(s, event, "ip", record, &function, 1))
 		return trace_seq_putc(s, '!');
 
-	func = pevent_find_function(pevent, function);
+	func = tep_find_function(pevent, function);
 
 	if (tep_get_field_val(s, event, "parent_ip", record, &pfunction, 1))
 		return trace_seq_putc(s, '!');
 
-	parent = pevent_find_function(pevent, pfunction);
+	parent = tep_find_function(pevent, pfunction);
 
 	if (parent && ftrace_indent->set)
 		index = add_and_get_index(parent, func, record->cpu);
diff --git a/plugins/plugin_kmem.c b/plugins/plugin_kmem.c
index 3088d3a..79e3d3b 100644
--- a/plugins/plugin_kmem.c
+++ b/plugins/plugin_kmem.c
@@ -23,10 +23,10 @@ static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 	if (tep_read_number_field(field, data, &val))
 		return 1;
 
-	func = pevent_find_function(event->pevent, val);
+	func = tep_find_function(event->pevent, val);
 	if (!func)
 		return 1;
-	addr = pevent_find_function_address(event->pevent, val);
+	addr = tep_find_function_address(event->pevent, val);
 
 	trace_seq_printf(s, "(%s+0x%x) ", func, (int)(val - addr));
 
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index e29581e..e826679 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -107,7 +107,7 @@ static PyObject *py_field_get_stack(struct tep_handle *pevent,
 		if ((long_size == 8 && addr == (unsigned long long)-1) ||
 		    ((int)addr == -1))
 			break;
-		func = pevent_find_function(event->pevent, addr);
+		func = tep_find_function(event->pevent, addr);
 		if (PyList_Append(list, PyString_FromString(func))) {
 			Py_DECREF(list);
 			return NULL;
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index 08e0449..324b20d 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -276,8 +276,8 @@ process_function(struct tep_handle *pevent, struct tep_record *record)
 
 	pid = val;
 
-	func = pevent_find_function(pevent, ip);
-	parent = pevent_find_function(pevent, parent_ip);
+	func = tep_find_function(pevent, ip);
+	parent = tep_find_function(pevent, parent_ip);
 
 	if (current_pid >= 0 && pid != current_pid) {
 		save_stack();
@@ -334,7 +334,7 @@ process_function_graph_entry(struct tep_handle *pevent, struct tep_record *recor
 
 	pid = val;
 
-	func = pevent_find_function(pevent, ip);
+	func = tep_find_function(pevent, ip);
 
 	if (current_pid >= 0 && pid != current_pid) {
 		save_stack();
@@ -465,7 +465,7 @@ process_kernel_stack(struct tep_handle *pevent, struct tep_record *record)
 		const char *func;
 
 		addr = tep_read_number(pevent, data, long_size);
-		func = pevent_find_function(pevent, addr);
+		func = tep_find_function(pevent, addr);
 		if (func)
 			push_stack_func(func);
 	}
@@ -598,7 +598,7 @@ update_event(struct tep_handle *pevent,
 {
 	struct event_format *event;
 
-	event = pevent_find_event_by_name(pevent, sys, name);
+	event = tep_find_event_by_name(pevent, sys, name);
 	if (!event)
 		return NULL;
 
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index c4edc06..8dfa285 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -67,7 +67,7 @@ update_event(struct tep_handle *pevent,
 {
 	struct event_format *event;
 
-	event = pevent_find_event_by_name(pevent, sys, name);
+	event = tep_find_event_by_name(pevent, sys, name);
 	if (!event)
 		return NULL;
 
@@ -347,7 +347,7 @@ process_kmalloc(struct tep_handle *pevent, struct tep_record *record,
 	alloc = val;
 	tep_read_number_field(ptr_field, record->data, &ptr);
 
-	func = pevent_find_function(pevent, callsite);
+	func = tep_find_function(pevent, callsite);
 
 	add_kmalloc(func, ptr, req, alloc);
 }
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index cf0eace..6d56093 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -798,7 +798,7 @@ add_event(struct handle_data *h, const char *system, const char *event_name,
 	struct event_format *event;
 	struct event_data *event_data;
 
-	event = pevent_find_event_by_name(h->pevent, system, event_name);
+	event = tep_find_event_by_name(h->pevent, system, event_name);
 	if (!event)
 		return NULL;
 
@@ -904,8 +904,8 @@ static void func_print(struct trace_seq *s, struct event_hash *event_hash)
 {
 	const char *func;
 
-	func = pevent_find_function(event_hash->event_data->event->pevent,
-				    event_hash->val);
+	func = tep_find_function(event_hash->event_data->event->pevent,
+				 event_hash->val);
 	if (func)
 		trace_seq_printf(s, "func: %s()", func);
 	else
@@ -1555,7 +1555,7 @@ static void output_event_stack(struct tep_handle *pevent, struct stack_data *sta
 		}
 		if (val == stop)
 			break;
-		func = pevent_find_function(pevent, val);
+		func = tep_find_function(pevent, val);
 		if (func)
 			printf("       => %s (0x%llx)\n", func, val);
 		else
@@ -1777,7 +1777,7 @@ static void print_chain_func(struct tep_handle *pevent, struct stack_chain *chai
 	unsigned long long val = chain->val;
 	const char *func;
 
-	func = pevent_find_function(pevent, val);
+	func = tep_find_function(pevent, val);
 	if (func)
 		printf("%s (0x%llx)\n", func, val);
 	else
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index fd5567e..b6c4c90 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -540,7 +540,7 @@ static void init_wakeup(struct tracecmd_input *handle)
 
 	trace_hash_init(&wakeup_hash, WAKEUP_HASH_SIZE);
 
-	event = pevent_find_event_by_name(pevent, "sched", "sched_wakeup");
+	event = tep_find_event_by_name(pevent, "sched", "sched_wakeup");
 	if (!event)
 		goto fail;
 	wakeup_id = event->id;
@@ -549,7 +549,7 @@ static void init_wakeup(struct tracecmd_input *handle)
 		goto fail;
 	wakeup_success = tep_find_field(event, "success");
 
-	event = pevent_find_event_by_name(pevent, "sched", "sched_switch");
+	event = tep_find_event_by_name(pevent, "sched", "sched_switch");
 	if (!event)
 		goto fail;
 	sched_id = event->id;
@@ -564,7 +564,7 @@ static void init_wakeup(struct tracecmd_input *handle)
 
 	wakeup_new_id = -1;
 
-	event = pevent_find_event_by_name(pevent, "sched", "sched_wakeup_new");
+	event = tep_find_event_by_name(pevent, "sched", "sched_wakeup_new");
 	if (!event)
 		goto skip;
 	wakeup_new_id = event->id;
@@ -793,7 +793,7 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 		struct event_format *event;
 		unsigned long long rec_ts = record->ts;
 
-		event = pevent_find_event_by_record(pevent, record);
+		event = tep_find_event_by_record(pevent, record);
 		tep_print_event_task(pevent, &s, event, record);
 		tep_print_event_time(pevent, &s, event, record,
 					use_trace_clock);
@@ -950,8 +950,8 @@ test_stacktrace(struct handle_list *handles, struct tep_record *record,
 			memset(info->cpus, 0, sizeof(*info->cpus));
 
 			pevent = tracecmd_get_pevent(h->handle);
-			event = pevent_find_event_by_name(pevent, "ftrace",
-							  "kernel_stack");
+			event = tep_find_event_by_name(pevent, "ftrace",
+						       "kernel_stack");
 			if (event)
 				info->stacktrace_id = event->id;
 			else
@@ -1161,7 +1161,7 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 
 		/* Find the kernel_stacktrace if available */
 		pevent = tracecmd_get_pevent(handles->handle);
-		event = pevent_find_event_by_name(pevent, "ftrace", "kernel_stack");
+		event = tep_find_event_by_name(pevent, "ftrace", "kernel_stack");
 		if (event)
 			stacktrace_id = event->id;
 
-- 
2.17.1
