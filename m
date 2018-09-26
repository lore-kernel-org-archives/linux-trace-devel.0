Return-Path: <SRS0=XLZm=MI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730062.outbound.protection.outlook.com ([40.107.73.62]:58268
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727622AbeIZSbs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Sep 2018 14:31:48 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 03/16] tools lib traceevent, perf tools: Rename struct format{_field} to struct tep_format{_field}
Date: Wed, 26 Sep 2018 15:18:19 +0300
Message-Id: <20180926121832.16101-4-tstoyanov@vmware.com>
In-Reply-To: <20180926121832.16101-1-tstoyanov@vmware.com>
References: <20180926121832.16101-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This renames struct format to
struct tep_format and struct format_field to struct tep_format_field

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180919185722.661319373@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h           | 42 +++++------
 kernel-shark-qt/src/plugins/sched_events.h | 12 ++--
 kernel-shark/include/trace-graph.h         | 18 ++---
 kernel-shark/include/trace-view-store.h    |  6 +-
 kernel-shark/trace-dialog.c                |  2 +-
 kernel-shark/trace-filter.c                |  8 +--
 lib/trace-cmd/trace-blk-hack.c             |  2 +-
 lib/trace-cmd/trace-ftrace.c               |  2 +-
 lib/traceevent/event-parse.c               | 82 +++++++++++-----------
 lib/traceevent/parse-filter.c              |  8 +--
 plugins/plugin_blk.c                       |  2 +-
 plugins/plugin_kmem.c                      |  2 +-
 plugins/plugin_mac80211.c                  |  6 +-
 plugins/plugin_sched_switch.c              |  6 +-
 python/ctracecmd.i                         | 10 +--
 tracecmd/trace-hist.c                      | 42 +++++------
 tracecmd/trace-mem.c                       | 48 ++++++-------
 tracecmd/trace-profile.c                   | 22 +++---
 tracecmd/trace-read.c                      | 12 ++--
 tracecmd/trace-record.c                    |  2 +-
 20 files changed, 167 insertions(+), 167 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index da246bf..bda679a 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -127,8 +127,8 @@ enum format_flags {
 	FIELD_IS_SYMBOLIC	= 128,
 };
 
