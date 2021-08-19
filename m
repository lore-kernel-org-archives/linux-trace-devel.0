Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C1CC432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B3946112F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhHSETU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 00:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229687AbhHSETS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 00:19:18 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A9BA61158;
        Thu, 19 Aug 2021 04:18:43 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mGZVq-004dyF-8X; Thu, 19 Aug 2021 00:18:42 -0400
Message-ID: <20210819041842.104626301@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 19 Aug 2021 00:13:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>
Subject: [PATCH v7 06/10] tracing/probe: Change traceprobe_set_print_fmt() to take a type
References: <20210819041321.105110033@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of a boolean "is_return" have traceprobe_set_print_fmt() take a
type (currently just PROBE_PRINT_NORMAL and PROBE_PRINT_RETURN). This will
simplify adding different types. For example, the development of the
event_probe, will need its own type as it prints an event, and not an IP.

Link: https://lkml.kernel.org/r/20210817035027.987567364@goodmis.org

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
Changes since v6:

 - Incorporated more of the ptype enum further into the functions.

 kernel/trace/trace_kprobe.c |  9 +++++++--
 kernel/trace/trace_probe.c  | 18 ++++++++++++------
 kernel/trace/trace_probe.h  |  7 ++++++-
 kernel/trace/trace_uprobe.c |  8 ++++++--
 4 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index ca726c9d0859..c6fe7a6e3f35 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -742,6 +742,7 @@ static int __trace_kprobe_create(int argc, const char *argv[])
 	bool is_return = false;
 	char *symbol = NULL, *tmp = NULL;
 	const char *event = NULL, *group = KPROBE_EVENT_SYSTEM;
+	enum probe_print_type ptype;
 	int maxactive = 0;
 	long offset = 0;
 	void *addr = NULL;
@@ -875,7 +876,8 @@ static int __trace_kprobe_create(int argc, const char *argv[])
 			goto error;	/* This can be -ENOMEM */
 	}
 
-	ret = traceprobe_set_print_fmt(&tk->tp, is_return);
+	ptype = is_return ? PROBE_PRINT_RETURN : PROBE_PRINT_NORMAL;
+	ret = traceprobe_set_print_fmt(&tk->tp, ptype);
 	if (ret < 0)
 		goto error;
 
