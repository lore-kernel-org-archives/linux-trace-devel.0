Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34282 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389121AbeHAO2N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 10:28:13 -0400
Received: by mail-wm0-f65.google.com with SMTP id l2-v6so13760941wme.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Aug 2018 05:42:34 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 08/24] tools/lib/traceevent, tools/perf: Rename pevent_read_number_* APIs
Date: Wed,  1 Aug 2018 15:41:40 +0300
Message-Id: <20180801124156.20894-9-tz.stoyanov@gmail.com>
In-Reply-To: <20180801124156.20894-1-tz.stoyanov@gmail.com>
References: <20180801124156.20894-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_read_number, pevent_read_number_field

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.c            | 44 +++++++++----------
 tools/lib/traceevent/event-parse.h            |  4 +-
 tools/lib/traceevent/parse-filter.c           |  2 +-
 tools/lib/traceevent/plugin_kmem.c            |  2 +-
 tools/lib/traceevent/plugin_mac80211.c        |  2 +-
 tools/perf/util/data-convert-bt.c             |  4 +-
 tools/perf/util/python.c                      |  4 +-
 .../scripting-engines/trace-event-python.c    |  2 +-
 tools/perf/util/sort.c                        |  2 +-
 tools/perf/util/trace-event-parse.c           |  6 +--
 10 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 762b953a491a..dacef9fdb512 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3329,7 +3329,7 @@ tep_find_any_field(struct event_format *event, const char *name)
 }
 
 /**
- * pevent_read_number - read a number from data
+ * tep_read_number - read a number from data
  * @pevent: handle for the pevent
  * @ptr: the raw data
  * @size: the size of the data that holds the number
@@ -3337,7 +3337,7 @@ tep_find_any_field(struct event_format *event, const char *name)
  * Returns the number (converted to host) from the
  * raw data.
  */
