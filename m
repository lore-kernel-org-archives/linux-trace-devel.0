Return-Path: <SRS0=01Tb=JF=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37990 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937149AbeFSNXq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Jun 2018 09:23:46 -0400
Received: by mail-wm0-f53.google.com with SMTP id 69-v6so411764wmf.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Jun 2018 06:23:45 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/2] trace-filter: Change the naming convention used in trace-filter-hash
Date: Tue, 19 Jun 2018 16:22:58 +0300
Message-Id: <20180619132259.21387-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The trace-filter-hash code implements a set of hashing utilities for
filtering the trace data. Currently, only tasks are filtered with this
utility via its pid. To use this tool for filtering other items such as
events, a name change is required for the structures and functions
used. Instead of using the term "task", use the term "id", which is
more generic, and will be less confusing when using the
trace-filter-hash for filtering events and such.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/include/kernel-shark.h      |   4 +-
 kernel-shark/include/trace-filter-hash.h |  31 +++--
 kernel-shark/include/trace-filter.h      |  12 +-
 kernel-shark/include/trace-graph.h       |  16 +--
 kernel-shark/include/trace-view-store.h  |  12 +-
 kernel-shark/include/trace-view.h        |   4 +-
 kernel-shark/kernel-shark.c              | 100 ++++++++--------
 kernel-shark/trace-filter-hash.c         | 143 ++++++++++++-----------
 kernel-shark/trace-filter.c              |  18 +--
 kernel-shark/trace-graph.c               |  48 ++++----
 kernel-shark/trace-view-main.c           |  22 ++--
 kernel-shark/trace-view-store.c          |  30 ++---
 kernel-shark/trace-view.c                |   4 +-
 13 files changed, 222 insertions(+), 222 deletions(-)

