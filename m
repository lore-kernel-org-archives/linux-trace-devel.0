Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A28AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Sep 2021 19:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FF5C61051
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Sep 2021 19:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344489AbhIFTOq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 15:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343770AbhIFTO0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 15:14:26 -0400
X-Greylist: delayed 1386 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 06 Sep 2021 12:13:21 PDT
Received: from metanate.com (unknown [IPv6:2001:8b0:1628:5005::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B229FC061575
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Sep 2021 12:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=metanate.com; s=stronger; h=Content-Transfer-Encoding:Message-Id:Date:
        Subject:Cc:To:From:Content-Type:Reply-To:Content-ID:Content-Description:
        In-Reply-To:References; bh=1OIV/i1l4L8GBUJYL7RyiWh3mL7kZBStQjeObXp+GpI=; b=P4
        1jv+5p5kWRJv2Wr/q4hCQNFYLUnAExOKm2LhV/hIHn3qv8JhT82RUjPU8/yZENZ5Ul9iejyuptliA
        khdSnRMCHak8PIStueV/QLzpSQ9+1Uvd+YviBDth0QgiM7futb482UVJnwy3OJA39JDKNoMrn7pjb
        K2C+I3zv3BY6VB3Fy7JYFt+FTZvVyilZxm+CfPNxswwb2/OpXmaWGGOGw7vTzxOKG/2yS+BKALyV7
        f1dULVk34EIV88tmh9cfJZoPn6bLWoE0225s6ibSZ5IukLht9v7pACMogCi/IkknSgupovKtuPX2N
        c+3EEbvKOeMcHsF4at934E+SIY67Wt3Q==;
Received: from [81.174.171.191] (helo=donbot.metanate.com)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john@metanate.com>)
        id 1mNJh7-0008AM-SB; Mon, 06 Sep 2021 19:50:13 +0100
From:   John Keeping <john@metanate.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     John Keeping <john@metanate.com>
Subject: [PATCH] kernel-shark: Handle traces with sched_switch and no sched_waking
Date:   Mon,  6 Sep 2021 19:50:05 +0100
Message-Id: <20210906185005.3130298-1-john@metanate.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated: YES
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

plugin_sched_init_context() is careful to make the sched_waking (or
sched_wakeup{,_new}) event optional but the initializer blindly
dereferences plugin_ctx->sched_waking_event which is null if no waking
event is found.

Add the necessary checks to avoid segfaults when (de)initializing the
plugin.

Signed-off-by: John Keeping <john@metanate.com>
---
 src/plugins/sched_events.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index 83c2520..198ed49 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -193,9 +193,11 @@ int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
 				      plugin_ctx->sched_switch_event->id,
 				      plugin_sched_swith_action);
 
-	kshark_register_event_handler(stream,
-				      plugin_ctx->sched_waking_event->id,
-				      plugin_sched_wakeup_action);
+	if (plugin_ctx->sched_waking_event) {
+		kshark_register_event_handler(stream,
+					      plugin_ctx->sched_waking_event->id,
+					      plugin_sched_wakeup_action);
+	}
 
 	kshark_register_draw_handler(stream, plugin_draw);
 
@@ -213,9 +215,11 @@ int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
 						plugin_ctx->sched_switch_event->id,
 						plugin_sched_swith_action);
 
-		kshark_unregister_event_handler(stream,
-						plugin_ctx->sched_waking_event->id,
-						plugin_sched_wakeup_action);
+		if (plugin_ctx->sched_waking_event) {
+			kshark_unregister_event_handler(stream,
+							plugin_ctx->sched_waking_event->id,
+							plugin_sched_wakeup_action);
+		}
 
 		kshark_unregister_draw_handler(stream, plugin_draw);
 
-- 
2.33.0

