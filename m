Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr680057.outbound.protection.outlook.com ([40.107.68.57]:19256
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727941AbeK2CSM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:12 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 04/17] kernel-shark qt: No error when Record authentication
 dialog is closed
Date: Wed, 28 Nov 2018 15:16:10 +0000
Message-ID: <20181128151530.21965-5-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

No error message must be shown in the case when the user dismissed
the authentication dialog (clicked Cancel).

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsMainWindow.cpp | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsM=
ainWindow.cpp
index ffb10d4..8e8484f 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -959,13 +959,28 @@ void KsMainWindow::_captureStarted()
 	_captureLocalServer.listen("KSCapture");
 }
=20
-void KsMainWindow::_captureFinished(int exit, QProcess::ExitStatus st)
+/**
+ * If the authorization could not be obtained because the user dismissed
+ * the authentication dialog (clicked Cancel), pkexec exits with a return
+ * value of 126.
+ */
+#define PKEXEC_DISMISS_RET	126
+
+void KsMainWindow::_captureFinished(int ret, QProcess::ExitStatus st)
 {
 	QProcess *capture =3D (QProcess *)sender();
=20
 	_captureLocalServer.close();
=20
-	if (exit !=3D 0 || st !=3D QProcess::NormalExit) {
+	if (ret =3D=3D PKEXEC_DISMISS_RET) {
+		/*
+		 * Authorization could not be obtained because the user
+		 * dismissed the authentication dialog.
+		 */
+		return;
+	}
+
+	if (ret !=3D 0 || st !=3D QProcess::NormalExit) {
 		QString message =3D "Capture process failed:<br>";
=20
 		message +=3D capture->errorString();
--=20
2.17.1
