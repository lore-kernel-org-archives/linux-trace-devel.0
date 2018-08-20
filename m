Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f49.google.com ([209.85.221.49]:40453 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbeHTRvf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 13:51:35 -0400
Received: by mail-wr1-f49.google.com with SMTP id n2-v6so2715762wrw.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Aug 2018 07:35:39 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 23/24] trace-cmd: Rename various pevent APIs
Date: Mon, 20 Aug 2018 17:35:04 +0300
Message-Id: <20180820143505.11525-24-tz.stoyanov@gmail.com>
In-Reply-To: <20180820143505.11525-1-tz.stoyanov@gmail.com>
References: <20180820143505.11525-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_reset_function_resolver, pevent_strerror, pevent_list_events,
pevent_event_common_fields, pevent_event_fields, pevent_ref, pevent_unref

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h | 14 +++++++-------
 kernel-shark/trace-dialog.c      |  2 +-
 kernel-shark/trace-filter.c      | 18 +++++++++---------
 kernel-shark/trace-graph.c       |  6 +++---
 kernel-shark/trace-view.c        |  4 ++--
 lib/traceevent/event-parse.c     | 22 +++++++++++-----------
 lib/traceevent/parse-filter.c    |  6 +++---
 tracecmd/trace-output.c          |  6 +++---
 tracecmd/trace-profile.c         |  4 ++--
 tracecmd/trace-read.c            |  6 +++---
 10 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 1da291e..713a4e4 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -605,7 +605,7 @@ enum trace_flag_type {
 
 int tep_set_function_resolver(struct tep_handle *pevent,
 			      tep_func_resolver_t *func, void *priv);
-void pevent_reset_function_resolver(struct tep_handle *pevent);
+void tep_reset_function_resolver(struct tep_handle *pevent);
 int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid);
 int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
 int tep_register_function(struct tep_handle *pevent, char *name,
@@ -712,12 +712,12 @@ void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct event_format *event);
 void tep_event_info(struct trace_seq *s, struct event_format *event,
 		       struct tep_record *record);
