Return-Path: <SRS0=XDEQ=MW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam02on0088.outbound.protection.outlook.com ([104.47.36.88]:15392
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727783AbeJKDgL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Oct 2018 23:36:11 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH] kernel-shark-qt: Fix the glitches in the preemption time
 visualization
Date: Wed, 10 Oct 2018 20:12:21 +0000
Message-ID: <20181010201154.23881-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This problem was reported by Steven Rostedt. The reason for having
the problem was my wrong assumption that for a given task the
sched_switch event is always the last record.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/plugins/SchedEvents.cpp | 52 +++++++++++++++++++++
 kernel-shark-qt/src/plugins/sched_events.c  |  3 --
 2 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/kernel-shark-qt/src/plugins/SchedEvents.cpp b/kernel-shark-qt/=
src/plugins/SchedEvents.cpp
index 713feb4..7e5c4ad 100644
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
@@ -29,6 +30,8 @@
=20
 #define PLUGIN_MAX_ENTRIES_PER_BIN 500
=20
+#define KS_TASK_COLLECTION_MARGIN 25
+
 //! @endcond
=20
 extern struct plugin_sched_context *plugin_sched_context_handler;
@@ -215,6 +218,41 @@ static void pluginDraw(plugin_sched_context *plugin_ct=
x,
 	return;
 }
=20
+static std::unordered_set<int> singlePassDone;
+
+static void singlePass(kshark_entry **data,
+		       kshark_entry_collection *col,
+		       int pid)
+{
+	kshark_entry *last;
+	int first, n;
+	ssize_t index;
+
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
+		if (!kshark_get_entry_back(req, data, &index))
+			continue;
+
+		for (last =3D data[index]; last->next; last =3D last->next) {
+			if (last->next->pid !=3D pid) {
+				last->pid =3D data[index]->pid;
+				last->visible &=3D ~KS_PLUGIN_UNTOUCHED_MASK;
+				break;
+			}
+		}
+	}
+
+	singlePassDone.insert(pid);
+}
+
 /**
  * @brief Plugin's draw function.
  *
@@ -246,8 +284,22 @@ void plugin_draw(kshark_cpp_argv *argv_c, int pid, int=
 draw_action)
 	 */
 	col =3D kshark_find_data_collection(kshark_ctx->collections,
 					  kshark_match_pid, pid);
+	if (!col) {
+		/*
+		 * If a data collection for this task does not exist,
+		 * register a new one.
+		 */
+		col =3D kshark_register_data_collection(kshark_ctx,
+						      _data->rows(),
+						      _data->size(),
+						      kshark_match_pid, pid,
+						      KS_TASK_COLLECTION_MARGIN);
+	}
=20
 	try {
+		if (singlePassDone.find(pid) =3D=3D singlePassDone.end())
+			singlePass(argvCpp->_histo->data, col, pid);
+
 		pluginDraw(plugin_ctx, kshark_ctx,
 			   argvCpp->_histo, col,
 			   SchedEvent::Switch, pid,
diff --git a/kernel-shark-qt/src/plugins/sched_events.c b/kernel-shark-qt/s=
rc/plugins/sched_events.c
index 13f3c4a..4bcaa48 100644
--- a/kernel-shark-qt/src/plugins/sched_events.c
+++ b/kernel-shark-qt/src/plugins/sched_events.c
@@ -224,9 +224,6 @@ bool plugin_switch_match_pid(struct kshark_context *ksh=
ark_ctx,
 	struct tep_record *record =3D NULL;
 	int switch_pid =3D -1;
=20
-	if (e->pid =3D=3D pid)
-		return true;
-
 	plugin_ctx =3D plugin_sched_context_handler;
=20
 	if (plugin_ctx->sched_switch_event &&
--=20
2.17.1
