Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-eopbgr810042.outbound.protection.outlook.com ([40.107.81.42]:30548
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726074AbfADT62 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Jan 2019 14:58:28 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 4/4] kernel-shark-qt: Do not auto-scrolling  when the marker
 switches
Date: Fri, 4 Jan 2019 19:57:55 +0000
Message-ID: <20190104195726.24264-4-ykaradzhov@vmware.com>
References: <20190104195726.24264-1-ykaradzhov@vmware.com>
In-Reply-To: <20190104195726.24264-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In some cases, the auto-scrolling (inside the table) to the
position of the marker, when the user switches between MarkerA
and MarkerB can be very annoying. This patch disables this
vertical auto-scrolling. Jumping to the position of the Active
marker is still possible, but the user has to do a second
click on the MarkerA/MarkerB button.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsTraceViewer.cpp | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/Ks=
TraceViewer.cpp
index 2418de3..f02fbbb 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -578,13 +578,18 @@ void KsTraceViewer::markSwitch()
 		 */
 		size_t row =3D_mState->getMarker(state)._pos;
=20
-		QModelIndex index =3D _proxyModel.mapFromSource(_model.index(row, 0));
+		QModelIndex index =3D
+			_proxyModel.mapFromSource(_model.index(row, 0));
=20
 		/*
 		 * The row of the active marker will be colored according to
-		 * the assigned property of the current state of the Dual marker.
+		 * the assigned property of the current state of the Dual
+		 * marker. Auto-scrolling is temporarily disabled because we
+		 * do not want to scroll to the position of the marker yet.
 		 */
+		_view.setAutoScroll(false);
 		_view.selectRow(index.row());
+		_view.setAutoScroll(true);
 	} else {
 		_view.clearSelection();
 	}
--=20
2.17.1
