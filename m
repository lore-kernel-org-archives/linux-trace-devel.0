Return-Path: <SRS0=XDEQ=MW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-co1nam03on0041.outbound.protection.outlook.com ([104.47.40.41]:56128
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726022AbeJJSM5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Oct 2018 14:12:57 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] tools lib traceevent, perf tools: Move struct tep_handler
 definition in a local header file
Date: Wed, 10 Oct 2018 10:51:17 +0000
Message-ID: <20181010105105.826-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

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
 include/traceevent/event-parse.h         | 238 +++-----------
 kernel-shark-qt/examples/datafilter.c    |   4 +-
 kernel-shark-qt/src/libkshark-configio.c |  13 +-
 lib/trace-cmd/trace-input.c              |  26 +-
 lib/trace-cmd/trace-util.c               |   2 +-
 lib/traceevent/Makefile                  |   1 +
 lib/traceevent/event-parse-api.c         | 401 +++++++++++++++++++++++
 lib/traceevent/event-parse-local.h       |  94 ++++++
 lib/traceevent/event-parse.c             |   2 +
 lib/traceevent/event-plugin.c            |   1 +
 lib/traceevent/parse-filter.c            |   1 +
 tracecmd/trace-check-events.c            |   2 +-
 tracecmd/trace-output.c                  |   2 +-
 tracecmd/trace-read.c                    |  10 +-
 tracecmd/trace-split.c                   |   2 +-
 15 files changed, 569 insertions(+), 230 deletions(-)
 create mode 100644 lib/traceevent/event-parse-api.c
 create mode 100644 lib/traceevent/event-parse-local.h

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-pa=
rse.h
index d148633..18652c8 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -391,151 +391,21 @@ void tep_print_plugins(struct trace_seq *s,
 			const char *prefix, const char *suffix,
 			const struct tep_plugin_list *list);
