Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37318 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727788AbeJEUaA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Oct 2018 16:30:00 -0400
Received: by mail-wm1-f66.google.com with SMTP id 185-v6so1968181wmt.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Oct 2018 06:31:12 -0700 (PDT)
From: tzvmware@gmail.com
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH v2] tools/lib/traceevent, tools/perf: Move struct tep_handler definition in a local header file
Date: Fri,  5 Oct 2018 16:31:09 +0300
Message-Id: <20181005133109.18740-1-tzvmware@gmail.com>
In-Reply-To: <20181005091709.2bd7abe8@gandalf.local.home>
References: <20181005091709.2bd7abe8@gandalf.local.home>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov <tstoyanov@vmware.com>"

As traceevent is going to be transfered into a poper library,
its local data should be protected from the library users.
This patch capsulates struct tep_handler into a local header,
not visible outside of the library. It implements also a bunch
of new APIs, which library users can use to access tep_handler members.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/Build               |   1 +
 tools/lib/traceevent/event-parse-api.c   | 275 +++++++++++++++++++++++
 tools/lib/traceevent/event-parse-local.h |  92 ++++++++
 tools/lib/traceevent/event-parse.c       |   2 +
 tools/lib/traceevent/event-parse.h       | 228 +++----------------
 tools/lib/traceevent/event-plugin.c      |   1 +
 tools/lib/traceevent/parse-filter.c      |   1 +
 tools/perf/util/trace-event-parse.c      |  25 ++-
 tools/perf/util/trace-event-read.c       |   2 +-
 9 files changed, 416 insertions(+), 211 deletions(-)
 create mode 100644 tools/lib/traceevent/event-parse-api.c
 create mode 100644 tools/lib/traceevent/event-parse-local.h

diff --git a/tools/lib/traceevent/Build b/tools/lib/traceevent/Build
index c681d0575d16..c10a937cc85a 100644
--- a/tools/lib/traceevent/Build
+++ b/tools/lib/traceevent/Build
@@ -4,6 +4,7 @@ libtraceevent-y += trace-seq.o
 libtraceevent-y += parse-filter.o
 libtraceevent-y += parse-utils.o
 libtraceevent-y += kbuffer-parse.o
+libtraceevent-y += event-parse-api.o
 
 plugin_jbd2-y         += plugin_jbd2.o
 plugin_hrtimer-y      += plugin_hrtimer.o
diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
new file mode 100644
index 000000000000..f4f9dc332ab2
--- /dev/null
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -0,0 +1,275 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+
+#include "event-parse.h"
+#include "event-parse-local.h"
+#include "event-utils.h"
+
+/**
+ * tep_get_first_event - returns the first event in the events array
+ * @pevent: a handle to the tep_handle
+ *
+ * This returns pointer to the first element of the events array
+ * If @pevent is NULL, NULL is returned.
+ */
+struct tep_event_format *tep_get_first_event(struct tep_handle *tep)
+{
+	if(tep && tep->events)
+		return tep->events[0];
+
+	return NULL;
+}
+
+/**
+ * tep_get_events_count - get the number of defined events
+ * @pevent: a handle to the tep_handle
+ *
+ * This returns number of elements in event array
+ * If @pevent is NULL, 0 is returned.
+ */
+int tep_get_events_count(struct tep_handle *tep)
+{
+	if(tep)
+		return tep->nr_events;
+	return 0;
+}
+
+/**
+ * tep_set_flag - set event parser flag
+ * @pevent: a handle to the tep_handle
+ * @flag: flag, or combination of flags to be set
+ * can be any combination from enum tep_flag
+ *
+ * This sets a flag or mbination of flags  from enum tep_flag
+  */
+void tep_set_flag(struct tep_handle *tep, int flag)
+{
+	if(tep)
+		tep->flags |= flag;
+}
+
+unsigned short __tep_data2host2(struct tep_handle *pevent, unsigned short data)
+{
+	unsigned short swap;
+
+	if (!pevent || pevent->host_bigendian == pevent->file_bigendian)
+		return data;
+
+	swap = ((data & 0xffULL) << 8) |
+		((data & (0xffULL << 8)) >> 8);
+
+	return swap;
+}
+
+unsigned int __tep_data2host4(struct tep_handle *pevent, unsigned int data)
+{
+	unsigned int swap;
+
+	if (!pevent || pevent->host_bigendian == pevent->file_bigendian)
+		return data;
+
+	swap = ((data & 0xffULL) << 24) |
+		((data & (0xffULL << 8)) << 8) |
+		((data & (0xffULL << 16)) >> 8) |
+		((data & (0xffULL << 24)) >> 24);
+
+	return swap;
+}
+
+unsigned long long
+__tep_data2host8(struct tep_handle *pevent, unsigned long long data)
+{
+	unsigned long long swap;
+
+	if (!pevent || pevent->host_bigendian == pevent->file_bigendian)
+		return data;
+
+	swap = ((data & 0xffULL) << 56) |
+		((data & (0xffULL << 8)) << 40) |
+		((data & (0xffULL << 16)) << 24) |
+		((data & (0xffULL << 24)) << 8) |
+		((data & (0xffULL << 32)) >> 8) |
+		((data & (0xffULL << 40)) >> 24) |
+		((data & (0xffULL << 48)) >> 40) |
+		((data & (0xffULL << 56)) >> 56);
+
+	return swap;
+}
+
+/**
+ * tep_get_header_page_size - get size of the header page
+ * @pevent: a handle to the tep_handle
+ *
+ * This returns size of the header page
+ * If @pevent is NULL, 0 is returned.
+ */
+int tep_get_header_page_size(struct tep_handle *pevent)
+{
+	if(pevent)
+		return pevent->header_page_size_size;
+	return 0;
+}
+
+/**
+ * tep_get_cpus - get the number of CPUs
+ * @pevent: a handle to the tep_handle
+ *
+ * This returns the number of CPUs
+ * If @pevent is NULL, 0 is returned.
+ */
+int tep_get_cpus(struct tep_handle *pevent)
+{
+	if(pevent)
+		return pevent->cpus;
+	return 0;
+}
+
+/**
+ * tep_set_cpus - set the number of CPUs
+ * @pevent: a handle to the tep_handle
+ *
+ * This sets the number of CPUs
+ */
+void tep_set_cpus(struct tep_handle *pevent, int cpus)
+{
+	if(pevent)
+		pevent->cpus = cpus;
+}
+
+/**
+ * tep_get_long_size - get the size of a long integer on the current machine
+ * @pevent: a handle to the tep_handle
+ *
+ * This returns the size of a long integer on the current machine
+ * If @pevent is NULL, 0 is returned.
+ */
+int tep_get_long_size(struct tep_handle *pevent)
+{
+	if(pevent)
+		return pevent->long_size;
+	return 0;
+}
+
+/**
+ * tep_set_long_size - set the size of a long integer on the current machine
+ * @pevent: a handle to the tep_handle
+ * @size: size, in bytes, of a long integer
+ *
+ * This sets the size of a long integer on the current machine
+ */
+void tep_set_long_size(struct tep_handle *pevent, int long_size)
+{
+	if(pevent)
+		pevent->long_size = long_size;
+}
+
+/**
+ * tep_get_page_size - get the size of a memory page on the current machine
+ * @pevent: a handle to the tep_handle
+ *
+ * This returns the size of a memory page on the current machine
+ * If @pevent is NULL, 0 is returned.
+ */
+int tep_get_page_size(struct tep_handle *pevent)
+{
+	if(pevent)
+		return pevent->page_size;
+	return 0;
+}
+
+/**
+ * tep_set_page_size - set the size of a memory page on the current machine
+ * @pevent: a handle to the tep_handle
+ * @_page_size: size of a memory page, in bytes
+ *
+ * This sets the size of a memory page on the current machine
+ */
+void tep_set_page_size(struct tep_handle *pevent, int _page_size)
+{
+	if(pevent)
+		pevent->page_size = _page_size;
+}
+
+/**
+ * tep_is_file_bigendian - get if the file is in big endian order
+ * @pevent: a handle to the tep_handle
+ *
+ * This returns if the file is in big endian order
+ * If @pevent is NULL, 0 is returned.
+ */
+int tep_is_file_bigendian(struct tep_handle *pevent)
+{
+	if(pevent)
+		return pevent->file_bigendian;
+	return 0;
+}
+
+/**
+ * tep_set_file_bigendian - set if the file is in big endian order
+ * @pevent: a handle to the tep_handle
+ * @endian: non zero, if the file is in big endian order
+ *
+ * This sets if the file is in big endian order
+ */
+void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian)
+{
+	if(pevent)
+		pevent->file_bigendian = endian;
+}
+
+/**
+ * tep_is_host_bigendian - get if the order of the current host is big endian
+ * @pevent: a handle to the tep_handle
+ *
+ * This gets if the order of the current host is big endian
+ * If @pevent is NULL, 0 is returned.
+ */
+int tep_is_host_bigendian(struct tep_handle *pevent)
+{
+	if(pevent)
+		return pevent->host_bigendian;
+	return 0;
+}
+
+/**
+ * tep_set_host_bigendian - set the order of the local host
+ * @pevent: a handle to the tep_handle
+ * @endian: non zero, if the local host has big endian order
+ *
+ * This sets the order of the local host
+ */
+void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian)
+{
+	if(pevent)
+		pevent->host_bigendian = endian;
+}
+
+/**
+ * tep_is_latency_format - get if the latency output format is configured
+ * @pevent: a handle to the tep_handle
+ *
+ * This gets if the latency output format is configured
+ * If @pevent is NULL, 0 is returned.
+ */
+int tep_is_latency_format(struct tep_handle *pevent)
+{
+	if(pevent)
+		return pevent->latency_format;
+	return 0;
+}
+
+/**
+ * tep_set_latency_format - set the latency output format
+ * @pevent: a handle to the tep_handle
+ * @lat: non zero for latency output format
+ *
+ * This sets the latency output format
+  */
+void tep_set_latency_format(struct tep_handle *pevent, int lat)
+{
+	if(pevent)
+		pevent->latency_format = lat;
+}
diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
new file mode 100644
index 000000000000..96af5a433dda
--- /dev/null
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+
+#ifndef _PARSE_EVENTS_INT_H
+#define _PARSE_EVENTS_INT_H
+
+struct cmdline;
+struct cmdline_list;
+struct func_map;
+struct func_list;
+struct event_handler;
+struct func_resolver;
+
+struct tep_handle {
+	int ref_count;
+
+	int header_page_ts_offset;
+	int header_page_ts_size;
+	int header_page_size_offset;
+	int header_page_size_size;
+	int header_page_data_offset;
+	int header_page_data_size;
+	int header_page_overwrite;
+
+	enum tep_endian file_bigendian;
+	enum tep_endian host_bigendian;
+
+	int latency_format;
+
+	int old_format;
+
+	int cpus;
+	int long_size;
+	int page_size;
+
+	struct cmdline *cmdlines;
+	struct cmdline_list *cmdlist;
+	int cmdline_count;
+
+	struct func_map *func_map;
+	struct func_resolver *func_resolver;
+	struct func_list *funclist;
+	unsigned int func_count;
+
+	struct printk_map *printk_map;
+	struct printk_list *printklist;
+	unsigned int printk_count;
+
+
+	struct tep_event_format **events;
+	int nr_events;
+	struct tep_event_format **sort_events;
+	enum tep_event_sort_type last_type;
+
+	int type_offset;
+	int type_size;
+
+	int pid_offset;
+	int pid_size;
+
+ 	int pc_offset;
+	int pc_size;
+
+	int flags_offset;
+	int flags_size;
+
+	int ld_offset;
+	int ld_size;
+
+	int print_raw;
+
+	int test_filters;
+
+	int flags;
+
+	struct tep_format_field *bprint_ip_field;
+	struct tep_format_field *bprint_fmt_field;
+	struct tep_format_field *bprint_buf_field;
+
+	struct event_handler *handlers;
+	struct tep_function_handler *func_handlers;
+
+	/* cache */
+	struct tep_event_format *last_event;
+
+	char *trace_clock;
+};
+
+#endif /* _PARSE_EVENTS_INT_H */
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 29e0825fbb92..aabd7516bafd 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -37,6 +37,8 @@
 
 #include <netinet/in.h>
 #include "event-parse.h"
