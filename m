Return-Path: <SRS0=XLZm=MI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730058.outbound.protection.outlook.com ([40.107.73.58]:63673
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726342AbeIZScM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Sep 2018 14:32:12 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 13/16] tools lib traceevent: Add prefix tep_ to structs filter_type and event_filter
Date: Wed, 26 Sep 2018 15:18:29 +0300
Message-Id: <20180926121832.16101-14-tstoyanov@vmware.com>
In-Reply-To: <20180926121832.16101-1-tstoyanov@vmware.com>
References: <20180926121832.16101-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This adds prefix tep_ to
structs filter_type and event_filter

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180919185724.309837130@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h         | 34 ++++-----
 kernel-shark-qt/examples/datafilter.c    |  2 +-
 kernel-shark-qt/src/libkshark-configio.c |  4 +-
 kernel-shark-qt/src/libkshark.c          |  2 +-
 kernel-shark-qt/src/libkshark.h          |  2 +-
 kernel-shark/include/trace-filter.h      | 16 ++--
 kernel-shark/include/trace-graph.h       |  4 +-
 kernel-shark/include/trace-view-store.h  |  4 +-
 kernel-shark/include/trace-view.h        |  2 +-
 kernel-shark/kernel-shark.c              |  8 +-
 kernel-shark/trace-filter.c              | 26 +++----
 kernel-shark/trace-graph.c               |  8 +-
 kernel-shark/trace-view-main.c           |  4 +-
 kernel-shark/trace-view.c                | 12 +--
 lib/traceevent/parse-filter.c            | 96 ++++++++++++------------
 tracecmd/trace-read.c                    |  2 +-
 16 files changed, 113 insertions(+), 113 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 04852f9..6009e11 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -870,7 +870,7 @@ struct tep_filter_arg {
 	};
 };
 
