Return-Path: <SRS0=h7mL=QS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A068C282DA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Feb 2019 01:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38707217D9
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Feb 2019 01:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfBKBV4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 10 Feb 2019 20:21:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfBKBV4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 10 Feb 2019 20:21:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3980A2176F;
        Mon, 11 Feb 2019 01:21:55 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92-RC5)
        (envelope-from <rostedt@goodmis.org>)
        id 1gt0IE-0003xW-Bw; Sun, 10 Feb 2019 20:21:54 -0500
Message-Id: <20190211012154.262506802@goodmis.org>
User-Agent: quilt/0.65
Date:   Sun, 10 Feb 2019 20:18:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 4/4] kernel-shark: Add sched_waking event processing to sched_waking
References: <20190211011807.714634783@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

It is now more common to enable the sched_waking event than to use the
sched_wakeup or sched_wakeup_new, as it encompasses both. But the sched
plugin does not handle that. Fix that by including the sched_waking event as
an event to use for processing schedule wakeup events.

Signen-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/src/plugins/sched_events.c | 6 ++++++
 kernel-shark/src/plugins/sched_events.h | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
index 0cfe5b5367e2..14f8edb2836b 100644
--- a/kernel-shark/src/plugins/sched_events.c
+++ b/kernel-shark/src/plugins/sched_events.c
@@ -85,6 +85,10 @@ static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
 					   &plugin_ctx->sched_wakeup_new_event,
 					   &plugin_ctx->sched_wakeup_new_pid_field);
 
+	wakeup_found |= define_wakeup_event(kshark_ctx->pevent, "sched_waking",
+					   &plugin_ctx->sched_waking_event,
+					   &plugin_ctx->sched_waking_pid_field);
+
 	if (!wakeup_found)
 		return false;
 
@@ -158,10 +162,12 @@ static bool wakeup_match_rec_pid(struct plugin_sched_context *plugin_ctx,
 				 int pid)
 {
 	struct tep_event *wakeup_events[] = {
+		plugin_ctx->sched_waking_event,
 		plugin_ctx->sched_wakeup_event,
 		plugin_ctx->sched_wakeup_new_event,
 	};
 	struct tep_format_field *wakeup_fields[] = {
+		plugin_ctx->sched_waking_pid_field,
 		plugin_ctx->sched_wakeup_pid_field,
 		plugin_ctx->sched_wakeup_new_pid_field,
 	};
diff --git a/kernel-shark/src/plugins/sched_events.h b/kernel-shark/src/plugins/sched_events.h
index 0beb63fe2b48..dbc9963cbc4e 100644
--- a/kernel-shark/src/plugins/sched_events.h
+++ b/kernel-shark/src/plugins/sched_events.h
@@ -51,6 +51,12 @@ struct plugin_sched_context {
 	/** Pointer to the sched_wakeup_new_pid_field format descriptor. */
 	struct tep_format_field	*sched_wakeup_new_pid_field;
 
+	/** Pointer to the sched_waking_event object. */
+	struct tep_event        *sched_waking_event;
+
+	/** Pointer to the sched_waking_pid_field format descriptor. */
+	struct tep_format_field *sched_waking_pid_field;
+
 	/** List of Data collections used by this plugin. */
 	struct kshark_entry_collection	*collections;
 
-- 
2.20.1


