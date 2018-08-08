Return-Path: <SRS0=PkBc=KX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:50718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727706AbeHHU1v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Aug 2018 16:27:51 -0400
Message-Id: <20180808180659.706175783@goodmis.org>
Date: Wed, 08 Aug 2018 14:02:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [RFC][PATCH v2 01/24] tools/lib/traceevent, tools/perf: Rename struct pevent to struct
 tep_handle
References: <20180808180245.352784763@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
the struct pevent to struct tep_handle.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c            | 148 +++++++++---------
 tools/lib/traceevent/event-parse.h            | 136 ++++++++--------
 tools/lib/traceevent/event-plugin.c           |  14 +-
 tools/lib/traceevent/parse-filter.c           |  14 +-
 tools/lib/traceevent/plugin_cfg80211.c        |   4 +-
 tools/lib/traceevent/plugin_function.c        |   6 +-
 tools/lib/traceevent/plugin_hrtimer.c         |   4 +-
 tools/lib/traceevent/plugin_jbd2.c            |   4 +-
 tools/lib/traceevent/plugin_kmem.c            |   4 +-
 tools/lib/traceevent/plugin_kvm.c             |   4 +-
 tools/lib/traceevent/plugin_mac80211.c        |   4 +-
 tools/lib/traceevent/plugin_sched_switch.c    |   4 +-
 tools/lib/traceevent/plugin_scsi.c            |   4 +-
 tools/lib/traceevent/plugin_xen.c             |   4 +-
 tools/perf/util/header.c                      |   4 +-
 tools/perf/util/python.c                      |   2 +-
 .../util/scripting-engines/trace-event-perl.c |   2 +-
 .../scripting-engines/trace-event-python.c    |   2 +-
 tools/perf/util/sort.h                        |   2 +-
 tools/perf/util/trace-event-parse.c           |  12 +-
 tools/perf/util/trace-event-read.c            |  24 +--
 tools/perf/util/trace-event-scripting.c       |   4 +-
 tools/perf/util/trace-event.c                 |   6 +-
 tools/perf/util/trace-event.h                 |  18 +--
 24 files changed, 215 insertions(+), 215 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index e5f2acbb70cc..1eec313cc447 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -160,7 +160,7 @@ struct cmdline_list {
 	int			pid;
 };
 
-static int cmdline_init(struct pevent *pevent)
+static int cmdline_init(struct tep_handle *pevent)
 {
 	struct cmdline_list *cmdlist = pevent->cmdlist;
 	struct cmdline_list *item;
@@ -189,7 +189,7 @@ static int cmdline_init(struct pevent *pevent)
 	return 0;
 }
 