@@ -1799,6 +1801,7 @@ struct trace_event_call *
 create_local_trace_kprobe(char *func, void *addr, unsigned long offs,
 			  bool is_return)
 {
+	enum probe_print_type ptype;
 	struct trace_kprobe *tk;
 	int ret;
 	char *event;
@@ -1822,7 +1825,9 @@ create_local_trace_kprobe(char *func, void *addr, unsigned long offs,
 
 	init_trace_event_call(tk);
 
-	if (traceprobe_set_print_fmt(&tk->tp, trace_kprobe_is_return(tk)) < 0) {
+	ptype = trace_kprobe_is_return(tk) ?
+		PROBE_PRINT_RETURN : PROBE_PRINT_NORMAL;
+	if (traceprobe_set_print_fmt(&tk->tp, ptype) < 0) {
 		ret = -ENOMEM;
 		goto error;
 	}
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 0916a9964719..9c9c83a063b2 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -851,19 +851,25 @@ int traceprobe_update_arg(struct probe_arg *arg)
 /* When len=0, we just calculate the needed length */
 #define LEN_OR_ZERO (len ? len - pos : 0)
 static int __set_print_fmt(struct trace_probe *tp, char *buf, int len,
-			   bool is_return)
+			   enum probe_print_type ptype)
 {
 	struct probe_arg *parg;
 	int i, j;
 	int pos = 0;
 	const char *fmt, *arg;
 
-	if (!is_return) {
+	switch (ptype) {
+	case PROBE_PRINT_NORMAL:
 		fmt = "(%lx)";
 		arg = "REC->" FIELD_STRING_IP;
-	} else {
+		break;
+	case PROBE_PRINT_RETURN:
 		fmt = "(%lx <- %lx)";
 		arg = "REC->" FIELD_STRING_FUNC ", REC->" FIELD_STRING_RETIP;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
 	}
 
 	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
@@ -912,20 +918,20 @@ static int __set_print_fmt(struct trace_probe *tp, char *buf, int len,
 }
 #undef LEN_OR_ZERO
 
-int traceprobe_set_print_fmt(struct trace_probe *tp, bool is_return)
+int traceprobe_set_print_fmt(struct trace_probe *tp, enum probe_print_type ptype)
 {
 	struct trace_event_call *call = trace_probe_event_call(tp);
 	int len;
 	char *print_fmt;
 
 	/* First: called with 0 length to calculate the needed length */
-	len = __set_print_fmt(tp, NULL, 0, is_return);
+	len = __set_print_fmt(tp, NULL, 0, ptype);
 	print_fmt = kmalloc(len + 1, GFP_KERNEL);
 	if (!print_fmt)
 		return -ENOMEM;
 
 	/* Second: actually write the @print_fmt */
-	__set_print_fmt(tp, print_fmt, len + 1, is_return);
+	__set_print_fmt(tp, print_fmt, len + 1, ptype);
 	call->print_fmt = print_fmt;
 
 	return 0;
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 42aa084902fa..8adf5f3542a6 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -363,7 +363,12 @@ extern int traceprobe_split_symbol_offset(char *symbol, long *offset);
 int traceprobe_parse_event_name(const char **pevent, const char **pgroup,
 				char *buf, int offset);
 
-extern int traceprobe_set_print_fmt(struct trace_probe *tp, bool is_return);
+enum probe_print_type {
+	PROBE_PRINT_NORMAL,
+	PROBE_PRINT_RETURN,
+};
+
+extern int traceprobe_set_print_fmt(struct trace_probe *tp, enum probe_print_type ptype);
 
 #ifdef CONFIG_PERF_EVENTS
 extern struct trace_event_call *
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 590bb9a02f8d..09f8ca7f7ba0 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -536,6 +536,7 @@ static int __trace_uprobe_create(int argc, const char **argv)
 	const char *event = NULL, *group = UPROBE_EVENT_SYSTEM;
 	char *arg, *filename, *rctr, *rctr_end, *tmp;
 	char buf[MAX_EVENT_NAME_LEN];
+	enum probe_print_type ptype;
 	struct path path;
 	unsigned long offset, ref_ctr_offset;
 	bool is_return = false;
@@ -687,7 +688,8 @@ static int __trace_uprobe_create(int argc, const char **argv)
 			goto error;
 	}
 
-	ret = traceprobe_set_print_fmt(&tu->tp, is_ret_probe(tu));
+	ptype = is_ret_probe(tu) ? PROBE_PRINT_RETURN : PROBE_PRINT_NORMAL;
+	ret = traceprobe_set_print_fmt(&tu->tp, ptype);
 	if (ret < 0)
 		goto error;
 
@@ -1578,6 +1580,7 @@ struct trace_event_call *
 create_local_trace_uprobe(char *name, unsigned long offs,
 			  unsigned long ref_ctr_offset, bool is_return)
 {
+	enum probe_print_type ptype;
 	struct trace_uprobe *tu;
 	struct path path;
 	int ret;
@@ -1612,7 +1615,8 @@ create_local_trace_uprobe(char *name, unsigned long offs,
 	tu->filename = kstrdup(name, GFP_KERNEL);
 	init_trace_event_call(tu);
 
-	if (traceprobe_set_print_fmt(&tu->tp, is_ret_probe(tu)) < 0) {
+	ptype = is_ret_probe(tu) ? PROBE_PRINT_RETURN : PROBE_PRINT_NORMAL;
+	if (traceprobe_set_print_fmt(&tu->tp, ptype) < 0) {
 		ret = -ENOMEM;
 		goto error;
 	}
-- 
2.30.2
