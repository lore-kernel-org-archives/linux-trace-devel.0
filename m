Return-Path: <SRS0=PkBc=KX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:50920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730213AbeHHU1y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Aug 2018 16:27:54 -0400
Message-Id: <20180808180702.524813185@goodmis.org>
Date: Wed, 08 Aug 2018 14:03:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [RFC][PATCH v2 17/24] tools/lib/traceevent: Rename pevent_register / unregister APIs
References: <20180808180245.352784763@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_register_print_function, pevent_unregister_print_function,
pevent_register_event_handler, pevent_unregister_event_handler,
pevent_register_function, pevent_register_trace_clock

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c         | 40 +++++-----
 tools/lib/traceevent/event-parse.h         | 30 ++++----
 tools/lib/traceevent/plugin_cfg80211.c     | 16 ++--
 tools/lib/traceevent/plugin_function.c     |  8 +-
 tools/lib/traceevent/plugin_hrtimer.c      | 20 ++---
 tools/lib/traceevent/plugin_jbd2.c         | 32 ++++----
 tools/lib/traceevent/plugin_kmem.c         | 52 ++++++-------
 tools/lib/traceevent/plugin_kvm.c          | 88 +++++++++++-----------
 tools/lib/traceevent/plugin_mac80211.c     | 12 +--
 tools/lib/traceevent/plugin_sched_switch.c | 24 +++---
 tools/lib/traceevent/plugin_scsi.c         | 20 ++---
 tools/lib/traceevent/plugin_xen.c          | 16 ++--
 12 files changed, 179 insertions(+), 179 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 8d0ce0ea52dc..0de470c07be9 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -324,7 +324,7 @@ int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid)
 	return 0;
 }
 
