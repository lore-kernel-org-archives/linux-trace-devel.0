Return-Path: <SRS0=o0t1=NS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bl2nam02on0067.outbound.protection.outlook.com ([104.47.38.67]:36896
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727977AbeKHBqU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 20:46:20 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 8/8] kernel-shark-qt: Update Sched Events plugin
Date: Wed, 7 Nov 2018 16:14:40 +0000
Message-ID: <20181107161410.22507-9-ykaradzhov@vmware.com>
References: <20181107161410.22507-1-ykaradzhov@vmware.com>
In-Reply-To: <20181107161410.22507-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch updates the Sched Events plugin to use the recently
introduced "Missed events" entries and tot_count field of the
Visualization model descriptor in its plotting logic.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/plugins/SchedEvents.cpp | 46 +++++++++------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/kernel-shark-qt/src/plugins/SchedEvents.cpp b/kernel-shark-qt/=
src/plugins/SchedEvents.cpp
index 1e872aa..42737e9 100644
--- a/kernel-shark-qt/src/plugins/SchedEvents.cpp
+++ b/kernel-shark-qt/src/plugins/SchedEvents.cpp
@@ -28,7 +28,7 @@
=20
 #define PLUGIN_MIN_BOX_SIZE 4
=20
-#define PLUGIN_MAX_ENTRIES_PER_BIN 500
+#define PLUGIN_MAX_ENTRIES 10000
=20
 #define KS_TASK_COLLECTION_MARGIN 25
=20
@@ -54,11 +54,11 @@ static void pluginDraw(plugin_sched_context *plugin_ctx=
,
 		       KsPlot::Graph *graph,
 		       KsPlot::PlotObjList *shapes)
 {
-	const kshark_entry *entryClose, *entryOpen;
+	const kshark_entry *entryClose, *entryOpen, *entryME;
+	ssize_t indexClose(0), indexOpen(0), indexME(0);
 	std::function<void(int)> ifSchedBack;
 	KsPlot::Rectangle *rec =3D nullptr;
 	int height =3D graph->getHeight() * .3;
-	ssize_t indexClose(0), indexOpen(0);
=20
 	auto openBox =3D [&] (const KsPlot::Point &p)
 	{
@@ -101,24 +101,6 @@ static void pluginDraw(plugin_sched_context *plugin_ct=
x,
 	};
=20
 	for (int bin =3D 0; bin < graph->size(); ++bin) {
-		/**
-		 * Plotting the latencies makes sense only in the case of a
-		 * deep zoom. Here we set a naive threshold based on the number
-		 * of entries inside the current bin. This cut seems to work
-		 * well in all cases I tested so far, but it may result in
-		 * unexpected behavior with some unusual trace data-sets.
-		 * TODO: find a better criteria for deciding when to start
-		 * plotting latencies.
-		 */
-		if (ksmodel_bin_count(histo, bin) > PLUGIN_MAX_ENTRIES_PER_BIN) {
-			if (rec) {
-				delete rec;
-				rec =3D nullptr;
-			}
-
-			continue;
-		}
-
 		/*
 		 * Starting from the first element in this bin, go forward
 		 * in time until you find a trace entry that satisfies the
@@ -128,6 +110,11 @@ static void pluginDraw(plugin_sched_context *plugin_ct=
x,
 						 plugin_switch_match_entry_pid,
 						 pid, col, &indexClose);
=20
+		entryME =3D ksmodel_get_task_missed_events(histo,
+							 bin, pid,
+							 col,
+							 &indexME);
+
 		if (e =3D=3D SchedEvent::Switch) {
 			/*
 			 * Starting from the last element in this bin, go backward
@@ -152,10 +139,12 @@ static void pluginDraw(plugin_sched_context *plugin_c=
tx,
 		}
=20
 		if (rec) {
-			if (entryClose) {
+			if (entryME || entryClose) {
 				/* Close the box in this bin. */
 				closeBox(graph->getBin(bin)._base);
-				if (entryOpen && indexClose < indexOpen) {
+				if (entryOpen &&
+				    indexME < indexOpen &&
+				    indexClose < indexOpen) {
 					/*
 					 * We have a Sched switch entry that
 					 * comes after (in time) the closure of
@@ -244,9 +233,6 @@ static void secondPass(kshark_entry **data,
  * @param argv_c: A C pointer to be converted to KsCppArgV (C++ struct).
  * @param pid: Process Id.
  * @param draw_action: Draw action identifier.
- *
- * @returns True if the Pid of the entry matches the value of "pid".
- *	    Otherwise false.
  */
 void plugin_draw(kshark_cpp_argv *argv_c, int pid, int draw_action)
 {
@@ -288,6 +274,14 @@ void plugin_draw(kshark_cpp_argv *argv_c, int pid, int=
 draw_action)
 		tracecmd_filter_id_add(plugin_ctx->second_pass_hash, pid);
 	}
=20
+	/*
+	 * Plotting the latencies makes sense only in the case of a deep zoom.
+	 * Here we set a threshold based on the total number of entries being
+	 * visualized by the model.
+	 * Don't be afraid to play with different values for this threshold.
+	 */
+	if (argvCpp->_histo->tot_count > PLUGIN_MAX_ENTRIES)
+		return;
 	try {
 		pluginDraw(plugin_ctx, kshark_ctx,
 			   argvCpp->_histo, col,
--=20
2.17.1
