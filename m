Return-Path: <SRS0=GMWY=KZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46127 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727534AbeHJPrm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Aug 2018 11:47:42 -0400
Received: by mail-wr1-f66.google.com with SMTP id h14-v6so8252994wrw.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Aug 2018 06:17:46 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 01/14] tools/lib/traceevent, tools/perf: Rename struct event_format to struct tep_event_format
Date: Fri, 10 Aug 2018 16:17:19 +0300
Message-Id: <20180810131732.24677-2-tz.stoyanov@gmail.com>
In-Reply-To: <20180810131732.24677-1-tz.stoyanov@gmail.com>
References: <20180810131732.24677-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This renames
struct event_format to struct tep_event_format

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.c            | 186 +++++++++---------
 tools/lib/traceevent/event-parse.h            |  66 +++----
 tools/lib/traceevent/parse-filter.c           |  42 ++--
 tools/lib/traceevent/plugin_function.c        |   2 +-
 tools/lib/traceevent/plugin_hrtimer.c         |   4 +-
 tools/lib/traceevent/plugin_kmem.c            |   2 +-
 tools/lib/traceevent/plugin_kvm.c             |  14 +-
 tools/lib/traceevent/plugin_mac80211.c        |   4 +-
 tools/lib/traceevent/plugin_sched_switch.c    |   4 +-
 tools/perf/builtin-trace.c                    |   2 +-
 tools/perf/util/evsel.h                       |   4 +-
 tools/perf/util/header.c                      |   2 +-
 tools/perf/util/python.c                      |   4 +-
 .../util/scripting-engines/trace-event-perl.c |   6 +-
 .../scripting-engines/trace-event-python.c    |   8 +-
 tools/perf/util/trace-event-parse.c           |  14 +-
 tools/perf/util/trace-event.c                 |   8 +-
 tools/perf/util/trace-event.h                 |  16 +-
 18 files changed, 194 insertions(+), 194 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 6313e32680ff..1874c249a963 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -108,7 +108,7 @@ struct tep_function_handler {
 
 static unsigned long long
 process_defined_func(struct trace_seq *s, void *data, int size,
-		     struct event_format *event, struct print_arg *arg);
+		     struct tep_event_format *event, struct print_arg *arg);
 
 static void free_func_handle(struct tep_function_handler *func);
 
@@ -751,16 +751,16 @@ void tep_print_printk(struct tep_handle *pevent)
 	}
 }
 
-static struct event_format *alloc_event(void)
+static struct tep_event_format *alloc_event(void)
 {
-	return calloc(1, sizeof(struct event_format));
+	return calloc(1, sizeof(struct tep_event_format));
 }
 
-static int add_event(struct tep_handle *pevent, struct event_format *event)
+static int add_event(struct tep_handle *pevent, struct tep_event_format *event)
 {
 	int i;
-	struct event_format **events = realloc(pevent->events, sizeof(event) *
-					       (pevent->nr_events + 1));
+	struct tep_event_format **events = realloc(pevent->events, sizeof(event) *
+						  (pevent->nr_events + 1));
 	if (!events)
 		return -1;
 
@@ -1367,7 +1367,7 @@ static unsigned int type_size(const char *name)
 	return 0;
 }
 
-static int event_read_fields(struct event_format *event, struct format_field **fields)
+static int event_read_fields(struct tep_event_format *event, struct format_field **fields)
 {
 	struct format_field *field = NULL;
 	enum event_type type;
@@ -1654,7 +1654,7 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 	return -1;
 }
 
-static int event_read_format(struct event_format *event)
+static int event_read_format(struct tep_event_format *event)
 {
 	char *token;
 	int ret;
@@ -1687,11 +1687,11 @@ static int event_read_format(struct event_format *event)
 }
 
 static enum event_type
