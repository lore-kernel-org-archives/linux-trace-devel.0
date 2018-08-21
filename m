Return-Path: <SRS0=yn/p=LE=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43109 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbeHUQyI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Aug 2018 12:54:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id k5-v6so4346736wre.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Aug 2018 06:33:55 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/24] tools lib traceevent: Rename pevent_register / unregister APIs
Date: Tue, 21 Aug 2018 16:33:21 +0300
Message-Id: <20180821133328.3249-18-tz.stoyanov@gmail.com>
In-Reply-To: <20180821133328.3249-1-tz.stoyanov@gmail.com>
References: <20180821133328.3249-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_register_print_function, pevent_unregister_print_function,
pevent_register_event_handler, pevent_unregister_event_handler,
pevent_register_function, pevent_register_trace_clock

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180808180702.524813185@goodmis.org
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h | 30 +++++------
 lib/trace-cmd/trace-ftrace.c     |  8 +--
 lib/trace-cmd/trace-util.c       |  4 +-
 lib/traceevent/event-parse.c     | 40 +++++++--------
 plugins/plugin_blk.c             |  4 +-
 plugins/plugin_cfg80211.c        | 16 +++---
 plugins/plugin_function.c        |  8 +--
 plugins/plugin_futex.c           |  8 +--
 plugins/plugin_hrtimer.c         | 18 +++----
 plugins/plugin_jbd2.c            | 34 ++++++-------
 plugins/plugin_kmem.c            | 50 +++++++++----------
 plugins/plugin_kvm.c             | 86 ++++++++++++++++----------------
 plugins/plugin_mac80211.c        |  8 +--
 plugins/plugin_sched_switch.c    | 24 ++++-----
 plugins/plugin_scsi.c            | 20 ++++----
 plugins/plugin_tlb.c             | 10 ++--
 plugins/plugin_xen.c             | 16 +++---
 python/ctracecmd.i               |  4 +-
 18 files changed, 194 insertions(+), 194 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 812ef18..9523143 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -607,9 +607,9 @@ int tep_set_function_resolver(struct tep_handle *pevent,
 			      tep_func_resolver_t *func, void *priv);
 void pevent_reset_function_resolver(struct tep_handle *pevent);
 int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid);
-int pevent_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
-int pevent_register_function(struct tep_handle *pevent, char *name,
-			     unsigned long long addr, char *mod);
+int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
+int tep_register_function(struct tep_handle *pevent, char *name,
+			  unsigned long long addr, char *mod);
 int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
 			      unsigned long long addr);
 int pevent_pid_is_registered(struct tep_handle *pevent, int pid);
@@ -661,18 +661,18 @@ int tep_print_func_field(struct trace_seq *s, const char *fmt,
 			 struct event_format *event, const char *name,
 			 struct tep_record *record, int err);
 
-int pevent_register_event_handler(struct tep_handle *pevent, int id,
-				  const char *sys_name, const char *event_name,
-				  tep_event_handler_func func, void *context);
-int pevent_unregister_event_handler(struct tep_handle *pevent, int id,
-				    const char *sys_name, const char *event_name,
-				    tep_event_handler_func func, void *context);
-int pevent_register_print_function(struct tep_handle *pevent,
-				   tep_func_handler func,
-				   enum tep_func_arg_type ret_type,
-				   char *name, ...);
-int pevent_unregister_print_function(struct tep_handle *pevent,
-				     tep_func_handler func, char *name);
+int tep_register_event_handler(struct tep_handle *pevent, int id,
+			       const char *sys_name, const char *event_name,
+			       tep_event_handler_func func, void *context);
+int tep_unregister_event_handler(struct tep_handle *pevent, int id,
+				 const char *sys_name, const char *event_name,
+				 tep_event_handler_func func, void *context);
+int tep_register_print_function(struct tep_handle *pevent,
+				tep_func_handler func,
+				enum tep_func_arg_type ret_type,
+				char *name, ...);
+int tep_unregister_print_function(struct tep_handle *pevent,
+				  tep_func_handler func, char *name);
 
 struct format_field *tep_find_common_field(struct event_format *event, const char *name);
 struct format_field *tep_find_field(struct event_format *event, const char *name);