diff --git a/kernel-shark/include/kernel-shark.h b/kernel-shark/include/kernel-shark.h
index a673dbd..1934583 100644
--- a/kernel-shark/include/kernel-shark.h
+++ b/kernel-shark/include/kernel-shark.h
@@ -48,8 +48,8 @@ struct shark_info {
 	gboolean			graph_follows;
 	gboolean			sync_task_filters;
 	gboolean			sync_event_filters;
-	struct filter_task		*list_task_filter;
-	struct filter_task		*list_hide_tasks;
+	struct filter_id		*list_task_filter;
+	struct filter_id		*list_hide_tasks;
 
 	/* Save capture state. */
 	gboolean			cap_all_events;
diff --git a/kernel-shark/include/trace-filter-hash.h b/kernel-shark/include/trace-filter-hash.h
index ceb4ad9..5cc39dc 100644
--- a/kernel-shark/include/trace-filter-hash.h
+++ b/kernel-shark/include/trace-filter-hash.h
@@ -22,28 +22,27 @@
 
 #include "trace-hash-local.h"
 
-struct filter_task_item {
-	struct filter_task_item	*next;
-	int			pid;
+struct filter_id_item {
+	struct filter_id_item	*next;
+	int			id;
 };
 
-struct filter_task {
-	struct filter_task_item **hash;
+struct filter_id {
+	struct filter_id_item **hash;
 	int			count;
 };
 
-struct filter_task_item *
-filter_task_find_pid(struct filter_task *hash, int pid);
-void filter_task_add_pid(struct filter_task *hash, int pid);
-void filter_task_remove_pid(struct filter_task *hash, int pid);
-void filter_task_clear(struct filter_task *hash);
-struct filter_task *filter_task_hash_alloc(void);
-void filter_task_hash_free(struct filter_task *hash);
-struct filter_task *filter_task_hash_copy(struct filter_task *hash);
-int *filter_task_pids(struct filter_task *hash);
-int filter_task_compare(struct filter_task *hash1, struct filter_task *hash2);
+struct filter_id_item *filter_id_find(struct filter_id *hash, int id);
+void filter_id_add(struct filter_id *hash, int id);
+void filter_id_remove(struct filter_id *hash, int id);
+void filter_id_clear(struct filter_id *hash);
+struct filter_id *filter_id_hash_alloc(void);
+void filter_id_hash_free(struct filter_id *hash);
+struct filter_id *filter_id_hash_copy(struct filter_id *hash);
+int *filter_ids(struct filter_id *hash);
+int filter_id_compare(struct filter_id *hash1, struct filter_id *hash2);
 
-static inline int filter_task_count(struct filter_task *hash)
+static inline int filter_task_count(struct filter_id *hash)
 {
 	return hash->count;
 }
diff --git a/kernel-shark/include/trace-filter.h b/kernel-shark/include/trace-filter.h
index d547095..4ddbd22 100644
--- a/kernel-shark/include/trace-filter.h
+++ b/kernel-shark/include/trace-filter.h
@@ -146,21 +146,21 @@ void trace_array_add(gint **array, gint *count, gint val);
 int trace_filter_save_events(struct tracecmd_xml_handle *handle,
 			     struct event_filter *filter);
 int trace_filter_save_tasks(struct tracecmd_xml_handle *handle,
-			    struct filter_task *filter);
+			    struct filter_id *filter);
 int trace_filter_load_events(struct event_filter *event_filter,
 			     struct tracecmd_xml_handle *handle,
 			     struct tracecmd_xml_system_node *node);
-int trace_filter_load_task_filter(struct filter_task *filter,
+int trace_filter_load_task_filter(struct filter_id *filter,
 				  struct tracecmd_xml_handle *handle,
 				  struct tracecmd_xml_system_node *node);
 int trace_filter_load_filters(struct tracecmd_xml_handle *handle,
 			      const char *system_name,
-			      struct filter_task *task_filter,
-			      struct filter_task *hide_tasks);
+			      struct filter_id *task_filter,
+			      struct filter_id *hide_tasks);
 int trace_filter_save_filters(struct tracecmd_xml_handle *handle,
 			      const char *system_name,
-			      struct filter_task *task_filter,
-			      struct filter_task *hide_tasks);
+			      struct filter_id *task_filter,
+			      struct filter_id *hide_tasks);
 
 GtkWidget *trace_create_event_list_view(struct pevent *pevent,
 					struct event_filter *filter,
diff --git a/kernel-shark/include/trace-graph.h b/kernel-shark/include/trace-graph.h
index 7e66838..0f35e59 100644
--- a/kernel-shark/include/trace-graph.h
+++ b/kernel-shark/include/trace-graph.h
@@ -29,8 +29,8 @@ struct graph_info;
 
 typedef void (graph_select_cb)(struct graph_info *ginfo, guint64 time);
 typedef void (graph_filter_cb)(struct graph_info *ginfo,
-			       struct filter_task *task_filter,
-			       struct filter_task *hide_tasks);
+			       struct filter_id *task_filter,
+			       struct filter_id *hide_tasks);
 
 /* Used for quereing what plots are defined */
 enum graph_plot_type {
@@ -248,10 +248,10 @@ struct graph_info {
 
 	gboolean		read_comms;	/* Read all comms on first load */
 
-	struct filter_task	*task_filter;
+	struct filter_id	*task_filter;
 	gint			filter_task_selected;
 
-	struct filter_task	*hide_tasks;
+	struct filter_id	*hide_tasks;
 
 	/* Box info for plot data info window */
 	gint			plot_data_x;
@@ -296,9 +296,9 @@ static inline GtkWidget *trace_graph_get_window(struct graph_info *ginfo)
 
 void trace_graph_refresh(struct graph_info *ginfo);
 
-struct filter_task_item *
+struct filter_id_item *
 trace_graph_filter_task_find_pid(struct graph_info *ginfo, gint pid);
-struct filter_task_item *
+struct filter_id_item *
 trace_graph_hide_task_find_pid(struct graph_info *ginfo, gint pid);
 void trace_graph_filter_toggle(struct graph_info *ginfo);
 void trace_graph_filter_add_remove_task(struct graph_info *info,
@@ -331,8 +331,8 @@ int trace_graph_load_filters(struct graph_info *ginfo,
 int trace_graph_save_filters(struct graph_info *ginfo,
 			     struct tracecmd_xml_handle *handle);
 void trace_graph_update_filters(struct graph_info *ginfo,
-				struct filter_task *task_filter,
-				struct filter_task *hide_tasks);
+				struct filter_id *task_filter,
+				struct filter_id *hide_tasks);
 void trace_graph_refresh_filters(struct graph_info *ginfo);
 
 /* plots */
diff --git a/kernel-shark/include/trace-view-store.h b/kernel-shark/include/trace-view-store.h
index 03141b1..1204c4b 100644
--- a/kernel-shark/include/trace-view-store.h
+++ b/kernel-shark/include/trace-view-store.h
@@ -117,8 +117,8 @@ struct trace_view_store
 	gint			all_events; /* set 1 when all events are enabled */
 						/* else */
 	struct event_filter	*event_filter; /* Filtered events */
-	struct filter_task	*task_filter;	/* hash of tasks to filter on */
-	struct filter_task	*hide_tasks;	/* hash of tasks to not display */
+	struct filter_id	*task_filter;	/* hash of tasks to filter on */
+	struct filter_id	*hide_tasks;	/* hash of tasks to not display */
 
 	gint			all_cpus;   /* set 1 when all cpus are enabled */
 						/* else */
@@ -141,13 +141,13 @@ gint trace_view_store_get_timestamp_page(TraceViewStore *store, guint64 ts);
 
 gint trace_view_store_get_timestamp_visible_row(TraceViewStore *store, guint64 ts);
 
-void trace_view_store_filter_tasks(TraceViewStore *store, struct filter_task *filter);
+void trace_view_store_filter_tasks(TraceViewStore *store, struct filter_id *filter);
 
-void trace_view_store_hide_tasks(TraceViewStore *store, struct filter_task *filter);
+void trace_view_store_hide_tasks(TraceViewStore *store, struct filter_id *filter);
 
 void trace_view_store_assign_filters(TraceViewStore *store,
-				     struct filter_task *task_filter,
-				     struct filter_task *hide_tasks);
+				     struct filter_id *task_filter,
+				     struct filter_id *hide_tasks);
 
 TraceViewRecord *trace_view_store_get_row(TraceViewStore *store, gint row);
 
diff --git a/kernel-shark/include/trace-view.h b/kernel-shark/include/trace-view.h
index 93a10f6..036f51e 100644
--- a/kernel-shark/include/trace-view.h
+++ b/kernel-shark/include/trace-view.h
@@ -34,8 +34,8 @@ void trace_view_reload(GtkWidget *view, struct tracecmd_input *handle,
 void trace_view(int argc, char **argv);
 
 void trace_view_update_filters(GtkWidget *treeview,
-			       struct filter_task *task_filter,
-			       struct filter_task *hide_tasks);
+			       struct filter_id *task_filter,
+			       struct filter_id *hide_tasks);
 
 void trace_view_make_selection_visible(GtkWidget *treeview);
 
diff --git a/kernel-shark/kernel-shark.c b/kernel-shark/kernel-shark.c
index 89723c3..33ada31 100644
--- a/kernel-shark/kernel-shark.c
+++ b/kernel-shark/kernel-shark.c
@@ -137,8 +137,8 @@ static int trace_sync_select_menu(const gchar *title,
 }
 
 static void update_tree_view_filters(struct shark_info *info,
-				     struct filter_task *task_filter,
-				     struct filter_task *hide_tasks)
+				     struct filter_id *task_filter,
+				     struct filter_id *hide_tasks)
 {
 	if (info->list_filter_enabled)
 		trace_view_update_filters(info->treeview,
@@ -193,8 +193,8 @@ static void ks_graph_select(struct graph_info *ginfo, guint64 cursor)
 }
 
 static void ks_graph_filter(struct graph_info *ginfo,
-			    struct filter_task *task_filter,
-			    struct filter_task *hide_tasks)
+			    struct filter_id *task_filter,
+			    struct filter_id *hide_tasks)
 {
 	struct graph_callbacks *cbs;
 	struct shark_info *info;
@@ -213,8 +213,8 @@ static void free_info(struct shark_info *info)
 	tracecmd_close(info->handle);
 	trace_graph_free_info(info->ginfo);
 
-	filter_task_hash_free(info->list_task_filter);
-	filter_task_hash_free(info->list_hide_tasks);
+	filter_id_hash_free(info->list_task_filter);
+	filter_id_hash_free(info->list_hide_tasks);
 
 	kernel_shark_clear_capture(info);
 
@@ -253,8 +253,8 @@ static void unsync_task_filters(struct shark_info *info)
 	gtk_widget_show(info->list_hide_task_menu);
 
 	/* The list now uses its own hash */
-	info->list_task_filter = filter_task_hash_copy(info->ginfo->task_filter);
-	info->list_hide_tasks = filter_task_hash_copy(info->ginfo->hide_tasks);
+	info->list_task_filter = filter_id_hash_copy(info->ginfo->task_filter);
+	info->list_hide_tasks = filter_id_hash_copy(info->ginfo->hide_tasks);
 }
 
 static void sync_task_filters(struct shark_info *info)
@@ -407,8 +407,8 @@ static void load_filter(struct shark_info *info, const char *filename)
 	GtkTreeModel *model;
 	TraceViewStore *store;
 	struct tracecmd_xml_handle *handle;
-	struct filter_task *task_filter;
-	struct filter_task *hide_tasks;
+	struct filter_id *task_filter;
+	struct filter_id *hide_tasks;
 	struct event_filter *event_filter;
 	int ret;
 
@@ -427,8 +427,8 @@ static void load_filter(struct shark_info *info, const char *filename)
 	ret = tracecmd_xml_system_exists(handle,
 					 "GraphTaskFilter");
 	if (ret) {
-		filter_task_clear(ginfo->task_filter);
-		filter_task_clear(ginfo->hide_tasks);
+		filter_id_clear(ginfo->task_filter);
+		filter_id_clear(ginfo->hide_tasks);
 
 		trace_filter_load_filters(handle,
 					  "GraphTaskFilter",
@@ -442,8 +442,8 @@ static void load_filter(struct shark_info *info, const char *filename)
 	if (ret) {
 		task_filter = info->list_task_filter;
 		hide_tasks = info->list_hide_tasks;
-		filter_task_clear(task_filter);
-		filter_task_clear(hide_tasks);
+		filter_id_clear(task_filter);
+		filter_id_clear(hide_tasks);
 
 		trace_filter_load_filters(handle,
 					  "ListTaskFilter",
@@ -461,9 +461,9 @@ static void load_filter(struct shark_info *info, const char *filename)
 	 * If the events or tasks filters are the same for both
 	 * the list and graph, then sync them back.
 	 */
-	if (filter_task_compare(ginfo->task_filter,
+	if (filter_id_compare(ginfo->task_filter,
 				info->list_task_filter) &&
-	    filter_task_compare(ginfo->hide_tasks,
+	    filter_id_compare(ginfo->hide_tasks,
 				info->list_hide_tasks))
 		sync_task_filters(info);
 
@@ -516,8 +516,8 @@ static void save_filters(struct shark_info *info, const char *filename)
 	struct graph_info *ginfo = info->ginfo;
 	struct tracecmd_xml_handle *handle;
 	GtkTreeView *trace_tree = GTK_TREE_VIEW(info->treeview);
-	struct filter_task *task_filter;
-	struct filter_task *hide_tasks;
+	struct filter_id *task_filter;
+	struct filter_id *hide_tasks;
 
 	handle = tracecmd_xml_create(filename, VERSION_STRING);
 	if (!handle) {
@@ -748,8 +748,8 @@ static void
 sync_task_filter_clicked (GtkWidget *subitem, gpointer data)
 {
 	struct shark_info *info = data;
-	struct filter_task *task_filter;
-	struct filter_task *hide_tasks;
+	struct filter_id *task_filter;
+	struct filter_id *hide_tasks;
 	GtkTreeView *trace_tree = GTK_TREE_VIEW(info->treeview);
 	GtkTreeModel *model;
 	gboolean keep;
@@ -770,9 +770,9 @@ sync_task_filter_clicked (GtkWidget *subitem, gpointer data)
 		return;
 
 	/* If they are already equal, then just perminently sync them */
-	if (filter_task_compare(info->ginfo->task_filter,
+	if (filter_id_compare(info->ginfo->task_filter,
 				info->list_task_filter) &&
-	    filter_task_compare(info->ginfo->hide_tasks,
+	    filter_id_compare(info->ginfo->hide_tasks,
 				info->list_hide_tasks))
 		result = 2;
 
@@ -784,8 +784,8 @@ sync_task_filter_clicked (GtkWidget *subitem, gpointer data)
 	switch (result) {
 	case 0:
 		/* Sync List Filter with Graph Filter */
-		filter_task_hash_free(info->list_task_filter);
-		filter_task_hash_free(info->list_hide_tasks);
+		filter_id_hash_free(info->list_task_filter);
+		filter_id_hash_free(info->list_hide_tasks);
 
 		info->list_task_filter = NULL;
 		info->list_hide_tasks = NULL;
@@ -794,8 +794,8 @@ sync_task_filter_clicked (GtkWidget *subitem, gpointer data)
 		hide_tasks = info->ginfo->hide_tasks;
 
 		if (!keep) {
-			info->list_task_filter = filter_task_hash_copy(task_filter);
-			info->list_hide_tasks = filter_task_hash_copy(hide_tasks);
+			info->list_task_filter = filter_id_hash_copy(task_filter);
+			info->list_hide_tasks = filter_id_hash_copy(hide_tasks);
 		}
 
 		update_tree_view_filters(info, task_filter, hide_tasks);
@@ -808,8 +808,8 @@ sync_task_filter_clicked (GtkWidget *subitem, gpointer data)
 					   info->list_hide_tasks);
 
 		if (keep) {
-			filter_task_hash_free(info->list_task_filter);
-			filter_task_hash_free(info->list_hide_tasks);
+			filter_id_hash_free(info->list_task_filter);
+			filter_id_hash_free(info->list_hide_tasks);
 
 			info->list_task_filter = NULL;
 			info->list_hide_tasks = NULL;
@@ -896,7 +896,7 @@ static void
 __update_list_task_filter_callback(struct shark_info *info,
 				   gboolean accept,
 				   gint *selected,
-				   struct filter_task *task_filter)
+				   struct filter_id *task_filter)
 {
 	GtkTreeView *trace_tree = GTK_TREE_VIEW(info->treeview);
 	GtkTreeModel *model;
@@ -909,11 +909,11 @@ __update_list_task_filter_callback(struct shark_info *info,
 	if (!model)
 		return;
 
-	filter_task_clear(task_filter);
+	filter_id_clear(task_filter);
 
 	if (selected) {
 		for (i = 0; selected[i] >= 0; i++)
-			filter_task_add_pid(task_filter, selected[i]);
+			filter_id_add(task_filter, selected[i]);
 	}
 
 	update_tree_view_filters(info, info->list_task_filter, info->list_hide_tasks);
@@ -952,7 +952,7 @@ update_list_hide_task_filter_callback(gboolean accept,
 /* Callback for the clicked signal of the List Tasks filter button */
 static void
 __list_tasks_clicked (struct shark_info *info,
-		      struct filter_task *task_filter,
+		      struct filter_id *task_filter,
 		      trace_task_cb_func func)
 {
 	GtkTreeView *trace_tree = GTK_TREE_VIEW(info->treeview);
@@ -969,7 +969,7 @@ __list_tasks_clicked (struct shark_info *info,
 		return;
 
 	tasks = trace_graph_task_list(ginfo);
-	selected = filter_task_pids(task_filter);
+	selected = filter_ids(task_filter);
 
 	trace_task_dialog(info->handle, tasks, selected, func, info);
 
@@ -999,7 +999,7 @@ static void
 __update_graph_task_filter_callback(struct shark_info *info,
 				  gboolean accept,
 				  gint *selected,
-				  struct filter_task *task_filter)
+				  struct filter_id *task_filter)
 {
 	struct graph_info *ginfo = info->ginfo;
 	int i;
@@ -1007,11 +1007,11 @@ __update_graph_task_filter_callback(struct shark_info *info,
 	if (!accept)
 		return;
 
-	filter_task_clear(task_filter);
+	filter_id_clear(task_filter);
 
 	if (selected) {
 		for (i = 0; selected[i] >= 0; i++)
-			filter_task_add_pid(task_filter, selected[i]);
+			filter_id_add(task_filter, selected[i]);
 	}
 
 	trace_graph_refresh_filters(ginfo);
@@ -1057,7 +1057,7 @@ update_graph_hide_task_filter_callback(gboolean accept,
 /* Callback for the clicked signal of the Tasks filter button */
 static void
 __graph_tasks_clicked (struct shark_info *info,
-		       struct filter_task *task_filter,
+		       struct filter_id *task_filter,
 		       trace_task_cb_func func)
 {
 	struct graph_info *ginfo = info->ginfo;
@@ -1068,7 +1068,7 @@ __graph_tasks_clicked (struct shark_info *info,
 		return;
 
 	tasks = trace_graph_task_list(ginfo);
-	selected = filter_task_pids(task_filter);
+	selected = filter_ids(task_filter);
 
 	trace_task_dialog(ginfo->handle, tasks, selected, func, info);
 
@@ -1369,8 +1369,8 @@ static void
 filter_list_enable_clicked (gpointer data)
 {
 	struct shark_info *info = data;
-	struct filter_task *task_filter;
-	struct filter_task *hide_tasks;
+	struct filter_id *task_filter;
+	struct filter_id *hide_tasks;
 
 	info->list_filter_enabled ^= 1;
 
@@ -1391,22 +1391,22 @@ filter_list_enable_clicked (gpointer data)
 
 static void
 filter_update_list_filter(struct shark_info *info,
-			  struct filter_task *filter,
-			  struct filter_task *other_filter)
+			  struct filter_id *filter,
+			  struct filter_id *other_filter)
 {
-	struct filter_task_item *task;
+	struct filter_id_item *task;
 	int pid = info->selected_task;
 
-	task = filter_task_find_pid(filter, pid);
+	task = filter_id_find(filter, pid);
 	if (task) {
-		filter_task_remove_pid(filter, pid);
+		filter_id_remove(filter, pid);
 		if (!filter_task_count(filter) &&
 		    !filter_task_count(other_filter)) {
 			info->list_filter_enabled = 0;
 			info->list_filter_available = 0;
 		}
 	} else {
-		filter_task_add_pid(filter, pid);
+		filter_id_add(filter, pid);
 		info->list_filter_available = 1;
 	}
 }
@@ -1511,8 +1511,8 @@ filter_clear_tasks_clicked (gpointer data)
 		return;
 	}
 
-	filter_task_clear(info->list_task_filter);
-	filter_task_clear(info->list_hide_tasks);
+	filter_id_clear(info->list_task_filter);
+	filter_id_clear(info->list_hide_tasks);
 	trace_view_update_filters(info->treeview, NULL, NULL);
 
 	info->list_filter_available = 0;
@@ -1686,14 +1686,14 @@ do_tree_popup(GtkWidget *widget, GdkEventButton *event, gpointer data)
 				gtk_widget_hide(menu_filter_graph_hide_task);
 
 			} else {
-				if (filter_task_find_pid(info->list_task_filter, pid))
+				if (filter_id_find(info->list_task_filter, pid))
 					set_menu_label(menu_filter_add_task, comm, pid,
 						       "Remove %s-%d from List filter");
 				else
 					set_menu_label(menu_filter_add_task, comm, pid,
 						       "Add %s-%d to List filter");
 
-				if (filter_task_find_pid(info->list_hide_tasks, pid))
+				if (filter_id_find(info->list_hide_tasks, pid))
 					set_menu_label(menu_filter_hide_task, comm, pid,
 						       "Show %s-%d in List");
 				else
diff --git a/kernel-shark/trace-filter-hash.c b/kernel-shark/trace-filter-hash.c
index 36a1cdd..cf41250 100644
--- a/kernel-shark/trace-filter-hash.c
+++ b/kernel-shark/trace-filter-hash.c
@@ -25,174 +25,175 @@
 
 #include "trace-filter-hash.h"
 
-#define FILTER_TASK_HASH_SIZE	256
+#define FILTER_HASH_SIZE	256
 
-struct filter_task_item *
-filter_task_find_pid(struct filter_task *hash, int pid)
+struct filter_id_item *
+filter_id_find(struct filter_id *hash, int id)
 {
-	int key = trace_hash(pid) % FILTER_TASK_HASH_SIZE;
-	struct filter_task_item *task = hash->hash[key];
+	int key = trace_hash(id) % FILTER_HASH_SIZE;
+	struct filter_id_item *item = hash->hash[key];
 
-	while (task) {
-		if (task->pid == pid)
+	while (item) {
+		if (item->id == id)
 			break;
-		task = task->next;
+		item = item->next;
 	}
-	return task;
+
+	return item;
 }
 
-void filter_task_add_pid(struct filter_task *hash, int pid)
+void filter_id_add(struct filter_id *hash, int id)
 {
-	int key = trace_hash(pid) % FILTER_TASK_HASH_SIZE;
-	struct filter_task_item *task;
+	int key = trace_hash(id) % FILTER_HASH_SIZE;
+	struct filter_id_item *item;
 
-	task = calloc(1, sizeof(*task));
-	assert(task);
+	item = calloc(1, sizeof(*item));
+	assert(item);
 
-	task->pid = pid;
-	task->next = hash->hash[key];
-	hash->hash[key] = task;
+	item->id = id;
+	item->next = hash->hash[key];
+	hash->hash[key] = item;
 
 	hash->count++;
 }
 
-void filter_task_remove_pid(struct filter_task *hash, int pid)
+void filter_id_remove(struct filter_id *hash, int id)
 {
-	int key = trace_hash(pid) % FILTER_TASK_HASH_SIZE;
-	struct filter_task_item **next = &hash->hash[key];
-	struct filter_task_item *task;
+	int key = trace_hash(id) % FILTER_HASH_SIZE;
+	struct filter_id_item **next = &hash->hash[key];
+	struct filter_id_item *item;
 
 	while (*next) {
-		if ((*next)->pid == pid)
+		if ((*next)->id == id)
 			break;
 		next = &(*next)->next;
 	}
+
 	if (!*next)
 		return;
 
 	assert(hash->count);
 	hash->count--;
 
-	task = *next;
+	item = *next;
 
-	*next = task->next;
+	*next = item->next;
 
-	free(task);
+	free(item);
 }
 
-void filter_task_clear(struct filter_task *hash)
+void filter_id_clear(struct filter_id *hash)
 {
-	struct filter_task_item *task, *next;;
+	struct filter_id_item *item, *next;
 	int i;
 
-	for (i = 0; i < FILTER_TASK_HASH_SIZE; i++) {
+	for (i = 0; i < FILTER_HASH_SIZE; i++) {
 		next = hash->hash[i];
 		if (!next)
 			continue;
 
 		hash->hash[i] = NULL;
 		while (next) {
-			task = next;
-			next = task->next;
-			free(task);
+			item = next;
+			next = item->next;
+			free(item);
 		}
 	}
 
 	hash->count = 0;
 }
 
-struct filter_task *filter_task_hash_alloc(void)
+struct filter_id *filter_id_hash_alloc(void)
 {
-	struct filter_task *hash;
+	struct filter_id *hash;
 
 	hash = calloc(1, sizeof(*hash));
 	assert(hash);
-	hash->hash = calloc(FILTER_TASK_HASH_SIZE, sizeof(*hash->hash));
+	hash->hash = calloc(FILTER_HASH_SIZE, sizeof(*hash->hash));
 	hash->count = 0;
 
 	return hash;
 }
 
-void filter_task_hash_free(struct filter_task *hash)
+void filter_id_hash_free(struct filter_id *hash)
 {
 	if (!hash)
 		return;
 
-	filter_task_clear(hash);
+	filter_id_clear(hash);
 	free(hash->hash);
 	free(hash);
 }
 
-struct filter_task *filter_task_hash_copy(struct filter_task *hash)
+struct filter_id *filter_id_hash_copy(struct filter_id *hash)
 {
-	struct filter_task *new_hash;
-	struct filter_task_item *task, **ptask;
+	struct filter_id *new_hash;
+	struct filter_id_item *item, **pitem;
 	int i;
 
 	if (!hash)
 		return NULL;
 
-	new_hash = filter_task_hash_alloc();
+	new_hash = filter_id_hash_alloc();
 	assert(new_hash);
 
-	for (i = 0; i < FILTER_TASK_HASH_SIZE; i++) {
-		task = hash->hash[i];
-		if (!task)
+	for (i = 0; i < FILTER_HASH_SIZE; i++) {
+		item = hash->hash[i];
+		if (!item)
 			continue;
 
-		ptask = &new_hash->hash[i];
+		pitem = &new_hash->hash[i];
 
-		while (task) {
-			*ptask = calloc(1, sizeof(*ptask));
-			assert(*ptask);
-			**ptask = *task;
+		while (item) {
+			*pitem = calloc(1, sizeof(*item));
+			assert(*pitem);
+			**pitem = *item;
 
-			ptask = &(*ptask)->next;
-			task = task->next;
+			pitem = &(*pitem)->next;
+			item = item->next;
 		}
 	}
 
 	new_hash->count = hash->count;
-
 	return new_hash;
 }
 
-int *filter_task_pids(struct filter_task *hash)
+int *filter_ids(struct filter_id *hash)
 {
-	struct filter_task_item *task;
-	int *pids;
+	struct filter_id_item *item;
+	int *ids;
 	int count = 0;
 	int i;
 
 	if (!hash->count)
 		return NULL;
 
-	pids = malloc(sizeof(*pids) * (hash->count + 1));
-	if (!pids)
+	ids = malloc(sizeof(*ids) * (hash->count + 1));
+	if (!ids)
 		return NULL;
 
-	for (i = 0; i < FILTER_TASK_HASH_SIZE; i++) {
-		task = hash->hash[i];
-		while (task) {
-			pids[count++] = task->pid;
-			task = task->next;
+	for (i = 0; i < FILTER_HASH_SIZE; i++) {
+		item = hash->hash[i];
+		while (item) {
+			ids[count++] = item->id;
+			item = item->next;
 		}
 	}
-	pids[count] = -1;
 
-	return pids;
+	ids[count] = -1;
+	return ids;
 }
 
 /**
- * filter_task_compare - compare two task hashs to see if they are equal
+ * filter_id_compare - compare two id hashes to see if they are equal
  * @hash1: one hash to compare
  * @hash2: another hash to compare to @hash1
  *
  * Returns 1 if the two hashes are the same, 0 otherwise.
  */
-int filter_task_compare(struct filter_task *hash1, struct filter_task *hash2)
+int filter_id_compare(struct filter_id *hash1, struct filter_id *hash2)
 {
-	int *pids;
+	int *ids;
 	int ret = 0;
 	int i;
 
@@ -205,16 +206,16 @@ int filter_task_compare(struct filter_task *hash1, struct filter_task *hash2)
 		return 1;
 
 	/* Now compare the pids of one hash with the other */
-	pids = filter_task_pids(hash1);
-	for (i = 0; pids[i] >= 0; i++) {
-		if (!filter_task_find_pid(hash2, pids[i]))
+	ids = filter_ids(hash1);
+	for (i = 0; ids[i] >= 0; i++) {
+		if (!filter_id_find(hash2, ids[i]))
 			break;
 	}
 
-	if (pids[i] == -1)
+	if (ids[i] == -1)
 		ret = 1;
 
-	free(pids);
+	free(ids);
 
 	return ret;
 }
diff --git a/kernel-shark/trace-filter.c b/kernel-shark/trace-filter.c
index bd8cb11..f5c3f29 100644
--- a/kernel-shark/trace-filter.c
+++ b/kernel-shark/trace-filter.c
@@ -2076,13 +2076,13 @@ int trace_filter_save_events(struct tracecmd_xml_handle *handle,
 }
 
 int trace_filter_save_tasks(struct tracecmd_xml_handle *handle,
-			    struct filter_task *filter)
+			    struct filter_id *filter)
 {
 	char buffer[100];
 	int *pids;
 	int i;
 
-	pids = filter_task_pids(filter);
+	pids = filter_ids(filter);
 	if (!pids)
 		return -1;
 
@@ -2171,7 +2171,7 @@ int trace_filter_load_events(struct event_filter *event_filter,
 	return 0;
 }
 
-int trace_filter_load_task_filter(struct filter_task *filter,
+int trace_filter_load_task_filter(struct filter_id *filter,
 				  struct tracecmd_xml_handle *handle,
 				  struct tracecmd_xml_system_node *node)
 {
@@ -2190,8 +2190,8 @@ int trace_filter_load_task_filter(struct filter_task *filter,
 		if (strcmp(name, "Task") == 0) {
 			task = tracecmd_xml_node_value(handle, node);
 			pid = atoi(task);
-			if (!filter_task_find_pid(filter, pid))
-				filter_task_add_pid(filter, pid);
+			if (!filter_id_find(filter, pid))
+				filter_id_add(filter, pid);
 		}
 		node = tracecmd_xml_node_next(node);
 	}
@@ -2201,8 +2201,8 @@ int trace_filter_load_task_filter(struct filter_task *filter,
 
 int trace_filter_load_filters(struct tracecmd_xml_handle *handle,
 			      const char *system_name,
-			      struct filter_task *task_filter,
-			      struct filter_task *hide_tasks)
+			      struct filter_id *task_filter,
+			      struct filter_id *hide_tasks)
 {
 	struct tracecmd_xml_system *system;
 	struct tracecmd_xml_system_node *syschild;
@@ -2240,8 +2240,8 @@ int trace_filter_load_filters(struct tracecmd_xml_handle *handle,
 
 int trace_filter_save_filters(struct tracecmd_xml_handle *handle,
 			      const char *system_name,
-			      struct filter_task *task_filter,
-			      struct filter_task *hide_tasks)
+			      struct filter_id *task_filter,
+			      struct filter_id *hide_tasks)
 {
 
 	tracecmd_xml_start_system(handle, system_name);
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index 1db342f..b652297 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -225,28 +225,28 @@ static void init_event_cache(struct graph_info *ginfo)
 	ginfo->read_comms = TRUE;
 }
 
-struct filter_task_item *
+struct filter_id_item *
 trace_graph_filter_task_find_pid(struct graph_info *ginfo, gint pid)
 {
-	return filter_task_find_pid(ginfo->task_filter, pid);
+	return filter_id_find(ginfo->task_filter, pid);
 }
 
-struct filter_task_item *
+struct filter_id_item *
 trace_graph_hide_task_find_pid(struct graph_info *ginfo, gint pid)
 {
-	return filter_task_find_pid(ginfo->hide_tasks, pid);
+	return filter_id_find(ginfo->hide_tasks, pid);
 }
 
 static void graph_filter_task_add_pid(struct graph_info *ginfo, gint pid)
 {
-	filter_task_add_pid(ginfo->task_filter, pid);
+	filter_id_add(ginfo->task_filter, pid);
 
 	ginfo->filter_available = 1;
 }
 
 static void graph_filter_task_remove_pid(struct graph_info *ginfo, gint pid)
 {
-	filter_task_remove_pid(ginfo->task_filter, pid);
+	filter_id_remove(ginfo->task_filter, pid);
 
 	if (!filter_task_count(ginfo->task_filter) &&
 	    !filter_task_count(ginfo->hide_tasks)) {
@@ -257,14 +257,14 @@ static void graph_filter_task_remove_pid(struct graph_info *ginfo, gint pid)
 
 static void graph_hide_task_add_pid(struct graph_info *ginfo, gint pid)
 {
-	filter_task_add_pid(ginfo->hide_tasks, pid);
+	filter_id_add(ginfo->hide_tasks, pid);
 
 	ginfo->filter_available = 1;
 }
 
 static void graph_hide_task_remove_pid(struct graph_info *ginfo, gint pid)
 {
-	filter_task_remove_pid(ginfo->hide_tasks, pid);
+	filter_id_remove(ginfo->hide_tasks, pid);
 
 	if (!filter_task_count(ginfo->task_filter) &&
 	    !filter_task_count(ginfo->hide_tasks)) {
@@ -275,8 +275,8 @@ static void graph_hide_task_remove_pid(struct graph_info *ginfo, gint pid)
 
 static void graph_filter_task_clear(struct graph_info *ginfo)
 {
-	filter_task_clear(ginfo->task_filter);
-	filter_task_clear(ginfo->hide_tasks);
+	filter_id_clear(ginfo->task_filter);
+	filter_id_clear(ginfo->hide_tasks);
 
 	ginfo->filter_available = 0;
 	ginfo->filter_enabled = 0;
@@ -495,12 +495,12 @@ void trace_graph_filter_add_remove_task(struct graph_info *ginfo,
 					gint pid)
 {
 	gint filter_enabled = ginfo->filter_enabled;
-	struct filter_task_item *task;
+	struct filter_id_item *task;
 
 	task = trace_graph_filter_task_find_pid(ginfo, pid);
 
 	if (task)
-		graph_filter_task_remove_pid(ginfo, task->pid);
+		graph_filter_task_remove_pid(ginfo, task->id);
 	else
 		graph_filter_task_add_pid(ginfo, pid);
 
@@ -516,12 +516,12 @@ void trace_graph_filter_hide_show_task(struct graph_info *ginfo,
 				       gint pid)
 {
 	gint filter_enabled = ginfo->filter_enabled;
-	struct filter_task_item *task;
+	struct filter_id_item *task;
 
 	task = trace_graph_hide_task_find_pid(ginfo, pid);
 
 	if (task)
-		graph_hide_task_remove_pid(ginfo, task->pid);
+		graph_hide_task_remove_pid(ginfo, task->id);
 	else
 		graph_hide_task_add_pid(ginfo, pid);
 
@@ -564,18 +564,18 @@ void trace_graph_clear_tasks(struct graph_info *ginfo)
 }
 
 void trace_graph_update_filters(struct graph_info *ginfo,
-				struct filter_task *task_filter,
-				struct filter_task *hide_tasks)
+				struct filter_id *task_filter,
+				struct filter_id *hide_tasks)
 {
 	/* Make sure the filter passed in is not the filter we use */
 	if (task_filter != ginfo->task_filter) {
-		filter_task_hash_free(ginfo->task_filter);
-		ginfo->task_filter = filter_task_hash_copy(task_filter);
+		filter_id_hash_free(ginfo->task_filter);
+		ginfo->task_filter = filter_id_hash_copy(task_filter);
 	}
 
 	if (hide_tasks != ginfo->hide_tasks) {
-		filter_task_hash_free(ginfo->hide_tasks);
-		ginfo->hide_tasks = filter_task_hash_copy(hide_tasks);
+		filter_id_hash_free(ginfo->hide_tasks);
+		ginfo->hide_tasks = filter_id_hash_copy(hide_tasks);
 	}
 
 	if (ginfo->callbacks && ginfo->callbacks->filter)
@@ -2392,8 +2392,8 @@ destroy_event(GtkWidget *widget, gpointer data)
 
 	trace_graph_free_info(ginfo);
 
-	filter_task_hash_free(ginfo->task_filter);
-	filter_task_hash_free(ginfo->hide_tasks);
+	filter_id_hash_free(ginfo->task_filter);
+	filter_id_hash_free(ginfo->hide_tasks);
 
 	return TRUE;
 }
@@ -2781,8 +2781,8 @@ trace_graph_create_with_callbacks(struct tracecmd_input *handle,
 
 	ginfo->callbacks = cbs;
 
-	ginfo->task_filter = filter_task_hash_alloc();
-	ginfo->hide_tasks = filter_task_hash_alloc();
+	ginfo->task_filter = filter_id_hash_alloc();
+	ginfo->hide_tasks = filter_id_hash_alloc();
 
 	ginfo->widget = gtk_vbox_new(FALSE, 0);
 	gtk_widget_show(ginfo->widget);
diff --git a/kernel-shark/trace-view-main.c b/kernel-shark/trace-view-main.c
index 56a5a34..a088bbb 100644
--- a/kernel-shark/trace-view-main.c
+++ b/kernel-shark/trace-view-main.c
@@ -49,8 +49,8 @@ struct trace_tree_info {
 	GtkWidget		*spin;
 	gint			filter_enabled;
 	gint			filter_task_selected;
-	struct filter_task	*task_filter;
-	struct filter_task	*hide_tasks;
+	struct filter_id	*task_filter;
+	struct filter_id	*hide_tasks;
 };
 
 void usage(char *prog)
@@ -243,17 +243,17 @@ filter_list_clicked (gpointer data)
 }
 
 static void update_task_filter(struct trace_tree_info *info,
-			       struct filter_task *filter)
+			       struct filter_id *filter)
 {
-	struct filter_task_item *task;
+	struct filter_id_item *task;
 	gint pid = info->filter_task_selected;
 
-	task = filter_task_find_pid(filter, pid);
+	task = filter_id_find(filter, pid);
 
 	if (task)
-		filter_task_remove_pid(filter, pid);
+		filter_id_remove(filter, pid);
 	else
-		filter_task_add_pid(filter, pid);
+		filter_id_add(filter, pid);
 
 	if (info->filter_enabled)
 		trace_view_update_filters(info->trace_tree,
@@ -399,7 +399,7 @@ do_tree_popup(GtkWidget *widget, GdkEventButton *event, gpointer data)
 			text = g_malloc(len);
 			g_assert(text);
 
-			if (filter_task_find_pid(info->task_filter, pid))
+			if (filter_id_find(info->task_filter, pid))
 				snprintf(text, len, "Remove %s-%d from filter", comm, pid);
 			else
 				snprintf(text, len, "Add %s-%d to filter", comm, pid);
@@ -409,7 +409,7 @@ do_tree_popup(GtkWidget *widget, GdkEventButton *event, gpointer data)
 			gtk_menu_item_set_label(GTK_MENU_ITEM(menu_filter_add_task),
 						text);
 
-			if (filter_task_find_pid(info->hide_tasks, pid))
+			if (filter_id_find(info->hide_tasks, pid))
 				snprintf(text, len, "Show %s-%d", comm, pid);
 			else
 				snprintf(text, len, "Hide %s-%d", comm, pid);
@@ -519,8 +519,8 @@ void trace_view(int argc, char **argv)
 
 	memset(&tree_info, 0, sizeof(tree_info));
 	tree_info.handle = handle;
-	tree_info.task_filter = filter_task_hash_alloc();
-	tree_info.hide_tasks = filter_task_hash_alloc();
+	tree_info.task_filter = filter_id_hash_alloc();
+	tree_info.hide_tasks = filter_id_hash_alloc();
 
 	/* --- Main window --- */
 
diff --git a/kernel-shark/trace-view-store.c b/kernel-shark/trace-view-store.c
index f5d0a04..29e064e 100644
--- a/kernel-shark/trace-view-store.c
+++ b/kernel-shark/trace-view-store.c
@@ -231,7 +231,7 @@ trace_view_store_finalize (GObject *object)
 	g_free(store->rows);
 	g_free(store->cpu_items);
 
-	filter_task_hash_free(store->task_filter);
+	filter_id_hash_free(store->task_filter);
 
 	if (store->spin) {
 		g_object_unref(store->spin);
@@ -1184,10 +1184,10 @@ static gboolean view_task(TraceViewStore *store, gint pid)
 {
 	return (!store->task_filter ||
 		!filter_task_count(store->task_filter) ||
-		filter_task_find_pid(store->task_filter, pid)) &&
+		filter_id_find(store->task_filter, pid)) &&
 		(!store->hide_tasks ||
 		 !filter_task_count(store->hide_tasks) ||
-		 !filter_task_find_pid(store->hide_tasks, pid));
+		 !filter_id_find(store->hide_tasks, pid));
 }
 
 static gboolean show_task(TraceViewStore *store, struct pevent *pevent,
@@ -1295,30 +1295,30 @@ static void update_filter_tasks(TraceViewStore *store)
 	merge_sort_rows_ts(store);
 }
 
-void trace_view_store_filter_tasks(TraceViewStore *store, struct filter_task *filter)
+void trace_view_store_filter_tasks(TraceViewStore *store, struct filter_id *filter)
 {
 	g_return_if_fail (TRACE_VIEW_IS_LIST (store));
 
 	/* We may pass in the store->task_filter. Don't free it if we do */
 	if (store->task_filter && store->task_filter != filter)
-		filter_task_hash_free(store->task_filter);
+		filter_id_hash_free(store->task_filter);
 
 	if (store->task_filter != filter)
-		store->task_filter = filter_task_hash_copy(filter);
+		store->task_filter = filter_id_hash_copy(filter);
 
 	update_filter_tasks(store);
 }
 
-void trace_view_store_hide_tasks(TraceViewStore *store, struct filter_task *filter)
+void trace_view_store_hide_tasks(TraceViewStore *store, struct filter_id *filter)
 {
 	g_return_if_fail (TRACE_VIEW_IS_LIST (store));
 
 	/* We may pass in the store->task_filter. Don't free it if we do */
 	if (store->hide_tasks && store->hide_tasks != filter)
-		filter_task_hash_free(store->hide_tasks);
+		filter_id_hash_free(store->hide_tasks);
 
 	if (store->hide_tasks != filter)
-		store->hide_tasks = filter_task_hash_copy(filter);
+		store->hide_tasks = filter_id_hash_copy(filter);
 
 	update_filter_tasks(store);
 }
@@ -1331,23 +1331,23 @@ void trace_view_store_update_filter(TraceViewStore *store)
 }
 
 void trace_view_store_assign_filters(TraceViewStore *store,
-				     struct filter_task *task_filter,
-				     struct filter_task *hide_tasks)
+				     struct filter_id *task_filter,
+				     struct filter_id *hide_tasks)
 {
 	g_return_if_fail (TRACE_VIEW_IS_LIST (store));
 
 	/* We may pass in the store->task_filter. Don't free it if we do */
 	if (store->task_filter && store->task_filter != task_filter)
-		filter_task_hash_free(store->task_filter);
+		filter_id_hash_free(store->task_filter);
 
 	if (store->hide_tasks && store->hide_tasks != hide_tasks)
-		filter_task_hash_free(store->hide_tasks);
+		filter_id_hash_free(store->hide_tasks);
 
 	if (store->hide_tasks != hide_tasks)
-		store->hide_tasks = filter_task_hash_copy(hide_tasks);
+		store->hide_tasks = filter_id_hash_copy(hide_tasks);
 
 	if (store->task_filter != task_filter)
-		store->task_filter = filter_task_hash_copy(task_filter);
+		store->task_filter = filter_id_hash_copy(task_filter);
 }
 
 /*****************************************************************************
diff --git a/kernel-shark/trace-view.c b/kernel-shark/trace-view.c
index 1dd3adc..377f2db 100644
--- a/kernel-shark/trace-view.c
+++ b/kernel-shark/trace-view.c
@@ -301,8 +301,8 @@ void trace_view_make_selection_visible(GtkWidget *treeview)
 }
 
 void trace_view_update_filters(GtkWidget *treeview,
-			       struct filter_task *task_filter,
-			       struct filter_task *hide_tasks)
+			       struct filter_id *task_filter,
+			       struct filter_id *hide_tasks)
 {
 	GtkTreeView *tree = GTK_TREE_VIEW(treeview);
 	TraceViewRecord *vrec;
-- 
2.17.1