-int pevent_register_trace_clock(struct tep_handle *pevent, const char *trace_clock)
+int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_clock)
 {
 	pevent->trace_clock = strdup(trace_clock);
 	if (!pevent->trace_clock) {
@@ -544,7 +544,7 @@ pevent_find_function_address(struct tep_handle *pevent, unsigned long long addr)
 }
 
 /**
- * pevent_register_function - register a function with a given address
+ * tep_register_function - register a function with a given address
  * @pevent: handle for the pevent
  * @function: the function name to register
  * @addr: the address the function starts at
@@ -553,8 +553,8 @@ pevent_find_function_address(struct tep_handle *pevent, unsigned long long addr)
  * This registers a function name with an address and module.
  * The @func passed in is duplicated.
  */
-int pevent_register_function(struct tep_handle *pevent, char *func,
-			     unsigned long long addr, char *mod)
+int tep_register_function(struct tep_handle *pevent, char *func,
+			  unsigned long long addr, char *mod)
 {
 	struct func_list *item = malloc(sizeof(*item));
 
@@ -6477,7 +6477,7 @@ static void free_func_handle(struct tep_function_handler *func)
 }
 
 /**
- * pevent_register_print_function - register a helper function
+ * tep_register_print_function - register a helper function
  * @pevent: the handle to the pevent
  * @func: the function to process the helper function
  * @ret_type: the return type of the helper function
@@ -6491,10 +6491,10 @@ static void free_func_handle(struct tep_function_handler *func)
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
@@ -6569,7 +6569,7 @@ int pevent_register_print_function(struct tep_handle *pevent,
 }
 
 /**
- * pevent_unregister_print_function - unregister a helper function
+ * tep_unregister_print_function - unregister a helper function
  * @pevent: the handle to the pevent
  * @func: the function to process the helper function
  * @name: the name of the helper function
@@ -6578,8 +6578,8 @@ int pevent_register_print_function(struct tep_handle *pevent,
  *
  * Returns 0 if the handler was removed successully, -1 otherwise.
  */
-int pevent_unregister_print_function(struct tep_handle *pevent,
-				     tep_func_handler func, char *name)
+int tep_unregister_print_function(struct tep_handle *pevent,
+				  tep_func_handler func, char *name)
 {
 	struct tep_function_handler *func_handle;
 
@@ -6615,7 +6615,7 @@ static struct event_format *pevent_search_event(struct tep_handle *pevent, int i
 }
 
 /**
- * pevent_register_event_handler - register a way to parse an event
+ * tep_register_event_handler - register a way to parse an event
  * @pevent: the handle to the pevent
  * @id: the id of the event to register
  * @sys_name: the system name the event belongs to
@@ -6631,9 +6631,9 @@ static struct event_format *pevent_search_event(struct tep_handle *pevent, int i
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
@@ -6700,7 +6700,7 @@ static int handle_matches(struct event_handler *handler, int id,
 }
 
 /**
- * pevent_unregister_event_handler - unregister an existing event handler
+ * tep_unregister_event_handler - unregister an existing event handler
  * @pevent: the handle to the pevent
  * @id: the id of the event to unregister
  * @sys_name: the system name the handler belongs to
@@ -6715,9 +6715,9 @@ static int handle_matches(struct event_handler *handler, int id,
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
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index c60329cd9463..dc0d2d3b7c33 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -619,9 +619,9 @@ int tep_set_function_resolver(struct tep_handle *pevent,
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
@@ -673,18 +673,18 @@ int tep_print_func_field(struct trace_seq *s, const char *fmt,
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
diff --git a/tools/lib/traceevent/plugin_cfg80211.c b/tools/lib/traceevent/plugin_cfg80211.c
index e0421e31509f..a51b366f47da 100644
--- a/tools/lib/traceevent/plugin_cfg80211.c
+++ b/tools/lib/traceevent/plugin_cfg80211.c
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
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index 57165da1bd51..50cc356124f6 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -165,8 +165,8 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1, "ftrace", "function",
-				      function_handler, NULL);
+	tep_register_event_handler(pevent, -1, "ftrace", "function",
+				   function_handler, NULL);
 
 	tep_plugin_add_options("ftrace", plugin_options);
 
@@ -177,8 +177,8 @@ void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	int i, x;
 
-	pevent_unregister_event_handler(pevent, -1, "ftrace", "function",
-					function_handler, NULL);
+	tep_unregister_event_handler(pevent, -1, "ftrace", "function",
+				     function_handler, NULL);
 
 	for (i = 0; i <= cpus; i++) {
 		for (x = 0; x < fstack[i].size && fstack[i].stack[x]; x++)
diff --git a/tools/lib/traceevent/plugin_hrtimer.c b/tools/lib/traceevent/plugin_hrtimer.c
index a37180eef959..b43bfec565d8 100644
--- a/tools/lib/traceevent/plugin_hrtimer.c
+++ b/tools/lib/traceevent/plugin_hrtimer.c
@@ -68,21 +68,21 @@ static int timer_start_handler(struct trace_seq *s,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1,
-				      "timer", "hrtimer_expire_entry",
-				      timer_expire_handler, NULL);
+	tep_register_event_handler(pevent, -1,
+				   "timer", "hrtimer_expire_entry",
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
diff --git a/tools/lib/traceevent/plugin_jbd2.c b/tools/lib/traceevent/plugin_jbd2.c
index 6da955ff037e..45a9acd19640 100644
--- a/tools/lib/traceevent/plugin_jbd2.c
+++ b/tools/lib/traceevent/plugin_jbd2.c
@@ -49,27 +49,27 @@ process_jiffies_to_msecs(struct trace_seq *s, unsigned long long *args)
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_print_function(pevent,
-				       process_jbd2_dev_to_name,
-				       TEP_FUNC_ARG_STRING,
-				       "jbd2_dev_to_name",
-				       TEP_FUNC_ARG_INT,
-				       TEP_FUNC_ARG_VOID);
+	tep_register_print_function(pevent,
+				    process_jbd2_dev_to_name,
+				    TEP_FUNC_ARG_STRING,
+				    "jbd2_dev_to_name",
+				    TEP_FUNC_ARG_INT,
+				    TEP_FUNC_ARG_VOID);
 
-	pevent_register_print_function(pevent,
-				       process_jiffies_to_msecs,
-				       TEP_FUNC_ARG_LONG,
-				       "jiffies_to_msecs",
-				       TEP_FUNC_ARG_LONG,
-				       TEP_FUNC_ARG_VOID);
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
diff --git a/tools/lib/traceevent/plugin_kmem.c b/tools/lib/traceevent/plugin_kmem.c
index 28cabe250daf..6d5938d82c66 100644
--- a/tools/lib/traceevent/plugin_kmem.c
+++ b/tools/lib/traceevent/plugin_kmem.c
@@ -50,45 +50,45 @@ static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 
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
 
-	pevent_register_event_handler(pevent, -1, "kmem",
-				      "kmem_cache_alloc_node",
-				      call_site_handler, NULL);
+	tep_register_event_handler(pevent, -1, "kmem",
+				   "kmem_cache_alloc_node",
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
diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index c20f743edf1f..4b3433763340 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -448,75 +448,75 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
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
 
-	pevent_register_event_handler(pevent, -1,
-				      "kvmmmu", "kvm_mmu_unsync_page",
-				      kvm_mmu_print_role, NULL);
+	tep_register_event_handler(pevent, -1,
+				   "kvmmmu", "kvm_mmu_unsync_page",
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
diff --git a/tools/lib/traceevent/plugin_mac80211.c b/tools/lib/traceevent/plugin_mac80211.c
index 5197f940d153..de50a5316203 100644
--- a/tools/lib/traceevent/plugin_mac80211.c
+++ b/tools/lib/traceevent/plugin_mac80211.c
@@ -88,15 +88,15 @@ static int drv_bss_info_changed(struct trace_seq *s,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1, "mac80211",
-				      "drv_bss_info_changed",
-				      drv_bss_info_changed, NULL);
+	tep_register_event_handler(pevent, -1, "mac80211",
+				   "drv_bss_info_changed",
+				   drv_bss_info_changed, NULL);
 	return 0;
 }
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_event_handler(pevent, -1, "mac80211",
-					"drv_bss_info_changed",
-					drv_bss_info_changed, NULL);
+	tep_unregister_event_handler(pevent, -1, "mac80211",
+				     "drv_bss_info_changed",
+				     drv_bss_info_changed, NULL);
 }
diff --git a/tools/lib/traceevent/plugin_sched_switch.c b/tools/lib/traceevent/plugin_sched_switch.c
index 4d8eaab6ac15..3f3a89c3d041 100644
--- a/tools/lib/traceevent/plugin_sched_switch.c
+++ b/tools/lib/traceevent/plugin_sched_switch.c
@@ -136,25 +136,25 @@ static int sched_switch_handler(struct trace_seq *s,
 
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
diff --git a/tools/lib/traceevent/plugin_scsi.c b/tools/lib/traceevent/plugin_scsi.c
index ce38df7ed4d8..5ec346f6b842 100644
--- a/tools/lib/traceevent/plugin_scsi.c
+++ b/tools/lib/traceevent/plugin_scsi.c
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
diff --git a/tools/lib/traceevent/plugin_xen.c b/tools/lib/traceevent/plugin_xen.c
index 2ffbd91d5bb7..b2acbd6e9c86 100644
--- a/tools/lib/traceevent/plugin_xen.c
+++ b/tools/lib/traceevent/plugin_xen.c
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
-- 
2.18.0
