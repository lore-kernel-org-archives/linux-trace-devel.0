Return-Path: <SRS0=GMWY=KZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46127 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbeHJPrm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Aug 2018 11:47:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id h14-v6so8253028wrw.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Aug 2018 06:17:47 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 02/14] tools/lib/traceevent, tools/perf: Rename struct format to struct tep_format and struct format_field to struct tep_format_field
Date: Fri, 10 Aug 2018 16:17:20 +0300
Message-Id: <20180810131732.24677-3-tz.stoyanov@gmail.com>
In-Reply-To: <20180810131732.24677-1-tz.stoyanov@gmail.com>
References: <20180810131732.24677-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This renames struct format to
struct tep_format and struct format_field to struct tep_format_field

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.c            | 82 +++++++++----------
 tools/lib/traceevent/event-parse.h            | 42 +++++-----
 tools/lib/traceevent/parse-filter.c           |  8 +-
 tools/lib/traceevent/plugin_kmem.c            |  2 +-
 tools/lib/traceevent/plugin_mac80211.c        |  2 +-
 tools/lib/traceevent/plugin_sched_switch.c    |  6 +-
 tools/perf/builtin-trace.c                    | 22 ++---
 tools/perf/tests/evsel-tp-sched.c             |  2 +-
 tools/perf/util/data-convert-bt.c             | 22 ++---
 tools/perf/util/evsel.c                       |  8 +-
 tools/perf/util/evsel.h                       |  6 +-
 tools/perf/util/evsel_fprintf.c               |  2 +-
 tools/perf/util/python.c                      |  4 +-
 .../util/scripting-engines/trace-event-perl.c |  4 +-
 .../scripting-engines/trace-event-python.c    |  6 +-
 tools/perf/util/sort.c                        | 18 ++--
 tools/perf/util/trace-event-parse.c           |  4 +-
 17 files changed, 120 insertions(+), 120 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 1874c249a963..40bad7b7533a 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1312,7 +1312,7 @@ static int event_read_id(void)
 	return -1;
 }
 
