Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f44.google.com ([209.85.221.44]:40434 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbeHTRv0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 13:51:26 -0400
Received: by mail-wr1-f44.google.com with SMTP id n2-v6so2715422wrw.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Aug 2018 07:35:31 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 16/24] trace-cmd: Rename pevent_filter* APIs
Date: Mon, 20 Aug 2018 17:34:57 +0300
Message-Id: <20180820143505.11525-17-tz.stoyanov@gmail.com>
In-Reply-To: <20180820143505.11525-1-tz.stoyanov@gmail.com>
References: <20180820143505.11525-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: PEVENT_FILTER_ERROR_BUFSZ, pevent_filter_alloc,
pevent_filter_add_filter_str, pevent_filter_match, pevent_filter_strerror,
pevent_event_filtered, pevent_filter_reset, pevent_filter_clear_trivial,
pevent_filter_free, pevent_filter_make_string, pevent_filter_remove_event,
pevent_filter_event_has_trivial, pevent_filter_copy, pevent_update_trivial,
pevent_filter_compare

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h      | 50 ++++++++--------
 kernel-shark-qt/examples/datafilter.c |  4 +-
 kernel-shark-qt/src/libkshark.c       |  8 +--
 kernel-shark/kernel-shark.c           |  4 +-
 kernel-shark/trace-filter.c           | 38 ++++++------
 kernel-shark/trace-graph.c            | 22 +++----
 kernel-shark/trace-view-store.c       | 12 ++--
 kernel-shark/trace-view.c             |  6 +-
 lib/traceevent/parse-filter.c         | 84 +++++++++++++--------------
 tracecmd/trace-read.c                 |  8 +--
 10 files changed, 118 insertions(+), 118 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 5a630cc..812ef18 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -918,16 +918,16 @@ struct filter_type {
 	struct filter_arg	*filter;
 };
 
-#define PEVENT_FILTER_ERROR_BUFSZ  1024
+#define TEP_FILTER_ERROR_BUFSZ  1024
 
 struct event_filter {
 	struct tep_handle	*pevent;
 	int			filters;
 	struct filter_type	*event_filters;
-	char			error_buffer[PEVENT_FILTER_ERROR_BUFSZ];
+	char			error_buffer[TEP_FILTER_ERROR_BUFSZ];
 };
 
-struct event_filter *pevent_filter_alloc(struct tep_handle *pevent);
+struct event_filter *tep_filter_alloc(struct tep_handle *pevent);
 
 /* for backward compatibility */
 #define FILTER_NONE		TEP_ERRNO__NO_FILTER
@@ -941,39 +941,39 @@ enum filter_trivial_type {
 	FILTER_TRIVIAL_BOTH,
 };
 
-enum tep_errno pevent_filter_add_filter_str(struct event_filter *filter,
-					    const char *filter_str);
+enum tep_errno tep_filter_add_filter_str(struct event_filter *filter,
+					 const char *filter_str);
 
-enum tep_errno pevent_filter_match(struct event_filter *filter,
-				   struct tep_record *record);
+enum tep_errno tep_filter_match(struct event_filter *filter,
+				struct tep_record *record);
 
-int pevent_filter_strerror(struct event_filter *filter, enum tep_errno err,
-			   char *buf, size_t buflen);
+int tep_filter_strerror(struct event_filter *filter, enum tep_errno err,
+			char *buf, size_t buflen);
 
-int pevent_event_filtered(struct event_filter *filter,
-			  int event_id);
+int tep_event_filtered(struct event_filter *filter,
+		       int event_id);
 
-void pevent_filter_reset(struct event_filter *filter);
+void tep_filter_reset(struct event_filter *filter);
 
-int pevent_filter_clear_trivial(struct event_filter *filter,
-				 enum filter_trivial_type type);
+int tep_filter_clear_trivial(struct event_filter *filter,
+			     enum filter_trivial_type type);
 
-void pevent_filter_free(struct event_filter *filter);
+void tep_filter_free(struct event_filter *filter);
 
-char *pevent_filter_make_string(struct event_filter *filter, int event_id);
+char *tep_filter_make_string(struct event_filter *filter, int event_id);
 
-int pevent_filter_remove_event(struct event_filter *filter,
-			       int event_id);
+int tep_filter_remove_event(struct event_filter *filter,
+			    int event_id);
 
