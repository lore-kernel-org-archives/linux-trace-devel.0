Return-Path: <SRS0=/uS6=LK=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37648 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbeH0MDo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Aug 2018 08:03:44 -0400
Received: by mail-wm0-f67.google.com with SMTP id n11-v6so7408349wmc.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Aug 2018 01:18:07 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 04/24] tools lib traceevent, perf tools: Rename pevent alloc / free APIs
Date: Mon, 27 Aug 2018 11:17:39 +0300
Message-Id: <20180827081759.17297-5-tz.stoyanov@gmail.com>
In-Reply-To: <20180827081759.17297-1-tz.stoyanov@gmail.com>
References: <20180827081759.17297-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_alloc, pevent_free, pevent_event_info and pevent_func_resolver_t

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180808180700.152609945@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/traceevent/event-parse.h | 12 ++++++------
 kernel-shark-qt/src/libkshark.c  |  2 +-
 kernel-shark/trace-capture.c     |  2 +-
 kernel-shark/trace-plot-cpu.c    |  2 +-
 kernel-shark/trace-plot-task.c   |  2 +-
 kernel-shark/trace-view-store.c  |  2 +-
 lib/trace-cmd/trace-input.c      |  4 ++--
 lib/trace-cmd/trace-util.c       |  4 ++--
 lib/traceevent/event-parse.c     | 24 ++++++++++++------------
 tracecmd/trace-check-events.c    |  4 ++--
 tracecmd/trace-list.c            |  8 ++++----
 tracecmd/trace-record.c          |  4 ++--
 12 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index ada1efa..a4a2bc9 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -440,8 +440,8 @@ struct func_list;
 struct event_handler;
 struct func_resolver;
 
-typedef char *(pevent_func_resolver_t)(void *priv,
-				       unsigned long long *addrp, char **modp);
+typedef char *(tep_func_resolver_t)(void *priv,
+				    unsigned long long *addrp, char **modp);
 
 struct tep_handle {
 	int ref_count;
@@ -604,7 +604,7 @@ enum trace_flag_type {
 };
 
 int pevent_set_function_resolver(struct tep_handle *pevent,
-				 pevent_func_resolver_t *func, void *priv);
+				 tep_func_resolver_t *func, void *priv);
 void pevent_reset_function_resolver(struct tep_handle *pevent);
 int pevent_register_comm(struct tep_handle *pevent, const char *comm, int pid);
 int pevent_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
@@ -710,7 +710,7 @@ void pevent_print_field(struct trace_seq *s, void *data,
 			struct format_field *field);
 void pevent_print_fields(struct trace_seq *s, void *data,
 			 int size __maybe_unused, struct event_format *event);
-void pevent_event_info(struct trace_seq *s, struct event_format *event,
+void tep_event_info(struct trace_seq *s, struct event_format *event,
 		       struct tep_record *record);
 int pevent_strerror(struct tep_handle *pevent, enum pevent_errno errnum,
 		    char *buf, size_t buflen);
@@ -779,8 +779,8 @@ static inline void pevent_set_latency_format(struct tep_handle *pevent, int lat)
 	pevent->latency_format = lat;
 }
 
-struct tep_handle *pevent_alloc(void);
-void pevent_free(struct tep_handle *pevent);
+struct tep_handle *tep_alloc(void);
+void tep_free(struct tep_handle *pevent);
 void pevent_ref(struct tep_handle *pevent);
 void pevent_unref(struct tep_handle *pevent);
 
diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 230ba77..bb23afe 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -855,7 +855,7 @@ static const char *kshark_get_info(struct tep_handle *pe,
 		return NULL;
 
 	trace_seq_reset(&seq);
-	pevent_event_info(&seq, event, record);
+	tep_event_info(&seq, event, record);
 
 	/*
 	 * The event info string contains a trailing newline.
diff --git a/kernel-shark/trace-capture.c b/kernel-shark/trace-capture.c
index 19df28a..d80a5c2 100644
--- a/kernel-shark/trace-capture.c
+++ b/kernel-shark/trace-capture.c
@@ -1561,7 +1561,7 @@ static void tracing_dialog(struct shark_info *info, const char *tracing)
 	gtk_widget_destroy(dialog);
 
 	if (pevent)
-		pevent_free(pevent);
+		tep_free(pevent);
 
 	if (plugins)
 		tracecmd_free_list(plugins);
diff --git a/kernel-shark/trace-plot-cpu.c b/kernel-shark/trace-plot-cpu.c
index dc161a4..39b96f7 100644
--- a/kernel-shark/trace-plot-cpu.c
+++ b/kernel-shark/trace-plot-cpu.c
@@ -406,7 +406,7 @@ int cpu_plot_display_info(struct graph_info *ginfo,
 			trace_seq_putc(s, '\n');
 			pevent_data_lat_fmt(pevent, s, record);
 			trace_seq_putc(s, '\n');
-			pevent_event_info(s, event, record);
+			tep_event_info(s, event, record);
 			trace_seq_putc(s, '\n');
 		} else
 			trace_seq_printf(s, "UNKNOW EVENT %d\n", type);
diff --git a/kernel-shark/trace-plot-task.c b/kernel-shark/trace-plot-task.c
index 4dedd8a..11930ed 100644
--- a/kernel-shark/trace-plot-task.c
+++ b/kernel-shark/trace-plot-task.c
@@ -766,7 +766,7 @@ int task_plot_display_info(struct graph_info *ginfo,
 			trace_seq_putc(s, '\n');
 			pevent_data_lat_fmt(pevent, s, record);
 			trace_seq_putc(s, '\n');
-			pevent_event_info(s, event, record);
+			tep_event_info(s, event, record);
 			trace_seq_putc(s, '\n');
 		} else
 			trace_seq_printf(s, "UNKNOW EVENT %d\n", type);
diff --git a/kernel-shark/trace-view-store.c b/kernel-shark/trace-view-store.c
index 2e2a125..3f0bbf1 100644
--- a/kernel-shark/trace-view-store.c
+++ b/kernel-shark/trace-view-store.c
@@ -499,7 +499,7 @@ trace_view_store_get_value (GtkTreeModel *tree_model,
 			}
 
 			trace_seq_init(&s);
-			pevent_event_info(&s, event, data);
+			tep_event_info(&s, event, data);
 			g_value_set_string(value, s.buffer);
 			trace_seq_destroy(&s);
 			break;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 7354bbf..ad6fc90 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2635,7 +2635,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
 	if (do_read_check(handle, buf, 1))
 		goto failed_read;
 
-	handle->pevent = pevent_alloc();
+	handle->pevent = tep_alloc();
 	if (!handle->pevent)
 		goto failed_read;
 
@@ -2804,7 +2804,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 	else {
 		/* Only main handle frees plugins and pevent */
 		tracecmd_unload_plugins(handle->plugin_list, handle->pevent);
-		pevent_free(handle->pevent);
+		tep_free(handle->pevent);
 	}
 	free(handle);
 }
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 4a66457..2058dc3 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -1130,12 +1130,12 @@ struct tep_handle *tracecmd_local_events(const char *tracing_dir)
 {
 	struct tep_handle *pevent = NULL;
 
-	pevent = pevent_alloc();
+	pevent = tep_alloc();
 	if (!pevent)
 		return NULL;
 
 	if (tracecmd_fill_local_events(tracing_dir, pevent)) {
-		pevent_free(pevent);
+		tep_free(pevent);
 		pevent = NULL;
 	}
 
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index f00a02b..f67af97 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -424,9 +424,9 @@ __find_func(struct tep_handle *pevent, unsigned long long addr)
 }
 
 struct func_resolver {
-	pevent_func_resolver_t *func;
-	void		       *priv;
-	struct func_map	       map;
+	tep_func_resolver_t	*func;
+	void			*priv;
+	struct func_map		map;
 };
 
 /**
@@ -440,7 +440,7 @@ struct func_resolver {
  * pevent->funclist.
  */
 int pevent_set_function_resolver(struct tep_handle *pevent,
-				 pevent_func_resolver_t *func, void *priv)
+				 tep_func_resolver_t *func, void *priv)
 {
 	struct func_resolver *resolver = malloc(sizeof(*resolver));
 
@@ -5385,8 +5385,8 @@ int pevent_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline)
  * This parses the raw @data using the given @event information and
  * writes the print format into the trace_seq.
  */
