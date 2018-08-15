Return-Path: <SRS0=+9rX=K6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:49654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729487AbeHOR7m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Aug 2018 13:59:42 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Clark Williams <williams@redhat.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/35] tools lib traceevent, perf tools: Rename 'struct pevent_record' to 'struct tep_record'
Date: Wed, 15 Aug 2018 12:05:39 -0300
Message-Id: <20180815150611.32080-4-acme@kernel.org>
In-Reply-To: <20180815150611.32080-1-acme@kernel.org>
References: <20180815150611.32080-1-acme@kernel.org>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

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
 tools/lib/traceevent/event-parse.c         | 36 ++++++++++++------------
 tools/lib/traceevent/event-parse.h         | 44 +++++++++++++++---------------
 tools/lib/traceevent/parse-filter.c        | 24 ++++++++--------
 tools/lib/traceevent/plugin_function.c     |  2 +-
 tools/lib/traceevent/plugin_hrtimer.c      |  4 +--
 tools/lib/traceevent/plugin_kmem.c         |  2 +-
 tools/lib/traceevent/plugin_kvm.c          | 14 +++++-----
 tools/lib/traceevent/plugin_mac80211.c     |  2 +-
 tools/lib/traceevent/plugin_sched_switch.c |  6 ++--
 tools/perf/builtin-kmem.c                  |  2 +-
 tools/perf/util/sort.c                     |  2 +-
 tools/perf/util/trace-event-parse.c        |  2 +-
 12 files changed, 70 insertions(+), 70 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 1eec313cc447..90f30f9dde14 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5150,7 +5150,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
  * and lock depth) and places it into the trace_seq.
  */
 void pevent_data_lat_fmt(struct tep_handle *pevent,
-			 struct trace_seq *s, struct pevent_record *record)
+			 struct trace_seq *s, struct tep_record *record)
 {
 	static int check_lock_depth = 1;
 	static int check_migrate_disable = 1;
@@ -5229,7 +5229,7 @@ void pevent_data_lat_fmt(struct tep_handle *pevent,
  *
  * This returns the event id from the @rec.
  */
-int pevent_data_type(struct tep_handle *pevent, struct pevent_record *rec)
+int pevent_data_type(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return trace_parse_common_type(pevent, rec->data);
 }
@@ -5253,7 +5253,7 @@ struct event_format *pevent_data_event_from_type(struct tep_handle *pevent, int
  *
  * This returns the PID from a record.
  */
-int pevent_data_pid(struct tep_handle *pevent, struct pevent_record *rec)
+int pevent_data_pid(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return parse_common_pid(pevent, rec->data);
 }
@@ -5265,7 +5265,7 @@ int pevent_data_pid(struct tep_handle *pevent, struct pevent_record *rec)
  *
  * This returns the preempt count from a record.
  */
-int pevent_data_preempt_count(struct tep_handle *pevent, struct pevent_record *rec)
+int pevent_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return parse_common_pc(pevent, rec->data);
 }
@@ -5279,7 +5279,7 @@ int pevent_data_preempt_count(struct tep_handle *pevent, struct pevent_record *r
  *
  *  Use trace_flag_type enum for the flags (see event-parse.h).
  */
-int pevent_data_flags(struct tep_handle *pevent, struct pevent_record *rec)
+int pevent_data_flags(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return parse_common_flags(pevent, rec->data);
 }
@@ -5400,7 +5400,7 @@ int pevent_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline)
  * writes the print format into the trace_seq.
  */
 void pevent_event_info(struct trace_seq *s, struct event_format *event,
-		       struct pevent_record *record)
+		       struct tep_record *record)
 {
 	int print_pretty = 1;
 
@@ -5441,7 +5441,7 @@ static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
  * is found.
  */
 struct event_format *
-pevent_find_event_by_record(struct tep_handle *pevent, struct pevent_record *record)
+pevent_find_event_by_record(struct tep_handle *pevent, struct tep_record *record)
 {
 	int type;
 
@@ -5466,7 +5466,7 @@ pevent_find_event_by_record(struct tep_handle *pevent, struct pevent_record *rec
  */
 void pevent_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
 			     struct event_format *event,
-			     struct pevent_record *record)
+			     struct tep_record *record)
 {
 	void *data = record->data;
 	const char *comm;
@@ -5494,7 +5494,7 @@ void pevent_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
  */
 void pevent_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 			     struct event_format *event,
-			     struct pevent_record *record,
+			     struct tep_record *record,
 			     bool use_trace_clock)
 {
 	unsigned long secs;
@@ -5544,7 +5544,7 @@ void pevent_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
  */
 void pevent_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 			     struct event_format *event,
-			     struct pevent_record *record)
+			     struct tep_record *record)
 {
 	static const char *spaces = "                    "; /* 20 spaces */
 	int len;
@@ -5560,7 +5560,7 @@ void pevent_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 }
 
 void pevent_print_event(struct tep_handle *pevent, struct trace_seq *s,
-			struct pevent_record *record, bool use_trace_clock)
+			struct tep_record *record, bool use_trace_clock)
 {
 	struct event_format *event;
 
@@ -6244,7 +6244,7 @@ int pevent_strerror(struct tep_handle *pevent __maybe_unused,
 }
 
 int get_field_val(struct trace_seq *s, struct format_field *field,
-		  const char *name, struct pevent_record *record,
+		  const char *name, struct tep_record *record,
 		  unsigned long long *val, int err)
 {
 	if (!field) {
@@ -6277,7 +6277,7 @@ int get_field_val(struct trace_seq *s, struct format_field *field,
  * On failure, it returns NULL.
  */
 void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
-			   const char *name, struct pevent_record *record,
+			   const char *name, struct tep_record *record,
 			   int *len, int err)
 {
 	struct format_field *field;
@@ -6324,7 +6324,7 @@ void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
  * Returns 0 on success -1 on field not found.
  */
 int pevent_get_field_val(struct trace_seq *s, struct event_format *event,
-			 const char *name, struct pevent_record *record,
+			 const char *name, struct tep_record *record,
 			 unsigned long long *val, int err)
 {
 	struct format_field *field;
@@ -6349,7 +6349,7 @@ int pevent_get_field_val(struct trace_seq *s, struct event_format *event,
  * Returns 0 on success -1 on field not found.
  */
 int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
-				const char *name, struct pevent_record *record,
+				const char *name, struct tep_record *record,
 				unsigned long long *val, int err)
 {
 	struct format_field *field;
@@ -6374,7 +6374,7 @@ int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
  * Returns 0 on success -1 on field not found.
  */
 int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
-			     const char *name, struct pevent_record *record,
+			     const char *name, struct tep_record *record,
 			     unsigned long long *val, int err)
 {
 	struct format_field *field;
@@ -6400,7 +6400,7 @@ int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
  */
 int pevent_print_num_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
-			   struct pevent_record *record, int err)
+			   struct tep_record *record, int err)
 {
 	struct format_field *field = pevent_find_field(event, name);
 	unsigned long long val;
@@ -6432,7 +6432,7 @@ int pevent_print_num_field(struct trace_seq *s, const char *fmt,
  */
 int pevent_print_func_field(struct trace_seq *s, const char *fmt,
 			    struct event_format *event, const char *name,
-			    struct pevent_record *record, int err)
+			    struct tep_record *record, int err)
 {
 	struct format_field *field = pevent_find_field(event, name);
 	struct tep_handle *pevent = event->pevent;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index b7f4c8393abd..b1e4d37bedd8 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -41,7 +41,7 @@
 #define DEBUG_RECORD 0
 #endif
 
-struct pevent_record {
+struct tep_record {
 	unsigned long long	ts;
 	unsigned long long	offset;
 	long long		missed_events;	/* buffer dropped events before */
@@ -53,8 +53,8 @@ struct pevent_record {
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
@@ -102,7 +102,7 @@ struct tep_handle;
 struct event_format;
 
 typedef int (*pevent_event_handler_func)(struct trace_seq *s,
-					 struct pevent_record *record,
+					 struct tep_record *record,
 					 struct event_format *event,
 					 void *context);
 
@@ -628,16 +628,16 @@ int pevent_pid_is_registered(struct tep_handle *pevent, int pid);
 
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
@@ -652,26 +652,26 @@ void pevent_free_format(struct event_format *event);
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
@@ -703,15 +703,15 @@ struct event_format *
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
@@ -723,7 +723,7 @@ void pevent_print_field(struct trace_seq *s, void *data,
 void pevent_print_fields(struct trace_seq *s, void *data,
 			 int size __maybe_unused, struct event_format *event);
 void pevent_event_info(struct trace_seq *s, struct event_format *event,
-		       struct pevent_record *record);
+		       struct tep_record *record);
 int pevent_strerror(struct tep_handle *pevent, enum pevent_errno errnum,
 		    char *buf, size_t buflen);
 
@@ -957,7 +957,7 @@ enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
 					       const char *filter_str);
 
 enum pevent_errno pevent_filter_match(struct event_filter *filter,
-				      struct pevent_record *record);
+				      struct tep_record *record);
 
 int pevent_filter_strerror(struct event_filter *filter, enum pevent_errno err,
 			   char *buf, size_t buflen);
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index a97b84aece3a..784ccac90999 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1697,10 +1697,10 @@ int pevent_filter_event_has_trivial(struct event_filter *filter,
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
@@ -1712,7 +1712,7 @@ get_comm(struct event_format *event, struct pevent_record *record)
 
 static unsigned long long
 get_value(struct event_format *event,
-	  struct format_field *field, struct pevent_record *record)
+	  struct format_field *field, struct tep_record *record)
 {
 	unsigned long long val;
 
@@ -1748,11 +1748,11 @@ get_value(struct event_format *event,
 
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
 
@@ -1807,7 +1807,7 @@ get_exp_value(struct event_format *event, struct filter_arg *arg,
 
 static unsigned long long
 get_arg_value(struct event_format *event, struct filter_arg *arg,
-	      struct pevent_record *record, enum pevent_errno *err)
+	      struct tep_record *record, enum pevent_errno *err)
 {
 	switch (arg->type) {
 	case FILTER_ARG_FIELD:
@@ -1831,7 +1831,7 @@ get_arg_value(struct event_format *event, struct filter_arg *arg,
 }
 
 static int test_num(struct event_format *event, struct filter_arg *arg,
-		    struct pevent_record *record, enum pevent_errno *err)
+		    struct tep_record *record, enum pevent_errno *err)
 {
 	unsigned long long lval, rval;
 
@@ -1871,7 +1871,7 @@ static int test_num(struct event_format *event, struct filter_arg *arg,
 	}
 }
 
-static const char *get_field_str(struct filter_arg *arg, struct pevent_record *record)
+static const char *get_field_str(struct filter_arg *arg, struct tep_record *record)
 {
 	struct event_format *event;
 	struct tep_handle *pevent;
@@ -1922,7 +1922,7 @@ static const char *get_field_str(struct filter_arg *arg, struct pevent_record *r
 }
 
 static int test_str(struct event_format *event, struct filter_arg *arg,
-		    struct pevent_record *record, enum pevent_errno *err)
+		    struct tep_record *record, enum pevent_errno *err)
 {
 	const char *val;
 
@@ -1953,7 +1953,7 @@ static int test_str(struct event_format *event, struct filter_arg *arg,
 }
 
 static int test_op(struct event_format *event, struct filter_arg *arg,
-		   struct pevent_record *record, enum pevent_errno *err)
+		   struct tep_record *record, enum pevent_errno *err)
 {
 	switch (arg->op.type) {
 	case FILTER_OP_AND:
@@ -1975,7 +1975,7 @@ static int test_op(struct event_format *event, struct filter_arg *arg,
 }
 
 static int test_filter(struct event_format *event, struct filter_arg *arg,
-		       struct pevent_record *record, enum pevent_errno *err)
+		       struct tep_record *record, enum pevent_errno *err)
 {
 	if (*err) {
 		/*
@@ -2047,7 +2047,7 @@ int pevent_event_filtered(struct event_filter *filter, int event_id)
  * otherwise - error occurred during test
  */
 enum pevent_errno pevent_filter_match(struct event_filter *filter,
-				      struct pevent_record *record)
+				      struct tep_record *record)
 {
 	struct tep_handle *pevent = filter->pevent;
 	struct filter_type *filter_type;
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index 3ed965a8b5f0..86b5bb9bf22c 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -122,7 +122,7 @@ static int add_and_get_index(const char *parent, const char *child, int cpu)
 	return 0;
 }
 
-static int function_handler(struct trace_seq *s, struct pevent_record *record,
+static int function_handler(struct trace_seq *s, struct tep_record *record,
 			    struct event_format *event, void *context)
 {
 	struct tep_handle *pevent = event->pevent;
diff --git a/tools/lib/traceevent/plugin_hrtimer.c b/tools/lib/traceevent/plugin_hrtimer.c
index 746e7d464802..695e8e1b90e6 100644
--- a/tools/lib/traceevent/plugin_hrtimer.c
+++ b/tools/lib/traceevent/plugin_hrtimer.c
@@ -25,7 +25,7 @@
 #include "event-parse.h"
 
 static int timer_expire_handler(struct trace_seq *s,
-				struct pevent_record *record,
+				struct tep_record *record,
 				struct event_format *event, void *context)
 {
 	trace_seq_printf(s, "hrtimer=");
@@ -45,7 +45,7 @@ static int timer_expire_handler(struct trace_seq *s,
 }
 
 static int timer_start_handler(struct trace_seq *s,
-			       struct pevent_record *record,
+			       struct tep_record *record,
 			       struct event_format *event, void *context)
 {
 	trace_seq_printf(s, "hrtimer=");
diff --git a/tools/lib/traceevent/plugin_kmem.c b/tools/lib/traceevent/plugin_kmem.c
index e342edadf03d..46e8e959539e 100644
--- a/tools/lib/traceevent/plugin_kmem.c
+++ b/tools/lib/traceevent/plugin_kmem.c
@@ -23,7 +23,7 @@
 
 #include "event-parse.h"
 
-static int call_site_handler(struct trace_seq *s, struct pevent_record *record,
+static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 			     struct event_format *event, void *context)
 {
 	struct format_field *field;
diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index a6e96ba4d776..63420e3a340c 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -247,7 +247,7 @@ static const char *find_exit_reason(unsigned isa, int val)
 	return strings[i].str;
 }
 
-static int print_exit_reason(struct trace_seq *s, struct pevent_record *record,
+static int print_exit_reason(struct trace_seq *s, struct tep_record *record,
 			     struct event_format *event, const char *field)
 {
 	unsigned long long isa;
@@ -268,7 +268,7 @@ static int print_exit_reason(struct trace_seq *s, struct pevent_record *record,
 	return 0;
 }
 
-static int kvm_exit_handler(struct trace_seq *s, struct pevent_record *record,
+static int kvm_exit_handler(struct trace_seq *s, struct tep_record *record,
 			    struct event_format *event, void *context)
 {
 	unsigned long long info1 = 0, info2 = 0;
@@ -291,7 +291,7 @@ static int kvm_exit_handler(struct trace_seq *s, struct pevent_record *record,
 #define KVM_EMUL_INSN_F_CS_L   (1 << 3)
 
 static int kvm_emulate_insn_handler(struct trace_seq *s,
-				    struct pevent_record *record,
+				    struct tep_record *record,
 				    struct event_format *event, void *context)
 {
 	unsigned long long rip, csbase, len, flags, failed;
@@ -330,7 +330,7 @@ static int kvm_emulate_insn_handler(struct trace_seq *s,
 }
 
 
-static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct pevent_record *record,
+static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct tep_record *record,
 					    struct event_format *event, void *context)
 {
 	if (print_exit_reason(s, record, event, "exit_code") < 0)
@@ -344,7 +344,7 @@ static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct pevent_r
 	return 0;
 }
 
-static int kvm_nested_vmexit_handler(struct trace_seq *s, struct pevent_record *record,
+static int kvm_nested_vmexit_handler(struct trace_seq *s, struct tep_record *record,
 				     struct event_format *event, void *context)
 {
 	pevent_print_num_field(s, "rip %llx ", event, "rip", record, 1);
@@ -370,7 +370,7 @@ union kvm_mmu_page_role {
 	};
 };
 
-static int kvm_mmu_print_role(struct trace_seq *s, struct pevent_record *record,
+static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 			      struct event_format *event, void *context)
 {
 	unsigned long long val;
@@ -417,7 +417,7 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct pevent_record *record,
 }
 
 static int kvm_mmu_get_page_handler(struct trace_seq *s,
-				    struct pevent_record *record,
+				    struct tep_record *record,
 				    struct event_format *event, void *context)
 {
 	unsigned long long val;
diff --git a/tools/lib/traceevent/plugin_mac80211.c b/tools/lib/traceevent/plugin_mac80211.c
index 9ac1141f351a..83d002753251 100644
--- a/tools/lib/traceevent/plugin_mac80211.c
+++ b/tools/lib/traceevent/plugin_mac80211.c
@@ -58,7 +58,7 @@ static void print_string(struct trace_seq *s, struct event_format *event,
 #define SP()	trace_seq_putc(s, ' ')
 
 static int drv_bss_info_changed(struct trace_seq *s,
-				struct pevent_record *record,
+				struct tep_record *record,
 				struct event_format *event, void *context)
 {
 	void *data = record->data;
diff --git a/tools/lib/traceevent/plugin_sched_switch.c b/tools/lib/traceevent/plugin_sched_switch.c
index de90fb82b83f..b72a52d2fd1d 100644
--- a/tools/lib/traceevent/plugin_sched_switch.c
+++ b/tools/lib/traceevent/plugin_sched_switch.c
@@ -45,7 +45,7 @@ static void write_state(struct trace_seq *s, int val)
 }
 
 static void write_and_save_comm(struct format_field *field,
-				struct pevent_record *record,
+				struct tep_record *record,
 				struct trace_seq *s, int pid)
 {
 	const char *comm;
@@ -65,7 +65,7 @@ static void write_and_save_comm(struct format_field *field,
 }
 
 static int sched_wakeup_handler(struct trace_seq *s,
-				struct pevent_record *record,
+				struct tep_record *record,
 				struct event_format *event, void *context)
 {
 	struct format_field *field;
@@ -94,7 +94,7 @@ static int sched_wakeup_handler(struct trace_seq *s,
 }
 
 static int sched_switch_handler(struct trace_seq *s,
-				struct pevent_record *record,
+				struct tep_record *record,
 				struct event_format *event, void *context)
 {
 	struct format_field *field;
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 54d3f21b0e62..b23e861fa6ae 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -729,7 +729,7 @@ static char *compact_gfp_string(unsigned long gfp_flags)
 static int parse_gfp_flags(struct perf_evsel *evsel, struct perf_sample *sample,
 			   unsigned int gfp_flags)
 {
-	struct pevent_record record = {
+	struct tep_record record = {
 		.cpu = sample->cpu,
 		.data = sample->raw_data,
 		.size = sample->raw_size,
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index fed2952ab45a..2c9924ab872d 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -601,7 +601,7 @@ static char *get_trace_output(struct hist_entry *he)
 {
 	struct trace_seq seq;
 	struct perf_evsel *evsel;
-	struct pevent_record rec = {
+	struct tep_record rec = {
 		.data = he->raw_data,
 		.size = he->raw_size,
 	};
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0ef1c5042bc6..29af1fb0b888 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -116,7 +116,7 @@ unsigned long long read_size(struct event_format *event, void *ptr, int size)
 void event_format__fprintf(struct event_format *event,
 			   int cpu, void *data, int size, FILE *fp)
 {
-	struct pevent_record record;
+	struct tep_record record;
 	struct trace_seq s;
 
 	memset(&record, 0, sizeof(record));
-- 
2.14.4