-int pevent_filter_event_has_trivial(struct event_filter *filter,
-				    int event_id,
-				    enum filter_trivial_type type);
+int tep_filter_event_has_trivial(struct event_filter *filter,
+				 int event_id,
+				 enum filter_trivial_type type);
 
-int pevent_filter_copy(struct event_filter *dest, struct event_filter *source);
+int tep_filter_copy(struct event_filter *dest, struct event_filter *source);
 
-int pevent_update_trivial(struct event_filter *dest, struct event_filter *source,
-			  enum filter_trivial_type type);
+int tep_update_trivial(struct event_filter *dest, struct event_filter *source,
+			enum filter_trivial_type type);
 
-int pevent_filter_compare(struct event_filter *filter1, struct event_filter *filter2);
+int tep_filter_compare(struct event_filter *filter1, struct event_filter *filter2);
 
 #endif /* _PARSE_EVENTS_H */
diff --git a/kernel-shark-qt/examples/datafilter.c b/kernel-shark-qt/examples/datafilter.c
index 1c04ce5..4b1e1e9 100644
--- a/kernel-shark-qt/examples/datafilter.c
+++ b/kernel-shark-qt/examples/datafilter.c
@@ -117,8 +117,8 @@ int main(int argc, char **argv)
 
 	/* Use the Advanced filter to do event content based filtering. */
 	adv_filter = kshark_ctx->advanced_event_filter;
-	pevent_filter_add_filter_str(adv_filter,
-				     "sched/sched_wakeup:target_cpu==1");
+	tep_filter_add_filter_str(adv_filter,
+				  "sched/sched_wakeup:target_cpu==1");
 
 	/* The Advanced filter requires reloading the data. */
 	for (i = 0; i < n_rows; ++i)
diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index bb23afe..4f8da8a 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -148,7 +148,7 @@ bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
 	kshark_ctx->pevent = tracecmd_get_pevent(handle);
 
 	kshark_ctx->advanced_event_filter =
-		pevent_filter_alloc(kshark_ctx->pevent);
+		tep_filter_alloc(kshark_ctx->pevent);
 
 	/*
 	 * Turn off function trace indent and turn on show parent
@@ -180,8 +180,8 @@ void kshark_close(struct kshark_context *kshark_ctx)
 	tracecmd_filter_id_clear(kshark_ctx->hide_event_filter);
 
 	if (kshark_ctx->advanced_event_filter) {
-		pevent_filter_reset(kshark_ctx->advanced_event_filter);
-		pevent_filter_free(kshark_ctx->advanced_event_filter);
+		tep_filter_reset(kshark_ctx->advanced_event_filter);
+		tep_filter_free(kshark_ctx->advanced_event_filter);
 		kshark_ctx->advanced_event_filter = NULL;
 	}
 
@@ -612,7 +612,7 @@ static size_t get_records(struct kshark_context *kshark_ctx,
 				/* Apply event filtering. */
 				ret = FILTER_MATCH;
 				if (adv_filter->filters)
-					ret = pevent_filter_match(adv_filter, rec);
+					ret = tep_filter_match(adv_filter, rec);
 
 				if (!kshark_show_event(kshark_ctx, entry->event_id) ||
 				    ret != FILTER_MATCH) {
diff --git a/kernel-shark/kernel-shark.c b/kernel-shark/kernel-shark.c
index 6b43296..8a512fc 100644
--- a/kernel-shark/kernel-shark.c
+++ b/kernel-shark/kernel-shark.c
@@ -460,7 +460,7 @@ static void load_filter(struct shark_info *info, const char *filename)
 	store = TRACE_VIEW_STORE(model);
 	event_filter = trace_view_store_get_event_filter(store);
 
-	if (pevent_filter_compare(event_filter, ginfo->event_filter))
+	if (tep_filter_compare(event_filter, ginfo->event_filter))
 		sync_event_filters(info);
 }
 
@@ -843,7 +843,7 @@ sync_events_filter_clicked (GtkWidget *subitem, gpointer data)
 	event_filter = trace_view_store_get_event_filter(store);
 
 	/* If they are already equal, then just perminently sync them */
-	if (pevent_filter_compare(event_filter, ginfo->event_filter))
+	if (tep_filter_compare(event_filter, ginfo->event_filter))
 		result = 2;
 	else
 		/* Ask user which way to sync */
