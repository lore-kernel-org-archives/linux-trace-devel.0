Received: from 9.mo552.mail-out.ovh.net (9.mo552.mail-out.ovh.net [87.98.180.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1618569F
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.108.9.223])
	by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 10E362A413;
	Sun, 14 Jan 2024 17:17:46 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:45 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S002b2d0a137-1930-426a-8ee2-68f42c9d8f03,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 32/34] kernelshark: Fix KsTableView columns width, and KsTraceViewer size
Date: Sun, 14 Jan 2024 18:17:21 +0100
Message-ID: <20240114171723.14092-33-dev@benjarobin.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240114171723.14092-1-dev@benjarobin.fr>
References: <20240114171723.14092-1-dev@benjarobin.fr>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DAG1EX2.mxp5.local (172.16.2.2) To DAG6EX2.mxp5.local
 (172.16.2.52)
X-Ovh-Tracer-GUID: 80127158-60d5-4190-9a2c-af5a30e1883a
X-Ovh-Tracer-Id: 1673368740826144666
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpeetgfdvtdeiudekffethfejiefggeevhfefveekheelhfduteeujeekiedtgfdtueenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhhvggruggvrhdrrghtnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrddutdekpdelvddrudeiuddruddviedrgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqedpnhgspghrtghpthhtohepuddprhgtphhtthhopeihrdhkrghrrgguiiesghhmrghilhdrtghomhdplhhinhhugidqthhrrggtvgdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheehvddpmhhouggvpehsmhhtphhouhht

- Use QSizePolicy::Expanding for KsTraceViewer object to use full height
- Do not use StyleSheet for KsTableView. When the StyleSheet is updated Qt6
  redraw the whole table but with default column width without querying items
  sizeHint(). So instead use QPalette::Highlight.
- Simplify _resizeToContents() since the columns have a proper width with Qt6

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218351
Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsTraceViewer.cpp | 67 ++++++++++++-------------------------------
 src/KsTraceViewer.hpp |  2 ++
 2 files changed, 20 insertions(+), 49 deletions(-)

