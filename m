Return-Path: <SRS0=PkBc=KX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:42196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728742AbeHHSdd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Aug 2018 14:33:33 -0400
Message-Id: <20180808161309.954102356@goodmis.org>
Date: Wed, 08 Aug 2018 11:56:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [RFC][PATCH 20/24] tools/lib/traceevent: Rename pevent_find_* APIs
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_find_function, pevent_find_function_address,
pevent_find_event_by_name, pevent_find_event_by_record

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c     | 24 ++++++++++++------------
 tools/lib/traceevent/event-parse.h     |  8 ++++----
 tools/lib/traceevent/parse-filter.c    | 10 +++++-----
 tools/lib/traceevent/plugin_function.c |  4 ++--
 tools/lib/traceevent/plugin_kmem.c     |  4 ++--
 5 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 652b8ef6f4c7..53d866434478 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -503,7 +503,7 @@ find_func(struct tep_handle *pevent, unsigned long long addr)
 }
 
 /**
- * pevent_find_function - find a function by a given address
+ * tep_find_function - find a function by a given address
  * @pevent: handle for the pevent
  * @addr: the address to find the function with
  *
@@ -511,7 +511,7 @@ find_func(struct tep_handle *pevent, unsigned long long addr)
  * address. Note, the address does not have to be exact, it
  * will select the function that would contain the address.
  */
