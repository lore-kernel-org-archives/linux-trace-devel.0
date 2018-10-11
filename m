Return-Path: <SRS0=tdNt=MX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-by2nam01on0041.outbound.protection.outlook.com ([104.47.34.41]:55376
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730301AbeJLA1W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Oct 2018 20:27:22 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2] kernel-shark-qt: Fix the glitches in the preemption time
 visualization
Date: Thu, 11 Oct 2018 16:59:14 +0000
Message-ID: <20181011165852.15325-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This problem was reported by Steven Rostedt. The reason for having
the problem was my wrong assumption that for a given task the
sched_switch event is always the last record before the task is
preempted.

The patch changes two things:
   It modifies the "match" functions used to search for sched events,
   making these functions to trigger only on sched_switch/_wakeup events.
   This eliminates the flakiness due to the fact that sometimes the
   sched_switch can happend to be in the same bin with some of the trailing
   events from the same task. This also has the side effect of simplifying
   the code.

   It introduces a second pass over the data, which is task-specific and
   gets executed only the first time the task is plotted. This second pass
   edits the "pid" field of the last trailing event making it equal to the
   "next pid" field of the sched_switch event.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/plugins/SchedEvents.cpp | 122 ++++++++++++++------
 kernel-shark-qt/src/plugins/sched_events.c  |  13 +--
 2 files changed, 90 insertions(+), 45 deletions(-)

diff --git a/kernel-shark-qt/src/plugins/SchedEvents.cpp b/kernel-shark-qt/=
src/plugins/SchedEvents.cpp
index 713feb4..b88ec6d 100644
--- a/kernel-shark-qt/src/plugins/SchedEvents.cpp
+++ b/kernel-shark-qt/src/plugins/SchedEvents.cpp
@@ -16,6 +16,7 @@
=20
 // C++ 11
 #include<functional>
+#include<unordered_set>
=20
 // KernelShark
 #include "libkshark.h"
@@ -29,25 +30,12 @@
=20
 #define PLUGIN_MAX_ENTRIES_PER_BIN 500
=20
+#define KS_TASK_COLLECTION_MARGIN 25
+
 //! @endcond
=20
 extern struct plugin_sched_context *plugin_sched_context_handler;
