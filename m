Return-Path: <SRS0=EnxC=OJ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr740058.outbound.protection.outlook.com ([40.107.74.58]:6592
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726572AbeLACwZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Nov 2018 21:52:25 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 1/2] kernel-shark-qt: Add a method for adding a new collection
 to a list
Date: Fri, 30 Nov 2018 15:42:36 +0000
Message-ID: <20181130154211.4575-2-ykaradzhov@vmware.com>
References: <20181130154211.4575-1-ykaradzhov@vmware.com>
In-Reply-To: <20181130154211.4575-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

So far we have only one method that creates a new Data Collection.
It is kshark_register_data_collection(). The problem with this method
is that it automatically adds the new collection to the list of
collections, owned by the context of the session. This patch adds
a more generic method, which can be used to add new data collection
to a given list. The method will be used by the Sched event plugin,
which will keep its own list of collections, relevant only for the
plugin.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/libkshark-collection.c | 45 +++++++++++++++++++++-
 kernel-shark-qt/src/libkshark.c            |  1 +
 kernel-shark-qt/src/libkshark.h            |  9 +++++
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark-collection.c b/kernel-shark-qt/s=
rc/libkshark-collection.c
index 9838042..c70da1e 100644
--- a/kernel-shark-qt/src/libkshark-collection.c
+++ b/kernel-shark-qt/src/libkshark-collection.c
@@ -781,14 +781,55 @@ kshark_register_data_collection(struct kshark_context=
 *kshark_ctx,
 {
 	struct kshark_entry_collection *col;
=20
+	col =3D kshark_add_collection_to_list(kshark_ctx,
+					    &kshark_ctx->collections,
+					    data, n_rows,
+					    cond, val,
+					    margin);
+
+	return col;
+}
+
+/**
+ * @brief Allocate and process data collection, defined with a given Match=
ing
+ *	  condition function and value. Add this collection to a given list of
+ *	  collections.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param col_list: Input location for the list of collections.
+ * @param data: Input location for the trace data.
+ * @param n_rows: The size of the inputted data.
+ * @param cond: Matching condition function for the collection to be
+ *	        registered.
+ * @param val: Matching condition value of for collection to be registered=
.
+ * @param margin: The size of the additional (margin) data which do not
+ *		  satisfy the matching condition, but is added at the
+ *		  beginning and at the end of each interval of the collection
+ *		  as well as at the beginning and at the end of data-set. If
+ *		  "0", no margin data is added.
+ *
+ * @returns Pointer to the registered Data collections on success, or NULL
+ *	    on failure.
+ */
+struct kshark_entry_collection *
+kshark_add_collection_to_list(struct kshark_context *kshark_ctx,
+			      struct kshark_entry_collection **col_list,
+			      struct kshark_entry **data,
+			      size_t n_rows,
+			      matching_condition_func cond,
+			      int val,
+			      size_t margin)
+{
+	struct kshark_entry_collection *col;
+
 	col =3D kshark_data_collection_alloc(kshark_ctx, data,
 					   0, n_rows,
 					   cond, val,
 					   margin);
=20
 	if (col) {
-		col->next =3D kshark_ctx->collections;
-		kshark_ctx->collections =3D col;
+		col->next =3D *col_list;
+		*col_list =3D col;
 	}
=20
 	return col;
diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshar=
k.c
index 86d3e58..598ea52 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -33,6 +33,7 @@ static bool kshark_default_context(struct kshark_context =
**context)
 		return false;
=20
 	kshark_ctx->event_handlers =3D NULL;
+	kshark_ctx->collections =3D NULL;
 	kshark_ctx->plugins =3D NULL;
=20
 	kshark_ctx->show_task_filter =3D tracecmd_filter_id_hash_alloc();
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshar=
k.h
index b3bd646..7d1edfc 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -412,6 +412,15 @@ struct kshark_entry_collection {
 	size_t size;
 };
=20
+struct kshark_entry_collection *
+kshark_add_collection_to_list(struct kshark_context *kshark_ctx,
+			      struct kshark_entry_collection **col_list,
+			      struct kshark_entry **data,
+			      size_t n_rows,
+			      matching_condition_func cond,
+			      int val,
+			      size_t margin);
+
 struct kshark_entry_collection *
 kshark_register_data_collection(struct kshark_context *kshark_ctx,
 				struct kshark_entry **data, size_t n_rows,
--=20
2.17.1
