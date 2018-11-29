Return-Path: <SRS0=ZWpJ=OI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr740080.outbound.protection.outlook.com ([40.107.74.80]:37312
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731249AbeK3CCA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Nov 2018 21:02:00 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] kernel-shark-qt: Debug the Quick Context Menu
Date: Thu, 29 Nov 2018 14:56:21 +0000
Message-ID: <20181129145600.8803-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch fixes a simple bug in KsQuickContextMenu::_hideTask().

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsQuickContextMenu.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark-qt/src/KsQuickContextMenu.cpp b/kernel-shark-qt/s=
rc/KsQuickContextMenu.cpp
index 95ffc4f..815e4b9 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.cpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.cpp
@@ -168,7 +168,7 @@ void KsQuickContextMenu::_hideTask()
 		return;
=20
 	vec =3D_getFilterVector(kshark_ctx->hide_task_filter, pid);
-	_data->applyPosTaskFilter(vec);
+	_data->applyNegTaskFilter(vec);
 }
=20
 void KsQuickContextMenu::_showTask()
--=20
2.17.1