+
+#include "event-parse-local.h"
 #include "event-utils.h"
 
 static const char *input_buf;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index c8d911bed12a..58d55ae81bfa 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -447,149 +447,18 @@ void tep_print_plugins(struct trace_seq *s,
 			const char *prefix, const char *suffix,
 			const struct tep_plugin_list *list);
 
-struct cmdline;
-struct cmdline_list;
-struct func_map;
-struct func_list;
-struct event_handler;
-struct func_resolver;
-
+/* tep_handle */
 typedef char *(tep_func_resolver_t)(void *priv,
 				    unsigned long long *addrp, char **modp);
+void tep_set_flag(struct tep_handle *tep, int flag);
+unsigned short __tep_data2host2(struct tep_handle *pevent, unsigned short data);
+unsigned int __tep_data2host4(struct tep_handle *pevent, unsigned int data);
+unsigned long long
+__tep_data2host8(struct tep_handle *pevent, unsigned long long data);
 
-struct tep_handle {
-	int ref_count;
-
-	int header_page_ts_offset;
-	int header_page_ts_size;
-	int header_page_size_offset;
-	int header_page_size_size;
-	int header_page_data_offset;
-	int header_page_data_size;
-	int header_page_overwrite;
-
-	int file_bigendian;
-	int host_bigendian;
-
-	int latency_format;
-
-	int old_format;
-
-	int cpus;
-	int long_size;
-	int page_size;
-
-	struct cmdline *cmdlines;
-	struct cmdline_list *cmdlist;
-	int cmdline_count;
-
-	struct func_map *func_map;
-	struct func_resolver *func_resolver;
-	struct func_list *funclist;
-	unsigned int func_count;
-
-	struct printk_map *printk_map;
-	struct printk_list *printklist;
-	unsigned int printk_count;
-
-
-	struct tep_event_format **events;
-	int nr_events;
-	struct tep_event_format **sort_events;
-	enum tep_event_sort_type last_type;
-
-	int type_offset;
-	int type_size;
-
-	int pid_offset;
-	int pid_size;
-
- 	int pc_offset;
-	int pc_size;
-
-	int flags_offset;
-	int flags_size;
-
-	int ld_offset;
-	int ld_size;
-
-	int print_raw;
-
-	int test_filters;
-
-	int flags;
-
-	struct tep_format_field *bprint_ip_field;
-	struct tep_format_field *bprint_fmt_field;
-	struct tep_format_field *bprint_buf_field;
-
-	struct event_handler *handlers;
-	struct tep_function_handler *func_handlers;
-
-	/* cache */
-	struct tep_event_format *last_event;
-
-	char *trace_clock;
-};
-
-static inline void tep_set_flag(struct tep_handle *pevent, int flag)
-{
-	pevent->flags |= flag;
-}
-
-static inline unsigned short
-__tep_data2host2(struct tep_handle *pevent, unsigned short data)
-{
-	unsigned short swap;
-
-	if (pevent->host_bigendian == pevent->file_bigendian)
-		return data;
-
-	swap = ((data & 0xffULL) << 8) |
-		((data & (0xffULL << 8)) >> 8);
-
-	return swap;
-}
-
-static inline unsigned int
-__tep_data2host4(struct tep_handle *pevent, unsigned int data)
-{
-	unsigned int swap;
-
-	if (pevent->host_bigendian == pevent->file_bigendian)
-		return data;
-
-	swap = ((data & 0xffULL) << 24) |
-		((data & (0xffULL << 8)) << 8) |
-		((data & (0xffULL << 16)) >> 8) |
-		((data & (0xffULL << 24)) >> 24);
-
-	return swap;
-}
-
-static inline unsigned long long
-__tep_data2host8(struct tep_handle *pevent, unsigned long long data)
-{
-	unsigned long long swap;
-
-	if (pevent->host_bigendian == pevent->file_bigendian)
-		return data;
-
-	swap = ((data & 0xffULL) << 56) |
-		((data & (0xffULL << 8)) << 40) |
-		((data & (0xffULL << 16)) << 24) |
-		((data & (0xffULL << 24)) << 8) |
-		((data & (0xffULL << 32)) >> 8) |
-		((data & (0xffULL << 40)) >> 24) |
-		((data & (0xffULL << 48)) >> 40) |
-		((data & (0xffULL << 56)) >> 56);
-
-	return swap;
-}
-
-#define tep_data2host2(pevent, ptr)		__tep_data2host2(pevent, *(unsigned short *)(ptr))
-#define tep_data2host4(pevent, ptr)		__tep_data2host4(pevent, *(unsigned int *)(ptr))
-#define tep_data2host8(pevent, ptr)					\
+#define tep_data2host2(pevent, ptr)	__tep_data2host2(pevent, *(unsigned short *)(ptr))
+#define tep_data2host4(pevent, ptr)	__tep_data2host4(pevent, *(unsigned int *)(ptr))
+#define tep_data2host8(pevent, ptr)	\
 ({								\
 	unsigned long long __val;				\
 								\
@@ -697,11 +566,12 @@ unsigned long long tep_read_number(struct tep_handle *pevent, const void *ptr, i
 int tep_read_number_field(struct tep_format_field *field, const void *data,
 			  unsigned long long *value);
 
+struct tep_event_format *tep_get_first_event(struct tep_handle *tep);
+int tep_get_events_count(struct tep_handle *tep);
 struct tep_event_format *tep_find_event(struct tep_handle *pevent, int id);
 
 struct tep_event_format *
 tep_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *name);
-
 struct tep_event_format *
 tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
 
@@ -731,65 +601,23 @@ struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum tep_ev
 struct tep_format_field **tep_event_common_fields(struct tep_event_format *event);
 struct tep_format_field **tep_event_fields(struct tep_event_format *event);
 
-static inline int tep_get_cpus(struct tep_handle *pevent)
-{
-	return pevent->cpus;
-}
-
-static inline void tep_set_cpus(struct tep_handle *pevent, int cpus)
-{
-	pevent->cpus = cpus;
-}
-
-static inline int tep_get_long_size(struct tep_handle *pevent)
-{
-	return pevent->long_size;
-}
-
-static inline void tep_set_long_size(struct tep_handle *pevent, int long_size)
-{
-	pevent->long_size = long_size;
-}
-
-static inline int tep_get_page_size(struct tep_handle *pevent)
-{
-	return pevent->page_size;
-}
-
-static inline void tep_set_page_size(struct tep_handle *pevent, int _page_size)
-{
-	pevent->page_size = _page_size;
-}
-
-static inline int tep_is_file_bigendian(struct tep_handle *pevent)
-{
-	return pevent->file_bigendian;
-}
-
-static inline void tep_set_file_bigendian(struct tep_handle *pevent, int endian)
-{
-	pevent->file_bigendian = endian;
-}
-
-static inline int tep_is_host_bigendian(struct tep_handle *pevent)
-{
-	return pevent->host_bigendian;
-}
-
-static inline void tep_set_host_bigendian(struct tep_handle *pevent, int endian)
-{
-	pevent->host_bigendian = endian;
-}
-
-static inline int tep_is_latency_format(struct tep_handle *pevent)
-{
-	return pevent->latency_format;
-}
-
-static inline void tep_set_latency_format(struct tep_handle *pevent, int lat)
-{
-	pevent->latency_format = lat;
-}
+enum tep_endian {
+        TEP_LITTLE_ENDIAN = 0,
+        TEP_BIG_ENDIAN
+};
+int tep_get_cpus(struct tep_handle *pevent);
+void tep_set_cpus(struct tep_handle *pevent, int cpus);
+int tep_get_long_size(struct tep_handle *pevent);
+void tep_set_long_size(struct tep_handle *pevent, int long_size);
+int tep_get_page_size(struct tep_handle *pevent);
+void tep_set_page_size(struct tep_handle *pevent, int _page_size);
+int tep_is_file_bigendian(struct tep_handle *pevent);
+void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian);
+int tep_is_host_bigendian(struct tep_handle *pevent);
+void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian endian);
+int tep_is_latency_format(struct tep_handle *pevent);
+void tep_set_latency_format(struct tep_handle *pevent, int lat);
+int tep_get_header_page_size(struct tep_handle *pevent);
 
 struct tep_handle *tep_alloc(void);
 void tep_free(struct tep_handle *pevent);
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index f6a9f9363c8d..d15313dbcc8f 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -28,6 +28,7 @@
 #include <unistd.h>
 #include <dirent.h>
 #include "event-parse.h"
