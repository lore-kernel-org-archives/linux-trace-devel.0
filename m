Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490F4C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E61DB64E95
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhBKKic (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhBKKfs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:35:48 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37355C06121F
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:40 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id b9so9214553ejy.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WBhagRs6pIZGEyxRjdwErefVL8BSm6/FZN1XY85vENw=;
        b=CIYjETQCVPB2aNax62h2VMUkM4GCIuSx0kRMmB4he3Scj/4de9qeLILm04Nk7zekI5
         uwhshn1iHw+Hb1zwv3hLKrVeYo2rTmxD7r5K+sqIl7L6r/mD49Tl8Y3eGczuHS3meitn
         GhO/xHIPOEoCcMIQhPQqrNySmZx6/sEMMuA5YlR9ZBsln9SgnLtTq7XLNyDpKXjonGnl
         k1Bl+vJt79PBK3g6npOZosXS0qySGIdXy9J2YvzUcPcXhNDuS96OdpS/Mh1L4/v6Jykt
         VVAkXSdM61sizKrf7VmUgGeUHaq6hF7NzSp76H5bu/apDGqWo7PJSPG9yojCWhGph/n1
         G+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WBhagRs6pIZGEyxRjdwErefVL8BSm6/FZN1XY85vENw=;
        b=U9dyliKKxe5EVN+WYpF8dtdOYZAaBWS1Fa7Npw5wsvDxcwlyoEQb7ZzoITHaTnzYWs
         Zt6UQFR/5DSNSNRjlokR8d0wTl06G6ZkWYLpD5ftDJNq28rBppygbPdI3vC9JN+/ULG5
         QscdtDUtCgfBPB+MsWt+3+h/7YRWL3c2mjrYTAVizuhDMtUim0OAM/B3T05mmquCBhQl
         /iQEjzRF4Jiyol62R4B8qRQyToOaaj4fkbldwtd+UFbk0UF3c27/n/ocZh7TYJeGR17m
         D1TfUqp1HRGKq3ag9gx8ixe/qrcQh52flNyqRsPdsYit39CmWaK9NY3BXHTSH63BDKpG
         F6cQ==
X-Gm-Message-State: AOAM531Xtt8XIuPpGgcNcvOs0Pt2cF1q6m75biCwqU20RSPjqNyKvuAO
        8wdBKS3nxvXkEzYQHXMQ9jg=
X-Google-Smtp-Source: ABdhPJzS4kLABEfCprPdPQpyVqHauCf86WIxbX39D8B+4/DsH8UHjdEXOS5LAQPf3kTug09pe6CViw==
X-Received: by 2002:a17:906:1447:: with SMTP id q7mr8168354ejc.27.1613039558936;
        Thu, 11 Feb 2021 02:32:38 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:38 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 18/27] kernel-shark: Update KsTraceViewer
Date:   Thu, 11 Feb 2021 12:31:56 +0200
Message-Id: <20210211103205.418588-19-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The compilation of KsTraceViewer.cpp is re-enabled and all
functionalities are made compatible with the new version of
the C API of libkshark (KernelShark 2.0).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt    |  4 +--
 src/KsTraceGraph.hpp  |  5 +++-
 src/KsTraceViewer.cpp | 57 +++++++++++++++++++++++++++++--------------
 src/KsTraceViewer.hpp | 13 +++++++---
 4 files changed, 54 insertions(+), 25 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index ab74d5a..e09deb7 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -73,7 +73,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
                         KsDualMarker.hpp
                         KsWidgetsLib.hpp
                         KsTraceGraph.hpp
-#                         KsTraceViewer.hpp
+                        KsTraceViewer.hpp
 #                         KsMainWindow.hpp
 #                         KsCaptureDialog.hpp
                         KsQuickContextMenu.hpp)
@@ -89,7 +89,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
                                                             KsDualMarker.cpp
                                                             KsWidgetsLib.cpp
                                                             KsTraceGraph.cpp
-#                                                             KsTraceViewer.cpp
+                                                            KsTraceViewer.cpp
 #                                                             KsMainWindow.cpp
 #                                                             KsCaptureDialog.cpp
                                                             KsQuickContextMenu.cpp)
diff --git a/src/KsTraceGraph.hpp b/src/KsTraceGraph.hpp
index 0e31b88..6e83f21 100644
--- a/src/KsTraceGraph.hpp
+++ b/src/KsTraceGraph.hpp
@@ -29,7 +29,10 @@ public:
 	 * Reimplemented handler for mouse wheel events. All mouse wheel
 	 * events will be ignored.
 	 */
