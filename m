Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33111 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbeHTRva (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 13:51:30 -0400
Received: by mail-wr1-f68.google.com with SMTP id v90-v6so10030597wrc.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Aug 2018 07:35:34 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 19/24] trace-cmd: Rename pevent field APIs
Date: Mon, 20 Aug 2018 17:35:00 +0300
Message-Id: <20180820143505.11525-20-tz.stoyanov@gmail.com>
In-Reply-To: <20180820143505.11525-1-tz.stoyanov@gmail.com>
References: <20180820143505.11525-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_free_format, pevent_free_format_field, pevent_get_field_raw,
pevent_get_field_val, pevent_get_common_field_val, pevent_get_any_field_val

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h | 28 ++++++++++-----------
 lib/trace-cmd/trace-ftrace.c     | 34 +++++++++++++-------------
 lib/traceevent/event-parse.c     | 42 ++++++++++++++++----------------
 plugins/plugin_function.c        |  4 +--
 plugins/plugin_futex.c           | 12 ++++-----
 plugins/plugin_kvm.c             | 28 ++++++++++-----------
 plugins/plugin_sched_switch.c    | 18 +++++++-------
 plugins/plugin_tlb.c             |  2 +-
 8 files changed, 84 insertions(+), 84 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 9ad3208..e1628f5 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -636,22 +636,22 @@ enum tep_errno tep_parse_format(struct tep_handle *pevent,
 				struct event_format **eventp,
 				const char *buf,
 				unsigned long size, const char *sys);
-void pevent_free_format(struct event_format *event);
-void pevent_free_format_field(struct format_field *field);
-
-void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
-			   const char *name, struct tep_record *record,
-			   int *len, int err);
-
-int pevent_get_field_val(struct trace_seq *s, struct event_format *event,
-			 const char *name, struct tep_record *record,
-			 unsigned long long *val, int err);
-int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
-				const char *name, struct tep_record *record,
-				unsigned long long *val, int err);
-int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
+void tep_free_format(struct event_format *event);
+void tep_free_format_field(struct format_field *field);
+
+void *tep_get_field_raw(struct trace_seq *s, struct event_format *event,
+			const char *name, struct tep_record *record,
+			int *len, int err);
+
+int tep_get_field_val(struct trace_seq *s, struct event_format *event,
+		      const char *name, struct tep_record *record,
+		      unsigned long long *val, int err);
+int tep_get_common_field_val(struct trace_seq *s, struct event_format *event,
 			     const char *name, struct tep_record *record,
 			     unsigned long long *val, int err);
+int tep_get_any_field_val(struct trace_seq *s, struct event_format *event,
+			  const char *name, struct tep_record *record,
+			  unsigned long long *val, int err);
 
 int tep_print_num_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 01a2a7c..05e1200 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -69,7 +69,7 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	unsigned long long function;
 	const char *func;
 
-	if (pevent_get_field_val(s, event, "ip", record, &function, 1))
+	if (tep_get_field_val(s, event, "ip", record, &function, 1))
 		return trace_seq_putc(s, '!');
 
 	func = pevent_find_function(pevent, function);
@@ -78,7 +78,7 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	else
 		trace_seq_printf(s, "0x%llx", function);
 
-	if (pevent_get_field_val(s, event, "parent_ip", record, &function, 1))
+	if (tep_get_field_val(s, event, "parent_ip", record, &function, 1))
 		return trace_seq_putc(s, '!');
 
 	func = pevent_find_function(pevent, function);
