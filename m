Return-Path: <SRS0=cF1r=MB=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731442AbeITAgk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Sep 2018 20:36:40 -0400
Message-Id: <20180919185722.803127871@goodmis.org>
Date: Wed, 19 Sep 2018 14:56:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH 03/15] tools/lib/traceevent, tools/perf: Rename enum format_flags to enum
 tep_format_flags
References: <20180919185643.358126338@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This renames enum format_flags
to enum tep_format_flags and adds prefix TEP_ to all of its members.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c            | 48 +++++++++----------
 tools/lib/traceevent/event-parse.h            | 18 +++----
 tools/lib/traceevent/parse-filter.c           |  8 ++--
 tools/perf/builtin-trace.c                    |  2 +-
 tools/perf/tests/evsel-tp-sched.c             |  2 +-
 tools/perf/util/data-convert-bt.c             | 34 ++++++-------
 tools/perf/util/evsel.c                       |  2 +-
 tools/perf/util/python.c                      | 12 ++---
 .../util/scripting-engines/trace-event-perl.c | 18 +++----
 .../scripting-engines/trace-event-python.c    | 26 +++++-----
 tools/perf/util/sort.c                        |  4 +-
 11 files changed, 87 insertions(+), 87 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 32547abb6500..508c89365c90 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1301,7 +1301,7 @@ static int event_read_id(void)
 
 static int field_is_string(struct tep_format_field *field)
 {
-	if ((field->flags & FIELD_IS_ARRAY) &&
+	if ((field->flags & TEP_FIELD_IS_ARRAY) &&
 	    (strstr(field->type, "char") || strstr(field->type, "u8") ||
 	     strstr(field->type, "s8")))
 		return 1;
@@ -1328,7 +1328,7 @@ static int field_is_long(struct tep_format_field *field)
 
 static unsigned int type_size(const char *name)
 {
-	/* This covers all FIELD_IS_STRING types. */
+	/* This covers all TEP_FIELD_IS_STRING types. */
 	static struct {
 		const char *type;
 		unsigned int size;
@@ -1416,7 +1416,7 @@ static int event_read_fields(struct tep_event_format *event, struct tep_format_f
 			     type == EVENT_OP && strcmp(token, ".") == 0)) {
 
 				if (strcmp(token, "*") == 0)
-					field->flags |= FIELD_IS_POINTER;
+					field->flags |= TEP_FIELD_IS_POINTER;
 
 				if (field->type) {
 					char *new_type;
@@ -1455,7 +1455,7 @@ static int event_read_fields(struct tep_event_format *event, struct tep_format_f
 			char *new_brackets;
 			int len;
 
-			field->flags |= FIELD_IS_ARRAY;
+			field->flags |= TEP_FIELD_IS_ARRAY;
 
 			type = read_token(&token);
 
@@ -1544,11 +1544,11 @@ static int event_read_fields(struct tep_event_format *event, struct tep_format_f
 		}
 
 		if (field_is_string(field))
-			field->flags |= FIELD_IS_STRING;
+			field->flags |= TEP_FIELD_IS_STRING;
 		if (field_is_dynamic(field))
-			field->flags |= FIELD_IS_DYNAMIC;
+			field->flags |= TEP_FIELD_IS_DYNAMIC;
 		if (field_is_long(field))
-			field->flags |= FIELD_IS_LONG;
+			field->flags |= TEP_FIELD_IS_LONG;
 
 		if (test_type_token(type, token,  EVENT_OP, ";"))
 			goto fail;
@@ -1597,7 +1597,7 @@ static int event_read_fields(struct tep_event_format *event, struct tep_format_f
 				goto fail;
 
 			if (strtoul(token, NULL, 0))
-				field->flags |= FIELD_IS_SIGNED;
+				field->flags |= TEP_FIELD_IS_SIGNED;
 
 			free_token(token);
 			if (read_expected(EVENT_OP, ";") < 0)
@@ -1609,14 +1609,14 @@ static int event_read_fields(struct tep_event_format *event, struct tep_format_f
 
 		free_token(token);
 
-		if (field->flags & FIELD_IS_ARRAY) {
+		if (field->flags & TEP_FIELD_IS_ARRAY) {
 			if (field->arraylen)
 				field->elementsize = field->size / field->arraylen;
-			else if (field->flags & FIELD_IS_DYNAMIC)
+			else if (field->flags & TEP_FIELD_IS_DYNAMIC)
 				field->elementsize = size_dynamic;
-			else if (field->flags & FIELD_IS_STRING)
+			else if (field->flags & TEP_FIELD_IS_STRING)
 				field->elementsize = 1;
-			else if (field->flags & FIELD_IS_LONG)
+			else if (field->flags & TEP_FIELD_IS_LONG)
 				field->elementsize = event->pevent ?
 						     event->pevent->long_size :
 						     sizeof(long);
@@ -2089,11 +2089,11 @@ process_entry(struct tep_event_format *event __maybe_unused, struct print_arg *a
 
 	if (is_flag_field) {
 		arg->field.field = tep_find_any_field(event, arg->field.name);
-		arg->field.field->flags |= FIELD_IS_FLAG;
+		arg->field.field->flags |= TEP_FIELD_IS_FLAG;
 		is_flag_field = 0;
 	} else if (is_symbolic_field) {
 		arg->field.field = tep_find_any_field(event, arg->field.name);
-		arg->field.field->flags |= FIELD_IS_SYMBOLIC;
+		arg->field.field->flags |= TEP_FIELD_IS_SYMBOLIC;
 		is_symbolic_field = 0;
 	}
 
@@ -3901,7 +3901,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		 * and the size is the same as long_size, assume that it
 		 * is a pointer.
 		 */
-		if (!(field->flags & FIELD_IS_ARRAY) &&
+		if (!(field->flags & TEP_FIELD_IS_ARRAY) &&
 		    field->size == pevent->long_size) {
 
 			/* Handle heterogeneous recording and processing
@@ -4794,16 +4794,16 @@ void tep_print_field(struct trace_seq *s, void *data,
 	unsigned int offset, len, i;
 	struct tep_handle *pevent = field->event->pevent;
 
-	if (field->flags & FIELD_IS_ARRAY) {
+	if (field->flags & TEP_FIELD_IS_ARRAY) {
 		offset = field->offset;
 		len = field->size;
-		if (field->flags & FIELD_IS_DYNAMIC) {
+		if (field->flags & TEP_FIELD_IS_DYNAMIC) {
 			val = tep_read_number(pevent, data + offset, len);
 			offset = val;
 			len = offset >> 16;
 			offset &= 0xffff;
 		}
-		if (field->flags & FIELD_IS_STRING &&
+		if (field->flags & TEP_FIELD_IS_STRING &&
 		    is_printable_array(data + offset, len)) {
 			trace_seq_printf(s, "%s", (char *)data + offset);
 		} else {
@@ -4815,21 +4815,21 @@ void tep_print_field(struct trace_seq *s, void *data,
 						 *((unsigned char *)data + offset + i));
 			}
 			trace_seq_putc(s, ']');
-			field->flags &= ~FIELD_IS_STRING;
+			field->flags &= ~TEP_FIELD_IS_STRING;
 		}
 	} else {
 		val = tep_read_number(pevent, data + field->offset,
 				      field->size);
-		if (field->flags & FIELD_IS_POINTER) {
+		if (field->flags & TEP_FIELD_IS_POINTER) {
 			trace_seq_printf(s, "0x%llx", val);
-		} else if (field->flags & FIELD_IS_SIGNED) {
+		} else if (field->flags & TEP_FIELD_IS_SIGNED) {
 			switch (field->size) {
 			case 4:
 				/*
 				 * If field is long then print it in hex.
 				 * A long usually stores pointers.
 				 */
-				if (field->flags & FIELD_IS_LONG)
+				if (field->flags & TEP_FIELD_IS_LONG)
 					trace_seq_printf(s, "0x%x", (int)val);
 				else
 					trace_seq_printf(s, "%d", (int)val);
@@ -4844,7 +4844,7 @@ void tep_print_field(struct trace_seq *s, void *data,
 				trace_seq_printf(s, "%lld", val);
 			}
 		} else {
-			if (field->flags & FIELD_IS_LONG)
+			if (field->flags & TEP_FIELD_IS_LONG)
 				trace_seq_printf(s, "0x%llx", val);
 			else
 				trace_seq_printf(s, "%llu", val);
@@ -6288,7 +6288,7 @@ void *tep_get_field_raw(struct trace_seq *s, struct tep_event_format *event,
 		len = &dummy;
 
 	offset = field->offset;
-	if (field->flags & FIELD_IS_DYNAMIC) {
+	if (field->flags & TEP_FIELD_IS_DYNAMIC) {
 		offset = tep_read_number(event->pevent,
 					    data + offset, field->size);
 		*len = offset >> 16;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index aba859056867..f1e1baee8cbd 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -130,15 +130,15 @@ struct tep_plugin_option {
 #define TEP_PLUGIN_OPTIONS_NAME MAKE_STR(TEP_PLUGIN_OPTIONS)
 #define TEP_PLUGIN_ALIAS_NAME MAKE_STR(TEP_PLUGIN_ALIAS)
 
-enum format_flags {
-	FIELD_IS_ARRAY		= 1,
-	FIELD_IS_POINTER	= 2,
-	FIELD_IS_SIGNED		= 4,
-	FIELD_IS_STRING		= 8,
-	FIELD_IS_DYNAMIC	= 16,
-	FIELD_IS_LONG		= 32,
-	FIELD_IS_FLAG		= 64,
-	FIELD_IS_SYMBOLIC	= 128,
+enum tep_format_flags {
+	TEP_FIELD_IS_ARRAY	= 1,
+	TEP_FIELD_IS_POINTER	= 2,
+	TEP_FIELD_IS_SIGNED	= 4,
+	TEP_FIELD_IS_STRING	= 8,
+	TEP_FIELD_IS_DYNAMIC	= 16,
+	TEP_FIELD_IS_LONG	= 32,
+	TEP_FIELD_IS_FLAG	= 64,
+	TEP_FIELD_IS_SYMBOLIC	= 128,
 };
 
 struct tep_format_field {
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index a0353f2c051a..dcd97acbbc49 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1716,7 +1716,7 @@ get_value(struct tep_event_format *event,
 
 	tep_read_number_field(field, record->data, &val);
 
-	if (!(field->flags & FIELD_IS_SIGNED))
+	if (!(field->flags & TEP_FIELD_IS_SIGNED))
 		return val;
 
 	switch (field->size) {
@@ -1867,11 +1867,11 @@ static const char *get_field_str(struct filter_arg *arg, struct tep_record *reco
 	char hex[64];
 
 	/* If the field is not a string convert it */
-	if (arg->str.field->flags & FIELD_IS_STRING) {
+	if (arg->str.field->flags & TEP_FIELD_IS_STRING) {
 		val = record->data + arg->str.field->offset;
 		size = arg->str.field->size;
 
-		if (arg->str.field->flags & FIELD_IS_DYNAMIC) {
+		if (arg->str.field->flags & TEP_FIELD_IS_DYNAMIC) {
 			addr = *(unsigned int *)val;
 			val = record->data + (addr & 0xffff);
 			size = addr >> 16;
@@ -1893,7 +1893,7 @@ static const char *get_field_str(struct filter_arg *arg, struct tep_record *reco
 		pevent = event->pevent;
 		addr = get_value(event, arg->str.field, record);
 
-		if (arg->str.field->flags & (FIELD_IS_POINTER | FIELD_IS_LONG))
+		if (arg->str.field->flags & (TEP_FIELD_IS_POINTER | TEP_FIELD_IS_LONG))
 			/* convert to a kernel symbol */
 			val = tep_find_function(pevent, addr);
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 95f3c255d977..90289f31dd87 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1293,7 +1293,7 @@ static int syscall__set_arg_fmts(struct syscall *sc)
 			  strcmp(field->name, "path") == 0 ||
 			  strcmp(field->name, "pathname") == 0))
 			sc->arg_fmt[idx].scnprintf = SCA_FILENAME;
-		else if (field->flags & FIELD_IS_POINTER)
+		else if (field->flags & TEP_FIELD_IS_POINTER)
 			sc->arg_fmt[idx].scnprintf = syscall_arg__scnprintf_hex;
 		else if (strcmp(field->type, "pid_t") == 0)
 			sc->arg_fmt[idx].scnprintf = SCA_PID;
diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
index da9d3c0f8ead..5f8501c68da4 100644
--- a/tools/perf/tests/evsel-tp-sched.c
+++ b/tools/perf/tests/evsel-tp-sched.c
@@ -17,7 +17,7 @@ static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
 		return -1;
 	}
 
-	is_signed = !!(field->flags | FIELD_IS_SIGNED);
+	is_signed = !!(field->flags | TEP_FIELD_IS_SIGNED);
 	if (should_be_signed && !is_signed) {
 		pr_debug("%s: \"%s\" signedness(%d) is wrong, should be %d\n",
 			 evsel->name, name, is_signed, should_be_signed);
diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index f50678f2d2f3..9dbd10ac15bf 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -186,16 +186,16 @@ get_tracepoint_field_type(struct ctf_writer *cw, struct tep_format_field *field)
 {
 	unsigned long flags = field->flags;
 
-	if (flags & FIELD_IS_STRING)
+	if (flags & TEP_FIELD_IS_STRING)
 		return cw->data.string;
 
-	if (!(flags & FIELD_IS_SIGNED)) {
+	if (!(flags & TEP_FIELD_IS_SIGNED)) {
 		/* unsigned long are mostly pointers */
-		if (flags & FIELD_IS_LONG || flags & FIELD_IS_POINTER)
+		if (flags & TEP_FIELD_IS_LONG || flags & TEP_FIELD_IS_POINTER)
 			return cw->data.u64_hex;
 	}
 
-	if (flags & FIELD_IS_SIGNED) {
+	if (flags & TEP_FIELD_IS_SIGNED) {
 		if (field->size == 8)
 			return cw->data.s64;
 		else
@@ -304,10 +304,10 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 	name = fmtf->alias;
 	offset = fmtf->offset;
 	len = fmtf->size;
-	if (flags & FIELD_IS_STRING)
-		flags &= ~FIELD_IS_ARRAY;
+	if (flags & TEP_FIELD_IS_STRING)
+		flags &= ~TEP_FIELD_IS_ARRAY;
 
-	if (flags & FIELD_IS_DYNAMIC) {
+	if (flags & TEP_FIELD_IS_DYNAMIC) {
 		unsigned long long tmp_val;
 
 		tmp_val = tep_read_number(fmtf->event->pevent,
@@ -317,7 +317,7 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 		offset &= 0xffff;
 	}
 
-	if (flags & FIELD_IS_ARRAY) {
+	if (flags & TEP_FIELD_IS_ARRAY) {
 
 		type = bt_ctf_event_class_get_field_by_name(
 				event_class, name);
@@ -338,7 +338,7 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 	type = get_tracepoint_field_type(cw, fmtf);
 
 	for (i = 0; i < n_items; i++) {
-		if (flags & FIELD_IS_ARRAY)
+		if (flags & TEP_FIELD_IS_ARRAY)
 			field = bt_ctf_field_array_get_field(array_field, i);
 		else
 			field = bt_ctf_field_create(type);
@@ -348,7 +348,7 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 			return -1;
 		}
 
-		if (flags & FIELD_IS_STRING)
+		if (flags & TEP_FIELD_IS_STRING)
 			ret = string_set_value(field, data + offset + i * len);
 		else {
 			unsigned long long value_int;
@@ -357,7 +357,7 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 					fmtf->event->pevent,
 					data + offset + i * len, len);
 
-			if (!(flags & FIELD_IS_SIGNED))
+			if (!(flags & TEP_FIELD_IS_SIGNED))
 				ret = bt_ctf_field_unsigned_integer_set_value(
 						field, value_int);
 			else
@@ -369,7 +369,7 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 			pr_err("failed to set file value %s\n", name);
 			goto err_put_field;
 		}
-		if (!(flags & FIELD_IS_ARRAY)) {
+		if (!(flags & TEP_FIELD_IS_ARRAY)) {
 			ret = bt_ctf_event_set_payload(event, name, field);
 			if (ret) {
 				pr_err("failed to set payload %s\n", name);
@@ -378,7 +378,7 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 		}
 		bt_ctf_field_put(field);
 	}
-	if (flags & FIELD_IS_ARRAY) {
+	if (flags & TEP_FIELD_IS_ARRAY) {
 		ret = bt_ctf_event_set_payload(event, name, array_field);
 		if (ret) {
 			pr_err("Failed add payload array %s\n", name);
@@ -1030,15 +1030,15 @@ static int add_tracepoint_fields_types(struct ctf_writer *cw,
 		 * type and don't care that it is an array. What we don't
 		 * support is an array of strings.
 		 */
-		if (flags & FIELD_IS_STRING)
-			flags &= ~FIELD_IS_ARRAY;
+		if (flags & TEP_FIELD_IS_STRING)
+			flags &= ~TEP_FIELD_IS_ARRAY;
 
-		if (flags & FIELD_IS_ARRAY)
+		if (flags & TEP_FIELD_IS_ARRAY)
 			type = bt_ctf_field_type_array_create(type, field->arraylen);
 
 		ret = event_class_add_field(event_class, type, field);
 
-		if (flags & FIELD_IS_ARRAY)
+		if (flags & TEP_FIELD_IS_ARRAY)
 			bt_ctf_field_type_put(type);
 
 		if (ret) {
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 751c98a2e336..cb7f01059940 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2698,7 +2698,7 @@ void *perf_evsel__rawptr(struct perf_evsel *evsel, struct perf_sample *sample,
 
 	offset = field->offset;
 
-	if (field->flags & FIELD_IS_DYNAMIC) {
+	if (field->flags & TEP_FIELD_IS_DYNAMIC) {
 		offset = *(int *)(sample->raw_data + field->offset);
 		offset &= 0xffff;
 	}
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index ebf84fe8cd29..50150dfc0cdf 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -348,28 +348,28 @@ tracepoint_field(struct pyrf_event *pe, struct tep_format_field *field)
 	unsigned long long val;
 	unsigned int offset, len;
 
-	if (field->flags & FIELD_IS_ARRAY) {
+	if (field->flags & TEP_FIELD_IS_ARRAY) {
 		offset = field->offset;
 		len    = field->size;
-		if (field->flags & FIELD_IS_DYNAMIC) {
+		if (field->flags & TEP_FIELD_IS_DYNAMIC) {
 			val     = tep_read_number(pevent, data + offset, len);
 			offset  = val;
 			len     = offset >> 16;
 			offset &= 0xffff;
 		}
-		if (field->flags & FIELD_IS_STRING &&
+		if (field->flags & TEP_FIELD_IS_STRING &&
 		    is_printable_array(data + offset, len)) {
 			ret = _PyUnicode_FromString((char *)data + offset);
 		} else {
 			ret = PyByteArray_FromStringAndSize((const char *) data + offset, len);
-			field->flags &= ~FIELD_IS_STRING;
+			field->flags &= ~TEP_FIELD_IS_STRING;
 		}
 	} else {
 		val = tep_read_number(pevent, data + field->offset,
 				      field->size);
-		if (field->flags & FIELD_IS_POINTER)
+		if (field->flags & TEP_FIELD_IS_POINTER)
 			ret = PyLong_FromUnsignedLong((unsigned long) val);
-		else if (field->flags & FIELD_IS_SIGNED)
+		else if (field->flags & TEP_FIELD_IS_SIGNED)
 			ret = PyLong_FromLong((long) val);
 		else
 			ret = PyLong_FromUnsignedLong((unsigned long) val);
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 1bb0b0c685b7..5d6a55183ad6 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -388,9 +388,9 @@ static void perl_process_tracepoint(struct perf_sample *sample,
 	/* common fields other than pid can be accessed via xsub fns */
 
 	for (field = event->format.fields; field; field = field->next) {
-		if (field->flags & FIELD_IS_STRING) {
+		if (field->flags & TEP_FIELD_IS_STRING) {
 			int offset;
-			if (field->flags & FIELD_IS_DYNAMIC) {
+			if (field->flags & TEP_FIELD_IS_DYNAMIC) {
 				offset = *(int *)(data + field->offset);
 				offset &= 0xffff;
 			} else
@@ -399,7 +399,7 @@ static void perl_process_tracepoint(struct perf_sample *sample,
 		} else { /* FIELD_IS_NUMERIC */
 			val = read_size(event, data + field->offset,
 					field->size);
-			if (field->flags & FIELD_IS_SIGNED) {
+			if (field->flags & TEP_FIELD_IS_SIGNED) {
 				XPUSHs(sv_2mortal(newSViv(val)));
 			} else {
 				XPUSHs(sv_2mortal(newSVuv(val)));
@@ -646,11 +646,11 @@ sub print_backtrace\n\
 			count++;
 
 			fprintf(ofp, "%s=", f->name);
-			if (f->flags & FIELD_IS_STRING ||
-			    f->flags & FIELD_IS_FLAG ||
-			    f->flags & FIELD_IS_SYMBOLIC)
+			if (f->flags & TEP_FIELD_IS_STRING ||
+			    f->flags & TEP_FIELD_IS_FLAG ||
+			    f->flags & TEP_FIELD_IS_SYMBOLIC)
 				fprintf(ofp, "%%s");
-			else if (f->flags & FIELD_IS_SIGNED)
+			else if (f->flags & TEP_FIELD_IS_SIGNED)
 				fprintf(ofp, "%%d");
 			else
 				fprintf(ofp, "%%u");
@@ -668,7 +668,7 @@ sub print_backtrace\n\
 			if (++count % 5 == 0)
 				fprintf(ofp, "\n\t       ");
 
-			if (f->flags & FIELD_IS_FLAG) {
+			if (f->flags & TEP_FIELD_IS_FLAG) {
 				if ((count - 1) % 5 != 0) {
 					fprintf(ofp, "\n\t       ");
 					count = 4;
@@ -678,7 +678,7 @@ sub print_backtrace\n\
 					event->name);
 				fprintf(ofp, "\"%s\", $%s)", f->name,
 					f->name);
-			} else if (f->flags & FIELD_IS_SYMBOLIC) {
+			} else if (f->flags & TEP_FIELD_IS_SYMBOLIC) {
 				if ((count - 1) % 5 != 0) {
 					fprintf(ofp, "\n\t       ");
 					count = 4;
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index dc26e58a791e..ba191def1ea9 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -335,7 +335,7 @@ static void define_event_symbols(struct tep_event_format *event,
 static PyObject *get_field_numeric_entry(struct tep_event_format *event,
 		struct tep_format_field *field, void *data)
 {
-	bool is_array = field->flags & FIELD_IS_ARRAY;
+	bool is_array = field->flags & TEP_FIELD_IS_ARRAY;
 	PyObject *obj = NULL, *list = NULL;
 	unsigned long long val;
 	unsigned int item_size, n_items, i;
@@ -353,7 +353,7 @@ static PyObject *get_field_numeric_entry(struct tep_event_format *event,
 
 		val = read_size(event, data + field->offset + i * item_size,
 				item_size);
-		if (field->flags & FIELD_IS_SIGNED) {
+		if (field->flags & TEP_FIELD_IS_SIGNED) {
 			if ((long long)val >= LONG_MIN &&
 					(long long)val <= LONG_MAX)
 				obj = _PyLong_FromLong(val);
@@ -867,22 +867,22 @@ static void python_process_tracepoint(struct perf_sample *sample,
 		unsigned int offset, len;
 		unsigned long long val;
 
-		if (field->flags & FIELD_IS_ARRAY) {
+		if (field->flags & TEP_FIELD_IS_ARRAY) {
 			offset = field->offset;
 			len    = field->size;
-			if (field->flags & FIELD_IS_DYNAMIC) {
+			if (field->flags & TEP_FIELD_IS_DYNAMIC) {
 				val     = tep_read_number(scripting_context->pevent,
 							  data + offset, len);
 				offset  = val;
 				len     = offset >> 16;
 				offset &= 0xffff;
 			}
-			if (field->flags & FIELD_IS_STRING &&
+			if (field->flags & TEP_FIELD_IS_STRING &&
 			    is_printable_array(data + offset, len)) {
 				obj = _PyUnicode_FromString((char *) data + offset);
 			} else {
 				obj = PyByteArray_FromStringAndSize((const char *) data + offset, len);
-				field->flags &= ~FIELD_IS_STRING;
+				field->flags &= ~TEP_FIELD_IS_STRING;
 			}
 		} else { /* FIELD_IS_NUMERIC */
 			obj = get_field_numeric_entry(event, field, data);
@@ -1686,12 +1686,12 @@ static int python_generate_script(struct tep_handle *pevent, const char *outfile
 			count++;
 
 			fprintf(ofp, "%s=", f->name);
-			if (f->flags & FIELD_IS_STRING ||
-			    f->flags & FIELD_IS_FLAG ||
-			    f->flags & FIELD_IS_ARRAY ||
-			    f->flags & FIELD_IS_SYMBOLIC)
+			if (f->flags & TEP_FIELD_IS_STRING ||
+			    f->flags & TEP_FIELD_IS_FLAG ||
+			    f->flags & TEP_FIELD_IS_ARRAY ||
+			    f->flags & TEP_FIELD_IS_SYMBOLIC)
 				fprintf(ofp, "%%s");
-			else if (f->flags & FIELD_IS_SIGNED)
+			else if (f->flags & TEP_FIELD_IS_SIGNED)
 				fprintf(ofp, "%%d");
 			else
 				fprintf(ofp, "%%u");
@@ -1709,7 +1709,7 @@ static int python_generate_script(struct tep_handle *pevent, const char *outfile
 			if (++count % 5 == 0)
 				fprintf(ofp, "\n\t\t");
 
-			if (f->flags & FIELD_IS_FLAG) {
+			if (f->flags & TEP_FIELD_IS_FLAG) {
 				if ((count - 1) % 5 != 0) {
 					fprintf(ofp, "\n\t\t");
 					count = 4;
@@ -1719,7 +1719,7 @@ static int python_generate_script(struct tep_handle *pevent, const char *outfile
 					event->name);
 				fprintf(ofp, "\"%s\", %s)", f->name,
 					f->name);
-			} else if (f->flags & FIELD_IS_SYMBOLIC) {
+			} else if (f->flags & TEP_FIELD_IS_SYMBOLIC) {
 				if ((count - 1) % 5 != 0) {
 					fprintf(ofp, "\n\t\t");
 					count = 4;
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 5e3179d995f9..f96c005b3c41 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1899,7 +1899,7 @@ static int hde_width(struct hpp_dynamic_entry *hde)
 		if (namelen > len)
 			len = namelen;
 
-		if (!(hde->field->flags & FIELD_IS_STRING)) {
+		if (!(hde->field->flags & TEP_FIELD_IS_STRING)) {
 			/* length for print hex numbers */
 			fieldlen = hde->field->size * 2 + 2;
 		}
@@ -2071,7 +2071,7 @@ static int64_t __sort__hde_cmp(struct perf_hpp_fmt *fmt,
 	}
 
 	field = hde->field;
-	if (field->flags & FIELD_IS_DYNAMIC) {
+	if (field->flags & TEP_FIELD_IS_DYNAMIC) {
 		unsigned long long dyn;
 
 		tep_read_number_field(field, a->raw_data, &dyn);
-- 
2.18.0
