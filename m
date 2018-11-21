Return-Path: <SRS0=0JuE=OA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr690087.outbound.protection.outlook.com ([40.107.69.87]:51424
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730512AbeKVBuJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Nov 2018 20:50:09 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 06/11] kernel-shark-qt: Update search iterator when marker is
 changed
Date: Wed, 21 Nov 2018 15:14:24 +0000
Message-ID: <20181121151356.16901-8-ykaradzhov@vmware.com>
References: <20181121151356.16901-1-ykaradzhov@vmware.com>
In-Reply-To: <20181121151356.16901-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

When the Dual marker changes it active state (between A and B) or
its selected row, the iterator over the list of search matching entries
has to be updated such that it points to the selected entry. If the
selected entry do not belong to the matching list, the iterator will
point to the first matching entry after the selected one.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsTraceViewer.cpp | 114 +++++++++++++++++---------
 kernel-shark-qt/src/KsTraceViewer.hpp |   4 +
 2 files changed, 80 insertions(+), 38 deletions(-)

diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/Ks=
TraceViewer.cpp
index 3df4a5d..1f96234 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -350,10 +350,21 @@ void KsTraceViewer::_next()
 	}
=20
 	if (!_matchList.empty()) { // Items have been found.
-		++_it; // Move the iterator.
-		if (_it =3D=3D _matchList.end() ) {
-			// This is the last item of the list. Go back to the beginning.
-			_it =3D _matchList.begin();
+		int row =3D _getSelectedDataRow();
+		/*
+		 * The iterator can only be at the selected row or if the
+		 * selected row is not a match at the first matching row after
+		 * the selected one.
+		 */
+		if (*_it =3D=3D row) {
+			++_it; // Move the iterator.
+			if (_it =3D=3D _matchList.end() ) {
+				/*
+				 * This is the last item of the list.
+				 * Go back to the beginning.
+				 */
+				_it =3D _matchList.begin();
+			}
 		}
=20
 		// Select the row of the item.
@@ -407,14 +418,17 @@ void KsTraceViewer::_searchStop()
=20
 void KsTraceViewer::_clicked(const QModelIndex& i)
 {
-	if (_graphFollows) {
-		/*
-		 * Use the index of the proxy model to retrieve the value
-		 * of the row number in the base model.
-		 */
-		size_t row =3D _proxyModel.mapRowFromSource(i.row());
+	/*
+	 * Use the index of the proxy model to retrieve the value
+	 * of the row number in the base model.
+	 */
+	size_t row =3D _proxyModel.mapRowFromSource(i.row());
+
+	_setSearchIterator(row);
+	_updateSearchCount();
+
+	if (_graphFollows)
 		emit select(row); // Send a signal to the Graph widget.
-	}
 }
=20
 /** Make a given row of the table visible. */
@@ -454,6 +468,8 @@ void KsTraceViewer::deselect()
 /** Switch the Dual marker. */
 void KsTraceViewer::markSwitch()
 {
+	int row;
+
 	/* The state of the Dual marker has changed. Get the new active marker. *=
/
 	DualMarkerState state =3D _mState->getState();
=20
@@ -495,6 +511,12 @@ void KsTraceViewer::markSwitch()
 	} else {
 		_view.clearSelection();
 	}
+
+	row =3D _getSelectedDataRow();
+	if (row >=3D 0) {
+		_setSearchIterator(row);
+		_updateSearchCount();
+	}
 }
=20
 /**
@@ -529,12 +551,9 @@ void KsTraceViewer::resizeEvent(QResizeEvent* event)
 void KsTraceViewer::keyReleaseEvent(QKeyEvent *event)
 {
 	if (event->key() =3D=3D Qt::Key_Up || event->key() =3D=3D Qt::Key_Down) {
-		QItemSelectionModel *sm =3D _view.selectionModel();
-		if (sm->hasSelection()) {
-			/* Only one row at the time can be selected. */
-			int row =3D sm->selectedRows()[0].row();
+		int row =3D _getSelectedDataRow();
+		if (row >=3D 0)
 			emit select(row); // Send a signal to the Graph widget.
-		}
=20
 		return;
 	}
@@ -564,7 +583,7 @@ size_t KsTraceViewer::_searchItems(int column,
 				   const QString &searchText,
 				   condition_func cond)
 {
-	int count;
+	int count, dataRow;
=20
 	_searchProgBar.show();
 	_pbAction->setVisible(true);
@@ -588,28 +607,10 @@ size_t KsTraceViewer::_searchItems(int column,
 	if (count =3D=3D 0) // No items have been found. Do nothing.
 		return 0;
=20
-	QItemSelectionModel *sm =3D _view.selectionModel();
-	if (sm->hasSelection()) {
-		/* Only one row at the time can be selected. */
-		int row =3D sm->selectedRows()[0].row();
-
+	dataRow =3D _getSelectedDataRow();
+	if (dataRow >=3D 0) {
 		_view.clearSelection();
-		_it =3D _matchList.begin();
-		/*
-		 * Move the iterator to the first element of the match list
-		 * after the selected one.
-		 */
-		while (*_it <=3D row) {
-			++_it;  // Move the iterator.
-			if (_it =3D=3D _matchList.end()) {
-				/*
-				 * This is the last item of the list. Go back
-				 * to the beginning.
-				 */
-				_it =3D _matchList.begin();
-				break;
-			}
-		}
+		_setSearchIterator(dataRow);
 	} else {
 		/* Move the iterator to the beginning of the match list. */
 		_view.clearSelection();
@@ -621,6 +622,29 @@ size_t KsTraceViewer::_searchItems(int column,
 	return count;
 }
=20
+void KsTraceViewer::_setSearchIterator(int row)
+{
+	if (_matchList.isEmpty())
+		return;
+
+	/*
+	 * Move the iterator to the first element of the match list
+	 * after the selected one.
+	 */
+	_it =3D _matchList.begin();
+	while (*_it < row) {
+		++_it;  // Move the iterator.
+		if (_it =3D=3D _matchList.end()) {
+			/*
+			 * This is the last item of the list. Go back
+			 * to the beginning.
+			 */
+			_it =3D _matchList.begin();
+			break;
+		}
+	}
+}
+
 void KsTraceViewer::_searchItemsMapReduce(int column,
 					  const QString &searchText,
 					  condition_func cond)
@@ -668,3 +692,17 @@ void KsTraceViewer::_searchItemsMapReduce(int column,
 	for (auto &m: maps)
 		lamSearchReduce(_matchList, m.get());
 }
+
+int KsTraceViewer::_getSelectedDataRow()
+{
+	QItemSelectionModel *sm =3D _view.selectionModel();
+	int dataRow =3D -1;
+
+	if (sm->hasSelection()) {
+		/* Only one row at the time can be selected. */
+		QModelIndex  i =3D sm->selectedRows()[0];
+		dataRow =3D _proxyModel.mapRowFromSource(i.row());
+	}
+
+	return dataRow;
+}
diff --git a/kernel-shark-qt/src/KsTraceViewer.hpp b/kernel-shark-qt/src/Ks=
TraceViewer.hpp
index 19371de..50c9115 100644
--- a/kernel-shark-qt/src/KsTraceViewer.hpp
+++ b/kernel-shark-qt/src/KsTraceViewer.hpp
@@ -140,6 +140,10 @@ private:
=20
 	void _onCustomContextMenu(const QPoint &);
=20
+	void _setSearchIterator(int row);
+
+	int _getSelectedDataRow();
+
 private slots:
=20
 	void _searchEdit(int);
--=20
2.17.1