diff --git a/kernel-shark/trace-filter.c b/kernel-shark/trace-filter.c
index 7216702..3145f99 100644
--- a/kernel-shark/trace-filter.c
+++ b/kernel-shark/trace-filter.c
@@ -470,7 +470,7 @@ create_tree_filter_model(struct tep_handle *pevent,
 		return GTK_TREE_MODEL(treestore);
 
 	for (i = 0; events[i]; i++) {
-		str = pevent_filter_make_string(event_filter, events[i]->id);
+		str = tep_filter_make_string(event_filter, events[i]->id);
 		if (!str)
 			continue;
 
@@ -1125,12 +1125,12 @@ create_tree_event_model(struct tep_handle *pevent,
 
 		normal = TRUE;
 		if (active && filter) {
-			if (pevent_event_filtered(filter, event->id) &&
-			    !pevent_filter_event_has_trivial(filter, event->id,
+			if (tep_event_filtered(filter, event->id) &&
+			    !tep_filter_event_has_trivial(filter, event->id,
 							     FILTER_TRIVIAL_BOTH))
 				normal = FALSE;
 			/* Make trivial false not selected */
-			else if (pevent_filter_event_has_trivial(filter, event->id,
+			else if (tep_filter_event_has_trivial(filter, event->id,
 								 FILTER_TRIVIAL_FALSE))
 				active = FALSE;
 		}
@@ -1950,7 +1950,7 @@ void trace_filter_convert_filter_to_names(struct event_filter *filter,
 			all_selected = 1;
 		}
 
-		if (pevent_filter_event_has_trivial(filter, event->id,
+		if (tep_filter_event_has_trivial(filter, event->id,
 						    FILTER_TRIVIAL_TRUE)) {
 			if (!all_selected || !systems)
 				*event_ids = tracecmd_add_id(*event_ids, event->id, event_count++);
@@ -1964,7 +1964,7 @@ void trace_filter_convert_filter_to_names(struct event_filter *filter,
 			all_selected = 0;
 
 			/* If this event is filtered, still add it */
-			if (pevent_event_filtered(filter, event->id))
+			if (tep_event_filtered(filter, event->id))
 				*event_ids = tracecmd_add_id(*event_ids, event->id, event_count++);
 		}
 		last_system = event->system;
@@ -1992,28 +1992,28 @@ void trace_filter_convert_char_to_filter(struct event_filter *filter,
 	pevent = filter->pevent;
 
 	/* Make a copy to use later */
-	copy = pevent_filter_alloc(pevent);
-	pevent_filter_copy(copy, filter);
-	pevent_filter_reset(filter);
+	copy = tep_filter_alloc(pevent);
+	tep_filter_copy(copy, filter);
+	tep_filter_reset(filter);
 
 	if (systems) {
 		for (i = 0; systems[i]; i++)
-			pevent_filter_add_filter_str(filter,
-						     systems[i]);
+			tep_filter_add_filter_str(filter,
+						  systems[i]);
 	}
 
 	if (events) {
 		for (i = 0; events[i] >= 0; i++) {
 			event = tep_find_event(filter->pevent, events[i]);
 			if (event)
-				pevent_filter_add_filter_str(filter,
-							     event->name);
+				tep_filter_add_filter_str(filter,
+							  event->name);
 		}
 	}
 
-	pevent_update_trivial(filter, copy, FILTER_TRIVIAL_BOTH);
+	tep_update_trivial(filter, copy, FILTER_TRIVIAL_BOTH);
 
-	pevent_filter_free(copy);
+	tep_filter_free(copy);
 }
 
 int trace_filter_save_events(struct tracecmd_xml_handle *handle,
@@ -2032,7 +2032,7 @@ int trace_filter_save_events(struct tracecmd_xml_handle *handle,
 		tracecmd_xml_write_element(handle, "System", "%s", systems[i]);
 
 	for (i = 0; event_ids && event_ids[i] > 0; i++) {
-		str = pevent_filter_make_string(filter, event_ids[i]);
+		str = tep_filter_make_string(filter, event_ids[i]);
 		if (!str)
 			continue;
 
@@ -2098,7 +2098,7 @@ int trace_filter_load_events(struct event_filter *event_filter,
 
 		if (strcmp(name, "System") == 0) {
 			system = tracecmd_xml_node_value(handle, node);
-			pevent_filter_add_filter_str(event_filter,
+			tep_filter_add_filter_str(event_filter,
 						     system);
 		} else if (strcmp(name, "Event") == 0) {
 			system = NULL;
@@ -2145,8 +2145,8 @@ int trace_filter_load_events(struct event_filter *event_filter,
 						sprintf(buffer, "%s", event);
 					}
 				}
-				pevent_filter_add_filter_str(event_filter,
-							     buffer);
+				tep_filter_add_filter_str(event_filter,
+							  buffer);
 				free(buffer);
 			}
 		}
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index 3fe0f83..53f5e39 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -279,7 +279,7 @@ gboolean trace_graph_filter_on_event(struct graph_info *ginfo, struct tep_record
 	if (ginfo->all_events)
 		return FALSE;
 
-	ret = pevent_filter_match(ginfo->event_filter, record);
+	ret = tep_filter_match(ginfo->event_filter, record);
 	return ret == FILTER_MATCH ? FALSE : TRUE;
 }
 
@@ -2235,14 +2235,14 @@ void trace_graph_event_filter_callback(gboolean accept,
 	if (all_events) {
 		ginfo->all_events = TRUE;
 		/* filter is no longer used */
-		pevent_filter_reset(ginfo->event_filter);
+		tep_filter_reset(ginfo->event_filter);
 		redraw_graph(ginfo);
 		return;
 	}
 
 	ginfo->all_events = FALSE;
 
-	pevent_filter_clear_trivial(ginfo->event_filter, FILTER_TRIVIAL_BOTH);
+	tep_filter_clear_trivial(ginfo->event_filter, FILTER_TRIVIAL_BOTH);
 
 	trace_filter_convert_char_to_filter(ginfo->event_filter,
 					    systems, events);
@@ -2271,17 +2271,17 @@ void trace_graph_adv_filter_callback(gboolean accept,
 
 	if (event_ids) {
 		for (i = 0; event_ids[i] >= 0; i++)
-			pevent_filter_remove_event(event_filter, event_ids[i]);
+			tep_filter_remove_event(event_filter, event_ids[i]);
 	}
 
 	if (has_text(text)) {
 
 		ginfo->all_events = FALSE;
 
-		pevent_filter_clear_trivial(event_filter,
+		tep_filter_clear_trivial(event_filter,
 					    FILTER_TRIVIAL_BOTH);
 
-		ret = pevent_filter_add_filter_str(event_filter, text);
+		ret = tep_filter_add_filter_str(event_filter, text);
 		if (ret < 0) {
 			pevent_strerror(event_filter->pevent, ret,
 					error_str, sizeof(error_str));
@@ -2300,14 +2300,14 @@ void trace_graph_copy_filter(struct graph_info *ginfo,
 	if (all_events) {
 		ginfo->all_events = TRUE;
 		/* filter is no longer used */
-		pevent_filter_reset(ginfo->event_filter);
+		tep_filter_reset(ginfo->event_filter);
 		redraw_graph(ginfo);
 		return;
 	}
 
 	ginfo->all_events = FALSE;
 
-	pevent_filter_copy(ginfo->event_filter, event_filter);
+	tep_filter_copy(ginfo->event_filter, event_filter);
 
 	redraw_graph(ginfo);
 }
@@ -2515,7 +2515,7 @@ static void free_int_array(int **array)
 void trace_graph_free_info(struct graph_info *ginfo)
 {
 	if (ginfo->handle) {
-		pevent_filter_free(ginfo->event_filter);
+		tep_filter_free(ginfo->event_filter);
 		trace_graph_plot_free(ginfo);
 		tracecmd_close(ginfo->handle);
 		free_task_hash(ginfo);
@@ -2552,7 +2552,7 @@ static int load_handle(struct graph_info *ginfo,
 	ginfo->cpus = tracecmd_cpus(handle);
 	ginfo->all_events = TRUE;
 
-	ginfo->event_filter = pevent_filter_alloc(ginfo->pevent);
+	ginfo->event_filter = tep_filter_alloc(ginfo->pevent);
 
 	ginfo->start_time = -1ULL;
 	ginfo->end_time = 0;
@@ -2645,7 +2645,7 @@ static int load_event_filter(struct graph_info *ginfo,
 	if (!node)
 		return -1;
 
-	pevent_filter_clear_trivial(event_filter, FILTER_TRIVIAL_BOTH);
+	tep_filter_clear_trivial(event_filter, FILTER_TRIVIAL_BOTH);
 	ginfo->all_events = FALSE;
 
 	trace_filter_load_events(event_filter, handle, node);
diff --git a/kernel-shark/trace-view-store.c b/kernel-shark/trace-view-store.c
index 61d0157..8d4e05f 100644
--- a/kernel-shark/trace-view-store.c
+++ b/kernel-shark/trace-view-store.c
@@ -224,7 +224,7 @@ trace_view_store_finalize (GObject *object)
 		store->spin = NULL;
 	}
 
-	pevent_filter_free(store->event_filter);
+	tep_filter_free(store->event_filter);
 	tracecmd_close(store->handle);
 
 	/* must chain up - finalize parent */
@@ -512,7 +512,7 @@ void trace_view_store_clear_all_events_enabled(TraceViewStore *store)
 {
 	g_return_if_fail (TRACE_VIEW_IS_LIST (store));
 
-	pevent_filter_clear_trivial(store->event_filter, FILTER_TRIVIAL_BOTH);
+	tep_filter_clear_trivial(store->event_filter, FILTER_TRIVIAL_BOTH);
 	store->all_events = 0;
 }
 
@@ -527,7 +527,7 @@ void trace_view_store_set_all_events_enabled(TraceViewStore *store)
 	 * All enabled means that we don't need to look at 
 	 * the system events, so free those arrays.
 	 */
-	pevent_filter_reset(store->event_filter);
+	tep_filter_reset(store->event_filter);
 
 	store->all_events = 1;
 }
@@ -855,7 +855,7 @@ trace_view_store_new (struct tracecmd_input *handle)
 	newstore->handle = handle;
 	newstore->cpus = tracecmd_cpus(handle);
 	tracecmd_ref(handle);
-	newstore->event_filter = pevent_filter_alloc(tracecmd_get_pevent(handle));
+	newstore->event_filter = tep_filter_alloc(tracecmd_get_pevent(handle));
 
 	newstore->cpu_list = g_new(TraceViewRecord *, newstore->cpus);
 	g_assert(newstore->cpu_list != NULL);
@@ -1257,8 +1257,8 @@ static void update_filter_tasks(TraceViewStore *store)
 			/* The record may be filtered by the events */
 			if (!store->all_events) {
 				int ret;
-				ret = pevent_filter_match(store->event_filter,
-							  record);
+				ret = tep_filter_match(store->event_filter,
+						       record);
 				if (ret != FILTER_MATCH) {
 					store->cpu_list[cpu][i].visible = 0;
 					goto skip;
diff --git a/kernel-shark/trace-view.c b/kernel-shark/trace-view.c
index a1e0b47..fdf8290 100644
--- a/kernel-shark/trace-view.c
+++ b/kernel-shark/trace-view.c
@@ -463,14 +463,14 @@ void trace_view_adv_filter_callback(gboolean accept,
 
 	if (event_ids) {
 		for (i = 0; event_ids[i] >= 0; i++)
-			pevent_filter_remove_event(event_filter, event_ids[i]);
+			tep_filter_remove_event(event_filter, event_ids[i]);
 	}
 
 	if (has_text(text)) {
 
 		trace_view_store_clear_all_events_enabled(store);
 
-		ret = pevent_filter_add_filter_str(event_filter, text);
+		ret = tep_filter_add_filter_str(event_filter, text);
 		if (ret < 0) {
 			pevent_strerror(event_filter->pevent, ret,
 					error_str, sizeof(error_str));
@@ -509,7 +509,7 @@ void trace_view_copy_filter(GtkWidget *treeview,
 
 		event_filter = trace_view_store_get_event_filter(store);
 
-		pevent_filter_copy(event_filter, src_event_filter);
+		tep_filter_copy(event_filter, src_event_filter);
 	}
 
 	update_rows(trace_tree, store);
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index 2241523..df42e04 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -52,7 +52,7 @@ static void show_error(char *error_buf, const char *fmt, ...)
 	}
 
 	va_start(ap, fmt);
-	vsnprintf(error_buf + len, PEVENT_FILTER_ERROR_BUFSZ - len, fmt, ap);
+	vsnprintf(error_buf + len, TEP_FILTER_ERROR_BUFSZ - len, fmt, ap);
 	va_end(ap);
 }
 
@@ -162,10 +162,10 @@ add_filter_type(struct event_filter *filter, int id)
 }
 
 /**
- * pevent_filter_alloc - create a new event filter
+ * tep_filter_alloc - create a new event filter
  * @pevent: The pevent that this filter is associated with
  */
-struct event_filter *pevent_filter_alloc(struct tep_handle *pevent)
+struct event_filter *tep_filter_alloc(struct tep_handle *pevent)
 {
 	struct event_filter *filter;
 
@@ -1245,16 +1245,16 @@ static void filter_init_error_buf(struct event_filter *filter)
 }
 
 /**
- * pevent_filter_add_filter_str - add a new filter
+ * tep_filter_add_filter_str - add a new filter
  * @filter: the event filter to add to
  * @filter_str: the filter string that contains the filter
  *
  * Returns 0 if the filter was successfully added or a
- * negative error code.  Use pevent_filter_strerror() to see
+ * negative error code.  Use tep_filter_strerror() to see
  * actual error message in case of error.
  */
-enum tep_errno pevent_filter_add_filter_str(struct event_filter *filter,
-					       const char *filter_str)
+enum tep_errno tep_filter_add_filter_str(struct event_filter *filter,
+					 const char *filter_str)
 {
 	struct tep_handle *pevent = filter->pevent;
 	struct event_list *event;
@@ -1335,7 +1335,7 @@ enum tep_errno pevent_filter_add_filter_str(struct event_filter *filter,
 
 		if (ret >= 0 && pevent->test_filters) {
 			char *test;
-			test = pevent_filter_make_string(filter, event->event->id);
+			test = tep_filter_make_string(filter, event->event->id);
 			if (test) {
 				printf(" '%s: %s'\n", event->event->name, test);
 				free(test);
@@ -1357,7 +1357,7 @@ static void free_filter_type(struct filter_type *filter_type)
 }
 
 /**
- * pevent_filter_strerror - fill error message in a buffer
+ * tep_filter_strerror - fill error message in a buffer
  * @filter: the event filter contains error
  * @err: the error code
  * @buf: the buffer to be filled in
@@ -1365,8 +1365,8 @@ static void free_filter_type(struct filter_type *filter_type)
  *
  * Returns 0 if message was filled successfully, -1 if error
  */
-int pevent_filter_strerror(struct event_filter *filter, enum tep_errno err,
-			   char *buf, size_t buflen)
+int tep_filter_strerror(struct event_filter *filter, enum tep_errno err,
+			char *buf, size_t buflen)
 {
 	if (err <= __TEP_ERRNO__START || err >= __TEP_ERRNO__END)
 		return -1;
@@ -1383,7 +1383,7 @@ int pevent_filter_strerror(struct event_filter *filter, enum tep_errno err,
 }
 
 /**
- * pevent_filter_remove_event - remove a filter for an event
+ * tep_filter_remove_event - remove a filter for an event
  * @filter: the event filter to remove from
  * @event_id: the event to remove a filter for
  *
@@ -1393,8 +1393,8 @@ int pevent_filter_strerror(struct event_filter *filter, enum tep_errno err,
  * Returns 1: if an event was removed
  *   0: if the event was not found
  */
-int pevent_filter_remove_event(struct event_filter *filter,
-			       int event_id)
+int tep_filter_remove_event(struct event_filter *filter,
+			    int event_id)
 {
 	struct filter_type *filter_type;
 	unsigned long len;
@@ -1423,12 +1423,12 @@ int pevent_filter_remove_event(struct event_filter *filter,
 }
 
 /**
- * pevent_filter_reset - clear all filters in a filter
+ * tep_filter_reset - clear all filters in a filter
  * @filter: the event filter to reset
  *
  * Removes all filters from a filter and resets it.
  */
-void pevent_filter_reset(struct event_filter *filter)
+void tep_filter_reset(struct event_filter *filter)
 {
 	int i;
 
@@ -1440,11 +1440,11 @@ void pevent_filter_reset(struct event_filter *filter)
 	filter->event_filters = NULL;
 }
 
-void pevent_filter_free(struct event_filter *filter)
+void tep_filter_free(struct event_filter *filter)
 {
 	pevent_unref(filter->pevent);
 
-	pevent_filter_reset(filter);
+	tep_filter_reset(filter);
 
 	free(filter);
 }
@@ -1501,18 +1501,18 @@ static int copy_filter_type(struct event_filter *filter,
 }
 
 /**
- * pevent_filter_copy - copy a filter using another filter
+ * tep_filter_copy - copy a filter using another filter
  * @dest - the filter to copy to
  * @source - the filter to copy from
  *
  * Returns 0 on success and -1 if not all filters were copied
  */
-int pevent_filter_copy(struct event_filter *dest, struct event_filter *source)
+int tep_filter_copy(struct event_filter *dest, struct event_filter *source)
 {
 	int ret = 0;
 	int i;
 
-	pevent_filter_reset(dest);
+	tep_filter_reset(dest);
 
 	for (i = 0; i < source->filters; i++) {
 		if (copy_filter_type(dest, source, &source->event_filters[i]))
@@ -1523,7 +1523,7 @@ int pevent_filter_copy(struct event_filter *dest, struct event_filter *source)
 
 
 /**
- * pevent_update_trivial - update the trivial filters with the given filter
+ * tep_update_trivial - update the trivial filters with the given filter
  * @dest - the filter to update
  * @source - the filter as the source of the update
  * @type - the type of trivial filter to update.
@@ -1533,8 +1533,8 @@ int pevent_filter_copy(struct event_filter *dest, struct event_filter *source)
  * Returns 0 on success and -1 if there was a problem updating, but
  *   events may have still been updated on error.
  */
-int pevent_update_trivial(struct event_filter *dest, struct event_filter *source,
-			  enum filter_trivial_type type)
+int tep_update_trivial(struct event_filter *dest, struct event_filter *source,
+		       enum filter_trivial_type type)
 {
 	struct tep_handle *src_pevent;
 	struct tep_handle *dest_pevent;
@@ -1571,7 +1571,7 @@ int pevent_update_trivial(struct event_filter *dest, struct event_filter *source
 				return -1;
 		}
 
-		str = pevent_filter_make_string(source, event->id);
+		str = tep_filter_make_string(source, event->id);
 		if (!str)
 			continue;
 
@@ -1584,7 +1584,7 @@ int pevent_update_trivial(struct event_filter *dest, struct event_filter *source
 }
 
 /**
- * pevent_filter_clear_trivial - clear TRUE and FALSE filters
+ * tep_filter_clear_trivial - clear TRUE and FALSE filters
  * @filter: the filter to remove trivial filters from
  * @type: remove only true, false, or both
  *
@@ -1592,8 +1592,8 @@ int pevent_update_trivial(struct event_filter *dest, struct event_filter *source
  *
  * Returns 0 on success and -1 if there was a problem.
  */
-int pevent_filter_clear_trivial(struct event_filter *filter,
-				 enum filter_trivial_type type)
+int tep_filter_clear_trivial(struct event_filter *filter,
+			     enum filter_trivial_type type)
 {
 	struct filter_type *filter_type;
 	int count = 0;
@@ -1639,14 +1639,14 @@ int pevent_filter_clear_trivial(struct event_filter *filter,
 		return 0;
 
 	for (i = 0; i < count; i++)
-		pevent_filter_remove_event(filter, ids[i]);
+		tep_filter_remove_event(filter, ids[i]);
 
 	free(ids);
 	return 0;
 }
 
 /**
- * pevent_filter_event_has_trivial - return true event contains trivial filter
+ * tep_filter_event_has_trivial - return true event contains trivial filter
  * @filter: the filter with the information
  * @event_id: the id of the event to test
  * @type: trivial type to test for (TRUE, FALSE, EITHER)
@@ -1654,9 +1654,9 @@ int pevent_filter_clear_trivial(struct event_filter *filter,
  * Returns 1 if the event contains a matching trivial type
  *  otherwise 0.
  */
-int pevent_filter_event_has_trivial(struct event_filter *filter,
-				    int event_id,
-				    enum filter_trivial_type type)
+int tep_filter_event_has_trivial(struct event_filter *filter,
+				 int event_id,
+				 enum filter_trivial_type type)
 {
 	struct filter_type *filter_type;
 
@@ -2001,14 +2001,14 @@ static int test_filter(struct event_format *event, struct filter_arg *arg,
 }
 
 /**
- * pevent_event_filtered - return true if event has filter
+ * tep_event_filtered - return true if event has filter
  * @filter: filter struct with filter information
  * @event_id: event id to test if filter exists
  *
  * Returns 1 if filter found for @event_id
  *   otherwise 0;
  */
-int pevent_event_filtered(struct event_filter *filter, int event_id)
+int tep_event_filtered(struct event_filter *filter, int event_id)
 {
 	struct filter_type *filter_type;
 
@@ -2021,7 +2021,7 @@ int pevent_event_filtered(struct event_filter *filter, int event_id)
 }
 
 /**
- * pevent_filter_match - test if a record matches a filter
+ * tep_filter_match - test if a record matches a filter
  * @filter: filter struct with filter information
  * @record: the record to test against the filter
  *
@@ -2032,8 +2032,8 @@ int pevent_event_filtered(struct event_filter *filter, int event_id)
  * NO_FILTER - if no filters exist
  * otherwise - error occurred during test
  */
-enum tep_errno pevent_filter_match(struct event_filter *filter,
-				   struct tep_record *record)
+enum tep_errno tep_filter_match(struct event_filter *filter,
+				struct tep_record *record)
 {
 	struct tep_handle *pevent = filter->pevent;
 	struct filter_type *filter_type;
@@ -2350,7 +2350,7 @@ static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
 }
 
 /**
- * pevent_filter_make_string - return a string showing the filter
+ * tep_filter_make_string - return a string showing the filter
  * @filter: filter struct with filter information
  * @event_id: the event id to return the filter string with
  *
@@ -2359,7 +2359,7 @@ static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
  *  NULL is returned if no filter is found or allocation failed.
  */
 char *
-pevent_filter_make_string(struct event_filter *filter, int event_id)
+tep_filter_make_string(struct event_filter *filter, int event_id)
 {
 	struct filter_type *filter_type;
 
@@ -2375,7 +2375,7 @@ pevent_filter_make_string(struct event_filter *filter, int event_id)
 }
 
 /**
- * pevent_filter_compare - compare two filters and return if they are the same
+ * tep_filter_compare - compare two filters and return if they are the same
  * @filter1: Filter to compare with @filter2
  * @filter2: Filter to compare with @filter1
  *
@@ -2383,7 +2383,7 @@ pevent_filter_make_string(struct event_filter *filter, int event_id)
  *  1 if the two filters hold the same content.
  *  0 if they do not.
  */
-int pevent_filter_compare(struct event_filter *filter1, struct event_filter *filter2)
+int tep_filter_compare(struct event_filter *filter1, struct event_filter *filter2)
 {
 	struct filter_type *filter_type1;
 	struct filter_type *filter_type2;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 74059a0..352ff11 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -503,11 +503,11 @@ static void process_filters(struct handle_list *handles)
 		if (!event_filter)
 			die("Failed to allocate for event filter");
 		event_filter->next = NULL;
-		event_filter->filter = pevent_filter_alloc(pevent);
+		event_filter->filter = tep_filter_alloc(pevent);
 		if (!event_filter->filter)
 			die("malloc");
 
-		ret = pevent_filter_add_filter_str(event_filter->filter,
+		ret = tep_filter_add_filter_str(event_filter->filter,
 						   filter->filter);
 		if (ret < 0) {
 			pevent_strerror(pevent, ret, errstr, sizeof(errstr));
@@ -891,7 +891,7 @@ test_filters(struct tep_handle *pevent, struct filter *event_filters,
 	}
 
 	while (event_filters) {
-		ret = pevent_filter_match(event_filters->filter, record);
+		ret = tep_filter_match(event_filters->filter, record);
 		switch (ret) {
 			case FILTER_NONE:
 			case FILTER_MATCH: 
@@ -1099,7 +1099,7 @@ static void free_filters(struct filter *event_filter)
 		filter = event_filter;
 		event_filter = filter->next;
 
-		pevent_filter_free(filter->filter);
+		tep_filter_free(filter->filter);
 		free(filter);
 	}
 }
-- 
2.17.1
