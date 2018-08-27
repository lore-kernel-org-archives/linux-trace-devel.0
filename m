Return-Path: <SRS0=/uS6=LK=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38807 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbeH0MDu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Aug 2018 08:03:50 -0400
Received: by mail-wm0-f68.google.com with SMTP id t25-v6so7389868wmi.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Aug 2018 01:18:13 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 10/24] tools lib traceevent, perf tools: Rename pevent_set_* APIs
Date: Mon, 27 Aug 2018 11:17:45 +0300
Message-Id: <20180827081759.17297-11-tz.stoyanov@gmail.com>
In-Reply-To: <20180827081759.17297-1-tz.stoyanov@gmail.com>
References: <20180827081759.17297-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_set_file_bigendian, pevent_set_flag,
pevent_set_function_resolver, pevent_set_host_bigendian,
pevent_set_long_size, pevent_set_page_size and pevent_get_long_size

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180808180701.256265951@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/traceevent/event-parse.h | 16 ++++++++--------
 lib/trace-cmd/trace-input.c      |  2 +-
 lib/traceevent/event-parse.c     |  6 +++---
 tracecmd/trace-profile.c         |  4 ++--
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index c368a55..ea5b9f5 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -520,7 +520,7 @@ struct tep_handle {
 	char *trace_clock;
 };
 
-static inline void pevent_set_flag(struct tep_handle *pevent, int flag)
+static inline void tep_set_flag(struct tep_handle *pevent, int flag)
 {
 	pevent->flags |= flag;
 }
@@ -603,8 +603,8 @@ enum trace_flag_type {
 	TRACE_FLAG_SOFTIRQ		= 0x10,
 };
 
-int pevent_set_function_resolver(struct tep_handle *pevent,
-				 tep_func_resolver_t *func, void *priv);
+int tep_set_function_resolver(struct tep_handle *pevent,
+			      tep_func_resolver_t *func, void *priv);
 void pevent_reset_function_resolver(struct tep_handle *pevent);
 int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid);
 int pevent_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
@@ -729,12 +729,12 @@ static inline void pevent_set_cpus(struct tep_handle *pevent, int cpus)
 	pevent->cpus = cpus;
 }
 
-static inline int pevent_get_long_size(struct tep_handle *pevent)
+static inline int tep_get_long_size(struct tep_handle *pevent)
 {
 	return pevent->long_size;
 }
 
-static inline void pevent_set_long_size(struct tep_handle *pevent, int long_size)
+static inline void tep_set_long_size(struct tep_handle *pevent, int long_size)
 {
 	pevent->long_size = long_size;
 }
@@ -744,7 +744,7 @@ static inline int pevent_get_page_size(struct tep_handle *pevent)
 	return pevent->page_size;
 }
 
-static inline void pevent_set_page_size(struct tep_handle *pevent, int _page_size)
+static inline void tep_set_page_size(struct tep_handle *pevent, int _page_size)
 {
 	pevent->page_size = _page_size;
 }
@@ -754,7 +754,7 @@ static inline int pevent_is_file_bigendian(struct tep_handle *pevent)
 	return pevent->file_bigendian;
 }
 
-static inline void pevent_set_file_bigendian(struct tep_handle *pevent, int endian)
+static inline void tep_set_file_bigendian(struct tep_handle *pevent, int endian)
 {
 	pevent->file_bigendian = endian;
 }
@@ -764,7 +764,7 @@ static inline int pevent_is_host_bigendian(struct tep_handle *pevent)
 	return pevent->host_bigendian;
 }
 
-static inline void pevent_set_host_bigendian(struct tep_handle *pevent, int endian)
+static inline void tep_set_host_bigendian(struct tep_handle *pevent, int endian)
 {
 	pevent->host_bigendian = endian;
 }
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ef55177..20203ad 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -748,7 +748,7 @@ int tracecmd_read_headers(struct tracecmd_input *handle)
 	if (read_and_parse_cmdlines(handle) < 0)
 		return -1;
 
-	pevent_set_long_size(handle->pevent, handle->long_size);
+	tep_set_long_size(handle->pevent, handle->long_size);
 
 	return 0;
 }
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index fcde4d1..0dc3dc5 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -430,7 +430,7 @@ struct func_resolver {
 };
 
 /**
- * pevent_set_function_resolver - set an alternative function resolver
+ * tep_set_function_resolver - set an alternative function resolver
  * @pevent: handle for the pevent
  * @resolver: function to be used
  * @priv: resolver function private state.
@@ -439,8 +439,8 @@ struct func_resolver {
  * keep using it instead of duplicating all the entries inside
  * pevent->funclist.
  */
-int pevent_set_function_resolver(struct tep_handle *pevent,
-				 tep_func_resolver_t *func, void *priv)
+int tep_set_function_resolver(struct tep_handle *pevent,
+			      tep_func_resolver_t *func, void *priv)
 {
 	struct func_resolver *resolver = malloc(sizeof(*resolver));
 
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index e3e49eb..2b50d33 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -1520,7 +1520,7 @@ void trace_init_profile(struct tracecmd_input *handle, struct hook_list *hook,
 
 static void output_event_stack(struct tep_handle *pevent, struct stack_data *stack)
 {
-	int longsize = pevent_get_long_size(pevent);
+	int longsize = tep_get_long_size(pevent);
 	unsigned long long val;
 	const char *func;
 	unsigned long long stop = -1ULL;
@@ -1886,7 +1886,7 @@ static void output_stacks(struct tep_handle *pevent, struct trace_hash *stack_ha
 	struct stack_chain *chain;
 	unsigned long long mask = 0;
 	int nr_chains;
-	int longsize = pevent_get_long_size(pevent);
+	int longsize = tep_get_long_size(pevent);
 	int nr_stacks;
 	int i;
 
-- 
2.17.1
