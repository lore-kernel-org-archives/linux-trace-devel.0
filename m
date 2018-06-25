Return-Path: <SRS0=jM0/=JL=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:37792 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934559AbeFYPC0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Jun 2018 11:02:26 -0400
Received: by mail-wr0-f196.google.com with SMTP id k6-v6so14034519wrp.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Jun 2018 08:02:26 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 6/7] kernel-shark-qt: Add filtering to the C API of KernelShark
Date: Mon, 25 Jun 2018 18:01:20 +0300
Message-Id: <20180625150121.14291-7-y.karadz@gmail.com>
In-Reply-To: <20180625150121.14291-1-y.karadz@gmail.com>
References: <20180625150121.14291-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Instruments for trace data filtering are added to the C API of
the Qt-based version of KernelShark. The following patch will
introduces an example, demonstrating the usage of this instruments.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 141 ++++++++++++++++++++++++++++++++
 kernel-shark-qt/src/libkshark.h |  75 +++++++++++++++++
 2 files changed, 216 insertions(+)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index f112a50..c6e03a8 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -28,6 +28,14 @@ static bool kshark_default_context(struct kshark_context **context)
 	if (!kshark_ctx)
 		return false;
 
+	kshark_ctx->show_task_filter = tracecmd_filter_id_hash_alloc();
+	kshark_ctx->hide_task_filter = tracecmd_filter_id_hash_alloc();
+
+	kshark_ctx->show_event_filter = tracecmd_filter_id_hash_alloc();
+	kshark_ctx->hide_event_filter = tracecmd_filter_id_hash_alloc();
+
+	kshark_ctx->filter_mask = 0x0;
+
 	/* Free the existing context (if any). */
 	if (*context && *context != kshark_context_handler) {
 		free(*context);
@@ -112,6 +120,15 @@ void kshark_close(struct kshark_context *kshark_ctx)
 	if (!kshark_ctx || !kshark_ctx->handle)
 		return;
 
+	/*
+	 * All Id filters are file specific. Make sure that the Pids and Event Ids
+	 * from this file are not going to be used with another file.
+	 */
+	tracecmd_filter_id_clear(kshark_ctx->show_task_filter);
+	tracecmd_filter_id_clear(kshark_ctx->hide_task_filter);
+	tracecmd_filter_id_clear(kshark_ctx->show_event_filter);
+	tracecmd_filter_id_clear(kshark_ctx->hide_event_filter);
+
 	tracecmd_close(kshark_ctx->handle);
 	kshark_ctx->handle = NULL;
 	kshark_ctx->pevt = NULL;
@@ -129,6 +146,12 @@ void kshark_free(struct kshark_context *kshark_ctx)
 		kshark_context_handler = NULL;
 	}
 
+	tracecmd_filter_id_hash_free(kshark_ctx->show_task_filter);
+	tracecmd_filter_id_hash_free(kshark_ctx->hide_task_filter);
+
+	tracecmd_filter_id_hash_free(kshark_ctx->show_event_filter);
+	tracecmd_filter_id_hash_free(kshark_ctx->hide_event_filter);
+
 	kshark_free_task_list(kshark_ctx);
 
 	if (seq.buffer)
@@ -171,6 +194,113 @@ kshark_add_task(struct kshark_context *kshark_ctx, int pid)
 	return list;
 }
 
