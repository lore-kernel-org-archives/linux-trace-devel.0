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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D60C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 03:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D31A60462
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 03:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbhHKDES (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 23:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbhHKDEQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 23:04:16 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD7AC061765;
        Tue, 10 Aug 2021 20:03:52 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id k29so894396wrd.7;
        Tue, 10 Aug 2021 20:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=flLH/7MYYPi90GkEn7V05SESUcUfVtGoExDOWR5n9mE=;
        b=ERaVMGAb+9g1fLmcbRo0jsPsQJ1wNPfIE/12AbMw6l08oNJGaMrp8cSvashSAn/3IK
         AmmbS5VCND/DmY7Y7cmJZ5Lf/bDDsuedMb2SwXKzoNpELeYqDImcgRAAIneR4YbD+APD
         qvS2RIYhjrjO02/33dhMMRQT9MJajc4t1Z7T1W8H+C2N3XwgmeQxXvSmjCGOjiH1k2+0
         YCQbiA2ODER2wC/oxxCGAxqOkKXpqCuuy2DO68R53SoOqg9aYhLKdPZ/T0W9Y8cQ73NM
         RuM1hnKqW7YFPGKrtJjMRlKSpe3LcObFlltFbaxZJ+g0ojasTsqPx+8ysLcPAJfje2ou
         85Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=flLH/7MYYPi90GkEn7V05SESUcUfVtGoExDOWR5n9mE=;
        b=JGOUjB3fyCrMIS1AgljdxVV0eqkhLC8d0hYF75Lrt/MBFKNfy7/qQCXAj8cSFVflk8
         /Pu5J9Q91egERBD0xG5uqziZYfX0PfvIh2Q5toaP7CuZTlB2ZxDtjZCH4UNwv/gF7Kx4
         qsD02Rc12Quxga+JRseKDiNRdLFW8h1Vzb2i3/c2Mg0aeegLACczj3Bdo/ibZfc9i4Ja
         I3b9y7OiDlDQRiy1WHUjJ7+Fzv/a5V7okXWB8qEdjD/hiGllr1GmHHm90t4wVCzjvsBF
         iUSnRMAqteS3g3RqyZoJE86bOtnEAmgOGqPKszHUF6ZMisSIf6t1812C88numJbdNFgo
         zx8g==
X-Gm-Message-State: AOAM530ur6+quP6M2KCjdfgjNOAfYrjuxPZCvPZte7pduhO1d3PlB+Gz
        DlzWDXT0CH/OVcepvmW1Nl8=
X-Google-Smtp-Source: ABdhPJxt5W+m4XRwBdmKsQpdlB6+xEH92Pfr7wdCz6Rq5Fy4bKxH0z7MNQccLKrYs/4a5x57jPoCMg==
X-Received: by 2002:a5d:4442:: with SMTP id x2mr5714205wrr.60.1628651031055;
        Tue, 10 Aug 2021 20:03:51 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i10sm4394419wmq.21.2021.08.10.20.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 20:03:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     mhiramat@kernel.org
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com
Subject: [PATCH v3] [RFC] trace: Add kprobe on tracepoint
Date:   Wed, 11 Aug 2021 06:03:48 +0300
Message-Id: <20210811030348.1791207-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

A new dynamic event is introduced: event probe. The event is attached
to an existing tracepoint and uses its fields as arguments. The user
can specify custom format string of the new event, select what tracepoint
arguments will be printed and how to print them.
An event probe is created by writing configuration string in
'dynamic_events' ftrace file:
 e:GNAME/ENAME SYSTEM.EVENT [FETCHARGS]	- Set an event probe
 -:GNAME/ENAME				- Delete an event probe

Where:
 GNAME	- Group name, if omitted 'eprobes' is used.
 ENAME	- Name of the new event in GNAME, mandatory.
 SYSTEM	- Name of the system, where the tracepoint is defined, mandatory.
 EVENT	- Name of the tracepoint event in SYSTEM, mandatory.
 FETCHARGS - Arguments:
  <name>=$<field>[:TYPE] - Fetch given filed of the tracepoint and print
			   it as given TYPE with given name. Supported
			   types are:
	                    (u8/u16/u32/u64/s8/s16/s32/s64), basic type
        	            (x8/x16/x32/x64), hexadecimal types
			    "string", "ustring" and bitfield.

Example, attach an event probe on openat system call and print name of the
file that will be opened:
 echo "e:esys/eopen syscalls.sys_enter_openat file=\$filename:string" >> dynamic_events
A new dynamic event is created in events/esys/eopen/ directory. It
can be deleted with:
 echo "-:esys/eopen" >> dynamic_events

Filters, triggers and histograms can be attached to the new event, it can
be matched in synthetic events. There is one limitation - no synthetic
events can be attached to an event probe.

Co-authored-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
Subject of the patch is still related to kprobe, though the design no more
depends on kprobe. I did not change it for consistency with the first
patch version. 

v3 changes:
 - Fixed warnings, reported by kernel test robot <lkp@intel.com>.

v2 changes:
 - Moved the changes from kbrobe code into a new dynamic event, as
   Masami Hiramatsu suggested.
 - Fixed few issues and added more comments, suggested by Steven Rostedt.

 include/linux/trace_events.h        |   4 +
 kernel/trace/Makefile               |   1 +
 kernel/trace/trace.h                |  13 +
 kernel/trace/trace_eprobe.c         | 874 ++++++++++++++++++++++++++++
 kernel/trace/trace_events_hist.c    |  35 +-
 kernel/trace/trace_events_trigger.c |  14 +-
 kernel/trace/trace_kprobe.c         |  13 +-
 kernel/trace/trace_probe.c          |  16 +-
 kernel/trace/trace_probe.h          |   6 +-
 kernel/trace/trace_probe_tmpl.h     |   6 +-
 kernel/trace/trace_uprobe.c         |   5 +-
 11 files changed, 957 insertions(+), 30 deletions(-)
 create mode 100644 kernel/trace/trace_eprobe.c

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index ad413b382a3c..34556b3b8ac2 100644
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
+	ETT_EVENT_EPROBE	= (1 << 6),
 };
 
 extern int filter_match_preds(struct event_filter *filter, void *rec);
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index b1c47ccf4f73..c4e632a5ccda 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_EVENT_TRACING) += trace_event_perf.o
 endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_EVENT_TRACING) += trace_events_trigger.o
