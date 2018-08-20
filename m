Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f49.google.com ([209.85.221.49]:40421 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbeHTRvR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 13:51:17 -0400
Received: by mail-wr1-f49.google.com with SMTP id n2-v6so2715009wrw.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Aug 2018 07:35:22 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 08/24] trace-cmd: Rename pevent_read_number_* APIs
Date: Mon, 20 Aug 2018 17:34:49 +0300
Message-Id: <20180820143505.11525-9-tz.stoyanov@gmail.com>
In-Reply-To: <20180820143505.11525-1-tz.stoyanov@gmail.com>
References: <20180820143505.11525-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_read_number, pevent_read_number_field

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h |  6 +--
 kernel-shark/trace-graph.c       | 12 +++---
 kernel-shark/trace-plot-task.c   |  2 +-
 kernel-shark/trace-view-store.c  |  6 +--
 lib/trace-cmd/trace-ftrace.c     |  2 +-
 lib/traceevent/event-parse.c     | 68 ++++++++++++++++----------------
 lib/traceevent/parse-filter.c    |  2 +-
 plugins/plugin_blk.c             | 14 +++----
 plugins/plugin_kmem.c            |  2 +-
 plugins/plugin_mac80211.c        |  6 +--
 python/ctracecmd.i               |  6 +--
 python/tracecmd.py               |  4 +-
 tracecmd/trace-hist.c            | 40 +++++++++----------
 tracecmd/trace-mem.c             | 12 +++---
 tracecmd/trace-profile.c         | 46 ++++++++++-----------
 tracecmd/trace-read.c            | 12 +++---
 16 files changed, 120 insertions(+), 120 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 11dd41b..97eb42d 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -681,9 +681,9 @@ struct format_field *tep_find_any_field(struct event_format *event, const char *
 const char *pevent_find_function(struct tep_handle *pevent, unsigned long long addr);
 unsigned long long
 pevent_find_function_address(struct tep_handle *pevent, unsigned long long addr);
-unsigned long long pevent_read_number(struct tep_handle *pevent, const void *ptr, int size);
-int pevent_read_number_field(struct format_field *field, const void *data,
-			     unsigned long long *value);
+unsigned long long tep_read_number(struct tep_handle *pevent, const void *ptr, int size);
+int tep_read_number_field(struct format_field *field, const void *data,
+			  unsigned long long *value);
 
 struct event_format *tep_find_event(struct tep_handle *pevent, int id);
 
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index 0bf0dba..04f58f1 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -1043,11 +1043,11 @@ int trace_graph_check_sched_wakeup(struct graph_info *ginfo,
 	if (id == ginfo->event_wakeup_id) {
 		/* We only want those that actually woke up the task */
 		if (ginfo->wakeup_success_field) {
-			pevent_read_number_field(ginfo->wakeup_success_field, record->data, &val);
+			tep_read_number_field(ginfo->wakeup_success_field, record->data, &val);
 			if (!val)
 				return 0;
 		}
-		pevent_read_number_field(ginfo->wakeup_pid_field, record->data, &val);
+		tep_read_number_field(ginfo->wakeup_pid_field, record->data, &val);
 		if (pid)
 			*pid = val;
 		return 1;
@@ -1056,11 +1056,11 @@ int trace_graph_check_sched_wakeup(struct graph_info *ginfo,
 	if (id == ginfo->event_wakeup_new_id) {
 		/* We only want those that actually woke up the task */
 		if (ginfo->wakeup_new_success_field) {
-			pevent_read_number_field(ginfo->wakeup_new_success_field, record->data, &val);
+			tep_read_number_field(ginfo->wakeup_new_success_field, record->data, &val);
 			if (!val)
 				return 0;
 		}
-		pevent_read_number_field(ginfo->wakeup_new_pid_field, record->data, &val);
+		tep_read_number_field(ginfo->wakeup_new_pid_field, record->data, &val);
 		if (pid)
 			*pid = val;
 		return 1;
@@ -1107,7 +1107,7 @@ int trace_graph_check_sched_switch(struct graph_info *ginfo,
 
 	id = pevent_data_type(ginfo->pevent, record);
 	if (id == ginfo->event_sched_switch_id) {
-		pevent_read_number_field(ginfo->event_pid_field, record->data, &val);
+		tep_read_number_field(ginfo->event_pid_field, record->data, &val);
 		if (comm)
 			*comm = record->data + ginfo->event_comm_field->offset;
 		if (pid)
@@ -1116,7 +1116,7 @@ int trace_graph_check_sched_switch(struct graph_info *ginfo,
 	}
 
 	if (id == ginfo->ftrace_sched_switch_id) {
-		pevent_read_number_field(ginfo->ftrace_pid_field, record->data, &val);
+		tep_read_number_field(ginfo->ftrace_pid_field, record->data, &val);
 		if (comm && ginfo->ftrace_comm_field)
 			*comm = record->data + ginfo->ftrace_comm_field->offset;
 		else
diff --git a/kernel-shark/trace-plot-task.c b/kernel-shark/trace-plot-task.c
index 11930ed..ca62457 100644
--- a/kernel-shark/trace-plot-task.c
+++ b/kernel-shark/trace-plot-task.c
@@ -58,7 +58,7 @@ static gboolean is_running(struct graph_info *ginfo, struct tep_record *record)
 	if (id != ginfo->event_sched_switch_id)
 		return FALSE;
 
-	pevent_read_number_field(ginfo->event_prev_state, record->data, &val);
+	tep_read_number_field(ginfo->event_prev_state, record->data, &val);
 	return val & ((1 << 11) - 1)? FALSE : TRUE;
 }
 
diff --git a/kernel-shark/trace-view-store.c b/kernel-shark/trace-view-store.c
index c6ddad8..61d0157 100644
--- a/kernel-shark/trace-view-store.c
+++ b/kernel-shark/trace-view-store.c
@@ -1143,7 +1143,7 @@ gint get_next_pid(TraceViewStore *store, struct tep_handle *pevent, struct tep_r
 {
 	unsigned long long val;
 
-	pevent_read_number_field(store->sched_switch_next_field, record->data, &val);
+	tep_read_number_field(store->sched_switch_next_field, record->data, &val);
 
 	return val;
 }
@@ -1152,7 +1152,7 @@ gint get_wakeup_pid(TraceViewStore *store, struct tep_handle *pevent, struct tep
 {
 	unsigned long long val;
 
-	pevent_read_number_field(store->sched_wakeup_pid_field, record->data, &val);
+	tep_read_number_field(store->sched_wakeup_pid_field, record->data, &val);
 
 	return val;
 }
@@ -1161,7 +1161,7 @@ gint get_wakeup_new_pid(TraceViewStore *store, struct tep_handle *pevent, struct
 {
 	unsigned long long val;
 
-	pevent_read_number_field(store->sched_wakeup_new_pid_field, record->data, &val);
+	tep_read_number_field(store->sched_wakeup_new_pid_field, record->data, &val);
 
 	return val;
 }
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 76f8f56..90770fc 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -383,7 +383,7 @@ trace_stack_handler(struct trace_seq *s, struct tep_record *record,
 
 	for (data += field->offset; data < record->data + record->size;
 	     data += finfo->long_size) {
-		addr = pevent_read_number(event->pevent, data, finfo->long_size);
+		addr = tep_read_number(event->pevent, data, finfo->long_size);
 
 		if ((finfo->long_size == 8 && addr == (unsigned long long)-1) ||
 		    ((int)addr == -1))
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index f59dc6e..3bcdde8 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -3315,7 +3315,7 @@ tep_find_any_field(struct event_format *event, const char *name)
 }
 
 /**
- * pevent_read_number - read a number from data
+ * tep_read_number - read a number from data
  * @pevent: handle for the pevent
  * @ptr: the raw data
  * @size: the size of the data that holds the number
@@ -3323,8 +3323,8 @@ tep_find_any_field(struct event_format *event, const char *name)
  * Returns the number (converted to host) from the
  * raw data.
  */
-unsigned long long pevent_read_number(struct tep_handle *pevent,
-				      const void *ptr, int size)
+unsigned long long tep_read_number(struct tep_handle *pevent,
+				   const void *ptr, int size)
 {
 	switch (size) {
 	case 1:
@@ -3342,7 +3342,7 @@ unsigned long long pevent_read_number(struct tep_handle *pevent,
 }
 
 /**
- * pevent_read_number_field - read a number from data
+ * tep_read_number_field - read a number from data
  * @field: a handle to the field
  * @data: the raw data to read
  * @value: the value to place the number in
@@ -3352,8 +3352,8 @@ unsigned long long pevent_read_number(struct tep_handle *pevent,
  *
  * Returns 0 on success, -1 otherwise.
  */
-int pevent_read_number_field(struct format_field *field, const void *data,
-			     unsigned long long *value)
+int tep_read_number_field(struct format_field *field, const void *data,
+			  unsigned long long *value)
 {
 	if (!field)
 		return -1;
@@ -3362,8 +3362,8 @@ int pevent_read_number_field(struct format_field *field, const void *data,
 	case 2:
 	case 4:
 	case 8:
-		*value = pevent_read_number(field->event->pevent,
-					    data + field->offset, field->size);
+		*value = tep_read_number(field->event->pevent,
+					 data + field->offset, field->size);
 		return 0;
 	default:
 		return -1;
@@ -3406,7 +3406,7 @@ static int __parse_common(struct tep_handle *pevent, void *data,
 		if (ret < 0)
 			return ret;
 	}
-	return pevent_read_number(pevent, data + *offset, *size);
+	return tep_read_number(pevent, data + *offset, *size);
 }
 
 static int trace_parse_common_type(struct tep_handle *pevent, void *data)
@@ -3545,8 +3545,8 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 			
 		}
 		/* must be a number */
-		val = pevent_read_number(pevent, data + arg->field.field->offset,
-				arg->field.field->size);
+		val = tep_read_number(pevent, data + arg->field.field->offset,
+				      arg->field.field->size);
 		break;
 	case PRINT_FLAGS:
 	case PRINT_SYMBOL:
@@ -3589,7 +3589,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 
 			switch (larg->type) {
 			case PRINT_DYNAMIC_ARRAY:
-				offset = pevent_read_number(pevent,
+				offset = tep_read_number(pevent,
 						   data + larg->dynarray.field->offset,
 						   larg->dynarray.field->size);
 				if (larg->dynarray.field->elementsize)
@@ -3618,8 +3618,8 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 			default:
 				goto default_op; /* oops, all bets off */
 			}
-			val = pevent_read_number(pevent,
-						 data + offset, field_size);
+			val = tep_read_number(pevent,
+					      data + offset, field_size);
 			if (typearg)
 				val = eval_type(val, typearg, 1);
 			break;
@@ -3719,9 +3719,9 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		}
 		break;
 	case PRINT_DYNAMIC_ARRAY_LEN:
-		offset = pevent_read_number(pevent,
-					    data + arg->dynarray.field->offset,
-					    arg->dynarray.field->size);
+		offset = tep_read_number(pevent,
+					 data + arg->dynarray.field->offset,
+					 arg->dynarray.field->size);
 		/*
 		 * The total allocated length of the dynamic array is
 		 * stored in the top half of the field, and the offset
@@ -3731,9 +3731,9 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		break;
 	case PRINT_DYNAMIC_ARRAY:
 		/* Without [], we pass the address to the dynamic data */
-		offset = pevent_read_number(pevent,
-					    data + arg->dynarray.field->offset,
-					    arg->dynarray.field->size);
+		offset = tep_read_number(pevent,
+					 data + arg->dynarray.field->offset,
+					 arg->dynarray.field->size);
 		/*
 		 * The total allocated length of the dynamic array is
 		 * stored in the top half of the field, and the offset
@@ -3978,7 +3978,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case PRINT_HEX_STR:
 		if (arg->hex.field->type == PRINT_DYNAMIC_ARRAY) {
 			unsigned long offset;
-			offset = pevent_read_number(pevent,
+			offset = tep_read_number(pevent,
 				data + arg->hex.field->dynarray.field->offset,
 				arg->hex.field->dynarray.field->size);
 			hex = data + (offset & 0xffff);
@@ -4009,9 +4009,9 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			unsigned long offset;
 			struct format_field *field =
 				arg->int_array.field->dynarray.field;
-			offset = pevent_read_number(pevent,
-						    data + field->offset,
-						    field->size);
+			offset = tep_read_number(pevent,
+						 data + field->offset,
+						 field->size);
 			num = data + (offset & 0xffff);
 		} else {
 			field = arg->int_array.field->field.field;
@@ -4239,7 +4239,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 		pevent->bprint_ip_field = ip_field;
 	}
 
-	ip = pevent_read_number(pevent, data + ip_field->offset, ip_field->size);
+	ip = tep_read_number(pevent, data + ip_field->offset, ip_field->size);
 
 	/*
 	 * The first arg is the IP pointer.
@@ -4333,7 +4333,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 				/* the pointers are always 4 bytes aligned */
 				bptr = (void *)(((unsigned long)bptr + 3) &
 						~3);
-				val = pevent_read_number(pevent, bptr, vsize);
+				val = tep_read_number(pevent, bptr, vsize);
 				bptr += vsize;
 				arg = alloc_arg();
 				if (!arg) {
@@ -4407,7 +4407,7 @@ get_bprint_format(void *data, int size __maybe_unused,
 		pevent->bprint_fmt_field = field;
 	}
 
-	addr = pevent_read_number(pevent, data + field->offset, field->size);
+	addr = tep_read_number(pevent, data + field->offset, field->size);
 
 	printk = find_printk(pevent, addr);
 	if (!printk) {
@@ -4797,7 +4797,7 @@ void tep_print_field(struct trace_seq *s, void *data,
 		offset = field->offset;
 		len = field->size;
 		if (field->flags & FIELD_IS_DYNAMIC) {
-			val = pevent_read_number(pevent, data + offset, len);
+			val = tep_read_number(pevent, data + offset, len);
 			offset = val;
 			len = offset >> 16;
 			offset &= 0xffff;
@@ -4817,8 +4817,8 @@ void tep_print_field(struct trace_seq *s, void *data,
 			field->flags &= ~FIELD_IS_STRING;
 		}
 	} else {
-		val = pevent_read_number(pevent, data + field->offset,
-					 field->size);
+		val = tep_read_number(pevent, data + field->offset,
+				      field->size);
 		if (field->flags & FIELD_IS_POINTER) {
 			trace_seq_printf(s, "0x%llx", val);
 		} else if (field->flags & FIELD_IS_SIGNED) {
@@ -6239,7 +6239,7 @@ int get_field_val(struct trace_seq *s, struct format_field *field,
 		return -1;
 	}
 
-	if (pevent_read_number_field(field, record->data, val)) {
+	if (tep_read_number_field(field, record->data, val)) {
 		if (err)
 			trace_seq_printf(s, " %s=INVALID", name);
 		return -1;
@@ -6288,7 +6288,7 @@ void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
 
 	offset = field->offset;
 	if (field->flags & FIELD_IS_DYNAMIC) {
-		offset = pevent_read_number(event->pevent,
+		offset = tep_read_number(event->pevent,
 					    data + offset, field->size);
 		*len = offset >> 16;
 		offset &= 0xffff;
@@ -6394,7 +6394,7 @@ int tep_print_num_field(struct trace_seq *s, const char *fmt,
 	if (!field)
 		goto failed;
 
-	if (pevent_read_number_field(field, record->data, &val))
+	if (tep_read_number_field(field, record->data, &val))
 		goto failed;
 
 	return trace_seq_printf(s, fmt, val);
@@ -6429,7 +6429,7 @@ int tep_print_func_field(struct trace_seq *s, const char *fmt,
 	if (!field)
 		goto failed;
 
-	if (pevent_read_number_field(field, record->data, &val))
+	if (tep_read_number_field(field, record->data, &val))
 		goto failed;
 
 	func = find_func(pevent, val);
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index 68d8d0e..bfdaec1 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -1714,7 +1714,7 @@ get_value(struct event_format *event,
 	if (field == &cpu)
 		return record->cpu;
 
-	pevent_read_number_field(field, record->data, &val);
+	tep_read_number_field(field, record->data, &val);
 
 	if (!(field->flags & FIELD_IS_SIGNED))
 		return val;
diff --git a/plugins/plugin_blk.c b/plugins/plugin_blk.c
index 81cce73..5070af2 100644
--- a/plugins/plugin_blk.c
+++ b/plugins/plugin_blk.c
@@ -291,28 +291,28 @@ static int blktrace_handler(struct trace_seq *s, struct tep_record *record,
 	field = tep_find_field(event, "action");
 	if (!field)
 		return 1;
-	if (pevent_read_number_field(field, data, &val))
+	if (tep_read_number_field(field, data, &val))
 		return 1;
 	blk_data.action = val;
 
 	field = tep_find_field(event, "bytes");
 	if (!field)
 		return 1;
-	if (pevent_read_number_field(field, data, &val))
+	if (tep_read_number_field(field, data, &val))
 		return 1;
 	blk_data.bytes = val;
 
 	field = tep_find_field(event, "device");
 	if (!field)
 		return 1;
-	if (pevent_read_number_field(field, data, &val))
+	if (tep_read_number_field(field, data, &val))
 		return 1;
 	blk_data.device = val;
 
 	field = tep_find_field(event, "pdu_len");
 	if (!field)
 		return 1;
-	if (pevent_read_number_field(field, data, &val))
+	if (tep_read_number_field(field, data, &val))
 		return 1;
 	blk_data.pdu_len = val;
 
@@ -324,20 +324,20 @@ static int blktrace_handler(struct trace_seq *s, struct tep_record *record,
 	field = tep_find_field(event, "sector");
 	if (!field)
 		return 1;
-	if (pevent_read_number_field(field, data, &blk_data.sector))
+	if (tep_read_number_field(field, data, &blk_data.sector))
 		return 1;
 
 	field = tep_find_field(event, "pid");
 	if (!field)
 		return 1;
-	if (pevent_read_number_field(field, data, &val))
+	if (tep_read_number_field(field, data, &val))
 		return 1;
 	blk_data.pid = val;
 
 	field = tep_find_field(event, "error");
 	if (!field)
 		return 1;
-	if (pevent_read_number_field(field, data, &val))
+	if (tep_read_number_field(field, data, &val))
 		return 1;
 	blk_data.error = val;
 
diff --git a/plugins/plugin_kmem.c b/plugins/plugin_kmem.c
index 5691b71..0840d6f 100644
--- a/plugins/plugin_kmem.c
+++ b/plugins/plugin_kmem.c
@@ -20,7 +20,7 @@ static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 	if (!field)
 		return 1;
 
-	if (pevent_read_number_field(field, data, &val))
+	if (tep_read_number_field(field, data, &val))
 		return 1;
 
 	func = pevent_find_function(event->pevent, val);
diff --git a/plugins/plugin_mac80211.c b/plugins/plugin_mac80211.c
index 0cb9c95..5fc3170 100644
--- a/plugins/plugin_mac80211.c
+++ b/plugins/plugin_mac80211.c
@@ -27,7 +27,7 @@ static void print_string(struct trace_seq *s, struct event_format *event,
 
 	if (!strncmp(f->type, "__data_loc", 10)) {
 		unsigned long long v;
-		if (pevent_read_number_field(f, data, &v)) {
+		if (tep_read_number_field(f, data, &v)) {
 			trace_seq_printf(s, "invalid_data_loc");
 			return;
 		}
@@ -56,7 +56,7 @@ static void _print_enum(struct trace_seq *s, struct event_format *event,
 		return;
 	}
 
-	if (pevent_read_number_field(f, data, &val)) {
+	if (tep_read_number_field(f, data, &val)) {
 		trace_seq_puts(s, "field-invalid");
 		return;
 	}
@@ -89,7 +89,7 @@ static void _print_flag(struct trace_seq *s, struct event_format *event,
 		return;
 	}
 
-	if (pevent_read_number_field(f, data, &val)) {
+	if (tep_read_number_field(f, data, &val)) {
 		trace_seq_puts(s, "field-invalid");
 		return;
 	}
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index df757af..0a3b84a 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -102,7 +102,7 @@ static PyObject *py_field_get_stack(struct tep_handle *pevent,
 
 	for (data += field->offset; data < record->data + record->size;
 	     data += long_size) {
-		addr = pevent_read_number(event->pevent, data, long_size);
+		addr = tep_read_number(event->pevent, data, long_size);
 
 		if ((long_size == 8 && addr == (unsigned long long)-1) ||
 		    ((int)addr == -1))
@@ -123,7 +123,7 @@ static PyObject *py_field_get_data(struct format_field *f, struct tep_record *r)
 		unsigned long long val;
 		int len, offset;
 
-		if (pevent_read_number_field(f, r->data, &val)) {
+		if (tep_read_number_field(f, r->data, &val)) {
 			PyErr_SetString(PyExc_TypeError,
 					"Field is not a valid number");
 			return NULL;
@@ -149,7 +149,7 @@ static PyObject *py_field_get_str(struct format_field *f, struct tep_record *r)
 		unsigned long long val;
 		int offset;
 
-		if (pevent_read_number_field(f, r->data, &val)) {
+		if (tep_read_number_field(f, r->data, &val)) {
 			PyErr_SetString(PyExc_TypeError,
 					"Field is not a valid number");
 			return NULL;
diff --git a/python/tracecmd.py b/python/tracecmd.py
index 7da113e..318887c 100644
--- a/python/tracecmd.py
+++ b/python/tracecmd.py
@@ -106,7 +106,7 @@ class Event(object, DictMixin):
         f = tep_find_any_field(self._format, name)
         if f is None:
             return None
-        ret, val = pevent_read_number_field(f, pevent_record_data_get(self._record))
+        ret, val = tep_read_number_field(f, pevent_record_data_get(self._record))
         if ret:
             return None
         return val
@@ -141,7 +141,7 @@ class Field(object):
         return py_field_get_data(self._field, self._record)
 
     def __long__(self):
-        ret, val =  pevent_read_number_field(self._field,
+        ret, val =  tep_read_number_field(self._field,
                                              pevent_record_data_get(self._record))
         if ret:
             raise FieldError("Not a number field")
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index d2adda9..87f96d8 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -262,15 +262,15 @@ process_function(struct tep_handle *pevent, struct tep_record *record)
 	int pid;
 	int ret;
 
-	ret = pevent_read_number_field(common_pid_field, record->data, &val);
+	ret = tep_read_number_field(common_pid_field, record->data, &val);
 	if (ret < 0)
 		die("no pid field for function?");
 
-	ret = pevent_read_number_field(function_ip_field, record->data, &ip);
+	ret = tep_read_number_field(function_ip_field, record->data, &ip);
 	if (ret < 0)
 		die("no ip field for function?");
 
-	ret = pevent_read_number_field(function_parent_ip_field, record->data, &parent_ip);
+	ret = tep_read_number_field(function_parent_ip_field, record->data, &parent_ip);
 	if (ret < 0)
 		die("no parent ip field for function?");
 
@@ -318,17 +318,17 @@ process_function_graph_entry(struct tep_handle *pevent, struct tep_record *recor
 	int pid;
 	int ret;
 
-	ret = pevent_read_number_field(common_pid_field, record->data, &val);
+	ret = tep_read_number_field(common_pid_field, record->data, &val);
 	if (ret < 0)
 		die("no pid field for function graph entry?");
 
-	ret = pevent_read_number_field(function_graph_entry_func_field,
-				       record->data, &ip);
+	ret = tep_read_number_field(function_graph_entry_func_field,
+				    record->data, &ip);
 	if (ret < 0)
 		die("no ip field for function graph entry?");
 
-	ret = pevent_read_number_field(function_graph_entry_depth_field,
-				       record->data, &depth);
+	ret = tep_read_number_field(function_graph_entry_depth_field,
+				    record->data, &depth);
 	if (ret < 0)
 		die("no parent ip field for function entry?");
 
@@ -362,12 +362,12 @@ process_function_graph_exit(struct tep_handle *pevent, struct tep_record *record
 	int pid;
 	int ret;
 
-	ret = pevent_read_number_field(common_pid_field, record->data, &val);
+	ret = tep_read_number_field(common_pid_field, record->data, &val);
 	if (ret < 0)
 		die("no pid field for function graph exit?");
 
-	ret = pevent_read_number_field(function_graph_exit_depth_field,
-				       record->data, &depth);
+	ret = tep_read_number_field(function_graph_exit_depth_field,
+				    record->data, &depth);
 	if (ret < 0)
 		die("no parent ip field for function?");
 
@@ -419,7 +419,7 @@ process_kernel_stack(struct tep_handle *pevent, struct tep_record *record)
 	int pid;
 	int ret;
 
-	ret = pevent_read_number_field(common_pid_field, record->data, &val);
+	ret = tep_read_number_field(common_pid_field, record->data, &val);
 	if (ret < 0)
 		die("no pid field for function?");
 	pid = val;
@@ -453,7 +453,7 @@ process_kernel_stack(struct tep_handle *pevent, struct tep_record *record)
 	     data += long_size) {
 		unsigned long long addr;
 
-		addr = pevent_read_number(pevent, data, long_size);
+		addr = tep_read_number(pevent, data, long_size);
 
 		if ((long_size == 8 && addr == (unsigned long long)-1) ||
 		    ((int)addr == -1))
@@ -464,7 +464,7 @@ process_kernel_stack(struct tep_handle *pevent, struct tep_record *record)
 		unsigned long long addr;
 		const char *func;
 
-		addr = pevent_read_number(pevent, data, long_size);
+		addr = tep_read_number(pevent, data, long_size);
 		func = pevent_find_function(pevent, addr);
 		if (func)
 			push_stack_func(func);
@@ -489,12 +489,12 @@ process_sched_wakeup(struct tep_handle *pevent, struct tep_record *record, int t
 
 	if (type == sched_wakeup_type) {
 		comm = (char *)(record->data + sched_wakeup_comm_field->offset);
-		ret = pevent_read_number_field(sched_wakeup_pid_field, record->data, &val);
+		ret = tep_read_number_field(sched_wakeup_pid_field, record->data, &val);
 		if (ret < 0)
 			die("no pid field in sched_wakeup?");
 	} else {
 		comm = (char *)(record->data + sched_wakeup_new_comm_field->offset);
-		ret = pevent_read_number_field(sched_wakeup_new_pid_field, record->data, &val);
+		ret = tep_read_number_field(sched_wakeup_new_pid_field, record->data, &val);
 		if (ret < 0)
 			die("no pid field in sched_wakeup_new?");
 	}
@@ -513,14 +513,14 @@ process_sched_switch(struct tep_handle *pevent, struct tep_record *record)
 	int ret;
 
 	comm = (char *)(record->data + sched_switch_prev_field->offset);
-	ret = pevent_read_number_field(sched_switch_prev_pid_field, record->data, &val);
+	ret = tep_read_number_field(sched_switch_prev_pid_field, record->data, &val);
 	if (ret < 0)
 		die("no prev_pid field in sched_switch?");
 	pid = val;
 	pevent_register_comm(pevent, comm, pid);
 
 	comm = (char *)(record->data + sched_switch_next_field->offset);
-	ret = pevent_read_number_field(sched_switch_next_pid_field, record->data, &val);
+	ret = tep_read_number_field(sched_switch_next_pid_field, record->data, &val);
 	if (ret < 0)
 		die("no next_pid field in sched_switch?");
 	pid = val;
@@ -544,7 +544,7 @@ process_event(struct tep_handle *pevent, struct tep_record *record, int type)
 	event = pevent_data_event_from_type(pevent, type);
 	event_name = event->name;
 
-	ret = pevent_read_number_field(common_pid_field, record->data, &val);
+	ret = tep_read_number_field(common_pid_field, record->data, &val);
 	if (ret < 0)
 		die("no pid field for function?");
 
@@ -568,7 +568,7 @@ process_record(struct tep_handle *pevent, struct tep_record *record)
 	unsigned long long val;
 	int type;
 
-	pevent_read_number_field(common_type_field, record->data, &val);
+	tep_read_number_field(common_type_field, record->data, &val);
 	type = val;
 
 	if (type == function_type)
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index d5a4df2..1833d88 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -340,12 +340,12 @@ process_kmalloc(struct tep_handle *pevent, struct tep_record *record,
 	int alloc;
 	const char *func;
 
-	pevent_read_number_field(callsite_field, record->data, &callsite);
-	pevent_read_number_field(bytes_req_field, record->data, &val);
+	tep_read_number_field(callsite_field, record->data, &callsite);
+	tep_read_number_field(bytes_req_field, record->data, &val);
 	req = val;
-	pevent_read_number_field(bytes_alloc_field, record->data, &val);
+	tep_read_number_field(bytes_alloc_field, record->data, &val);
 	alloc = val;
-	pevent_read_number_field(ptr_field, record->data, &ptr);
+	tep_read_number_field(ptr_field, record->data, &ptr);
 
 	func = pevent_find_function(pevent, callsite);
 
@@ -358,7 +358,7 @@ process_kfree(struct tep_handle *pevent, struct tep_record *record,
 {
 	unsigned long long ptr;
 
-	pevent_read_number_field(ptr_field, record->data, &ptr);
+	tep_read_number_field(ptr_field, record->data, &ptr);
 
 	remove_kmalloc(ptr);
 }
@@ -369,7 +369,7 @@ process_record(struct tep_handle *pevent, struct tep_record *record)
 	unsigned long long val;
 	int type;
 
-	pevent_read_number_field(common_type_field, record->data, &val);
+	tep_read_number_field(common_type_field, record->data, &val);
 	type = val;
 
 	if (type == kmalloc_type)
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index 2df208c..e3e49eb 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -563,8 +563,8 @@ static void account_task(struct task_data *task, struct event_data *event_data,
 	 * stack traces on this event.
 	 */
 	if (event_data->pid_field) {
-		pevent_read_number_field(event_data->pid_field,
-					 record->data, &pid);
+		tep_read_number_field(event_data->pid_field,
+				      record->data, &pid);
 		proxy = task;
 		task = find_task(task->handle, pid);
 		if (!task)
@@ -577,12 +577,12 @@ static void account_task(struct task_data *task, struct event_data *event_data,
 	 * if the start_field is defined, use that for search_val.
 	 */
 	if (event_data->data_field) {
-		pevent_read_number_field(event_data->data_field,
-					 record->data, &val);
+		tep_read_number_field(event_data->data_field,
+				      record->data, &val);
 	}
 	if (event_data->start_match_field) {
-		pevent_read_number_field(event_data->start_match_field,
-					 record->data, &search_val);
+		tep_read_number_field(event_data->start_match_field,
+				      record->data, &search_val);
 	}
 
 	edata.event_data = event_data;
@@ -612,8 +612,8 @@ find_event_task(struct handle_data *h, struct event_data *event_data,
 
 	/* If pid_field is defined, use that to find the task */
 	if (event_data->pid_field)
-		pevent_read_number_field(event_data->pid_field,
-					 record->data, &pid);
+		tep_read_number_field(event_data->pid_field,
+				      record->data, &pid);
 	return find_task(h, pid);
 }
 
@@ -629,8 +629,8 @@ handle_end_event(struct handle_data *h, struct event_data *event_data,
 	if (!task)
 		return NULL;
 
-	pevent_read_number_field(event_data->start_match_field, record->data,
-				 &val);
+	tep_read_number_field(event_data->start_match_field, record->data,
+			      &val);
 	event_hash = find_and_update_start(task, event_data->start, record->ts, val);
 	task->last_start = NULL;
 	task->last_event = event_hash;
@@ -650,7 +650,7 @@ handle_start_event(struct handle_data *h, struct event_data *event_data,
 	if (!task)
 		return NULL;
 
-	pevent_read_number_field(event_data->end_match_field, record->data,
+	tep_read_number_field(event_data->end_match_field, record->data,
 				 &val);
 	start = add_start(task, event_data, record, val, val);
 	if (!start) {
@@ -772,7 +772,7 @@ static void trace_profile_record(struct tracecmd_input *handle,
 
 
 	/* Get this current PID */
-	pevent_read_number_field(h->common_pid, record->data, &pid);
+	tep_read_number_field(h->common_pid, record->data, &pid);
 
 	task = find_task(h, pid);
 	if (!task)
@@ -998,18 +998,18 @@ static int handle_sched_switch_event(struct handle_data *h,
 	struct start_data *start;
 
 	/* pid_field holds prev_pid, data_field holds prev_state */
-	pevent_read_number_field(event_data->pid_field,
-				 record->data, &prev_pid);
+	tep_read_number_field(event_data->pid_field,
+			      record->data, &prev_pid);
 
-	pevent_read_number_field(event_data->data_field,
+	tep_read_number_field(event_data->data_field,
 				 record->data, &prev_state);
 
 	/* only care about real states */
 	prev_state &= TASK_STATE_MAX - 1;
 
 	/* end_match_field holds next_pid */
-	pevent_read_number_field(event_data->end_match_field,
-				 record->data, &next_pid);
+	tep_read_number_field(event_data->end_match_field,
+			      record->data, &next_pid);
 
 	task = find_task(h, prev_pid);
 	if (!task)
@@ -1186,8 +1186,8 @@ static int handle_process_exec(struct handle_data *h,
 
 	/* Task has execed, remove the comm for it */
 	if (event_data->data_field) {
-		pevent_read_number_field(event_data->data_field,
-					 record->data, &val);
+		tep_read_number_field(event_data->data_field,
+				      record->data, &val);
 		pid = val;
 	}
 
@@ -1217,16 +1217,16 @@ static int handle_sched_wakeup_event(struct handle_data *h,
 
 	/* If present, data_field holds "success" */
 	if (event_data->data_field) {
-		pevent_read_number_field(event_data->data_field,
-					 record->data, &success);
+		tep_read_number_field(event_data->data_field,
+				      record->data, &success);
 
 		/* If not a successful wakeup, ignore this */
 		if (!success)
 			return 0;
 	}
 
-	pevent_read_number_field(event_data->pid_field,
-				 record->data, &pid);
+	tep_read_number_field(event_data->pid_field,
+			      record->data, &pid);
 
 	task = find_task(h, pid);
 	if (!task)
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 880656f..a61f6aa 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -671,28 +671,28 @@ static void process_wakeup(struct tep_handle *pevent, struct tep_record *record)
 
 	id = pevent_data_type(pevent, record);
 	if (id == wakeup_id) {
-		if (pevent_read_number_field(wakeup_success, record->data, &val) == 0) {
+		if (tep_read_number_field(wakeup_success, record->data, &val) == 0) {
 			if (!val)
 				return;
 		}
-		if (pevent_read_number_field(wakeup_task, record->data, &val))
+		if (tep_read_number_field(wakeup_task, record->data, &val))
 			return;
 		add_wakeup(val, record->ts);
 	} else if (id == wakeup_new_id) {
-		if (pevent_read_number_field(wakeup_new_success, record->data, &val) == 0) {
+		if (tep_read_number_field(wakeup_new_success, record->data, &val) == 0) {
 			if (!val)
 				return;
 		}
-		if (pevent_read_number_field(wakeup_new_task, record->data, &val))
+		if (tep_read_number_field(wakeup_new_task, record->data, &val))
 			return;
 		add_wakeup(val, record->ts);
 	} else if (id == sched_id) {
 		int rt = 1;
-		if (pevent_read_number_field(sched_prio, record->data, &val))
+		if (tep_read_number_field(sched_prio, record->data, &val))
 			return;
 		if (val > 99)
 			rt = 0;
-		if (pevent_read_number_field(sched_task, record->data, &val))
+		if (tep_read_number_field(sched_task, record->data, &val))
 			return;
 		add_sched(val, record->ts, rt);
 	}
-- 
2.17.1
