Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 508E2C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 20:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1440C64E6C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Feb 2021 20:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhBQUvR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:51:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232050AbhBQUvR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 15:51:17 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E90A64E2E
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Feb 2021 20:50:36 +0000 (UTC)
Date:   Wed, 17 Feb 2021 15:50:34 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd/timesync: Remove double check of finding the
 protocol
Message-ID: <20210217155034.04f6891f@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In the two locations that call clock_context_init(), the protocol is
searched for via tsync_proto_find() to test if it has clock_sync_calc set.
clock_context_init() then does another tsync_proto_find(). Instead of having
this duplicate search, have clock_context_init() do the search and check if
clock_sync_calc is set, and return the protocol back to the caller on
success.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-timesync.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 9cbed775..8d01c0bc 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -327,7 +327,8 @@ clock_synch_delete_instance(struct tracefs_instance *inst)
 	tracefs_instance_free(inst);
 }
 
-static int clock_context_init(struct tracecmd_time_sync *tsync, bool guest)
+static int clock_context_init(struct tracecmd_time_sync *tsync,
+			      struct tsync_proto **proto, bool guest)
 {
 	struct clock_sync_context *clock = NULL;
 	struct tsync_proto *protocol;
@@ -336,7 +337,7 @@ static int clock_context_init(struct tracecmd_time_sync *tsync, bool guest)
 		return 0;
 
 	protocol = tsync_proto_find(tsync->proto_name);
-	if (!protocol)
+	if (!protocol || !protocol->clock_sync_calc)
 		return -1;
 
 	clock = calloc(1, sizeof(struct clock_sync_context));
@@ -359,6 +360,8 @@ static int clock_context_init(struct tracecmd_time_sync *tsync, bool guest)
 	if (protocol->clock_sync_init && protocol->clock_sync_init(tsync) < 0)
 		goto error;
 
+	*proto = protocol;
+
 	return 0;
 error:
 	tsync->context = NULL;
@@ -432,11 +435,7 @@ void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync)
 	unsigned int command;
 	int ret;
 
-	proto = tsync_proto_find(tsync->proto_name);
-	if (!proto || !proto->clock_sync_calc)
-		return;
-
-	clock_context_init(tsync, true);
+	clock_context_init(tsync, &proto, true);
 	if (!tsync->context)
 		return;
 
@@ -534,11 +533,7 @@ void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
 	bool end = false;
 	int ret;
 
-	proto = tsync_proto_find(tsync->proto_name);
-	if (!proto || !proto->clock_sync_calc)
-		return;
-
-	clock_context_init(tsync, false);
+	clock_context_init(tsync, &proto, false);
 	if (!tsync->context)
 		return;
 
-- 
2.25.4

