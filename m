Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37384 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbeHTRvQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 13:51:16 -0400
Received: by mail-wm0-f67.google.com with SMTP id n11-v6so14084934wmc.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Aug 2018 07:35:20 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 07/24] trace-cmd: Rename pevent print APIs
Date: Mon, 20 Aug 2018 17:34:48 +0300
Message-Id: <20180820143505.11525-8-tz.stoyanov@gmail.com>
In-Reply-To: <20180820143505.11525-1-tz.stoyanov@gmail.com>
References: <20180820143505.11525-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_print_field, pevent_print_fields, pevent_print_funcs,
pevent_print_printk

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h | 44 +++++++++----------
 kernel-shark/trace-dialog.c      |  4 +-
 lib/traceevent/event-parse.c     | 74 ++++++++++++++++----------------
 plugins/plugin_hrtimer.c         | 18 ++++----
 plugins/plugin_kvm.c             | 16 +++----
 plugins/plugin_mac80211.c        |  8 ++--
 plugins/plugin_tlb.c             |  2 +-
 tracecmd/trace-read.c            | 20 ++++-----
 8 files changed, 93 insertions(+), 93 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 93b040e..11dd41b 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -614,18 +614,18 @@ int pevent_register_print_string(struct tep_handle *pevent, const char *fmt,
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
@@ -653,13 +653,13 @@ int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
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
@@ -706,10 +706,10 @@ struct cmdline *pevent_data_pid_from_comm(struct tep_handle *pevent, const char
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
@@ -793,8 +793,8 @@ const char *pevent_get_input_buf(void);
 unsigned long long pevent_get_input_buf_ptr(void);
 
 /* for debugging */
-void pevent_print_funcs(struct tep_handle *pevent);
-void pevent_print_printk(struct tep_handle *pevent);
+void tep_print_funcs(struct tep_handle *pevent);
+void tep_print_printk(struct tep_handle *pevent);
 
 /* ----------------------- filtering ----------------------- */
 
diff --git a/kernel-shark/trace-dialog.c b/kernel-shark/trace-dialog.c
index c9f8eec..9298078 100644
--- a/kernel-shark/trace-dialog.c
+++ b/kernel-shark/trace-dialog.c
@@ -385,7 +385,7 @@ static void read_raw_events(struct trace_seq *s,
 
 	for (i = 0; fields[i]; i++) {
 		trace_seq_printf(s, "%s: ", fields[i]->name);
-		pevent_print_field(s, record->data, fields[i]);
+		tep_print_field(s, record->data, fields[i]);
 		trace_seq_putc(s, '\n');
 	}
 
@@ -407,7 +407,7 @@ void trace_show_record_dialog(GtkWindow *parent, struct tep_handle *pevent,
 	if (raw)
 		read_raw_events(&s, event, record);
 	else
-		pevent_print_event(pevent, &s, record, FALSE);
+		tep_print_event(pevent, &s, record, FALSE);
 
 	if (s.buffer_size) {
 		trace_seq_terminate(&s);
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 49689b2..f59dc6e 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -575,12 +575,12 @@ out_free:
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
 
@@ -718,12 +718,12 @@ out_free:
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
 
@@ -4786,8 +4786,8 @@ static int is_printable_array(char *p, unsigned int len)
 	return 1;
 }
 
-void pevent_print_field(struct trace_seq *s, void *data,
-			struct format_field *field)
+void tep_print_field(struct trace_seq *s, void *data,
+		     struct format_field *field)
 {
 	unsigned long long val;
 	unsigned int offset, len, i;
@@ -4851,15 +4851,15 @@ void pevent_print_field(struct trace_seq *s, void *data,
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
@@ -4885,7 +4885,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 
 	if (event->flags & EVENT_FL_FAILED) {
 		trace_seq_printf(s, "[FAILED TO PARSE]");
-		pevent_print_fields(s, data, size, event);
+		tep_print_fields(s, data, size, event);
 		return;
 	}
 
@@ -5391,7 +5391,7 @@ void tep_event_info(struct trace_seq *s, struct event_format *event,
 	int print_pretty = 1;
 
 	if (event->pevent->print_raw || (event->flags & EVENT_FL_PRINTRAW))
-		pevent_print_fields(s, record->data, record->size, event);
+		tep_print_fields(s, record->data, record->size, event);
 	else {
 
 		if (event->handler && !(event->flags & EVENT_FL_NOHANDLE))
@@ -5442,7 +5442,7 @@ pevent_find_event_by_record(struct tep_handle *pevent, struct tep_record *record
 }
 
 /**
- * pevent_print_event_task - Write the event task comm, pid and CPU
+ * tep_print_event_task - Write the event task comm, pid and CPU
  * @pevent: a handle to the pevent
  * @s: the trace_seq to write to
  * @event: the handle to the record's event
@@ -5450,9 +5450,9 @@ pevent_find_event_by_record(struct tep_handle *pevent, struct tep_record *record
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
@@ -5469,7 +5469,7 @@ void pevent_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
 }
 
 /**
- * pevent_print_event_time - Write the event timestamp
+ * tep_print_event_time - Write the event timestamp
  * @pevent: a handle to the pevent
  * @s: the trace_seq to write to
  * @event: the handle to the record's event
@@ -5478,10 +5478,10 @@ void pevent_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
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
@@ -5520,7 +5520,7 @@ void pevent_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 }
 
 /**
- * pevent_print_event_data - Write the event data section
+ * tep_print_event_data - Write the event data section
  * @pevent: a handle to the pevent
  * @s: the trace_seq to write to
  * @event: the handle to the record's event
@@ -5528,9 +5528,9 @@ void pevent_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
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
@@ -5545,8 +5545,8 @@ void pevent_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 	tep_event_info(s, event, record);
 }
 
-void pevent_print_event(struct tep_handle *pevent, struct trace_seq *s,
-			struct tep_record *record, bool use_trace_clock)
+void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
+		     struct tep_record *record, bool use_trace_clock)
 {
 	struct event_format *event;
 
@@ -5563,9 +5563,9 @@ void pevent_print_event(struct tep_handle *pevent, struct trace_seq *s,
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
@@ -6374,7 +6374,7 @@ int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
 }
 
 /**
- * pevent_print_num_field - print a field and a format
+ * tep_print_num_field - print a field and a format
  * @s: The seq to print to
  * @fmt: The printf format to print the field with.
  * @event: the event that the field is for
@@ -6384,9 +6384,9 @@ int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
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
@@ -6406,7 +6406,7 @@ int pevent_print_num_field(struct trace_seq *s, const char *fmt,
 }
 
 /**
- * pevent_print_func_field - print a field and a format for function pointers
+ * tep_print_func_field - print a field and a format for function pointers
  * @s: The seq to print to
  * @fmt: The printf format to print the field with.
  * @event: the event that the field is for
@@ -6416,9 +6416,9 @@ int pevent_print_num_field(struct trace_seq *s, const char *fmt,
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
diff --git a/plugins/plugin_hrtimer.c b/plugins/plugin_hrtimer.c
index fd067e0..f3a0ceb 100644
--- a/plugins/plugin_hrtimer.c
+++ b/plugins/plugin_hrtimer.c
@@ -14,14 +14,14 @@ static int timer_expire_handler(struct trace_seq *s, struct tep_record *record,
 {
 	trace_seq_printf(s, "hrtimer=");
 
-	if (pevent_print_num_field(s, "0x%llx", event, "timer", record, 0) == -1)
-		pevent_print_num_field(s, "0x%llx", event, "hrtimer", record, 1);
+	if (tep_print_num_field(s, "0x%llx", event, "timer", record, 0) == -1)
+		tep_print_num_field(s, "0x%llx", event, "hrtimer", record, 1);
 
 	trace_seq_printf(s, " now=");
 
-	pevent_print_num_field(s, "%llu", event, "now", record, 1);
+	tep_print_num_field(s, "%llu", event, "now", record, 1);
 
-	pevent_print_func_field(s, " function=%s", event, "function", record, 0);
+	tep_print_func_field(s, " function=%s", event, "function", record, 0);
 
 	return 0;
 }
@@ -31,17 +31,17 @@ static int timer_start_handler(struct trace_seq *s, struct tep_record *record,
 {
 	trace_seq_printf(s, "hrtimer=");
 
-	if (pevent_print_num_field(s, "0x%llx", event, "timer", record, 0) == -1)
-		pevent_print_num_field(s, "0x%llx", event, "hrtimer", record, 1);
+	if (tep_print_num_field(s, "0x%llx", event, "timer", record, 0) == -1)
+		tep_print_num_field(s, "0x%llx", event, "hrtimer", record, 1);
 
-	pevent_print_func_field(s, " function=%s", event, "function",
+	tep_print_func_field(s, " function=%s", event, "function",
 				record, 0);
 
 	trace_seq_printf(s, " expires=");
-	pevent_print_num_field(s, "%llu", event, "expires", record, 1);
+	tep_print_num_field(s, "%llu", event, "expires", record, 1);
 
 	trace_seq_printf(s, " softexpires=");
-	pevent_print_num_field(s, "%llu", event, "softexpires", record, 1);
+	tep_print_num_field(s, "%llu", event, "softexpires", record, 1);
 
 	return 0;
 }
diff --git a/plugins/plugin_kvm.c b/plugins/plugin_kvm.c
index 686ba6a..0244768 100644
--- a/plugins/plugin_kvm.c
+++ b/plugins/plugin_kvm.c
@@ -277,7 +277,7 @@ static int kvm_exit_handler(struct trace_seq *s, struct tep_record *record,
 	if (print_exit_reason(s, record, event, "exit_reason") < 0)
 		return -1;
 
-	pevent_print_num_field(s, " rip 0x%lx", event, "guest_rip", record, 1);
+	tep_print_num_field(s, " rip 0x%lx", event, "guest_rip", record, 1);
 
 	if (pevent_get_field_val(s, event, "info1", record, &info1, 0) >= 0
 	    && pevent_get_field_val(s, event, "info2", record, &info2, 0) >= 0)
@@ -337,10 +337,10 @@ static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct tep_reco
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
@@ -348,7 +348,7 @@ static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct tep_reco
 static int kvm_nested_vmexit_handler(struct trace_seq *s, struct tep_record *record,
 				     struct event_format *event, void *context)
 {
-	pevent_print_num_field(s, "rip %lx ", event, "rip", record, 1);
+	tep_print_num_field(s, "rip %lx ", event, "rip", record, 1);
 
 	return kvm_nested_vmexit_inject_handler(s, record, event, context);
 }
@@ -400,8 +400,8 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 	} else
 		trace_seq_printf(s, "WORD: %08x", role.word);
 
-	pevent_print_num_field(s, " root %u ",  event,
-			       "root_count", record, 1);
+	tep_print_num_field(s, " root %u ",  event,
+			    "root_count", record, 1);
 
 	if (pevent_get_field_val(s, event, "unsync", record, &val, 1) < 0)
 		return -1;
diff --git a/plugins/plugin_mac80211.c b/plugins/plugin_mac80211.c
index ba81e29..0cb9c95 100644
--- a/plugins/plugin_mac80211.c
+++ b/plugins/plugin_mac80211.c
@@ -119,8 +119,8 @@ static void _print_flag(struct trace_seq *s, struct event_format *event,
 	_print_flag(s, ev, name, data, __n, sizeof(__n)/sizeof(__n[0]));	\
 	})
 
-#define SF(fn)	pevent_print_num_field(s, fn ":%d", event, fn, record, 0)
-#define SFX(fn)	pevent_print_num_field(s, fn ":%#x", event, fn, record, 0)
+#define SF(fn)	tep_print_num_field(s, fn ":%d", event, fn, record, 0)
+#define SFX(fn)	tep_print_num_field(s, fn ":%#x", event, fn, record, 0)
 #define SP()	trace_seq_putc(s, ' ')
 
 static int drv_bss_info_changed(struct trace_seq *s, struct tep_record *record,
@@ -131,7 +131,7 @@ static int drv_bss_info_changed(struct trace_seq *s, struct tep_record *record,
 	print_string(s, event, "wiphy_name", data);
 	trace_seq_printf(s, " vif:");
 	print_string(s, event, "vif_name", data);
-	pevent_print_num_field(s, "(%d)", event, "vif_type", record, 1);
+	tep_print_num_field(s, "(%d)", event, "vif_type", record, 1);
 
 	trace_seq_printf(s, "\n%*s", INDENT, "");
 	SF("assoc"); SP();
@@ -164,7 +164,7 @@ static int drv_config(struct trace_seq *s, struct tep_record *record,
 		{ 2, "IDLE" },
 		{ 3, "QOS"},
 	);
-	pevent_print_num_field(s, " chan:%d/", event, "center_freq", record, 1);
+	tep_print_num_field(s, " chan:%d/", event, "center_freq", record, 1);
 	print_enum(s, event, "channel_type", data,
 		{ 0, "noht" },
 		{ 1, "ht20" },
diff --git a/plugins/plugin_tlb.c b/plugins/plugin_tlb.c
index 4a750aa..86f4cba 100644
--- a/plugins/plugin_tlb.c
+++ b/plugins/plugin_tlb.c
@@ -23,7 +23,7 @@ static int tlb_flush_handler(struct trace_seq *s, struct tep_record *record,
 
 	trace_seq_printf(s, "pages=");
 
-	pevent_print_num_field(s, "%ld", event, "pages", record, 1);
+	tep_print_num_field(s, "%ld", event, "pages", record, 1);
 
 	if (pevent_get_field_val(s, event, "reason", record, &val, 1) < 0)
 		return -1;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 9df3f91..880656f 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -149,7 +149,7 @@ static void show_test(struct tracecmd_input *handle)
 	record = tracecmd_read_at(handle, test_read_at_offset, &cpu);
 	printf("\nHERE'S THE COPY RECORD\n");
 	trace_seq_init(&s);
-	pevent_print_event(pevent, &s, cpu, record->data, record->size, record->ts);
+	tep_print_event(pevent, &s, cpu, record->data, record->size, record->ts);
 	trace_seq_do_printf(&s);
 	trace_seq_destroy(&s);
 	printf("\n");
@@ -196,7 +196,7 @@ static void show_test(struct tracecmd_input *handle)
 	       (void *)(record->offset & ~(page_size - 1)),
 	       (void *)record->offset);
 	trace_seq_init(&s);
-	pevent_print_event(pevent, &s, cpu, record->data, record->size, record->ts);
+	tep_print_event(pevent, &s, cpu, record->data, record->size, record->ts);
 	trace_seq_do_printf(&s);
 	trace_seq_destroy(&s);
 	printf("\n");
@@ -237,7 +237,7 @@ static void show_test(struct tracecmd_input *handle)
 	printf("\nHERE'S THE FIRST RECORD with offset %p\n",
 	       (void *)record->offset);
 	trace_seq_init(&s);
-	pevent_print_event(pevent, &s, cpu, record->data, record->size, record->ts);
+	tep_print_event(pevent, &s, cpu, record->data, record->size, record->ts);
 	trace_seq_do_printf(&s);
 	trace_seq_destroy(&s);
 	printf("\n");
@@ -253,7 +253,7 @@ static void show_test(struct tracecmd_input *handle)
 	printf("\nHERE'S THE LAST RECORD with offset %p\n",
 	       (void *)record->offset);
 	trace_seq_init(&s);
-	pevent_print_event(pevent, &s, cpu, record->data, record->size, record->ts);
+	tep_print_event(pevent, &s, cpu, record->data, record->size, record->ts);
 	trace_seq_do_printf(&s);
 	trace_seq_destroy(&s);
 	printf("\n");
@@ -794,8 +794,8 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 		unsigned long long rec_ts = record->ts;
 
 		event = pevent_find_event_by_record(pevent, record);
-		pevent_print_event_task(pevent, &s, event, record);
-		pevent_print_event_time(pevent, &s, event, record,
+		tep_print_event_task(pevent, &s, event, record);
+		tep_print_event_time(pevent, &s, event, record,
 					use_trace_clock);
 		buf[0] = 0;
 		if (use_trace_clock && !(pevent->flags & PEVENT_NSEC_OUTPUT))
@@ -807,9 +807,9 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 		}
 		last_ts = rec_ts;
 		trace_seq_printf(&s, " %-8s", buf);
-		pevent_print_event_data(pevent, &s, event, record);
+		tep_print_event_data(pevent, &s, event, record);
 	} else
-		pevent_print_event(pevent, &s, record, use_trace_clock);
+		tep_print_event(pevent, &s, record, use_trace_clock);
 	if (s.len && *(s.buffer + s.len - 1) == '\n')
 		s.len--;
 	if (debug) {
@@ -1727,11 +1727,11 @@ void trace_report (int argc, char **argv)
 		}
 
 		if (show_funcs) {
-			pevent_print_funcs(pevent);
+			tep_print_funcs(pevent);
 			return;
 		}
 		if (show_printk) {
-			pevent_print_printk(pevent);
+			tep_print_printk(pevent);
 			return;
 		}
 
-- 
2.17.1