-void pevent_event_info(struct trace_seq *s, struct event_format *event,
-		       struct tep_record *record)
+void tep_event_info(struct trace_seq *s, struct event_format *event,
+		    struct tep_record *record)
 {
 	int print_pretty = 1;
 
@@ -5542,7 +5542,7 @@ void pevent_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 	if (len < 20)
 		trace_seq_printf(s, "%.*s", 20 - len, spaces);
 
-	pevent_event_info(s, event, record);
+	tep_event_info(s, event, record);
 }
 
 void pevent_print_event(struct tep_handle *pevent, struct trace_seq *s,
@@ -6740,9 +6740,9 @@ not_found:
 }
 
 /**
- * pevent_alloc - create a pevent handle
+ * tep_alloc - create a pevent handle
  */
-struct tep_handle *pevent_alloc(void)
+struct tep_handle *tep_alloc(void)
 {
 	struct tep_handle *pevent = calloc(1, sizeof(*pevent));
 
@@ -6797,10 +6797,10 @@ void pevent_free_format(struct event_format *event)
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
@@ -6887,5 +6887,5 @@ void pevent_free(struct tep_handle *pevent)
 
 void pevent_unref(struct tep_handle *pevent)
 {
-	pevent_free(pevent);
+	tep_free(pevent);
 }
diff --git a/tracecmd/trace-check-events.c b/tracecmd/trace-check-events.c
index a8e7711..63c9918 100644
--- a/tracecmd/trace-check-events.c
+++ b/tracecmd/trace-check-events.c
@@ -38,7 +38,7 @@ void trace_check_events(int argc, char **argv)
 		exit(EINVAL);
 	}
 
-	pevent = pevent_alloc();
+	pevent = tep_alloc();
 	if (!pevent)
 		exit(EINVAL);
 	list = tracecmd_load_plugins(pevent);
@@ -46,7 +46,7 @@ void trace_check_events(int argc, char **argv)
 	if (ret || pevent->parsing_failures)
 		ret = EINVAL;
 	tracecmd_unload_plugins(list, pevent);
-	pevent_free(pevent);
+	tep_free(pevent);
 
 	return;
 }
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 1368dae..1eae38b 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -313,7 +313,7 @@ static void show_plugin_options(void)
 
 	tracecmd_ftrace_load_options();
 
-	pevent = pevent_alloc();
+	pevent = tep_alloc();
 	if (!pevent)
 		die("Can not allocate pevent\n");
 
@@ -323,7 +323,7 @@ static void show_plugin_options(void)
 	trace_util_print_plugin_options(&s);
 	trace_seq_do_printf(&s);
 	tracecmd_unload_plugins(list, pevent);
-	pevent_free(pevent);
+	tep_free(pevent);
 }
 
 
@@ -339,7 +339,7 @@ static void show_plugins(void)
 	struct plugin_list *list;
 	struct trace_seq s;
 
-	pevent = pevent_alloc();
+	pevent = tep_alloc();
 	if (!pevent)
 		die("Can not allocate pevent\n");
 
@@ -349,7 +349,7 @@ static void show_plugins(void)
 	trace_util_print_plugins(&s, "  ", "\n", list);
 	trace_seq_do_printf(&s);
 	tracecmd_unload_plugins(list, pevent);
-	pevent_free(pevent);
+	tep_free(pevent);
 }
 
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 45e5feb..8fb923e 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3497,7 +3497,7 @@ static char *get_date_to_ts(void)
 	int i;
 
 	/* Set up a pevent to read the raw format */
-	pevent = pevent_alloc();
+	pevent = tep_alloc();
 	if (!pevent) {
 		warning("failed to alloc pevent, --date ignored");
 		return NULL;
@@ -3578,7 +3578,7 @@ static char *get_date_to_ts(void)
 	snprintf(date2ts, 19, "0x%llx", min_stamp - min_ts / 1000);
 
  out_pevent:
-	pevent_free(pevent);
+	tep_free(pevent);
 
 	return date2ts;
 }
-- 
2.17.1