diff --git a/lib/trace-cmd/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
index 90770fc..01a2a7c 100644
--- a/lib/trace-cmd/trace-ftrace.c
+++ b/lib/trace-cmd/trace-ftrace.c
@@ -421,16 +421,16 @@ int tracecmd_ftrace_overrides(struct tracecmd_input *handle,
 
 	pevent = tracecmd_get_pevent(handle);
 
-	pevent_register_event_handler(pevent, -1, "ftrace", "function",
+	tep_register_event_handler(pevent, -1, "ftrace", "function",
 				      function_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "ftrace", "funcgraph_entry",
+	tep_register_event_handler(pevent, -1, "ftrace", "funcgraph_entry",
 				      fgraph_ent_handler, finfo);
 
-	pevent_register_event_handler(pevent, -1, "ftrace", "funcgraph_exit",
+	tep_register_event_handler(pevent, -1, "ftrace", "funcgraph_exit",
 				      fgraph_ret_handler, finfo);
 
-	pevent_register_event_handler(pevent, -1, "ftrace", "kernel_stack",
+	tep_register_event_handler(pevent, -1, "ftrace", "kernel_stack",
 				      trace_stack_handler, finfo);
 
 	trace_util_add_options("ftrace", trace_ftrace_options);
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 877907d..0760815 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -388,7 +388,7 @@ static void extract_trace_clock(struct tep_handle *pevent, char *line)
 
 	data = strtok_r(line, "[]", &next);
 	sscanf(data, "%ms", &clock);
-	pevent_register_trace_clock(pevent, clock);
+	tep_register_trace_clock(pevent, clock);
 	free(clock);
 }
 
@@ -444,7 +444,7 @@ void tracecmd_parse_proc_kallsyms(struct tep_handle *pevent,
 		 *  - x86-64 that reports per-cpu variable offsets as absolute
 		 */
 		if (func[0] != '$' && ch != 'A' && ch != 'a')
-			pevent_register_function(pevent, func, addr, mod);
+			tep_register_function(pevent, func, addr, mod);
 		free(func);
 		free(mod);
 
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 5e4f493..7f9c0b3 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -310,7 +310,7 @@ int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid)
 	return 0;
 }
 
-int pevent_register_trace_clock(struct tep_handle *pevent, const char *trace_clock)
+int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_clock)
 {
 	pevent->trace_clock = strdup(trace_clock);
 	if (!pevent->trace_clock) {
@@ -530,7 +530,7 @@ pevent_find_function_address(struct tep_handle *pevent, unsigned long long addr)
 }
 
 /**
- * pevent_register_function - register a function with a given address
+ * tep_register_function - register a function with a given address
  * @pevent: handle for the pevent
  * @function: the function name to register
  * @addr: the address the function starts at
@@ -539,8 +539,8 @@ pevent_find_function_address(struct tep_handle *pevent, unsigned long long addr)
  * This registers a function name with an address and module.
  * The @func passed in is duplicated.
  */
-int pevent_register_function(struct tep_handle *pevent, char *func,
-			     unsigned long long addr, char *mod)
+int tep_register_function(struct tep_handle *pevent, char *func,
+			  unsigned long long addr, char *mod)
 {
 	struct func_list *item = malloc(sizeof(*item));
 
@@ -6463,7 +6463,7 @@ static void free_func_handle(struct tep_function_handler *func)
 }
 
 /**
- * pevent_register_print_function - register a helper function
+ * tep_register_print_function - register a helper function
  * @pevent: the handle to the pevent
  * @func: the function to process the helper function
  * @ret_type: the return type of the helper function
@@ -6477,10 +6477,10 @@ static void free_func_handle(struct tep_function_handler *func)
  * The @parameters is a variable list of tep_func_arg_type enums that
  * must end with TEP_FUNC_ARG_VOID.
  */
-int pevent_register_print_function(struct tep_handle *pevent,
-				   tep_func_handler func,
-				   enum tep_func_arg_type ret_type,
-				   char *name, ...)
+int tep_register_print_function(struct tep_handle *pevent,
+				tep_func_handler func,
+				enum tep_func_arg_type ret_type,
+				char *name, ...)
 {
 	struct tep_function_handler *func_handle;
 	struct pevent_func_params **next_param;
@@ -6555,7 +6555,7 @@ int pevent_register_print_function(struct tep_handle *pevent,
 }
 
 /**
- * pevent_unregister_print_function - unregister a helper function
+ * tep_unregister_print_function - unregister a helper function
  * @pevent: the handle to the pevent
  * @func: the function to process the helper function
  * @name: the name of the helper function
@@ -6564,8 +6564,8 @@ int pevent_register_print_function(struct tep_handle *pevent,
  *
  * Returns 0 if the handler was removed successully, -1 otherwise.
  */
-int pevent_unregister_print_function(struct tep_handle *pevent,
-				     tep_func_handler func, char *name)
+int tep_unregister_print_function(struct tep_handle *pevent,
+				  tep_func_handler func, char *name)
 {
 	struct tep_function_handler *func_handle;
 
@@ -6601,7 +6601,7 @@ static struct event_format *pevent_search_event(struct tep_handle *pevent, int i
 }
 
 /**
- * pevent_register_event_handler - register a way to parse an event
+ * tep_register_event_handler - register a way to parse an event
  * @pevent: the handle to the pevent
  * @id: the id of the event to register
  * @sys_name: the system name the event belongs to
@@ -6617,9 +6617,9 @@ static struct event_format *pevent_search_event(struct tep_handle *pevent, int i
  * If @id is >= 0, then it is used to find the event.
  * else @sys_name and @event_name are used.
  */
-int pevent_register_event_handler(struct tep_handle *pevent, int id,
-				  const char *sys_name, const char *event_name,
-				  tep_event_handler_func func, void *context)
+int tep_register_event_handler(struct tep_handle *pevent, int id,
+			       const char *sys_name, const char *event_name,
+			       tep_event_handler_func func, void *context)
 {
 	struct event_format *event;
 	struct event_handler *handle;
@@ -6686,7 +6686,7 @@ static int handle_matches(struct event_handler *handler, int id,
 }
 
 /**
- * pevent_unregister_event_handler - unregister an existing event handler
+ * tep_unregister_event_handler - unregister an existing event handler
  * @pevent: the handle to the pevent
  * @id: the id of the event to unregister
  * @sys_name: the system name the handler belongs to
@@ -6701,9 +6701,9 @@ static int handle_matches(struct event_handler *handler, int id,
  *
  * Returns 0 if handler was removed successfully, -1 if event was not found.
  */
-int pevent_unregister_event_handler(struct tep_handle *pevent, int id,
-				    const char *sys_name, const char *event_name,
-				    tep_event_handler_func func, void *context)
+int tep_unregister_event_handler(struct tep_handle *pevent, int id,
+				 const char *sys_name, const char *event_name,
+				 tep_event_handler_func func, void *context)
 {
 	struct event_format *event;
 	struct event_handler *handle;
diff --git a/plugins/plugin_blk.c b/plugins/plugin_blk.c
index 5070af2..0e92546 100644
--- a/plugins/plugin_blk.c
+++ b/plugins/plugin_blk.c
@@ -365,7 +365,7 @@ static int blktrace_handler(struct trace_seq *s, struct tep_record *record,
 
 int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1, "ftrace", "blktrace",
-				      blktrace_handler, NULL);
+	tep_register_event_handler(pevent, -1, "ftrace", "blktrace",
+				   blktrace_handler, NULL);
 	return 0;
 }
diff --git a/plugins/plugin_cfg80211.c b/plugins/plugin_cfg80211.c
index e0421e3..a51b366 100644
--- a/plugins/plugin_cfg80211.c
+++ b/plugins/plugin_cfg80211.c
@@ -27,17 +27,17 @@ process___le16_to_cpup(struct trace_seq *s, unsigned long long *args)
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_print_function(pevent,
-				       process___le16_to_cpup,
-				       TEP_FUNC_ARG_INT,
-				       "__le16_to_cpup",
-				       TEP_FUNC_ARG_PTR,
-				       TEP_FUNC_ARG_VOID);
+	tep_register_print_function(pevent,
+				    process___le16_to_cpup,
+				    TEP_FUNC_ARG_INT,
+				    "__le16_to_cpup",
+				    TEP_FUNC_ARG_PTR,
+				    TEP_FUNC_ARG_VOID);
 	return 0;
 }
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_print_function(pevent, process___le16_to_cpup,
-					 "__le16_to_cpup");
+	tep_unregister_print_function(pevent, process___le16_to_cpup,
+				      "__le16_to_cpup");
 }
diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index 5434a5f..f88da43 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -170,8 +170,8 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1, "ftrace", "function",
-				      function_handler, NULL);
+	tep_register_event_handler(pevent, -1, "ftrace", "function",
+				   function_handler, NULL);
 
 	trace_util_add_options("ftrace", plugin_options);
 
@@ -182,8 +182,8 @@ void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	int i, x;
 
-	pevent_unregister_event_handler(pevent, -1, "ftrace", "function",
-					function_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "ftrace", "function",
+				     function_handler, NULL);
 
 	for (i = 0; i <= cpus; i++) {
 		for (x = 0; x < fstack[i].size && fstack[i].stack[x]; x++)
diff --git a/plugins/plugin_futex.c b/plugins/plugin_futex.c
index 60babce..d060bd0 100644
--- a/plugins/plugin_futex.c
+++ b/plugins/plugin_futex.c
@@ -109,13 +109,13 @@ static int futex_handler(struct trace_seq *s, struct tep_record *record,
 
 int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1, "syscalls", "sys_enter_futex",
-				      futex_handler, NULL);
+	tep_register_event_handler(pevent, -1, "syscalls", "sys_enter_futex",
+				   futex_handler, NULL);
 	return 0;
 }
 
 void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_event_handler(pevent, -1, "syscalls", "sys_enter_futex",
-					futex_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "syscalls", "sys_enter_futex",
+				     futex_handler, NULL);
 }
diff --git a/plugins/plugin_hrtimer.c b/plugins/plugin_hrtimer.c
index f3a0ceb..a2edb69 100644
--- a/plugins/plugin_hrtimer.c
+++ b/plugins/plugin_hrtimer.c
@@ -48,21 +48,21 @@ static int timer_start_handler(struct trace_seq *s, struct tep_record *record,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1, "timer", "hrtimer_expire_entry",
-				      timer_expire_handler, NULL);
+	tep_register_event_handler(pevent, -1, "timer", "hrtimer_expire_entry",
+				   timer_expire_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "timer", "hrtimer_start",
-				      timer_start_handler, NULL);
+	tep_register_event_handler(pevent, -1, "timer", "hrtimer_start",
+				   timer_start_handler, NULL);
 
 	return 0;
 }
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_event_handler(pevent, -1,
-					"timer", "hrtimer_expire_entry",
-					timer_expire_handler, NULL);
+	tep_unregister_event_handler(pevent, -1,
+				     "timer", "hrtimer_expire_entry",
+				     timer_expire_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "timer", "hrtimer_start",
-					timer_start_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "timer", "hrtimer_start",
+				     timer_start_handler, NULL);
 }
