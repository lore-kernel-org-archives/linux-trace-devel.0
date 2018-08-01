Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34303 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730355AbeHAO22 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 10:28:28 -0400
Received: by mail-wm0-f65.google.com with SMTP id l2-v6so13761399wme.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Aug 2018 05:42:47 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 17/24] tools/lib/traceevent: Rename pevent_register / unregister APIs
Date: Wed,  1 Aug 2018 15:41:49 +0300
Message-Id: <20180801124156.20894-18-tz.stoyanov@gmail.com>
In-Reply-To: <20180801124156.20894-1-tz.stoyanov@gmail.com>
References: <20180801124156.20894-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_register_print_function, pevent_unregister_print_function,
pevent_register_event_handler, pevent_unregister_event_handler,
pevent_register_function, pevent_register_trace_clock

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.c         | 22 ++++++------
 tools/lib/traceevent/event-parse.h         | 12 +++----
 tools/lib/traceevent/plugin_cfg80211.c     |  4 +--
 tools/lib/traceevent/plugin_function.c     |  4 +--
 tools/lib/traceevent/plugin_hrtimer.c      |  8 ++---
 tools/lib/traceevent/plugin_jbd2.c         |  8 ++---
 tools/lib/traceevent/plugin_kmem.c         | 24 ++++++-------
 tools/lib/traceevent/plugin_kvm.c          | 40 +++++++++++-----------
 tools/lib/traceevent/plugin_mac80211.c     |  4 +--
 tools/lib/traceevent/plugin_sched_switch.c | 12 +++----
 tools/lib/traceevent/plugin_scsi.c         |  4 +--
 tools/lib/traceevent/plugin_xen.c          |  4 +--
 12 files changed, 73 insertions(+), 73 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 9967c9a58359..16a0d9643731 100644
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
@@ -553,7 +553,7 @@ pevent_find_function_address(struct tep_handle *pevent, unsigned long long addr)
  * This registers a function name with an address and module.
  * The @func passed in is duplicated.
  */
