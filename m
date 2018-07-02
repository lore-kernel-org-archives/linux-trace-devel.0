Return-Path: <SRS0=8H7y=JS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35383 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752399AbeGBOFM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Jul 2018 10:05:12 -0400
Received: by mail-wm0-f65.google.com with SMTP id z137-v6so8895791wmc.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Jul 2018 07:05:11 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 8/9] kernel-shark-qt: Add Advanced filter to the session context.
Date: Mon,  2 Jul 2018 17:04:23 +0300
Message-Id: <20180702140424.23221-8-y.karadz@gmail.com>
In-Reply-To: <20180702140424.23221-1-y.karadz@gmail.com>
References: <20180702140424.23221-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch adds to the KernelShark session's context instrumentation
for sophisticated filtering based on the content of the trace event.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 34 +++++++++++++++++++++++++++++++--
 kernel-shark-qt/src/libkshark.h |  6 ++++++
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 4d86f9c..13d7e6d 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -143,6 +143,9 @@ bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
 	kshark_ctx->handle = handle;
 	kshark_ctx->pevent = tracecmd_get_pevent(handle);
 
+	kshark_ctx->advanced_event_filter =
+		pevent_filter_alloc(kshark_ctx->pevent);
+
 	/*
 	 * Turn off function trace indent and turn on show parent
 	 * if possible.
@@ -163,7 +166,7 @@ void kshark_close(struct kshark_context *kshark_ctx)
 		return;
 
 	/*
-	 * All Id filters are file specific. Make sure that the Pids and Event Ids
+	 * All filters are file specific. Make sure that the Pids and Event Ids
 	 * from this file are not going to be used with another file.
 	 */
 	tracecmd_filter_id_clear(kshark_ctx->show_task_filter);
@@ -171,6 +174,12 @@ void kshark_close(struct kshark_context *kshark_ctx)
 	tracecmd_filter_id_clear(kshark_ctx->show_event_filter);
 	tracecmd_filter_id_clear(kshark_ctx->hide_event_filter);
 
+	if (kshark_ctx->advanced_event_filter) {
+		pevent_filter_reset(kshark_ctx->advanced_event_filter);
+		pevent_filter_free(kshark_ctx->advanced_event_filter);
+		kshark_ctx->advanced_event_filter = NULL;
+	}
+
 	tracecmd_close(kshark_ctx->handle);
 	kshark_ctx->handle = NULL;
 	kshark_ctx->pevent = NULL;
@@ -422,6 +431,9 @@ static void unset_event_filter_flag(struct kshark_context *kshark_ctx,
  *	  context. The field "filter_mask" of the session's context is used to
  *	  control the level of visibility/invisibility of the entries which
  *	  are filtered-out.
+ *	  WARNING: Do not use this function if the advanced filter is set.
+ *	  Applying the advanced filter requires access to prevent_record,
+ *	  hence the data has to be reloaded using kshark_load_data_entries().
  * @param kshark_ctx: Input location for the session context pointer.
  * @param data: Input location for the trace data to be filtered.
  * @param n_entries: The size of the inputted data.
@@ -432,9 +444,19 @@ void kshark_filter_entries(struct kshark_context *kshark_ctx,
 {
 	int i;
 
+	if (kshark_ctx->advanced_event_filter->filters) {
+		/* The advanced filter is set. */
+		fprintf(stderr,
+			"Failed to filter!\n");
+		fprintf(stderr,
+			"Reset the Advanced filter or reload the data.\n");
+		return;
+	}
+
 	if (!kshark_filter_is_set(kshark_ctx))
 		return;
 
+	/* Apply only the Id filters. */
 	for (i = 0; i < n_entries; ++i) {
 		/* Start with and entry which is visible everywhere. */
 		data[i]->visible = 0xFF;
@@ -495,6 +517,7 @@ static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
 ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 				struct kshark_entry ***data_rows)
 {
+	struct event_filter *adv_filter = kshark_ctx->advanced_event_filter;
 	struct kshark_entry **cpu_list, **rows;
 	struct kshark_entry *entry, **next;
 	struct kshark_task_list *task;
@@ -502,6 +525,7 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 	int cpu, n_cpus, next_cpu;
 	size_t count, total = 0;
 	uint64_t ts;
+	int ret;
 
 	if (*data_rows)
 		free(*data_rows);
@@ -526,8 +550,14 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 				goto fail;
 
 			/* Apply event filtering. */
-			if (!kshark_show_event(kshark_ctx, entry->event_id))
+			ret = FILTER_NONE;
+			if (adv_filter->filters)
+				ret = pevent_filter_match(adv_filter, rec);
+
+			if (!kshark_show_event(kshark_ctx, entry->event_id) ||
+			    ret != FILTER_MATCH) {
 				unset_event_filter_flag(kshark_ctx, entry);
+			}
 
 			/* Apply task filtering. */
 			if (!kshark_show_task(kshark_ctx, entry->pid)) {
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index dfb1be5..6ed2a1e 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -109,6 +109,12 @@ struct kshark_context {
 	 * have this bit unset in their "visible" fields.
 	 */
 	uint8_t				filter_mask;
+
+	/**
+	 * Filter allowing sophisticated filtering based on the content of
+	 * the event.
+	 */
+	struct event_filter		*advanced_event_filter;
 };
 
 bool kshark_instance(struct kshark_context **kshark_ctx);
-- 
2.17.1
