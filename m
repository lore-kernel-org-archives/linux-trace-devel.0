Return-Path: <SRS0=/uS6=LK=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44244 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726872AbeH0MEC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Aug 2018 08:04:02 -0400
Received: by mail-wr1-f67.google.com with SMTP id v16-v6so12733537wro.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Aug 2018 01:18:25 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 21/24] tools lib traceevent: Rename various pevent get/set/is APIs
Date: Mon, 27 Aug 2018 11:17:56 +0300
Message-Id: <20180827081759.17297-22-tz.stoyanov@gmail.com>
In-Reply-To: <20180827081759.17297-1-tz.stoyanov@gmail.com>
References: <20180827081759.17297-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

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
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/traceevent/event-parse.h | 14 +++++++-------
 kernel-shark/trace-graph.c       |  2 +-
 lib/trace-cmd/trace-input.c      |  2 +-
 lib/traceevent/event-parse.c     |  4 ++--
 plugins/plugin_kvm.c             |  4 ++--
 python/tracecmd.py               |  2 +-
 tracecmd/trace-read.c            |  6 +++---
 7 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 87777c2..328d0d3 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -612,7 +612,7 @@ int tep_register_function(struct tep_handle *pevent, char *name,
 			  unsigned long long addr, char *mod);
 int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
 			      unsigned long long addr);
-int pevent_pid_is_registered(struct tep_handle *pevent, int pid);
+int tep_pid_is_registered(struct tep_handle *pevent, int pid);
 
 void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
 			  struct event_format *event,
@@ -719,12 +719,12 @@ struct event_format **pevent_list_events(struct tep_handle *pevent, enum event_s
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
@@ -749,7 +749,7 @@ static inline void tep_set_page_size(struct tep_handle *pevent, int _page_size)
 	pevent->page_size = _page_size;
 }
 
-static inline int pevent_is_file_bigendian(struct tep_handle *pevent)
+static inline int tep_is_file_bigendian(struct tep_handle *pevent)
 {
 	return pevent->file_bigendian;
 }
@@ -759,7 +759,7 @@ static inline void tep_set_file_bigendian(struct tep_handle *pevent, int endian)
 	pevent->file_bigendian = endian;
 }
 
-static inline int pevent_is_host_bigendian(struct tep_handle *pevent)
+static inline int tep_is_host_bigendian(struct tep_handle *pevent)
 {
 	return pevent->host_bigendian;
 }
@@ -769,12 +769,12 @@ static inline void tep_set_host_bigendian(struct tep_handle *pevent, int endian)
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
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index 808b2f3..88870c1 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -1133,7 +1133,7 @@ int trace_graph_check_sched_switch(struct graph_info *ginfo,
 		 * First time through, register any missing
 		 *  comm / pid mappings.
 		 */
-		if (!pevent_pid_is_registered(ginfo->pevent, *pid))
+		if (!tep_find_event_by_record(ginfo->pevent, *pid))
 			tep_register_comm(ginfo->pevent,
 					  *comm, *pid);
 	}
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 20203ad..af812c1 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2406,7 +2406,7 @@ int tracecmd_init_data(struct tracecmd_input *handle)
 		return -1;
 	handle->cpus = cpus;
 
-	pevent_set_cpus(pevent, handle->cpus);
+	tep_set_cpus(pevent, handle->cpus);
 
 	ret = read_cpu_data(handle);
 	if (ret < 0)
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 5d2f738..8264309 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -197,14 +197,14 @@ static const char *find_cmdline(struct tep_handle *pevent, int pid)
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
diff --git a/plugins/plugin_kvm.c b/plugins/plugin_kvm.c
index b19311d..3f4a8c0 100644
--- a/plugins/plugin_kvm.c
+++ b/plugins/plugin_kvm.c
@@ -385,8 +385,8 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 	 * We can only use the structure if file is of the same
 	 * endianess.
 	 */
-	if (pevent_is_file_bigendian(event->pevent) ==
-	    pevent_is_host_bigendian(event->pevent)) {
+	if (tep_is_file_bigendian(event->pevent) ==
+	    tep_is_host_bigendian(event->pevent)) {
 
 		trace_seq_printf(s, "%u/%u q%u%s %s%s %spge %snxe",
 				 role.level,
diff --git a/python/tracecmd.py b/python/tracecmd.py
index bc926c6..1267941 100644
--- a/python/tracecmd.py
+++ b/python/tracecmd.py
@@ -166,7 +166,7 @@ class PEvent(object):
 
     @cached_property
     def file_endian(self):
-        if pevent_is_file_bigendian(self._pevent):
+        if tep_is_file_bigendian(self._pevent):
             return '>'
         return '<'
 
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index b6c4c90..5832a8e 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1700,8 +1700,8 @@ void trace_report (int argc, char **argv)
 
 		if (show_endian) {
 			printf("file is %s endian and host is %s endian\n",
-			       pevent_is_file_bigendian(pevent) ? "big" : "little",
-			       pevent_is_host_bigendian(pevent) ? "big" : "little");
+			       tep_is_file_bigendian(pevent) ? "big" : "little",
+			       tep_is_host_bigendian(pevent) ? "big" : "little");
 			return;
 		}
 
@@ -1755,7 +1755,7 @@ void trace_report (int argc, char **argv)
 	}
 
 	if (latency_format)
-		pevent_set_latency_format(pevent, latency_format);
+		tep_set_latency_format(pevent, latency_format);
 
 	otype = OUTPUT_NORMAL;
 
-- 
2.17.1
