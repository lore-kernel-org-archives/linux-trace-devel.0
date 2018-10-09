Return-Path: <SRS0=LhtG=MV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from terminus.zytor.com ([198.137.202.136]:52053 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbeJIMtF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Oct 2018 08:49:05 -0400
Date: Mon, 8 Oct 2018 22:33:46 -0700
From: tip-bot for Tzvetomir Stoyanov <tipbot@zytor.com>
Message-ID: <tip-bb3dd7e7c4d5e024d607c0ec06c2a2fb9408cc99@git.kernel.org>
Cc: jolsa@redhat.com, linux-trace-devel@vger.kernel.org,
        tglx@linutronix.de, mingo@kernel.org, tstoyanov@vmware.com,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        hpa@zytor.com, namhyung@kernel.org
Reply-To: mingo@kernel.org, tglx@linutronix.de, jolsa@redhat.com,
          linux-trace-devel@vger.kernel.org, hpa@zytor.com,
          acme@redhat.com, namhyung@kernel.org, tstoyanov@vmware.com,
          rostedt@goodmis.org, linux-kernel@vger.kernel.org
In-Reply-To: <20181005122225.522155df@gandalf.local.home>
References: <20181005122225.522155df@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent, perf tools: Move struct
 tep_handler definition in a local header file
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Commit-ID:  bb3dd7e7c4d5e024d607c0ec06c2a2fb9408cc99
Gitweb:     https://git.kernel.org/tip/bb3dd7e7c4d5e024d607c0ec06c2a2fb9408cc99
Author:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
AuthorDate: Fri, 5 Oct 2018 12:22:25 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Oct 2018 15:05:37 -0300

tools lib traceevent, perf tools: Move struct tep_handler definition in a local header file

As traceevent is going to be transferred into a proper library,
its local data should be protected from the library users.
This patch encapsulates struct tep_handler into a local header,
not visible outside of the library. It implements also a bunch
of new APIs, which library users can use to access tep_handler members.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux trace devel <linux-trace-devel@vger.kernel.org>
Cc: tzvetomir stoyanov <tstoyanov@vmware.com>
Link: http://lkml.kernel.org/r/20181005122225.522155df@gandalf.local.home
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Build               |   1 +
 tools/lib/traceevent/event-parse-api.c   | 275 +++++++++++++++++++++++++++++++
 tools/lib/traceevent/event-parse-local.h |  92 +++++++++++
 tools/lib/traceevent/event-parse.c       |   2 +
 tools/lib/traceevent/event-parse.h       | 228 ++++---------------------
 tools/lib/traceevent/event-plugin.c      |   1 +
 tools/lib/traceevent/parse-filter.c      |   1 +
 tools/perf/util/trace-event-parse.c      |  25 +--
 tools/perf/util/trace-event-read.c       |   2 +-
 9 files changed, 416 insertions(+), 211 deletions(-)

diff --git a/tools/lib/traceevent/Build b/tools/lib/traceevent/Build
index 0050c145d806..ba54bfce0b0b 100644
--- a/tools/lib/traceevent/Build
+++ b/tools/lib/traceevent/Build
@@ -5,6 +5,7 @@ libtraceevent-y += parse-filter.o
 libtraceevent-y += parse-utils.o
 libtraceevent-y += kbuffer-parse.o
 libtraceevent-y += tep_strerror.o
+libtraceevent-y += event-parse-api.o
 
 plugin_jbd2-y         += plugin_jbd2.o
 plugin_hrtimer-y      += plugin_hrtimer.o
diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
new file mode 100644
index 000000000000..61f7149085ee
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
+ * @tep: a handle to the tep_handle
+ *
+ * This returns pointer to the first element of the events array
+ * If @tep is NULL, NULL is returned.
+ */
+struct tep_event_format *tep_get_first_event(struct tep_handle *tep)
+{
+	if (tep && tep->events)
+		return tep->events[0];
+
+	return NULL;
+}
+
+/**
+ * tep_get_events_count - get the number of defined events
+ * @tep: a handle to the tep_handle
+ *
+ * This returns number of elements in event array
+ * If @tep is NULL, 0 is returned.
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
+ * @tep: a handle to the tep_handle
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
index 000000000000..b9bddde577f8
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
+	int pc_offset;
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
index 233179a712d6..3692f29fee46 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -22,6 +22,8 @@
 
 #include <netinet/in.h>
 #include "event-parse.h"
+
+#include "event-parse-local.h"
 #include "event-utils.h"
 #include "trace-seq.h"
 
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 9c29a5f7aa39..16bf4c890b6f 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -405,149 +405,18 @@ void tep_print_plugins(struct trace_seq *s,
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
@@ -655,11 +524,12 @@ unsigned long long tep_read_number(struct tep_handle *pevent, const void *ptr, i
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
 
@@ -689,65 +559,23 @@ struct tep_event_format **tep_list_events(struct tep_handle *pevent, enum tep_ev
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
index 46eb64eb0c2e..e74f16c88398 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -14,6 +14,7 @@
 #include <unistd.h>
 #include <dirent.h>
 #include "event-parse.h"
+#include "event-parse-local.h"
 #include "event-utils.h"
 #include "trace-seq.h"
 
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index d64b6128fa7d..ed87cb56713d 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -11,6 +11,7 @@
 #include <sys/types.h>
 
 #include "event-parse.h"
+#include "event-parse-local.h"
 #include "event-utils.h"
 
 #define COMM "COMM"
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 02f97f5dd588..32e558a65af3 100644
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
index add8441de579..76f12c705ef9 100644
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
 
