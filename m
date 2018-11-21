Return-Path: <SRS0=0JuE=OA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr790077.outbound.protection.outlook.com ([40.107.79.77]:22848
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731144AbeKVBtv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Nov 2018 20:49:51 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 07/11] kernel-shark-qt: Optimize the search in a case of a
 small data-set
Date: Wed, 21 Nov 2018 15:14:25 +0000
Message-ID: <20181121151356.16901-9-ykaradzhov@vmware.com>
References: <20181121151356.16901-1-ykaradzhov@vmware.com>
In-Reply-To: <20181121151356.16901-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Parallelizing the search (map-reduce) and showing the progress make
sense only in the case of very big data-sets. If the data-set is
small we do not want to have the overhead added by the update of
the progress bar. This overhead turns to be not so small (~1s. on
my laptop).

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsTraceViewer.cpp | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/Ks=
TraceViewer.cpp
index 1f96234..64c9fb7 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -579,6 +579,12 @@ void KsTraceViewer::_resizeToContents()
 	_view.setColumnWidth(0, columnSize);
 }
=20
+//! @cond Doxygen_Suppress
+
+#define KS_SEARCH_SHOW_PROGRESS_MIN 100000
+
+//! @endcond
+
 size_t KsTraceViewer::_searchItems(int column,
 				   const QString &searchText,
 				   condition_func cond)
@@ -588,7 +594,14 @@ size_t KsTraceViewer::_searchItems(int column,
 	_searchProgBar.show();
 	_pbAction->setVisible(true);
=20
-	if (column =3D=3D KsViewModel::TRACE_VIEW_COL_INFO ||
+	if (_proxyModel.rowCount({}) < KS_SEARCH_SHOW_PROGRESS_MIN) {
+		/*
+		 * This is a small data-set. Do a single-threaded search
+		 * without showing the progress.
+		 */
+		_proxyModel.search(column, searchText, cond, &_matchList,
+				   nullptr, nullptr);
+	} else if (column =3D=3D KsViewModel::TRACE_VIEW_COL_INFO ||
 	    column =3D=3D KsViewModel::TRACE_VIEW_COL_LAT) {
 		_searchStopAction->setVisible(true);
 		_proxyModel.search(column, searchText, cond, &_matchList,
--=20
2.17.1
