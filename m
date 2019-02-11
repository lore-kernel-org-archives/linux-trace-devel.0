Return-Path: <SRS0=h7mL=QS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83FFC282CC
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Feb 2019 01:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1FAF21773
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Feb 2019 01:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfBKBV4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 10 Feb 2019 20:21:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbfBKBV4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 10 Feb 2019 20:21:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E708521736;
        Mon, 11 Feb 2019 01:21:54 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92-RC5)
        (envelope-from <rostedt@goodmis.org>)
        id 1gt0IE-0003wY-34; Sun, 10 Feb 2019 20:21:54 -0500
Message-Id: <20190211012153.982548008@goodmis.org>
User-Agent: quilt/0.65
Date:   Sun, 10 Feb 2019 20:18:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 2/4] kernel-shark: Consolidate duplicate code of the sched_wakeup events
References: <20190211011807.714634783@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The logic used for sched_wakeup and sched_wakeup_new events are basically
the same. Create helper functions to be called to do the duplicate code with
just passing in the parameters that are unique to the events.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/src/plugins/sched_events.c | 106 +++++++++++++++---------
 1 file changed, 66 insertions(+), 40 deletions(-)

diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
index 5b1af7722624..0f5c08e3508d 100644
--- a/kernel-shark/src/plugins/sched_events.c
+++ b/kernel-shark/src/plugins/sched_events.c
@@ -23,10 +23,27 @@
 /** Plugin context instance. */
 struct plugin_sched_context *plugin_sched_context_handler = NULL;
 
+static bool define_wakeup_event(struct tep_handle *tep, const char *wakeup_name,
+				struct tep_event **wakeup_event,
+				struct tep_format_field **pid_field)
+{
+	struct tep_event *event;
+
+	event = tep_find_event_by_name(tep, "sched", wakeup_name);
+	if (!event)
+		return false;
+
+	*wakeup_event = event;
+	*pid_field = tep_find_any_field(event, "pid");
+
+	return true;
+}
+
 static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
 {
 	struct plugin_sched_context *plugin_ctx;
 	struct tep_event *event;
+	bool wakeup_found;
 
 	/* No context should exist when we initialize the plugin. */
 	assert(plugin_sched_context_handler == NULL);
@@ -59,23 +76,17 @@ static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
 	plugin_ctx->sched_switch_prev_state_field =
 		tep_find_field(event, "prev_state");
 
-	event = tep_find_event_by_name(plugin_ctx->pevent,
-				      "sched", "sched_wakeup");
-	if (!event)
-		return false;
 
-	plugin_ctx->sched_wakeup_event = event;
-	plugin_ctx->sched_wakeup_pid_field =
-		tep_find_any_field(event, "pid");
+	wakeup_found = define_wakeup_event(kshark_ctx->pevent, "sched_wakeup",
+					   &plugin_ctx->sched_wakeup_event,
+					   &plugin_ctx->sched_wakeup_pid_field);
 
-	event = tep_find_event_by_name(plugin_ctx->pevent,
-				       "sched", "sched_wakeup_new");
-	if (!event)
-		return false;
+	wakeup_found |= define_wakeup_event(kshark_ctx->pevent, "sched_wakeup_new",
+					   &plugin_ctx->sched_wakeup_new_event,
+					   &plugin_ctx->sched_wakeup_new_pid_field);
 
-	plugin_ctx->sched_wakeup_new_event = event;
-	plugin_ctx->sched_wakeup_new_pid_field =
-		tep_find_any_field(event, "pid");
+	if (!wakeup_found)
+		return false;
 
 	plugin_ctx->second_pass_hash = tracecmd_filter_id_hash_alloc();
 
@@ -139,17 +150,51 @@ static void plugin_register_command(struct kshark_context *kshark_ctx,
 			tep_register_comm(kshark_ctx->pevent, comm, pid);
 }
 
-static int plugin_get_rec_wakeup_new_pid(struct tep_record *record)
+int find_wakeup_pid(struct kshark_context *kshark_ctx, struct kshark_entry *e,
+		    struct tep_event *wakeup_event, struct tep_format_field *pid_field)
 {
-	struct plugin_sched_context *plugin_ctx =
-		plugin_sched_context_handler;
+	struct tep_record *record;
 	unsigned long long val;
 	int ret;
 
-	ret = tep_read_number_field(plugin_ctx->sched_wakeup_new_pid_field,
-				    record->data, &val);
+	if (!wakeup_event || e->event_id != wakeup_event->id)
+		return -1;
 
-	return ret ? : val;
+	record = tracecmd_read_at(kshark_ctx->handle, e->offset, NULL);
+	ret = tep_read_number_field(pid_field, record->data, &val);
+	free_record(record);
+
+	if (ret)
+		return -1;
+
+	return val;
+}
+
+static bool wakeup_match_rec_pid(struct plugin_sched_context *plugin_ctx,
+				 struct kshark_context *kshark_ctx,
+				 struct kshark_entry *e,
+				 int pid)
+{
+	struct tep_event *wakeup_events[] = {
+		plugin_ctx->sched_wakeup_event,
+		plugin_ctx->sched_wakeup_new_event,
+	};
+	struct tep_format_field *wakeup_fields[] = {
+		plugin_ctx->sched_wakeup_pid_field,
+		plugin_ctx->sched_wakeup_new_pid_field,
+	};
+	int i, wakeup_pid = -1;
+
+	for (i = 0; i < sizeof(wakeup_events) / sizeof(wakeup_events[0]); i++) {
+		wakeup_pid = find_wakeup_pid(kshark_ctx, e, wakeup_events[i], wakeup_fields[i]);
+		if (wakeup_pid >= 0)
+			break;
+	}
+
+	if (wakeup_pid >= 0 && wakeup_pid == pid)
+		return true;
+
+	return false;
 }
 
 /**
@@ -168,31 +213,12 @@ bool plugin_wakeup_match_rec_pid(struct kshark_context *kshark_ctx,
 				 int pid)
 {
 	struct plugin_sched_context *plugin_ctx;
-	struct tep_record *record = NULL;
-	int wakeup_pid = -1;
 
 	plugin_ctx = plugin_sched_context_handler;
 	if (!plugin_ctx)
 		return false;
 
-	if (plugin_ctx->sched_wakeup_event &&
-	    e->event_id == plugin_ctx->sched_wakeup_event->id) {
-		record = tracecmd_read_at(kshark_ctx->handle, e->offset, NULL);
-		wakeup_pid = plugin_get_rec_wakeup_pid(record);
-	}
-
-	if (plugin_ctx->sched_wakeup_new_event &&
-	    e->event_id == plugin_ctx->sched_wakeup_new_event->id) {
-		record = tracecmd_read_at(kshark_ctx->handle, e->offset, NULL);
-		wakeup_pid = plugin_get_rec_wakeup_new_pid(record);
-	}
-
-	free_record(record);
-
-	if (wakeup_pid >= 0 && wakeup_pid == pid)
-		return true;
-
-	return false;
+	return wakeup_match_rec_pid(plugin_ctx, kshark_ctx, e, pid);
 }
 
 /**
-- 
2.20.1


