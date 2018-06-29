Return-Path: <SRS0=62yJ=JP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38561 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936543AbeF2P0g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Jun 2018 11:26:36 -0400
Received: by mail-wm0-f68.google.com with SMTP id 69-v6so2480399wmf.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jun 2018 08:26:35 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 6/9] kernel-shark-qt: Add filtering to the C API of KernelShark
Date: Fri, 29 Jun 2018 18:25:38 +0300
Message-Id: <20180629152541.10109-7-y.karadz@gmail.com>
In-Reply-To: <20180629152541.10109-1-y.karadz@gmail.com>
References: <20180629152541.10109-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Instruments for trace data filtering are added to the C API of
the Qt-based version of KernelShark. The following patch will
introduces an example, demonstrating the usage of this instruments.

This version of the patch contains a number of improvements suggested
by Steven Rostedt. Thanks Steven!

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 178 ++++++++++++++++++++++++++++++++
 kernel-shark-qt/src/libkshark.h |  79 +++++++++++++-
 2 files changed, 256 insertions(+), 1 deletion(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index a8e9e7e..e33ba93 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -33,6 +33,14 @@ static bool kshark_default_context(struct kshark_context **context)
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
 	/* Will free kshark_context_handler. */
 	kshark_free(NULL);
 
@@ -154,6 +162,15 @@ void kshark_close(struct kshark_context *kshark_ctx)
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
 	kshark_ctx->pevent = NULL;
@@ -179,6 +196,12 @@ void kshark_free(struct kshark_context *kshark_ctx)
 		/* kshark_ctx_handler will be set to NULL below. */
 	}
 
+	tracecmd_filter_id_hash_free(kshark_ctx->show_task_filter);
+	tracecmd_filter_id_hash_free(kshark_ctx->hide_task_filter);
+
+	tracecmd_filter_id_hash_free(kshark_ctx->show_event_filter);
+	tracecmd_filter_id_hash_free(kshark_ctx->hide_event_filter);
+
 	kshark_free_task_list(kshark_ctx);
 
 	if (seq.buffer)
@@ -266,6 +289,148 @@ size_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids)
 	return pid_count;
 }
 
+static bool filter_find(struct tracecmd_filter_id *filter, int pid,
+			bool test)
+{
+	return !filter || !filter->count ||
+		!!(unsigned long)tracecmd_filter_id_find(filter, pid) == test;
+}
+
+static bool kshark_show_task(struct kshark_context *kshark_ctx, int pid)
+{
+	return filter_find(kshark_ctx->show_task_filter, pid, true) &&
+	       filter_find(kshark_ctx->hide_task_filter, pid, false);
+}
+
+static bool kshark_show_event(struct kshark_context *kshark_ctx, int pid)
+{
+	return filter_find(kshark_ctx->show_event_filter, pid, true) &&
+	       filter_find(kshark_ctx->hide_event_filter, pid, false);
+}
+
+/**
+ * @brief Add an Id value to the filster specified by "filter_id".
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param filter_id: Identifier of the filter.
+ * @param id: Id value to be added to the filter.
+ */
+void kshark_filter_add_id(struct kshark_context *kshark_ctx,
+			  int filter_id, int id)
+{
+	struct tracecmd_filter_id *filter;
+
+	switch (filter_id) {
+		case KS_SHOW_EVENT_FILTER:
+			filter = kshark_ctx->show_event_filter;
+			break;
+		case KS_HIDE_EVENT_FILTER:
+			filter = kshark_ctx->hide_event_filter;
+			break;
+		case KS_SHOW_TASK_FILTER:
+			filter = kshark_ctx->show_task_filter;
+			break;
+		case KS_HIDE_TASK_FILTER:
+			filter = kshark_ctx->hide_task_filter;
+			break;
+		default:
+			return;
+	}
+
+	tracecmd_filter_id_add(filter, id);
+}
+
+/**
+ * @brief Clear (reset) the filster specified by "filter_id".
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param filter_id: Identifier of the filter.
+ */
+void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id)
+{
+	struct tracecmd_filter_id *filter;
+
+	switch (filter_id) {
+		case KS_SHOW_EVENT_FILTER:
+			filter = kshark_ctx->show_event_filter;
+			break;
+		case KS_HIDE_EVENT_FILTER:
+			filter = kshark_ctx->hide_event_filter;
+			break;
+		case KS_SHOW_TASK_FILTER:
+			filter = kshark_ctx->show_task_filter;
+			break;
+		case KS_HIDE_TASK_FILTER:
+			filter = kshark_ctx->hide_task_filter;
+			break;
+		default:
+			return;
+	}
+
+	tracecmd_filter_id_clear(filter);
+}
+
+static bool filter_is_set(struct tracecmd_filter_id *filter)
+{
+	return filter && filter->count;
+}
+
+static bool kshark_filter_is_set(struct kshark_context *kshark_ctx)
+{
+	return filter_is_set(kshark_ctx->show_task_filter) ||
+	       filter_is_set(kshark_ctx->hide_task_filter) ||
+	       filter_is_set(kshark_ctx->show_event_filter) ||
+	       filter_is_set(kshark_ctx->hide_event_filter);
+}
+
+static void unset_event_filter_flag(struct kshark_context *kshark_ctx,
+				    struct kshark_entry *e)
+{
+	/*
+	 * All entries, filtered-out by the event filters, will be treated
+	 * differently, when visualized. Because of this, ignore the value
+	 * of the GRAPH_VIEW flag provided by the user via
+	 * kshark_ctx->filter_mask and unset the EVENT_VIEW flag.
+	 */
+	int event_mask = kshark_ctx->filter_mask;
+
+	event_mask &= ~KS_GRAPH_VIEW_FILTER_MASK;
+	event_mask |= KS_EVENT_VIEW_FILTER_MASK;
+	e->visible &= ~event_mask;
+}
+
+/**
+ * @brief This function loops over the array of entries specified by "data"
+ *	  and "n_entries" and sets the "visible" fields of each entry
+ *	  according to the criteria provided by the filters of the session's
+ *	  context. The field "filter_mask" of the session's context is used to
+ *	  control the level of visibility/invisibility of the entries which
+ *	  are filtered-out.
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param data: Input location for the trace data to be filtered.
+ * @param n_entries: The size of the inputted data.
+ */
+void kshark_filter_entries(struct kshark_context *kshark_ctx,
+			   struct kshark_entry **data,
+			   size_t n_entries)
+{
+	int i;
+
+	if (!kshark_filter_is_set(kshark_ctx))
+		return;
+
+	for (i = 0; i < n_entries; ++i) {
+		/* Start with and entry which is visible everywhere. */
+		data[i]->visible = 0xFF;
+
+		/* Apply event filtering. */
+		if (!kshark_show_event(kshark_ctx, data[i]->event_id))
+			unset_event_filter_flag(kshark_ctx, data[i]);
+
+		/* Apply task filtering. */
+		if (!kshark_show_task(kshark_ctx, data[i]->pid))
+			data[i]->visible &= ~kshark_ctx->filter_mask;
+	}
+}
+
 static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
 				    struct pevent_record *record,
 				    struct kshark_entry *entry)