diff --git a/plugins/plugin_jbd2.c b/plugins/plugin_jbd2.c
index 0dd1633..fe95f3e 100644
--- a/plugins/plugin_jbd2.c
+++ b/plugins/plugin_jbd2.c
@@ -36,27 +36,27 @@ process_jiffies_to_msecs(struct trace_seq *s,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_print_function(pevent,
-				       process_jbd2_dev_to_name,
-				       TEP_FUNC_ARG_STRING,
-				       "jbd2_dev_to_name",
-				       TEP_FUNC_ARG_INT,
-				       TEP_FUNC_ARG_VOID);
-
-	pevent_register_print_function(pevent,
-				       process_jiffies_to_msecs,
-				       TEP_FUNC_ARG_LONG,
-				       "jiffies_to_msecs",
-				       TEP_FUNC_ARG_LONG,
-				       TEP_FUNC_ARG_VOID);
+	tep_register_print_function(pevent,
+				    process_jbd2_dev_to_name,
+				    TEP_FUNC_ARG_STRING,
+				    "jbd2_dev_to_name",
+				    TEP_FUNC_ARG_INT,
+				    TEP_FUNC_ARG_VOID);
+
+	tep_register_print_function(pevent,
+				    process_jiffies_to_msecs,
+				    TEP_FUNC_ARG_LONG,
+				    "jiffies_to_msecs",
+				    TEP_FUNC_ARG_LONG,
+				    TEP_FUNC_ARG_VOID);
 	return 0;
 }
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_print_function(pevent, process_jbd2_dev_to_name,
-					 "jbd2_dev_to_name");
+	tep_unregister_print_function(pevent, process_jbd2_dev_to_name,
+				      "jbd2_dev_to_name");
 
