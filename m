Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:33411 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbeHTRvO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 13:51:14 -0400
Received: by mail-wm0-f42.google.com with SMTP id i134-v6so7249387wmf.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Aug 2018 07:35:19 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 05/24] trace-cmd: Rename pevent find APIs
Date: Mon, 20 Aug 2018 17:34:46 +0300
Message-Id: <20180820143505.11525-6-tz.stoyanov@gmail.com>
In-Reply-To: <20180820143505.11525-1-tz.stoyanov@gmail.com>
References: <20180820143505.11525-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_find_any_field, pevent_find_common_field, pevent_find_event,
pevent_find_field

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h |  8 ++--
 kernel-shark/trace-capture.c     |  4 +-
 kernel-shark/trace-filter.c      |  4 +-
 kernel-shark/trace-graph.c       | 18 ++++----
 kernel-shark/trace-view-store.c  |  6 +--
 lib/trace-cmd/trace-blk-hack.c   | 10 ++---
 lib/trace-cmd/trace-ftrace.c     |  2 +-
 lib/traceevent/event-parse.c     | 76 ++++++++++++++++----------------
 lib/traceevent/parse-filter.c    |  4 +-
 plugins/plugin_blk.c             | 16 +++----
 plugins/plugin_kmem.c            |  2 +-
 plugins/plugin_mac80211.c        |  6 +--
 plugins/plugin_sched_switch.c    |  6 +--
 python/ctracecmd.i               |  2 +-
 python/tracecmd.py               |  6 +--
 tracecmd/trace-hist.c            | 40 ++++++++---------
 tracecmd/trace-mem.c             | 38 ++++++++--------
 tracecmd/trace-profile.c         | 24 +++++-----
 tracecmd/trace-read.c            | 12 ++---
 tracecmd/trace-record.c          |  2 +-
 20 files changed, 143 insertions(+), 143 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index a4a2bc9..db910b5 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -674,9 +674,9 @@ int pevent_register_print_function(struct tep_handle *pevent,
 int pevent_unregister_print_function(struct tep_handle *pevent,
 				     pevent_func_handler func, char *name);
 
-struct format_field *pevent_find_common_field(struct event_format *event, const char *name);
-struct format_field *pevent_find_field(struct event_format *event, const char *name);
-struct format_field *pevent_find_any_field(struct event_format *event, const char *name);
+struct format_field *tep_find_common_field(struct event_format *event, const char *name);
+struct format_field *tep_find_field(struct event_format *event, const char *name);
+struct format_field *tep_find_any_field(struct event_format *event, const char *name);
 
 const char *pevent_find_function(struct tep_handle *pevent, unsigned long long addr);
 unsigned long long
@@ -685,7 +685,7 @@ unsigned long long pevent_read_number(struct tep_handle *pevent, const void *ptr
 int pevent_read_number_field(struct format_field *field, const void *data,
 			     unsigned long long *value);
 
-struct event_format *pevent_find_event(struct tep_handle *pevent, int id);
+struct event_format *tep_find_event(struct tep_handle *pevent, int id);
 
 struct event_format *
 pevent_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *name);
diff --git a/kernel-shark/trace-capture.c b/kernel-shark/trace-capture.c
index d80a5c2..27cea40 100644
--- a/kernel-shark/trace-capture.c
+++ b/kernel-shark/trace-capture.c
@@ -385,7 +385,7 @@ static int add_trace_cmd_words(struct trace_capture *cap, char **args)
 
 		if (events) {
 			for (i = 0; events[i] >= 0; i++) {
-				event = pevent_find_event(cap->pevent, events[i]);
+				event = tep_find_event(cap->pevent, events[i]);
 				if (!event)
 					continue;
 				args[words++] = strdup("-e");
@@ -1012,7 +1012,7 @@ static void save_events(struct trace_capture *cap,
 
 	tracecmd_xml_start_sub_system(handle, "Events");
 	for (i = 0; events[i] > 0; i++) {
-		event = pevent_find_event(pevent, events[i]);
+		event = tep_find_event(pevent, events[i]);
 		if (event) {
 			tracecmd_xml_start_sub_system(handle, "Event");
 			tracecmd_xml_write_element(handle, "System", "%s", event->system);
diff --git a/kernel-shark/trace-filter.c b/kernel-shark/trace-filter.c
index 6202802..7216702 100644
--- a/kernel-shark/trace-filter.c
+++ b/kernel-shark/trace-filter.c
@@ -2004,7 +2004,7 @@ void trace_filter_convert_char_to_filter(struct event_filter *filter,
 
 	if (events) {
 		for (i = 0; events[i] >= 0; i++) {
-			event = pevent_find_event(filter->pevent, events[i]);
+			event = tep_find_event(filter->pevent, events[i]);
 			if (event)
 				pevent_filter_add_filter_str(filter,
 							     event->name);
@@ -2036,7 +2036,7 @@ int trace_filter_save_events(struct tracecmd_xml_handle *handle,
 		if (!str)
 			continue;
 
-		event = pevent_find_event(filter->pevent, event_ids[i]);
+		event = tep_find_event(filter->pevent, event_ids[i]);
 		if (event) {
 
 			/* skip not filtered items */
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index 2c6d00b..0bf0dba 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -1021,8 +1021,8 @@ int trace_graph_check_sched_wakeup(struct graph_info *ginfo,
 		if (event) {
 			found = TRUE;
 			ginfo->event_wakeup_id = event->id;
-			ginfo->wakeup_pid_field = pevent_find_field(event, "pid");
-			ginfo->wakeup_success_field = pevent_find_field(event, "success");
+			ginfo->wakeup_pid_field = tep_find_field(event, "pid");
+			ginfo->wakeup_success_field = tep_find_field(event, "success");
 		}
 
 
@@ -1031,8 +1031,8 @@ int trace_graph_check_sched_wakeup(struct graph_info *ginfo,
 		if (event) {
 			found = TRUE;
 			ginfo->event_wakeup_new_id = event->id;
-			ginfo->wakeup_new_pid_field = pevent_find_field(event, "pid");
-			ginfo->wakeup_new_success_field = pevent_find_field(event, "success");
+			ginfo->wakeup_new_pid_field = tep_find_field(event, "pid");
+			ginfo->wakeup_new_success_field = tep_find_field(event, "success");
 		}
 		if (!found)
 			return 0;
@@ -1092,16 +1092,16 @@ int trace_graph_check_sched_switch(struct graph_info *ginfo,
 			return 0;
 
 		ginfo->event_sched_switch_id = event->id;
-		ginfo->event_prev_state = pevent_find_field(event, "prev_state");
-		ginfo->event_pid_field = pevent_find_field(event, "next_pid");
-		ginfo->event_comm_field = pevent_find_field(event, "next_comm");
+		ginfo->event_prev_state = tep_find_field(event, "prev_state");
+		ginfo->event_pid_field = tep_find_field(event, "next_pid");
+		ginfo->event_comm_field = tep_find_field(event, "next_comm");
 
 		event = pevent_find_event_by_name(ginfo->pevent,
 						  "ftrace", "context_switch");
 		if (event) {
 			ginfo->ftrace_sched_switch_id = event->id;
-			ginfo->ftrace_pid_field = pevent_find_field(event, "next_pid");
-			ginfo->ftrace_comm_field = pevent_find_field(event, "next_comm");
+			ginfo->ftrace_pid_field = tep_find_field(event, "next_pid");
+			ginfo->ftrace_comm_field = tep_find_field(event, "next_comm");
 		}
 	}
 
diff --git a/kernel-shark/trace-view-store.c b/kernel-shark/trace-view-store.c
index 3f0bbf1..c6ddad8 100644
--- a/kernel-shark/trace-view-store.c
+++ b/kernel-shark/trace-view-store.c
@@ -1230,20 +1230,20 @@ static void update_filter_tasks(TraceViewStore *store)
 			pevent_find_event_by_name(pevent, "sched", "sched_switch");
 		if (store->sched_switch_event)
 			store->sched_switch_next_field =
-				pevent_find_any_field(store->sched_switch_event,
+				tep_find_any_field(store->sched_switch_event,
 						      "next_pid");
 		store->sched_wakeup_event =
 			pevent_find_event_by_name(pevent, "sched", "sched_wakeup");
 		if (store->sched_wakeup_event)
 			store->sched_wakeup_pid_field =
-				pevent_find_any_field(store->sched_wakeup_event,
+				tep_find_any_field(store->sched_wakeup_event,
 						      "pid");
 
 		store->sched_wakeup_new_event =
 			pevent_find_event_by_name(pevent, "sched", "sched_wakeup_new");
 		if (store->sched_wakeup_new_event)
 			store->sched_wakeup_new_pid_field =
-				pevent_find_any_field(store->sched_wakeup_new_event,
+				tep_find_any_field(store->sched_wakeup_new_event,
 						      "pid");
 	}
 
diff --git a/lib/trace-cmd/trace-blk-hack.c b/lib/trace-cmd/trace-blk-hack.c
index b964bc4..9dec648 100644
--- a/lib/trace-cmd/trace-blk-hack.c
+++ b/lib/trace-cmd/trace-blk-hack.c
@@ -111,23 +111,23 @@ int tracecmd_blk_hack(struct tracecmd_input *handle)
 	 */
 
 	/* Make sure the common fields exist */
-	field = pevent_find_common_field(event, "common_type");
+	field = tep_find_common_field(event, "common_type");
 	if (!field || field->offset != 0 || field->size != 2)
 		goto fail;
-	field = pevent_find_common_field(event, "common_flags");
+	field = tep_find_common_field(event, "common_flags");
 	if (!field || field->offset != 2 || field->size != 1)
 		goto fail;
-	field = pevent_find_common_field(event, "common_preempt_count");
+	field = tep_find_common_field(event, "common_preempt_count");
 	if (!field || field->offset != 3 || field->size != 1)
 		goto fail;
-	field = pevent_find_common_field(event, "common_pid");
+	field = tep_find_common_field(event, "common_pid");
 	if (!field || field->offset != 4 || field->size != 4)
 		goto fail;
 	r = sprintf(buf, blk_event_start, id);
 	l = r;
 
 	/* lock depth is optional */
-	field = pevent_find_common_field(event, "common_lock_depth");
+	field = tep_find_common_field(event, "common_lock_depth");
 	if (field) {
 		if (field->offset != 8 || field->size != 4)
 			return -1;
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 8c706f3..76f8f56 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -371,7 +371,7 @@ trace_stack_handler(struct trace_seq *s, struct tep_record *record,
 	const char *func;
 	void *data = record->data;
 
-	field = pevent_find_any_field(event, "caller");
+	field = tep_find_any_field(event, "caller");
 	if (!field) {
 		trace_seq_printf(s, "<CANT FIND FIELD %s>", "caller");
 		return 0;
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index f67af97..9142f28 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -2087,11 +2087,11 @@ process_entry(struct event_format *event __maybe_unused, struct print_arg *arg,
 	arg->field.name = field;
 
 	if (is_flag_field) {
-		arg->field.field = pevent_find_any_field(event, arg->field.name);
+		arg->field.field = tep_find_any_field(event, arg->field.name);
 		arg->field.field->flags |= FIELD_IS_FLAG;
 		is_flag_field = 0;
 	} else if (is_symbolic_field) {
-		arg->field.field = pevent_find_any_field(event, arg->field.name);
+		arg->field.field = tep_find_any_field(event, arg->field.name);
 		arg->field.field->flags |= FIELD_IS_SYMBOLIC;
 		is_symbolic_field = 0;
 	}
@@ -2700,7 +2700,7 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
 
 	/* Find the field */
 
-	field = pevent_find_field(event, token);
+	field = tep_find_field(event, token);
 	if (!field)
 		goto out_free;
 
@@ -2757,7 +2757,7 @@ process_dynamic_array_len(struct event_format *event, struct print_arg *arg,
 	arg->type = PRINT_DYNAMIC_ARRAY_LEN;
 
 	/* Find the field */
-	field = pevent_find_field(event, token);
+	field = tep_find_field(event, token);
 	if (!field)
 		goto out_free;
 
@@ -3251,7 +3251,7 @@ static int event_read_print(struct event_format *event)
 }
 
 /**
- * pevent_find_common_field - return a common field by event
+ * tep_find_common_field - return a common field by event
  * @event: handle for the event
  * @name: the name of the common field to return
  *
@@ -3259,7 +3259,7 @@ static int event_read_print(struct event_format *event)
  * This only searchs the common fields and not all field.
  */
 struct format_field *
-pevent_find_common_field(struct event_format *event, const char *name)
+tep_find_common_field(struct event_format *event, const char *name)
 {
 	struct format_field *format;
 
@@ -3273,7 +3273,7 @@ pevent_find_common_field(struct event_format *event, const char *name)
 }
 
 /**
- * pevent_find_field - find a non-common field
+ * tep_find_field - find a non-common field
  * @event: handle for the event
  * @name: the name of the non-common field
  *
@@ -3281,7 +3281,7 @@ pevent_find_common_field(struct event_format *event, const char *name)
  * This does not search common fields.
  */
 struct format_field *
-pevent_find_field(struct event_format *event, const char *name)
+tep_find_field(struct event_format *event, const char *name)
 {
 	struct format_field *format;
 
@@ -3295,7 +3295,7 @@ pevent_find_field(struct event_format *event, const char *name)
 }
 
 /**
- * pevent_find_any_field - find any field by name
+ * tep_find_any_field - find any field by name
  * @event: handle for the event
  * @name: the name of the field
  *
@@ -3304,14 +3304,14 @@ pevent_find_field(struct event_format *event, const char *name)
  * the non-common ones if a common one was not found.
  */
 struct format_field *
-pevent_find_any_field(struct event_format *event, const char *name)
+tep_find_any_field(struct event_format *event, const char *name)
 {
 	struct format_field *format;
 
-	format = pevent_find_common_field(event, name);
+	format = tep_find_common_field(event, name);
 	if (format)
 		return format;
-	return pevent_find_field(event, name);
+	return tep_find_field(event, name);
 }
 
 /**
@@ -3386,7 +3386,7 @@ static int get_common_info(struct tep_handle *pevent,
 	}
 
 	event = pevent->events[0];
-	field = pevent_find_common_field(event, type);
+	field = tep_find_common_field(event, type);
 	if (!field)
 		return -1;
 
@@ -3454,13 +3454,13 @@ static int parse_common_migrate_disable(struct tep_handle *pevent, void *data)
 static int events_id_cmp(const void *a, const void *b);
 
 /**
- * pevent_find_event - find an event by given id
+ * tep_find_event - find an event by given id
  * @pevent: a handle to the pevent
  * @id: the id of the event
  *
  * Returns an event that has a given @id.
  */
-struct event_format *pevent_find_event(struct tep_handle *pevent, int id)
+struct event_format *tep_find_event(struct tep_handle *pevent, int id)
 {
 	struct event_format **eventptr;
 	struct event_format key;
@@ -3539,7 +3539,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		return strtoull(arg->atom.atom, NULL, 0);
 	case PRINT_FIELD:
 		if (!arg->field.field) {
-			arg->field.field = pevent_find_any_field(event, arg->field.name);
+			arg->field.field = tep_find_any_field(event, arg->field.name);
 			if (!arg->field.field)
 				goto out_warning_field;
 			
@@ -3605,7 +3605,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 			case PRINT_FIELD:
 				if (!larg->field.field) {
 					larg->field.field =
-						pevent_find_any_field(event, larg->field.name);
+						tep_find_any_field(event, larg->field.name);
 					if (!larg->field.field) {
 						arg = larg;
 						goto out_warning_field;
@@ -3885,7 +3885,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case PRINT_FIELD:
 		field = arg->field.field;
 		if (!field) {
-			field = pevent_find_any_field(event, arg->field.name);
+			field = tep_find_any_field(event, arg->field.name);
 			if (!field) {
 				str = arg->field.name;
 				goto out_warning_field;
@@ -3986,7 +3986,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			field = arg->hex.field->field.field;
 			if (!field) {
 				str = arg->hex.field->field.name;
-				field = pevent_find_any_field(event, str);
+				field = tep_find_any_field(event, str);
 				if (!field)
 					goto out_warning_field;
 				arg->hex.field->field.field = field;
@@ -4017,7 +4017,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			field = arg->int_array.field->field.field;
 			if (!field) {
 				str = arg->int_array.field->field.name;
-				field = pevent_find_any_field(event, str);
+				field = tep_find_any_field(event, str);
 				if (!field)
 					goto out_warning_field;
 				arg->int_array.field->field.field = field;
@@ -4057,7 +4057,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		if (arg->string.offset == -1) {
 			struct format_field *f;
 
-			f = pevent_find_any_field(event, arg->string.string);
+			f = tep_find_any_field(event, arg->string.string);
 			arg->string.offset = f->offset;
 		}
 		str_offset = data2host4(pevent, data + arg->string.offset);
@@ -4075,7 +4075,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		if (arg->bitmask.offset == -1) {
 			struct format_field *f;
 
-			f = pevent_find_any_field(event, arg->bitmask.bitmask);
+			f = tep_find_any_field(event, arg->bitmask.bitmask);
 			arg->bitmask.offset = f->offset;
 		}
 		bitmask_offset = data2host4(pevent, data + arg->bitmask.offset);
@@ -4225,12 +4225,12 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 	ip_field = pevent->bprint_ip_field;
 
 	if (!field) {
-		field = pevent_find_field(event, "buf");
+		field = tep_find_field(event, "buf");
 		if (!field) {
 			do_warning_event(event, "can't find buffer field for binary printk");
 			return NULL;
 		}
-		ip_field = pevent_find_field(event, "ip");
+		ip_field = tep_find_field(event, "ip");
 		if (!ip_field) {
 			do_warning_event(event, "can't find ip field for binary printk");
 			return NULL;
@@ -4399,7 +4399,7 @@ get_bprint_format(void *data, int size __maybe_unused,
 	field = pevent->bprint_fmt_field;
 
 	if (!field) {
-		field = pevent_find_field(event, "fmt");
+		field = tep_find_field(event, "fmt");
 		if (!field) {
 			do_warning_event(event, "can't find format field for binary printk");
 			return NULL;
@@ -4443,7 +4443,7 @@ static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
 		fmt = "%.2x%.2x%.2x%.2x%.2x%.2x";
 	if (!arg->field.field) {
 		arg->field.field =
-			pevent_find_any_field(event, arg->field.name);
+			tep_find_any_field(event, arg->field.name);
 		if (!arg->field.field) {
 			do_warning_event(event, "%s: field %s not found",
 					 __func__, arg->field.name);
@@ -4593,7 +4593,7 @@ static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
 
 	if (!arg->field.field) {
 		arg->field.field =
-			pevent_find_any_field(event, arg->field.name);
+			tep_find_any_field(event, arg->field.name);
 		if (!arg->field.field) {
 			do_warning("%s: field %s not found",
 				   __func__, arg->field.name);
@@ -4639,7 +4639,7 @@ static int print_ipv6_arg(struct trace_seq *s, const char *ptr, char i,
 
 	if (!arg->field.field) {
 		arg->field.field =
-			pevent_find_any_field(event, arg->field.name);
+			tep_find_any_field(event, arg->field.name);
 		if (!arg->field.field) {
 			do_warning("%s: field %s not found",
 				   __func__, arg->field.name);
@@ -4697,7 +4697,7 @@ static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
 
 	if (!arg->field.field) {
 		arg->field.field =
-			pevent_find_any_field(event, arg->field.name);
+			tep_find_any_field(event, arg->field.name);
 		if (!arg->field.field) {
 			do_warning("%s: field %s not found",
 				   __func__, arg->field.name);
@@ -5229,7 +5229,7 @@ int pevent_data_type(struct tep_handle *pevent, struct tep_record *rec)
  */
 struct event_format *pevent_data_event_from_type(struct tep_handle *pevent, int type)
 {
-	return pevent_find_event(pevent, type);
+	return tep_find_event(pevent, type);
 }
 
 /**
@@ -5438,7 +5438,7 @@ pevent_find_event_by_record(struct tep_handle *pevent, struct tep_record *record
 
 	type = trace_parse_common_type(pevent, record->data);
 
-	return pevent_find_event(pevent, type);
+	return tep_find_event(pevent, type);
 }
 
 /**
@@ -6274,7 +6274,7 @@ void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
 	if (!event)
 		return NULL;
 
-	field = pevent_find_field(event, name);
+	field = tep_find_field(event, name);
 
 	if (!field) {
 		if (err)
@@ -6318,7 +6318,7 @@ int pevent_get_field_val(struct trace_seq *s, struct event_format *event,
 	if (!event)
 		return -1;
 
-	field = pevent_find_field(event, name);
+	field = tep_find_field(event, name);
 
 	return get_field_val(s, field, name, record, val, err);
 }
@@ -6343,7 +6343,7 @@ int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
 	if (!event)
 		return -1;
 
-	field = pevent_find_common_field(event, name);
+	field = tep_find_common_field(event, name);
 
 	return get_field_val(s, field, name, record, val, err);
 }
@@ -6368,7 +6368,7 @@ int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
 	if (!event)
 		return -1;
 
-	field = pevent_find_any_field(event, name);
+	field = tep_find_any_field(event, name);
 
 	return get_field_val(s, field, name, record, val, err);
 }
@@ -6388,7 +6388,7 @@ int pevent_print_num_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
 			   struct tep_record *record, int err)
 {
-	struct format_field *field = pevent_find_field(event, name);
+	struct format_field *field = tep_find_field(event, name);
 	unsigned long long val;
 
 	if (!field)
@@ -6420,7 +6420,7 @@ int pevent_print_func_field(struct trace_seq *s, const char *fmt,
 			    struct event_format *event, const char *name,
 			    struct tep_record *record, int err)
 {
-	struct format_field *field = pevent_find_field(event, name);
+	struct format_field *field = tep_find_field(event, name);
 	struct tep_handle *pevent = event->pevent;
 	unsigned long long val;
 	struct func_map *func;
@@ -6585,7 +6585,7 @@ static struct event_format *pevent_search_event(struct tep_handle *pevent, int i
 
 	if (id >= 0) {
 		/* search by id */
-		event = pevent_find_event(pevent, id);
+		event = tep_find_event(pevent, id);
 		if (!event)
 			return NULL;
 		if (event_name && (strcmp(event_name, event->name) != 0))
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index 5ca0803..68d8d0e 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -153,7 +153,7 @@ add_filter_type(struct event_filter *filter, int id)
 
 	filter_type = &filter->event_filters[i];
 	filter_type->event_id = id;
-	filter_type->event = pevent_find_event(filter->pevent, id);
+	filter_type->event = tep_find_event(filter->pevent, id);
 	filter_type->filter = NULL;
 
 	filter->filters++;
@@ -368,7 +368,7 @@ create_arg_item(struct event_format *event, const char *token,
 			break;
 		}
 		/* Consider this a field */
-		field = pevent_find_any_field(event, token);
+		field = tep_find_any_field(event, token);
 		if (!field) {
 			/* If token is 'COMM' or 'CPU' then it is special */
 			if (strcmp(token, COMM) == 0) {
diff --git a/plugins/plugin_blk.c b/plugins/plugin_blk.c
index 6cb6151..81cce73 100644
--- a/plugins/plugin_blk.c
+++ b/plugins/plugin_blk.c
@@ -288,53 +288,53 @@ static int blktrace_handler(struct trace_seq *s, struct tep_record *record,
 	unsigned short what;
 	int long_act = 0;
 
-	field = pevent_find_field(event, "action");
+	field = tep_find_field(event, "action");
 	if (!field)
 		return 1;
 	if (pevent_read_number_field(field, data, &val))
 		return 1;
 	blk_data.action = val;
 
-	field = pevent_find_field(event, "bytes");
+	field = tep_find_field(event, "bytes");
 	if (!field)
 		return 1;
 	if (pevent_read_number_field(field, data, &val))
 		return 1;
 	blk_data.bytes = val;
 
-	field = pevent_find_field(event, "device");
+	field = tep_find_field(event, "device");
 	if (!field)
 		return 1;
 	if (pevent_read_number_field(field, data, &val))
 		return 1;
 	blk_data.device = val;
 
-	field = pevent_find_field(event, "pdu_len");
+	field = tep_find_field(event, "pdu_len");
 	if (!field)
 		return 1;
 	if (pevent_read_number_field(field, data, &val))
 		return 1;
 	blk_data.pdu_len = val;
 
-	field = pevent_find_field(event, "data");
+	field = tep_find_field(event, "data");
 	if (!field)
 		return 1;
 	blk_data.pdu_data = data + field->offset;
 
-	field = pevent_find_field(event, "sector");
+	field = tep_find_field(event, "sector");
 	if (!field)
 		return 1;
 	if (pevent_read_number_field(field, data, &blk_data.sector))
 		return 1;
 
-	field = pevent_find_field(event, "pid");
+	field = tep_find_field(event, "pid");
 	if (!field)
 		return 1;
 	if (pevent_read_number_field(field, data, &val))
 		return 1;
 	blk_data.pid = val;
 
-	field = pevent_find_field(event, "error");
+	field = tep_find_field(event, "error");
 	if (!field)
 		return 1;
 	if (pevent_read_number_field(field, data, &val))
diff --git a/plugins/plugin_kmem.c b/plugins/plugin_kmem.c
index d4478f5..5691b71 100644
--- a/plugins/plugin_kmem.c
+++ b/plugins/plugin_kmem.c
@@ -16,7 +16,7 @@ static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 	void *data = record->data;
 	const char *func;
 
-	field = pevent_find_field(event, "call_site");
+	field = tep_find_field(event, "call_site");
 	if (!field)
 		return 1;
 
diff --git a/plugins/plugin_mac80211.c b/plugins/plugin_mac80211.c
index a830b25..ba81e29 100644
--- a/plugins/plugin_mac80211.c
+++ b/plugins/plugin_mac80211.c
@@ -13,7 +13,7 @@
 static void print_string(struct trace_seq *s, struct event_format *event,
 			 const char *name, const void *data)
 {
-	struct format_field *f = pevent_find_field(event, name);
+	struct format_field *f = tep_find_field(event, name);
 	int offset;
 	int length;
 
@@ -47,7 +47,7 @@ static void _print_enum(struct trace_seq *s, struct event_format *event,
 			const char *name, const void *data,
 			const struct value_name *names, int n_names)
 {
-	struct format_field *f = pevent_find_field(event, name);
+	struct format_field *f = tep_find_field(event, name);
 	unsigned long long val;
 	int i;
 
@@ -80,7 +80,7 @@ static void _print_flag(struct trace_seq *s, struct event_format *event,
 			const char *name, const void *data,
 			const struct value_name *names, int n_names)
 {
-	struct format_field *f = pevent_find_field(event, name);
+	struct format_field *f = tep_find_field(event, name);
 	unsigned long long val;
 	int i, j, found, first = 1;
 
diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index 26fa5c8..fa3add1 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -58,7 +58,7 @@ static int sched_wakeup_handler(struct trace_seq *s, struct tep_record *record,
 	if (pevent_get_field_val(s, event, "pid", record, &val, 1))
 		return trace_seq_putc(s, '!');
 
-	field = pevent_find_any_field(event, "comm");
+	field = tep_find_any_field(event, "comm");
 	if (field) {
 		write_and_save_comm(field, record, s, val);
 		trace_seq_putc(s, ':');
@@ -86,7 +86,7 @@ static int sched_switch_handler(struct trace_seq *s, struct tep_record *record,
 	if (pevent_get_field_val(s, event, "prev_pid", record, &val, 1))
 		return trace_seq_putc(s, '!');
 
-	field = pevent_find_any_field(event, "prev_comm");
+	field = tep_find_any_field(event, "prev_comm");
 	if (field) {
 		write_and_save_comm(field, record, s, val);
 		trace_seq_putc(s, ':');
@@ -104,7 +104,7 @@ static int sched_switch_handler(struct trace_seq *s, struct tep_record *record,
 	if (pevent_get_field_val(s, event, "next_pid", record, &val, 1))
 		return trace_seq_putc(s, '!');
 
-	field = pevent_find_any_field(event, "next_comm");
+	field = tep_find_any_field(event, "next_comm");
 	if (field) {
 		write_and_save_comm(field, record, s, val);
 		trace_seq_putc(s, ':');
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index eb6dbd6..df757af 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -91,7 +91,7 @@ static PyObject *py_field_get_stack(struct tep_handle *pevent,
 	const char *func = NULL;
 	unsigned long addr;
 
-	field = pevent_find_any_field(event, "caller");
+	field = tep_find_any_field(event, "caller");
 	if (!field) {
 		PyErr_SetString(PyExc_TypeError,
 				"Event doesn't have caller field");
diff --git a/python/tracecmd.py b/python/tracecmd.py
index 358185b..7da113e 100644
--- a/python/tracecmd.py
+++ b/python/tracecmd.py
@@ -70,7 +70,7 @@ class Event(object, DictMixin):
         free_record(self._record)
 
     def __getitem__(self, n):
-        f = pevent_find_field(self._format, n)
+        f = tep_find_field(self._format, n)
         if f is None:
             raise KeyError("no field '%s'" % n)
         return Field(self._record, f)
@@ -103,7 +103,7 @@ class Event(object, DictMixin):
         return pevent_data_type(self._pevent, self._record)
 
     def num_field(self, name):
-        f = pevent_find_any_field(self._format, name)
+        f = tep_find_any_field(self._format, name)
         if f is None:
             return None
         ret, val = pevent_read_number_field(f, pevent_record_data_get(self._record))
@@ -112,7 +112,7 @@ class Event(object, DictMixin):
         return val
 
     def str_field(self, name):
-        f = pevent_find_any_field(self._format, name)
+        f = tep_find_any_field(self._format, name)
         if f is None:
             return None
         return py_field_get_str(f, self._record)
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index b8ff77d..d2adda9 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -615,8 +615,8 @@ static void update_sched_wakeup(struct tep_handle *pevent)
 	if (!event)
 		return;
 
-	sched_wakeup_comm_field = pevent_find_field(event, "comm");
-	sched_wakeup_pid_field = pevent_find_field(event, "pid");
+	sched_wakeup_comm_field = tep_find_field(event, "comm");
+	sched_wakeup_pid_field = tep_find_field(event, "pid");
 }
 
 static void update_sched_wakeup_new(struct tep_handle *pevent)
@@ -627,8 +627,8 @@ static void update_sched_wakeup_new(struct tep_handle *pevent)
 	if (!event)
 		return;
 
-	sched_wakeup_new_comm_field = pevent_find_field(event, "comm");
-	sched_wakeup_new_pid_field = pevent_find_field(event, "pid");
+	sched_wakeup_new_comm_field = tep_find_field(event, "comm");
+	sched_wakeup_new_pid_field = tep_find_field(event, "pid");
 }
 
 static void update_sched_switch(struct tep_handle *pevent)
@@ -639,10 +639,10 @@ static void update_sched_switch(struct tep_handle *pevent)
 	if (!event)
 		return;
 
-	sched_switch_prev_field = pevent_find_field(event, "prev_comm");
-	sched_switch_next_field = pevent_find_field(event, "next_comm");
-	sched_switch_prev_pid_field = pevent_find_field(event, "prev_pid");
-	sched_switch_next_pid_field = pevent_find_field(event, "next_pid");
+	sched_switch_prev_field = tep_find_field(event, "prev_comm");
+	sched_switch_next_field = tep_find_field(event, "next_comm");
+	sched_switch_prev_pid_field = tep_find_field(event, "prev_pid");
+	sched_switch_next_pid_field = tep_find_field(event, "next_pid");
 }
 
 static void update_function(struct tep_handle *pevent)
@@ -653,8 +653,8 @@ static void update_function(struct tep_handle *pevent)
 	if (!event)
 		return;
 
-	function_ip_field = pevent_find_field(event, "ip");
-	function_parent_ip_field = pevent_find_field(event, "parent_ip");
+	function_ip_field = tep_find_field(event, "ip");
+	function_parent_ip_field = tep_find_field(event, "parent_ip");
 }
 
 static void update_function_graph_entry(struct tep_handle *pevent)
@@ -665,8 +665,8 @@ static void update_function_graph_entry(struct tep_handle *pevent)
 	if (!event)
 		return;
 
-	function_graph_entry_func_field = pevent_find_field(event, "func");
-	function_graph_entry_depth_field = pevent_find_field(event, "depth");
+	function_graph_entry_func_field = tep_find_field(event, "func");
+	function_graph_entry_depth_field = tep_find_field(event, "depth");
 }
 
 static void update_function_graph_exit(struct tep_handle *pevent)
@@ -677,11 +677,11 @@ static void update_function_graph_exit(struct tep_handle *pevent)
 	if (!event)
 		return;
 
-	function_graph_exit_func_field = pevent_find_field(event, "func");
-	function_graph_exit_depth_field = pevent_find_field(event, "depth");
-	function_graph_exit_calltime_field = pevent_find_field(event, "calltime");
-	function_graph_exit_rettime_field = pevent_find_field(event, "rettime");
-	function_graph_exit_overrun_field = pevent_find_field(event, "overrun");
+	function_graph_exit_func_field = tep_find_field(event, "func");
+	function_graph_exit_depth_field = tep_find_field(event, "depth");
+	function_graph_exit_calltime_field = tep_find_field(event, "calltime");
+	function_graph_exit_rettime_field = tep_find_field(event, "rettime");
+	function_graph_exit_overrun_field = tep_find_field(event, "overrun");
 }
 
 static void update_kernel_stack(struct tep_handle *pevent)
@@ -692,7 +692,7 @@ static void update_kernel_stack(struct tep_handle *pevent)
 	if (!event)
 		return;
 
-	kernel_stack_caller_field = pevent_find_field(event, "caller");
+	kernel_stack_caller_field = tep_find_field(event, "caller");
 }
 
 enum field { NEXT_PTR, SIB_PTR };
@@ -956,11 +956,11 @@ static void do_trace_hist(struct tracecmd_input *handle)
 
 	long_size = tracecmd_long_size(handle);
 
-	common_type_field = pevent_find_common_field(event, "common_type");
+	common_type_field = tep_find_common_field(event, "common_type");
 	if (!common_type_field)
 		die("Can't find a 'type' field?");
 
-	common_pid_field = pevent_find_common_field(event, "common_pid");
+	common_pid_field = tep_find_common_field(event, "common_pid");
 	if (!common_pid_field)
 		die("Can't find a 'pid' field?");
 
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index 42953b2..d5a4df2 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -84,10 +84,10 @@ static void update_kmalloc(struct tep_handle *pevent)
 	if (!event)
 		return;
 
-	kmalloc_callsite_field = pevent_find_field(event, "call_site");
-	kmalloc_bytes_req_field = pevent_find_field(event, "bytes_req");
-	kmalloc_bytes_alloc_field = pevent_find_field(event, "bytes_alloc");
-	kmalloc_ptr_field = pevent_find_field(event, "ptr");
+	kmalloc_callsite_field = tep_find_field(event, "call_site");
+	kmalloc_bytes_req_field = tep_find_field(event, "bytes_req");
+	kmalloc_bytes_alloc_field = tep_find_field(event, "bytes_alloc");
+	kmalloc_ptr_field = tep_find_field(event, "ptr");
 }
 
 static void update_kmalloc_node(struct tep_handle *pevent)
@@ -98,10 +98,10 @@ static void update_kmalloc_node(struct tep_handle *pevent)
 	if (!event)
 		return;
 
-	kmalloc_node_callsite_field = pevent_find_field(event, "call_site");
-	kmalloc_node_bytes_req_field = pevent_find_field(event, "bytes_req");
-	kmalloc_node_bytes_alloc_field = pevent_find_field(event, "bytes_alloc");
-	kmalloc_node_ptr_field = pevent_find_field(event, "ptr");
+	kmalloc_node_callsite_field = tep_find_field(event, "call_site");
+	kmalloc_node_bytes_req_field = tep_find_field(event, "bytes_req");
+	kmalloc_node_bytes_alloc_field = tep_find_field(event, "bytes_alloc");
+	kmalloc_node_ptr_field = tep_find_field(event, "ptr");
 }
 
 static void update_kfree(struct tep_handle *pevent)
@@ -112,7 +112,7 @@ static void update_kfree(struct tep_handle *pevent)
 	if (!event)
 		return;
 
-	kfree_ptr_field = pevent_find_field(event, "ptr");
+	kfree_ptr_field = tep_find_field(event, "ptr");
 }
 
 static void update_kmem_cache_alloc(struct tep_handle *pevent)
@@ -123,10 +123,10 @@ static void update_kmem_cache_alloc(struct tep_handle *pevent)
 	if (!event)
 		return;
 
-	kmem_cache_callsite_field = pevent_find_field(event, "call_site");
-	kmem_cache_bytes_req_field = pevent_find_field(event, "bytes_req");
-	kmem_cache_bytes_alloc_field = pevent_find_field(event, "bytes_alloc");
-	kmem_cache_ptr_field = pevent_find_field(event, "ptr");
+	kmem_cache_callsite_field = tep_find_field(event, "call_site");
+	kmem_cache_bytes_req_field = tep_find_field(event, "bytes_req");
+	kmem_cache_bytes_alloc_field = tep_find_field(event, "bytes_alloc");
+	kmem_cache_ptr_field = tep_find_field(event, "ptr");
 }
 
 static void update_kmem_cache_alloc_node(struct tep_handle *pevent)
@@ -138,10 +138,10 @@ static void update_kmem_cache_alloc_node(struct tep_handle *pevent)
 	if (!event)
 		return;
 
-	kmem_cache_node_callsite_field = pevent_find_field(event, "call_site");
-	kmem_cache_node_bytes_req_field = pevent_find_field(event, "bytes_req");
-	kmem_cache_node_bytes_alloc_field = pevent_find_field(event, "bytes_alloc");
-	kmem_cache_node_ptr_field = pevent_find_field(event, "ptr");
+	kmem_cache_node_callsite_field = tep_find_field(event, "call_site");
+	kmem_cache_node_bytes_req_field = tep_find_field(event, "bytes_req");
+	kmem_cache_node_bytes_alloc_field = tep_find_field(event, "bytes_alloc");
+	kmem_cache_node_ptr_field = tep_find_field(event, "ptr");
 }
 
 static void update_kmem_cache_free(struct tep_handle *pevent)
@@ -152,7 +152,7 @@ static void update_kmem_cache_free(struct tep_handle *pevent)
 	if (!event)
 		return;
 
-	kmem_cache_free_ptr_field = pevent_find_field(event, "ptr");
+	kmem_cache_free_ptr_field = tep_find_field(event, "ptr");
 }
 
 struct func_descr {
@@ -490,7 +490,7 @@ static void do_trace_mem(struct tracecmd_input *handle)
 	ret = pevent_data_type(pevent, record);
 	event = pevent_data_event_from_type(pevent, ret);
 
-	common_type_field = pevent_find_common_field(event, "common_type");
+	common_type_field = tep_find_common_field(event, "common_type");
 	if (!common_type_field)
 		die("Can't find a 'type' field?");
 
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index 964a65f..2df208c 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -803,7 +803,7 @@ add_event(struct handle_data *h, const char *system, const char *event_name,
 		return NULL;
 
 	if (!h->common_pid) {
-		h->common_pid = pevent_find_common_field(event, "common_pid");
+		h->common_pid = tep_find_common_field(event, "common_pid");
 		if (!h->common_pid)
 			die("No 'common_pid' found in event");
 	}
@@ -834,20 +834,20 @@ mate_events(struct handle_data *h, struct event_data *start,
 	end->start = start;
 
 	if (pid_field) {
-		start->pid_field = pevent_find_field(start->event, pid_field);
+		start->pid_field = tep_find_field(start->event, pid_field);
 		if (!start->pid_field)
 			die("Event: %s does not have field %s",
 			    start->event->name, pid_field);
 	}
 
 	/* Field to match with end */
-	start->end_match_field = pevent_find_field(start->event, end_match_field);
+	start->end_match_field = tep_find_field(start->event, end_match_field);
 	if (!start->end_match_field)
 		die("Event: %s does not have field %s",
 		    start->event->name, end_match_field);
 
 	/* Field to match with start */
-	end->start_match_field = pevent_find_field(end->event, start_match_field);
+	end->start_match_field = tep_find_field(end->event, start_match_field);
 	if (!end->start_match_field)
 		die("Event: %s does not have field %s",
 		    end->event->name, start_match_field);
@@ -1372,7 +1372,7 @@ void trace_init_profile(struct tracecmd_input *handle, struct hook_list *hook,
 	if (stacktrace_event) {
 		stacktrace_event->handle_event = handle_stacktrace_event;
 
-		stacktrace_event->data_field = pevent_find_field(stacktrace_event->event,
+		stacktrace_event->data_field = tep_find_field(stacktrace_event->event,
 							    "caller");
 		if (!stacktrace_event->data_field)
 			die("Event: %s does not have field caller",
@@ -1381,25 +1381,25 @@ void trace_init_profile(struct tracecmd_input *handle, struct hook_list *hook,
 
 	if (process_exec) {
 		process_exec->handle_event = handle_process_exec;
-		process_exec->data_field = pevent_find_field(process_exec->event,
+		process_exec->data_field = tep_find_field(process_exec->event,
 							     "old_pid");
 	}
 
 	if (sched_switch) {
 		sched_switch->handle_event = handle_sched_switch_event;
-		sched_switch->data_field = pevent_find_field(sched_switch->event,
+		sched_switch->data_field = tep_find_field(sched_switch->event,
 							     "prev_state");
 		if (!sched_switch->data_field)
 			die("Event: %s does not have field prev_state",
 			    sched_switch->event->name);
 
-		h->switch_prev_comm = pevent_find_field(sched_switch->event,
+		h->switch_prev_comm = tep_find_field(sched_switch->event,
 							"prev_comm");
 		if (!h->switch_prev_comm)
 			die("Event: %s does not have field prev_comm",
 			    sched_switch->event->name);
 
-		h->switch_next_comm = pevent_find_field(sched_switch->event,
+		h->switch_next_comm = tep_find_field(sched_switch->event,
 							"next_comm");
 		if (!h->switch_next_comm)
 			die("Event: %s does not have field next_comm",
@@ -1416,10 +1416,10 @@ void trace_init_profile(struct tracecmd_input *handle, struct hook_list *hook,
 		sched_wakeup->handle_event = handle_sched_wakeup_event;
 
 		/* The 'success' field may or may not be present */
-		sched_wakeup->data_field = pevent_find_field(sched_wakeup->event,
+		sched_wakeup->data_field = tep_find_field(sched_wakeup->event,
 							     "success");
 
-		h->wakeup_comm = pevent_find_field(sched_wakeup->event, "comm");
+		h->wakeup_comm = tep_find_field(sched_wakeup->event, "comm");
 		if (!h->wakeup_comm)
 			die("Event: %s does not have field comm",
 			    sched_wakeup->event->name);
@@ -1466,7 +1466,7 @@ void trace_init_profile(struct tracecmd_input *handle, struct hook_list *hook,
 	event_data = add_event(h, "ftrace", "function", EVENT_TYPE_FUNC);
 	if (event_data) {
 		event_data->data_field =
-			pevent_find_field(event_data->event, "ip");
+			tep_find_field(event_data->event, "ip");
 	}
 
 	/* Add any user defined hooks */
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index ac74876..9df3f91 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -544,20 +544,20 @@ static void init_wakeup(struct tracecmd_input *handle)
 	if (!event)
 		goto fail;
 	wakeup_id = event->id;
-	wakeup_task = pevent_find_field(event, "pid");
+	wakeup_task = tep_find_field(event, "pid");
 	if (!wakeup_task)
 		goto fail;
-	wakeup_success = pevent_find_field(event, "success");
+	wakeup_success = tep_find_field(event, "success");
 
 	event = pevent_find_event_by_name(pevent, "sched", "sched_switch");
 	if (!event)
 		goto fail;
 	sched_id = event->id;
-	sched_task = pevent_find_field(event, "next_pid");
+	sched_task = tep_find_field(event, "next_pid");
 	if (!sched_task)
 		goto fail;
 
-	sched_prio = pevent_find_field(event, "next_prio");
+	sched_prio = tep_find_field(event, "next_prio");
 	if (!sched_prio)
 		goto fail;
 
@@ -568,10 +568,10 @@ static void init_wakeup(struct tracecmd_input *handle)
 	if (!event)
 		goto skip;
 	wakeup_new_id = event->id;
-	wakeup_new_task = pevent_find_field(event, "pid");
+	wakeup_new_task = tep_find_field(event, "pid");
 	if (!wakeup_new_task)
 		goto fail;
-	wakeup_new_success = pevent_find_field(event, "success");
+	wakeup_new_success = tep_find_field(event, "success");
 
  skip:
 	return;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8fb923e..5e57f4a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3366,7 +3366,7 @@ find_ts_in_page(struct tep_handle *pevent, void *page, int size)
 		event = pevent_data_event_from_type(pevent, id);
 		if (event) {
 			/* Make sure this is our event */
-			field = pevent_find_field(event, "buf");
+			field = tep_find_field(event, "buf");
 			/* the trace_marker adds a '\n' */
 			if (field && strcmp(STAMP"\n", record->data + field->offset) == 0)
 				ts = record->ts;
-- 
2.17.1