-static const char *find_cmdline(struct pevent *pevent, int pid)
+static const char *find_cmdline(struct tep_handle *pevent, int pid)
 {
 	const struct cmdline *comm;
 	struct cmdline key;
@@ -218,7 +218,7 @@ static const char *find_cmdline(struct pevent *pevent, int pid)
  * Returns 1 if the pid has a cmdline mapped to it
  * 0 otherwise.
  */
-int pevent_pid_is_registered(struct pevent *pevent, int pid)
+int pevent_pid_is_registered(struct tep_handle *pevent, int pid)
 {
 	const struct cmdline *comm;
 	struct cmdline key;
@@ -244,7 +244,7 @@ int pevent_pid_is_registered(struct pevent *pevent, int pid)
  * we must add this pid. This is much slower than when cmdlines
  * are added before the array is initialized.
  */
-static int add_new_comm(struct pevent *pevent, const char *comm, int pid)
+static int add_new_comm(struct tep_handle *pevent, const char *comm, int pid)
 {
 	struct cmdline *cmdlines = pevent->cmdlines;
 	const struct cmdline *cmdline;
@@ -296,7 +296,7 @@ static int add_new_comm(struct pevent *pevent, const char *comm, int pid)
  * This adds a mapping to search for command line names with
  * a given pid. The comm is duplicated.
  */
-int pevent_register_comm(struct pevent *pevent, const char *comm, int pid)
+int pevent_register_comm(struct tep_handle *pevent, const char *comm, int pid)
 {
 	struct cmdline_list *item;
 
@@ -324,7 +324,7 @@ int pevent_register_comm(struct pevent *pevent, const char *comm, int pid)
 	return 0;
 }
 
-int pevent_register_trace_clock(struct pevent *pevent, const char *trace_clock)
+int pevent_register_trace_clock(struct tep_handle *pevent, const char *trace_clock)
 {
 	pevent->trace_clock = strdup(trace_clock);
 	if (!pevent->trace_clock) {
@@ -381,7 +381,7 @@ static int func_bcmp(const void *a, const void *b)
 	return 1;
 }
 
-static int func_map_init(struct pevent *pevent)
+static int func_map_init(struct tep_handle *pevent)
 {
 	struct func_list *funclist;
 	struct func_list *item;
@@ -421,7 +421,7 @@ static int func_map_init(struct pevent *pevent)
 }
 
 static struct func_map *
-__find_func(struct pevent *pevent, unsigned long long addr)
+__find_func(struct tep_handle *pevent, unsigned long long addr)
 {
 	struct func_map *func;
 	struct func_map key;
@@ -453,7 +453,7 @@ struct func_resolver {
  * keep using it instead of duplicating all the entries inside
  * pevent->funclist.
  */
-int pevent_set_function_resolver(struct pevent *pevent,
+int pevent_set_function_resolver(struct tep_handle *pevent,
 				 pevent_func_resolver_t *func, void *priv)
 {
 	struct func_resolver *resolver = malloc(sizeof(*resolver));
@@ -477,14 +477,14 @@ int pevent_set_function_resolver(struct pevent *pevent,
  * Stop using whatever alternative resolver was set, use the default
  * one instead.
  */
-void pevent_reset_function_resolver(struct pevent *pevent)
+void pevent_reset_function_resolver(struct tep_handle *pevent)
 {
 	free(pevent->func_resolver);
 	pevent->func_resolver = NULL;
 }
 
 static struct func_map *
-find_func(struct pevent *pevent, unsigned long long addr)
+find_func(struct tep_handle *pevent, unsigned long long addr)
 {
 	struct func_map *map;
 
@@ -511,7 +511,7 @@ find_func(struct pevent *pevent, unsigned long long addr)
  * address. Note, the address does not have to be exact, it
  * will select the function that would contain the address.
  */
-const char *pevent_find_function(struct pevent *pevent, unsigned long long addr)
+const char *pevent_find_function(struct tep_handle *pevent, unsigned long long addr)
 {
 	struct func_map *map;
 
@@ -532,7 +532,7 @@ const char *pevent_find_function(struct pevent *pevent, unsigned long long addr)
  * name and the function offset.
  */
 unsigned long long
-pevent_find_function_address(struct pevent *pevent, unsigned long long addr)
+pevent_find_function_address(struct tep_handle *pevent, unsigned long long addr)
 {
 	struct func_map *map;
 
@@ -553,7 +553,7 @@ pevent_find_function_address(struct pevent *pevent, unsigned long long addr)
  * This registers a function name with an address and module.
  * The @func passed in is duplicated.
  */
-int pevent_register_function(struct pevent *pevent, char *func,
+int pevent_register_function(struct tep_handle *pevent, char *func,
 			     unsigned long long addr, char *mod)
 {
 	struct func_list *item = malloc(sizeof(*item));
@@ -594,7 +594,7 @@ int pevent_register_function(struct pevent *pevent, char *func,
  *
  * This prints out the stored functions.
  */
-void pevent_print_funcs(struct pevent *pevent)
+void pevent_print_funcs(struct tep_handle *pevent)
 {
 	int i;
 
@@ -636,7 +636,7 @@ static int printk_cmp(const void *a, const void *b)
 	return 0;
 }
 
-static int printk_map_init(struct pevent *pevent)
+static int printk_map_init(struct tep_handle *pevent)
 {
 	struct printk_list *printklist;
 	struct printk_list *item;
@@ -668,7 +668,7 @@ static int printk_map_init(struct pevent *pevent)
 }
 
 static struct printk_map *
-find_printk(struct pevent *pevent, unsigned long long addr)
+find_printk(struct tep_handle *pevent, unsigned long long addr)
 {
 	struct printk_map *printk;
 	struct printk_map key;
@@ -693,7 +693,7 @@ find_printk(struct pevent *pevent, unsigned long long addr)
  * This registers a string by the address it was stored in the kernel.
  * The @fmt passed in is duplicated.
  */
-int pevent_register_print_string(struct pevent *pevent, const char *fmt,
+int pevent_register_print_string(struct tep_handle *pevent, const char *fmt,
 				 unsigned long long addr)
 {
 	struct printk_list *item = malloc(sizeof(*item));
@@ -737,7 +737,7 @@ int pevent_register_print_string(struct pevent *pevent, const char *fmt,
  *
  * This prints the string formats that were stored.
  */
-void pevent_print_printk(struct pevent *pevent)
+void pevent_print_printk(struct tep_handle *pevent)
 {
 	int i;
 
@@ -756,7 +756,7 @@ static struct event_format *alloc_event(void)
 	return calloc(1, sizeof(struct event_format));
 }
 
-static int add_event(struct pevent *pevent, struct event_format *event)
+static int add_event(struct tep_handle *pevent, struct event_format *event)
 {
 	int i;
 	struct event_format **events = realloc(pevent->events, sizeof(event) *
@@ -2915,7 +2915,7 @@ process_bitmask(struct event_format *event __maybe_unused, struct print_arg *arg
 }
 
 static struct pevent_function_handler *
-find_func_handler(struct pevent *pevent, char *func_name)
+find_func_handler(struct tep_handle *pevent, char *func_name)
 {
 	struct pevent_function_handler *func;
 
@@ -2930,7 +2930,7 @@ find_func_handler(struct pevent *pevent, char *func_name)
 	return func;
 }
 
-static void remove_func_handler(struct pevent *pevent, char *func_name)
+static void remove_func_handler(struct tep_handle *pevent, char *func_name)
 {
 	struct pevent_function_handler *func;
 	struct pevent_function_handler **next;
@@ -3337,7 +3337,7 @@ pevent_find_any_field(struct event_format *event, const char *name)
  * Returns the number (converted to host) from the
  * raw data.
  */
-unsigned long long pevent_read_number(struct pevent *pevent,
+unsigned long long pevent_read_number(struct tep_handle *pevent,
 				      const void *ptr, int size)
 {
 	switch (size) {
@@ -3384,7 +3384,7 @@ int pevent_read_number_field(struct format_field *field, const void *data,
 	}
 }
 
-static int get_common_info(struct pevent *pevent,
+static int get_common_info(struct tep_handle *pevent,
 			   const char *type, int *offset, int *size)
 {
 	struct event_format *event;
@@ -3410,7 +3410,7 @@ static int get_common_info(struct pevent *pevent,
 	return 0;
 }
 
-static int __parse_common(struct pevent *pevent, void *data,
+static int __parse_common(struct tep_handle *pevent, void *data,
 			  int *size, int *offset, const char *name)
 {
 	int ret;
@@ -3423,42 +3423,42 @@ static int __parse_common(struct pevent *pevent, void *data,
 	return pevent_read_number(pevent, data + *offset, *size);
 }
 
-static int trace_parse_common_type(struct pevent *pevent, void *data)
+static int trace_parse_common_type(struct tep_handle *pevent, void *data)
 {
 	return __parse_common(pevent, data,
 			      &pevent->type_size, &pevent->type_offset,
 			      "common_type");
 }
 
-static int parse_common_pid(struct pevent *pevent, void *data)
+static int parse_common_pid(struct tep_handle *pevent, void *data)
 {
 	return __parse_common(pevent, data,
 			      &pevent->pid_size, &pevent->pid_offset,
 			      "common_pid");
 }
 
-static int parse_common_pc(struct pevent *pevent, void *data)
+static int parse_common_pc(struct tep_handle *pevent, void *data)
 {
 	return __parse_common(pevent, data,
 			      &pevent->pc_size, &pevent->pc_offset,
 			      "common_preempt_count");
 }
 
-static int parse_common_flags(struct pevent *pevent, void *data)
+static int parse_common_flags(struct tep_handle *pevent, void *data)
 {
 	return __parse_common(pevent, data,
 			      &pevent->flags_size, &pevent->flags_offset,
 			      "common_flags");
 }
 
-static int parse_common_lock_depth(struct pevent *pevent, void *data)
+static int parse_common_lock_depth(struct tep_handle *pevent, void *data)
 {
 	return __parse_common(pevent, data,
 			      &pevent->ld_size, &pevent->ld_offset,
 			      "common_lock_depth");
 }
 
-static int parse_common_migrate_disable(struct pevent *pevent, void *data)
+static int parse_common_migrate_disable(struct tep_handle *pevent, void *data)
 {
 	return __parse_common(pevent, data,
 			      &pevent->ld_size, &pevent->ld_offset,
@@ -3474,7 +3474,7 @@ static int events_id_cmp(const void *a, const void *b);
  *
  * Returns an event that has a given @id.
  */
-struct event_format *pevent_find_event(struct pevent *pevent, int id)
+struct event_format *pevent_find_event(struct tep_handle *pevent, int id)
 {
 	struct event_format **eventptr;
 	struct event_format key;
@@ -3507,7 +3507,7 @@ struct event_format *pevent_find_event(struct pevent *pevent, int id)
  * @sys. If @sys is NULL the first event with @name is returned.
  */
 struct event_format *
-pevent_find_event_by_name(struct pevent *pevent,
+pevent_find_event_by_name(struct tep_handle *pevent,
 			  const char *sys, const char *name)
 {
 	struct event_format *event;
@@ -3537,7 +3537,7 @@ pevent_find_event_by_name(struct pevent *pevent,
 static unsigned long long
 eval_num_arg(void *data, int size, struct event_format *event, struct print_arg *arg)
 {
-	struct pevent *pevent = event->pevent;
+	struct tep_handle *pevent = event->pevent;
 	unsigned long long val = 0;
 	unsigned long long left, right;
 	struct print_arg *typearg = NULL;
@@ -3820,7 +3820,7 @@ static void print_str_to_seq(struct trace_seq *s, const char *format,
 		trace_seq_printf(s, format, str);
 }
 
-static void print_bitmask_to_seq(struct pevent *pevent,
+static void print_bitmask_to_seq(struct tep_handle *pevent,
 				 struct trace_seq *s, const char *format,
 				 int len_arg, const void *data, int size)
 {
@@ -3878,7 +3878,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			  struct event_format *event, const char *format,
 			  int len_arg, struct print_arg *arg)
 {
-	struct pevent *pevent = event->pevent;
+	struct tep_handle *pevent = event->pevent;
 	struct print_flag_sym *flag;
 	struct format_field *field;
 	struct printk_map *printk;
@@ -4227,7 +4227,7 @@ static void free_args(struct print_arg *args)
 
 static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struct event_format *event)
 {
-	struct pevent *pevent = event->pevent;
+	struct tep_handle *pevent = event->pevent;
 	struct format_field *field, *ip_field;
 	struct print_arg *args, *arg, **next;
 	unsigned long long ip, val;
@@ -4404,7 +4404,7 @@ static char *
 get_bprint_format(void *data, int size __maybe_unused,
 		  struct event_format *event)
 {
-	struct pevent *pevent = event->pevent;
+	struct tep_handle *pevent = event->pevent;
 	unsigned long long addr;
 	struct format_field *field;
 	struct printk_map *printk;
@@ -4805,7 +4805,7 @@ void pevent_print_field(struct trace_seq *s, void *data,
 {
 	unsigned long long val;
 	unsigned int offset, len, i;
-	struct pevent *pevent = field->event->pevent;
+	struct tep_handle *pevent = field->event->pevent;
 
 	if (field->flags & FIELD_IS_ARRAY) {
 		offset = field->offset;
@@ -4880,7 +4880,7 @@ void pevent_print_fields(struct trace_seq *s, void *data,
 
 static void pretty_print(struct trace_seq *s, void *data, int size, struct event_format *event)
 {
-	struct pevent *pevent = event->pevent;
+	struct tep_handle *pevent = event->pevent;
 	struct print_fmt *print_fmt = &event->print_fmt;
 	struct print_arg *arg = print_fmt->args;
 	struct print_arg *args = NULL;
@@ -5149,7 +5149,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
  * need rescheduling, in hard/soft interrupt, preempt count
  * and lock depth) and places it into the trace_seq.
  */
-void pevent_data_lat_fmt(struct pevent *pevent,
+void pevent_data_lat_fmt(struct tep_handle *pevent,
 			 struct trace_seq *s, struct pevent_record *record)
 {
 	static int check_lock_depth = 1;
@@ -5229,7 +5229,7 @@ void pevent_data_lat_fmt(struct pevent *pevent,
  *
  * This returns the event id from the @rec.
  */
-int pevent_data_type(struct pevent *pevent, struct pevent_record *rec)
+int pevent_data_type(struct tep_handle *pevent, struct pevent_record *rec)
 {
 	return trace_parse_common_type(pevent, rec->data);
 }
@@ -5241,7 +5241,7 @@ int pevent_data_type(struct pevent *pevent, struct pevent_record *rec)
  *
  * This returns the event form a given @type;
  */
-struct event_format *pevent_data_event_from_type(struct pevent *pevent, int type)
+struct event_format *pevent_data_event_from_type(struct tep_handle *pevent, int type)
 {
 	return pevent_find_event(pevent, type);
 }
@@ -5253,7 +5253,7 @@ struct event_format *pevent_data_event_from_type(struct pevent *pevent, int type
  *
  * This returns the PID from a record.
  */
-int pevent_data_pid(struct pevent *pevent, struct pevent_record *rec)
+int pevent_data_pid(struct tep_handle *pevent, struct pevent_record *rec)
 {
 	return parse_common_pid(pevent, rec->data);
 }
@@ -5265,7 +5265,7 @@ int pevent_data_pid(struct pevent *pevent, struct pevent_record *rec)
  *
  * This returns the preempt count from a record.
  */
-int pevent_data_preempt_count(struct pevent *pevent, struct pevent_record *rec)
+int pevent_data_preempt_count(struct tep_handle *pevent, struct pevent_record *rec)
 {
 	return parse_common_pc(pevent, rec->data);
 }
@@ -5279,7 +5279,7 @@ int pevent_data_preempt_count(struct pevent *pevent, struct pevent_record *rec)
  *
  *  Use trace_flag_type enum for the flags (see event-parse.h).
  */
-int pevent_data_flags(struct pevent *pevent, struct pevent_record *rec)
+int pevent_data_flags(struct tep_handle *pevent, struct pevent_record *rec)
 {
 	return parse_common_flags(pevent, rec->data);
 }
@@ -5292,7 +5292,7 @@ int pevent_data_flags(struct pevent *pevent, struct pevent_record *rec)
  * This returns a pointer to the command line that has the given
  * @pid.
  */
-const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid)
+const char *pevent_data_comm_from_pid(struct tep_handle *pevent, int pid)
 {
 	const char *comm;
 
@@ -5301,7 +5301,7 @@ const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid)
 }
 
 static struct cmdline *
-pid_from_cmdlist(struct pevent *pevent, const char *comm, struct cmdline *next)
+pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct cmdline *next)
 {
 	struct cmdline_list *cmdlist = (struct cmdline_list *)next;
 
@@ -5329,7 +5329,7 @@ pid_from_cmdlist(struct pevent *pevent, const char *comm, struct cmdline *next)
  * next pid.
  * Also, it does a linear seach, so it may be slow.
  */
-struct cmdline *pevent_data_pid_from_comm(struct pevent *pevent, const char *comm,
+struct cmdline *pevent_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
 					  struct cmdline *next)
 {
 	struct cmdline *cmdline;
@@ -5371,7 +5371,7 @@ struct cmdline *pevent_data_pid_from_comm(struct pevent *pevent, const char *com
  * Returns the pid for a give cmdline. If @cmdline is NULL, then
  * -1 is returned.
  */
-int pevent_cmdline_pid(struct pevent *pevent, struct cmdline *cmdline)
+int pevent_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline)
 {
 	struct cmdline_list *cmdlist = (struct cmdline_list *)cmdline;
 
@@ -5441,7 +5441,7 @@ static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
  * is found.
  */
 struct event_format *
-pevent_find_event_by_record(struct pevent *pevent, struct pevent_record *record)
+pevent_find_event_by_record(struct tep_handle *pevent, struct pevent_record *record)
 {
 	int type;
 
@@ -5464,7 +5464,7 @@ pevent_find_event_by_record(struct pevent *pevent, struct pevent_record *record)
  *
  * Writes the tasks comm, pid and CPU to @s.
  */
-void pevent_print_event_task(struct pevent *pevent, struct trace_seq *s,
+void pevent_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
 			     struct event_format *event,
 			     struct pevent_record *record)
 {
@@ -5492,7 +5492,7 @@ void pevent_print_event_task(struct pevent *pevent, struct trace_seq *s,
  *
  * Writes the timestamp of the record into @s.
  */
-void pevent_print_event_time(struct pevent *pevent, struct trace_seq *s,
+void pevent_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 			     struct event_format *event,
 			     struct pevent_record *record,
 			     bool use_trace_clock)
@@ -5542,7 +5542,7 @@ void pevent_print_event_time(struct pevent *pevent, struct trace_seq *s,
  *
  * Writes the parsing of the record's data to @s.
  */
-void pevent_print_event_data(struct pevent *pevent, struct trace_seq *s,
+void pevent_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 			     struct event_format *event,
 			     struct pevent_record *record)
 {
@@ -5559,7 +5559,7 @@ void pevent_print_event_data(struct pevent *pevent, struct trace_seq *s,
 	pevent_event_info(s, event, record);
 }
 
-void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
+void pevent_print_event(struct tep_handle *pevent, struct trace_seq *s,
 			struct pevent_record *record, bool use_trace_clock)
 {
 	struct event_format *event;
@@ -5630,7 +5630,7 @@ static int events_system_cmp(const void *a, const void *b)
 	return events_id_cmp(a, b);
 }
 
-struct event_format **pevent_list_events(struct pevent *pevent, enum event_sort_type sort_type)
+struct event_format **pevent_list_events(struct tep_handle *pevent, enum event_sort_type sort_type)
 {
 	struct event_format **events;
 	int (*sort)(const void *a, const void *b);
@@ -5941,7 +5941,7 @@ static void parse_header_field(const char *field,
  *
  * /sys/kernel/debug/tracing/events/header_page
  */
-int pevent_parse_header_page(struct pevent *pevent, char *buf, unsigned long size,
+int pevent_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
 			     int long_size)
 {
 	int ignore;
@@ -5994,7 +5994,7 @@ static void free_handler(struct event_handler *handle)
 	free(handle);
 }
 
-static int find_event_handle(struct pevent *pevent, struct event_format *event)
+static int find_event_handle(struct tep_handle *pevent, struct event_format *event)
 {
 	struct event_handler *handle, **next;
 
@@ -6036,7 +6036,7 @@ static int find_event_handle(struct pevent *pevent, struct event_format *event)
  * /sys/kernel/debug/tracing/events/.../.../format
  */
 enum pevent_errno __pevent_parse_format(struct event_format **eventp,
-					struct pevent *pevent, const char *buf,
+					struct tep_handle *pevent, const char *buf,
 					unsigned long size, const char *sys)
 {
 	struct event_format *event;
@@ -6143,7 +6143,7 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
 }
 
 static enum pevent_errno
-__pevent_parse_event(struct pevent *pevent,
+__pevent_parse_event(struct tep_handle *pevent,
 		     struct event_format **eventp,
 		     const char *buf, unsigned long size,
 		     const char *sys)
@@ -6185,7 +6185,7 @@ __pevent_parse_event(struct pevent *pevent,
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum pevent_errno pevent_parse_format(struct pevent *pevent,
+enum pevent_errno pevent_parse_format(struct tep_handle *pevent,
 				      struct event_format **eventp,
 				      const char *buf,
 				      unsigned long size, const char *sys)
@@ -6207,7 +6207,7 @@ enum pevent_errno pevent_parse_format(struct pevent *pevent,
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
+enum pevent_errno pevent_parse_event(struct tep_handle *pevent, const char *buf,
 				     unsigned long size, const char *sys)
 {
 	struct event_format *event = NULL;
@@ -6221,7 +6221,7 @@ static const char * const pevent_error_str[] = {
 };
 #undef _PE
 
-int pevent_strerror(struct pevent *pevent __maybe_unused,
+int pevent_strerror(struct tep_handle *pevent __maybe_unused,
 		    enum pevent_errno errnum, char *buf, size_t buflen)
 {
 	int idx;
@@ -6435,7 +6435,7 @@ int pevent_print_func_field(struct trace_seq *s, const char *fmt,
 			    struct pevent_record *record, int err)
 {
 	struct format_field *field = pevent_find_field(event, name);
-	struct pevent *pevent = event->pevent;
+	struct tep_handle *pevent = event->pevent;
 	unsigned long long val;
 	struct func_map *func;
 	char tmp[128];
@@ -6491,7 +6491,7 @@ static void free_func_handle(struct pevent_function_handler *func)
  * The @parameters is a variable list of pevent_func_arg_type enums that
  * must end with PEVENT_FUNC_ARG_VOID.
  */
-int pevent_register_print_function(struct pevent *pevent,
+int pevent_register_print_function(struct tep_handle *pevent,
 				   pevent_func_handler func,
 				   enum pevent_func_arg_type ret_type,
 				   char *name, ...)
@@ -6578,7 +6578,7 @@ int pevent_register_print_function(struct pevent *pevent,
  *
  * Returns 0 if the handler was removed successully, -1 otherwise.
  */
-int pevent_unregister_print_function(struct pevent *pevent,
+int pevent_unregister_print_function(struct tep_handle *pevent,
 				     pevent_func_handler func, char *name)
 {
 	struct pevent_function_handler *func_handle;
@@ -6591,7 +6591,7 @@ int pevent_unregister_print_function(struct pevent *pevent,
 	return -1;
 }
 
-static struct event_format *pevent_search_event(struct pevent *pevent, int id,
+static struct event_format *pevent_search_event(struct tep_handle *pevent, int id,
 						const char *sys_name,
 						const char *event_name)
 {
@@ -6631,7 +6631,7 @@ static struct event_format *pevent_search_event(struct pevent *pevent, int id,
  * If @id is >= 0, then it is used to find the event.
  * else @sys_name and @event_name are used.
  */
-int pevent_register_event_handler(struct pevent *pevent, int id,
+int pevent_register_event_handler(struct tep_handle *pevent, int id,
 				  const char *sys_name, const char *event_name,
 				  pevent_event_handler_func func, void *context)
 {
@@ -6715,7 +6715,7 @@ static int handle_matches(struct event_handler *handler, int id,
  *
  * Returns 0 if handler was removed successfully, -1 if event was not found.
  */
-int pevent_unregister_event_handler(struct pevent *pevent, int id,
+int pevent_unregister_event_handler(struct tep_handle *pevent, int id,
 				    const char *sys_name, const char *event_name,
 				    pevent_event_handler_func func, void *context)
 {
@@ -6756,9 +6756,9 @@ int pevent_unregister_event_handler(struct pevent *pevent, int id,
 /**
  * pevent_alloc - create a pevent handle
  */
-struct pevent *pevent_alloc(void)
+struct tep_handle *pevent_alloc(void)
 {
-	struct pevent *pevent = calloc(1, sizeof(*pevent));
+	struct tep_handle *pevent = calloc(1, sizeof(*pevent));
 
 	if (pevent)
 		pevent->ref_count = 1;
@@ -6766,7 +6766,7 @@ struct pevent *pevent_alloc(void)
 	return pevent;
 }
 
-void pevent_ref(struct pevent *pevent)
+void pevent_ref(struct tep_handle *pevent)
 {
 	pevent->ref_count++;
 }
@@ -6814,7 +6814,7 @@ void pevent_free_format(struct event_format *event)
  * pevent_free - free a pevent handle
  * @pevent: the pevent handle to free
  */
-void pevent_free(struct pevent *pevent)
+void pevent_free(struct tep_handle *pevent)
 {
 	struct cmdline_list *cmdlist, *cmdnext;
 	struct func_list *funclist, *funcnext;
@@ -6899,7 +6899,7 @@ void pevent_free(struct pevent *pevent)
 	free(pevent);
 }
 
-void pevent_unref(struct pevent *pevent)
+void pevent_unref(struct tep_handle *pevent)
 {
 	pevent_free(pevent);
 }
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 0c03538df74c..b7f4c8393abd 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -98,7 +98,7 @@ extern int trace_seq_do_printf(struct trace_seq *s);
 
 /* ----------------------- pevent ----------------------- */
 
-struct pevent;
+struct tep_handle;
 struct event_format;
 
 typedef int (*pevent_event_handler_func)(struct trace_seq *s,
@@ -106,8 +106,8 @@ typedef int (*pevent_event_handler_func)(struct trace_seq *s,
 					 struct event_format *event,
 					 void *context);
 
-typedef int (*pevent_plugin_load_func)(struct pevent *pevent);
-typedef int (*pevent_plugin_unload_func)(struct pevent *pevent);
+typedef int (*pevent_plugin_load_func)(struct tep_handle *pevent);
+typedef int (*pevent_plugin_unload_func)(struct tep_handle *pevent);
 
 struct pevent_plugin_option {
 	struct pevent_plugin_option	*next;
@@ -127,12 +127,12 @@ struct pevent_plugin_option {
  * PEVENT_PLUGIN_LOADER:  (required)
  *   The function name to initialized the plugin.
  *
- *   int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+ *   int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
  *
  * PEVENT_PLUGIN_UNLOADER:  (optional)
  *   The function called just before unloading
  *
- *   int PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+ *   int PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
  *
  * PEVENT_PLUGIN_OPTIONS:  (optional)
  *   Plugin options that can be set before loading
@@ -320,7 +320,7 @@ struct print_fmt {
 };
 
 struct event_format {
-	struct pevent		*pevent;
+	struct tep_handle	*pevent;
 	char			*name;
 	int			id;
 	int			flags;
@@ -435,9 +435,9 @@ struct plugin_list;
 
 #define INVALID_PLUGIN_LIST_OPTION	((char **)((unsigned long)-1))
 
-struct plugin_list *traceevent_load_plugins(struct pevent *pevent);
+struct plugin_list *traceevent_load_plugins(struct tep_handle *pevent);
 void traceevent_unload_plugins(struct plugin_list *plugin_list,
-			       struct pevent *pevent);
+			       struct tep_handle *pevent);
 char **traceevent_plugin_list_options(void);
 void traceevent_plugin_free_options_list(char **list);
 int traceevent_plugin_add_options(const char *name,
@@ -457,7 +457,7 @@ struct func_resolver;
 typedef char *(pevent_func_resolver_t)(void *priv,
 				       unsigned long long *addrp, char **modp);
 
-struct pevent {
+struct tep_handle {
 	int ref_count;
 
 	int header_page_ts_offset;
@@ -532,13 +532,13 @@ struct pevent {
 	char *trace_clock;
 };
 
-static inline void pevent_set_flag(struct pevent *pevent, int flag)
+static inline void pevent_set_flag(struct tep_handle *pevent, int flag)
 {
 	pevent->flags |= flag;
 }
 
 static inline unsigned short
-__data2host2(struct pevent *pevent, unsigned short data)
+__data2host2(struct tep_handle *pevent, unsigned short data)
 {
 	unsigned short swap;
 
@@ -552,7 +552,7 @@ __data2host2(struct pevent *pevent, unsigned short data)
 }
 
 static inline unsigned int
-__data2host4(struct pevent *pevent, unsigned int data)
+__data2host4(struct tep_handle *pevent, unsigned int data)
 {
 	unsigned int swap;
 
@@ -568,7 +568,7 @@ __data2host4(struct pevent *pevent, unsigned int data)
 }
 
 static inline unsigned long long
-__data2host8(struct pevent *pevent, unsigned long long data)
+__data2host8(struct tep_handle *pevent, unsigned long long data)
 {
 	unsigned long long swap;
 
@@ -615,36 +615,36 @@ enum trace_flag_type {
 	TRACE_FLAG_SOFTIRQ		= 0x10,
 };
 
-int pevent_set_function_resolver(struct pevent *pevent,
+int pevent_set_function_resolver(struct tep_handle *pevent,
 				 pevent_func_resolver_t *func, void *priv);
-void pevent_reset_function_resolver(struct pevent *pevent);
-int pevent_register_comm(struct pevent *pevent, const char *comm, int pid);
-int pevent_register_trace_clock(struct pevent *pevent, const char *trace_clock);
-int pevent_register_function(struct pevent *pevent, char *name,
+void pevent_reset_function_resolver(struct tep_handle *pevent);
+int pevent_register_comm(struct tep_handle *pevent, const char *comm, int pid);
+int pevent_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
+int pevent_register_function(struct tep_handle *pevent, char *name,
 			     unsigned long long addr, char *mod);
-int pevent_register_print_string(struct pevent *pevent, const char *fmt,
+int pevent_register_print_string(struct tep_handle *pevent, const char *fmt,
 				 unsigned long long addr);
-int pevent_pid_is_registered(struct pevent *pevent, int pid);
+int pevent_pid_is_registered(struct tep_handle *pevent, int pid);
 
-void pevent_print_event_task(struct pevent *pevent, struct trace_seq *s,
+void pevent_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
 			     struct event_format *event,
 			     struct pevent_record *record);
-void pevent_print_event_time(struct pevent *pevent, struct trace_seq *s,
+void pevent_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 			     struct event_format *event,
 			     struct pevent_record *record,
 			     bool use_trace_clock);
-void pevent_print_event_data(struct pevent *pevent, struct trace_seq *s,
+void pevent_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 			     struct event_format *event,
 			     struct pevent_record *record);
-void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
+void pevent_print_event(struct tep_handle *pevent, struct trace_seq *s,
 			struct pevent_record *record, bool use_trace_clock);
 
-int pevent_parse_header_page(struct pevent *pevent, char *buf, unsigned long size,
+int pevent_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
 			     int long_size);
 
-enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
+enum pevent_errno pevent_parse_event(struct tep_handle *pevent, const char *buf,
 				     unsigned long size, const char *sys);
-enum pevent_errno pevent_parse_format(struct pevent *pevent,
+enum pevent_errno pevent_parse_format(struct tep_handle *pevent,
 				      struct event_format **eventp,
 				      const char *buf,
 				      unsigned long size, const char *sys);
@@ -673,50 +673,50 @@ int pevent_print_func_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
 			   struct pevent_record *record, int err);
 
-int pevent_register_event_handler(struct pevent *pevent, int id,
+int pevent_register_event_handler(struct tep_handle *pevent, int id,
 				  const char *sys_name, const char *event_name,
 				  pevent_event_handler_func func, void *context);
-int pevent_unregister_event_handler(struct pevent *pevent, int id,
+int pevent_unregister_event_handler(struct tep_handle *pevent, int id,
 				    const char *sys_name, const char *event_name,
 				    pevent_event_handler_func func, void *context);
-int pevent_register_print_function(struct pevent *pevent,
+int pevent_register_print_function(struct tep_handle *pevent,
 				   pevent_func_handler func,
 				   enum pevent_func_arg_type ret_type,
 				   char *name, ...);
-int pevent_unregister_print_function(struct pevent *pevent,
+int pevent_unregister_print_function(struct tep_handle *pevent,
 				     pevent_func_handler func, char *name);
 
 struct format_field *pevent_find_common_field(struct event_format *event, const char *name);
 struct format_field *pevent_find_field(struct event_format *event, const char *name);
 struct format_field *pevent_find_any_field(struct event_format *event, const char *name);
 
-const char *pevent_find_function(struct pevent *pevent, unsigned long long addr);
+const char *pevent_find_function(struct tep_handle *pevent, unsigned long long addr);
 unsigned long long
-pevent_find_function_address(struct pevent *pevent, unsigned long long addr);
-unsigned long long pevent_read_number(struct pevent *pevent, const void *ptr, int size);
+pevent_find_function_address(struct tep_handle *pevent, unsigned long long addr);
+unsigned long long pevent_read_number(struct tep_handle *pevent, const void *ptr, int size);
 int pevent_read_number_field(struct format_field *field, const void *data,
 			     unsigned long long *value);
 
-struct event_format *pevent_find_event(struct pevent *pevent, int id);
+struct event_format *pevent_find_event(struct tep_handle *pevent, int id);
 
 struct event_format *
-pevent_find_event_by_name(struct pevent *pevent, const char *sys, const char *name);
+pevent_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *name);
 
 struct event_format *
-pevent_find_event_by_record(struct pevent *pevent, struct pevent_record *record);
+pevent_find_event_by_record(struct tep_handle *pevent, struct pevent_record *record);
 
-void pevent_data_lat_fmt(struct pevent *pevent,
+void pevent_data_lat_fmt(struct tep_handle *pevent,
 			 struct trace_seq *s, struct pevent_record *record);
-int pevent_data_type(struct pevent *pevent, struct pevent_record *rec);
-struct event_format *pevent_data_event_from_type(struct pevent *pevent, int type);
-int pevent_data_pid(struct pevent *pevent, struct pevent_record *rec);
-int pevent_data_preempt_count(struct pevent *pevent, struct pevent_record *rec);
-int pevent_data_flags(struct pevent *pevent, struct pevent_record *rec);
-const char *pevent_data_comm_from_pid(struct pevent *pevent, int pid);
+int pevent_data_type(struct tep_handle *pevent, struct pevent_record *rec);
+struct event_format *pevent_data_event_from_type(struct tep_handle *pevent, int type);
+int pevent_data_pid(struct tep_handle *pevent, struct pevent_record *rec);
+int pevent_data_preempt_count(struct tep_handle *pevent, struct pevent_record *rec);
+int pevent_data_flags(struct tep_handle *pevent, struct pevent_record *rec);
+const char *pevent_data_comm_from_pid(struct tep_handle *pevent, int pid);
 struct cmdline;
-struct cmdline *pevent_data_pid_from_comm(struct pevent *pevent, const char *comm,
+struct cmdline *pevent_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
 					  struct cmdline *next);
-int pevent_cmdline_pid(struct pevent *pevent, struct cmdline *cmdline);
+int pevent_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline);
 
 void pevent_print_field(struct trace_seq *s, void *data,
 			struct format_field *field);
@@ -724,77 +724,77 @@ void pevent_print_fields(struct trace_seq *s, void *data,
 			 int size __maybe_unused, struct event_format *event);
 void pevent_event_info(struct trace_seq *s, struct event_format *event,
 		       struct pevent_record *record);
-int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
+int pevent_strerror(struct tep_handle *pevent, enum pevent_errno errnum,
 		    char *buf, size_t buflen);
 
-struct event_format **pevent_list_events(struct pevent *pevent, enum event_sort_type);
+struct event_format **pevent_list_events(struct tep_handle *pevent, enum event_sort_type);
 struct format_field **pevent_event_common_fields(struct event_format *event);
 struct format_field **pevent_event_fields(struct event_format *event);
 
-static inline int pevent_get_cpus(struct pevent *pevent)
+static inline int pevent_get_cpus(struct tep_handle *pevent)
 {
 	return pevent->cpus;
 }
 
-static inline void pevent_set_cpus(struct pevent *pevent, int cpus)
+static inline void pevent_set_cpus(struct tep_handle *pevent, int cpus)
 {
 	pevent->cpus = cpus;
 }
 
-static inline int pevent_get_long_size(struct pevent *pevent)
+static inline int pevent_get_long_size(struct tep_handle *pevent)
 {
 	return pevent->long_size;
 }
 
-static inline void pevent_set_long_size(struct pevent *pevent, int long_size)
+static inline void pevent_set_long_size(struct tep_handle *pevent, int long_size)
 {
 	pevent->long_size = long_size;
 }
 
-static inline int pevent_get_page_size(struct pevent *pevent)
+static inline int pevent_get_page_size(struct tep_handle *pevent)
 {
 	return pevent->page_size;
 }
 
-static inline void pevent_set_page_size(struct pevent *pevent, int _page_size)
+static inline void pevent_set_page_size(struct tep_handle *pevent, int _page_size)
 {
 	pevent->page_size = _page_size;
 }
 
-static inline int pevent_is_file_bigendian(struct pevent *pevent)
+static inline int pevent_is_file_bigendian(struct tep_handle *pevent)
 {
 	return pevent->file_bigendian;
 }
 
-static inline void pevent_set_file_bigendian(struct pevent *pevent, int endian)
+static inline void pevent_set_file_bigendian(struct tep_handle *pevent, int endian)
 {
 	pevent->file_bigendian = endian;
 }
 
-static inline int pevent_is_host_bigendian(struct pevent *pevent)
+static inline int pevent_is_host_bigendian(struct tep_handle *pevent)
 {
 	return pevent->host_bigendian;
 }
 
-static inline void pevent_set_host_bigendian(struct pevent *pevent, int endian)
+static inline void pevent_set_host_bigendian(struct tep_handle *pevent, int endian)
 {
 	pevent->host_bigendian = endian;
 }
 
-static inline int pevent_is_latency_format(struct pevent *pevent)
+static inline int pevent_is_latency_format(struct tep_handle *pevent)
 {
 	return pevent->latency_format;
 }
 
-static inline void pevent_set_latency_format(struct pevent *pevent, int lat)
+static inline void pevent_set_latency_format(struct tep_handle *pevent, int lat)
 {
 	pevent->latency_format = lat;
 }
 
-struct pevent *pevent_alloc(void);
-void pevent_free(struct pevent *pevent);
-void pevent_ref(struct pevent *pevent);
-void pevent_unref(struct pevent *pevent);
+struct tep_handle *pevent_alloc(void);
+void pevent_free(struct tep_handle *pevent);
+void pevent_ref(struct tep_handle *pevent);
+void pevent_unref(struct tep_handle *pevent);
 
 /* access to the internal parser */
 void pevent_buffer_init(const char *buf, unsigned long long size);
@@ -805,8 +805,8 @@ const char *pevent_get_input_buf(void);
 unsigned long long pevent_get_input_buf_ptr(void);
 
 /* for debugging */
-void pevent_print_funcs(struct pevent *pevent);
-void pevent_print_printk(struct pevent *pevent);
+void pevent_print_funcs(struct tep_handle *pevent);
+void pevent_print_printk(struct tep_handle *pevent);
 
 /* ----------------------- filtering ----------------------- */
 
@@ -933,13 +933,13 @@ struct filter_type {
 #define PEVENT_FILTER_ERROR_BUFSZ  1024
 
 struct event_filter {
-	struct pevent		*pevent;
+	struct tep_handle	*pevent;
 	int			filters;
 	struct filter_type	*event_filters;
 	char			error_buffer[PEVENT_FILTER_ERROR_BUFSZ];
 };
 
-struct event_filter *pevent_filter_alloc(struct pevent *pevent);
+struct event_filter *pevent_filter_alloc(struct tep_handle *pevent);
 
 /* for backward compatibility */
 #define FILTER_NONE		PEVENT_ERRNO__NO_FILTER
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index d542cb60ca1a..62b011ae18c1 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -281,7 +281,7 @@ void traceevent_print_plugins(struct trace_seq *s,
 }
 
 static void
-load_plugin(struct pevent *pevent, const char *path,
+load_plugin(struct tep_handle *pevent, const char *path,
 	    const char *file, void *data)
 {
 	struct plugin_list **plugin_list = data;
@@ -336,9 +336,9 @@ load_plugin(struct pevent *pevent, const char *path,
 }
 
 static void
-load_plugins_dir(struct pevent *pevent, const char *suffix,
+load_plugins_dir(struct tep_handle *pevent, const char *suffix,
 		 const char *path,
-		 void (*load_plugin)(struct pevent *pevent,
+		 void (*load_plugin)(struct tep_handle *pevent,
 				     const char *path,
 				     const char *name,
 				     void *data),
@@ -378,8 +378,8 @@ load_plugins_dir(struct pevent *pevent, const char *suffix,
 }
 
 static void
-load_plugins(struct pevent *pevent, const char *suffix,
-	     void (*load_plugin)(struct pevent *pevent,
+load_plugins(struct tep_handle *pevent, const char *suffix,
+	     void (*load_plugin)(struct tep_handle *pevent,
 				 const char *path,
 				 const char *name,
 				 void *data),
@@ -431,7 +431,7 @@ load_plugins(struct pevent *pevent, const char *suffix,
 }
 
 struct plugin_list*
-traceevent_load_plugins(struct pevent *pevent)
+traceevent_load_plugins(struct tep_handle *pevent)
 {
 	struct plugin_list *list = NULL;
 
@@ -440,7 +440,7 @@ traceevent_load_plugins(struct pevent *pevent)
 }
 
 void
-traceevent_unload_plugins(struct plugin_list *plugin_list, struct pevent *pevent)
+traceevent_unload_plugins(struct plugin_list *plugin_list, struct tep_handle *pevent)
 {
 	pevent_plugin_unload_func func;
 	struct plugin_list *list;
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 431e8b309f6e..a97b84aece3a 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -179,7 +179,7 @@ add_filter_type(struct event_filter *filter, int id)
  * pevent_filter_alloc - create a new event filter
  * @pevent: The pevent that this filter is associated with
  */
-struct event_filter *pevent_filter_alloc(struct pevent *pevent)
+struct event_filter *pevent_filter_alloc(struct tep_handle *pevent)
 {
 	struct event_filter *filter;
 
@@ -269,7 +269,7 @@ static int event_match(struct event_format *event,
 }
 
 static enum pevent_errno
-find_event(struct pevent *pevent, struct event_list **events,
+find_event(struct tep_handle *pevent, struct event_list **events,
 	   char *sys_name, char *event_name)
 {
 	struct event_format *event;
@@ -1270,7 +1270,7 @@ static void filter_init_error_buf(struct event_filter *filter)
 enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
 					       const char *filter_str)
 {
-	struct pevent *pevent = filter->pevent;
+	struct tep_handle *pevent = filter->pevent;
 	struct event_list *event;
 	struct event_list *events = NULL;
 	const char *filter_start;
@@ -1550,8 +1550,8 @@ int pevent_filter_copy(struct event_filter *dest, struct event_filter *source)
 int pevent_update_trivial(struct event_filter *dest, struct event_filter *source,
 			  enum filter_trivial_type type)
 {
-	struct pevent *src_pevent;
-	struct pevent *dest_pevent;
+	struct tep_handle *src_pevent;
+	struct tep_handle *dest_pevent;
 	struct event_format *event;
 	struct filter_type *filter_type;
 	struct filter_arg *arg;
@@ -1874,7 +1874,7 @@ static int test_num(struct event_format *event, struct filter_arg *arg,
 static const char *get_field_str(struct filter_arg *arg, struct pevent_record *record)
 {
 	struct event_format *event;
-	struct pevent *pevent;
+	struct tep_handle *pevent;
 	unsigned long long addr;
 	const char *val = NULL;
 	unsigned int size;
@@ -2049,7 +2049,7 @@ int pevent_event_filtered(struct event_filter *filter, int event_id)
 enum pevent_errno pevent_filter_match(struct event_filter *filter,
 				      struct pevent_record *record)
 {
-	struct pevent *pevent = filter->pevent;
+	struct tep_handle *pevent = filter->pevent;
 	struct filter_type *filter_type;
 	int event_id;
 	int ret;
diff --git a/tools/lib/traceevent/plugin_cfg80211.c b/tools/lib/traceevent/plugin_cfg80211.c
index 8f8586912da7..959d94f1d7f5 100644
--- a/tools/lib/traceevent/plugin_cfg80211.c
+++ b/tools/lib/traceevent/plugin_cfg80211.c
@@ -25,7 +25,7 @@ process___le16_to_cpup(struct trace_seq *s, unsigned long long *args)
 	return val ? (long long) le16toh(*val) : 0;
 }
 
-int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_print_function(pevent,
 				       process___le16_to_cpup,
@@ -36,7 +36,7 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_print_function(pevent, process___le16_to_cpup,
 					 "__le16_to_cpup");
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index 42dbf73758f3..3ed965a8b5f0 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -125,7 +125,7 @@ static int add_and_get_index(const char *parent, const char *child, int cpu)
 static int function_handler(struct trace_seq *s, struct pevent_record *record,
 			    struct event_format *event, void *context)
 {
-	struct pevent *pevent = event->pevent;
+	struct tep_handle *pevent = event->pevent;
 	unsigned long long function;
 	unsigned long long pfunction;
 	const char *func;
@@ -163,7 +163,7 @@ static int function_handler(struct trace_seq *s, struct pevent_record *record,
 	return 0;
 }
 
-int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_event_handler(pevent, -1, "ftrace", "function",
 				      function_handler, NULL);
@@ -173,7 +173,7 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	int i, x;
 
diff --git a/tools/lib/traceevent/plugin_hrtimer.c b/tools/lib/traceevent/plugin_hrtimer.c
index 12bf14cc1152..746e7d464802 100644
--- a/tools/lib/traceevent/plugin_hrtimer.c
+++ b/tools/lib/traceevent/plugin_hrtimer.c
@@ -66,7 +66,7 @@ static int timer_start_handler(struct trace_seq *s,
 	return 0;
 }
 
-int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_event_handler(pevent, -1,
 				      "timer", "hrtimer_expire_entry",
@@ -77,7 +77,7 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_event_handler(pevent, -1,
 					"timer", "hrtimer_expire_entry",
diff --git a/tools/lib/traceevent/plugin_jbd2.c b/tools/lib/traceevent/plugin_jbd2.c
index 5c23d5bd27ce..3909db7043c9 100644
--- a/tools/lib/traceevent/plugin_jbd2.c
+++ b/tools/lib/traceevent/plugin_jbd2.c
@@ -47,7 +47,7 @@ process_jiffies_to_msecs(struct trace_seq *s, unsigned long long *args)
 	return jiffies;
 }
 
-int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_print_function(pevent,
 				       process_jbd2_dev_to_name,
@@ -65,7 +65,7 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_print_function(pevent, process_jbd2_dev_to_name,
 					 "jbd2_dev_to_name");
diff --git a/tools/lib/traceevent/plugin_kmem.c b/tools/lib/traceevent/plugin_kmem.c
index 70650ff48d78..e342edadf03d 100644
--- a/tools/lib/traceevent/plugin_kmem.c
+++ b/tools/lib/traceevent/plugin_kmem.c
@@ -48,7 +48,7 @@ static int call_site_handler(struct trace_seq *s, struct pevent_record *record,
 	return 1;
 }
 
-int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_event_handler(pevent, -1, "kmem", "kfree",
 				      call_site_handler, NULL);
@@ -71,7 +71,7 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_event_handler(pevent, -1, "kmem", "kfree",
 					call_site_handler, NULL);
diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 18536f756577..a6e96ba4d776 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -444,7 +444,7 @@ process_is_writable_pte(struct trace_seq *s, unsigned long long *args)
 	return pte & PT_WRITABLE_MASK;
 }
 
-int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	init_disassembler();
 
@@ -486,7 +486,7 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_exit",
 					kvm_exit_handler, NULL);
diff --git a/tools/lib/traceevent/plugin_mac80211.c b/tools/lib/traceevent/plugin_mac80211.c
index 7e15a0f1c2fd..9ac1141f351a 100644
--- a/tools/lib/traceevent/plugin_mac80211.c
+++ b/tools/lib/traceevent/plugin_mac80211.c
@@ -86,7 +86,7 @@ static int drv_bss_info_changed(struct trace_seq *s,
 	return 0;
 }
 
-int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_event_handler(pevent, -1, "mac80211",
 				      "drv_bss_info_changed",
@@ -94,7 +94,7 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_event_handler(pevent, -1, "mac80211",
 					"drv_bss_info_changed",
diff --git a/tools/lib/traceevent/plugin_sched_switch.c b/tools/lib/traceevent/plugin_sched_switch.c
index ec30c2fcbac0..de90fb82b83f 100644
--- a/tools/lib/traceevent/plugin_sched_switch.c
+++ b/tools/lib/traceevent/plugin_sched_switch.c
@@ -134,7 +134,7 @@ static int sched_switch_handler(struct trace_seq *s,
 	return 0;
 }
 
-int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_event_handler(pevent, -1, "sched", "sched_switch",
 				      sched_switch_handler, NULL);
@@ -147,7 +147,7 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_event_handler(pevent, -1, "sched", "sched_switch",
 					sched_switch_handler, NULL);
diff --git a/tools/lib/traceevent/plugin_scsi.c b/tools/lib/traceevent/plugin_scsi.c
index 5e750af2b461..e430a49e4995 100644
--- a/tools/lib/traceevent/plugin_scsi.c
+++ b/tools/lib/traceevent/plugin_scsi.c
@@ -413,7 +413,7 @@ unsigned long long process_scsi_trace_parse_cdb(struct trace_seq *s,
 	return 0;
 }
 
-int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_print_function(pevent,
 				       process_scsi_trace_parse_cdb,
@@ -426,7 +426,7 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_print_function(pevent, process_scsi_trace_parse_cdb,
 					 "scsi_trace_parse_cdb");
diff --git a/tools/lib/traceevent/plugin_xen.c b/tools/lib/traceevent/plugin_xen.c
index 690173bfa13e..11dbddde2e6a 100644
--- a/tools/lib/traceevent/plugin_xen.c
+++ b/tools/lib/traceevent/plugin_xen.c
@@ -119,7 +119,7 @@ unsigned long long process_xen_hypercall_name(struct trace_seq *s,
 	return 0;
 }
 
-int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	pevent_register_print_function(pevent,
 				       process_xen_hypercall_name,
@@ -130,7 +130,7 @@ int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
 	return 0;
 }
 
-void PEVENT_PLUGIN_UNLOADER(struct pevent *pevent)
+void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	pevent_unregister_print_function(pevent, process_xen_hypercall_name,
 					 "xen_hypercall_name");
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 5af58aac91ad..08d98dea7854 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -3207,7 +3207,7 @@ static int read_attr(int fd, struct perf_header *ph,
 }
 
 static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
-						struct pevent *pevent)
+						struct tep_handle *pevent)
 {
 	struct event_format *event;
 	char bf[128];
@@ -3239,7 +3239,7 @@ static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
 }
 
 static int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
-						  struct pevent *pevent)
+						  struct tep_handle *pevent)
 {
 	struct perf_evsel *pos;
 
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 863b61478edd..fd72cce6599c 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -341,7 +341,7 @@ static bool is_tracepoint(struct pyrf_event *pevent)
 static PyObject*
 tracepoint_field(struct pyrf_event *pe, struct format_field *field)
 {
-	struct pevent *pevent = field->event->pevent;
+	struct tep_handle *pevent = field->event->pevent;
 	void *data = pe->sample.raw_data;
 	PyObject *ret = NULL;
 	unsigned long long val;
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 7b79c413486b..45484f0f7292 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -535,7 +535,7 @@ static int perl_stop_script(void)
 	return 0;
 }
 
-static int perl_generate_script(struct pevent *pevent, const char *outfile)
+static int perl_generate_script(struct tep_handle *pevent, const char *outfile)
 {
 	struct event_format *event = NULL;
 	struct format_field *f;
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index bc32e57d17be..77bddd50e705 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -1588,7 +1588,7 @@ static int python_stop_script(void)
 	return 0;
 }
 
-static int python_generate_script(struct pevent *pevent, const char *outfile)
+static int python_generate_script(struct tep_handle *pevent, const char *outfile)
 {
 	struct event_format *event = NULL;
 	struct format_field *f;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 8bf302cafcec..a97cf8e6be86 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -276,7 +276,7 @@ extern struct sort_entry sort_thread;
 extern struct list_head hist_entry__sort_list;
 
 struct perf_evlist;
-struct pevent;
+struct tep_handle;
 int setup_sorting(struct perf_evlist *evlist);
 int setup_output_field(void);
 void reset_output_field(void);
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index e0a6e9a6a053..0ef1c5042bc6 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -32,7 +32,7 @@
 static int get_common_field(struct scripting_context *context,
 			    int *offset, int *size, const char *type)
 {
-	struct pevent *pevent = context->pevent;
+	struct tep_handle *pevent = context->pevent;
 	struct event_format *event;
 	struct format_field *field;
 
@@ -136,7 +136,7 @@ void event_format__print(struct event_format *event,
 	return event_format__fprintf(event, cpu, data, size, stdout);
 }
 
-void parse_ftrace_printk(struct pevent *pevent,
+void parse_ftrace_printk(struct tep_handle *pevent,
 			 char *file, unsigned int size __maybe_unused)
 {
 	unsigned long long addr;
@@ -161,7 +161,7 @@ void parse_ftrace_printk(struct pevent *pevent,
 	}
 }
 
-void parse_saved_cmdline(struct pevent *pevent,
+void parse_saved_cmdline(struct tep_handle *pevent,
 			 char *file, unsigned int size __maybe_unused)
 {
 	char *comm;
@@ -178,18 +178,18 @@ void parse_saved_cmdline(struct pevent *pevent,
 	}
 }
 
-int parse_ftrace_file(struct pevent *pevent, char *buf, unsigned long size)
+int parse_ftrace_file(struct tep_handle *pevent, char *buf, unsigned long size)
 {
 	return pevent_parse_event(pevent, buf, size, "ftrace");
 }
 
-int parse_event_file(struct pevent *pevent,
+int parse_event_file(struct tep_handle *pevent,
 		     char *buf, unsigned long size, char *sys)
 {
 	return pevent_parse_event(pevent, buf, size, sys);
 }
 
-struct event_format *trace_find_next_event(struct pevent *pevent,
+struct event_format *trace_find_next_event(struct tep_handle *pevent,
 					   struct event_format *event)
 {
 	static int idx;
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 40b425949aa3..cbd4970415ef 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -96,7 +96,7 @@ static void skip(int size)
 	};
 }
 
-static unsigned int read4(struct pevent *pevent)
+static unsigned int read4(struct tep_handle *pevent)
 {
 	unsigned int data;
 
@@ -105,7 +105,7 @@ static unsigned int read4(struct pevent *pevent)
 	return __data2host4(pevent, data);
 }
 
-static unsigned long long read8(struct pevent *pevent)
+static unsigned long long read8(struct tep_handle *pevent)
 {
 	unsigned long long data;
 
@@ -158,7 +158,7 @@ static char *read_string(void)
 	return str;
 }
 
-static int read_proc_kallsyms(struct pevent *pevent)
+static int read_proc_kallsyms(struct tep_handle *pevent)
 {
 	unsigned int size;
 
@@ -181,7 +181,7 @@ static int read_proc_kallsyms(struct pevent *pevent)
 	return 0;
 }
 
-static int read_ftrace_printk(struct pevent *pevent)
+static int read_ftrace_printk(struct tep_handle *pevent)
 {
 	unsigned int size;
 	char *buf;
@@ -208,7 +208,7 @@ static int read_ftrace_printk(struct pevent *pevent)
 	return 0;
 }
 
-static int read_header_files(struct pevent *pevent)
+static int read_header_files(struct tep_handle *pevent)
 {
 	unsigned long long size;
 	char *header_page;
@@ -259,7 +259,7 @@ static int read_header_files(struct pevent *pevent)
 	return ret;
 }
 
-static int read_ftrace_file(struct pevent *pevent, unsigned long long size)
+static int read_ftrace_file(struct tep_handle *pevent, unsigned long long size)
 {
 	int ret;
 	char *buf;
@@ -284,8 +284,8 @@ static int read_ftrace_file(struct pevent *pevent, unsigned long long size)
 	return ret;
 }
 
-static int read_event_file(struct pevent *pevent, char *sys,
-			    unsigned long long size)
+static int read_event_file(struct tep_handle *pevent, char *sys,
+			   unsigned long long size)
 {
 	int ret;
 	char *buf;
@@ -310,7 +310,7 @@ static int read_event_file(struct pevent *pevent, char *sys,
 	return ret;
 }
 
-static int read_ftrace_files(struct pevent *pevent)
+static int read_ftrace_files(struct tep_handle *pevent)
 {
 	unsigned long long size;
 	int count;
@@ -328,7 +328,7 @@ static int read_ftrace_files(struct pevent *pevent)
 	return 0;
 }
 
-static int read_event_files(struct pevent *pevent)
+static int read_event_files(struct tep_handle *pevent)
 {
 	unsigned long long size;
 	char *sys;
@@ -356,7 +356,7 @@ static int read_event_files(struct pevent *pevent)
 	return 0;
 }
 
-static int read_saved_cmdline(struct pevent *pevent)
+static int read_saved_cmdline(struct tep_handle *pevent)
 {
 	unsigned long long size;
 	char *buf;
@@ -399,7 +399,7 @@ ssize_t trace_report(int fd, struct trace_event *tevent, bool __repipe)
 	int host_bigendian;
 	int file_long_size;
 	int file_page_size;
-	struct pevent *pevent = NULL;
+	struct tep_handle *pevent = NULL;
 	int err;
 
 	repipe = __repipe;
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index b1e5c3a2b8e3..b749f812ac70 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -66,7 +66,7 @@ static int python_start_script_unsupported(const char *script __maybe_unused,
 	return -1;
 }
 
-static int python_generate_script_unsupported(struct pevent *pevent
+static int python_generate_script_unsupported(struct tep_handle *pevent
 					      __maybe_unused,
 					      const char *outfile
 					      __maybe_unused)
@@ -130,7 +130,7 @@ static int perl_start_script_unsupported(const char *script __maybe_unused,
 	return -1;
 }
 
-static int perl_generate_script_unsupported(struct pevent *pevent
+static int perl_generate_script_unsupported(struct tep_handle *pevent
 					    __maybe_unused,
 					    const char *outfile __maybe_unused)
 {
diff --git a/tools/perf/util/trace-event.c b/tools/perf/util/trace-event.c
index 1aa368603268..7c0cd9a0f575 100644
--- a/tools/perf/util/trace-event.c
+++ b/tools/perf/util/trace-event.c
@@ -28,7 +28,7 @@ static bool tevent_initialized;
 
 int trace_event__init(struct trace_event *t)
 {
-	struct pevent *pevent = pevent_alloc();
+	struct tep_handle *pevent = pevent_alloc();
 
 	if (pevent) {
 		t->plugin_list = traceevent_load_plugins(pevent);
@@ -41,7 +41,7 @@ int trace_event__init(struct trace_event *t)
 static int trace_event__init2(void)
 {
 	int be = traceevent_host_bigendian();
-	struct pevent *pevent;
+	struct tep_handle *pevent;
 
 	if (trace_event__init(&tevent))
 		return -1;
@@ -76,7 +76,7 @@ static struct event_format*
 tp_format(const char *sys, const char *name)
 {
 	char *tp_dir = get_events_file(sys);
-	struct pevent *pevent = tevent.pevent;
+	struct tep_handle *pevent = tevent.pevent;
 	struct event_format *event = NULL;
 	char path[PATH_MAX];
 	size_t size;
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index dcbdb53dc702..b8f2516e9a65 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -13,7 +13,7 @@ struct thread;
 struct plugin_list;
 
 struct trace_event {
-	struct pevent		*pevent;
+	struct tep_handle	*pevent;
 	struct plugin_list	*plugin_list;
 };
 
@@ -34,20 +34,20 @@ void event_format__fprintf(struct event_format *event,
 void event_format__print(struct event_format *event,
 			 int cpu, void *data, int size);
 
-int parse_ftrace_file(struct pevent *pevent, char *buf, unsigned long size);
-int parse_event_file(struct pevent *pevent,
+int parse_ftrace_file(struct tep_handle *pevent, char *buf, unsigned long size);
+int parse_event_file(struct tep_handle *pevent,
 		     char *buf, unsigned long size, char *sys);
 
 unsigned long long
 raw_field_value(struct event_format *event, const char *name, void *data);
 
-void parse_proc_kallsyms(struct pevent *pevent, char *file, unsigned int size);
-void parse_ftrace_printk(struct pevent *pevent, char *file, unsigned int size);
-void parse_saved_cmdline(struct pevent *pevent, char *file, unsigned int size);
+void parse_proc_kallsyms(struct tep_handle *pevent, char *file, unsigned int size);
+void parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigned int size);
+void parse_saved_cmdline(struct tep_handle *pevent, char *file, unsigned int size);
 
 ssize_t trace_report(int fd, struct trace_event *tevent, bool repipe);
 
-struct event_format *trace_find_next_event(struct pevent *pevent,
+struct event_format *trace_find_next_event(struct tep_handle *pevent,
 					   struct event_format *event);
 unsigned long long read_size(struct event_format *event, void *ptr, int size);
 unsigned long long eval_flag(const char *flag);
@@ -83,7 +83,7 @@ struct scripting_ops {
 	void (*process_stat)(struct perf_stat_config *config,
 			     struct perf_evsel *evsel, u64 tstamp);
 	void (*process_stat_interval)(u64 tstamp);
-	int (*generate_script) (struct pevent *pevent, const char *outfile);
+	int (*generate_script) (struct tep_handle *pevent, const char *outfile);
 };
 
 extern unsigned int scripting_max_stack;
@@ -94,7 +94,7 @@ void setup_perl_scripting(void);
 void setup_python_scripting(void);
 
 struct scripting_context {
-	struct pevent *pevent;
+	struct tep_handle *pevent;
 	void *event_data;
 };
 
-- 
2.18.0
