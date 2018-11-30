Return-Path: <SRS0=EnxC=OJ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730080.outbound.protection.outlook.com ([40.107.73.80]:3348
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726595AbeLACr6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Nov 2018 21:47:58 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 2/2] kernel-shark-qt: Add better handling of the search
 iterator.
Date: Fri, 30 Nov 2018 15:38:13 +0000
Message-ID: <20181130153749.4419-2-ykaradzhov@vmware.com>
References: <20181130153749.4419-1-ykaradzhov@vmware.com>
In-Reply-To: <20181130153749.4419-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch provides better handling of the search iterator in the case
when no matches are found. Without these fixes, the search iterator
shows an arbitrary value when we load a session that has the active
marker being set.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsTraceViewer.cpp | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/Ks=
TraceViewer.cpp
index d52d7e3..a308ea0 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -420,8 +420,13 @@ void KsTraceViewer::_prev()
=20
 void KsTraceViewer::_updateSearchCount()
 {
-	int index(_it - _matchList.begin());
-	int total(_matchList.count());
+	int index, total;
+
+	if (_matchList.isEmpty())
+		return;
+
+	index =3D _it - _matchList.begin();
+	total =3D_matchList.count();
=20
 	_searchCountLabel.setText(QString(" %1 / %2").arg(index).arg(total));
 }
@@ -655,6 +660,7 @@ size_t KsTraceViewer::_searchItems(int column,
=20
 void KsTraceViewer::_setSearchIterator(int row)
 {
+	_it =3D _matchList.begin();
 	if (_matchList.isEmpty())
 		return;
=20
@@ -662,7 +668,6 @@ void KsTraceViewer::_setSearchIterator(int row)
 	 * Move the iterator to the first element of the match list
 	 * after the selected one.
 	 */
-	_it =3D _matchList.begin();
 	while (*_it < row) {
 		++_it;  // Move the iterator.
 		if (_it =3D=3D _matchList.end()) {
--=20
2.17.1