=20
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
+void tep_set_flag(struct tep_handle *tep, enum tep_flag flag);
+void tep_reset_flag(struct tep_handle *tep, enum tep_flag flag);
+int tep_check_flag(struct tep_handle *tep, enum tep_flag flag);
=20
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
-	int parsing_failures;
-
-	/* cache */
-	struct tep_event_format *last_event;
-
-	char *trace_clock;
-};
-
-static inline void tep_set_flag(struct tep_handle *pevent, int flag)
-{
-	pevent->flags |=3D flag;
-}
-
-static inline unsigned short
-__tep_data2host2(struct tep_handle *pevent, unsigned short data)
-{
-	unsigned short swap;
-
-	if (pevent->host_bigendian =3D=3D pevent->file_bigendian)
-		return data;
-
-	swap =3D ((data & 0xffULL) << 8) |
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
-	if (pevent->host_bigendian =3D=3D pevent->file_bigendian)
-		return data;
-
-	swap =3D ((data & 0xffULL) << 24) |
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
-	if (pevent->host_bigendian =3D=3D pevent->file_bigendian)
-		return data;
-
-	swap =3D ((data & 0xffULL) << 56) |
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
+unsigned short __tep_data2host2(struct tep_handle *pevent, unsigned short =
data);
+unsigned int __tep_data2host4(struct tep_handle *pevent, unsigned int data=
);
+unsigned long long
+__tep_data2host8(struct tep_handle *pevent, unsigned long long data);
=20
-#define tep_data2host2(pevent, ptr)		__tep_data2host2(pevent, *(unsigned s=
hort *)(ptr))
-#define tep_data2host4(pevent, ptr)		__tep_data2host4(pevent, *(unsigned i=
nt *)(ptr))
-#define tep_data2host8(pevent, ptr)					\
+#define tep_data2host2(pevent, ptr)	__tep_data2host2(pevent, *(unsigned sh=
ort *)(ptr))
+#define tep_data2host4(pevent, ptr)	__tep_data2host4(pevent, *(unsigned in=
t *)(ptr))
+#define tep_data2host8(pevent, ptr)	\
 ({								\
 	unsigned long long __val;				\
 								\
@@ -643,11 +513,13 @@ unsigned long long tep_read_number(struct tep_handle =
*pevent, const void *ptr, i
 int tep_read_number_field(struct tep_format_field *field, const void *data=
,
 			  unsigned long long *value);
=20
+struct tep_event_format *tep_get_first_event(struct tep_handle *tep);
+struct tep_event_format *tep_get_event(struct tep_handle *tep, int index);
+int tep_get_events_count(struct tep_handle *tep);
 struct tep_event_format *tep_find_event(struct tep_handle *pevent, int id)=
;
=20
 struct tep_event_format *
 tep_find_event_by_name(struct tep_handle *pevent, const char *sys, const c=
har *name);
-
 struct tep_event_format *
 tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *rec=
ord);
=20
@@ -677,65 +549,29 @@ struct tep_event_format **tep_list_events(struct tep_=
handle *pevent, enum tep_ev
 struct tep_format_field **tep_event_common_fields(struct tep_event_format =
*event);
 struct tep_format_field **tep_event_fields(struct tep_event_format *event)=
;
=20
-static inline int tep_get_cpus(struct tep_handle *pevent)
-{
-	return pevent->cpus;
-}
-
-static inline void tep_set_cpus(struct tep_handle *pevent, int cpus)
-{
-	pevent->cpus =3D cpus;
-}
-
-static inline int tep_get_long_size(struct tep_handle *pevent)
-{
-	return pevent->long_size;
-}
-
-static inline void tep_set_long_size(struct tep_handle *pevent, int long_s=
ize)
-{
-	pevent->long_size =3D long_size;
-}
-
-static inline int tep_get_page_size(struct tep_handle *pevent)
-{
-	return pevent->page_size;
-}
-
-static inline void tep_set_page_size(struct tep_handle *pevent, int _page_=
size)
-{
-	pevent->page_size =3D _page_size;
-}
-
-static inline int tep_is_file_bigendian(struct tep_handle *pevent)
-{
-	return pevent->file_bigendian;
-}
-
-static inline void tep_set_file_bigendian(struct tep_handle *pevent, int e=
ndian)
-{
-	pevent->file_bigendian =3D endian;
-}
-
-static inline int tep_is_host_bigendian(struct tep_handle *pevent)
-{
-	return pevent->host_bigendian;
-}
-
-static inline void tep_set_host_bigendian(struct tep_handle *pevent, int e=
ndian)
-{
-	pevent->host_bigendian =3D endian;
-}
-
-static inline int tep_is_latency_format(struct tep_handle *pevent)
-{
-	return pevent->latency_format;
-}
-
-static inline void tep_set_latency_format(struct tep_handle *pevent, int l=
at)
-{
-	pevent->latency_format =3D lat;
-}
+enum tep_endian {
+        TEP_LITTLE_ENDIAN =3D 0,
+        TEP_BIG_ENDIAN
+};
+int tep_get_cpus(struct tep_handle *pevent);
+void tep_set_cpus(struct tep_handle *pevent, int cpus);
+int tep_get_long_size(struct tep_handle *pevent);
+void tep_set_long_size(struct tep_handle *pevent, int long_size);
+int tep_get_page_size(struct tep_handle *pevent);
+void tep_set_page_size(struct tep_handle *pevent, int _page_size);
+int tep_is_file_bigendian(struct tep_handle *pevent);
+void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian end=
ian);
+int tep_is_host_bigendian(struct tep_handle *pevent);
+void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian end=
ian);
+int tep_is_latency_format(struct tep_handle *pevent);
+void tep_set_latency_format(struct tep_handle *pevent, int lat);
+int tep_get_header_page_size(struct tep_handle *pevent);
+void tep_set_parsing_failures(struct tep_handle *tep, int parsing_failures=
);
+int tep_get_parsing_failures(struct tep_handle *tep);
+int tep_get_header_page_ts_size(struct tep_handle *tep);
+int tep_is_old_format(struct tep_handle *pevent);
+void tep_set_print_raw(struct tep_handle *tep, int print_raw);
+void tep_set_test_filters(struct tep_handle *tep, int test_filters);
=20
 struct tep_handle *tep_alloc(void);
 void tep_free(struct tep_handle *pevent);
diff --git a/kernel-shark-qt/examples/datafilter.c b/kernel-shark-qt/exampl=
es/datafilter.c
index 45bf6c5..7f274d5 100644
--- a/kernel-shark-qt/examples/datafilter.c
+++ b/kernel-shark-qt/examples/datafilter.c
@@ -83,9 +83,9 @@ int main(int argc, char **argv)
 	puts("\n\n");
=20
 	/* Show only "sched" events. */
-	n_evts =3D kshark_ctx->pevent->nr_events;
+	n_evts =3D tep_get_events_count(kshark_ctx->pevent);
 	for (i =3D 0; i < n_evts; ++i) {
-		event =3D kshark_ctx->pevent->events[i];
+		event =3D tep_get_event(kshark_ctx->pevent, i);
 		if (strcmp(event->system, "sched") =3D=3D 0)
 			kshark_filter_add_id(kshark_ctx, KS_SHOW_EVENT_FILTER,
 							 event->id);
diff --git a/kernel-shark-qt/src/libkshark-configio.c b/kernel-shark-qt/src=
/libkshark-configio.c
index 7337865..bf2a08b 100644
--- a/kernel-shark-qt/src/libkshark-configio.c
+++ b/kernel-shark-qt/src/libkshark-configio.c
@@ -691,7 +691,8 @@ static bool kshark_event_filter_to_json(struct tep_hand=
le *pevent,
 					struct json_object *jobj)
 {
 	json_object *jfilter_data, *jevent, *jsystem, *jname;
-	int i, evt, *ids;
+	struct tep_event_format *event;
+	int i, evt, *ids, nr_events;
 	char *temp;
=20
 	jevent =3D jsystem =3D jname =3D NULL;
@@ -712,15 +713,17 @@ static bool kshark_event_filter_to_json(struct tep_ha=
ndle *pevent,
 	if (!jfilter_data)
 		goto fail;
=20
+	nr_events =3D tep_get_events_count(pevent);
 	for (i =3D 0; i < filter->count; ++i) {
-		for (evt =3D 0; evt < pevent->nr_events; ++evt) {
-			if (pevent->events[evt]->id =3D=3D ids[i]) {
+		for (evt =3D 0; evt < nr_events; ++evt) {
+			event =3D tep_get_event(pevent, evt);
+			if (event->id =3D=3D ids[i]) {
 				jevent =3D json_object_new_object();
=20
-				temp =3D pevent->events[evt]->system;
+				temp =3D event->system;
 				jsystem =3D json_object_new_string(temp);
=20
-				temp =3D pevent->events[evt]->name;
+				temp =3D event->name;
 				jname =3D json_object_new_string(temp);
=20
 				if (!jevent || !jsystem || !jname)
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 0395efc..d70c110 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -340,7 +340,7 @@ static int read_header_files(struct tracecmd_input *han=
dle)
 	 * The size field in the page is of type long,
 	 * use that instead, since it represents the kernel.
 	 */
-	handle->long_size =3D pevent->header_page_size_size;
+	handle->long_size =3D tep_get_header_page_size(pevent);
=20
 	if (do_read_check(handle, buf, 13))
 		return -1;
@@ -422,7 +422,7 @@ static int read_ftrace_file(struct tracecmd_input *hand=
le,
 			printf("%.*s\n", (int)size, buf);
 	} else {
 		if (tep_parse_event(pevent, buf, size, "ftrace"))
-			pevent->parsing_failures =3D 1;
+			tep_set_parsing_failures(pevent, 1);
 	}
 	free(buf);
=20
@@ -456,7 +456,7 @@ static int read_event_file(struct tracecmd_input *handl=
e,
 		}
 	} else {
 		if (tep_parse_event(pevent, buf, size, system))
-			pevent->parsing_failures =3D 1;
+			tep_set_parsing_failures(pevent, 1);
 	}
 	free(buf);
=20
@@ -1047,7 +1047,7 @@ static int update_page_info(struct tracecmd_input *ha=
ndle, int cpu)
 	struct kbuffer *kbuf =3D handle->cpu_data[cpu].kbuf;
=20
 	/* FIXME: handle header page */
-	if (pevent->header_page_ts_size !=3D 8) {
+	if (tep_get_header_page_ts_size(pevent) !=3D 8) {
 		warning("expected a long long type for timestamp");
 		return -1;
 	}
@@ -1619,7 +1619,7 @@ tracecmd_translate_data(struct tracecmd_input *handle=
,
 	memset(record, 0, sizeof(*record));
=20
 	record->ref_count =3D 1;
-	if (pevent->host_bigendian =3D=3D pevent->file_bigendian)
+	if (tep_is_host_bigendian(pevent) =3D=3D tep_is_file_bigendian(pevent))
 		swap =3D 0;
 	record->data =3D kbuffer_translate_data(swap, ptr, &length);
 	record->size =3D length;
@@ -1661,12 +1661,12 @@ tracecmd_read_page_record(struct tep_handle *pevent=
, void *page, int size,
 	enum kbuffer_endian endian;
 	void *ptr;
=20
-	if (pevent->file_bigendian)
+	if (tep_is_file_bigendian(pevent))
 		endian =3D KBUFFER_ENDIAN_BIG;
 	else
 		endian =3D KBUFFER_ENDIAN_LITTLE;
=20
-	if (pevent->header_page_size_size =3D=3D 8)
+	if (tep_get_header_page_size(pevent) =3D=3D 8)
 		long_size =3D KBUFFER_LSIZE_8;
 	else
 		long_size =3D KBUFFER_LSIZE_4;
@@ -2266,7 +2266,7 @@ static int read_cpu_data(struct tracecmd_input *handl=
e)
 	else
 		long_size =3D KBUFFER_LSIZE_4;
=20
-	if (handle->pevent->file_bigendian)
+	if (tep_is_file_bigendian(handle->pevent))
 		endian =3D KBUFFER_ENDIAN_BIG;
 	else
 		endian =3D KBUFFER_ENDIAN_LITTLE;
@@ -2279,7 +2279,7 @@ static int read_cpu_data(struct tracecmd_input *handl=
e)
 		handle->cpu_data[cpu].kbuf =3D kbuffer_alloc(long_size, endian);
 		if (!handle->cpu_data[cpu].kbuf)
 			goto out_free;
-		if (pevent->old_format)
+		if (tep_is_old_format(pevent))
 			kbuffer_set_old_format(handle->cpu_data[cpu].kbuf);
=20
 		read8(handle, &offset);
@@ -2475,7 +2475,7 @@ int tracecmd_make_pipe(struct tracecmd_input *handle,=
 int cpu, int fd, int cpus)
 	else
 		long_size =3D KBUFFER_LSIZE_4;
=20
-	if (handle->pevent->file_bigendian)
+	if (tep_is_file_bigendian(handle->pevent))
 		endian =3D KBUFFER_ENDIAN_BIG;
 	else
 		endian =3D KBUFFER_ENDIAN_LITTLE;
@@ -2487,7 +2487,7 @@ int tracecmd_make_pipe(struct tracecmd_input *handle,=
 int cpu, int fd, int cpus)
 	handle->cpu_data[cpu].kbuf =3D kbuffer_alloc(long_size, endian);
 	if (!handle->cpu_data[cpu].kbuf)
 		return -1;
-	if (handle->pevent->old_format)
+	if (tep_is_old_format(handle->pevent))
 		kbuffer_set_old_format(handle->cpu_data[cpu].kbuf);
=20
 	handle->cpu_data[cpu].file_offset =3D 0;
@@ -2644,8 +2644,8 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
=20
 	handle->plugin_list =3D tracecmd_load_plugins(handle->pevent);
=20
-	handle->pevent->file_bigendian =3D buf[0];
-	handle->pevent->host_bigendian =3D tracecmd_host_bigendian();
+	tep_set_file_bigendian(handle->pevent, buf[0]);
+	tep_set_host_bigendian(handle->pevent, tracecmd_host_bigendian());
=20
 	do_read_check(handle, buf, 1);
 	handle->long_size =3D buf[0];
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 325a4a5..b5aea39 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -1212,7 +1212,7 @@ int tracecmd_fill_local_events(const char *tracing_di=
r, struct tep_handle *peven
  out_free:
 	free(events_dir);
=20
-	pevent->parsing_failures =3D failure;
+	tep_set_parsing_failures(pevent, failure);
=20
 	return ret;
 }
diff --git a/lib/traceevent/Makefile b/lib/traceevent/Makefile
index 60246aa..bfbb6a3 100644
--- a/lib/traceevent/Makefile
+++ b/lib/traceevent/Makefile
@@ -13,6 +13,7 @@ OBJS +=3D kbuffer-parse.o
 OBJS +=3D trace-seq.o
 OBJS +=3D parse-filter.o
 OBJS +=3D parse-utils.o
+OBJS +=3D event-parse-api.o
=20
 # Additional util objects
 OBJS +=3D str_error_r.o
diff --git a/lib/traceevent/event-parse-api.c b/lib/traceevent/event-parse-=
api.c
new file mode 100644
index 0000000..c8b7bfe
--- /dev/null
+++ b/lib/traceevent/event-parse-api.c
@@ -0,0 +1,401 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.c=
om>
+ *
+ */
+
+#include "event-parse.h"
+#include "event-parse-local.h"
+#include "event-utils.h"
+
+/**
+ * tep_get_event - returns the event with the given index
+ * @tep: a handle to the tep_handle
+ * @index: index of the requested event, in the range 0 .. nr_events
+ *
+ * This returns pointer to the element of the events array with the given =
index
+ * If @tep is NULL, or @index is not in the range 0 .. nr_events, NULL is =
returned.
+ */
+struct tep_event_format *tep_get_event(struct tep_handle *tep, int index)
+{
+	if (tep && tep->events && index < tep->nr_events)
+		return tep->events[index];
+
+	return NULL;
+}
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
+	return tep_get_event(tep, 0);
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
+	if (tep)
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
+ * This sets a flag or combination of flags from enum tep_flag
+ */
+void tep_set_flag(struct tep_handle *tep, enum tep_flag flag)
+{
+	if (tep)
+		tep->flags |=3D flag;
+}
+
+/**
+ * tep_reset_flag - reset event parser flag
+ * @tep: a handle to the tep_handle
+ * @flag: flag, or combination of flags to be reseted
+ * can be any combination from enum tep_flag
+ *
+ * This resets a flag or combination of flags from enum tep_flag
+ */
+void tep_reset_flag(struct tep_handle *tep, enum tep_flag flag)
+{
+	if (tep)
+		tep->flags &=3D ~flag;
+}
+
+/**
+ * tep_check_flag - check the state of event parser flag
+ * @tep: a handle to the tep_handle
+ * @flag: flag, or combination of flags to be checked
+ * can be any combination from enum tep_flag
+ *
+ * This checks the state of a flag or combination of flags from enum tep_f=
lag
+ */
+int tep_check_flag(struct tep_handle *tep, enum tep_flag flag)
+{
+	if (tep)
+		return (tep->flags & flag);
+	return 0;
+}
+
+unsigned short __tep_data2host2(struct tep_handle *pevent, unsigned short =
data)
+{
+	unsigned short swap;
+
+	if (!pevent || pevent->host_bigendian =3D=3D pevent->file_bigendian)
+		return data;
+
+	swap =3D ((data & 0xffULL) << 8) |
+		((data & (0xffULL << 8)) >> 8);
+
+	return swap;
+}
+
+unsigned int __tep_data2host4(struct tep_handle *pevent, unsigned int data=
)
+{
+	unsigned int swap;
+
+	if (!pevent || pevent->host_bigendian =3D=3D pevent->file_bigendian)
+		return data;
+
+	swap =3D ((data & 0xffULL) << 24) |
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
+	if (!pevent || pevent->host_bigendian =3D=3D pevent->file_bigendian)
+		return data;
+
+	swap =3D ((data & 0xffULL) << 56) |
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
+	if (pevent)
+		return pevent->header_page_size_size;
+	return 0;
+}
+
+/**
+ * tep_get_header_page_ts_size - get size of the time stamp in the header =
page
+ * @tep: a handle to the tep_handle
+ *
+ * This returns size of the time stamp in the header page
+ * If @tep is NULL, 0 is returned.
+ */
+int tep_get_header_page_ts_size(struct tep_handle *tep)
+{
+	if (tep)
+		return tep->header_page_ts_size;
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
+	if (pevent)
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
+	if (pevent)
+		pevent->cpus =3D cpus;
+}
+
+/**
+ * tep_get_long_size - get the size of a long integer on the current machi=
ne
+ * @pevent: a handle to the tep_handle
+ *
+ * This returns the size of a long integer on the current machine
+ * If @pevent is NULL, 0 is returned.
+ */
+int tep_get_long_size(struct tep_handle *pevent)
+{
+	if (pevent)
+		return pevent->long_size;
+	return 0;
+}
+
+/**
+ * tep_set_long_size - set the size of a long integer on the current machi=
ne
+ * @pevent: a handle to the tep_handle
+ * @size: size, in bytes, of a long integer
+ *
+ * This sets the size of a long integer on the current machine
+ */
+void tep_set_long_size(struct tep_handle *pevent, int long_size)
+{
+	if (pevent)
+		pevent->long_size =3D long_size;
+}
+
+/**
+ * tep_get_page_size - get the size of a memory page on the current machin=
e
+ * @pevent: a handle to the tep_handle
+ *
+ * This returns the size of a memory page on the current machine
+ * If @pevent is NULL, 0 is returned.
+ */
+int tep_get_page_size(struct tep_handle *pevent)
+{
+	if (pevent)
+		return pevent->page_size;
+	return 0;
+}
+
+/**
+ * tep_set_page_size - set the size of a memory page on the current machin=
e
+ * @pevent: a handle to the tep_handle
+ * @_page_size: size of a memory page, in bytes
+ *
+ * This sets the size of a memory page on the current machine
+ */
+void tep_set_page_size(struct tep_handle *pevent, int _page_size)
+{
+	if (pevent)
+		pevent->page_size =3D _page_size;
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
+	if (pevent)
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
+void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian end=
ian)
+{
+	if (pevent)
+		pevent->file_bigendian =3D endian;
+}
+
+/**
+ * tep_is_host_bigendian - get if the order of the current host is big end=
ian
+ * @pevent: a handle to the tep_handle
+ *
+ * This gets if the order of the current host is big endian
+ * If @pevent is NULL, 0 is returned.
+ */
+int tep_is_host_bigendian(struct tep_handle *pevent)
+{
+	if (pevent)
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
+void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian end=
ian)
+{
+	if (pevent)
+		pevent->host_bigendian =3D endian;
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
+	if (pevent)
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
+	if (pevent)
+		pevent->latency_format =3D lat;
+}
+
+/**
+ * tep_set_parsing_failures - set parsing failures flag
+ * @tep: a handle to the tep_handle
+ * @parsing_failures: the new value of the parsing_failures flag
+ *
+ * This sets flag "parsing_failures" to the given count
+ */
+void tep_set_parsing_failures(struct tep_handle *tep, int parsing_failures=
)
+{
+	if (tep)
+		tep->parsing_failures =3D parsing_failures;
+}
+
+/**
+ * tep_get_parsing_failures - get the parsing failures flag
+ * @tep: a handle to the tep_handle
+ *
+ * This returns value of flag "parsing_failures"
+ * If @tep is NULL, 0 is returned.
+ */
+int tep_get_parsing_failures(struct tep_handle *tep)
+{
+	if (tep)
+		return tep->parsing_failures;
+	return 0;
+}
+
+/**
+ * tep_is_old_format - get if an old kernel is used
+ * @tep: a handle to the tep_handle
+ *
+ * This returns 1, if an old kernel is used to generate the tracing events=
 or
+ * 0 if a new kernel is used. Old kernels did not have header page info.
+ * If @pevent is NULL, 0 is returned.
+ */
+int tep_is_old_format(struct tep_handle *tep)
+{
+	if (tep)
+		return tep->old_format;
+	return 0;
+}
+
+/**
+ * tep_set_print_raw - set a flag to force print in raw format
+ * @tep: a handle to the tep_handle
+ * @print_raw: the new value of the print_raw flag
+ *
+ * This sets a flag to force print in raw format
+ */
+void tep_set_print_raw(struct tep_handle *tep, int print_raw)
+{
+	if (tep)
+		tep->print_raw =3D print_raw;
+}
+
+/**
+ * tep_set_print_raw - set a flag to test a filter string
+ * @tep: a handle to the tep_handle
+ * @test_filters: the new value of the test_filters flag
+ *
+ * This sets a flag to fjust test a filter string. If this flag is set,
+ * when a filter string is added, then it will print the filters strings
+ * that were created and exit.
+ */
+void tep_set_test_filters(struct tep_handle *tep, int test_filters)
+{
+	if (tep)
+		tep->test_filters =3D test_filters;
+}
diff --git a/lib/traceevent/event-parse-local.h b/lib/traceevent/event-pars=
e-local.h
new file mode 100644
index 0000000..6df0e57
--- /dev/null
+++ b/lib/traceevent/event-parse-local.h
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.c=
om>
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
+	int parsing_failures;
+
+	/* cache */
+	struct tep_event_format *last_event;
+
+	char *trace_clock;
+};
+
+#endif /* _PARSE_EVENTS_INT_H */
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 7980fc6..d889a62 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -23,6 +23,8 @@
=20
 #include <netinet/in.h>
 #include "event-parse.h"
+
+#include "event-parse-local.h"
 #include "event-utils.h"
 #include "trace-seq.h"
=20
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 46eb64e..e74f16c 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -14,6 +14,7 @@
 #include <unistd.h>
 #include <dirent.h>
 #include "event-parse.h"
+#include "event-parse-local.h"
 #include "event-utils.h"
 #include "trace-seq.h"
=20
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index d64b612..ed87cb5 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -11,6 +11,7 @@
 #include <sys/types.h>
=20
 #include "event-parse.h"
+#include "event-parse-local.h"
 #include "event-utils.h"
=20
 #define COMM "COMM"
diff --git a/tracecmd/trace-check-events.c b/tracecmd/trace-check-events.c
index 3bd25ef..a0e05f5 100644
--- a/tracecmd/trace-check-events.c
+++ b/tracecmd/trace-check-events.c
@@ -43,7 +43,7 @@ void trace_check_events(int argc, char **argv)
 		exit(EINVAL);
 	list =3D tracecmd_load_plugins(pevent);
 	ret =3D tracecmd_fill_local_events(tracing, pevent);
-	if (ret || pevent->parsing_failures)
+	if (ret || tep_get_parsing_failures(pevent))
 		ret =3D EINVAL;
 	tracecmd_unload_plugins(list, pevent);
 	tep_free(pevent);
diff --git a/tracecmd/trace-output.c b/tracecmd/trace-output.c
index a9d7d6e..9b5f8e9 100644
--- a/tracecmd/trace-output.c
+++ b/tracecmd/trace-output.c
@@ -809,7 +809,7 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 		/* Use the pevent of the ihandle for later writes */
 		handle->pevent =3D tracecmd_get_pevent(ihandle);
 		tep_ref(pevent);
-		if (pevent->file_bigendian)
+		if (tep_is_file_bigendian(pevent))
 			buf[0] =3D 1;
 		else
 			buf[0] =3D 0;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 6aa0b5e..3f1a4cd 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -798,7 +798,7 @@ void trace_show_data(struct tracecmd_input *handle, str=
uct tep_record *record)
 		tep_print_event_time(pevent, &s, event, record,
 					use_trace_clock);
 		buf[0] =3D 0;
-		if (use_trace_clock && !(pevent->flags & TEP_NSEC_OUTPUT))
+		if (use_trace_clock && !tep_check_flag(pevent, TEP_NSEC_OUTPUT))
 			rec_ts =3D (rec_ts + 500) / 1000;
 		if (last_ts) {
 			diff_ts =3D rec_ts - last_ts;
@@ -1687,13 +1687,13 @@ void trace_report (int argc, char **argv)
 		pevent =3D tracecmd_get_pevent(handle);
=20
 		if (nanosec)
-			pevent->flags |=3D TEP_NSEC_OUTPUT;
+			tep_set_flag(pevent, TEP_NSEC_OUTPUT);
=20
 		if (raw)
-			pevent->print_raw =3D 1;
+			tep_set_print_raw(pevent, 1);
=20
 		if (test_filters)
-			pevent->test_filters =3D 1;
+			tep_set_test_filters(pevent, 1);
=20
 		if (functions)
 			add_functions(pevent, functions);
@@ -1717,7 +1717,7 @@ void trace_report (int argc, char **argv)
=20
 		ret =3D tracecmd_read_headers(handle);
 		if (check_event_parsing) {
-			if (ret || pevent->parsing_failures)
+			if (ret || tep_get_parsing_failures(pevent))
 				exit(EINVAL);
 			else
 				exit(0);
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index ea76c5b..1b1cd45 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -65,7 +65,7 @@ static int create_type_len(struct tep_handle *pevent, int=
 time, int len)
 			bigendian =3D 1;
 	}
=20
-	if (pevent->file_bigendian)
+	if (tep_is_file_bigendian(pevent))
 		time |=3D (len << 27);
 	else
 		time =3D (time << 5) | len;
--=20
2.17.1