-	void wheelEvent(QWheelEvent *evt) {evt->ignore();}
+	void wheelEvent(QWheelEvent *evt) {
+		if (QApplication::keyboardModifiers() != Qt::ControlModifier)
+			QScrollArea::wheelEvent(evt);
+	}
 };
 
 /**
diff --git a/src/KsTraceViewer.cpp b/src/KsTraceViewer.cpp
index 0e0e3d4..afd5a85 100644
--- a/src/KsTraceViewer.cpp
+++ b/src/KsTraceViewer.cpp
@@ -9,7 +9,7 @@
  *  @brief   KernelShark Trace Viewer widget.
  */
 
-// C++11
+// C++
 #include <thread>
 #include <future>
 #include <queue>
@@ -50,11 +50,10 @@ void KsTableView::scrollTo(const QModelIndex &index, ScrollHint hint)
 
 /** Create a default (empty) Trace viewer widget. */
 KsTraceViewer::KsTraceViewer(QWidget *parent)
-: QWidget(parent),
+: KsWidgetsLib::KsDataWidget(parent),
   _view(this),
   _model(this),
   _proxyModel(this),
-  _tableHeader(_model.header()),
   _toolbar(this),
   _labelSearch("Search: Column", this),
   _labelGrFollows("Graph follows  ", this),
@@ -72,7 +71,7 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
 
 	/* On the toolbar make two Combo boxes for the search settings. */
 	_toolbar.addWidget(&_labelSearch);
-	_searchFSM._columnComboBox.addItems(_tableHeader);
+	_searchFSM._columnComboBox.addItems(_model.header());
 
 	/*
 	 * Using the old Signal-Slot syntax because
@@ -163,6 +162,9 @@ void KsTraceViewer::loadData(KsDataStore *data)
 	_model.fill(data);
 	this->_resizeToContents();
 
+	_searchFSM._columnComboBox.clear();
+	_searchFSM._columnComboBox.addItems(_model.header());
+
 	this->setMinimumHeight(SCREEN_HEIGHT / 5);
 }
 
@@ -172,8 +174,8 @@ void KsTraceViewer::setMarkerSM(KsDualMarkerSM *m)
 	QString styleSheetA, styleSheetB;
 
 	_mState = m;
-	_model.setColors(_mState->markerA()._color,
-			 _mState->markerB()._color);
+	_model.setMarkerColors(_mState->markerA()._color,
+			       _mState->markerB()._color);
 
 	/*
 	 * Assign a property to State A of the Dual marker state machine. When
@@ -234,6 +236,7 @@ void KsTraceViewer::update(KsDataStore *data)
 	_data = data;
 	if (_mState->activeMarker()._isSet)
 		showRow(_mState->activeMarker()._pos, true);
+	_resizeToContents();
 }
 
 void KsTraceViewer::_onCustomContextMenu(const QPoint &point)
@@ -246,7 +249,7 @@ void KsTraceViewer::_onCustomContextMenu(const QPoint &point)
 		 * of the row number in the source model.
 		 */
 		size_t row = _proxyModel.mapRowFromSource(i.row());
