Return-Path: <SRS0=W9qh=MK=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-cys01nam02on0087.outbound.protection.outlook.com ([104.47.37.87]:37664
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728859AbeI1NoI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Sep 2018 09:44:08 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] powertop: use external traceevent library
Date: Fri, 28 Sep 2018 10:21:27 +0300
Message-Id: <20180928072127.30130-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch switches powertop to use the external libtraceevent.so, instead of the internal implementation located in traceevent directory. The library libtraceevent.so must be installed on the system and properly hooked to pkg-config.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 Doxyfile.in                |  2 +-
 Makefile.am                |  1 -
 configure.ac               |  9 +++++-
 po/POTFILES.in             |  4 +--
 src/Makefile.am            | 12 +++----
 src/cpu/cpu.cpp            | 12 +++----
 src/perf/perf.cpp          | 12 +++----
 src/perf/perf.h            |  4 +--
 src/perf/perf_bundle.cpp   | 12 +++----
 src/process/do_process.cpp | 64 +++++++++++++++++++-------------------
 10 files changed, 68 insertions(+), 64 deletions(-)

diff --git a/Doxyfile.in b/Doxyfile.in
index 1f1d8b4..6617357 100644
--- a/Doxyfile.in
+++ b/Doxyfile.in
@@ -733,7 +733,7 @@ WARN_LOGFILE           =
 # spaces.
 # Note: If this tag is empty the current directory is searched.
 
-INPUT                  = src traceevent
+INPUT                  = src
 
 # This tag can be used to specify the character encoding of the source files
 # that doxygen parses. Internally doxygen uses the UTF-8 encoding. Doxygen uses
diff --git a/Makefile.am b/Makefile.am
index 3aabb22..15f2120 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,7 +2,6 @@ AUTOMAKE_OPTIONS = subdir-objects
 ACLOCAL_AMFLAGS = --install -I m4
 
 SUBDIRS = \
-	traceevent \
 	src \
 	po \
 	doc
diff --git a/configure.ac b/configure.ac
index d6a15e1..e511f42 100644
--- a/configure.ac
+++ b/configure.ac
@@ -14,7 +14,6 @@ AC_CONFIG_FILES([
 	Makefile
 	Doxyfile
 	src/Makefile
-	traceevent/Makefile
 	po/Makefile.in
 	doc/Makefile
 ])
@@ -137,6 +136,14 @@ AS_IF([test "$has_libnl_ver" -gt 1], [
 	AC_DEFINE([HAVE_LIBNL20], [1], [Define if you have libnl-2.0 or higher])
 ])
 
