Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-cys01nam02on0082.outbound.protection.outlook.com ([104.47.37.82]:58643
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725752AbeKJFdL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 10 Nov 2018 00:33:11 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 1/8] kernel-shark-qt: Reset the second pass hash when
 reloading Sched plugin
Date: Fri, 9 Nov 2018 19:50:24 +0000
Message-ID: <20181109195004.25455-2-ykaradzhov@vmware.com>
References: <20181109195004.25455-1-ykaradzhov@vmware.com>
In-Reply-To: <20181109195004.25455-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

When the plugin is reloaded, the trace data gets reloaded as well.
Hence the second pass over the data has to be repeated.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/plugins/SchedEvents.cpp | 15 ++++++---------
 kernel-shark-qt/src/plugins/sched_events.c  |  4 ++++
 kernel-shark-qt/src/plugins/sched_events.h  |  3 +++
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel-shark-qt/src/plugins/SchedEvents.cpp b/kernel-shark-qt/=
src/plugins/SchedEvents.cpp
index 7f75baa..5f833df 100644
--- a/kernel-shark-qt/src/plugins/SchedEvents.cpp
+++ b/kernel-shark-qt/src/plugins/SchedEvents.cpp
@@ -193,8 +193,6 @@ static void pluginDraw(plugin_sched_context *plugin_ctx=
,
 	return;
 }
=20
-static std::unordered_set<int> secondPassDone;
-
 /*
  * Ideally, the sched_switch has to be the last trace event recorded befor=
e the
  * task is preempted. Because of this, when the data is loaded (the first =
pass),
@@ -250,8 +248,6 @@ static void secondPass(kshark_entry **data,
 			}
 		}
 	}
-
-	secondPassDone.insert(pid);
 }
=20
 /**
@@ -298,12 +294,13 @@ void plugin_draw(kshark_cpp_argv *argv_c, int pid, in=
t draw_action)
 						      KS_TASK_COLLECTION_MARGIN);
 	}
=20
-	try {
-		if (secondPassDone.find(pid) =3D=3D secondPassDone.end()) {
-			/* The second pass for this task is not done yet. */
-			secondPass(argvCpp->_histo->data, col, pid);
-		}
+	if (!tracecmd_filter_id_find(plugin_ctx->second_pass_hash, pid)) {
+		/* The second pass for this task is not done yet. */
+		secondPass(argvCpp->_histo->data, col, pid);
+		tracecmd_filter_id_add(plugin_ctx->second_pass_hash, pid);
+	}
=20
+	try {
 		pluginDraw(plugin_ctx, kshark_ctx,
 			   argvCpp->_histo, col,
 			   SchedEvent::Switch, pid,
diff --git a/kernel-shark-qt/src/plugins/sched_events.c b/kernel-shark-qt/s=
rc/plugins/sched_events.c
index 80ac214..f23c916 100644
--- a/kernel-shark-qt/src/plugins/sched_events.c
+++ b/kernel-shark-qt/src/plugins/sched_events.c
@@ -79,6 +79,8 @@ static bool plugin_sched_init_context(struct kshark_conte=
xt *kshark_ctx)
 	plugin_ctx->sched_wakeup_new_success_field =3D
 		tep_find_field(event, "success");
=20
+	plugin_ctx->second_pass_hash =3D tracecmd_filter_id_hash_alloc();
+
 	return true;
 }
=20
@@ -279,6 +281,8 @@ static int plugin_sched_close(struct kshark_context *ks=
hark_ctx)
 					plugin_sched_action,
 					plugin_draw);
=20
+	tracecmd_filter_id_hash_free(plugin_ctx->second_pass_hash);
+
 	free(plugin_ctx);
 	plugin_sched_context_handler =3D NULL;
=20
diff --git a/kernel-shark-qt/src/plugins/sched_events.h b/kernel-shark-qt/s=
rc/plugins/sched_events.h
index 5a9406b..481413f 100644
--- a/kernel-shark-qt/src/plugins/sched_events.h
+++ b/kernel-shark-qt/src/plugins/sched_events.h
@@ -55,6 +55,9 @@ struct plugin_sched_context {
 	 * Pointer to the sched_wakeup_new_success_field format descriptor.
 	 */
 	struct tep_format_field	*sched_wakeup_new_success_field;
+
+	/** Hash of the tasks for which the second pass is already done. */
+	struct tracecmd_filter_id	*second_pass_hash;
 };
=20
 int plugin_get_next_pid(struct tep_record *record);
--=20
2.17.1
