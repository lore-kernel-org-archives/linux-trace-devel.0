Return-Path: <SRS0=xHrW=KR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:51849 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732154AbeHBPyI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Aug 2018 11:54:08 -0400
Received: by mail-wm0-f67.google.com with SMTP id y2-v6so2664553wma.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Aug 2018 07:02:45 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 07/24] tools/lib/traceevent, tools/perf: Rename pevent print APIs
Date: Thu,  2 Aug 2018 17:02:07 +0300
Message-Id: <20180802140224.19070-8-tz.stoyanov@gmail.com>
In-Reply-To: <20180802140224.19070-1-tz.stoyanov@gmail.com>
References: <20180802140224.19070-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_print_field, pevent_print_fields, pevent_print_funcs,
pevent_print_printk

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.c     | 74 +++++++++++++-------------
 tools/lib/traceevent/event-parse.h     | 44 +++++++--------
 tools/lib/traceevent/plugin_hrtimer.c  | 28 +++++-----
 tools/lib/traceevent/plugin_kvm.c      | 16 +++---
 tools/lib/traceevent/plugin_mac80211.c |  6 +--
 tools/perf/util/sort.c                 |  6 +--
 tools/perf/util/trace-event-read.c     |  4 +-
 7 files changed, 89 insertions(+), 89 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 419e57f5bbf3..2b717c2d65cc 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -589,12 +589,12 @@ int pevent_register_function(struct tep_handle *pevent, char *func,
 }
 
 /**
- * pevent_print_funcs - print out the stored functions
+ * tep_print_funcs - print out the stored functions
  * @pevent: handle for the pevent
  *
  * This prints out the stored functions.
  */
-void pevent_print_funcs(struct tep_handle *pevent)
+void tep_print_funcs(struct tep_handle *pevent)
 {
 	int i;
 
@@ -732,12 +732,12 @@ int pevent_register_print_string(struct tep_handle *pevent, const char *fmt,
 }
 
 /**
- * pevent_print_printk - print out the stored strings
+ * tep_print_printk - print out the stored strings
  * @pevent: handle for the pevent
  *
  * This prints the string formats that were stored.
  */
-void pevent_print_printk(struct tep_handle *pevent)
+void tep_print_printk(struct tep_handle *pevent)
 {
 	int i;
 
@@ -4800,8 +4800,8 @@ static int is_printable_array(char *p, unsigned int len)
 	return 1;
 }
 
-void pevent_print_field(struct trace_seq *s, void *data,
-			struct format_field *field)
+void tep_print_field(struct trace_seq *s, void *data,
+		     struct format_field *field)
 {
 	unsigned long long val;
 	unsigned int offset, len, i;
@@ -4865,15 +4865,15 @@ void pevent_print_field(struct trace_seq *s, void *data,
 	}
 }
 
-void pevent_print_fields(struct trace_seq *s, void *data,
-			 int size __maybe_unused, struct event_format *event)
+void tep_print_fields(struct trace_seq *s, void *data,
+		      int size __maybe_unused, struct event_format *event)
 {
 	struct format_field *field;
 
 	field = event->format.fields;
 	while (field) {
 		trace_seq_printf(s, " %s=", field->name);
-		pevent_print_field(s, data, field);
+		tep_print_field(s, data, field);
 		field = field->next;
 	}
 }
@@ -4899,7 +4899,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 
 	if (event->flags & EVENT_FL_FAILED) {
 		trace_seq_printf(s, "[FAILED TO PARSE]");
-		pevent_print_fields(s, data, size, event);
+		tep_print_fields(s, data, size, event);
 		return;
 	}
 
@@ -5405,7 +5405,7 @@ void tep_event_info(struct trace_seq *s, struct event_format *event,
 	int print_pretty = 1;
 
 	if (event->pevent->print_raw || (event->flags & EVENT_FL_PRINTRAW))
-		pevent_print_fields(s, record->data, record->size, event);
+		tep_print_fields(s, record->data, record->size, event);
 	else {
 
 		if (event->handler && !(event->flags & EVENT_FL_NOHANDLE))
@@ -5456,7 +5456,7 @@ pevent_find_event_by_record(struct tep_handle *pevent, struct tep_record *record
 }
 
 /**
- * pevent_print_event_task - Write the event task comm, pid and CPU
+ * tep_print_event_task - Write the event task comm, pid and CPU
  * @pevent: a handle to the pevent
  * @s: the trace_seq to write to
  * @event: the handle to the record's event
@@ -5464,9 +5464,9 @@ pevent_find_event_by_record(struct tep_handle *pevent, struct tep_record *record
  *
  * Writes the tasks comm, pid and CPU to @s.
  */
-void pevent_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
-			     struct event_format *event,
-			     struct tep_record *record)
+void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
+			  struct event_format *event,
+			  struct tep_record *record)
 {
 	void *data = record->data;
 	const char *comm;
@@ -5483,7 +5483,7 @@ void pevent_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
 }
 
 /**
- * pevent_print_event_time - Write the event timestamp
+ * tep_print_event_time - Write the event timestamp
  * @pevent: a handle to the pevent
  * @s: the trace_seq to write to
  * @event: the handle to the record's event
@@ -5492,10 +5492,10 @@ void pevent_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
  *
  * Writes the timestamp of the record into @s.
  */
-void pevent_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
-			     struct event_format *event,
-			     struct tep_record *record,
-			     bool use_trace_clock)
+void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
+			  struct event_format *event,
+			  struct tep_record *record,
+			  bool use_trace_clock)
 {
 	unsigned long secs;
 	unsigned long usecs;
@@ -5534,7 +5534,7 @@ void pevent_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 }
 
 /**
- * pevent_print_event_data - Write the event data section
+ * tep_print_event_data - Write the event data section
  * @pevent: a handle to the pevent
  * @s: the trace_seq to write to
  * @event: the handle to the record's event
@@ -5542,9 +5542,9 @@ void pevent_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
  *
  * Writes the parsing of the record's data to @s.
  */
