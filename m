Return-Path: <SRS0=0JuE=OA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr690040.outbound.protection.outlook.com ([40.107.69.40]:23584
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726849AbeKVBtr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Nov 2018 20:49:47 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 05/11] kernel-shark-qt: Add iterator index to the search panel
Date: Wed, 21 Nov 2018 15:14:23 +0000
Message-ID: <20181121151356.16901-7-ykaradzhov@vmware.com>
References: <20181121151356.16901-1-ykaradzhov@vmware.com>
In-Reply-To: <20181121151356.16901-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The search panel displays the index inside the list of search
matching entries.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsTraceViewer.cpp | 17 +++++++++++++++--
 kernel-shark-qt/src/KsTraceViewer.hpp |  2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/Ks=
TraceViewer.cpp
index e92dd83..3df4a5d 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -362,6 +362,8 @@ void KsTraceViewer::_next()
 		if (_graphFollows)
 			emit select(*_it); // Send a signal to the Graph widget.
 	}
+
+	_updateSearchCount();
 }
=20
 void KsTraceViewer::_prev()
@@ -385,6 +387,16 @@ void KsTraceViewer::_prev()
 		if (_graphFollows)
 			emit select(*_it); // Send a signal to the Graph widget.
 	}
+
+	_updateSearchCount();
+}
+
+void KsTraceViewer::_updateSearchCount()
+{
+	int index(_it - _matchList.begin());
+	int total(_matchList.count());
+
+	_searchCountLabel.setText(QString(" %1 / %2").arg(index).arg(total));
 }
=20
 void KsTraceViewer::_searchStop()
@@ -571,7 +583,6 @@ size_t KsTraceViewer::_searchItems(int column,
 	count =3D _matchList.count();
=20
 	_pbAction->setVisible(false);
-	_searchCountLabel.setText(QString(" %1").arg(count));
 	_searchDone =3D true;
=20
 	if (count =3D=3D 0) // No items have been found. Do nothing.
@@ -605,6 +616,8 @@ size_t KsTraceViewer::_searchItems(int column,
 		_it =3D _matchList.begin();
 	}
=20
+	_updateSearchCount();
+
 	return count;
 }
=20
@@ -645,7 +658,7 @@ void KsTraceViewer::_searchItemsMapReduce(int column,
 	for (int r =3D 1; r < nThreads; ++r)
 		maps.push_back(std::async(lamSearchMap, ranges[r], false));
=20
-	while (_proxyModel.searchProgress() < KS_PROGRESS_BAR_MAX- nThreads) {
+	while (_proxyModel.searchProgress() < KS_PROGRESS_BAR_MAX - nThreads) {
 		std::unique_lock<std::mutex> lk(_proxyModel._mutex);
 		_proxyModel._pbCond.wait(lk);
 		_searchProgBar.setValue(_proxyModel.searchProgress());
diff --git a/kernel-shark-qt/src/KsTraceViewer.hpp b/kernel-shark-qt/src/Ks=
TraceViewer.hpp
index de8af97..19371de 100644
--- a/kernel-shark-qt/src/KsTraceViewer.hpp
+++ b/kernel-shark-qt/src/KsTraceViewer.hpp
@@ -132,6 +132,8 @@ private:
=20
 	void _prev();
=20
+	void _updateSearchCount();
+
 	void _searchStop();
=20
 	void _clicked(const QModelIndex& i);
--=20
2.17.1
