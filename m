Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38308 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730250AbfAINKD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Jan 2019 08:10:03 -0500
Received: by mail-wm1-f68.google.com with SMTP id m22so8192841wml.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Jan 2019 05:10:02 -0800 (PST)
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/6] kernel-shark-qt: Make the selection in the Table less touchy
Date: Wed,  9 Jan 2019 15:09:42 +0200
Message-Id: <20190109130945.28519-4-ykaradzhov@vmware.com>
In-Reply-To: <20190109130945.28519-1-ykaradzhov@vmware.com>
References: <20190109130945.28519-1-ykaradzhov@vmware.com>
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

diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/KsTraceViewer.cpp
index d64c2af..2418de3 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -30,6 +30,23 @@ void KsTableView::mousePressEvent(QMouseEvent *e) {
 	QTableView::mousePressEvent(e);
 }
 
+/**
+ * Reimplemented the handler for Auto-scrolling. With this we disable
+ * the Horizontal Auto-scrolling.
+ */
+void KsTableView::scrollTo(const QModelIndex &index, ScrollHint hint)
+{
+	int bottomMargin(2);
+
+	if (hint == QAbstractItemView::EnsureVisible &&
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
 	int nColumns = _tableHeader.count();
 	int tableSize(0), viewSize, freeSpace;
 
+	_resizeToContents();
 	for (int c = 0; c < nColumns; ++c) {
 		tableSize += _view.columnWidth(c);
 	}
diff --git a/kernel-shark-qt/src/KsTraceViewer.hpp b/kernel-shark-qt/src/KsTraceViewer.hpp
index a89fce1..a8c1fe6 100644
--- a/kernel-shark-qt/src/KsTraceViewer.hpp
+++ b/kernel-shark-qt/src/KsTraceViewer.hpp
@@ -33,6 +33,8 @@ public:
 	: QTableView(parent) {};
 
 	void mousePressEvent(QMouseEvent *event) override;
+
+	void scrollTo(const QModelIndex &index, ScrollHint hint) override;
 };
 
 /**
-- 
2.17.1