-	pevent_unregister_print_function(pevent, process_jiffies_to_msecs,
-					 "jiffies_to_msecs");
+	tep_unregister_print_function(pevent, process_jiffies_to_msecs,
+				      "jiffies_to_msecs");
 }
diff --git a/plugins/plugin_kmem.c b/plugins/plugin_kmem.c
index 0840d6f..3088d3a 100644
--- a/plugins/plugin_kmem.c
+++ b/plugins/plugin_kmem.c
@@ -35,45 +35,45 @@ static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1, "kmem", "kfree",
-				      call_site_handler, NULL);
+	tep_register_event_handler(pevent, -1, "kmem", "kfree",
+				   call_site_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kmem", "kmalloc",
-				      call_site_handler, NULL);
+	tep_register_event_handler(pevent, -1, "kmem", "kmalloc",
+				   call_site_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kmem", "kmalloc_node",
-				      call_site_handler, NULL);
+	tep_register_event_handler(pevent, -1, "kmem", "kmalloc_node",
+				   call_site_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kmem", "kmem_cache_alloc",
-				      call_site_handler, NULL);
+	tep_register_event_handler(pevent, -1, "kmem", "kmem_cache_alloc",
+				   call_site_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kmem", "kmem_cache_alloc_node",
-				      call_site_handler, NULL);
+	tep_register_event_handler(pevent, -1, "kmem", "kmem_cache_alloc_node",
+				   call_site_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kmem", "kmem_cache_free",
-				      call_site_handler, NULL);
+	tep_register_event_handler(pevent, -1, "kmem", "kmem_cache_free",
+				   call_site_handler, NULL);
 
 	return 0;
 }
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_event_handler(pevent, -1, "kmem", "kfree",
-					call_site_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "kmem", "kfree",
+				     call_site_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kmem", "kmalloc",
-					call_site_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "kmem", "kmalloc",
+				     call_site_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kmem", "kmalloc_node",
-					call_site_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "kmem", "kmalloc_node",
+				     call_site_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kmem", "kmem_cache_alloc",
-					call_site_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "kmem", "kmem_cache_alloc",
+				     call_site_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kmem",
-					"kmem_cache_alloc_node",
-					call_site_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "kmem",
+				     "kmem_cache_alloc_node",
+				     call_site_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kmem", "kmem_cache_free",
-					call_site_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "kmem", "kmem_cache_free",
+				     call_site_handler, NULL);
 }
