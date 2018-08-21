Return-Path: <SRS0=yn/p=LE=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:39711 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbeHUQxt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Aug 2018 12:53:49 -0400
Received: by mail-wm0-f54.google.com with SMTP id q8-v6so2877105wmq.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Aug 2018 06:33:35 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/24] tools lib traceevent, perf tools: Rename 'struct pevent_record' to 'struct tep_record'
Date: Tue, 21 Aug 2018 16:33:06 +0300
Message-Id: <20180821133328.3249-3-tz.stoyanov@gmail.com>
In-Reply-To: <20180821133328.3249-1-tz.stoyanov@gmail.com>
References: <20180821133328.3249-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
the 'struct pevent_record' to 'struct tep_record'.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180808180659.866021298@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/trace-cmd/trace-cmd.h      | 48 ++++++++--------
 include/traceevent/event-parse.h   | 44 +++++++--------
 kernel-shark-qt/src/libkshark.c    | 28 +++++-----
 kernel-shark-qt/src/libkshark.h    |  4 +-
 kernel-shark/include/trace-graph.h | 18 +++---
 kernel-shark/include/trace-gui.h   |  4 +-
 kernel-shark/kernel-shark.c        |  4 +-
 kernel-shark/trace-dialog.c        |  4 +-
 kernel-shark/trace-graph.c         | 16 +++---
 kernel-shark/trace-plot-cpu.c      | 30 +++++-----
 kernel-shark/trace-plot-task.c     | 60 ++++++++++----------
 kernel-shark/trace-plot.c          |  4 +-
 kernel-shark/trace-view-main.c     |  2 +-
 kernel-shark/trace-view-store.c    | 14 ++---
 lib/trace-cmd/trace-ftrace.c       | 20 +++----
 lib/trace-cmd/trace-input.c        | 88 +++++++++++++++---------------
 lib/traceevent/event-parse.c       | 36 ++++++------
 lib/traceevent/parse-filter.c      | 24 ++++----
 plugins/plugin_blk.c               |  2 +-
 plugins/plugin_function.c          |  2 +-
 plugins/plugin_futex.c             |  2 +-
 plugins/plugin_hrtimer.c           |  4 +-
 plugins/plugin_kmem.c              |  2 +-
 plugins/plugin_kvm.c               | 14 ++---
 plugins/plugin_mac80211.c          |  4 +-
 plugins/plugin_sched_switch.c      |  6 +-
 plugins/plugin_tlb.c               |  2 +-
 python/ctracecmd.i                 | 12 ++--
 tracecmd/include/trace-local.h     |  4 +-
 tracecmd/trace-hist.c              | 20 +++----
 tracecmd/trace-mem.c               |  8 +--
 tracecmd/trace-profile.c           | 36 ++++++------
 tracecmd/trace-read.c              | 34 ++++++------
 tracecmd/trace-record.c            |  4 +-
 tracecmd/trace-split.c             | 12 ++--
 tracecmd/trace-stream.c            |  2 +-
 36 files changed, 309 insertions(+), 309 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 2560bc4..ade21b1 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -45,8 +45,8 @@ enum {
 	RINGBUF_TYPE_TIME_STAMP		= 31,
 };
 
-void tracecmd_record_ref(struct pevent_record *record);
-void free_record(struct pevent_record *record);
+void tracecmd_record_ref(struct tep_record *record);
+void free_record(struct tep_record *record);
 
 struct tracecmd_input;
 struct tracecmd_output;
@@ -96,7 +96,7 @@ struct tracecmd_ftrace {
 };
 
 typedef void (*tracecmd_show_data_func)(struct tracecmd_input *handle,
-					struct pevent_record *record);
+					struct tep_record *record);
 typedef void (*tracecmd_handle_init_func)(struct tracecmd_input *handle,
 					  struct hook_list *hook, int global);
 
@@ -136,45 +136,45 @@ int tracecmd_init_data(struct tracecmd_input *handle);
 void tracecmd_print_stats(struct tracecmd_input *handle);
 void tracecmd_print_uname(struct tracecmd_input *handle);
 
-struct pevent_record *
+struct tep_record *
 tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
-			  struct pevent_record *last_record);
-struct pevent_record *
+			  struct tep_record *last_record);
+struct tep_record *
 tracecmd_peek_data(struct tracecmd_input *handle, int cpu);
 
-static inline struct pevent_record *
+static inline struct tep_record *
 tracecmd_peek_data_ref(struct tracecmd_input *handle, int cpu)
 {
-	struct pevent_record *rec = tracecmd_peek_data(handle, cpu);
+	struct tep_record *rec = tracecmd_peek_data(handle, cpu);
 	if (rec)
 		rec->ref_count++;
 	return rec;
 }
 
-struct pevent_record *
+struct tep_record *
 tracecmd_read_data(struct tracecmd_input *handle, int cpu);
 
-struct pevent_record *
-tracecmd_read_prev(struct tracecmd_input *handle, struct pevent_record *record);
+struct tep_record *
+tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record);
 
-struct pevent_record *
+struct tep_record *
 tracecmd_read_next_data(struct tracecmd_input *handle, int *rec_cpu);
 
-struct pevent_record *
+struct tep_record *
 tracecmd_peek_next_data(struct tracecmd_input *handle, int *rec_cpu);
 
-struct pevent_record *
+struct tep_record *
 tracecmd_read_at(struct tracecmd_input *handle, unsigned long long offset,
 		 int *cpu);
-struct pevent_record *
+struct tep_record *
 tracecmd_translate_data(struct tracecmd_input *handle,
 			void *ptr, int size);
-struct pevent_record *
+struct tep_record *
 tracecmd_read_cpu_first(struct tracecmd_input *handle, int cpu);
-struct pevent_record *
+struct tep_record *
 tracecmd_read_cpu_last(struct tracecmd_input *handle, int cpu);
 int tracecmd_refresh_record(struct tracecmd_input *handle,
-			    struct pevent_record *record);
+			    struct tep_record *record);
 
 int tracecmd_set_cpu_to_timestamp(struct tracecmd_input *handle,
 				  int cpu, unsigned long long ts);
@@ -198,11 +198,11 @@ void tracecmd_set_show_data_func(struct tracecmd_input *handle,
 char *tracecmd_get_tracing_file(const char *name);
 void tracecmd_put_tracing_file(char *name);
 
-int tracecmd_record_at_buffer_start(struct tracecmd_input *handle, struct pevent_record *record);
+int tracecmd_record_at_buffer_start(struct tracecmd_input *handle, struct tep_record *record);
 unsigned long long tracecmd_page_ts(struct tracecmd_input *handle,
-				    struct pevent_record *record);
+				    struct tep_record *record);
 unsigned int tracecmd_record_ts_delta(struct tracecmd_input *handle,
-				      struct pevent_record *record);
+				      struct tep_record *record);
 
 #ifndef SWIG
 /* hack for function graph work around */
@@ -385,10 +385,10 @@ int tracecmd_stack_tracer_status(int *status);
 
 /* --- Debugging --- */
 struct kbuffer *tracecmd_record_kbuf(struct tracecmd_input *handle,
-				     struct pevent_record *record);
+				     struct tep_record *record);
 void *tracecmd_record_page(struct tracecmd_input *handle,
-			   struct pevent_record *record);
+			   struct tep_record *record);
 void *tracecmd_record_offset(struct tracecmd_input *handle,
-			     struct pevent_record *record);
+			     struct tep_record *record);
 
 #endif /* _TRACE_CMD_H */
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 4c6c43d..3b99120 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -27,7 +27,7 @@
 #define DEBUG_RECORD 0
 #endif
 
-struct pevent_record {
+struct tep_record {
 	unsigned long long	ts;
 	unsigned long long	offset;
 	long long		missed_events;	/* buffer dropped events before */
@@ -39,8 +39,8 @@ struct pevent_record {
 	int			locked;		/* Do not free, even if ref_count is zero */
 	void			*priv;
 #if DEBUG_RECORD
-	struct pevent_record	*prev;
-	struct pevent_record	*next;
+	struct tep_record	*prev;
+	struct tep_record	*next;
 	long			alloc_addr;
 #endif
 };
@@ -88,7 +88,7 @@ struct tep_handle;
 struct event_format;
 
 typedef int (*pevent_event_handler_func)(struct trace_seq *s,
-					 struct pevent_record *record,
+					 struct tep_record *record,
 					 struct event_format *event,
 					 void *context);
 
@@ -616,16 +616,16 @@ int pevent_pid_is_registered(struct tep_handle *pevent, int pid);
 
 void pevent_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
 			     struct event_format *event,
-			     struct pevent_record *record);
+			     struct tep_record *record);
 void pevent_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 			     struct event_format *event,
-			     struct pevent_record *record,
+			     struct tep_record *record,
 			     bool use_trace_clock);
 void pevent_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 			     struct event_format *event,
-			     struct pevent_record *record);
+			     struct tep_record *record);
 void pevent_print_event(struct tep_handle *pevent, struct trace_seq *s,
-			struct pevent_record *record, bool use_trace_clock);
+			struct tep_record *record, bool use_trace_clock);
 
 int pevent_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
 			     int long_size);
@@ -640,26 +640,26 @@ void pevent_free_format(struct event_format *event);
 void pevent_free_format_field(struct format_field *field);
 
 void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
-			   const char *name, struct pevent_record *record,
+			   const char *name, struct tep_record *record,
 			   int *len, int err);
 
 int pevent_get_field_val(struct trace_seq *s, struct event_format *event,
-			 const char *name, struct pevent_record *record,
+			 const char *name, struct tep_record *record,
 			 unsigned long long *val, int err);
 int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
-				const char *name, struct pevent_record *record,
+				const char *name, struct tep_record *record,
 				unsigned long long *val, int err);
 int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
-			     const char *name, struct pevent_record *record,
+			     const char *name, struct tep_record *record,
 			     unsigned long long *val, int err);
 
 int pevent_print_num_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
-			   struct pevent_record *record, int err);
+			   struct tep_record *record, int err);
 
 int pevent_print_func_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
-			   struct pevent_record *record, int err);
+			   struct tep_record *record, int err);
 
 int pevent_register_event_handler(struct tep_handle *pevent, int id,
 				  const char *sys_name, const char *event_name,
@@ -691,15 +691,15 @@ struct event_format *
 pevent_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *name);
 
 struct event_format *
-pevent_find_event_by_record(struct tep_handle *pevent, struct pevent_record *record);
+pevent_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
 
 void pevent_data_lat_fmt(struct tep_handle *pevent,
-			 struct trace_seq *s, struct pevent_record *record);
-int pevent_data_type(struct tep_handle *pevent, struct pevent_record *rec);
+			 struct trace_seq *s, struct tep_record *record);
+int pevent_data_type(struct tep_handle *pevent, struct tep_record *rec);
 struct event_format *pevent_data_event_from_type(struct tep_handle *pevent, int type);
-int pevent_data_pid(struct tep_handle *pevent, struct pevent_record *rec);
-int pevent_data_preempt_count(struct tep_handle *pevent, struct pevent_record *rec);
-int pevent_data_flags(struct tep_handle *pevent, struct pevent_record *rec);
+int pevent_data_pid(struct tep_handle *pevent, struct tep_record *rec);
+int pevent_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec);
+int pevent_data_flags(struct tep_handle *pevent, struct tep_record *rec);
 const char *pevent_data_comm_from_pid(struct tep_handle *pevent, int pid);
 struct cmdline;
 struct cmdline *pevent_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
@@ -711,7 +711,7 @@ void pevent_print_field(struct trace_seq *s, void *data,
 void pevent_print_fields(struct trace_seq *s, void *data,
 			 int size __maybe_unused, struct event_format *event);
 void pevent_event_info(struct trace_seq *s, struct event_format *event,
-		       struct pevent_record *record);
+		       struct tep_record *record);
 int pevent_strerror(struct tep_handle *pevent, enum pevent_errno errnum,
 		    char *buf, size_t buflen);
 
@@ -945,7 +945,7 @@ enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
 					       const char *filter_str);
 
 enum pevent_errno pevent_filter_match(struct event_filter *filter,
-				      struct pevent_record *record);
+				      struct tep_record *record);
 
 int pevent_filter_strerror(struct event_filter *filter, enum pevent_errno err,
 			   char *buf, size_t buflen);
diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index cf80c1b..230ba77 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -491,7 +491,7 @@ void kshark_filter_entries(struct kshark_context *kshark_ctx,
 }
 
 static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
-				    struct pevent_record *record,
+				    struct tep_record *record,
 				    struct kshark_entry *entry)
 {
 	/* Offset of the record */
@@ -528,7 +528,7 @@ struct rec_list {
 			/** next pointer, matches entry->next */
 			struct rec_list		*next;
 			/** pointer to the raw record data */
-			struct pevent_record	*rec;
+			struct tep_record	*rec;
 		};
 		/** entry - Used for kshark_load_data_entries() */
 		struct kshark_entry		entry;
@@ -566,7 +566,7 @@ static size_t get_records(struct kshark_context *kshark_ctx,
 {
 	struct event_filter *adv_filter;
 	struct kshark_task_list *task;
-	struct pevent_record *rec;
+	struct tep_record *rec;
 	struct rec_list **temp_next;
 	struct rec_list **cpu_list;
 	struct rec_list *temp_rec;
@@ -770,10 +770,10 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
  *	    negative error code on failure.
  */
 ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
-				struct pevent_record ***data_rows)
+				struct tep_record ***data_rows)
 {
-	struct pevent_record **rows;
-	struct pevent_record *rec;
+	struct tep_record **rows;
+	struct tep_record *rec;
 	struct rec_list **rec_list;
 	struct rec_list *temp_rec;
 	enum rec_type type = REC_RECORD;
@@ -784,7 +784,7 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 	if (total < 0)
 		goto fail;
 
-	rows = calloc(total, sizeof(struct pevent_record *));
+	rows = calloc(total, sizeof(struct tep_record *));
 	if (!rows)
 		goto fail;
 
@@ -816,8 +816,8 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 	return -ENOMEM;
 }
 
-static struct pevent_record *kshark_read_at(struct kshark_context *kshark_ctx,
-					    uint64_t offset)
+static struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
+					 uint64_t offset)
 {
 	/*
 	 * It turns that tracecmd_read_at() is not thread-safe.
@@ -826,7 +826,7 @@ static struct pevent_record *kshark_read_at(struct kshark_context *kshark_ctx,
 	 */
 	pthread_mutex_lock(&kshark_ctx->input_mutex);
 
-	struct pevent_record *data = tracecmd_read_at(kshark_ctx->handle,
+	struct tep_record *data = tracecmd_read_at(kshark_ctx->handle,
 						      offset, NULL);
 
 	pthread_mutex_unlock(&kshark_ctx->input_mutex);
@@ -835,7 +835,7 @@ static struct pevent_record *kshark_read_at(struct kshark_context *kshark_ctx,
 }
 
 static const char *kshark_get_latency(struct tep_handle *pe,
-				      struct pevent_record *record)
+				      struct tep_record *record)
 {
 	if (!record)
 		return NULL;
@@ -846,7 +846,7 @@ static const char *kshark_get_latency(struct tep_handle *pe,
 }
 
 static const char *kshark_get_info(struct tep_handle *pe,
-				   struct pevent_record *record,
+				   struct tep_record *record,
 				   struct event_format *event)
 {
 	char *pos;
@@ -881,7 +881,7 @@ char* kshark_dump_entry(const struct kshark_entry *entry)
 {
 	const char *event_name, *task, *lat, *info;
 	struct kshark_context *kshark_ctx;
-	struct pevent_record *data;
+	struct tep_record *data;
 	struct event_format *event;
 	char *temp_str, *entry_str;
 	int event_id, size = 0;
@@ -977,7 +977,7 @@ ssize_t kshark_find_entry_by_time(uint64_t time,
 	    the function returns BSEARCH_ALL_SMALLER (negative value).
  */
 ssize_t kshark_find_record_by_time(uint64_t time,
-				   struct pevent_record **data,
+				   struct tep_record **data,
 				   size_t l, size_t h)
 {
 	size_t mid;
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index 386cbf6..c4a2480 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -128,7 +128,7 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 				 struct kshark_entry ***data_rows);
 
 ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
-				 struct pevent_record ***data_rows);
+				 struct tep_record ***data_rows);
 
 ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids);
 
@@ -219,7 +219,7 @@ ssize_t kshark_find_entry_by_time(uint64_t time,
 				  size_t l, size_t h);
 
 ssize_t kshark_find_record_by_time(uint64_t time,
-				   struct pevent_record **data_rows,
+				   struct tep_record **data_rows,
 				   size_t l, size_t h);
 
 bool kshark_match_pid(struct kshark_context *kshark_ctx,
diff --git a/kernel-shark/include/trace-graph.h b/kernel-shark/include/trace-graph.h
index cc3d660..6686675 100644
--- a/kernel-shark/include/trace-graph.h
+++ b/kernel-shark/include/trace-graph.h
@@ -97,12 +97,12 @@ struct plot_callbacks {
 		      unsigned long long time);
 	int (*plot_event)(struct graph_info *ginfo,
 			  struct graph_plot *plot,
-			  struct pevent_record *record);
+			  struct tep_record *record);
 	void (*end)(struct graph_info *, struct graph_plot *);
 	int (*display_last_event)(struct graph_info *ginfo, struct graph_plot *plot,
 				  struct trace_seq *s, unsigned long long time);
-	struct pevent_record *(*find_record)(struct graph_info *, struct graph_plot *,
-				      unsigned long long time);
+	struct tep_record *(*find_record)(struct graph_info *, struct graph_plot *,
+					  unsigned long long time);
 	int (*display_info)(struct graph_info *, struct graph_plot *,
 			    struct trace_seq *s,
 			    unsigned long long time);
@@ -297,15 +297,15 @@ int trace_graph_load_handle(struct graph_info *ginfo,
 			    struct tracecmd_input *handle);
 
 int trace_graph_check_sched_switch(struct graph_info *ginfo,
-				   struct pevent_record *record,
+				   struct tep_record *record,
 				   gint *pid, const char **comm);
 int trace_graph_check_sched_wakeup(struct graph_info *ginfo,
-				   struct pevent_record *record,
+				   struct tep_record *record,
 				   gint *pid);
 enum graph_irq_type trace_graph_check_irq(struct graph_info *ginfo,
-		      struct pevent_record *record);
+		      struct tep_record *record);
 gboolean trace_graph_filter_on_task(struct graph_info *ginfo, gint pid);
-gboolean trace_graph_filter_on_event(struct graph_info *ginfo, struct pevent_record *record);
+gboolean trace_graph_filter_on_event(struct graph_info *ginfo, struct tep_record *record);
 
 void trace_graph_copy_filter(struct graph_info *ginfo,
 			     gboolean all_events,
@@ -368,12 +368,12 @@ void trace_graph_plot_start(struct graph_info *ginfo,
 
 int trace_graph_plot_event(struct graph_info *ginfo,
 			   struct graph_plot *plot,
-			   struct pevent_record *record);
+			   struct tep_record *record);
 
 void trace_graph_plot_end(struct graph_info *ginfo,
 			  struct graph_plot *plot);
 
-struct pevent_record *
+struct tep_record *
 trace_graph_plot_find_record(struct graph_info *ginfo,
 			     struct graph_plot *plot,
 			     unsigned long long time);
diff --git a/kernel-shark/include/trace-gui.h b/kernel-shark/include/trace-gui.h
index 720683e..e9bfbd6 100644
--- a/kernel-shark/include/trace-gui.h
+++ b/kernel-shark/include/trace-gui.h
@@ -49,9 +49,9 @@ trace_create_combo_box(GtkWidget *hbox, const gchar *text,
 		       gpointer data);
 
 struct tep_handle;
-struct pevent_record;
+struct tep_record;
 
 void trace_show_record_dialog(GtkWindow *parent, struct tep_handle *pevent,
-			      struct pevent_record *record, gboolean raw);
+			      struct tep_record *record, gboolean raw);
 
 #endif /* _TRACE_GUI */
diff --git a/kernel-shark/kernel-shark.c b/kernel-shark/kernel-shark.c
index 8893504..6b43296 100644
--- a/kernel-shark/kernel-shark.c
+++ b/kernel-shark/kernel-shark.c
@@ -1440,7 +1440,7 @@ static void
 handle_display_event_clicked (gpointer data, gboolean raw)
 {
 	struct shark_info *info = data;
-	struct pevent_record *record;
+	struct tep_record *record;
 	struct tep_handle *pevent;
 	TraceViewRecord *vrec;
 	GtkTreeModel *model;
@@ -1547,7 +1547,7 @@ do_tree_popup(GtkWidget *widget, GdkEventButton *event, gpointer data)
 	static GtkWidget *menu_filter_graph_clear_tasks;
 	static GtkWidget *menu_display_event;
 	static GtkWidget *menu_display_raw_event;
-	struct pevent_record *record;
+	struct tep_record *record;
 	TraceViewRecord *vrec;
 	GtkTreeModel *model;
 	const char *comm;
diff --git a/kernel-shark/trace-dialog.c b/kernel-shark/trace-dialog.c
index ec27550..c9f8eec 100644
--- a/kernel-shark/trace-dialog.c
+++ b/kernel-shark/trace-dialog.c
@@ -374,7 +374,7 @@ GtkResponseType trace_dialog(GtkWindow *parent, enum trace_dialog_type type,
 
 static void read_raw_events(struct trace_seq *s,
 			    struct event_format *event,
-			    struct pevent_record *record)
+			    struct tep_record *record)
 {
 	struct format_field **fields;
 	int i;
@@ -393,7 +393,7 @@ static void read_raw_events(struct trace_seq *s,
 }
 
 void trace_show_record_dialog(GtkWindow *parent, struct tep_handle *pevent,
-			      struct pevent_record *record, gboolean raw)
+			      struct tep_record *record, gboolean raw)
 {
 	struct event_format *event;
 	struct trace_seq s;
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index 92ac782..2c6d00b 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -269,7 +269,7 @@ static void graph_filter_task_clear(struct graph_info *ginfo)
 	ginfo->filter_enabled = 0;
 }
 
-gboolean trace_graph_filter_on_event(struct graph_info *ginfo, struct pevent_record *record)
+gboolean trace_graph_filter_on_event(struct graph_info *ginfo, struct tep_record *record)
 {
 	int ret;
 
@@ -653,7 +653,7 @@ do_pop_up(GtkWidget *widget, GdkEventButton *event, gpointer data)
 	static GtkWidget *menu_filter_clear_tasks;
 	static GtkWidget *menu_plot_task;
 	static GtkWidget *menu_remove_plot;
-	struct pevent_record *record = NULL;
+	struct tep_record *record = NULL;
 	struct graph_plot *plot;
 	const char *comm;
 	guint64 time;
@@ -1004,7 +1004,7 @@ info_button_release_event(GtkWidget *widget, GdkEventMotion *event, gpointer dat
 #define PLOT_BOARDER 5
 
 int trace_graph_check_sched_wakeup(struct graph_info *ginfo,
-				   struct pevent_record *record,
+				   struct tep_record *record,
 				   gint *pid)
 {
 	struct event_format *event;
@@ -1070,7 +1070,7 @@ int trace_graph_check_sched_wakeup(struct graph_info *ginfo,
 }
 
 int trace_graph_check_sched_switch(struct graph_info *ginfo,
-				   struct pevent_record *record,
+				   struct tep_record *record,
 				   gint *pid, const char **comm)
 {
 	unsigned long long val;
@@ -1151,7 +1151,7 @@ static void enter_id(gint **ids, gint id, gint *len)
 
 enum graph_irq_type
 trace_graph_check_irq(struct graph_info *ginfo,
-		      struct pevent_record *record)
+		      struct tep_record *record)
 {
 	struct event_format *event;
 	struct event_format **events;
@@ -1832,7 +1832,7 @@ static void draw_plot_box(struct graph_info *ginfo, int i,
 }
 
 static void draw_plot(struct graph_info *ginfo, struct graph_plot *plot,
-		      struct pevent_record *record)
+		      struct tep_record *record)
 {
 	static PangoFontDescription *font;
 	PangoLayout *layout;
@@ -1926,7 +1926,7 @@ static void draw_plots(struct graph_info *ginfo, gint new_width)
 	struct timeval tv_start, tv_stop;
 	struct plot_list *list;
 	struct graph_plot *plot;
-	struct pevent_record *record;
+	struct tep_record *record;
 	struct plot_hash *hash;
 	gint pid;
 	gint cpu;
@@ -2533,7 +2533,7 @@ void trace_graph_free_info(struct graph_info *ginfo)
 static int load_handle(struct graph_info *ginfo,
 		       struct tracecmd_input *handle)
 {
-	struct pevent_record *record;
+	struct tep_record *record;
 	unsigned long sec, usec;
 	gint cpu;
 
diff --git a/kernel-shark/trace-plot-cpu.c b/kernel-shark/trace-plot-cpu.c
index 2d184e7..dc161a4 100644
--- a/kernel-shark/trace-plot-cpu.c
+++ b/kernel-shark/trace-plot-cpu.c
@@ -15,7 +15,7 @@ struct cpu_plot_info {
 	int			cpu;
 	unsigned long long	last_time;
 	int			last_pid;
-	struct pevent_record	*last_record;
+	struct tep_record	*last_record;
 };
 
 static gint hash_pid(gint val)
@@ -34,10 +34,10 @@ static void convert_nano(unsigned long long time, unsigned long *sec,
 	*usec = (time / 1000) % 1000000;
 }
 
-static struct pevent_record *get_record_from_time(struct graph_info *ginfo, int cpu,
-					   unsigned long long time)
+static struct tep_record *get_record_from_time(struct graph_info *ginfo, int cpu,
+					       unsigned long long time)
 {
-	struct pevent_record *record;
+	struct tep_record *record;
 
 	tracecmd_set_cpu_to_timestamp(ginfo->handle, cpu, time);
 	record = tracecmd_read_data(ginfo->handle, cpu);
@@ -53,7 +53,7 @@ static int cpu_plot_match_time(struct graph_info *ginfo, struct graph_plot *plot
 			       unsigned long long time)
 {
 	struct cpu_plot_info *cpu_info = plot->private;
-	struct pevent_record *record;
+	struct tep_record *record;
 	int ret = 0;
 
 	record = get_record_from_time(ginfo, cpu_info->cpu, time);
@@ -74,7 +74,7 @@ static int cpu_plot_match_time(struct graph_info *ginfo, struct graph_plot *plot
  * @is_sched_switch returns 1 on context switch, otherwise 0
  */
 static int filter_record(struct graph_info *ginfo,
-			 struct pevent_record *record,
+			 struct tep_record *record,
 			 int *orig_pid, int *sched_pid,
 			 gboolean *sched_switch)
 {
@@ -118,7 +118,7 @@ static int cpu_plot_display_last_event(struct graph_info *ginfo,
 {
 	struct cpu_plot_info *cpu_info = plot->private;
 	struct event_format *event;
-	struct pevent_record *record;
+	struct tep_record *record;
 	int cpu = cpu_info->cpu;
 	unsigned long long offset = 0;
 	gboolean is_sched_switch;
@@ -192,10 +192,10 @@ static void cpu_plot_start(struct graph_info *ginfo, struct graph_plot *plot,
 
 static void update_last_record(struct graph_info *ginfo,
 			       struct cpu_plot_info *cpu_info,
-			       struct pevent_record *record)
+			       struct tep_record *record)
 {
 	struct tracecmd_input *handle = ginfo->handle;
-	struct pevent_record *trecord;
+	struct tep_record *trecord;
 	int sched_pid;
 	int orig_pid;
 	int is_sched_switch;
@@ -225,7 +225,7 @@ static void update_last_record(struct graph_info *ginfo,
 
 static int cpu_plot_event(struct graph_info *ginfo,
 			  struct graph_plot *plot,
-			  struct pevent_record *record)
+			  struct tep_record *record)
 {
 	struct cpu_plot_info *cpu_info = plot->private;
 	struct plot_info *info = &plot->info;
@@ -310,10 +310,10 @@ static int cpu_plot_event(struct graph_info *ginfo,
 	return ret;
 }
 
-static struct pevent_record *
+static struct tep_record *
 find_record_on_cpu(struct graph_info *ginfo, gint cpu, guint64 time)
 {
-	struct pevent_record *record = NULL;
+	struct tep_record *record = NULL;
 	guint64 offset = 0;
 
 	tracecmd_set_cpu_to_timestamp(ginfo->handle, cpu, time);
@@ -335,7 +335,7 @@ find_record_on_cpu(struct graph_info *ginfo, gint cpu, guint64 time)
 	return record;
 }
 
-static struct pevent_record *
+static struct tep_record *
 cpu_plot_find_record(struct graph_info *ginfo, struct graph_plot *plot,
 		     unsigned long long time)
 {
@@ -354,8 +354,8 @@ int cpu_plot_display_info(struct graph_info *ginfo,
 {
 	struct cpu_plot_info *cpu_info = plot->private;
 	struct event_format *event;
-	struct pevent_record *record;
-	struct pevent_record *next_record;
+	struct tep_record *record;
+	struct tep_record *next_record;
 	struct tep_handle *pevent;
 	unsigned long sec, usec;
 	const char *comm;
diff --git a/kernel-shark/trace-plot-task.c b/kernel-shark/trace-plot-task.c
index fa30ce6..4dedd8a 100644
--- a/kernel-shark/trace-plot-task.c
+++ b/kernel-shark/trace-plot-task.c
@@ -17,7 +17,7 @@
 struct task_plot_info {
 	int			pid;
 	struct cpu_data		*cpu_data;
-	struct pevent_record	**last_records;
+	struct tep_record	**last_records;
 	unsigned long long	last_time;
 	unsigned long long	wake_time;
 	unsigned long long	display_wake_time;
@@ -49,7 +49,7 @@ static int hash_cpu(int cpu)
 	return trace_hash(cpu);
 }
 
-static gboolean is_running(struct graph_info *ginfo, struct pevent_record *record)
+static gboolean is_running(struct graph_info *ginfo, struct tep_record *record)
 {
 	unsigned long long val;
 	int id;
@@ -63,7 +63,7 @@ static gboolean is_running(struct graph_info *ginfo, struct pevent_record *recor
 }
 
 static gboolean record_matches_pid(struct graph_info *ginfo,
-				   struct pevent_record *record, int match_pid,
+				   struct tep_record *record, int match_pid,
 				   int *pid, int *sched_pid,
 				   gboolean *is_sched,
 				   gboolean *wakeup)
@@ -98,7 +98,7 @@ static gboolean record_matches_pid(struct graph_info *ginfo,
 
 static void set_cpu_to_time(int cpu, struct graph_info *ginfo, unsigned long long time)
 {
-	struct pevent_record *record;
+	struct tep_record *record;
 
 	tracecmd_set_cpu_to_timestamp(ginfo->handle, cpu, time);
 
@@ -127,7 +127,7 @@ static int task_plot_match_time(struct graph_info *ginfo, struct graph_plot *plo
 			       unsigned long long time)
 {
 	struct task_plot_info *task_info = plot->private;
-	struct pevent_record *record = NULL;
+	struct tep_record *record = NULL;
 	gboolean is_wakeup;
 	gboolean is_sched;
 	gboolean match;
@@ -169,7 +169,7 @@ struct offset_cache {
 static struct offset_cache *save_offsets(struct graph_info *ginfo)
 {
 	struct offset_cache *offsets;
-	struct pevent_record *record;
+	struct tep_record *record;
 	int cpu;
 
 	offsets = malloc_or_die(sizeof(*offsets));
@@ -187,7 +187,7 @@ static struct offset_cache *save_offsets(struct graph_info *ginfo)
 
 static void restore_offsets(struct graph_info *ginfo, struct offset_cache *offsets)
 {
-	struct pevent_record *record;
+	struct tep_record *record;
 	int cpu;
 
 	for (cpu = 0; cpu < ginfo->cpus; cpu++) {
@@ -204,10 +204,10 @@ static void restore_offsets(struct graph_info *ginfo, struct offset_cache *offse
 	free(offsets);
 }
 
-static struct pevent_record *
+static struct tep_record *
 find_record(struct graph_info *ginfo, gint pid, guint64 time)
 {
-	struct pevent_record *record = NULL;
+	struct tep_record *record = NULL;
 	gboolean is_wakeup;
 	gboolean is_sched;
 	gboolean match;
@@ -241,7 +241,7 @@ static int task_plot_display_last_event(struct graph_info *ginfo,
 {
 	struct task_plot_info *task_info = plot->private;
 	struct event_format *event;
-	struct pevent_record *record;
+	struct tep_record *record;
 	struct offset_cache *offsets;
 	gboolean is_sched;
 	gboolean is_wakeup;
@@ -312,7 +312,7 @@ static void task_plot_start(struct graph_info *ginfo, struct graph_plot *plot,
 {
 	struct task_plot_info *task_info = plot->private;
 
-	memset(task_info->last_records, 0, sizeof(struct pevent_record *) * ginfo->cpus);
+	memset(task_info->last_records, 0, sizeof(struct tep_record *) * ginfo->cpus);
 
 	task_info->last_time = 0ULL;
 	task_info->last_cpu = -1;
@@ -322,7 +322,7 @@ static void task_plot_start(struct graph_info *ginfo, struct graph_plot *plot,
 }
 
 static gboolean record_is_interrupt(struct graph_info *ginfo,
-				    struct pevent_record *record,
+				    struct tep_record *record,
 				    gboolean check_type)
 {
 	gboolean in_irq;
@@ -353,11 +353,11 @@ static gboolean record_is_interrupt(struct graph_info *ginfo,
 
 static void update_last_record(struct graph_info *ginfo,
 			       struct task_plot_info *task_info,
-			       struct pevent_record *record)
+			       struct tep_record *record)
 {
 	struct tracecmd_input *handle = ginfo->handle;
-	struct pevent_record *trecord, *t2record;
-	struct pevent_record *saved;
+	struct tep_record *trecord, *t2record;
+	struct tep_record *saved;
 	unsigned long long ts;
 	int sched_pid;
 	int pid;
@@ -435,11 +435,11 @@ static void update_last_record(struct graph_info *ginfo,
 
 static int task_plot_event(struct graph_info *ginfo,
 			   struct graph_plot *plot,
-			   struct pevent_record *record)
+			   struct tep_record *record)
 {
 	struct task_plot_info *task_info = plot->private;
 	struct plot_info *info = &plot->info;
-	struct pevent_record *next_record;
+	struct tep_record *next_record;
 	gboolean match;
 	gboolean in_irq;
 	int sched_pid;
@@ -605,7 +605,7 @@ static int task_plot_event(struct graph_info *ginfo,
 }
 
 
-static struct pevent_record *
+static struct tep_record *
 task_plot_find_record(struct graph_info *ginfo, struct graph_plot *plot,
 		      unsigned long long time)
 {
@@ -619,12 +619,12 @@ task_plot_find_record(struct graph_info *ginfo, struct graph_plot *plot,
 
 #define MAX_SEARCH 20
 
-static struct pevent_record *
-find_previous_record(struct graph_info *ginfo, struct pevent_record *start_record,
+static struct tep_record *
+find_previous_record(struct graph_info *ginfo, struct tep_record *start_record,
 		     int pid, int cpu)
 {
-	struct pevent_record *last_record = start_record;
-	struct pevent_record *record;
+	struct tep_record *last_record = start_record;
+	struct tep_record *record;
 	gboolean match;
 	gboolean is_sched;
 	gboolean is_wakeup;
@@ -659,11 +659,11 @@ find_previous_record(struct graph_info *ginfo, struct pevent_record *start_recor
 	return record;
 }
 
-static struct pevent_record *
+static struct tep_record *
 get_display_record(struct graph_info *ginfo, int pid, unsigned long long time)
 {
-	struct pevent_record *record;
-	struct pevent_record **records;
+	struct tep_record *record;
+	struct tep_record **records;
 	unsigned long long ts;
 	int next_cpu;
 	int cpu;
@@ -735,7 +735,7 @@ int task_plot_display_info(struct graph_info *ginfo,
 {
 	struct task_plot_info *task_info = plot->private;
 	struct event_format *event;
-	struct pevent_record *record;
+	struct tep_record *record;
 	struct tep_handle *pevent;
 	unsigned long sec, usec;
 	const char *comm;
@@ -778,7 +778,7 @@ int task_plot_display_info(struct graph_info *ginfo,
 		trace_seq_printf(s, " CPU: %03d", cpu);
 
 	if (record_is_interrupt(ginfo, record, TRUE)) {
-		struct pevent_record *next_record;
+		struct tep_record *next_record;
 
 		next_record = tracecmd_peek_data(ginfo->handle, record->cpu);
 		if (record_is_interrupt(ginfo, next_record, FALSE))
@@ -901,7 +901,7 @@ void graph_plot_init_tasks(struct graph_info *ginfo)
 {
 	struct task_plot_info *task_info;
 	char label[100];
-	struct pevent_record *record;
+	struct tep_record *record;
 	int pid;
 
 	/* Just for testing */
@@ -916,7 +916,7 @@ void graph_plot_init_tasks(struct graph_info *ginfo)
 
 	task_info = malloc_or_die(sizeof(*task_info));
 	task_info->last_records =
-		malloc_or_die(sizeof(struct pevent_record *) * ginfo->cpus);
+		malloc_or_die(sizeof(struct tep_record *) * ginfo->cpus);
 	task_info->pid = pid;
 
 	snprintf(label, 100, "TASK %d", pid);
@@ -934,7 +934,7 @@ void graph_plot_task(struct graph_info *ginfo, int pid, int pos)
 
 	task_info = malloc_or_die(sizeof(*task_info));
 	task_info->last_records =
-		malloc_or_die(sizeof(struct pevent_record *) * ginfo->cpus);
+		malloc_or_die(sizeof(struct tep_record *) * ginfo->cpus);
 	task_info->pid = pid;
 	comm = pevent_data_comm_from_pid(ginfo->pevent, pid);
 
diff --git a/kernel-shark/trace-plot.c b/kernel-shark/trace-plot.c
index ca6f52f..fb55178 100644
--- a/kernel-shark/trace-plot.c
+++ b/kernel-shark/trace-plot.c
@@ -325,7 +325,7 @@ void trace_graph_plot_start(struct graph_info *ginfo,
 
 int trace_graph_plot_event(struct graph_info *ginfo,
 			   struct graph_plot *plot,
-			   struct pevent_record *record)
+			   struct tep_record *record)
 
 {
 	struct plot_info *info = &plot->info;
@@ -360,7 +360,7 @@ int trace_graph_plot_display_last_event(struct graph_info *ginfo,
 	return plot->cb->display_last_event(ginfo, plot, s, time);
 }
 
-struct pevent_record *
+struct tep_record *
 trace_graph_plot_find_record(struct graph_info *ginfo,
 			     struct graph_plot *plot,
 			     unsigned long long time)
diff --git a/kernel-shark/trace-view-main.c b/kernel-shark/trace-view-main.c
index 08e8c1c..00f53e0 100644
--- a/kernel-shark/trace-view-main.c
+++ b/kernel-shark/trace-view-main.c
@@ -302,7 +302,7 @@ do_tree_popup(GtkWidget *widget, GdkEventButton *event, gpointer data)
 	static GtkWidget *menu_display_event;
 	static GtkWidget *menu_display_raw_event;
 	struct tep_handle *pevent;
-	struct pevent_record *record;
+	struct tep_record *record;
 	TraceViewRecord *vrec;
 	GtkTreeModel *model;
 	const char *comm;
diff --git a/kernel-shark/trace-view-store.c b/kernel-shark/trace-view-store.c
index 4a5614b..2e2a125 100644
--- a/kernel-shark/trace-view-store.c
+++ b/kernel-shark/trace-view-store.c
@@ -407,7 +407,7 @@ trace_view_store_get_value (GtkTreeModel *tree_model,
 	struct trace_seq s;
 	struct tep_handle *pevent;
 	struct event_format *event;
-	struct pevent_record *data;
+	struct tep_record *data;
 	const gchar *comm;
 	gchar *str;
 	guint64 secs, usecs;
@@ -840,7 +840,7 @@ TraceViewStore *
 trace_view_store_new (struct tracecmd_input *handle)
 {
 	TraceViewStore *newstore;
-	struct pevent_record *data;
+	struct tep_record *data;
 	gint cpu, count, total=0;
 	struct temp {
 		guint64		offset;
@@ -1139,7 +1139,7 @@ gint trace_view_store_get_num_actual_rows(TraceViewStore *store)
 	return store->actual_rows;
 }
 
-gint get_next_pid(TraceViewStore *store, struct tep_handle *pevent, struct pevent_record *record)
+gint get_next_pid(TraceViewStore *store, struct tep_handle *pevent, struct tep_record *record)
 {
 	unsigned long long val;
 
@@ -1148,7 +1148,7 @@ gint get_next_pid(TraceViewStore *store, struct tep_handle *pevent, struct peven
 	return val;
 }
 
-gint get_wakeup_pid(TraceViewStore *store, struct tep_handle *pevent, struct pevent_record *record)
+gint get_wakeup_pid(TraceViewStore *store, struct tep_handle *pevent, struct tep_record *record)
 {
 	unsigned long long val;
 
@@ -1157,7 +1157,7 @@ gint get_wakeup_pid(TraceViewStore *store, struct tep_handle *pevent, struct pev
 	return val;
 }
 
-gint get_wakeup_new_pid(TraceViewStore *store, struct tep_handle *pevent, struct pevent_record *record)
+gint get_wakeup_new_pid(TraceViewStore *store, struct tep_handle *pevent, struct tep_record *record)
 {
 	unsigned long long val;
 
@@ -1177,7 +1177,7 @@ static gboolean view_task(TraceViewStore *store, gint pid)
 }
 
 static gboolean show_task(TraceViewStore *store, struct tep_handle *pevent,
-			  struct pevent_record *record, gint pid)
+			  struct tep_record *record, gint pid)
 {
 	gint event_id;
 
@@ -1217,7 +1217,7 @@ static void update_filter_tasks(TraceViewStore *store)
 {
 	struct tracecmd_input *handle;
 	struct tep_handle *pevent;
-	struct pevent_record *record;
+	struct tep_record *record;
 	gint pid;
 	gint cpu;
 	gint i;
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 20dd00f..3b87071 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -62,7 +62,7 @@ static int find_ret_event(struct tracecmd_ftrace *finfo, struct tep_handle *peve
 			return -1;					\
 	} while (0)
 
-static int function_handler(struct trace_seq *s, struct pevent_record *record,
+static int function_handler(struct trace_seq *s, struct tep_record *record,
 			    struct event_format *event, void *context)
 {
 	struct tep_handle *pevent = event->pevent;
@@ -92,9 +92,9 @@ static int function_handler(struct trace_seq *s, struct pevent_record *record,
 
 #define TRACE_GRAPH_INDENT		2
 
-static struct pevent_record *
+static struct tep_record *
 get_return_for_leaf(struct trace_seq *s, int cpu, int cur_pid,
-		    unsigned long long cur_func, struct pevent_record *next,
+		    unsigned long long cur_func, struct tep_record *next,
 		    struct tracecmd_ftrace *finfo)
 {
 	unsigned long long val;
@@ -188,8 +188,8 @@ static void print_graph_duration(struct trace_seq *s, unsigned long long duratio
 static int
 print_graph_entry_leaf(struct trace_seq *s,
 		       struct event_format *event,
-		       struct pevent_record *record,
-		       struct pevent_record *ret_rec,
+		       struct tep_record *record,
+		       struct tep_record *ret_rec,
 		       struct tracecmd_ftrace *finfo)
 {
 	struct tep_handle *pevent = event->pevent;
@@ -238,7 +238,7 @@ print_graph_entry_leaf(struct trace_seq *s,
 
 static int print_graph_nested(struct trace_seq *s,
 			      struct event_format *event,
-			      struct pevent_record *record)
+			      struct tep_record *record)
 {
 	struct tep_handle *pevent = event->pevent;
 	unsigned long long depth;
@@ -277,11 +277,11 @@ static int print_graph_nested(struct trace_seq *s,
 }
 
 static int
-fgraph_ent_handler(struct trace_seq *s, struct pevent_record *record,
+fgraph_ent_handler(struct trace_seq *s, struct tep_record *record,
 		   struct event_format *event, void *context)
 {
 	struct tracecmd_ftrace *finfo = context;
-	struct pevent_record *rec;
+	struct tep_record *rec;
 	unsigned long long val, pid;
 	int cpu;
 
@@ -311,7 +311,7 @@ fgraph_ent_handler(struct trace_seq *s, struct pevent_record *record,
 }
 
 static int
-fgraph_ret_handler(struct trace_seq *s, struct pevent_record *record,
+fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 		   struct event_format *event, void *context)
 {
 	struct tracecmd_ftrace *finfo = context;
@@ -362,7 +362,7 @@ fgraph_ret_handler(struct trace_seq *s, struct pevent_record *record,
 }
 
 static int
-trace_stack_handler(struct trace_seq *s, struct pevent_record *record,
+trace_stack_handler(struct trace_seq *s, struct tep_record *record,
 		    struct event_format *event, void *context)
 {
 	struct tracecmd_ftrace *finfo = context;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 635d8b6..7354bbf 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -57,7 +57,7 @@ struct page {
 	int			cpu;
 	long long		lost_events;
 #if DEBUG_RECORD
-	struct pevent_record	*records;
+	struct tep_record	*records;
 #endif
 };
 
@@ -71,7 +71,7 @@ struct cpu_data {
 	struct list_head	page_maps;
 	struct page_map		*page_map;
 	struct page		**pages;
-	struct pevent_record	*next;
+	struct tep_record	*next;
 	struct page		*page;
 	struct kbuffer		*kbuf;
 	int			page_cnt;
@@ -137,7 +137,7 @@ unsigned long tracecmd_get_flags(struct tracecmd_input *handle)
 }
 
 #if DEBUG_RECORD
-static void remove_record(struct page *page, struct pevent_record *record)
+static void remove_record(struct page *page, struct tep_record *record)
 {
 	if (record->prev)
 		record->prev->next = record->next;
@@ -146,7 +146,7 @@ static void remove_record(struct page *page, struct pevent_record *record)
 	if (record->next)
 		record->next->prev = record->prev;
 }
-static void add_record(struct page *page, struct pevent_record *record)
+static void add_record(struct page *page, struct tep_record *record)
 {
 	if (page->records)
 		page->records->prev = record;
@@ -157,7 +157,7 @@ static void add_record(struct page *page, struct pevent_record *record)
 static const char *show_records(struct page **pages)
 {
 	static char buf[BUFSIZ + 1];
-	struct pevent_record *record;
+	struct tep_record *record;
 	struct page *page;
 	int len;
 
@@ -178,8 +178,8 @@ static const char *show_records(struct page **pages)
 	return buf;
 }
 #else
-static inline void remove_record(struct page *page, struct pevent_record *record) {}
-static inline void add_record(struct page *page, struct pevent_record *record) {}
+static inline void remove_record(struct page *page, struct tep_record *record) {}
+static inline void add_record(struct page *page, struct tep_record *record) {}
 static const char *show_records(struct page **pages)
 {
 	return "";
@@ -979,7 +979,7 @@ static void free_page(struct tracecmd_input *handle, int cpu)
 	handle->cpu_data[cpu].page = NULL;
 }
 
-static void __free_record(struct pevent_record *record)
+static void __free_record(struct tep_record *record)
 {
 	if (record->priv) {
 		struct page *page = record->priv;
@@ -990,7 +990,7 @@ static void __free_record(struct pevent_record *record)
 	free(record);
 }
 
-void free_record(struct pevent_record *record)
+void free_record(struct tep_record *record)
 {
 	if (!record)
 		return;
@@ -1011,7 +1011,7 @@ void free_record(struct pevent_record *record)
 	__free_record(record);
 }
 
-void tracecmd_record_ref(struct pevent_record *record)
+void tracecmd_record_ref(struct tep_record *record)
 {
 	record->ref_count++;
 #if DEBUG_RECORD
@@ -1022,7 +1022,7 @@ void tracecmd_record_ref(struct pevent_record *record)
 
 static void free_next(struct tracecmd_input *handle, int cpu)
 {
-	struct pevent_record *record;
+	struct tep_record *record;
 
 	if (!handle->cpu_data || cpu >= handle->cpus)
 		return;
@@ -1135,11 +1135,11 @@ static int get_next_page(struct tracecmd_input *handle, int cpu)
 	return get_page(handle, cpu, offset);
 }
 
-static struct pevent_record *
+static struct tep_record *
 peek_event(struct tracecmd_input *handle, unsigned long long offset,
 	   int cpu)
 {
-	struct pevent_record *record = NULL;
+	struct tep_record *record = NULL;
 
 	/*
 	 * Since the timestamp is calculated from the beginning
@@ -1159,11 +1159,11 @@ peek_event(struct tracecmd_input *handle, unsigned long long offset,
 	return record;
 }
 
-static struct pevent_record *
+static struct tep_record *
 read_event(struct tracecmd_input *handle, unsigned long long offset,
 	   int cpu)
 {
-	struct pevent_record *record;
+	struct tep_record *record;
 
 	record = peek_event(handle, offset, cpu);
 	if (record)
@@ -1171,7 +1171,7 @@ read_event(struct tracecmd_input *handle, unsigned long long offset,
 	return record;
 }
 
-static struct pevent_record *
+static struct tep_record *
 find_and_peek_event(struct tracecmd_input *handle, unsigned long long offset,
 		    int *pcpu)
 {
@@ -1203,11 +1203,11 @@ find_and_peek_event(struct tracecmd_input *handle, unsigned long long offset,
 }
 
 
-static struct pevent_record *
+static struct tep_record *
 find_and_read_event(struct tracecmd_input *handle, unsigned long long offset,
 		    int *pcpu)
 {
-	struct pevent_record *record;
+	struct tep_record *record;
 	int cpu;
 
 	record = find_and_peek_event(handle, offset, &cpu);
@@ -1232,7 +1232,7 @@ find_and_read_event(struct tracecmd_input *handle, unsigned long long offset,
  *
  * The record returned must be freed.
  */
-struct pevent_record *
+struct tep_record *
 tracecmd_read_at(struct tracecmd_input *handle, unsigned long long offset,
 		 int *pcpu)
 {
@@ -1274,7 +1274,7 @@ tracecmd_read_at(struct tracecmd_input *handle, unsigned long long offset,
  *        -1 on error.
  */
 int tracecmd_refresh_record(struct tracecmd_input *handle,
-			    struct pevent_record *record)
+			    struct tep_record *record)
 {
 	unsigned long long page_offset;
 	int cpu = record->cpu;
@@ -1308,7 +1308,7 @@ int tracecmd_refresh_record(struct tracecmd_input *handle,
  *
  * The record returned must be freed.
  */
-struct pevent_record *
+struct tep_record *
 tracecmd_read_cpu_first(struct tracecmd_input *handle, int cpu)
 {
 	int ret;
@@ -1335,10 +1335,10 @@ tracecmd_read_cpu_first(struct tracecmd_input *handle, int cpu)
  *
  * The record returned must be freed.
  */
-struct pevent_record *
+struct tep_record *
 tracecmd_read_cpu_last(struct tracecmd_input *handle, int cpu)
 {
-	struct pevent_record *record = NULL;
+	struct tep_record *record = NULL;
 	off64_t offset, page_offset;
 
 	offset = handle->cpu_data[cpu].file_offset +
@@ -1600,12 +1600,12 @@ tracecmd_get_cursor(struct tracecmd_input *handle, int cpu)
  *
  * The record returned must be freed.
  */
-struct pevent_record *
+struct tep_record *
 tracecmd_translate_data(struct tracecmd_input *handle,
 			void *ptr, int size)
 {
 	struct tep_handle *pevent = handle->pevent;
-	struct pevent_record *record;
+	struct tep_record *record;
 	unsigned int length;
 	int swap = 1;
 
@@ -1650,13 +1650,13 @@ tracecmd_translate_data(struct tracecmd_input *handle,
  *  a record is found. Otherwise NULL is returned if the record is bad
  *  or no more records exist.
  */
-struct pevent_record *
+struct tep_record *
 tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
-			  struct pevent_record *last_record)
+			  struct tep_record *last_record)
 {
 	unsigned long long ts;
 	struct kbuffer *kbuf;
-	struct pevent_record *record = NULL;
+	struct tep_record *record = NULL;
 	enum kbuffer_long_size long_size;
 	enum kbuffer_endian endian;
 	void *ptr;
@@ -1728,10 +1728,10 @@ tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
  * This returns the record at the current location of the CPU
  * iterator. It does not increment the CPU iterator.
  */
-struct pevent_record *
+struct tep_record *
 tracecmd_peek_data(struct tracecmd_input *handle, int cpu)
 {
-	struct pevent_record *record;
+	struct tep_record *record;
 	unsigned long long ts;
 	struct kbuffer *kbuf;
 	struct page *page;
@@ -1826,10 +1826,10 @@ read_again:
  *
  * The record returned must be freed.
  */
-struct pevent_record *
+struct tep_record *
 tracecmd_read_data(struct tracecmd_input *handle, int cpu)
 {
-	struct pevent_record *record;
+	struct tep_record *record;
 
 	record = tracecmd_peek_data(handle, cpu);
 	handle->cpu_data[cpu].next = NULL;
@@ -1859,10 +1859,10 @@ tracecmd_read_data(struct tracecmd_input *handle, int cpu)
  *
  * The record returned must be freed.
  */
-struct pevent_record *
+struct tep_record *
 tracecmd_read_next_data(struct tracecmd_input *handle, int *rec_cpu)
 {
-	struct pevent_record *record;
+	struct tep_record *record;
 	int next_cpu;
 
 	record = tracecmd_peek_next_data(handle, &next_cpu);
@@ -1886,11 +1886,11 @@ tracecmd_read_next_data(struct tracecmd_input *handle, int *rec_cpu)
  * returned. If @rec_cpu is not NULL it gets the CPU id the record was
  * on. It does not increment the CPU iterator.
  */
-struct pevent_record *
+struct tep_record *
 tracecmd_peek_next_data(struct tracecmd_input *handle, int *rec_cpu)
 {
 	unsigned long long ts;
-	struct pevent_record *record, *next_record = NULL;
+	struct tep_record *record, *next_record = NULL;
 	int next_cpu;
 	int cpu;
 
@@ -1935,8 +1935,8 @@ tracecmd_peek_next_data(struct tracecmd_input *handle, int *rec_cpu)
  *
  * The record returned must be freed with free_record().
  */
-struct pevent_record *
-tracecmd_read_prev(struct tracecmd_input *handle, struct pevent_record *record)
+struct tep_record *
+tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record)
 {
 	unsigned long long offset, page_offset;;
 	struct cpu_data *cpu_data;
@@ -3028,7 +3028,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd)
  * Returns true if the record is the first record on the page.
  */
 int tracecmd_record_at_buffer_start(struct tracecmd_input *handle,
-				    struct pevent_record *record)
+				    struct tep_record *record)
 {
 	struct page *page = record->priv;
 	struct kbuffer *kbuf = handle->cpu_data[record->cpu].kbuf;
@@ -3042,7 +3042,7 @@ int tracecmd_record_at_buffer_start(struct tracecmd_input *handle,
 }
 
 unsigned long long tracecmd_page_ts(struct tracecmd_input *handle,
-				    struct pevent_record *record)
+				    struct tep_record *record)
 {
 	struct page *page = record->priv;
 	struct kbuffer *kbuf = handle->cpu_data[record->cpu].kbuf;
@@ -3054,7 +3054,7 @@ unsigned long long tracecmd_page_ts(struct tracecmd_input *handle,
 }
 
 unsigned int tracecmd_record_ts_delta(struct tracecmd_input *handle,
-				      struct pevent_record *record)
+				      struct tep_record *record)
 {
 	struct kbuffer *kbuf = handle->cpu_data[record->cpu].kbuf;
 	struct page *page = record->priv;
@@ -3069,13 +3069,13 @@ unsigned int tracecmd_record_ts_delta(struct tracecmd_input *handle,
 }
 
 struct kbuffer *tracecmd_record_kbuf(struct tracecmd_input *handle,
-				     struct pevent_record *record)
+				     struct tep_record *record)
 {
 	return handle->cpu_data[record->cpu].kbuf;
 }
 
 void *tracecmd_record_page(struct tracecmd_input *handle,
-			   struct pevent_record *record)
+			   struct tep_record *record)
 {
 	struct page *page = record->priv;
 
@@ -3083,7 +3083,7 @@ void *tracecmd_record_page(struct tracecmd_input *handle,
 }
 
 void *tracecmd_record_offset(struct tracecmd_input *handle,
-			     struct pevent_record *record)
+			     struct tep_record *record)
 {
 	struct page *page = record->priv;
 	int offset;
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 62deefb..9088b99 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -5136,7 +5136,7 @@ out_failed:
  * and lock depth) and places it into the trace_seq.
  */
 void pevent_data_lat_fmt(struct tep_handle *pevent,
-			 struct trace_seq *s, struct pevent_record *record)
+			 struct trace_seq *s, struct tep_record *record)
 {
 	static int check_lock_depth = 1;
 	static int check_migrate_disable = 1;
@@ -5215,7 +5215,7 @@ void pevent_data_lat_fmt(struct tep_handle *pevent,
  *
  * This returns the event id from the @rec.
  */
-int pevent_data_type(struct tep_handle *pevent, struct pevent_record *rec)
+int pevent_data_type(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return trace_parse_common_type(pevent, rec->data);
 }
@@ -5239,7 +5239,7 @@ struct event_format *pevent_data_event_from_type(struct tep_handle *pevent, int
  *
  * This returns the PID from a record.
  */
-int pevent_data_pid(struct tep_handle *pevent, struct pevent_record *rec)
+int pevent_data_pid(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return parse_common_pid(pevent, rec->data);
 }
@@ -5251,7 +5251,7 @@ int pevent_data_pid(struct tep_handle *pevent, struct pevent_record *rec)
  *
  * This returns the preempt count from a record.
  */
-int pevent_data_preempt_count(struct tep_handle *pevent, struct pevent_record *rec)
+int pevent_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return parse_common_pc(pevent, rec->data);
 }
@@ -5265,7 +5265,7 @@ int pevent_data_preempt_count(struct tep_handle *pevent, struct pevent_record *r
  *
  *  Use trace_flag_type enum for the flags (see event-parse.h).
  */
-int pevent_data_flags(struct tep_handle *pevent, struct pevent_record *rec)
+int pevent_data_flags(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return parse_common_flags(pevent, rec->data);
 }
@@ -5386,7 +5386,7 @@ int pevent_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline)
  * writes the print format into the trace_seq.
  */
 void pevent_event_info(struct trace_seq *s, struct event_format *event,
-		       struct pevent_record *record)
+		       struct tep_record *record)
 {
 	int print_pretty = 1;
 
@@ -5427,7 +5427,7 @@ static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
  * is found.
  */
 struct event_format *
-pevent_find_event_by_record(struct tep_handle *pevent, struct pevent_record *record)
+pevent_find_event_by_record(struct tep_handle *pevent, struct tep_record *record)
 {
 	int type;
 
@@ -5452,7 +5452,7 @@ pevent_find_event_by_record(struct tep_handle *pevent, struct pevent_record *rec
  */
 void pevent_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
 			     struct event_format *event,
-			     struct pevent_record *record)
+			     struct tep_record *record)
 {
 	void *data = record->data;
 	const char *comm;
@@ -5480,7 +5480,7 @@ void pevent_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
  */
 void pevent_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 			     struct event_format *event,
-			     struct pevent_record *record,
+			     struct tep_record *record,
 			     bool use_trace_clock)
 {
 	unsigned long secs;
@@ -5530,7 +5530,7 @@ void pevent_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
  */
 void pevent_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 			     struct event_format *event,
-			     struct pevent_record *record)
+			     struct tep_record *record)
 {
 	static const char *spaces = "                    "; /* 20 spaces */
 	int len;
@@ -5546,7 +5546,7 @@ void pevent_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 }
 
 void pevent_print_event(struct tep_handle *pevent, struct trace_seq *s,
-			struct pevent_record *record, bool use_trace_clock)
+			struct tep_record *record, bool use_trace_clock)
 {
 	struct event_format *event;
 
@@ -6230,7 +6230,7 @@ int pevent_strerror(struct tep_handle *pevent __maybe_unused,
 }
 
 int get_field_val(struct trace_seq *s, struct format_field *field,
-		  const char *name, struct pevent_record *record,
+		  const char *name, struct tep_record *record,
 		  unsigned long long *val, int err)
 {
 	if (!field) {
@@ -6263,7 +6263,7 @@ int get_field_val(struct trace_seq *s, struct format_field *field,
  * On failure, it returns NULL.
  */
 void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
-			   const char *name, struct pevent_record *record,
+			   const char *name, struct tep_record *record,
 			   int *len, int err)
 {
 	struct format_field *field;
@@ -6310,7 +6310,7 @@ void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
  * Returns 0 on success -1 on field not found.
  */
 int pevent_get_field_val(struct trace_seq *s, struct event_format *event,
-			 const char *name, struct pevent_record *record,
+			 const char *name, struct tep_record *record,
 			 unsigned long long *val, int err)
 {
 	struct format_field *field;
@@ -6335,7 +6335,7 @@ int pevent_get_field_val(struct trace_seq *s, struct event_format *event,
  * Returns 0 on success -1 on field not found.
  */
 int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
-				const char *name, struct pevent_record *record,
+				const char *name, struct tep_record *record,
 				unsigned long long *val, int err)
 {
 	struct format_field *field;
@@ -6360,7 +6360,7 @@ int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
  * Returns 0 on success -1 on field not found.
  */
 int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
-			     const char *name, struct pevent_record *record,
+			     const char *name, struct tep_record *record,
 			     unsigned long long *val, int err)
 {
 	struct format_field *field;
@@ -6386,7 +6386,7 @@ int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
  */
 int pevent_print_num_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
-			   struct pevent_record *record, int err)
+			   struct tep_record *record, int err)
 {
 	struct format_field *field = pevent_find_field(event, name);
 	unsigned long long val;
@@ -6418,7 +6418,7 @@ int pevent_print_num_field(struct trace_seq *s, const char *fmt,
  */
 int pevent_print_func_field(struct trace_seq *s, const char *fmt,
 			    struct event_format *event, const char *name,
-			    struct pevent_record *record, int err)
+			    struct tep_record *record, int err)
 {
 	struct format_field *field = pevent_find_field(event, name);
 	struct tep_handle *pevent = event->pevent;
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index 21e74b0..5ca0803 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -1683,10 +1683,10 @@ int pevent_filter_event_has_trivial(struct event_filter *filter,
 }
 
 static int test_filter(struct event_format *event, struct filter_arg *arg,
-		       struct pevent_record *record, enum pevent_errno *err);
+		       struct tep_record *record, enum pevent_errno *err);
 
 static const char *
-get_comm(struct event_format *event, struct pevent_record *record)
+get_comm(struct event_format *event, struct tep_record *record)
 {
 	const char *comm;
 	int pid;
@@ -1698,7 +1698,7 @@ get_comm(struct event_format *event, struct pevent_record *record)
 
 static unsigned long long
 get_value(struct event_format *event,
-	  struct format_field *field, struct pevent_record *record)
+	  struct format_field *field, struct tep_record *record)
 {
 	unsigned long long val;
 
@@ -1734,11 +1734,11 @@ get_value(struct event_format *event,
 
 static unsigned long long
 get_arg_value(struct event_format *event, struct filter_arg *arg,
-	      struct pevent_record *record, enum pevent_errno *err);
+	      struct tep_record *record, enum pevent_errno *err);
 
 static unsigned long long
 get_exp_value(struct event_format *event, struct filter_arg *arg,
-	      struct pevent_record *record, enum pevent_errno *err)
+	      struct tep_record *record, enum pevent_errno *err)
 {
 	unsigned long long lval, rval;
 
@@ -1793,7 +1793,7 @@ get_exp_value(struct event_format *event, struct filter_arg *arg,
 
 static unsigned long long
 get_arg_value(struct event_format *event, struct filter_arg *arg,
-	      struct pevent_record *record, enum pevent_errno *err)
+	      struct tep_record *record, enum pevent_errno *err)
 {
 	switch (arg->type) {
 	case FILTER_ARG_FIELD:
@@ -1817,7 +1817,7 @@ get_arg_value(struct event_format *event, struct filter_arg *arg,
 }
 
 static int test_num(struct event_format *event, struct filter_arg *arg,
-		    struct pevent_record *record, enum pevent_errno *err)
+		    struct tep_record *record, enum pevent_errno *err)
 {
 	unsigned long long lval, rval;
 
@@ -1857,7 +1857,7 @@ static int test_num(struct event_format *event, struct filter_arg *arg,
 	}
 }
 
-static const char *get_field_str(struct filter_arg *arg, struct pevent_record *record)
+static const char *get_field_str(struct filter_arg *arg, struct tep_record *record)
 {
 	struct event_format *event;
 	struct tep_handle *pevent;
@@ -1908,7 +1908,7 @@ static const char *get_field_str(struct filter_arg *arg, struct pevent_record *r
 }
 
 static int test_str(struct event_format *event, struct filter_arg *arg,
-		    struct pevent_record *record, enum pevent_errno *err)
+		    struct tep_record *record, enum pevent_errno *err)
 {
 	const char *val;
 
@@ -1939,7 +1939,7 @@ static int test_str(struct event_format *event, struct filter_arg *arg,
 }
 
 static int test_op(struct event_format *event, struct filter_arg *arg,
-		   struct pevent_record *record, enum pevent_errno *err)
+		   struct tep_record *record, enum pevent_errno *err)
 {
 	switch (arg->op.type) {
 	case FILTER_OP_AND:
@@ -1961,7 +1961,7 @@ static int test_op(struct event_format *event, struct filter_arg *arg,
 }
 
 static int test_filter(struct event_format *event, struct filter_arg *arg,
-		       struct pevent_record *record, enum pevent_errno *err)
+		       struct tep_record *record, enum pevent_errno *err)
 {
 	if (*err) {
 		/*
@@ -2033,7 +2033,7 @@ int pevent_event_filtered(struct event_filter *filter, int event_id)
  * otherwise - error occurred during test
  */
 enum pevent_errno pevent_filter_match(struct event_filter *filter,
-				      struct pevent_record *record)
+				      struct tep_record *record)
 {
 	struct tep_handle *pevent = filter->pevent;
 	struct filter_type *filter_type;
diff --git a/plugins/plugin_blk.c b/plugins/plugin_blk.c
index 8fb5de3..6cb6151 100644
--- a/plugins/plugin_blk.c
+++ b/plugins/plugin_blk.c
@@ -278,7 +278,7 @@ static const struct {
 	[__BLK_TA_REMAP]	= {{  "A", "remap" },	   blk_log_remap },
 };
 
-static int blktrace_handler(struct trace_seq *s, struct pevent_record *record,
+static int blktrace_handler(struct trace_seq *s, struct tep_record *record,
 			    struct event_format *event, void *context)
 {
 	struct format_field *field;
diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index 4ac669e..058144e 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -127,7 +127,7 @@ static void show_function(struct trace_seq *s, struct tep_handle *pevent,
 	}
 }
 
-static int function_handler(struct trace_seq *s, struct pevent_record *record,
+static int function_handler(struct trace_seq *s, struct tep_record *record,
 			    struct event_format *event, void *context)
 {
 	struct tep_handle *pevent = event->pevent;
diff --git a/plugins/plugin_futex.c b/plugins/plugin_futex.c
index b73670a..60babce 100644
--- a/plugins/plugin_futex.c
+++ b/plugins/plugin_futex.c
@@ -64,7 +64,7 @@ static void futex_print(struct trace_seq *s, const struct futex_args *args,
 		trace_seq_printf(s, fop->fmt_val3, args->val3);
 }
 
-static int futex_handler(struct trace_seq *s, struct pevent_record *record,
+static int futex_handler(struct trace_seq *s, struct tep_record *record,
 			 struct event_format *event, void *context)
 {
 	const struct futex_op *fop;
diff --git a/plugins/plugin_hrtimer.c b/plugins/plugin_hrtimer.c
index da85bb1..176788c 100644
--- a/plugins/plugin_hrtimer.c
+++ b/plugins/plugin_hrtimer.c
@@ -9,7 +9,7 @@
 
 #include "event-parse.h"
 
-static int timer_expire_handler(struct trace_seq *s, struct pevent_record *record,
+static int timer_expire_handler(struct trace_seq *s, struct tep_record *record,
 				struct event_format *event, void *context)
 {
 	trace_seq_printf(s, "hrtimer=");
@@ -26,7 +26,7 @@ static int timer_expire_handler(struct trace_seq *s, struct pevent_record *recor
 	return 0;
 }
 
-static int timer_start_handler(struct trace_seq *s, struct pevent_record *record,
+static int timer_start_handler(struct trace_seq *s, struct tep_record *record,
 			       struct event_format *event, void *context)
 {
 	trace_seq_printf(s, "hrtimer=");
diff --git a/plugins/plugin_kmem.c b/plugins/plugin_kmem.c
index a4a2135..c913cc7 100644
--- a/plugins/plugin_kmem.c
+++ b/plugins/plugin_kmem.c
@@ -8,7 +8,7 @@
 
 #include "trace-cmd.h"
 
-static int call_site_handler(struct trace_seq *s, struct pevent_record *record,
+static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 			     struct event_format *event, void *context)
 {
 	struct format_field *field;
diff --git a/plugins/plugin_kvm.c b/plugins/plugin_kvm.c
index 5007b36..f5024db 100644
--- a/plugins/plugin_kvm.c
+++ b/plugins/plugin_kvm.c
@@ -248,7 +248,7 @@ static const char *find_exit_reason(unsigned isa, int val)
 	return strings[i].str;
 }
 
-static int print_exit_reason(struct trace_seq *s, struct pevent_record *record,
+static int print_exit_reason(struct trace_seq *s, struct tep_record *record,
 			     struct event_format *event, const char *field)
 {
 	unsigned long long isa;
@@ -269,7 +269,7 @@ static int print_exit_reason(struct trace_seq *s, struct pevent_record *record,
 	return 0;
 }
 
-static int kvm_exit_handler(struct trace_seq *s, struct pevent_record *record,
+static int kvm_exit_handler(struct trace_seq *s, struct tep_record *record,
 			    struct event_format *event, void *context)
 {
 	unsigned long long info1 = 0, info2 = 0;
@@ -291,7 +291,7 @@ static int kvm_exit_handler(struct trace_seq *s, struct pevent_record *record,
 #define KVM_EMUL_INSN_F_CS_D   (1 << 2)
 #define KVM_EMUL_INSN_F_CS_L   (1 << 3)
 
-static int kvm_emulate_insn_handler(struct trace_seq *s, struct pevent_record *record,
+static int kvm_emulate_insn_handler(struct trace_seq *s, struct tep_record *record,
 				    struct event_format *event, void *context)
 {
 	unsigned long long rip, csbase, len, flags, failed;
@@ -331,7 +331,7 @@ static int kvm_emulate_insn_handler(struct trace_seq *s, struct pevent_record *r
 }
 
 
-static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct pevent_record *record,
+static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct tep_record *record,
 					    struct event_format *event, void *context)
 {
 	if (print_exit_reason(s, record, event, "exit_code") < 0)
@@ -345,7 +345,7 @@ static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct pevent_r
 	return 0;
 }
 
-static int kvm_nested_vmexit_handler(struct trace_seq *s, struct pevent_record *record,
+static int kvm_nested_vmexit_handler(struct trace_seq *s, struct tep_record *record,
 				     struct event_format *event, void *context)
 {
 	pevent_print_num_field(s, "rip %lx ", event, "rip", record, 1);
@@ -368,7 +368,7 @@ union kvm_mmu_page_role {
 	};
 };
 
-static int kvm_mmu_print_role(struct trace_seq *s, struct pevent_record *record,
+static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 			      struct event_format *event, void *context)
 {
 	unsigned long long val;
@@ -410,7 +410,7 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct pevent_record *record,
 
 	return 0;
 }
-static int kvm_mmu_get_page_handler(struct trace_seq *s, struct pevent_record *record,
+static int kvm_mmu_get_page_handler(struct trace_seq *s, struct tep_record *record,
 				    struct event_format *event, void *context)
 {
 	unsigned long long val;
diff --git a/plugins/plugin_mac80211.c b/plugins/plugin_mac80211.c
index 455cb85..b98803b 100644
--- a/plugins/plugin_mac80211.c
+++ b/plugins/plugin_mac80211.c
@@ -123,7 +123,7 @@ static void _print_flag(struct trace_seq *s, struct event_format *event,
 #define SFX(fn)	pevent_print_num_field(s, fn ":%#x", event, fn, record, 0)
 #define SP()	trace_seq_putc(s, ' ')
 
-static int drv_bss_info_changed(struct trace_seq *s, struct pevent_record *record,
+static int drv_bss_info_changed(struct trace_seq *s, struct tep_record *record,
 				struct event_format *event, void *context)
 {
 	void *data = record->data;
@@ -151,7 +151,7 @@ static int drv_bss_info_changed(struct trace_seq *s, struct pevent_record *recor
 	return 0;
 }
 
-static int drv_config(struct trace_seq *s, struct pevent_record *record,
+static int drv_config(struct trace_seq *s, struct tep_record *record,
 		      struct event_format *event, void *context)
 {
 	void *data = record->data;
diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index be60308..6c6e9f5 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -30,7 +30,7 @@ static void write_state(struct trace_seq *s, int val)
 }
 
 static void write_and_save_comm(struct format_field *field,
-				struct pevent_record *record,
+				struct tep_record *record,
 				struct trace_seq *s, int pid)
 {
 	const char *comm;
@@ -49,7 +49,7 @@ static void write_and_save_comm(struct format_field *field,
 	pevent_register_comm(field->event->pevent, comm, pid);
 }
 
-static int sched_wakeup_handler(struct trace_seq *s, struct pevent_record *record,
+static int sched_wakeup_handler(struct trace_seq *s, struct tep_record *record,
 				struct event_format *event, void *context)
 {
 	struct format_field *field;
@@ -77,7 +77,7 @@ static int sched_wakeup_handler(struct trace_seq *s, struct pevent_record *recor
 	return 0;
 }
 
-static int sched_switch_handler(struct trace_seq *s, struct pevent_record *record,
+static int sched_switch_handler(struct trace_seq *s, struct tep_record *record,
 				struct event_format *event, void *context)
 {
 	struct format_field *field;
diff --git a/plugins/plugin_tlb.c b/plugins/plugin_tlb.c
index 781d6fe..4a750aa 100644
--- a/plugins/plugin_tlb.c
+++ b/plugins/plugin_tlb.c
@@ -16,7 +16,7 @@ enum tlb_flush_reason {
 	NR_TLB_FLUSH_REASONS,
 };
 
-static int tlb_flush_handler(struct trace_seq *s, struct pevent_record *record,
+static int tlb_flush_handler(struct trace_seq *s, struct tep_record *record,
 			     struct event_format *event, void *context)
 {
 	unsigned long long val;
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index 04ab547..eb6dbd6 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -31,7 +31,7 @@
 
 %inline %{
 static int python_callback(struct trace_seq *s,
-			   struct pevent_record *record,
+			   struct tep_record *record,
 			   struct event_format *event,
 			   void *context);
 
@@ -81,7 +81,7 @@ void py_pevent_register_event_handler(struct tep_handle *pevent, int id,
 }
 
 static PyObject *py_field_get_stack(struct tep_handle *pevent,
-				    struct pevent_record *record,
+				    struct tep_record *record,
 				    struct event_format *event,
 				    int long_size)
 {
@@ -117,7 +117,7 @@ static PyObject *py_field_get_stack(struct tep_handle *pevent,
 	return list;
 }
 
-static PyObject *py_field_get_data(struct format_field *f, struct pevent_record *r)
+static PyObject *py_field_get_data(struct format_field *f, struct tep_record *r)
 {
 	if (!strncmp(f->type, "__data_loc ", 11)) {
 		unsigned long long val;
@@ -143,7 +143,7 @@ static PyObject *py_field_get_data(struct format_field *f, struct pevent_record
 	return PyBuffer_FromMemory((char *)r->data + f->offset, f->size);
 }
 
-static PyObject *py_field_get_str(struct format_field *f, struct pevent_record *r)
+static PyObject *py_field_get_str(struct format_field *f, struct tep_record *r)
 {
 	if (!strncmp(f->type, "__data_loc ", 11)) {
 		unsigned long long val;
@@ -190,7 +190,7 @@ static PyObject *py_format_get_keys(struct event_format *ef)
 
 %wrapper %{
 static int python_callback(struct trace_seq *s,
-			   struct pevent_record *record,
+			   struct tep_record *record,
 			   struct event_format *event,
 			   void *context)
 {
@@ -203,7 +203,7 @@ static int python_callback(struct trace_seq *s,
 		SWIG_NewPointerObj(SWIG_as_voidptr(s),
 				   SWIGTYPE_p_trace_seq, 0),
 		SWIG_NewPointerObj(SWIG_as_voidptr(record),
-				   SWIGTYPE_p_pevent_record, 0),
+				   SWIGTYPE_p_tep_record, 0),
 		SWIG_NewPointerObj(SWIG_as_voidptr(event),
 				   SWIGTYPE_p_event_format, 0));
 
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 18c457d..a1a06e9 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -34,7 +34,7 @@ struct pid_record_data {
 	int			closed;
 	struct tracecmd_input	*stream;
 	struct buffer_instance	*instance;
-	struct pevent_record	*record;
+	struct tep_record	*record;
 };
 
 void show_file(const char *name);
@@ -101,7 +101,7 @@ trace_stream_init(struct buffer_instance *instance, int cpu, int fd, int cpus,
 		  tracecmd_handle_init_func handle_init, int global);
 int trace_stream_read(struct pid_record_data *pids, int nr_pids, struct timeval *tv);
 
-void trace_show_data(struct tracecmd_input *handle, struct pevent_record *record);
+void trace_show_data(struct tracecmd_input *handle, struct tep_record *record);
 
 /* --- event interation --- */
 
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index 81bac87..b8ff77d 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -252,7 +252,7 @@ static void pop_stack_func(void)
 }
 
 static void
-process_function(struct tep_handle *pevent, struct pevent_record *record)
+process_function(struct tep_handle *pevent, struct tep_record *record)
 {
 	unsigned long long parent_ip;
 	unsigned long long ip;
@@ -309,7 +309,7 @@ process_function(struct tep_handle *pevent, struct pevent_record *record)
 }
 
 static void
-process_function_graph_entry(struct tep_handle *pevent, struct pevent_record *record)
+process_function_graph_entry(struct tep_handle *pevent, struct tep_record *record)
 {
 	unsigned long long depth;
 	unsigned long long ip;
@@ -355,7 +355,7 @@ process_function_graph_entry(struct tep_handle *pevent, struct pevent_record *re
 }
 
 static void
-process_function_graph_exit(struct tep_handle *pevent, struct pevent_record *record)
+process_function_graph_exit(struct tep_handle *pevent, struct tep_record *record)
 {
 	unsigned long long depth;
 	unsigned long long val;
@@ -410,7 +410,7 @@ static void copy_stack_to_pending(int pid)
 }
 
 static void
-process_kernel_stack(struct tep_handle *pevent, struct pevent_record *record)
+process_kernel_stack(struct tep_handle *pevent, struct tep_record *record)
 {
 	struct format_field *field = kernel_stack_caller_field;
 	unsigned long long val;
@@ -480,7 +480,7 @@ process_kernel_stack(struct tep_handle *pevent, struct pevent_record *record)
 }
 
 static void
-process_sched_wakeup(struct tep_handle *pevent, struct pevent_record *record, int type)
+process_sched_wakeup(struct tep_handle *pevent, struct tep_record *record, int type)
 {
 	unsigned long long val;
 	const char *comm;
@@ -505,7 +505,7 @@ process_sched_wakeup(struct tep_handle *pevent, struct pevent_record *record, in
 }
 
 static void
-process_sched_switch(struct tep_handle *pevent, struct pevent_record *record)
+process_sched_switch(struct tep_handle *pevent, struct tep_record *record)
 {
 	unsigned long long val;
 	const char *comm;
@@ -528,7 +528,7 @@ process_sched_switch(struct tep_handle *pevent, struct pevent_record *record)
 }
 
 static void
-process_event(struct tep_handle *pevent, struct pevent_record *record, int type)
+process_event(struct tep_handle *pevent, struct tep_record *record, int type)
 {
 	struct event_format *event;
 	const char *event_name;
@@ -563,7 +563,7 @@ process_event(struct tep_handle *pevent, struct pevent_record *record, int type)
 }
 
 static void
-process_record(struct tep_handle *pevent, struct pevent_record *record)
+process_record(struct tep_handle *pevent, struct tep_record *record)
 {
 	unsigned long long val;
 	int type;
@@ -935,7 +935,7 @@ static void do_trace_hist(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = tracecmd_get_pevent(handle);
 	struct event_format *event;
-	struct pevent_record *record;
+	struct tep_record *record;
 	int cpus;
 	int cpu;
 	int ret;
@@ -974,7 +974,7 @@ static void do_trace_hist(struct tracecmd_input *handle)
 
 	for (cpu = 0; cpu < cpus; cpu++) {
 		for (;;) {
-			struct pevent_record *record;
+			struct tep_record *record;
 
 			record = tracecmd_read_data(handle, cpu);
 			if (!record)
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index f9658e5..42953b2 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -327,7 +327,7 @@ static void remove_kmalloc(unsigned long long ptr)
 }
 
 static void
-process_kmalloc(struct tep_handle *pevent, struct pevent_record *record,
+process_kmalloc(struct tep_handle *pevent, struct tep_record *record,
 		struct format_field *callsite_field,
 		struct format_field *bytes_req_field,
 		struct format_field *bytes_alloc_field,
@@ -353,7 +353,7 @@ process_kmalloc(struct tep_handle *pevent, struct pevent_record *record,
 }
 
 static void
-process_kfree(struct tep_handle *pevent, struct pevent_record *record,
+process_kfree(struct tep_handle *pevent, struct tep_record *record,
 	      struct format_field *ptr_field)
 {
 	unsigned long long ptr;
@@ -364,7 +364,7 @@ process_kfree(struct tep_handle *pevent, struct pevent_record *record,
 }
 
 static void
-process_record(struct tep_handle *pevent, struct pevent_record *record)
+process_record(struct tep_handle *pevent, struct tep_record *record)
 {
 	unsigned long long val;
 	int type;
@@ -463,7 +463,7 @@ static void do_trace_mem(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent = tracecmd_get_pevent(handle);
 	struct event_format *event;
-	struct pevent_record *record;
+	struct tep_record *record;
 	int missed_events = 0;
 	int cpus;
 	int cpu;
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index 246520a..964a65f 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -51,7 +51,7 @@ struct event_data;
 typedef void (*event_data_print)(struct trace_seq *s, struct event_hash *hash);
 typedef int (*handle_event_func)(struct handle_data *h, unsigned long long pid,
 				 struct event_data *data,
-				 struct pevent_record *record, int cpu);
+				 struct tep_record *record, int cpu);
 
 enum event_data_type {
 	EVENT_TYPE_UNDEFINED,
@@ -105,7 +105,7 @@ struct stack_data {
 struct stack_holder {
 	unsigned long		size;
 	void			*caller;
-	struct pevent_record	*record;
+	struct tep_record	*record;
 };
 
 struct start_data {
@@ -158,7 +158,7 @@ struct task_data {
 	struct task_data	*proxy;
 	struct start_data	*last_start;
 	struct event_hash	*last_event;
-	struct pevent_record	*last_stack;
+	struct tep_record	*last_stack;
 	struct handle_data	*handle;
 	struct group_data	*group;
 };
@@ -211,7 +211,7 @@ void trace_profile_set_merge_like_comms(void)
 
 static struct start_data *
 add_start(struct task_data *task,
-	  struct event_data *event_data, struct pevent_record *record,
+	  struct event_data *event_data, struct tep_record *record,
 	  unsigned long long search_val, unsigned long long val)
 {
 	struct start_data *start;
@@ -532,7 +532,7 @@ static int match_group(struct trace_hash_item *item, void *data)
 
 static void
 add_task_comm(struct task_data *task, struct format_field *field,
-	      struct pevent_record *record)
+	      struct tep_record *record)
 {
 	const char *comm;
 
@@ -548,7 +548,7 @@ add_task_comm(struct task_data *task, struct format_field *field,
 
 /* Account for tasks that don't have starts */
 static void account_task(struct task_data *task, struct event_data *event_data,
-			 struct pevent_record *record)
+			 struct tep_record *record)
 {
 	struct event_data_match edata;
 	struct event_hash *event_hash;
@@ -601,7 +601,7 @@ static void account_task(struct task_data *task, struct event_data *event_data,
 
 static struct task_data *
 find_event_task(struct handle_data *h, struct event_data *event_data,
-		struct pevent_record *record, unsigned long long pid)
+		struct tep_record *record, unsigned long long pid)
 {
 	if (event_data->global) {
 		if (event_data->migrate)
@@ -619,7 +619,7 @@ find_event_task(struct handle_data *h, struct event_data *event_data,
 
 static struct task_data *
 handle_end_event(struct handle_data *h, struct event_data *event_data,
-		 struct pevent_record *record, int pid)
+		 struct tep_record *record, int pid)
 {
 	struct event_hash *event_hash;
 	struct task_data *task;
@@ -640,7 +640,7 @@ handle_end_event(struct handle_data *h, struct event_data *event_data,
 
 static struct task_data *
 handle_start_event(struct handle_data *h, struct event_data *event_data,
-		   struct pevent_record *record, unsigned long long pid)
+		   struct tep_record *record, unsigned long long pid)
 {
 	struct start_data *start;
 	struct task_data *task;
@@ -667,7 +667,7 @@ handle_start_event(struct handle_data *h, struct event_data *event_data,
 static int handle_event_data(struct handle_data *h,
 			     unsigned long long pid,
 			     struct event_data *event_data,
-			     struct pevent_record *record, int cpu)
+			     struct tep_record *record, int cpu)
 {
 	struct task_data *task = NULL;
 
@@ -734,10 +734,10 @@ find_event_data(struct handle_data *h, int id)
 }
 
 static void trace_profile_record(struct tracecmd_input *handle,
-				struct pevent_record *record)
+				 struct tep_record *record)
 {
 	static struct handle_data *last_handle;
-	struct pevent_record *stack_record;
+	struct tep_record *stack_record;
 	struct event_data *event_data;
 	struct task_data *task;
 	struct handle_data *h;
@@ -989,7 +989,7 @@ static void sched_switch_print(struct trace_seq *s, struct event_hash *event_has
 static int handle_sched_switch_event(struct handle_data *h,
 				     unsigned long long pid,
 				     struct event_data *event_data,
-				     struct pevent_record *record, int cpu)
+				     struct tep_record *record, int cpu)
 {
 	struct task_data *task;
 	unsigned long long prev_pid;
@@ -1054,7 +1054,7 @@ static int handle_sched_switch_event(struct handle_data *h,
 static int handle_stacktrace_event(struct handle_data *h,
 				   unsigned long long pid,
 				   struct event_data *event_data,
-				   struct pevent_record *record, int cpu)
+				   struct tep_record *record, int cpu)
 {
 	struct task_data *orig_task;
 	struct task_data *proxy;
@@ -1124,7 +1124,7 @@ static int handle_stacktrace_event(struct handle_data *h,
 static int handle_fgraph_entry_event(struct handle_data *h,
 				    unsigned long long pid,
 				    struct event_data *event_data,
-				    struct pevent_record *record, int cpu)
+				    struct tep_record *record, int cpu)
 {
 	unsigned long long size;
 	struct start_data *start;
@@ -1163,7 +1163,7 @@ static int handle_fgraph_entry_event(struct handle_data *h,
 static int handle_fgraph_exit_event(struct handle_data *h,
 				    unsigned long long pid,
 				    struct event_data *event_data,
-				    struct pevent_record *record, int cpu)
+				    struct tep_record *record, int cpu)
 {
 	struct task_data *task;
 
@@ -1179,7 +1179,7 @@ static int handle_fgraph_exit_event(struct handle_data *h,
 static int handle_process_exec(struct handle_data *h,
 			       unsigned long long pid,
 			       struct event_data *event_data,
-			       struct pevent_record *record, int cpu)
+			       struct tep_record *record, int cpu)
 {
 	struct task_data *task;
 	unsigned long long val;
@@ -1204,7 +1204,7 @@ static int handle_process_exec(struct handle_data *h,
 static int handle_sched_wakeup_event(struct handle_data *h,
 				     unsigned long long pid,
 				     struct event_data *event_data,
-				     struct pevent_record *record, int cpu)
+				     struct tep_record *record, int cpu)
 {
 	struct task_data *proxy;
 	struct task_data *task = NULL;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index c1dbd77..ac74876 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -50,7 +50,7 @@ struct handle_list {
 	const char		*file;
 	int			cpus;
 	int			done;
-	struct pevent_record	*record;
+	struct tep_record	*record;
 	struct filter		*event_filters;
 	struct filter		*event_filter_out;
 };
@@ -135,7 +135,7 @@ static int test_read_at_index;
 static void show_test(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent;
-	struct pevent_record *record;
+	struct tep_record *record;
 	struct trace_seq s;
 	int cpu;
 
@@ -157,7 +157,7 @@ static void show_test(struct tracecmd_input *handle)
 	free_record(record);
 }
 
-static void test_save(struct pevent_record *record, int cpu)
+static void test_save(struct tep_record *record, int cpu)
 {
 	if (test_read_at_index++ == test_read_at_copy) {
 		test_read_at_offset = record->offset;
@@ -177,7 +177,7 @@ static int test_at_timestamp_index;
 static void show_test(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent;
-	struct pevent_record *record;
+	struct tep_record *record;
 	struct trace_seq s;
 	int cpu = test_at_timestamp_cpu;
 
@@ -204,7 +204,7 @@ static void show_test(struct tracecmd_input *handle)
 	free_record(record);
 }
 
-static void test_save(struct pevent_record *record, int cpu)
+static void test_save(struct tep_record *record, int cpu)
 {
 	if (test_at_timestamp_index++ == test_at_timestamp_copy) {
 		test_at_timestamp_ts = record->ts;
@@ -222,7 +222,7 @@ static void test_save(struct pevent_record *record, int cpu)
 static void show_test(struct tracecmd_input *handle)
 {
 	struct tep_handle *pevent;
-	struct pevent_record *record;
+	struct tep_record *record;
 	struct trace_seq s;
 	int cpu = 0;
 
@@ -260,7 +260,7 @@ static void show_test(struct tracecmd_input *handle)
 
 	free_record(record);
 }
-static void test_save(struct pevent_record *record, int cpu)
+static void test_save(struct tep_record *record, int cpu)
 {
 }
 #endif /* TEST_FIRST_LAST */
@@ -269,7 +269,7 @@ static void test_save(struct pevent_record *record, int cpu)
 static void show_test(struct tracecmd_input *handle)
 {
 }
-static void test_save(struct pevent_record *record, int cpu)
+static void test_save(struct tep_record *record, int cpu)
 {
 }
 #endif
@@ -661,7 +661,7 @@ static void add_sched(unsigned int val, unsigned long long end, int rt)
 	free(info);
 }
 
-static void process_wakeup(struct tep_handle *pevent, struct pevent_record *record)
+static void process_wakeup(struct tep_handle *pevent, struct tep_record *record)
 {
 	unsigned long long val;
 	int id;
@@ -749,7 +749,7 @@ static void finish_wakeup(void)
 	trace_hash_free(&wakeup_hash);
 }
 
-void trace_show_data(struct tracecmd_input *handle, struct pevent_record *record)
+void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 {
 	tracecmd_show_data_func func = tracecmd_get_show_data_func(handle);
 	struct tep_handle *pevent;
@@ -876,7 +876,7 @@ static void read_rest(void)
 
 static int
 test_filters(struct tep_handle *pevent, struct filter *event_filters,
-	     struct pevent_record *record, int neg)
+	     struct tep_record *record, int neg)
 {
 	int found = 0;
 	int ret = FILTER_NONE;
@@ -920,7 +920,7 @@ struct stack_info {
 };
 
 static int
-test_stacktrace(struct handle_list *handles, struct pevent_record *record,
+test_stacktrace(struct handle_list *handles, struct tep_record *record,
 		int last_printed)
 {
 	static struct stack_info *infos;
@@ -994,9 +994,9 @@ test_stacktrace(struct handle_list *handles, struct pevent_record *record,
 	return 0;
 }
 
-static struct pevent_record *get_next_record(struct handle_list *handles)
+static struct tep_record *get_next_record(struct handle_list *handles)
 {
-	struct pevent_record *record;
+	struct tep_record *record;
 	struct tep_handle *pevent;
 	int found = 0;
 	int cpu;
@@ -1013,7 +1013,7 @@ static struct pevent_record *get_next_record(struct handle_list *handles)
 	do {
 		if (filter_cpus) {
 			long long last_stamp = -1;
-			struct pevent_record *precord;
+			struct tep_record *precord;
 			int first_record = 1;
 			int next_cpu = -1;
 			int i;
@@ -1115,8 +1115,8 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 {
 	struct handle_list *handles;
 	struct handle_list *last_handle;
-	struct pevent_record *record;
-	struct pevent_record *last_record;
+	struct tep_record *record;
+	struct tep_record *last_record;
 	struct event_format *event;
 	struct tep_handle *pevent;
 	int cpus;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4531a97..45e5feb 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3348,8 +3348,8 @@ find_ts_in_page(struct tep_handle *pevent, void *page, int size)
 {
 	struct event_format *event;
 	struct format_field *field;
-	struct pevent_record *last_record = NULL;
-	struct pevent_record *record;
+	struct tep_record *last_record = NULL;
+	struct tep_record *record;
 	unsigned long long ts = 0;
 	int id;
 
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index bd7a33c..cabcc3d 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -41,7 +41,7 @@ enum split_types {
 struct cpu_data {
 	unsigned long long		ts;
 	unsigned long long		offset;
-	struct pevent_record		*record;
+	struct tep_record		*record;
 	int				cpu;
 	int				fd;
 	int				index;
@@ -74,7 +74,7 @@ static int create_type_len(struct tep_handle *pevent, int time, int len)
 }
 
 static int write_record(struct tracecmd_input *handle,
-			struct pevent_record *record,
+			struct tep_record *record,
 			struct cpu_data *cpu_data,
 			enum split_types type)
 {
@@ -151,8 +151,8 @@ static void write_page(struct tep_handle *pevent,
 	write(cpu_data->fd, cpu_data->page, page_size);
 }
 
-static struct pevent_record *read_record(struct tracecmd_input *handle,
-				  int percpu, int *cpu)
+static struct tep_record *read_record(struct tracecmd_input *handle,
+				      int percpu, int *cpu)
 {
 	if (percpu)
 		return tracecmd_read_data(handle, *cpu);
@@ -180,7 +180,7 @@ static int parse_cpu(struct tracecmd_input *handle,
 		     int count_limit, int percpu, int cpu,
 		     enum split_types type)
 {
-	struct pevent_record *record;
+	struct tep_record *record;
 	struct tep_handle *pevent;
 	void *ptr;
 	int page_size;
@@ -333,7 +333,7 @@ static double parse_file(struct tracecmd_input *handle,
 	unsigned long long current;
 	struct tracecmd_output *ohandle;
 	struct cpu_data *cpu_data;
-	struct pevent_record *record;
+	struct tep_record *record;
 	char **cpu_list;
 	char *output;
 	char *base;
diff --git a/tracecmd/trace-stream.c b/tracecmd/trace-stream.c
index 795f666..dad3466 100644
--- a/tracecmd/trace-stream.c
+++ b/tracecmd/trace-stream.c
@@ -87,7 +87,7 @@ trace_stream_init(struct buffer_instance *instance, int cpu, int fd, int cpus,
 
 int trace_stream_read(struct pid_record_data *pids, int nr_pids, struct timeval *tv)
 {
-	struct pevent_record *record;
+	struct tep_record *record;
 	struct pid_record_data *pid;
 	struct pid_record_data *last_pid;
 	fd_set rfds;
-- 
2.17.1
