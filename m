Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37BACC4320A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 03:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1761060EB5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 03:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbhHQDvC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237000AbhHQDvB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 23:51:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8885F60EFE;
        Tue, 17 Aug 2021 03:50:28 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mFq7P-004OKj-BY; Mon, 16 Aug 2021 23:50:27 -0400
Message-ID: <20210817035027.174869074@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 16 Aug 2021 23:42:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 2/7] tracing: Have dynamic events have a ref counter
References: <20210817034255.421910614@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As dynamic events are not created by modules, if something is attached to
one, calling "try_module_get()" on its "mod" field, is not going to keep
the dynamic event from going away.

Since dynamic events do not need the "mod" pointer of the event structure,
make a union out of it in order to save memory (there's one structure for
each of the thousand+ events in the kernel), and have any event with the
DYNAMIC flag set to use a ref counter instead.

Link: https://lore.kernel.org/linux-trace-devel/20210813004448.51c7de69ce432d338f4d226b@kernel.org/

Suggested-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/linux/trace_events.h        | 45 ++++++++++++++++++++++++++++-
 kernel/trace/trace.c                |  4 +--
 kernel/trace/trace_dynevent.c       | 38 ++++++++++++++++++++++++
 kernel/trace/trace_event_perf.c     |  6 ++--
 kernel/trace/trace_events.c         | 22 +++++++++-----
 kernel/trace/trace_events_synth.c   | 19 +++++++-----
 kernel/trace/trace_events_trigger.c |  6 ++--
 kernel/trace/trace_kprobe.c         |  4 +++
 kernel/trace/trace_uprobe.c         |  4 +++
 9 files changed, 124 insertions(+), 24 deletions(-)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 53c9dffd87fd..858443258812 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -350,7 +350,14 @@ struct trace_event_call {
 	struct trace_event	event;
 	char			*print_fmt;
 	struct event_filter	*filter;
-	void			*mod;
+	/*
+	 * Static events can disappear with modules,
+	 * where as dynamic ones need their own ref count.
+	 */
+	union {
+		void				*module;
+		atomic_t			refcnt;
+	};
 	void			*data;
 
 	/* See the TRACE_EVENT_FL_* flags above */
@@ -366,6 +373,42 @@ struct trace_event_call {
 #endif
 };
 
+#ifdef CONFIG_DYNAMIC_EVENTS
+bool trace_event_dyn_try_get_ref(struct trace_event_call *call);
+void trace_event_dyn_put_ref(struct trace_event_call *call);
+bool trace_event_dyn_busy(struct trace_event_call *call);
+#else
+static inline bool trace_event_dyn_try_get_ref(struct trace_event_call *call)
+{
+	/* Without DYNAMIC_EVENTS configured, nothing should be calling this */
+	return false;
+}
+static inline void trace_event_dyn_put_ref(struct trace_event_call *call)
+{
+}
+static inline bool trace_event_dyn_busy(struct trace_event_call *call)
+{
+	/* Nothing should call this without DYNAIMIC_EVENTS configured. */
+	return true;
+}
+#endif
+
+static inline bool trace_event_try_get_ref(struct trace_event_call *call)
+{
+	if (call->flags & TRACE_EVENT_FL_DYNAMIC)
+		return trace_event_dyn_try_get_ref(call);
+	else
+		return try_module_get(call->module);
+}
+
+static inline void trace_event_put_ref(struct trace_event_call *call)
+{
+	if (call->flags & TRACE_EVENT_FL_DYNAMIC)
+		return trace_event_dyn_put_ref(call);
+	else
+		return module_put(call->module);
+}
+
 #ifdef CONFIG_PERF_EVENTS
 static inline bool bpf_prog_array_valid(struct trace_event_call *call)
 {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index be0169594de5..8425c3d70895 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3697,11 +3697,11 @@ static bool trace_safe_str(struct trace_iterator *iter, const char *str)
 		return false;
 
 	event = container_of(trace_event, struct trace_event_call, event);
-	if (!event->mod)
+	if ((event->flags & TRACE_EVENT_FL_DYNAMIC) || !event->module)
 		return false;
 
 	/* Would rather have rodata, but this will suffice */
-	if (within_module_core(addr, event->mod))
+	if (within_module_core(addr, event->module))
 		return true;
 
 	return false;
diff --git a/kernel/trace/trace_dynevent.c b/kernel/trace/trace_dynevent.c
index e57cc0870892..1110112e55bd 100644
--- a/kernel/trace/trace_dynevent.c
+++ b/kernel/trace/trace_dynevent.c
@@ -13,11 +13,49 @@
 #include <linux/tracefs.h>
 
 #include "trace.h"
+#include "trace_output.h"	/* for trace_event_sem */
 #include "trace_dynevent.h"
 
 static DEFINE_MUTEX(dyn_event_ops_mutex);
 static LIST_HEAD(dyn_event_ops_list);
 
+bool trace_event_dyn_try_get_ref(struct trace_event_call *dyn_call)
+{
+	struct trace_event_call *call;
+	bool ret = false;
+
+	if (WARN_ON_ONCE(!(dyn_call->flags & TRACE_EVENT_FL_DYNAMIC)))
+		return false;
+
+	down_read(&trace_event_sem);
+	list_for_each_entry(call, &ftrace_events, list) {
+		if (call == dyn_call) {
+			atomic_inc(&dyn_call->refcnt);
+			ret = true;
+		}
+	}
+	up_read(&trace_event_sem);
+	return ret;
+}
+
+void trace_event_dyn_put_ref(struct trace_event_call *call)
+{
+	if (WARN_ON_ONCE(!(call->flags & TRACE_EVENT_FL_DYNAMIC)))
+		return;
+
+	if (WARN_ON_ONCE(atomic_read(&call->refcnt) <= 0)) {
+		atomic_set(&call->refcnt, 0);
+		return;
+	}
+
+	atomic_dec(&call->refcnt);
+}
+
+bool trace_event_dyn_busy(struct trace_event_call *call)
+{
+	return atomic_read(&call->refcnt) != 0;
+}
+
 int dyn_event_register(struct dyn_event_operations *ops)
 {
 	if (!ops || !ops->create || !ops->show || !ops->is_busy ||
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 03be4435d103..6aed10e2f7ce 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -177,7 +177,7 @@ static void perf_trace_event_unreg(struct perf_event *p_event)
 		}
 	}
 out:
-	module_put(tp_event->mod);
+	trace_event_put_ref(tp_event);
 }
 
 static int perf_trace_event_open(struct perf_event *p_event)
@@ -224,10 +224,10 @@ int perf_trace_init(struct perf_event *p_event)
 	list_for_each_entry(tp_event, &ftrace_events, list) {
 		if (tp_event->event.type == event_id &&
 		    tp_event->class && tp_event->class->reg &&
-		    try_module_get(tp_event->mod)) {
+		    trace_event_try_get_ref(tp_event)) {
 			ret = perf_trace_event_init(tp_event, p_event);
 			if (ret)
-				module_put(tp_event->mod);
+				trace_event_put_ref(tp_event);
 			break;
 		}
 	}
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 80e96989770e..1349b6de5eeb 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2525,7 +2525,10 @@ __register_event(struct trace_event_call *call, struct module *mod)
 		return ret;
 
 	list_add(&call->list, &ftrace_events);
-	call->mod = mod;
+	if (call->flags & TRACE_EVENT_FL_DYNAMIC)
+		atomic_set(&call->refcnt, 0);
+	else
+		call->module = mod;
 
 	return 0;
 }
