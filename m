Return-Path: <SRS0=+9rX=K6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:50598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729293AbeHOSAn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Aug 2018 14:00:43 -0400
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
Subject: [PATCH 22/35] tools lib traceevent: Rename various pevent get/set/is APIs
Date: Wed, 15 Aug 2018 12:05:58 -0300
Message-Id: <20180815150611.32080-23-acme@kernel.org>
In-Reply-To: <20180815150611.32080-1-acme@kernel.org>
References: <20180815150611.32080-1-acme@kernel.org>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_pid_is_registered, pevent_get_cpus, pevent_set_cpus,
pevent_is_file_bigendian, pevent_is_host_bigendian, pevent_is_latency_format,
pevent_set_latency_format

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180808180703.114110715@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |  4 ++--
 tools/lib/traceevent/event-parse.h | 14 +++++++-------
 tools/lib/traceevent/plugin_kvm.c  |  4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 53d866434478..d367f7f2f2fc 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -211,14 +211,14 @@ static const char *find_cmdline(struct tep_handle *pevent, int pid)
 }
 
 /**
- * pevent_pid_is_registered - return if a pid has a cmdline registered
+ * tep_pid_is_registered - return if a pid has a cmdline registered
  * @pevent: handle for the pevent
  * @pid: The pid to check if it has a cmdline registered with.
  *
  * Returns 1 if the pid has a cmdline mapped to it
  * 0 otherwise.
  */
-int pevent_pid_is_registered(struct tep_handle *pevent, int pid)
+int tep_pid_is_registered(struct tep_handle *pevent, int pid)
 {
 	const struct cmdline *comm;
 	struct cmdline key;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 63ec6d419219..7f8921431cf1 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -624,7 +624,7 @@ int tep_register_function(struct tep_handle *pevent, char *name,
 			  unsigned long long addr, char *mod);
 int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
 			      unsigned long long addr);
-int pevent_pid_is_registered(struct tep_handle *pevent, int pid);
+int tep_pid_is_registered(struct tep_handle *pevent, int pid);
 
 void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
 			  struct event_format *event,
@@ -731,12 +731,12 @@ struct event_format **pevent_list_events(struct tep_handle *pevent, enum event_s
 struct format_field **pevent_event_common_fields(struct event_format *event);
 struct format_field **pevent_event_fields(struct event_format *event);
 
-static inline int pevent_get_cpus(struct tep_handle *pevent)
+static inline int tep_get_cpus(struct tep_handle *pevent)
 {
 	return pevent->cpus;
 }
 
-static inline void pevent_set_cpus(struct tep_handle *pevent, int cpus)
+static inline void tep_set_cpus(struct tep_handle *pevent, int cpus)
 {
 	pevent->cpus = cpus;
 }
@@ -761,7 +761,7 @@ static inline void tep_set_page_size(struct tep_handle *pevent, int _page_size)
 	pevent->page_size = _page_size;
 }
 
-static inline int pevent_is_file_bigendian(struct tep_handle *pevent)
+static inline int tep_is_file_bigendian(struct tep_handle *pevent)
 {
 	return pevent->file_bigendian;
 }
@@ -771,7 +771,7 @@ static inline void tep_set_file_bigendian(struct tep_handle *pevent, int endian)
 	pevent->file_bigendian = endian;
 }
 
-static inline int pevent_is_host_bigendian(struct tep_handle *pevent)
+static inline int tep_is_host_bigendian(struct tep_handle *pevent)
 {
 	return pevent->host_bigendian;
 }
@@ -781,12 +781,12 @@ static inline void tep_set_host_bigendian(struct tep_handle *pevent, int endian)
 	pevent->host_bigendian = endian;
 }
 
-static inline int pevent_is_latency_format(struct tep_handle *pevent)
+static inline int tep_is_latency_format(struct tep_handle *pevent)
 {
 	return pevent->latency_format;
 }
 
-static inline void pevent_set_latency_format(struct tep_handle *pevent, int lat)
+static inline void tep_set_latency_format(struct tep_handle *pevent, int lat)
 {
 	pevent->latency_format = lat;
 }
diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 7ebe82bf19ce..1d0d15906225 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -388,8 +388,8 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 	 * We can only use the structure if file is of the same
 	 * endianess.
 	 */
-	if (pevent_is_file_bigendian(event->pevent) ==
-	    pevent_is_host_bigendian(event->pevent)) {
+	if (tep_is_file_bigendian(event->pevent) ==
+	    tep_is_host_bigendian(event->pevent)) {
 
 		trace_seq_printf(s, "%u q%u%s %s%s %spae %snxe %swp%s%s%s",
 				 role.level,
-- 
2.14.4
