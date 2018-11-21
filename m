Return-Path: <SRS0=0JuE=OA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr790053.outbound.protection.outlook.com ([40.107.79.53]:64832
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730820AbeKVBvK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Nov 2018 20:51:10 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 04/11] kernel-shark-qt: Optimize the search in the text data
Date: Wed, 21 Nov 2018 15:14:22 +0000
Message-ID: <20181121151356.16901-6-ykaradzhov@vmware.com>
References: <20181121151356.16901-1-ykaradzhov@vmware.com>
In-Reply-To: <20181121151356.16901-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch aims to optimize the search by doing two small
modifications:

It changes the type of the matching function used when searching.
This will eliminate the call of the QString copy constructor.

It also adds an intermediate step in the conversion of the tracing
data into the format expected by the QTableView widget (QVariant).
By having this intermediate step we avoid the unnecessary conversion
QString -> QVariant -> QString when searching.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsModels.cpp      | 28 ++++++++++++++++-----------
 kernel-shark-qt/src/KsModels.hpp      |  4 +++-
 kernel-shark-qt/src/KsTraceViewer.cpp |  6 +++---
 kernel-shark-qt/src/KsTraceViewer.hpp |  3 ---
 4 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/kernel-shark-qt/src/KsModels.cpp b/kernel-shark-qt/src/KsModel=
s.cpp
index 5eb1646..d67ee62 100644
--- a/kernel-shark-qt/src/KsModels.cpp
+++ b/kernel-shark-qt/src/KsModels.cpp
@@ -59,8 +59,7 @@ void KsFilterProxyModel::_search(int column,
 {
 	int row, nRows(last - first + 1);
 	int pbCount(1);
-	QVariant item;
-	QString text;
+	QString item;
=20
 	_searchProgress =3D 0;
=20
@@ -76,10 +75,9 @@ void KsFilterProxyModel::_search(int column,
 		 * of the row number in the base model.
 		 */
 		row =3D mapRowFromSource(r);
-		item =3D _source->getValue(column, row);
-		if (cond(searchText, item.toString())) {
+		item =3D _source->getValueStr(column, row);
+		if (cond(searchText, item))
 			matchList->append(row);
-		}
=20
 		if (_searchStop) {
 			_searchStop =3D false;
@@ -156,7 +154,6 @@ QList<int> KsFilterProxyModel::searchMap(int column,
 					 bool notify)
 {
 	QList<int> matchList;
-	qInfo() << "searchMap" << first << last;
 	_search(column, searchText, cond, &matchList, first, last,
 		nullptr, nullptr, notify);
=20
@@ -203,15 +200,17 @@ QVariant KsViewModel::data(const QModelIndex &index, =
int role) const
 	return {};
 }
=20
-/** Get the data stored in a given cell of the table. */
-QVariant KsViewModel::getValue(int column, int row) const
+/** Get the string data stored in a given cell of the table. */
+QString KsViewModel::getValueStr(int column, int row) const
 {
+	int pid;
+
 	switch (column) {
 		case TRACE_VIEW_COL_INDEX :
-			return row;
+			return QString("%1").arg(row);
=20
 		case TRACE_VIEW_COL_CPU:
-			return _data[row]->cpu;
+			return QString("%1").arg(_data[row]->cpu);
=20
 		case TRACE_VIEW_COL_TS:
 			return KsUtils::Ts2String(_data[row]->ts, 6);
@@ -220,7 +219,8 @@ QVariant KsViewModel::getValue(int column, int row) con=
st
 			return kshark_get_task_easy(_data[row]);
=20
 		case TRACE_VIEW_COL_PID:
-			return kshark_get_pid_easy(_data[row]);
+			pid =3D kshark_get_pid_easy(_data[row]);
+			return QString("%1").arg(pid);
=20
 		case TRACE_VIEW_COL_LAT:
 			return kshark_get_latency_easy(_data[row]);
@@ -236,6 +236,12 @@ QVariant KsViewModel::getValue(int column, int row) co=
nst
 	}
 }
=20
+/** Get the data stored in a given cell of the table. */
+QVariant KsViewModel::getValue(int column, int row) const
+{
+	return getValueStr(column, row);
+}
+
 /**
  * Get the header of a column. This is an implementation of the pure virtu=
al
  * method of the abstract model class.
diff --git a/kernel-shark-qt/src/KsModels.hpp b/kernel-shark-qt/src/KsModel=
s.hpp
index 00b20b2..b66c259 100644
--- a/kernel-shark-qt/src/KsModels.hpp
+++ b/kernel-shark-qt/src/KsModels.hpp
@@ -28,7 +28,7 @@
 #include "libkshark-model.h"
=20
 /** Matching condition function type. To be user for searching. */
-typedef bool (*condition_func)(QString, QString);
+typedef bool (*condition_func)(const QString &, const QString &);
=20
 enum class DualMarkerState;
=20
@@ -81,6 +81,8 @@ public:
 	/** Get the list of column's headers. */
 	QStringList header() const {return _header;}
=20
+	QString getValueStr(int column, int row) const;
+
 	QVariant getValue(int column, int row) const;
=20
 	size_t search(int column,
diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/Ks=
TraceViewer.cpp
index 7f12365..e92dd83 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -275,17 +275,17 @@ void KsTraceViewer::_graphFollowsChanged(int state)
 		emit select(*_it); // Send a signal to the Graph widget.
 }
=20
-static bool notHaveCond(QString searchText, QString itemText)
+static bool notHaveCond(const QString &searchText, const QString &itemText=
)
 {
 	return !itemText.contains(searchText, Qt::CaseInsensitive);
 }
=20
-static bool containsCond(QString searchText, QString itemText)
+static bool containsCond(const QString &searchText, const QString &itemTex=
t)
 {
 	return itemText.contains(searchText, Qt::CaseInsensitive);
 }
=20
-static bool matchCond(QString searchText, QString itemText)
+static bool matchCond(const QString &searchText, const QString &itemText)
 {
 	return (itemText.compare(searchText, Qt::CaseInsensitive) =3D=3D 0);
 }
diff --git a/kernel-shark-qt/src/KsTraceViewer.hpp b/kernel-shark-qt/src/Ks=
TraceViewer.hpp
index 2a85e4f..de8af97 100644
--- a/kernel-shark-qt/src/KsTraceViewer.hpp
+++ b/kernel-shark-qt/src/KsTraceViewer.hpp
@@ -20,9 +20,6 @@
 #include "KsModels.hpp"
 #include "KsDualMarker.hpp"
=20
-/** Matching condition function type. To be user for searchong. */
-typedef bool (*condition_func)(QString, QString);
-
 /**
  * The KsTraceViewer class provides a widget for browsing in the trace dat=
a
  * shown in a text form.
--=20
2.17.1