@@ -298,6 +463,10 @@ static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
  *	  "latency" and the "info" fields can be accessed only via the offset
  *	  into the file. This makes the access to these two fields much
  *	  slower.
+ *	  If one or more filters are set, the "visible" fields of each entry
+ *	  is updated according to the criteria provided by the filters. The
+ *	  field "filter_mask" of the session's context is used to control the
+ *	  level of visibility/invisibility of the filtered entries.
  * @param kshark_ctx: Input location for context pointer.
  * @param data_rows: Output location for the trace data. The user is
  *		     responsible for freeing the elements of the outputted
@@ -339,6 +508,15 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 			if (!task)
 				goto fail;
 
+			/* Apply event filtering. */
+			if (!kshark_show_event(kshark_ctx, entry->event_id))
+				unset_event_filter_flag(kshark_ctx, entry);
+
+			/* Apply task filtering. */
+			if (!kshark_show_task(kshark_ctx, entry->pid)) {
+				entry->visible &= ~kshark_ctx->filter_mask;
+			}
+
 			entry->next = NULL;
 			next = &entry->next;
 			free_record(rec);
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index 62da7c1..69d5af0 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -22,6 +22,7 @@ extern "C" {
 
 // trace-cmd
 #include "trace-cmd.h"
+#include "trace-filter-hash.h"
 #include "event-parse.h"
 #include "trace-filter-hash.h"
 
@@ -34,7 +35,9 @@ extern "C" {
 struct kshark_entry {
 	/**
 	 * A bit mask controlling the visibility of the entry. A value of OxFF
-	 * would mean that the entry is visible everywhere.
+	 * would mean that the entry is visible everywhere. Use
+	 * kshark_filter_masks to check the level of visibility/invisibility
+	 * of the entry.
 	 */
 	uint8_t		visible;
 
@@ -87,6 +90,25 @@ struct kshark_context {
 
 	/** A mutex, used to protect the access to the input file. */
 	pthread_mutex_t		input_mutex;
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
+	 * Bit mask, controlling the visibility of the entries after filtering.
+	 * If given bit is set here, all entries which are filtered-out will
+	 * have this bit unset in their "visible" fields.
+	 */
+	uint8_t				filter_mask;
 };
 
 bool kshark_instance(struct kshark_context **kshark_ctx);
@@ -107,6 +129,61 @@ void kshark_free(struct kshark_context *kshark_ctx);
 
 char* kshark_dump_entry(struct kshark_entry *entry);
 
+/** Bit masks used to control the visibility of the entry after filtering. */
+enum kshark_filter_masks {
+	/**
+	 * Use this mask to check the visibility of the entry in the text
+	 * view.
+	 */
+	KS_TEXT_VIEW_FILTER_MASK	= 1 << 0,
+
+	/**
+	 * Use this mask to check the visibility of the entry in the graph
+	 * view.
+	 */
+	KS_GRAPH_VIEW_FILTER_MASK	= 1 << 1,
+
+	/** Special mask used whene filtering events. */
+	KS_EVENT_VIEW_FILTER_MASK	= 1 << 2,
+};
+
+/** Filter type identifier. */
+enum kshark_filter_type {
+	/** Dummy filter identifier reserved for future use. */
+	KS_NO_FILTER,
+
+	/**
+	 * Identifier of the filter, used to specified the events to be shown.
+	 */
+	KS_SHOW_EVENT_FILTER,
+
+	/**
+	 * Identifier of the filter, used to specified the events to be
+	 * filtered-out.
+	 */
+	KS_HIDE_EVENT_FILTER,
+
+	/**
+	 * Identifier of the filter, used to specified the tasks to be shown.
+	 */
+	KS_SHOW_TASK_FILTER,
+
+	/**
+	 * Identifier of the filter, used to specified the tasks to be
+	 * filtered-out.
+	 */
+	KS_HIDE_TASK_FILTER,
+};
+
+void kshark_filter_add_id(struct kshark_context *kshark_ctx,
+			  int filter_id, int id);
+
+void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id);
+
+void kshark_filter_entries(struct kshark_context *kshark_ctx,
+			   struct kshark_entry **data,
+			   size_t n_entries);
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.17.1
