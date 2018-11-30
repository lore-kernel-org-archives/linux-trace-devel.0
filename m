Return-Path: <SRS0=EnxC=OJ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr740058.outbound.protection.outlook.com ([40.107.74.58]:6592
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726645AbeLACwa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Nov 2018 21:52:30 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 2/2] kernel-shark-qt: Make Sched event plugin use its own data
 collections
Date: Fri, 30 Nov 2018 15:42:38 +0000
Message-ID: <20181130154211.4575-3-ykaradzhov@vmware.com>
References: <20181130154211.4575-1-ykaradzhov@vmware.com>
In-Reply-To: <20181130154211.4575-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The Sched events plugin now mentains its own list of per-task
data collections of Sched events. Since this restors the log(n)
complexity of the latency plotting, we no longer need the  cut
which disables plotting if the number of entries shown by the
graph is bigger than PLUGIN_MAX_ENTRIES.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/plugins/SchedEvents.cpp | 33 ++++++++-------------
 kernel-shark-qt/src/plugins/sched_events.c  | 21 +++++++++++++
 kernel-shark-qt/src/plugins/sched_events.h  |  6 ++++
 3 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/kernel-shark-qt/src/plugins/SchedEvents.cpp b/kernel-shark-qt/=
src/plugins/SchedEvents.cpp
index c8dc3bf..8408657 100644
--- a/kernel-shark-qt/src/plugins/SchedEvents.cpp
+++ b/kernel-shark-qt/src/plugins/SchedEvents.cpp
@@ -28,8 +28,6 @@
=20
 #define PLUGIN_MIN_BOX_SIZE 4
=20
-#define PLUGIN_MAX_ENTRIES 10000
-
 #define KS_TASK_COLLECTION_MARGIN 25
=20
 //! @endcond