@@ -2839,7 +2842,9 @@ static void trace_module_remove_events(struct module *mod)
 
 	down_write(&trace_event_sem);
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
-		if (call->mod == mod)
+		if ((call->flags & TRACE_EVENT_FL_DYNAMIC) || !call->module)
+			continue;
+		if (call->module == mod)
 			__trace_remove_event_call(call);
 	}
 	up_write(&trace_event_sem);
@@ -2982,7 +2987,7 @@ struct trace_event_file *trace_get_event_file(const char *instance,
 	}
 
 	/* Don't let event modules unload while in use */
-	ret = try_module_get(file->event_call->mod);
+	ret = trace_event_try_get_ref(file->event_call);
 	if (!ret) {
 		trace_array_put(tr);
 		ret = -EBUSY;
@@ -3012,7 +3017,7 @@ EXPORT_SYMBOL_GPL(trace_get_event_file);
 void trace_put_event_file(struct trace_event_file *file)
 {
 	mutex_lock(&event_mutex);
-	module_put(file->event_call->mod);
+	trace_event_put_ref(file->event_call);
 	mutex_unlock(&event_mutex);
 
 	trace_array_put(file->tr);
@@ -3147,7 +3152,7 @@ static int free_probe_data(void *data)
 	if (!edata->ref) {
 		/* Remove the SOFT_MODE flag */
 		__ftrace_event_enable_disable(edata->file, 0, 1);
-		module_put(edata->file->event_call->mod);
+		trace_event_put_ref(edata->file->event_call);
 		kfree(edata);
 	}
 	return 0;
@@ -3280,7 +3285,7 @@ event_enable_func(struct trace_array *tr, struct ftrace_hash *hash,
 
  out_reg:
 	/* Don't let event modules unload while probe registered */
-	ret = try_module_get(file->event_call->mod);
+	ret = trace_event_try_get_ref(file->event_call);
 	if (!ret) {
 		ret = -EBUSY;
 		goto out_free;
@@ -3310,7 +3315,7 @@ event_enable_func(struct trace_array *tr, struct ftrace_hash *hash,
  out_disable:
 	__ftrace_event_enable_disable(file, 0, 1);
  out_put:
-	module_put(file->event_call->mod);
+	trace_event_put_ref(file->event_call);
  out_free:
 	kfree(data);
 	goto out;
@@ -3376,7 +3381,8 @@ void __trace_early_add_events(struct trace_array *tr)
 
 	list_for_each_entry(call, &ftrace_events, list) {
 		/* Early boot up should not have any modules loaded */
-		if (WARN_ON_ONCE(call->mod))
+		if (!(call->flags & TRACE_EVENT_FL_DYNAMIC) &&
+		    WARN_ON_ONCE(call->module))
 			continue;
 
 		ret = __trace_early_add_new_event(call, tr);
diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index f4f5489e1e28..d54094b7a9d7 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -1369,13 +1369,15 @@ static int destroy_synth_event(struct synth_event *se)
 	int ret;
 
 	if (se->ref)
-		ret = -EBUSY;
-	else {
-		ret = unregister_synth_event(se);
-		if (!ret) {
-			dyn_event_remove(&se->devent);
-			free_synth_event(se);
-		}
+		return -EBUSY;
+
+	if (trace_event_dyn_busy(&se->call))
+		return -EBUSY;
+
+	ret = unregister_synth_event(se);
+	if (!ret) {
+		dyn_event_remove(&se->devent);
+		free_synth_event(se);
 	}
 
 	return ret;
@@ -2102,6 +2104,9 @@ static int synth_event_release(struct dyn_event *ev)
 	if (event->ref)
 		return -EBUSY;
 
+	if (trace_event_dyn_busy(&event->call))
+		return -EBUSY;
+
 	ret = unregister_synth_event(event);
 	if (ret)
 		return ret;
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index cf84d0f6583a..6b11e335a62e 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1334,7 +1334,7 @@ void event_enable_trigger_free(struct event_trigger_ops *ops,
 	if (!data->ref) {
 		/* Remove the SOFT_MODE flag */
 		trace_event_enable_disable(enable_data->file, 0, 1);
-		module_put(enable_data->file->event_call->mod);
+		trace_event_put_ref(enable_data->file->event_call);
 		trigger_data_free(data);
 		kfree(enable_data);
 	}
@@ -1481,7 +1481,7 @@ int event_enable_trigger_func(struct event_command *cmd_ops,
 
  out_reg:
 	/* Don't let event modules unload while probe registered */
-	ret = try_module_get(event_enable_file->event_call->mod);
+	ret = trace_event_try_get_ref(event_enable_file->event_call);
 	if (!ret) {
 		ret = -EBUSY;
 		goto out_free;
@@ -1510,7 +1510,7 @@ int event_enable_trigger_func(struct event_command *cmd_ops,
  out_disable:
 	trace_event_enable_disable(event_enable_file, 0, 1);
  out_put:
-	module_put(event_enable_file->event_call->mod);
+	trace_event_put_ref(event_enable_file->event_call);
  out_free:
 	if (cmd_ops->set_filter)
 		cmd_ops->set_filter(NULL, trigger_data, NULL);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index bfef43bfce37..82c3b86013b2 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -543,6 +543,10 @@ static int unregister_trace_kprobe(struct trace_kprobe *tk)
 	if (trace_probe_is_enabled(&tk->tp))
 		return -EBUSY;
 
+	/* If there's a reference to the dynamic event */
+	if (trace_event_dyn_busy(trace_probe_event_call(&tk->tp)))
+		return -EBUSY;
+
 	/* Will fail if probe is being used by ftrace or perf */
 	if (unregister_kprobe_event(tk))
 		return -EBUSY;
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 50eca53b8d22..1e2a92e7607d 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -393,6 +393,10 @@ static int unregister_trace_uprobe(struct trace_uprobe *tu)
 	if (trace_probe_has_sibling(&tu->tp))
 		goto unreg;
 
+	/* If there's a reference to the dynamic event */
+	if (trace_event_dyn_busy(trace_probe_event_call(&tu->tp)))
+		return -EBUSY;
+
 	ret = unregister_uprobe_event(tu);
 	if (ret)
 		return ret;
-- 
2.30.2
