Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f52.google.com ([209.85.221.52]:41056 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730355AbeHAO2d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 10:28:33 -0400
Received: by mail-wr1-f52.google.com with SMTP id j5-v6so19992262wrr.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Aug 2018 05:42:54 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 23/24] tools/lib/traceevent: Rename various pevent APIs
Date: Wed,  1 Aug 2018 15:41:55 +0300
Message-Id: <20180801124156.20894-24-tz.stoyanov@gmail.com>
In-Reply-To: <20180801124156.20894-1-tz.stoyanov@gmail.com>
References: <20180801124156.20894-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_reset_function_resolver, pevent_strerror, pevent_list_events,
pevent_event_common_fields, pevent_event_fields, pevent_ref, pevent_unref

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.c  | 20 ++++++++++----------
 tools/lib/traceevent/event-parse.h  | 14 +++++++-------
 tools/lib/traceevent/parse-filter.c |  6 +++---
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 36d9dbec0b01..58529f6e02b2 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -471,13 +471,13 @@ int tep_set_function_resolver(struct tep_handle *pevent,
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
@@ -5630,7 +5630,7 @@ static int events_system_cmp(const void *a, const void *b)
 	return events_id_cmp(a, b);
 }
 
-struct event_format **pevent_list_events(struct tep_handle *pevent, enum event_sort_type sort_type)
+struct event_format **tep_list_events(struct tep_handle *pevent, enum event_sort_type sort_type)
 {
 	struct event_format **events;
 	int (*sort)(const void *a, const void *b);
@@ -5709,13 +5709,13 @@ get_event_fields(const char *type, const char *name,
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
@@ -5723,13 +5723,13 @@ struct format_field **pevent_event_common_fields(struct event_format *event)
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
@@ -6221,7 +6221,7 @@ static const char * const pevent_error_str[] = {
 };
 #undef _PE
 
-int pevent_strerror(struct tep_handle *pevent __maybe_unused,
+int tep_strerror(struct tep_handle *pevent __maybe_unused,
 		    enum tep_errno errnum, char *buf, size_t buflen)
 {
 	int idx;
@@ -6766,7 +6766,7 @@ struct tep_handle *tep_alloc(void)
 	return pevent;
 }
 
-void pevent_ref(struct tep_handle *pevent)
+void tep_ref(struct tep_handle *pevent)
 {
 	pevent->ref_count++;
 }
@@ -6899,7 +6899,7 @@ void tep_free(struct tep_handle *pevent)
 	free(pevent);
 }
 
-void pevent_unref(struct tep_handle *pevent)
+void tep_unref(struct tep_handle *pevent)
 {
 	tep_free(pevent);
 }
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 11b5608d2071..5959fc6bc7fd 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -617,7 +617,7 @@ enum trace_flag_type {
 
 int tep_set_function_resolver(struct tep_handle *pevent,
 				 tep_func_resolver_t *func, void *priv);
-void pevent_reset_function_resolver(struct tep_handle *pevent);
+void tep_reset_function_resolver(struct tep_handle *pevent);
 int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid);
 int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
 int tep_register_function(struct tep_handle *pevent, char *name,
@@ -724,12 +724,12 @@ void tep_print_fields(struct trace_seq *s, void *data,
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
@@ -793,8 +793,8 @@ static inline void tep_set_latency_format(struct tep_handle *pevent, int lat)
 
 struct tep_handle *tep_alloc(void);
 void tep_free(struct tep_handle *pevent);
-void pevent_ref(struct tep_handle *pevent);
-void pevent_unref(struct tep_handle *pevent);
+void tep_ref(struct tep_handle *pevent);
+void tep_unref(struct tep_handle *pevent);
 
 /* access to the internal parser */
 void tep_buffer_init(const char *buf, unsigned long long size);
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index e698fe503c92..f65ff63448eb 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -189,7 +189,7 @@ struct event_filter *tep_filter_alloc(struct tep_handle *pevent)
 
 	memset(filter, 0, sizeof(*filter));
 	filter->pevent = pevent;
-	pevent_ref(pevent);
+	tep_ref(pevent);
 
 	return filter;
 }
@@ -1393,7 +1393,7 @@ int tep_filter_strerror(struct event_filter *filter, enum tep_errno err,
 		return 0;
 	}
 
-	return pevent_strerror(filter->pevent, err, buf, buflen);
+	return tep_strerror(filter->pevent, err, buf, buflen);
 }
 
 /**
@@ -1456,7 +1456,7 @@ void tep_filter_reset(struct event_filter *filter)
 
 void tep_filter_free(struct event_filter *filter)
 {
-	pevent_unref(filter->pevent);
+	tep_unref(filter->pevent);
 
 	tep_filter_reset(filter);
 
-- 
2.17.1