-static int field_is_string(struct format_field *field)
+static int field_is_string(struct tep_format_field *field)
 {
 	if ((field->flags & FIELD_IS_ARRAY) &&
 	    (strstr(field->type, "char") || strstr(field->type, "u8") ||
@@ -1322,7 +1322,7 @@ static int field_is_string(struct format_field *field)
 	return 0;
 }
 
-static int field_is_dynamic(struct format_field *field)
+static int field_is_dynamic(struct tep_format_field *field)
 {
 	if (strncmp(field->type, "__data_loc", 10) == 0)
 		return 1;
@@ -1330,7 +1330,7 @@ static int field_is_dynamic(struct format_field *field)
 	return 0;
 }
 
-static int field_is_long(struct format_field *field)
+static int field_is_long(struct tep_format_field *field)
 {
 	/* includes long long */
 	if (strstr(field->type, "long"))
@@ -1367,9 +1367,9 @@ static unsigned int type_size(const char *name)
 	return 0;
 }
 
-static int event_read_fields(struct tep_event_format *event, struct format_field **fields)
+static int event_read_fields(struct tep_event_format *event, struct tep_format_field **fields)
 {
-	struct format_field *field = NULL;
+	struct tep_format_field *field = NULL;
 	enum event_type type;
 	char *token;
 	char *last_token;
@@ -2696,7 +2696,7 @@ process_int_array(struct tep_event_format *event, struct print_arg *arg, char **
 static enum event_type
 process_dynamic_array(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	enum event_type type;
 	char *token;
 
@@ -2761,7 +2761,7 @@ static enum event_type
 process_dynamic_array_len(struct tep_event_format *event, struct print_arg *arg,
 			  char **tok)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	enum event_type type;
 	char *token;
 
@@ -3272,10 +3272,10 @@ static int event_read_print(struct tep_event_format *event)
  * Returns a common field from the event by the given @name.
  * This only searchs the common fields and not all field.
  */
-struct format_field *
+struct tep_format_field *
 tep_find_common_field(struct tep_event_format *event, const char *name)
 {
-	struct format_field *format;
+	struct tep_format_field *format;
 
 	for (format = event->format.common_fields;
 	     format; format = format->next) {
@@ -3294,10 +3294,10 @@ tep_find_common_field(struct tep_event_format *event, const char *name)
  * Returns a non-common field by the given @name.
  * This does not search common fields.
  */
-struct format_field *
+struct tep_format_field *
 tep_find_field(struct tep_event_format *event, const char *name)
 {
-	struct format_field *format;
+	struct tep_format_field *format;
 
 	for (format = event->format.fields;
 	     format; format = format->next) {
@@ -3317,10 +3317,10 @@ tep_find_field(struct tep_event_format *event, const char *name)
  * This searchs the common field names first, then
  * the non-common ones if a common one was not found.
  */
-struct format_field *
+struct tep_format_field *
 tep_find_any_field(struct tep_event_format *event, const char *name)
 {
-	struct format_field *format;
+	struct tep_format_field *format;
 
 	format = tep_find_common_field(event, name);
 	if (format)
@@ -3366,7 +3366,7 @@ unsigned long long tep_read_number(struct tep_handle *pevent,
  *
  * Returns 0 on success, -1 otherwise.
  */
-int tep_read_number_field(struct format_field *field, const void *data,
+int tep_read_number_field(struct tep_format_field *field, const void *data,
 			  unsigned long long *value)
 {
 	if (!field)
@@ -3388,7 +3388,7 @@ static int get_common_info(struct tep_handle *pevent,
 			   const char *type, int *offset, int *size)
 {
 	struct tep_event_format *event;
-	struct format_field *field;
+	struct tep_format_field *field;
 
 	/*
 	 * All events should have the same common elements.
@@ -3880,7 +3880,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 {
 	struct tep_handle *pevent = event->pevent;
 	struct print_flag_sym *flag;
-	struct format_field *field;
+	struct tep_format_field *field;
 	struct printk_map *printk;
 	long long val, fval;
 	unsigned long long addr;
@@ -4021,7 +4021,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 
 		if (arg->int_array.field->type == PRINT_DYNAMIC_ARRAY) {
 			unsigned long offset;
-			struct format_field *field =
+			struct tep_format_field *field =
 				arg->int_array.field->dynarray.field;
 			offset = tep_read_number(pevent,
 						 data + field->offset,
@@ -4069,7 +4069,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		int str_offset;
 
 		if (arg->string.offset == -1) {
-			struct format_field *f;
+			struct tep_format_field *f;
 
 			f = tep_find_any_field(event, arg->string.string);
 			arg->string.offset = f->offset;
@@ -4087,7 +4087,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		int bitmask_size;
 
 		if (arg->bitmask.offset == -1) {
-			struct format_field *f;
+			struct tep_format_field *f;
 
 			f = tep_find_any_field(event, arg->bitmask.bitmask);
 			arg->bitmask.offset = f->offset;
@@ -4228,7 +4228,7 @@ static void free_args(struct print_arg *args)
 static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struct tep_event_format *event)
 {
 	struct tep_handle *pevent = event->pevent;
-	struct format_field *field, *ip_field;
+	struct tep_format_field *field, *ip_field;
 	struct print_arg *args, *arg, **next;
 	unsigned long long ip, val;
 	char *ptr;
@@ -4406,7 +4406,7 @@ get_bprint_format(void *data, int size __maybe_unused,
 {
 	struct tep_handle *pevent = event->pevent;
 	unsigned long long addr;
-	struct format_field *field;
+	struct tep_format_field *field;
 	struct printk_map *printk;
 	char *format;
 
@@ -4801,7 +4801,7 @@ static int is_printable_array(char *p, unsigned int len)
 }
 
 void tep_print_field(struct trace_seq *s, void *data,
-		     struct format_field *field)
+		     struct tep_format_field *field)
 {
 	unsigned long long val;
 	unsigned int offset, len, i;
@@ -4868,7 +4868,7 @@ void tep_print_field(struct trace_seq *s, void *data,
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event_format *event)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 
 	field = event->format.fields;
 	while (field) {
@@ -5677,12 +5677,12 @@ struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum event_
 	return events;
 }
 
-static struct format_field **
+static struct tep_format_field **
 get_event_fields(const char *type, const char *name,
-		 int count, struct format_field *list)
+		 int count, struct tep_format_field *list)
 {
-	struct format_field **fields;
-	struct format_field *field;
+	struct tep_format_field **fields;
+	struct tep_format_field *field;
 	int i = 0;
 
 	fields = malloc(sizeof(*fields) * (count + 1));
@@ -5715,7 +5715,7 @@ get_event_fields(const char *type, const char *name,
  * Returns an allocated array of fields. The last item in the array is NULL.
  * The array must be freed with free().
  */
-struct format_field **tep_event_common_fields(struct tep_event_format *event)
+struct tep_format_field **tep_event_common_fields(struct tep_event_format *event)
 {
 	return get_event_fields("common", event->name,
 				event->format.nr_common,
@@ -5729,7 +5729,7 @@ struct format_field **tep_event_common_fields(struct tep_event_format *event)
  * Returns an allocated array of fields. The last item in the array is NULL.
  * The array must be freed with free().
  */
-struct format_field **tep_event_fields(struct tep_event_format *event)
+struct tep_format_field **tep_event_fields(struct tep_event_format *event)
 {
 	return get_event_fields("event", event->name,
 				event->format.nr_fields,
@@ -6103,7 +6103,7 @@ enum tep_errno __tep_parse_format(struct tep_event_format **eventp,
 	}
 
 	if (!ret && (event->flags & EVENT_FL_ISFTRACE)) {
-		struct format_field *field;
+		struct tep_format_field *field;
 		struct print_arg *arg, **list;
 
 		/* old ftrace had no args */
@@ -6243,7 +6243,7 @@ int tep_strerror(struct tep_handle *pevent __maybe_unused,
 	return 0;
 }
 
-int get_field_val(struct trace_seq *s, struct format_field *field,
+int get_field_val(struct trace_seq *s, struct tep_format_field *field,
 		  const char *name, struct tep_record *record,
 		  unsigned long long *val, int err)
 {
@@ -6280,7 +6280,7 @@ void *tep_get_field_raw(struct trace_seq *s, struct tep_event_format *event,
 			const char *name, struct tep_record *record,
 			int *len, int err)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	void *data = record->data;
 	unsigned offset;
 	int dummy;
@@ -6327,7 +6327,7 @@ int tep_get_field_val(struct trace_seq *s, struct tep_event_format *event,
 		      const char *name, struct tep_record *record,
 		      unsigned long long *val, int err)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 
 	if (!event)
 		return -1;
@@ -6352,7 +6352,7 @@ int tep_get_common_field_val(struct trace_seq *s, struct tep_event_format *event
 			     const char *name, struct tep_record *record,
 			     unsigned long long *val, int err)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 
 	if (!event)
 		return -1;
@@ -6377,7 +6377,7 @@ int tep_get_any_field_val(struct trace_seq *s, struct tep_event_format *event,
 			  const char *name, struct tep_record *record,
 			  unsigned long long *val, int err)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 
 	if (!event)
 		return -1;
@@ -6402,7 +6402,7 @@ int tep_print_num_field(struct trace_seq *s, const char *fmt,
 			struct tep_event_format *event, const char *name,
 			struct tep_record *record, int err)
 {
-	struct format_field *field = tep_find_field(event, name);
+	struct tep_format_field *field = tep_find_field(event, name);
 	unsigned long long val;
 
 	if (!field)
@@ -6434,7 +6434,7 @@ int tep_print_func_field(struct trace_seq *s, const char *fmt,
 			 struct tep_event_format *event, const char *name,
 			 struct tep_record *record, int err)
 {
-	struct format_field *field = tep_find_field(event, name);
+	struct tep_format_field *field = tep_find_field(event, name);
 	struct tep_handle *pevent = event->pevent;
 	unsigned long long val;
 	struct func_map *func;
@@ -6771,7 +6771,7 @@ void tep_ref(struct tep_handle *pevent)
 	pevent->ref_count++;
 }
 
-void tep_free_format_field(struct format_field *field)
+void tep_free_format_field(struct tep_format_field *field)
 {
 	free(field->type);
 	if (field->alias != field->name)
@@ -6780,9 +6780,9 @@ void tep_free_format_field(struct format_field *field)
 	free(field);
 }
 
-static void free_format_fields(struct format_field *field)
+static void free_format_fields(struct tep_format_field *field)
 {
-	struct format_field *next;
+	struct tep_format_field *next;
 
 	while (field) {
 		next = field->next;
@@ -6791,7 +6791,7 @@ static void free_format_fields(struct format_field *field)
 	}
 }
 
-static void free_formats(struct format *format)
+static void free_formats(struct tep_format *format)
 {
 	free_format_fields(format->common_fields);
 	free_format_fields(format->fields);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 0e7775c5da69..9753cefe1b75 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -183,8 +183,8 @@ enum format_flags {
 	FIELD_IS_SYMBOLIC	= 128,
 };
 
-struct format_field {
-	struct format_field	*next;
+struct tep_format_field {
+	struct tep_format_field	*next;
 	struct tep_event_format	*event;
 	char			*type;
 	char			*name;
@@ -196,11 +196,11 @@ struct format_field {
 	unsigned long		flags;
 };
 
-struct format {
+struct tep_format {
 	int			nr_common;
 	int			nr_fields;
-	struct format_field	*common_fields;
-	struct format_field	*fields;
+	struct tep_format_field	*common_fields;
+	struct tep_format_field	*fields;
 };
 
 struct print_arg_atom {
@@ -219,7 +219,7 @@ struct print_arg_bitmask {
 
 struct print_arg_field {
 	char			*name;
-	struct format_field	*field;
+	struct tep_format_field	*field;
 };
 
 struct print_flag_sym {
@@ -256,7 +256,7 @@ struct print_arg_int_array {
 };
 
 struct print_arg_dynarray {
-	struct format_field	*field;
+	struct tep_format_field	*field;
 	struct print_arg	*index;
 };
 
@@ -324,7 +324,7 @@ struct tep_event_format {
 	char			*name;
 	int			id;
 	int			flags;
-	struct format		format;
+	struct tep_format	format;
 	struct print_fmt	print_fmt;
 	char			*system;
 	tep_event_handler_func	handler;
@@ -519,9 +519,9 @@ struct tep_handle {
 
 	int flags;
 
-	struct format_field *bprint_ip_field;
-	struct format_field *bprint_fmt_field;
-	struct format_field *bprint_buf_field;
+	struct tep_format_field *bprint_ip_field;
+	struct tep_format_field *bprint_fmt_field;
+	struct tep_format_field *bprint_buf_field;
 
 	struct event_handler *handlers;
 	struct tep_function_handler *func_handlers;
@@ -649,7 +649,7 @@ enum tep_errno tep_parse_format(struct tep_handle *pevent,
 				const char *buf,
 				unsigned long size, const char *sys);
 void tep_free_format(struct tep_event_format *event);
-void tep_free_format_field(struct format_field *field);
+void tep_free_format_field(struct tep_format_field *field);
 
 void *tep_get_field_raw(struct trace_seq *s, struct tep_event_format *event,
 			const char *name, struct tep_record *record,
@@ -686,15 +686,15 @@ int tep_register_print_function(struct tep_handle *pevent,
 int tep_unregister_print_function(struct tep_handle *pevent,
 				  tep_func_handler func, char *name);
 
-struct format_field *tep_find_common_field(struct tep_event_format *event, const char *name);
-struct format_field *tep_find_field(struct tep_event_format *event, const char *name);
-struct format_field *tep_find_any_field(struct tep_event_format *event, const char *name);
+struct tep_format_field *tep_find_common_field(struct tep_event_format *event, const char *name);
+struct tep_format_field *tep_find_field(struct tep_event_format *event, const char *name);
+struct tep_format_field *tep_find_any_field(struct tep_event_format *event, const char *name);
 
 const char *tep_find_function(struct tep_handle *pevent, unsigned long long addr);
 unsigned long long
 tep_find_function_address(struct tep_handle *pevent, unsigned long long addr);
 unsigned long long tep_read_number(struct tep_handle *pevent, const void *ptr, int size);
-int tep_read_number_field(struct format_field *field, const void *data,
+int tep_read_number_field(struct tep_format_field *field, const void *data,
 			  unsigned long long *value);
 
 struct tep_event_format *tep_find_event(struct tep_handle *pevent, int id);
@@ -719,7 +719,7 @@ struct cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char *co
 int tep_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline);
 
 void tep_print_field(struct trace_seq *s, void *data,
-		     struct format_field *field);
+		     struct tep_format_field *field);
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event_format *event);
 void tep_event_info(struct trace_seq *s, struct tep_event_format *event,
@@ -728,8 +728,8 @@ int tep_strerror(struct tep_handle *pevent, enum tep_errno errnum,
 		    char *buf, size_t buflen);
 
 struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum event_sort_type);
-struct format_field **tep_event_common_fields(struct tep_event_format *event);
-struct format_field **tep_event_fields(struct tep_event_format *event);
+struct tep_format_field **tep_event_common_fields(struct tep_event_format *event);
+struct tep_format_field **tep_event_fields(struct tep_event_format *event);
 
 static inline int tep_get_cpus(struct tep_handle *pevent)
 {
@@ -874,7 +874,7 @@ struct filter_arg_boolean {
 };
 
 struct filter_arg_field {
-	struct format_field	*field;
+	struct tep_format_field	*field;
 };
 
 struct filter_arg_value {
@@ -905,7 +905,7 @@ struct filter_arg_num {
 
 struct filter_arg_str {
 	enum filter_cmp_type	type;
-	struct format_field	*field;
+	struct tep_format_field	*field;
 	char			*val;
 	char			*buffer;
 	regex_t			reg;
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 3ecd9575698a..500cd3150b22 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -30,11 +30,11 @@
 #define COMM "COMM"
 #define CPU "CPU"
 
-static struct format_field comm = {
+static struct tep_format_field comm = {
 	.name = "COMM",
 };
 
-static struct format_field cpu = {
+static struct tep_format_field cpu = {
 	.name = "CPU",
 };
 
@@ -350,7 +350,7 @@ static enum tep_errno
 create_arg_item(struct tep_event_format *event, const char *token,
 		enum event_type type, struct filter_arg **parg, char *error_str)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	struct filter_arg *arg;
 
 	arg = allocate_arg();
@@ -1712,7 +1712,7 @@ get_comm(struct tep_event_format *event, struct tep_record *record)
 
 static unsigned long long
 get_value(struct tep_event_format *event,
-	  struct format_field *field, struct tep_record *record)
+	  struct tep_format_field *field, struct tep_record *record)
 {
 	unsigned long long val;
 
diff --git a/tools/lib/traceevent/plugin_kmem.c b/tools/lib/traceevent/plugin_kmem.c
index ba4d7c7ad8bd..e40e15a52086 100644
--- a/tools/lib/traceevent/plugin_kmem.c
+++ b/tools/lib/traceevent/plugin_kmem.c
@@ -26,7 +26,7 @@
 static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 			     struct tep_event_format *event, void *context)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	unsigned long long val, addr;
 	void *data = record->data;
 	const char *func;
diff --git a/tools/lib/traceevent/plugin_mac80211.c b/tools/lib/traceevent/plugin_mac80211.c
index de36d1d5a450..d3ce41ebe400 100644
--- a/tools/lib/traceevent/plugin_mac80211.c
+++ b/tools/lib/traceevent/plugin_mac80211.c
@@ -28,7 +28,7 @@
 static void print_string(struct trace_seq *s, struct tep_event_format *event,
 			 const char *name, const void *data)
 {
-	struct format_field *f = tep_find_field(event, name);
+	struct tep_format_field *f = tep_find_field(event, name);
 	int offset;
 	int length;
 
diff --git a/tools/lib/traceevent/plugin_sched_switch.c b/tools/lib/traceevent/plugin_sched_switch.c
index ec22d4de8890..07f067b84396 100644
--- a/tools/lib/traceevent/plugin_sched_switch.c
+++ b/tools/lib/traceevent/plugin_sched_switch.c
@@ -44,7 +44,7 @@ static void write_state(struct trace_seq *s, int val)
 		trace_seq_putc(s, 'R');
 }
 
-static void write_and_save_comm(struct format_field *field,
+static void write_and_save_comm(struct tep_format_field *field,
 				struct tep_record *record,
 				struct trace_seq *s, int pid)
 {
@@ -68,7 +68,7 @@ static int sched_wakeup_handler(struct trace_seq *s,
 				struct tep_record *record,
 				struct tep_event_format *event, void *context)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	unsigned long long val;
 
 	if (tep_get_field_val(s, event, "pid", record, &val, 1))
@@ -97,7 +97,7 @@ static int sched_switch_handler(struct trace_seq *s,
 				struct tep_record *record,
 				struct tep_event_format *event, void *context)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	unsigned long long val;
 
 	if (tep_get_field_val(s, event, "prev_pid", record, &val, 1))
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 92007ebd9b8d..5cc7264947e8 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -158,7 +158,7 @@ TP_UINT_FIELD__SWAPPED(32);
 TP_UINT_FIELD__SWAPPED(64);
 
 static int tp_field__init_uint(struct tp_field *field,
-			       struct format_field *format_field,
+			       struct tep_format_field *format_field,
 			       bool needs_swap)
 {
 	field->offset = format_field->offset;
@@ -188,7 +188,7 @@ static void *tp_field__ptr(struct tp_field *field, struct perf_sample *sample)
 	return sample->raw_data + field->offset;
 }
 
-static int tp_field__init_ptr(struct tp_field *field, struct format_field *format_field)
+static int tp_field__init_ptr(struct tp_field *field, struct tep_format_field *format_field)
 {
 	field->offset = format_field->offset;
 	field->pointer = tp_field__ptr;
@@ -206,7 +206,7 @@ static int perf_evsel__init_tp_uint_field(struct perf_evsel *evsel,
 					  struct tp_field *field,
 					  const char *name)
 {
-	struct format_field *format_field = perf_evsel__field(evsel, name);
+	struct tep_format_field *format_field = perf_evsel__field(evsel, name);
 
 	if (format_field == NULL)
 		return -1;
@@ -222,7 +222,7 @@ static int perf_evsel__init_tp_ptr_field(struct perf_evsel *evsel,
 					 struct tp_field *field,
 					 const char *name)
 {
-	struct format_field *format_field = perf_evsel__field(evsel, name);
+	struct tep_format_field *format_field = perf_evsel__field(evsel, name);
 
 	if (format_field == NULL)
 		return -1;
@@ -805,11 +805,11 @@ static struct syscall_fmt *syscall_fmt__find(const char *name)
 
 struct syscall {
 	struct tep_event_format *tp_format;
-	int		    nr_args;
-	struct format_field *args;
-	const char	    *name;
-	bool		    is_exit;
-	struct syscall_fmt  *fmt;
+	int			nr_args;
+	struct tep_format_field *args;
+	const char		*name;
+	bool			is_exit;
+	struct syscall_fmt	*fmt;
 	struct syscall_arg_fmt *arg_fmt;
 };
 
@@ -1203,7 +1203,7 @@ static int syscall__alloc_arg_fmts(struct syscall *sc, int nr_args)
 
 static int syscall__set_arg_fmts(struct syscall *sc)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	int idx = 0, len;
 
 	for (field = sc->args; field; field = field->next, ++idx) {
@@ -1439,7 +1439,7 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 	ttrace->ret_scnprintf = NULL;
 
 	if (sc->args != NULL) {
-		struct format_field *field;
+		struct tep_format_field *field;
 
 		for (field = sc->args; field;
 		     field = field->next, ++arg.idx, bit <<= 1) {
diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
index 699561fa512c..da9d3c0f8ead 100644
--- a/tools/perf/tests/evsel-tp-sched.c
+++ b/tools/perf/tests/evsel-tp-sched.c
@@ -8,7 +8,7 @@
 static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
 				  int size, bool should_be_signed)
 {
-	struct format_field *field = perf_evsel__field(evsel, name);
+	struct tep_format_field *field = perf_evsel__field(evsel, name);
 	int is_signed;
 	int ret = 0;
 
diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index abd38abf1d91..f50678f2d2f3 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -182,7 +182,7 @@ value_set_string(struct ctf_writer *cw, struct bt_ctf_event *event,
 }
 
 static struct bt_ctf_field_type*
-get_tracepoint_field_type(struct ctf_writer *cw, struct format_field *field)
+get_tracepoint_field_type(struct ctf_writer *cw, struct tep_format_field *field)
 {
 	unsigned long flags = field->flags;
 
@@ -287,7 +287,7 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 				      struct bt_ctf_event_class *event_class,
 				      struct bt_ctf_event *event,
 				      struct perf_sample *sample,
-				      struct format_field *fmtf)
+				      struct tep_format_field *fmtf)
 {
 	struct bt_ctf_field_type *type;
 	struct bt_ctf_field *array_field;
@@ -396,10 +396,10 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 static int add_tracepoint_fields_values(struct ctf_writer *cw,
 					struct bt_ctf_event_class *event_class,
 					struct bt_ctf_event *event,
-					struct format_field *fields,
+					struct tep_format_field *fields,
 					struct perf_sample *sample)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	int ret;
 
 	for (field = fields; field; field = field->next) {
@@ -417,8 +417,8 @@ static int add_tracepoint_values(struct ctf_writer *cw,
 				 struct perf_evsel *evsel,
 				 struct perf_sample *sample)
 {
-	struct format_field *common_fields = evsel->tp_format->format.common_fields;
-	struct format_field *fields        = evsel->tp_format->format.fields;
+	struct tep_format_field *common_fields = evsel->tp_format->format.common_fields;
+	struct tep_format_field *fields        = evsel->tp_format->format.fields;
 	int ret;
 
 	ret = add_tracepoint_fields_values(cw, event_class, event,
@@ -970,7 +970,7 @@ static char *change_name(char *name, char *orig_name, int dup)
 
 static int event_class_add_field(struct bt_ctf_event_class *event_class,
 		struct bt_ctf_field_type *type,
-		struct format_field *field)
+		struct tep_format_field *field)
 {
 	struct bt_ctf_field_type *t = NULL;
 	char *name;
@@ -1009,10 +1009,10 @@ static int event_class_add_field(struct bt_ctf_event_class *event_class,
 }
 
 static int add_tracepoint_fields_types(struct ctf_writer *cw,
-				       struct format_field *fields,
+				       struct tep_format_field *fields,
 				       struct bt_ctf_event_class *event_class)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	int ret;
 
 	for (field = fields; field; field = field->next) {
@@ -1055,8 +1055,8 @@ static int add_tracepoint_types(struct ctf_writer *cw,
 				struct perf_evsel *evsel,
 				struct bt_ctf_event_class *class)
 {
-	struct format_field *common_fields = evsel->tp_format->format.common_fields;
-	struct format_field *fields        = evsel->tp_format->format.fields;
+	struct tep_format_field *common_fields = evsel->tp_format->format.common_fields;
+	struct tep_format_field *fields        = evsel->tp_format->format.fields;
 	int ret;
 
 	ret = add_tracepoint_fields_types(cw, common_fields, class);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a8d348947e99..551a44f9b014 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2656,7 +2656,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 	return 0;
 }
 
-struct format_field *perf_evsel__field(struct perf_evsel *evsel, const char *name)
+struct tep_format_field *perf_evsel__field(struct perf_evsel *evsel, const char *name)
 {
 	return tep_find_field(evsel->tp_format, name);
 }
@@ -2664,7 +2664,7 @@ struct format_field *perf_evsel__field(struct perf_evsel *evsel, const char *nam
 void *perf_evsel__rawptr(struct perf_evsel *evsel, struct perf_sample *sample,
 			 const char *name)
 {
-	struct format_field *field = perf_evsel__field(evsel, name);
+	struct tep_format_field *field = perf_evsel__field(evsel, name);
 	int offset;
 
 	if (!field)
@@ -2680,7 +2680,7 @@ void *perf_evsel__rawptr(struct perf_evsel *evsel, struct perf_sample *sample,
 	return sample->raw_data + offset;
 }
 
-u64 format_field__intval(struct format_field *field, struct perf_sample *sample,
+u64 format_field__intval(struct tep_format_field *field, struct perf_sample *sample,
 			 bool needs_swap)
 {
 	u64 value;
@@ -2722,7 +2722,7 @@ u64 format_field__intval(struct format_field *field, struct perf_sample *sample,
 u64 perf_evsel__intval(struct perf_evsel *evsel, struct perf_sample *sample,
 		       const char *name)
 {
-	struct format_field *field = perf_evsel__field(evsel, name);
+	struct tep_format_field *field = perf_evsel__field(evsel, name);
 
 	if (!field)
 		return 0;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 2a3eb5dc4ba5..fa1729c49ef3 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -296,11 +296,11 @@ static inline char *perf_evsel__strval(struct perf_evsel *evsel,
 	return perf_evsel__rawptr(evsel, sample, name);
 }
 
-struct format_field;
+struct tep_format_field;
 
-u64 format_field__intval(struct format_field *field, struct perf_sample *sample, bool needs_swap);
+u64 format_field__intval(struct tep_format_field *field, struct perf_sample *sample, bool needs_swap);
 
-struct format_field *perf_evsel__field(struct perf_evsel *evsel, const char *name);
+struct tep_format_field *perf_evsel__field(struct perf_evsel *evsel, const char *name);
 
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
diff --git a/tools/perf/util/evsel_fprintf.c b/tools/perf/util/evsel_fprintf.c
index 06dfb027879d..0d0a4c6f368b 100644
--- a/tools/perf/util/evsel_fprintf.c
+++ b/tools/perf/util/evsel_fprintf.c
@@ -73,7 +73,7 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 	}
 
 	if (details->trace_fields) {
-		struct format_field *field;
+		struct tep_format_field *field;
 
 		if (evsel->attr.type != PERF_TYPE_TRACEPOINT) {
 			printed += comma_fprintf(fp, &first, " (not a tracepoint)");
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 7629973ef6f1..cff713a4a35e 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -339,7 +339,7 @@ static bool is_tracepoint(struct pyrf_event *pevent)
 }
 
 static PyObject*
-tracepoint_field(struct pyrf_event *pe, struct format_field *field)
+tracepoint_field(struct pyrf_event *pe, struct tep_format_field *field)
 {
 	struct tep_handle *pevent = field->event->pevent;
 	void *data = pe->sample.raw_data;
@@ -382,7 +382,7 @@ get_tracepoint_field(struct pyrf_event *pevent, PyObject *attr_name)
 {
 	const char *str = _PyUnicode_AsString(PyObject_Str(attr_name));
 	struct perf_evsel *evsel = pevent->evsel;
-	struct format_field *field;
+	struct tep_format_field *field;
 
 	if (!evsel->tp_format) {
 		struct tep_event_format *tp_format;
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 370cc60f0afa..1bb0b0c685b7 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -339,7 +339,7 @@ static void perl_process_tracepoint(struct perf_sample *sample,
 {
 	struct thread *thread = al->thread;
 	struct tep_event_format *event = evsel->tp_format;
-	struct format_field *field;
+	struct tep_format_field *field;
 	static char handler[256];
 	unsigned long long val;
 	unsigned long s, ns;
@@ -538,7 +538,7 @@ static int perl_stop_script(void)
 static int perl_generate_script(struct tep_handle *pevent, const char *outfile)
 {
 	struct tep_event_format *event = NULL;
-	struct format_field *f;
+	struct tep_format_field *f;
 	char fname[PATH_MAX];
 	int not_first, count;
 	FILE *ofp;
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 9a8a7b7ff64a..dc26e58a791e 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -333,7 +333,7 @@ static void define_event_symbols(struct tep_event_format *event,
 }
 
 static PyObject *get_field_numeric_entry(struct tep_event_format *event,
-		struct format_field *field, void *data)
+		struct tep_format_field *field, void *data)
 {
 	bool is_array = field->flags & FIELD_IS_ARRAY;
 	PyObject *obj = NULL, *list = NULL;
@@ -794,7 +794,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
 	PyObject *handler, *context, *t, *obj = NULL, *callchain;
 	PyObject *dict = NULL, *all_entries_dict = NULL;
 	static char handler_name[256];
-	struct format_field *field;
+	struct tep_format_field *field;
 	unsigned long s, ns;
 	unsigned n = 0;
 	int pid;
@@ -1591,7 +1591,7 @@ static int python_stop_script(void)
 static int python_generate_script(struct tep_handle *pevent, const char *outfile)
 {
 	struct tep_event_format *event = NULL;
-	struct format_field *f;
+	struct tep_format_field *f;
 	char fname[PATH_MAX];
 	int not_first, count;
 	FILE *ofp;
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b284276ec963..5e3179d995f9 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1884,7 +1884,7 @@ static int __sort_dimension__add_hpp_output(struct sort_dimension *sd,
 struct hpp_dynamic_entry {
 	struct perf_hpp_fmt hpp;
 	struct perf_evsel *evsel;
-	struct format_field *field;
+	struct tep_format_field *field;
 	unsigned dynamic_len;
 	bool raw_trace;
 };
@@ -1915,7 +1915,7 @@ static void update_dynamic_len(struct hpp_dynamic_entry *hde,
 			       struct hist_entry *he)
 {
 	char *str, *pos;
-	struct format_field *field = hde->field;
+	struct tep_format_field *field = hde->field;
 	size_t namelen;
 	bool last = false;
 
@@ -2000,7 +2000,7 @@ static int __sort__hde_entry(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 	struct hpp_dynamic_entry *hde;
 	size_t len = fmt->user_len;
 	char *str, *pos;
-	struct format_field *field;
+	struct tep_format_field *field;
 	size_t namelen;
 	bool last = false;
 	int ret;
@@ -2060,7 +2060,7 @@ static int64_t __sort__hde_cmp(struct perf_hpp_fmt *fmt,
 			       struct hist_entry *a, struct hist_entry *b)
 {
 	struct hpp_dynamic_entry *hde;
-	struct format_field *field;
+	struct tep_format_field *field;
 	unsigned offset, size;
 
 	hde = container_of(fmt, struct hpp_dynamic_entry, hpp);
@@ -2117,7 +2117,7 @@ static void hde_free(struct perf_hpp_fmt *fmt)
 }
 
 static struct hpp_dynamic_entry *
-__alloc_dynamic_entry(struct perf_evsel *evsel, struct format_field *field,
+__alloc_dynamic_entry(struct perf_evsel *evsel, struct tep_format_field *field,
 		      int level)
 {
 	struct hpp_dynamic_entry *hde;
@@ -2252,7 +2252,7 @@ static struct perf_evsel *find_evsel(struct perf_evlist *evlist, char *event_nam
 }
 
 static int __dynamic_dimension__add(struct perf_evsel *evsel,
-				    struct format_field *field,
+				    struct tep_format_field *field,
 				    bool raw_trace, int level)
 {
 	struct hpp_dynamic_entry *hde;
@@ -2270,7 +2270,7 @@ static int __dynamic_dimension__add(struct perf_evsel *evsel,
 static int add_evsel_fields(struct perf_evsel *evsel, bool raw_trace, int level)
 {
 	int ret;
-	struct format_field *field;
+	struct tep_format_field *field;
 
 	field = evsel->tp_format->format.fields;
 	while (field) {
@@ -2305,7 +2305,7 @@ static int add_all_matching_fields(struct perf_evlist *evlist,
 {
 	int ret = -ESRCH;
 	struct perf_evsel *evsel;
-	struct format_field *field;
+	struct tep_format_field *field;
 
 	evlist__for_each_entry(evlist, evsel) {
 		if (evsel->attr.type != PERF_TYPE_TRACEPOINT)
@@ -2327,7 +2327,7 @@ static int add_dynamic_entry(struct perf_evlist *evlist, const char *tok,
 {
 	char *str, *event_name, *field_name, *opt_name;
 	struct perf_evsel *evsel;
-	struct format_field *field;
+	struct tep_format_field *field;
 	bool raw_trace = symbol_conf.raw_trace;
 	int ret = 0;
 
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 562db55422be..2ea658268767 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -34,7 +34,7 @@ static int get_common_field(struct scripting_context *context,
 {
 	struct tep_handle *pevent = context->pevent;
 	struct tep_event_format *event;
-	struct format_field *field;
+	struct tep_format_field *field;
 
 	if (!*size) {
 		if (!pevent->events)
@@ -96,7 +96,7 @@ int common_pc(struct scripting_context *context)
 unsigned long long
 raw_field_value(struct tep_event_format *event, const char *name, void *data)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	unsigned long long val;
 
 	field = tep_find_any_field(event, name);
-- 
2.17.1
