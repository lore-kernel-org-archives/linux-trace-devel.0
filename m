Return-Path: <SRS0=g7z+=NM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810041.outbound.protection.outlook.com ([40.107.81.41]:23872
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727001AbeKBGu2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Nov 2018 02:50:28 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 4/8] kernel-shark-qt: Fix bug when loading the Dual Marker
Date: Thu, 1 Nov 2018 21:45:41 +0000
Message-ID: <20181101214512.18684-5-ykaradzhov@vmware.com>
References: <20181101214512.18684-1-ykaradzhov@vmware.com>
In-Reply-To: <20181101214512.18684-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

When loading the settings of the Dual Marker for a session,
the View(table) must be updated only if the active marker is
actually set.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsSession.cpp | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel-shark-qt/src/KsSession.cpp b/kernel-shark-qt/src/KsSess=
ion.cpp
index 96e09f2..6cd1403 100644
--- a/kernel-shark-qt/src/KsSession.cpp
+++ b/kernel-shark-qt/src/KsSession.cpp
@@ -431,7 +431,6 @@ void KsSession::loadDualMarker(KsDualMarkerSM *dm, KsTr=
aceGraph *graphs)
=20
 	dm->reset();
 	dm->setState(DualMarkerState::A);
-
 	if (_getMarker("markA", &pos)) {
 		graphs->markEntry(pos);
 	} else {
@@ -446,9 +445,10 @@ void KsSession::loadDualMarker(KsDualMarkerSM *dm, KsT=
raceGraph *graphs)
 	}
=20
 	dm->setState(_getMarkerState());
-	pos =3D dm->activeMarker()._pos;
-
-	emit graphs->glPtr()->updateView(pos, true);
+	if (dm->activeMarker()._isSet) {
+		pos =3D dm->activeMarker()._pos;
+		emit graphs->glPtr()->updateView(pos, true);
+	}
 }
=20
 json_object *KsSession::_getMarkerJson()
--=20
2.17.1
