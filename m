Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75126C4360F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 15:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F641222DA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 15:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfBNP4j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 10:56:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbfBNP4i (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 10:56:38 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 786DF222DA;
        Thu, 14 Feb 2019 15:56:37 +0000 (UTC)
Date:   Thu, 14 Feb 2019 10:56:35 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] kernel-shark: sched-plugin: Initialize
 plugin_sched_context_handler to zeros
Message-ID: <20190214105635.3e0e1570@gandalf.local.home>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Now that the sched plugin only requires a single wakeup event to process the
wakeup latency boxes, there's no guarantee that all the wakeup events saved
in plugin_sched_context_handler will be initialized.

Allocate plugin_sched_context_handler to zeros with calloc() instead of
malloc() to make sure the pointers it has are NULL and not left
uninitialized.

Fixes: e50d3bbfc9a4 ("kernel-shark: Add sched_waking event processing to sched_waking")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/src/plugins/sched_events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
index 14f8edb2..68734d4d 100644
--- a/kernel-shark/src/plugins/sched_events.c
+++ b/kernel-shark/src/plugins/sched_events.c
@@ -49,7 +49,7 @@ static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
 	assert(plugin_sched_context_handler == NULL);
 
 	plugin_sched_context_handler =
-		malloc(sizeof(*plugin_sched_context_handler));
+		calloc(1, sizeof(*plugin_sched_context_handler));
 	if (!plugin_sched_context_handler) {
 		fprintf(stderr,
 			"Failed to allocate memory for plugin_sched_context.\n");
-- 
2.20.1