-struct format_field {
-	struct format_field	*next;
+struct tep_format_field {
+	struct tep_format_field	*next;
 	struct tep_event_format	*event;
 	char			*type;
 	char			*name;
@@ -140,11 +140,11 @@ struct format_field {
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
@@ -163,7 +163,7 @@ struct print_arg_bitmask {
 
 struct print_arg_field {
 	char			*name;
-	struct format_field	*field;
+	struct tep_format_field	*field;
 };
 
 struct print_flag_sym {
@@ -200,7 +200,7 @@ struct print_arg_int_array {
 };
 
 struct print_arg_dynarray {
-	struct format_field	*field;
+	struct tep_format_field	*field;
 	struct print_arg	*index;
 };
 
@@ -268,7 +268,7 @@ struct tep_event_format {
 	char			*name;
 	int			id;
 	int			flags;
-	struct format		format;
+	struct tep_format	format;
 	struct print_fmt	print_fmt;
 	char			*system;
 	tep_event_handler_func	handler;
@@ -463,9 +463,9 @@ struct tep_handle {
 
 	int flags;
 
-	struct format_field *bprint_ip_field;
-	struct format_field *bprint_fmt_field;
-	struct format_field *bprint_buf_field;
+	struct tep_format_field *bprint_ip_field;
+	struct tep_format_field *bprint_fmt_field;
+	struct tep_format_field *bprint_buf_field;
 
 	struct event_handler *handlers;
 	struct tep_function_handler *func_handlers;
@@ -595,7 +595,7 @@ enum tep_errno tep_parse_format(struct tep_handle *pevent,
 				const char *buf,
 				unsigned long size, const char *sys);
 void tep_free_format(struct tep_event_format *event);
-void tep_free_format_field(struct format_field *field);
+void tep_free_format_field(struct tep_format_field *field);
 
 void *tep_get_field_raw(struct trace_seq *s, struct tep_event_format *event,
 			const char *name, struct tep_record *record,
@@ -632,15 +632,15 @@ int tep_register_print_function(struct tep_handle *pevent,
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
@@ -665,7 +665,7 @@ struct cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char *co
 int tep_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline);
 
 void tep_print_field(struct trace_seq *s, void *data,
-		     struct format_field *field);
+		     struct tep_format_field *field);
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event_format *event);
 void tep_event_info(struct trace_seq *s, struct tep_event_format *event,
@@ -674,8 +674,8 @@ int tep_strerror(struct tep_handle *pevent, enum tep_errno errnum,
 		    char *buf, size_t buflen);
 
 struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum event_sort_type);
-struct format_field **tep_event_common_fields(struct tep_event_format *event);
-struct format_field **tep_event_fields(struct tep_event_format *event);
+struct tep_format_field **tep_event_common_fields(struct tep_event_format *event);
+struct tep_format_field **tep_event_fields(struct tep_event_format *event);
 
 static inline int tep_get_cpus(struct tep_handle *pevent)
 {
@@ -820,7 +820,7 @@ struct filter_arg_boolean {
 };
 
 struct filter_arg_field {
-	struct format_field	*field;
+	struct tep_format_field	*field;
 };
 
 struct filter_arg_value {
@@ -851,7 +851,7 @@ struct filter_arg_num {
 
 struct filter_arg_str {
 	enum filter_cmp_type	type;
-	struct format_field	*field;
+	struct tep_format_field	*field;
 	char			*val;
 	char			*buffer;
 	regex_t			reg;
diff --git a/kernel-shark-qt/src/plugins/sched_events.h b/kernel-shark-qt/src/plugins/sched_events.h
index 164619e..5a9406b 100644
--- a/kernel-shark-qt/src/plugins/sched_events.h
+++ b/kernel-shark-qt/src/plugins/sched_events.h
@@ -31,30 +31,30 @@ struct plugin_sched_context {
 	struct tep_event_format	*sched_switch_event;
 
 	/** Pointer to the sched_switch_next_field format descriptor. */
-	struct format_field	*sched_switch_next_field;
+	struct tep_format_field	*sched_switch_next_field;
 
 	/** Pointer to the sched_switch_comm_field format descriptor. */
-	struct format_field	*sched_switch_comm_field;
+	struct tep_format_field	*sched_switch_comm_field;
 
 	/** Pointer to the sched_wakeup_event object. */
 	struct tep_event_format	*sched_wakeup_event;
 
 	/** Pointer to the sched_wakeup_pid_field format descriptor. */
-	struct format_field	*sched_wakeup_pid_field;
+	struct tep_format_field	*sched_wakeup_pid_field;
 
 	/** Pointer to the sched_wakeup_success_field format descriptor. */
-	struct format_field	*sched_wakeup_success_field;
+	struct tep_format_field	*sched_wakeup_success_field;
 
 	/** Pointer to the sched_wakeup_new_event object. */
 	struct tep_event_format	*sched_wakeup_new_event;
 
 	/** Pointer to the sched_wakeup_new_pid_field format descriptor. */
-	struct format_field	*sched_wakeup_new_pid_field;
+	struct tep_format_field	*sched_wakeup_new_pid_field;
 
 	/**
 	 * Pointer to the sched_wakeup_new_success_field format descriptor.
 	 */
-	struct format_field	*sched_wakeup_new_success_field;
+	struct tep_format_field	*sched_wakeup_new_success_field;
 };
 
 int plugin_get_next_pid(struct tep_record *record);
diff --git a/kernel-shark/include/trace-graph.h b/kernel-shark/include/trace-graph.h
index 6686675..0368df2 100644
--- a/kernel-shark/include/trace-graph.h
+++ b/kernel-shark/include/trace-graph.h
@@ -220,15 +220,15 @@ struct graph_info {
 	gint			*hard_irq_exit_ids;
 	gint			*soft_irq_entry_ids;
 	gint			*soft_irq_exit_ids;
-	struct format_field	*event_prev_state;
-	struct format_field	*event_pid_field;
-	struct format_field	*event_comm_field;
-	struct format_field	*ftrace_pid_field;
-	struct format_field	*ftrace_comm_field;
-	struct format_field	*wakeup_pid_field;
-	struct format_field	*wakeup_success_field;
-	struct format_field	*wakeup_new_pid_field;
-	struct format_field	*wakeup_new_success_field;
+	struct tep_format_field	*event_prev_state;
+	struct tep_format_field	*event_pid_field;
+	struct tep_format_field	*event_comm_field;
+	struct tep_format_field	*ftrace_pid_field;
+	struct tep_format_field	*ftrace_comm_field;
+	struct tep_format_field	*wakeup_pid_field;
+	struct tep_format_field	*wakeup_success_field;
+	struct tep_format_field	*wakeup_new_pid_field;
+	struct tep_format_field	*wakeup_new_success_field;
 
 	gboolean		no_irqs;
 
diff --git a/kernel-shark/include/trace-view-store.h b/kernel-shark/include/trace-view-store.h
index f4b8013..c01619b 100644
--- a/kernel-shark/include/trace-view-store.h
+++ b/kernel-shark/include/trace-view-store.h
@@ -84,11 +84,11 @@ struct trace_view_store
 	/* Tracecmd specific info */
 	struct tracecmd_input *handle;
 	struct tep_event_format	*sched_switch_event;
-	struct format_field	*sched_switch_next_field;
+	struct tep_format_field	*sched_switch_next_field;
 	struct tep_event_format	*sched_wakeup_event;
-	struct format_field	*sched_wakeup_pid_field;
+	struct tep_format_field	*sched_wakeup_pid_field;
 	struct tep_event_format	*sched_wakeup_new_event;
-	struct format_field	*sched_wakeup_new_pid_field;
+	struct tep_format_field	*sched_wakeup_new_pid_field;
 	int			cpus;
 
 	TraceViewRecord		**cpu_list;
diff --git a/kernel-shark/trace-dialog.c b/kernel-shark/trace-dialog.c
index e81d760..ac44ee3 100644
--- a/kernel-shark/trace-dialog.c
+++ b/kernel-shark/trace-dialog.c
@@ -376,7 +376,7 @@ static void read_raw_events(struct trace_seq *s,
 			    struct tep_event_format *event,
 			    struct tep_record *record)
 {
-	struct format_field **fields;
+	struct tep_format_field **fields;
 	int i;
 
 	fields = tep_event_fields(event);
diff --git a/kernel-shark/trace-filter.c b/kernel-shark/trace-filter.c
index 29f4e4a..8296f61 100644
--- a/kernel-shark/trace-filter.c
+++ b/kernel-shark/trace-filter.c
@@ -146,8 +146,8 @@ static GtkTreeModel *create_field_combo_model(gpointer data)
 	GtkListStore *list;
 	GtkTreeIter iter;
 	struct tep_event_format **events;
-	struct format_field **fields;
-	struct format_field *field;
+	struct tep_format_field **fields;
+	struct tep_format_field *field;
 	int i;
 
 	events = tep_list_events(pevent, EVENT_SORT_SYSTEM);
@@ -179,8 +179,8 @@ static void update_field_combo(struct tep_handle *pevent,
 {
 	struct tep_event_format **events;
 	struct tep_event_format *event;
-	struct format_field **fields;
-	struct format_field *field;
+	struct tep_format_field **fields;
+	struct tep_format_field *field;
 	GtkTreeModel *model;
 	GtkListStore *list;
 	GtkTreeIter iter;
diff --git a/lib/trace-cmd/trace-blk-hack.c b/lib/trace-cmd/trace-blk-hack.c
index 79d129f..45ba77a 100644
--- a/lib/trace-cmd/trace-blk-hack.c
+++ b/lib/trace-cmd/trace-blk-hack.c
@@ -33,7 +33,7 @@ int tracecmd_blk_hack(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent;
 	struct tep_event_format *event;
-	struct format_field *field;
+	struct tep_format_field *field;
 	char buf[4096]; /* way more than enough! */
 	int id;
 	int l;
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index ffbb72d..974f8b6 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -366,7 +366,7 @@ trace_stack_handler(struct trace_seq *s, struct tep_record *record,
 		    struct tep_event_format *event, void *context)
 {
 	struct tracecmd_ftrace *finfo = context;
-	struct format_field *field;
+	struct tep_format_field *field;
 	unsigned long long addr;
 	const char *func;
 	void *data = record->data;
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index bb2ebb3..32547ab 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -1299,7 +1299,7 @@ static int event_read_id(void)
 	return -1;
 }
 
-static int field_is_string(struct format_field *field)
+static int field_is_string(struct tep_format_field *field)
 {
 	if ((field->flags & FIELD_IS_ARRAY) &&
 	    (strstr(field->type, "char") || strstr(field->type, "u8") ||
@@ -1309,7 +1309,7 @@ static int field_is_string(struct format_field *field)
 	return 0;
 }
 
-static int field_is_dynamic(struct format_field *field)
+static int field_is_dynamic(struct tep_format_field *field)
 {
 	if (strncmp(field->type, "__data_loc", 10) == 0)
 		return 1;
@@ -1317,7 +1317,7 @@ static int field_is_dynamic(struct format_field *field)
 	return 0;
 }
 
-static int field_is_long(struct format_field *field)
+static int field_is_long(struct tep_format_field *field)
 {
 	/* includes long long */
 	if (strstr(field->type, "long"))
@@ -1354,9 +1354,9 @@ static unsigned int type_size(const char *name)
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
@@ -2683,7 +2683,7 @@ out:
 static enum event_type
 process_dynamic_array(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	enum event_type type;
 	char *token;
 
@@ -2748,7 +2748,7 @@ static enum event_type
 process_dynamic_array_len(struct tep_event_format *event, struct print_arg *arg,
 			  char **tok)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	enum event_type type;
 	char *token;
 
@@ -3259,10 +3259,10 @@ static int event_read_print(struct tep_event_format *event)
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
@@ -3281,10 +3281,10 @@ tep_find_common_field(struct tep_event_format *event, const char *name)
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
@@ -3304,10 +3304,10 @@ tep_find_field(struct tep_event_format *event, const char *name)
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
@@ -3353,7 +3353,7 @@ unsigned long long tep_read_number(struct tep_handle *pevent,
  *
  * Returns 0 on success, -1 otherwise.
  */
-int tep_read_number_field(struct format_field *field, const void *data,
+int tep_read_number_field(struct tep_format_field *field, const void *data,
 			  unsigned long long *value)
 {
 	if (!field)
@@ -3375,7 +3375,7 @@ static int get_common_info(struct tep_handle *pevent,
 			   const char *type, int *offset, int *size)
 {
 	struct tep_event_format *event;
-	struct format_field *field;
+	struct tep_format_field *field;
 
 	/*
 	 * All events should have the same common elements.
@@ -3867,7 +3867,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 {
 	struct tep_handle *pevent = event->pevent;
 	struct print_flag_sym *flag;
-	struct format_field *field;
+	struct tep_format_field *field;
 	struct printk_map *printk;
 	long long val, fval;
 	unsigned long long addr;
@@ -4008,7 +4008,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 
 		if (arg->int_array.field->type == PRINT_DYNAMIC_ARRAY) {
 			unsigned long offset;
-			struct format_field *field =
+			struct tep_format_field *field =
 				arg->int_array.field->dynarray.field;
 			offset = tep_read_number(pevent,
 						 data + field->offset,
@@ -4056,7 +4056,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		int str_offset;
 
 		if (arg->string.offset == -1) {
-			struct format_field *f;
+			struct tep_format_field *f;
 
 			f = tep_find_any_field(event, arg->string.string);
 			arg->string.offset = f->offset;
@@ -4074,7 +4074,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		int bitmask_size;
 
 		if (arg->bitmask.offset == -1) {
-			struct format_field *f;
+			struct tep_format_field *f;
 
 			f = tep_find_any_field(event, arg->bitmask.bitmask);
 			arg->bitmask.offset = f->offset;
@@ -4215,7 +4215,7 @@ static void free_args(struct print_arg *args)
 static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struct tep_event_format *event)
 {
 	struct tep_handle *pevent = event->pevent;
-	struct format_field *field, *ip_field;
+	struct tep_format_field *field, *ip_field;
 	struct print_arg *args, *arg, **next;
 	unsigned long long ip, val;
 	char *ptr;
@@ -4393,7 +4393,7 @@ get_bprint_format(void *data, int size __maybe_unused,
 {
 	struct tep_handle *pevent = event->pevent;
 	unsigned long long addr;
-	struct format_field *field;
+	struct tep_format_field *field;
 	struct printk_map *printk;
 	char *format;
 
@@ -4788,7 +4788,7 @@ static int is_printable_array(char *p, unsigned int len)
 }
 
 void tep_print_field(struct trace_seq *s, void *data,
-		     struct format_field *field)
+		     struct tep_format_field *field)
 {
 	unsigned long long val;
 	unsigned int offset, len, i;
@@ -4855,7 +4855,7 @@ void tep_print_field(struct trace_seq *s, void *data,
 void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event_format *event)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 
 	field = event->format.fields;
 	while (field) {
@@ -5664,12 +5664,12 @@ struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum event_
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
@@ -5702,7 +5702,7 @@ get_event_fields(const char *type, const char *name,
  * Returns an allocated array of fields. The last item in the array is NULL.
  * The array must be freed with free().
  */
-struct format_field **tep_event_common_fields(struct tep_event_format *event)
+struct tep_format_field **tep_event_common_fields(struct tep_event_format *event)
 {
 	return get_event_fields("common", event->name,
 				event->format.nr_common,
@@ -5716,7 +5716,7 @@ struct format_field **tep_event_common_fields(struct tep_event_format *event)
  * Returns an allocated array of fields. The last item in the array is NULL.
  * The array must be freed with free().
  */
-struct format_field **tep_event_fields(struct tep_event_format *event)
+struct tep_format_field **tep_event_fields(struct tep_event_format *event)
 {
 	return get_event_fields("event", event->name,
 				event->format.nr_fields,
@@ -6090,7 +6090,7 @@ enum tep_errno __tep_parse_format(struct tep_event_format **eventp,
 	}
 
 	if (!ret && (event->flags & EVENT_FL_ISFTRACE)) {
-		struct format_field *field;
+		struct tep_format_field *field;
 		struct print_arg *arg, **list;
 
 		/* old ftrace had no args */
@@ -6230,7 +6230,7 @@ int tep_strerror(struct tep_handle *pevent __maybe_unused,
 	return 0;
 }
 
-int get_field_val(struct trace_seq *s, struct format_field *field,
+int get_field_val(struct trace_seq *s, struct tep_format_field *field,
 		  const char *name, struct tep_record *record,
 		  unsigned long long *val, int err)
 {
@@ -6267,7 +6267,7 @@ void *tep_get_field_raw(struct trace_seq *s, struct tep_event_format *event,
 			const char *name, struct tep_record *record,
 			int *len, int err)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	void *data = record->data;
 	unsigned offset;
 	int dummy;
@@ -6314,7 +6314,7 @@ int tep_get_field_val(struct trace_seq *s, struct tep_event_format *event,
 		      const char *name, struct tep_record *record,
 		      unsigned long long *val, int err)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 
 	if (!event)
 		return -1;
@@ -6339,7 +6339,7 @@ int tep_get_common_field_val(struct trace_seq *s, struct tep_event_format *event
 			     const char *name, struct tep_record *record,
 			     unsigned long long *val, int err)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 
 	if (!event)
 		return -1;
@@ -6364,7 +6364,7 @@ int tep_get_any_field_val(struct trace_seq *s, struct tep_event_format *event,
 			  const char *name, struct tep_record *record,
 			  unsigned long long *val, int err)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 
 	if (!event)
 		return -1;
@@ -6389,7 +6389,7 @@ int tep_print_num_field(struct trace_seq *s, const char *fmt,
 			struct tep_event_format *event, const char *name,
 			struct tep_record *record, int err)
 {
-	struct format_field *field = tep_find_field(event, name);
+	struct tep_format_field *field = tep_find_field(event, name);
 	unsigned long long val;
 
 	if (!field)
@@ -6421,7 +6421,7 @@ int tep_print_func_field(struct trace_seq *s, const char *fmt,
 			 struct tep_event_format *event, const char *name,
 			 struct tep_record *record, int err)
 {
-	struct format_field *field = tep_find_field(event, name);
+	struct tep_format_field *field = tep_find_field(event, name);
 	struct tep_handle *pevent = event->pevent;
 	unsigned long long val;
 	struct func_map *func;
@@ -6758,7 +6758,7 @@ void tep_ref(struct tep_handle *pevent)
 	pevent->ref_count++;
 }
 
-void tep_free_format_field(struct format_field *field)
+void tep_free_format_field(struct tep_format_field *field)
 {
 	free(field->type);
 	if (field->alias != field->name)
@@ -6767,9 +6767,9 @@ void tep_free_format_field(struct format_field *field)
 	free(field);
 }
 
-static void free_format_fields(struct format_field *field)
+static void free_format_fields(struct tep_format_field *field)
 {
-	struct format_field *next;
+	struct tep_format_field *next;
 
 	while (field) {
 		next = field->next;
@@ -6778,7 +6778,7 @@ static void free_format_fields(struct format_field *field)
 	}
 }
 
-static void free_formats(struct format *format)
+static void free_formats(struct tep_format *format)
 {
 	free_format_fields(format->common_fields);
 	free_format_fields(format->fields);
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index 5572756..a0353f2 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -16,11 +16,11 @@
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
 
@@ -336,7 +336,7 @@ static enum tep_errno
 create_arg_item(struct tep_event_format *event, const char *token,
 		enum event_type type, struct filter_arg **parg, char *error_str)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	struct filter_arg *arg;
 
 	arg = allocate_arg();
@@ -1698,7 +1698,7 @@ get_comm(struct tep_event_format *event, struct tep_record *record)
 
 static unsigned long long
 get_value(struct tep_event_format *event,
-	  struct format_field *field, struct tep_record *record)
+	  struct tep_format_field *field, struct tep_record *record)
 {
 	unsigned long long val;
 
diff --git a/plugins/plugin_blk.c b/plugins/plugin_blk.c
index 2bc0fce..60e5ff6 100644
--- a/plugins/plugin_blk.c
+++ b/plugins/plugin_blk.c
@@ -281,7 +281,7 @@ static const struct {
 static int blktrace_handler(struct trace_seq *s, struct tep_record *record,
 			    struct tep_event_format *event, void *context)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	unsigned long long val;
 	void *data = record->data;
 	struct blk_data blk_data;
diff --git a/plugins/plugin_kmem.c b/plugins/plugin_kmem.c
index c45e43c..8703c32 100644
--- a/plugins/plugin_kmem.c
+++ b/plugins/plugin_kmem.c
@@ -12,7 +12,7 @@
 static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 			     struct tep_event_format *event, void *context)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	unsigned long long val, addr;
 	void *data = record->data;
 	const char *func;
diff --git a/plugins/plugin_mac80211.c b/plugins/plugin_mac80211.c
index 8bef87d..8bad2f0 100644
--- a/plugins/plugin_mac80211.c
+++ b/plugins/plugin_mac80211.c
@@ -14,7 +14,7 @@
 static void print_string(struct trace_seq *s, struct tep_event_format *event,
 			 const char *name, const void *data)
 {
-	struct format_field *f = tep_find_field(event, name);
+	struct tep_format_field *f = tep_find_field(event, name);
 	int offset;
 	int length;
 
@@ -48,7 +48,7 @@ static void _print_enum(struct trace_seq *s, struct tep_event_format *event,
 			const char *name, const void *data,
 			const struct value_name *names, int n_names)
 {
-	struct format_field *f = tep_find_field(event, name);
+	struct tep_format_field *f = tep_find_field(event, name);
 	unsigned long long val;
 	int i;
 
@@ -81,7 +81,7 @@ static void _print_flag(struct trace_seq *s, struct tep_event_format *event,
 			const char *name, const void *data,
 			const struct value_name *names, int n_names)
 {
-	struct format_field *f = tep_find_field(event, name);
+	struct tep_format_field *f = tep_find_field(event, name);
 	unsigned long long val;
 	int i, j, found, first = 1;
 
diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index 782712d..485c0b3 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -30,7 +30,7 @@ static void write_state(struct trace_seq *s, int val)
 		trace_seq_putc(s, 'R');
 }
 
-static void write_and_save_comm(struct format_field *field,
+static void write_and_save_comm(struct tep_format_field *field,
 				struct tep_record *record,
 				struct trace_seq *s, int pid)
 {
@@ -53,7 +53,7 @@ static void write_and_save_comm(struct format_field *field,
 static int sched_wakeup_handler(struct trace_seq *s, struct tep_record *record,
 				struct tep_event_format *event, void *context)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	unsigned long long val;
 
 	if (tep_get_field_val(s, event, "pid", record, &val, 1))
@@ -81,7 +81,7 @@ static int sched_wakeup_handler(struct trace_seq *s, struct tep_record *record,
 static int sched_switch_handler(struct trace_seq *s, struct tep_record *record,
 				struct tep_event_format *event, void *context)
 {
-	struct format_field *field;
+	struct tep_format_field *field;
 	unsigned long long val;
 
 	if (tep_get_field_val(s, event, "prev_pid", record, &val, 1))
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index 4505649..fae521e 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -8,7 +8,7 @@
 
 %apply Pointer NONNULL { struct tracecmd_input *handle };
 %apply Pointer NONNULL { struct tep_handle *pevent };
-%apply Pointer NONNULL { struct format_field * };
+%apply Pointer NONNULL { struct tep_format_field * };
 %apply unsigned long long *OUTPUT {unsigned long long *}
 %apply int *OUTPUT {int *}
 
@@ -86,7 +86,7 @@ static PyObject *py_field_get_stack(struct tep_handle *pevent,
 				    int long_size)
 {
 	PyObject *list;
-	struct format_field *field;
+	struct tep_format_field *field;
 	void *data = record->data;
 	const char *func = NULL;
 	unsigned long addr;
@@ -117,7 +117,7 @@ static PyObject *py_field_get_stack(struct tep_handle *pevent,
 	return list;
 }
 
-static PyObject *py_field_get_data(struct format_field *f, struct tep_record *r)
+static PyObject *py_field_get_data(struct tep_format_field *f, struct tep_record *r)
 {
 	if (!strncmp(f->type, "__data_loc ", 11)) {
 		unsigned long long val;
@@ -143,7 +143,7 @@ static PyObject *py_field_get_data(struct format_field *f, struct tep_record *r)
 	return PyBuffer_FromMemory((char *)r->data + f->offset, f->size);
 }
 
-static PyObject *py_field_get_str(struct format_field *f, struct tep_record *r)
+static PyObject *py_field_get_str(struct tep_format_field *f, struct tep_record *r)
 {
 	if (!strncmp(f->type, "__data_loc ", 11)) {
 		unsigned long long val;
@@ -172,7 +172,7 @@ static PyObject *py_field_get_str(struct format_field *f, struct tep_record *r)
 static PyObject *py_format_get_keys(struct tep_event_format *ef)
 {
 	PyObject *list;
-	struct format_field *f;
+	struct tep_format_field *f;
 
 	list = PyList_New(0);
 
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index 93d68cd..6378fc0 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -27,26 +27,26 @@ static int kernel_stack_type;
 
 static int long_size;
 
-struct format_field *common_type_field;
-struct format_field *common_pid_field;
-struct format_field *sched_wakeup_comm_field;
-struct format_field *sched_wakeup_new_comm_field;
-struct format_field *sched_wakeup_pid_field;
-struct format_field *sched_wakeup_new_pid_field;
-struct format_field *sched_switch_prev_field;
-struct format_field *sched_switch_next_field;
-struct format_field *sched_switch_prev_pid_field;
-struct format_field *sched_switch_next_pid_field;
-struct format_field *function_ip_field;
-struct format_field *function_parent_ip_field;
-struct format_field *function_graph_entry_func_field;
-struct format_field *function_graph_entry_depth_field;
-struct format_field *function_graph_exit_func_field;
-struct format_field *function_graph_exit_depth_field;
-struct format_field *function_graph_exit_calltime_field;
-struct format_field *function_graph_exit_rettime_field;
-struct format_field *function_graph_exit_overrun_field;
-struct format_field *kernel_stack_caller_field;
+struct tep_format_field *common_type_field;
+struct tep_format_field *common_pid_field;
+struct tep_format_field *sched_wakeup_comm_field;
+struct tep_format_field *sched_wakeup_new_comm_field;
+struct tep_format_field *sched_wakeup_pid_field;
+struct tep_format_field *sched_wakeup_new_pid_field;
+struct tep_format_field *sched_switch_prev_field;
+struct tep_format_field *sched_switch_next_field;
+struct tep_format_field *sched_switch_prev_pid_field;
+struct tep_format_field *sched_switch_next_pid_field;
+struct tep_format_field *function_ip_field;
+struct tep_format_field *function_parent_ip_field;
+struct tep_format_field *function_graph_entry_func_field;
+struct tep_format_field *function_graph_entry_depth_field;
+struct tep_format_field *function_graph_exit_func_field;
+struct tep_format_field *function_graph_exit_depth_field;
+struct tep_format_field *function_graph_exit_calltime_field;
+struct tep_format_field *function_graph_exit_rettime_field;
+struct tep_format_field *function_graph_exit_overrun_field;
+struct tep_format_field *kernel_stack_caller_field;
 
 static int compact;
 
@@ -412,7 +412,7 @@ static void copy_stack_to_pending(int pid)
 static void
 process_kernel_stack(struct tep_handle *pevent, struct tep_record *record)
 {
-	struct format_field *field = kernel_stack_caller_field;
+	struct tep_format_field *field = kernel_stack_caller_field;
 	unsigned long long val;
 	void *data = record->data;
 	int do_restore = 0;
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index 1dcc1af..8c0286b 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -30,31 +30,31 @@ static int kmem_cache_alloc_type;
 static int kmem_cache_alloc_node_type;
 static int kmem_cache_free_type;
 
-struct format_field *common_type_field;
+struct tep_format_field *common_type_field;
 
-struct format_field *kmalloc_callsite_field;
-struct format_field *kmalloc_bytes_req_field;
-struct format_field *kmalloc_bytes_alloc_field;
-struct format_field *kmalloc_ptr_field;
+struct tep_format_field *kmalloc_callsite_field;
+struct tep_format_field *kmalloc_bytes_req_field;
+struct tep_format_field *kmalloc_bytes_alloc_field;
+struct tep_format_field *kmalloc_ptr_field;
 
-struct format_field *kmalloc_node_callsite_field;
-struct format_field *kmalloc_node_bytes_req_field;
-struct format_field *kmalloc_node_bytes_alloc_field;
-struct format_field *kmalloc_node_ptr_field;
+struct tep_format_field *kmalloc_node_callsite_field;
+struct tep_format_field *kmalloc_node_bytes_req_field;
+struct tep_format_field *kmalloc_node_bytes_alloc_field;
+struct tep_format_field *kmalloc_node_ptr_field;
 
-struct format_field *kfree_ptr_field;
+struct tep_format_field *kfree_ptr_field;
 
-struct format_field *kmem_cache_callsite_field;
-struct format_field *kmem_cache_bytes_req_field;
-struct format_field *kmem_cache_bytes_alloc_field;
-struct format_field *kmem_cache_ptr_field;
+struct tep_format_field *kmem_cache_callsite_field;
+struct tep_format_field *kmem_cache_bytes_req_field;
+struct tep_format_field *kmem_cache_bytes_alloc_field;
+struct tep_format_field *kmem_cache_ptr_field;
 
-struct format_field *kmem_cache_node_callsite_field;
-struct format_field *kmem_cache_node_bytes_req_field;
-struct format_field *kmem_cache_node_bytes_alloc_field;
-struct format_field *kmem_cache_node_ptr_field;
+struct tep_format_field *kmem_cache_node_callsite_field;
+struct tep_format_field *kmem_cache_node_bytes_req_field;
+struct tep_format_field *kmem_cache_node_bytes_alloc_field;
+struct tep_format_field *kmem_cache_node_ptr_field;
 
-struct format_field *kmem_cache_free_ptr_field;
+struct tep_format_field *kmem_cache_free_ptr_field;
 
 static void *zalloc(size_t size)
 {
@@ -328,10 +328,10 @@ static void remove_kmalloc(unsigned long long ptr)
 
 static void
 process_kmalloc(struct tep_handle *pevent, struct tep_record *record,
-		struct format_field *callsite_field,
-		struct format_field *bytes_req_field,
-		struct format_field *bytes_alloc_field,
-		struct format_field *ptr_field)
+		struct tep_format_field *callsite_field,
+		struct tep_format_field *bytes_req_field,
+		struct tep_format_field *bytes_alloc_field,
+		struct tep_format_field *ptr_field)
 {
 	unsigned long long callsite;
 	unsigned long long val;
@@ -354,7 +354,7 @@ process_kmalloc(struct tep_handle *pevent, struct tep_record *record,
 
 static void
 process_kfree(struct tep_handle *pevent, struct tep_record *record,
-	      struct format_field *ptr_field)
+	      struct tep_format_field *ptr_field)
 {
 	unsigned long long ptr;
 
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index 81753f6..cf9242e 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -76,10 +76,10 @@ struct event_data {
 	struct event_data	*end;
 	struct event_data	*start;
 
-	struct format_field	*pid_field;
-	struct format_field	*start_match_field;	/* match with start */
-	struct format_field	*end_match_field;	/* match with end */
-	struct format_field	*data_field;	/* optional */
+	struct tep_format_field	*pid_field;
+	struct tep_format_field	*start_match_field;	/* match with start */
+	struct tep_format_field	*end_match_field;	/* match with end */
+	struct tep_format_field	*data_field;	/* optional */
 
 	event_data_print	print_func;
 	handle_event_func	handle_event;
@@ -168,7 +168,7 @@ struct cpu_info {
 };
 
 struct sched_switch_data {
-	struct format_field	*prev_state;
+	struct tep_format_field	*prev_state;
 	int			match_state;
 };
 
@@ -182,10 +182,10 @@ struct handle_data {
 
 	struct cpu_info		**cpu_data;
 
-	struct format_field	*common_pid;
-	struct format_field	*wakeup_comm;
-	struct format_field	*switch_prev_comm;
-	struct format_field	*switch_next_comm;
+	struct tep_format_field	*common_pid;
+	struct tep_format_field	*wakeup_comm;
+	struct tep_format_field	*switch_prev_comm;
+	struct tep_format_field	*switch_next_comm;
 
 	struct sched_switch_data sched_switch_blocked;
 	struct sched_switch_data sched_switch_preempt;
@@ -531,7 +531,7 @@ static int match_group(struct trace_hash_item *item, void *data)
 
 
 static void
-add_task_comm(struct task_data *task, struct format_field *field,
+add_task_comm(struct task_data *task, struct tep_format_field *field,
 	      struct tep_record *record)
 {
 	const char *comm;
@@ -1269,7 +1269,7 @@ void trace_init_profile(struct tracecmd_input *handle, struct hook_list *hook,
 {
 	struct tep_handle *pevent = tracecmd_get_pevent(handle);
 	struct tep_event_format **events;
-	struct format_field **fields;
+	struct tep_format_field **fields;
 	struct handle_data *h;
 	struct event_data *event_data;
 	struct event_data *sched_switch;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 173da3a..60efe09 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -100,12 +100,12 @@ static int no_softirqs;
 
 static int tsdiff;
 
-static struct format_field *wakeup_task;
-static struct format_field *wakeup_success;
-static struct format_field *wakeup_new_task;
-static struct format_field *wakeup_new_success;
-static struct format_field *sched_task;
-static struct format_field *sched_prio;
+static struct tep_format_field *wakeup_task;
+static struct tep_format_field *wakeup_success;
+static struct tep_format_field *wakeup_new_task;
+static struct tep_format_field *wakeup_new_success;
+static struct tep_format_field *sched_task;
+static struct tep_format_field *sched_prio;
 
 static unsigned long long total_wakeup_lat;
 static unsigned long wakeup_lat_count;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 0418db2..c006306 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3347,7 +3347,7 @@ static unsigned long long
 find_ts_in_page(struct tep_handle *pevent, void *page, int size)
 {
 	struct tep_event_format *event;
-	struct format_field *field;
+	struct tep_format_field *field;
 	struct tep_record *last_record = NULL;
 	struct tep_record *record;
 	unsigned long long ts = 0;
-- 
2.17.1
