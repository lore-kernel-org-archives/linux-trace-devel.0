Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:53211 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389216AbeHAO2F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 10:28:05 -0400
Received: by mail-wm0-f66.google.com with SMTP id o11-v6so6784613wmh.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Aug 2018 05:42:28 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 04/24] tools/lib/traceevent, tools/perf: Rename pevent alloc / free APIs
Date: Wed,  1 Aug 2018 15:41:36 +0300
Message-Id: <20180801124156.20894-5-tz.stoyanov@gmail.com>
In-Reply-To: <20180801124156.20894-1-tz.stoyanov@gmail.com>
References: <20180801124156.20894-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_alloc, pevent_free, pevent_event_info and pevent_func_resolver_t

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.c  | 18 +++++++++---------
 tools/lib/traceevent/event-parse.h  | 10 +++++-----
 tools/perf/builtin-kmem.c           |  2 +-
 tools/perf/util/sort.c              |  2 +-
 tools/perf/util/trace-event-parse.c |  2 +-
 tools/perf/util/trace-event.c       |  6 +++---
 tools/perf/util/trace-event.h       |  2 +-
 7 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 5f8019773673..6bf08ad6d35c 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -438,7 +438,7 @@ __find_func(struct tep_handle *pevent, unsigned long long addr)
 }
 
 struct func_resolver {
-	pevent_func_resolver_t *func;
+	tep_func_resolver_t *func;
 	void		       *priv;
 	struct func_map	       map;
 };
@@ -454,7 +454,7 @@ struct func_resolver {
  * pevent->funclist.
  */
 int pevent_set_function_resolver(struct tep_handle *pevent,
-				 pevent_func_resolver_t *func, void *priv)
+				 tep_func_resolver_t *func, void *priv)
 {
 	struct func_resolver *resolver = malloc(sizeof(*resolver));
 
@@ -5399,7 +5399,7 @@ int pevent_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline)
  * This parses the raw @data using the given @event information and
  * writes the print format into the trace_seq.
  */
