Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-cys01nam02on0088.outbound.protection.outlook.com ([104.47.37.88]:36407
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725872AbeKJFdH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 10 Nov 2018 00:33:07 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 8/8] kernel-shark-qt: Update Sched Events plugin
Date: Fri, 9 Nov 2018 19:50:31 +0000
Message-ID: <20181109195004.25455-9-ykaradzhov@vmware.com>
References: <20181109195004.25455-1-ykaradzhov@vmware.com>
In-Reply-To: <20181109195004.25455-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch updates the Sched Events plugin to use the recently
introduced "Missed events" entries and tot_count field of the
Visualization model descriptor in its plotting logic. We need this
update because the sched plugin would get confused because of missed
events, where we could have missed events hiding wakeups, and only
have the sched switch, or a wakeup with a missing sched switch would
break the plotting of the latency.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/plugins/SchedEvents.cpp | 43 ++++++++++-----------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/kernel-shark-qt/src/plugins/SchedEvents.cpp b/kernel-shark-qt/=
src/plugins/SchedEvents.cpp
index eec60fe..b4596c9 100644
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
@@ -104,24 +104,6 @@ static void pluginDraw(plugin_sched_context *plugin_ct=
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
@@ -131,6 +113,11 @@ static void pluginDraw(plugin_sched_context *plugin_ct=
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
@@ -155,10 +142,12 @@ static void pluginDraw(plugin_sched_context *plugin_c=
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
@@ -288,6 +277,14 @@ void plugin_draw(kshark_cpp_argv *argv_c, int pid, int=
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
