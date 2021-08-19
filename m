Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B353C43216
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81032610FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhHSETU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 00:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhHSETS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 00:19:18 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1492C610FE;
        Thu, 19 Aug 2021 04:18:43 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mGZVq-004dxh-2Z; Thu, 19 Aug 2021 00:18:42 -0400
Message-ID: <20210819041841.922871824@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 19 Aug 2021 00:13:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>
Subject: [PATCH v7 05/10] tracing/probes: Use struct_size() instead of defining custom macros
References: <20210819041321.105110033@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Remove SIZEOF_TRACE_KPROBE() and SIZEOF_TRACE_UPROBE() and use
struct_size() as that's what it is made for. No need to have custom
macros. Especially since struct_size() has some extra memory checks for
correctness.

Link: https://lkml.kernel.org/r/20210817035027.795000217@goodmis.org

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c | 6 +-----
 kernel/trace/trace_uprobe.c | 6 +-----
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index ed1e3c2087ab..ca726c9d0859 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -80,10 +80,6 @@ static struct trace_kprobe *to_trace_kprobe(struct dyn_event *ev)
 	for_each_dyn_event(dpos)		\
 		if (is_trace_kprobe(dpos) && (pos = to_trace_kprobe(dpos)))
 
-#define SIZEOF_TRACE_KPROBE(n)				\
-	(offsetof(struct trace_kprobe, tp.args) +	\
-	(sizeof(struct probe_arg) * (n)))
-
 static nokprobe_inline bool trace_kprobe_is_return(struct trace_kprobe *tk)
 {
 	return tk->rp.handler != NULL;
@@ -265,7 +261,7 @@ static struct trace_kprobe *alloc_trace_kprobe(const char *group,
 	struct trace_kprobe *tk;
 	int ret = -ENOMEM;
 
-	tk = kzalloc(SIZEOF_TRACE_KPROBE(nargs), GFP_KERNEL);
+	tk = kzalloc(struct_size(tk, tp.args, nargs), GFP_KERNEL);
 	if (!tk)
 		return ERR_PTR(ret);
 
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 93ff96541971..590bb9a02f8d 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -83,10 +83,6 @@ static struct trace_uprobe *to_trace_uprobe(struct dyn_event *ev)
 	for_each_dyn_event(dpos)		\
 		if (is_trace_uprobe(dpos) && (pos = to_trace_uprobe(dpos)))
 
-#define SIZEOF_TRACE_UPROBE(n)				\
-	(offsetof(struct trace_uprobe, tp.args) +	\
-	(sizeof(struct probe_arg) * (n)))
-
 static int register_uprobe_event(struct trace_uprobe *tu);
 static int unregister_uprobe_event(struct trace_uprobe *tu);
 
@@ -340,7 +336,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 	struct trace_uprobe *tu;
 	int ret;
 
-	tu = kzalloc(SIZEOF_TRACE_UPROBE(nargs), GFP_KERNEL);
+	tu = kzalloc(struct_size(tu, tp.args, nargs), GFP_KERNEL);
 	if (!tu)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.30.2
