Return-Path: <SRS0=g7z+=NM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-co1nam03on0067.outbound.protection.outlook.com ([104.47.40.67]:55472
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727001AbeKBGu1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Nov 2018 02:50:27 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 3/8] kernel-shark-qt: Put error messages always on top
Date: Thu, 1 Nov 2018 21:45:40 +0000
Message-ID: <20181101214512.18684-4-ykaradzhov@vmware.com>
References: <20181101214512.18684-1-ykaradzhov@vmware.com>
In-Reply-To: <20181101214512.18684-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

When an error message is shown its widget must be placed always on top
of all other windows. Also the user shouldn't be able to do anything
else, before closing the error message widget.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsMainWindow.cpp | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsM=
ainWindow.cpp
index b3cbc3b..4f9a6e2 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -859,8 +859,9 @@ void KsMainWindow::_error(const QString &text, const QS=
tring &errCode,
 	if (unloadPlugins)
 		_plugins.unloadAll();
=20
-	em->showMessage(text, errCode);
 	qCritical() << "ERROR: " << text;
+	em->showMessage(text, errCode);
+	em->exec();
 }
=20
 /**
--=20
2.17.1
