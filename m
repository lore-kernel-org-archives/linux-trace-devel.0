Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr750048.outbound.protection.outlook.com ([40.107.75.48]:44920
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729832AbeLNMwo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 07:52:44 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 3/8] kernel-shark-qt: Make the parallelized search
 stoppable
Date: Fri, 14 Dec 2018 12:52:37 +0000
Message-ID: <20181214125212.9637-4-ykaradzhov@vmware.com>
References: <20181214125212.9637-1-ykaradzhov@vmware.com>
In-Reply-To: <20181214125212.9637-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

So far only the single-threaded search inside the "Latency" and "Info"
columns can be stopped by the "stop search" button. This patch makes it
possible to stop also the parallelized search. Note that after stopping
the parallelized search, the list of matches will contain entries which
may not be consecutive, because each thread was searching in its own
subset of the data and was stoped at an arbitrary position in this
subset.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsModels.cpp      |  6 +++++-
 kernel-shark-qt/src/KsModels.hpp      |  5 ++++-
 kernel-shark-qt/src/KsTraceViewer.cpp | 19 ++++++++++++-------
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/kernel-shark-qt/src/KsModels.cpp b/kernel-shark-qt/src/KsModel=
s.cpp
index d67ee62..c8cc410 100644
--- a/kernel-shark-qt/src/KsModels.cpp
+++ b/kernel-shark-qt/src/KsModels.cpp
@@ -80,7 +80,11 @@ void KsFilterProxyModel::_search(int column,
 			matchList->append(row);
=20
 		if (_searchStop) {
-			_searchStop =3D false;
+			if (notify) {
+				_searchProgress =3D KS_PROGRESS_BAR_MAX;
+				_pbCond.notify_one();
+			}
+
 			break;
 		}
=20
diff --git a/kernel-shark-qt/src/KsModels.hpp b/kernel-shark-qt/src/KsModel=
s.hpp
index b66c259..08019e7 100644
--- a/kernel-shark-qt/src/KsModels.hpp
+++ b/kernel-shark-qt/src/KsModels.hpp
@@ -178,7 +178,10 @@ public:
 	int searchProgress() const {return _searchProgress;}
=20
 	/** Reset the progress value of the search. */
-	void searchReset() {_searchProgress =3D 0;}
+	void searchReset() {
+		_searchProgress =3D 0;
+		_searchStop =3D false;
+	}
=20
 	/** Stop the serch for all threads. */
 	void searchStop() {_searchStop =3D true;}
diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/Ks=
TraceViewer.cpp
index 7f0f1e2..aeed5f7 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -446,6 +446,7 @@ void KsTraceViewer::_searchStop()
 {
 	_searchStopAction->setVisible(false);
 	_proxyModel.searchStop();
+	_lockSearchPanel(false);
 }
=20
 void KsTraceViewer::_clicked(const QModelIndex& i)
@@ -625,7 +626,6 @@ size_t KsTraceViewer::_searchItems(int column,
 {
 	int count, dataRow;
=20
-	_searchProgBar.show();
 	_pbAction->setVisible(true);
=20
 	if (_proxyModel.rowCount({}) < KS_SEARCH_SHOW_PROGRESS_MIN) {
@@ -635,15 +635,20 @@ size_t KsTraceViewer::_searchItems(int column,
 		 */
 		_proxyModel.search(column, searchText, cond, &_matchList,
 				   nullptr, nullptr);
-	} else if (column =3D=3D KsViewModel::TRACE_VIEW_COL_INFO ||
-	    column =3D=3D KsViewModel::TRACE_VIEW_COL_LAT) {
+	} else {
 		_searchStopAction->setVisible(true);
-		_proxyModel.search(column, searchText, cond, &_matchList,
-				   &_searchProgBar, &_searchCountLabel);
+
+		if (column =3D=3D KsViewModel::TRACE_VIEW_COL_INFO ||
+		    column =3D=3D KsViewModel::TRACE_VIEW_COL_LAT) {
+			_proxyModel.search(column, searchText,
+					   cond, &_matchList,
+					   &_searchProgBar,
+					   &_searchCountLabel);
+		} else {
+			_searchItemsMapReduce(column, searchText, cond);
+		}
=20
 		_searchStopAction->setVisible(false);
-	} else {
-		_searchItemsMapReduce(column, searchText, cond);
 	}
=20
 	count =3D _matchList.count();
--=20
2.17.1