-int pevent_strerror(struct tep_handle *pevent, enum tep_errno errnum,
+int tep_strerror(struct tep_handle *pevent, enum tep_errno errnum,
 		    char *buf, size_t buflen);
 
-struct event_format **pevent_list_events(struct tep_handle *pevent, enum event_sort_type);
-struct format_field **pevent_event_common_fields(struct event_format *event);
-struct format_field **pevent_event_fields(struct event_format *event);
+struct event_format **tep_list_events(struct tep_handle *pevent, enum event_sort_type);
+struct format_field **tep_event_common_fields(struct event_format *event);
+struct format_field **tep_event_fields(struct event_format *event);
 
 static inline int tep_get_cpus(struct tep_handle *pevent)
 {
@@ -781,8 +781,8 @@ static inline void tep_set_latency_format(struct tep_handle *pevent, int lat)
 
 struct tep_handle *tep_alloc(void);
 void tep_free(struct tep_handle *pevent);
-void pevent_ref(struct tep_handle *pevent);
-void pevent_unref(struct tep_handle *pevent);
+void tep_ref(struct tep_handle *pevent);
+void tep_unref(struct tep_handle *pevent);
 
 /* access to the internal parser */
 void tep_buffer_init(const char *buf, unsigned long long size);
diff --git a/kernel-shark/trace-dialog.c b/kernel-shark/trace-dialog.c
index 50b4daf..3eba62e 100644
--- a/kernel-shark/trace-dialog.c
+++ b/kernel-shark/trace-dialog.c
@@ -379,7 +379,7 @@ static void read_raw_events(struct trace_seq *s,
 	struct format_field **fields;
 	int i;
 
-	fields = pevent_event_fields(event);
+	fields = tep_event_fields(event);
 	if (!fields)
 		return;
 
diff --git a/kernel-shark/trace-filter.c b/kernel-shark/trace-filter.c
index d9b1563..8d78b31 100644
--- a/kernel-shark/trace-filter.c
+++ b/kernel-shark/trace-filter.c
@@ -92,7 +92,7 @@ static GtkTreeModel *create_event_combo_model(gpointer data)
 	const char *last_sys = NULL;
 	int i;
 
-	events = pevent_list_events(pevent, EVENT_SORT_SYSTEM);
+	events = tep_list_events(pevent, EVENT_SORT_SYSTEM);
 	if (!events)
 		return NULL;
 
@@ -150,14 +150,14 @@ static GtkTreeModel *create_field_combo_model(gpointer data)
 	struct format_field *field;
 	int i;
 
-	events = pevent_list_events(pevent, EVENT_SORT_SYSTEM);
+	events = tep_list_events(pevent, EVENT_SORT_SYSTEM);
 	if (!events)
 		return NULL;
 
 	list = gtk_list_store_new(1, G_TYPE_STRING);
 
 	/* use any event for common fields */
-	fields = pevent_event_common_fields(events[0]);
+	fields = tep_event_common_fields(events[0]);
 
 	for (i = 0; fields[i]; i++) {
 		field = fields[i];
@@ -199,7 +199,7 @@ static void update_field_combo(struct tep_handle *pevent,
 			return;
 	} else {
 		/* use any event */
-		events = pevent_list_events(pevent, EVENT_SORT_SYSTEM);
+		events = tep_list_events(pevent, EVENT_SORT_SYSTEM);
 		if (!events)
 			return;
 		event = events[0];
@@ -215,7 +215,7 @@ static void update_field_combo(struct tep_handle *pevent,
 		;
 
 	/* always load the common fields first */
-	fields = pevent_event_common_fields(event);
+	fields = tep_event_common_fields(event);
 	for (i = 0; fields[i]; i++) {
 		field = fields[i];
 		gtk_list_store_append(list, &iter);
@@ -227,7 +227,7 @@ static void update_field_combo(struct tep_handle *pevent,
 
 	/* Now add event specific events */
 	if (event_name) {
-		fields = pevent_event_fields(event);
+		fields = tep_event_fields(event);
 		for (i = 0; fields[i]; i++) {
 			field = fields[i];
 			gtk_list_store_append(list, &iter);
@@ -465,7 +465,7 @@ create_tree_filter_model(struct tep_handle *pevent,
 				       G_TYPE_STRING, G_TYPE_STRING,
 				       G_TYPE_INT);
 
-	events = pevent_list_events(pevent, EVENT_SORT_SYSTEM);
+	events = tep_list_events(pevent, EVENT_SORT_SYSTEM);
 	if (!events)
 		return GTK_TREE_MODEL(treestore);
 
@@ -1086,7 +1086,7 @@ create_tree_event_model(struct tep_handle *pevent,
 			   COL_ACTIVE_START, FALSE,
 			   -1);
 
-	events = pevent_list_events(pevent, EVENT_SORT_SYSTEM);
+	events = tep_list_events(pevent, EVENT_SORT_SYSTEM);
 	if (!events)
 		return GTK_TREE_MODEL(treestore);
 
@@ -1937,7 +1937,7 @@ void trace_filter_convert_filter_to_names(struct event_filter *filter,
 	if (event_ids)
 		*event_ids = NULL;
 
-	events = pevent_list_events(pevent, EVENT_SORT_SYSTEM);
+	events = tep_list_events(pevent, EVENT_SORT_SYSTEM);
 
 	for (i = 0; events[i]; i++) {
 		event = events[i];
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index 88870c1..183f7bd 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -1196,7 +1196,7 @@ trace_graph_check_irq(struct graph_info *ginfo,
 		else
 			ginfo->soft_irq_entry_ids = null_int_array;
 
-		events = pevent_list_events(ginfo->pevent, EVENT_SORT_SYSTEM);
+		events = tep_list_events(ginfo->pevent, EVENT_SORT_SYSTEM);
 
 		for (i = 0; events[i]; i++) {
 			event = events[i];
@@ -2283,8 +2283,8 @@ void trace_graph_adv_filter_callback(gboolean accept,
 
 		ret = tep_filter_add_filter_str(event_filter, text);
 		if (ret < 0) {
-			pevent_strerror(event_filter->pevent, ret,
-					error_str, sizeof(error_str));
+			tep_strerror(event_filter->pevent, ret,
+				     error_str, sizeof(error_str));
 			warning("filter failed due to: %s", error_str);
 			return;
 		}
diff --git a/kernel-shark/trace-view.c b/kernel-shark/trace-view.c
index fdf8290..2f50361 100644
--- a/kernel-shark/trace-view.c
+++ b/kernel-shark/trace-view.c
@@ -472,8 +472,8 @@ void trace_view_adv_filter_callback(gboolean accept,
 
 		ret = tep_filter_add_filter_str(event_filter, text);
 		if (ret < 0) {
-			pevent_strerror(event_filter->pevent, ret,
-					error_str, sizeof(error_str));
+			tep_strerror(event_filter->pevent, ret,
+				     error_str, sizeof(error_str));
 			warning("filter failed due to: %s", error_str);
 			return;
 		}
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index b41608e..51932b8 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -457,13 +457,13 @@ int tep_set_function_resolver(struct tep_handle *pevent,
 }
 
 /**
- * pevent_reset_function_resolver - reset alternative function resolver
+ * tep_reset_function_resolver - reset alternative function resolver
  * @pevent: handle for the pevent
  *
  * Stop using whatever alternative resolver was set, use the default
  * one instead.
  */
-void pevent_reset_function_resolver(struct tep_handle *pevent)
+void tep_reset_function_resolver(struct tep_handle *pevent)
 {
 	free(pevent->func_resolver);
 	pevent->func_resolver = NULL;
@@ -5616,7 +5616,7 @@ static int events_system_cmp(const void *a, const void *b)
 	return events_id_cmp(a, b);
 }
 
-struct event_format **pevent_list_events(struct tep_handle *pevent, enum event_sort_type sort_type)
+struct event_format **tep_list_events(struct tep_handle *pevent, enum event_sort_type sort_type)
 {
 	struct event_format **events;
 	int (*sort)(const void *a, const void *b);
@@ -5695,13 +5695,13 @@ get_event_fields(const char *type, const char *name,
 }
 
 /**
- * pevent_event_common_fields - return a list of common fields for an event
+ * tep_event_common_fields - return a list of common fields for an event
  * @event: the event to return the common fields of.
  *
  * Returns an allocated array of fields. The last item in the array is NULL.
  * The array must be freed with free().
  */
-struct format_field **pevent_event_common_fields(struct event_format *event)
+struct format_field **tep_event_common_fields(struct event_format *event)
 {
 	return get_event_fields("common", event->name,
 				event->format.nr_common,
@@ -5709,13 +5709,13 @@ struct format_field **pevent_event_common_fields(struct event_format *event)
 }
 
 /**
- * pevent_event_fields - return a list of event specific fields for an event
+ * tep_event_fields - return a list of event specific fields for an event
  * @event: the event to return the fields of.
  *
  * Returns an allocated array of fields. The last item in the array is NULL.
  * The array must be freed with free().
  */
-struct format_field **pevent_event_fields(struct event_format *event)
+struct format_field **tep_event_fields(struct event_format *event)
 {
 	return get_event_fields("event", event->name,
 				event->format.nr_fields,
@@ -6207,8 +6207,8 @@ static const char * const pevent_error_str[] = {
 };
 #undef _PE
 
-int pevent_strerror(struct tep_handle *pevent __maybe_unused,
-		    enum tep_errno errnum, char *buf, size_t buflen)
+int tep_strerror(struct tep_handle *pevent __maybe_unused,
+		 enum tep_errno errnum, char *buf, size_t buflen)
 {
 	int idx;
 	const char *msg;
@@ -6752,7 +6752,7 @@ struct tep_handle *tep_alloc(void)
 	return pevent;
 }
 
-void pevent_ref(struct tep_handle *pevent)
+void tep_ref(struct tep_handle *pevent)
 {
 	pevent->ref_count++;
 }
@@ -6885,7 +6885,7 @@ void tep_free(struct tep_handle *pevent)
 	free(pevent);
 }
 
-void pevent_unref(struct tep_handle *pevent)
+void tep_unref(struct tep_handle *pevent)
 {
 	tep_free(pevent);
 }
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index 1ff488d..e76154c 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -175,7 +175,7 @@ struct event_filter *tep_filter_alloc(struct tep_handle *pevent)
 
 	memset(filter, 0, sizeof(*filter));
 	filter->pevent = pevent;
-	pevent_ref(pevent);
+	tep_ref(pevent);
 
 	return filter;
 }
@@ -1379,7 +1379,7 @@ int tep_filter_strerror(struct event_filter *filter, enum tep_errno err,
 		return 0;
 	}
 
-	return pevent_strerror(filter->pevent, err, buf, buflen);
+	return tep_strerror(filter->pevent, err, buf, buflen);
 }
 
 /**
@@ -1442,7 +1442,7 @@ void tep_filter_reset(struct event_filter *filter)
 
 void tep_filter_free(struct event_filter *filter)
 {
-	pevent_unref(filter->pevent);
+	tep_unref(filter->pevent);
 
 	tep_filter_reset(filter);
 
diff --git a/tracecmd/trace-output.c b/tracecmd/trace-output.c
index a0f2898..ff7b198 100644
--- a/tracecmd/trace-output.c
+++ b/tracecmd/trace-output.c
@@ -116,7 +116,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 		free(handle->tracing_dir);
 
 	if (handle->pevent)
-		pevent_unref(handle->pevent);
+		tep_unref(handle->pevent);
 
 	while (!list_empty(&handle->options)) {
 		option = container_of(handle->options.next,
@@ -808,7 +808,7 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 		pevent = tracecmd_get_pevent(ihandle);
 		/* Use the pevent of the ihandle for later writes */
 		handle->pevent = tracecmd_get_pevent(ihandle);
-		pevent_ref(pevent);
+		tep_ref(pevent);
 		if (pevent->file_bigendian)
 			buf[0] = 1;
 		else
@@ -1261,7 +1261,7 @@ int tracecmd_attach_cpu_data_fd(int fd, int cpus, char * const *cpu_data_files)
 	pevent = tracecmd_get_pevent(ihandle);
 	/* Use the pevent of the ihandle for later writes */
 	handle->pevent = tracecmd_get_pevent(ihandle);
-	pevent_ref(pevent);
+	tep_ref(pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
 	list_head_init(&handle->options);
 
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index 6d56093..5cf0ccd 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -1458,7 +1458,7 @@ void trace_init_profile(struct tracecmd_input *handle, struct hook_list *hook,
 		syscall_exit->print_func = syscall_print;
 	}
 
-	events = pevent_list_events(pevent, EVENT_SORT_ID);
+	events = tep_list_events(pevent, EVENT_SORT_ID);
 	if (!events)
 		die("malloc");
 
@@ -1497,7 +1497,7 @@ void trace_init_profile(struct tracecmd_input *handle, struct hook_list *hook,
 		event_data = add_event(h, events[i]->system, events[i]->name,
 				       EVENT_TYPE_UNDEFINED);
 
-		fields = pevent_event_fields(events[i]);
+		fields = tep_event_fields(events[i]);
 		if (!fields)
 			die("malloc");
 
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 5832a8e..02f0ce8 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -510,7 +510,7 @@ static void process_filters(struct handle_list *handles)
 		ret = tep_filter_add_filter_str(event_filter->filter,
 						   filter->filter);
 		if (ret < 0) {
-			pevent_strerror(pevent, ret, errstr, sizeof(errstr));
+			tep_strerror(pevent, ret, errstr, sizeof(errstr));
 			die("Error filtering: %s\n%s",
 			    filter->filter, errstr);
 		}
@@ -1346,7 +1346,7 @@ static void set_event_flags(struct tep_handle *pevent, struct event_str *list,
 	if (!list)
 		return;
 
-	events = pevent_list_events(pevent, 0);
+	events = tep_list_events(pevent, 0);
 
 	for (str = list; str; str = str->next) {
 		char *match;
@@ -1740,7 +1740,7 @@ void trace_report (int argc, char **argv)
 			struct event_format *event;
 			int i;
 
-			events = pevent_list_events(pevent, EVENT_SORT_SYSTEM);
+			events = tep_list_events(pevent, EVENT_SORT_SYSTEM);
 			for (i = 0; events[i]; i++) {
 				event = events[i];
 				if (event->system)
-- 
2.17.1