-process_arg_token(struct event_format *event, struct print_arg *arg,
+process_arg_token(struct tep_event_format *event, struct print_arg *arg,
 		  char **tok, enum event_type type);
 
 static enum event_type
-process_arg(struct event_format *event, struct print_arg *arg, char **tok)
+process_arg(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	enum event_type type;
 	char *token;
@@ -1703,14 +1703,14 @@ process_arg(struct event_format *event, struct print_arg *arg, char **tok)
 }
 
 static enum event_type
-process_op(struct event_format *event, struct print_arg *arg, char **tok);
+process_op(struct tep_event_format *event, struct print_arg *arg, char **tok);
 
 /*
  * For __print_symbolic() and __print_flags, we need to completely
  * evaluate the first argument, which defines what to print next.
  */
 static enum event_type
-process_field_arg(struct event_format *event, struct print_arg *arg, char **tok)
+process_field_arg(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	enum event_type type;
 
@@ -1724,7 +1724,7 @@ process_field_arg(struct event_format *event, struct print_arg *arg, char **tok)
 }
 
 static enum event_type
-process_cond(struct event_format *event, struct print_arg *top, char **tok)
+process_cond(struct tep_event_format *event, struct print_arg *top, char **tok)
 {
 	struct print_arg *arg, *left, *right;
 	enum event_type type;
@@ -1780,7 +1780,7 @@ process_cond(struct event_format *event, struct print_arg *top, char **tok)
 }
 
 static enum event_type
-process_array(struct event_format *event, struct print_arg *top, char **tok)
+process_array(struct tep_event_format *event, struct print_arg *top, char **tok)
 {
 	struct print_arg *arg;
 	enum event_type type;
@@ -1882,7 +1882,7 @@ static int set_op_prio(struct print_arg *arg)
 
 /* Note, *tok does not get freed, but will most likely be saved */
 static enum event_type
-process_op(struct event_format *event, struct print_arg *arg, char **tok)
+process_op(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *left, *right = NULL;
 	enum event_type type;
@@ -2083,7 +2083,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 }
 
 static enum event_type
-process_entry(struct event_format *event __maybe_unused, struct print_arg *arg,
+process_entry(struct tep_event_format *event __maybe_unused, struct print_arg *arg,
 	      char **tok)
 {
 	enum event_type type;
@@ -2122,7 +2122,7 @@ process_entry(struct event_format *event __maybe_unused, struct print_arg *arg,
 	return EVENT_ERROR;
 }
 
-static int alloc_and_process_delim(struct event_format *event, char *next_token,
+static int alloc_and_process_delim(struct tep_event_format *event, char *next_token,
 				   struct print_arg **print_arg)
 {
 	struct print_arg *field;
@@ -2457,7 +2457,7 @@ static char *arg_eval (struct print_arg *arg)
 }
 
 static enum event_type
-process_fields(struct event_format *event, struct print_flag_sym **list, char **tok)
+process_fields(struct tep_event_format *event, struct print_flag_sym **list, char **tok)
 {
 	enum event_type type;
 	struct print_arg *arg = NULL;
@@ -2538,7 +2538,7 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 }
 
 static enum event_type
-process_flags(struct event_format *event, struct print_arg *arg, char **tok)
+process_flags(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *field;
 	enum event_type type;
@@ -2591,7 +2591,7 @@ process_flags(struct event_format *event, struct print_arg *arg, char **tok)
 }
 
 static enum event_type
-process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
+process_symbols(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *field;
 	enum event_type type;
@@ -2630,7 +2630,7 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
 }
 
 static enum event_type
-process_hex_common(struct event_format *event, struct print_arg *arg,
+process_hex_common(struct tep_event_format *event, struct print_arg *arg,
 		   char **tok, enum print_arg_type type)
 {
 	memset(arg, 0, sizeof(*arg));
@@ -2653,20 +2653,20 @@ process_hex_common(struct event_format *event, struct print_arg *arg,
 }
 
 static enum event_type
-process_hex(struct event_format *event, struct print_arg *arg, char **tok)
+process_hex(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	return process_hex_common(event, arg, tok, PRINT_HEX);
 }
 
 static enum event_type
-process_hex_str(struct event_format *event, struct print_arg *arg,
+process_hex_str(struct tep_event_format *event, struct print_arg *arg,
 		char **tok)
 {
 	return process_hex_common(event, arg, tok, PRINT_HEX_STR);
 }
 
 static enum event_type
-process_int_array(struct event_format *event, struct print_arg *arg, char **tok)
+process_int_array(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	memset(arg, 0, sizeof(*arg));
 	arg->type = PRINT_INT_ARRAY;
@@ -2694,7 +2694,7 @@ process_int_array(struct event_format *event, struct print_arg *arg, char **tok)
 }
 
 static enum event_type
-process_dynamic_array(struct event_format *event, struct print_arg *arg, char **tok)
+process_dynamic_array(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	struct format_field *field;
 	enum event_type type;
@@ -2758,7 +2758,7 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
 }
 
 static enum event_type
-process_dynamic_array_len(struct event_format *event, struct print_arg *arg,
+process_dynamic_array_len(struct tep_event_format *event, struct print_arg *arg,
 			  char **tok)
 {
 	struct format_field *field;
@@ -2794,7 +2794,7 @@ process_dynamic_array_len(struct event_format *event, struct print_arg *arg,
 }
 
 static enum event_type
-process_paren(struct event_format *event, struct print_arg *arg, char **tok)
+process_paren(struct tep_event_format *event, struct print_arg *arg, char **tok)
 {
 	struct print_arg *item_arg;
 	enum event_type type;
@@ -2857,7 +2857,7 @@ process_paren(struct event_format *event, struct print_arg *arg, char **tok)
 
 
 static enum event_type
-process_str(struct event_format *event __maybe_unused, struct print_arg *arg,
+process_str(struct tep_event_format *event __maybe_unused, struct print_arg *arg,
 	    char **tok)
 {
 	enum event_type type;
@@ -2886,8 +2886,8 @@ process_str(struct event_format *event __maybe_unused, struct print_arg *arg,
 }
 
 static enum event_type
-process_bitmask(struct event_format *event __maybe_unused, struct print_arg *arg,
-	    char **tok)
+process_bitmask(struct tep_event_format *event __maybe_unused, struct print_arg *arg,
+		char **tok)
 {
 	enum event_type type;
 	char *token;
@@ -2947,7 +2947,7 @@ static void remove_func_handler(struct tep_handle *pevent, char *func_name)
 }
 
 static enum event_type
-process_func_handler(struct event_format *event, struct tep_function_handler *func,
+process_func_handler(struct tep_event_format *event, struct tep_function_handler *func,
 		     struct print_arg *arg, char **tok)
 {
 	struct print_arg **next_arg;
@@ -3005,7 +3005,7 @@ process_func_handler(struct event_format *event, struct tep_function_handler *fu
 }
 
 static enum event_type
-process_function(struct event_format *event, struct print_arg *arg,
+process_function(struct tep_event_format *event, struct print_arg *arg,
 		 char *token, char **tok)
 {
 	struct tep_function_handler *func;
@@ -3061,7 +3061,7 @@ process_function(struct event_format *event, struct print_arg *arg,
 }
 
 static enum event_type
-process_arg_token(struct event_format *event, struct print_arg *arg,
+process_arg_token(struct tep_event_format *event, struct print_arg *arg,
 		  char **tok, enum event_type type)
 {
 	char *token;
@@ -3149,7 +3149,7 @@ process_arg_token(struct event_format *event, struct print_arg *arg,
 	return type;
 }
 
-static int event_read_print_args(struct event_format *event, struct print_arg **list)
+static int event_read_print_args(struct tep_event_format *event, struct print_arg **list)
 {
 	enum event_type type = EVENT_ERROR;
 	struct print_arg *arg;
@@ -3207,7 +3207,7 @@ static int event_read_print_args(struct event_format *event, struct print_arg **
 	return args;
 }
 
-static int event_read_print(struct event_format *event)
+static int event_read_print(struct tep_event_format *event)
 {
 	enum event_type type;
 	char *token;
@@ -3273,7 +3273,7 @@ static int event_read_print(struct event_format *event)
  * This only searchs the common fields and not all field.
  */
 struct format_field *
-tep_find_common_field(struct event_format *event, const char *name)
+tep_find_common_field(struct tep_event_format *event, const char *name)
 {
 	struct format_field *format;
 
@@ -3295,7 +3295,7 @@ tep_find_common_field(struct event_format *event, const char *name)
  * This does not search common fields.
  */
 struct format_field *
-tep_find_field(struct event_format *event, const char *name)
+tep_find_field(struct tep_event_format *event, const char *name)
 {
 	struct format_field *format;
 
@@ -3318,7 +3318,7 @@ tep_find_field(struct event_format *event, const char *name)
  * the non-common ones if a common one was not found.
  */
 struct format_field *
-tep_find_any_field(struct event_format *event, const char *name)
+tep_find_any_field(struct tep_event_format *event, const char *name)
 {
 	struct format_field *format;
 
@@ -3387,7 +3387,7 @@ int tep_read_number_field(struct format_field *field, const void *data,
 static int get_common_info(struct tep_handle *pevent,
 			   const char *type, int *offset, int *size)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct format_field *field;
 
 	/*
@@ -3474,11 +3474,11 @@ static int events_id_cmp(const void *a, const void *b);
  *
  * Returns an event that has a given @id.
  */
-struct event_format *tep_find_event(struct tep_handle *pevent, int id)
+struct tep_event_format *tep_find_event(struct tep_handle *pevent, int id)
 {
-	struct event_format **eventptr;
-	struct event_format key;
-	struct event_format *pkey = &key;
+	struct tep_event_format **eventptr;
+	struct tep_event_format key;
+	struct tep_event_format *pkey = &key;
 
 	/* Check cache first */
 	if (pevent->last_event && pevent->last_event->id == id)
@@ -3506,11 +3506,11 @@ struct event_format *tep_find_event(struct tep_handle *pevent, int id)
  * This returns an event with a given @name and under the system
  * @sys. If @sys is NULL the first event with @name is returned.
  */
-struct event_format *
+struct tep_event_format *
 tep_find_event_by_name(struct tep_handle *pevent,
 		       const char *sys, const char *name)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	int i;
 
 	if (pevent->last_event &&
@@ -3535,7 +3535,7 @@ tep_find_event_by_name(struct tep_handle *pevent,
 }
 
 static unsigned long long
-eval_num_arg(void *data, int size, struct event_format *event, struct print_arg *arg)
+eval_num_arg(void *data, int size, struct tep_event_format *event, struct print_arg *arg)
 {
 	struct tep_handle *pevent = event->pevent;
 	unsigned long long val = 0;
@@ -3875,7 +3875,7 @@ static void print_bitmask_to_seq(struct tep_handle *pevent,
 }
 
 static void print_str_arg(struct trace_seq *s, void *data, int size,
-			  struct event_format *event, const char *format,
+			  struct tep_event_format *event, const char *format,
 			  int len_arg, struct print_arg *arg)
 {
 	struct tep_handle *pevent = event->pevent;
@@ -4130,7 +4130,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 
 static unsigned long long
 process_defined_func(struct trace_seq *s, void *data, int size,
-		     struct event_format *event, struct print_arg *arg)
+		     struct tep_event_format *event, struct print_arg *arg)
 {
 	struct tep_function_handler *func_handle = arg->func.func;
 	struct func_params *param;
@@ -4225,7 +4225,7 @@ static void free_args(struct print_arg *args)
 	}
 }
 
-static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struct event_format *event)
+static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struct tep_event_format *event)
 {
 	struct tep_handle *pevent = event->pevent;
 	struct format_field *field, *ip_field;
@@ -4402,7 +4402,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 
 static char *
 get_bprint_format(void *data, int size __maybe_unused,
-		  struct event_format *event)
+		  struct tep_event_format *event)
 {
 	struct tep_handle *pevent = event->pevent;
 	unsigned long long addr;
@@ -4437,7 +4437,7 @@ get_bprint_format(void *data, int size __maybe_unused,
 }
 
 static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
-			  struct event_format *event, struct print_arg *arg)
+			  struct tep_event_format *event, struct print_arg *arg)
 {
 	unsigned char *buf;
 	const char *fmt = "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x";
@@ -4590,7 +4590,7 @@ static void print_ip6_addr(struct trace_seq *s, char i, unsigned char *buf)
  * %pISpc print an IP address based on sockaddr; p adds port.
  */
 static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
-			  void *data, int size, struct event_format *event,
+			  void *data, int size, struct tep_event_format *event,
 			  struct print_arg *arg)
 {
 	unsigned char *buf;
@@ -4627,7 +4627,7 @@ static int print_ipv4_arg(struct trace_seq *s, const char *ptr, char i,
 }
 
 static int print_ipv6_arg(struct trace_seq *s, const char *ptr, char i,
-			  void *data, int size, struct event_format *event,
+			  void *data, int size, struct tep_event_format *event,
 			  struct print_arg *arg)
 {
 	char have_c = 0;
@@ -4677,7 +4677,7 @@ static int print_ipv6_arg(struct trace_seq *s, const char *ptr, char i,
 }
 
 static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
-			  void *data, int size, struct event_format *event,
+			  void *data, int size, struct tep_event_format *event,
 			  struct print_arg *arg)
 {
 	char have_c = 0, have_p = 0;
@@ -4759,7 +4759,7 @@ static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
 }
 
 static int print_ip_arg(struct trace_seq *s, const char *ptr,
-			void *data, int size, struct event_format *event,
+			void *data, int size, struct tep_event_format *event,
 			struct print_arg *arg)
 {
 	char i = *ptr;  /* 'i' or 'I' */
@@ -4866,7 +4866,7 @@ void tep_print_field(struct trace_seq *s, void *data,
 }
 
 void tep_print_fields(struct trace_seq *s, void *data,
-		      int size __maybe_unused, struct event_format *event)
+		      int size __maybe_unused, struct tep_event_format *event)
 {
 	struct format_field *field;
 
@@ -4878,7 +4878,7 @@ void tep_print_fields(struct trace_seq *s, void *data,
 	}
 }
 
-static void pretty_print(struct trace_seq *s, void *data, int size, struct event_format *event)
+static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_event_format *event)
 {
 	struct tep_handle *pevent = event->pevent;
 	struct print_fmt *print_fmt = &event->print_fmt;
@@ -5241,7 +5241,7 @@ int tep_data_type(struct tep_handle *pevent, struct tep_record *rec)
  *
  * This returns the event form a given @type;
  */
-struct event_format *tep_data_event_from_type(struct tep_handle *pevent, int type)
+struct tep_event_format *tep_data_event_from_type(struct tep_handle *pevent, int type)
 {
 	return tep_find_event(pevent, type);
 }
@@ -5399,7 +5399,7 @@ int tep_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline)
  * This parses the raw @data using the given @event information and
  * writes the print format into the trace_seq.
  */
-void tep_event_info(struct trace_seq *s, struct event_format *event,
+void tep_event_info(struct trace_seq *s, struct tep_event_format *event,
 		    struct tep_record *record)
 {
 	int print_pretty = 1;
@@ -5440,7 +5440,7 @@ static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
  * Returns the associated event for a given record, or NULL if non is
  * is found.
  */
-struct event_format *
+struct tep_event_format *
 tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record)
 {
 	int type;
@@ -5465,7 +5465,7 @@ tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record)
  * Writes the tasks comm, pid and CPU to @s.
  */
 void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
-			  struct event_format *event,
+			  struct tep_event_format *event,
 			  struct tep_record *record)
 {
 	void *data = record->data;
@@ -5493,7 +5493,7 @@ void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
  * Writes the timestamp of the record into @s.
  */
 void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
-			  struct event_format *event,
+			  struct tep_event_format *event,
 			  struct tep_record *record,
 			  bool use_trace_clock)
 {
@@ -5543,7 +5543,7 @@ void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
  * Writes the parsing of the record's data to @s.
  */
 void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
-			  struct event_format *event,
+			  struct tep_event_format *event,
 			  struct tep_record *record)
 {
 	static const char *spaces = "                    "; /* 20 spaces */
@@ -5562,7 +5562,7 @@ void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
 		     struct tep_record *record, bool use_trace_clock)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	event = tep_find_event_by_record(pevent, record);
 	if (!event) {
@@ -5584,8 +5584,8 @@ void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
 
 static int events_id_cmp(const void *a, const void *b)
 {
-	struct event_format * const * ea = a;
-	struct event_format * const * eb = b;
+	struct tep_event_format * const * ea = a;
+	struct tep_event_format * const * eb = b;
 
 	if ((*ea)->id < (*eb)->id)
 		return -1;
@@ -5598,8 +5598,8 @@ static int events_id_cmp(const void *a, const void *b)
 
 static int events_name_cmp(const void *a, const void *b)
 {
-	struct event_format * const * ea = a;
-	struct event_format * const * eb = b;
+	struct tep_event_format * const * ea = a;
+	struct tep_event_format * const * eb = b;
 	int res;
 
 	res = strcmp((*ea)->name, (*eb)->name);
@@ -5615,8 +5615,8 @@ static int events_name_cmp(const void *a, const void *b)
 
 static int events_system_cmp(const void *a, const void *b)
 {
-	struct event_format * const * ea = a;
-	struct event_format * const * eb = b;
+	struct tep_event_format * const * ea = a;
+	struct tep_event_format * const * eb = b;
 	int res;
 
 	res = strcmp((*ea)->system, (*eb)->system);
@@ -5630,9 +5630,9 @@ static int events_system_cmp(const void *a, const void *b)
 	return events_id_cmp(a, b);
 }
 
-struct event_format **tep_list_events(struct tep_handle *pevent, enum event_sort_type sort_type)
+struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum event_sort_type sort_type)
 {
-	struct event_format **events;
+	struct tep_event_format **events;
 	int (*sort)(const void *a, const void *b);
 
 	events = pevent->sort_events;
@@ -5715,7 +5715,7 @@ get_event_fields(const char *type, const char *name,
  * Returns an allocated array of fields. The last item in the array is NULL.
  * The array must be freed with free().
  */
-struct format_field **tep_event_common_fields(struct event_format *event)
+struct format_field **tep_event_common_fields(struct tep_event_format *event)
 {
 	return get_event_fields("common", event->name,
 				event->format.nr_common,
@@ -5729,7 +5729,7 @@ struct format_field **tep_event_common_fields(struct event_format *event)
  * Returns an allocated array of fields. The last item in the array is NULL.
  * The array must be freed with free().
  */
-struct format_field **tep_event_fields(struct event_format *event)
+struct format_field **tep_event_fields(struct tep_event_format *event)
 {
 	return get_event_fields("event", event->name,
 				event->format.nr_fields,
@@ -5971,7 +5971,7 @@ int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long si
 	return 0;
 }
 
-static int event_matches(struct event_format *event,
+static int event_matches(struct tep_event_format *event,
 			 int id, const char *sys_name,
 			 const char *event_name)
 {
@@ -5994,7 +5994,7 @@ static void free_handler(struct event_handler *handle)
 	free(handle);
 }
 
-static int find_event_handle(struct tep_handle *pevent, struct event_format *event)
+static int find_event_handle(struct tep_handle *pevent, struct tep_event_format *event)
 {
 	struct event_handler *handle, **next;
 
@@ -6035,11 +6035,11 @@ static int find_event_handle(struct tep_handle *pevent, struct event_format *eve
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum tep_errno __tep_parse_format(struct event_format **eventp,
+enum tep_errno __tep_parse_format(struct tep_event_format **eventp,
 				  struct tep_handle *pevent, const char *buf,
 				  unsigned long size, const char *sys)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	int ret;
 
 	init_input_buf(buf, size);
@@ -6144,12 +6144,12 @@ enum tep_errno __tep_parse_format(struct event_format **eventp,
 
 static enum tep_errno
 __parse_event(struct tep_handle *pevent,
-	      struct event_format **eventp,
+	      struct tep_event_format **eventp,
 	      const char *buf, unsigned long size,
 	      const char *sys)
 {
 	int ret = __tep_parse_format(eventp, pevent, buf, size, sys);
-	struct event_format *event = *eventp;
+	struct tep_event_format *event = *eventp;
 
 	if (event == NULL)
 		return ret;
@@ -6186,7 +6186,7 @@ __parse_event(struct tep_handle *pevent,
  * /sys/kernel/debug/tracing/events/.../.../format
  */
 enum tep_errno tep_parse_format(struct tep_handle *pevent,
-				struct event_format **eventp,
+				struct tep_event_format **eventp,
 				const char *buf,
 				unsigned long size, const char *sys)
 {
@@ -6210,7 +6210,7 @@ enum tep_errno tep_parse_format(struct tep_handle *pevent,
 enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
 			       unsigned long size, const char *sys)
 {
-	struct event_format *event = NULL;
+	struct tep_event_format *event = NULL;
 	return __parse_event(pevent, &event, buf, size, sys);
 }
 
@@ -6276,7 +6276,7 @@ int get_field_val(struct trace_seq *s, struct format_field *field,
  *
  * On failure, it returns NULL.
  */
-void *tep_get_field_raw(struct trace_seq *s, struct event_format *event,
+void *tep_get_field_raw(struct trace_seq *s, struct tep_event_format *event,
 			const char *name, struct tep_record *record,
 			int *len, int err)
 {
@@ -6323,7 +6323,7 @@ void *tep_get_field_raw(struct trace_seq *s, struct event_format *event,
  *
  * Returns 0 on success -1 on field not found.
  */
-int tep_get_field_val(struct trace_seq *s, struct event_format *event,
+int tep_get_field_val(struct trace_seq *s, struct tep_event_format *event,
 		      const char *name, struct tep_record *record,
 		      unsigned long long *val, int err)
 {
@@ -6348,7 +6348,7 @@ int tep_get_field_val(struct trace_seq *s, struct event_format *event,
  *
  * Returns 0 on success -1 on field not found.
  */
-int tep_get_common_field_val(struct trace_seq *s, struct event_format *event,
+int tep_get_common_field_val(struct trace_seq *s, struct tep_event_format *event,
 			     const char *name, struct tep_record *record,
 			     unsigned long long *val, int err)
 {
@@ -6373,7 +6373,7 @@ int tep_get_common_field_val(struct trace_seq *s, struct event_format *event,
  *
  * Returns 0 on success -1 on field not found.
  */
-int tep_get_any_field_val(struct trace_seq *s, struct event_format *event,
+int tep_get_any_field_val(struct trace_seq *s, struct tep_event_format *event,
 			  const char *name, struct tep_record *record,
 			  unsigned long long *val, int err)
 {
@@ -6399,7 +6399,7 @@ int tep_get_any_field_val(struct trace_seq *s, struct event_format *event,
  * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
  */
 int tep_print_num_field(struct trace_seq *s, const char *fmt,
-			struct event_format *event, const char *name,
+			struct tep_event_format *event, const char *name,
 			struct tep_record *record, int err)
 {
 	struct format_field *field = tep_find_field(event, name);
@@ -6431,7 +6431,7 @@ int tep_print_num_field(struct trace_seq *s, const char *fmt,
  * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
  */
 int tep_print_func_field(struct trace_seq *s, const char *fmt,
-			 struct event_format *event, const char *name,
+			 struct tep_event_format *event, const char *name,
 			 struct tep_record *record, int err)
 {
 	struct format_field *field = tep_find_field(event, name);
@@ -6591,11 +6591,11 @@ int tep_unregister_print_function(struct tep_handle *pevent,
 	return -1;
 }
 
-static struct event_format *search_event(struct tep_handle *pevent, int id,
+static struct tep_event_format *search_event(struct tep_handle *pevent, int id,
 					 const char *sys_name,
 					 const char *event_name)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 
 	if (id >= 0) {
 		/* search by id */
@@ -6635,7 +6635,7 @@ int tep_register_event_handler(struct tep_handle *pevent, int id,
 			       const char *sys_name, const char *event_name,
 			       tep_event_handler_func func, void *context)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct event_handler *handle;
 
 	event = search_event(pevent, id, sys_name, event_name);
@@ -6719,7 +6719,7 @@ int tep_unregister_event_handler(struct tep_handle *pevent, int id,
 				 const char *sys_name, const char *event_name,
 				 tep_event_handler_func func, void *context)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct event_handler *handle;
 	struct event_handler **next;
 
@@ -6797,7 +6797,7 @@ static void free_formats(struct format *format)
 	free_format_fields(format->fields);
 }
 
-void tep_free_format(struct event_format *event)
+void tep_free_format(struct tep_event_format *event)
 {
 	free(event->name);
 	free(event->system);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 44b7c2d41f9f..0e7775c5da69 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -96,14 +96,14 @@ extern int trace_seq_do_fprintf(struct trace_seq *s, FILE *fp);
 extern int trace_seq_do_printf(struct trace_seq *s);
 
 
-/* ----------------------- pevent ----------------------- */
+/* ----------------------- tep ----------------------- */
 
 struct tep_handle;
-struct event_format;
+struct tep_event_format;
 
 typedef int (*tep_event_handler_func)(struct trace_seq *s,
 				      struct tep_record *record,
-				      struct event_format *event,
+				      struct tep_event_format *event,
 				      void *context);
 
 typedef int (*tep_plugin_load_func)(struct tep_handle *pevent);
@@ -185,7 +185,7 @@ enum format_flags {
 
 struct format_field {
 	struct format_field	*next;
-	struct event_format	*event;
+	struct tep_event_format	*event;
 	char			*type;
 	char			*name;
 	char			*alias;
@@ -319,7 +319,7 @@ struct print_fmt {
 	struct print_arg	*args;
 };
 
-struct event_format {
+struct tep_event_format {
 	struct tep_handle	*pevent;
 	char			*name;
 	int			id;
@@ -493,9 +493,9 @@ struct tep_handle {
 	unsigned int printk_count;
 
 
-	struct event_format **events;
+	struct tep_event_format **events;
 	int nr_events;
-	struct event_format **sort_events;
+	struct tep_event_format **sort_events;
 	enum event_sort_type last_type;
 
 	int type_offset;
@@ -527,7 +527,7 @@ struct tep_handle {
 	struct tep_function_handler *func_handlers;
 
 	/* cache */
-	struct event_format *last_event;
+	struct tep_event_format *last_event;
 
 	char *trace_clock;
 };
@@ -627,14 +627,14 @@ int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
 int tep_pid_is_registered(struct tep_handle *pevent, int pid);
 
 void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
-			  struct event_format *event,
+			  struct tep_event_format *event,
 			  struct tep_record *record);
 void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
-			  struct event_format *event,
+			  struct tep_event_format *event,
 			  struct tep_record *record,
 			  bool use_trace_clock);
 void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
-			  struct event_format *event,
+			  struct tep_event_format *event,
 			  struct tep_record *record);
 void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
 		     struct tep_record *record, bool use_trace_clock);
@@ -645,32 +645,32 @@ int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long si
 enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
 			       unsigned long size, const char *sys);
 enum tep_errno tep_parse_format(struct tep_handle *pevent,
-				struct event_format **eventp,
+				struct tep_event_format **eventp,
 				const char *buf,
 				unsigned long size, const char *sys);
-void tep_free_format(struct event_format *event);
+void tep_free_format(struct tep_event_format *event);
 void tep_free_format_field(struct format_field *field);
 
-void *tep_get_field_raw(struct trace_seq *s, struct event_format *event,
+void *tep_get_field_raw(struct trace_seq *s, struct tep_event_format *event,
 			const char *name, struct tep_record *record,
 			int *len, int err);
 
-int tep_get_field_val(struct trace_seq *s, struct event_format *event,
+int tep_get_field_val(struct trace_seq *s, struct tep_event_format *event,
 		      const char *name, struct tep_record *record,
 		      unsigned long long *val, int err);
-int tep_get_common_field_val(struct trace_seq *s, struct event_format *event,
+int tep_get_common_field_val(struct trace_seq *s, struct tep_event_format *event,
 			     const char *name, struct tep_record *record,
 			     unsigned long long *val, int err);
-int tep_get_any_field_val(struct trace_seq *s, struct event_format *event,
+int tep_get_any_field_val(struct trace_seq *s, struct tep_event_format *event,
 			  const char *name, struct tep_record *record,
 			  unsigned long long *val, int err);
 
 int tep_print_num_field(struct trace_seq *s, const char *fmt,
-			   struct event_format *event, const char *name,
-			   struct tep_record *record, int err);
+			struct tep_event_format *event, const char *name,
+			struct tep_record *record, int err);
 
 int tep_print_func_field(struct trace_seq *s, const char *fmt,
-			 struct event_format *event, const char *name,
+			 struct tep_event_format *event, const char *name,
 			 struct tep_record *record, int err);
 
 int tep_register_event_handler(struct tep_handle *pevent, int id,
@@ -686,9 +686,9 @@ int tep_register_print_function(struct tep_handle *pevent,
 int tep_unregister_print_function(struct tep_handle *pevent,
 				  tep_func_handler func, char *name);
 
-struct format_field *tep_find_common_field(struct event_format *event, const char *name);
-struct format_field *tep_find_field(struct event_format *event, const char *name);
-struct format_field *tep_find_any_field(struct event_format *event, const char *name);
+struct format_field *tep_find_common_field(struct tep_event_format *event, const char *name);
+struct format_field *tep_find_field(struct tep_event_format *event, const char *name);
+struct format_field *tep_find_any_field(struct tep_event_format *event, const char *name);
 
 const char *tep_find_function(struct tep_handle *pevent, unsigned long long addr);
 unsigned long long
@@ -697,18 +697,18 @@ unsigned long long tep_read_number(struct tep_handle *pevent, const void *ptr, i
 int tep_read_number_field(struct format_field *field, const void *data,
 			  unsigned long long *value);
 
-struct event_format *tep_find_event(struct tep_handle *pevent, int id);
+struct tep_event_format *tep_find_event(struct tep_handle *pevent, int id);
 
-struct event_format *
+struct tep_event_format *
 tep_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *name);
 
-struct event_format *
+struct tep_event_format *
 tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
 
 void tep_data_lat_fmt(struct tep_handle *pevent,
 		      struct trace_seq *s, struct tep_record *record);
 int tep_data_type(struct tep_handle *pevent, struct tep_record *rec);
-struct event_format *tep_data_event_from_type(struct tep_handle *pevent, int type);
+struct tep_event_format *tep_data_event_from_type(struct tep_handle *pevent, int type);
 int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_flags(struct tep_handle *pevent, struct tep_record *rec);
@@ -721,15 +721,15 @@ int tep_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline);
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct format_field *field);
 void tep_print_fields(struct trace_seq *s, void *data,
-		      int size __maybe_unused, struct event_format *event);
-void tep_event_info(struct trace_seq *s, struct event_format *event,
+		      int size __maybe_unused, struct tep_event_format *event);
+void tep_event_info(struct trace_seq *s, struct tep_event_format *event,
 		       struct tep_record *record);
 int tep_strerror(struct tep_handle *pevent, enum tep_errno errnum,
 		    char *buf, size_t buflen);
 
-struct event_format **tep_list_events(struct tep_handle *pevent, enum event_sort_type);
-struct format_field **tep_event_common_fields(struct event_format *event);
-struct format_field **tep_event_fields(struct event_format *event);
+struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum event_sort_type);
+struct format_field **tep_event_common_fields(struct tep_event_format *event);
+struct format_field **tep_event_fields(struct tep_event_format *event);
 
 static inline int tep_get_cpus(struct tep_handle *pevent)
 {
@@ -926,7 +926,7 @@ struct filter_arg {
 
 struct filter_type {
 	int			event_id;
-	struct event_format	*event;
+	struct tep_event_format	*event;
 	struct filter_arg	*filter;
 };
 
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 682a50e8b5f7..3ecd9575698a 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -40,7 +40,7 @@ static struct format_field cpu = {
 
 struct event_list {
 	struct event_list	*next;
-	struct event_format	*event;
+	struct tep_event_format	*event;
 };
 
 static void show_error(char *error_buf, const char *fmt, ...)
@@ -242,7 +242,7 @@ static void free_arg(struct filter_arg *arg)
 }
 
 static int add_event(struct event_list **events,
-		      struct event_format *event)
+		     struct tep_event_format *event)
 {
 	struct event_list *list;
 
@@ -256,7 +256,7 @@ static int add_event(struct event_list **events,
 	return 0;
 }
 
-static int event_match(struct event_format *event,
+static int event_match(struct tep_event_format *event,
 		       regex_t *sreg, regex_t *ereg)
 {
 	if (sreg) {
@@ -272,7 +272,7 @@ static enum tep_errno
 find_event(struct tep_handle *pevent, struct event_list **events,
 	   char *sys_name, char *event_name)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	regex_t ereg;
 	regex_t sreg;
 	int match = 0;
@@ -347,7 +347,7 @@ static void free_events(struct event_list *events)
 }
 
 static enum tep_errno
-create_arg_item(struct event_format *event, const char *token,
+create_arg_item(struct tep_event_format *event, const char *token,
 		enum event_type type, struct filter_arg **parg, char *error_str)
 {
 	struct format_field *field;
@@ -953,7 +953,7 @@ static int collapse_tree(struct filter_arg *arg,
 }
 
 static enum tep_errno
-process_filter(struct event_format *event, struct filter_arg **parg,
+process_filter(struct tep_event_format *event, struct filter_arg **parg,
 	       char *error_str, int not)
 {
 	enum event_type type;
@@ -1193,7 +1193,7 @@ process_filter(struct event_format *event, struct filter_arg **parg,
 }
 
 static enum tep_errno
-process_event(struct event_format *event, const char *filter_str,
+process_event(struct tep_event_format *event, const char *filter_str,
 	      struct filter_arg **parg, char *error_str)
 {
 	int ret;
@@ -1218,7 +1218,7 @@ process_event(struct event_format *event, const char *filter_str,
 }
 
 static enum tep_errno
-filter_event(struct event_filter *filter, struct event_format *event,
+filter_event(struct event_filter *filter, struct tep_event_format *event,
 	     const char *filter_str, char *error_str)
 {
 	struct filter_type *filter_type;
@@ -1470,7 +1470,7 @@ static int copy_filter_type(struct event_filter *filter,
 			     struct filter_type *filter_type)
 {
 	struct filter_arg *arg;
-	struct event_format *event;
+	struct tep_event_format *event;
 	const char *sys;
 	const char *name;
 	char *str;
@@ -1552,7 +1552,7 @@ int tep_update_trivial(struct event_filter *dest, struct event_filter *source,
 {
 	struct tep_handle *src_pevent;
 	struct tep_handle *dest_pevent;
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct filter_type *filter_type;
 	struct filter_arg *arg;
 	char *str;
@@ -1696,11 +1696,11 @@ int tep_filter_event_has_trivial(struct event_filter *filter,
 	}
 }
 
-static int test_filter(struct event_format *event, struct filter_arg *arg,
+static int test_filter(struct tep_event_format *event, struct filter_arg *arg,
 		       struct tep_record *record, enum tep_errno *err);
 
 static const char *
-get_comm(struct event_format *event, struct tep_record *record)
+get_comm(struct tep_event_format *event, struct tep_record *record)
 {
 	const char *comm;
 	int pid;
@@ -1711,7 +1711,7 @@ get_comm(struct event_format *event, struct tep_record *record)
 }
 
 static unsigned long long
-get_value(struct event_format *event,
+get_value(struct tep_event_format *event,
 	  struct format_field *field, struct tep_record *record)
 {
 	unsigned long long val;
@@ -1747,11 +1747,11 @@ get_value(struct event_format *event,
 }
 
 static unsigned long long
-get_arg_value(struct event_format *event, struct filter_arg *arg,
+get_arg_value(struct tep_event_format *event, struct filter_arg *arg,
 	      struct tep_record *record, enum tep_errno *err);
 
 static unsigned long long
-get_exp_value(struct event_format *event, struct filter_arg *arg,
+get_exp_value(struct tep_event_format *event, struct filter_arg *arg,
 	      struct tep_record *record, enum tep_errno *err)
 {
 	unsigned long long lval, rval;
@@ -1806,7 +1806,7 @@ get_exp_value(struct event_format *event, struct filter_arg *arg,
 }
 
 static unsigned long long
-get_arg_value(struct event_format *event, struct filter_arg *arg,
+get_arg_value(struct tep_event_format *event, struct filter_arg *arg,
 	      struct tep_record *record, enum tep_errno *err)
 {
 	switch (arg->type) {
@@ -1830,7 +1830,7 @@ get_arg_value(struct event_format *event, struct filter_arg *arg,
 	return 0;
 }
 
-static int test_num(struct event_format *event, struct filter_arg *arg,
+static int test_num(struct tep_event_format *event, struct filter_arg *arg,
 		    struct tep_record *record, enum tep_errno *err)
 {
 	unsigned long long lval, rval;
@@ -1873,7 +1873,7 @@ static int test_num(struct event_format *event, struct filter_arg *arg,
 
 static const char *get_field_str(struct filter_arg *arg, struct tep_record *record)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct tep_handle *pevent;
 	unsigned long long addr;
 	const char *val = NULL;
@@ -1921,7 +1921,7 @@ static const char *get_field_str(struct filter_arg *arg, struct tep_record *reco
 	return val;
 }
 
-static int test_str(struct event_format *event, struct filter_arg *arg,
+static int test_str(struct tep_event_format *event, struct filter_arg *arg,
 		    struct tep_record *record, enum tep_errno *err)
 {
 	const char *val;
@@ -1952,7 +1952,7 @@ static int test_str(struct event_format *event, struct filter_arg *arg,
 	}
 }
 
-static int test_op(struct event_format *event, struct filter_arg *arg,
+static int test_op(struct tep_event_format *event, struct filter_arg *arg,
 		   struct tep_record *record, enum tep_errno *err)
 {
 	switch (arg->op.type) {
@@ -1974,7 +1974,7 @@ static int test_op(struct event_format *event, struct filter_arg *arg,
 	}
 }
 
-static int test_filter(struct event_format *event, struct filter_arg *arg,
+static int test_filter(struct tep_event_format *event, struct filter_arg *arg,
 		       struct tep_record *record, enum tep_errno *err)
 {
 	if (*err) {
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index 424747475d37..a671396f213f 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -123,7 +123,7 @@ static int add_and_get_index(const char *parent, const char *child, int cpu)
 }
 
 static int function_handler(struct trace_seq *s, struct tep_record *record,
-			    struct event_format *event, void *context)
+			    struct tep_event_format *event, void *context)
 {
 	struct tep_handle *pevent = event->pevent;
 	unsigned long long function;
diff --git a/tools/lib/traceevent/plugin_hrtimer.c b/tools/lib/traceevent/plugin_hrtimer.c
index b43bfec565d8..14eeb9b11515 100644
--- a/tools/lib/traceevent/plugin_hrtimer.c
+++ b/tools/lib/traceevent/plugin_hrtimer.c
@@ -26,7 +26,7 @@
 
 static int timer_expire_handler(struct trace_seq *s,
 				struct tep_record *record,
-				struct event_format *event, void *context)
+				struct tep_event_format *event, void *context)
 {
 	trace_seq_printf(s, "hrtimer=");
 
@@ -46,7 +46,7 @@ static int timer_expire_handler(struct trace_seq *s,
 
 static int timer_start_handler(struct trace_seq *s,
 			       struct tep_record *record,
-			       struct event_format *event, void *context)
+			       struct tep_event_format *event, void *context)
 {
 	trace_seq_printf(s, "hrtimer=");
 
diff --git a/tools/lib/traceevent/plugin_kmem.c b/tools/lib/traceevent/plugin_kmem.c
index 73966b05abce..ba4d7c7ad8bd 100644
--- a/tools/lib/traceevent/plugin_kmem.c
+++ b/tools/lib/traceevent/plugin_kmem.c
@@ -24,7 +24,7 @@
 #include "event-parse.h"
 
 static int call_site_handler(struct trace_seq *s, struct tep_record *record,
-			     struct event_format *event, void *context)
+			     struct tep_event_format *event, void *context)
 {
 	struct format_field *field;
 	unsigned long long val, addr;
diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 1d0d15906225..db108d1a1207 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -248,7 +248,7 @@ static const char *find_exit_reason(unsigned isa, int val)
 }
 
 static int print_exit_reason(struct trace_seq *s, struct tep_record *record,
-			     struct event_format *event, const char *field)
+			     struct tep_event_format *event, const char *field)
 {
 	unsigned long long isa;
 	unsigned long long val;
@@ -269,7 +269,7 @@ static int print_exit_reason(struct trace_seq *s, struct tep_record *record,
 }
 
 static int kvm_exit_handler(struct trace_seq *s, struct tep_record *record,
-			    struct event_format *event, void *context)
+			    struct tep_event_format *event, void *context)
 {
 	unsigned long long info1 = 0, info2 = 0;
 
@@ -292,7 +292,7 @@ static int kvm_exit_handler(struct trace_seq *s, struct tep_record *record,
 
 static int kvm_emulate_insn_handler(struct trace_seq *s,
 				    struct tep_record *record,
-				    struct event_format *event, void *context)
+				    struct tep_event_format *event, void *context)
 {
 	unsigned long long rip, csbase, len, flags, failed;
 	int llen;
@@ -331,7 +331,7 @@ static int kvm_emulate_insn_handler(struct trace_seq *s,
 
 
 static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct tep_record *record,
-					    struct event_format *event, void *context)
+					    struct tep_event_format *event, void *context)
 {
 	if (print_exit_reason(s, record, event, "exit_code") < 0)
 		return -1;
@@ -345,7 +345,7 @@ static int kvm_nested_vmexit_inject_handler(struct trace_seq *s, struct tep_reco
 }
 
 static int kvm_nested_vmexit_handler(struct trace_seq *s, struct tep_record *record,
-				     struct event_format *event, void *context)
+				     struct tep_event_format *event, void *context)
 {
 	tep_print_num_field(s, "rip %llx ", event, "rip", record, 1);
 
@@ -371,7 +371,7 @@ union kvm_mmu_page_role {
 };
 
 static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
-			      struct event_format *event, void *context)
+			      struct tep_event_format *event, void *context)
 {
 	unsigned long long val;
 	static const char *access_str[] = {
@@ -418,7 +418,7 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 
 static int kvm_mmu_get_page_handler(struct trace_seq *s,
 				    struct tep_record *record,
-				    struct event_format *event, void *context)
+				    struct tep_event_format *event, void *context)
 {
 	unsigned long long val;
 
diff --git a/tools/lib/traceevent/plugin_mac80211.c b/tools/lib/traceevent/plugin_mac80211.c
index de50a5316203..de36d1d5a450 100644
--- a/tools/lib/traceevent/plugin_mac80211.c
+++ b/tools/lib/traceevent/plugin_mac80211.c
@@ -25,7 +25,7 @@
 
 #define INDENT 65
 
-static void print_string(struct trace_seq *s, struct event_format *event,
+static void print_string(struct trace_seq *s, struct tep_event_format *event,
 			 const char *name, const void *data)
 {
 	struct format_field *f = tep_find_field(event, name);
@@ -59,7 +59,7 @@ static void print_string(struct trace_seq *s, struct event_format *event,
 
 static int drv_bss_info_changed(struct trace_seq *s,
 				struct tep_record *record,
-				struct event_format *event, void *context)
+				struct tep_event_format *event, void *context)
 {
 	void *data = record->data;
 
diff --git a/tools/lib/traceevent/plugin_sched_switch.c b/tools/lib/traceevent/plugin_sched_switch.c
index eecb4bd95c11..ec22d4de8890 100644
--- a/tools/lib/traceevent/plugin_sched_switch.c
+++ b/tools/lib/traceevent/plugin_sched_switch.c
@@ -66,7 +66,7 @@ static void write_and_save_comm(struct format_field *field,
 
 static int sched_wakeup_handler(struct trace_seq *s,
 				struct tep_record *record,
-				struct event_format *event, void *context)
+				struct tep_event_format *event, void *context)
 {
 	struct format_field *field;
 	unsigned long long val;
@@ -95,7 +95,7 @@ static int sched_wakeup_handler(struct trace_seq *s,
 
 static int sched_switch_handler(struct trace_seq *s,
 				struct tep_record *record,
-				struct event_format *event, void *context)
+				struct tep_event_format *event, void *context)
 {
 	struct format_field *field;
 	unsigned long long val;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6a748eca2edb..92007ebd9b8d 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -804,7 +804,7 @@ static struct syscall_fmt *syscall_fmt__find(const char *name)
 }
 
 struct syscall {
-	struct event_format *tp_format;
+	struct tep_event_format *tp_format;
 	int		    nr_args;
 	struct format_field *args;
 	const char	    *name;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index d277930b19a1..2a3eb5dc4ba5 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -102,7 +102,7 @@ struct perf_evsel {
 	char			*name;
 	double			scale;
 	const char		*unit;
-	struct event_format	*tp_format;
+	struct tep_event_format	*tp_format;
 	off_t			id_offset;
 	struct perf_stat_evsel  *stats;
 	void			*priv;
@@ -211,7 +211,7 @@ static inline struct perf_evsel *perf_evsel__newtp(const char *sys, const char *
 
 struct perf_evsel *perf_evsel__new_cycles(bool precise);
 
-struct event_format *event_format__new(const char *sys, const char *name);
+struct tep_event_format *event_format__new(const char *sys, const char *name);
 
 void perf_evsel__init(struct perf_evsel *evsel,
 		      struct perf_event_attr *attr, int idx);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 126578996dcf..a079243d3ffc 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -3209,7 +3209,7 @@ static int read_attr(int fd, struct perf_header *ph,
 static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
 						struct tep_handle *pevent)
 {
-	struct event_format *event;
+	struct tep_event_format *event;
 	char bf[128];
 
 	/* already prepared */
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index f74fbb652a4f..7629973ef6f1 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -385,7 +385,7 @@ get_tracepoint_field(struct pyrf_event *pevent, PyObject *attr_name)
 	struct format_field *field;
 
 	if (!evsel->tp_format) {
-		struct event_format *tp_format;
+		struct tep_event_format *tp_format;
 
 		tp_format = trace_event__tp_format_id(evsel->attr.config);
 		if (!tp_format)
@@ -1222,7 +1222,7 @@ static struct {
 static PyObject *pyrf__tracepoint(struct pyrf_evsel *pevsel,
 				  PyObject *args, PyObject *kwargs)
 {
-	struct event_format *tp_format;
+	struct tep_event_format *tp_format;
 	static char *kwlist[] = { "sys", "name", NULL };
 	char *sys  = NULL;
 	char *name = NULL;
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 45484f0f7292..370cc60f0afa 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -189,7 +189,7 @@ static void define_flag_field(const char *ev_name,
 	LEAVE;
 }
 
-static void define_event_symbols(struct event_format *event,
+static void define_event_symbols(struct tep_event_format *event,
 				 const char *ev_name,
 				 struct print_arg *args)
 {
@@ -338,7 +338,7 @@ static void perl_process_tracepoint(struct perf_sample *sample,
 				    struct addr_location *al)
 {
 	struct thread *thread = al->thread;
-	struct event_format *event = evsel->tp_format;
+	struct tep_event_format *event = evsel->tp_format;
 	struct format_field *field;
 	static char handler[256];
 	unsigned long long val;
@@ -537,7 +537,7 @@ static int perl_stop_script(void)
 
 static int perl_generate_script(struct tep_handle *pevent, const char *outfile)
 {
-	struct event_format *event = NULL;
+	struct tep_event_format *event = NULL;
 	struct format_field *f;
 	char fname[PATH_MAX];
 	int not_first, count;
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index dfc6093f118c..9a8a7b7ff64a 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -264,7 +264,7 @@ static void define_field(enum print_arg_type field_type,
 	Py_DECREF(t);
 }
 
-static void define_event_symbols(struct event_format *event,
+static void define_event_symbols(struct tep_event_format *event,
 				 const char *ev_name,
 				 struct print_arg *args)
 {
@@ -332,7 +332,7 @@ static void define_event_symbols(struct event_format *event,
 		define_event_symbols(event, ev_name, args->next);
 }
 
-static PyObject *get_field_numeric_entry(struct event_format *event,
+static PyObject *get_field_numeric_entry(struct tep_event_format *event,
 		struct format_field *field, void *data)
 {
 	bool is_array = field->flags & FIELD_IS_ARRAY;
@@ -790,7 +790,7 @@ static void python_process_tracepoint(struct perf_sample *sample,
 				      struct perf_evsel *evsel,
 				      struct addr_location *al)
 {
-	struct event_format *event = evsel->tp_format;
+	struct tep_event_format *event = evsel->tp_format;
 	PyObject *handler, *context, *t, *obj = NULL, *callchain;
 	PyObject *dict = NULL, *all_entries_dict = NULL;
 	static char handler_name[256];
@@ -1590,7 +1590,7 @@ static int python_stop_script(void)
 
 static int python_generate_script(struct tep_handle *pevent, const char *outfile)
 {
-	struct event_format *event = NULL;
+	struct tep_event_format *event = NULL;
 	struct format_field *f;
 	char fname[PATH_MAX];
 	int not_first, count;
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 920b1d58a068..562db55422be 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -33,7 +33,7 @@ static int get_common_field(struct scripting_context *context,
 			    int *offset, int *size, const char *type)
 {
 	struct tep_handle *pevent = context->pevent;
-	struct event_format *event;
+	struct tep_event_format *event;
 	struct format_field *field;
 
 	if (!*size) {
@@ -94,7 +94,7 @@ int common_pc(struct scripting_context *context)
 }
 
 unsigned long long
-raw_field_value(struct event_format *event, const char *name, void *data)
+raw_field_value(struct tep_event_format *event, const char *name, void *data)
 {
 	struct format_field *field;
 	unsigned long long val;
@@ -108,12 +108,12 @@ raw_field_value(struct event_format *event, const char *name, void *data)
 	return val;
 }
 
-unsigned long long read_size(struct event_format *event, void *ptr, int size)
+unsigned long long read_size(struct tep_event_format *event, void *ptr, int size)
 {
 	return tep_read_number(event->pevent, ptr, size);
 }
 
-void event_format__fprintf(struct event_format *event,
+void event_format__fprintf(struct tep_event_format *event,
 			   int cpu, void *data, int size, FILE *fp)
 {
 	struct tep_record record;
@@ -130,7 +130,7 @@ void event_format__fprintf(struct event_format *event,
 	trace_seq_destroy(&s);
 }
 
-void event_format__print(struct event_format *event,
+void event_format__print(struct tep_event_format *event,
 			 int cpu, void *data, int size)
 {
 	return event_format__fprintf(event, cpu, data, size, stdout);
@@ -189,8 +189,8 @@ int parse_event_file(struct tep_handle *pevent,
 	return tep_parse_event(pevent, buf, size, sys);
 }
 
-struct event_format *trace_find_next_event(struct tep_handle *pevent,
-					   struct event_format *event)
+struct tep_event_format *trace_find_next_event(struct tep_handle *pevent,
+					       struct tep_event_format *event)
 {
 	static int idx;
 
diff --git a/tools/perf/util/trace-event.c b/tools/perf/util/trace-event.c
index 58bb72f266f3..95664b2f771e 100644
--- a/tools/perf/util/trace-event.c
+++ b/tools/perf/util/trace-event.c
@@ -72,12 +72,12 @@ void trace_event__cleanup(struct trace_event *t)
 /*
  * Returns pointer with encoded error via <linux/err.h> interface.
  */
-static struct event_format*
+static struct tep_event_format*
 tp_format(const char *sys, const char *name)
 {
 	char *tp_dir = get_events_file(sys);
 	struct tep_handle *pevent = tevent.pevent;
-	struct event_format *event = NULL;
+	struct tep_event_format *event = NULL;
 	char path[PATH_MAX];
 	size_t size;
 	char *data;
@@ -102,7 +102,7 @@ tp_format(const char *sys, const char *name)
 /*
  * Returns pointer with encoded error via <linux/err.h> interface.
  */
-struct event_format*
+struct tep_event_format*
 trace_event__tp_format(const char *sys, const char *name)
 {
 	if (!tevent_initialized && trace_event__init2())
@@ -111,7 +111,7 @@ trace_event__tp_format(const char *sys, const char *name)
 	return tp_format(sys, name);
 }
 
-struct event_format *trace_event__tp_format_id(int id)
+struct tep_event_format *trace_event__tp_format_id(int id)
 {
 	if (!tevent_initialized && trace_event__init2())
 		return ERR_PTR(-ENOMEM);
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 40204ec3a7a2..dfbe0db9212d 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -21,17 +21,17 @@ int trace_event__init(struct trace_event *t);
 void trace_event__cleanup(struct trace_event *t);
 int trace_event__register_resolver(struct machine *machine,
 				   tep_func_resolver_t *func);
-struct event_format*
+struct tep_event_format*
 trace_event__tp_format(const char *sys, const char *name);
 
-struct event_format *trace_event__tp_format_id(int id);
+struct tep_event_format *trace_event__tp_format_id(int id);
 
 int bigendian(void);
 
-void event_format__fprintf(struct event_format *event,
+void event_format__fprintf(struct tep_event_format *event,
 			   int cpu, void *data, int size, FILE *fp);
 
-void event_format__print(struct event_format *event,
+void event_format__print(struct tep_event_format *event,
 			 int cpu, void *data, int size);
 
 int parse_ftrace_file(struct tep_handle *pevent, char *buf, unsigned long size);
@@ -39,7 +39,7 @@ int parse_event_file(struct tep_handle *pevent,
 		     char *buf, unsigned long size, char *sys);
 
 unsigned long long
-raw_field_value(struct event_format *event, const char *name, void *data);
+raw_field_value(struct tep_event_format *event, const char *name, void *data);
 
 void parse_proc_kallsyms(struct tep_handle *pevent, char *file, unsigned int size);
 void parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigned int size);
@@ -47,9 +47,9 @@ void parse_saved_cmdline(struct tep_handle *pevent, char *file, unsigned int siz
 
 ssize_t trace_report(int fd, struct trace_event *tevent, bool repipe);
 
-struct event_format *trace_find_next_event(struct tep_handle *pevent,
-					   struct event_format *event);
-unsigned long long read_size(struct event_format *event, void *ptr, int size);
+struct tep_event_format *trace_find_next_event(struct tep_handle *pevent,
+					       struct tep_event_format *event);
+unsigned long long read_size(struct tep_event_format *event, void *ptr, int size);
 unsigned long long eval_flag(const char *flag);
 
 int read_tracing_data(int fd, struct list_head *pattrs);
-- 
2.17.1
