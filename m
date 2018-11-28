Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710043.outbound.protection.outlook.com ([40.107.71.43]:7840
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728732AbeK2CSR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:17 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 06/17] kernel-shark-qt: Ignore sched_wakeup events if the task
 is running.
Date: Wed, 28 Nov 2018 15:16:14 +0000
Message-ID: <20181128151530.21965-7-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The "Sched Events" plugin uses the sched_wakeup events to visualize
the wake up latency of the task. This patch deals with the corner
case, when we have a second sched_wakeup events which tries to wake
up a task which is already running.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/plugins/SchedEvents.cpp | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel-shark-qt/src/plugins/SchedEvents.cpp b/kernel-shark-qt/=
src/plugins/SchedEvents.cpp
index b4596c9..ea07662 100644
--- a/kernel-shark-qt/src/plugins/SchedEvents.cpp
+++ b/kernel-shark-qt/src/plugins/SchedEvents.cpp
@@ -139,6 +139,21 @@ static void pluginDraw(plugin_sched_context *plugin_ct=
x,
 				ksmodel_get_entry_back(histo, bin, false,
 						       plugin_wakeup_match_rec_pid,
 						       pid, col, &indexOpen);
+
+			if (entryOpen) {
+				int cpu =3D ksmodel_get_cpu_back(histo, bin,
+								      pid,
+								      false,
+								      col,
+								      nullptr);
+				if (cpu >=3D 0) {
+					/*
+					 * The task is already running. Ignore
+					 * this wakeup event.
+					 */
+					entryOpen =3D nullptr;
+				}
+			}
 		}
=20
 		if (rec) {
--=20
2.17.1
