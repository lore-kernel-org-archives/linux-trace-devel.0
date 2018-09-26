Return-Path: <SRS0=XLZm=MI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730058.outbound.protection.outlook.com ([40.107.73.58]:63673
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727672AbeIZSbs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Sep 2018 14:31:48 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 02/16] tools lib traceevent, perf tools: Rename struct event_format to struct tep_event_format
Date: Wed, 26 Sep 2018 15:18:18 +0300
Message-Id: <20180926121832.16101-3-tstoyanov@vmware.com>
In-Reply-To: <20180926121832.16101-1-tstoyanov@vmware.com>
References: <20180926121832.16101-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This renames struct event_format
to struct tep_event_format

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180919185722.495820809@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/trace-cmd/trace-cmd.h              |   2 +-
 include/traceevent/event-parse.h           |  64 +++----
 kernel-shark-qt/examples/datafilter.c      |   2 +-
 kernel-shark-qt/src/libkshark-configio.c   |   4 +-
 kernel-shark-qt/src/libkshark.c            |   4 +-
 kernel-shark-qt/src/plugins/sched_events.c |   2 +-
 kernel-shark-qt/src/plugins/sched_events.h |   6 +-
 kernel-shark/include/trace-view-store.h    |   6 +-
 kernel-shark/trace-capture.c               |   6 +-
 kernel-shark/trace-dialog.c                |   4 +-
 kernel-shark/trace-filter.c                |  24 +--
 kernel-shark/trace-graph.c                 |   8 +-
 kernel-shark/trace-plot-cpu.c              |   4 +-
 kernel-shark/trace-plot-task.c             |   4 +-
 kernel-shark/trace-view-store.c            |   2 +-
 lib/trace-cmd/trace-blk-hack.c             |   2 +-
 lib/trace-cmd/trace-ftrace.c               |  16 +-
 lib/traceevent/event-parse.c               | 186 ++++++++++-----------
 lib/traceevent/parse-filter.c              |  42 ++---
 plugins/plugin_blk.c                       |   4 +-
 plugins/plugin_function.c                  |   2 +-
 plugins/plugin_futex.c                     |   2 +-
 plugins/plugin_hrtimer.c                   |   4 +-
 plugins/plugin_kmem.c                      |   2 +-
 plugins/plugin_kvm.c                       |  14 +-
 plugins/plugin_mac80211.c                  |  10 +-
 plugins/plugin_sched_switch.c              |   4 +-
 plugins/plugin_tlb.c                       |   2 +-
 python/ctracecmd.i                         |  10 +-
 tracecmd/trace-hist.c                      |  22 +--
 tracecmd/trace-mem.c                       |  18 +-
 tracecmd/trace-profile.c                   |  10 +-
 tracecmd/trace-read.c                      |  16 +-
 tracecmd/trace-record.c                    |   2 +-
 34 files changed, 255 insertions(+), 255 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 1f5ef81..f1c5703 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -90,7 +90,7 @@ enum {
 
 struct tracecmd_ftrace {
 	struct tracecmd_input		*handle;
-	struct event_format *fgraph_ret_event;
+	struct tep_event_format *fgraph_ret_event;
 	int fgraph_ret_id;
 	int long_size;
 };
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 3b6d16d..da246bf 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -40,14 +40,14 @@ struct tep_record {
 #endif
 };
 
-/* ----------------------- pevent ----------------------- */
+/* ----------------------- tep ----------------------- */
 
 struct tep_handle;
-struct event_format;
+struct tep_event_format;
 
 typedef int (*tep_event_handler_func)(struct trace_seq *s,
 				      struct tep_record *record,
-				      struct event_format *event,
+				      struct tep_event_format *event,
 				      void *context);
 
 typedef int (*tep_plugin_load_func)(struct tep_handle *pevent);
@@ -129,7 +129,7 @@ enum format_flags {
 
 struct format_field {
 	struct format_field	*next;
-	struct event_format	*event;
+	struct tep_event_format	*event;
 	char			*type;
 	char			*name;
 	char			*alias;
@@ -263,7 +263,7 @@ struct print_fmt {
 	struct print_arg	*args;
 };
 
-struct event_format {
+struct tep_event_format {
 	struct tep_handle	*pevent;
 	char			*name;
 	int			id;
@@ -437,9 +437,9 @@ struct tep_handle {
 	unsigned int printk_count;
 
 
-	struct event_format **events;
+	struct tep_event_format **events;
 	int nr_events;
-	struct event_format **sort_events;
+	struct tep_event_format **sort_events;
 	enum event_sort_type last_type;
 
 	int type_offset;
@@ -473,7 +473,7 @@ struct tep_handle {
 	int parsing_failures;
 
 	/* cache */
-	struct event_format *last_event;
+	struct tep_event_format *last_event;
 
 	char *trace_clock;
 };
@@ -573,14 +573,14 @@ int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
 int tep_pid_is_registered(struct tep_handle *pevent, int pid);
 
 void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
-			  struct event_format *event,
+			  struct tep_event_format *event,
 			  struct tep_record *record);
 void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
-			  struct event_format *event,
+			  struct tep_event_format *event,
 			  struct tep_record *record,
 			  bool use_trace_clock);
 void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
-			  struct event_format *event,
+			  struct tep_event_format *event,
 			  struct tep_record *record);
 void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
 		     struct tep_record *record, bool use_trace_clock);
@@ -591,32 +591,32 @@ int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long si
 enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
 			       unsigned long size, const char *sys);
 enum tep_errno tep_parse_format(struct tep_handle *pevent,
-				struct event_format **eventp,
+				struct tep_event_format **eventp,
 				const char *buf,
 				unsigned long size, const char *sys);
-void tep_free_format(struct event_format *event);
+void tep_free_format(struct tep_event_format *event);
 void tep_free_format_field(struct format_field *field);
 
-void *tep_get_field_raw(struct trace_seq *s, struct event_format *event,
+void *tep_get_field_raw(struct trace_seq *s, struct tep_event_format *event,
 			const char *name, struct tep_record *record,
 			int *len, int err);
 
-int tep_get_field_val(struct trace_seq *s, struct event_format *event,
+int tep_get_field_val(struct trace_seq *s, struct tep_event_format *event,
 		      const char *name, struct tep_record *record,
 		      unsigned long long *val, int err);
-int tep_get_common_field_val(struct trace_seq *s, struct event_format *event,
+int tep_get_common_field_val(struct trace_seq *s, struct tep_event_format *event,
 			     const char *name, struct tep_record *record,
 			     unsigned long long *val, int err);
-int tep_get_any_field_val(struct trace_seq *s, struct event_format *event,
+int tep_get_any_field_val(struct trace_seq *s, struct tep_event_format *event,
 			  const char *name, struct tep_record *record,
 			  unsigned long long *val, int err);
 
 int tep_print_num_field(struct trace_seq *s, const char *fmt,
-			   struct event_format *event, const char *name,
+			   struct tep_event_format *event, const char *name,
 			   struct tep_record *record, int err);
 
 int tep_print_func_field(struct trace_seq *s, const char *fmt,
-			 struct event_format *event, const char *name,
+			 struct tep_event_format *event, const char *name,
 			 struct tep_record *record, int err);
 
 int tep_register_event_handler(struct tep_handle *pevent, int id,
@@ -632,9 +632,9 @@ int tep_register_print_function(struct tep_handle *pevent,
 int tep_unregister_print_function(struct tep_handle *pevent,
 				  tep_func_handler func, char *name);
 
-struct format_field *tep_find_common_field(struct event_format *event, const char *name);
-struct format_field *tep_find_field(struct event_format *event, const char *name);
-struct format_field *tep_find_any_field(struct event_format *event, const char *name);
+struct format_field *tep_find_common_field(struct tep_event_format *event, const char *name);
+struct format_field *tep_find_field(struct tep_event_format *event, const char *name);
+struct format_field *tep_find_any_field(struct tep_event_format *event, const char *name);
 
 const char *tep_find_function(struct tep_handle *pevent, unsigned long long addr);
 unsigned long long
@@ -643,18 +643,18 @@ unsigned long long tep_read_number(struct tep_handle *pevent, const void *ptr, i
 int tep_read_number_field(struct format_field *field, const void *data,
 			  unsigned long long *value);
 
-struct event_format *tep_find_event(struct tep_handle *pevent, int id);
+struct tep_event_format *tep_find_event(struct tep_handle *pevent, int id);
 
-struct event_format *
+struct tep_event_format *
 tep_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *name);
 
-struct event_format *
+struct tep_event_format *
 tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
 
 void tep_data_lat_fmt(struct tep_handle *pevent,
 		      struct trace_seq *s, struct tep_record *record);
 int tep_data_type(struct tep_handle *pevent, struct tep_record *rec);
-struct event_format *tep_data_event_from_type(struct tep_handle *pevent, int type);
+struct tep_event_format *tep_data_event_from_type(struct tep_handle *pevent, int type);
 int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_flags(struct tep_handle *pevent, struct tep_record *rec);
@@ -667,15 +667,15 @@ int tep_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline);
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct format_field *field);
 void tep_print_fields(struct trace_seq *s, void *data,
-		      int size __maybe_unused, struct event_format *event);
-void tep_event_info(struct trace_seq *s, struct event_format *event,
+		      int size __maybe_unused, struct tep_event_format *event);
+void tep_event_info(struct trace_seq *s, struct tep_event_format *event,
 		       struct tep_record *record);
 int tep_strerror(struct tep_handle *pevent, enum tep_errno errnum,
 		    char *buf, size_t buflen);
 
-struct event_format **tep_list_events(struct tep_handle *pevent, enum event_sort_type);
-struct format_field **tep_event_common_fields(struct event_format *event);
-struct format_field **tep_event_fields(struct event_format *event);
+struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum event_sort_type);
+struct format_field **tep_event_common_fields(struct tep_event_format *event);
+struct format_field **tep_event_fields(struct tep_event_format *event);
 
 static inline int tep_get_cpus(struct tep_handle *pevent)
 {
@@ -872,7 +872,7 @@ struct filter_arg {
 
 struct filter_type {
 	int			event_id;
-	struct event_format	*event;
+	struct tep_event_format	*event;
 	struct filter_arg	*filter;
 };
 
diff --git a/kernel-shark-qt/examples/datafilter.c b/kernel-shark-qt/examples/datafilter.c
index 7129f37..08a3757 100644
--- a/kernel-shark-qt/examples/datafilter.c
+++ b/kernel-shark-qt/examples/datafilter.c
@@ -19,7 +19,7 @@ int main(int argc, char **argv)
 	struct kshark_context *kshark_ctx;
 	struct kshark_entry **data = NULL;
 	struct event_filter *adv_filter;
-	struct event_format *event;
+	struct tep_event_format *event;
 	char *entry_str;
 	bool status;
 	int *pids;
diff --git a/kernel-shark-qt/src/libkshark-configio.c b/kernel-shark-qt/src/libkshark-configio.c
index 22a0b70..8fe348b 100644
--- a/kernel-shark-qt/src/libkshark-configio.c
+++ b/kernel-shark-qt/src/libkshark-configio.c
@@ -794,7 +794,7 @@ static bool kshark_event_filter_from_json(struct tep_handle *pevent,
 {
 	json_object *jfilter, *jevent, *jsystem, *jname;
 	const char *system_str, *name_str;
-	struct event_format *event;
+	struct tep_event_format *event;
 	int i, length;
 
 	/*
@@ -1011,7 +1011,7 @@ static bool kshark_adv_filters_to_json(struct kshark_context *kshark_ctx,
 {
 	struct event_filter *adv_filter = kshark_ctx->advanced_event_filter;
 	json_object *jfilter_data, *jevent, *jsystem, *jname, *jfilter;
-	struct event_format **events;
+	struct tep_event_format **events;
 	char *str;
 	int i;
 
diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 506511d..67e809c 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -868,7 +868,7 @@ static const char *kshark_get_latency(struct tep_handle *pe,
 
 static const char *kshark_get_info(struct tep_handle *pe,
 				   struct tep_record *record,
-				   struct event_format *event)
+				   struct tep_event_format *event)
 {
 	char *pos;
 
@@ -903,7 +903,7 @@ char* kshark_dump_entry(const struct kshark_entry *entry)
 	const char *event_name, *task, *lat, *info;
 	struct kshark_context *kshark_ctx;
 	struct tep_record *data;
-	struct event_format *event;
+	struct tep_event_format *event;
 	char *temp_str, *entry_str;
 	int event_id, size = 0;
 
diff --git a/kernel-shark-qt/src/plugins/sched_events.c b/kernel-shark-qt/src/plugins/sched_events.c
index ffc8333..13f3c4a 100644
--- a/kernel-shark-qt/src/plugins/sched_events.c
+++ b/kernel-shark-qt/src/plugins/sched_events.c
@@ -26,7 +26,7 @@ struct plugin_sched_context *plugin_sched_context_handler = NULL;
 static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
 {
 	struct plugin_sched_context *plugin_ctx;
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	/* No context should exist when we initialize the plugin. */
 	assert(plugin_sched_context_handler == NULL);
diff --git a/kernel-shark-qt/src/plugins/sched_events.h b/kernel-shark-qt/src/plugins/sched_events.h
index 673f5cf..164619e 100644
--- a/kernel-shark-qt/src/plugins/sched_events.h
+++ b/kernel-shark-qt/src/plugins/sched_events.h
@@ -28,7 +28,7 @@ struct plugin_sched_context {
 	struct tep_handle	*pevent;
 
 	/** Pointer to the sched_switch_event object. */
-	struct event_format	*sched_switch_event;
+	struct tep_event_format	*sched_switch_event;
 
 	/** Pointer to the sched_switch_next_field format descriptor. */
 	struct format_field	*sched_switch_next_field;
@@ -37,7 +37,7 @@ struct plugin_sched_context {
 	struct format_field	*sched_switch_comm_field;
 
 	/** Pointer to the sched_wakeup_event object. */
-	struct event_format	*sched_wakeup_event;
+	struct tep_event_format	*sched_wakeup_event;
 
 	/** Pointer to the sched_wakeup_pid_field format descriptor. */
 	struct format_field	*sched_wakeup_pid_field;
@@ -46,7 +46,7 @@ struct plugin_sched_context {
 	struct format_field	*sched_wakeup_success_field;
 
 	/** Pointer to the sched_wakeup_new_event object. */
-	struct event_format	*sched_wakeup_new_event;
+	struct tep_event_format	*sched_wakeup_new_event;
 
 	/** Pointer to the sched_wakeup_new_pid_field format descriptor. */
 	struct format_field	*sched_wakeup_new_pid_field;
diff --git a/kernel-shark/include/trace-view-store.h b/kernel-shark/include/trace-view-store.h
index 2ab394b..f4b8013 100644
--- a/kernel-shark/include/trace-view-store.h
+++ b/kernel-shark/include/trace-view-store.h
@@ -83,11 +83,11 @@ struct trace_view_store
 
 	/* Tracecmd specific info */
 	struct tracecmd_input *handle;
-	struct event_format	*sched_switch_event;
+	struct tep_event_format	*sched_switch_event;
 	struct format_field	*sched_switch_next_field;
-	struct event_format	*sched_wakeup_event;
+	struct tep_event_format	*sched_wakeup_event;
 	struct format_field	*sched_wakeup_pid_field;
-	struct event_format	*sched_wakeup_new_event;
+	struct tep_event_format	*sched_wakeup_new_event;
 	struct format_field	*sched_wakeup_new_pid_field;
 	int			cpus;
 
diff --git a/kernel-shark/trace-capture.c b/kernel-shark/trace-capture.c
index 4bfec6a..e3e6ebc 100644
--- a/kernel-shark/trace-capture.c
+++ b/kernel-shark/trace-capture.c
@@ -349,7 +349,7 @@ static char *find_tracecmd(void)
 
 static int add_trace_cmd_words(struct trace_capture *cap, char **args)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	char **systems = cap->info->cap_systems;
 	const gchar *output;
 	int *events = cap->info->cap_events;
@@ -808,7 +808,7 @@ static int load_events(struct trace_capture *cap,
 {
 	struct shark_info *info = cap->info;
 	struct tracecmd_xml_system_node *event_node;
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct tep_handle *pevent = cap->pevent;
 	const char *name;
 	int *events = NULL;
@@ -997,7 +997,7 @@ static void save_events(struct trace_capture *cap,
 			struct tracecmd_xml_handle *handle)
 {
 	struct tep_handle *pevent = cap->pevent;
-	struct event_format *event;
+	struct tep_event_format *event;
 	char **systems = cap->info->cap_systems;
 	int *events = cap->info->cap_events;
 	int i;
diff --git a/kernel-shark/trace-dialog.c b/kernel-shark/trace-dialog.c
index 3eba62e..e81d760 100644
--- a/kernel-shark/trace-dialog.c
+++ b/kernel-shark/trace-dialog.c
@@ -373,7 +373,7 @@ GtkResponseType trace_dialog(GtkWindow *parent, enum trace_dialog_type type,
 }
 
 static void read_raw_events(struct trace_seq *s,
-			    struct event_format *event,
+			    struct tep_event_format *event,
 			    struct tep_record *record)
 {
 	struct format_field **fields;
@@ -395,7 +395,7 @@ static void read_raw_events(struct trace_seq *s,
 void trace_show_record_dialog(GtkWindow *parent, struct tep_handle *pevent,
 			      struct tep_record *record, gboolean raw)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct trace_seq s;
 	int type;
 
diff --git a/kernel-shark/trace-filter.c b/kernel-shark/trace-filter.c
index 8d78b31..29f4e4a 100644
--- a/kernel-shark/trace-filter.c
+++ b/kernel-shark/trace-filter.c
@@ -87,8 +87,8 @@ static GtkTreeModel *create_event_combo_model(gpointer data)
 	GtkTreeStore *tree;
 	GtkTreeIter sys_iter;
 	GtkTreeIter iter;
-	struct event_format **events;
-	struct event_format *event;
+	struct tep_event_format **events;
+	struct tep_event_format *event;
 	const char *last_sys = NULL;
 	int i;
 
@@ -145,7 +145,7 @@ static GtkTreeModel *create_field_combo_model(gpointer data)
 	struct tep_handle *pevent = data;
 	GtkListStore *list;
 	GtkTreeIter iter;
-	struct event_format **events;
+	struct tep_event_format **events;
 	struct format_field **fields;
 	struct format_field *field;
 	int i;
@@ -177,8 +177,8 @@ static void update_field_combo(struct tep_handle *pevent,
 			       const char *system,
 			       const char *event_name)
 {
-	struct event_format **events;
-	struct event_format *event;
+	struct tep_event_format **events;
+	struct tep_event_format *event;
 	struct format_field **fields;
 	struct format_field *field;
 	GtkTreeModel *model;
@@ -457,7 +457,7 @@ create_tree_filter_model(struct tep_handle *pevent,
 {
 	GtkTreeStore *treestore;
 	GtkTreeIter iter_events;
-	struct event_format **events;
+	struct tep_event_format **events;
 	char *str;
 	gint i;
 
@@ -1063,8 +1063,8 @@ create_tree_event_model(struct tep_handle *pevent,
 {
 	GtkTreeStore *treestore;
 	GtkTreeIter iter_all, iter_sys, iter_events;
-	struct event_format **events;
-	struct event_format *event;
+	struct tep_event_format **events;
+	struct tep_event_format *event;
 	char *last_system = NULL;
 	gboolean sysactive;
 	gboolean active, normal;
@@ -1923,8 +1923,8 @@ void trace_filter_convert_filter_to_names(struct event_filter *filter,
 					  gint **event_ids)
 {
 	struct tep_handle *pevent = filter->pevent;
-	struct event_format **events;
-	struct event_format *event;
+	struct tep_event_format **events;
+	struct tep_event_format *event;
 	char *last_system = NULL;
 	int all_selected = 1;
 	int start_sys = 0;
@@ -1986,7 +1986,7 @@ void trace_filter_convert_char_to_filter(struct event_filter *filter,
 {
 	struct tep_handle *pevent;
 	struct event_filter *copy;
-	struct event_format *event;
+	struct tep_event_format *event;
 	int i;
 
 	pevent = filter->pevent;
@@ -2019,7 +2019,7 @@ void trace_filter_convert_char_to_filter(struct event_filter *filter,
 int trace_filter_save_events(struct tracecmd_xml_handle *handle,
 			     struct event_filter *filter)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	char **systems;
 	gint *event_ids;
 	char *str;
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index 75b6df8..c591aab 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -1007,7 +1007,7 @@ int trace_graph_check_sched_wakeup(struct graph_info *ginfo,
 				   struct tep_record *record,
 				   gint *pid)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	unsigned long long val;
 	gboolean found;
 	gint id;
@@ -1074,7 +1074,7 @@ int trace_graph_check_sched_switch(struct graph_info *ginfo,
 				   gint *pid, const char **comm)
 {
 	unsigned long long val;
-	struct event_format *event;
+	struct tep_event_format *event;
 	gint this_pid;
 	gint id;
 	int ret = 1;
@@ -1153,8 +1153,8 @@ enum graph_irq_type
 trace_graph_check_irq(struct graph_info *ginfo,
 		      struct tep_record *record)
 {
-	struct event_format *event;
-	struct event_format **events;
+	struct tep_event_format *event;
+	struct tep_event_format **events;
 	gint id;
 	int i;
 
diff --git a/kernel-shark/trace-plot-cpu.c b/kernel-shark/trace-plot-cpu.c
index b2ec987..0c520f4 100644
--- a/kernel-shark/trace-plot-cpu.c
+++ b/kernel-shark/trace-plot-cpu.c
@@ -117,7 +117,7 @@ static int cpu_plot_display_last_event(struct graph_info *ginfo,
 				       unsigned long long time)
 {
 	struct cpu_plot_info *cpu_info = plot->private;
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct tep_record *record;
 	int cpu = cpu_info->cpu;
 	unsigned long long offset = 0;
@@ -353,7 +353,7 @@ int cpu_plot_display_info(struct graph_info *ginfo,
 			  unsigned long long time)
 {
 	struct cpu_plot_info *cpu_info = plot->private;
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct tep_record *record;
 	struct tep_record *next_record;
 	struct tep_handle *pevent;
diff --git a/kernel-shark/trace-plot-task.c b/kernel-shark/trace-plot-task.c
index 81ac157..c5866c4 100644
--- a/kernel-shark/trace-plot-task.c
+++ b/kernel-shark/trace-plot-task.c
@@ -240,7 +240,7 @@ static int task_plot_display_last_event(struct graph_info *ginfo,
 					unsigned long long time)
 {
 	struct task_plot_info *task_info = plot->private;
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct tep_record *record;
 	struct offset_cache *offsets;
 	gboolean is_sched;
@@ -734,7 +734,7 @@ int task_plot_display_info(struct graph_info *ginfo,
 			  unsigned long long time)
 {
 	struct task_plot_info *task_info = plot->private;
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct tep_record *record;
 	struct tep_handle *pevent;
 	unsigned long sec, usec;
diff --git a/kernel-shark/trace-view-store.c b/kernel-shark/trace-view-store.c
index a798804..9fd2d5e 100644
--- a/kernel-shark/trace-view-store.c
+++ b/kernel-shark/trace-view-store.c
@@ -406,7 +406,7 @@ trace_view_store_get_value (GtkTreeModel *tree_model,
 	TraceViewStore	*trace_view_store;
 	struct trace_seq s;
 	struct tep_handle *pevent;
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct tep_record *data;
 	const gchar *comm;
 	gchar *str;
diff --git a/lib/trace-cmd/trace-blk-hack.c b/lib/trace-cmd/trace-blk-hack.c
index dbeedab..79d129f 100644
--- a/lib/trace-cmd/trace-blk-hack.c
+++ b/lib/trace-cmd/trace-blk-hack.c
@@ -32,7 +32,7 @@ static const char blk_body[] = "\n"
 int tracecmd_blk_hack(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent;
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct format_field *field;
 	char buf[4096]; /* way more than enough! */
 	int id;
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 09fd40f..ffbb72d 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -44,7 +44,7 @@ static void find_long_size(struct tracecmd_ftrace *finfo)
 
 static int find_ret_event(struct tracecmd_ftrace *finfo, struct tep_handle *pevent)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	/* Store the func ret id and event for later use */
 	event = tep_find_event_by_name(pevent, "ftrace", "funcgraph_exit");
@@ -63,7 +63,7 @@ static int find_ret_event(struct tracecmd_ftrace *finfo, struct tep_handle *peve
 	} while (0)
 
 static int function_handler(struct trace_seq *s, struct tep_record *record,
-			    struct event_format *event, void *context)
+			    struct tep_event_format *event, void *context)
 {
 	struct tep_handle *pevent = event->pevent;
 	unsigned long long function;
@@ -187,7 +187,7 @@ static void print_graph_duration(struct trace_seq *s, unsigned long long duratio
 
 static int
 print_graph_entry_leaf(struct trace_seq *s,
-		       struct event_format *event,
+		       struct tep_event_format *event,
 		       struct tep_record *record,
 		       struct tep_record *ret_rec,
 		       struct tracecmd_ftrace *finfo)
@@ -237,7 +237,7 @@ print_graph_entry_leaf(struct trace_seq *s,
 }
 
 static int print_graph_nested(struct trace_seq *s,
-			      struct event_format *event,
+			      struct tep_event_format *event,
 			      struct tep_record *record)
 {
 	struct tep_handle *pevent = event->pevent;
@@ -278,7 +278,7 @@ static int print_graph_nested(struct trace_seq *s,
 
 static int
 fgraph_ent_handler(struct trace_seq *s, struct tep_record *record,
-		   struct event_format *event, void *context)
+		   struct tep_event_format *event, void *context)
 {
 	struct tracecmd_ftrace *finfo = context;
 	struct tep_record *rec;
@@ -312,7 +312,7 @@ fgraph_ent_handler(struct trace_seq *s, struct tep_record *record,
 
 static int
 fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
-		   struct event_format *event, void *context)
+		   struct tep_event_format *event, void *context)
 {
 	struct tracecmd_ftrace *finfo = context;
 	unsigned long long rettime, calltime;
@@ -363,7 +363,7 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 
 static int
 trace_stack_handler(struct trace_seq *s, struct tep_record *record,
-		    struct event_format *event, void *context)
+		    struct tep_event_format *event, void *context)
 {
 	struct tracecmd_ftrace *finfo = context;
 	struct format_field *field;
@@ -415,7 +415,7 @@ int tracecmd_ftrace_overrides(struct tracecmd_input *handle,
 	struct tracecmd_ftrace *finfo)
 {
 	struct tep_handle *pevent;
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	finfo->handle = handle;
 
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 70a42be..bb2ebb3 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -95,7 +95,7 @@ struct tep_function_handler {
 
 static unsigned long long
 process_defined_func(struct trace_seq *s, void *data, int size,
-		     struct event_format *event, struct print_arg *arg);
+		     struct tep_event_format *event, struct print_arg *arg);
 
 static void free_func_handle(struct tep_function_handler *func);
 
@@ -738,16 +738,16 @@ void tep_print_printk(struct tep_handle *pevent)
 	}
 }
 
-static struct event_format *alloc_event(void)
+static struct tep_event_format *alloc_event(void)
 {
-	return calloc(1, sizeof(struct event_format));
+	return calloc(1, sizeof(struct tep_event_format));
 }
 
-static int add_event(struct tep_handle *pevent, struct event_format *event)
+static int add_event(struct tep_handle *pevent, struct tep_event_format *event)
 {
 	int i;
-	struct event_format **events = realloc(pevent->events, sizeof(event) *
-					       (pevent->nr_events + 1));
+	struct tep_event_format **events = realloc(pevent->events, sizeof(event) *
+						  (pevent->nr_events + 1));
 	if (!events)
 		return -1;
 
@@ -1354,7 +1354,7 @@ static unsigned int type_size(const char *name)
 	return 0;
 }
 
-static int event_read_fields(struct event_format *event, struct format_field **fields)
+static int event_read_fields(struct tep_event_format *event, struct format_field **fields)
 {
 	struct format_field *field = NULL;
 	enum event_type type;
@@ -1641,7 +1641,7 @@ fail_expect:
 	return -1;
 }
 
-static int event_read_format(struct event_format *event)
+static int event_read_format(struct tep_event_format *event)
 {
 	char *token;
 	int ret;
@@ -1674,11 +1674,11 @@ static int event_read_format(struct event_format *event)
 }
 
 static enum event_type
-process_arg_token(struct event_format *event, struct print_arg *arg,
+process_arg_token(struct tep_event_format *event, struct print_arg *arg,
 		  char **tok, enum event_type type);
 
 static enum event_type
-process_arg(struct event_format *event, struct print_arg *arg, char **tok)
+process_arg(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	enum event_type type;
 	char *token;
@@ -1690,14 +1690,14 @@ process_arg(struct event_format *event, struct print_arg *arg, char **tok)
 }
 
 static enum event_type
-process_op(struct event_format *event, struct print_arg *arg, char **tok);
+process_op(struct tep_event_format *event, struct print_arg *arg, char **tok);
 
 /*
  * For __print_symbolic() and __print_flags, we need to completely
  * evaluate the first argument, which defines what to print next.
  */
 static enum event_type
-process_field_arg(struct event_format *event, struct print_arg *arg, char **tok)
+process_field_arg(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	enum event_type type;
 
@@ -1711,7 +1711,7 @@ process_field_arg(struct event_format *event, struct print_arg *arg, char **tok)
 }
 
 static enum event_type
-process_cond(struct event_format *event, struct print_arg *top, char **tok)
+process_cond(struct tep_event_format *event, struct print_arg *top, char **tok)
 {
 	struct print_arg *arg, *left, *right;
 	enum event_type type;
@@ -1767,7 +1767,7 @@ out_free:
 }
 
 static enum event_type
-process_array(struct event_format *event, struct print_arg *top, char **tok)
+process_array(struct tep_event_format *event, struct print_arg *top, char **tok)
 {
 	struct print_arg *arg;
 	enum event_type type;
@@ -1869,7 +1869,7 @@ static int set_op_prio(struct print_arg *arg)
 
 /* Note, *tok does not get freed, but will most likely be saved */
 static enum event_type
-process_op(struct event_format *event, struct print_arg *arg, char **tok)
+process_op(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *left, *right = NULL;
 	enum event_type type;
@@ -2070,7 +2070,7 @@ out_free:
 }
 
 static enum event_type
-process_entry(struct event_format *event __maybe_unused, struct print_arg *arg,
+process_entry(struct tep_event_format *event __maybe_unused, struct print_arg *arg,
 	      char **tok)
 {
 	enum event_type type;
@@ -2109,7 +2109,7 @@ process_entry(struct event_format *event __maybe_unused, struct print_arg *arg,
 	return EVENT_ERROR;
 }
 
-static int alloc_and_process_delim(struct event_format *event, char *next_token,
+static int alloc_and_process_delim(struct tep_event_format *event, char *next_token,
 				   struct print_arg **print_arg)
 {
 	struct print_arg *field;
@@ -2444,7 +2444,7 @@ static char *arg_eval (struct print_arg *arg)
 }
 
 static enum event_type
-process_fields(struct event_format *event, struct print_flag_sym **list, char **tok)
+process_fields(struct tep_event_format *event, struct print_flag_sym **list, char **tok)
 {
 	enum event_type type;
 	struct print_arg *arg = NULL;
@@ -2525,7 +2525,7 @@ out_free:
 }
 
 static enum event_type
-process_flags(struct event_format *event, struct print_arg *arg, char **tok)
+process_flags(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *field;
 	enum event_type type;
@@ -2578,7 +2578,7 @@ out_free:
 }
 
 static enum event_type
-process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
+process_symbols(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *field;
 	enum event_type type;
@@ -2617,7 +2617,7 @@ out_free:
 }
 
 static enum event_type
-process_hex_common(struct event_format *event, struct print_arg *arg,
+process_hex_common(struct tep_event_format *event, struct print_arg *arg,
 		   char **tok, enum print_arg_type type)
 {
 	memset(arg, 0, sizeof(*arg));
@@ -2640,20 +2640,20 @@ out:
 }
 
 static enum event_type
-process_hex(struct event_format *event, struct print_arg *arg, char **tok)
+process_hex(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	return process_hex_common(event, arg, tok, PRINT_HEX);
 }
 
 static enum event_type
-process_hex_str(struct event_format *event, struct print_arg *arg,
+process_hex_str(struct tep_event_format *event, struct print_arg *arg,
 		char **tok)
 {
 	return process_hex_common(event, arg, tok, PRINT_HEX_STR);
 }
 
 static enum event_type
-process_int_array(struct event_format *event, struct print_arg *arg, char **tok)
+process_int_array(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	memset(arg, 0, sizeof(*arg));
 	arg->type = PRINT_INT_ARRAY;
@@ -2681,7 +2681,7 @@ out:
 }
 
 static enum event_type
-process_dynamic_array(struct event_format *event, struct print_arg *arg, char **tok)
+process_dynamic_array(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	struct format_field *field;
 	enum event_type type;
@@ -2745,7 +2745,7 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
 }
 
 static enum event_type
-process_dynamic_array_len(struct event_format *event, struct print_arg *arg,
+process_dynamic_array_len(struct tep_event_format *event, struct print_arg *arg,
 			  char **tok)
 {
 	struct format_field *field;
@@ -2781,7 +2781,7 @@ process_dynamic_array_len(struct event_format *event, struct print_arg *arg,
 }
 
 static enum event_type
-process_paren(struct event_format *event, struct print_arg *arg, char **tok)
+process_paren(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *item_arg;
 	enum event_type type;
@@ -2844,7 +2844,7 @@ process_paren(struct event_format *event, struct print_arg *arg, char **tok)
 
 
 static enum event_type
-process_str(struct event_format *event __maybe_unused, struct print_arg *arg,
+process_str(struct tep_event_format *event __maybe_unused, struct print_arg *arg,
 	    char **tok)
 {
 	enum event_type type;
@@ -2873,8 +2873,8 @@ process_str(struct event_format *event __maybe_unused, struct print_arg *arg,
 }
 
 static enum event_type
-process_bitmask(struct event_format *event __maybe_unused, struct print_arg *arg,
-	    char **tok)
+process_bitmask(struct tep_event_format *event __maybe_unused, struct print_arg *arg,
+		char **tok)
 {
 	enum event_type type;
 	char *token;
@@ -2934,7 +2934,7 @@ static void remove_func_handler(struct tep_handle *pevent, char *func_name)
 }
 
 static enum event_type
-process_func_handler(struct event_format *event, struct tep_function_handler *func,
+process_func_handler(struct tep_event_format *event, struct tep_function_handler *func,
 		     struct print_arg *arg, char **tok)
 {
 	struct print_arg **next_arg;
@@ -2992,7 +2992,7 @@ err:
 }
 
 static enum event_type
-process_function(struct event_format *event, struct print_arg *arg,
+process_function(struct tep_event_format *event, struct print_arg *arg,
 		 char *token, char **tok)
 {
 	struct tep_function_handler *func;
@@ -3048,7 +3048,7 @@ process_function(struct event_format *event, struct print_arg *arg,
 }
 
 static enum event_type
-process_arg_token(struct event_format *event, struct print_arg *arg,
+process_arg_token(struct tep_event_format *event, struct print_arg *arg,
 		  char **tok, enum event_type type)
 {
 	char *token;
@@ -3136,7 +3136,7 @@ process_arg_token(struct event_format *event, struct print_arg *arg,
 	return type;
 }
 
-static int event_read_print_args(struct event_format *event, struct print_arg **list)
+static int event_read_print_args(struct tep_event_format *event, struct print_arg **list)
 {
 	enum event_type type = EVENT_ERROR;
 	struct print_arg *arg;
@@ -3194,7 +3194,7 @@ static int event_read_print_args(struct event_format *event, struct print_arg **
 	return args;
 }
 
-static int event_read_print(struct event_format *event)
+static int event_read_print(struct tep_event_format *event)
 {
 	enum event_type type;
 	char *token;
@@ -3260,7 +3260,7 @@ static int event_read_print(struct event_format *event)
  * This only searchs the common fields and not all field.
  */
 struct format_field *
-tep_find_common_field(struct event_format *event, const char *name)
+tep_find_common_field(struct tep_event_format *event, const char *name)
 {
 	struct format_field *format;
 
@@ -3282,7 +3282,7 @@ tep_find_common_field(struct event_format *event, const char *name)
  * This does not search common fields.
  */
 struct format_field *
-tep_find_field(struct event_format *event, const char *name)
+tep_find_field(struct tep_event_format *event, const char *name)
 {
 	struct format_field *format;
 
@@ -3305,7 +3305,7 @@ tep_find_field(struct event_format *event, const char *name)
  * the non-common ones if a common one was not found.
  */
 struct format_field *
-tep_find_any_field(struct event_format *event, const char *name)
+tep_find_any_field(struct tep_event_format *event, const char *name)
 {
 	struct format_field *format;
 
@@ -3374,7 +3374,7 @@ int tep_read_number_field(struct format_field *field, const void *data,
 static int get_common_info(struct tep_handle *pevent,
 			   const char *type, int *offset, int *size)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct format_field *field;
 
 	/*
@@ -3461,11 +3461,11 @@ static int events_id_cmp(const void *a, const void *b);
  *
  * Returns an event that has a given @id.
  */
-struct event_format *tep_find_event(struct tep_handle *pevent, int id)
+struct tep_event_format *tep_find_event(struct tep_handle *pevent, int id)
 {
-	struct event_format **eventptr;
-	struct event_format key;
-	struct event_format *pkey = &key;
+	struct tep_event_format **eventptr;
+	struct tep_event_format key;
+	struct tep_event_format *pkey = &key;
 
 	/* Check cache first */
 	if (pevent->last_event && pevent->last_event->id == id)
@@ -3493,11 +3493,11 @@ struct event_format *tep_find_event(struct tep_handle *pevent, int id)
  * This returns an event with a given @name and under the system
  * @sys. If @sys is NULL the first event with @name is returned.
  */
-struct event_format *
+struct tep_event_format *
 tep_find_event_by_name(struct tep_handle *pevent,
 		       const char *sys, const char *name)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	int i;
 
 	if (pevent->last_event &&
@@ -3522,7 +3522,7 @@ tep_find_event_by_name(struct tep_handle *pevent,
 }
 
 static unsigned long long
-eval_num_arg(void *data, int size, struct event_format *event, struct print_arg *arg)
+eval_num_arg(void *data, int size, struct tep_event_format *event, struct print_arg *arg)
 {
 	struct tep_handle *pevent = event->pevent;
 	unsigned long long val = 0;
@@ -3862,7 +3862,7 @@ static void print_bitmask_to_seq(struct tep_handle *pevent,
 }
 
 static void print_str_arg(struct trace_seq *s, void *data, int size,
-			  struct event_format *event, const char *format,
+			  struct tep_event_format *event, const char *format,
 			  int len_arg, struct print_arg *arg)
 {
 	struct tep_handle *pevent = event->pevent;
@@ -4117,7 +4117,7 @@ out_warning_field:
 
 static unsigned long long
 process_defined_func(struct trace_seq *s, void *data, int size,
-		     struct event_format *event, struct print_arg *arg)
+		     struct tep_event_format *event, struct print_arg *arg)
 {
 	struct tep_function_handler *func_handle = arg->func.func;
 	struct func_params *param;
@@ -4212,7 +4212,7 @@ static void free_args(struct print_arg *args)
 	}
 }
 
-static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struct event_format *event)
+static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struct tep_event_format *event)
 {
 	struct tep_handle *pevent = event->pevent;
 	struct format_field *field, *ip_field;
@@ -4389,7 +4389,7 @@ out_free:
 
 static char *
 get_bprint_format(void *data, int size __maybe_unused,
-		  struct event_format *event)
+		  struct tep_event_format *event)
 {
 	struct tep_handle *pevent = event->pevent;
 	unsigned long long addr;
@@ -4424,7 +4424,7 @@ get_bprint_format(void *data, int size __maybe_unused,
 }
 
 static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
-			  struct event_format *event, struct print_arg *arg)
+			  struct tep_event_format *event, struct print_arg *arg)
 {
 	unsigned char *buf;
 	const char *fmt = "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x";
@@ -4577,7 +4577,7 @@ static void print_ip6_addr(struct trace_seq *s, char i, unsigned char *buf)
  * %pISpc print an IP address based on sockaddr; p adds port.
  */
 static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
-			  void *data, int size, struct event_format *event,
+			  void *data, int size, struct tep_event_format *event,
 			  struct print_arg *arg)
 {
 	unsigned char *buf;
@@ -4614,7 +4614,7 @@ static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
 }
 
 static int print_ipv6_arg(struct trace_seq *s, const char *ptr, char i,
-			  void *data, int size, struct event_format *event,
+			  void *data, int size, struct tep_event_format *event,
 			  struct print_arg *arg)
 {
 	char have_c = 0;
@@ -4664,7 +4664,7 @@ static int print_ipv6_arg(struct trace_seq *s, const char *ptr, char i,
 }
 
 static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
-			  void *data, int size, struct event_format *event,
+			  void *data, int size, struct tep_event_format *event,
 			  struct print_arg *arg)
 {
 	char have_c = 0, have_p = 0;
@@ -4746,7 +4746,7 @@ static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
 }
 
 static int print_ip_arg(struct trace_seq *s, const char *ptr,
-			void *data, int size, struct event_format *event,
+			void *data, int size, struct tep_event_format *event,
 			struct print_arg *arg)
 {
 	char i = *ptr;  /* 'i' or 'I' */
@@ -4853,7 +4853,7 @@ void tep_print_field(struct trace_seq *s, void *data,
 }
 
 void tep_print_fields(struct trace_seq *s, void *data,
-		      int size __maybe_unused, struct event_format *event)
+		      int size __maybe_unused, struct tep_event_format *event)
 {
 	struct format_field *field;
 
@@ -4865,7 +4865,7 @@ void tep_print_fields(struct trace_seq *s, void *data,
 	}
 }
 
-static void pretty_print(struct trace_seq *s, void *data, int size, struct event_format *event)
+static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_event_format *event)
 {
 	struct tep_handle *pevent = event->pevent;
 	struct print_fmt *print_fmt = &event->print_fmt;
@@ -5228,7 +5228,7 @@ int tep_data_type(struct tep_handle *pevent, struct tep_record *rec)
  *
  * This returns the event form a given @type;
  */
-struct event_format *tep_data_event_from_type(struct tep_handle *pevent, int type)
+struct tep_event_format *tep_data_event_from_type(struct tep_handle *pevent, int type)
 {
 	return tep_find_event(pevent, type);
 }
@@ -5386,7 +5386,7 @@ int tep_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline)
  * This parses the raw @data using the given @event information and
  * writes the print format into the trace_seq.
  */
-void tep_event_info(struct trace_seq *s, struct event_format *event,
+void tep_event_info(struct trace_seq *s, struct tep_event_format *event,
 		    struct tep_record *record)
 {
 	int print_pretty = 1;
@@ -5427,7 +5427,7 @@ static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
  * Returns the associated event for a given record, or NULL if non is
  * is found.
  */
-struct event_format *
+struct tep_event_format *
 tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record)
 {
 	int type;
@@ -5452,7 +5452,7 @@ tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record)
  * Writes the tasks comm, pid and CPU to @s.
  */
 void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
-			  struct event_format *event,
+			  struct tep_event_format *event,
 			  struct tep_record *record)
 {
 	void *data = record->data;
@@ -5480,7 +5480,7 @@ void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
  * Writes the timestamp of the record into @s.
  */
 void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
-			  struct event_format *event,
+			  struct tep_event_format *event,
 			  struct tep_record *record,
 			  bool use_trace_clock)
 {
@@ -5530,7 +5530,7 @@ void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
  * Writes the parsing of the record's data to @s.
  */
 void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
-			  struct event_format *event,
+			  struct tep_event_format *event,
 			  struct tep_record *record)
 {
 	static const char *spaces = "                    "; /* 20 spaces */
@@ -5549,7 +5549,7 @@ void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
 		     struct tep_record *record, bool use_trace_clock)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = tep_find_event_by_record(pevent, record);
 	if (!event) {
@@ -5571,8 +5571,8 @@ void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
 
 static int events_id_cmp(const void *a, const void *b)
 {
-	struct event_format * const * ea = a;
-	struct event_format * const * eb = b;
+	struct tep_event_format * const * ea = a;
+	struct tep_event_format * const * eb = b;
 
 	if ((*ea)->id < (*eb)->id)
 		return -1;
@@ -5585,8 +5585,8 @@ static int events_id_cmp(const void *a, const void *b)
 
 static int events_name_cmp(const void *a, const void *b)
 {
-	struct event_format * const * ea = a;
-	struct event_format * const * eb = b;
+	struct tep_event_format * const * ea = a;
+	struct tep_event_format * const * eb = b;
 	int res;
 
 	res = strcmp((*ea)->name, (*eb)->name);
@@ -5602,8 +5602,8 @@ static int events_name_cmp(const void *a, const void *b)
 
 static int events_system_cmp(const void *a, const void *b)
 {
-	struct event_format * const * ea = a;
-	struct event_format * const * eb = b;
+	struct tep_event_format * const * ea = a;
+	struct tep_event_format * const * eb = b;
 	int res;
 
 	res = strcmp((*ea)->system, (*eb)->system);
@@ -5617,9 +5617,9 @@ static int events_system_cmp(const void *a, const void *b)
 	return events_id_cmp(a, b);
 }
 
-struct event_format **tep_list_events(struct tep_handle *pevent, enum event_sort_type sort_type)
+struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum event_sort_type sort_type)
 {
-	struct event_format **events;
+	struct tep_event_format **events;
 	int (*sort)(const void *a, const void *b);
 
 	events = pevent->sort_events;
@@ -5702,7 +5702,7 @@ get_event_fields(const char *type, const char *name,
  * Returns an allocated array of fields. The last item in the array is NULL.
  * The array must be freed with free().
  */
-struct format_field **tep_event_common_fields(struct event_format *event)
+struct format_field **tep_event_common_fields(struct tep_event_format *event)
 {
 	return get_event_fields("common", event->name,
 				event->format.nr_common,
@@ -5716,7 +5716,7 @@ struct format_field **tep_event_common_fields(struct event_format *event)
  * Returns an allocated array of fields. The last item in the array is NULL.
  * The array must be freed with free().
  */
-struct format_field **tep_event_fields(struct event_format *event)
+struct format_field **tep_event_fields(struct tep_event_format *event)
 {
 	return get_event_fields("event", event->name,
 				event->format.nr_fields,
@@ -5958,7 +5958,7 @@ int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long si
 	return 0;
 }
 
-static int event_matches(struct event_format *event,
+static int event_matches(struct tep_event_format *event,
 			 int id, const char *sys_name,
 			 const char *event_name)
 {
@@ -5981,7 +5981,7 @@ static void free_handler(struct event_handler *handle)
 	free(handle);
 }
 
-static int find_event_handle(struct tep_handle *pevent, struct event_format *event)
+static int find_event_handle(struct tep_handle *pevent, struct tep_event_format *event)
 {
 	struct event_handler *handle, **next;
 
@@ -6022,11 +6022,11 @@ static int find_event_handle(struct tep_handle *pevent, struct event_format *eve
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum tep_errno __tep_parse_format(struct event_format **eventp,
+enum tep_errno __tep_parse_format(struct tep_event_format **eventp,
 				  struct tep_handle *pevent, const char *buf,
 				  unsigned long size, const char *sys)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	int ret;
 
 	init_input_buf(buf, size);
@@ -6131,12 +6131,12 @@ enum tep_errno __tep_parse_format(struct event_format **eventp,
 
 static enum tep_errno
 __parse_event(struct tep_handle *pevent,
-	      struct event_format **eventp,
+	      struct tep_event_format **eventp,
 	      const char *buf, unsigned long size,
 	      const char *sys)
 {
 	int ret = __tep_parse_format(eventp, pevent, buf, size, sys);
-	struct event_format *event = *eventp;
+	struct tep_event_format *event = *eventp;
 
 	if (event == NULL)
 		return ret;
@@ -6173,7 +6173,7 @@ event_add_failed:
  * /sys/kernel/debug/tracing/events/.../.../format
  */
 enum tep_errno tep_parse_format(struct tep_handle *pevent,
-				struct event_format **eventp,
+				struct tep_event_format **eventp,
 				const char *buf,
 				unsigned long size, const char *sys)
 {
@@ -6197,7 +6197,7 @@ enum tep_errno tep_parse_format(struct tep_handle *pevent,
 enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
 			       unsigned long size, const char *sys)
 {
-	struct event_format *event = NULL;
+	struct tep_event_format *event = NULL;
 	return __parse_event(pevent, &event, buf, size, sys);
 }
 
@@ -6263,7 +6263,7 @@ int get_field_val(struct trace_seq *s, struct format_field *field,
  *
  * On failure, it returns NULL.
  */
-void *tep_get_field_raw(struct trace_seq *s, struct event_format *event,
+void *tep_get_field_raw(struct trace_seq *s, struct tep_event_format *event,
 			const char *name, struct tep_record *record,
 			int *len, int err)
 {
@@ -6310,7 +6310,7 @@ void *tep_get_field_raw(struct trace_seq *s, struct event_format *event,
  *
  * Returns 0 on success -1 on field not found.
  */
-int tep_get_field_val(struct trace_seq *s, struct event_format *event,
+int tep_get_field_val(struct trace_seq *s, struct tep_event_format *event,
 		      const char *name, struct tep_record *record,
 		      unsigned long long *val, int err)
 {
@@ -6335,7 +6335,7 @@ int tep_get_field_val(struct trace_seq *s, struct event_format *event,
  *
  * Returns 0 on success -1 on field not found.
  */
-int tep_get_common_field_val(struct trace_seq *s, struct event_format *event,
+int tep_get_common_field_val(struct trace_seq *s, struct tep_event_format *event,
 			     const char *name, struct tep_record *record,
 			     unsigned long long *val, int err)
 {
@@ -6360,7 +6360,7 @@ int tep_get_common_field_val(struct trace_seq *s, struct event_format *event,
  *
  * Returns 0 on success -1 on field not found.
  */
-int tep_get_any_field_val(struct trace_seq *s, struct event_format *event,
+int tep_get_any_field_val(struct trace_seq *s, struct tep_event_format *event,
 			  const char *name, struct tep_record *record,
 			  unsigned long long *val, int err)
 {
@@ -6386,7 +6386,7 @@ int tep_get_any_field_val(struct trace_seq *s, struct event_format *event,
  * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
  */
 int tep_print_num_field(struct trace_seq *s, const char *fmt,
-			struct event_format *event, const char *name,
+			struct tep_event_format *event, const char *name,
 			struct tep_record *record, int err)
 {
 	struct format_field *field = tep_find_field(event, name);
@@ -6418,7 +6418,7 @@ int tep_print_num_field(struct trace_seq *s, const char *fmt,
  * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
  */
 int tep_print_func_field(struct trace_seq *s, const char *fmt,
-			 struct event_format *event, const char *name,
+			 struct tep_event_format *event, const char *name,
 			 struct tep_record *record, int err)
 {
 	struct format_field *field = tep_find_field(event, name);
@@ -6578,11 +6578,11 @@ int tep_unregister_print_function(struct tep_handle *pevent,
 	return -1;
 }
 
-static struct event_format *search_event(struct tep_handle *pevent, int id,
+static struct tep_event_format *search_event(struct tep_handle *pevent, int id,
 					 const char *sys_name,
 					 const char *event_name)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	if (id >= 0) {
 		/* search by id */
@@ -6622,7 +6622,7 @@ int tep_register_event_handler(struct tep_handle *pevent, int id,
 			       const char *sys_name, const char *event_name,
 			       tep_event_handler_func func, void *context)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct event_handler *handle;
 
 	event = search_event(pevent, id, sys_name, event_name);
@@ -6706,7 +6706,7 @@ int tep_unregister_event_handler(struct tep_handle *pevent, int id,
 				 const char *sys_name, const char *event_name,
 				 tep_event_handler_func func, void *context)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct event_handler *handle;
 	struct event_handler **next;
 
@@ -6784,7 +6784,7 @@ static void free_formats(struct format *format)
 	free_format_fields(format->fields);
 }
 
-void tep_free_format(struct event_format *event)
+void tep_free_format(struct tep_event_format *event)
 {
 	free(event->name);
 	free(event->system);
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index e76154c..5572756 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -26,7 +26,7 @@ static struct format_field cpu = {
 
 struct event_list {
 	struct event_list	*next;
-	struct event_format	*event;
+	struct tep_event_format	*event;
 };
 
 static void show_error(char *error_buf, const char *fmt, ...)
@@ -228,7 +228,7 @@ static void free_arg(struct filter_arg *arg)
 }
 
 static int add_event(struct event_list **events,
-		      struct event_format *event)
+		     struct tep_event_format *event)
 {
 	struct event_list *list;
 
@@ -242,7 +242,7 @@ static int add_event(struct event_list **events,
 	return 0;
 }
 
-static int event_match(struct event_format *event,
+static int event_match(struct tep_event_format *event,
 		       regex_t *sreg, regex_t *ereg)
 {
 	if (sreg) {
@@ -258,7 +258,7 @@ static enum tep_errno
 find_event(struct tep_handle *pevent, struct event_list **events,
 	   char *sys_name, char *event_name)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	regex_t ereg;
 	regex_t sreg;
 	int match = 0;
@@ -333,7 +333,7 @@ static void free_events(struct event_list *events)
 }
 
 static enum tep_errno
-create_arg_item(struct event_format *event, const char *token,
+create_arg_item(struct tep_event_format *event, const char *token,
 		enum event_type type, struct filter_arg **parg, char *error_str)
 {
 	struct format_field *field;
@@ -939,7 +939,7 @@ static int collapse_tree(struct filter_arg *arg,
 }
 
 static enum tep_errno
-process_filter(struct event_format *event, struct filter_arg **parg,
+process_filter(struct tep_event_format *event, struct filter_arg **parg,
 	       char *error_str, int not)
 {
 	enum event_type type;
@@ -1179,7 +1179,7 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 }
 
 static enum tep_errno
-process_event(struct event_format *event, const char *filter_str,
+process_event(struct tep_event_format *event, const char *filter_str,
 	      struct filter_arg **parg, char *error_str)
 {
 	int ret;
@@ -1204,7 +1204,7 @@ process_event(struct event_format *event, const char *filter_str,
 }
 
 static enum tep_errno
-filter_event(struct event_filter *filter, struct event_format *event,
+filter_event(struct event_filter *filter, struct tep_event_format *event,
 	     const char *filter_str, char *error_str)
 {
 	struct filter_type *filter_type;
@@ -1456,7 +1456,7 @@ static int copy_filter_type(struct event_filter *filter,
 			     struct filter_type *filter_type)
 {
 	struct filter_arg *arg;
-	struct event_format *event;
+	struct tep_event_format *event;
 	const char *sys;
 	const char *name;
 	char *str;
@@ -1538,7 +1538,7 @@ int tep_update_trivial(struct event_filter *dest, struct event_filter *source,
 {
 	struct tep_handle *src_pevent;
 	struct tep_handle *dest_pevent;
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct filter_type *filter_type;
 	struct filter_arg *arg;
 	char *str;
@@ -1682,11 +1682,11 @@ int tep_filter_event_has_trivial(struct event_filter *filter,
 	}
 }
 
-static int test_filter(struct event_format *event, struct filter_arg *arg,
+static int test_filter(struct tep_event_format *event, struct filter_arg *arg,
 		       struct tep_record *record, enum tep_errno *err);
 
 static const char *
-get_comm(struct event_format *event, struct tep_record *record)
+get_comm(struct tep_event_format *event, struct tep_record *record)
 {
 	const char *comm;
 	int pid;
@@ -1697,7 +1697,7 @@ get_comm(struct event_format *event, struct tep_record *record)
 }
 
 static unsigned long long
-get_value(struct event_format *event,
+get_value(struct tep_event_format *event,
 	  struct format_field *field, struct tep_record *record)
 {
 	unsigned long long val;
@@ -1733,11 +1733,11 @@ get_value(struct event_format *event,
 }
 
 static unsigned long long
-get_arg_value(struct event_format *event, struct filter_arg *arg,
+get_arg_value(struct tep_event_format *event, struct filter_arg *arg,
 	      struct tep_record *record, enum tep_errno *err);
 
 static unsigned long long
-get_exp_value(struct event_format *event, struct filter_arg *arg,
+get_exp_value(struct tep_event_format *event, struct filter_arg *arg,
 	      struct tep_record *record, enum tep_errno *err)
 {
 	unsigned long long lval, rval;
@@ -1792,7 +1792,7 @@ get_exp_value(struct event_format *event, struct filter_arg *arg,
 }
 
 static unsigned long long
-get_arg_value(struct event_format *event, struct filter_arg *arg,
+get_arg_value(struct tep_event_format *event, struct filter_arg *arg,
 	      struct tep_record *record, enum tep_errno *err)
 {
 	switch (arg->type) {
@@ -1816,7 +1816,7 @@ get_arg_value(struct event_format *event, struct filter_arg *arg,
 	return 0;
 }
 
-static int test_num(struct event_format *event, struct filter_arg *arg,
+static int test_num(struct tep_event_format *event, struct filter_arg *arg,
 		    struct tep_record *record, enum tep_errno *err)
 {
 	unsigned long long lval, rval;
@@ -1859,7 +1859,7 @@ static int test_num(struct event_format *event, struct filter_arg *arg,
 
 static const char *get_field_str(struct filter_arg *arg, struct tep_record *record)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct tep_handle *pevent;
 	unsigned long long addr;
 	const char *val = NULL;
@@ -1907,7 +1907,7 @@ static const char *get_field_str(struct filter_arg *arg, struct tep_record *reco
 	return val;
 }
 
-static int test_str(struct event_format *event, struct filter_arg *arg,
+static int test_str(struct tep_event_format *event, struct filter_arg *arg,
 		    struct tep_record *record, enum tep_errno *err)
 {
 	const char *val;
@@ -1938,7 +1938,7 @@ static int test_str(struct event_format *event, struct filter_arg *arg,
 	}
 }
 
-static int test_op(struct event_format *event, struct filter_arg *arg,
+static int test_op(struct tep_event_format *event, struct filter_arg *arg,
 		   struct tep_record *record, enum tep_errno *err)
 {
 	switch (arg->op.type) {
@@ -1960,7 +1960,7 @@ static int test_op(struct event_format *event, struct filter_arg *arg,
 	}
 }
 
-static int test_filter(struct event_format *event, struct filter_arg *arg,
+static int test_filter(struct tep_event_format *event, struct filter_arg *arg,
 		       struct tep_record *record, enum tep_errno *err)
 {
 	if (*err) {
diff --git a/plugins/plugin_blk.c b/plugins/plugin_blk.c
index ee69d8e..2bc0fce 100644
--- a/plugins/plugin_blk.c
+++ b/plugins/plugin_blk.c
@@ -17,7 +17,7 @@
 
 struct blk_data {
 	unsigned long long	sector;
-	struct event_format	*event;
+	struct tep_event_format	*event;
 	unsigned int		action;
 	unsigned int		pid;
 	unsigned int		device;
@@ -279,7 +279,7 @@ static const struct {
 };
 
 static int blktrace_handler(struct trace_seq *s, struct tep_record *record,
-			    struct event_format *event, void *context)
+			    struct tep_event_format *event, void *context)
 {
 	struct format_field *field;
 	unsigned long long val;
diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index 3e0e1b2..5bd394f 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -129,7 +129,7 @@ static void show_function(struct trace_seq *s, struct tep_handle *pevent,
 }
 
 static int function_handler(struct trace_seq *s, struct tep_record *record,
-			    struct event_format *event, void *context)
+			    struct tep_event_format *event, void *context)
 {
 	struct tep_handle *pevent = event->pevent;
 	unsigned long long function;
diff --git a/plugins/plugin_futex.c b/plugins/plugin_futex.c
index a8af6d4..d44c1d9 100644
--- a/plugins/plugin_futex.c
+++ b/plugins/plugin_futex.c
@@ -65,7 +65,7 @@ static void futex_print(struct trace_seq *s, const struct futex_args *args,
 }
 
 static int futex_handler(struct trace_seq *s, struct tep_record *record,
-			 struct event_format *event, void *context)
+			 struct tep_event_format *event, void *context)
 {
 	const struct futex_op *fop;
 	struct futex_args args;
diff --git a/plugins/plugin_hrtimer.c b/plugins/plugin_hrtimer.c
index 9defa1b..8524257 100644
--- a/plugins/plugin_hrtimer.c
+++ b/plugins/plugin_hrtimer.c
@@ -11,7 +11,7 @@
 #include "trace-seq.h"
 
 static int timer_expire_handler(struct trace_seq *s, struct tep_record *record,
-				struct event_format *event, void *context)
+				struct tep_event_format *event, void *context)
 {
 	trace_seq_printf(s, "hrtimer=");
 
@@ -28,7 +28,7 @@ static int timer_expire_handler(struct trace_seq *s, struct tep_record *record,
 }
 
 static int timer_start_handler(struct trace_seq *s, struct tep_record *record,
-			       struct event_format *event, void *context)
+			       struct tep_event_format *event, void *context)
 {
 	trace_seq_printf(s, "hrtimer=");
 
diff --git a/plugins/plugin_kmem.c b/plugins/plugin_kmem.c
index 29f8e6c..c45e43c 100644
--- a/plugins/plugin_kmem.c
+++ b/plugins/plugin_kmem.c
@@ -10,7 +10,7 @@
 #include "trace-seq.h"
 
 static int call_site_handler(struct trace_seq *s, struct tep_record *record,
-			     struct event_format *event, void *context)
+			     struct tep_event_format *event, void *context)
 {
 	struct format_field *field;
 	unsigned long long val, addr;
diff --git a/plugins/plugin_kvm.c b/plugins/plugin_kvm.c
index ca7d111..db3117b 100644
--- a/plugins/plugin_kvm.c
+++ b/plugins/plugin_kvm.c
@@ -250,7 +250,7 @@ static const char *find_exit_reason(unsigned isa, int val)
 }
 
 static int print_exit_reason(struct trace_seq *s, struct tep_record *record,
-			     struct event_format *event, const char *field)
+			     struct tep_event_format *event, const char *field)
 {
 	unsigned long long isa;
 	unsigned long long val;
@@ -271,7 +271,7 @@ static int print_exit_reason(struct trace_seq *s, struct tep_record *record,
 }
 
 static int kvm_exit_handler(struct trace_seq *s, struct tep_record *record,
-			    struct event_format *event, void *context)
+			    struct tep_event_format *event, void *context)
 {
 	unsigned long long info1 = 0, info2 = 0;
 
@@ -293,7 +293,7 @@ static int kvm_exit_handler(struct trace_seq *s, struct tep_record *record,
 #define KVM_EMUL_INSN_F_CS_L   (1 << 3)
 
 static int kvm_emulate_insn_handler(struct trace_seq *s, struct tep_record *record,
-				    struct event_format *event, void *context)
+				    struct tep_event_format *event, void *context)
 {
 	unsigned long long rip, csbase, len, flags, failed;
 	int llen;
@@ -333,7 +333,7 @@ static int kvm_emulate_insn_handler(struct trace_seq *s, struct tep_record *reco
 
 
 static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct tep_record *record,
-					    struct event_format *event, void *context)
+					    struct tep_event_format *event, void *context)
 {
 	if (print_exit_reason(s, record, event, "exit_code") < 0)
 		return -1;
@@ -347,7 +347,7 @@ static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct tep_reco
 }
 
 static int kvm_nested_vmexit_handler(struct trace_seq *s, struct tep_record *record,
-				     struct event_format *event, void *context)
+				     struct tep_event_format *event, void *context)
 {
 	tep_print_num_field(s, "rip %lx ", event, "rip", record, 1);
 
@@ -370,7 +370,7 @@ union kvm_mmu_page_role {
 };
 
 static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
-			      struct event_format *event, void *context)
+			      struct tep_event_format *event, void *context)
 {
 	unsigned long long val;
 	static const char *access_str[] =
@@ -412,7 +412,7 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 static int kvm_mmu_get_page_handler(struct trace_seq *s, struct tep_record *record,
-				    struct event_format *event, void *context)
+				    struct tep_event_format *event, void *context)
 {
 	unsigned long long val;
 
diff --git a/plugins/plugin_mac80211.c b/plugins/plugin_mac80211.c
index c1276c2..8bef87d 100644
--- a/plugins/plugin_mac80211.c
+++ b/plugins/plugin_mac80211.c
@@ -11,7 +11,7 @@
 
 #define INDENT 65
 
-static void print_string(struct trace_seq *s, struct event_format *event,
+static void print_string(struct trace_seq *s, struct tep_event_format *event,
 			 const char *name, const void *data)
 {
 	struct format_field *f = tep_find_field(event, name);
@@ -44,7 +44,7 @@ struct value_name {
 	const char *name;
 };
 
-static void _print_enum(struct trace_seq *s, struct event_format *event,
+static void _print_enum(struct trace_seq *s, struct tep_event_format *event,
 			const char *name, const void *data,
 			const struct value_name *names, int n_names)
 {
@@ -77,7 +77,7 @@ static void _print_enum(struct trace_seq *s, struct event_format *event,
 	_print_enum(s, ev, name, data, __n, sizeof(__n)/sizeof(__n[0]));	\
 	})
 
-static void _print_flag(struct trace_seq *s, struct event_format *event,
+static void _print_flag(struct trace_seq *s, struct tep_event_format *event,
 			const char *name, const void *data,
 			const struct value_name *names, int n_names)
 {
@@ -125,7 +125,7 @@ static void _print_flag(struct trace_seq *s, struct event_format *event,
 #define SP()	trace_seq_putc(s, ' ')
 
 static int drv_bss_info_changed(struct trace_seq *s, struct tep_record *record,
-				struct event_format *event, void *context)
+				struct tep_event_format *event, void *context)
 {
 	void *data = record->data;
 
@@ -153,7 +153,7 @@ static int drv_bss_info_changed(struct trace_seq *s, struct tep_record *record,
 }
 
 static int drv_config(struct trace_seq *s, struct tep_record *record,
-		      struct event_format *event, void *context)
+		      struct tep_event_format *event, void *context)
 {
 	void *data = record->data;
 
diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index 1a5f548..782712d 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -51,7 +51,7 @@ static void write_and_save_comm(struct format_field *field,
 }
 
 static int sched_wakeup_handler(struct trace_seq *s, struct tep_record *record,
-				struct event_format *event, void *context)
+				struct tep_event_format *event, void *context)
 {
 	struct format_field *field;
 	unsigned long long val;
@@ -79,7 +79,7 @@ static int sched_wakeup_handler(struct trace_seq *s, struct tep_record *record,
 }
 
 static int sched_switch_handler(struct trace_seq *s, struct tep_record *record,
-				struct event_format *event, void *context)
+				struct tep_event_format *event, void *context)
 {
 	struct format_field *field;
 	unsigned long long val;
diff --git a/plugins/plugin_tlb.c b/plugins/plugin_tlb.c
index f96da40..afe0f7a 100644
--- a/plugins/plugin_tlb.c
+++ b/plugins/plugin_tlb.c
@@ -17,7 +17,7 @@ enum tlb_flush_reason {
 };
 
 static int tlb_flush_handler(struct trace_seq *s, struct tep_record *record,
-			     struct event_format *event, void *context)
+			     struct tep_event_format *event, void *context)
 {
 	unsigned long long val;
 
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index e826679..4505649 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -32,7 +32,7 @@
 %inline %{
 static int python_callback(struct trace_seq *s,
 			   struct tep_record *record,
-			   struct event_format *event,
+			   struct tep_event_format *event,
 			   void *context);
 
 static int skip_output = 0;
@@ -82,7 +82,7 @@ void py_pevent_register_event_handler(struct tep_handle *pevent, int id,
 
 static PyObject *py_field_get_stack(struct tep_handle *pevent,
 				    struct tep_record *record,
-				    struct event_format *event,
+				    struct tep_event_format *event,
 				    int long_size)
 {
 	PyObject *list;
@@ -169,7 +169,7 @@ static PyObject *py_field_get_str(struct format_field *f, struct tep_record *r)
 				strnlen((char *)r->data + f->offset, f->size));
 }
 
-static PyObject *py_format_get_keys(struct event_format *ef)
+static PyObject *py_format_get_keys(struct tep_event_format *ef)
 {
 	PyObject *list;
 	struct format_field *f;
@@ -191,7 +191,7 @@ static PyObject *py_format_get_keys(struct event_format *ef)
 %wrapper %{
 static int python_callback(struct trace_seq *s,
 			   struct tep_record *record,
-			   struct event_format *event,
+			   struct tep_event_format *event,
 			   void *context)
 {
 	PyObject *arglist, *result;
@@ -205,7 +205,7 @@ static int python_callback(struct trace_seq *s,
 		SWIG_NewPointerObj(SWIG_as_voidptr(record),
 				   SWIGTYPE_p_tep_record, 0),
 		SWIG_NewPointerObj(SWIG_as_voidptr(event),
-				   SWIGTYPE_p_event_format, 0));
+				   SWIGTYPE_p_tep_event_format, 0));
 
 	result = PyEval_CallObject(context, arglist);
 	Py_XDECREF(arglist);
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index 324b20d..93d68cd 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -530,7 +530,7 @@ process_sched_switch(struct tep_handle *pevent, struct tep_record *record)
 static void
 process_event(struct tep_handle *pevent, struct tep_record *record, int type)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	const char *event_name;
 	unsigned long long val;
 	int pid;
@@ -592,11 +592,11 @@ process_record(struct tep_handle *pevent, struct tep_record *record)
 	process_event(pevent, record, type);
 }
 
-static struct event_format *
+static struct tep_event_format *
 update_event(struct tep_handle *pevent,
 	     const char *sys, const char *name, int *id)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = tep_find_event_by_name(pevent, sys, name);
 	if (!event)
@@ -609,7 +609,7 @@ update_event(struct tep_handle *pevent,
 
 static void update_sched_wakeup(struct tep_handle *pevent)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = update_event(pevent, "sched", "sched_wakeup", &sched_wakeup_type);
 	if (!event)
@@ -621,7 +621,7 @@ static void update_sched_wakeup(struct tep_handle *pevent)
 
 static void update_sched_wakeup_new(struct tep_handle *pevent)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = update_event(pevent, "sched", "sched_wakeup_new", &sched_wakeup_new_type);
 	if (!event)
@@ -633,7 +633,7 @@ static void update_sched_wakeup_new(struct tep_handle *pevent)
 
 static void update_sched_switch(struct tep_handle *pevent)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = update_event(pevent, "sched", "sched_switch", &sched_switch_type);
 	if (!event)
@@ -647,7 +647,7 @@ static void update_sched_switch(struct tep_handle *pevent)
 
 static void update_function(struct tep_handle *pevent)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = update_event(pevent, "ftrace", "function", &function_type);
 	if (!event)
@@ -659,7 +659,7 @@ static void update_function(struct tep_handle *pevent)
 
 static void update_function_graph_entry(struct tep_handle *pevent)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = update_event(pevent, "ftrace", "funcgraph_entry", &function_graph_entry_type);
 	if (!event)
@@ -671,7 +671,7 @@ static void update_function_graph_entry(struct tep_handle *pevent)
 
 static void update_function_graph_exit(struct tep_handle *pevent)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = update_event(pevent, "ftrace", "funcgraph_exit", &function_graph_exit_type);
 	if (!event)
@@ -686,7 +686,7 @@ static void update_function_graph_exit(struct tep_handle *pevent)
 
 static void update_kernel_stack(struct tep_handle *pevent)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = update_event(pevent, "ftrace", "kernel_stack", &kernel_stack_type);
 	if (!event)
@@ -934,7 +934,7 @@ static void print_chains(struct tep_handle *pevent)
 static void do_trace_hist(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = tracecmd_get_pevent(handle);
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct tep_record *record;
 	int cpus;
 	int cpu;
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index 8dfa285..1dcc1af 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -61,11 +61,11 @@ static void *zalloc(size_t size)
 	return calloc(1, size);
 }
 
-static struct event_format *
+static struct tep_event_format *
 update_event(struct tep_handle *pevent,
 	     const char *sys, const char *name, int *id)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = tep_find_event_by_name(pevent, sys, name);
 	if (!event)
@@ -78,7 +78,7 @@ update_event(struct tep_handle *pevent,
 
 static void update_kmalloc(struct tep_handle *pevent)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = update_event(pevent, "kmem", "kmalloc", &kmalloc_type);
 	if (!event)
@@ -92,7 +92,7 @@ static void update_kmalloc(struct tep_handle *pevent)
 
 static void update_kmalloc_node(struct tep_handle *pevent)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = update_event(pevent, "kmem", "kmalloc_node", &kmalloc_node_type);
 	if (!event)
@@ -106,7 +106,7 @@ static void update_kmalloc_node(struct tep_handle *pevent)
 
 static void update_kfree(struct tep_handle *pevent)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = update_event(pevent, "kmem", "kfree", &kfree_type);
 	if (!event)
@@ -117,7 +117,7 @@ static void update_kfree(struct tep_handle *pevent)
 
 static void update_kmem_cache_alloc(struct tep_handle *pevent)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = update_event(pevent, "kmem", "kmem_cache_alloc", &kmem_cache_alloc_type);
 	if (!event)
@@ -131,7 +131,7 @@ static void update_kmem_cache_alloc(struct tep_handle *pevent)
 
 static void update_kmem_cache_alloc_node(struct tep_handle *pevent)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = update_event(pevent, "kmem", "kmem_cache_alloc_node",
 			     &kmem_cache_alloc_node_type);
@@ -146,7 +146,7 @@ static void update_kmem_cache_alloc_node(struct tep_handle *pevent)
 
 static void update_kmem_cache_free(struct tep_handle *pevent)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = update_event(pevent, "kmem", "kmem_cache_free", &kmem_cache_free_type);
 	if (!event)
@@ -462,7 +462,7 @@ static void print_list(void)
 static void do_trace_mem(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = tracecmd_get_pevent(handle);
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct tep_record *record;
 	int missed_events = 0;
 	int cpus;
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index 5cf0ccd..81753f6 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -71,7 +71,7 @@ struct event_data {
 	struct trace_hash_item	hash;
 	int			id;
 	int			trace;
-	struct event_format	*event;
+	struct tep_event_format	*event;
 
 	struct event_data	*end;
 	struct event_data	*start;
@@ -795,7 +795,7 @@ static struct event_data *
 add_event(struct handle_data *h, const char *system, const char *event_name,
 	  enum event_data_type type)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct event_data *event_data;
 
 	event = tep_find_event_by_name(h->pevent, system, event_name);
@@ -870,9 +870,9 @@ mate_events(struct handle_data *h, struct event_data *start,
  * @global: The events are global and not per task
  */
 void tracecmd_mate_events(struct tracecmd_input *handle,
-			  struct event_format *start_event,
+			  struct tep_event_format *start_event,
 			  const char *pid_field, const char *end_match_field,
-			  struct event_format *end_event,
+			  struct tep_event_format *end_event,
 			  const char *start_match_field,
 			  int migrate, int global)
 {
@@ -1268,7 +1268,7 @@ void trace_init_profile(struct tracecmd_input *handle, struct hook_list *hook,
 			int global)
 {
 	struct tep_handle *pevent = tracecmd_get_pevent(handle);
-	struct event_format **events;
+	struct tep_event_format **events;
 	struct format_field **fields;
 	struct handle_data *h;
 	struct event_data *event_data;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 02f0ce8..173da3a 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -530,7 +530,7 @@ static void process_filters(struct handle_list *handles)
 
 static void init_wakeup(struct tracecmd_input *handle)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct tep_handle *pevent;
 
 	if (!show_wakeup)
@@ -790,7 +790,7 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 	}
 	use_trace_clock = tracecmd_get_use_trace_clock(handle);
 	if (tsdiff) {
-		struct event_format *event;
+		struct tep_event_format *event;
 		unsigned long long rec_ts = record->ts;
 
 		event = tep_find_event_by_record(pevent, record);
@@ -928,7 +928,7 @@ test_stacktrace(struct handle_list *handles, struct tep_record *record,
 	struct stack_info_cpu *cpu_info;
 	struct handle_list *h;
 	struct tracecmd_input *handle;
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct tep_handle *pevent;
 	static int init;
 	int ret;
@@ -1117,7 +1117,7 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 	struct handle_list *last_handle;
 	struct tep_record *record;
 	struct tep_record *last_record;
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct tep_handle *pevent;
 	int cpus;
 	int ret;
@@ -1336,8 +1336,8 @@ static void process_plugin_option(char *option)
 static void set_event_flags(struct tep_handle *pevent, struct event_str *list,
 			    unsigned int flag)
 {
-	struct event_format **events;
-	struct event_format *event;
+	struct tep_event_format **events;
+	struct tep_event_format *event;
 	struct event_str *str;
 	regex_t regex;
 	int ret;
@@ -1736,8 +1736,8 @@ void trace_report (int argc, char **argv)
 		}
 
 		if (show_events) {
-			struct event_format **events;
-			struct event_format *event;
+			struct tep_event_format **events;
+			struct tep_event_format *event;
 			int i;
 
 			events = tep_list_events(pevent, EVENT_SORT_SYSTEM);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5a1d2a0..0418db2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3346,7 +3346,7 @@ static void add_func(struct func_list **list, const char *mod, const char *func)
 static unsigned long long
 find_ts_in_page(struct tep_handle *pevent, void *page, int size)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct format_field *field;
 	struct tep_record *last_record = NULL;
 	struct tep_record *record;
-- 
2.17.1
