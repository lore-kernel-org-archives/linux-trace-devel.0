Return-Path: <SRS0=dEKL=OV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr780050.outbound.protection.outlook.com ([40.107.78.50]:47139
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727808AbeLLQ67 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Dec 2018 11:58:59 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 1/5] kernel-shark-qt: Avoid spurious searches
Date: Wed, 12 Dec 2018 16:58:44 +0000
Message-ID: <20181212165826.8218-2-ykaradzhov@vmware.com>
References: <20181212165826.8218-1-ykaradzhov@vmware.com>
In-Reply-To: <20181212165826.8218-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Do not search if the text field of search panel is empty.
Most probably this is an accidental key press or mouse click.

The text field gets locked only during the actual searching.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsTraceViewer.cpp | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/Ks=
TraceViewer.cpp
index a308ea0..599b687 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -308,8 +308,6 @@ static bool matchCond(const QString &searchText, const =
QString &itemText)
=20
 void KsTraceViewer::_search()
 {
-	/* Disable the user input until the search is done. */
-	_searchLineEdit.setReadOnly(true);
 	if (!_searchDone) {
 		int xColumn, xSelect;
 		QString xText;
@@ -319,7 +317,19 @@ void KsTraceViewer::_search()
 		 * have been modified since the last time we searched.
 		 */
 		_matchList.clear();
+
 		xText =3D _searchLineEdit.text();
+		if (xText.isEmpty()) {
+			/*
+			 * No text is provided by the user. Most probably this
+			 * is an accidental key press.
+			 */
+			return;
+		}
+
+		/* Disable the user input until the search is done. */
+		_searchLineEdit.setReadOnly(true);
+
 		xColumn =3D _columnComboBox.currentIndex();
 		xSelect =3D _selectComboBox.currentIndex();
=20
@@ -346,6 +356,9 @@ void KsTraceViewer::_search()
 			if (_graphFollows)
 				emit select(*_it); // Send a signal to the Graph widget.
 		}
+
+		/* Enable the user input. */
+		_searchLineEdit.setReadOnly(false);
 	} else {
 		/*
 		 * If the search is done, pressing "Enter" is equivalent
@@ -353,9 +366,6 @@ void KsTraceViewer::_search()
 		 */
 		this->_next();
 	}
-
-	/* Enable the user input. */
-	_searchLineEdit.setReadOnly(false);
 }
=20
 void KsTraceViewer::_next()
--=20
2.17.1
