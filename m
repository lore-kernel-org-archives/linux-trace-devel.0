Return-Path: <SRS0=dEKL=OV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr680083.outbound.protection.outlook.com ([40.107.68.83]:11474
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727808AbeLLQ71 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Dec 2018 11:59:27 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 4/5] kernel-shark-qt: Update the documentation link
Date: Wed, 12 Dec 2018 16:58:48 +0000
Message-ID: <20181212165826.8218-5-ykaradzhov@vmware.com>
References: <20181212165826.8218-1-ykaradzhov@vmware.com>
In-Reply-To: <20181212165826.8218-1-ykaradzhov@vmware.com>
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