@@ -133,15 +131,13 @@ static void pluginDraw(plugin_sched_context *plugin_c=
tx,
 			/*
 			 * Starting from the last element in this bin, go backward
 			 * in time until you find a trace entry that satisfies the
-			 * condition defined by plugin_wakeup_match_rec_pid. Note
-			 * that the wakeup event does not belong to this task,
-			 * hence we cannot use the task's collection.
+			 * condition defined by plugin_wakeup_match_rec_pid.
 			 */
 			entryOpen =3D
 				ksmodel_get_entry_back(histo, bin, false,
 						       plugin_wakeup_match_rec_pid,
 						       pid,
-						       nullptr, // No collection.
+						       col,
 						       &indexOpen);
=20
 			if (entryOpen) {
@@ -207,6 +203,9 @@ static void secondPass(kshark_entry **data,
 		       kshark_entry_collection *col,
 		       int pid)
 {
+	if (!col)
+		return;
+
 	const kshark_entry *e;
 	kshark_entry *last;
 	int first, n;
@@ -275,8 +274,8 @@ void plugin_draw(kshark_cpp_argv *argv_c, int pid, int =
draw_action)
 	 * Try to find a collections for this task. It is OK if
 	 * coll =3D NULL.
 	 */
-	col =3D kshark_find_data_collection(kshark_ctx->collections,
-					  kshark_match_pid, pid);
+	col =3D kshark_find_data_collection(plugin_ctx->collections,
+					  plugin_match_pid, pid);
 	if (!col) {
 		/*
 		 * If a data collection for this task does not exist,
@@ -284,10 +283,12 @@ void plugin_draw(kshark_cpp_argv *argv_c, int pid, in=
t draw_action)
 		 */
 		kshark_entry **data =3D argvCpp->_histo->data;
 		int size =3D argvCpp->_histo->data_size;
-		col =3D kshark_register_data_collection(kshark_ctx,
-						      data, size,
-						      kshark_match_pid, pid,
-						      KS_TASK_COLLECTION_MARGIN);
+
+		col =3D kshark_add_collection_to_list(kshark_ctx,
+						    &plugin_ctx->collections,
+						    data, size,
+						    plugin_match_pid, pid,
+						    KS_TASK_COLLECTION_MARGIN);
 	}
=20
 	if (!tracecmd_filter_id_find(plugin_ctx->second_pass_hash, pid)) {
@@ -296,14 +297,6 @@ void plugin_draw(kshark_cpp_argv *argv_c, int pid, int=
 draw_action)
 		tracecmd_filter_id_add(plugin_ctx->second_pass_hash, pid);
 	}
=20
-	/*
-	 * Plotting the latencies makes sense only in the case of a deep zoom.
-	 * Here we set a threshold based on the total number of entries being
-	 * visualized by the model.
-	 * Don't be afraid to play with different values for this threshold.
-	 */
-	if (argvCpp->_histo->tot_count > PLUGIN_MAX_ENTRIES)
-		return;
 	try {
 		pluginDraw(plugin_ctx, kshark_ctx,
 			   argvCpp->_histo, col,
diff --git a/kernel-shark-qt/src/plugins/sched_events.c b/kernel-shark-qt/s=
rc/plugins/sched_events.c
index 59ffcfe..1500110 100644
--- a/kernel-shark-qt/src/plugins/sched_events.c
+++ b/kernel-shark-qt/src/plugins/sched_events.c
@@ -42,6 +42,7 @@ static bool plugin_sched_init_context(struct kshark_conte=
xt *kshark_ctx)
 	plugin_ctx =3D plugin_sched_context_handler;
 	plugin_ctx->handle =3D kshark_ctx->handle;
 	plugin_ctx->pevent =3D kshark_ctx->pevent;
+	plugin_ctx->collections =3D NULL;
=20
 	event =3D tep_find_event_by_name(plugin_ctx->pevent,
 				       "sched", "sched_switch");
@@ -279,6 +280,25 @@ bool plugin_switch_match_entry_pid(struct kshark_conte=
xt *kshark_ctx,
 	return false;
 }
=20
+/**
+ * @brief A match function to be used to process a data collections for
+ *	  the Sched events plugin.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param e: kshark_entry to be checked.
+ * @param pid: Matching condition value.
+ *
+ * @returns True if the entry is relevant for the Sched events plugin.
+ *	    Otherwise false.
+ */
+bool plugin_match_pid(struct kshark_context *kshark_ctx,
+		      struct kshark_entry *e, int pid)
+{
+	return plugin_switch_match_entry_pid(kshark_ctx, e, pid) ||
+	       plugin_switch_match_rec_pid(kshark_ctx, e, pid) ||
+	       plugin_wakeup_match_rec_pid(kshark_ctx, e, pid);
+}
+
 static void plugin_sched_action(struct kshark_context *kshark_ctx,
 				struct tep_record *rec,
 				struct kshark_entry *entry)
@@ -326,6 +346,7 @@ static int plugin_sched_close(struct kshark_context *ks=
hark_ctx)
=20
 	tracecmd_filter_id_hash_free(plugin_ctx->second_pass_hash);
=20
+	kshark_free_collection_list(plugin_ctx->collections);
 	free(plugin_ctx);
 	plugin_sched_context_handler =3D NULL;
=20
diff --git a/kernel-shark-qt/src/plugins/sched_events.h b/kernel-shark-qt/s=
rc/plugins/sched_events.h
index 28625e3..5318ef3 100644
--- a/kernel-shark-qt/src/plugins/sched_events.h
+++ b/kernel-shark-qt/src/plugins/sched_events.h
@@ -59,6 +59,9 @@ struct plugin_sched_context {
 	 */
 	struct tep_format_field	*sched_wakeup_new_success_field;
=20
+	/** List of Data collections used by this plugin. */
+	struct kshark_entry_collection	*collections;
+
 	/** Hash of the tasks for which the second pass is already done. */
 	struct tracecmd_filter_id	*second_pass_hash;
 };
@@ -75,6 +78,9 @@ bool plugin_switch_match_entry_pid(struct kshark_context =
*kshark_ctx,
 				   struct kshark_entry *e,
 				   int pid);
=20
+bool plugin_match_pid(struct kshark_context *kshark_ctx,
+		      struct kshark_entry *e, int pid);
+
 void plugin_draw(struct kshark_cpp_argv *argv, int pid, int draw_action);
=20
 #ifdef __cplusplus
--=20
2.17.1
