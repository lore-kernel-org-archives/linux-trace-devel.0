Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE17C00143
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 03:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0366160EFE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 03:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237376AbhHQDvE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237120AbhHQDvB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 23:51:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FC3660FA0;
        Tue, 17 Aug 2021 03:50:29 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mFq7Q-004OMx-4r; Mon, 16 Aug 2021 23:50:28 -0400
Message-ID: <20210817035027.987567364@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 16 Aug 2021 23:43:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 6/7] tracing/probe: Change traceprobe_set_print_fmt() to take a type
References: <20210817034255.421910614@goodmis.org>
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

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c | 9 +++++++--
 kernel/trace/trace_probe.c  | 3 ++-
 kernel/trace/trace_probe.h  | 7 ++++++-
 kernel/trace/trace_uprobe.c | 8 ++++++--
 4 files changed, 21 insertions(+), 6 deletions(-)

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
index 0916a9964719..a8dcadeaae95 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -912,9 +912,10 @@ static int __set_print_fmt(struct trace_probe *tp, char *buf, int len,
 }
 #undef LEN_OR_ZERO
 
-int traceprobe_set_print_fmt(struct trace_probe *tp, bool is_return)
+int traceprobe_set_print_fmt(struct trace_probe *tp, enum probe_print_type ptype)
 {
 	struct trace_event_call *call = trace_probe_event_call(tp);
+	bool is_return = ptype == PROBE_PRINT_RETURN;
 	int len;
 	char *print_fmt;
 
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