+obj-$(CONFIG_EVENT_TRACING) += trace_eprobe.o
 obj-$(CONFIG_TRACE_EVENT_INJECT) += trace_events_inject.o
 obj-$(CONFIG_SYNTH_EVENTS) += trace_events_synth.o
 obj-$(CONFIG_HIST_TRIGGERS) += trace_events_hist.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a180abf76d4e..f0534b885f62 100644
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
@@ -1950,6 +1955,14 @@ static inline bool is_good_name(const char *name)
 	return true;
 }
 
+/* Convert certain expected symbols into '_' when generating event names */
+static inline void sanitize_event_name(char *name)
+{
+	while (*name++ != '\0')
+		if (*name == ':' || *name == '.')
+			*name = '_';
+}
+
 /*
  * This is a generic way to read and write a u64 value from a file in tracefs.
  *
diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
new file mode 100644
index 000000000000..a19f6e6842ba
--- /dev/null
+++ b/kernel/trace/trace_eprobe.c
@@ -0,0 +1,874 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * event probes
+ *
+ * Part of this code was copied from kernel/trace/trace_kprobe.c written by
+ * Masami Hiramatsu <mhiramat@kernel.org>
+ *
+ * Copyright (C) 2021, VMware Inc, Steven Rostedt <rostedt@goodmis.org>
+ * Copyright (C) 2021, VMware Inc, Tzvetomir Stoyanov tz.stoyanov@gmail.com>
+ *
+ */
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/ftrace.h>
+
+#include "trace_dynevent.h"
+#include "trace_probe.h"
+#include "trace_probe_tmpl.h"
+
+#define EPROBE_EVENT_SYSTEM "eprobes"
+
+#define SIZEOF_TRACE_EPROBE(n)				\
+	(offsetof(struct trace_eprobe, tp.args) +	\
+	(sizeof(struct probe_arg) * (n)))
+
+struct trace_eprobe {
+	/* tracepoint system */
+	const char *event_system;
+
+	/* tracepoint event */
+	const char *event_name;
+
+	struct trace_event_call *event;
+
+	struct dyn_event	devent;
+	struct trace_probe	tp;
+};
+
+struct eprobe_data {
+	struct trace_event_file	*file;
+	struct trace_eprobe	*ep;
+};
+
+static int __trace_eprobe_create(int argc, const char *argv[]);
+
+static void trace_event_probe_cleanup(struct trace_eprobe *ep)
+{
+	trace_probe_cleanup(&ep->tp);
+	kfree(ep->event_name);
+	kfree(ep->event_system);
+	if (ep->event)
+		module_put(ep->event->mod);
+	kfree(ep);
+}
+
+static struct trace_eprobe *to_trace_eprobe(struct dyn_event *ev)
+{
+	return container_of(ev, struct trace_eprobe, devent);
+}
+
+static int trace_eprobe_find(struct trace_eprobe *ep)
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
+		    strcmp(ep->event_system, tp_event->class->system))
+			continue;
+		name = trace_event_name(tp_event);
+		if (!name ||
+		    strcmp(ep->event_name, name))
+			continue;
+		if (!try_module_get(tp_event->mod)) {
+			ret = -ENODEV;
+			break;
+		}
+		ep->event = tp_event;
+		ret = 0;
+		break;
+	}
+	mutex_unlock(&event_mutex);
+
+	return ret;
+}
+
+static int eprobe_dyn_event_create(const char *raw_command)
+{
+	return trace_probe_create(raw_command, __trace_eprobe_create);
+}
+
+static int eprobe_dyn_event_show(struct seq_file *m, struct dyn_event *ev)
+{
+	struct trace_eprobe *ep = to_trace_eprobe(ev);
+	int i;
+
+	seq_printf(m, "e:%s/%s", trace_probe_group_name(&ep->tp),
+				trace_probe_name(&ep->tp));
+	seq_printf(m, " %s.%s", ep->event_system, ep->event_name);
+
+	for (i = 0; i < ep->tp.nr_args; i++)
+		seq_printf(m, " %s=%s", ep->tp.args[i].name, ep->tp.args[i].comm);
+	seq_putc(m, '\n');
+
+	return 0;
+}
+
+static int unregister_trace_eprobe(struct trace_eprobe *ep)
+{
+	/* If other probes are on the event, just unregister eprobe */
+	if (trace_probe_has_sibling(&ep->tp))
+		goto unreg;
+
+	/* Enabled event can not be unregistered */
+	if (trace_probe_is_enabled(&ep->tp))
+		return -EBUSY;
+
+	/* Will fail if probe is being used by ftrace or perf */
+	if (trace_probe_unregister_event_call(&ep->tp))
+		return -EBUSY;
+
+unreg:
+	dyn_event_remove(&ep->devent);
+	trace_probe_unlink(&ep->tp);
+
+	return 0;
+}
+
+static int eprobe_dyn_event_release(struct dyn_event *ev)
+{
+	struct trace_eprobe *ep = to_trace_eprobe(ev);
+	int ret = unregister_trace_eprobe(ep);
+
+	if (!ret)
+		trace_event_probe_cleanup(ep);
+	return ret;
+}
+
+static bool eprobe_dyn_event_is_busy(struct dyn_event *ev)
+{
+	struct trace_eprobe *ep = to_trace_eprobe(ev);
+
+	return trace_probe_is_enabled(&ep->tp);
+}
+
+static bool eprobe_dyn_event_match(const char *system, const char *event,
+			int argc, const char **argv, struct dyn_event *ev)
+{
+	struct trace_eprobe *ep = to_trace_eprobe(ev);
+
+	return strcmp(trace_probe_name(&ep->tp), event) == 0 &&
+	    (!system || strcmp(trace_probe_group_name(&ep->tp), system) == 0) &&
+	    trace_probe_match_command_args(&ep->tp, argc, argv);
+}
+
+static struct dyn_event_operations eprobe_dyn_event_ops = {
+	.create = eprobe_dyn_event_create,
+	.show = eprobe_dyn_event_show,
+	.is_busy = eprobe_dyn_event_is_busy,
+	.free = eprobe_dyn_event_release,
+	.match = eprobe_dyn_event_match,
+};
+
+static struct trace_eprobe *alloc_event_probe(const char *group,
+					      const char *event,
+					      const char *sys_name,
+					      const char *sys_event,
+					      int nargs)
+{
+	struct trace_eprobe *ep;
+	int ret = -ENOMEM;
+
+	ep = kzalloc(SIZEOF_TRACE_EPROBE(nargs), GFP_KERNEL);
+	if (!ep)
+		goto error;
+	ep->event_name = kstrdup(sys_event, GFP_KERNEL);
+	if (!ep->event_name)
+		goto error;
+	ep->event_system = kstrdup(sys_name, GFP_KERNEL);
+	if (!ep->event_system)
+		goto error;
+
+	ret = trace_probe_init(&ep->tp, event, group, false);
+	if (ret < 0)
+		goto error;
+
+	dyn_event_init(&ep->devent, &eprobe_dyn_event_ops);
+	return ep;
+error:
+	trace_event_probe_cleanup(ep);
+	return ERR_PTR(ret);
+}
+
+static int trace_eprobe_tp_arg_find(struct trace_eprobe *ep, int i)
+{
+	struct probe_arg *parg = &ep->tp.args[i];
+	struct ftrace_event_field *field;
+	struct list_head *head;
+
+	head = trace_get_fields(ep->event);
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
+static int kprobe_event_define_fields(struct trace_event_call *event_call)
+{
+	int ret;
+	struct kprobe_trace_entry_head field;
+	struct trace_probe *tp;
+
+	tp = trace_probe_primary_from_call(event_call);
+	if (WARN_ON_ONCE(!tp))
+		return -ENOENT;
+
+	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
+
+	return traceprobe_define_arg_fields(event_call, sizeof(field), tp);
+}
+
+static struct trace_event_fields eprobe_fields_array[] = {
+	{ .type = TRACE_FUNCTION_TYPE,
+	  .define_fields = kprobe_event_define_fields },
+	{}
+};
+
+/* Event entry printers */
+static enum print_line_t
+print_eprobe_event(struct trace_iterator *iter, int flags,
+		   struct trace_event *event)
+{
+	struct kprobe_trace_entry_head *field;
+	struct trace_seq *s = &iter->seq;
+	struct trace_probe *tp;
+
+	field = (struct kprobe_trace_entry_head *)iter->ent;
+	tp = trace_probe_primary_from_call(
+		container_of(event, struct trace_event_call, event));
+	if (WARN_ON_ONCE(!tp))
+		goto out;
+
+	trace_seq_printf(s, "%s: (", trace_probe_name(tp));
+
+	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
+		goto out;
+
+	trace_seq_putc(s, ')');
+
+	if (print_probe_args(s, tp->args, tp->nr_args,
+			     (u8 *)&field[1], field) < 0)
+		goto out;
+
+	trace_seq_putc(s, '\n');
+ out:
+	return trace_handle_return(s);
+}
+
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
+/* Kprobe specific fetch functions */
+
+/* Note that we don't verify it, since the code does not come from user space */
+static int
+process_fetch_insn(struct fetch_insn *code, void *rec, void *dest,
+		   void *base)
+{
+	unsigned long val;
+
+	val = get_event_field(code, rec);
+	return process_fetch_insn_bottom(code + 1, val, dest, base);
+}
+NOKPROBE_SYMBOL(process_fetch_insn)
+
+/* Return the length of string -- including null terminal byte */
+static nokprobe_inline int
+fetch_store_strlen_user(unsigned long addr)
+{
+	const void __user *uaddr =  (__force const void __user *)addr;
+
+	return strnlen_user_nofault(uaddr, MAX_STRING_SIZE);
+}
+
+/* Return the length of string -- including null terminal byte */
+static nokprobe_inline int
+fetch_store_strlen(unsigned long addr)
+{
+	int ret, len = 0;
+	u8 c;
+
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	if (addr < TASK_SIZE)
+		return fetch_store_strlen_user(addr);
+#endif
+
+	do {
+		ret = copy_from_kernel_nofault(&c, (u8 *)addr + len, 1);
+		len++;
+	} while (c && ret == 0 && len < MAX_STRING_SIZE);
+
+	return (ret < 0) ? ret : len;
+}
+
+/*
+ * Fetch a null-terminated string from user. Caller MUST set *(u32 *)buf
+ * with max length and relative data location.
+ */
+static nokprobe_inline int
+fetch_store_string_user(unsigned long addr, void *dest, void *base)
+{
+	const void __user *uaddr =  (__force const void __user *)addr;
+	int maxlen = get_loc_len(*(u32 *)dest);
+	void *__dest;
+	long ret;
+
+	if (unlikely(!maxlen))
+		return -ENOMEM;
+
+	__dest = get_loc_data(dest, base);
+
+	ret = strncpy_from_user_nofault(__dest, uaddr, maxlen);
+	if (ret >= 0)
+		*(u32 *)dest = make_data_loc(ret, __dest - base);
+
+	return ret;
+}
+
+/*
+ * Fetch a null-terminated string. Caller MUST set *(u32 *)buf with max
+ * length and relative data location.
+ */
+static nokprobe_inline int
+fetch_store_string(unsigned long addr, void *dest, void *base)
+{
+	int maxlen = get_loc_len(*(u32 *)dest);
+	void *__dest;
+	long ret;
+
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	if ((unsigned long)addr < TASK_SIZE)
+		return fetch_store_string_user(addr, dest, base);
+#endif
+
+	if (unlikely(!maxlen))
+		return -ENOMEM;
+
+	__dest = get_loc_data(dest, base);
+
+	/*
+	 * Try to get string again, since the string can be changed while
+	 * probing.
+	 */
+	ret = strncpy_from_kernel_nofault(__dest, (void *)addr, maxlen);
+	if (ret >= 0)
+		*(u32 *)dest = make_data_loc(ret, __dest - base);
+
+	return ret;
+}
+
+static nokprobe_inline int
+probe_mem_read_user(void *dest, void *src, size_t size)
+{
+	const void __user *uaddr =  (__force const void __user *)src;
+
+	return copy_from_user_nofault(dest, uaddr, size);
+}
+
+static nokprobe_inline int
+probe_mem_read(void *dest, void *src, size_t size)
+{
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	if ((unsigned long)src < TASK_SIZE)
+		return probe_mem_read_user(dest, src, size);
+#endif
+	return copy_from_kernel_nofault(dest, src, size);
+}
+
+/* eprobe handler */
+static inline void
+__eprobe_trace_func(struct eprobe_data *edata, void *rec)
+{
+	struct kprobe_trace_entry_head *entry;
+	struct trace_event_call *call = trace_probe_event_call(&edata->ep->tp);
+	struct trace_event_buffer fbuffer;
+	int dsize;
+
+	WARN_ON(call != edata->file->event_call);
+
+	if (trace_trigger_soft_disabled(edata->file))
+		return;
+
+	fbuffer.trace_ctx = tracing_gen_ctx();
+	fbuffer.trace_file = edata->file;
+
+	dsize = get_eprobe_size(&edata->ep->tp, rec);
+	fbuffer.regs = NULL;
+
+	fbuffer.event =
+		trace_event_buffer_lock_reserve(&fbuffer.buffer, edata->file,
+					call->event.type,
+					sizeof(*entry) + edata->ep->tp.size + dsize,
+					fbuffer.trace_ctx);
+	if (!fbuffer.event)
+		return;
+
+	entry = fbuffer.entry = ring_buffer_event_data(fbuffer.event);
+	entry->ip = 0;
+	store_trace_args(&entry[1], &edata->ep->tp, rec, sizeof(*entry), dsize);
+
+	trace_event_buffer_commit(&fbuffer);
+}
+
+/*
+ * The event probe implementation uses event triggers to get access to
+ * the event it is attached to, but is not an actual trigger. The below
+ * functions are just stubs to fulfill what is needed to use the trigger
+ * infrastructure.
+ */
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
+	/* Do not print eprobe event triggers */
+	return 0;
+}
+
+static void eprobe_trigger_func(struct event_trigger_data *data,
+				struct trace_buffer *buffer, void *rec,
+				struct ring_buffer_event *rbe)
+{
+	struct eprobe_data *edata = data->private_data;
+
+	__eprobe_trace_func(edata, rec);
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
+	.trigger_type		= ETT_EVENT_EPROBE,
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
+new_eprobe_trigger(struct trace_eprobe *ep, struct trace_event_file *file)
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
+	 * EVENT PROBE triggers are not registered as commands with
+	 * register_event_command(), as they are not controlled by the user
+	 * from the trigger file
+	 */
+	trigger->cmd_ops = &event_trigger_cmd;
+
+	INIT_LIST_HEAD(&trigger->list);
+	RCU_INIT_POINTER(trigger->filter, NULL);
+
+	edata->file = file;
+	edata->ep = ep;
+	trigger->private_data = edata;
+
+	return trigger;
+}
+
+static int enable_eprobe(struct trace_eprobe *ep,
+			 struct trace_event_file *eprobe_file)
+{
+	struct event_trigger_data *trigger;
+	struct trace_event_file *file;
+	struct trace_array *tr = eprobe_file->tr;
+
+	file = find_event_file(tr, ep->event_system, ep->event_name);
+	if (!file)
+		return -ENOENT;
+	trigger = new_eprobe_trigger(ep, eprobe_file);
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
+static struct trace_event_functions eprobe_funcs = {
+	.trace		= print_eprobe_event
+};
+
+static int disable_eprobe(struct trace_eprobe *ep,
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
+	return 0;
+}
+
+static int enable_trace_eprobe(struct trace_event_call *call,
+			       struct trace_event_file *file)
+{
+	struct trace_probe *pos, *tp;
+	struct trace_eprobe *ep;
+	bool enabled;
+	int ret = 0;
+
+	tp = trace_probe_primary_from_call(call);
+	if (WARN_ON_ONCE(!tp))
+		return -ENODEV;
+	enabled = trace_probe_is_enabled(tp);
+
+	/* This also changes "enabled" state */
+	if (file) {
+		ret = trace_probe_add_file(tp, file);
+		if (ret)
+			return ret;
+	} else
+		trace_probe_set_flag(tp, TP_FLAG_PROFILE);
+
+	if (enabled)
+		return 0;
+
+	list_for_each_entry(pos, trace_probe_probe_list(tp), list) {
+		ep = container_of(pos, struct trace_eprobe, tp);
+		ret = enable_eprobe(ep, file);
+		if (ret)
+			break;
+		enabled = true;
+	}
+
+	if (ret) {
+		/* Failed to enable one of them. Roll back all */
+		if (enabled)
+			disable_eprobe(ep, file->tr);
+		if (file)
+			trace_probe_remove_file(tp, file);
+		else
+			trace_probe_clear_flag(tp, TP_FLAG_PROFILE);
+	}
+
+	return ret;
+}
+
+static int disable_trace_eprobe(struct trace_event_call *call,
+				struct trace_event_file *file)
+{
+	struct trace_probe *pos, *tp;
+	struct trace_eprobe *ep;
+
+	tp = trace_probe_primary_from_call(call);
+	if (WARN_ON_ONCE(!tp))
+		return -ENODEV;
+
+	if (file) {
+		if (!trace_probe_get_file_link(tp, file))
+			return -ENOENT;
+		if (!trace_probe_has_single_file(tp))
+			goto out;
+		trace_probe_clear_flag(tp, TP_FLAG_TRACE);
+	} else
+		trace_probe_clear_flag(tp, TP_FLAG_PROFILE);
+
+	if (!trace_probe_is_enabled(tp)) {
+		list_for_each_entry(pos, trace_probe_probe_list(tp), list) {
+			ep = container_of(pos, struct trace_eprobe, tp);
+			disable_eprobe(ep, file->tr);
+		}
+	}
+
+ out:
+	if (file)
+		/*
+		 * Synchronization is done in below function. For perf event,
+		 * file == NULL and perf_trace_event_unreg() calls
+		 * tracepoint_synchronize_unregister() to ensure synchronize
+		 * event. We don't need to care about it.
+		 */
+		trace_probe_remove_file(tp, file);
+
+	return 0;
+}
+
+static int eprobe_register(struct trace_event_call *event,
+			   enum trace_reg type, void *data)
+{
+	struct trace_event_file *file = data;
+
+	switch (type) {
+	case TRACE_REG_REGISTER:
+		return enable_trace_eprobe(event, file);
+	case TRACE_REG_UNREGISTER:
+		return disable_trace_eprobe(event, file);
+#ifdef CONFIG_PERF_EVENTS
+	case TRACE_REG_PERF_REGISTER:
+	case TRACE_REG_PERF_UNREGISTER:
+	case TRACE_REG_PERF_OPEN:
+	case TRACE_REG_PERF_CLOSE:
+	case TRACE_REG_PERF_ADD:
+	case TRACE_REG_PERF_DEL:
+		return 0;
+#endif
+	}
+	return 0;
+}
+
+static inline void init_trace_eprobe_call(struct trace_eprobe *ep)
+{
+	struct trace_event_call *call = trace_probe_event_call(&ep->tp);
+
+	call->flags = TRACE_EVENT_FL_EPROBE;
+	call->event.funcs = &eprobe_funcs;
+	call->class->fields_array = eprobe_fields_array;
+	call->class->reg = eprobe_register;
+}
+
+static int __trace_eprobe_create(int argc, const char *argv[])
+{
+	/*
+	 * Argument syntax:
+	 *      e[:[GRP/]ENAME] SYSTEM.EVENT [FETCHARGS]
+	 * Fetch args:
+	 *  <name>=$<field>[:TYPE]
+	 */
+	const char *event = NULL, *group = EPROBE_EVENT_SYSTEM;
+	unsigned int flags = TPARG_FL_KERNEL | TPARG_FL_TPOINT;
+	const char *sys_event = NULL, *sys_name = NULL;
+	struct trace_eprobe *ep = NULL;
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
+	ep = alloc_event_probe(group, event, sys_name, sys_event, argc - 2);
+	if (IS_ERR(ep)) {
+		ret = PTR_ERR(ep);
+		/* This must return -ENOMEM, else there is a bug */
+		WARN_ON_ONCE(ret != -ENOMEM);
+		goto error;	/* We know ep is not allocated */
+	}
+	ret = trace_eprobe_find(ep);
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
+		ret = traceprobe_parse_probe_arg(&ep->tp, i, tmp, flags);
+		if (ret == -EINVAL)
+			kfree(tmp);
+		if (ret)
+			goto error;	/* This can be -ENOMEM */
+		if (ep->tp.args[i].code->op == FETCH_OP_TP_ARG) {
+			ret = trace_eprobe_tp_arg_find(ep, i);
+			if (ret)
+				goto error;
+		}
+	}
+	ret = traceprobe_set_print_fmt(&ep->tp, false);
+	if (ret < 0)
+		goto error;
+	init_trace_eprobe_call(ep);
+	mutex_lock(&event_mutex);
+	ret = trace_probe_register_event_call(&ep->tp);
+	if (ret)
+		goto out_unlock;
+	ret = dyn_event_add(&ep->devent);
+out_unlock:
+	mutex_unlock(&event_mutex);
+	return ret;
+
+parse_error:
+	ret = -EINVAL;
+error:
+	trace_event_probe_cleanup(ep);
+	return ret;
+}
+
+/*
+ * Register dynevent at core_initcall. This allows kernel to setup eprobe
+ * events in postcore_initcall without tracefs.
+ */
+static __init int trace_events_eprobe_init_early(void)
+{
+	int err = 0;
+
+	err = dyn_event_register(&eprobe_dyn_event_ops);
+	if (err)
+		pr_warn("Could not register eprobe_dyn_event_ops\n");
+
+	return err;
+}
+core_initcall(trace_events_eprobe_init_early);
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 949ef09dc537..45f5392fb35c 100644
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
@@ -2413,7 +2414,7 @@ find_compatible_hist(struct hist_trigger_data *target_hist_data,
 }
 
 static struct trace_event_file *event_file(struct trace_array *tr,
-					   char *system, char *event_name)
+					   const char *system, const char *event_name)
 {
 	struct trace_event_file *file;
 
@@ -3165,9 +3166,21 @@ static int parse_action_params(struct trace_array *tr, char *params,
 	return ret;
 }
 
-static int action_parse(struct trace_array *tr, char *str, struct action_data *data,
+static inline bool check_match_on_eprobe(struct trace_array *tr,
+					 const char *system, const char *event)
+{
+	struct trace_event_file *file;
+
+	file = event_file(tr, system, event);
+	if (file && (file->event_call->flags & TRACE_EVENT_FL_EPROBE))
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
 
@@ -3235,6 +3248,12 @@ static int action_parse(struct trace_array *tr, char *str, struct action_data *d
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
@@ -3293,7 +3312,7 @@ static struct action_data *track_data_parse(struct hist_trigger_data *hist_data,
 		goto free;
 	}
 
-	ret = action_parse(hist_data->event_file->tr, str, data, handler);
+	ret = action_parse(hist_data, str, data, handler);
 	if (ret)
 		goto free;
  out:
@@ -3626,8 +3645,9 @@ static int onmatch_create(struct hist_trigger_data *hist_data,
 	return action_create(hist_data, data);
 }
 
-static struct action_data *onmatch_parse(struct trace_array *tr, char *str)
+static struct action_data *onmatch_parse(struct hist_trigger_data *hist_data, char *str)
 {
+	struct trace_array *tr = hist_data->event_file->tr;
 	char *match_event, *match_event_system;
 	struct action_data *data;
 	int ret = -EINVAL;
@@ -3665,7 +3685,7 @@ static struct action_data *onmatch_parse(struct trace_array *tr, char *str)
 		goto free;
 	}
 
-	ret = action_parse(tr, str, data, HANDLER_ONMATCH);
+	ret = action_parse(hist_data, str, data, HANDLER_ONMATCH);
 	if (ret)
 		goto free;
  out:
@@ -4120,7 +4140,6 @@ static void destroy_actions(struct hist_trigger_data *hist_data)
 
 static int parse_actions(struct hist_trigger_data *hist_data)
 {
-	struct trace_array *tr = hist_data->event_file->tr;
 	struct action_data *data;
 	unsigned int i;
 	int ret = 0;
@@ -4133,7 +4152,7 @@ static int parse_actions(struct hist_trigger_data *hist_data)
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
index ea6178cb5e33..36c2671cbbb3 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -703,14 +703,6 @@ static struct notifier_block trace_kprobe_module_nb = {
 	.priority = 1	/* Invoked after kprobe module callback */
 };
 
-/* Convert certain expected symbols into '_' when generating event names */
-static inline void sanitize_event_name(char *name)
-{
-	while (*name++ != '\0')
-		if (*name == ':' || *name == '.')
-			*name = '_';
-}
-
 static int __trace_kprobe_create(int argc, const char *argv[])
 {
 	/*
@@ -841,7 +833,7 @@ static int __trace_kprobe_create(int argc, const char *argv[])
 	trace_probe_log_set_index(0);
 	if (event) {
 		ret = traceprobe_parse_event_name(&event, &group, buf,
-						  event - argv[0]);
+						  event - argv[0], '/');
 		if (ret)
 			goto parse_error;
 	} else {
@@ -1330,9 +1322,10 @@ probe_mem_read(void *dest, void *src, size_t size)
 
 /* Note that we don't verify it, since the code does not come from user space */
 static int
-process_fetch_insn(struct fetch_insn *code, struct pt_regs *regs, void *dest,
+process_fetch_insn(struct fetch_insn *code, void *rec, void *dest,
 		   void *base)
 {
+	struct pt_regs *regs = rec;
 	unsigned long val;
 
 retry:
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 15413ad7cef2..5a97317e91fb 100644
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
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 227d518e5ba5..efc976695f93 100644
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
@@ -351,7 +352,8 @@ int trace_probe_create(const char *raw_command, int (*createfn)(int, const char
 #define TPARG_FL_RETURN BIT(0)
 #define TPARG_FL_KERNEL BIT(1)
 #define TPARG_FL_FENTRY BIT(2)
-#define TPARG_FL_MASK	GENMASK(2, 0)
+#define TPARG_FL_TPOINT BIT(3)
+#define TPARG_FL_MASK	GENMASK(3, 0)
 
 extern int traceprobe_parse_probe_arg(struct trace_probe *tp, int i,
 				char *arg, unsigned int flags);
@@ -361,7 +363,7 @@ extern void traceprobe_free_probe_arg(struct probe_arg *arg);
 
 extern int traceprobe_split_symbol_offset(char *symbol, long *offset);
 int traceprobe_parse_event_name(const char **pevent, const char **pgroup,
-				char *buf, int offset);
+				char *buf, int offset, int delim);
 
 extern int traceprobe_set_print_fmt(struct trace_probe *tp, bool is_return);
 
diff --git a/kernel/trace/trace_probe_tmpl.h b/kernel/trace/trace_probe_tmpl.h
index f003c5d02a3a..b3bdb8ddb862 100644
--- a/kernel/trace/trace_probe_tmpl.h
+++ b/kernel/trace/trace_probe_tmpl.h
@@ -54,7 +54,7 @@ fetch_apply_bitfield(struct fetch_insn *code, void *buf)
  * If dest is NULL, don't store result and return required dynamic data size.
  */
 static int
-process_fetch_insn(struct fetch_insn *code, struct pt_regs *regs,
+process_fetch_insn(struct fetch_insn *code, void *rec,
 		   void *dest, void *base);
 static nokprobe_inline int fetch_store_strlen(unsigned long addr);
 static nokprobe_inline int
@@ -188,7 +188,7 @@ __get_data_size(struct trace_probe *tp, struct pt_regs *regs)
 
 /* Store the value of each argument */
 static nokprobe_inline void
-store_trace_args(void *data, struct trace_probe *tp, struct pt_regs *regs,
+store_trace_args(void *data, struct trace_probe *tp, void *rec,
 		 int header_size, int maxlen)
 {
 	struct probe_arg *arg;
@@ -203,7 +203,7 @@ store_trace_args(void *data, struct trace_probe *tp, struct pt_regs *regs,
 		/* Point the dynamic data area if needed */
 		if (unlikely(arg->dynamic))
 			*dl = make_data_loc(maxlen, dyndata - base);
-		ret = process_fetch_insn(arg->code, regs, dl, base);
+		ret = process_fetch_insn(arg->code, rec, dl, base);
 		if (unlikely(ret < 0 && arg->dynamic)) {
 			*dl = make_data_loc(0, dyndata - base);
 		} else {
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 9b50869a5ddb..180d9af6492e 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -217,9 +217,10 @@ static unsigned long translate_user_vaddr(unsigned long file_offset)
 
 /* Note that we don't verify it, since the code does not come from user space */
 static int
-process_fetch_insn(struct fetch_insn *code, struct pt_regs *regs, void *dest,
+process_fetch_insn(struct fetch_insn *code, void *rec, void *dest,
 		   void *base)
 {
+	struct pt_regs *regs = rec;
 	unsigned long val;
 
 	/* 1st stage: get value from context */
@@ -641,7 +642,7 @@ static int __trace_uprobe_create(int argc, const char **argv)
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

