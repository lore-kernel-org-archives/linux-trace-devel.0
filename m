Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D82C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 18:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 726A964F0D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 18:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhBXSD7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 13:03:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232103AbhBXSD5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 13:03:57 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 798EC64ECE;
        Wed, 24 Feb 2021 18:03:16 +0000 (UTC)
Date:   Wed, 24 Feb 2021 13:03:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Viktor Rosendahl <Viktor.Rosendahl@bmw.de>
Subject: [PATCH] trace-cmd record: Disable all tracing after recording data
Message-ID: <20210224130314.2a515592@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The latency tracers (preemptirqsoff, wakeup_rt, etc) just take a snapshot at
the end of the tracing, and this is done in the record_data() function. But
if "keep" is not set, tracecmd_disable_all_tracing() is called before then.
That function will clear the trace output and with it, the snapshot that
should be recorded for the latency tracers.

As writing to the trace buffer is already disabled by the call to
tracecmd_disable_tracing() above the tracecmd_disable_all_tracing(), there's
no reason to disable all tracing before the record_data() is called. Simply
move the disable tracing after that, and then the information about the
latency tracers snapshot will be stored in the trace.dat file.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index efd96d27..f1a48045 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6363,9 +6363,6 @@ static void record_trace(int argc, char **argv,
 
 	record_stats();
 
-	if (!keep)
-		tracecmd_disable_all_tracing(0);
-
 	if (!latency)
 		wait_threads();
 
@@ -6375,6 +6372,9 @@ static void record_trace(int argc, char **argv,
 	} else
 		print_stats();
 
+	if (!keep)
+		tracecmd_disable_all_tracing(0);
+
 	destroy_stats();
 	finalize_record_trace(ctx);
 }
-- 
2.25.4