diff --git a/src/KsTraceViewer.cpp b/src/KsTraceViewer.cpp
index 86e9185..93535a4 100644
--- a/src/KsTraceViewer.cpp
+++ b/src/KsTraceViewer.cpp
@@ -83,7 +83,7 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
   _mState(nullptr),
   _data(nullptr)
 {
-	this->setSizePolicy(QSizePolicy::Preferred, QSizePolicy::Maximum);
+	this->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
 
 	/* Make a search toolbar. */
 	_toolbar.setOrientation(Qt::Horizontal);
@@ -125,6 +125,7 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
 	int defaultRowHeight = FONT_HEIGHT * 1.25;
 	auto lamSelectionChanged = [this, defaultRowHeight] (const QItemSelection &selected,
 							     const QItemSelection &deselected) {
+
 		if (deselected.count()) {
 			_view.verticalHeader()->resizeSection(deselected.indexes().first().row(),
 							      defaultRowHeight);
@@ -208,33 +209,13 @@ void KsTraceViewer::loadData(KsDataStore *data)
 /** Connect the QTableView widget and the State machine of the Dual marker. */
 void KsTraceViewer::setMarkerSM(KsDualMarkerSM *m)
 {
-	QString styleSheetA, styleSheetB;
-
 	_mState = m;
 	_model.setMarkerColors(_mState->markerA()._color,
 			       _mState->markerB()._color);
 
-	/*
-	 * Assign a property to State A of the Dual marker state machine. When
-	 * the marker is in State A the background color of the selected row
-	 * will be the same as the color of Marker A.
-	 */
-	styleSheetA = "selection-background-color : " +
-		      _mState->markerA()._color.name() + ";";
-
-	_mState->stateAPtr()->assignProperty(&_view, "styleSheet",
-						     styleSheetA);
-
-	/*
-	 * Assign a property to State B. When the marker is in State B the
-	 * background color of the selected row will be the same as the color
-	 * of Marker B.
-	 */
-	styleSheetB = "selection-background-color : " +
-		      _mState->markerB()._color.name() + ";";
-
-	_mState->stateBPtr()->assignProperty(&_view, "styleSheet",
-						     styleSheetB);
+	_viewPalette = _view.palette();
+	_viewPalette.setColor(QPalette::Highlight, _mState->activeMarker()._color);
+	_view.setPalette(_viewPalette);
 }
 
 /** Reset (empty) the table. */
@@ -502,35 +483,38 @@ void KsTraceViewer::markSwitch()
 	ssize_t row;
 
 	/* The state of the Dual marker has changed. Get the new active marker. */
-	DualMarkerState state = _mState->getState();
+	DualMarkerState actState = _mState->getState();
+	DualMarkerState pasState = !actState;
 
 	/* First deal with the passive marker. */
-	if (_mState->getMarker(!state)._isSet) {
+	KsGraphMark &pasMark = _mState->getMarker(pasState);
+	if (pasMark._isSet) {
 		/*
 		 * The passive marker is set. Use the model to color the row of
 		 * the passive marker.
 		 */
-		_model.selectRow(!state, _mState->getMarker(!state)._pos);
+		_model.selectRow(pasState, pasMark._pos);
 	}
 	else {
 		/*
 		 * The passive marker is not set.
 		 * Make sure that the model colors nothing.
 		 */
-		_model.selectRow(!state, KS_NO_ROW_SELECTED);
+		_model.selectRow(pasState, KS_NO_ROW_SELECTED);
 	}
 
 	/*
 	 * Now deal with the active marker. This has to be done after dealing
 	 *  with the model, because changing the model clears the selection.
 	 */
-	if (_mState->getMarker(state)._isSet) {
+	KsGraphMark &actMark = _mState->getMarker(actState);
+	if (actMark._isSet) {
 		/*
 		 * The active marker is set. Use QTableView to select its row.
 		 * The index in the source model is used to retrieve the value
 		 * of the row number in the proxy model.
 		 */
-		row =_mState->getMarker(state)._pos;
+		row = actMark._pos;
 
 		QModelIndex index =
 			_proxyModel.mapFromSource(_model.index(row, 0));
@@ -552,6 +536,9 @@ void KsTraceViewer::markSwitch()
 		_view.clearSelection();
 	}
 
+	_viewPalette.setColor(QPalette::Highlight, actMark._color);
+	_view.setPalette(_viewPalette);
+
 	row = selectedRow();
 	if (row >= 0) {
 		_setSearchIterator(row);
@@ -604,7 +591,7 @@ void KsTraceViewer::keyReleaseEvent(QKeyEvent *event)
 
 void KsTraceViewer::_resizeToContents()
 {
-	int col, rows, columnSize, markRow = selectedRow();
+	int markRow = selectedRow();
 
 	_view.setVisible(false);
 	_view.resizeColumnsToContents();
@@ -617,24 +604,6 @@ void KsTraceViewer::_resizeToContents()
 	 */
 	if (markRow == KS_NO_ROW_SELECTED)
 		_view.clearSelection();
-
-	/*
-	 * Because of some unknown reason some of the columns doesn't get
-	 * resized properly by the code above. We will resize this
-	 * column by hand.
-	 */
-	col = KsViewModel::TRACE_VIEW_COL_STREAM;
-	columnSize = STRING_WIDTH(_model.header().at(col)) + FONT_WIDTH;
-	_view.setColumnWidth(col, columnSize);
-
-	col = KsViewModel::TRACE_VIEW_COL_CPU;
-	columnSize = STRING_WIDTH(_model.header().at(col)) + FONT_WIDTH * 2;
-	_view.setColumnWidth(col, columnSize);
-
-	col = KsViewModel::TRACE_VIEW_COL_INDEX;
-	rows = _model.rowCount({});
-	columnSize = STRING_WIDTH(QString("%1").arg(rows)) + FONT_WIDTH;
-	_view.setColumnWidth(col, columnSize);
 }
 
 //! @cond Doxygen_Suppress
diff --git a/src/KsTraceViewer.hpp b/src/KsTraceViewer.hpp
index 7cc5751..9815787 100644
--- a/src/KsTraceViewer.hpp
+++ b/src/KsTraceViewer.hpp
@@ -123,6 +123,8 @@ private:
 
 	KsTableView	_view;
 
+	QPalette	_viewPalette;
+
 	KsViewModel		_model;
 
 	KsFilterProxyModel	_proxyModel;
-- 
2.43.0