-void pevent_event_info(struct trace_seq *s, struct event_format *event,
+void tep_event_info(struct trace_seq *s, struct event_format *event,
 		       struct tep_record *record)
 {
 	int print_pretty = 1;
@@ -5556,7 +5556,7 @@ void pevent_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 	if (len < 20)
 		trace_seq_printf(s, "%.*s", 20 - len, spaces);
 
-	pevent_event_info(s, event, record);
+	tep_event_info(s, event, record);
 }
 
 void pevent_print_event(struct tep_handle *pevent, struct trace_seq *s,
@@ -6754,9 +6754,9 @@ int pevent_unregister_event_handler(struct tep_handle *pevent, int id,
 }
 
 /**
- * pevent_alloc - create a pevent handle
+ * tep_alloc - create a pevent handle
  */
-struct tep_handle *pevent_alloc(void)
+struct tep_handle *tep_alloc(void)
 {
 	struct tep_handle *pevent = calloc(1, sizeof(*pevent));
 
@@ -6811,10 +6811,10 @@ void pevent_free_format(struct event_format *event)
 }
 
 /**
- * pevent_free - free a pevent handle
+ * tep_free - free a pevent handle
  * @pevent: the pevent handle to free
  */
-void pevent_free(struct tep_handle *pevent)
+void tep_free(struct tep_handle *pevent)
 {
 	struct cmdline_list *cmdlist, *cmdnext;
 	struct func_list *funclist, *funcnext;
@@ -6901,5 +6901,5 @@ void pevent_free(struct tep_handle *pevent)
 
 void pevent_unref(struct tep_handle *pevent)
 {
-	pevent_free(pevent);
+	tep_free(pevent);
 }
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index e6d7e899629c..de01c450921f 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -454,7 +454,7 @@ struct func_list;
 struct event_handler;
 struct func_resolver;
 
-typedef char *(pevent_func_resolver_t)(void *priv,
+typedef char *(tep_func_resolver_t)(void *priv,
 				       unsigned long long *addrp, char **modp);
 
 struct tep_handle {
@@ -616,7 +616,7 @@ enum trace_flag_type {
 };
 
 int pevent_set_function_resolver(struct tep_handle *pevent,
-				 pevent_func_resolver_t *func, void *priv);
+				 tep_func_resolver_t *func, void *priv);
 void pevent_reset_function_resolver(struct tep_handle *pevent);
 int pevent_register_comm(struct tep_handle *pevent, const char *comm, int pid);
 int pevent_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
@@ -722,7 +722,7 @@ void pevent_print_field(struct trace_seq *s, void *data,
 			struct format_field *field);
 void pevent_print_fields(struct trace_seq *s, void *data,
 			 int size __maybe_unused, struct event_format *event);
-void pevent_event_info(struct trace_seq *s, struct event_format *event,
+void tep_event_info(struct trace_seq *s, struct event_format *event,
 		       struct tep_record *record);
 int pevent_strerror(struct tep_handle *pevent, enum pevent_errno errnum,
 		    char *buf, size_t buflen);
@@ -791,8 +791,8 @@ static inline void pevent_set_latency_format(struct tep_handle *pevent, int lat)
 	pevent->latency_format = lat;
 }
 
-struct tep_handle *pevent_alloc(void);
-void pevent_free(struct tep_handle *pevent);
+struct tep_handle *tep_alloc(void);
+void tep_free(struct tep_handle *pevent);
 void pevent_ref(struct tep_handle *pevent);
 void pevent_unref(struct tep_handle *pevent);
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index b23e861fa6ae..73c073ade71c 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -747,7 +747,7 @@ static int parse_gfp_flags(struct perf_evsel *evsel, struct perf_sample *sample,
 	}
 
 	trace_seq_init(&seq);
-	pevent_event_info(&seq, evsel->tp_format, &record);
+	tep_event_info(&seq, evsel->tp_format, &record);
 
 	str = strtok_r(seq.buffer, " ", &pos);
 	while (str) {
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 2c9924ab872d..08cdaf2be1af 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -613,7 +613,7 @@ static char *get_trace_output(struct hist_entry *he)
 		pevent_print_fields(&seq, he->raw_data, he->raw_size,
 				    evsel->tp_format);
 	} else {
-		pevent_event_info(&seq, evsel->tp_format, &rec);
+		tep_event_info(&seq, evsel->tp_format, &rec);
 	}
 	/*
 	 * Trim the buffer, it starts at 4KB and we're not going to
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 29af1fb0b888..630d0e81fe87 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -125,7 +125,7 @@ void event_format__fprintf(struct event_format *event,
 	record.data = data;
 
 	trace_seq_init(&s);
-	pevent_event_info(&s, event, &record);
+	tep_event_info(&s, event, &record);
 	trace_seq_do_fprintf(&s, fp);
 	trace_seq_destroy(&s);
 }
diff --git a/tools/perf/util/trace-event.c b/tools/perf/util/trace-event.c
index 7c0cd9a0f575..11066ed43ca4 100644
--- a/tools/perf/util/trace-event.c
+++ b/tools/perf/util/trace-event.c
@@ -28,7 +28,7 @@ static bool tevent_initialized;
 
 int trace_event__init(struct trace_event *t)
 {
-	struct tep_handle *pevent = pevent_alloc();
+	struct tep_handle *pevent = tep_alloc();
 
 	if (pevent) {
 		t->plugin_list = traceevent_load_plugins(pevent);
@@ -55,7 +55,7 @@ static int trace_event__init2(void)
 }
 
 int trace_event__register_resolver(struct machine *machine,
-				   pevent_func_resolver_t *func)
+				   tep_func_resolver_t *func)
 {
 	if (!tevent_initialized && trace_event__init2())
 		return -1;
@@ -66,7 +66,7 @@ int trace_event__register_resolver(struct machine *machine,
 void trace_event__cleanup(struct trace_event *t)
 {
 	traceevent_unload_plugins(t->plugin_list, t->pevent);
-	pevent_free(t->pevent);
+	tep_free(t->pevent);
 }
 
 /*
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 1af1329cf4a2..f109e77f3d7e 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -20,7 +20,7 @@ struct trace_event {
 int trace_event__init(struct trace_event *t);
 void trace_event__cleanup(struct trace_event *t);
 int trace_event__register_resolver(struct machine *machine,
-				   pevent_func_resolver_t *func);
+				   tep_func_resolver_t *func);
 struct event_format*
 trace_event__tp_format(const char *sys, const char *name);
 
-- 
2.17.1
