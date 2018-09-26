Return-Path: <SRS0=XLZm=MI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730062.outbound.protection.outlook.com ([40.107.73.62]:58268
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726342AbeIZSbt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Sep 2018 14:31:49 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 04/16] tools lib traceevent, perf tools: Rename enum format_flags to enum tep_format_flags
Date: Wed, 26 Sep 2018 15:18:20 +0300
Message-Id: <20180926121832.16101-5-tstoyanov@vmware.com>
In-Reply-To: <20180926121832.16101-1-tstoyanov@vmware.com>
References: <20180926121832.16101-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This renames enum format_flags
to enum tep_format_flags and adds prefix TEP_ to all of its members.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180919185722.803127871@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h | 18 ++++++------
 lib/traceevent/event-parse.c     | 48 ++++++++++++++++----------------
 lib/traceevent/parse-filter.c    |  8 +++---
 3 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index bda679a..da7d31b 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -116,15 +116,15 @@ struct tep_plugin_option {
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
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 32547ab..508c893 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
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
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index a0353f2..dcd97ac 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
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
 
-- 
2.17.1
