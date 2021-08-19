Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62EC5C4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 15:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47ABE6101A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 15:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240407AbhHSP3D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 11:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240329AbhHSP3D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 11:29:03 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66C5C60FE8;
        Thu, 19 Aug 2021 15:28:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mGjxx-004hei-3d; Thu, 19 Aug 2021 11:28:25 -0400
Message-ID: <20210819152824.940415026@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 19 Aug 2021 11:26:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>
Subject: [PATCH v8 1/5] tracing/probes: Reject events which have the same name of existing
 one
References: <20210819152604.704335282@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

Since kprobe_events and uprobe_events only check whether the
other same-type probe event has the same name or not, if the
user gives the same name of the existing tracepoint event (or
the other type of probe events), it silently fails to create
the tracefs entry (but registered.) as below.

/sys/kernel/tracing # ls events/task/task_rename
enable   filter   format   hist     id       trigger
/sys/kernel/tracing # echo p:task/task_rename vfs_read >> kprobe_events
[  113.048508] Could not create tracefs 'task_rename' directory
/sys/kernel/tracing # cat kprobe_events
p:task/task_rename vfs_read

To fix this issue, check whether the existing events have the
same name or not in trace_probe_register_event_call(). If exists,
it rejects to register the new event.

Link: https://lkml.kernel.org/r/162936876189.187130.17558311387542061930.stgit@devnote2

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |  6 +++++-
 kernel/trace/trace_probe.c  | 25 +++++++++++++++++++++++++
 kernel/trace/trace_probe.h  |  1 +
 kernel/trace/trace_uprobe.c |  6 +++++-
 4 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 4b013d24f5a9..882c27044029 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -647,7 +647,11 @@ static int register_trace_kprobe(struct trace_kprobe *tk)
 	/* Register new event */
 	ret = register_kprobe_event(tk);
 	if (ret) {
-		pr_warn("Failed to register probe event(%d)\n", ret);
+		if (ret == -EEXIST) {
+			trace_probe_log_set_index(0);
+			trace_probe_log_err(0, EVENT_EXIST);
+		} else
+			pr_warn("Failed to register probe event(%d)\n", ret);
 		goto end;
 	}
 
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 9c9c83a063b2..782c00eb6859 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1047,11 +1047,36 @@ int trace_probe_init(struct trace_probe *tp, const char *event,
 	return ret;
 }
 
+static struct trace_event_call *
+find_trace_event_call(const char *system, const char *event_name)
+{
+	struct trace_event_call *tp_event;
+	const char *name;
+
+	list_for_each_entry(tp_event, &ftrace_events, list) {
+		if (!tp_event->class->system ||
+		    strcmp(system, tp_event->class->system))
+			continue;
+		name = trace_event_name(tp_event);
+		if (!name || strcmp(event_name, name))
+			continue;
+		return tp_event;
+	}
+
+	return NULL;
+}
+
 int trace_probe_register_event_call(struct trace_probe *tp)
 {
 	struct trace_event_call *call = trace_probe_event_call(tp);
 	int ret;
 
+	lockdep_assert_held(&event_mutex);
+
+	if (find_trace_event_call(trace_probe_group_name(tp),
+				  trace_probe_name(tp)))
+		return -EEXIST;
+
 	ret = register_trace_event(&call->event);
 	if (!ret)
 		return -ENODEV;
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 8adf5f3542a6..66701a92d186 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -404,6 +404,7 @@ extern int traceprobe_define_arg_fields(struct trace_event_call *event_call,
 	C(NO_EVENT_NAME,	"Event name is not specified"),		\
 	C(EVENT_TOO_LONG,	"Event name is too long"),		\
 	C(BAD_EVENT_NAME,	"Event name must follow the same rules as C identifiers"), \
+	C(EVENT_EXIST,		"Given group/event name is already used by another event"), \
 	C(RETVAL_ON_PROBE,	"$retval is not available on probe"),	\
 	C(BAD_STACK_NUM,	"Invalid stack number"),		\
 	C(BAD_ARG_NUM,		"Invalid argument number"),		\
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index d219ba50efbd..225ce569bf8f 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -515,7 +515,11 @@ static int register_trace_uprobe(struct trace_uprobe *tu)
 
 	ret = register_uprobe_event(tu);
 	if (ret) {
-		pr_warn("Failed to register probe event(%d)\n", ret);
+		if (ret == -EEXIST) {
+			trace_probe_log_set_index(0);
+			trace_probe_log_err(0, EVENT_EXIST);
+		} else
+			pr_warn("Failed to register probe event(%d)\n", ret);
 		goto end;
 	}
 
-- 
2.30.2
