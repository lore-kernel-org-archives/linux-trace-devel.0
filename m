Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-cys01nam02on0088.outbound.protection.outlook.com ([104.47.37.88]:36407
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725872AbeKJFdB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 10 Nov 2018 00:33:01 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 2/8] kernel-shark-qt: Improve the plotting logic of the
 Sched event plugin
Date: Fri, 9 Nov 2018 19:50:25 +0000
Message-ID: <20181109195004.25455-3-ykaradzhov@vmware.com>
References: <20181109195004.25455-1-ykaradzhov@vmware.com>
In-Reply-To: <20181109195004.25455-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch aims to make the plotting logic of the Sched event plugin
more robust and easy to understand. It also provides a proper
processing of the case when we have multiple Sched events in one bin.
The red box showing the time the task was preempted is open only if
the prev_state of the sched_switch event is "R".

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/plugins/SchedEvents.cpp | 160 +++++++++-----------
 kernel-shark-qt/src/plugins/sched_events.c  |  61 ++++++--
 kernel-shark-qt/src/plugins/sched_events.h  |  15 +-
 3 files changed, 132 insertions(+), 104 deletions(-)

diff --git a/kernel-shark-qt/src/plugins/SchedEvents.cpp b/kernel-shark-qt/=
src/plugins/SchedEvents.cpp
index 5f833df..eec60fe 100644
--- a/kernel-shark-qt/src/plugins/SchedEvents.cpp
+++ b/kernel-shark-qt/src/plugins/SchedEvents.cpp
@@ -54,9 +54,11 @@ static void pluginDraw(plugin_sched_context *plugin_ctx,
 		       KsPlot::Graph *graph,
 		       KsPlot::PlotObjList *shapes)
 {
+	const kshark_entry *entryClose, *entryOpen;
 	std::function<void(int)> ifSchedBack;
 	KsPlot::Rectangle *rec =3D nullptr;
 	int height =3D graph->getHeight() * .3;
+	ssize_t indexClose(0), indexOpen(0);
=20
 	auto openBox =3D [&] (const KsPlot::Point &p)
 	{
@@ -67,7 +69,16 @@ static void pluginDraw(plugin_sched_context *plugin_ctx,
 		if (!rec)
 			rec =3D new KsPlot::Rectangle;
=20
+		if (e =3D=3D SchedEvent::Switch) {
+			/* Red box. */
+			rec->_color =3D KsPlot::Color(255, 0, 0);
+		} else {
+			/* Green box. */
+			rec->_color =3D KsPlot::Color(0, 255, 0);
+		}
+
 		rec->setFill(false);
+
 		rec->setPoint(0, p.x() - 1, p.y() - height);
 		rec->setPoint(1, p.x() - 1, p.y() - 1);
 	};
@@ -77,7 +88,7 @@ static void pluginDraw(plugin_sched_context *plugin_ctx,
 		if (rec =3D=3D nullptr)
 			return;
=20
-		int boxSize =3D rec->getPoint(0)->x;
+		int boxSize =3D p.x() - rec->getPoint(0)->x;
 		if (boxSize < PLUGIN_MIN_BOX_SIZE) {
 			/* This box is too small. Don't try to plot it. */
 			delete rec;
@@ -92,99 +103,78 @@ static void pluginDraw(plugin_sched_context *plugin_ct=
x,
 		rec =3D nullptr;
 	};
=20
-	auto lamIfSchSwitchFront =3D [&] (int bin)
-	{
-		/*
-		 * Starting from the first element in this bin, go forward
-		 * in time until you find a trace entry that satisfies the
-		 * condition defined by kshark_match_pid.
+	for (int bin =3D 0; bin < graph->size(); ++bin) {
+		/**
+		 * Plotting the latencies makes sense only in the case of a
+		 * deep zoom. Here we set a naive threshold based on the number
+		 * of entries inside the current bin. This cut seems to work
+		 * well in all cases I tested so far, but it may result in
+		 * unexpected behavior with some unusual trace data-sets.
+		 * TODO: find a better criteria for deciding when to start
+		 * plotting latencies.
 		 */
-		const kshark_entry *entryF =3D
-			ksmodel_get_entry_front(histo, bin, false,
-						kshark_match_pid, pid,
-						col, nullptr);
-
-		if (entryF &&
-		    entryF->pid =3D=3D pid &&
-		    plugin_ctx->sched_switch_event &&
-		    entryF->event_id =3D=3D plugin_ctx->sched_switch_event->id) {
-			/*
-			 * entryF is sched_switch_event. Close the box and add
-			 * it to the list of shapes to be ploted.
-			 */
-			closeBox(graph->getBin(bin)._base);
+		if (ksmodel_bin_count(histo, bin) > PLUGIN_MAX_ENTRIES_PER_BIN) {
+			if (rec) {
+				delete rec;
+				rec =3D nullptr;
+			}
+
+			continue;
 		}
-	};
=20
-	auto lamIfSchWakeupBack =3D [&] (int bin)
-	{
 		/*
-		 * Starting from the last element in this bin, go backward
+		 * Starting from the first element in this bin, go forward
 		 * in time until you find a trace entry that satisfies the
-		 * condition defined by plugin_wakeup_match_pid.
+		 * condition defined by kshark_match_pid.
 		 */
-		const kshark_entry *entryB =3D
-			ksmodel_get_entry_back(histo, bin, false,
-					       plugin_wakeup_match_pid, pid,
-					       col, nullptr);
+		entryClose =3D ksmodel_get_entry_back(histo, bin, false,
+						 plugin_switch_match_entry_pid,
+						 pid, col, &indexClose);
=20
-		if (entryB) {
+		if (e =3D=3D SchedEvent::Switch) {
 			/*
-			 * entryB is a sched_wakeup_event. Open a
-			 * green box here.
+			 * Starting from the last element in this bin, go backward
+			 * in time until you find a trace entry that satisfies the
+			 * condition defined by plugin_switch_match_pid.
 			 */
-			openBox(graph->getBin(bin)._base);
-
-			/* Green */
-			rec->_color =3D KsPlot::Color(0, 255, 0);
-		}
-	};
-
-	auto lamIfSchSwitchBack =3D [&] (int bin)
-	{
-		/*
-		 * Starting from the last element in this bin, go backward
-		 * in time until you find a trace entry that satisfies the
-		 * condition defined by plugin_switch_match_pid.
-		 */
-		const kshark_entry *entryB =3D
-			ksmodel_get_entry_back(histo, bin, false,
-					       plugin_switch_match_pid, pid,
-					       col, nullptr);
+			entryOpen =3D
+				ksmodel_get_entry_back(histo, bin, false,
+						       plugin_switch_match_rec_pid,
+						       pid, col, &indexOpen);
=20
-		if (entryB && entryB->pid !=3D pid) {
+		} else {
 			/*
-			 * entryB is a sched_switch_event. Open a
-			 * red box here.
+			 * Starting from the last element in this bin, go backward
+			 * in time until you find a trace entry that satisfies the
+			 * condition defined by plugin_wakeup_match_pid.
 			 */
-			openBox(graph->getBin(bin)._base);
-
-			/* Red */
-			rec->_color =3D KsPlot::Color(255, 0, 0);
+			entryOpen =3D
+				ksmodel_get_entry_back(histo, bin, false,
+						       plugin_wakeup_match_rec_pid,
+						       pid, col, &indexOpen);
 		}
-	};
-
-	if (e =3D=3D SchedEvent::Switch)
-		ifSchedBack =3D lamIfSchSwitchBack;
-	else
-		ifSchedBack =3D lamIfSchWakeupBack;
=20
-	for (int bin =3D 0; bin < graph->size(); ++bin) {
-		/**
-		 * Plotting the latencies makes sense only in the case of a
-		 * deep zoom. Here we set a naive threshold based on the number
-		 * of entries inside the current bin. This cut seems to work
-		 * well in all cases I tested so far, but it may result in
-		 * unexpected behavior with some unusual trace data-sets.
-		 * TODO: find a better criteria for deciding when to start
-		 * plotting latencies.
-		 */
-		if (ksmodel_bin_count(histo, bin) > PLUGIN_MAX_ENTRIES_PER_BIN)
-			continue;
-
-		lamIfSchSwitchFront(bin);
-
-		ifSchedBack(bin);
+		if (rec) {
+			if (entryClose) {
+				/* Close the box in this bin. */
+				closeBox(graph->getBin(bin)._base);
+				if (entryOpen && indexClose < indexOpen) {
+					/*
+					 * We have a Sched switch entry that
+					 * comes after (in time) the closure of
+					 * the previous box. We have to open a
+					 * new box in this bin.
+					 */
+					openBox(graph->getBin(bin)._base);
+				}
+			}
+		} else {
+			if (entryOpen &&
+			    (!entryClose || indexClose < indexOpen)) {
+				/* Open a new box in this bin. */
+				openBox(graph->getBin(bin)._base);
+			}
+		}
 	}
=20
 	if (rec)
@@ -221,7 +211,8 @@ static void secondPass(kshark_entry **data,
=20
 		kshark_entry_request *req =3D
 			kshark_entry_request_alloc(first, n,
-						   plugin_switch_match_pid, pid,
+						   plugin_switch_match_rec_pid,
+						   pid,
 						   false,
 						   KS_GRAPH_VIEW_FILTER_MASK);
=20
@@ -256,9 +247,6 @@ static void secondPass(kshark_entry **data,
  * @param argv_c: A C pointer to be converted to KsCppArgV (C++ struct).
  * @param pid: Process Id.
  * @param draw_action: Draw action identifier.
- *
- * @returns True if the Pid of the entry matches the value of "pid".
- *	    Otherwise false.
  */
 void plugin_draw(kshark_cpp_argv *argv_c, int pid, int draw_action)
 {
@@ -303,12 +291,12 @@ void plugin_draw(kshark_cpp_argv *argv_c, int pid, in=
t draw_action)
 	try {
 		pluginDraw(plugin_ctx, kshark_ctx,
 			   argvCpp->_histo, col,
-			   SchedEvent::Switch, pid,
+			   SchedEvent::Wakeup, pid,
 			   argvCpp->_graph, argvCpp->_shapes);
=20
 		pluginDraw(plugin_ctx, kshark_ctx,
 			   argvCpp->_histo, col,
-			   SchedEvent::Wakeup, pid,
+			   SchedEvent::Switch, pid,
 			   argvCpp->_graph, argvCpp->_shapes);
 	} catch (const std::exception &exc) {
 		std::cerr << "Exception in SchedEvents\n" << exc.what();
diff --git a/kernel-shark-qt/src/plugins/sched_events.c b/kernel-shark-qt/s=
rc/plugins/sched_events.c
index f23c916..1851569 100644
--- a/kernel-shark-qt/src/plugins/sched_events.c
+++ b/kernel-shark-qt/src/plugins/sched_events.c
@@ -55,6 +55,9 @@ static bool plugin_sched_init_context(struct kshark_conte=
xt *kshark_ctx)
 	plugin_ctx->sched_switch_comm_field =3D
 		tep_find_field(event, "next_comm");
=20
+	plugin_ctx->sched_switch_prev_state_field =3D
+		tep_find_field(event, "prev_state");
+
 	event =3D tep_find_event_by_name(plugin_ctx->pevent,
 				      "sched", "sched_wakeup");
 	if (!event)
@@ -105,7 +108,7 @@ int plugin_get_next_pid(struct tep_record *record)
  *
  * @param record: Input location for a sched_wakeup record.
  */
-int plugin_get_wakeup_pid(struct tep_record *record)
+int plugin_get_rec_wakeup_pid(struct tep_record *record)
 {
 	struct plugin_sched_context *plugin_ctx =3D
 		plugin_sched_context_handler;
@@ -137,7 +140,7 @@ static void plugin_register_command(struct kshark_conte=
xt *kshark_ctx,
 			tep_register_comm(kshark_ctx->pevent, comm, pid);
 }
=20
-static int plugin_get_wakeup_new_pid(struct tep_record *record)
+static int plugin_get_rec_wakeup_new_pid(struct tep_record *record)
 {
 	struct plugin_sched_context *plugin_ctx =3D
 		plugin_sched_context_handler;
@@ -157,12 +160,12 @@ static int plugin_get_wakeup_new_pid(struct tep_recor=
d *record)
  * @param e: kshark_entry to be checked.
  * @param pid: Matching condition value.
  *
- * @returns True if the Pid of the entry matches the value of "pid".
+ * @returns True if the Pid of the record matches the value of "pid".
  *	    Otherwise false.
  */
-bool plugin_wakeup_match_pid(struct kshark_context *kshark_ctx,
-			     struct kshark_entry *e,
-			     int pid)
+bool plugin_wakeup_match_rec_pid(struct kshark_context *kshark_ctx,
+				 struct kshark_entry *e,
+				 int pid)
 {
 	struct plugin_sched_context *plugin_ctx;
 	struct tep_record *record =3D NULL;
@@ -182,7 +185,7 @@ bool plugin_wakeup_match_pid(struct kshark_context *ksh=
ark_ctx,
 				      record->data, &val);
=20
 		if (val)
-			wakeup_pid =3D plugin_get_wakeup_pid(record);
+			wakeup_pid =3D plugin_get_rec_wakeup_pid(record);
 	}
=20
 	if (plugin_ctx->sched_wakeup_new_event &&
@@ -194,7 +197,7 @@ bool plugin_wakeup_match_pid(struct kshark_context *ksh=
ark_ctx,
 				      record->data, &val);
=20
 		if (val)
-			wakeup_pid =3D plugin_get_wakeup_new_pid(record);
+			wakeup_pid =3D plugin_get_rec_wakeup_new_pid(record);
 	}
=20
 	free_record(record);
@@ -212,14 +215,15 @@ bool plugin_wakeup_match_pid(struct kshark_context *k=
shark_ctx,
  * @param e: kshark_entry to be checked.
  * @param pid: Matching condition value.
  *
- * @returns True if the Pid of the entry matches the value of "pid".
+ * @returns True if the Pid of the record matches the value of "pid".
  *	    Otherwise false.
  */
-bool plugin_switch_match_pid(struct kshark_context *kshark_ctx,
-			     struct kshark_entry *e,
-			     int pid)
+bool plugin_switch_match_rec_pid(struct kshark_context *kshark_ctx,
+				 struct kshark_entry *e,
+				 int pid)
 {
 	struct plugin_sched_context *plugin_ctx;
+	unsigned long long val;
 	int switch_pid =3D -1;
=20
 	plugin_ctx =3D plugin_sched_context_handler;
@@ -229,7 +233,12 @@ bool plugin_switch_match_pid(struct kshark_context *ks=
hark_ctx,
 		struct tep_record *record;
=20
 		record =3D kshark_read_at(kshark_ctx, e->offset);
-		switch_pid =3D tep_data_pid(plugin_ctx->pevent, record);
+		tep_read_number_field(plugin_ctx->sched_switch_prev_state_field,
+				      record->data, &val);
+
+		if (!(val & 0x7f))
+			switch_pid =3D tep_data_pid(plugin_ctx->pevent, record);
+
 		free_record(record);
 	}
=20
@@ -239,6 +248,32 @@ bool plugin_switch_match_pid(struct kshark_context *ks=
hark_ctx,
 	return false;
 }
=20
+/**
+ * @brief Process Id matching function adapted for sched_switch events.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param e: kshark_entry to be checked.
+ * @param pid: Matching condition value.
+ *
+ * @returns True if the Pid of the entry matches the value of "pid".
+ *	    Otherwise false.
+ */
+bool plugin_switch_match_entry_pid(struct kshark_context *kshark_ctx,
+				   struct kshark_entry *e,
+				   int pid)
+{
+	struct plugin_sched_context *plugin_ctx;
+
+	plugin_ctx =3D plugin_sched_context_handler;
+
+	if (plugin_ctx->sched_switch_event &&
+	    e->event_id =3D=3D plugin_ctx->sched_switch_event->id &&
+	    e->pid =3D=3D pid)
+		return true;
+
+	return false;
+}
+
 static void plugin_sched_action(struct kshark_context *kshark_ctx,
 				struct tep_record *rec,
 				struct kshark_entry *entry)
diff --git a/kernel-shark-qt/src/plugins/sched_events.h b/kernel-shark-qt/s=
rc/plugins/sched_events.h
index 481413f..28625e3 100644
--- a/kernel-shark-qt/src/plugins/sched_events.h
+++ b/kernel-shark-qt/src/plugins/sched_events.h
@@ -36,6 +36,9 @@ struct plugin_sched_context {
 	/** Pointer to the sched_switch_comm_field format descriptor. */
 	struct tep_format_field	*sched_switch_comm_field;
=20
+	/** Pointer to the sched_switch_prev_state_field format descriptor. */
+	struct tep_format_field	*sched_switch_prev_state_field;
+
 	/** Pointer to the sched_wakeup_event object. */
 	struct tep_event_format	*sched_wakeup_event;
=20
@@ -62,13 +65,15 @@ struct plugin_sched_context {
=20
 int plugin_get_next_pid(struct tep_record *record);
=20
-int plugin_get_wakeup_pid(struct tep_record *record);
+bool plugin_wakeup_match_rec_pid(struct kshark_context *kshark_ctx,
+				 struct kshark_entry *e, int pid);
=20
-bool plugin_wakeup_match_pid(struct kshark_context *kshark_ctx,
-			     struct kshark_entry *e, int pid);
+bool plugin_switch_match_rec_pid(struct kshark_context *kshark_ctx,
+				 struct kshark_entry *e, int pid);
=20
-bool plugin_switch_match_pid(struct kshark_context *kshark_ctx,
-			     struct kshark_entry *e, int pid);
+bool plugin_switch_match_entry_pid(struct kshark_context *kshark_ctx,
+				   struct kshark_entry *e,
+				   int pid);
=20
 void plugin_draw(struct kshark_cpp_argv *argv, int pid, int draw_action);
=20
--=20
2.17.1