+#include "event-parse-local.h"
 #include "event-utils.h"
 
 #define LOCAL_PLUGIN_DIR ".traceevent/plugins"
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index c4a5404f5f2b..eebbff7cd1a3 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -25,6 +25,7 @@
 #include <sys/types.h>
 
 #include "event-parse.h"
+#include "event-parse-local.h"
 #include "event-utils.h"
 
 #define COMM "COMM"
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 2ea658268767..a6ec3983cb02 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -37,10 +37,11 @@ static int get_common_field(struct scripting_context *context,
 	struct tep_format_field *field;
 
 	if (!*size) {
-		if (!pevent->events)
+
+		event = tep_get_first_event(pevent);
+		if (!event)
 			return 0;
 
-		event = pevent->events[0];
 		field = tep_find_common_field(event, type);
 		if (!field)
 			return 0;
@@ -193,25 +194,29 @@ struct tep_event_format *trace_find_next_event(struct tep_handle *pevent,
 					       struct tep_event_format *event)
 {
 	static int idx;
+	int events_count;
+	struct tep_event_format *all_events;
 
-	if (!pevent || !pevent->events)
+	all_events = tep_get_first_event(pevent);
+	events_count = tep_get_events_count(pevent);
+	if (!pevent || !all_events || events_count < 1)
 		return NULL;
 
 	if (!event) {
 		idx = 0;
-		return pevent->events[0];
+		return all_events;
 	}
 
-	if (idx < pevent->nr_events && event == pevent->events[idx]) {
+	if (idx < events_count && event == (all_events + idx)) {
 		idx++;
-		if (idx == pevent->nr_events)
+		if (idx == events_count)
 			return NULL;
-		return pevent->events[idx];
+		return (all_events + idx);
 	}
 
-	for (idx = 1; idx < pevent->nr_events; idx++) {
-		if (event == pevent->events[idx - 1])
-			return pevent->events[idx];
+	for (idx = 1; idx < events_count; idx++) {
+		if (event == (all_events + (idx - 1)))
+			return (all_events + idx);
 	}
 	return NULL;
 }
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index b98ee2a2eb44..cdf6de82a507 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -241,7 +241,7 @@ static int read_header_files(struct tep_handle *pevent)
 		 * The commit field in the page is of type long,
 		 * use that instead, since it represents the kernel.
 		 */
-		tep_set_long_size(pevent, pevent->header_page_size_size);
+		tep_set_long_size(pevent, tep_get_header_page_size(pevent));
 	}
 	free(header_page);
 
-- 
2.17.1
