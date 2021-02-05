Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA96C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Feb 2021 19:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEDB764E3F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Feb 2021 19:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbhBERnl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Feb 2021 12:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbhBEPzf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Feb 2021 10:55:35 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDB2C06174A
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Feb 2021 09:37:17 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id s11so9725713edd.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Feb 2021 09:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TlGO1zAu5hiPfSm43KQebeVWuuCXiLoKpwGmweMeYi4=;
        b=NHDtBLD9KKsxxAL26idrmwrgfyPQXUTc5UZh7cRWCwLciJtQ3FFGTFXEmkHlKQPKXJ
         0C7kvxdFdMQtA7b8eVhVZsK8QidV/jN5pmPLap0chZ9Nx+2bytUPDoUEAO5d/iSFdcnv
         QTlO4oKheD085yVTiZzbgPnkXJUrUfNMKxDEhSIVDCBRR+6asVMZHgWM91eTR6VCb5Rn
         pk2S7rvLBkxJuvtqsudCr/sCLPRbvlpWD5RNzERZkliZY6381f9cMSZNvkc9B+UMQfEE
         nQhcr3VO4rtsQPjX8dxSiHOXw97nbLNApuuF+8ImsEghQ7PhuTP4ysThPgK1R969Mo1R
         Jjow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TlGO1zAu5hiPfSm43KQebeVWuuCXiLoKpwGmweMeYi4=;
        b=Fmi22cSzrRQ5bv6FHKe/GzW5U1s0AteyIVg2Bzr9oHcLASvPUpJ48fcD/fS9V/vSyC
         Bzcrk1Awg36mREBk3jlIB+ZJFRbJszilWnRMV6sKY147Mot5LgqIrIVxqgVuIfL3Lade
         jCPyttxcEPg8UWAPtSf/y04AyNE03ana74+vd3nKyBS2eC2t8gPY++IVOV1jmUSF7xIf
         9APjLlWo5JrKFlmRB18czRJUxav8nYpL88kJdvUu3sNYo3lzS0wwseZ2+M3Ezl6UQdGb
         ychZSajkqTJKqoH1aJWOZpfg1trGo5523uLVWZtqlwwYmWQxALh/yBuqfSjhW1vPyB/W
         LxXw==
X-Gm-Message-State: AOAM533V3B8TbQVTS+m2Vyz/Lgh2Bb8aeWnl5yy8xjDiDD0ld/HQae/6
        CDvVGGHjx4CJnNqkapy1CxHYegkdHOWC/A==
X-Google-Smtp-Source: ABdhPJx52ZNzfVojU14/H44neFPSE847kcQ/w7mRtmgrJfviVVO8YtAV15eipTZEjLMVQcKRX4AYUA==
X-Received: by 2002:a50:ef0f:: with SMTP id m15mr4810248eds.175.1612546636448;
        Fri, 05 Feb 2021 09:37:16 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b6sm747412edy.31.2021.02.05.09.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 09:37:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] [WIP] Add new kprobe on tracepoint
Date:   Fri,  5 Feb 2021 19:37:13 +0200
Message-Id: <20210205173713.132051-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir (VMware)  Stoyanov" <tz.stoyanov@gmail.com>

Hi Steven,

That is my progress so far on kprobe tracepoint implementation, it is still
far from a working prototype. Looks like I have to add a new trigger type, as
existing ones cannot be used. Triggers are designed to be configured from the
user and that's why there is a lot of logic for that - the cmd_ops field in
struct event_trigger_data. There are a lot of mandatory callbacks, that should
be dummy functions in the new trigger type, as it will not be set through tracefs.
I could implement these as dummy callbacks, or the logic could be changed so
these callbacks can be optional. Which is the right approach?

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 include/linux/kprobes.h      |  10 +
 include/linux/trace_events.h |   1 +
 kernel/trace/trace_kprobe.c  | 349 +++++++++++++++++++++++++++++++++--
 kernel/trace/trace_probe.c   |  25 ++-
 kernel/trace/trace_probe.h   |   7 +-
 kernel/trace/trace_uprobe.c  |   2 +-
 6 files changed, 373 insertions(+), 21 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 1883a4a9f16a..687552b811fd 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -162,6 +162,16 @@ struct kretprobe {
 	struct kretprobe_holder *rph;
 };
 
