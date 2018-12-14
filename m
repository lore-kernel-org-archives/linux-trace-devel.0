Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr800084.outbound.protection.outlook.com ([40.107.80.84]:60384
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729835AbeLNMwq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 07:52:46 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 7/8] kernel-shark-qt: Update the documentation link
Date: Fri, 14 Dec 2018 12:52:41 +0000
Message-ID: <20181214125212.9637-8-ykaradzhov@vmware.com>
References: <20181214125212.9637-1-ykaradzhov@vmware.com>
In-Reply-To: <20181214125212.9637-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Help->Contents now opens http://kernelshark.org/

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsMainWindow.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsM=
ainWindow.cpp
index 142cd1f..a375126 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -820,7 +820,7 @@ void KsMainWindow::_aboutInfo()
=20
 void KsMainWindow::_contents()
 {
-	QDesktopServices::openUrl(QUrl("https://www.google.bg/search?q=3Dkernelsh=
ark",
+	QDesktopServices::openUrl(QUrl("http://kernelshark.org/",
 				  QUrl::TolerantMode));
 }
=20
--=20
2.17.1