+static bool kshark_show_task(struct kshark_context *kshark_ctx, int pid)
+{
+	return (!kshark_ctx->show_task_filter ||
+		!kshark_ctx->show_task_filter->count ||
+		tracecmd_filter_id_find(kshark_ctx->show_task_filter, pid)) &&
+		(!kshark_ctx->hide_task_filter ||
+		 !kshark_ctx->hide_task_filter->count ||
+		 !tracecmd_filter_id_find(kshark_ctx->hide_task_filter, pid));
+}
+
+static bool kshark_show_event(struct kshark_context *kshark_ctx, int event_id)
+{
+	return (!kshark_ctx->show_event_filter ||
+		!kshark_ctx->show_event_filter->count ||
+		tracecmd_filter_id_find(kshark_ctx->show_event_filter, event_id)) &&
+		(!kshark_ctx->hide_event_filter ||
+		 !kshark_ctx->hide_event_filter->count ||
+		 !tracecmd_filter_id_find(kshark_ctx->hide_event_filter, event_id));
+}
+
+void kshark_filter_add_id(struct kshark_context *kshark_ctx, int filter_id, int id)
+{
+	switch (filter_id) {
+		case SHOW_EVENT_FILTER:
+			tracecmd_filter_id_add(kshark_ctx->show_event_filter, id);
+			break;
+
+		case HIDE_EVENT_FILTER:
+			tracecmd_filter_id_add(kshark_ctx->hide_event_filter, id);
+			break;
+
+		case SHOW_TASK_FILTER:
+			tracecmd_filter_id_add(kshark_ctx->show_task_filter, id);
+			break;
+
+		case HIDE_TASK_FILTER:
+			tracecmd_filter_id_add(kshark_ctx->hide_task_filter, id);
+			break;
+
+		default:
+			break;
+	}
+}
+
+void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id)
+{
+	switch (filter_id) {
+		case SHOW_EVENT_FILTER:
+			tracecmd_filter_id_clear(kshark_ctx->show_event_filter);
+			break;
+
+		case HIDE_EVENT_FILTER:
+			tracecmd_filter_id_clear(kshark_ctx->hide_event_filter);
+			break;
+
+		case SHOW_TASK_FILTER:
+			tracecmd_filter_id_clear(kshark_ctx->show_task_filter);
+			break;
+
+		case HIDE_TASK_FILTER:
+			tracecmd_filter_id_clear(kshark_ctx->hide_task_filter);
+			break;
+
+		default:
+			break;
+	}
+}
+
+static bool kshark_filter_is_set(struct kshark_context *kshark_ctx)
+{
+	if ((kshark_ctx->show_task_filter &&
+	     kshark_ctx->show_task_filter->count) ||
+	    (kshark_ctx->hide_task_filter &&
+	     kshark_ctx->hide_task_filter->count) ||
+	    (kshark_ctx->show_event_filter &&
+	     kshark_ctx->show_event_filter->count) ||
+	    (kshark_ctx->hide_event_filter &&
+	     kshark_ctx->hide_event_filter->count)) {
+		return true;
+	}
+
+	return false;
+}
+
+void kshark_filter_entries(struct kshark_context *kshark_ctx,
+			   struct kshark_entry **data,
+			   size_t n_entries)
+{
+	if (!kshark_filter_is_set(kshark_ctx))
+		return;
+
+	int i;
+	for (i = 0; i < n_entries; ++i) {
+		data[i]->visible = 0xFF;
+		if (!kshark_show_task(kshark_ctx, data[i]->pid)) {
+			data[i]->visible &= ~kshark_ctx->filter_mask;
+		}
+
+		if (!kshark_show_event(kshark_ctx, data[i]->event_id)) {
+			int mask = kshark_ctx->filter_mask;
+			mask &= ~KS_GRAPH_VIEW_FILTER_MASK;
+			mask |= KS_EVENT_VIEW_FILTER_MASK;
+			data[i]->visible &= ~mask;
+		}
+	}
+}
+
 static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
 				    struct pevent_record *record,
 				    struct kshark_entry *entry)
@@ -224,6 +354,17 @@ size_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 			kshark_set_entry_values(kshark_ctx, rec, entry);
 			kshark_add_task(kshark_ctx, entry->pid);
 
