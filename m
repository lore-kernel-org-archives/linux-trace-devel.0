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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C7C3C43216
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Aug 2021 17:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FC9B611BF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Aug 2021 17:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241963AbhHFRty (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Aug 2021 13:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241943AbhHFRtu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Aug 2021 13:49:50 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B663CC0613CF;
        Fri,  6 Aug 2021 10:49:32 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id k9so14143700edr.10;
        Fri, 06 Aug 2021 10:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Be/RJ/xZd5tCm4NBSjsu03bEEDBqIebt5rRrxVDmaQM=;
        b=F3sjaszR6OCvPMULUgdy1KbC7eakOryXafmXZCVyUQnXZDhegxy1CvVPIUlQIWW7dF
         JejJ53EhHr+bYCsNkGZZ/rCfhhOymT7ueKjxPFCacWhi/aq54J2NhkfOsMBjGrbj691Y
         YD/ZgFoJWjOzK5xzfzYfsBm/h+rFe0TjAp3c7FOfRMVy2D6l4D9u4LT7No1XMX9CIm/V
         GBd2lTs8XWdDPNKiUWE6ajcsIrhvDsCu3xbOnzs5eeGyQEqrkRRnPEfsJq3KPI25SPd5
         LMztCqjJfvgT7zxjVE//3F2GtykYoYsI4N92qUY3CeC5qgxB3k0Ozb48gTX95sJ7dxqf
         zS/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Be/RJ/xZd5tCm4NBSjsu03bEEDBqIebt5rRrxVDmaQM=;
        b=mnG8Vuek0HKAM4IBgV2EFJRTr1VzzvRWG6e/8rsAgXjaIGlxadIh2V0PDCOs9xWkR2
         Fk38rtIQhkAiH/LfC4ZuVUfQwUGI+P3uEGBvWzLH1fd4kFiFzo9/gG8cVETb3YdYrjJ4
         z39++rgpPwjVPcD0v6KDE9w8+VU4K1x+I3mgrwBS0+sL0og07W1Wp1XxWTZspC6+vR2e
         bagO/f34fKVbiJPhh+hpwOED1cdWXS5QN9CJuq+ksDd3xgTmi7Sy36rJ/FDKoFDFtbM7
         SfyKEH+8y3OEWIdx3RlrIHKRQJr+tdFp+Nlf6vj0a/LVuRId4t+U0TYGZOkXYcsKWwC2
         dU5g==
X-Gm-Message-State: AOAM533dnpQ4ge9eruvqrWRXYJVpj794yYy8ASa5S00ESh54Xc36QgGb
        +KMBh+OfL/UQp3peFa/6wZTa9orURkV3LA==
X-Google-Smtp-Source: ABdhPJwmaA2jJ+eRWRA9P4YcX048G53iaEWlEi0okCgD4dxxobptnzGOeOi5ouQcc+Rs5Cic4V+bMA==
X-Received: by 2002:a05:6402:50:: with SMTP id f16mr14606517edu.346.1628272171082;
        Fri, 06 Aug 2021 10:49:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w23sm4092516edx.34.2021.08.06.10.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 10:49:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, mhiramat@kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com
Subject: [RFC] [RFC] trace: Add kprobe on tracepoint
Date:   Fri,  6 Aug 2021 20:49:28 +0300
Message-Id: <20210806174928.847848-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

The /sys/kernel/debug/tracing/kprobe_events interface is extended with a
new type of user defined dynamic event, that is attached to an existing
tracepoint. The user can specify custom format string of the new event,
select what tracepoint arguments will be printed and how to print them.

The format is similar to the existing kprobe_events interface:
 e:GNAME/ENAME SYSTEM/EVENT [FETCHARGS]	- Set an event probe
 -e:GNAME/ENAME				- Delete an event probe

Where:
 GNAME	- Group name, mandatory
 ENAME	- Name of the new event in GNAME, mandatory
 SYSTEM	- Name of the system, where the tracepoint is defined, mandatory
 EVENT	- Name of the tracepoint event in SYSTEM, mandatory
 FETCHARGS - Arguments:
  <name>=$<field>[:TYPE] - Fetch given filed of the tracepoint and print it as
		    given TYPE with given name. Supported types are
                    (u8/u16/u32/u64/s8/s16/s32/s64), basic type
                    (x8/x16/x32/x64), hexadecimal types
		    "string", "ustring" and bitfield.

Example, attach event probe on openat system call and print name of the
file that will be opened:
 echo "e:esys/eopen syscalls.sys_enter_openat file=\$filename:string" >> kprobe_events
A new dynamic event is created in events/esys/eopen/ directory. It
can be deleted with:
 echo "-e:esys/eopen" >> kprobe_events

Filters, triggers and histograms can be attached to the new event, it can
be matched in synthetic events. There is one limitation - no synthetic
events can be attached to an event probe.

Co-authored-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/linux/kprobes.h             |  10 +
 include/linux/trace_events.h        |   4 +
 kernel/trace/trace.h                |   5 +
 kernel/trace/trace_events_hist.c    |  32 +-
 kernel/trace/trace_events_trigger.c |  14 +-
 kernel/trace/trace_kprobe.c         | 454 ++++++++++++++++++++++++++--
 kernel/trace/trace_probe.c          |  25 +-
 kernel/trace/trace_probe.h          |   7 +-
 kernel/trace/trace_probe_tmpl.h     |  56 +++-
 kernel/trace/trace_uprobe.c         |   2 +-
 10 files changed, 571 insertions(+), 38 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index e4f3bfe08757..9de9b1f2d27b 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -154,6 +154,16 @@ struct kretprobe {
 	struct kretprobe_holder *rph;
 };
 
+struct keventprobe {
+	/* tracepoint system */
+	const char *event_system;
+
+	/* tracepoint event */
+	const char *event_name;
+
+	struct trace_event_call *event;
+};
+
 struct kretprobe_instance {
 	union {
 		struct freelist_node freelist;
diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index ad413b382a3c..1302b81c9879 100644
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
@@ -634,6 +637,7 @@ enum event_trigger_type {
 	ETT_EVENT_ENABLE	= (1 << 3),
 	ETT_EVENT_HIST		= (1 << 4),
 	ETT_HIST_ENABLE		= (1 << 5),
+	ETT_EVENT_KPROBE	= (1 << 6),
 };
 
 extern int filter_match_preds(struct event_filter *filter, void *rec);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a180abf76d4e..dadd25b0e044 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1540,9 +1540,14 @@ static inline int register_trigger_hist_enable_disable_cmds(void) { return 0; }
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
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 949ef09dc537..a1759de35fda 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -66,7 +66,8 @@
 	C(EMPTY_SORT_FIELD,	"Empty sort field"),			\
 	C(TOO_MANY_SORT_FIELDS,	"Too many sort fields (Max = 2)"),	\
 	C(INVALID_SORT_FIELD,	"Sort field must be a key or a val"),	\
-	C(INVALID_STR_OPERAND,	"String type can not be an operand in expression"),
+	C(INVALID_STR_OPERAND,	"String type can not be an operand in expression"),  \
+	C(SYNTH_ON_EPROBE,	"Synthetic event on eprobe is not supported"),
 
 #undef C
 #define C(a, b)		HIST_ERR_##a
@@ -3165,9 +3166,20 @@ static int parse_action_params(struct trace_array *tr, char *params,
 	return ret;
 }
 
-static int action_parse(struct trace_array *tr, char *str, struct action_data *data,
+static inline bool check_match_on_eprobe(struct trace_array *tr, char *system, char *event)
+{
+	struct trace_event_file *efile;
+
+	efile = event_file(tr, system, event);
+	if (efile && (efile->event_call->flags & TRACE_EVENT_FL_EPROBE))
+		return true;
+	return false;
+}
+
+static int action_parse(struct hist_trigger_data *hist_data, char *str, struct action_data *data,
 			enum handler_id handler)
 {
+	struct trace_array *tr =  hist_data->event_file->tr;
 	char *action_name;
 	int ret = 0;
 
@@ -3235,6 +3247,12 @@ static int action_parse(struct trace_array *tr, char *str, struct action_data *d
 		data->action = ACTION_SNAPSHOT;
 	} else {
 		char *params = strsep(&str, ")");
+		if (check_match_on_eprobe(tr, hist_data->event_file->system->subsystem->name,
+					  trace_event_name(hist_data->event_file->event_call))) {
+			hist_err(tr, HIST_ERR_SYNTH_ON_EPROBE, 0);
+			ret = -EINVAL;
+			goto out;
+		}
 
 		if (str_has_prefix(action_name, "trace"))
 			data->use_trace_keyword = true;
@@ -3293,7 +3311,7 @@ static struct action_data *track_data_parse(struct hist_trigger_data *hist_data,
 		goto free;
 	}
 
-	ret = action_parse(hist_data->event_file->tr, str, data, handler);
+	ret = action_parse(hist_data, str, data, handler);
 	if (ret)
 		goto free;
  out:
@@ -3626,8 +3644,9 @@ static int onmatch_create(struct hist_trigger_data *hist_data,
 	return action_create(hist_data, data);
 }
 
-static struct action_data *onmatch_parse(struct trace_array *tr, char *str)
+static struct action_data *onmatch_parse(struct hist_trigger_data *hist_data, char *str)
 {
+	struct trace_array *tr = hist_data->event_file->tr;
 	char *match_event, *match_event_system;
 	struct action_data *data;
 	int ret = -EINVAL;
@@ -3665,7 +3684,7 @@ static struct action_data *onmatch_parse(struct trace_array *tr, char *str)
 		goto free;
 	}
 
-	ret = action_parse(tr, str, data, HANDLER_ONMATCH);
+	ret = action_parse(hist_data, str, data, HANDLER_ONMATCH);
 	if (ret)
 		goto free;
  out:
@@ -4120,7 +4139,6 @@ static void destroy_actions(struct hist_trigger_data *hist_data)
 
 static int parse_actions(struct hist_trigger_data *hist_data)
 {
-	struct trace_array *tr = hist_data->event_file->tr;
 	struct action_data *data;
 	unsigned int i;
 	int ret = 0;
@@ -4133,7 +4151,7 @@ static int parse_actions(struct hist_trigger_data *hist_data)
 		if ((len = str_has_prefix(str, "onmatch("))) {
 			char *action_str = str + len;
 
-			data = onmatch_parse(tr, action_str);
+			data = onmatch_parse(hist_data, action_str);
 			if (IS_ERR(data)) {
 				ret = PTR_ERR(data);
 				break;
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index cf84d0f6583a..f1390c2b8636 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -124,6 +124,18 @@ static void *trigger_next(struct seq_file *m, void *t, loff_t *pos)
 	return seq_list_next(t, &event_file->triggers, pos);
 }
 
+static bool check_user_trigger(struct trace_event_file *file)
+{
+	struct event_trigger_data *data;
+
+	list_for_each_entry_rcu(data, &file->triggers, list) {
+		if (data->flags & EVENT_TRIGGER_FL_PROBE)
+			continue;
+		return true;
+	}
+	return false;
+}
+
 static void *trigger_start(struct seq_file *m, loff_t *pos)
 {
 	struct trace_event_file *event_file;
@@ -134,7 +146,7 @@ static void *trigger_start(struct seq_file *m, loff_t *pos)
 	if (unlikely(!event_file))
 		return ERR_PTR(-ENODEV);
 
-	if (list_empty(&event_file->triggers))
+	if (list_empty(&event_file->triggers) || !check_user_trigger(event_file))
 		return *pos == 0 ? SHOW_AVAILABLE_TRIGGERS : NULL;
 
 	return seq_list_start(&event_file->triggers, *pos);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index ea6178cb5e33..07db5e2d4ba9 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -56,11 +56,16 @@ static struct dyn_event_operations trace_kprobe_ops = {
 struct trace_kprobe {
 	struct dyn_event	devent;
 	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
+	struct keventprobe	*ep;	/* kprobe on tracepoint event */
 	unsigned long __percpu *nhit;
 	const char		*symbol;	/* symbol name */
 	struct trace_probe	tp;
 };
 
+static nokprobe_inline void
+__kprobe_trace_func(struct trace_kprobe *tk, void *rec,
+		    struct trace_event_file *trace_file);
+
 static bool is_trace_kprobe(struct dyn_event *ev)
 {
 	return ev->ops == &trace_kprobe_ops;
@@ -84,6 +89,11 @@ static struct trace_kprobe *to_trace_kprobe(struct dyn_event *ev)
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
@@ -247,6 +257,8 @@ static void free_trace_kprobe(struct trace_kprobe *tk)
 		trace_probe_cleanup(&tk->tp);
 		kfree(tk->symbol);
 		free_percpu(tk->nhit);
+		if (tk->ep)
+			trace_event_probe_cleanup(tk->ep);
 		kfree(tk);
 	}
 }
@@ -302,6 +314,48 @@ static struct trace_kprobe *alloc_trace_kprobe(const char *group,
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
@@ -315,13 +369,202 @@ static struct trace_kprobe *find_trace_kprobe(const char *event,
 	return NULL;
 }
 
-static inline int __enable_trace_kprobe(struct trace_kprobe *tk)
+struct eprobe_data {
+	struct trace_event_file		*file;
+	struct trace_kprobe		*tk;
+};
+
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
+	/* Do not print kprobe event triggers */
+	return 0;
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
+static void eprobe_trigger_func(struct event_trigger_data *data,
+				struct trace_buffer *buffer, void *rec,
+				struct ring_buffer_event *rbe)
+{
+	struct eprobe_data *edata = data->private_data;
+
+	__kprobe_trace_func(edata->tk, rec, edata->file);
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
+	.name			= "eprobe",
+	.trigger_type		= ETT_EVENT_KPROBE,
+	.flags			= EVENT_CMD_FL_NEEDS_REC,
+	.func			= eprobe_trigger_cmd_func,
+	.reg			= eprobe_trigger_reg_func,
+	.unreg			= eprobe_trigger_unreg_func,
+	.unreg_all		= NULL,
+	.get_trigger_ops	= eprobe_trigger_get_ops,
+	.set_filter		= NULL,
+};
+
+static struct event_trigger_data *
+new_eprobe_trigger(struct trace_kprobe *tk, struct trace_event_file *file)
+{
+	struct event_trigger_data *trigger;
+	struct eprobe_data *edata;
+
+	edata = kzalloc(sizeof(*edata), GFP_KERNEL);
+	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
+	if (!trigger || !edata) {
+		kfree(edata);
+		kfree(trigger);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	trigger->flags = EVENT_TRIGGER_FL_PROBE;
+	trigger->count = -1;
+	trigger->ops = &eprobe_trigger_ops;
+
+	/*
+	 * EVENT KPROBE triggers are not registered as commands with
+	 * register_event_command(), as they are not controlled by the user
+	 * from the trigger file
+	 */
+	trigger->cmd_ops = &event_trigger_cmd;
+
+	INIT_LIST_HEAD(&trigger->list);
+	RCU_INIT_POINTER(trigger->filter, NULL);
+
+	edata->file = file;
+	edata->tk = tk;
+	trigger->private_data = edata;
+
+	return trigger;
+}
+
+static int enable_eprobe(struct trace_kprobe *tk,
+			 struct trace_event_file *eprobe_file)
+{
+	struct event_trigger_data *trigger;
+	struct trace_event_file *file;
+	struct trace_array *tr = eprobe_file->tr;
+	struct keventprobe *ep = tk->ep;
+
+	file = find_event_file(tr, ep->event_system, ep->event_name);
+	if (!file)
+		return -ENOENT;
+	trigger = new_eprobe_trigger(tk, eprobe_file);
+	if (IS_ERR(trigger))
+		return PTR_ERR(trigger);
+
+	list_add_tail_rcu(&trigger->list, &file->triggers);
+
+	trace_event_trigger_enable_disable(file, 1);
+	update_cond_flag(file);
+
+	return 0;
+}
+
+static int disable_eprobe(struct keventprobe *ep,
+			  struct trace_array *tr)
+{
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
+		if (edata->tk->ep == ep)
+			break;
+	}
+	if (list_entry_is_head(trigger, &file->triggers, list))
+		return -ENODEV;
+
+	list_del_rcu(&trigger->list);
+
+	trace_event_trigger_enable_disable(file, 0);
+	update_cond_flag(file);
+	return 0;
+}
+
+static inline int __enable_trace_kprobe(struct trace_kprobe *tk,
+					struct trace_event_file *file)
 {
 	int ret = 0;
 
 	if (trace_kprobe_is_registered(tk) && !trace_kprobe_has_gone(tk)) {
 		if (trace_kprobe_is_return(tk))
 			ret = enable_kretprobe(&tk->rp);
+		else if (trace_kprobe_is_event(tk))
+			ret = enable_eprobe(tk, file);
 		else
 			ret = enable_kprobe(&tk->rp.kp);
 	}
@@ -329,7 +572,8 @@ static inline int __enable_trace_kprobe(struct trace_kprobe *tk)
 	return ret;
 }
 
-static void __disable_trace_kprobe(struct trace_probe *tp)
+static void __disable_trace_kprobe(struct trace_probe *tp,
+				   struct trace_event_file *file)
 {
 	struct trace_probe *pos;
 	struct trace_kprobe *tk;
@@ -340,6 +584,8 @@ static void __disable_trace_kprobe(struct trace_probe *tp)
 			continue;
 		if (trace_kprobe_is_return(tk))
 			disable_kretprobe(&tk->rp);
+		else  if (trace_kprobe_is_event(tk))
+			disable_eprobe(tk->ep, file->tr);
 		else
 			disable_kprobe(&tk->rp.kp);
 	}
@@ -377,7 +623,7 @@ static int enable_trace_kprobe(struct trace_event_call *call,
 		tk = container_of(pos, struct trace_kprobe, tp);
 		if (trace_kprobe_has_gone(tk))
 			continue;
-		ret = __enable_trace_kprobe(tk);
+		ret = __enable_trace_kprobe(tk, file);
 		if (ret)
 			break;
 		enabled = true;
@@ -386,7 +632,7 @@ static int enable_trace_kprobe(struct trace_event_call *call,
 	if (ret) {
 		/* Failed to enable one of them. Roll back all */
 		if (enabled)
-			__disable_trace_kprobe(tp);
+			__disable_trace_kprobe(tp, file);
 		if (file)
 			trace_probe_remove_file(tp, file);
 		else
@@ -419,7 +665,7 @@ static int disable_trace_kprobe(struct trace_event_call *call,
 		trace_probe_clear_flag(tp, TP_FLAG_PROFILE);
 
 	if (!trace_probe_is_enabled(tp))
-		__disable_trace_kprobe(tp);
+		__disable_trace_kprobe(tp, file);
 
  out:
 	if (file)
@@ -711,6 +957,155 @@ static inline void sanitize_event_name(char *name)
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
+		if (tp_event->flags & TRACE_EVENT_FL_IGNORE_ENABLE)
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
+		tk->ep->event = tp_event;
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
+	head = trace_get_fields(tk->ep->event);
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
+static int __trace_eprobe_create(int argc, const char *argv[])
+{
+	const char *event = NULL, *group = KPROBE_EVENT_SYSTEM;
+	unsigned int flags = TPARG_FL_KERNEL | TPARG_FL_TPOINT;
+	const char *sys_event = NULL, *sys_name = NULL;
+	struct trace_kprobe *tk = NULL;
+	struct trace_event_call *call;
+	char buf1[MAX_EVENT_NAME_LEN];
+	char buf2[MAX_EVENT_NAME_LEN];
+	char *tmp = NULL;
+	int ret = 0;
+	int i;
+
+	if (argc < 2)
+		return -ECANCELED;
+
+	trace_probe_log_init("event_probe", argc, argv);
+
+	event = strchr(&argv[0][1], ':');
+	if (event) {
+		event++;
+		ret = traceprobe_parse_event_name(&event, &group, buf1,
+						  event - argv[0], '/');
+		if (ret)
+			goto parse_error;
+	} else {
+		strscpy(buf1, argv[1], MAX_EVENT_NAME_LEN);
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
+
+	mutex_lock(&event_mutex);
+	ret = register_kprobe_event(tk);
+	if (ret)
+		goto out_unlock;
+
+	/* Reassign to a EPROBE */
+	call = trace_probe_event_call(&tk->tp);
+	call->flags = TRACE_EVENT_FL_EPROBE;
+
+	ret = dyn_event_add(&tk->devent);
+out_unlock:
+	mutex_unlock(&event_mutex);
+	return ret;
+
+parse_error:
+	ret = -EINVAL;
+error:
+	free_trace_kprobe(tk);
+	return ret;
+}
+
+static int trace_eprobe_create(const char *raw_command)
+{
+	return trace_probe_create(raw_command, __trace_eprobe_create);
+}
+
 static int __trace_kprobe_create(int argc, const char *argv[])
 {
 	/*
@@ -841,7 +1236,7 @@ static int __trace_kprobe_create(int argc, const char *argv[])
 	trace_probe_log_set_index(0);
 	if (event) {
 		ret = traceprobe_parse_event_name(&event, &group, buf,
-						  event - argv[0]);
+						  event - argv[0], '/');
 		if (ret)
 			goto parse_error;
 	} else {
@@ -922,7 +1317,11 @@ static int create_or_delete_trace_kprobe(const char *raw_command)
 	if (raw_command[0] == '-')
 		return dyn_event_release(raw_command, &trace_kprobe_ops);
 
-	ret = trace_kprobe_create(raw_command);
+	if (raw_command[0] == 'e')
+		ret = trace_eprobe_create(raw_command);
+	else
+		ret = trace_kprobe_create(raw_command);
+
 	return ret == -ECANCELED ? -EINVAL : ret;
 }
 
@@ -1107,20 +1506,25 @@ static int trace_kprobe_show(struct seq_file *m, struct dyn_event *ev)
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
@@ -1378,11 +1782,12 @@ NOKPROBE_SYMBOL(process_fetch_insn)
 
 /* Kprobe handler */
 static nokprobe_inline void
-__kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs,
+__kprobe_trace_func(struct trace_kprobe *tk, void *rec,
 		    struct trace_event_file *trace_file)
 {
 	struct kprobe_trace_entry_head *entry;
 	struct trace_event_call *call = trace_probe_event_call(&tk->tp);
+	bool eprobe = trace_kprobe_is_event(tk);
 	struct trace_event_buffer fbuffer;
 	int dsize;
 
@@ -1394,7 +1799,14 @@ __kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs,
 	fbuffer.trace_ctx = tracing_gen_ctx();
 	fbuffer.trace_file = trace_file;
 
-	dsize = __get_data_size(&tk->tp, regs);
+	if (eprobe) {
+		dsize = get_eprobe_size(&tk->tp, rec);
+		fbuffer.regs = 0;
+	} else {
+		dsize = __get_data_size(&tk->tp, rec);
+		fbuffer.regs = rec;
+	}
+
 
 	fbuffer.event =
 		trace_event_buffer_lock_reserve(&fbuffer.buffer, trace_file,
@@ -1404,10 +1816,9 @@ __kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs,
 	if (!fbuffer.event)
 		return;
 
-	fbuffer.regs = regs;
 	entry = fbuffer.entry = ring_buffer_event_data(fbuffer.event);
 	entry->ip = (unsigned long)tk->rp.kp.addr;
-	store_trace_args(&entry[1], &tk->tp, regs, sizeof(*entry), dsize);
+	store_trace_args_ext(&entry[1], &tk->tp, rec, sizeof(*entry), dsize, !eprobe);
 
 	trace_event_buffer_commit(&fbuffer);
 }
@@ -1779,6 +2190,9 @@ static inline void init_trace_event_call(struct trace_kprobe *tk)
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
index 15413ad7cef2..2c7988d5698f 100644
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
+	if (ep->event)
+		module_put(ep->event->mod);
+	kfree(ep);
+}
+
 int trace_probe_init(struct trace_probe *tp, const char *event,
 		     const char *group, bool alloc_filter)
 {
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 227d518e5ba5..9cb7529a7009 100644
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
@@ -351,7 +353,8 @@ int trace_probe_create(const char *raw_command, int (*createfn)(int, const char
 #define TPARG_FL_RETURN BIT(0)
 #define TPARG_FL_KERNEL BIT(1)
 #define TPARG_FL_FENTRY BIT(2)
-#define TPARG_FL_MASK	GENMASK(2, 0)
+#define TPARG_FL_TPOINT BIT(3)
+#define TPARG_FL_MASK	GENMASK(3, 0)
 
 extern int traceprobe_parse_probe_arg(struct trace_probe *tp, int i,
 				char *arg, unsigned int flags);
@@ -361,7 +364,7 @@ extern void traceprobe_free_probe_arg(struct probe_arg *arg);
 
 extern int traceprobe_split_symbol_offset(char *symbol, long *offset);
 int traceprobe_parse_event_name(const char **pevent, const char **pgroup,
-				char *buf, int offset);
+				char *buf, int offset, int delim);
 
 extern int traceprobe_set_print_fmt(struct trace_probe *tp, bool is_return);
 
diff --git a/kernel/trace/trace_probe_tmpl.h b/kernel/trace/trace_probe_tmpl.h
index f003c5d02a3a..7ee3a9e7047f 100644
--- a/kernel/trace/trace_probe_tmpl.h
+++ b/kernel/trace/trace_probe_tmpl.h
@@ -186,12 +186,50 @@ __get_data_size(struct trace_probe *tp, struct pt_regs *regs)
 	return ret;
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
+			val = *(char *)addr;
+		else
+			val = *(unsigned char *)addr;
+		break;
+	case 2:
+		if (field->is_signed)
+			val = *(short *)addr;
+		else
+			val = *(unsigned short *)addr;
+		break;
+	case 4:
+		if (field->is_signed)
+			val = *(int *)addr;
+		else
+			val = *(unsigned int *)addr;
+		break;
+	default:
+		if (field->is_signed)
+			val = *(long *)addr;
+		else
+			val = *(unsigned long *)addr;
+		break;
+	}
+	return val;
+}
+
 /* Store the value of each argument */
 static nokprobe_inline void
-store_trace_args(void *data, struct trace_probe *tp, struct pt_regs *regs,
-		 int header_size, int maxlen)
+store_trace_args_ext(void *data, struct trace_probe *tp, void *rec,
+		     int header_size, int maxlen, bool reg)
 {
 	struct probe_arg *arg;
+	unsigned long val;
 	void *base = data - header_size;
 	void *dyndata = data + tp->size;
 	u32 *dl;	/* Data location */
@@ -203,7 +241,12 @@ store_trace_args(void *data, struct trace_probe *tp, struct pt_regs *regs,
 		/* Point the dynamic data area if needed */
 		if (unlikely(arg->dynamic))
 			*dl = make_data_loc(maxlen, dyndata - base);
-		ret = process_fetch_insn(arg->code, regs, dl, base);
+		if (reg) {
+			ret = process_fetch_insn(arg->code, rec, dl, base);
+		} else {
+			val = get_event_field(arg->code, rec);
+			ret = process_fetch_insn_bottom(arg->code + 1, val, dl, base);
+		}
 		if (unlikely(ret < 0 && arg->dynamic)) {
 			*dl = make_data_loc(0, dyndata - base);
 		} else {
@@ -213,6 +256,13 @@ store_trace_args(void *data, struct trace_probe *tp, struct pt_regs *regs,
 	}
 }
 
+static nokprobe_inline void
+store_trace_args(void *data, struct trace_probe *tp, struct pt_regs *regs,
+		 int header_size, int maxlen)
+{
+	store_trace_args_ext(data, tp, regs, header_size, maxlen, true);
+}
+
 static inline int
 print_probe_args(struct trace_seq *s, struct probe_arg *args, int nr_args,
 		 u8 *data, void *field)
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 9b50869a5ddb..0fa06a60a0a8 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -641,7 +641,7 @@ static int __trace_uprobe_create(int argc, const char **argv)
 	trace_probe_log_set_index(0);
 	if (event) {
 		ret = traceprobe_parse_event_name(&event, &group, buf,
-						  event - argv[0]);
+						  event - argv[0], '/');
 		if (ret)
 			goto fail_address_parse;
 	} else {
-- 
2.31.1

