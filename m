Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C08FC433E9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F029A64EA9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhBARZt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhBARZm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:25:42 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBABC061794
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:24 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id n6so19754455edt.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aRGPnmVJ3x74ujs38CBBI0OlHVGEWkX91q8T7fnnn+E=;
        b=umhxP806u8eUdwfEmXniI5wf3SSRJoeJeAf9C8uk4Ok1MikVor9iDi7u9t5VnWFrZV
         pGBnCVZWDbAHidvSGIcsUhj9qxRHeO5oO8KKxrz9IAXHezoFgRzXwrQGLpUwLmZtcSU5
         9fDoYMgb7FORk5/Kqck+e/LCDjBozqXkh4enTNhKU+h/EOeWifRwBC8KspQJyBUTOs5n
         6N0ep/0RgpWI0HP8oAvhu7gDrZmwoGLO1mRcha0vqsjogVRJBcVotXQAsGgIiyxU5bvo
         QRM2OB64flSDD6AdASus81uoJ9MxaM7IAVQHT5ZpFVACL502e3PNg9ZF1QhAeFnHVmh7
         qBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aRGPnmVJ3x74ujs38CBBI0OlHVGEWkX91q8T7fnnn+E=;
        b=TXwa2D6OL0N75A4+Q553yqpdpfYWVTWCo1yTkFEzfAhTLhNx0O16/hVrxkmiPDXMB1
         PzSVhfThTmC9XSMLy2cDVt5erQ2I5hD/Kma1PvwHKQ3AmAU5XP8XYviPdxtcxDZernsJ
         4urUPKaZs60JjozTDG7cK33H4xIe1iuXSvox3gOgzSIndAC19nf0vjyTM/FeRbtO8Cd8
         iB2pcX3PUgd2OXjXDkN14gcfcqAMevLu0RIlNKTERri+FeK/8ap9u02F5h0VsNuY09ge
         In84YZu6dYf4nxL2cP9RMBrFYFkJu7VCRgG/YMb6nBoh1cZ0LWurS/IsDDLe5BJ8n3rd
         YpSQ==
X-Gm-Message-State: AOAM531QBzAXN2xnyDC7Fgx1a7mfwHdZFMKvI6RhuW1zs5QfXjDtiWnN
        kHsNkejlGf3vRXx8MMcLV5A=
X-Google-Smtp-Source: ABdhPJymitd5gHC5kFoMMiS0e0ZhURAsWgLorhz8vt4mk259Yq0is4TWK67pH7uzlC4GEBqaGjduFw==
X-Received: by 2002:a05:6402:270e:: with SMTP id y14mr19525467edd.322.1612200262798;
        Mon, 01 Feb 2021 09:24:22 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:22 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 11/24] kernel-shark: Update KsWidgetsLib
Date:   Mon,  1 Feb 2021 19:23:45 +0200
Message-Id: <20210201172358.175407-12-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The compilation of  KsWidgetsLib is re-enabled and all functionalities
are made compatible with the new version of the C API of libkshark
(KernelShark 2.0). We re-enable the widgetdemo example as well.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/CMakeLists.txt |  24 +-
 examples/widgetdemo.cpp |  65 ++--
 src/CMakeLists.txt      |   8 +-
 src/KsUtils.cpp         |  29 ++
 src/KsWidgetsLib.cpp    | 695 +++++++++++++++++++++++++++++++++++-----
 src/KsWidgetsLib.hpp    | 331 +++++++++++++++++--
 6 files changed, 996 insertions(+), 156 deletions(-)

diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
index b8bc79a..8360841 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
@@ -23,15 +23,15 @@ target_link_libraries(confio   kshark)
 # message(STATUS "dataplot")
 # add_executable(dplot          dataplot.cpp)
 # target_link_libraries(dplot   kshark-plot)
-#
-# if (Qt5Widgets_FOUND)
-#
-#     message(STATUS "widgetdemo")
-#     add_executable(widgetdemo          widgetdemo.cpp)
-#     target_link_libraries(widgetdemo   kshark-gui)
-#
-#     message(STATUS "cmd_split")
-#     add_executable(cmd_split           cmd_split.cpp)
-#     target_link_libraries(cmd_split    kshark-gui)
-#
-# endif (Qt5Widgets_FOUND)
+
+if (Qt5Widgets_FOUND)
+
+    message(STATUS "widgetdemo")
+    add_executable(widgetdemo          widgetdemo.cpp)
+    target_link_libraries(widgetdemo   kshark-gui)
+
+    message(STATUS "cmd_split")
+    add_executable(cmd_split           cmd_split.cpp)
+    target_link_libraries(cmd_split    kshark-gui)
+
+endif (Qt5Widgets_FOUND)
diff --git a/examples/widgetdemo.cpp b/examples/widgetdemo.cpp
index 73049bf..0234d4b 100644
--- a/examples/widgetdemo.cpp
+++ b/examples/widgetdemo.cpp
@@ -24,6 +24,7 @@
 static char *input_file = nullptr;
 
 using namespace std;
+using namespace KsWidgetsLib;
 
 void usage(const char *prog)
 {
@@ -37,13 +38,11 @@ void usage(const char *prog)
 
 struct TaskPrint : public QObject
 {
-	tep_handle	*_pevent;
-
-	void print(QVector<int> pids)
+	void print(int sd, QVector<int> pids)
 	{
 		for (auto const &pid: pids)
 			cout << "task: "
-			     << tep_data_comm_from_pid(_pevent, pid)
+			     << kshark_comm_from_pid(sd, pid)
 			     << "  pid: " << pid << endl;
 	}
 };
@@ -51,11 +50,12 @@ struct TaskPrint : public QObject
 int main(int argc, char **argv)
 {
 	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
 	QApplication a(argc, argv);
 	KsPluginManager plugins;
+	int c, i(0), sd(-1);
 	KsDataStore data;
 	size_t nRows(0);
-	int c;
 
 	if (!kshark_instance(&kshark_ctx))
 		return 1;
@@ -71,11 +71,11 @@ int main(int argc, char **argv)
 			break;
 
 		case 'p':
-			plugins.registerPlugin(QString(optarg));
+			plugins.registerPlugins(QString(optarg));
 			break;
 
 		case 'u':
-			plugins.unregisterPlugin(QString(optarg));
+			plugins.unregisterPlugins(QString(optarg));
 			break;
 
 		case 'h':
@@ -91,7 +91,7 @@ int main(int argc, char **argv)
 	}
 
 	if (input_file) {
-		data.loadDataFile(input_file);
+		sd = data.loadDataFile(input_file, {});
 		nRows = data.size();
 	} else {
 		cerr << "No input file is provided.\n";
@@ -99,54 +99,51 @@ int main(int argc, char **argv)
 
 	cout << nRows << " entries loaded\n";
 
-	auto lamPrintPl = [&]()
-	{
-		kshark_plugin_list *pl;
-		for (pl = kshark_ctx->plugins; pl; pl = pl->next)
-			cout << pl->file << endl;
-	};
+	if (!nRows)
+		return 1;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return 1;
 
 	cout << "\n\n";
-	lamPrintPl();
+	for (kshark_plugin_list *pl = kshark_ctx->plugins; pl; pl = pl->next)
+			cout << pl->file << endl;
 	sleep(1);
 
-	QVector<bool> registeredPlugins;
 	QStringList pluginsList;
+	QVector<int> streamIds, enabledPlugins, failedPlugins;
 
-	pluginsList << plugins._ksPluginList
-		    << plugins._userPluginList;
-
-	registeredPlugins << plugins._registeredKsPlugins
-			  << plugins._registeredUserPlugins;
+	pluginsList = plugins.getStreamPluginList(sd);
+	enabledPlugins = plugins.getActivePlugins(sd);
+	failedPlugins = plugins.getPluginsByStatus(sd, KSHARK_PLUGIN_FAILED);
 
 	KsCheckBoxWidget *pluginCBD
-		= new KsPluginCheckBoxWidget(pluginsList);
-
-	pluginCBD->set(registeredPlugins);
+		= new KsPluginCheckBoxWidget(sd, pluginsList);
+	pluginCBD->set(enabledPlugins);
 
-	KsCheckBoxDialog *dialog1 = new KsCheckBoxDialog(pluginCBD);
+	KsCheckBoxDialog *dialog1 = new KsCheckBoxDialog({pluginCBD});
+	dialog1->applyStatus();
 	QObject::connect(dialog1,	&KsCheckBoxDialog::apply,
-			&plugins,	&KsPluginManager::updatePlugins);
+			 &plugins,	&KsPluginManager::updatePlugins);
 
 	dialog1->show();
 	a.exec();
 
 	cout << "\n\nYou selected\n";
-	lamPrintPl();
-	sleep(1);
+	enabledPlugins = plugins.getActivePlugins(sd);
+	for (auto const &p: pluginsList)
+		qInfo() << p << (bool) enabledPlugins[i++];
 
-	if (!nRows)
-		return 1;
+	sleep(1);
 
 	KsCheckBoxWidget *tasks_cbd =
-		new KsTasksCheckBoxWidget(data.tep(), true);
+		new KsTasksCheckBoxWidget(stream, true);
 
 	tasks_cbd->setDefault(false);
 
 	TaskPrint p;
-	p._pevent = data.tep();
-
-	KsCheckBoxDialog *dialog2 = new KsCheckBoxDialog(tasks_cbd);
+	KsCheckBoxDialog *dialog2 = new KsCheckBoxDialog({tasks_cbd});
 	QObject::connect(dialog2,	&KsCheckBoxDialog::apply,
 			 &p,		&TaskPrint::print);
 
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index b308403..140fed8 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -69,9 +69,9 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
     set (ks-guiLib_hdr  KsUtils.hpp
                         KsModels.hpp
 #                         KsGLWidget.hpp
-                        KsSearchFSM.hpp)
+                        KsSearchFSM.hpp
 #                         KsDualMarker.hpp
-#                         KsWidgetsLib.hpp
+                        KsWidgetsLib.hpp)
 #                         KsTraceGraph.hpp
 #                         KsTraceViewer.hpp
 #                         KsMainWindow.hpp
