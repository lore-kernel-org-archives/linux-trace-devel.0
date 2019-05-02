Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF67C43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B23BC2075E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfEBMkg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:40:36 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33465 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEBMkg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:40:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id e28so3189048wra.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 May 2019 05:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/1kmzUWBiZYQO3XqM7s+21dJRQ1VpCT3JOC8swqDTnY=;
        b=ib188twkeSauQZenppj7eZUahcIbrUsMGIw+qih/Mp+BI4ugmBQswzdCagoEKwDpAl
         0Y2RfG26QkXm1wHzsdR3V2Lv1NP8BR/oovJkVLbD78DKiMFuUS3MFmFfxtXy/40ZShTE
         6RnICgLtCHkP2lbyzmAdC8H/UFQAphZXmg9tMT5ItIl+2igaq37RHz9i/FlWiMDDyE1R
         nn1D1H6TpuyJleFt1vrQM+55GkXUUsVbTTvqtWndclCikVRUufcjf6lGPGE43shxNYGb
         CBIPb10ApckR0Z3oR3a1FZWhAWbSX2Ni7nb0bNkO+hOSXD5/9OtZuQ+oyzdvqM65/Ez8
         XIuA==
X-Gm-Message-State: APjAAAUjSIryYONnypVTMhJpZNy714bM0PmA4O6YZSRSCgrlj15s2F6Y
        nXttEfFvkwKMcciog/IBY6+Ezt5x
X-Google-Smtp-Source: APXvYqy/DztM+Nuj1uOs32zFTiJkraOzvRm8T7P0Vunbii/BV6rRWSdp3L7Ek7xLokvMLedSK5HUjg==
X-Received: by 2002:adf:bac9:: with SMTP id w9mr2648756wrg.256.1556800833725;
        Thu, 02 May 2019 05:40:33 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d11sm7511008wmb.39.2019.05.02.05.40.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:40:33 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        troyengel@gmail.com, Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH v2 2/8] kernel-shark: Add logic for the initial path of Open-File dialogs
Date:   Thu,  2 May 2019 15:40:03 +0300
Message-Id: <20190502124009.32208-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502124009.32208-1-ykaradzhov@vmware.com>
References: <20190502124009.32208-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If the application has been started from its installation location,
all Open File dialogs will start at ${HOME}. Otherwise the dialogs will
start at ${PWD}. If a given dialog has been used already to select a file,
next time the dialog will start in the directory of this file.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsCaptureDialog.cpp |  34 +++-----
 kernel-shark/src/KsCaptureDialog.hpp |   2 +
 kernel-shark/src/KsMainWindow.cpp    |  70 ++++++----------
 kernel-shark/src/KsMainWindow.hpp    |   4 +-
 kernel-shark/src/KsUtils.cpp         | 121 +++++++++++++++++++++++++++
 kernel-shark/src/KsUtils.hpp         |  17 ++++
 6 files changed, 183 insertions(+), 65 deletions(-)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index 1272c2e..2976a3b 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -206,10 +206,9 @@ void KsCaptureControl::_importSettings()
 	events = tep_list_events(_localTEP, TEP_EVENT_SORT_SYSTEM);
 
 	/* Get the configuration document. */
-	fileName = QFileDialog::getOpenFileName(this,
-						"Import from Filter",
-						KS_DIR,
-						"Kernel Shark Config files (*.json);;");
+	fileName = KsUtils::getFile(this, "Import from Filter",
+				    "Kernel Shark Config files (*.json);;",
+				    _lastFilePath);
 
 	if (fileName.isEmpty())
 		return;
@@ -256,23 +255,16 @@ void KsCaptureControl::_exportSettings()
 	json_object *jplugin;
 	QString plugin, out, comm;
 	QVector<int> ids;
-	QString fileName =
-		QFileDialog::getSaveFileName(this,
-					     "Export to File",
-					     KS_DIR,
-					     "Kernel Shark Config files (*.json);;");
+	QString fileName;
+
+	fileName = KsUtils::getSaveFile(this, "Export to File",
+					"Kernel Shark Config files (*.json);;",
+					".json",
+					_lastFilePath);
 
 	if (fileName.isEmpty())
 		return;
 
-	if (!fileName.endsWith(".json")) {
-		fileName += ".json";
-		if (QFileInfo(fileName).exists()) {
-			if (!KsWidgetsLib::fileExistsDialog(fileName))
-				return;
-		}
-	}
-
 	/* Create a configuration document. */
 	conf = kshark_record_config_new(KS_CONFIG_JSON);
 	events = kshark_filter_config_new(KS_CONFIG_JSON);