-int pevent_register_function(struct tep_handle *pevent, char *func,
+int tep_register_function(struct tep_handle *pevent, char *func,
 			     unsigned long long addr, char *mod)
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
@@ -6491,7 +6491,7 @@ static void free_func_handle(struct tep_function_handler *func)
  * The @parameters is a variable list of tep_func_arg_type enums that
  * must end with TEP_FUNC_ARG_VOID.
  */
-int pevent_register_print_function(struct tep_handle *pevent,
+int tep_register_print_function(struct tep_handle *pevent,
 				   tep_func_handler func,
 				   enum tep_func_arg_type ret_type,
 				   char *name, ...)
@@ -6569,7 +6569,7 @@ int pevent_register_print_function(struct tep_handle *pevent,
 }
 
 /**
- * pevent_unregister_print_function - unregister a helper function
+ * tep_unregister_print_function - unregister a helper function
  * @pevent: the handle to the pevent
  * @func: the function to process the helper function
  * @name: the name of the helper function
@@ -6578,7 +6578,7 @@ int pevent_register_print_function(struct tep_handle *pevent,
  *
  * Returns 0 if the handler was removed successully, -1 otherwise.
  */
-int pevent_unregister_print_function(struct tep_handle *pevent,
+int tep_unregister_print_function(struct tep_handle *pevent,
 				     tep_func_handler func, char *name)
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
@@ -6631,7 +6631,7 @@ static struct event_format *pevent_search_event(struct tep_handle *pevent, int i
  * If @id is >= 0, then it is used to find the event.
  * else @sys_name and @event_name are used.
  */
-int pevent_register_event_handler(struct tep_handle *pevent, int id,
+int tep_register_event_handler(struct tep_handle *pevent, int id,
 				  const char *sys_name, const char *event_name,
 				  tep_event_handler_func func, void *context)
 {
@@ -6700,7 +6700,7 @@ static int handle_matches(struct event_handler *handler, int id,
 }
 
 /**
- * pevent_unregister_event_handler - unregister an existing event handler
+ * tep_unregister_event_handler - unregister an existing event handler
  * @pevent: the handle to the pevent
  * @id: the id of the event to unregister
  * @sys_name: the system name the handler belongs to
@@ -6715,7 +6715,7 @@ static int handle_matches(struct event_handler *handler, int id,
  *
  * Returns 0 if handler was removed successfully, -1 if event was not found.
  */
-int pevent_unregister_event_handler(struct tep_handle *pevent, int id,
+int tep_unregister_event_handler(struct tep_handle *pevent, int id,
 				    const char *sys_name, const char *event_name,
 				    tep_event_handler_func func, void *context)
 {
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 5ea88d03bf31..6a1952f5d483 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -619,8 +619,8 @@ int tep_set_function_resolver(struct tep_handle *pevent,
 				 tep_func_resolver_t *func, void *priv);
 void pevent_reset_function_resolver(struct tep_handle *pevent);
 int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid);
-int pevent_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
-int pevent_register_function(struct tep_handle *pevent, char *name,
+int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
+int tep_register_function(struct tep_handle *pevent, char *name,
 			     unsigned long long addr, char *mod);
 int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
 				 unsigned long long addr);
@@ -673,17 +673,17 @@ int tep_print_func_field(struct trace_seq *s, const char *fmt,
 			   struct event_format *event, const char *name,
 			   struct tep_record *record, int err);
 
-int pevent_register_event_handler(struct tep_handle *pevent, int id,
+int tep_register_event_handler(struct tep_handle *pevent, int id,
 				  const char *sys_name, const char *event_name,
 				  tep_event_handler_func func, void *context);
-int pevent_unregister_event_handler(struct tep_handle *pevent, int id,
+int tep_unregister_event_handler(struct tep_handle *pevent, int id,
 				    const char *sys_name, const char *event_name,
 				    tep_event_handler_func func, void *context);
-int pevent_register_print_function(struct tep_handle *pevent,
+int tep_register_print_function(struct tep_handle *pevent,
 				   tep_func_handler func,
 				   enum tep_func_arg_type ret_type,
 				   char *name, ...);
-int pevent_unregister_print_function(struct tep_handle *pevent,
+int tep_unregister_print_function(struct tep_handle *pevent,
 				     tep_func_handler func, char *name);
 
 struct format_field *tep_find_common_field(struct event_format *event, const char *name);
diff --git a/tools/lib/traceevent/plugin_cfg80211.c b/tools/lib/traceevent/plugin_cfg80211.c
index e0421e31509f..7e978b3d98a7 100644
--- a/tools/lib/traceevent/plugin_cfg80211.c
+++ b/tools/lib/traceevent/plugin_cfg80211.c
@@ -27,7 +27,7 @@ process___le16_to_cpup(struct trace_seq *s, unsigned long long *args)
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_print_function(pevent,
+	tep_register_print_function(pevent,
 				       process___le16_to_cpup,
 				       TEP_FUNC_ARG_INT,
 				       "__le16_to_cpup",
@@ -38,6 +38,6 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_print_function(pevent, process___le16_to_cpup,
+	tep_unregister_print_function(pevent, process___le16_to_cpup,
 					 "__le16_to_cpup");
 }
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index 57165da1bd51..4f534112fa78 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -165,7 +165,7 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1, "ftrace", "function",
+	tep_register_event_handler(pevent, -1, "ftrace", "function",
 				      function_handler, NULL);
 
 	tep_plugin_add_options("ftrace", plugin_options);
@@ -177,7 +177,7 @@ void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
 	int i, x;
 
-	pevent_unregister_event_handler(pevent, -1, "ftrace", "function",
+	tep_unregister_event_handler(pevent, -1, "ftrace", "function",
 					function_handler, NULL);
 
 	for (i = 0; i <= cpus; i++) {
diff --git a/tools/lib/traceevent/plugin_hrtimer.c b/tools/lib/traceevent/plugin_hrtimer.c
index c399f1faa029..748a23079f20 100644
--- a/tools/lib/traceevent/plugin_hrtimer.c
+++ b/tools/lib/traceevent/plugin_hrtimer.c
@@ -68,21 +68,21 @@ static int timer_start_handler(struct trace_seq *s,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1,
+	tep_register_event_handler(pevent, -1,
 				      "timer", "hrtimer_expire_entry",
 				      timer_expire_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "timer", "hrtimer_start",
+	tep_register_event_handler(pevent, -1, "timer", "hrtimer_start",
 				      timer_start_handler, NULL);
 	return 0;
 }
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_event_handler(pevent, -1,
+	tep_unregister_event_handler(pevent, -1,
 					"timer", "hrtimer_expire_entry",
 					timer_expire_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "timer", "hrtimer_start",
+	tep_unregister_event_handler(pevent, -1, "timer", "hrtimer_start",
 					timer_start_handler, NULL);
 }
diff --git a/tools/lib/traceevent/plugin_jbd2.c b/tools/lib/traceevent/plugin_jbd2.c
index 6da955ff037e..c5e89d71b5a6 100644
--- a/tools/lib/traceevent/plugin_jbd2.c
+++ b/tools/lib/traceevent/plugin_jbd2.c
@@ -49,14 +49,14 @@ process_jiffies_to_msecs(struct trace_seq *s, unsigned long long *args)
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_print_function(pevent,
+	tep_register_print_function(pevent,
 				       process_jbd2_dev_to_name,
 				       TEP_FUNC_ARG_STRING,
 				       "jbd2_dev_to_name",
 				       TEP_FUNC_ARG_INT,
 				       TEP_FUNC_ARG_VOID);
 
-	pevent_register_print_function(pevent,
+	tep_register_print_function(pevent,
 				       process_jiffies_to_msecs,
 				       TEP_FUNC_ARG_LONG,
 				       "jiffies_to_msecs",
@@ -67,9 +67,9 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_print_function(pevent, process_jbd2_dev_to_name,
+	tep_unregister_print_function(pevent, process_jbd2_dev_to_name,
 					 "jbd2_dev_to_name");
 
-	pevent_unregister_print_function(pevent, process_jiffies_to_msecs,
+	tep_unregister_print_function(pevent, process_jiffies_to_msecs,
 					 "jiffies_to_msecs");
 }
diff --git a/tools/lib/traceevent/plugin_kmem.c b/tools/lib/traceevent/plugin_kmem.c
index 28cabe250daf..398c5d19db38 100644
--- a/tools/lib/traceevent/plugin_kmem.c
+++ b/tools/lib/traceevent/plugin_kmem.c
@@ -50,45 +50,45 @@ static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1, "kmem", "kfree",
+	tep_register_event_handler(pevent, -1, "kmem", "kfree",
 				      call_site_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kmem", "kmalloc",
+	tep_register_event_handler(pevent, -1, "kmem", "kmalloc",
 				      call_site_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kmem", "kmalloc_node",
+	tep_register_event_handler(pevent, -1, "kmem", "kmalloc_node",
 				      call_site_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kmem", "kmem_cache_alloc",
+	tep_register_event_handler(pevent, -1, "kmem", "kmem_cache_alloc",
 				      call_site_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kmem",
+	tep_register_event_handler(pevent, -1, "kmem",
 				      "kmem_cache_alloc_node",
 				      call_site_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kmem", "kmem_cache_free",
+	tep_register_event_handler(pevent, -1, "kmem", "kmem_cache_free",
 				      call_site_handler, NULL);
 	return 0;
 }
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_event_handler(pevent, -1, "kmem", "kfree",
+	tep_unregister_event_handler(pevent, -1, "kmem", "kfree",
 					call_site_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kmem", "kmalloc",
+	tep_unregister_event_handler(pevent, -1, "kmem", "kmalloc",
 					call_site_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kmem", "kmalloc_node",
+	tep_unregister_event_handler(pevent, -1, "kmem", "kmalloc_node",
 					call_site_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kmem", "kmem_cache_alloc",
+	tep_unregister_event_handler(pevent, -1, "kmem", "kmem_cache_alloc",
 					call_site_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kmem",
+	tep_unregister_event_handler(pevent, -1, "kmem",
 					"kmem_cache_alloc_node",
 					call_site_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kmem", "kmem_cache_free",
+	tep_unregister_event_handler(pevent, -1, "kmem", "kmem_cache_free",
 					call_site_handler, NULL);
 }
diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index bf49926f9715..9560b1f659ee 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -448,36 +448,36 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
 	init_disassembler();
 
-	pevent_register_event_handler(pevent, -1, "kvm", "kvm_exit",
+	tep_register_event_handler(pevent, -1, "kvm", "kvm_exit",
 				      kvm_exit_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
+	tep_register_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
 				      kvm_emulate_insn_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
+	tep_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
 				      kvm_nested_vmexit_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
+	tep_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
 				      kvm_nested_vmexit_inject_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
+	tep_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
 				      kvm_mmu_get_page_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_sync_page",
+	tep_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_sync_page",
 				      kvm_mmu_print_role, NULL);
 
-	pevent_register_event_handler(pevent, -1,
+	tep_register_event_handler(pevent, -1,
 				      "kvmmmu", "kvm_mmu_unsync_page",
 				      kvm_mmu_print_role, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_zap_page",
+	tep_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_zap_page",
 				      kvm_mmu_print_role, NULL);
 
-	pevent_register_event_handler(pevent, -1, "kvmmmu",
+	tep_register_event_handler(pevent, -1, "kvmmmu",
 			"kvm_mmu_prepare_zap_page", kvm_mmu_print_role,
 			NULL);
 
-	pevent_register_print_function(pevent,
+	tep_register_print_function(pevent,
 				       process_is_writable_pte,
 				       TEP_FUNC_ARG_INT,
 				       "is_writable_pte",
@@ -488,35 +488,35 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_exit",
+	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_exit",
 					kvm_exit_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
+	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
 					kvm_emulate_insn_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
+	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
 					kvm_nested_vmexit_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
+	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
 					kvm_nested_vmexit_inject_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
+	tep_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
 					kvm_mmu_get_page_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_sync_page",
+	tep_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_sync_page",
 					kvm_mmu_print_role, NULL);
 
-	pevent_unregister_event_handler(pevent, -1,
+	tep_unregister_event_handler(pevent, -1,
 					"kvmmmu", "kvm_mmu_unsync_page",
 					kvm_mmu_print_role, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_zap_page",
+	tep_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_zap_page",
 					kvm_mmu_print_role, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "kvmmmu",
+	tep_unregister_event_handler(pevent, -1, "kvmmmu",
 			"kvm_mmu_prepare_zap_page", kvm_mmu_print_role,
 			NULL);
 
-	pevent_unregister_print_function(pevent, process_is_writable_pte,
+	tep_unregister_print_function(pevent, process_is_writable_pte,
 					 "is_writable_pte");
 }
diff --git a/tools/lib/traceevent/plugin_mac80211.c b/tools/lib/traceevent/plugin_mac80211.c
index 5197f940d153..e76d5f61032a 100644
--- a/tools/lib/traceevent/plugin_mac80211.c
+++ b/tools/lib/traceevent/plugin_mac80211.c
@@ -88,7 +88,7 @@ static int drv_bss_info_changed(struct trace_seq *s,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1, "mac80211",
+	tep_register_event_handler(pevent, -1, "mac80211",
 				      "drv_bss_info_changed",
 				      drv_bss_info_changed, NULL);
 	return 0;
@@ -96,7 +96,7 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_event_handler(pevent, -1, "mac80211",
+	tep_unregister_event_handler(pevent, -1, "mac80211",
 					"drv_bss_info_changed",
 					drv_bss_info_changed, NULL);
 }
diff --git a/tools/lib/traceevent/plugin_sched_switch.c b/tools/lib/traceevent/plugin_sched_switch.c
index 4d8eaab6ac15..230dc440d4bf 100644
--- a/tools/lib/traceevent/plugin_sched_switch.c
+++ b/tools/lib/traceevent/plugin_sched_switch.c
@@ -136,25 +136,25 @@ static int sched_switch_handler(struct trace_seq *s,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_event_handler(pevent, -1, "sched", "sched_switch",
+	tep_register_event_handler(pevent, -1, "sched", "sched_switch",
 				      sched_switch_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "sched", "sched_wakeup",
+	tep_register_event_handler(pevent, -1, "sched", "sched_wakeup",
 				      sched_wakeup_handler, NULL);
 
-	pevent_register_event_handler(pevent, -1, "sched", "sched_wakeup_new",
+	tep_register_event_handler(pevent, -1, "sched", "sched_wakeup_new",
 				      sched_wakeup_handler, NULL);
 	return 0;
 }
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_event_handler(pevent, -1, "sched", "sched_switch",
+	tep_unregister_event_handler(pevent, -1, "sched", "sched_switch",
 					sched_switch_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "sched", "sched_wakeup",
+	tep_unregister_event_handler(pevent, -1, "sched", "sched_wakeup",
 					sched_wakeup_handler, NULL);
 
-	pevent_unregister_event_handler(pevent, -1, "sched", "sched_wakeup_new",
+	tep_unregister_event_handler(pevent, -1, "sched", "sched_wakeup_new",
 					sched_wakeup_handler, NULL);
 }
diff --git a/tools/lib/traceevent/plugin_scsi.c b/tools/lib/traceevent/plugin_scsi.c
index ce38df7ed4d8..f01fb7ff9edf 100644
--- a/tools/lib/traceevent/plugin_scsi.c
+++ b/tools/lib/traceevent/plugin_scsi.c
@@ -415,7 +415,7 @@ unsigned long long process_scsi_trace_parse_cdb(struct trace_seq *s,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_print_function(pevent,
+	tep_register_print_function(pevent,
 				       process_scsi_trace_parse_cdb,
 				       TEP_FUNC_ARG_STRING,
 				       "scsi_trace_parse_cdb",
@@ -428,6 +428,6 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_print_function(pevent, process_scsi_trace_parse_cdb,
+	tep_unregister_print_function(pevent, process_scsi_trace_parse_cdb,
 					 "scsi_trace_parse_cdb");
 }
diff --git a/tools/lib/traceevent/plugin_xen.c b/tools/lib/traceevent/plugin_xen.c
index 2ffbd91d5bb7..be41e27340a2 100644
--- a/tools/lib/traceevent/plugin_xen.c
+++ b/tools/lib/traceevent/plugin_xen.c
@@ -121,7 +121,7 @@ unsigned long long process_xen_hypercall_name(struct trace_seq *s,
 
 int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 {
-	pevent_register_print_function(pevent,
+	tep_register_print_function(pevent,
 				       process_xen_hypercall_name,
 				       TEP_FUNC_ARG_STRING,
 				       "xen_hypercall_name",
@@ -132,6 +132,6 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 
 void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
 {
-	pevent_unregister_print_function(pevent, process_xen_hypercall_name,
+	tep_unregister_print_function(pevent, process_xen_hypercall_name,
 					 "xen_hypercall_name");
 }
-- 
2.17.1
