Return-Path: <SRS0=aTL9=JH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:42566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933368AbeFUPrY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jun 2018 11:47:24 -0400
Message-Id: <20180621154722.344748885@goodmis.org>
Date: Thu, 21 Jun 2018 11:43:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 4/5] trace-cmd: Add "tracecmd_" to namespace of filter hash
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-trace-cmd-Add-tracecmd_-to-namespace-of-filter-hash.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Now that the trace filter hash code is integrated in libtracecmd.a, it needs
to have its own name space. Prefix "tracecmd_" to all the structures and
functions that is used.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-filter-hash.h   |  35 +++----
 kernel-shark/include/kernel-shark.h     |   4 +-
 kernel-shark/include/trace-filter.h     |  12 +--
 kernel-shark/include/trace-graph.h      |  16 ++--
 kernel-shark/include/trace-view-store.h |  14 +--
 kernel-shark/include/trace-view.h       |   4 +-
 kernel-shark/kernel-shark.c             | 120 ++++++++++++------------
 kernel-shark/trace-filter.c             |  22 ++---
 kernel-shark/trace-graph.c              |  72 +++++++-------
 kernel-shark/trace-view-main.c          |  40 ++++----
 kernel-shark/trace-view-store.c         |  36 +++----
 kernel-shark/trace-view.c               |   4 +-
 lib/trace-cmd/trace-filter-hash.c       |  48 +++++-----
 13 files changed, 217 insertions(+), 210 deletions(-)

diff --git a/include/trace-cmd/trace-filter-hash.h b/include/trace-cmd/trace-filter-hash.h
index cfc9115c15ce..6f4ee3c15417 100644
--- a/include/trace-cmd/trace-filter-hash.h
+++ b/include/trace-cmd/trace-filter-hash.h
@@ -23,27 +23,30 @@
 
 #include <stdint.h>
 
