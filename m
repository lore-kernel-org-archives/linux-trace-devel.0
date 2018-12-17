Return-Path: <SRS0=DGv/=O2=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700052.outbound.protection.outlook.com ([40.107.70.52]:10656
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726801AbeLQR4G (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Dec 2018 12:56:06 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 3/3] kernel-shark-qt: Make the Quick Contex menu less touchy
Date: Mon, 17 Dec 2018 17:56:02 +0000
Message-ID: <20181217175516.2944-3-ykaradzhov@vmware.com>
References: <20181217175516.2944-1-ykaradzhov@vmware.com>
In-Reply-To: <20181217175516.2944-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The menu is shifted just a bit so that it is not positioned under
the mouse. This will prevent from an accidental selection of the menu
item under the mouse.

Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsTraceGraph.cpp  | 7 +++++++
 kernel-shark-qt/src/KsTraceViewer.cpp | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/kernel-shark-qt/src/KsTraceGraph.cpp b/kernel-shark-qt/src/KsT=
raceGraph.cpp
index 5144f61..462918f 100644
--- a/kernel-shark-qt/src/KsTraceGraph.cpp
+++ b/kernel-shark-qt/src/KsTraceGraph.cpp
@@ -791,6 +791,13 @@ void KsTraceGraph::_onCustomContextMenu(const QPoint &=
point)
 		QPoint global =3D _glWindow.mapToGlobal(point);
 		global.ry() -=3D menu->sizeHint().height() / 2;
=20
+		/*
+		 * Shift the menu so that it is not positioned under the mouse.
+		 * This will prevent from an accidental selection of the menu
+		 * item under the mouse.
+		 */
+		global.rx() +=3D FONT_WIDTH;
+
 		menu->exec(global);
 	}
 }
diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/Ks=
TraceViewer.cpp
index 09f6a1e..d64c2af 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -272,6 +272,13 @@ void KsTraceViewer::_onCustomContextMenu(const QPoint =
&point)
 		QPoint global =3D _view.mapToGlobal(point);
 		global.ry() -=3D menu.sizeHint().height() / 2;
=20
+		/*
+		 * Shift the menu so that it is not positioned under the mouse.
+		 * This will prevent from an accidental selection of the menu
+		 * item under the mouse.
+		 */
+		global.rx() +=3D FONT_WIDTH;
+
 		connect(&menu,	&KsQuickContextMenu::addTaskPlot,
 			this,	&KsTraceViewer::addTaskPlot);
=20
--=20
2.17.1
