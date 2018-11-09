Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-cys01nam02on0088.outbound.protection.outlook.com ([104.47.37.88]:36407
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725883AbeKJFdC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 10 Nov 2018 00:33:02 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 3/8] kernel-shark-qt: Update the visualization model when
 updating Graphs
Date: Fri, 9 Nov 2018 19:50:26 +0000
Message-ID: <20181109195004.25455-4-ykaradzhov@vmware.com>
References: <20181109195004.25455-1-ykaradzhov@vmware.com>
In-Reply-To: <20181109195004.25455-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Updating the model when the Graph widget is doing self-update, guarantees
that all previously plotted graphs are wiped out before plotting something
new.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsTraceGraph.cpp | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel-shark-qt/src/KsTraceGraph.cpp b/kernel-shark-qt/src/KsT=
raceGraph.cpp
index 21a09d0..29a5950 100644
--- a/kernel-shark-qt/src/KsTraceGraph.cpp
+++ b/kernel-shark-qt/src/KsTraceGraph.cpp
@@ -215,6 +215,7 @@ void KsTraceGraph::_selfUpdate()
 	_updateGraphLegends();
 	_updateTimeLegends();
 	_markerReDraw();
+	_glWindow.model()->update();
 	updateGeom();
 }
=20
--=20
2.17.1
