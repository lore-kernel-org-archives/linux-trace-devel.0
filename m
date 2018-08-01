Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f54.google.com ([209.85.221.54]:39329 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389196AbeHAO23 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 10:28:29 -0400
Received: by mail-wr1-f54.google.com with SMTP id h10-v6so19963380wre.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Aug 2018 05:42:51 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 20/24] tools/lib/traceevent: Rename pevent_find_* APIs
Date: Wed,  1 Aug 2018 15:41:52 +0300
Message-Id: <20180801124156.20894-21-tz.stoyanov@gmail.com>
In-Reply-To: <20180801124156.20894-1-tz.stoyanov@gmail.com>
References: <20180801124156.20894-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_find_function, pevent_find_function_address,
pevent_find_event_by_name, pevent_find_event_by_record
---
 tools/lib/traceevent/event-parse.c     | 22 +++++++++++-----------
 tools/lib/traceevent/event-parse.h     |  8 ++++----
 tools/lib/traceevent/parse-filter.c    |  6 +++---
 tools/lib/traceevent/plugin_function.c |  4 ++--
 tools/lib/traceevent/plugin_kmem.c     |  4 ++--
 5 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index dfc8e8e5042b..7fec48897e8b 100644
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
@@ -3507,7 +3507,7 @@ struct event_format *tep_find_event(struct tep_handle *pevent, int id)
  * @sys. If @sys is NULL the first event with @name is returned.
  */
 struct event_format *
-pevent_find_event_by_name(struct tep_handle *pevent,
+tep_find_event_by_name(struct tep_handle *pevent,
 			  const char *sys, const char *name)
 {
 	struct event_format *event;
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
index f0a11183eea1..222abfb06b5b 100644
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
index 397a89b53a71..aaf35995e9bb 100644
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
 
@@ -1578,7 +1578,7 @@ int tep_update_trivial(struct event_filter *dest, struct event_filter *source,
 
 		if (src_pevent != dest_pevent) {
 			/* do a look up */
-			event = pevent_find_event_by_name(src_pevent,
+			event = tep_find_event_by_name(src_pevent,
 							  event->system,
 							  event->name);
 			if (!event)
@@ -1909,7 +1909,7 @@ static const char *get_field_str(struct filter_arg *arg, struct tep_record *reco
 
 		if (arg->str.field->flags & (FIELD_IS_POINTER | FIELD_IS_LONG))
 			/* convert to a kernel symbol */
-			val = pevent_find_function(pevent, addr);
+			val = tep_find_function(pevent, addr);
 
 		if (val == NULL) {
 			/* just use the hex of the string name */
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index 7b214b6422e6..d926080f50fa 100644
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
index 398c5d19db38..41d31f035f00 100644
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
2.17.1