-unsigned long long pevent_read_number(struct tep_handle *pevent,
+unsigned long long tep_read_number(struct tep_handle *pevent,
 				      const void *ptr, int size)
 {
 	switch (size) {
@@ -3356,7 +3356,7 @@ unsigned long long pevent_read_number(struct tep_handle *pevent,
 }
 
 /**
- * pevent_read_number_field - read a number from data
+ * tep_read_number_field - read a number from data
  * @field: a handle to the field
  * @data: the raw data to read
  * @value: the value to place the number in
@@ -3366,7 +3366,7 @@ unsigned long long pevent_read_number(struct tep_handle *pevent,
  *
  * Returns 0 on success, -1 otherwise.
  */
-int pevent_read_number_field(struct format_field *field, const void *data,
+int tep_read_number_field(struct format_field *field, const void *data,
 			     unsigned long long *value)
 {
 	if (!field)
@@ -3376,7 +3376,7 @@ int pevent_read_number_field(struct format_field *field, const void *data,
 	case 2:
 	case 4:
 	case 8:
-		*value = pevent_read_number(field->event->pevent,
+		*value = tep_read_number(field->event->pevent,
 					    data + field->offset, field->size);
 		return 0;
 	default:
@@ -3420,7 +3420,7 @@ static int __parse_common(struct tep_handle *pevent, void *data,
 		if (ret < 0)
 			return ret;
 	}
-	return pevent_read_number(pevent, data + *offset, *size);
+	return tep_read_number(pevent, data + *offset, *size);
 }
 
 static int trace_parse_common_type(struct tep_handle *pevent, void *data)
@@ -3559,7 +3559,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 			
 		}
 		/* must be a number */
-		val = pevent_read_number(pevent, data + arg->field.field->offset,
+		val = tep_read_number(pevent, data + arg->field.field->offset,
 				arg->field.field->size);
 		break;
 	case PRINT_FLAGS:
@@ -3603,7 +3603,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 
 			switch (larg->type) {
 			case PRINT_DYNAMIC_ARRAY:
-				offset = pevent_read_number(pevent,
+				offset = tep_read_number(pevent,
 						   data + larg->dynarray.field->offset,
 						   larg->dynarray.field->size);
 				if (larg->dynarray.field->elementsize)
@@ -3632,7 +3632,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 			default:
 				goto default_op; /* oops, all bets off */
 			}
-			val = pevent_read_number(pevent,
+			val = tep_read_number(pevent,
 						 data + offset, field_size);
 			if (typearg)
 				val = eval_type(val, typearg, 1);
@@ -3733,7 +3733,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		}
 		break;
 	case PRINT_DYNAMIC_ARRAY_LEN:
-		offset = pevent_read_number(pevent,
+		offset = tep_read_number(pevent,
 					    data + arg->dynarray.field->offset,
 					    arg->dynarray.field->size);
 		/*
@@ -3745,7 +3745,7 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
 		break;
 	case PRINT_DYNAMIC_ARRAY:
 		/* Without [], we pass the address to the dynamic data */
-		offset = pevent_read_number(pevent,
+		offset = tep_read_number(pevent,
 					    data + arg->dynarray.field->offset,
 					    arg->dynarray.field->size);
 		/*
@@ -3992,7 +3992,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case PRINT_HEX_STR:
 		if (arg->hex.field->type == PRINT_DYNAMIC_ARRAY) {
 			unsigned long offset;
-			offset = pevent_read_number(pevent,
+			offset = tep_read_number(pevent,
 				data + arg->hex.field->dynarray.field->offset,
 				arg->hex.field->dynarray.field->size);
 			hex = data + (offset & 0xffff);
@@ -4023,7 +4023,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			unsigned long offset;
 			struct format_field *field =
 				arg->int_array.field->dynarray.field;
-			offset = pevent_read_number(pevent,
+			offset = tep_read_number(pevent,
 						    data + field->offset,
 						    field->size);
 			num = data + (offset & 0xffff);
@@ -4253,7 +4253,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 		pevent->bprint_ip_field = ip_field;
 	}
 
-	ip = pevent_read_number(pevent, data + ip_field->offset, ip_field->size);
+	ip = tep_read_number(pevent, data + ip_field->offset, ip_field->size);
 
 	/*
 	 * The first arg is the IP pointer.
@@ -4347,7 +4347,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 				/* the pointers are always 4 bytes aligned */
 				bptr = (void *)(((unsigned long)bptr + 3) &
 						~3);
-				val = pevent_read_number(pevent, bptr, vsize);
+				val = tep_read_number(pevent, bptr, vsize);
 				bptr += vsize;
 				arg = alloc_arg();
 				if (!arg) {
@@ -4421,7 +4421,7 @@ get_bprint_format(void *data, int size __maybe_unused,
 		pevent->bprint_fmt_field = field;
 	}
 
-	addr = pevent_read_number(pevent, data + field->offset, field->size);
+	addr = tep_read_number(pevent, data + field->offset, field->size);
 
 	printk = find_printk(pevent, addr);
 	if (!printk) {
@@ -4811,7 +4811,7 @@ void tep_print_field(struct trace_seq *s, void *data,
 		offset = field->offset;
 		len = field->size;
 		if (field->flags & FIELD_IS_DYNAMIC) {
-			val = pevent_read_number(pevent, data + offset, len);
+			val = tep_read_number(pevent, data + offset, len);
 			offset = val;
 			len = offset >> 16;
 			offset &= 0xffff;
@@ -4831,7 +4831,7 @@ void tep_print_field(struct trace_seq *s, void *data,
 			field->flags &= ~FIELD_IS_STRING;
 		}
 	} else {
-		val = pevent_read_number(pevent, data + field->offset,
+		val = tep_read_number(pevent, data + field->offset,
 					 field->size);
 		if (field->flags & FIELD_IS_POINTER) {
 			trace_seq_printf(s, "0x%llx", val);
@@ -6253,7 +6253,7 @@ int get_field_val(struct trace_seq *s, struct format_field *field,
 		return -1;
 	}
 
-	if (pevent_read_number_field(field, record->data, val)) {
+	if (tep_read_number_field(field, record->data, val)) {
 		if (err)
 			trace_seq_printf(s, " %s=INVALID", name);
 		return -1;
@@ -6302,7 +6302,7 @@ void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
 
 	offset = field->offset;
 	if (field->flags & FIELD_IS_DYNAMIC) {
-		offset = pevent_read_number(event->pevent,
+		offset = tep_read_number(event->pevent,
 					    data + offset, field->size);
 		*len = offset >> 16;
 		offset &= 0xffff;
@@ -6408,7 +6408,7 @@ int tep_print_num_field(struct trace_seq *s, const char *fmt,
 	if (!field)
 		goto failed;
 
-	if (pevent_read_number_field(field, record->data, &val))
+	if (tep_read_number_field(field, record->data, &val))
 		goto failed;
 
 	return trace_seq_printf(s, fmt, val);
@@ -6443,7 +6443,7 @@ int tep_print_func_field(struct trace_seq *s, const char *fmt,
 	if (!field)
 		goto failed;
 
-	if (pevent_read_number_field(field, record->data, &val))
+	if (tep_read_number_field(field, record->data, &val))
 		goto failed;
 
 	func = find_func(pevent, val);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 3a6f109095aa..9f30a266c23d 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -693,8 +693,8 @@ struct format_field *tep_find_any_field(struct event_format *event, const char *
 const char *pevent_find_function(struct tep_handle *pevent, unsigned long long addr);
 unsigned long long
 pevent_find_function_address(struct tep_handle *pevent, unsigned long long addr);
-unsigned long long pevent_read_number(struct tep_handle *pevent, const void *ptr, int size);
-int pevent_read_number_field(struct format_field *field, const void *data,
+unsigned long long tep_read_number(struct tep_handle *pevent, const void *ptr, int size);
+int tep_read_number_field(struct format_field *field, const void *data,
 			     unsigned long long *value);
 
 struct event_format *tep_find_event(struct tep_handle *pevent, int id);
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 7b6bab1ab0cd..732c9e7d8aaf 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1728,7 +1728,7 @@ get_value(struct event_format *event,
 	if (field == &cpu)
 		return record->cpu;
 
-	pevent_read_number_field(field, record->data, &val);
+	tep_read_number_field(field, record->data, &val);
 
 	if (!(field->flags & FIELD_IS_SIGNED))
 		return val;
diff --git a/tools/lib/traceevent/plugin_kmem.c b/tools/lib/traceevent/plugin_kmem.c
index a5f8641495f3..28cabe250daf 100644
--- a/tools/lib/traceevent/plugin_kmem.c
+++ b/tools/lib/traceevent/plugin_kmem.c
@@ -35,7 +35,7 @@ static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 	if (!field)
 		return 1;
 
-	if (pevent_read_number_field(field, data, &val))
+	if (tep_read_number_field(field, data, &val))
 		return 1;
 
 	func = pevent_find_function(event->pevent, val);
diff --git a/tools/lib/traceevent/plugin_mac80211.c b/tools/lib/traceevent/plugin_mac80211.c
index 611250300855..5197f940d153 100644
--- a/tools/lib/traceevent/plugin_mac80211.c
+++ b/tools/lib/traceevent/plugin_mac80211.c
@@ -42,7 +42,7 @@ static void print_string(struct trace_seq *s, struct event_format *event,
 
 	if (!strncmp(f->type, "__data_loc", 10)) {
 		unsigned long long v;
-		if (pevent_read_number_field(f, data, &v)) {
+		if (tep_read_number_field(f, data, &v)) {
 			trace_seq_printf(s, "invalid_data_loc");
 			return;
 		}
diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index 5744c12641a5..2c40b5811723 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -310,7 +310,7 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 	if (flags & FIELD_IS_DYNAMIC) {
 		unsigned long long tmp_val;
 
-		tmp_val = pevent_read_number(fmtf->event->pevent,
+		tmp_val = tep_read_number(fmtf->event->pevent,
 				data + offset, len);
 		offset = tmp_val;
 		len = offset >> 16;
@@ -353,7 +353,7 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 		else {
 			unsigned long long value_int;
 
-			value_int = pevent_read_number(
+			value_int = tep_read_number(
 					fmtf->event->pevent,
 					data + offset + i * len, len);
 
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index ff01cd53eddd..10be14e1722a 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -351,7 +351,7 @@ tracepoint_field(struct pyrf_event *pe, struct format_field *field)
 		offset = field->offset;
 		len    = field->size;
 		if (field->flags & FIELD_IS_DYNAMIC) {
-			val     = pevent_read_number(pevent, data + offset, len);
+			val     = tep_read_number(pevent, data + offset, len);
 			offset  = val;
 			len     = offset >> 16;
 			offset &= 0xffff;
@@ -364,7 +364,7 @@ tracepoint_field(struct pyrf_event *pe, struct format_field *field)
 			field->flags &= ~FIELD_IS_STRING;
 		}
 	} else {
-		val = pevent_read_number(pevent, data + field->offset,
+		val = tep_read_number(pevent, data + field->offset,
 					 field->size);
 		if (field->flags & FIELD_IS_POINTER)
 			ret = PyLong_FromUnsignedLong((unsigned long) val);
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 77bddd50e705..8aa070bf477f 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -871,7 +871,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
 			offset = field->offset;
 			len    = field->size;
 			if (field->flags & FIELD_IS_DYNAMIC) {
-				val     = pevent_read_number(scripting_context->pevent,
+				val     = tep_read_number(scripting_context->pevent,
 							     data + offset, len);
 				offset  = val;
 				len     = offset >> 16;
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index bc6ffc362b3e..b5dc1113f1c1 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -2074,7 +2074,7 @@ static int64_t __sort__hde_cmp(struct perf_hpp_fmt *fmt,
 	if (field->flags & FIELD_IS_DYNAMIC) {
 		unsigned long long dyn;
 
-		pevent_read_number_field(field, a->raw_data, &dyn);
+		tep_read_number_field(field, a->raw_data, &dyn);
 		offset = dyn & 0xffff;
 		size = (dyn >> 16) & 0xffff;
 
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index f8b91f3813ca..a0e2b2c54567 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -48,7 +48,7 @@ static int get_common_field(struct scripting_context *context,
 		*size = field->size;
 	}
 
-	return pevent_read_number(pevent, context->event_data + *offset, *size);
+	return tep_read_number(pevent, context->event_data + *offset, *size);
 }
 
 int common_lock_depth(struct scripting_context *context)
@@ -103,14 +103,14 @@ raw_field_value(struct event_format *event, const char *name, void *data)
 	if (!field)
 		return 0ULL;
 
-	pevent_read_number_field(field, data, &val);
+	tep_read_number_field(field, data, &val);
 
 	return val;
 }
 
 unsigned long long read_size(struct event_format *event, void *ptr, int size)
 {
-	return pevent_read_number(event->pevent, ptr, size);
+	return tep_read_number(event->pevent, ptr, size);
 }
 
 void event_format__fprintf(struct event_format *event,
-- 
2.17.1
