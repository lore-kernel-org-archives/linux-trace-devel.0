Return-Path: <SRS0=0JuE=OA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr790077.outbound.protection.outlook.com ([40.107.79.77]:22848
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726849AbeKVBtx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Nov 2018 20:49:53 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 08/11] kernel-shark qt: No error when Record authentication
 dialog is closed
Date: Wed, 21 Nov 2018 15:14:26 +0000
Message-ID: <20181121151356.16901-10-ykaradzhov@vmware.com>
References: <20181121151356.16901-1-ykaradzhov@vmware.com>
In-Reply-To: <20181121151356.16901-1-ykaradzhov@vmware.com>
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
 kernel-shark-qt/src/KsMainWindow.cpp | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsM=
ainWindow.cpp
index ffb10d4..d5b22dc 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -965,6 +965,14 @@ void KsMainWindow::_captureFinished(int exit, QProcess=
::ExitStatus st)
=20
 	_captureLocalServer.close();
=20
+	if (exit =3D=3D 126) {
+		/*
+		 * Authorization could not be obtained because the user
+		 * dismissed the authentication dialog.
+		 */
+		return;
+	}
+
 	if (exit !=3D 0 || st !=3D QProcess::NormalExit) {
 		QString message =3D "Capture process failed:<br>";
=20
--=20
2.17.1