+			if (!kshark_show_task(kshark_ctx, entry->pid)) {
+				entry->visible &= ~kshark_ctx->filter_mask;
+			}
+
+			if (!kshark_show_event(kshark_ctx, entry->event_id)) {
+				int mask = kshark_ctx->filter_mask;
+				mask &= ~KS_GRAPH_VIEW_FILTER_MASK;
+				mask |= KS_EVENT_VIEW_FILTER_MASK;
+				entry->visible &= ~mask;
+			}
+
 			entry->next = NULL;
 			next = &(entry->next);
 			free_record(rec);
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index d6e41bb..460c0c5 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -22,6 +22,7 @@ extern "C" {
 
 // trace-cmd
 #include "trace-cmd.h"
+// #include "trace-filter-hash.h"
 #include "event-parse.h"
 
 /**
@@ -82,6 +83,25 @@ struct kshark_context {
 
 	/** A mutex, used to protect the access to the input file. */
 	pthread_mutex_t input_mutex;
+
+	/** Hash of tasks to filter on. */
+	struct tracecmd_filter_id	*show_task_filter;
+
+	/** Hash of tasks to not display. */
+	struct tracecmd_filter_id	*hide_task_filter;
+
+	/** Hash of events to filter on. */
+	struct tracecmd_filter_id	*show_event_filter;
+
+	/** Hash of events to not display. */
+	struct tracecmd_filter_id	*hide_event_filter;
+
+	/**
+	 * Bit mask, controlling the visibility of the entries after filtering. If given
+	 * bit is set here, all entries which are filtered-out will have this bit unset
+	 * in their "visible" fields.
+	 */
+	uint8_t				filter_mask;
 };
 
 /**
@@ -150,6 +170,61 @@ void kshark_free(struct kshark_context *kshark_ctx);
  */
 char* kshark_dump_entry(struct kshark_entry *entry);
 
+/** Bit masks used to control the visibility of the entry after filtering. */
+enum kshark_filter_masks {
+	/** Use this mask to check the visibility of the entry in the text view. */
+	KS_TEXT_VIEW_FILTER_MASK	= (1 << 0),
+
+	/** Use this mask to check the visibility of the entry in the graph view. */
+	KS_GRAPH_VIEW_FILTER_MASK	= (1 << 1),
+
+	/** Special mask used whene filtering events. */
+	KS_EVENT_VIEW_FILTER_MASK	= (1 << 2),
+};
+
+/** Filter type identifier. */
+enum kshark_filter_type {
+	/** Identifier of the filter, used to specified the events to be shown. */
+	SHOW_EVENT_FILTER,
+
+	/** Identifier of the filter, used to specified the events to be filtered-out. */
+	HIDE_EVENT_FILTER,
+
+	/** Identifier of the filter, used to specified the tasks to be shown. */
+	SHOW_TASK_FILTER,
+
+	/** Identifier of the filter, used to specified the tasks to be filtered-out. */
+	HIDE_TASK_FILTER,
+};
+
+/**
+ * @brief Add an Id value to the filster specified by "filter_id".
+ * @param kshark_ctx: kshark_ctx: Input location for the session context pointer.
+ * @param filter_id: Identifier of the filter.
+ * @param id: Id value to be added to the filter.
+ */
+void kshark_filter_add_id(struct kshark_context *kshark_ctx, int filter_id, int id);
+
+/**
+ * @brief Clear (reset) the filster specified by "filter_id".
+ * @param kshark_ctx: kshark_ctx: Input location for the session context pointer.
+ * @param filter_id: Identifier of the filter.
+ */
+void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id);
+
+/**
+ * @brief This function loops over the array of entries specified by "data" and "n_entries"
+ * and sets the "visible" fields of each entry according to the criteria provided by the
+ * filters of the session's context. The field "filter_mask" of the session's context is
+ * used to control the level of visibility/invisibility of the entries which are filtered-out.
+ * @param kshark_ctx: kshark_ctx: Input location for the session context pointer.
+ * @param data: Input location for the trace data to be filtered.
+ * @param n_entries: The size of the inputted data.
+ */
+void kshark_filter_entries(struct kshark_context *kshark_ctx,
+			   struct kshark_entry **data,
+			   size_t n_entries);
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.17.1
