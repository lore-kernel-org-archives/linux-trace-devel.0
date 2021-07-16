Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D510C636CA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Jul 2021 03:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDFDB611AB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Jul 2021 03:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhGPDeq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Jul 2021 23:34:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233669AbhGPDep (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Jul 2021 23:34:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 305E0613E8;
        Fri, 16 Jul 2021 03:31:51 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1m4EZq-000vEN-6W; Thu, 15 Jul 2021 23:31:50 -0400
Message-ID: <20210716033150.039236101@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 15 Jul 2021 23:26:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>
Subject: [PATCH 2/2] tracing: Update to the event probes
References: <20210716032632.272262604@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/linux/kprobes.h      |   5 +-
 include/linux/trace_events.h |   3 +
 kernel/trace/trace.h         |   5 +
 kernel/trace/trace_kprobe.c  | 248 ++++++++++++++++++++++++++++-------
 kernel/trace/trace_probe.c   |   4 +-
 5 files changed, 218 insertions(+), 47 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 687552b811fd..9dd38ca7ebb3 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -162,6 +162,8 @@ struct kretprobe {
 	struct kretprobe_holder *rph;
 };
 
+struct trace_kprobe;
+
 struct keventprobe {
 	/* tracepoint system */
 	const char *event_system;
@@ -169,7 +171,8 @@ struct keventprobe {
 	/* tracepoint event */
 	const char *event_name;
 
-	struct trace_event_call *tp;
+	struct trace_event_call *event;
+	struct trace_kprobe *tk;
 };
 
 struct kretprobe_instance {
diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 95195515147f..1302b81c9879 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -312,6 +312,7 @@ enum {
 	TRACE_EVENT_FL_TRACEPOINT_BIT,
 	TRACE_EVENT_FL_KPROBE_BIT,
 	TRACE_EVENT_FL_UPROBE_BIT,
+	TRACE_EVENT_FL_EPROBE_BIT,
 };
 
 /*
@@ -323,6 +324,7 @@ enum {
  *  TRACEPOINT    - Event is a tracepoint
  *  KPROBE        - Event is a kprobe
  *  UPROBE        - Event is a uprobe
+ *  EPROBE        - Event is an event probe
  */
 enum {
 	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
@@ -332,6 +334,7 @@ enum {
 	TRACE_EVENT_FL_TRACEPOINT	= (1 << TRACE_EVENT_FL_TRACEPOINT_BIT),
 	TRACE_EVENT_FL_KPROBE		= (1 << TRACE_EVENT_FL_KPROBE_BIT),
 	TRACE_EVENT_FL_UPROBE		= (1 << TRACE_EVENT_FL_UPROBE_BIT),
+	TRACE_EVENT_FL_EPROBE		= (1 << TRACE_EVENT_FL_EPROBE_BIT),
 };
 
 #define TRACE_EVENT_FL_UKPROBE (TRACE_EVENT_FL_KPROBE | TRACE_EVENT_FL_UPROBE)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d83bbb6859b4..e3ae52b7a1da 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1547,9 +1547,14 @@ static inline int register_trigger_hist_enable_disable_cmds(void) { return 0; }
 extern int register_trigger_cmds(void);
 extern void clear_event_triggers(struct trace_array *tr);
 
+enum {
+	EVENT_TRIGGER_FL_PROBE		= BIT(0),
+};
+
 struct event_trigger_data {
 	unsigned long			count;
 	int				ref;
+	int				flags;
 	struct event_trigger_ops	*ops;
 	struct event_command		*cmd_ops;
 	struct event_filter __rcu	*filter;
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index f14c8f233142..45500ce7dedd 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -339,6 +339,7 @@ static struct trace_kprobe *alloc_event_kprobe(const char *group,
 	tk->ep->event_system = kstrdup(sys_name, GFP_KERNEL);
 	if (!tk->ep->event_system)
 		goto error;
+	tk->ep->tk = tk;
 
 	tk->rp.maxactive = maxactive;
 	ret = trace_probe_init(&tk->tp, event, group, false);
@@ -365,6 +366,11 @@ static struct trace_kprobe *find_trace_kprobe(const char *event,
 	return NULL;
 }
 
+struct eprobe_data {
+	struct keventprobe		*ep;
+	struct trace_event_file		*file;
+};
+
 static int eprobe_trigger_init(struct event_trigger_ops *ops,
 			       struct event_trigger_data *data)
 {
@@ -384,11 +390,126 @@ static int eprobe_trigger_print(struct seq_file *m,
 	return 0;
 }
 
+static unsigned long get_event_field(struct fetch_insn *code, void *rec)
+{
+	struct ftrace_event_field *field = code->data;
+	unsigned long val;
+	void *addr;
+
+	addr = rec + field->offset;
+
+	switch (field->size) {
+	case 1:
+		if (field->is_signed)
+			val = *(char*)addr;
+		else
+			val = *(unsigned char*)addr;
+		break;
+	case 2:
+		if (field->is_signed)
+			val = *(short*)addr;
+		else
+			val = *(unsigned short*)addr;
+		break;
+	case 4:
+		if (field->is_signed)
+			val = *(int*)addr;
+		else
+			val = *(unsigned int*)addr;
+		break;
+	default:
+		if (field->is_signed)
+			val = *(long*)addr;
+		else
+			val = *(unsigned long*)addr;
+		break;
+	}
+	return val;
+}
+
+static int get_eprobe_size(struct trace_probe *tp, void *rec)
+{
+	struct probe_arg *arg;
+	int i, len, ret = 0;
+
+	for (i = 0; i < tp->nr_args; i++) {
+		arg = tp->args + i;
+		if (unlikely(arg->dynamic)) {
+			unsigned long val;
+
+			val = get_event_field(arg->code, rec);
+			len = process_fetch_insn_bottom(arg->code + 1, val, NULL, NULL);
+			if (len > 0)
+				ret += len;
+		}
+	}
+
+	return ret;
+}
+
+static inline void
+store_event_args(void *data, struct trace_probe *tp, void *rec,
+		 int header_size, int maxlen)
+{
+	struct probe_arg *arg;
+	unsigned long val;
+	void *base = data - header_size;
+	void *dyndata = data + tp->size;
+	u32 *dl;	/* Data location */
+	int ret, i;
+
+	for (i = 0; i < tp->nr_args; i++) {
+		arg = tp->args + i;
+		dl = data + arg->offset;
+		/* Point the dynamic data area if needed */
+		if (unlikely(arg->dynamic))
+			*dl = make_data_loc(maxlen, dyndata - base);
+		val = get_event_field(arg->code, rec);
+		ret = process_fetch_insn_bottom(arg->code + 1, val, dl, base);
+		if (unlikely(ret < 0 && arg->dynamic)) {
+			*dl = make_data_loc(0, dyndata - base);
+		} else {
+			dyndata += ret;
+			maxlen -= ret;
+		}
+	}
+}
+
 static void eprobe_trigger_func(struct event_trigger_data *data,
 				struct trace_buffer *buffer, void *rec,
 				struct ring_buffer_event *rbe)
 {
- /* ToDo */
+	struct kprobe_trace_entry_head *entry;
+	struct eprobe_data *edata = data->private_data;
+	struct keventprobe *ep = edata->ep;
+	struct trace_event_file *trace_file = edata->file;
+	struct trace_kprobe *tk = ep->tk;
+	struct trace_event_call *call = trace_probe_event_call(&tk->tp);
+	struct trace_event_buffer fbuffer;
+	int dsize;
+
+	if (trace_trigger_soft_disabled(edata->file))
+		return;
+
+	fbuffer.trace_ctx = tracing_gen_ctx();
+	fbuffer.trace_file = trace_file;
+
+	dsize = get_eprobe_size(&tk->tp, rec);
+
+	fbuffer.event =
+		trace_event_buffer_lock_reserve(&fbuffer.buffer, trace_file,
+					call->event.type,
+					sizeof(*entry) + tk->tp.size + dsize,
+					fbuffer.trace_ctx);
+	if (!fbuffer.event)
+		return;
+
+	fbuffer.regs = 0;
+	entry = fbuffer.entry = ring_buffer_event_data(fbuffer.event);
+	entry->ip = (unsigned long)tk->rp.kp.addr;
+	store_event_args(&entry[1], &tk->tp, rec, sizeof(*entry), dsize);
+
+	trace_event_buffer_commit(&fbuffer);
 }
 
 static struct event_trigger_ops eprobe_trigger_ops = {
@@ -426,9 +547,9 @@ static struct event_trigger_ops *eprobe_trigger_get_ops(char *cmd,
 }
 
 static struct event_command event_trigger_cmd = {
-	.name			= "kprobe",
+	.name			= "eprobe",
 	.trigger_type		= ETT_EVENT_KPROBE,
-	.flags			= EVENT_CMD_FL_POST_TRIGGER | EVENT_CMD_FL_NEEDS_REC,
+	.flags			= EVENT_CMD_FL_NEEDS_REC,
 	.func			= eprobe_trigger_cmd_func,
 	.reg			= eprobe_trigger_reg_func,
 	.unreg			= eprobe_trigger_unreg_func,
@@ -437,56 +558,87 @@ static struct event_command event_trigger_cmd = {
 	.set_filter		= NULL,
 };
 
-static int new_eprobe_trigger(struct event_trigger_data **trigger)
+static struct event_trigger_data *
+new_eprobe_trigger(struct keventprobe *ep, struct trace_event_file *file)
 {
-	int ret = 0;
-
-	*trigger = kzalloc(sizeof(struct event_trigger_data), GFP_KERNEL);
-	if (!(*trigger)) {
-		ret = -ENOMEM;
-		goto error;
+	struct event_trigger_data *trigger;
+	struct eprobe_data *edata;
+
+	edata = kzalloc(sizeof(*edata), GFP_KERNEL);
+	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
+	if (!trigger || !edata) {
+		kfree(edata);
+		kfree(trigger);
+		return ERR_PTR(-ENOMEM);
 	}
 
-	(*trigger)->count = -1;
-	(*trigger)->ops = &eprobe_trigger_ops;
-	(*trigger)->cmd_ops = &event_trigger_cmd;
+	trigger->flags = EVENT_TRIGGER_FL_PROBE;
+	trigger->count = -1;
+	trigger->ops = &eprobe_trigger_ops;
+	trigger->cmd_ops = &event_trigger_cmd;
 
-	INIT_LIST_HEAD(&(*trigger)->list);
-	RCU_INIT_POINTER((*trigger)->filter, NULL);
+	INIT_LIST_HEAD(&trigger->list);
+	RCU_INIT_POINTER(trigger->filter, NULL);
 
-	return ret;
+	edata->ep = ep;
+	edata->file = file;
+	trigger->private_data = edata;
 
-error:
-	return ret;
+	return trigger;
 }
 
-static int enable_eprobe(struct keventprobe *ep, struct trace_array *tr)
+static int enable_eprobe(struct keventprobe *ep,
+			 struct trace_event_file *eprobe_file)
 {
-	struct trace_event_file *target_event;
 	struct event_trigger_data *trigger;
-	int ret;
+	struct trace_event_file *file;
+	struct trace_array *tr = eprobe_file->tr;
 
-	target_event = find_event_file(tr, ep->event_system, ep->event_name);
-	if (!target_event)
+	file = find_event_file(tr, ep->event_system, ep->event_name);
+	if (!file)
 		return -ENOENT;
-	ret = new_eprobe_trigger(&trigger);
-	if (!ret)
-		return ret;
+	trigger = new_eprobe_trigger(ep, eprobe_file);
+	if (IS_ERR(trigger))
+		return PTR_ERR(trigger);
 
-	list_add_tail_rcu(&trigger->list, &target_event->triggers);
+	list_add_tail_rcu(&trigger->list, &file->triggers);
 
-	trace_event_trigger_enable_disable(target_event, 1);
+	trace_event_trigger_enable_disable(file, 1);
+	update_cond_flag(file);
 
 	return 0;
 }
 
-static int disable_eprobe(struct keventprobe *ep)
+static int disable_eprobe(struct keventprobe *ep,
+			  struct trace_array *tr)
 {
+	struct event_trigger_data *trigger;
+	struct trace_event_file *file;
+	struct eprobe_data *edata;
+
+	file = find_event_file(tr, ep->event_system, ep->event_name);
+	if (!file)
+		return -ENOENT;
+
+	list_for_each_entry(trigger, &file->triggers, list) {
+		if (!(trigger->flags & EVENT_TRIGGER_FL_PROBE))
+			continue;
+		edata = trigger->private_data;
+		if (edata->ep == ep)
+			break;
+	}
+	if (list_entry_is_head(trigger, &file->triggers, list))
+		return -ENODEV;
+
+	list_del_rcu(&trigger->list);
+
+	trace_event_trigger_enable_disable(file, 0);
+	update_cond_flag(file);
 	return 0;
 }
 
 static inline int __enable_trace_kprobe(struct trace_kprobe *tk,
-					struct trace_array *tr)
+					struct trace_event_file *file)
 {
 	int ret = 0;
 
@@ -494,7 +646,7 @@ static inline int __enable_trace_kprobe(struct trace_kprobe *tk,
 		if (trace_kprobe_is_return(tk))
 			ret = enable_kretprobe(&tk->rp);
 		else if (trace_kprobe_is_event(tk))
-			ret = enable_eprobe(tk->ep, tr);
+			ret = enable_eprobe(tk->ep, file);
 		else
 			ret = enable_kprobe(&tk->rp.kp);
 	}
@@ -502,7 +654,8 @@ static inline int __enable_trace_kprobe(struct trace_kprobe *tk,
 	return ret;
 }
 
-static void __disable_trace_kprobe(struct trace_probe *tp)
+static void __disable_trace_kprobe(struct trace_probe *tp,
+				   struct trace_event_file *file)
 {
 	struct trace_probe *pos;
 	struct trace_kprobe *tk;
@@ -514,7 +667,7 @@ static void __disable_trace_kprobe(struct trace_probe *tp)
 		if (trace_kprobe_is_return(tk))
 			disable_kretprobe(&tk->rp);
 		else  if (trace_kprobe_is_event(tk))
-			disable_eprobe(tk->ep);
+			disable_eprobe(tk->ep, file->tr);
 		else
 			disable_kprobe(&tk->rp.kp);
 	}
@@ -552,7 +705,7 @@ static int enable_trace_kprobe(struct trace_event_call *call,
 		tk = container_of(pos, struct trace_kprobe, tp);
 		if (trace_kprobe_has_gone(tk))
 			continue;
-		ret = __enable_trace_kprobe(tk, file->tr);
+		ret = __enable_trace_kprobe(tk, file);
 		if (ret)
 			break;
 		enabled = true;
@@ -561,7 +714,7 @@ static int enable_trace_kprobe(struct trace_event_call *call,
 	if (ret) {
 		/* Failed to enable one of them. Roll back all */
 		if (enabled)
-			__disable_trace_kprobe(tp);
+			__disable_trace_kprobe(tp, file);
 		if (file)
 			trace_probe_remove_file(tp, file);
 		else
@@ -594,7 +747,7 @@ static int disable_trace_kprobe(struct trace_event_call *call,
 		trace_probe_clear_flag(tp, TP_FLAG_PROFILE);
 
 	if (!trace_probe_is_enabled(tp))
-		__disable_trace_kprobe(tp);
+		__disable_trace_kprobe(tp, file);
 
  out:
 	if (file)
@@ -894,7 +1047,7 @@ static int trace_eprobe_tp_find(struct trace_kprobe *tk)
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(tp_event, &ftrace_events, list) {
-		if (!(tp_event->flags & TRACE_EVENT_FL_TRACEPOINT))
+		if (tp_event->flags & TRACE_EVENT_FL_IGNORE_ENABLE)
 			continue;
 		if (!tp_event->class->system ||
 		    strcmp(tk->ep->event_system, tp_event->class->system))
@@ -907,7 +1060,7 @@ static int trace_eprobe_tp_find(struct trace_kprobe *tk)
 			ret = -ENODEV;
 			break;
 		}
-		tk->ep->tp = tp_event;
+		tk->ep->event = tp_event;
 		ret = 0;
 		break;
 	}
@@ -922,7 +1075,7 @@ static int trace_eprobe_tp_arg_find(struct trace_kprobe *tk, int i)
 	struct ftrace_event_field *field;
 	struct list_head *head;
 
-	head = trace_get_fields(tk->ep->tp);
+	head = trace_get_fields(tk->ep->event);
 	list_for_each_entry(field, head, link) {
 		if (!strcmp(parg->code->data, field->name)) {
 			kfree(parg->code->data);
@@ -941,6 +1094,7 @@ static int __trace_eprobe_create(int argc, const char *argv[])
 	unsigned int flags = TPARG_FL_KERNEL | TPARG_FL_TPOINT;
 	const char *sys_event = NULL, *sys_name = NULL;
 	struct trace_kprobe *tk = NULL;
+	struct trace_event_call *call;
 	char buf1[MAX_EVENT_NAME_LEN];
 	char buf2[MAX_EVENT_NAME_LEN];
 	char *tmp = NULL;
@@ -950,7 +1104,7 @@ static int __trace_eprobe_create(int argc, const char *argv[])
 	if (argc < 2)
 		return -ECANCELED;
 
-	trace_probe_log_init("trace_kprobe", argc, argv);
+	trace_probe_log_init("event_probe", argc, argv);
 
 	event = strchr(&argv[0][1], ':');
 	if (event) {
@@ -1007,19 +1161,25 @@ static int __trace_eprobe_create(int argc, const char *argv[])
 	ret = traceprobe_set_print_fmt(&tk->tp, false);
 	if (ret < 0)
 		goto error;
+
+	mutex_lock(&event_mutex);
 	ret = register_kprobe_event(tk);
 	if (ret)
-		goto error;
+		goto out_unlock;
 
-	ret = dyn_event_add(&tk->devent);
-	if (ret)
-		goto error;
+	/* Reassign to a EPROBE */
+	call = trace_probe_event_call(&tk->tp);
+	call->flags = TRACE_EVENT_FL_EPROBE;
 
+	ret = dyn_event_add(&tk->devent);
+out_unlock:
+	mutex_unlock(&event_mutex);
 	return ret;
 
 parse_error:
 	ret = -EINVAL;
 error:
+	free_trace_kprobe(tk);
 	return ret;
 }
 
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 535e1f20519b..2c7988d5698f 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -997,8 +997,8 @@ void trace_event_probe_cleanup(struct keventprobe *ep)
 {
 	kfree(ep->event_name);
 	kfree(ep->event_system);
-	if (ep->tp)
-		module_put(ep->tp->mod);
+	if (ep->event)
+		module_put(ep->event->mod);
 	kfree(ep);
 }
 
-- 
2.30.2
