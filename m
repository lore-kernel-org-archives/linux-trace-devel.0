Return-Path: <SRS0=4N8R=MD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam02on0058.outbound.protection.outlook.com ([104.47.36.58]:21536
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728313AbeIUTfZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Sep 2018 15:35:25 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/4] kernel-shark-qt: Add functions for fast clearing of the filters.
Date: Fri, 21 Sep 2018 16:45:39 +0300
Message-Id: <20180921134540.13074-4-ykaradzhov@vmware.com>
In-Reply-To: <20180921134540.13074-1-ykaradzhov@vmware.com>
References: <20180921134540.13074-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>

The first added function checks if any Id filter is set.

The second added function is used to reset the "visible" field of each
entry to the default value of "0xFF" (visible everywhere).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 28 +++++++++++++++++++++++++++-
 kernel-shark-qt/src/libkshark.h |  6 ++++++
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 40625e5..271e556 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -427,7 +427,14 @@ static bool filter_is_set(struct tracecmd_filter_id *filter)
 	return filter && filter->count;
 }
 
-static bool kshark_filter_is_set(struct kshark_context *kshark_ctx)
+/**
+ * @brief Check if an Id filter is set.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ *
+ * @returns True if at least one Id filter is set, otherwise False.
+ */
+bool kshark_filter_is_set(struct kshark_context *kshark_ctx)
 {
 	return filter_is_set(kshark_ctx->show_task_filter) ||
 	       filter_is_set(kshark_ctx->hide_task_filter) ||
@@ -499,6 +506,25 @@ void kshark_filter_entries(struct kshark_context *kshark_ctx,
 	}
 }
 
+/**
+ * @brief This function loops over the array of entries specified by "data"
+ *	  and "n_entries" and resets the "visible" fields of each entry to
+ *	  the default value of "0xFF" (visible everywhere).
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param data: Input location for the trace data to be filtered.
+ * @param n_entries: The size of the inputted data.
+ */
+void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
+			      struct kshark_entry **data,
+			      size_t n_entries)
+{
+	int i;
+
+	for (i = 0; i < n_entries; ++i)
+		data[i]->visible = 0xFF;
+}
+
 static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
 				    struct tep_record *record,
 				    struct kshark_entry *entry)
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index 085b79c..16730b9 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -224,10 +224,16 @@ void kshark_filter_add_id(struct kshark_context *kshark_ctx,
 
 void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id);
 
+bool kshark_filter_is_set(struct kshark_context *kshark_ctx);
+
 void kshark_filter_entries(struct kshark_context *kshark_ctx,
 			   struct kshark_entry **data,
 			   size_t n_entries);
 
+void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
+			      struct kshark_entry **data,
+			      size_t n_entries);
+
 /** Search failed identifiers. */
 enum kshark_search_failed {
 	/** All entries have timestamps greater timestamps. */
-- 
2.17.1
