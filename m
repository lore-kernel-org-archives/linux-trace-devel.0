Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710075.outbound.protection.outlook.com ([40.107.71.75]:2944
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728754AbeK2CSa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:30 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 11/17] kernel-shark-qt: Sort all graphs before plotting
Date: Wed, 28 Nov 2018 15:16:20 +0000
Message-ID: <20181128151530.21965-12-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The CPU/Task graphs are plotted in sorted order. The graph
having smallest CPU id/Pid will be plotted first (on top).

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsTraceGraph.cpp | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel-shark-qt/src/KsTraceGraph.cpp b/kernel-shark-qt/src/KsT=
raceGraph.cpp
index 09b322a..0b5a8b1 100644
--- a/kernel-shark-qt/src/KsTraceGraph.cpp
+++ b/kernel-shark-qt/src/KsTraceGraph.cpp
@@ -439,6 +439,7 @@ void KsTraceGraph::addCPUPlot(int cpu)
 		return;
=20
 	_glWindow._cpuList.append(cpu);
+	qSort(_glWindow._cpuList);
 	_selfUpdate();
 }
=20
@@ -449,6 +450,7 @@ void KsTraceGraph::addTaskPlot(int pid)
 		return;
=20
 	_glWindow._taskList.append(pid);
+	qSort(_glWindow._taskList);
 	_selfUpdate();
 }
=20
--=20
2.17.1