-struct filter_type {
+struct tep_filter_type {
 	int			event_id;
 	struct tep_event_format	*event;
 	struct tep_filter_arg	*filter;
@@ -878,14 +878,14 @@ struct filter_type {
 
 #define TEP_FILTER_ERROR_BUFSZ  1024
 
-struct event_filter {
+struct tep_event_filter {
 	struct tep_handle	*pevent;
 	int			filters;
-	struct filter_type	*event_filters;
+	struct tep_filter_type	*event_filters;
 	char			error_buffer[TEP_FILTER_ERROR_BUFSZ];
 };
 
-struct event_filter *tep_filter_alloc(struct tep_handle *pevent);
+struct tep_event_filter *tep_filter_alloc(struct tep_handle *pevent);
 
 /* for backward compatibility */
 #define FILTER_NONE		TEP_ERRNO__NO_FILTER
@@ -899,39 +899,39 @@ enum filter_trivial_type {
 	FILTER_TRIVIAL_BOTH,
 };
 
-enum tep_errno tep_filter_add_filter_str(struct event_filter *filter,
+enum tep_errno tep_filter_add_filter_str(struct tep_event_filter *filter,
 					 const char *filter_str);
 
-enum tep_errno tep_filter_match(struct event_filter *filter,
+enum tep_errno tep_filter_match(struct tep_event_filter *filter,
 				struct tep_record *record);
 
-int tep_filter_strerror(struct event_filter *filter, enum tep_errno err,
+int tep_filter_strerror(struct tep_event_filter *filter, enum tep_errno err,
 			char *buf, size_t buflen);
 
-int tep_event_filtered(struct event_filter *filter,
+int tep_event_filtered(struct tep_event_filter *filter,
 		       int event_id);
 
-void tep_filter_reset(struct event_filter *filter);
+void tep_filter_reset(struct tep_event_filter *filter);
 
-int tep_filter_clear_trivial(struct event_filter *filter,
+int tep_filter_clear_trivial(struct tep_event_filter *filter,
 			     enum filter_trivial_type type);
 
-void tep_filter_free(struct event_filter *filter);
+void tep_filter_free(struct tep_event_filter *filter);
 
-char *tep_filter_make_string(struct event_filter *filter, int event_id);
+char *tep_filter_make_string(struct tep_event_filter *filter, int event_id);
 
-int tep_filter_remove_event(struct event_filter *filter,
+int tep_filter_remove_event(struct tep_event_filter *filter,
 			    int event_id);
 
-int tep_filter_event_has_trivial(struct event_filter *filter,
+int tep_filter_event_has_trivial(struct tep_event_filter *filter,
 				 int event_id,
 				 enum filter_trivial_type type);
 
-int tep_filter_copy(struct event_filter *dest, struct event_filter *source);
+int tep_filter_copy(struct tep_event_filter *dest, struct tep_event_filter *source);
 
-int tep_update_trivial(struct event_filter *dest, struct event_filter *source,
+int tep_update_trivial(struct tep_event_filter *dest, struct tep_event_filter *source,
 			enum filter_trivial_type type);
 
-int tep_filter_compare(struct event_filter *filter1, struct event_filter *filter2);
+int tep_filter_compare(struct tep_event_filter *filter1, struct tep_event_filter *filter2);
 
 #endif /* _PARSE_EVENTS_H */
diff --git a/kernel-shark-qt/examples/datafilter.c b/kernel-shark-qt/examples/datafilter.c
index 08a3757..45bf6c5 100644
--- a/kernel-shark-qt/examples/datafilter.c
+++ b/kernel-shark-qt/examples/datafilter.c
@@ -18,7 +18,7 @@ int main(int argc, char **argv)
 	size_t i, n_rows, n_tasks, n_evts, count;
 	struct kshark_context *kshark_ctx;
 	struct kshark_entry **data = NULL;
-	struct event_filter *adv_filter;
+	struct tep_event_filter *adv_filter;
 	struct tep_event_format *event;
 	char *entry_str;
 	bool status;
diff --git a/kernel-shark-qt/src/libkshark-configio.c b/kernel-shark-qt/src/libkshark-configio.c
index c7071fb..7337865 100644
--- a/kernel-shark-qt/src/libkshark-configio.c
+++ b/kernel-shark-qt/src/libkshark-configio.c
@@ -1009,7 +1009,7 @@ bool kshark_import_task_filter(struct tracecmd_filter_id *filter,
 static bool kshark_adv_filters_to_json(struct kshark_context *kshark_ctx,
 				       struct json_object *jobj)
 {
-	struct event_filter *adv_filter = kshark_ctx->advanced_event_filter;
+	struct tep_event_filter *adv_filter = kshark_ctx->advanced_event_filter;
 	json_object *jfilter_data, *jevent, *jsystem, *jname, *jfilter;
 	struct tep_event_format **events;
 	char *str;
@@ -1107,7 +1107,7 @@ bool kshark_export_adv_filters(struct kshark_context *kshark_ctx,
 static bool kshark_adv_filters_from_json(struct kshark_context *kshark_ctx,
 					 struct json_object *jobj)
 {
-	struct event_filter *adv_filter = kshark_ctx->advanced_event_filter;
+	struct tep_event_filter *adv_filter = kshark_ctx->advanced_event_filter;
 	json_object *jfilter, *jsystem, *jname, *jcond;
 	int i, length, n, ret = 0;
 	char *filter_str = NULL;
diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 67e809c..7c789bd 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -574,7 +574,7 @@ static size_t get_records(struct kshark_context *kshark_ctx,
 			  struct rec_list ***rec_list, enum rec_type type)
 {
 	struct kshark_event_handler *evt_handler;
-	struct event_filter *adv_filter;
+	struct tep_event_filter *adv_filter;
 	struct kshark_task_list *task;
 	struct tep_record *rec;
 	struct rec_list **temp_next;
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index e846c85..c81d11f 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -120,7 +120,7 @@ struct kshark_context {
 	 * Filter allowing sophisticated filtering based on the content of
 	 * the event.
 	 */
-	struct event_filter		*advanced_event_filter;
+	struct tep_event_filter		*advanced_event_filter;
 
 	/** List of Data collections. */
 	struct kshark_entry_collection *collections;
diff --git a/kernel-shark/include/trace-filter.h b/kernel-shark/include/trace-filter.h
index 589c30f..1f46f1e 100644
--- a/kernel-shark/include/trace-filter.h
+++ b/kernel-shark/include/trace-filter.h
@@ -71,7 +71,7 @@ typedef void (*trace_filter_event_cb_func)(gboolean accept,
 					   gpointer data);
 
 void trace_adv_filter_dialog(struct tracecmd_input *handle,
-			     struct event_filter *event_filter,
+			     struct tep_event_filter *event_filter,
 			     trace_adv_filter_cb_func func,
 			     gpointer data);
 
@@ -94,16 +94,16 @@ void trace_filter_pevent_dialog(struct tep_handle *pevent,
 				gpointer data);
 
 void trace_filter_event_filter_dialog(struct tracecmd_input *handle,
-			       struct event_filter *filter,
+			       struct tep_event_filter *filter,
 			       gboolean all_events,
 			       trace_filter_event_cb_func func,
 			       gpointer data);
 
-void trace_filter_convert_filter_to_names(struct event_filter *filter,
+void trace_filter_convert_filter_to_names(struct tep_event_filter *filter,
 					  gchar ***systems,
 					  gint **events);
 
-void trace_filter_convert_char_to_filter(struct event_filter *filter,
+void trace_filter_convert_char_to_filter(struct tep_event_filter *filter,
 					 gchar **systems,
 					 gint *events);
 /**
@@ -130,10 +130,10 @@ void trace_array_add(gint **array, gint *count, gint val);
 
 /* save and load filters */
 int trace_filter_save_events(struct tracecmd_xml_handle *handle,
-			     struct event_filter *filter);
+			     struct tep_event_filter *filter);
 int trace_filter_save_tasks(struct tracecmd_xml_handle *handle,
 			    struct tracecmd_filter_id *filter);
-int trace_filter_load_events(struct event_filter *event_filter,
+int trace_filter_load_events(struct tep_event_filter *event_filter,
 			     struct tracecmd_xml_handle *handle,
 			     struct tracecmd_xml_system_node *node);
 int trace_filter_load_task_filter(struct tracecmd_filter_id *filter,
@@ -149,7 +149,7 @@ int trace_filter_save_filters(struct tracecmd_xml_handle *handle,
 			      struct tracecmd_filter_id *hide_tasks);
 
 GtkWidget *trace_create_event_list_view(struct tep_handle *pevent,
-					struct event_filter *filter,
+					struct tep_event_filter *filter,
 					gboolean all_events, gchar **systems,
 					gint *events);
 gint trace_extract_event_list_view(GtkWidget *event_view,
@@ -158,7 +158,7 @@ gint trace_extract_event_list_view(GtkWidget *event_view,
 				   gint **events);
 int trace_update_event_view(GtkWidget *event_view,
 			    struct tep_handle *pevent,
-			    struct event_filter *filter,
+			    struct tep_event_filter *filter,
 			    gboolean all_events,
 			    gchar **systems, gint *events);
 
diff --git a/kernel-shark/include/trace-graph.h b/kernel-shark/include/trace-graph.h
index 0368df2..101f1e1 100644
--- a/kernel-shark/include/trace-graph.h
+++ b/kernel-shark/include/trace-graph.h
@@ -209,7 +209,7 @@ struct graph_info {
 	gboolean		filter_available;
 
 	gboolean		all_events;	/* all events enabled */
-	struct event_filter	*event_filter;	/* filtered events */
+	struct tep_event_filter	*event_filter;	/* filtered events */
 
 	/* cache of event fields */
 	gint			ftrace_sched_switch_id;
@@ -309,7 +309,7 @@ gboolean trace_graph_filter_on_event(struct graph_info *ginfo, struct tep_record
 
 void trace_graph_copy_filter(struct graph_info *ginfo,
 			     gboolean all_events,
-			     struct event_filter *event_filter);
+			     struct tep_event_filter *event_filter);
 gint *trace_graph_task_list(struct graph_info *ginfo);
 
 int trace_graph_load_filters(struct graph_info *ginfo,
diff --git a/kernel-shark/include/trace-view-store.h b/kernel-shark/include/trace-view-store.h
index c01619b..1f65481 100644
--- a/kernel-shark/include/trace-view-store.h
+++ b/kernel-shark/include/trace-view-store.h
@@ -102,7 +102,7 @@ struct trace_view_store
 	/* filters */
 	gint			all_events; /* set 1 when all events are enabled */
 						/* else */
-	struct event_filter		*event_filter; /* Filtered events */
+	struct tep_event_filter		*event_filter; /* Filtered events */
 	struct tracecmd_filter_id	*task_filter;	/* hash of tasks to filter on */
 	struct tracecmd_filter_id	*hide_tasks;	/* hash of tasks to not display */
 
@@ -235,7 +235,7 @@ static inline gboolean trace_view_store_get_all_events_enabled(TraceViewStore *s
 	return store->all_events;
 }
 
-static inline struct event_filter *
+static inline struct tep_event_filter *
 trace_view_store_get_event_filter(TraceViewStore *store)
 {
 	g_return_val_if_fail (TRACE_VIEW_IS_LIST (store), FALSE);
diff --git a/kernel-shark/include/trace-view.h b/kernel-shark/include/trace-view.h
index b666746..0da88e0 100644
--- a/kernel-shark/include/trace-view.h
+++ b/kernel-shark/include/trace-view.h
@@ -45,7 +45,7 @@ void trace_view_cpu_filter_callback(gboolean accept,
 
 void trace_view_copy_filter(GtkWidget *treeview,
 			    gboolean all_events,
-			    struct event_filter *event_filter);
+			    struct tep_event_filter *event_filter);
 
 void trace_view_search_setup(GtkBox *box, GtkTreeView *treeview);
 
diff --git a/kernel-shark/kernel-shark.c b/kernel-shark/kernel-shark.c
index 0da78be..62059b4 100644
--- a/kernel-shark/kernel-shark.c
+++ b/kernel-shark/kernel-shark.c
@@ -395,7 +395,7 @@ static void load_filter(struct shark_info *info, const char *filename)
 	struct tracecmd_xml_handle *handle;
 	struct tracecmd_filter_id *task_filter;
 	struct tracecmd_filter_id *hide_tasks;
-	struct event_filter *event_filter;
+	struct tep_event_filter *event_filter;
 	int ret;
 
 	handle = tracecmd_xml_open(filename);
@@ -818,7 +818,7 @@ sync_events_filter_clicked (GtkWidget *subitem, gpointer data)
 {
 	struct shark_info *info = data;
 	struct graph_info *ginfo = info->ginfo;
-	struct event_filter *event_filter;
+	struct tep_event_filter *event_filter;
 	GtkTreeView *trace_tree = GTK_TREE_VIEW(info->treeview);
 	GtkTreeModel *model;
 	TraceViewStore *store;
@@ -1087,7 +1087,7 @@ static void
 list_events_clicked (gpointer data)
 {
 	struct shark_info *info = data;
-	struct event_filter *event_filter;
+	struct tep_event_filter *event_filter;
 	GtkTreeView *trace_tree = GTK_TREE_VIEW(info->treeview);
 	GtkTreeModel *model;
 	TraceViewStore *store;
@@ -1151,7 +1151,7 @@ static void
 adv_list_filter_clicked (gpointer data)
 {
 	struct shark_info *info = data;
-	struct event_filter *event_filter;
+	struct tep_event_filter *event_filter;
 	GtkTreeView *trace_tree = GTK_TREE_VIEW(info->treeview);
 	GtkTreeModel *model;
 	TraceViewStore *store;
diff --git a/kernel-shark/trace-filter.c b/kernel-shark/trace-filter.c
index 0428dff..6144d0c 100644
--- a/kernel-shark/trace-filter.c
+++ b/kernel-shark/trace-filter.c
@@ -453,7 +453,7 @@ static gint *get_event_ids(GtkTreeView *treeview)
 
 static GtkTreeModel *
 create_tree_filter_model(struct tep_handle *pevent,
-			 struct event_filter *event_filter)
+			 struct tep_event_filter *event_filter)
 {
 	GtkTreeStore *treestore;
 	GtkTreeIter iter_events;
@@ -539,7 +539,7 @@ static void adv_filter_cursor_changed(GtkTreeView *treeview, gpointer data)
 
 static GtkWidget *
 create_adv_filter_view(struct tep_handle *pevent,
-		       struct event_filter *event_filter)
+		       struct tep_event_filter *event_filter)
 {
 	GtkTreeViewColumn *col;
 	GtkCellRenderer *renderer;
@@ -615,7 +615,7 @@ create_adv_filter_view(struct tep_handle *pevent,
  * @data: data to pass to the function @func
  */
 void trace_adv_filter_dialog(struct tracecmd_input *handle,
-			     struct event_filter *event_filter,
+			     struct tep_event_filter *event_filter,
 			       trace_adv_filter_cb_func func,
 			       gpointer data)
 {
@@ -1057,7 +1057,7 @@ gboolean event_is_enabled(gint *events, gint events_size, gint event)
 
 static GtkTreeModel *
 create_tree_event_model(struct tep_handle *pevent,
-			struct event_filter *filter,
+			struct tep_event_filter *filter,
 			gboolean all_events, gchar **systems_set,
 			gint *event_ids_set)
 {
@@ -1353,7 +1353,7 @@ static void expand_rows(GtkTreeView *tree, GtkTreeModel *model,
  */
 int trace_update_event_view(GtkWidget *event_view,
 			    struct tep_handle *pevent,
-			    struct event_filter *filter,
+			    struct tep_event_filter *filter,
 			    gboolean all_events,
 			    gchar **systems, gint *events)
 {
@@ -1386,7 +1386,7 @@ int trace_update_event_view(GtkWidget *event_view,
  */
 GtkWidget *
 trace_create_event_list_view(struct tep_handle *pevent,
-			     struct event_filter *filter,
+			     struct tep_event_filter *filter,
 			     gboolean all_events, gchar **systems,
 			     gint *events)
 {
@@ -1553,7 +1553,7 @@ static void accept_events(GtkWidget *view,
 }
 
 static void filter_event_dialog(struct tep_handle *pevent,
-				struct event_filter *filter,
+				struct tep_event_filter *filter,
 				gboolean all_events,
 				gchar **systems, gint *events,
 				trace_filter_event_cb_func func,
@@ -1659,7 +1659,7 @@ void trace_filter_pevent_dialog(struct tep_handle *pevent,
  * If @all_events is set, then @systems and @events are ignored.
  */
 void trace_filter_event_filter_dialog(struct tracecmd_input *handle,
-				      struct event_filter *filter,
+				      struct tep_event_filter *filter,
 				      gboolean all_events,
 				      trace_filter_event_cb_func func,
 				      gpointer data)
@@ -1918,7 +1918,7 @@ void trace_filter_cpu_dialog(gboolean all_cpus, guint64 *cpus_selected, gint cpu
  * @event_ids will be all events selected (not including those selected
  *  by @systems)
  */
-void trace_filter_convert_filter_to_names(struct event_filter *filter,
+void trace_filter_convert_filter_to_names(struct tep_event_filter *filter,
 					  gchar ***systems,
 					  gint **event_ids)
 {
@@ -1980,12 +1980,12 @@ void trace_filter_convert_filter_to_names(struct event_filter *filter,
  * @systems: array of systems that will have its events selected in @filter
  * @events: array of event ids that will be selected in @filter
  */
-void trace_filter_convert_char_to_filter(struct event_filter *filter,
+void trace_filter_convert_char_to_filter(struct tep_event_filter *filter,
 					 gchar **systems,
 					 gint *events)
 {
 	struct tep_handle *pevent;
-	struct event_filter *copy;
+	struct tep_event_filter *copy;
 	struct tep_event_format *event;
 	int i;
 
@@ -2017,7 +2017,7 @@ void trace_filter_convert_char_to_filter(struct event_filter *filter,
 }
 
 int trace_filter_save_events(struct tracecmd_xml_handle *handle,
-			     struct event_filter *filter)
+			     struct tep_event_filter *filter)
 {
 	struct tep_event_format *event;
 	char **systems;
@@ -2082,7 +2082,7 @@ int trace_filter_save_tasks(struct tracecmd_xml_handle *handle,
 	return 0;
 }
 
-int trace_filter_load_events(struct event_filter *event_filter,
+int trace_filter_load_events(struct tep_event_filter *event_filter,
 			     struct tracecmd_xml_handle *handle,
 			     struct tracecmd_xml_system_node *node)
 {
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index 862bdcd..c3b99e4 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -2256,7 +2256,7 @@ void trace_graph_adv_filter_callback(gboolean accept,
 				     gpointer data)
 {
 	struct graph_info *ginfo = data;
-	struct event_filter *event_filter;
+	struct tep_event_filter *event_filter;
 	char error_str[200];
 	int ret;
 	int i;
@@ -2295,7 +2295,7 @@ void trace_graph_adv_filter_callback(gboolean accept,
 
 void trace_graph_copy_filter(struct graph_info *ginfo,
 			     gboolean all_events,
-			     struct event_filter *event_filter)
+			     struct tep_event_filter *event_filter)
 {
 	if (all_events) {
 		ginfo->all_events = TRUE;
@@ -2625,7 +2625,7 @@ static int load_event_filter(struct graph_info *ginfo,
 			     struct tracecmd_xml_system_node *node)
 {
 	struct tracecmd_xml_system_node *child;
-	struct event_filter *event_filter;
+	struct tep_event_filter *event_filter;
 	const char *name;
 	const char *value;
 
@@ -2706,7 +2706,7 @@ int trace_graph_load_filters(struct graph_info *ginfo,
 int trace_graph_save_filters(struct graph_info *ginfo,
 			     struct tracecmd_xml_handle *handle)
 {
-	struct event_filter *event_filter;
+	struct tep_event_filter *event_filter;
 
 	tracecmd_xml_start_system(handle, "TraceGraph");
 
diff --git a/kernel-shark/trace-view-main.c b/kernel-shark/trace-view-main.c
index faaef99..257f8b3 100644
--- a/kernel-shark/trace-view-main.c
+++ b/kernel-shark/trace-view-main.c
@@ -146,7 +146,7 @@ static void
 events_clicked (gpointer data)
 {
 	struct trace_tree_info *info = data;
-	struct event_filter *event_filter;
+	struct tep_event_filter *event_filter;
 	GtkTreeView *trace_tree = GTK_TREE_VIEW(info->trace_tree);
 	GtkTreeModel *model;
 	TraceViewStore *store;
@@ -172,7 +172,7 @@ static void
 adv_filter_clicked (gpointer data)
 {
 	struct trace_tree_info *info = data;
-	struct event_filter *event_filter;
+	struct tep_event_filter *event_filter;
 	GtkTreeView *trace_tree = GTK_TREE_VIEW(info->trace_tree);
 	GtkTreeModel *model;
 	TraceViewStore *store;
diff --git a/kernel-shark/trace-view.c b/kernel-shark/trace-view.c
index 2f50361..2787158 100644
--- a/kernel-shark/trace-view.c
+++ b/kernel-shark/trace-view.c
@@ -404,7 +404,7 @@ void trace_view_event_filter_callback(gboolean accept,
 				      gint *events,
 				      gpointer data)
 {
-	struct event_filter *event_filter;
+	struct tep_event_filter *event_filter;
 	GtkTreeView *trace_tree = data;
 	GtkTreeModel *model;
 	TraceViewStore *store;
@@ -439,7 +439,7 @@ void trace_view_adv_filter_callback(gboolean accept,
 				    gint *event_ids,
 				    gpointer data)
 {
-	struct event_filter *event_filter;
+	struct tep_event_filter *event_filter;
 	GtkTreeView *trace_tree = data;
 	GtkTreeModel *model;
 	TraceViewStore *store;
@@ -484,10 +484,10 @@ void trace_view_adv_filter_callback(gboolean accept,
 
 void trace_view_copy_filter(GtkWidget *treeview,
 			    gboolean all_events,
-			    struct event_filter *src_event_filter)
+			    struct tep_event_filter *src_event_filter)
 {
 	GtkTreeView *trace_tree;
-	struct event_filter *event_filter;
+	struct tep_event_filter *event_filter;
 	GtkTreeModel *model;
 	TraceViewStore *store;
 
@@ -944,7 +944,7 @@ void trace_view_search_setup(GtkBox *box, GtkTreeView *treeview)
 int trace_view_save_filters(struct tracecmd_xml_handle *handle,
 			    GtkTreeView *trace_tree)
 {
-	struct event_filter *event_filter;
+	struct tep_event_filter *event_filter;
 	GtkTreeModel *model;
 	TraceViewStore *store;
 	gboolean all_events;
@@ -981,7 +981,7 @@ static int load_event_filter(TraceViewStore *store,
 			     struct tracecmd_xml_system_node *node)
 {
 	struct tracecmd_xml_system_node *child;
-	struct event_filter *event_filter;
+	struct tep_event_filter *event_filter;
 	const char *name;
 	const char *value;
 
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index b9ca1b9..875bfaf 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -94,8 +94,8 @@ static enum tep_event_type read_token(char **tok)
 
 static int filter_cmp(const void *a, const void *b)
 {
-	const struct filter_type *ea = a;
-	const struct filter_type *eb = b;
+	const struct tep_filter_type *ea = a;
+	const struct tep_filter_type *eb = b;
 
 	if (ea->event_id < eb->event_id)
 		return -1;
@@ -106,11 +106,11 @@ static int filter_cmp(const void *a, const void *b)
 	return 0;
 }
 
-static struct filter_type *
-find_filter_type(struct event_filter *filter, int id)
+static struct tep_filter_type *
+find_filter_type(struct tep_event_filter *filter, int id)
 {
-	struct filter_type *filter_type;
-	struct filter_type key;
+	struct tep_filter_type *filter_type;
+	struct tep_filter_type key;
 
 	key.event_id = id;
 
@@ -122,10 +122,10 @@ find_filter_type(struct event_filter *filter, int id)
 	return filter_type;
 }
 
-static struct filter_type *
-add_filter_type(struct event_filter *filter, int id)
+static struct tep_filter_type *
+add_filter_type(struct tep_event_filter *filter, int id)
 {
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 	int i;
 
 	filter_type = find_filter_type(filter, id);
@@ -165,9 +165,9 @@ add_filter_type(struct event_filter *filter, int id)
  * tep_filter_alloc - create a new event filter
  * @pevent: The pevent that this filter is associated with
  */
-struct event_filter *tep_filter_alloc(struct tep_handle *pevent)
+struct tep_event_filter *tep_filter_alloc(struct tep_handle *pevent)
 {
-	struct event_filter *filter;
+	struct tep_event_filter *filter;
 
 	filter = malloc(sizeof(*filter));
 	if (filter == NULL)
@@ -1204,10 +1204,10 @@ process_event(struct tep_event_format *event, const char *filter_str,
 }
 
 static enum tep_errno
-filter_event(struct event_filter *filter, struct tep_event_format *event,
+filter_event(struct tep_event_filter *filter, struct tep_event_format *event,
 	     const char *filter_str, char *error_str)
 {
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 	struct tep_filter_arg *arg;
 	enum tep_errno ret;
 
@@ -1237,7 +1237,7 @@ filter_event(struct event_filter *filter, struct tep_event_format *event,
 	return 0;
 }
 
-static void filter_init_error_buf(struct event_filter *filter)
+static void filter_init_error_buf(struct tep_event_filter *filter)
 {
 	/* clear buffer to reset show error */
 	tep_buffer_init("", 0);
@@ -1253,7 +1253,7 @@ static void filter_init_error_buf(struct event_filter *filter)
  * negative error code.  Use tep_filter_strerror() to see
  * actual error message in case of error.
  */
-enum tep_errno tep_filter_add_filter_str(struct event_filter *filter,
+enum tep_errno tep_filter_add_filter_str(struct tep_event_filter *filter,
 					 const char *filter_str)
 {
 	struct tep_handle *pevent = filter->pevent;
@@ -1351,7 +1351,7 @@ enum tep_errno tep_filter_add_filter_str(struct event_filter *filter,
 	return rtn;
 }
 
-static void free_filter_type(struct filter_type *filter_type)
+static void free_filter_type(struct tep_filter_type *filter_type)
 {
 	free_arg(filter_type->filter);
 }
@@ -1365,7 +1365,7 @@ static void free_filter_type(struct filter_type *filter_type)
  *
  * Returns 0 if message was filled successfully, -1 if error
  */
-int tep_filter_strerror(struct event_filter *filter, enum tep_errno err,
+int tep_filter_strerror(struct tep_event_filter *filter, enum tep_errno err,
 			char *buf, size_t buflen)
 {
 	if (err <= __TEP_ERRNO__START || err >= __TEP_ERRNO__END)
@@ -1393,10 +1393,10 @@ int tep_filter_strerror(struct event_filter *filter, enum tep_errno err,
  * Returns 1: if an event was removed
  *   0: if the event was not found
  */
-int tep_filter_remove_event(struct event_filter *filter,
+int tep_filter_remove_event(struct tep_event_filter *filter,
 			    int event_id)
 {
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 	unsigned long len;
 
 	if (!filter->filters)
@@ -1428,7 +1428,7 @@ int tep_filter_remove_event(struct event_filter *filter,
  *
  * Removes all filters from a filter and resets it.
  */
-void tep_filter_reset(struct event_filter *filter)
+void tep_filter_reset(struct tep_event_filter *filter)
 {
 	int i;
 
@@ -1440,7 +1440,7 @@ void tep_filter_reset(struct event_filter *filter)
 	filter->event_filters = NULL;
 }
 
-void tep_filter_free(struct event_filter *filter)
+void tep_filter_free(struct tep_event_filter *filter)
 {
 	tep_unref(filter->pevent);
 
@@ -1449,11 +1449,11 @@ void tep_filter_free(struct event_filter *filter)
 	free(filter);
 }
 
-static char *arg_to_str(struct event_filter *filter, struct tep_filter_arg *arg);
+static char *arg_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg);
 
-static int copy_filter_type(struct event_filter *filter,
-			     struct event_filter *source,
-			     struct filter_type *filter_type)
+static int copy_filter_type(struct tep_event_filter *filter,
+			    struct tep_event_filter *source,
+			    struct tep_filter_type *filter_type)
 {
 	struct tep_filter_arg *arg;
 	struct tep_event_format *event;
@@ -1507,7 +1507,7 @@ static int copy_filter_type(struct event_filter *filter,
  *
  * Returns 0 on success and -1 if not all filters were copied
  */
-int tep_filter_copy(struct event_filter *dest, struct event_filter *source)
+int tep_filter_copy(struct tep_event_filter *dest, struct tep_event_filter *source)
 {
 	int ret = 0;
 	int i;
@@ -1533,13 +1533,13 @@ int tep_filter_copy(struct event_filter *dest, struct event_filter *source)
  * Returns 0 on success and -1 if there was a problem updating, but
  *   events may have still been updated on error.
  */
-int tep_update_trivial(struct event_filter *dest, struct event_filter *source,
+int tep_update_trivial(struct tep_event_filter *dest, struct tep_event_filter *source,
 		       enum filter_trivial_type type)
 {
 	struct tep_handle *src_pevent;
 	struct tep_handle *dest_pevent;
 	struct tep_event_format *event;
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 	struct tep_filter_arg *arg;
 	char *str;
 	int i;
@@ -1592,10 +1592,10 @@ int tep_update_trivial(struct event_filter *dest, struct event_filter *source,
  *
  * Returns 0 on success and -1 if there was a problem.
  */
-int tep_filter_clear_trivial(struct event_filter *filter,
+int tep_filter_clear_trivial(struct tep_event_filter *filter,
 			     enum filter_trivial_type type)
 {
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 	int count = 0;
 	int *ids = NULL;
 	int i;
@@ -1654,11 +1654,11 @@ int tep_filter_clear_trivial(struct event_filter *filter,
  * Returns 1 if the event contains a matching trivial type
  *  otherwise 0.
  */
-int tep_filter_event_has_trivial(struct event_filter *filter,
+int tep_filter_event_has_trivial(struct tep_event_filter *filter,
 				 int event_id,
 				 enum filter_trivial_type type)
 {
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 
 	if (!filter->filters)
 		return 0;
@@ -2008,9 +2008,9 @@ static int test_filter(struct tep_event_format *event, struct tep_filter_arg *ar
  * Returns 1 if filter found for @event_id
  *   otherwise 0;
  */
-int tep_event_filtered(struct event_filter *filter, int event_id)
+int tep_event_filtered(struct tep_event_filter *filter, int event_id)
 {
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 
 	if (!filter->filters)
 		return 0;
@@ -2032,11 +2032,11 @@ int tep_event_filtered(struct event_filter *filter, int event_id)
  * NO_FILTER - if no filters exist
  * otherwise - error occurred during test
  */
-enum tep_errno tep_filter_match(struct event_filter *filter,
+enum tep_errno tep_filter_match(struct tep_event_filter *filter,
 				struct tep_record *record)
 {
 	struct tep_handle *pevent = filter->pevent;
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 	int event_id;
 	int ret;
 	enum tep_errno err = 0;
@@ -2059,7 +2059,7 @@ enum tep_errno tep_filter_match(struct event_filter *filter,
 	return ret ? TEP_ERRNO__FILTER_MATCH : TEP_ERRNO__FILTER_MISS;
 }
 
-static char *op_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
+static char *op_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *str = NULL;
 	char *left = NULL;
@@ -2163,7 +2163,7 @@ static char *op_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
 	return str;
 }
 
-static char *val_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
+static char *val_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *str = NULL;
 
@@ -2172,12 +2172,12 @@ static char *val_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
 	return str;
 }
 
-static char *field_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
+static char *field_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg)
 {
 	return strdup(arg->field.field->name);
 }
 
-static char *exp_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
+static char *exp_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *lstr;
 	char *rstr;
@@ -2233,7 +2233,7 @@ out:
 	return str;
 }
 
-static char *num_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
+static char *num_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *lstr;
 	char *rstr;
@@ -2283,7 +2283,7 @@ out:
 	return str;
 }
 
-static char *str_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
+static char *str_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *str = NULL;
 	char *op = NULL;
@@ -2315,7 +2315,7 @@ static char *str_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
 	return str;
 }
 
-static char *arg_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
+static char *arg_to_str(struct tep_event_filter *filter, struct tep_filter_arg *arg)
 {
 	char *str = NULL;
 
@@ -2359,9 +2359,9 @@ static char *arg_to_str(struct event_filter *filter, struct tep_filter_arg *arg)
  *  NULL is returned if no filter is found or allocation failed.
  */
 char *
-tep_filter_make_string(struct event_filter *filter, int event_id)
+tep_filter_make_string(struct tep_event_filter *filter, int event_id)
 {
-	struct filter_type *filter_type;
+	struct tep_filter_type *filter_type;
 
 	if (!filter->filters)
 		return NULL;
@@ -2383,10 +2383,10 @@ tep_filter_make_string(struct event_filter *filter, int event_id)
  *  1 if the two filters hold the same content.
  *  0 if they do not.
  */
-int tep_filter_compare(struct event_filter *filter1, struct event_filter *filter2)
+int tep_filter_compare(struct tep_event_filter *filter1, struct tep_event_filter *filter2)
 {
-	struct filter_type *filter_type1;
-	struct filter_type *filter_type2;
+	struct tep_filter_type *filter_type1;
+	struct tep_filter_type *filter_type2;
 	char *str1, *str2;
 	int result;
 	int i;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 9c23bbf..6aa0b5e 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -36,7 +36,7 @@ static struct filter_str **filter_next = &filter_strings;
 
 struct filter {
 	struct filter		*next;
-	struct event_filter	*filter;
+	struct tep_event_filter	*filter;
 };
 
 struct event_str {
-- 
2.17.1