diff --git a/plugins/plugin_kvm.c b/plugins/plugin_kvm.c
index a7626ac..2c1a8a7 100644
--- a/plugins/plugin_kvm.c
+++ b/plugins/plugin_kvm.c
@@ -442,74 +442,74 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	init_disassembler();
 
-	pevent_register_event_handler(pevent, -1, "kvm", "kvm_exit",
-				      kvm_exit_handler, NULL);
+	tep_register_event_handler(pevent, -1, "kvm", "kvm_exit",
+				   kvm_exit_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
-				      kvm_emulate_insn_handler, NULL);
+	tep_register_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
+				   kvm_emulate_insn_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
-				      kvm_nested_vmexit_handler, NULL);
+	tep_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
+				   kvm_nested_vmexit_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
-				      kvm_nested_vmexit_inject_handler, NULL);
+	tep_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
+				   kvm_nested_vmexit_inject_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
-				      kvm_mmu_get_page_handler, NULL);
+	tep_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
+				   kvm_mmu_get_page_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_sync_page",
-				      kvm_mmu_print_role, NULL);
+	tep_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_sync_page",
+				   kvm_mmu_print_role, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_unsync_page",
-				      kvm_mmu_print_role, NULL);
+	tep_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_unsync_page",
+				   kvm_mmu_print_role, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_zap_page",
-				      kvm_mmu_print_role, NULL);
+	tep_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_zap_page",
+				   kvm_mmu_print_role, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kvmmmu",
+	tep_register_event_handler(pevent, -1, "kvmmmu",
 			"kvm_mmu_prepare_zap_page", kvm_mmu_print_role,
 			NULL);
 
