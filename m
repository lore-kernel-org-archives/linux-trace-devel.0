Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AA89C43462
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 23:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B18161078
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 23:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhCaXHm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 19:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232207AbhCaXH3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:29 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49B4F61076
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 23:07:29 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lRjvs-003g68-AW
        for linux-trace-devel@vger.kernel.org; Wed, 31 Mar 2021 19:07:28 -0400
Message-ID: <20210331230728.211232789@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 31 Mar 2021 19:06:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] trace-cmd: Have tracecmd_tsync_free() free even with no context
References: <20210331230610.035418770@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

tracecmd_tsync_free() incorrectly exits the function if the tsync has no
context. But it may still need to free up the resources in that case. Do
not leak memory if the context failed to be created.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-timesync.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 4ed283eb1fb8..24984fb17dab 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -513,25 +513,28 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 	struct clock_sync_context *tsync_context;
 	struct tsync_proto *proto;
 
-	if (!tsync || !tsync->context)
+	if (!tsync)
 		return;
+
 	tsync_context = (struct clock_sync_context *)tsync->context;
 
 	proto = tsync_proto_find(tsync->proto_name);
 	if (proto && proto->clock_sync_free)
 		proto->clock_sync_free(tsync);
 
-	clock_synch_delete_instance(tsync_context->instance);
-	tsync_context->instance = NULL;
-
-	free(tsync_context->sync_ts);
-	free(tsync_context->sync_offsets);
-	free(tsync_context->sync_scalings);
-	tsync_context->sync_ts = NULL;
-	tsync_context->sync_offsets = NULL;
-	tsync_context->sync_scalings = NULL;
-	tsync_context->sync_count = 0;
-	tsync_context->sync_size = 0;
+	if (tsync_context) {
+		clock_synch_delete_instance(tsync_context->instance);
+		tsync_context->instance = NULL;
+
+		free(tsync_context->sync_ts);
+		free(tsync_context->sync_offsets);
+		free(tsync_context->sync_scalings);
+		tsync_context->sync_ts = NULL;
+		tsync_context->sync_offsets = NULL;
+		tsync_context->sync_scalings = NULL;
+		tsync_context->sync_count = 0;
+		tsync_context->sync_size = 0;
+	}
 	pthread_mutex_destroy(&tsync->lock);
 	pthread_cond_destroy(&tsync->cond);
 	pthread_barrier_destroy(&tsync->first_sync);
-- 
2.30.1


