Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr750048.outbound.protection.outlook.com ([40.107.75.48]:44920
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729846AbeLNMwp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 07:52:45 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 4/8] kernel-shark-qt: Avoid spurious searches
Date: Fri, 14 Dec 2018 12:52:38 +0000
Message-ID: <20181214125212.9637-5-ykaradzhov@vmware.com>
References: <20181214125212.9637-1-ykaradzhov@vmware.com>
In-Reply-To: <20181214125212.9637-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

We do not want to search if the text field of search panel is empty.
Most probably this is an accidental key press or mouse click.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsTraceViewer.cpp | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/Ks=
TraceViewer.cpp
index aeed5f7..971793f 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -331,6 +331,15 @@ void KsTraceViewer::_search()
=20
 		_matchList.clear();
 		xText =3D _searchLineEdit.text();
+		if (xText.isEmpty()) {
+			/*
+			 * No text is provided by the user. Most probably this
+			 * is an accidental key press. Just reenable the input.
+			 */
+			_lockSearchPanel(false);
+			return;
+		}
+
 		xColumn =3D _columnComboBox.currentIndex();
 		xSelect =3D _selectComboBox.currentIndex();
=20
--=20
2.17.1