-	pevent_register_print_function(pevent,
-				       process_is_writable_pte,
-				       TEP_FUNC_ARG_INT,
-				       "is_writable_pte",
-				       TEP_FUNC_ARG_LONG,
-				       TEP_FUNC_ARG_VOID);
+	tep_register_print_function(pevent,
+				    process_is_writable_pte,
+				    TEP_FUNC_ARG_INT,
+				    "is_writable_pte",
+				    TEP_FUNC_ARG_LONG,
+				    TEP_FUNC_ARG_VOID);
 	return 0;
 }
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_exit",
-					kvm_exit_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_exit",
+				     kvm_exit_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
-					kvm_emulate_insn_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
+				     kvm_emulate_insn_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
-					kvm_nested_vmexit_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
+				     kvm_nested_vmexit_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
-					kvm_nested_vmexit_inject_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
+				     kvm_nested_vmexit_inject_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
-					kvm_mmu_get_page_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
+				     kvm_mmu_get_page_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_sync_page",
-					kvm_mmu_print_role, NULL);
+	tep_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_sync_page",
+				     kvm_mmu_print_role, NULL);
 
-	pevent_unregister_event_handler(pevent, -1,
-					"kvmmmu", "kvm_mmu_unsync_page",
-					kvm_mmu_print_role, NULL);
+	tep_unregister_event_handler(pevent, -1,
+				     "kvmmmu", "kvm_mmu_unsync_page",
+				     kvm_mmu_print_role, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_zap_page",
-					kvm_mmu_print_role, NULL);
+	tep_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_zap_page",
+				     kvm_mmu_print_role, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kvmmmu",
+	tep_unregister_event_handler(pevent, -1, "kvmmmu",
 			"kvm_mmu_prepare_zap_page", kvm_mmu_print_role,
 			NULL);
 
-	pevent_unregister_print_function(pevent, process_is_writable_pte,
-					 "is_writable_pte");
+	tep_unregister_print_function(pevent, process_is_writable_pte,
+				      "is_writable_pte");
 }
diff --git a/plugins/plugin_mac80211.c b/plugins/plugin_mac80211.c
index 5fc3170..72f7d7c 100644
--- a/plugins/plugin_mac80211.c
+++ b/plugins/plugin_mac80211.c
@@ -178,10 +178,10 @@ static int drv_config(struct trace_seq *s, struct tep_record *record,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1, "mac80211", "drv_bss_info_changed",
-				      drv_bss_info_changed, NULL);
-	pevent_register_event_handler(pevent, -1, "mac80211", "drv_config",
-				      drv_config, NULL);
+	tep_register_event_handler(pevent, -1, "mac80211", "drv_bss_info_changed",
+				   drv_bss_info_changed, NULL);
+	tep_register_event_handler(pevent, -1, "mac80211", "drv_config",
+				   drv_config, NULL);
 
 	return 0;
 }
diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index 534e99c..f1229b8 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -119,26 +119,26 @@ static int sched_switch_handler(struct trace_seq *s, struct tep_record *record,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1, "sched", "sched_switch",
-				      sched_switch_handler, NULL);
+	tep_register_event_handler(pevent, -1, "sched", "sched_switch",
+				   sched_switch_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "sched", "sched_wakeup",
-				      sched_wakeup_handler, NULL);
+	tep_register_event_handler(pevent, -1, "sched", "sched_wakeup",
+				   sched_wakeup_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "sched", "sched_wakeup_new",
-				      sched_wakeup_handler, NULL);
+	tep_register_event_handler(pevent, -1, "sched", "sched_wakeup_new",
+				   sched_wakeup_handler, NULL);
 
 	return 0;
 }
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_event_handler(pevent, -1, "sched", "sched_switch",
-					sched_switch_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "sched", "sched_switch",
+				     sched_switch_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "sched", "sched_wakeup",
-					sched_wakeup_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "sched", "sched_wakeup",
+				     sched_wakeup_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "sched", "sched_wakeup_new",
-					sched_wakeup_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "sched", "sched_wakeup_new",
+				     sched_wakeup_handler, NULL);
 }
