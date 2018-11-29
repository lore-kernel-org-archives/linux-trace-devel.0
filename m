Return-Path: <SRS0=ZWpJ=OI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr740080.outbound.protection.outlook.com ([40.107.74.80]:37312
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731655AbeK3CCC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Nov 2018 21:02:02 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] kernel-shark-qt: Don't use collection when searching for
 sched_wakeup
Date: Thu, 29 Nov 2018 14:56:22 +0000
Message-ID: <20181129145600.8803-2-ykaradzhov@vmware.com>
References: <20181129145600.8803-1-ykaradzhov@vmware.com>
In-Reply-To: <20181129145600.8803-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch modifies the way the wake up latency is plotted by
the Sched events plugin. The sched_wakeup event does not belong to
the task it is waking, hence we cannot use the task's collection
to search for it. It was partially working so far because in most
of the cases the sched_wakeup event happened to be inside the
"margins" of the collection. Note that if we do not use collection
when searching, the time complexity of the plugin becomes linear.
However, this should not be a problem, because we have an explicit
cut which disables plotting if the number of entries shown by
the graph is bigger than PLUGIN_MAX_ENTRIES (10 000).

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/plugins/SchedEvents.cpp | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel-shark-qt/src/plugins/SchedEvents.cpp b/kernel-shark-qt/=
src/plugins/SchedEvents.cpp
index ea07662..c8dc3bf 100644
--- a/kernel-shark-qt/src/plugins/SchedEvents.cpp
+++ b/kernel-shark-qt/src/plugins/SchedEvents.cpp
@@ -122,7 +122,7 @@ static void pluginDraw(plugin_sched_context *plugin_ctx=
,
 			/*
 			 * Starting from the last element in this bin, go backward
 			 * in time until you find a trace entry that satisfies the
-			 * condition defined by plugin_switch_match_pid.
+			 * condition defined by plugin_switch_match_rec_pid.
 			 */
 			entryOpen =3D
 				ksmodel_get_entry_back(histo, bin, false,
@@ -133,12 +133,16 @@ static void pluginDraw(plugin_sched_context *plugin_c=
tx,
 			/*
 			 * Starting from the last element in this bin, go backward
 			 * in time until you find a trace entry that satisfies the
-			 * condition defined by plugin_wakeup_match_pid.
+			 * condition defined by plugin_wakeup_match_rec_pid. Note
+			 * that the wakeup event does not belong to this task,
+			 * hence we cannot use the task's collection.
 			 */
 			entryOpen =3D
 				ksmodel_get_entry_back(histo, bin, false,
 						       plugin_wakeup_match_rec_pid,
-						       pid, col, &indexOpen);
+						       pid,
+						       nullptr, // No collection.
+						       &indexOpen);
=20
 			if (entryOpen) {
 				int cpu =3D ksmodel_get_cpu_back(histo, bin,
--=20
2.17.1
