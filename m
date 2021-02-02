Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52508C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Feb 2021 20:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18F4C64E43
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Feb 2021 20:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbhBBUBR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Feb 2021 15:01:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240308AbhBBUAx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 15:00:53 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2216864E4B
        for <linux-trace-devel@vger.kernel.org>; Tue,  2 Feb 2021 20:00:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1l71qN-0095Zt-5G
        for linux-trace-devel@vger.kernel.org; Tue, 02 Feb 2021 15:00:11 -0500
Message-ID: <20210202200011.041636204@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 02 Feb 2021 14:55:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] libtracefs: Have the options_map elements be each on their own line
References: <20210202195458.176697224@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In order to verify the order of the option names in the options_map array,
have each name on its own line. This is much easier to see the mapping when
compared to the enums in tracefs_options_id that represent them.

No function changes.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 51 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 9 deletions(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 7f69cde93115..e2dfc7b8acff 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -20,15 +20,48 @@
 #define TRACE_CTRL	"tracing_on"
 
 static const char * const options_map[] = {
-	"unknown", "annotate", "bin", "blk_cgname", "blk_cgroup", "blk_classic",
-	"block", "context-info", "disable_on_free", "display-graph", "event-fork",
-	"funcgraph-abstime", "funcgraph-cpu", "funcgraph-duration", "funcgraph-irqs",
-	"funcgraph-overhead", "funcgraph-overrun", "funcgraph-proc", "funcgraph-tail",
-	"func_stack_trace", "function-fork", "function-trace", "graph-time", "hex",
-	"irq-info", "latency-format", "markers", "overwrite", "pause-on-trace",
-	"printk-msg-only", "print-parent", "raw", "record-cmd", "record-tgid",
-	"sleep-time", "stacktrace", "sym-addr", "sym-offset", "sym-userobj",
-	"trace_printk", "userstacktrace", "verbose" };
+	"unknown",
+	"annotate",
+	"bin",
+	"blk_cgname",
+	"blk_cgroup",
+	"blk_classic",
+	"block",
+	"context-info",
+	"disable_on_free",
+	"display-graph",
+	"event-fork",
+	"funcgraph-abstime",
+	"funcgraph-cpu",
+	"funcgraph-duration",
+	"funcgraph-irqs",
+	"funcgraph-overhead",
+	"funcgraph-overrun",
+	"funcgraph-proc",
+	"funcgraph-tail",
+	"func_stack_trace",
+	"function-fork",
+	"function-trace",
+	"graph-time",
+	"hex",
+	"irq-info",
+	"latency-format",
+	"markers",
+	"overwrite",
+	"pause-on-trace",
+	"printk-msg-only",
+	"print-parent",
+	"raw",
+	"record-cmd",
+	"record-tgid",
+	"sleep-time",
+	"stacktrace",
+	"sym-addr",
+	"sym-offset",
+	"sym-userobj",
+	"trace_printk",
+	"userstacktrace",
+	"verbose" };
 
 static int trace_on_off(int fd, bool on)
 {
-- 
2.29.2