-struct filter_id_item {
-	struct filter_id_item	*next;
-	int			id;
+struct tracecmd_filter_id_item {
+	struct tracecmd_filter_id_item	*next;
+	int				id;
 };
 
-struct filter_id {
-	struct filter_id_item **hash;
-	int			count;
+struct tracecmd_filter_id {
+	struct tracecmd_filter_id_item **hash;
+	int				count;
 };
 
-struct filter_id_item *filter_id_find(struct filter_id *hash, int id);
-void filter_id_add(struct filter_id *hash, int id);
-void filter_id_remove(struct filter_id *hash, int id);
-void filter_id_clear(struct filter_id *hash);
-struct filter_id *filter_id_hash_alloc(void);
-void filter_id_hash_free(struct filter_id *hash);
-struct filter_id *filter_id_hash_copy(struct filter_id *hash);
-int *filter_ids(struct filter_id *hash);
-int filter_id_compare(struct filter_id *hash1, struct filter_id *hash2);
+struct tracecmd_filter_id_item *
+  tracecmd_filter_id_find(struct tracecmd_filter_id *hash, int id);
+void tracecmd_filter_id_add(struct tracecmd_filter_id *hash, int id);
+void tracecmd_filter_id_remove(struct tracecmd_filter_id *hash, int id);
+void tracecmd_filter_id_clear(struct tracecmd_filter_id *hash);
+struct tracecmd_filter_id *tracecmd_filter_id_hash_alloc(void);
+void tracecmd_filter_id_hash_free(struct tracecmd_filter_id *hash);
+struct tracecmd_filter_id *
+  tracecmd_filter_id_hash_copy(struct tracecmd_filter_id *hash);
+int *tracecmd_filter_ids(struct tracecmd_filter_id *hash);
+int tracecmd_filter_id_compare(struct tracecmd_filter_id *hash1,
+			       struct tracecmd_filter_id *hash2);
 
-static inline int filter_task_count(struct filter_id *hash)
+static inline int tracecmd_filter_task_count(struct tracecmd_filter_id *hash)
 {
 	return hash->count;
 }
diff --git a/kernel-shark/include/kernel-shark.h b/kernel-shark/include/kernel-shark.h
index 193458364972..de00512ce5ed 100644
--- a/kernel-shark/include/kernel-shark.h
+++ b/kernel-shark/include/kernel-shark.h
@@ -48,8 +48,8 @@ struct shark_info {
 	gboolean			graph_follows;
 	gboolean			sync_task_filters;
 	gboolean			sync_event_filters;
-	struct filter_id		*list_task_filter;
-	struct filter_id		*list_hide_tasks;
+	struct tracecmd_filter_id	*list_task_filter;
+	struct tracecmd_filter_id	*list_hide_tasks;
 
 	/* Save capture state. */
 	gboolean			cap_all_events;
diff --git a/kernel-shark/include/trace-filter.h b/kernel-shark/include/trace-filter.h
index 4ddbd2273895..070d3db91aa0 100644
--- a/kernel-shark/include/trace-filter.h
+++ b/kernel-shark/include/trace-filter.h
@@ -146,21 +146,21 @@ void trace_array_add(gint **array, gint *count, gint val);
 int trace_filter_save_events(struct tracecmd_xml_handle *handle,
 			     struct event_filter *filter);
 int trace_filter_save_tasks(struct tracecmd_xml_handle *handle,
-			    struct filter_id *filter);
+			    struct tracecmd_filter_id *filter);
 int trace_filter_load_events(struct event_filter *event_filter,
 			     struct tracecmd_xml_handle *handle,
 			     struct tracecmd_xml_system_node *node);
-int trace_filter_load_task_filter(struct filter_id *filter,
+int trace_filter_load_task_filter(struct tracecmd_filter_id *filter,
 				  struct tracecmd_xml_handle *handle,
 				  struct tracecmd_xml_system_node *node);
 int trace_filter_load_filters(struct tracecmd_xml_handle *handle,
 			      const char *system_name,
-			      struct filter_id *task_filter,
-			      struct filter_id *hide_tasks);
+			      struct tracecmd_filter_id *task_filter,
+			      struct tracecmd_filter_id *hide_tasks);
 int trace_filter_save_filters(struct tracecmd_xml_handle *handle,
 			      const char *system_name,
-			      struct filter_id *task_filter,
-			      struct filter_id *hide_tasks);
+			      struct tracecmd_filter_id *task_filter,
+			      struct tracecmd_filter_id *hide_tasks);
 
 GtkWidget *trace_create_event_list_view(struct pevent *pevent,
 					struct event_filter *filter,
diff --git a/kernel-shark/include/trace-graph.h b/kernel-shark/include/trace-graph.h
index 0f35e5946c1c..92b2747287eb 100644
--- a/kernel-shark/include/trace-graph.h
+++ b/kernel-shark/include/trace-graph.h
@@ -29,8 +29,8 @@ struct graph_info;
 
 typedef void (graph_select_cb)(struct graph_info *ginfo, guint64 time);
 typedef void (graph_filter_cb)(struct graph_info *ginfo,
-			       struct filter_id *task_filter,
-			       struct filter_id *hide_tasks);
+			       struct tracecmd_filter_id *task_filter,
+			       struct tracecmd_filter_id *hide_tasks);
 
 /* Used for quereing what plots are defined */
 enum graph_plot_type {
@@ -248,10 +248,10 @@ struct graph_info {
 
 	gboolean		read_comms;	/* Read all comms on first load */
 
-	struct filter_id	*task_filter;
+	struct tracecmd_filter_id *task_filter;
 	gint			filter_task_selected;
 
-	struct filter_id	*hide_tasks;
+	struct tracecmd_filter_id *hide_tasks;
 
 	/* Box info for plot data info window */
 	gint			plot_data_x;
@@ -296,9 +296,9 @@ static inline GtkWidget *trace_graph_get_window(struct graph_info *ginfo)
 
 void trace_graph_refresh(struct graph_info *ginfo);
 
-struct filter_id_item *
+struct tracecmd_filter_id_item *
 trace_graph_filter_task_find_pid(struct graph_info *ginfo, gint pid);
-struct filter_id_item *
+struct tracecmd_filter_id_item *
 trace_graph_hide_task_find_pid(struct graph_info *ginfo, gint pid);
 void trace_graph_filter_toggle(struct graph_info *ginfo);
 void trace_graph_filter_add_remove_task(struct graph_info *info,
@@ -331,8 +331,8 @@ int trace_graph_load_filters(struct graph_info *ginfo,
 int trace_graph_save_filters(struct graph_info *ginfo,
 			     struct tracecmd_xml_handle *handle);
 void trace_graph_update_filters(struct graph_info *ginfo,
-				struct filter_id *task_filter,
-				struct filter_id *hide_tasks);
+				struct tracecmd_filter_id *task_filter,
+				struct tracecmd_filter_id *hide_tasks);
 void trace_graph_refresh_filters(struct graph_info *ginfo);
 
 /* plots */
diff --git a/kernel-shark/include/trace-view-store.h b/kernel-shark/include/trace-view-store.h
index 1204c4b73285..61ce974db9c6 100644
--- a/kernel-shark/include/trace-view-store.h
+++ b/kernel-shark/include/trace-view-store.h
@@ -116,9 +116,9 @@ struct trace_view_store
 	/* filters */
 	gint			all_events; /* set 1 when all events are enabled */
 						/* else */
-	struct event_filter	*event_filter; /* Filtered events */
-	struct filter_id	*task_filter;	/* hash of tasks to filter on */
-	struct filter_id	*hide_tasks;	/* hash of tasks to not display */
+	struct event_filter		*event_filter; /* Filtered events */
+	struct tracecmd_filter_id	*task_filter;	/* hash of tasks to filter on */
+	struct tracecmd_filter_id	*hide_tasks;	/* hash of tasks to not display */
 
 	gint			all_cpus;   /* set 1 when all cpus are enabled */
 						/* else */
@@ -141,13 +141,13 @@ gint trace_view_store_get_timestamp_page(TraceViewStore *store, guint64 ts);
 
 gint trace_view_store_get_timestamp_visible_row(TraceViewStore *store, guint64 ts);
 
-void trace_view_store_filter_tasks(TraceViewStore *store, struct filter_id *filter);
+void trace_view_store_filter_tasks(TraceViewStore *store, struct tracecmd_filter_id *filter);
 
-void trace_view_store_hide_tasks(TraceViewStore *store, struct filter_id *filter);
+void trace_view_store_hide_tasks(TraceViewStore *store, struct tracecmd_filter_id *filter);
 
 void trace_view_store_assign_filters(TraceViewStore *store,
-				     struct filter_id *task_filter,
-				     struct filter_id *hide_tasks);
+				     struct tracecmd_filter_id *task_filter,
+				     struct tracecmd_filter_id *hide_tasks);
 
 TraceViewRecord *trace_view_store_get_row(TraceViewStore *store, gint row);
 
diff --git a/kernel-shark/include/trace-view.h b/kernel-shark/include/trace-view.h
index 036f51e0932e..84870bd5b278 100644
--- a/kernel-shark/include/trace-view.h
+++ b/kernel-shark/include/trace-view.h
@@ -34,8 +34,8 @@ void trace_view_reload(GtkWidget *view, struct tracecmd_input *handle,
 void trace_view(int argc, char **argv);
 
 void trace_view_update_filters(GtkWidget *treeview,
-			       struct filter_id *task_filter,
-			       struct filter_id *hide_tasks);
+			       struct tracecmd_filter_id *task_filter,
+			       struct tracecmd_filter_id *hide_tasks);
 
 void trace_view_make_selection_visible(GtkWidget *treeview);
 
diff --git a/kernel-shark/kernel-shark.c b/kernel-shark/kernel-shark.c
index 33ada3159007..884b9c0903e6 100644
--- a/kernel-shark/kernel-shark.c
+++ b/kernel-shark/kernel-shark.c
@@ -137,15 +137,15 @@ static int trace_sync_select_menu(const gchar *title,
 }
 
 static void update_tree_view_filters(struct shark_info *info,
-				     struct filter_id *task_filter,
-				     struct filter_id *hide_tasks)
+				     struct tracecmd_filter_id *task_filter,
+				     struct tracecmd_filter_id *hide_tasks)
 {
 	if (info->list_filter_enabled)
 		trace_view_update_filters(info->treeview,
 					  task_filter, hide_tasks);
 
-	if (filter_task_count(task_filter) ||
-	    filter_task_count(hide_tasks))
+	if (tracecmd_filter_task_count(task_filter) ||
+	    tracecmd_filter_task_count(hide_tasks))
 		info->list_filter_available = 1;
 	else {
 		info->list_filter_enabled = 0;
@@ -193,8 +193,8 @@ static void ks_graph_select(struct graph_info *ginfo, guint64 cursor)
 }
 
 static void ks_graph_filter(struct graph_info *ginfo,
-			    struct filter_id *task_filter,
-			    struct filter_id *hide_tasks)
+			    struct tracecmd_filter_id *task_filter,
+			    struct tracecmd_filter_id *hide_tasks)
 {
 	struct graph_callbacks *cbs;
 	struct shark_info *info;
@@ -213,8 +213,8 @@ static void free_info(struct shark_info *info)
 	tracecmd_close(info->handle);
 	trace_graph_free_info(info->ginfo);
 
-	filter_id_hash_free(info->list_task_filter);
-	filter_id_hash_free(info->list_hide_tasks);
+	tracecmd_filter_id_hash_free(info->list_task_filter);
+	tracecmd_filter_id_hash_free(info->list_hide_tasks);
 
 	kernel_shark_clear_capture(info);
 
@@ -253,8 +253,8 @@ static void unsync_task_filters(struct shark_info *info)
 	gtk_widget_show(info->list_hide_task_menu);
 
 	/* The list now uses its own hash */
-	info->list_task_filter = filter_id_hash_copy(info->ginfo->task_filter);
-	info->list_hide_tasks = filter_id_hash_copy(info->ginfo->hide_tasks);
+	info->list_task_filter = tracecmd_filter_id_hash_copy(info->ginfo->task_filter);
+	info->list_hide_tasks = tracecmd_filter_id_hash_copy(info->ginfo->hide_tasks);
 }
 
 static void sync_task_filters(struct shark_info *info)
@@ -407,8 +407,8 @@ static void load_filter(struct shark_info *info, const char *filename)
 	GtkTreeModel *model;
 	TraceViewStore *store;
 	struct tracecmd_xml_handle *handle;
-	struct filter_id *task_filter;
-	struct filter_id *hide_tasks;
+	struct tracecmd_filter_id *task_filter;
+	struct tracecmd_filter_id *hide_tasks;
 	struct event_filter *event_filter;
 	int ret;
 
@@ -427,8 +427,8 @@ static void load_filter(struct shark_info *info, const char *filename)
 	ret = tracecmd_xml_system_exists(handle,
 					 "GraphTaskFilter");
 	if (ret) {
-		filter_id_clear(ginfo->task_filter);
-		filter_id_clear(ginfo->hide_tasks);
+		tracecmd_filter_id_clear(ginfo->task_filter);
+		tracecmd_filter_id_clear(ginfo->hide_tasks);
 
 		trace_filter_load_filters(handle,
 					  "GraphTaskFilter",
@@ -442,8 +442,8 @@ static void load_filter(struct shark_info *info, const char *filename)
 	if (ret) {
 		task_filter = info->list_task_filter;
 		hide_tasks = info->list_hide_tasks;
-		filter_id_clear(task_filter);
-		filter_id_clear(hide_tasks);
+		tracecmd_filter_id_clear(task_filter);
+		tracecmd_filter_id_clear(hide_tasks);
 
 		trace_filter_load_filters(handle,
 					  "ListTaskFilter",
@@ -461,9 +461,9 @@ static void load_filter(struct shark_info *info, const char *filename)
 	 * If the events or tasks filters are the same for both
 	 * the list and graph, then sync them back.
 	 */
-	if (filter_id_compare(ginfo->task_filter,
+	if (tracecmd_filter_id_compare(ginfo->task_filter,
 				info->list_task_filter) &&
-	    filter_id_compare(ginfo->hide_tasks,
+	    tracecmd_filter_id_compare(ginfo->hide_tasks,
 				info->list_hide_tasks))
 		sync_task_filters(info);
 
@@ -516,8 +516,8 @@ static void save_filters(struct shark_info *info, const char *filename)
 	struct graph_info *ginfo = info->ginfo;
 	struct tracecmd_xml_handle *handle;
 	GtkTreeView *trace_tree = GTK_TREE_VIEW(info->treeview);
-	struct filter_id *task_filter;
-	struct filter_id *hide_tasks;
+	struct tracecmd_filter_id *task_filter;
+	struct tracecmd_filter_id *hide_tasks;
 
 	handle = tracecmd_xml_create(filename, VERSION_STRING);
 	if (!handle) {
@@ -748,8 +748,8 @@ static void
 sync_task_filter_clicked (GtkWidget *subitem, gpointer data)
 {
 	struct shark_info *info = data;
-	struct filter_id *task_filter;
-	struct filter_id *hide_tasks;
+	struct tracecmd_filter_id *task_filter;
+	struct tracecmd_filter_id *hide_tasks;
 	GtkTreeView *trace_tree = GTK_TREE_VIEW(info->treeview);
 	GtkTreeModel *model;
 	gboolean keep;
@@ -770,9 +770,9 @@ sync_task_filter_clicked (GtkWidget *subitem, gpointer data)
 		return;
 
 	/* If they are already equal, then just perminently sync them */
-	if (filter_id_compare(info->ginfo->task_filter,
+	if (tracecmd_filter_id_compare(info->ginfo->task_filter,
 				info->list_task_filter) &&
-	    filter_id_compare(info->ginfo->hide_tasks,
+	    tracecmd_filter_id_compare(info->ginfo->hide_tasks,
 				info->list_hide_tasks))
 		result = 2;
 
@@ -784,8 +784,8 @@ sync_task_filter_clicked (GtkWidget *subitem, gpointer data)
 	switch (result) {
 	case 0:
 		/* Sync List Filter with Graph Filter */
-		filter_id_hash_free(info->list_task_filter);
-		filter_id_hash_free(info->list_hide_tasks);
+		tracecmd_filter_id_hash_free(info->list_task_filter);
+		tracecmd_filter_id_hash_free(info->list_hide_tasks);
 
 		info->list_task_filter = NULL;
 		info->list_hide_tasks = NULL;
@@ -794,8 +794,8 @@ sync_task_filter_clicked (GtkWidget *subitem, gpointer data)
 		hide_tasks = info->ginfo->hide_tasks;
 
 		if (!keep) {
-			info->list_task_filter = filter_id_hash_copy(task_filter);
-			info->list_hide_tasks = filter_id_hash_copy(hide_tasks);
+			info->list_task_filter = tracecmd_filter_id_hash_copy(task_filter);
+			info->list_hide_tasks = tracecmd_filter_id_hash_copy(hide_tasks);
 		}
 
 		update_tree_view_filters(info, task_filter, hide_tasks);
@@ -808,8 +808,8 @@ sync_task_filter_clicked (GtkWidget *subitem, gpointer data)
 					   info->list_hide_tasks);
 
 		if (keep) {
-			filter_id_hash_free(info->list_task_filter);
-			filter_id_hash_free(info->list_hide_tasks);
+			tracecmd_filter_id_hash_free(info->list_task_filter);
+			tracecmd_filter_id_hash_free(info->list_hide_tasks);
 
 			info->list_task_filter = NULL;
 			info->list_hide_tasks = NULL;
@@ -896,7 +896,7 @@ static void
 __update_list_task_filter_callback(struct shark_info *info,
 				   gboolean accept,
 				   gint *selected,
-				   struct filter_id *task_filter)
+				   struct tracecmd_filter_id *task_filter)
 {
 	GtkTreeView *trace_tree = GTK_TREE_VIEW(info->treeview);
 	GtkTreeModel *model;
@@ -909,11 +909,11 @@ __update_list_task_filter_callback(struct shark_info *info,
 	if (!model)
 		return;
 
-	filter_id_clear(task_filter);
+	tracecmd_filter_id_clear(task_filter);
 
 	if (selected) {
 		for (i = 0; selected[i] >= 0; i++)
-			filter_id_add(task_filter, selected[i]);
+			tracecmd_filter_id_add(task_filter, selected[i]);
 	}
 
 	update_tree_view_filters(info, info->list_task_filter, info->list_hide_tasks);
@@ -952,7 +952,7 @@ update_list_hide_task_filter_callback(gboolean accept,
 /* Callback for the clicked signal of the List Tasks filter button */
 static void
 __list_tasks_clicked (struct shark_info *info,
-		      struct filter_id *task_filter,
+		      struct tracecmd_filter_id *task_filter,
 		      trace_task_cb_func func)
 {
 	GtkTreeView *trace_tree = GTK_TREE_VIEW(info->treeview);
@@ -969,7 +969,7 @@ __list_tasks_clicked (struct shark_info *info,
 		return;
 
 	tasks = trace_graph_task_list(ginfo);
-	selected = filter_ids(task_filter);
+	selected = tracecmd_filter_ids(task_filter);
 
 	trace_task_dialog(info->handle, tasks, selected, func, info);
 
@@ -999,7 +999,7 @@ static void
 __update_graph_task_filter_callback(struct shark_info *info,
 				  gboolean accept,
 				  gint *selected,
-				  struct filter_id *task_filter)
+				  struct tracecmd_filter_id *task_filter)
 {
 	struct graph_info *ginfo = info->ginfo;
 	int i;
@@ -1007,11 +1007,11 @@ __update_graph_task_filter_callback(struct shark_info *info,
 	if (!accept)
 		return;
 
-	filter_id_clear(task_filter);
+	tracecmd_filter_id_clear(task_filter);
 
 	if (selected) {
 		for (i = 0; selected[i] >= 0; i++)
-			filter_id_add(task_filter, selected[i]);
+			tracecmd_filter_id_add(task_filter, selected[i]);
 	}
 
 	trace_graph_refresh_filters(ginfo);
@@ -1057,7 +1057,7 @@ update_graph_hide_task_filter_callback(gboolean accept,
 /* Callback for the clicked signal of the Tasks filter button */
 static void
 __graph_tasks_clicked (struct shark_info *info,
-		       struct filter_id *task_filter,
+		       struct tracecmd_filter_id *task_filter,
 		       trace_task_cb_func func)
 {
 	struct graph_info *ginfo = info->ginfo;
@@ -1068,7 +1068,7 @@ __graph_tasks_clicked (struct shark_info *info,
 		return;
 
 	tasks = trace_graph_task_list(ginfo);
-	selected = filter_ids(task_filter);
+	selected = tracecmd_filter_ids(task_filter);
 
 	trace_task_dialog(ginfo->handle, tasks, selected, func, info);
 
@@ -1369,8 +1369,8 @@ static void
 filter_list_enable_clicked (gpointer data)
 {
 	struct shark_info *info = data;
-	struct filter_id *task_filter;
-	struct filter_id *hide_tasks;
+	struct tracecmd_filter_id *task_filter;
+	struct tracecmd_filter_id *hide_tasks;
 
 	info->list_filter_enabled ^= 1;
 
@@ -1391,22 +1391,22 @@ filter_list_enable_clicked (gpointer data)
 
 static void
 filter_update_list_filter(struct shark_info *info,
-			  struct filter_id *filter,
-			  struct filter_id *other_filter)
+			  struct tracecmd_filter_id *filter,
+			  struct tracecmd_filter_id *other_filter)
 {
-	struct filter_id_item *task;
+	struct tracecmd_filter_id_item *task;
 	int pid = info->selected_task;
 
-	task = filter_id_find(filter, pid);
+	task = tracecmd_filter_id_find(filter, pid);
 	if (task) {
-		filter_id_remove(filter, pid);
-		if (!filter_task_count(filter) &&
-		    !filter_task_count(other_filter)) {
+		tracecmd_filter_id_remove(filter, pid);
+		if (!tracecmd_filter_task_count(filter) &&
+		    !tracecmd_filter_task_count(other_filter)) {
 			info->list_filter_enabled = 0;
 			info->list_filter_available = 0;
 		}
 	} else {
-		filter_id_add(filter, pid);
+		tracecmd_filter_id_add(filter, pid);
 		info->list_filter_available = 1;
 	}
 }
@@ -1511,8 +1511,8 @@ filter_clear_tasks_clicked (gpointer data)
 		return;
 	}
 
-	filter_id_clear(info->list_task_filter);
-	filter_id_clear(info->list_hide_tasks);
+	tracecmd_filter_id_clear(info->list_task_filter);
+	tracecmd_filter_id_clear(info->list_hide_tasks);
 	trace_view_update_filters(info->treeview, NULL, NULL);
 
 	info->list_filter_available = 0;
@@ -1686,14 +1686,14 @@ do_tree_popup(GtkWidget *widget, GdkEventButton *event, gpointer data)
 				gtk_widget_hide(menu_filter_graph_hide_task);
 
 			} else {
-				if (filter_id_find(info->list_task_filter, pid))
+				if (tracecmd_filter_id_find(info->list_task_filter, pid))
 					set_menu_label(menu_filter_add_task, comm, pid,
 						       "Remove %s-%d from List filter");
 				else
 					set_menu_label(menu_filter_add_task, comm, pid,
 						       "Add %s-%d to List filter");
 
-				if (filter_id_find(info->list_hide_tasks, pid))
+				if (tracecmd_filter_id_find(info->list_hide_tasks, pid))
 					set_menu_label(menu_filter_hide_task, comm, pid,
 						       "Show %s-%d in List");
 				else
@@ -1763,8 +1763,8 @@ do_tree_popup(GtkWidget *widget, GdkEventButton *event, gpointer data)
 		gtk_widget_set_sensitive(menu_filter_list_enable, FALSE);
 
 	if (info->sync_task_filters) {
-		if (filter_task_count(ginfo->task_filter) ||
-		    filter_task_count(ginfo->hide_tasks))
+		if (tracecmd_filter_task_count(ginfo->task_filter) ||
+		    tracecmd_filter_task_count(ginfo->hide_tasks))
 			gtk_widget_set_sensitive(menu_filter_clear_tasks, TRUE);
 		else
 			gtk_widget_set_sensitive(menu_filter_clear_tasks, FALSE);
@@ -1773,14 +1773,14 @@ do_tree_popup(GtkWidget *widget, GdkEventButton *event, gpointer data)
 					"Clear Task Filter");
 		gtk_widget_hide(menu_filter_graph_clear_tasks);
 	} else {
-		if (filter_task_count(ginfo->task_filter) ||
-		    filter_task_count(ginfo->hide_tasks))
+		if (tracecmd_filter_task_count(ginfo->task_filter) ||
+		    tracecmd_filter_task_count(ginfo->hide_tasks))
 			gtk_widget_set_sensitive(menu_filter_graph_clear_tasks, TRUE);
 		else
 			gtk_widget_set_sensitive(menu_filter_graph_clear_tasks, FALSE);
 
-		if (filter_task_count(info->list_task_filter) ||
-		    filter_task_count(info->list_hide_tasks))
+		if (tracecmd_filter_task_count(info->list_task_filter) ||
+		    tracecmd_filter_task_count(info->list_hide_tasks))
 			gtk_widget_set_sensitive(menu_filter_clear_tasks, TRUE);
 		else
 			gtk_widget_set_sensitive(menu_filter_clear_tasks, FALSE);
diff --git a/kernel-shark/trace-filter.c b/kernel-shark/trace-filter.c
index f5c3f29fcf80..32ddccef4bde 100644
--- a/kernel-shark/trace-filter.c
+++ b/kernel-shark/trace-filter.c
@@ -2076,13 +2076,13 @@ int trace_filter_save_events(struct tracecmd_xml_handle *handle,
 }
 
 int trace_filter_save_tasks(struct tracecmd_xml_handle *handle,
-			    struct filter_id *filter)
+			    struct tracecmd_filter_id *filter)
 {
 	char buffer[100];
 	int *pids;
 	int i;
 
-	pids = filter_ids(filter);
+	pids = tracecmd_filter_ids(filter);
 	if (!pids)
 		return -1;
 
@@ -2171,7 +2171,7 @@ int trace_filter_load_events(struct event_filter *event_filter,
 	return 0;
 }
 
-int trace_filter_load_task_filter(struct filter_id *filter,
+int trace_filter_load_task_filter(struct tracecmd_filter_id *filter,
 				  struct tracecmd_xml_handle *handle,
 				  struct tracecmd_xml_system_node *node)
 {
@@ -2190,8 +2190,8 @@ int trace_filter_load_task_filter(struct filter_id *filter,
 		if (strcmp(name, "Task") == 0) {
 			task = tracecmd_xml_node_value(handle, node);
 			pid = atoi(task);
-			if (!filter_id_find(filter, pid))
-				filter_id_add(filter, pid);
+			if (!tracecmd_filter_id_find(filter, pid))
+				tracecmd_filter_id_add(filter, pid);
 		}
 		node = tracecmd_xml_node_next(node);
 	}
@@ -2201,8 +2201,8 @@ int trace_filter_load_task_filter(struct filter_id *filter,
 
 int trace_filter_load_filters(struct tracecmd_xml_handle *handle,
 			      const char *system_name,
-			      struct filter_id *task_filter,
-			      struct filter_id *hide_tasks)
+			      struct tracecmd_filter_id *task_filter,
+			      struct tracecmd_filter_id *hide_tasks)
 {
 	struct tracecmd_xml_system *system;
 	struct tracecmd_xml_system_node *syschild;
@@ -2240,19 +2240,19 @@ int trace_filter_load_filters(struct tracecmd_xml_handle *handle,
 
 int trace_filter_save_filters(struct tracecmd_xml_handle *handle,
 			      const char *system_name,
-			      struct filter_id *task_filter,
-			      struct filter_id *hide_tasks)
+			      struct tracecmd_filter_id *task_filter,
+			      struct tracecmd_filter_id *hide_tasks)
 {
 
 	tracecmd_xml_start_system(handle, system_name);
 
-	if (task_filter && filter_task_count(task_filter)) {
+	if (task_filter && tracecmd_filter_task_count(task_filter)) {
 		tracecmd_xml_start_sub_system(handle, "TaskFilter");
 		trace_filter_save_tasks(handle, task_filter);
 		tracecmd_xml_end_sub_system(handle);
 	}
 
-	if (hide_tasks && filter_task_count(hide_tasks)) {
+	if (hide_tasks && tracecmd_filter_task_count(hide_tasks)) {
 		tracecmd_xml_start_sub_system(handle, "HideTasks");
 		trace_filter_save_tasks(handle, hide_tasks);
 		tracecmd_xml_end_sub_system(handle);
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index 1aba41782234..ed9406bd6030 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -226,31 +226,31 @@ static void init_event_cache(struct graph_info *ginfo)
 	ginfo->read_comms = TRUE;
 }
 
-struct filter_id_item *
+struct tracecmd_filter_id_item *
 trace_graph_filter_task_find_pid(struct graph_info *ginfo, gint pid)
 {
-	return filter_id_find(ginfo->task_filter, pid);
+	return tracecmd_filter_id_find(ginfo->task_filter, pid);
 }
 
-struct filter_id_item *
+struct tracecmd_filter_id_item *
 trace_graph_hide_task_find_pid(struct graph_info *ginfo, gint pid)
 {
-	return filter_id_find(ginfo->hide_tasks, pid);
+	return tracecmd_filter_id_find(ginfo->hide_tasks, pid);
 }
 
 static void graph_filter_task_add_pid(struct graph_info *ginfo, gint pid)
 {
-	filter_id_add(ginfo->task_filter, pid);
+	tracecmd_filter_id_add(ginfo->task_filter, pid);
 
 	ginfo->filter_available = 1;
 }
 
 static void graph_filter_task_remove_pid(struct graph_info *ginfo, gint pid)
 {
-	filter_id_remove(ginfo->task_filter, pid);
+	tracecmd_filter_id_remove(ginfo->task_filter, pid);
 
-	if (!filter_task_count(ginfo->task_filter) &&
-	    !filter_task_count(ginfo->hide_tasks)) {
+	if (!tracecmd_filter_task_count(ginfo->task_filter) &&
+	    !tracecmd_filter_task_count(ginfo->hide_tasks)) {
 		ginfo->filter_available = 0;
 		ginfo->filter_enabled = 0;
 	}
@@ -258,17 +258,17 @@ static void graph_filter_task_remove_pid(struct graph_info *ginfo, gint pid)
 
 static void graph_hide_task_add_pid(struct graph_info *ginfo, gint pid)
 {
-	filter_id_add(ginfo->hide_tasks, pid);
+	tracecmd_filter_id_add(ginfo->hide_tasks, pid);
 
 	ginfo->filter_available = 1;
 }
 
 static void graph_hide_task_remove_pid(struct graph_info *ginfo, gint pid)
 {
-	filter_id_remove(ginfo->hide_tasks, pid);
+	tracecmd_filter_id_remove(ginfo->hide_tasks, pid);
 
-	if (!filter_task_count(ginfo->task_filter) &&
-	    !filter_task_count(ginfo->hide_tasks)) {
+	if (!tracecmd_filter_task_count(ginfo->task_filter) &&
+	    !tracecmd_filter_task_count(ginfo->hide_tasks)) {
 		ginfo->filter_available = 0;
 		ginfo->filter_enabled = 0;
 	}
@@ -276,8 +276,8 @@ static void graph_hide_task_remove_pid(struct graph_info *ginfo, gint pid)
 
 static void graph_filter_task_clear(struct graph_info *ginfo)
 {
-	filter_id_clear(ginfo->task_filter);
-	filter_id_clear(ginfo->hide_tasks);
+	tracecmd_filter_id_clear(ginfo->task_filter);
+	tracecmd_filter_id_clear(ginfo->hide_tasks);
 
 	ginfo->filter_available = 0;
 	ginfo->filter_enabled = 0;
@@ -304,9 +304,9 @@ gboolean trace_graph_filter_on_task(struct graph_info *ginfo, gint pid)
 	filter = FALSE;
 
 	if (ginfo->filter_enabled &&
-	    ((filter_task_count(ginfo->task_filter) &&
+	    ((tracecmd_filter_task_count(ginfo->task_filter) &&
 	      !trace_graph_filter_task_find_pid(ginfo, pid)) ||
-	     (filter_task_count(ginfo->hide_tasks) &&
+	     (tracecmd_filter_task_count(ginfo->hide_tasks) &&
 	      trace_graph_hide_task_find_pid(ginfo, pid))))
 		filter = TRUE;
 
@@ -496,7 +496,7 @@ void trace_graph_filter_add_remove_task(struct graph_info *ginfo,
 					gint pid)
 {
 	gint filter_enabled = ginfo->filter_enabled;
-	struct filter_id_item *task;
+	struct tracecmd_filter_id_item *task;
 
 	task = trace_graph_filter_task_find_pid(ginfo, pid);
 
@@ -517,7 +517,7 @@ void trace_graph_filter_hide_show_task(struct graph_info *ginfo,
 				       gint pid)
 {
 	gint filter_enabled = ginfo->filter_enabled;
-	struct filter_id_item *task;
+	struct tracecmd_filter_id_item *task;
 
 	task = trace_graph_hide_task_find_pid(ginfo, pid);
 
@@ -565,18 +565,18 @@ void trace_graph_clear_tasks(struct graph_info *ginfo)
 }
 
 void trace_graph_update_filters(struct graph_info *ginfo,
-				struct filter_id *task_filter,
-				struct filter_id *hide_tasks)
+				struct tracecmd_filter_id *task_filter,
+				struct tracecmd_filter_id *hide_tasks)
 {
 	/* Make sure the filter passed in is not the filter we use */
 	if (task_filter != ginfo->task_filter) {
-		filter_id_hash_free(ginfo->task_filter);
-		ginfo->task_filter = filter_id_hash_copy(task_filter);
+		tracecmd_filter_id_hash_free(ginfo->task_filter);
+		ginfo->task_filter = tracecmd_filter_id_hash_copy(task_filter);
 	}
 
 	if (hide_tasks != ginfo->hide_tasks) {
-		filter_id_hash_free(ginfo->hide_tasks);
-		ginfo->hide_tasks = filter_id_hash_copy(hide_tasks);
+		tracecmd_filter_id_hash_free(ginfo->hide_tasks);
+		ginfo->hide_tasks = tracecmd_filter_id_hash_copy(hide_tasks);
 	}
 
 	if (ginfo->callbacks && ginfo->callbacks->filter)
@@ -586,8 +586,8 @@ void trace_graph_update_filters(struct graph_info *ginfo,
 	if (ginfo->filter_enabled)
 		redraw_graph(ginfo);
 
-	if (filter_task_count(ginfo->task_filter) ||
-	    filter_task_count(ginfo->hide_tasks))
+	if (tracecmd_filter_task_count(ginfo->task_filter) ||
+	    tracecmd_filter_task_count(ginfo->hide_tasks))
 		ginfo->filter_available = 1;
 	else {
 		ginfo->filter_enabled = 0;
@@ -742,8 +742,8 @@ do_pop_up(GtkWidget *widget, GdkEventButton *event, gpointer data)
 	else
 		gtk_widget_set_sensitive(menu_filter_enable, FALSE);
 
-	if (filter_task_count(ginfo->task_filter) ||
-	    filter_task_count(ginfo->hide_tasks))
+	if (tracecmd_filter_task_count(ginfo->task_filter) ||
+	    tracecmd_filter_task_count(ginfo->hide_tasks))
 		gtk_widget_set_sensitive(menu_filter_clear_tasks, TRUE);
 	else
 		gtk_widget_set_sensitive(menu_filter_clear_tasks, FALSE);
@@ -2393,8 +2393,8 @@ destroy_event(GtkWidget *widget, gpointer data)
 
 	trace_graph_free_info(ginfo);
 
-	filter_id_hash_free(ginfo->task_filter);
-	filter_id_hash_free(ginfo->hide_tasks);
+	tracecmd_filter_id_hash_free(ginfo->task_filter);
+	tracecmd_filter_id_hash_free(ginfo->hide_tasks);
 
 	return TRUE;
 }
@@ -2674,8 +2674,8 @@ int trace_graph_load_filters(struct graph_info *ginfo,
 	struct tracecmd_xml_system_node *syschild;
 	const char *name;
 
-	if (filter_task_count(ginfo->task_filter) ||
-	    filter_task_count(ginfo->hide_tasks))
+	if (tracecmd_filter_task_count(ginfo->task_filter) ||
+	    tracecmd_filter_task_count(ginfo->hide_tasks))
 		ginfo->filter_available = 1;
 	else
 		ginfo->filter_available = 0;
@@ -2697,8 +2697,8 @@ int trace_graph_load_filters(struct graph_info *ginfo,
 		syschild = tracecmd_xml_node_next(syschild);
 	} while (syschild);
 
-	if (filter_task_count(ginfo->task_filter) ||
-	    filter_task_count(ginfo->hide_tasks))
+	if (tracecmd_filter_task_count(ginfo->task_filter) ||
+	    tracecmd_filter_task_count(ginfo->hide_tasks))
 		ginfo->filter_available = 1;
 	else
 		ginfo->filter_available = 0;
@@ -2782,8 +2782,8 @@ trace_graph_create_with_callbacks(struct tracecmd_input *handle,
 
 	ginfo->callbacks = cbs;
 
-	ginfo->task_filter = filter_id_hash_alloc();
-	ginfo->hide_tasks = filter_id_hash_alloc();
+	ginfo->task_filter = tracecmd_filter_id_hash_alloc();
+	ginfo->hide_tasks = tracecmd_filter_id_hash_alloc();
 
 	ginfo->widget = gtk_vbox_new(FALSE, 0);
 	gtk_widget_show(ginfo->widget);
diff --git a/kernel-shark/trace-view-main.c b/kernel-shark/trace-view-main.c
index a088bbb332a6..b61dc02cd82f 100644
--- a/kernel-shark/trace-view-main.c
+++ b/kernel-shark/trace-view-main.c
@@ -44,13 +44,13 @@
 static char *input_file;
 
 struct trace_tree_info {
-	struct tracecmd_input	*handle;
-	GtkWidget		*trace_tree;
-	GtkWidget		*spin;
-	gint			filter_enabled;
-	gint			filter_task_selected;
-	struct filter_id	*task_filter;
-	struct filter_id	*hide_tasks;
+	struct tracecmd_input		*handle;
+	GtkWidget			*trace_tree;
+	GtkWidget			*spin;
+	gint				filter_enabled;
+	gint				filter_task_selected;
+	struct tracecmd_filter_id	*task_filter;
+	struct tracecmd_filter_id	*hide_tasks;
 };
 
 void usage(char *prog)
@@ -228,8 +228,8 @@ filter_list_clicked (gpointer data)
 {
 	struct trace_tree_info *info = data;
 
-	if (!filter_task_count(info->task_filter) &&
-	    !filter_task_count(info->hide_tasks))
+	if (!tracecmd_filter_task_count(info->task_filter) &&
+	    !tracecmd_filter_task_count(info->hide_tasks))
 		return;
 
 	info->filter_enabled ^= 1;
@@ -243,17 +243,17 @@ filter_list_clicked (gpointer data)
 }
 
 static void update_task_filter(struct trace_tree_info *info,
-			       struct filter_id *filter)
+			       struct tracecmd_filter_id *filter)
 {
-	struct filter_id_item *task;
+	struct tracecmd_filter_id_item *task;
 	gint pid = info->filter_task_selected;
 
-	task = filter_id_find(filter, pid);
+	task = tracecmd_filter_id_find(filter, pid);
 
 	if (task)
-		filter_id_remove(filter, pid);
+		tracecmd_filter_id_remove(filter, pid);
 	else
-		filter_id_add(filter, pid);
+		tracecmd_filter_id_add(filter, pid);
 
 	if (info->filter_enabled)
 		trace_view_update_filters(info->trace_tree,
@@ -399,7 +399,7 @@ do_tree_popup(GtkWidget *widget, GdkEventButton *event, gpointer data)
 			text = g_malloc(len);
 			g_assert(text);
 
-			if (filter_id_find(info->task_filter, pid))
+			if (tracecmd_filter_id_find(info->task_filter, pid))
 				snprintf(text, len, "Remove %s-%d from filter", comm, pid);
 			else
 				snprintf(text, len, "Add %s-%d to filter", comm, pid);
@@ -409,7 +409,7 @@ do_tree_popup(GtkWidget *widget, GdkEventButton *event, gpointer data)
 			gtk_menu_item_set_label(GTK_MENU_ITEM(menu_filter_add_task),
 						text);
 
-			if (filter_id_find(info->hide_tasks, pid))
+			if (tracecmd_filter_id_find(info->hide_tasks, pid))
 				snprintf(text, len, "Show %s-%d", comm, pid);
 			else
 				snprintf(text, len, "Hide %s-%d", comm, pid);
@@ -442,8 +442,8 @@ do_tree_popup(GtkWidget *widget, GdkEventButton *event, gpointer data)
 		gtk_menu_item_set_label(GTK_MENU_ITEM(menu_filter_enable),
 					"Enable List Filter");
 
-	if (filter_task_count(info->task_filter) ||
-	    filter_task_count(info->hide_tasks)) {
+	if (tracecmd_filter_task_count(info->task_filter) ||
+	    tracecmd_filter_task_count(info->hide_tasks)) {
 		gtk_widget_set_sensitive(menu_filter_clear_tasks, TRUE);
 		gtk_widget_set_sensitive(menu_filter_enable, TRUE);
 	} else {
@@ -519,8 +519,8 @@ void trace_view(int argc, char **argv)
 
 	memset(&tree_info, 0, sizeof(tree_info));
 	tree_info.handle = handle;
-	tree_info.task_filter = filter_id_hash_alloc();
-	tree_info.hide_tasks = filter_id_hash_alloc();
+	tree_info.task_filter = tracecmd_filter_id_hash_alloc();
+	tree_info.hide_tasks = tracecmd_filter_id_hash_alloc();
 
 	/* --- Main window --- */
 
diff --git a/kernel-shark/trace-view-store.c b/kernel-shark/trace-view-store.c
index 29e064e2bbea..dcf6e2dc0982 100644
--- a/kernel-shark/trace-view-store.c
+++ b/kernel-shark/trace-view-store.c
@@ -231,7 +231,7 @@ trace_view_store_finalize (GObject *object)
 	g_free(store->rows);
 	g_free(store->cpu_items);
 
-	filter_id_hash_free(store->task_filter);
+	tracecmd_filter_id_hash_free(store->task_filter);
 
 	if (store->spin) {
 		g_object_unref(store->spin);
@@ -1183,11 +1183,11 @@ gint get_wakeup_new_pid(TraceViewStore *store, struct pevent *pevent, struct pev
 static gboolean view_task(TraceViewStore *store, gint pid)
 {
 	return (!store->task_filter ||
-		!filter_task_count(store->task_filter) ||
-		filter_id_find(store->task_filter, pid)) &&
+		!tracecmd_filter_task_count(store->task_filter) ||
+		tracecmd_filter_id_find(store->task_filter, pid)) &&
 		(!store->hide_tasks ||
-		 !filter_task_count(store->hide_tasks) ||
-		 !filter_id_find(store->hide_tasks, pid));
+		 !tracecmd_filter_task_count(store->hide_tasks) ||
+		 !tracecmd_filter_id_find(store->hide_tasks, pid));
 }
 
 static gboolean show_task(TraceViewStore *store, struct pevent *pevent,
@@ -1295,30 +1295,32 @@ static void update_filter_tasks(TraceViewStore *store)
 	merge_sort_rows_ts(store);
 }
 
-void trace_view_store_filter_tasks(TraceViewStore *store, struct filter_id *filter)
+void trace_view_store_filter_tasks(TraceViewStore *store,
+				   struct tracecmd_filter_id *filter)
 {
 	g_return_if_fail (TRACE_VIEW_IS_LIST (store));
 
 	/* We may pass in the store->task_filter. Don't free it if we do */
 	if (store->task_filter && store->task_filter != filter)
-		filter_id_hash_free(store->task_filter);
+		tracecmd_filter_id_hash_free(store->task_filter);
 
 	if (store->task_filter != filter)
-		store->task_filter = filter_id_hash_copy(filter);
+		store->task_filter = tracecmd_filter_id_hash_copy(filter);
 
 	update_filter_tasks(store);
 }
 
-void trace_view_store_hide_tasks(TraceViewStore *store, struct filter_id *filter)
+void trace_view_store_hide_tasks(TraceViewStore *store,
+				 struct tracecmd_filter_id *filter)
 {
 	g_return_if_fail (TRACE_VIEW_IS_LIST (store));
 
 	/* We may pass in the store->task_filter. Don't free it if we do */
 	if (store->hide_tasks && store->hide_tasks != filter)
-		filter_id_hash_free(store->hide_tasks);
+		tracecmd_filter_id_hash_free(store->hide_tasks);
 
 	if (store->hide_tasks != filter)
-		store->hide_tasks = filter_id_hash_copy(filter);
+		store->hide_tasks = tracecmd_filter_id_hash_copy(filter);
 
 	update_filter_tasks(store);
 }
@@ -1331,23 +1333,23 @@ void trace_view_store_update_filter(TraceViewStore *store)
 }
 
 void trace_view_store_assign_filters(TraceViewStore *store,
-				     struct filter_id *task_filter,
-				     struct filter_id *hide_tasks)
+				     struct tracecmd_filter_id *task_filter,
+				     struct tracecmd_filter_id *hide_tasks)
 {
 	g_return_if_fail (TRACE_VIEW_IS_LIST (store));
 
 	/* We may pass in the store->task_filter. Don't free it if we do */
 	if (store->task_filter && store->task_filter != task_filter)
-		filter_id_hash_free(store->task_filter);
+		tracecmd_filter_id_hash_free(store->task_filter);
 
 	if (store->hide_tasks && store->hide_tasks != hide_tasks)
-		filter_id_hash_free(store->hide_tasks);
+		tracecmd_filter_id_hash_free(store->hide_tasks);
 
 	if (store->hide_tasks != hide_tasks)
-		store->hide_tasks = filter_id_hash_copy(hide_tasks);
+		store->hide_tasks = tracecmd_filter_id_hash_copy(hide_tasks);
 
 	if (store->task_filter != task_filter)
-		store->task_filter = filter_id_hash_copy(task_filter);
+		store->task_filter = tracecmd_filter_id_hash_copy(task_filter);
 }
 
 /*****************************************************************************
diff --git a/kernel-shark/trace-view.c b/kernel-shark/trace-view.c
index 377f2db9df10..8ee118e2813f 100644
--- a/kernel-shark/trace-view.c
+++ b/kernel-shark/trace-view.c
@@ -301,8 +301,8 @@ void trace_view_make_selection_visible(GtkWidget *treeview)
 }
 
 void trace_view_update_filters(GtkWidget *treeview,
-			       struct filter_id *task_filter,
-			       struct filter_id *hide_tasks)
+			       struct tracecmd_filter_id *task_filter,
+			       struct tracecmd_filter_id *hide_tasks)
 {
 	GtkTreeView *tree = GTK_TREE_VIEW(treeview);
 	TraceViewRecord *vrec;
diff --git a/lib/trace-cmd/trace-filter-hash.c b/lib/trace-cmd/trace-filter-hash.c
index 8e75eb9cdd4d..7912534f947b 100644
--- a/lib/trace-cmd/trace-filter-hash.c
+++ b/lib/trace-cmd/trace-filter-hash.c
@@ -63,11 +63,11 @@ static inline uint32_t knuth_hash(uint32_t val)
 	return val * UINT32_C(2654435761);
 }
 
-struct filter_id_item *
-filter_id_find(struct filter_id *hash, int id)
+struct tracecmd_filter_id_item *
+tracecmd_filter_id_find(struct tracecmd_filter_id *hash, int id)
 {
 	int key = knuth_hash8(id);
-	struct filter_id_item *item = hash->hash[key];
+	struct tracecmd_filter_id_item *item = hash->hash[key];
 
 	while (item) {
 		if (item->id == id)
@@ -78,10 +78,10 @@ filter_id_find(struct filter_id *hash, int id)
 	return item;
 }
 
-void filter_id_add(struct filter_id *hash, int id)
+void tracecmd_filter_id_add(struct tracecmd_filter_id *hash, int id)
 {
 	int key = knuth_hash8(id);
-	struct filter_id_item *item;
+	struct tracecmd_filter_id_item *item;
 
 	item = calloc(1, sizeof(*item));
 	assert(item);
@@ -93,11 +93,11 @@ void filter_id_add(struct filter_id *hash, int id)
 	hash->count++;
 }
 
-void filter_id_remove(struct filter_id *hash, int id)
+void tracecmd_filter_id_remove(struct tracecmd_filter_id *hash, int id)
 {
 	int key = knuth_hash8(id);
-	struct filter_id_item **next = &hash->hash[key];
-	struct filter_id_item *item;
+	struct tracecmd_filter_id_item **next = &hash->hash[key];
+	struct tracecmd_filter_id_item *item;
 
 	while (*next) {
 		if ((*next)->id == id)
@@ -118,9 +118,9 @@ void filter_id_remove(struct filter_id *hash, int id)
 	free(item);
 }
 
-void filter_id_clear(struct filter_id *hash)
+void tracecmd_filter_id_clear(struct tracecmd_filter_id *hash)
 {
-	struct filter_id_item *item, *next;
+	struct tracecmd_filter_id_item *item, *next;
 	int i;
 
 	for (i = 0; i < FILTER_HASH_SIZE; i++) {
@@ -139,9 +139,9 @@ void filter_id_clear(struct filter_id *hash)
 	hash->count = 0;
 }
 
-struct filter_id *filter_id_hash_alloc(void)
+struct tracecmd_filter_id *tracecmd_filter_id_hash_alloc(void)
 {
-	struct filter_id *hash;
+	struct tracecmd_filter_id *hash;
 
 	hash = calloc(1, sizeof(*hash));
 	assert(hash);
@@ -151,26 +151,27 @@ struct filter_id *filter_id_hash_alloc(void)
 	return hash;
 }
 
-void filter_id_hash_free(struct filter_id *hash)
+void tracecmd_filter_id_hash_free(struct tracecmd_filter_id *hash)
 {
 	if (!hash)
 		return;
 
-	filter_id_clear(hash);
+	tracecmd_filter_id_clear(hash);
 	free(hash->hash);
 	free(hash);
 }
 
-struct filter_id *filter_id_hash_copy(struct filter_id *hash)
+struct tracecmd_filter_id *
+tracecmd_filter_id_hash_copy(struct tracecmd_filter_id *hash)
 {
-	struct filter_id *new_hash;
-	struct filter_id_item *item, **pitem;
+	struct tracecmd_filter_id *new_hash;
+	struct tracecmd_filter_id_item *item, **pitem;
 	int i;
 
 	if (!hash)
 		return NULL;
 
-	new_hash = filter_id_hash_alloc();
+	new_hash = tracecmd_filter_id_hash_alloc();
 	assert(new_hash);
 
 	for (i = 0; i < FILTER_HASH_SIZE; i++) {
@@ -194,9 +195,9 @@ struct filter_id *filter_id_hash_copy(struct filter_id *hash)
 	return new_hash;
 }
 
-int *filter_ids(struct filter_id *hash)
+int *tracecmd_filter_ids(struct tracecmd_filter_id *hash)
 {
-	struct filter_id_item *item;
+	struct tracecmd_filter_id_item *item;
 	int *ids;
 	int count = 0;
 	int i;
@@ -227,7 +228,8 @@ int *filter_ids(struct filter_id *hash)
  *
  * Returns 1 if the two hashes are the same, 0 otherwise.
  */
-int filter_id_compare(struct filter_id *hash1, struct filter_id *hash2)
+int tracecmd_filter_id_compare(struct tracecmd_filter_id *hash1,
+			       struct tracecmd_filter_id *hash2)
 {
 	int *ids;
 	int ret = 0;
@@ -242,9 +244,9 @@ int filter_id_compare(struct filter_id *hash1, struct filter_id *hash2)
 		return 1;
 
 	/* Now compare the pids of one hash with the other */
-	ids = filter_ids(hash1);
+	ids = tracecmd_filter_ids(hash1);
 	for (i = 0; ids[i] >= 0; i++) {
-		if (!filter_id_find(hash2, ids[i]))
+		if (!tracecmd_filter_id_find(hash2, ids[i]))
 			break;
 	}
 
-- 
2.17.1
