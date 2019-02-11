Return-Path: <SRS0=h7mL=QS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3890FC282D7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Feb 2019 01:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E2D821773
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Feb 2019 01:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfBKBVz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 10 Feb 2019 20:21:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbfBKBVz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 10 Feb 2019 20:21:55 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7F77214DA;
        Mon, 11 Feb 2019 01:21:54 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92-RC5)
        (envelope-from <rostedt@goodmis.org>)
        id 1gt0ID-0003w4-Un; Sun, 10 Feb 2019 20:21:53 -0500
Message-Id: <20190211012153.848572065@goodmis.org>
User-Agent: quilt/0.65
Date:   Sun, 10 Feb 2019 20:18:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/4] kernel-shark: Remove testing of "success" field of wakeup events
References: <20190211011807.714634783@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Since 2011 (or Linux version 3.0) the sched wakeup event "success" field has
been hardcoded to true (or 1). There's no reason to waste cycles checking it
in any newer kernel, which is most of them. Just ignore it. Even when
running on older kernels which may have a success=0 value, the algorithm
should still work.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/src/plugins/sched_events.c | 25 +++----------------------
 kernel-shark/src/plugins/sched_events.h |  8 --------
 2 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
index c0328e804911..5b1af7722624 100644
--- a/kernel-shark/src/plugins/sched_events.c
+++ b/kernel-shark/src/plugins/sched_events.c
@@ -68,9 +68,6 @@ static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
 	plugin_ctx->sched_wakeup_pid_field =
 		tep_find_any_field(event, "pid");
 
-	plugin_ctx->sched_wakeup_success_field =
-		tep_find_field(event, "success");
-
 	event = tep_find_event_by_name(plugin_ctx->pevent,
 				       "sched", "sched_wakeup_new");
 	if (!event)
@@ -80,9 +77,6 @@ static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
 	plugin_ctx->sched_wakeup_new_pid_field =
 		tep_find_any_field(event, "pid");
 
-	plugin_ctx->sched_wakeup_new_success_field =
-		tep_find_field(event, "success");
-
 	plugin_ctx->second_pass_hash = tracecmd_filter_id_hash_alloc();
 
 	return true;
@@ -175,8 +169,7 @@ bool plugin_wakeup_match_rec_pid(struct kshark_context *kshark_ctx,
 {
 	struct plugin_sched_context *plugin_ctx;
 	struct tep_record *record = NULL;
-	unsigned long long val;
-	int ret, wakeup_pid = -1;
+	int wakeup_pid = -1;
 
 	plugin_ctx = plugin_sched_context_handler;
 	if (!plugin_ctx)
@@ -185,25 +178,13 @@ bool plugin_wakeup_match_rec_pid(struct kshark_context *kshark_ctx,
 	if (plugin_ctx->sched_wakeup_event &&
 	    e->event_id == plugin_ctx->sched_wakeup_event->id) {
 		record = tracecmd_read_at(kshark_ctx->handle, e->offset, NULL);
-
-		/* We only want those that actually woke up the task. */
-		ret = tep_read_number_field(plugin_ctx->sched_wakeup_success_field,
-					    record->data, &val);
-
-		if (ret == 0 && val)
-			wakeup_pid = plugin_get_rec_wakeup_pid(record);
+		wakeup_pid = plugin_get_rec_wakeup_pid(record);
 	}
 
 	if (plugin_ctx->sched_wakeup_new_event &&
 	    e->event_id == plugin_ctx->sched_wakeup_new_event->id) {
 		record = tracecmd_read_at(kshark_ctx->handle, e->offset, NULL);
-
-		/* We only want those that actually woke up the task. */
-		ret = tep_read_number_field(plugin_ctx->sched_wakeup_new_success_field,
-					    record->data, &val);
-
-		if (ret == 0 && val)
-			wakeup_pid = plugin_get_rec_wakeup_new_pid(record);
+		wakeup_pid = plugin_get_rec_wakeup_new_pid(record);
 	}
 
 	free_record(record);
diff --git a/kernel-shark/src/plugins/sched_events.h b/kernel-shark/src/plugins/sched_events.h
index fb1849ee8ffb..0beb63fe2b48 100644
--- a/kernel-shark/src/plugins/sched_events.h
+++ b/kernel-shark/src/plugins/sched_events.h
@@ -45,20 +45,12 @@ struct plugin_sched_context {
 	/** Pointer to the sched_wakeup_pid_field format descriptor. */
 	struct tep_format_field	*sched_wakeup_pid_field;
 
-	/** Pointer to the sched_wakeup_success_field format descriptor. */
-	struct tep_format_field	*sched_wakeup_success_field;
-
 	/** Pointer to the sched_wakeup_new_event object. */
 	struct tep_event	*sched_wakeup_new_event;
 
 	/** Pointer to the sched_wakeup_new_pid_field format descriptor. */
 	struct tep_format_field	*sched_wakeup_new_pid_field;
 
-	/**
-	 * Pointer to the sched_wakeup_new_success_field format descriptor.
-	 */
-	struct tep_format_field	*sched_wakeup_new_success_field;
-
 	/** List of Data collections used by this plugin. */
 	struct kshark_entry_collection	*collections;
 
-- 
2.20.1