@@ -312,10 +304,10 @@ void KsCaptureControl::_exportSettings()
 void KsCaptureControl::_browse()
 {
 	QString fileName =
-		QFileDialog::getSaveFileName(this,
-					     "Save File",
-					     KS_DIR,
-					     "trace-cmd files (*.dat);;All files (*)");
+		KsUtils::getSaveFile(this, "Save File",
+				     "trace-cmd files (*.dat);;All files (*)",
+				     ".dat",
+				     _lastFilePath);
 
 	if (!fileName.isEmpty())
 		_outputLineEdit.setText(fileName);
diff --git a/kernel-shark/src/KsCaptureDialog.hpp b/kernel-shark/src/KsCaptureDialog.hpp
index d65f475..2265704 100644
--- a/kernel-shark/src/KsCaptureDialog.hpp
+++ b/kernel-shark/src/KsCaptureDialog.hpp
@@ -61,6 +61,8 @@ private:
 
 	QPushButton	_outputBrowseButton;
 
+	QString		_lastFilePath;
+
 	QStringList _getPlugins();
 
 	void _importSettings();
diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index c839aca..748bacd 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -360,11 +360,11 @@ void KsMainWindow::_createMenus()
 
 void KsMainWindow::_open()
 {
-	QString fileName =
-		QFileDialog::getOpenFileName(this,
-					     "Open File",
-					     KS_DIR,
-					     "trace-cmd files (*.dat);;All files (*)");
+	QString fileName;
+
+	fileName = KsUtils::getFile(this, "Open File",
+				    "trace-cmd files (*.dat);;All files (*)",
+				    _lastDataFilePath);
 
 	if (!fileName.isEmpty())
 		loadDataFile(fileName);
@@ -429,11 +429,11 @@ void KsMainWindow::_restoreSession()
 
 void KsMainWindow::_importSession()
 {
-	QString fileName =
-		QFileDialog::getOpenFileName(this,
-					     "Import Session",
-					     KS_DIR,
-					     "Kernel Shark Config files (*.json);;");
+	QString fileName;
+
+	fileName = KsUtils::getFile(this, "Import Session",
+				    "Kernel Shark Config files (*.json);;",
+				    _lastConfFilePath);
 
 	if (fileName.isEmpty())
 		return;
@@ -460,23 +460,15 @@ void KsMainWindow::_updateSession()
 
 void KsMainWindow::_exportSession()
 {
-	QString fileName =
-		QFileDialog::getSaveFileName(this,
-					     "Export Filter",
-					     KS_DIR,
-					     "Kernel Shark Config files (*.json);;");
+	QString fileName;
 
+	fileName = KsUtils::getSaveFile(this, "Export Filter",
+					"Kernel Shark Config files (*.json);;",
+					".json",
+					_lastConfFilePath);
 	if (fileName.isEmpty())
 		return;
 
-	if (!fileName.endsWith(".json")) {
-		fileName += ".json";
-		if (QFileInfo(fileName).exists()) {
-			if (!KsWidgetsLib::fileExistsDialog(fileName))
-				return;
-		}
-	}
-
 	_updateSession();
 	_session.exportToFile(fileName);
 }
@@ -512,8 +504,9 @@ void KsMainWindow::_importFilter()
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	fileName = QFileDialog::getOpenFileName(this, "Import Filter", KS_DIR,
-						"Kernel Shark Config files (*.json);;");
+	fileName = KsUtils::getFile(this, "Import Filter",
+				    "Kernel Shark Config files (*.json);;",
+				    _lastConfFilePath);
 
 	if (fileName.isEmpty())
 		return;
@@ -540,20 +533,14 @@ void KsMainWindow::_exportFilter()
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	fileName = QFileDialog::getSaveFileName(this, "Export Filter", KS_DIR,
-						"Kernel Shark Config files (*.json);;");
+	fileName = KsUtils::getSaveFile(this, "Export Filter",
+					"Kernel Shark Config files (*.json);;",
+					".json",
+					_lastConfFilePath);
 
 	if (fileName.isEmpty())
 		return;
 
-	if (!fileName.endsWith(".json")) {
-		fileName += ".json";
-		if (QFileInfo(fileName).exists()) {
-			if (!KsWidgetsLib::fileExistsDialog(fileName))
-				return;
-		}
-	}
-
 	kshark_export_all_event_filters(kshark_ctx, &conf);
 	kshark_save_config_file(fileName.toStdString().c_str(), conf);
 	kshark_free_config_doc(conf);
@@ -859,15 +846,12 @@ void KsMainWindow::_pluginAdd()
 {
 	QStringList fileNames;
 
-	fileNames =
-		QFileDialog::getOpenFileNames(this, "Add KernelShark plugins",
-					      KS_DIR,
-					      "KernelShark Plugins (*.so);;");
-
-	if (fileNames.isEmpty())
-		return;
+	fileNames = KsUtils::getFiles(this, "Add KernelShark plugins",
+				     "KernelShark Plugins (*.so);;",
+				     _lastPluginFilePath);
 
-	_plugins.addPlugins(fileNames);
+	if (!fileNames.isEmpty())
+		_plugins.addPlugins(fileNames);
 }
 
 void KsMainWindow::_record()
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index ec6506e..2bf3285 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -151,7 +151,9 @@ private:
 
 	QAction		_contentsAction;
 
-	QShortcut        _deselectShortcut;
+	QShortcut	_deselectShortcut;
+
+	QString		_lastDataFilePath, _lastConfFilePath, _lastPluginFilePath;
 
 	void _open();
 
diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index 6af0c66..8c42206 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -11,6 +11,7 @@
 
 // KernelShark
 #include "KsUtils.hpp"
+#include "KsWidgetsLib.hpp"
 
 namespace KsUtils {
 
@@ -136,6 +137,126 @@ bool matchCPUVisible(struct kshark_context *kshark_ctx,
 	return (e->cpu == cpu && (e->visible & KS_GRAPH_VIEW_FILTER_MASK));
 }
 
+/**
+ * @brief Check if the application runs from its installation location.
+ */
+bool isInstalled()
+{
+	QString appPath = QCoreApplication::applicationFilePath();
+	QString installPath(_INSTALL_PREFIX);
+
+	installPath += "/bin/kernelshark";
+	installPath = QDir::cleanPath(installPath);
+
+	return appPath == installPath;
+}
+
+static QString getFileDialog(QWidget *parent,
+			     const QString &windowName,
+			     const QString &filter,
+			     QString &lastFilePath,
+			     bool forSave)
+{
+	QString fileName;
+
+	if (lastFilePath.isEmpty()) {
+		lastFilePath = isInstalled() ? QDir::homePath() :
+					       QDir::currentPath();
+	}
+
+	if (forSave) {
+		fileName = QFileDialog::getSaveFileName(parent,
+							windowName,
+							lastFilePath,
+							filter);
+	} else {
+		fileName = QFileDialog::getOpenFileName(parent,
+							windowName,
+							lastFilePath,
+							filter);
+	}
+
+	if (!fileName.isEmpty())
+		lastFilePath = QFileInfo(fileName).path();
+
+	return fileName;
+}
+
+static QStringList getFilesDialog(QWidget *parent,
+				  const QString &windowName,
+				  const QString &filter,
+				  QString &lastFilePath)
+{
+	QStringList fileNames;
+
+	if (lastFilePath.isEmpty()) {
+		lastFilePath = isInstalled() ? QDir::homePath() :
+					       QDir::currentPath();
+	}
+
+	fileNames = QFileDialog::getOpenFileNames(parent,
+						  windowName,
+						  lastFilePath,
+						  filter);
+
+	if (!fileNames.isEmpty())
+		lastFilePath = QFileInfo(fileNames[0]).path();
+
+	return fileNames;
+}
+
+/**
+ * @brief Open a standard Qt getFileName dialog and return the name of the
+ *	  selected file. Only one file can be selected.
+ */
+QString getFile(QWidget *parent,
+		const QString &windowName,
+		const QString &filter,
+		QString &lastFilePath)
+{
+	return getFileDialog(parent, windowName, filter, lastFilePath, false);
+}
+
+/**
+ * @brief Open a standard Qt getFileName dialog and return the names of the
+ *	  selected files. Multiple files can be selected.
+ */
+QStringList getFiles(QWidget *parent,
+		     const QString &windowName,
+		     const QString &filter,
+		     QString &lastFilePath)
+{
+	return getFilesDialog(parent, windowName, filter, lastFilePath);
+}
+
+/**
+ * @brief Open a standard Qt getFileName dialog and return the name of the
+ *	  selected file. Only one file can be selected.
+ */
+QString getSaveFile(QWidget *parent,
+		    const QString &windowName,
+		    const QString &filter,
+		    const QString &extension,
+		    QString &lastFilePath)
+{
+	QString fileName = getFileDialog(parent,
+					 windowName,
+					 filter,
+					 lastFilePath,
+					 true);
+
+	if (!fileName.isEmpty() && !fileName.endsWith(extension)) {
+		fileName += extension;
+
+		if (QFileInfo(fileName).exists()) {
+			if (!KsWidgetsLib::fileExistsDialog(fileName))
+				fileName.clear();
+		}
+	}
+
+	return fileName;
+}
+
 }; // KsUtils
 
 /** A stream operator for converting QColor into KsPlot::Color. */
diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
index c8b5e88..7b80b21 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -111,6 +111,23 @@ inline QString Ts2String(int64_t ts, int prec)
 
 bool matchCPUVisible(struct kshark_context *kshark_ctx,
 			      struct kshark_entry *e, int cpu);
+
+QString getFile(QWidget *parent,
+		const QString &windowName,
+		const QString &filter,
+		QString &lastFilePath);
+
+QStringList getFiles(QWidget *parent,
+		     const QString &windowName,
+		     const QString &filter,
+		     QString &lastFilePath);
+
+QString getSaveFile(QWidget *parent,
+		    const QString &windowName,
+		    const QString &filter,
+		    const QString &extension,
+		    QString &lastFilePath);
+
 }; // KsUtils
 
 /** Identifier of the Dual Marker active state. */
-- 
2.20.1