-void pevent_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
-			     struct event_format *event,
-			     struct tep_record *record)
+void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
+			  struct event_format *event,
+			  struct tep_record *record)
 {
 	static const char *spaces = "                    "; /* 20 spaces */
 	int len;
@@ -5559,8 +5559,8 @@ void pevent_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 	tep_event_info(s, event, record);
 }
 
-void pevent_print_event(struct tep_handle *pevent, struct trace_seq *s,
-			struct tep_record *record, bool use_trace_clock)
+void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
+		     struct tep_record *record, bool use_trace_clock)
 {
 	struct event_format *event;
 
@@ -5577,9 +5577,9 @@ void pevent_print_event(struct tep_handle *pevent, struct trace_seq *s,
 		return;
 	}
 
-	pevent_print_event_task(pevent, s, event, record);
-	pevent_print_event_time(pevent, s, event, record, use_trace_clock);
-	pevent_print_event_data(pevent, s, event, record);
+	tep_print_event_task(pevent, s, event, record);
+	tep_print_event_time(pevent, s, event, record, use_trace_clock);
+	tep_print_event_data(pevent, s, event, record);
 }
 
 static int events_id_cmp(const void *a, const void *b)
@@ -6388,7 +6388,7 @@ int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
 }
 
 /**
- * pevent_print_num_field - print a field and a format
+ * tep_print_num_field - print a field and a format
  * @s: The seq to print to
  * @fmt: The printf format to print the field with.
  * @event: the event that the field is for
@@ -6398,9 +6398,9 @@ int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
  *
  * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
  */
