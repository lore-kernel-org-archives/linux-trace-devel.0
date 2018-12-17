Return-Path: <SRS0=DGv/=O2=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700052.outbound.protection.outlook.com ([40.107.70.52]:10656
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727468AbeLQR4F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Dec 2018 12:56:05 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 2/3] kernel-shark-qt: Better positioning of the Quick Context
 menu.
Date: Mon, 17 Dec 2018 17:56:01 +0000
Message-ID: <20181217175516.2944-2-ykaradzhov@vmware.com>
References: <20181217175516.2944-1-ykaradzhov@vmware.com>
In-Reply-To: <20181217175516.2944-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

So far I wrongly assumed that the coordinates of the point provided by
the customContextMenuRequested signal are given in the reference frame
of the parent widget (KsTraceGraph or KsTraceViewer). In fact the signal
is emitted by the child widget (KsGLWidget or KsTableView) and the
coordinates are given in the reference frame of the child. This patch
provides a proper positioning of the menu.

Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsTraceGraph.cpp  | 13 ++++++++-----
 kernel-shark-qt/src/KsTraceViewer.cpp | 13 +++++++++++--
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/kernel-shark-qt/src/KsTraceGraph.cpp b/kernel-shark-qt/src/KsT=
raceGraph.cpp
index 858930c..5144f61 100644
--- a/kernel-shark-qt/src/KsTraceGraph.cpp
+++ b/kernel-shark-qt/src/KsTraceGraph.cpp
@@ -136,7 +136,7 @@ KsTraceGraph::KsTraceGraph(QWidget *parent)
 		this,			&KsTraceGraph::_updateTimeLegends);
=20
 	_glWindow.setContextMenuPolicy(Qt::CustomContextMenu);
-	connect(&_glWindow,	&QTableView::customContextMenuRequested,
+	connect(&_glWindow,	&QWidget::customContextMenuRequested,
 		this,		&KsTraceGraph::_onCustomContextMenu);
=20
 	_scrollArea.setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
@@ -782,12 +782,15 @@ void KsTraceGraph::_onCustomContextMenu(const QPoint =
&point)
 		connect(menu,	&KsQuickMarkerMenu::deselect,
 			this,	&KsTraceGraph::deselect);
=20
-		QPoint global =3D mapToGlobal(point);
 		/*
-		 * The global coordinates have to be corrected for the offset
-		 * of the vertical scrollbar.
+		 * Note that this slot was connected to the
+		 * customContextMenuRequested signal of the OpenGL widget.
+		 * Because of this the coordinates of the point are given with
+		 * respect to the frame of this widget.
 		 */
-		global.ry() -=3D _scrollArea.verticalScrollBar()->value();
+		QPoint global =3D _glWindow.mapToGlobal(point);
+		global.ry() -=3D menu->sizeHint().height() / 2;
+
 		menu->exec(global);
 	}
 }
diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/Ks=
TraceViewer.cpp
index 971793f..09f6a1e 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -150,7 +150,7 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
 		this, &KsTraceViewer::_searchReset);
=20
 	_view.setContextMenuPolicy(Qt::CustomContextMenu);
-	connect(&_view,	&QTableView::customContextMenuRequested,
+	connect(&_view,	&QWidget::customContextMenuRequested,
 		this,	&KsTraceViewer::_onCustomContextMenu);
=20
 	connect(&_view,	&QTableView::clicked,
@@ -263,13 +263,22 @@ void KsTraceViewer::_onCustomContextMenu(const QPoint=
 &point)
 		size_t row =3D _proxyModel.mapRowFromSource(i.row());
 		KsQuickContextMenu menu(_data, row, _mState, this);
=20
+		/*
+		 * Note that this slot was connected to the
+		 * customContextMenuRequested signal of the Table widget.
+		 * Because of this the coordinates of the point are given with
+		 * respect to the frame of this widget.
+		 */
+		QPoint global =3D _view.mapToGlobal(point);
+		global.ry() -=3D menu.sizeHint().height() / 2;
+
 		connect(&menu,	&KsQuickContextMenu::addTaskPlot,
 			this,	&KsTraceViewer::addTaskPlot);
=20
 		connect(&menu,	&KsQuickMarkerMenu::deselect,
 			this,	&KsTraceViewer::deselect);
=20
-		menu.exec(mapToGlobal(point));
+		menu.exec(global);
 	}
 }
=20
--=20
2.17.1
