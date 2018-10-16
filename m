Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710064.outbound.protection.outlook.com ([40.107.71.64]:54000
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727006AbeJPXoh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:44:37 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 12/23] kernel-shark-qt: Add "File exists" dialog.
Date: Tue, 16 Oct 2018 15:53:11 +0000
Message-ID: <20181016155232.5257-13-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

A helper function for launching a "File exists" dialog is added to
KsWidgetsLib. This function asks the user, before overwriting an existing
file. The "File exists" dialog function is used by the KsMainWindow widget
when saving the configuration of the filters and sessions.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsMainWindow.cpp | 22 +++++++--------------
 kernel-shark-qt/src/KsWidgetsLib.cpp | 29 ++++++++++++++++++++++++++++
 kernel-shark-qt/src/KsWidgetsLib.hpp |  7 +++++++
 3 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsM=
ainWindow.cpp
index d30f752..b9fb587 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -397,20 +397,7 @@ void KsMainWindow::_exportSession()
 	if (!fileName.endsWith(".json")) {
 		fileName +=3D ".json";
 		if (QFileInfo(fileName).exists()) {
-			QString msg("A file ");
-			QMessageBox msgBox;
-
-			msg +=3D fileName;
-			msg +=3D " already exists.";
-			msgBox.setText(msg);
-			msgBox.setInformativeText("Do you want to replace it?");
-
-			msgBox.setStandardButtons(QMessageBox::Save |
-						  QMessageBox::Cancel);
-
-			msgBox.setDefaultButton(QMessageBox::Cancel);
-
-			if (msgBox.exec() =3D=3D QMessageBox::Cancel)
+			if (!KsWidgetsLib::fileExistsDialog(fileName))
 				return;
 		}
 	}
@@ -461,8 +448,13 @@ void KsMainWindow::_exportFilter()
 	if (fileName.isEmpty())
 		return;
=20
-	if (!fileName.endsWith(".json"))
+	if (!fileName.endsWith(".json")) {
 		fileName +=3D ".json";
+		if (QFileInfo(fileName).exists()) {
+			if (!KsWidgetsLib::fileExistsDialog(fileName))
+				return;
+		}
+	}
=20
 	kshark_export_all_event_filters(kshark_ctx, &conf);
 	kshark_save_config_file(fileName.toStdString().c_str(), conf);
diff --git a/kernel-shark-qt/src/KsWidgetsLib.cpp b/kernel-shark-qt/src/KsW=
idgetsLib.cpp
index f7fca09..b4b62a4 100644
--- a/kernel-shark-qt/src/KsWidgetsLib.cpp
+++ b/kernel-shark-qt/src/KsWidgetsLib.cpp
@@ -76,6 +76,35 @@ KsMessageDialog::KsMessageDialog(QString message, QWidge=
t *parent)
 	this->setLayout(&_layout);
 }
=20
+namespace KsWidgetsLib
+{
+
+/**
+ * @brief Launch a File exists dialog. Use this function to ask the user
+ * before overwriting an existing file.
+ *
+ * @param fileName: the name of the file.
+ *
+ * @returns True if the user wants to overwrite the file. Otherwise
+ */
+bool fileExistsDialog(QString fileName)
+{
+	QString msg("A file ");
+	QMessageBox msgBox;
+
+	msg +=3D fileName;
+	msg +=3D " already exists.";
+	msgBox.setText(msg);
+	msgBox.setInformativeText("Do you want to replace it?");
+
+	msgBox.setStandardButtons(QMessageBox::Save | QMessageBox::Cancel);
+	msgBox.setDefaultButton(QMessageBox::Cancel);
+
+	return (msgBox.exec() =3D=3D QMessageBox::Save);
+}
+
+}; // KsWidgetsLib
+
 /**
  * @brief Create KsCheckBoxWidget.
  *
diff --git a/kernel-shark-qt/src/KsWidgetsLib.hpp b/kernel-shark-qt/src/KsW=
idgetsLib.hpp
index b9ba35a..89c196a 100644
--- a/kernel-shark-qt/src/KsWidgetsLib.hpp
+++ b/kernel-shark-qt/src/KsWidgetsLib.hpp
@@ -66,6 +66,13 @@ public:
 /** The width of the KsMessageDialog widget. */
 #define KS_MSG_DIALOG_WIDTH  (SCREEN_WIDTH / 10)
=20
+namespace KsWidgetsLib
+{
+
+bool fileExistsDialog(QString fileName);
+
+}; // KsWidgetsLib
+
 /**
  * The KsCheckBoxWidget class is the base class of all CheckBox widget use=
d
  * by KernelShark.
--=20
2.17.1
