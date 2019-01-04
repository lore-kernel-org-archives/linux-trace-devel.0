Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-eopbgr810042.outbound.protection.outlook.com ([40.107.81.42]:30548
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725930AbfADT61 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Jan 2019 14:58:27 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 3/4] kernel-shark-qt: Make the selection in the Table less
 touchy
Date: Fri, 4 Jan 2019 19:57:53 +0000
Message-ID: <20190104195726.24264-3-ykaradzhov@vmware.com>
References: <20190104195726.24264-1-ykaradzhov@vmware.com>
In-Reply-To: <20190104195726.24264-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch aims to make the selection in the table by using the
mouse more intuitive (less touchy). First of all, it disables
the auto-scrolling in horizontal direction. In addition to this,
it makes sure that all columns of the table have proper sizes
when the main window gets resized by the user.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsTraceViewer.cpp | 18 ++++++++++++++++++
 kernel-shark-qt/src/KsTraceViewer.hpp |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/Ks=
TraceViewer.cpp
index d64c2af..2418de3 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -30,6 +30,23 @@ void KsTableView::mousePressEvent(QMouseEvent *e) {
 	QTableView::mousePressEvent(e);
 }
=20
+/**
+ * Reimplemented the handler for Auto-scrolling. With this we disable
+ * the Horizontal Auto-scrolling.
+ */
+void KsTableView::scrollTo(const QModelIndex &index, ScrollHint hint)
+{
+	int bottomMargin(2);
+
+	if (hint =3D=3D QAbstractItemView::EnsureVisible &&
+	    index.row() > indexAt(rect().topLeft()).row() &&
+	    index.row() < indexAt(rect().bottomLeft()).row() - bottomMargin)
+		return;
+
+	QTableView::scrollTo(index, hint);
+}
+
+
 /** Create a default (empty) Trace viewer widget. */
 KsTraceViewer::KsTraceViewer(QWidget *parent)
 : QWidget(parent),
@@ -588,6 +605,7 @@ void KsTraceViewer::resizeEvent(QResizeEvent* event)
 	int nColumns =3D _tableHeader.count();
 	int tableSize(0), viewSize, freeSpace;
=20
+	_resizeToContents();
 	for (int c =3D 0; c < nColumns; ++c) {
 		tableSize +=3D _view.columnWidth(c);
 	}
diff --git a/kernel-shark-qt/src/KsTraceViewer.hpp b/kernel-shark-qt/src/Ks=
TraceViewer.hpp
index a89fce1..a8c1fe6 100644
--- a/kernel-shark-qt/src/KsTraceViewer.hpp
+++ b/kernel-shark-qt/src/KsTraceViewer.hpp
@@ -33,6 +33,8 @@ public:
 	: QTableView(parent) {};
=20
 	void mousePressEvent(QMouseEvent *event) override;
+
+	void scrollTo(const QModelIndex &index, ScrollHint hint) override;
 };
=20
 /**
--=20
2.17.1
