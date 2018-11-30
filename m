Return-Path: <SRS0=EnxC=OJ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr690083.outbound.protection.outlook.com ([40.107.69.83]:12320
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726572AbeLACr5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Nov 2018 21:47:57 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 1/2] kernel-shark-qt: Correct the coordinates of the Quick
 Context Menu
Date: Fri, 30 Nov 2018 15:38:11 +0000
Message-ID: <20181130153749.4419-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The "Y" coordinate of the Quick Context Menu has to be corrected in
the case when the menu gets opened from the Graph widget. This is
needed because the Graph widget is nested inside a scroll area and
we have to take into account the offset of the vertical scrollbar.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsTraceGraph.cpp | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel-shark-qt/src/KsTraceGraph.cpp b/kernel-shark-qt/src/KsT=
raceGraph.cpp
index 0b5a8b1..858930c 100644
--- a/kernel-shark-qt/src/KsTraceGraph.cpp
+++ b/kernel-shark-qt/src/KsTraceGraph.cpp
@@ -782,6 +782,12 @@ void KsTraceGraph::_onCustomContextMenu(const QPoint &=
point)
 		connect(menu,	&KsQuickMarkerMenu::deselect,
 			this,	&KsTraceGraph::deselect);
=20
-		menu->exec(mapToGlobal(point));
+		QPoint global =3D mapToGlobal(point);
+		/*
+		 * The global coordinates have to be corrected for the offset
+		 * of the vertical scrollbar.
+		 */
+		global.ry() -=3D _scrollArea.verticalScrollBar()->value();
+		menu->exec(global);
 	}
 }
--=20
2.17.1