-int pevent_print_num_field(struct trace_seq *s, const char *fmt,
-			   struct event_format *event, const char *name,
-			   struct tep_record *record, int err)
+int tep_print_num_field(struct trace_seq *s, const char *fmt,
+			struct event_format *event, const char *name,
+			struct tep_record *record, int err)
 {
 	struct format_field *field = tep_find_field(event, name);
 	unsigned long long val;
@@ -6420,7 +6420,7 @@ int pevent_print_num_field(struct trace_seq *s, const char *fmt,
 }
 
 /**
- * pevent_print_func_field - print a field and a format for function pointers
+ * tep_print_func_field - print a field and a format for function pointers
  * @s: The seq to print to
  * @fmt: The printf format to print the field with.
  * @event: the event that the field is for
@@ -6430,9 +6430,9 @@ int pevent_print_num_field(struct trace_seq *s, const char *fmt,
  *
  * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
  */
-int pevent_print_func_field(struct trace_seq *s, const char *fmt,
-			    struct event_format *event, const char *name,
-			    struct tep_record *record, int err)
+int tep_print_func_field(struct trace_seq *s, const char *fmt,
+			 struct event_format *event, const char *name,
+			 struct tep_record *record, int err)
 {
 	struct format_field *field = tep_find_field(event, name);
 	struct tep_handle *pevent = event->pevent;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index eae429a98f7a..fb7f2277bbec 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -626,18 +626,18 @@ int pevent_register_print_string(struct tep_handle *pevent, const char *fmt,
 				 unsigned long long addr);
 int pevent_pid_is_registered(struct tep_handle *pevent, int pid);
 
-void pevent_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
-			     struct event_format *event,
-			     struct tep_record *record);
-void pevent_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
-			     struct event_format *event,
-			     struct tep_record *record,
-			     bool use_trace_clock);
-void pevent_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
-			     struct event_format *event,
-			     struct tep_record *record);
-void pevent_print_event(struct tep_handle *pevent, struct trace_seq *s,
-			struct tep_record *record, bool use_trace_clock);
+void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
+			  struct event_format *event,
+			  struct tep_record *record);
+void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
+			  struct event_format *event,
+			  struct tep_record *record,
+			  bool use_trace_clock);
+void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
+			  struct event_format *event,
+			  struct tep_record *record);
+void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
+		     struct tep_record *record, bool use_trace_clock);
 
 int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
 			  int long_size);
@@ -665,13 +665,13 @@ int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
 			     const char *name, struct tep_record *record,
 			     unsigned long long *val, int err);
 
-int pevent_print_num_field(struct trace_seq *s, const char *fmt,
+int tep_print_num_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
 			   struct tep_record *record, int err);
 
-int pevent_print_func_field(struct trace_seq *s, const char *fmt,
-			   struct event_format *event, const char *name,
-			   struct tep_record *record, int err);
+int tep_print_func_field(struct trace_seq *s, const char *fmt,
+			 struct event_format *event, const char *name,
+			 struct tep_record *record, int err);
 
 int pevent_register_event_handler(struct tep_handle *pevent, int id,
 				  const char *sys_name, const char *event_name,
@@ -718,10 +718,10 @@ struct cmdline *pevent_data_pid_from_comm(struct tep_handle *pevent, const char
 					  struct cmdline *next);
 int pevent_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline);
 