+has_libtraceevent_ver=0
+dnl check for tracevent library
+PKG_CHECK_MODULES([LIBTRACEEVENT], [libtraceevent], [has_libtraceevent_ver=1])
+
+AS_IF([test "$has_libtraceevent_ver" -eq 0], [
+	AC_MSG_ERROR([libtraceevent is required but were not found])
+])
+
 AS_IF([test "$has_libpci" -eq 0], [
 	AC_DEFINE([HAVE_NO_PCI], [1], [Define if pci is not supported])
         AC_MSG_WARN([
diff --git a/po/POTFILES.in b/po/POTFILES.in
index aa853f0..4a239ef 100644
--- a/po/POTFILES.in
+++ b/po/POTFILES.in
@@ -36,6 +36,4 @@ src/tuning/tuning.cpp
 src/tuning/tuningi2c.cpp
 src/tuning/tuningsysfs.cpp
 src/tuning/tuningusb.cpp
-src/tuning/wifi.cpp
-traceevent/event-parse.h
-traceevent/parse-utils.c
+src/tuning/wifi.cpp
\ No newline at end of file
diff --git a/src/Makefile.am b/src/Makefile.am
index 8357bae..defdfc3 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -136,7 +136,8 @@ powertop_CXXFLAGS = \
 	$(LIBNL_CFLAGS) \
 	$(NCURSES_CFLAGS) \
 	$(PCIUTILS_CFLAGS) \
-	$(PTHREAD_CFLAGS)
+	$(PTHREAD_CFLAGS) \
+	$(LIBTRACEEVENT_CFLAGS)
 
 
 powertop_CPPFLAGS = \
@@ -146,10 +147,8 @@ powertop_CPPFLAGS = \
 	$(LIBZ_CFLAGS) \
 	$(NCURSES_CFLAGS) \
 	$(PCIUTILS_CFLAGS) \
-	$(PTHREAD_CFLAGS)
-
-powertop_LDADD = \
-	../traceevent/libtraceevnet.la
+	$(PTHREAD_CFLAGS) \
+	$(LIBTRACEEVENT_CFLAGS)
 
 AM_LDFLAGS = \
 	$(LIBNL_LIBS) \
@@ -158,7 +157,8 @@ AM_LDFLAGS = \
 	$(NCURSES_LIBS) \
 	$(PCIUTILS_LIBS) \
 	$(PTHREAD_LIBS) \
-	$(RESOLV_LIBS)
+	$(RESOLV_LIBS) \
+	$(LIBTRACEEVENT_LIBS)
 
 BUILT_SOURCES = css.h
 CLEANFILES = css.h
diff --git a/src/cpu/cpu.cpp b/src/cpu/cpu.cpp
index 28afc4f..f725b7f 100644
--- a/src/cpu/cpu.cpp
+++ b/src/cpu/cpu.cpp
@@ -961,15 +961,15 @@ struct power_entry {
 
 void perf_power_bundle::handle_trace_point(void *trace, int cpunr, uint64_t time)
 {
-	struct event_format *event;
-        struct pevent_record rec; /* holder */
+	struct tep_event_format *event;
+        struct tep_record rec; /* holder */
 	class abstract_cpu *cpu;
 	int type;
 
 	rec.data = trace;
 
-	type = pevent_data_type(perf_event::pevent, &rec);
-	event = pevent_find_event(perf_event::pevent, type);
+	type = tep_data_type(perf_event::pevent, &rec);
+	event = tep_find_event(perf_event::pevent, type);
 
 	if (!event)
 		return;
@@ -992,7 +992,7 @@ void perf_power_bundle::handle_trace_point(void *trace, int cpunr, uint64_t time
 	int ret;
 	if (strcmp(event->name, "cpu_idle")==0) {
 
-		ret = pevent_get_field_val(NULL, event, "state", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "state", &rec, &val, 0);
                 if (ret < 0) {
                         fprintf(stderr, _("cpu_idle event returned no state?\n"));
                         exit(-1);
@@ -1007,7 +1007,7 @@ void perf_power_bundle::handle_trace_point(void *trace, int cpunr, uint64_t time
 	if (strcmp(event->name, "power_frequency") == 0
 	|| strcmp(event->name, "cpu_frequency") == 0){
 
-		ret = pevent_get_field_val(NULL, event, "state", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "state", &rec, &val, 0);
 		if (ret < 0) {
 			fprintf(stderr, _("power or cpu_frequency event returned no state?\n"));
 			exit(-1);
diff --git a/src/perf/perf.cpp b/src/perf/perf.cpp
index 9ed0ba8..8ea201d 100644
--- a/src/perf/perf.cpp
+++ b/src/perf/perf.cpp
@@ -44,7 +44,7 @@
 #include "../lib.h"
 #include "../display.h"
 
-struct pevent *perf_event::pevent;
+struct tep_handle *perf_event::pevent;
 
 static int get_trace_type(const char *eventname)
 {
@@ -169,12 +169,12 @@ perf_event::~perf_event(void)
 {
 	free(name);
 
-	if (perf_event::pevent->ref_count == 1) {
-		pevent_free(perf_event::pevent);
+	if (tep_ref_get(perf_event::pevent) == 1) {
+		tep_free(perf_event::pevent);
 		perf_event::pevent = NULL;
 		clear();
 	} else
-		pevent_unref(perf_event::pevent);
+		tep_unref(perf_event::pevent);
 }
 
 void perf_event::set_cpu(int _cpu)
@@ -185,9 +185,9 @@ void perf_event::set_cpu(int _cpu)
 static void allocate_pevent(void)
 {
 	if (!perf_event::pevent)
-		perf_event::pevent = pevent_alloc();
+		perf_event::pevent = tep_alloc();
 	else
-		pevent_ref(perf_event::pevent);
+		tep_ref(perf_event::pevent);
 }
 
 perf_event::perf_event(const char *event_name, int _cpu, int buffer_size)
diff --git a/src/perf/perf.h b/src/perf/perf.h
index ee072ae..511e3e1 100644
--- a/src/perf/perf.h
+++ b/src/perf/perf.h
@@ -29,7 +29,7 @@
 
 
 extern "C" {
-	#include "../traceevent/event-parse.h"
+	#include <event-parse.h>
 }
 
 
@@ -69,7 +69,7 @@ public:
 
 	virtual void handle_event(struct perf_event_header *header, void *cookie) { };
 
-	static struct pevent *pevent;
+	static struct tep_handle *pevent;
 
 };
 
diff --git a/src/perf/perf_bundle.cpp b/src/perf/perf_bundle.cpp
index 3d216ff..edd00a1 100644
--- a/src/perf/perf_bundle.cpp
+++ b/src/perf/perf_bundle.cpp
@@ -148,7 +148,7 @@ static void parse_event_format(const char *event_name)
 		return;
 	}
 
-	pevent_parse_event(perf_event::pevent, buf, strlen(buf), sys);
+	tep_parse_event(perf_event::pevent, buf, strlen(buf), sys);
 	free(name);
 	free(buf);
 }
@@ -295,19 +295,19 @@ static bool event_sort_function (void *i, void *j)
  */
 static void fixup_sample_trace_cpu(struct perf_sample *sample)
 {
-	struct event_format *event;
-	struct pevent_record rec;
+	struct tep_event_format *event;
+	struct tep_record rec;
 	unsigned long long cpu_nr;
 	int type;
 	int ret;
 
 	rec.data = &sample->data;
-	type = pevent_data_type(perf_event::pevent, &rec);
-	event = pevent_find_event(perf_event::pevent, type);
+	type = tep_data_type(perf_event::pevent, &rec);
+	event = tep_find_event(perf_event::pevent, type);
 	if (!event)
 		return;
 	/** don't touch trace if event does not contain cpu_id field*/
-	ret = pevent_get_field_val(NULL, event, "cpu_id", &rec, &cpu_nr, 0);
+	ret = tep_get_field_val(NULL, event, "cpu_id", &rec, &cpu_nr, 0);
 	if (ret < 0)
 		return;
 	sample->trace.cpu = cpu_nr;
diff --git a/src/process/do_process.cpp b/src/process/do_process.cpp
index 812572c..d6765e4 100644
--- a/src/process/do_process.cpp
+++ b/src/process/do_process.cpp
@@ -188,13 +188,13 @@ int dont_blame_me(char *comm)
 	return 0;
 }
 
-static char * get_pevent_field_str(void *trace, struct event_format *event, struct format_field *field)
+static char * get_pevent_field_str(void *trace, struct tep_event_format *event, struct tep_format_field *field)
 {
 	unsigned long long offset, len;
-	if (field->flags & FIELD_IS_DYNAMIC) {
+	if (field->flags & TEP_FIELD_IS_DYNAMIC) {
 		offset = field->offset;
 		len = field->size;
-		offset = pevent_read_number(event->pevent, (char *)trace + offset, len);
+		offset = tep_read_number(event->pevent, (char *)trace + offset, len);
 		offset &= 0xffff;
 		return (char *)trace + offset;
 	}
@@ -204,17 +204,17 @@ static char * get_pevent_field_str(void *trace, struct event_format *event, stru
 
 void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time)
 {
-	struct event_format *event;
-	struct pevent_record rec; /* holder */
-	struct format_field *field;
+	struct tep_event_format *event;
+	struct tep_record rec; /* holder */
+	struct tep_format_field *field;
 	unsigned long long val;
 	int type;
 	int ret;
 
 	rec.data = trace;
 
-	type = pevent_data_type(perf_event::pevent, &rec);
-	event = pevent_find_event(perf_event::pevent, type);
+	type = tep_data_type(perf_event::pevent, &rec);
+	event = tep_find_event(perf_event::pevent, type);
 	if (!event)
 		return;
 
@@ -233,18 +233,18 @@ void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time
 		int next_pid;
 		int prev_pid;
 
-		field = pevent_find_any_field(event, "next_comm");
-		if (!field || !(field->flags & FIELD_IS_STRING))
+		field = tep_find_any_field(event, "next_comm");
+		if (!field || !(field->flags & TEP_FIELD_IS_STRING))
 			return; /* ?? */
 
 		next_comm = get_pevent_field_str(trace, event, field);
 
-		ret = pevent_get_field_val(NULL, event, "next_pid", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "next_pid", &rec, &val, 0);
 		if (ret < 0)
 			return;
 		next_pid = (int)val;
 
-		ret = pevent_get_field_val(NULL, event, "prev_pid", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "prev_pid", &rec, &val, 0);
 		if (ret < 0)
 			return;
 		prev_pid = (int)val;
@@ -301,7 +301,7 @@ void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time
 		int flags;
 		int pid;
 
-		ret = pevent_get_common_field_val(NULL, event, "common_flags", &rec, &val, 0);
+		ret = tep_get_common_field_val(NULL, event, "common_flags", &rec, &val, 0);
 		if (ret < 0)
 			return;
 		flags = (int)val;
@@ -322,14 +322,14 @@ void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time
 		}
 
 
-		field = pevent_find_any_field(event, "comm");
+		field = tep_find_any_field(event, "comm");
 
-		if (!field || !(field->flags & FIELD_IS_STRING))
+		if (!field || !(field->flags & TEP_FIELD_IS_STRING))
  			return;
 
 		comm = get_pevent_field_str(trace, event, field);
 
-		ret = pevent_get_field_val(NULL, event, "pid", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "pid", &rec, &val, 0);
 		if (ret < 0)
 			return;
 		pid = (int)val;
@@ -359,13 +359,13 @@ void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time
 		const char *handler;
 		int nr;
 
-		field = pevent_find_any_field(event, "name");
-		if (!field || !(field->flags & FIELD_IS_STRING))
+		field = tep_find_any_field(event, "name");
+		if (!field || !(field->flags & TEP_FIELD_IS_STRING))
 			return; /* ?? */
 
 		handler = get_pevent_field_str(trace, event, field);
 
-		ret = pevent_get_field_val(NULL, event, "irq", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "irq", &rec, &val, 0);
 		if (ret < 0)
 			return;
 		nr = (int)val;
@@ -401,7 +401,7 @@ void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time
 		const char *handler = NULL;
 		int vec;
 
-		ret = pevent_get_field_val(NULL, event, "vec", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "vec", &rec, &val, 0);
                 if (ret < 0) {
                         fprintf(stderr, "softirq_entry event returned no vector number?\n");
                         return;
@@ -438,7 +438,7 @@ void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time
 		uint64_t function;
 		uint64_t tmr;
 
-		ret = pevent_get_field_val(NULL, event, "function", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "function", &rec, &val, 0);
 		if (ret < 0) {
 			fprintf(stderr, "timer_expire_entry event returned no function value?\n");
 			return;
@@ -450,7 +450,7 @@ void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time
 		if (timer->is_deferred())
 			return;
 
-		ret = pevent_get_field_val(NULL, event, "timer", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "timer", &rec, &val, 0);
 		if (ret < 0) {
 			fprintf(stderr, "softirq_entry event returned no timer ?\n");
 			return;
@@ -468,7 +468,7 @@ void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time
 		uint64_t tmr;
 		uint64_t t;
 
-		ret = pevent_get_field_val(NULL, event, "timer", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "timer", &rec, &val, 0);
 		if (ret < 0)
 			return;
 		tmr = (uint64_t)val;
@@ -490,14 +490,14 @@ void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time
 		uint64_t function;
 		uint64_t tmr;
 
-		ret = pevent_get_field_val(NULL, event, "function", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "function", &rec, &val, 0);
 		if (ret < 0)
 			return;
 		function = (uint64_t)val;
 
 		timer = find_create_timer(function);
 
-		ret = pevent_get_field_val(NULL, event, "hrtimer", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "hrtimer", &rec, &val, 0);
 		if (ret < 0)
 			return;
 		tmr = (uint64_t)val;
@@ -518,7 +518,7 @@ void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time
 			return;
 		}
 
-		ret = pevent_get_field_val(NULL, event, "hrtimer", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "hrtimer", &rec, &val, 0);
 		if (ret < 0)
 			return;
 		tmr = (uint64_t)val;
@@ -536,12 +536,12 @@ void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time
 		uint64_t function;
 		uint64_t wk;
 
-		ret = pevent_get_field_val(NULL, event, "function", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "function", &rec, &val, 0);
 		if (ret < 0)
 			return;
 		function = (uint64_t)val;
 
-		ret = pevent_get_field_val(NULL, event, "work", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "work", &rec, &val, 0);
 		if (ret < 0)
 			return;
 		wk = (uint64_t)val;
@@ -561,7 +561,7 @@ void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time
 		uint64_t t;
 		uint64_t wk;
 
-		ret = pevent_get_field_val(NULL, event, "work", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "work", &rec, &val, 0);
 		if (ret < 0)
 			return;
 		wk = (uint64_t)val;
@@ -579,7 +579,7 @@ void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time
 		consumer_child_time(cpu, t);
 	}
 	else if (strcmp(event->name, "cpu_idle") == 0) {
-		pevent_get_field_val(NULL, event, "state", &rec, &val, 0);
+		tep_get_field_val(NULL, event, "state", &rec, &val, 0);
 		if (val == (unsigned int)-1)
 			consume_blame(cpu);
 		else
@@ -598,7 +598,7 @@ void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time
 		class power_consumer *consumer = NULL;
 		int flags;
 
-		ret = pevent_get_common_field_val(NULL, event, "common_flags", &rec, &val, 0);
+		ret = tep_get_common_field_val(NULL, event, "common_flags", &rec, &val, 0);
 		if (ret < 0)
 			return;
 		flags = (int)val;
@@ -632,7 +632,7 @@ void perf_process_bundle::handle_trace_point(void *trace, int cpu, uint64_t time
 
 		consumer = current_consumer(cpu);
 
-		ret = pevent_get_field_val(NULL, event, "dev", &rec, &val, 0);
+		ret = tep_get_field_val(NULL, event, "dev", &rec, &val, 0);
 		if (ret < 0)
 
 			return;
-- 
2.17.1