@@ -102,20 +102,20 @@ get_return_for_leaf(struct trace_seq *s, int cpu, int cur_pid,
 	unsigned long long pid;
 
 	/* Searching a common field, can use any event */
-	if (pevent_get_common_field_val(s, finfo->fgraph_ret_event, "common_type", next, &type, 1))
+	if (tep_get_common_field_val(s, finfo->fgraph_ret_event, "common_type", next, &type, 1))
 		return NULL;
 
 	if (type != finfo->fgraph_ret_id)
 		return NULL;
 
-	if (pevent_get_common_field_val(s, finfo->fgraph_ret_event, "common_pid", next, &pid, 1))
+	if (tep_get_common_field_val(s, finfo->fgraph_ret_event, "common_pid", next, &pid, 1))
 		return NULL;
 
 	if (cur_pid != pid)
 		return NULL;
 
 	/* We aleady know this is a funcgraph_ret_event */
-	if (pevent_get_field_val(s, finfo->fgraph_ret_event, "func", next, &val, 1))
+	if (tep_get_field_val(s, finfo->fgraph_ret_event, "func", next, &val, 1))
 		return NULL;
 
 	if (cur_func != val)
@@ -200,10 +200,10 @@ print_graph_entry_leaf(struct trace_seq *s,
 	int ret;
 	int i;
 
-	if (pevent_get_field_val(s, finfo->fgraph_ret_event, "rettime", ret_rec, &rettime, 1))
+	if (tep_get_field_val(s, finfo->fgraph_ret_event, "rettime", ret_rec, &rettime, 1))
 		return trace_seq_putc(s, '!');
 
-	if (pevent_get_field_val(s, finfo->fgraph_ret_event, "calltime", ret_rec, &calltime, 1))
+	if (tep_get_field_val(s, finfo->fgraph_ret_event, "calltime", ret_rec, &calltime, 1))
 		return trace_seq_putc(s, '!');
 
 	duration = rettime - calltime;
@@ -214,14 +214,14 @@ print_graph_entry_leaf(struct trace_seq *s,
 	/* Duration */
 	print_graph_duration(s, duration);
 
-	if (pevent_get_field_val(s, event, "depth", record, &depth, 1))
+	if (tep_get_field_val(s, event, "depth", record, &depth, 1))
 		return trace_seq_putc(s, '!');
 
 	/* Function */
 	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
 		trace_seq_putc(s, ' ');
 
-	if (pevent_get_field_val(s, event, "func", record, &val, 1))
+	if (tep_get_field_val(s, event, "func", record, &val, 1))
 		return trace_seq_putc(s, '!');
 	func = pevent_find_function(pevent, val);
 
@@ -253,14 +253,14 @@ static int print_graph_nested(struct trace_seq *s,
 	/* No time */
 	trace_seq_puts(s, "           |  ");
 
-	if (pevent_get_field_val(s, event, "depth", record, &depth, 1))
+	if (tep_get_field_val(s, event, "depth", record, &depth, 1))
 		return trace_seq_putc(s, '!');
 
 	/* Function */
 	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
 		trace_seq_putc(s, ' ');
 
-	if (pevent_get_field_val(s, event, "func", record, &val, 1))
+	if (tep_get_field_val(s, event, "func", record, &val, 1))
 		return trace_seq_putc(s, '!');
 
 	func = pevent_find_function(pevent, val);
@@ -287,10 +287,10 @@ fgraph_ent_handler(struct trace_seq *s, struct tep_record *record,
 
 	ret_event_check(finfo, event->pevent);
 
-	if (pevent_get_common_field_val(s, event, "common_pid", record, &pid, 1))
+	if (tep_get_common_field_val(s, event, "common_pid", record, &pid, 1))
 		return trace_seq_putc(s, '!');
 
-	if (pevent_get_field_val(s, event, "func", record, &val, 1))
+	if (tep_get_field_val(s, event, "func", record, &val, 1))
 		return trace_seq_putc(s, '!');
 
 	rec = tracecmd_peek_next_data(tracecmd_curr_thread_handle, &cpu);
@@ -323,10 +323,10 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 
 	ret_event_check(finfo, event->pevent);
 
-	if (pevent_get_field_val(s, event, "rettime", record, &rettime, 1))
+	if (tep_get_field_val(s, event, "rettime", record, &rettime, 1))
 		return trace_seq_putc(s, '!');
 
-	if (pevent_get_field_val(s, event, "calltime", record, &calltime, 1))
+	if (tep_get_field_val(s, event, "calltime", record, &calltime, 1))
 		return trace_seq_putc(s, '!');
 
 	duration = rettime - calltime;
@@ -337,7 +337,7 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 	/* Duration */
 	print_graph_duration(s, duration);
 
-	if (pevent_get_field_val(s, event, "depth", record, &depth, 1))
+	if (tep_get_field_val(s, event, "depth", record, &depth, 1))
 		return trace_seq_putc(s, '!');
 
 	/* Function */
@@ -347,7 +347,7 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
 	trace_seq_putc(s, '}');
 
 	if (fgraph_tail->set) {
-		if (pevent_get_field_val(s, event, "func", record, &val, 0))
+		if (tep_get_field_val(s, event, "func", record, &val, 0))
 			return 0;
 		func = pevent_find_function(event->pevent, val);
 		if (!func)
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index a140fbc..63c3e76 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -6152,7 +6152,7 @@ __pevent_parse_event(struct tep_handle *pevent,
 	return 0;
 
 event_add_failed:
-	pevent_free_format(event);
+	tep_free_format(event);
 	return ret;
 }
 
@@ -6249,7 +6249,7 @@ int get_field_val(struct trace_seq *s, struct format_field *field,
 }
 
 /**
- * pevent_get_field_raw - return the raw pointer into the data field
+ * tep_get_field_raw - return the raw pointer into the data field
  * @s: The seq to print to on error
  * @event: the event that the field is for
  * @name: The name of the field
@@ -6262,9 +6262,9 @@ int get_field_val(struct trace_seq *s, struct format_field *field,
  *
  * On failure, it returns NULL.
  */
-void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
-			   const char *name, struct tep_record *record,
-			   int *len, int err)
+void *tep_get_field_raw(struct trace_seq *s, struct event_format *event,
+			const char *name, struct tep_record *record,
+			int *len, int err)
 {
 	struct format_field *field;
 	void *data = record->data;
@@ -6299,7 +6299,7 @@ void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
 }
 
 /**
- * pevent_get_field_val - find a field and return its value
+ * tep_get_field_val - find a field and return its value
  * @s: The seq to print to on error
  * @event: the event that the field is for
  * @name: The name of the field
@@ -6309,9 +6309,9 @@ void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
  *
  * Returns 0 on success -1 on field not found.
  */
-int pevent_get_field_val(struct trace_seq *s, struct event_format *event,
-			 const char *name, struct tep_record *record,
-			 unsigned long long *val, int err)
+int tep_get_field_val(struct trace_seq *s, struct event_format *event,
+		      const char *name, struct tep_record *record,
+		      unsigned long long *val, int err)
 {
 	struct format_field *field;
 
@@ -6324,7 +6324,7 @@ int pevent_get_field_val(struct trace_seq *s, struct event_format *event,
 }
 
 /**
- * pevent_get_common_field_val - find a common field and return its value
+ * tep_get_common_field_val - find a common field and return its value
  * @s: The seq to print to on error
  * @event: the event that the field is for
  * @name: The name of the field
@@ -6334,9 +6334,9 @@ int pevent_get_field_val(struct trace_seq *s, struct event_format *event,
  *
  * Returns 0 on success -1 on field not found.
  */
-int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
-				const char *name, struct tep_record *record,
-				unsigned long long *val, int err)
+int tep_get_common_field_val(struct trace_seq *s, struct event_format *event,
+			     const char *name, struct tep_record *record,
+			     unsigned long long *val, int err)
 {
 	struct format_field *field;
 
@@ -6349,7 +6349,7 @@ int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
 }
 
 /**
- * pevent_get_any_field_val - find a any field and return its value
+ * tep_get_any_field_val - find a any field and return its value
  * @s: The seq to print to on error
  * @event: the event that the field is for
  * @name: The name of the field
@@ -6359,9 +6359,9 @@ int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
  *
  * Returns 0 on success -1 on field not found.
  */
-int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
-			     const char *name, struct tep_record *record,
-			     unsigned long long *val, int err)
+int tep_get_any_field_val(struct trace_seq *s, struct event_format *event,
+			  const char *name, struct tep_record *record,
+			  unsigned long long *val, int err)
 {
 	struct format_field *field;
 
@@ -6757,7 +6757,7 @@ void pevent_ref(struct tep_handle *pevent)
 	pevent->ref_count++;
 }
 
-void pevent_free_format_field(struct format_field *field)
+void tep_free_format_field(struct format_field *field)
 {
 	free(field->type);
 	if (field->alias != field->name)
@@ -6772,7 +6772,7 @@ static void free_format_fields(struct format_field *field)
 
 	while (field) {
 		next = field->next;
-		pevent_free_format_field(field);
+		tep_free_format_field(field);
 		field = next;
 	}
 }
@@ -6783,7 +6783,7 @@ static void free_formats(struct format *format)
 	free_format_fields(format->fields);
 }
 
-void pevent_free_format(struct event_format *event)
+void tep_free_format(struct event_format *event)
 {
 	free(event->name);
 	free(event->system);
@@ -6869,7 +6869,7 @@ void tep_free(struct tep_handle *pevent)
 	}
 
 	for (i = 0; i < pevent->nr_events; i++)
-		pevent_free_format(pevent->events[i]);
+		tep_free_format(pevent->events[i]);
 
 	while (pevent->handlers) {
 		handle = pevent->handlers;
diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index f88da43..0e1f13a 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -137,12 +137,12 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	const char *parent;
 	int index = 0;
 
-	if (pevent_get_field_val(s, event, "ip", record, &function, 1))
+	if (tep_get_field_val(s, event, "ip", record, &function, 1))
 		return trace_seq_putc(s, '!');
 
 	func = pevent_find_function(pevent, function);
 
-	if (pevent_get_field_val(s, event, "parent_ip", record, &pfunction, 1))
+	if (tep_get_field_val(s, event, "parent_ip", record, &pfunction, 1))
 		return trace_seq_putc(s, '!');
 
 	parent = pevent_find_function(pevent, pfunction);
diff --git a/plugins/plugin_futex.c b/plugins/plugin_futex.c
index d060bd0..988b093 100644
--- a/plugins/plugin_futex.c
+++ b/plugins/plugin_futex.c
@@ -71,22 +71,22 @@ static int futex_handler(struct trace_seq *s, struct tep_record *record,
 	struct futex_args args;
 	unsigned long long cmd;
 
-	if (pevent_get_field_val(s, event, "uaddr", record, &args.uaddr, 1))
+	if (tep_get_field_val(s, event, "uaddr", record, &args.uaddr, 1))
 		return 1;
 
-	if (pevent_get_field_val(s, event, "op", record, &args.op, 1))
+	if (tep_get_field_val(s, event, "op", record, &args.op, 1))
 		return 1;
 
-	if (pevent_get_field_val(s, event, "val", record, &args.val, 1))
+	if (tep_get_field_val(s, event, "val", record, &args.val, 1))
 		return 1;
 
-	if (pevent_get_field_val(s, event, "utime", record, &args.utime, 1))
+	if (tep_get_field_val(s, event, "utime", record, &args.utime, 1))
 		return 1;
 
-	if (pevent_get_field_val(s, event, "uaddr2", record, &args.uaddr2, 1))
+	if (tep_get_field_val(s, event, "uaddr2", record, &args.uaddr2, 1))
 		return 1;
 
-	if (pevent_get_field_val(s, event, "val3", record, &args.val3, 1))
+	if (tep_get_field_val(s, event, "val3", record, &args.val3, 1))
 		return 1;
 
 	cmd = args.op & FUTEX_CMD_MASK;
diff --git a/plugins/plugin_kvm.c b/plugins/plugin_kvm.c
index 2c1a8a7..b19311d 100644
--- a/plugins/plugin_kvm.c
+++ b/plugins/plugin_kvm.c
@@ -255,10 +255,10 @@ static int print_exit_reason(struct trace_seq *s, struct tep_record *record,
 	unsigned long long val;
 	const char *reason;
 
-	if (pevent_get_field_val(s, event, field, record, &val, 1) < 0)
+	if (tep_get_field_val(s, event, field, record, &val, 1) < 0)
 		return -1;
 
-	if (pevent_get_field_val(s, event, "isa", record, &isa, 0) < 0)
+	if (tep_get_field_val(s, event, "isa", record, &isa, 0) < 0)
 		isa = 1;
 
 	reason = find_exit_reason(isa, val);
@@ -279,8 +279,8 @@ static int kvm_exit_handler(struct trace_seq *s, struct tep_record *record,
 
 	tep_print_num_field(s, " rip 0x%lx", event, "guest_rip", record, 1);
 
-	if (pevent_get_field_val(s, event, "info1", record, &info1, 0) >= 0
-	    && pevent_get_field_val(s, event, "info2", record, &info2, 0) >= 0)
+	if (tep_get_field_val(s, event, "info1", record, &info1, 0) >= 0
+	    && tep_get_field_val(s, event, "info2", record, &info2, 0) >= 0)
 		trace_seq_printf(s, " info %llx %llx\n", info1, info2);
 
 	return 0;
@@ -299,22 +299,22 @@ static int kvm_emulate_insn_handler(struct trace_seq *s, struct tep_record *reco
 	uint8_t *insn;
 	const char *disasm;
 
-	if (pevent_get_field_val(s, event, "rip", record, &rip, 1) < 0)
+	if (tep_get_field_val(s, event, "rip", record, &rip, 1) < 0)
 		return -1;
 
-	if (pevent_get_field_val(s, event, "csbase", record, &csbase, 1) < 0)
+	if (tep_get_field_val(s, event, "csbase", record, &csbase, 1) < 0)
 		return -1;
 
-	if (pevent_get_field_val(s, event, "len", record, &len, 1) < 0)
+	if (tep_get_field_val(s, event, "len", record, &len, 1) < 0)
 		return -1;
 
-	if (pevent_get_field_val(s, event, "flags", record, &flags, 1) < 0)
+	if (tep_get_field_val(s, event, "flags", record, &flags, 1) < 0)
 		return -1;
 
-	if (pevent_get_field_val(s, event, "failed", record, &failed, 1) < 0)
+	if (tep_get_field_val(s, event, "failed", record, &failed, 1) < 0)
 		return -1;
 
-	insn = pevent_get_field_raw(s, event, "insn", record, &llen, 1);
+	insn = tep_get_field_raw(s, event, "insn", record, &llen, 1);
 	if (!insn)
 		return -1;
 
@@ -376,7 +376,7 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 		{ "---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux" };
 	union kvm_mmu_page_role role;
 
-	if (pevent_get_field_val(s, event, "role", record, &val, 1) < 0)
+	if (tep_get_field_val(s, event, "role", record, &val, 1) < 0)
 		return -1;
 
 	role.word = (int)val;
@@ -403,7 +403,7 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 	tep_print_num_field(s, " root %u ",  event,
 			    "root_count", record, 1);
 
-	if (pevent_get_field_val(s, event, "unsync", record, &val, 1) < 0)
+	if (tep_get_field_val(s, event, "unsync", record, &val, 1) < 0)
 		return -1;
 
 	trace_seq_printf(s, "%s%c",  val ? "unsync" : "sync", 0);
@@ -415,12 +415,12 @@ static int kvm_mmu_get_page_handler(struct trace_seq *s, struct tep_record *reco
 {
 	unsigned long long val;
 
-	if (pevent_get_field_val(s, event, "created", record, &val, 1) < 0)
+	if (tep_get_field_val(s, event, "created", record, &val, 1) < 0)
 		return -1;
 
 	trace_seq_printf(s, "%s ", val ? "new" : "existing");
 
-	if (pevent_get_field_val(s, event, "gfn", record, &val, 1) < 0)
+	if (tep_get_field_val(s, event, "gfn", record, &val, 1) < 0)
 		return -1;
 
 	trace_seq_printf(s, "sp gfn %llx ", val);
diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index f1229b8..715587a 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -55,7 +55,7 @@ static int sched_wakeup_handler(struct trace_seq *s, struct tep_record *record,
 	struct format_field *field;
 	unsigned long long val;
 
-	if (pevent_get_field_val(s, event, "pid", record, &val, 1))
+	if (tep_get_field_val(s, event, "pid", record, &val, 1))
 		return trace_seq_putc(s, '!');
 
 	field = tep_find_any_field(event, "comm");
@@ -65,13 +65,13 @@ static int sched_wakeup_handler(struct trace_seq *s, struct tep_record *record,
 	}
 	trace_seq_printf(s, "%lld", val);
 
-	if (pevent_get_field_val(s, event, "prio", record, &val, 0) == 0)
+	if (tep_get_field_val(s, event, "prio", record, &val, 0) == 0)
 		trace_seq_printf(s, " [%lld]", val);
 
-	if (pevent_get_field_val(s, event, "success", record, &val, 1) == 0)
+	if (tep_get_field_val(s, event, "success", record, &val, 1) == 0)
 		trace_seq_printf(s, " success=%lld", val);
 
-	if (pevent_get_field_val(s, event, "target_cpu", record, &val, 0) == 0)
+	if (tep_get_field_val(s, event, "target_cpu", record, &val, 0) == 0)
 		trace_seq_printf(s, " CPU:%03llu", val);
 
 	return 0;
@@ -83,7 +83,7 @@ static int sched_switch_handler(struct trace_seq *s, struct tep_record *record,
 	struct format_field *field;
 	unsigned long long val;
 
-	if (pevent_get_field_val(s, event, "prev_pid", record, &val, 1))
+	if (tep_get_field_val(s, event, "prev_pid", record, &val, 1))
 		return trace_seq_putc(s, '!');
 
 	field = tep_find_any_field(event, "prev_comm");
@@ -93,15 +93,15 @@ static int sched_switch_handler(struct trace_seq *s, struct tep_record *record,
 	}
 	trace_seq_printf(s, "%lld ", val);
 
-	if (pevent_get_field_val(s, event, "prev_prio", record, &val, 0) == 0)
+	if (tep_get_field_val(s, event, "prev_prio", record, &val, 0) == 0)
 		trace_seq_printf(s, "[%lld] ", val);
 
-	if (pevent_get_field_val(s,  event, "prev_state", record, &val, 0) == 0)
+	if (tep_get_field_val(s,  event, "prev_state", record, &val, 0) == 0)
 		write_state(s, val);
 
 	trace_seq_puts(s, " ==> ");
 
-	if (pevent_get_field_val(s, event, "next_pid", record, &val, 1))
+	if (tep_get_field_val(s, event, "next_pid", record, &val, 1))
 		return trace_seq_putc(s, '!');
 
 	field = tep_find_any_field(event, "next_comm");
@@ -111,7 +111,7 @@ static int sched_switch_handler(struct trace_seq *s, struct tep_record *record,
 	}
 	trace_seq_printf(s, "%lld", val);
 
-	if (pevent_get_field_val(s, event, "next_prio", record, &val, 0) == 0)
+	if (tep_get_field_val(s, event, "next_prio", record, &val, 0) == 0)
 		trace_seq_printf(s, " [%lld]", val);
 
 	return 0;
diff --git a/plugins/plugin_tlb.c b/plugins/plugin_tlb.c
index 9f1a70a..14afa18 100644
--- a/plugins/plugin_tlb.c
+++ b/plugins/plugin_tlb.c
@@ -25,7 +25,7 @@ static int tlb_flush_handler(struct trace_seq *s, struct tep_record *record,
 
 	tep_print_num_field(s, "%ld", event, "pages", record, 1);
 
-	if (pevent_get_field_val(s, event, "reason", record, &val, 1) < 0)
+	if (tep_get_field_val(s, event, "reason", record, &val, 1) < 0)
 		return -1;
 
 	trace_seq_puts(s, " reason=");
-- 
2.17.1