diff --git a/plugins/plugin_scsi.c b/plugins/plugin_scsi.c
index ce38df7..5ec346f 100644
--- a/plugins/plugin_scsi.c
+++ b/plugins/plugin_scsi.c
@@ -415,19 +415,19 @@ unsigned long long process_scsi_trace_parse_cdb(struct trace_seq *s,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_print_function(pevent,
-				       process_scsi_trace_parse_cdb,
-				       TEP_FUNC_ARG_STRING,
-				       "scsi_trace_parse_cdb",
-				       TEP_FUNC_ARG_PTR,
-				       TEP_FUNC_ARG_PTR,
-				       TEP_FUNC_ARG_INT,
-				       TEP_FUNC_ARG_VOID);
+	tep_register_print_function(pevent,
+				    process_scsi_trace_parse_cdb,
+				    TEP_FUNC_ARG_STRING,
+				    "scsi_trace_parse_cdb",
+				    TEP_FUNC_ARG_PTR,
+				    TEP_FUNC_ARG_PTR,
+				    TEP_FUNC_ARG_INT,
+				    TEP_FUNC_ARG_VOID);
 	return 0;
 }
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_print_function(pevent, process_scsi_trace_parse_cdb,
-					 "scsi_trace_parse_cdb");
+	tep_unregister_print_function(pevent, process_scsi_trace_parse_cdb,
+				      "scsi_trace_parse_cdb");
 }
diff --git a/plugins/plugin_tlb.c b/plugins/plugin_tlb.c
index 86f4cba..9f1a70a 100644
--- a/plugins/plugin_tlb.c
+++ b/plugins/plugin_tlb.c
@@ -52,15 +52,15 @@ static int tlb_flush_handler(struct trace_seq *s, struct tep_record *record,
 
 int PEVENT_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1, "tlb", "tlb_flush",
-				      tlb_flush_handler, NULL);
+	tep_register_event_handler(pevent, -1, "tlb", "tlb_flush",
+				   tlb_flush_handler, NULL);
 
 	return 0;
 }
 
 void PEVENT_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_event_handler(pevent, -1,
-					"tlb", "tlb_flush",
-					tlb_flush_handler, NULL);
+	tep_unregister_event_handler(pevent, -1,
+				     "tlb", "tlb_flush",
+				     tlb_flush_handler, NULL);
 }
diff --git a/plugins/plugin_xen.c b/plugins/plugin_xen.c
index 2ffbd91..b2acbd6 100644
--- a/plugins/plugin_xen.c
+++ b/plugins/plugin_xen.c
@@ -121,17 +121,17 @@ unsigned long long process_xen_hypercall_name(struct trace_seq *s,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_print_function(pevent,
-				       process_xen_hypercall_name,
-				       TEP_FUNC_ARG_STRING,
-				       "xen_hypercall_name",
-				       TEP_FUNC_ARG_INT,
-				       TEP_FUNC_ARG_VOID);
+	tep_register_print_function(pevent,
+				    process_xen_hypercall_name,
+				    TEP_FUNC_ARG_STRING,
+				    "xen_hypercall_name",
+				    TEP_FUNC_ARG_INT,
+				    TEP_FUNC_ARG_VOID);
 	return 0;
 }
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_print_function(pevent, process_xen_hypercall_name,
-					 "xen_hypercall_name");
+	tep_unregister_print_function(pevent, process_xen_hypercall_name,
+				      "xen_hypercall_name");
 }
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index 0a3b84a..e29581e 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -76,8 +76,8 @@ void py_pevent_register_event_handler(struct tep_handle *pevent, int id,
 				      PyObject *pyfunc)
 {
 	Py_INCREF(pyfunc);
-	pevent_register_event_handler(pevent, id, subsys, evname,
-				      python_callback, pyfunc);
+	tep_register_event_handler(pevent, id, subsys, evname,
+				   python_callback, pyfunc);
 }
 
 static PyObject *py_field_get_stack(struct tep_handle *pevent,
-- 
2.17.1