+struct keventprobe {
+	/* tracepoint system */
+	const char *event_system;
+
+	/* tracepoint event */
+	const char *event_name;
+
+	struct trace_event_call *tp;
+};
+
 struct kretprobe_instance {
 	union {
 		struct freelist_node freelist;
diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index d321fe5ad1a1..a49029a8511d 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -581,6 +581,7 @@ enum event_trigger_type {
 	ETT_EVENT_ENABLE	= (1 << 3),
 	ETT_EVENT_HIST		= (1 << 4),
 	ETT_HIST_ENABLE		= (1 << 5),
+	ETT_EVENT_KPROBE	= (1 << 6),
 };
 
 extern int filter_match_preds(struct event_filter *filter, void *rec);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 56c7fbff7bd7..31bb4fcac137 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -56,6 +56,7 @@ static struct dyn_event_operations trace_kprobe_ops = {
 struct trace_kprobe {
 	struct dyn_event	devent;
 	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
+	struct keventprobe	*ep;	/* kprobe on tracepoint event */
 	unsigned long __percpu *nhit;
 	const char		*symbol;	/* symbol name */
 	struct trace_probe	tp;
@@ -84,6 +85,11 @@ static struct trace_kprobe *to_trace_kprobe(struct dyn_event *ev)
 	(offsetof(struct trace_kprobe, tp.args) +	\
 	(sizeof(struct probe_arg) * (n)))
 
+static nokprobe_inline bool trace_kprobe_is_event(struct trace_kprobe *tk)
+{
+	return tk->ep != NULL;
+}
+
 static nokprobe_inline bool trace_kprobe_is_return(struct trace_kprobe *tk)
 {
 	return tk->rp.handler != NULL;
@@ -247,6 +253,8 @@ static void free_trace_kprobe(struct trace_kprobe *tk)
 		trace_probe_cleanup(&tk->tp);
 		kfree(tk->symbol);
 		free_percpu(tk->nhit);
+		if (tk->ep)
+			trace_event_probe_cleanup(tk->ep);
 		kfree(tk);
 	}
 }
@@ -302,6 +310,48 @@ static struct trace_kprobe *alloc_trace_kprobe(const char *group,
 	return ERR_PTR(ret);
 }
 
+/*
+ * Allocate new trace_probe and initialize it (including kprobes).
+ */
+static struct trace_kprobe *alloc_event_kprobe(const char *group,
+					     const char *event,
+					     const char *sys_name,
+					     const char *sys_event,
+					     int maxactive,
+					     int nargs)
+{
+	struct trace_kprobe *tk;
+	struct keventprobe *ep;
+	int ret = -ENOMEM;
+
+	tk = kzalloc(SIZEOF_TRACE_KPROBE(nargs), GFP_KERNEL);
+	if (!tk)
+		return ERR_PTR(ret);
+	tk->ep = kzalloc(sizeof(*ep), GFP_KERNEL);
+	if (!tk->ep)
+		goto error;
+	tk->nhit = alloc_percpu(unsigned long);
+	if (!tk->nhit)
+		goto error;
+	tk->ep->event_name = kstrdup(sys_event, GFP_KERNEL);
+	if (!tk->ep->event_name)
+		goto error;
+	tk->ep->event_system = kstrdup(sys_name, GFP_KERNEL);
+	if (!tk->ep->event_system)
+		goto error;
+
+	tk->rp.maxactive = maxactive;
+	ret = trace_probe_init(&tk->tp, event, group, false);
+	if (ret < 0)
+		goto error;
+
+	dyn_event_init(&tk->devent, &trace_kprobe_ops);
+	return tk;
+error:
+	free_trace_kprobe(tk);
+	return ERR_PTR(ret);
+}
+
 static struct trace_kprobe *find_trace_kprobe(const char *event,
 					      const char *group)
 {
@@ -315,13 +365,135 @@ static struct trace_kprobe *find_trace_kprobe(const char *event,
 	return NULL;
 }
 
-static inline int __enable_trace_kprobe(struct trace_kprobe *tk)
+static int eprobe_trigger_init(struct event_trigger_ops *ops,
+			       struct event_trigger_data *data)
+{
+	return 0;
+}
+
+static void eprobe_trigger_free(struct event_trigger_ops *ops,
+				struct event_trigger_data *data)
+{
+
+}
+
+static int eprobe_trigger_print(struct seq_file *m,
+				struct event_trigger_ops *ops,
+				struct event_trigger_data *data)
+{
+	return 0;
+}
+
+static void eprobe_trigger_func(struct event_trigger_data *data, void *rec,
+				struct ring_buffer_event *rbe)
+{
+ /* ToDo */
+}
+
+static struct event_trigger_ops eprobe_trigger_ops = {
+	.func			= eprobe_trigger_func,
+	.print			= eprobe_trigger_print,
+	.init			= eprobe_trigger_init,
+	.free			= eprobe_trigger_free,
+};
+
+static int eprobe_trigger_cmd_func(struct event_command *cmd_ops,
+				   struct trace_event_file *file,
+				   char *glob, char *cmd, char *param)
+{
+	return -1;
+}
+
+static int eprobe_trigger_reg_func(char *glob, struct event_trigger_ops *ops,
+				 struct event_trigger_data *data,
+				 struct trace_event_file *file)
+{
+	return -1;
+}
+
+static void eprobe_trigger_unreg_func(char *glob, struct event_trigger_ops *ops,
+				    struct event_trigger_data *data,
+				    struct trace_event_file *file)
+{
+
+}
+
+static struct event_trigger_ops *eprobe_trigger_get_ops(char *cmd,
+							char *param)
+{
+	return &eprobe_trigger_ops;
+}
+
+static struct event_command event_trigger_cmd = {
+	.name			= "kprobe",
+	.trigger_type		= ETT_EVENT_KPROBE,
+	.flags			= EVENT_CMD_FL_POST_TRIGGER | EVENT_CMD_FL_NEEDS_REC,
+	.func			= eprobe_trigger_cmd_func,
+	.reg			= eprobe_trigger_reg_func,
+	.unreg			= eprobe_trigger_unreg_func,
+	.unreg_all		= NULL,
+	.get_trigger_ops	= eprobe_trigger_get_ops,
+	.set_filter		= NULL,
+};
+
+static int new_eprobe_trigger(struct event_trigger_data **trigger)
+{
+	int ret = 0;
+
+	*trigger = kzalloc(sizeof(struct event_trigger_data), GFP_KERNEL);
+	if (!(*trigger)) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	(*trigger)->count = -1;
+	(*trigger)->ops = &eprobe_trigger_ops;
+	(*trigger)->cmd_ops = &event_trigger_cmd;
+
+	INIT_LIST_HEAD(&(*trigger)->list);
+	RCU_INIT_POINTER((*trigger)->filter, NULL);
+
+	return ret;
+
+error:
+	return ret;
+}
+
+static int enable_eprobe(struct keventprobe *ep, struct trace_array *tr)
+{
+	struct trace_event_file *target_event;
+	struct event_trigger_data *trigger;
+	int ret;
+
+	target_event = find_event_file(tr, ep->event_system, ep->event_name);
+	if (!target_event)
+		return -ENOENT;
+	ret = new_eprobe_trigger(&trigger);
+	if (!ret)
+		return ret;
+
+	list_add_tail_rcu(&trigger->list, &target_event->triggers);
+
+	trace_event_trigger_enable_disable(target_event, 1);
+
+	return 0;
+}
+
+static int disable_eprobe(struct keventprobe *ep)
+{
+	return 0;
+}
+
+static inline int __enable_trace_kprobe(struct trace_kprobe *tk,
+					struct trace_array *tr)
 {
 	int ret = 0;
 
 	if (trace_kprobe_is_registered(tk) && !trace_kprobe_has_gone(tk)) {
 		if (trace_kprobe_is_return(tk))
 			ret = enable_kretprobe(&tk->rp);
+		else if (trace_kprobe_is_event(tk))
+			ret = enable_eprobe(tk->ep, tr);
 		else
 			ret = enable_kprobe(&tk->rp.kp);
 	}
@@ -340,6 +512,8 @@ static void __disable_trace_kprobe(struct trace_probe *tp)
 			continue;
 		if (trace_kprobe_is_return(tk))
 			disable_kretprobe(&tk->rp);
+		else  if (trace_kprobe_is_event(tk))
+			disable_eprobe(tk->ep);
 		else
 			disable_kprobe(&tk->rp.kp);
 	}
@@ -377,7 +551,7 @@ static int enable_trace_kprobe(struct trace_event_call *call,
 		tk = container_of(pos, struct trace_kprobe, tp);
 		if (trace_kprobe_has_gone(tk))
 			continue;
-		ret = __enable_trace_kprobe(tk);
+		ret = __enable_trace_kprobe(tk, file->tr);
 		if (ret)
 			break;
 		enabled = true;
@@ -711,6 +885,143 @@ static inline void sanitize_event_name(char *name)
 			*name = '_';
 }
 
+static int trace_eprobe_tp_find(struct trace_kprobe *tk)
+{
+	struct trace_event_call *tp_event;
+	int ret = -ENOENT;
+	const char *name;
+
+	mutex_lock(&event_mutex);
+	list_for_each_entry(tp_event, &ftrace_events, list) {
+		if (!(tp_event->flags & TRACE_EVENT_FL_TRACEPOINT))
+			continue;
+		if (!tp_event->class->system ||
+		    strcmp(tk->ep->event_system, tp_event->class->system))
+			continue;
+		name = trace_event_name(tp_event);
+		if (!name ||
+		    strcmp(tk->ep->event_name, name))
+			continue;
+		if (!try_module_get(tp_event->mod)) {
+			ret = -ENODEV;
+			break;
+		}
+		tk->ep->tp = tp_event;
+		ret = 0;
+		break;
+	}
+	mutex_unlock(&event_mutex);
+
+	return ret;
+}
+
+static int trace_eprobe_tp_arg_find(struct trace_kprobe *tk, int i)
+{
+	struct probe_arg *parg = &tk->tp.args[i];
+	struct ftrace_event_field *field;
+	struct list_head *head;
+
+	head = trace_get_fields(tk->ep->tp);
+	list_for_each_entry(field, head, link) {
+		if (!strcmp(parg->code->data, field->name)) {
+			kfree(parg->code->data);
+			parg->code->data = field;
+			return 0;
+		}
+	}
+	kfree(parg->code->data);
+	parg->code->data = NULL;
+	return -ENOENT;
+}
+
+static int trace_eprobe_create(int argc, const char *argv[])
+{
+	const char *event = NULL, *group = KPROBE_EVENT_SYSTEM;
+	unsigned int flags = TPARG_FL_KERNEL | TPARG_FL_TPOINT;
+	const char *sys_event = NULL, *sys_name = NULL;
+	struct trace_kprobe *tk = NULL;
+	char buf1[MAX_EVENT_NAME_LEN];
+	char buf2[MAX_EVENT_NAME_LEN];
+	char *tmp = NULL;
+	int ret = 0;
+	int i;
+
+	if (argc < 2)
+		return -ECANCELED;
+
+	trace_probe_log_init("trace_kprobe", argc, argv);
+
+	event = strchr(&argv[0][1], ':');
+	if (event) {
+		event++;
+		ret = traceprobe_parse_event_name(&event, &group, buf1,
+						  event - argv[0], '/');
+		if (ret)
+			goto parse_error;
+	} else {
+		strlcpy(buf1, argv[1], MAX_EVENT_NAME_LEN);
+		sanitize_event_name(buf1);
+		event = buf1;
+	}
+	if (!is_good_name(event) || !is_good_name(group))
+		goto parse_error;
+
+	sys_event = argv[1];
+	ret = traceprobe_parse_event_name(&sys_event, &sys_name, buf2,
+					  sys_event - argv[1], '.');
+	if (ret || !sys_name)
+		goto parse_error;
+	if (!is_good_name(sys_event) || !is_good_name(sys_name))
+		goto parse_error;
+	tk = alloc_event_kprobe(group, event, sys_name, sys_event, 0, argc - 2);
+	if (IS_ERR(tk)) {
+		ret = PTR_ERR(tk);
+		/* This must return -ENOMEM, else there is a bug */
+		WARN_ON_ONCE(ret != -ENOMEM);
+		goto error;	/* We know tk is not allocated */
+	}
+	ret = trace_eprobe_tp_find(tk);
+	if (ret)
+		goto error;
+
+	argc -= 2; argv += 2;
+	/* parse arguments */
+	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
+		tmp = kstrdup(argv[i], GFP_KERNEL);
+		if (!tmp) {
+			ret = -ENOMEM;
+			goto error;
+		}
+		ret = traceprobe_parse_probe_arg(&tk->tp, i, tmp, flags);
+		if (ret == -EINVAL)
+			kfree(tmp);
+		if (ret)
+			goto error;	/* This can be -ENOMEM */
+		if (tk->tp.args[i].code->op == FETCH_OP_TP_ARG) {
+			ret = trace_eprobe_tp_arg_find(tk, i);
+			if (ret)
+				goto error;
+		}
+	}
+	ret = traceprobe_set_print_fmt(&tk->tp, false);
+	if (ret < 0)
+		goto error;
+	ret = register_kprobe_event(tk);
+	if (ret)
+		goto error;
+
+	ret = dyn_event_add(&tk->devent);
+	if (ret)
+		goto error;
+
+	return ret;
+
+parse_error:
+	ret = -EINVAL;
+error:
+	return ret;
+}
+
 static int trace_kprobe_create(int argc, const char *argv[])
 {
 	/*
@@ -841,7 +1152,7 @@ static int trace_kprobe_create(int argc, const char *argv[])
 	trace_probe_log_set_index(0);
 	if (event) {
 		ret = traceprobe_parse_event_name(&event, &group, buf,
-						  event - argv[0]);
+						  event - argv[0], '/');
 		if (ret)
 			goto parse_error;
 	} else {
@@ -916,8 +1227,10 @@ static int create_or_delete_trace_kprobe(int argc, char **argv)
 
 	if (argv[0][0] == '-')
 		return dyn_event_release(argc, argv, &trace_kprobe_ops);
-
-	ret = trace_kprobe_create(argc, (const char **)argv);
+	if (argv[0][0] == 'e')
+		ret = trace_eprobe_create(argc, (const char **)argv);
+	else
+		ret = trace_kprobe_create(argc, (const char **)argv);
 	return ret == -ECANCELED ? -EINVAL : ret;
 }
 
@@ -1102,20 +1415,25 @@ static int trace_kprobe_show(struct seq_file *m, struct dyn_event *ev)
 {
 	struct trace_kprobe *tk = to_trace_kprobe(ev);
 	int i;
+	char c;
 
-	seq_putc(m, trace_kprobe_is_return(tk) ? 'r' : 'p');
+	c = trace_kprobe_is_event(tk) ? 'e' : trace_kprobe_is_return(tk) ? 'r' : 'p';
+	seq_putc(m, c);
 	if (trace_kprobe_is_return(tk) && tk->rp.maxactive)
 		seq_printf(m, "%d", tk->rp.maxactive);
 	seq_printf(m, ":%s/%s", trace_probe_group_name(&tk->tp),
 				trace_probe_name(&tk->tp));
-
-	if (!tk->symbol)
-		seq_printf(m, " 0x%p", tk->rp.kp.addr);
-	else if (tk->rp.kp.offset)
-		seq_printf(m, " %s+%u", trace_kprobe_symbol(tk),
-			   tk->rp.kp.offset);
-	else
-		seq_printf(m, " %s", trace_kprobe_symbol(tk));
+	if (trace_kprobe_is_event(tk)) {
+		seq_printf(m, " %s.%s", tk->ep->event_system, tk->ep->event_name);
+	} else {
+		if (!tk->symbol)
+			seq_printf(m, " 0x%p", tk->rp.kp.addr);
+		else if (tk->rp.kp.offset)
+			seq_printf(m, " %s+%u", trace_kprobe_symbol(tk),
+				   tk->rp.kp.offset);
+		else
+			seq_printf(m, " %s", trace_kprobe_symbol(tk));
+	}
 
 	for (i = 0; i < tk->tp.nr_args; i++)
 		seq_printf(m, " %s=%s", tk->tp.args[i].name, tk->tp.args[i].comm);
@@ -1776,6 +2094,9 @@ static inline void init_trace_event_call(struct trace_kprobe *tk)
 	if (trace_kprobe_is_return(tk)) {
 		call->event.funcs = &kretprobe_funcs;
 		call->class->fields_array = kretprobe_fields_array;
+	} else if (trace_kprobe_is_event(tk)) {
+		call->event.funcs = &kprobe_funcs;
+		call->class->fields_array = kprobe_fields_array;
 	} else {
 		call->event.funcs = &kprobe_funcs;
 		call->class->fields_array = kprobe_fields_array;
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index d2867ccc6aca..c660ca81d90f 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -227,12 +227,12 @@ int traceprobe_split_symbol_offset(char *symbol, long *offset)
 
 /* @buf must has MAX_EVENT_NAME_LEN size */
 int traceprobe_parse_event_name(const char **pevent, const char **pgroup,
-				char *buf, int offset)
+				char *buf, int offset, int delim)
 {
 	const char *slash, *event = *pevent;
 	int len;
 
-	slash = strchr(event, '/');
+	slash = strchr(event, delim);
 	if (slash) {
 		if (slash == event) {
 			trace_probe_log_err(offset, NO_GROUP_NAME);
@@ -316,6 +316,13 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 		code->op = FETCH_OP_ARG;
 		code->param = (unsigned int)param - 1;
 #endif
+	} else if (flags & TPARG_FL_TPOINT) {
+		if (code->data)
+			return -EFAULT;
+		code->data = kstrdup(arg, GFP_KERNEL);
+		if (!code->data)
+			return -ENOMEM;
+		code->op = FETCH_OP_TP_ARG;
 	} else
 		goto inval_var;
 
@@ -633,14 +640,15 @@ static int traceprobe_parse_probe_arg_body(char *arg, ssize_t *size,
 	    !strcmp(parg->type->name, "ustring")) {
 		if (code->op != FETCH_OP_DEREF && code->op != FETCH_OP_UDEREF &&
 		    code->op != FETCH_OP_IMM && code->op != FETCH_OP_COMM &&
-		    code->op != FETCH_OP_DATA) {
+		    code->op != FETCH_OP_DATA && code->op != FETCH_OP_TP_ARG) {
 			trace_probe_log_err(offset + (t ? (t - arg) : 0),
 					    BAD_STRING);
 			ret = -EINVAL;
 			goto fail;
 		}
 		if ((code->op == FETCH_OP_IMM || code->op == FETCH_OP_COMM ||
-		     code->op == FETCH_OP_DATA) || parg->count) {
+		     code->op == FETCH_OP_DATA) || code->op == FETCH_OP_TP_ARG ||
+		     parg->count) {
 			/*
 			 * IMM, DATA and COMM is pointing actual address, those
 			 * must be kept, and if parg->count != 0, this is an
@@ -985,6 +993,15 @@ void trace_probe_cleanup(struct trace_probe *tp)
 		trace_probe_unlink(tp);
 }
 
+void trace_event_probe_cleanup(struct keventprobe *ep)
+{
+	kfree(ep->event_name);
+	kfree(ep->event_system);
+	if (ep->tp)
+		module_put(ep->tp->mod);
+	kfree(ep);
+}
+
 int trace_probe_init(struct trace_probe *tp, const char *event,
 		     const char *group, bool alloc_filter)
 {
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 2f703a20c724..b6dc5b2c69d2 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -102,6 +102,7 @@ enum fetch_op {
 	FETCH_OP_MOD_BF,	/* Bitfield: .basesize, .lshift, .rshift */
 	// Stage 5 (loop) op
 	FETCH_OP_LP_ARRAY,	/* Array: .param = loop count */
+	FETCH_OP_TP_ARG,	/* Trace Point argument */
 	FETCH_OP_END,
 	FETCH_NOP_SYMBOL,	/* Unresolved Symbol holder */
 };
@@ -330,6 +331,7 @@ static inline bool trace_probe_has_single_file(struct trace_probe *tp)
 int trace_probe_init(struct trace_probe *tp, const char *event,
 		     const char *group, bool alloc_filter);
 void trace_probe_cleanup(struct trace_probe *tp);
+void trace_event_probe_cleanup(struct keventprobe *ep);
 int trace_probe_append(struct trace_probe *tp, struct trace_probe *to);
 void trace_probe_unlink(struct trace_probe *tp);
 int trace_probe_register_event_call(struct trace_probe *tp);
@@ -350,7 +352,8 @@ bool trace_probe_match_command_args(struct trace_probe *tp,
 #define TPARG_FL_RETURN BIT(0)
 #define TPARG_FL_KERNEL BIT(1)
 #define TPARG_FL_FENTRY BIT(2)
-#define TPARG_FL_MASK	GENMASK(2, 0)
+#define TPARG_FL_TPOINT BIT(3)
+#define TPARG_FL_MASK	GENMASK(3, 0)
 
 extern int traceprobe_parse_probe_arg(struct trace_probe *tp, int i,
 				char *arg, unsigned int flags);
@@ -360,7 +363,7 @@ extern void traceprobe_free_probe_arg(struct probe_arg *arg);
 
 extern int traceprobe_split_symbol_offset(char *symbol, long *offset);
 int traceprobe_parse_event_name(const char **pevent, const char **pgroup,
-				char *buf, int offset);
+				char *buf, int offset, int delim);
 
 extern int traceprobe_set_print_fmt(struct trace_probe *tp, bool is_return);
 
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 3cf7128e1ad3..05811feb83fe 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -641,7 +641,7 @@ static int trace_uprobe_create(int argc, const char **argv)
 	trace_probe_log_set_index(0);
 	if (event) {
 		ret = traceprobe_parse_event_name(&event, &group, buf,
-						  event - argv[0]);
+						  event - argv[0], '/');
 		if (ret)
 			goto fail_address_parse;
 	} else {
-- 
2.29.2

