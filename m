Return-Path: <SRS0=+9rX=K6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:49802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729386AbeHOR7x (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Aug 2018 13:59:53 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Clark Williams <williams@redhat.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/35] tools lib traceevent, perf tools: Rename pevent find APIs
Date: Wed, 15 Aug 2018 12:05:42 -0300
Message-Id: <20180815150611.32080-7-acme@kernel.org>
In-Reply-To: <20180815150611.32080-1-acme@kernel.org>
References: <20180815150611.32080-1-acme@kernel.org>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_find_any_field, pevent_find_common_field,
pevent_find_event, pevent_find_field

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180808180700.316995920@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c         | 76 +++++++++++++++---------------
 tools/lib/traceevent/event-parse.h         |  8 ++--
 tools/lib/traceevent/parse-filter.c        |  4 +-
 tools/lib/traceevent/plugin_kmem.c         |  2 +-
 tools/lib/traceevent/plugin_mac80211.c     |  2 +-
 tools/lib/traceevent/plugin_sched_switch.c |  6 +--
 tools/perf/util/evsel.c                    |  2 +-
 tools/perf/util/header.c                   |  2 +-
 tools/perf/util/python.c                   |  2 +-
 tools/perf/util/sort.c                     |  4 +-
 tools/perf/util/trace-event-parse.c        |  4 +-
 tools/perf/util/trace-event.c              |  2 +-
 12 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 040180f6ed74..29f22e432084 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2101,11 +2101,11 @@ process_entry(struct event_format *event __maybe_unused, struct print_arg *arg,
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
@@ -2714,7 +2714,7 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
 
 	/* Find the field */
 
-	field = pevent_find_field(event, token);
+	field = tep_find_field(event, token);
 	if (!field)
 		goto out_free;
 
@@ -2771,7 +2771,7 @@ process_dynamic_array_len(struct event_format *event, struct print_arg *arg,
 	arg->type = PRINT_DYNAMIC_ARRAY_LEN;
 
 	/* Find the field */
-	field = pevent_find_field(event, token);
+	field = tep_find_field(event, token);
 	if (!field)
 		goto out_free;
 
@@ -3265,7 +3265,7 @@ static int event_read_print(struct event_format *event)
 }
 
 /**
- * pevent_find_common_field - return a common field by event
+ * tep_find_common_field - return a common field by event
  * @event: handle for the event
  * @name: the name of the common field to return
  *
@@ -3273,7 +3273,7 @@ static int event_read_print(struct event_format *event)
  * This only searchs the common fields and not all field.
  */
 struct format_field *
-pevent_find_common_field(struct event_format *event, const char *name)
+tep_find_common_field(struct event_format *event, const char *name)
 {
 	struct format_field *format;
 
@@ -3287,7 +3287,7 @@ pevent_find_common_field(struct event_format *event, const char *name)
 }
 
 /**
- * pevent_find_field - find a non-common field
+ * tep_find_field - find a non-common field
  * @event: handle for the event
  * @name: the name of the non-common field
  *
@@ -3295,7 +3295,7 @@ pevent_find_common_field(struct event_format *event, const char *name)
  * This does not search common fields.
  */
 struct format_field *
-pevent_find_field(struct event_format *event, const char *name)
+tep_find_field(struct event_format *event, const char *name)
 {
 	struct format_field *format;
 
@@ -3309,7 +3309,7 @@ pevent_find_field(struct event_format *event, const char *name)
 }
 
 /**
- * pevent_find_any_field - find any field by name
+ * tep_find_any_field - find any field by name
  * @event: handle for the event
  * @name: the name of the field
  *
@@ -3318,14 +3318,14 @@ pevent_find_field(struct event_format *event, const char *name)
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
@@ -3400,7 +3400,7 @@ static int get_common_info(struct tep_handle *pevent,
 	}
 
 	event = pevent->events[0];
-	field = pevent_find_common_field(event, type);
+	field = tep_find_common_field(event, type);
 	if (!field)
 		return -1;
 
@@ -3468,13 +3468,13 @@ static int parse_common_migrate_disable(struct tep_handle *pevent, void *data)
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
@@ -3553,7 +3553,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		return strtoull(arg->atom.atom, NULL, 0);
 	case PRINT_FIELD:
 		if (!arg->field.field) {
-			arg->field.field = pevent_find_any_field(event, arg->field.name);
+			arg->field.field = tep_find_any_field(event, arg->field.name);
 			if (!arg->field.field)
 				goto out_warning_field;
 			
@@ -3619,7 +3619,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 			case PRINT_FIELD:
 				if (!larg->field.field) {
 					larg->field.field =
-						pevent_find_any_field(event, larg->field.name);
+						tep_find_any_field(event, larg->field.name);
 					if (!larg->field.field) {
 						arg = larg;
 						goto out_warning_field;
@@ -3899,7 +3899,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case PRINT_FIELD:
 		field = arg->field.field;
 		if (!field) {
-			field = pevent_find_any_field(event, arg->field.name);
+			field = tep_find_any_field(event, arg->field.name);
 			if (!field) {
 				str = arg->field.name;
 				goto out_warning_field;
@@ -4000,7 +4000,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			field = arg->hex.field->field.field;
 			if (!field) {
 				str = arg->hex.field->field.name;
-				field = pevent_find_any_field(event, str);
+				field = tep_find_any_field(event, str);
 				if (!field)
 					goto out_warning_field;
 				arg->hex.field->field.field = field;
@@ -4031,7 +4031,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			field = arg->int_array.field->field.field;
 			if (!field) {
 				str = arg->int_array.field->field.name;
-				field = pevent_find_any_field(event, str);
+				field = tep_find_any_field(event, str);
 				if (!field)
 					goto out_warning_field;
 				arg->int_array.field->field.field = field;
@@ -4071,7 +4071,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		if (arg->string.offset == -1) {
 			struct format_field *f;
 
-			f = pevent_find_any_field(event, arg->string.string);
+			f = tep_find_any_field(event, arg->string.string);
 			arg->string.offset = f->offset;
 		}
 		str_offset = data2host4(pevent, data + arg->string.offset);
@@ -4089,7 +4089,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		if (arg->bitmask.offset == -1) {
 			struct format_field *f;
 
-			f = pevent_find_any_field(event, arg->bitmask.bitmask);
+			f = tep_find_any_field(event, arg->bitmask.bitmask);
 			arg->bitmask.offset = f->offset;
 		}
 		bitmask_offset = data2host4(pevent, data + arg->bitmask.offset);
@@ -4239,12 +4239,12 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
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
@@ -4413,7 +4413,7 @@ get_bprint_format(void *data, int size __maybe_unused,
 	field = pevent->bprint_fmt_field;
 
 	if (!field) {
-		field = pevent_find_field(event, "fmt");
+		field = tep_find_field(event, "fmt");
 		if (!field) {
 			do_warning_event(event, "can't find format field for binary printk");
 			return NULL;
@@ -4457,7 +4457,7 @@ static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
 		fmt = "%.2x%.2x%.2x%.2x%.2x%.2x";
 	if (!arg->field.field) {
 		arg->field.field =
-			pevent_find_any_field(event, arg->field.name);
+			tep_find_any_field(event, arg->field.name);
 		if (!arg->field.field) {
 			do_warning_event(event, "%s: field %s not found",
 					 __func__, arg->field.name);
@@ -4607,7 +4607,7 @@ static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
 
 	if (!arg->field.field) {
 		arg->field.field =
-			pevent_find_any_field(event, arg->field.name);
+			tep_find_any_field(event, arg->field.name);
 		if (!arg->field.field) {
 			do_warning("%s: field %s not found",
 				   __func__, arg->field.name);
@@ -4653,7 +4653,7 @@ static int print_ipv6_arg(struct trace_seq *s, const char *ptr, char i,
 
 	if (!arg->field.field) {
 		arg->field.field =
-			pevent_find_any_field(event, arg->field.name);
+			tep_find_any_field(event, arg->field.name);
 		if (!arg->field.field) {
 			do_warning("%s: field %s not found",
 				   __func__, arg->field.name);
@@ -4711,7 +4711,7 @@ static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
 
 	if (!arg->field.field) {
 		arg->field.field =
-			pevent_find_any_field(event, arg->field.name);
+			tep_find_any_field(event, arg->field.name);
 		if (!arg->field.field) {
 			do_warning("%s: field %s not found",
 				   __func__, arg->field.name);
@@ -5243,7 +5243,7 @@ int pevent_data_type(struct tep_handle *pevent, struct tep_record *rec)
  */
 struct event_format *pevent_data_event_from_type(struct tep_handle *pevent, int type)
 {
-	return pevent_find_event(pevent, type);
+	return tep_find_event(pevent, type);
 }
 
 /**
@@ -5452,7 +5452,7 @@ pevent_find_event_by_record(struct tep_handle *pevent, struct tep_record *record
 
 	type = trace_parse_common_type(pevent, record->data);
 
-	return pevent_find_event(pevent, type);
+	return tep_find_event(pevent, type);
 }
 
 /**
@@ -6288,7 +6288,7 @@ void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
 	if (!event)
 		return NULL;
 
-	field = pevent_find_field(event, name);
+	field = tep_find_field(event, name);
 
 	if (!field) {
 		if (err)
@@ -6332,7 +6332,7 @@ int pevent_get_field_val(struct trace_seq *s, struct event_format *event,
 	if (!event)
 		return -1;
 
-	field = pevent_find_field(event, name);
+	field = tep_find_field(event, name);
 
 	return get_field_val(s, field, name, record, val, err);
 }
@@ -6357,7 +6357,7 @@ int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
 	if (!event)
 		return -1;
 
-	field = pevent_find_common_field(event, name);
+	field = tep_find_common_field(event, name);
 
 	return get_field_val(s, field, name, record, val, err);
 }
@@ -6382,7 +6382,7 @@ int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
 	if (!event)
 		return -1;
 
-	field = pevent_find_any_field(event, name);
+	field = tep_find_any_field(event, name);
 
 	return get_field_val(s, field, name, record, val, err);
 }
@@ -6402,7 +6402,7 @@ int pevent_print_num_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
 			   struct tep_record *record, int err)
 {
-	struct format_field *field = pevent_find_field(event, name);
+	struct format_field *field = tep_find_field(event, name);
 	unsigned long long val;
 
 	if (!field)
@@ -6434,7 +6434,7 @@ int pevent_print_func_field(struct trace_seq *s, const char *fmt,
 			    struct event_format *event, const char *name,
 			    struct tep_record *record, int err)
 {
-	struct format_field *field = pevent_find_field(event, name);
+	struct format_field *field = tep_find_field(event, name);
 	struct tep_handle *pevent = event->pevent;
 	unsigned long long val;
 	struct func_map *func;
@@ -6599,7 +6599,7 @@ static struct event_format *pevent_search_event(struct tep_handle *pevent, int i
 
 	if (id >= 0) {
 		/* search by id */
-		event = pevent_find_event(pevent, id);
+		event = tep_find_event(pevent, id);
 		if (!event)
 			return NULL;
 		if (event_name && (strcmp(event_name, event->name) != 0))
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index c229240666b7..83c78290061e 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -686,9 +686,9 @@ int pevent_register_print_function(struct tep_handle *pevent,
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
@@ -697,7 +697,7 @@ unsigned long long pevent_read_number(struct tep_handle *pevent, const void *ptr
 int pevent_read_number_field(struct format_field *field, const void *data,
 			     unsigned long long *value);
 
-struct event_format *pevent_find_event(struct tep_handle *pevent, int id);
+struct event_format *tep_find_event(struct tep_handle *pevent, int id);
 
 struct event_format *
 pevent_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *name);
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 784ccac90999..7b6bab1ab0cd 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -167,7 +167,7 @@ add_filter_type(struct event_filter *filter, int id)
 
 	filter_type = &filter->event_filters[i];
 	filter_type->event_id = id;
-	filter_type->event = pevent_find_event(filter->pevent, id);
+	filter_type->event = tep_find_event(filter->pevent, id);
 	filter_type->filter = NULL;
 
 	filter->filters++;
@@ -382,7 +382,7 @@ create_arg_item(struct event_format *event, const char *token,
 			break;
 		}
 		/* Consider this a field */
-		field = pevent_find_any_field(event, token);
+		field = tep_find_any_field(event, token);
 		if (!field) {
 			/* If token is 'COMM' or 'CPU' then it is special */
 			if (strcmp(token, COMM) == 0) {
diff --git a/tools/lib/traceevent/plugin_kmem.c b/tools/lib/traceevent/plugin_kmem.c
index 0a56562d0645..a5f8641495f3 100644
--- a/tools/lib/traceevent/plugin_kmem.c
+++ b/tools/lib/traceevent/plugin_kmem.c
@@ -31,7 +31,7 @@ static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 	void *data = record->data;
 	const char *func;
 
-	field = pevent_find_field(event, "call_site");
+	field = tep_find_field(event, "call_site");
 	if (!field)
 		return 1;
 
diff --git a/tools/lib/traceevent/plugin_mac80211.c b/tools/lib/traceevent/plugin_mac80211.c
index 61eea3543cf1..dd5c7fc0193f 100644
--- a/tools/lib/traceevent/plugin_mac80211.c
+++ b/tools/lib/traceevent/plugin_mac80211.c
@@ -28,7 +28,7 @@
 static void print_string(struct trace_seq *s, struct event_format *event,
 			 const char *name, const void *data)
 {
-	struct format_field *f = pevent_find_field(event, name);
+	struct format_field *f = tep_find_field(event, name);
 	int offset;
 	int length;
 
diff --git a/tools/lib/traceevent/plugin_sched_switch.c b/tools/lib/traceevent/plugin_sched_switch.c
index 24dc2bca8e67..90d2ef293cf9 100644
--- a/tools/lib/traceevent/plugin_sched_switch.c
+++ b/tools/lib/traceevent/plugin_sched_switch.c
@@ -74,7 +74,7 @@ static int sched_wakeup_handler(struct trace_seq *s,
 	if (pevent_get_field_val(s, event, "pid", record, &val, 1))
 		return trace_seq_putc(s, '!');
 
-	field = pevent_find_any_field(event, "comm");
+	field = tep_find_any_field(event, "comm");
 	if (field) {
 		write_and_save_comm(field, record, s, val);
 		trace_seq_putc(s, ':');
@@ -103,7 +103,7 @@ static int sched_switch_handler(struct trace_seq *s,
 	if (pevent_get_field_val(s, event, "prev_pid", record, &val, 1))
 		return trace_seq_putc(s, '!');
 
-	field = pevent_find_any_field(event, "prev_comm");
+	field = tep_find_any_field(event, "prev_comm");
 	if (field) {
 		write_and_save_comm(field, record, s, val);
 		trace_seq_putc(s, ':');
@@ -121,7 +121,7 @@ static int sched_switch_handler(struct trace_seq *s,
 	if (pevent_get_field_val(s, event, "next_pid", record, &val, 1))
 		return trace_seq_putc(s, '!');
 
-	field = pevent_find_any_field(event, "next_comm");
+	field = tep_find_any_field(event, "next_comm");
 	if (field) {
 		write_and_save_comm(field, record, s, val);
 		trace_seq_putc(s, ':');
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ddf84b941abf..c980bbff6353 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2683,7 +2683,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 
 struct format_field *perf_evsel__field(struct perf_evsel *evsel, const char *name)
 {
-	return pevent_find_field(evsel->tp_format, name);
+	return tep_find_field(evsel->tp_format, name);
 }
 
 void *perf_evsel__rawptr(struct perf_evsel *evsel, struct perf_sample *sample,
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index c669896de98a..3cadc252dd89 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -3218,7 +3218,7 @@ static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
 		return -1;
 	}
 
-	event = pevent_find_event(pevent, evsel->attr.config);
+	event = tep_find_event(pevent, evsel->attr.config);
 	if (event == NULL) {
 		pr_debug("cannot find event format for %d\n", (int)evsel->attr.config);
 		return -1;
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index fd72cce6599c..ff01cd53eddd 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -394,7 +394,7 @@ get_tracepoint_field(struct pyrf_event *pevent, PyObject *attr_name)
 		evsel->tp_format = tp_format;
 	}
 
-	field = pevent_find_any_field(evsel->tp_format, str);
+	field = tep_find_any_field(evsel->tp_format, str);
 	if (!field)
 		return NULL;
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 08cdaf2be1af..f27087d06f52 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -2311,7 +2311,7 @@ static int add_all_matching_fields(struct perf_evlist *evlist,
 		if (evsel->attr.type != PERF_TYPE_TRACEPOINT)
 			continue;
 
-		field = pevent_find_any_field(evsel->tp_format, field_name);
+		field = tep_find_any_field(evsel->tp_format, field_name);
 		if (field == NULL)
 			continue;
 
@@ -2378,7 +2378,7 @@ static int add_dynamic_entry(struct perf_evlist *evlist, const char *tok,
 	if (!strcmp(field_name, "*")) {
 		ret = add_evsel_fields(evsel, raw_trace, level);
 	} else {
-		field = pevent_find_any_field(evsel->tp_format, field_name);
+		field = tep_find_any_field(evsel->tp_format, field_name);
 		if (field == NULL) {
 			pr_debug("Cannot find event field for %s.%s\n",
 				 event_name, field_name);
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 630d0e81fe87..0a769a340fc9 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -41,7 +41,7 @@ static int get_common_field(struct scripting_context *context,
 			return 0;
 
 		event = pevent->events[0];
-		field = pevent_find_common_field(event, type);
+		field = tep_find_common_field(event, type);
 		if (!field)
 			return 0;
 		*offset = field->offset;
@@ -99,7 +99,7 @@ raw_field_value(struct event_format *event, const char *name, void *data)
 	struct format_field *field;
 	unsigned long long val;
 
-	field = pevent_find_any_field(event, name);
+	field = tep_find_any_field(event, name);
 	if (!field)
 		return 0ULL;
 
diff --git a/tools/perf/util/trace-event.c b/tools/perf/util/trace-event.c
index 11066ed43ca4..116fffa788b9 100644
--- a/tools/perf/util/trace-event.c
+++ b/tools/perf/util/trace-event.c
@@ -116,5 +116,5 @@ struct event_format *trace_event__tp_format_id(int id)
 	if (!tevent_initialized && trace_event__init2())
 		return ERR_PTR(-ENOMEM);
 
-	return pevent_find_event(tevent.pevent, id);
+	return tep_find_event(tevent.pevent, id);
 }
-- 
2.14.4
