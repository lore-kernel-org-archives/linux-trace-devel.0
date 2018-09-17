Return-Path: <SRS0=TioG=L7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44293 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728790AbeIQULE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Sep 2018 16:11:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id v16-v6so17594830wro.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Sep 2018 07:43:25 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 2/7] kernel-shark-qt: Add Plugin event handlers to session.
Date: Mon, 17 Sep 2018 17:42:21 +0300
Message-Id: <20180917144226.8653-3-y.karadz@gmail.com>
In-Reply-To: <20180917144226.8653-1-y.karadz@gmail.com>
References: <20180917144226.8653-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Plugin event handlers are added to the Session context descriptor.
The handlers are used to execute plugin-specific action (callback
function) during the processing of the trace data.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 21 +++++++++++++++++++++
 kernel-shark-qt/src/libkshark.h | 12 ++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index b4a76ae..eef0236 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -33,6 +33,9 @@ static bool kshark_default_context(struct kshark_context **context)
 	if (!kshark_ctx)
 		return false;
 
+	kshark_ctx->event_handlers = NULL;
+	kshark_ctx->plugins = NULL;
+
 	kshark_ctx->show_task_filter = tracecmd_filter_id_hash_alloc();
 	kshark_ctx->hide_task_filter = tracecmd_filter_id_hash_alloc();
 
@@ -217,6 +220,12 @@ void kshark_free(struct kshark_context *kshark_ctx)
 	tracecmd_filter_id_hash_free(kshark_ctx->show_event_filter);
 	tracecmd_filter_id_hash_free(kshark_ctx->hide_event_filter);
 
+	if(kshark_ctx->plugins) {
+		kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_UNLOAD);
+		kshark_free_plugin_list(kshark_ctx->plugins);
+		kshark_free_event_handler_list(kshark_ctx->event_handlers);
+	}
+
 	kshark_free_task_list(kshark_ctx);
 
 	if (seq.buffer)
@@ -564,6 +573,7 @@ static void free_rec_list(struct rec_list **rec_list, int n_cpus,
 static size_t get_records(struct kshark_context *kshark_ctx,
 			  struct rec_list ***rec_list, enum rec_type type)
 {
+	struct kshark_event_handler *evt_handler;
 	struct event_filter *adv_filter;
 	struct kshark_task_list *task;
 	struct tep_record *rec;
@@ -608,6 +618,17 @@ static size_t get_records(struct kshark_context *kshark_ctx,
 
 				entry = &temp_rec->entry;
 				kshark_set_entry_values(kshark_ctx, rec, entry);
+
+				/* Execute all plugin-provided actions (if any). */
+				evt_handler = kshark_ctx->event_handlers;
+				while ((evt_handler = find_event_handler(evt_handler,
+									 entry->event_id))) {
+					evt_handler->event_func(kshark_ctx, rec, entry);
+
+					if ((evt_handler = evt_handler->next))
+						entry->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
+				}
+
 				pid = entry->pid;
 				/* Apply event filtering. */
 				ret = FILTER_MATCH;
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index fda133c..203c812 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -29,6 +29,9 @@ extern "C" {
 #include "event-parse.h"
 #include "trace-filter-hash.h"
 
+// KernelShark
+#include "libkshark-plugin.h"
+
 /**
  * Kernel Shark entry contains all information from one trace record needed
  * in order to  visualize the time-series of trace records. The part of the
@@ -124,6 +127,9 @@ struct kshark_context {
 
 	/** List of Plugins. */
 	struct kshark_plugin_list	*plugins;
+
+	/** List of Plugin Event handlers. */
+	struct kshark_event_handler	*event_handlers;
 };
 
 bool kshark_instance(struct kshark_context **kshark_ctx);
@@ -160,6 +166,12 @@ enum kshark_filter_masks {
 
 	/** Special mask used whene filtering events. */
 	KS_EVENT_VIEW_FILTER_MASK	= 1 << 2,
+
+	/**
+	 * Use this mask to check if the content of the entry has been accessed
+	 * by a plugin-defined function.
+	 */
+	KS_PLUGIN_UNTOUCHED_MASK	= 1 << 7
 };
 
 /** Filter type identifier. */
-- 
2.17.1