-const char *pevent_find_function(struct tep_handle *pevent, unsigned long long addr)
+const char *tep_find_function(struct tep_handle *pevent, unsigned long long addr)
 {
 	struct func_map *map;
 
@@ -523,16 +523,16 @@ const char *pevent_find_function(struct tep_handle *pevent, unsigned long long a
 }
 
 /**
- * pevent_find_function_address - find a function address by a given address
+ * tep_find_function_address - find a function address by a given address
  * @pevent: handle for the pevent
  * @addr: the address to find the function with
  *
  * Returns the address the function starts at. This can be used in
- * conjunction with pevent_find_function to print both the function
+ * conjunction with tep_find_function to print both the function
  * name and the function offset.
  */
 unsigned long long
-pevent_find_function_address(struct tep_handle *pevent, unsigned long long addr)
+tep_find_function_address(struct tep_handle *pevent, unsigned long long addr)
 {
 	struct func_map *map;
 
@@ -3498,7 +3498,7 @@ struct event_format *tep_find_event(struct tep_handle *pevent, int id)
 }
 
 /**
- * pevent_find_event_by_name - find an event by given name
+ * tep_find_event_by_name - find an event by given name
  * @pevent: a handle to the pevent
  * @sys: the system name to search for
  * @name: the name of the event to search for
@@ -3507,8 +3507,8 @@ struct event_format *tep_find_event(struct tep_handle *pevent, int id)
  * @sys. If @sys is NULL the first event with @name is returned.
  */
 struct event_format *
-pevent_find_event_by_name(struct tep_handle *pevent,
-			  const char *sys, const char *name)
+tep_find_event_by_name(struct tep_handle *pevent,
+		       const char *sys, const char *name)
 {
 	struct event_format *event;
 	int i;
@@ -5433,7 +5433,7 @@ static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
 }
 
 /**
- * pevent_find_event_by_record - return the event from a given record
+ * tep_find_event_by_record - return the event from a given record
  * @pevent: a handle to the pevent
  * @record: The record to get the event from
  *
@@ -5441,7 +5441,7 @@ static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
  * is found.
  */
 struct event_format *
-pevent_find_event_by_record(struct tep_handle *pevent, struct tep_record *record)
+tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record)
 {
 	int type;
 
@@ -5564,7 +5564,7 @@ void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
 {
 	struct event_format *event;
 
-	event = pevent_find_event_by_record(pevent, record);
+	event = tep_find_event_by_record(pevent, record);
 	if (!event) {
 		int i;
 		int type = trace_parse_common_type(pevent, record->data);
@@ -6607,7 +6607,7 @@ static struct event_format *pevent_search_event(struct tep_handle *pevent, int i
 		if (sys_name && (strcmp(sys_name, event->system) != 0))
 			return NULL;
 	} else {
-		event = pevent_find_event_by_name(pevent, sys_name, event_name);
+		event = tep_find_event_by_name(pevent, sys_name, event_name);
 		if (!event)
 			return NULL;
 	}
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 04ffc6e508cf..63ec6d419219 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -690,9 +690,9 @@ struct format_field *tep_find_common_field(struct event_format *event, const cha
 struct format_field *tep_find_field(struct event_format *event, const char *name);
 struct format_field *tep_find_any_field(struct event_format *event, const char *name);
 
-const char *pevent_find_function(struct tep_handle *pevent, unsigned long long addr);
+const char *tep_find_function(struct tep_handle *pevent, unsigned long long addr);
 unsigned long long
-pevent_find_function_address(struct tep_handle *pevent, unsigned long long addr);
+tep_find_function_address(struct tep_handle *pevent, unsigned long long addr);
 unsigned long long tep_read_number(struct tep_handle *pevent, const void *ptr, int size);
 int tep_read_number_field(struct format_field *field, const void *data,
 			  unsigned long long *value);
@@ -700,10 +700,10 @@ int tep_read_number_field(struct format_field *field, const void *data,
 struct event_format *tep_find_event(struct tep_handle *pevent, int id);
 
 struct event_format *
-pevent_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *name);
+tep_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *name);
 
 struct event_format *
-pevent_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
+tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
 
 void tep_data_lat_fmt(struct tep_handle *pevent,
 		      struct trace_seq *s, struct tep_record *record);
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 474d820e97e1..3efab9b4298f 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1478,7 +1478,7 @@ static int copy_filter_type(struct event_filter *filter,
 	/* Can't assume that the pevent's are the same */
 	sys = filter_type->event->system;
 	name = filter_type->event->name;
-	event = pevent_find_event_by_name(filter->pevent, sys, name);
+	event = tep_find_event_by_name(filter->pevent, sys, name);
 	if (!event)
 		return -1;
 
@@ -1578,9 +1578,9 @@ int tep_update_trivial(struct event_filter *dest, struct event_filter *source,
 
 		if (src_pevent != dest_pevent) {
 			/* do a look up */
-			event = pevent_find_event_by_name(src_pevent,
-							  event->system,
-							  event->name);
+			event = tep_find_event_by_name(src_pevent,
+						       event->system,
+						       event->name);
 			if (!event)
 				return -1;
 		}
@@ -1909,7 +1909,7 @@ static const char *get_field_str(struct filter_arg *arg, struct tep_record *reco
 
 		if (arg->str.field->flags & (FIELD_IS_POINTER | FIELD_IS_LONG))
 			/* convert to a kernel symbol */
-			val = pevent_find_function(pevent, addr);
+			val = tep_find_function(pevent, addr);
 
 		if (val == NULL) {
 			/* just use the hex of the string name */
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index 0962120960eb..424747475d37 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -135,12 +135,12 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	if (tep_get_field_val(s, event, "ip", record, &function, 1))
 		return trace_seq_putc(s, '!');
 
-	func = pevent_find_function(pevent, function);
+	func = tep_find_function(pevent, function);
 
 	if (tep_get_field_val(s, event, "parent_ip", record, &pfunction, 1))
 		return trace_seq_putc(s, '!');
 
-	parent = pevent_find_function(pevent, pfunction);
+	parent = tep_find_function(pevent, pfunction);
 
 	if (parent && ftrace_indent->set)
 		index = add_and_get_index(parent, func, record->cpu);
diff --git a/tools/lib/traceevent/plugin_kmem.c b/tools/lib/traceevent/plugin_kmem.c
index 6d5938d82c66..73966b05abce 100644
--- a/tools/lib/traceevent/plugin_kmem.c
+++ b/tools/lib/traceevent/plugin_kmem.c
@@ -38,11 +38,11 @@ static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 	if (tep_read_number_field(field, data, &val))
 		return 1;
 
-	func = pevent_find_function(event->pevent, val);
+	func = tep_find_function(event->pevent, val);
 	if (!func)
 		return 1;
 
-	addr = pevent_find_function_address(event->pevent, val);
+	addr = tep_find_function_address(event->pevent, val);
 
 	trace_seq_printf(s, "(%s+0x%x) ", func, (int)(val - addr));
 	return 1;
-- 
2.18.0
