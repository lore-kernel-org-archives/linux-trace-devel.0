Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-by2nam01on0085.outbound.protection.outlook.com ([104.47.34.85]:56048
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728044AbeJFBdZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Oct 2018 21:33:25 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 3/5] kernel-shark-qt: Add functions for fast clearing of
 the filters.
Date: Fri, 5 Oct 2018 18:33:27 +0000
Message-ID: <20181005183241.27026-4-ykaradzhov@vmware.com>
References: <20181005183241.27026-1-ykaradzhov@vmware.com>
In-Reply-To: <20181005183241.27026-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
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

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshar=
k.c
index d9d1929..56ae3ce 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -427,7 +427,14 @@ static bool filter_is_set(struct tracecmd_filter_id *f=
ilter)
 	return filter && filter->count;
 }
=20
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
@@ -499,6 +506,25 @@ void kshark_filter_entries(struct kshark_context *ksha=
rk_ctx,
 	}
 }
=20
+/**
+ * @brief This function loops over the array of entries specified by "data=
"
+ *	  and "n_entries" and resets the "visible" fields of each entry to
+ *	  the default value of "0xFF" (visible everywhere).
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param data: Input location for the trace data to be unfiltered.
+ * @param n_entries: The size of the inputted data.
+ */
+void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
+			      struct kshark_entry **data,
+			      size_t n_entries)
+{
+	int i;
+
+	for (i =3D 0; i < n_entries; ++i)
+		data[i]->visible =3D 0xFF;
+}
+
 static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
 				    struct tep_record *record,
 				    struct kshark_entry *entry)
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshar=
k.h
index d24ed8c..a329e08 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -226,10 +226,16 @@ void kshark_filter_add_id(struct kshark_context *ksha=
rk_ctx,
=20
 void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id)=
;
=20
+bool kshark_filter_is_set(struct kshark_context *kshark_ctx);
+
 void kshark_filter_entries(struct kshark_context *kshark_ctx,
 			   struct kshark_entry **data,
 			   size_t n_entries);
=20
+void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
+			      struct kshark_entry **data,
+			      size_t n_entries);
+
 /** Search failed identifiers. */
 enum kshark_search_failed {
 	/** All entries have timestamps greater timestamps. */
--=20
2.17.1