-		KsQuickContextMenu menu(_data, row, _mState, this);
+		KsQuickContextMenu menu(_mState, _data, row, this);
 
 		/*
 		 * Note that this slot was connected to the
@@ -290,7 +293,7 @@ void KsTraceViewer::_graphFollowsChanged(int state)
 
 	_graphFollows = (bool) state;
 	if (_graphFollows && row != KS_NO_ROW_SELECTED)
-		emit select(row); // Send a signal to the Graph widget.
+		emit select(*_it); // Send a signal to the Graph widget.
 }
 
 void KsTraceViewer::_search()
@@ -459,7 +462,7 @@ void KsTraceViewer::clearSelection()
 /** Switch the Dual marker. */
 void KsTraceViewer::markSwitch()
 {
-	int row;
+	ssize_t row;
 
 	/* The state of the Dual marker has changed. Get the new active marker. */
 	DualMarkerState state = _mState->getState();
@@ -490,7 +493,7 @@ void KsTraceViewer::markSwitch()
 		 * The index in the source model is used to retrieve the value
 		 * of the row number in the proxy model.
 		 */
-		size_t row =_mState->getMarker(state)._pos;
+		row =_mState->getMarker(state)._pos;
 
 		QModelIndex index =
 			_proxyModel.mapFromSource(_model.index(row, 0));
@@ -525,7 +528,7 @@ void KsTraceViewer::markSwitch()
  */
 void KsTraceViewer::resizeEvent(QResizeEvent* event)
 {
-	int nColumns = _tableHeader.count();
+	int nColumns = _model.header().count();
 	int tableSize(0), viewSize, freeSpace;
 
 	_resizeToContents();
@@ -564,7 +567,7 @@ void KsTraceViewer::keyReleaseEvent(QKeyEvent *event)
 
 void KsTraceViewer::_resizeToContents()
 {
-	int rows, columnSize, markRow = selectedRow();
+	int col, rows, columnSize, markRow = selectedRow();
 
 	_view.setVisible(false);
 	_view.resizeColumnsToContents();
@@ -579,13 +582,22 @@ void KsTraceViewer::_resizeToContents()
 		_view.clearSelection();
 
 	/*
-	 * Because of some unknown reason the first column doesn't get
+	 * Because of some unknown reason some of the columns doesn't get
 	 * resized properly by the code above. We will resize this
 	 * column by hand.
 	 */
+	col = KsViewModel::TRACE_VIEW_COL_STREAM;
+	columnSize = STRING_WIDTH(_model.header()[col]) + FONT_WIDTH;
+	_view.setColumnWidth(col, columnSize);
+
+	col = KsViewModel::TRACE_VIEW_COL_CPU;
+	columnSize = STRING_WIDTH(_model.header()[col]) + FONT_WIDTH * 2;
+	_view.setColumnWidth(col, columnSize);
+
+	col = KsViewModel::TRACE_VIEW_COL_INDEX;
 	rows = _model.rowCount({});
 	columnSize = STRING_WIDTH(QString("%1").arg(rows)) + FONT_WIDTH;
-	_view.setColumnWidth(0, columnSize);
+	_view.setColumnWidth(col, columnSize);
 }
 
 //! @cond Doxygen_Suppress
@@ -598,7 +610,16 @@ size_t KsTraceViewer::_searchItems()
 {
 	int column = _searchFSM._columnComboBox.currentIndex();
 	QString searchText = _searchFSM._searchLineEdit.text();
-	int count, dataRow;
+	int count, dataRow, columnIndex = column;
+
+	if (_model.singleStream()) {
+		/*
+		 * If only one Data stream (file) is loaded, the first column
+		 * (TRACE_VIEW_COL_STREAM) is not shown. The column index has
+		 * to be corrected.
+		 */
+		++columnIndex;
+	}
 
 	if (searchText.isEmpty()) {
 		/*
@@ -620,8 +641,8 @@ size_t KsTraceViewer::_searchItems()
 	} else {
 		_searchFSM.handleInput(sm_input_t::Start);
 
-		if (column == KsViewModel::TRACE_VIEW_COL_INFO ||
-		    column == KsViewModel::TRACE_VIEW_COL_LAT)
+		if (columnIndex == KsViewModel::TRACE_VIEW_COL_INFO ||
+		    columnIndex == KsViewModel::TRACE_VIEW_COL_AUX)
 			_searchItemsST();
 		else
 			_searchItemsMT();
@@ -761,7 +782,7 @@ void KsTraceViewer::_searchItemsMT()
 		};
 
 		for (int i = 0; i < mapList.size(); ++i)
-			if ( mapList[i].count()) {
+			if (mapList[i].count()) {
 				queue.push(std::make_pair(i, mapList[i].front()));
 				mapList[i].pop_front();
 			}
diff --git a/src/KsTraceViewer.hpp b/src/KsTraceViewer.hpp
index 6080d0d..f3979a6 100644
--- a/src/KsTraceViewer.hpp
+++ b/src/KsTraceViewer.hpp
@@ -20,6 +20,7 @@
 #include "KsModels.hpp"
 #include "KsSearchFSM.hpp"
 #include "KsDualMarker.hpp"
+#include "KsWidgetsLib.hpp"
 
 /**
  * Table View class, needed in order to reimplemented the handler for mouse
@@ -42,7 +43,7 @@ public:
  * The KsTraceViewer class provides a widget for browsing in the trace data
  * shown in a text form.
  */
-class KsTraceViewer : public QWidget
+class KsTraceViewer : public KsWidgetsLib::KsDataWidget
 {
 	Q_OBJECT
 public:
@@ -74,6 +75,12 @@ public:
 
 	void update(KsDataStore *data);
 
+	/** Update the color scheme used by the model. */
+	void loadColors()
+	{
+		_model.loadColors();
+	}
+
 signals:
 	/** Signal emitted when new row is selected. */
 	void select(size_t);
@@ -82,7 +89,7 @@ signals:
 	 * This signal is used to re-emitted the addTaskPlot signal of the
 	 * KsQuickContextMenu.
 	 */
-	void addTaskPlot(int pid);
+	void addTaskPlot(int sd, int pid);
 
 	/**
 	 * This signal is used to re-emitted the deselect signal of the
@@ -99,8 +106,6 @@ private:
 
 	KsFilterProxyModel	_proxyModel;
 
-	QStringList	_tableHeader;
-
 	QToolBar	_toolbar;
 
 	QLabel		_labelSearch, _labelGrFollows;
-- 
2.25.1

