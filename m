Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAD46C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 21:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A543361205
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 21:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbhDGVyk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Apr 2021 17:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234432AbhDGVyj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Apr 2021 17:54:39 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1666961205
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Apr 2021 21:54:29 +0000 (UTC)
Date:   Wed, 7 Apr 2021 17:54:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record: Have -d only touch the instance its for
Message-ID: <20210407175427.536f0423@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The -d option for trace-cmd record disables the function tracing option.
It currently only does it for the top level, which does not affect the
instances. It should only disable the instances it is for and not touch
the top level if the top level is not part of the command line.

Also have set_ftrace return the result of set_ftrace_proc() if it was
called.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 20cb5424..fd03a605 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -829,13 +829,14 @@ static int set_ftrace_proc(int set)
 	return ret;
 }
 
-static int set_ftrace(int set, int use_proc)
+static int set_ftrace(struct buffer_instance *instance, int set, int use_proc)
 {
 	char *path;
 	int ret;
 
-	/* First check if the function-trace option exists */
-	path = tracefs_get_tracing_file("options/function-trace");
+	path = tracefs_instance_get_file(instance->tracefs, "options/function-trace");
+	if (!path)
+		return -1;
 	ret = set_ftrace_enable(path, set);
 	tracefs_put_tracing_file(path);
 
@@ -843,7 +844,7 @@ static int set_ftrace(int set, int use_proc)
 	if (ret < 0 || set || use_proc)
 		ret = set_ftrace_proc(set);
 
-	return 0;
+	return ret;
 }
 
 static int write_file(const char *file, const char *str)
@@ -6653,7 +6654,7 @@ static void record_trace(int argc, char **argv,
 	page_size = getpagesize();
 
 	if (!is_guest(ctx->instance))
-		fset = set_ftrace(!ctx->disable, ctx->total_disable);
+		fset = set_ftrace(ctx->instance, !ctx->disable, ctx->total_disable);
 	if (!IS_CMDSET(ctx))
 		tracecmd_disable_all_tracing(1);
 
-- 
2.29.2

