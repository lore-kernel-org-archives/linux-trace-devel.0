Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E8EC433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Feb 2021 20:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B25364E43
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Feb 2021 20:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240232AbhBBUBc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Feb 2021 15:01:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240307AbhBBUAx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 15:00:53 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15A7464E2C
        for <linux-trace-devel@vger.kernel.org>; Tue,  2 Feb 2021 20:00:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1l71qN-0095ZO-0Y
        for linux-trace-devel@vger.kernel.org; Tue, 02 Feb 2021 15:00:11 -0500
Message-ID: <20210202200010.887769022@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 02 Feb 2021 14:54:59 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] tracefs: Use new BUILD_BUG_ON() and ARRAY_SIZE() macros for
 options_map intergity
References: <20210202195458.176697224@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of having the options_map use TRACEFS_OPTIONS_MAX as its index, have
the array extend by the elements, and use the new macros BUILD_BUG_ON() and
ARRAY_SIZE() to make sure that the array always is the same size as the
TRACEFS_OPTIONS_MAX.

No functional changes.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs-local.h | 6 ++++++
 src/tracefs-tools.c     | 5 ++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 3a7ec32a8853..187870e7c491 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -8,6 +8,12 @@
 
 #define __hidden __attribute__((visibility ("hidden")))
 
+#define ARRAY_SIZE(array) (sizeof(array) / sizeof((array)[0]))
+
+/* Will cause a division by zero warning if cond is true */
+#define BUILD_BUG_ON(cond)			\
+	do { if (!(1/!(cond))) { } } while (0)
+
 /* Can be overridden */
 void warning(const char *fmt, ...);
 
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 6e7fce53cef1..7f69cde93115 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -19,7 +19,7 @@
 
 #define TRACE_CTRL	"tracing_on"
 
-static const char * const options_map[TRACEFS_OPTION_MAX] = {
+static const char * const options_map[] = {
 	"unknown", "annotate", "bin", "blk_cgname", "blk_cgroup", "blk_classic",
 	"block", "context-info", "disable_on_free", "display-graph", "event-fork",
 	"funcgraph-abstime", "funcgraph-cpu", "funcgraph-duration", "funcgraph-irqs",
@@ -132,6 +132,9 @@ int tracefs_trace_off_fd(int fd)
  */
 const char *tracefs_option_name(enum tracefs_option_id id)
 {
+	/* Make sure options map contains all the options */
+	BUILD_BUG_ON(ARRAY_SIZE(options_map) != TRACEFS_OPTION_MAX);
+
 	if (id < TRACEFS_OPTION_MAX)
 		return options_map[id];
 
-- 
2.29.2