-void pevent_print_field(struct trace_seq *s, void *data,
-			struct format_field *field);
-void pevent_print_fields(struct trace_seq *s, void *data,
-			 int size __maybe_unused, struct event_format *event);
+void tep_print_field(struct trace_seq *s, void *data,
+		     struct format_field *field);
+void tep_print_fields(struct trace_seq *s, void *data,
+		      int size __maybe_unused, struct event_format *event);
 void tep_event_info(struct trace_seq *s, struct event_format *event,
 		       struct tep_record *record);
 int pevent_strerror(struct tep_handle *pevent, enum pevent_errno errnum,
@@ -805,8 +805,8 @@ const char *pevent_get_input_buf(void);
 unsigned long long pevent_get_input_buf_ptr(void);
 
 /* for debugging */
-void pevent_print_funcs(struct tep_handle *pevent);
-void pevent_print_printk(struct tep_handle *pevent);
+void tep_print_funcs(struct tep_handle *pevent);
+void tep_print_printk(struct tep_handle *pevent);
 
 /* ----------------------- filtering ----------------------- */
 
diff --git a/tools/lib/traceevent/plugin_hrtimer.c b/tools/lib/traceevent/plugin_hrtimer.c
index 5704d56c6f6f..a37180eef959 100644
--- a/tools/lib/traceevent/plugin_hrtimer.c
+++ b/tools/lib/traceevent/plugin_hrtimer.c
@@ -30,16 +30,16 @@ static int timer_expire_handler(struct trace_seq *s,
 {
 	trace_seq_printf(s, "hrtimer=");
 
-	if (pevent_print_num_field(s, "0x%llx", event, "timer",
-				   record, 0) == -1)
-		pevent_print_num_field(s, "0x%llx", event, "hrtimer",
-				       record, 1);
+	if (tep_print_num_field(s, "0x%llx", event, "timer",
+				record, 0) == -1)
+		tep_print_num_field(s, "0x%llx", event, "hrtimer",
+				    record, 1);
 
 	trace_seq_printf(s, " now=");
 
-	pevent_print_num_field(s, "%llu", event, "now", record, 1);
+	tep_print_num_field(s, "%llu", event, "now", record, 1);
 
-	pevent_print_func_field(s, " function=%s", event, "function",
+	tep_print_func_field(s, " function=%s", event, "function",
 				record, 0);
 	return 0;
 }
@@ -50,19 +50,19 @@ static int timer_start_handler(struct trace_seq *s,
 {
 	trace_seq_printf(s, "hrtimer=");
 
-	if (pevent_print_num_field(s, "0x%llx", event, "timer",
-				   record, 0) == -1)
-		pevent_print_num_field(s, "0x%llx", event, "hrtimer",
-				       record, 1);
+	if (tep_print_num_field(s, "0x%llx", event, "timer",
+				record, 0) == -1)
+		tep_print_num_field(s, "0x%llx", event, "hrtimer",
+				    record, 1);
 
-	pevent_print_func_field(s, " function=%s", event, "function",
-				record, 0);
+	tep_print_func_field(s, " function=%s", event, "function",
+			     record, 0);
 
 	trace_seq_printf(s, " expires=");
-	pevent_print_num_field(s, "%llu", event, "expires", record, 1);
+	tep_print_num_field(s, "%llu", event, "expires", record, 1);
 
 	trace_seq_printf(s, " softexpires=");
-	pevent_print_num_field(s, "%llu", event, "softexpires", record, 1);
+	tep_print_num_field(s, "%llu", event, "softexpires", record, 1);
 	return 0;
 }
 
diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index ab5439e0ad87..d71bc3fde75b 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -276,7 +276,7 @@ static int kvm_exit_handler(struct trace_seq *s, struct tep_record *record,
 	if (print_exit_reason(s, record, event, "exit_reason") < 0)
 		return -1;
 
-	pevent_print_num_field(s, " rip 0x%lx", event, "guest_rip", record, 1);
+	tep_print_num_field(s, " rip 0x%lx", event, "guest_rip", record, 1);
 
 	if (pevent_get_field_val(s, event, "info1", record, &info1, 0) >= 0
 	    && pevent_get_field_val(s, event, "info2", record, &info2, 0) >= 0)
@@ -336,10 +336,10 @@ static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct tep_reco
 	if (print_exit_reason(s, record, event, "exit_code") < 0)
 		return -1;
 
-	pevent_print_num_field(s, " info1 %llx", event, "exit_info1", record, 1);
-	pevent_print_num_field(s, " info2 %llx", event, "exit_info2", record, 1);
-	pevent_print_num_field(s, " int_info %llx", event, "exit_int_info", record, 1);
-	pevent_print_num_field(s, " int_info_err %llx", event, "exit_int_info_err", record, 1);
+	tep_print_num_field(s, " info1 %llx", event, "exit_info1", record, 1);
+	tep_print_num_field(s, " info2 %llx", event, "exit_info2", record, 1);
+	tep_print_num_field(s, " int_info %llx", event, "exit_int_info", record, 1);
+	tep_print_num_field(s, " int_info_err %llx", event, "exit_int_info_err", record, 1);
 
 	return 0;
 }
@@ -347,7 +347,7 @@ static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct tep_reco
 static int kvm_nested_vmexit_handler(struct trace_seq *s, struct tep_record *record,
 				     struct event_format *event, void *context)
 {
-	pevent_print_num_field(s, "rip %llx ", event, "rip", record, 1);
+	tep_print_num_field(s, "rip %llx ", event, "rip", record, 1);
 
 	return kvm_nested_vmexit_inject_handler(s, record, event, context);
 }
@@ -406,8 +406,8 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 	} else
 		trace_seq_printf(s, "WORD: %08x", role.word);
 
-	pevent_print_num_field(s, " root %u ",  event,
-			       "root_count", record, 1);
+	tep_print_num_field(s, " root %u ",  event,
+			    "root_count", record, 1);
 
 	if (pevent_get_field_val(s, event, "unsync", record, &val, 1) < 0)
 		return -1;
diff --git a/tools/lib/traceevent/plugin_mac80211.c b/tools/lib/traceevent/plugin_mac80211.c
index dd5c7fc0193f..611250300855 100644
--- a/tools/lib/traceevent/plugin_mac80211.c
+++ b/tools/lib/traceevent/plugin_mac80211.c
@@ -53,8 +53,8 @@ static void print_string(struct trace_seq *s, struct event_format *event,
 	trace_seq_printf(s, "%.*s", length, (char *)data + offset);
 }
 
-#define SF(fn)	pevent_print_num_field(s, fn ":%d", event, fn, record, 0)
-#define SFX(fn)	pevent_print_num_field(s, fn ":%#x", event, fn, record, 0)
+#define SF(fn)	tep_print_num_field(s, fn ":%d", event, fn, record, 0)
+#define SFX(fn)	tep_print_num_field(s, fn ":%#x", event, fn, record, 0)
 #define SP()	trace_seq_putc(s, ' ')
 
 static int drv_bss_info_changed(struct trace_seq *s,
@@ -66,7 +66,7 @@ static int drv_bss_info_changed(struct trace_seq *s,
 	print_string(s, event, "wiphy_name", data);
 	trace_seq_printf(s, " vif:");
 	print_string(s, event, "vif_name", data);
-	pevent_print_num_field(s, "(%d)", event, "vif_type", record, 1);
+	tep_print_num_field(s, "(%d)", event, "vif_type", record, 1);
 
 	trace_seq_printf(s, "\n%*s", INDENT, "");
 	SF("assoc"); SP();
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index f27087d06f52..93bc9b1860af 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -610,8 +610,8 @@ static char *get_trace_output(struct hist_entry *he)
 
 	trace_seq_init(&seq);
 	if (symbol_conf.raw_trace) {
-		pevent_print_fields(&seq, he->raw_data, he->raw_size,
-				    evsel->tp_format);
+		tep_print_fields(&seq, he->raw_data, he->raw_size,
+				 evsel->tp_format);
 	} else {
 		tep_event_info(&seq, evsel->tp_format, &rec);
 	}
@@ -2047,7 +2047,7 @@ static int __sort__hde_entry(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 		struct trace_seq seq;
 raw_field:
 		trace_seq_init(&seq);
-		pevent_print_field(&seq, he->raw_data, hde->field);
+		tep_print_field(&seq, he->raw_data, hde->field);
 		str = seq.buffer;
 	}
 
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index a89a50dee8e7..850f7bf0eced 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -479,9 +479,9 @@ ssize_t trace_report(int fd, struct trace_event *tevent, bool __repipe)
 	repipe = false;
 
 	if (show_funcs) {
-		pevent_print_funcs(pevent);
+		tep_print_funcs(pevent);
 	} else if (show_printk) {
-		pevent_print_printk(pevent);
+		tep_print_printk(pevent);
 	}
 
 	pevent = NULL;
-- 
2.17.1