=20
-static int plugin_get_wakeup_pid(kshark_context *kshark_ctx,
-				 plugin_sched_context *plugin_ctx,
-				 const struct kshark_entry *e)
-{
-	struct tep_record *record;
-	unsigned long long val;
-
-	record =3D kshark_read_at(kshark_ctx, e->offset);
-	tep_read_number_field(plugin_ctx->sched_wakeup_pid_field,
-			      record->data, &val);
-	free_record(record);
-
-	return val;
-}
-
 /** Sched Event identifier. */
 enum class SchedEvent {
 	/** Sched Switch Event. */
@@ -139,23 +127,16 @@ static void pluginDraw(plugin_sched_context *plugin_c=
tx,
 			ksmodel_get_entry_back(histo, bin, false,
 					       plugin_wakeup_match_pid, pid,
 					       col, nullptr);
-		int wakeup_pid;
-
-		if (entryB &&
-		    plugin_ctx->sched_wakeup_event &&
-		    entryB->event_id =3D=3D plugin_ctx->sched_wakeup_event->id) {
-			wakeup_pid =3D
-				plugin_get_wakeup_pid(kshark_ctx, plugin_ctx, entryB);
-			if (wakeup_pid =3D=3D pid) {
-				/*
-				 * entryB is a sched_wakeup_event. Open a
-				 * green box here.
-				 */
-				openBox(graph->getBin(bin)._base);
=20
-				 /* Green */
-				rec->_color =3D KsPlot::Color(0, 255, 0);
-			}
+		if (entryB) {
+			/*
+			 * entryB is a sched_wakeup_event. Open a
+			 * green box here.
+			 */
+			openBox(graph->getBin(bin)._base);
+
+			/* Green */
+			rec->_color =3D KsPlot::Color(0, 255, 0);
 		}
 	};
=20
@@ -171,10 +152,7 @@ static void pluginDraw(plugin_sched_context *plugin_ct=
x,
 					       plugin_switch_match_pid, pid,
 					       col, nullptr);
=20
-		if (entryB &&
-		    entryB->pid !=3D pid &&
-		    plugin_ctx->sched_switch_event &&
-		    entryB->event_id =3D=3D plugin_ctx->sched_switch_event->id) {
+		if (entryB && entryB->pid !=3D pid) {
 			/*
 			 * entryB is a sched_switch_event. Open a
 			 * red box here.
@@ -215,6 +193,63 @@ static void pluginDraw(plugin_sched_context *plugin_ct=
x,
 	return;
 }
=20
+static std::unordered_set<int> secondPassDone;
+
+/*
+ * Ideally, the sched_switch has to be the last trace event recorded befor=
e the
+ * task is preempted. Because of this, when the data is loaded (the first =
pass),
+ * the "pid" field of the sched_switch entries gets edited by this plugin =
to be
+ * equal to the "next pid" of the sched_switch event. However, in reality =
the
+ * sched_switch event may be followed by some trailing events from the sam=
e task
+ * (printk events for example). This has the effect of extending the graph=
 of
+ * the task outside of the actual duration of the task. The "second pass" =
over
+ * the data is used to fix this problem. It takes advantage of the "next" =
field
+ * of the entry (this field is set during the first pass) to search for tr=
ailing
+ * events after the "sched_switch".
+ */
+static void secondPass(kshark_entry **data,
+		       kshark_entry_collection *col,
+		       int pid)
+{
+	kshark_entry *last;
+	int first, n;
+	ssize_t index;
+
+	/* Loop over the intervals of the data collection. */
+	for (size_t i =3D 0; i < col->size; ++i) {
+		first =3D col->break_points[i];
+		n =3D first - col->resume_points[i];
+
+		kshark_entry_request *req =3D
+			kshark_entry_request_alloc(first, n,
+						   plugin_switch_match_pid, pid,
+						   true,
+						   KS_GRAPH_VIEW_FILTER_MASK);
+
+		if (!kshark_get_entry_back(req, data, &index)) {
+			/* No sched_switch event in this interval. */
+			continue;
+		}
+
+		/* Find the very last trailing event. */
+		for (last =3D data[index]; last->next; last =3D last->next) {
+			if (last->next->pid !=3D pid) {
+				/*
+				 * This is the last trailing event. Change the
+				 * "pid" to be equal to the "next pid" of the
+				 * sched_switch event and leave a sign that you
+				 * edited this entry.
+				 */
+				last->pid =3D data[index]->pid;
+				last->visible &=3D ~KS_PLUGIN_UNTOUCHED_MASK;
+				break;
+			}
+		}
+	}
+
+	secondPassDone.insert(pid);
+}
+
 /**
  * @brief Plugin's draw function.
  *
@@ -246,8 +281,25 @@ void plugin_draw(kshark_cpp_argv *argv_c, int pid, int=
 draw_action)
 	 */
 	col =3D kshark_find_data_collection(kshark_ctx->collections,
 					  kshark_match_pid, pid);
+	if (!col) {
+		/*
+		 * If a data collection for this task does not exist,
+		 * register a new one.
+		 */
+		kshark_entry **data =3D argvCpp->_histo->data;
+		int size =3D argvCpp->_histo->data_size;
+		col =3D kshark_register_data_collection(kshark_ctx,
+						      data, size,
+						      kshark_match_pid, pid,
+						      KS_TASK_COLLECTION_MARGIN);
+	}
=20
 	try {
+		if (secondPassDone.find(pid) =3D=3D secondPassDone.end()) {
+			/* The second pass for this task is not done yet. */
+			secondPass(argvCpp->_histo->data, col, pid);
+		}
+
 		pluginDraw(plugin_ctx, kshark_ctx,
 			   argvCpp->_histo, col,
 			   SchedEvent::Switch, pid,
diff --git a/kernel-shark-qt/src/plugins/sched_events.c b/kernel-shark-qt/s=
rc/plugins/sched_events.c
index 13f3c4a..80ac214 100644
--- a/kernel-shark-qt/src/plugins/sched_events.c
+++ b/kernel-shark-qt/src/plugins/sched_events.c
@@ -167,9 +167,6 @@ bool plugin_wakeup_match_pid(struct kshark_context *ksh=
ark_ctx,
 	unsigned long long val;
 	int wakeup_pid =3D -1;
=20
-	if (e->pid =3D=3D pid)
-		return true;
-
 	plugin_ctx =3D plugin_sched_context_handler;
 	if (!plugin_ctx)
 		return false;
@@ -221,23 +218,19 @@ bool plugin_switch_match_pid(struct kshark_context *k=
shark_ctx,
 			     int pid)
 {
 	struct plugin_sched_context *plugin_ctx;
-	struct tep_record *record =3D NULL;
 	int switch_pid =3D -1;
=20
-	if (e->pid =3D=3D pid)
-		return true;
-
 	plugin_ctx =3D plugin_sched_context_handler;
=20
 	if (plugin_ctx->sched_switch_event &&
 	    e->event_id =3D=3D plugin_ctx->sched_switch_event->id) {
-		record =3D kshark_read_at(kshark_ctx, e->offset);
+		struct tep_record *record;
=20
+		record =3D kshark_read_at(kshark_ctx, e->offset);
 		switch_pid =3D tep_data_pid(plugin_ctx->pevent, record);
+		free_record(record);
 	}
=20
-	free_record(record);
-
 	if (switch_pid >=3D 0 && switch_pid =3D=3D pid)
 		return true;
=20
--=20
2.17.1