@@ -85,9 +85,9 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                                                             KsModels.cpp
 #                                                             KsSession.cpp
 #                                                             KsGLWidget.cpp
-                                                            KsSearchFSM.cpp)
+                                                            KsSearchFSM.cpp
 #                                                             KsDualMarker.cpp
-#                                                             KsWidgetsLib.cpp
+                                                            KsWidgetsLib.cpp)
 #                                                             KsTraceGraph.cpp
 #                                                             KsTraceViewer.cpp
 #                                                             KsMainWindow.cpp
diff --git a/src/KsUtils.cpp b/src/KsUtils.cpp
index 36f9b25..27cda55 100644
--- a/src/KsUtils.cpp
+++ b/src/KsUtils.cpp
@@ -13,6 +13,7 @@
 #include "libkshark-plugin.h"
 #include "libkshark-tepdata.h"
 #include "KsUtils.hpp"
+#include "KsWidgetsLib.hpp"
 
 namespace KsUtils {
 
@@ -451,6 +452,34 @@ QStringList getFiles(QWidget *parent,
 	return getFilesDialog(parent, windowName, filter, lastFilePath);
 }
 
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
 /**
  * @brief Separate the command line arguments inside the string taking into
  *	  account possible shell quoting and new lines.
diff --git a/src/KsWidgetsLib.cpp b/src/KsWidgetsLib.cpp
index a84aff3..4ec6033 100644
--- a/src/KsWidgetsLib.cpp
+++ b/src/KsWidgetsLib.cpp
@@ -9,13 +9,18 @@
  *  @brief   Defines small widgets and dialogues used by the KernelShark GUI.
  */
 
+// C
+#include <unistd.h>
+
 // KernelShark
-#include "libkshark.h"
-#include "KsUtils.hpp"
+#include "libkshark-tepdata.h"
 #include "KsCmakeDef.hpp"
 #include "KsPlotTools.hpp"
 #include "KsWidgetsLib.hpp"
 
+namespace KsWidgetsLib
+{
+
 /**
  * @brief Create KsProgressBar.
  *
@@ -25,11 +30,12 @@
 KsProgressBar::KsProgressBar(QString message, QWidget *parent)
 : QWidget(parent),
   _sb(this),
-  _pb(&_sb) {
-	resize(KS_BROGBAR_WIDTH, KS_BROGBAR_HEIGHT);
+  _pb(&_sb),
+  _notDone(false) {
 	setWindowTitle("KernelShark");
 	setLayout(new QVBoxLayout);
-
+	setFixedHeight(KS_PROGBAR_HEIGHT);
+	setFixedWidth(KS_PROGBAR_WIDTH);
 	_pb.setOrientation(Qt::Horizontal);
 	_pb.setTextVisible(false);
 	_pb.setRange(0, KS_PROGRESS_BAR_MAX);
@@ -45,6 +51,13 @@ KsProgressBar::KsProgressBar(QString message, QWidget *parent)
 	show();
 }
 
+/** Destroy the KsProgressBar object. */
+KsProgressBar::~KsProgressBar()
+{
+	_notDone = false;
+	usleep(10000);
+}
+
 /** @brief Set the state of the progressbar.
  *
  * @param i: A value ranging from 0 to KS_PROGRESS_BAR_MAX.
@@ -54,6 +67,101 @@ void KsProgressBar::setValue(int i) {
 	QApplication::processEvents();
 }
 
+/** Show continuous work. */
+void KsProgressBar::workInProgress()
+{
+	int progress, inc;
+	bool inv = false;
+
+	progress = inc = 5;
+	_notDone = true;
+	while (_notDone) {
+		if (progress > KS_PROGRESS_BAR_MAX ||
+		    progress <= 0) {
+			inc = -inc;
+			inv = !inv;
+			_pb.setInvertedAppearance(inv);
+		}
+
+		setValue(progress);
+		progress += inc;
+		usleep(30000);
+	}
+}
+
+/**
+ * @brief Create KsWorkInProgress.
+ *
+ * @param parent: The parent of this widget.
+ */
+KsWorkInProgress::KsWorkInProgress(QWidget *parent)
+: QWidget(parent),
+  _icon(this),
+  _message("work in progress", this)
+{
+	QIcon statusIcon = QIcon::fromTheme("dialog-warning");
+	_icon.setPixmap(statusIcon.pixmap(.8 * FONT_HEIGHT));
+}
+
+/**
+ * @brief Show the "work in progress" notification.
+ *
+ * @param w: Data Work identifier.
+ */
+void KsWorkInProgress::show(KsDataWork w)
+{
+	_works.insert(w);
+	if (_works.size() == 1) {
+		_icon.show();
+		_message.show();
+
+		if (w != KsDataWork::RenderGL &&
+		    w != KsDataWork::ResizeGL)
+			QApplication::processEvents();
+	}
+}
+
+/**
+ * @brief Hide the "work in progress" notification.
+ *
+ * @param w: Data Work identifier.
+ */
+void KsWorkInProgress::hide(KsDataWork w)
+{
+	_works.remove(w);
+	if (_works.isEmpty()) {
+		_icon.hide();
+		_message.hide();
+
+		if (w != KsDataWork::RenderGL &&
+		    w != KsDataWork::ResizeGL)
+			QApplication::processEvents();
+	}
+}
+
+/**
+ * @brief Returns True the "work in progress" notification is active.
+ *	  Otherwise False.
+ *
+ * @param w: Data Work identifier.
+ */
+bool KsWorkInProgress::isBusy(KsDataWork w) const
+{
+	if (w == KsDataWork::AnyWork)
+		return _works.isEmpty()? false : true;
+
+	return _works.contains(w)? true : false;
+}
+
+/** Add the KsWorkInProgress widget to a given Status Bar. */
+void KsWorkInProgress::addToStatusBar(QStatusBar *sb)
+{
+	sb->addPermanentWidget(&_icon);
+	sb->addPermanentWidget(&_message);
+	_icon.hide();
+	_message.hide();
+}
+
 /**
  * @brief Create KsMessageDialog.
  *
@@ -76,9 +184,6 @@ KsMessageDialog::KsMessageDialog(QString message, QWidget *parent)
 	this->setLayout(&_layout);
 }
 
-namespace KsWidgetsLib
-{
-
 /**
  * @brief Launch a File exists dialog. Use this function to ask the user
  * before overwriting an existing file.
@@ -103,38 +208,156 @@ bool fileExistsDialog(QString fileName)
 	return (msgBox.exec() == QMessageBox::Save);
 }
 
-}; // KsWidgetsLib
+/** Create KsTimeOffsetDialog. */
+KsTimeOffsetDialog::KsTimeOffsetDialog(QWidget *parent)
+{
+	kshark_context *kshark_ctx(nullptr);
+	QVector<int> streamIds;
+	QString streamName;
+	int64_t max_ofst;
+
+	auto lamApply = [&] (double val) {
+		int sd = _streamCombo.currentData().toInt();
+		emit apply(sd, val);
+		close();
+	};
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	this->setLayout(new QVBoxLayout);
+
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	if (streamIds.size() > 1) {
+		for (auto const &sd: streamIds)
+			if (sd != 0) {
+				streamName = KsUtils::streamDescription(kshark_ctx->stream[sd]);
+				_streamCombo.addItem(streamName);
+			}
+
+		layout()->addWidget(&_streamCombo);
+	}
+
+	_input.setInputMode(QInputDialog::DoubleInput);
+	 max_ofst = (int64_t) 1 << 60;
+	_input.setDoubleRange(-max_ofst, max_ofst);
+	_input.setDoubleDecimals(3);
+	_input.setLabelText("Offset [usec]:");
+	_setDefault(_streamCombo.currentIndex());
+
+	layout()->addWidget(&_input);
+
+	connect(&_input,	&QInputDialog::doubleValueSelected,
+		lamApply);
+
+	connect(&_input,	&QDialog::rejected,
+		this,		&QWidget::close);
+
+	connect(&_streamCombo,	SIGNAL(currentIndexChanged(int)),
+		SLOT(_setDefault(int)));
+
+	show();
+}
+
+void KsTimeOffsetDialog::_setDefault(int index) {
+	int sd = _streamCombo.currentData().toInt();
+	kshark_context *kshark_ctx(nullptr);
+	struct kshark_data_stream *stream;
+	double offset;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return;
+
+	if (!stream->calib_array) {
+		stream->calib = kshark_offset_calib;
+		stream->calib_array =
+			(int64_t *) calloc(1, sizeof(int64_t));
+		stream->calib_array_size = 1;
+	}
+
+	offset = stream->calib_array[0] * 1e-3;
+	_input.setDoubleValue(offset);
+}
+
+/**
+ * @brief Static function that starts a KsTimeOffsetDialog and returns value
+ *	  selected by the user.
+ *
+ * @param dataFile: The name of the trace file to which the Time Offset will
+ *		    apply. To be shown by the dialog.
+ * @param ok: Output location to a success flag. True if the user has pressed
+ *	      "Apply".
+ */
+double KsTimeOffsetDialog::getValueNanoSec(QString dataFile, bool *ok)
+{
+	KsTimeOffsetDialog dialog;
+	int64_t ofst(0);
+	int sd(-1);
+
+	*ok = false;
+
+	auto lamGetOffset = [&] (int stream_id, double ms) {
+		ofst = ms * 1000;
+		sd = stream_id;
+		*ok = true;
+	};
+
+	connect(&dialog, &KsTimeOffsetDialog::apply, lamGetOffset);
+	dialog._streamCombo.hide();
+	dialog._input.setLabelText(dataFile + "\nOffset [usec]:");
+	dialog.exec();
+
+	return ofst;
+}
 
 /**
  * @brief Create KsCheckBoxWidget.
  *
+ * @param sd: Data stream identifier.
  * @param name: The name of this widget.
  * @param parent: The parent of this widget.
  */
-KsCheckBoxWidget::KsCheckBoxWidget(const QString &name, QWidget *parent)
+KsCheckBoxWidget::KsCheckBoxWidget(int sd, const QString &name,
+				   QWidget *parent)
 : QWidget(parent),
-  _tb(this),
-  _allCb("all", &_tb),
+  _userInput(false),
+  _sd(sd),
+  _allCb("all"),
   _cbWidget(this),
   _cbLayout(&_cbWidget),
   _topLayout(this),
+  _allCbAction(nullptr),
+  _streamLabel("", this),
   _name(name),
-  _nameLabel(name + ":  ",&_tb)
+  _nameLabel(name + ":  ")
 {
 	setWindowTitle(_name);
 	setMinimumHeight(SCREEN_HEIGHT / 2);
+	setMinimumWidth(FONT_WIDTH * 20);
+
+	auto lamCheckAll = [this] (bool s) {
+		_userInput = true;
+		_checkAll(s);
+	};
 
 	connect(&_allCb,	&QCheckBox::clicked,
-		this,		&KsCheckBoxWidget::_checkAll);
+				lamCheckAll);
 
 	_cbWidget.setLayout(&_cbLayout);
 
+	_setStream(sd);
+	if (!_streamLabel.text().isEmpty())
+		_topLayout.addWidget(&_streamLabel);
+
 	_tb.addWidget(&_nameLabel);
-	_tb.addWidget(&_allCb);
-	_topLayout.addWidget(&_tb);
+	_allCbAction = _tb.addWidget(&_allCb);
 
+	_topLayout.addWidget(&_tb);
 	_topLayout.addWidget(&_cbWidget);
-	_topLayout.setContentsMargins(0, 0, 0, 0);
 
 	setLayout(&_topLayout);
 	_allCb.setCheckState(Qt::Checked);
@@ -154,6 +377,27 @@ void KsCheckBoxWidget::setDefault(bool st)
 	_checkAll(state);
 }
 
+/** Set the stream Id of the widget. */
+void KsCheckBoxWidget::_setStream(int8_t sd)
+{
+	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	_sd = sd;
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return;
+
+	_streamName = KsUtils::streamDescription(stream);
+
+	KsUtils::setElidedText(&_streamLabel, _streamName,
+			       Qt::ElideLeft, width());
+	QApplication::processEvents();
+}
+
 /** Get a vector containing the indexes of all checked boxes. */
 QVector<int> KsCheckBoxWidget::getCheckedIds()
 {
@@ -167,12 +411,24 @@ QVector<int> KsCheckBoxWidget::getCheckedIds()
 	return vec;
 }
 
+/** Get a vector containing the state of all checkboxes. */
+QVector<int> KsCheckBoxWidget::getStates()
+{
+	int n = _id.size();
+	QVector<int> vec(n);
+
+	for (int i = 0; i < n; ++i)
+		vec[i] = !!_checkState(i);
+
+	return vec;
+}
+
 /**
  * @brief Set the state of the checkboxes.
  *
- * @param v: Vector containing the bool values for all checkboxes.
+ * @param v: Vector containing the state values for all checkboxes.
  */
-void KsCheckBoxWidget::set(QVector<bool> v)
+void KsCheckBoxWidget::set(QVector<int> v)
 {
 	Qt::CheckState state;
 	int nChecks;
@@ -215,18 +471,24 @@ void KsCheckBoxWidget::_checkAll(bool st)
 /**
  * @brief Create KsCheckBoxDialog.
  *
- * @param cbw: A KsCheckBoxWidget to be nested in this dialog.
+ * @param cbws: A vector of KsCheckBoxWidgets to be nested in this dialog.
  * @param parent: The parent of this widget.
  */
-KsCheckBoxDialog::KsCheckBoxDialog(KsCheckBoxWidget *cbw, QWidget *parent)
-: QDialog(parent), _checkBoxWidget(cbw),
+KsCheckBoxDialog::KsCheckBoxDialog(QVector<KsCheckBoxWidget *> cbws, QWidget *parent)
+: QDialog(parent),
+  _applyIds(true),
+  _checkBoxWidgets(cbws),
   _applyButton("Apply", this),
   _cancelButton("Cancel", this)
 {
 	int buttonWidth;
 
-	setWindowTitle(cbw->name());
-	_topLayout.addWidget(_checkBoxWidget);
+	if (!cbws.isEmpty())
+		setWindowTitle(cbws[0]->name());
+
+	for (auto const &w: _checkBoxWidgets)
+		_cbLayout.addWidget(w);
+	_topLayout.addLayout(&_cbLayout);
 
 	buttonWidth = STRING_WIDTH("--Cancel--");
 	_applyButton.setFixedWidth(buttonWidth);
@@ -256,16 +518,29 @@ KsCheckBoxDialog::KsCheckBoxDialog(KsCheckBoxWidget *cbw, QWidget *parent)
 
 void KsCheckBoxDialog::_applyPress()
 {
-	QVector<int> vec = _checkBoxWidget->getCheckedIds();
-	emit apply(vec);
+	QVector<int> vec;
 
 	/*
 	 * Disconnect _applyButton. This is done in order to protect
 	 * against multiple clicks.
 	 */
 	disconnect(_applyButtonConnection);
-}
 
+	_preApplyAction();
+
+	for (auto const &w: _checkBoxWidgets) {
+		if (!w->_userInput)
+			continue;
+
+		if (_applyIds)
+			vec = w->getCheckedIds();
+		else
+			vec = w->getStates();
+		emit apply(w->sd(), vec);
+	}
+
+	_postApplyAction();
+}
 
 /**
  * @brief Create KsCheckBoxTable.
@@ -356,12 +631,13 @@ void KsCheckBoxTable::_doubleClicked(int row, int col)
 /**
  * @brief Create KsCheckBoxTableWidget.
  *
+ * @param sd: Data stream identifier.
  * @param name: The name of this widget.
  * @param parent: The parent of this widget.
  */
-KsCheckBoxTableWidget::KsCheckBoxTableWidget(const QString &name,
+KsCheckBoxTableWidget::KsCheckBoxTableWidget(int sd, const QString &name,
 					     QWidget *parent)
-: KsCheckBoxWidget(name, parent),
+: KsCheckBoxWidget(sd, name, parent),
   _table(this)
 {
 	connect(&_table,	&KsCheckBoxTable::changeState,
@@ -409,6 +685,8 @@ void  KsCheckBoxTableWidget::_update(bool state)
 	/* If a Checkbox is being unchecked. Unchecked "all" as well. */
 	if (!state)
 		_allCb.setCheckState(Qt::Unchecked);
+
+	_userInput = true;
 }
 
 void KsCheckBoxTableWidget::_changeState(int row)
@@ -425,6 +703,8 @@ void KsCheckBoxTableWidget::_changeState(int row)
 			break;
 		}
 	}
+
+	_userInput = true;
 }
 
 static void update_r(QTreeWidgetItem *item, Qt::CheckState state)
@@ -511,16 +791,24 @@ void KsCheckBoxTree::mousePressEvent(QMouseEvent *event)
 /**
  * @brief Create KsCheckBoxTreeWidget.
  *
+ * @param sd: Data stream identifier.
  * @param name: The name of this widget.
  * @param parent: The parent of this widget.
  */
-KsCheckBoxTreeWidget::KsCheckBoxTreeWidget(const QString &name,
+KsCheckBoxTreeWidget::KsCheckBoxTreeWidget(int sd, const QString &name,
 					   QWidget *parent)
-: KsCheckBoxWidget(name, parent),
+: KsCheckBoxWidget(sd, name, parent),
   _tree(this)
 {
-	connect(&_tree,	&KsCheckBoxTree::verify,
-		this,	&KsCheckBoxTreeWidget::_verify);
+	connect(&_tree,		&KsCheckBoxTree::verify,
+		this,		&KsCheckBoxTreeWidget::_verify);
+
+	auto lamSetUserInput = [this] (QTreeWidgetItem *, int) {
+		_userInput = true;
+	};
+
+	connect(&_tree,		&QTreeWidget::itemClicked,
+				lamSetUserInput);
 }
 
 /** Initialize the KsCheckBoxTree and its layout. */
@@ -553,7 +841,7 @@ void KsCheckBoxTreeWidget::_adjustSize()
 		width = _tree.visualItemRect(_tree.topLevelItem(0)).width();
 	}
 
-	width += FONT_WIDTH*3 + style()->pixelMetric(QStyle::PM_ScrollBarExtent);
+	width += FONT_WIDTH * 3 + style()->pixelMetric(QStyle::PM_ScrollBarExtent);
 	_cbWidget.resize(width, _cbWidget.height());
 
 	for (int i = 0; i < n; ++i)
@@ -614,14 +902,13 @@ void KsCheckBoxTreeWidget::_verify()
 /**
  * @brief Create KsCPUCheckBoxWidget.
  *
- * @param tep: Trace event parseer.
+ * @param stream: Input location for a Data stream pointer.
  * @param parent: The parent of this widget.
  */
-KsCPUCheckBoxWidget::KsCPUCheckBoxWidget(struct tep_handle *tep,
-					 QWidget *parent)
-: KsCheckBoxTreeWidget("CPUs", parent)
+KsCPUCheckBoxWidget::KsCPUCheckBoxWidget(kshark_data_stream *stream, QWidget *parent)
+: KsCheckBoxTreeWidget(stream->stream_id, "CPUs", parent)
 {
-	int nCPUs(0), height(FONT_HEIGHT * 1.5);
+	int height(FONT_HEIGHT * 1.5);
 	KsPlot::ColorTable colors;
 	QString style;
 
@@ -630,19 +917,16 @@ KsCPUCheckBoxWidget::KsCPUCheckBoxWidget(struct tep_handle *tep,
 
 	_initTree();
 
-	if (tep)
-		nCPUs = tep_get_cpus(tep);
+	_id.resize(stream->n_cpus);
+	_cb.resize(stream->n_cpus);
+	colors = KsPlot::CPUColorTable();
 
-	_id.resize(nCPUs);
-	_cb.resize(nCPUs);
-	colors = KsPlot::getCPUColorTable();
-
-	for (int i = 0; i < nCPUs; ++i) {
+	for (int i = 0; i < stream->n_cpus; ++i) {
 		QTreeWidgetItem *cpuItem = new QTreeWidgetItem;
 		cpuItem->setText(0, "  ");
 		cpuItem->setText(1, QString("CPU %1").arg(i));
 		cpuItem->setCheckState(0, Qt::Checked);
-		cpuItem->setBackground(0, QColor(colors[i].r(),
+		cpuItem->setBackgroundColor(0, QColor(colors[i].r(),
 						      colors[i].g(),
 						      colors[i].b()));
 		_tree.addTopLevelItem(cpuItem);
@@ -656,36 +940,66 @@ KsCPUCheckBoxWidget::KsCPUCheckBoxWidget(struct tep_handle *tep,
 /**
  * @brief Create KsEventsCheckBoxWidget.
  *
- * @param tep: Trace event parseer.
+ * @param stream: Input location for a Data stream pointer.
  * @param parent: The parent of this widget.
  */
-KsEventsCheckBoxWidget::KsEventsCheckBoxWidget(struct tep_handle *tep,
+KsEventsCheckBoxWidget::KsEventsCheckBoxWidget(kshark_data_stream *stream,
 					       QWidget *parent)
-: KsCheckBoxTreeWidget("Events", parent)
+: KsCheckBoxTreeWidget(stream->stream_id, "Events", parent)
 {
-	QTreeWidgetItem *sysItem, *evtItem;
-	tep_event **events(nullptr);
-	QString sysName, evtName;
-	int nEvts(0), i(0);
+	QVector<int> eventIds = KsUtils::getEventIdList(stream->stream_id);
+
+	_initTree();
+	if(!stream->n_events || eventIds.isEmpty())
+		return;
+
+	_id.resize(stream->n_events);
+	_cb.resize(stream->n_events);
 
-	if (tep) {
-		nEvts = tep_get_events_count(tep);
-		events = tep_list_events(tep, TEP_EVENT_SORT_SYSTEM);
+	if (kshark_is_tep(stream))
+		_makeTepEventItems(stream, eventIds);
+	else
+		_makeItems(stream, eventIds);
+}
+
+void KsEventsCheckBoxWidget::_makeItems(kshark_data_stream *stream,
+					QVector<int> eventIds)
+{
+	QTreeWidgetItem *evtItem;
+	QString evtName;
+
+	for (int i = 0; i < stream->n_events; ++i) {
+		evtName = KsUtils::getEventName(stream->stream_id,
+						eventIds[i]);
+		evtItem = new QTreeWidgetItem;
+		evtItem->setText(0, evtName);
+		evtItem->setCheckState(0, Qt::Checked);
+		evtItem->setFlags(evtItem->flags() |
+				  Qt::ItemIsUserCheckable);
+		_tree.addTopLevelItem(evtItem);
+		_cb[i] = evtItem;
 	}
+}
 
-	_initTree();
-	_id.resize(nEvts);
-	_cb.resize(nEvts);
+void KsEventsCheckBoxWidget::_makeTepEventItems(kshark_data_stream *stream,
+						QVector<int> eventIds)
+{
+	QTreeWidgetItem *sysItem, *evtItem;
+	QString sysName, evtName;
+	QStringList name;
+	int i(0);
 
-	while (i < nEvts) {
-		sysName = events[i]->system;
+	while (i < stream->n_events) {
+		name = KsUtils::getTepEvtName(stream->stream_id,
+					      eventIds[i]);
+		sysName = name[0];
 		sysItem = new QTreeWidgetItem;
 		sysItem->setText(0, sysName);
 		sysItem->setCheckState(0, Qt::Checked);
 		_tree.addTopLevelItem(sysItem);
 
-		while (sysName == events[i]->system) {
-			evtName = events[i]->name;
+		while (sysName == name[0]) {
+			evtName = name[1];
 			evtItem = new QTreeWidgetItem;
 			evtItem->setText(0, evtName);
 			evtItem->setCheckState(0, Qt::Checked);
@@ -694,11 +1008,13 @@ KsEventsCheckBoxWidget::KsEventsCheckBoxWidget(struct tep_handle *tep,
 
 			sysItem->addChild(evtItem);
 
-			_id[i] = events[i]->id;
+			_id[i] = eventIds[i];
 			_cb[i] = evtItem;
-
-			if (++i == nEvts)
+			if (++i == stream->n_events)
 				break;
+
+			name = KsUtils::getTepEvtName(stream->stream_id,
+						      eventIds[i]);
 		}
 	}
 
@@ -726,7 +1042,7 @@ QStringList KsEventsCheckBoxWidget::getCheckedEvents(bool option)
 		optStr = "-e";
 
 	nSys = _tree.topLevelItemCount();
-	for (int t = 0; t < nSys; ++t) {
+	for(int t = 0; t < nSys; ++t) {
 		sysItem = _tree.topLevelItem(t);
 		if (sysItem->checkState(0) == Qt::Checked) {
 			list << optStr + sysItem->text(0);
@@ -763,48 +1079,48 @@ void KsEventsCheckBoxWidget::removeSystem(QString name) {
 /**
  * @brief Create KsTasksCheckBoxWidget.
  *
- * @param pevent: Page event used to parse the page.
+ * @param stream: Input location for a Data stream pointer.
  * @param cond: If True make a "Show Task" widget. Otherwise make "Hide Task".
  * @param parent: The parent of this widget.
  */
-KsTasksCheckBoxWidget::KsTasksCheckBoxWidget(struct tep_handle *pevent,
+KsTasksCheckBoxWidget::KsTasksCheckBoxWidget(kshark_data_stream *stream,
 					     bool cond, QWidget *parent)
-: KsCheckBoxTableWidget("Tasks", parent)
+: KsCheckBoxTableWidget(stream->stream_id, "Tasks", parent),
+  _cond(cond)
 {
-	kshark_context *kshark_ctx(nullptr);
 	QTableWidgetItem *pidItem, *comItem;
 	KsPlot::ColorTable colors;
 	QStringList headers;
+	kshark_entry entry;
 	const char *comm;
 	int nTasks, pid;
 
-	if (!kshark_instance(&kshark_ctx))
-		return;
-
 	if (_cond)
 		headers << "Show" << "Pid" << "Task";
 	else
 		headers << "Hide" << "Pid" << "Task";
 
-	_id = KsUtils::getPidList();
+	_id = KsUtils::getPidList(stream->stream_id);
 	nTasks = _id.count();
 	_initTable(headers, nTasks);
-	colors = KsPlot::getTaskColorTable();
-
+	colors = KsPlot::taskColorTable();
+	entry.stream_id = stream->stream_id;
+	entry.visible = 0xff;
 	for (int i = 0; i < nTasks; ++i) {
-		pid = _id[i];
-		pidItem	= new QTableWidgetItem(tr("%1").arg(pid));
+		entry.pid = pid = _id[i];
+		pidItem = new QTableWidgetItem(tr("%1").arg(pid));
 		_table.setItem(i, 1, pidItem);
 
-		comm = tep_data_comm_from_pid(kshark_ctx->pevent, pid);
+		comm = kshark_get_task(&entry);
+
 		comItem = new QTableWidgetItem(tr(comm));
 
-		pidItem->setBackground(QColor(colors[pid].r(),
+		pidItem->setBackgroundColor(QColor(colors[pid].r(),
 						   colors[pid].g(),
 						   colors[pid].b()));
 
 		if (_id[i] == 0)
-			pidItem->setForeground(Qt::white);
+			pidItem->setTextColor(Qt::white);
 
 		_table.setItem(i, 2, comItem);
 	}
@@ -815,12 +1131,13 @@ KsTasksCheckBoxWidget::KsTasksCheckBoxWidget(struct tep_handle *pevent,
 /**
  * @brief Create KsPluginCheckBoxWidget.
  *
+ * @param sd: Data stream identifier.
  * @param pluginList: A list of plugin names.
  * @param parent: The parent of this widget.
  */
-KsPluginCheckBoxWidget::KsPluginCheckBoxWidget(QStringList pluginList,
+KsPluginCheckBoxWidget::KsPluginCheckBoxWidget(int sd, QStringList pluginList,
 					       QWidget *parent)
-: KsCheckBoxTableWidget("Plugins", parent)
+: KsCheckBoxTableWidget(sd, "Manage plugins", parent)
 {
 	QTableWidgetItem *nameItem, *infoItem;
 	QStringList headers;
@@ -833,7 +1150,16 @@ KsPluginCheckBoxWidget::KsPluginCheckBoxWidget(QStringList pluginList,
 	_id.resize(nPlgins);
 
 	for (int i = 0; i < nPlgins; ++i) {
-		nameItem = new QTableWidgetItem(pluginList[i]);
+		if (pluginList[i] < 30) {
+			nameItem = new QTableWidgetItem(pluginList[i]);
+		} else {
+			QLabel l;
+			KsUtils::setElidedText(&l, pluginList[i],
+					       Qt::ElideLeft,
+					       FONT_WIDTH * 30);
+			nameItem = new QTableWidgetItem(l.text());
+		}
+
 		_table.setItem(i, 1, nameItem);
 		infoItem = new QTableWidgetItem(" -- ");
 		_table.setItem(i, 2, infoItem);
@@ -842,3 +1168,200 @@ KsPluginCheckBoxWidget::KsPluginCheckBoxWidget(QStringList pluginList,
 
 	_adjustSize();
 }
+
+/**
+ * @brief Set the "Info" field inside the table of the widget.
+ *
+ * @param row: The row number in the table.
+ * @param info: The "Info" string to be shown.
+ */
+void KsPluginCheckBoxWidget::setInfo(int row, QString info)
+{
+	QTableWidgetItem *infoItem = _table.item(row, 2);
+	infoItem->setText(info);
+}
+
+/**
+ * @brief Set the "Active" field inside the table of the widget.
+ *
+ * @param rows: The row numbers in the table.
+ * @param a: Are those plugins active.
+ */
+void KsPluginCheckBoxWidget::setActive(QVector<int> rows, bool a)
+{
+	for (auto const &r: rows) {
+		QTableWidgetItem *infoItem = _table.item(r, 2);
+		if (a) {
+			infoItem->setText("- Active");
+			infoItem->setForeground(QBrush(QColor(0, 220, 80)));
+		} else {
+			infoItem->setText("- Not Active");
+			infoItem->setForeground(QBrush(QColor(255, 50, 50)));
+		}
+	}
+}
+
+void KsPluginsCheckBoxDialog::_postApplyAction()
+{
+	emit _data->updateWidgets(_data);
+}
+
+/**
+ * @brief Create KsDStreamCheckBoxWidget.
+ *
+ * @param parent: The parent of this widget.
+ */
+KsDStreamCheckBoxWidget::KsDStreamCheckBoxWidget(QWidget *parent)
+: KsCheckBoxTableWidget(-1, "Select Data stream", parent)
+{
+	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
+	QTableWidgetItem *nameItem;
+	QVector<int> streamIds;
+	QStringList headers;
+	int nStreams;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	headers << "Apply" << "To stream";
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	nStreams = streamIds.size();
+	_initTable(headers, nStreams);
+	_id.resize(nStreams);
+
+	for (int i = 0; i < nStreams; ++i) {
+		stream = kshark_ctx->stream[streamIds[i]];
+		QString name = KsUtils::streamDescription(stream);
+		if (name < 40) {
+			nameItem = new QTableWidgetItem(name);
+		} else {
+			QLabel l;
+			KsUtils::setElidedText(&l, name,
+					       Qt::ElideLeft,
+					       FONT_WIDTH * 40);
+			nameItem = new QTableWidgetItem(l.text());
+		}
+
+		_table.setItem(i, 1, nameItem);
+		_id[i] = stream->stream_id;
+	}
+
+	_adjustSize();
+}
+
+/**
+ * @brief Create KsEventFieldSelectWidget.
+ *
+ * @param parent: The parent of this widget.
+ */
+KsEventFieldSelectWidget::KsEventFieldSelectWidget(QWidget *parent)
+: QWidget(parent),
+  _streamLabel("Data stream", this),
+  _eventLabel("Event (type in for searching)", this),
+  _fieldLabel("Field", this)
+{
+	auto lamAddLine = [&] {
+		QFrame* line = new QFrame();
+		QSpacerItem *spacer = new QSpacerItem(1, FONT_HEIGHT / 2,
+						      QSizePolicy::Expanding,
+						      QSizePolicy::Minimum);
+		line->setFrameShape(QFrame::HLine);
+		line->setFrameShadow(QFrame::Sunken);
+		_topLayout.addSpacerItem(spacer);
+		_topLayout.addWidget(line);
+	};
+
+	_topLayout.addWidget(&_streamLabel);
+	_topLayout.addWidget(&_streamComboBox);
+
+	/*
+	 * Using the old Signal-Slot syntax because QComboBox::currentIndexChanged
+	 * has overloads.
+	 */
+	connect(&_streamComboBox,	SIGNAL(currentIndexChanged(const QString&)),
+		this,			SLOT(_streamChanged(const QString&)));
+
+	lamAddLine();
+
+	_topLayout.addWidget(&_eventLabel);
+	_topLayout.addWidget(&_eventComboBox);
+	_eventComboBox.setEditable(true);
+	_eventComboBox.view()->setVerticalScrollBarPolicy(Qt::ScrollBarAsNeeded);
+	_eventComboBox.setMaxVisibleItems(25);
+
+	/*
+	 * Using the old Signal-Slot syntax because QComboBox::currentIndexChanged
+	 * has overloads.
+	 */
+	connect(&_eventComboBox,	SIGNAL(currentIndexChanged(const QString&)),
+		this,			SLOT(_eventChanged(const QString&)));
+
+	lamAddLine();
+
+	_topLayout.addWidget(&_fieldLabel);
+	_topLayout.addWidget(&_fieldComboBox);
+
+	lamAddLine();
+
+	setLayout(&_topLayout);
+}
+
+/** Populate the Data stream selection combo box. */
+void KsEventFieldSelectWidget::setStreamCombo()
+{
+	kshark_context *kshark_ctx(NULL);
+	kshark_data_stream *stream;
+	QVector<int> streamIds;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	for (auto const &sd: streamIds) {
+		stream = kshark_ctx->stream[sd];
+		if (_streamComboBox.findData(sd) < 0)
+			_streamComboBox.addItem(KsUtils::streamDescription(stream), sd);
+	}
+}
+
+void KsEventFieldSelectWidget::_streamChanged(const QString &streamFile)
+{
+	int sd = _streamComboBox.currentData().toInt();
+	QVector<int> eventIds = KsUtils::getEventIdList(sd);
+	QStringList evtsList;
+
+	_eventComboBox.clear();
+
+	for (auto const &eid: eventIds)
+		evtsList << KsUtils::getEventName(sd, eid);
+
+	std::sort(evtsList.begin(), evtsList.end());
+	_eventComboBox.addItems(evtsList);
+}
+
+void KsEventFieldSelectWidget::_eventChanged(const QString &eventName)
+{
+	int sd = _streamComboBox.currentData().toInt();
+	int eventId = KsUtils::getEventId(sd, eventName);
+	QStringList fieldsList = KsUtils::getEventFieldsList(sd, eventId);
+
+	auto lamIsValide = [&] (const QString &f) {
+		return KsUtils::getEventFieldType(sd, eventId, f) ==
+		       KS_INVALID_FIELD;
+	};
+
+	_fieldComboBox.clear();
+
+	fieldsList.erase(std::remove_if(fieldsList.begin(), fieldsList.end(),
+					lamIsValide), fieldsList.end());
+
+	if (fieldsList.isEmpty())
+		return;
+
+	std::sort(fieldsList.begin(), fieldsList.end());
+
+	_fieldComboBox.addItems(fieldsList);
+}
+
+}; // KsWidgetsLib
diff --git a/src/KsWidgetsLib.hpp b/src/KsWidgetsLib.hpp
index 59e773d..428e8dd 100644
--- a/src/KsWidgetsLib.hpp
+++ b/src/KsWidgetsLib.hpp
@@ -15,6 +15,13 @@
 // Qt
 #include <QtWidgets>
 
+// KernelShark
+#include "libkshark.h"
+#include "KsUtils.hpp"
+
+namespace KsWidgetsLib
+{
+
 /**
  * The KsProgressBar class provides a visualization of the progress of a
  * running job.
@@ -30,17 +37,133 @@ class KsProgressBar : public QWidget
 public:
 	KsProgressBar(QString message, QWidget *parent = nullptr);
 
+	virtual ~KsProgressBar();
+
 	void setValue(int i);
+
+	void workInProgress();
+
+private:
+	bool	_notDone;
 };
 
 /** Defines the progress bar's maximum value. */
 #define KS_PROGRESS_BAR_MAX 200
 
 /** The height of the KsProgressBar widget. */
-#define KS_BROGBAR_HEIGHT (FONT_HEIGHT * 5)
+#define KS_PROGBAR_HEIGHT (FONT_HEIGHT * 5)
 
 /** The width of the KsProgressBar widget. */
-#define KS_BROGBAR_WIDTH  (FONT_WIDTH * 50)
+#define KS_PROGBAR_WIDTH  (FONT_WIDTH * 50)
+
+/** Data Work identifiers. */
+enum class KsDataWork
+{
+	AnyWork,
+	EditPlotList,
+	ZoomIn,
+	QuickZoomIn,
+	ZoomOut,
+	QuickZoomOut,
+	ScrollLeft,
+	ScrollRight,
+	JumpTo,
+	GraphUpdateGeom,
+	UpdatePlugins,
+	ResizeGL,
+	RenderGL,
+};
+
+/** Defines hash function needed by the QSet tempate container class. */
+inline uint qHash(KsDataWork key, uint seed)
+{
+	/*
+	 * Cast the enum class to uint and use the definition of qHash outside
+	 * the current scope.
+	 */
+	return ::qHash(static_cast<uint>(key), seed);
+}
+
+/**
+ * The KsWorkInProgress class provides a widget showing the
+ * "work in progress" notification.
+ */
+class KsWorkInProgress : public QWidget
+{
+public:
+	explicit KsWorkInProgress(QWidget *parent = nullptr);
+
+	void show(KsDataWork w);
+
+	void hide(KsDataWork w);
+
+	bool isBusy(KsDataWork w = KsDataWork::AnyWork) const;
+
+	void addToStatusBar(QStatusBar *sb);
+
+private:
+	QLabel	_icon, _message;
+
+	QSet<KsDataWork>	_works;
+};
+
+/**
+ * The KsDataWidget class provides a base widget that provides the capability
+ * to show the "work in progress" notification. The class must be inherited by
+ * the widgets performing heavy data processing operations.
+ */
+class KsDataWidget : public QWidget
+{
+public:
+	/**
+	 * @brief Create KsDataWidget.
+	 *
+	 * @param parent: The parent of this widget.
+	 */
+	explicit KsDataWidget(QWidget *parent = nullptr)
+	: QWidget(parent), _workInProgress(nullptr) {}
+
+	/** Set a pointer to the KsWorkInProgress widget. */
+	const KsWorkInProgress *wipPtr(KsWorkInProgress *wip) const
+	{
+		return _workInProgress;
+	}
+
+	/** Set the pointer to the KsWorkInProgress widget. */
+	void setWipPtr(KsWorkInProgress *wip)
+	{
+		_workInProgress = wip;
+	}
+
+	/**
+	 * Call this function when a given work is about to start in order to
+	 * show the "work in progress" notification.
+	 */
+	void startOfWork(KsDataWork w)
+	{
+		if (_workInProgress)
+			_workInProgress->show(w);
+	}
+
+	/**
+	 * Call this function when a given work is done in order to hide the
+	 * "work in progress" notification.
+	 */
+	void endOfWork(KsDataWork w)
+	{
+		if (_workInProgress)
+			_workInProgress->hide(w);
+	}
+
+	/** Check if the GUI is busy processing data. */
+	bool isBusy(KsDataWork w = KsDataWork::AnyWork) const
+	{
+		return _workInProgress ? _workInProgress->isBusy(w) : false;
+	}
+
+private:
+	KsWorkInProgress	*_workInProgress;
+};
 
 /**
  * The KsMessageDialog class provides a widget showing a message and having
@@ -66,12 +189,32 @@ public:
 /** The width of the KsMessageDialog widget. */
 #define KS_MSG_DIALOG_WIDTH  (SCREEN_WIDTH / 10)
 
-namespace KsWidgetsLib
+bool fileExistsDialog(QString fileName);
+
+/**
+ * The KsTimeOffsetDialog class provides a dialog used to enter the value of
+ * the time offset between two Data streams.
+ */
+class KsTimeOffsetDialog : public QDialog
 {
+	Q_OBJECT
+public:
+	explicit KsTimeOffsetDialog(QWidget *parent = nullptr);
 
-bool fileExistsDialog(QString fileName);
+	static double getValueNanoSec(QString dataFile, bool *ok);
 
-}; // KsWidgetsLib
+signals:
+	/** Signal emitted when the "Apply" button is pressed. */
+	void apply(int sd, double val);
+
+private:
+	QInputDialog	_input;
+
+	QComboBox	_streamCombo;
+
+private slots:
+	void _setDefault(int index);
+};
 
 /**
  * The KsCheckBoxWidget class is the base class of all CheckBox widget used
@@ -81,7 +224,7 @@ class KsCheckBoxWidget : public QWidget
 {
 	Q_OBJECT
 public:
-	KsCheckBoxWidget(const QString &name = "",
+	KsCheckBoxWidget(int sd, const QString &name = "",
 			 QWidget *parent = nullptr);
 
 	/** Get the name of the widget. */
@@ -95,9 +238,12 @@ public:
 		return false;
 	}
 
+	/** The "all" checkboxe to be visible or not. */
+	void setVisibleCbAll(bool v) {_allCbAction->setVisible(v);}
+
 	void setDefault(bool);
 
-	void set(QVector<bool> v);
+	void set(QVector<int> v);
 
 	/**
 	 * Get a vector containing all Ids (can be PID CPU Ids etc.) managed
@@ -107,10 +253,35 @@ public:
 
 	QVector<int> getCheckedIds();
 
+	QVector<int> getStates();
+
+	/**
+	 * Get the identifier of the Data stream for which the selection
+	 * applies.
+	 */
+	int sd() const {return _sd;}
+
+	/**
+	 * Reimplemented event handler used to update the geometry of the widget on
+	 * resize events.
+	 */
+	void resizeEvent(QResizeEvent* event)
+	{
+		KsUtils::setElidedText(&_streamLabel, _streamName,
+				       Qt::ElideLeft, width());
+		QApplication::processEvents();
+	}
+
+	/** The user provided an input. The widget has been modified. */
+	bool _userInput;
+
 private:
 	QToolBar _tb;
 
 protected:
+	/** Identifier of the Data stream for which the selection applies. */
+	int		_sd;
+
 	/** The "all" checkboxe. */
 	QCheckBox	_allCb;
 
@@ -126,13 +297,25 @@ protected:
 	/** The top level layout of this widget. */
 	QVBoxLayout	_topLayout;
 
+private:
+	QAction		*_allCbAction;
+
+	/**
+	 * The name of this Data stream. Typically this will be the name of
+	 * the data file.
+	 */
+	QString		_streamName;
+	/**
+	 * A label to show the name of the Data stream for which the selection
+	 * applies. */
+	QLabel		_streamLabel;
+
 	/** The name of this widget. */
 	QString		_name;
 
 	/** A label to show the name of the widget. */
 	QLabel		_nameLabel;
 
-private:
 	virtual void _setCheckState(int i, Qt::CheckState st) = 0;
 
 	virtual Qt::CheckState _checkState(int i) const = 0;
@@ -140,6 +323,8 @@ private:
 	virtual void _verify() {};
 
 	void _checkAll(bool);
+
+	void _setStream(int8_t sd);
 };
 
 /**
@@ -152,26 +337,65 @@ class KsCheckBoxDialog : public QDialog
 public:
 	KsCheckBoxDialog() = delete;
 
-	KsCheckBoxDialog(KsCheckBoxWidget *cbw, QWidget *parent = nullptr);
+	KsCheckBoxDialog(QVector<KsCheckBoxWidget *> cbws,
+			 QWidget *parent = nullptr);
+
+	/**
+	 * The "apply" signal will emit a vector containing the Ids of all
+	 * checked checkboxe.
+	 */
+	void applyIds(bool v = true) {_applyIds = v;}
+
+	/**
+	 * The "apply" signal will emit a vector containing the statuse of all
+	 * checkboxe.
+	 */
+	void applyStatus(bool v = true) {_applyIds = !v;}
 
 signals:
 	/** Signal emitted when the "Apply" button is pressed. */
-	void apply(QVector<int>);
+	void apply(int sd, QVector<int>);
 
 private:
 	void _applyPress();
 
-	QVBoxLayout		_topLayout;
+	virtual void _preApplyAction() {}
+
+	virtual void _postApplyAction() {}
+
+	bool _applyIds;
+
+	QVBoxLayout			_topLayout;
 
-	QHBoxLayout		_buttonLayout;
+	QHBoxLayout			_cbLayout, _buttonLayout;
 
-	KsCheckBoxWidget	*_checkBoxWidget;
+	QVector<KsCheckBoxWidget *>	_checkBoxWidgets;
 
-	QPushButton		_applyButton, _cancelButton;
+	QPushButton			_applyButton, _cancelButton;
 
 	QMetaObject::Connection		_applyButtonConnection;
 };
 
+/**
+ * The KsPluginsCheckBoxDialog provides dialog for selecting plugins.
+ * used by KernelShark. The class is used to override _postApplyAction().
+ */
+class KsPluginsCheckBoxDialog : public KsCheckBoxDialog
+{
+public:
+	KsPluginsCheckBoxDialog() = delete;
+
+	/** Create KsPluginsCheckBoxDialog. */
+	KsPluginsCheckBoxDialog(QVector<KsCheckBoxWidget *> cbws,
+				KsDataStore *d, QWidget *parent = nullptr)
+	: KsCheckBoxDialog(cbws, parent), _data(d) {}
+
+private:
+	virtual void _postApplyAction() override;
+
+	KsDataStore	*_data;
+};
+
 /** The KsCheckBoxTable class provides a table of checkboxes. */
 class KsCheckBoxTable : public QTableWidget
 {
@@ -205,9 +429,16 @@ class KsCheckBoxTableWidget : public KsCheckBoxWidget
 {
 	Q_OBJECT
 public:
-	KsCheckBoxTableWidget(const QString &name = "",
+	KsCheckBoxTableWidget(int sd, const QString &name = "",
 			      QWidget *parent = nullptr);
 
+	/** Only one checkboxe at the time can be checked. */
+	void setSingleSelection()
+	{
+		_table.setSelectionMode(QAbstractItemView::SingleSelection);
+		setVisibleCbAll(false);
+	}
+
 protected:
 	void _adjustSize();
 
@@ -266,9 +497,16 @@ class KsCheckBoxTreeWidget : public KsCheckBoxWidget
 public:
 	KsCheckBoxTreeWidget() = delete;
 
-	KsCheckBoxTreeWidget(const QString &name = "",
+	KsCheckBoxTreeWidget(int sd, const QString &name = "",
 			     QWidget *parent = nullptr);
 
+	/** Only one checkboxe at the time can be checked. */
+	void setSingleSelection()
+	{
+		_tree.setSelectionMode(QAbstractItemView::SingleSelection);
+		setVisibleCbAll(false);
+	}
+
 protected:
 	void _adjustSize();
 
@@ -304,7 +542,7 @@ struct KsCPUCheckBoxWidget : public KsCheckBoxTreeWidget
 {
 	KsCPUCheckBoxWidget() = delete;
 
-	KsCPUCheckBoxWidget(struct tep_handle *pe,
+	KsCPUCheckBoxWidget(kshark_data_stream *stream,
 			    QWidget *parent = nullptr);
 };
 
@@ -316,7 +554,7 @@ struct KsTasksCheckBoxWidget : public KsCheckBoxTableWidget
 {
 	KsTasksCheckBoxWidget() = delete;
 
-	KsTasksCheckBoxWidget(struct tep_handle *pe,
+	KsTasksCheckBoxWidget(kshark_data_stream *stream,
 			      bool cond = true,
 			      QWidget *parent = nullptr);
 
@@ -336,12 +574,17 @@ struct KsEventsCheckBoxWidget : public KsCheckBoxTreeWidget
 {
 	KsEventsCheckBoxWidget() = delete;
 
-	KsEventsCheckBoxWidget(struct tep_handle *pe,
+	KsEventsCheckBoxWidget(kshark_data_stream *stream,
 			       QWidget *parent = nullptr);
 
 	QStringList getCheckedEvents(bool option);
 
 	void removeSystem(QString name);
+
+private:
+	void _makeItems(kshark_data_stream *stream, QVector<int> eventIds);
+
+	void _makeTepEventItems(kshark_data_stream *stream, QVector<int> eventIds);
 };
 
 /**
@@ -351,8 +594,56 @@ struct KsPluginCheckBoxWidget : public KsCheckBoxTableWidget
 {
 	KsPluginCheckBoxWidget() = delete;
 
-	KsPluginCheckBoxWidget(QStringList pluginList,
+	KsPluginCheckBoxWidget(int sd, QStringList pluginList,
 			       QWidget *parent = nullptr);
+
+	void setInfo(int row, QString info);
+
+	void setActive(QVector<int> rows, bool a);
 };
 
+/**
+ * The KsDStreamCheckBoxWidget class provides a widget for selecting Data streams.
+ */
+struct KsDStreamCheckBoxWidget : public KsCheckBoxTableWidget
+{
+	explicit KsDStreamCheckBoxWidget(QWidget *parent = nullptr);
+};
+
+/**
+ * The KsEventFieldSelectWidget class provides a widget for selecting a data
+ * field of the trace event.
+ */
+class KsEventFieldSelectWidget : public QWidget
+{
+	Q_OBJECT
+public:
+	explicit KsEventFieldSelectWidget(QWidget *parent = nullptr);
+
+	/** Get the currently selected stream Id. */
+	int streamId() const {return _streamComboBox.currentData().toInt();}
+
+	/** Get the currently selected event name. */
+	QString eventName() const {return _eventComboBox.currentText();}
+
+	/** Get the currently selected field name. */
+	QString fieldName() const {return _fieldComboBox.currentText();}
+
+	void setStreamCombo();
+
+private slots:
+	void _streamChanged(const QString &stream);
+
+	void _eventChanged(const QString &event);
+
+private:
+	QVBoxLayout	_topLayout;
+
+	QComboBox	_streamComboBox, _eventComboBox, _fieldComboBox;
+
+	QLabel		_streamLabel, _eventLabel, _fieldLabel;
+};
+
+}; // KsWidgetsLib
+
 #endif
-- 
2.25.1

