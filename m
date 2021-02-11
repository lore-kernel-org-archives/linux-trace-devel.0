Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74B5C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F1E664E9A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhBKKjX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhBKKfv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:35:51 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE32C061225
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:45 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id l25so9256086eja.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t7+/sAocjRfq5fLfRAhz9c05UYu8hEGN+A+DQH2akc4=;
        b=Hd6EMbF5j0TBo91yAo6nxqYcI3h1lOTg6T0vg07hN5FJYevESEcZt5F0Ymojdl/hnc
         dighdBWZ8NAZ3BS4oOtPO5dvfZWPBplRA1vmxswHUVmC/NxkqFLYvGholOdpNnYajRUs
         n7ZngGc0UzuiJI0aeBw2TPxRNJ7MTAdOl9KQu98W4GCA5YCfi0Pfbc50xtnz8cOFsquv
         MHDcJSvMvSvGgx98Ahe/8ribbJVtuWzulU7dNt0pANUBxvvVjAw0GlbjB4s7vuSzjqgY
         OGURLNeTF60MksKcsgXYhEzKMiXeCRRgloUObWrhkAHM/p4yGyjdPy0ptf69nvt3UEkF
         qxgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t7+/sAocjRfq5fLfRAhz9c05UYu8hEGN+A+DQH2akc4=;
        b=nWB1p15dh/Ymosi6d5QKMdBgdn0fhQULvEdqjkdXZEuhtaAx+tdCr72+xPDZxD4hxH
         ZUzXd1Pgjt6lB7NPtFpRqhqUm7kqUIegieUlyejtYImzA6LTk4YavTf0Vkdx41wv/Xef
         Kx5tuXEnN3QhL5sNUk5qyze7r6Pblc4wvCoBV5iqg6GAu2xO5vj0fF7QNMPcJ2vjpXpq
         xIhn0C/hxudvi0VG+bH8215hXhvAHMJ3kTIcA37KR7NVmFdDA/WA4ROY3cn13W38TqzN
         4og+pM/THG3pG6fXlUYO8+N9sdCltJi506mPWKdnNHDmQ+IR7XLlbcRkVQ1s2cTROICq
         zhDw==
X-Gm-Message-State: AOAM532nxzdATemhkp9I/1asV2ipU/i2d6Qe4ipuqdgaWEut4HupFFfy
        CH80UnmD9eSJln+mNac/cR4=
X-Google-Smtp-Source: ABdhPJyalXoetguQ2jRX5QAUkNFZRMFPLD8e3KMxAPYv2gNCzV/UeSlTLpFJVRAx4D6V4Lx+8FxQEQ==
X-Received: by 2002:a17:906:b50:: with SMTP id v16mr7537639ejg.298.1613039564222;
        Thu, 11 Feb 2021 02:32:44 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:43 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 23/27] kernel-shark: Update KsMainWindow and kernelshark.cpp
Date:   Thu, 11 Feb 2021 12:32:01 +0200
Message-Id: <20210211103205.418588-24-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The compilation of KsMainWindow.cpp and kernelshark.cpp is
re-enabled and all functionalities are made compatible with
the new version of the C API of libkshark (KernelShark 2.0).

This patch completes the destructive part of the transformation
and the GUI is finally fully functional again.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt   |  21 +-
 src/KsMainWindow.cpp | 786 +++++++++++++++++++++++++++++--------------
 src/KsMainWindow.hpp | 108 ++++--
 src/KsPlugins.hpp    |   5 +
 src/KsSession.cpp    |  34 ++
 src/KsSession.hpp    |   4 +
 src/kernelshark.cpp  |  49 +--
 7 files changed, 695 insertions(+), 312 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 5ea34ed..4158901 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -74,7 +74,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
                         KsWidgetsLib.hpp
                         KsTraceGraph.hpp
                         KsTraceViewer.hpp
-#                         KsMainWindow.hpp
+                        KsMainWindow.hpp
                         KsCaptureDialog.hpp
                         KsQuickContextMenu.hpp
                         KsAdvFilteringDialog.hpp)
@@ -90,7 +90,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
                                                             KsWidgetsLib.cpp
                                                             KsTraceGraph.cpp
                                                             KsTraceViewer.cpp
-#                                                             KsMainWindow.cpp
+                                                            KsMainWindow.cpp
                                                             KsCaptureDialog.cpp
                                                             KsQuickContextMenu.cpp
                                                             KsAdvFilteringDialog.cpp)
@@ -102,20 +102,19 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
 
     set_target_properties(kshark-gui PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
 
-#     message(STATUS ${KS_APP_NAME})
-#     add_executable(${KS_APP_NAME}          kernelshark.cpp)
-#     target_link_libraries(${KS_APP_NAME}   kshark-gui)
+    message(STATUS ${KS_APP_NAME})
+    add_executable(${KS_APP_NAME}          kernelshark.cpp)
+    target_link_libraries(${KS_APP_NAME}   kshark-gui)
 
     message(STATUS "kshark-record")
     add_executable(kshark-record        kshark-record.cpp)
     target_link_libraries(kshark-record kshark-gui)
 
-#     install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
-#             RUNTIME DESTINATION       ${_INSTALL_PREFIX}/bin/
-#                 COMPONENT                 kernelshark
-#             LIBRARY DESTINATION       ${_LIBDIR}
-#                 COMPONENT                 kernelshark)
-
+    install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
+            RUNTIME DESTINATION       ${_INSTALL_PREFIX}/bin/
+                COMPONENT                 kernelshark
+            LIBRARY DESTINATION       ${_LIBDIR}
+                COMPONENT                 kernelshark)
 
     install(FILES "${KS_DIR}/${KS_APP_NAME}.desktop"
             DESTINATION ${_INSTALL_PREFIX}/share/applications/
diff --git a/src/KsMainWindow.cpp b/src/KsMainWindow.cpp
index fc4e9a9..e830c5e 100644
--- a/src/KsMainWindow.cpp
+++ b/src/KsMainWindow.cpp
@@ -26,11 +26,13 @@
 
 // KernelShark
 #include "libkshark.h"
+#include "libkshark-tepdata.h"
 #include "KsCmakeDef.hpp"
 #include "KsMainWindow.hpp"
-#include "KsCaptureDialog.hpp"
 #include "KsAdvFilteringDialog.hpp"
 
+using namespace KsWidgetsLib;
+
 /** Create KernelShark Main window. */
 KsMainWindow::KsMainWindow(QWidget *parent)
 : QMainWindow(parent),
@@ -42,25 +44,25 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _plugins(this),
   _capture(this),
   _captureLocalServer(this),
-  _openAction("Open", this),
+  _openAction("Open Trace File", this),
+  _appendAction("Append Trace File", this),
   _restoreSessionAction("Restore Last Session", this),
   _importSessionAction("Import Session", this),
   _exportSessionAction("Export Session", this),
   _quitAction("Quit", this),
-  _importFilterAction("Import Filter", this),
-  _exportFilterAction("Export Filter", this),
   _graphFilterSyncCBox(nullptr),
   _listFilterSyncCBox(nullptr),
   _showEventsAction("Show events", this),
   _showTasksAction("Show tasks", this),
   _showCPUsAction("Show CPUs", this),
-  _advanceFilterAction("Advance Filtering", this),
+  _advanceFilterAction("TEP Advance Filtering", this),
   _clearAllFilters("Clear all filters", this),
   _cpuSelectAction("CPUs", this),
   _taskSelectAction("Tasks", this),
-  _managePluginsAction("Manage plugins", this),
+  _managePluginsAction("Manage Plotting plugins", this),
   _addPluginsAction("Add plugins", this),
   _captureAction("Record", this),
+  _addOffcetAction("Add Time Offset", this),
   _colorAction(this),
   _colSlider(this),
   _colorPhaseSlider(Qt::Horizontal, this),
@@ -69,12 +71,15 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _contentsAction("Contents", this),
   _bugReportAction("Report a bug", this),
   _deselectShortcut(this),
-  _settings(_getCacheDir() + "/setting.ini", QSettings::IniFormat)
+  _settings(_getCacheDir() + "/setting.ini", QSettings::IniFormat),
+  _workInProgress(this),
+  _updateSessionSize(true)
 {
 	setWindowTitle("Kernel Shark");
 	_createActions();
 	_createMenus();
 	_initCapture();
+	_plugins.registerPluginMenues();
 
 	if (geteuid() == 0)
 		_rootWarning();
@@ -82,6 +87,24 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 	_splitter.addWidget(&_graph);
 	_splitter.addWidget(&_view);
 	setCentralWidget(&_splitter);
+
+	/*
+	 * Add Status bar. First of all remove the bottom margins of the table
+	 * so that the Status bar can nicely stick to it.
+	 */
+	QMargins m = _view.layout()->contentsMargins();
+	m.setBottom(0);
+	_view.layout()->setContentsMargins(m);
+
+	/* Now create the Status bar and the "Work In Progress" Widget. */
+	QStatusBar *sb = statusBar();
+	sb->setFixedHeight(1.2 * FONT_HEIGHT);
+	_workInProgress.addToStatusBar(sb);
+
+	_graph.setWipPtr(&_workInProgress);
+	_graph.glPtr()->setWipPtr(&_workInProgress);
+	_view.setWipPtr(&_workInProgress);
+
 	connect(&_splitter,	&QSplitter::splitterMoved,
 		this,		&KsMainWindow::_splitterMoved);
 
@@ -157,6 +180,7 @@ KsMainWindow::~KsMainWindow()
 	_settings.setValue("pluginPath", _lastPluginFilePath);
 
 	_data.clear();
+	_plugins.deletePluginDialogs();
 
 	/*
 	 * Do not show error messages if the "capture" process is still
@@ -168,14 +192,32 @@ KsMainWindow::~KsMainWindow()
 		_capture.waitForFinished();
 	}
 
+	/**
+	 * The list of shapes generated by the plugins may contain objects
+	 * defined inside the plugins. Make sure to delete these objects now,
+	 * because after closing the plugins, the destructors of the
+	 * plugins-defined objects will no longer be available.
+	 */
+	_graph.glPtr()->freePluginShapes();
+
 	if (kshark_instance(&kshark_ctx))
 		kshark_free(kshark_ctx);
 }
 
 /** Set the list ot CPU cores to be plotted. */
-void KsMainWindow::setCPUPlots(QVector<int> cpus)
+void KsMainWindow::setCPUPlots(int sd, QVector<int> cpus)
 {
-	int nCPUs = tep_get_cpus(_data.tep());
+	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return;
+
+	int nCPUs = stream->n_cpus;
 	auto lamCPUCheck = [=] (int cpu) {
 		if (cpu >= nCPUs) {
 			qWarning() << "Warning: No CPU" << cpu << "found in the data.";
@@ -188,13 +230,13 @@ void KsMainWindow::setCPUPlots(QVector<int> cpus)
 	cpus.erase(std::remove_if(cpus.begin(), cpus.end(), lamCPUCheck),
 		   cpus.end());
 
-	_graph.cpuReDraw(cpus);
+	_graph.cpuReDraw(sd, cpus);
 }
 
 /** Set the list ot tasks (pids) to be plotted. */
-void KsMainWindow::setTaskPlots(QVector<int> pids)
+void KsMainWindow::setTaskPlots(int sd, QVector<int> pids)
 {
-	QVector<int> allPids = KsUtils::getPidList();
+	QVector<int> allPids = KsUtils::getPidList(sd);
 	auto lamPidCheck = [=] (int pid) {
 		int i = allPids.indexOf(pid);
 		if (i < 0) {
@@ -208,7 +250,7 @@ void KsMainWindow::setTaskPlots(QVector<int> pids)
 	pids.erase(std::remove_if(pids.begin(), pids.end(), lamPidCheck),
 		   pids.end());
 
-	_graph.taskReDraw(pids);
+	_graph.taskReDraw(sd, pids);
 }
 
 /**
@@ -219,8 +261,10 @@ void KsMainWindow::resizeEvent(QResizeEvent* event)
 {
 	QMainWindow::resizeEvent(event);
 
-	_session.saveMainWindowSize(*this);
-	_session.saveSplitterSize(_splitter);
+	if (_updateSessionSize) {
+		_session.saveMainWindowSize(*this);
+		_session.saveSplitterSize(_splitter);
+	}
 }
 
 void KsMainWindow::_createActions()
@@ -233,6 +277,13 @@ void KsMainWindow::_createActions()
 	connect(&_openAction,	&QAction::triggered,
 		this,		&KsMainWindow::_open);
 
+	_appendAction.setIcon(QIcon::fromTheme("document-open"));
+	_appendAction.setShortcut(tr("Ctrl+A"));
+	_appendAction.setStatusTip("Append an existing data file");
+
+	connect(&_appendAction,	&QAction::triggered,
+		this,		&KsMainWindow::_append);
+
 	_restoreSessionAction.setIcon(QIcon::fromTheme("document-open-recent"));
 	connect(&_restoreSessionAction,	&QAction::triggered,
 		this,			&KsMainWindow::_restoreSession);
@@ -257,18 +308,6 @@ void KsMainWindow::_createActions()
 		this,		&KsMainWindow::close);
 
 	/* Filter menu */
-	_importFilterAction.setIcon(QIcon::fromTheme("document-send"));
-	_importFilterAction.setStatusTip("Load a filter");
-
-	connect(&_importFilterAction,	&QAction::triggered,
-		this,			&KsMainWindow::_importFilter);
-
-	_exportFilterAction.setIcon(QIcon::fromTheme("document-revert"));
-	_exportFilterAction.setStatusTip("Export a filter");
-
-	connect(&_exportFilterAction,	&QAction::triggered,
-		this,			&KsMainWindow::_exportFilter);
-
 	connect(&_showEventsAction,	&QAction::triggered,
 		this,			&KsMainWindow::_showEvents);
 
@@ -312,14 +351,24 @@ void KsMainWindow::_createActions()
 	connect(&_captureAction,	&QAction::triggered,
 		this,			&KsMainWindow::_record);
 
+	connect(&_addOffcetAction,	&QAction::triggered,
+		this,			&KsMainWindow::_offset);
+
 	_colorPhaseSlider.setMinimum(20);
 	_colorPhaseSlider.setMaximum(180);
-	_colorPhaseSlider.setValue(KsPlot::Color::getRainbowFrequency() * 100);
+	_colorPhaseSlider.setValue(KsPlot::Color::rainbowFrequency() * 100);
 	_colorPhaseSlider.setFixedWidth(FONT_WIDTH * 15);
 
 	connect(&_colorPhaseSlider,	&QSlider::valueChanged,
 		this,			&KsMainWindow::_setColorPhase);
 
+	/*
+	 * Updating the colors of the table can be slow. Do this only when
+	 * the slider is released.
+	 */
+	connect(&_colorPhaseSlider,	&QSlider::sliderReleased,
+		&_view,			&KsTraceViewer::loadColors);
+
 	_colSlider.setLayout(new QHBoxLayout);
 	_colSlider.layout()->addWidget(new QLabel("Color scheme", this));
 	_colSlider.layout()->addWidget(&_colorPhaseSlider);
@@ -357,6 +406,7 @@ void KsMainWindow::_createMenus()
 	/* File menu */
 	file = menuBar()->addMenu("File");
 	file->addAction(&_openAction);
+	file->addAction(&_appendAction);
 
 	sessions = file->addMenu("Sessions");
 	sessions->setIcon(QIcon::fromTheme("document-properties"));
@@ -365,15 +415,30 @@ void KsMainWindow::_createMenus()
 	sessions->addAction(&_exportSessionAction);
 	file->addAction(&_quitAction);
 
+	/*
+	 * Enable the "Append Trace File" menu only in the case of multiple
+	 * data streams.
+	 */
+	auto lamEnableAppendAction = [this] () {
+		kshark_context *kshark_ctx(nullptr);
+
+		if (!kshark_instance(&kshark_ctx))
+			return;
+
+		if (kshark_ctx->n_streams > 0)
+			_appendAction.setEnabled(true);
+		else
+			_appendAction.setEnabled(false);
+	};
+
+	connect(file,	&QMenu::aboutToShow, lamEnableAppendAction);
+
 	/* Filter menu */
 	filter = menuBar()->addMenu("Filter");
 
 	connect(filter, 		&QMenu::aboutToShow,
 		this,			&KsMainWindow::_updateFilterMenu);
 
-	filter->addAction(&_importFilterAction);
-	filter->addAction(&_exportFilterAction);
-
 	/*
 	 * Set the default filter mask. Filter will apply to both View and
 	 * Graph.
@@ -403,6 +468,29 @@ void KsMainWindow::_createMenus()
 	filter->addAction(&_advanceFilterAction);
 	filter->addAction(&_clearAllFilters);
 
+	/*
+	 * Enable the "TEP Advance Filtering" menu only in the case when TEP
+	 * data is loaded.
+	 */
+	auto lamEnableAdvFilterAction = [this] () {
+		kshark_context *kshark_ctx(nullptr);
+		QVector<int> streamIds;
+
+		if (!kshark_instance(&kshark_ctx))
+			return;
+
+		_advanceFilterAction.setEnabled(false);
+		streamIds = KsUtils::getStreamIdList(kshark_ctx);
+		for (auto const &sd: streamIds) {
+			if (kshark_is_tep(kshark_ctx->stream[sd])) {
+				_advanceFilterAction.setEnabled(true);
+				break;
+			}
+		}
+	};
+
+	connect(filter,	&QMenu::aboutToShow, lamEnableAdvFilterAction);
+
 	/* Plot menu */
 	plots = menuBar()->addMenu("Plots");
 	plots->addAction(&_cpuSelectAction);
@@ -410,12 +498,31 @@ void KsMainWindow::_createMenus()
 
 	/* Tools menu */
 	tools = menuBar()->addMenu("Tools");
-	tools->addAction(&_managePluginsAction);
-	tools->addAction(&_addPluginsAction);
-	tools->addAction(&_captureAction);
-	tools->addSeparator();
 	tools->addAction(&_colorAction);
 	tools->addAction(&_fullScreenModeAction);
+	tools->addSeparator();
+	tools->addAction(&_captureAction);
+	tools->addAction(&_managePluginsAction);
+	tools->addAction(&_addPluginsAction);
+	tools->addAction(&_addOffcetAction);
+
+	/*
+	 * Enable the "Add Time Offset" menu only in the case of multiple
+	 * data streams.
+	 */
+	auto lamEnableOffcetAction = [this] () {
+		kshark_context *kshark_ctx(nullptr);
+
+		if (!kshark_instance(&kshark_ctx))
+			return;
+
+		if (kshark_ctx->n_streams > 1)
+			_addOffcetAction.setEnabled(true);
+		else
+			_addOffcetAction.setEnabled(false);
+	};
+
+	connect(tools,	&QMenu::aboutToShow, lamEnableOffcetAction);
 
 	/* Help menu */
 	help = menuBar()->addMenu("Help");
@@ -424,6 +531,53 @@ void KsMainWindow::_createMenus()
 	help->addAction(&_bugReportAction);
 }
 
+/**
+ * @brief Add a plugin configuration/control menu.
+ *
+ * @param place: String describing the place to add the menu. For example
+ *		 "Tools/Plot Latency".
+ * @param func: Function that will launch of plugin control menus.
+ */
+void KsMainWindow::addPluginMenu(QString place, pluginActionFunc func)
+{
+	QStringList dialogPath = place.split("/");
+	QAction *pluginAction;
+
+	auto lamAddMenu = [this, func] () {
+		func(this);
+	};
+
+	for (auto &m:  menuBar()->findChildren<QMenu*>()) {
+		if(dialogPath[0] == m->menuAction()->text()) {
+			pluginAction = new QAction(dialogPath[1], this);
+			m->addAction(pluginAction);
+
+			connect(pluginAction,	&QAction::triggered,
+				lamAddMenu);
+		}
+	}
+}
+
+/** Select the kshark_entry having given index with a given maker. */
+void KsMainWindow::markEntry(ssize_t row, DualMarkerState st)
+{
+	if (row >= 0) {
+		_mState.setState(st);
+		_graph.markEntry(row);
+		_view.showRow(row, true);
+	}
+}
+
+/** Select given kshark_entry with a given maker. */
+void KsMainWindow::markEntry(const kshark_entry *e, DualMarkerState st)
+{
+	ssize_t row = kshark_find_entry_by_time(e->ts, _data.rows(),
+						0, _data.size() - 1);
+
+	markEntry(row, st);
+}
+
+
 void KsMainWindow::_open()
 {
 	QString fileName;
@@ -436,6 +590,17 @@ void KsMainWindow::_open()
 		loadDataFile(fileName);
 }
 
+void KsMainWindow::_append()
+{
+	QString fileName = KsUtils::getFile(this,
+					    "Append File",
+					    "trace-cmd files (*.dat);;Text files (*.txt);;All files (*)",
+					    _lastDataFilePath);
+
+	if (!fileName.isEmpty())
+		appendDataFile(fileName);
+}
+
 QString KsMainWindow::_getCacheDir()
 {
 	QString dir;
@@ -524,13 +689,13 @@ void KsMainWindow::_updateSession()
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	_session.saveGraphs(*_graph.glPtr());
 	_session.saveVisModel(_graph.glPtr()->model()->histo());
-	_session.saveFilters(kshark_ctx);
+	_session.saveDataStreams(kshark_ctx);
+	_session.saveGraphs(kshark_ctx, _graph);
 	_session.saveDualMarker(&_mState);
 	_session.saveTable(_view);
 	_session.saveColorScheme();
-	_session.savePlugins(_plugins);
+	_session.saveUserPlugins(_plugins);
 }
 
 void KsMainWindow::_exportSession()
@@ -570,57 +735,6 @@ void KsMainWindow::_updateFilterMenu()
 		_filterSyncCBoxUpdate(kshark_ctx);
 }
 
-void KsMainWindow::_importFilter()
-{
-	kshark_context *kshark_ctx(nullptr);
-	kshark_config_doc *conf;
-	QString fileName;
-
-	if (!kshark_instance(&kshark_ctx) || _data.size() < 1)
-		return;
-
-	fileName = KsUtils::getFile(this, "Import Filter",
-				    "Kernel Shark Config files (*.json);;",
-				    _lastConfFilePath);
-
-	if (fileName.isEmpty())
-		return;
-
-	conf = kshark_open_config_file(fileName.toStdString().c_str(),
-				       "kshark.config.filter");
-	if (!conf)
-		return;
-
-	kshark_import_all_event_filters(kshark_ctx, conf);
-	kshark_free_config_doc(conf);
-
-	kshark_filter_entries(kshark_ctx, _data.rows(), _data.size());
-	_filterSyncCBoxUpdate(kshark_ctx);
-	emit _data.updateWidgets(&_data);
-}
-
-void KsMainWindow::_exportFilter()
-{
-	kshark_context *kshark_ctx(nullptr);
-	kshark_config_doc *conf(nullptr);
-	QString fileName;
-
-	if (!kshark_instance(&kshark_ctx))
-		return;
-
-	fileName = KsUtils::getSaveFile(this, "Export Filter",
-					"Kernel Shark Config files (*.json);;",
-					".json",
-					_lastConfFilePath);
-
-	if (fileName.isEmpty())
-		return;
-
-	kshark_export_all_event_filters(kshark_ctx, &conf);
-	kshark_save_config_file(fileName.toStdString().c_str(), conf);
-	kshark_free_config_doc(conf);
-}
-
 void KsMainWindow::_listFilterSync(int state)
 {
 	KsUtils::listFilterSync(state);
@@ -633,8 +747,8 @@ void KsMainWindow::_graphFilterSync(int state)
 	_data.update();
 }
 
-void KsMainWindow::_presetCBWidget(tracecmd_filter_id *showFilter,
-				   tracecmd_filter_id *hideFilter,
+void KsMainWindow::_presetCBWidget(kshark_hash_id *showFilter,
+				   kshark_hash_id *hideFilter,
 				   KsCheckBoxWidget *cbw)
 {
 	if (!kshark_this_filter_is_set(showFilter) &&
@@ -646,7 +760,7 @@ void KsMainWindow::_presetCBWidget(tracecmd_filter_id *showFilter,
 		cbw->setDefault(true);
 	} else {
 		QVector<int> ids = cbw->getIds();
-		QVector<bool>  status;
+		QVector<int>  status;
 		int n = ids.count();
 		bool show, hide;
 
@@ -655,12 +769,12 @@ void KsMainWindow::_presetCBWidget(tracecmd_filter_id *showFilter,
 			 * The "show only" filter is set. The default status
 			 * of all CheckBoxes will be "unchecked".
 			 */
-			status = QVector<bool>(n, false);
+			status = QVector<int>(n, false);
 			for (int i = 0; i < n; ++i) {
-				show = !!tracecmd_filter_id_find(showFilter,
+				show = !!kshark_hash_id_find(showFilter,
 							         ids[i]);
 
-				hide = !!tracecmd_filter_id_find(hideFilter,
+				hide = !!kshark_hash_id_find(hideFilter,
 							         ids[i]);
 
 				if (show && !hide) {
@@ -677,9 +791,9 @@ void KsMainWindow::_presetCBWidget(tracecmd_filter_id *showFilter,
 			 * Only the "do not show" filter is set. The default
 			 * status of all CheckBoxes will be "checked".
 			 */
-			status = QVector<bool>(n, true);
+			status = QVector<int>(n, true);
 			for (int i = 0; i < n; ++i) {
-				hide = !!tracecmd_filter_id_find(hideFilter,
+				hide = !!kshark_hash_id_find(hideFilter,
 							         ids[i]);
 
 				if (hide)
@@ -691,12 +805,12 @@ void KsMainWindow::_presetCBWidget(tracecmd_filter_id *showFilter,
 	}
 }
 
-void KsMainWindow::_applyFilter(QVector<int> all, QVector<int> show,
-				std::function<void(QVector<int>)> posFilter,
-				std::function<void(QVector<int>)> negFilter)
+void KsMainWindow::_applyFilter(int sd, QVector<int> all, QVector<int> show,
+				std::function<void(int, QVector<int>)> posFilter,
+				std::function<void(int, QVector<int>)> negFilter)
 {
-	if (show.count() < all.count() / 2) {
-		posFilter(show);
+	if (show.count() != 0 && show.count() < all.count() / 2) {
+		posFilter(sd, show);
 	} else {
 		/*
 		 * It is more efficiant to apply negative (do not show) filter.
@@ -719,38 +833,46 @@ void KsMainWindow::_applyFilter(QVector<int> all, QVector<int> show,
 				    show.begin(), show.end(),
 				    std::inserter(diff, diff.begin()));
 
-		negFilter(diff);
+		negFilter(sd, diff);
 	}
 }
 
 /* Quiet warnings over documenting simple structures */
 //! @cond Doxygen_Suppress
 
-#define LAMDA_FILTER(method) [=] (QVector<int> vec) {method(vec);}
+#define LAMBDA_FILTER(method) [=] (int sd, QVector<int> vec) {method(sd, vec);}
 
 //! @endcond
 
 void KsMainWindow::_showEvents()
 {
 	kshark_context *kshark_ctx(nullptr);
-	KsCheckBoxWidget *events_cb;
+	QVector<KsCheckBoxWidget *> cbws;
+	KsCheckBoxWidget *events_cbw;
 	KsCheckBoxDialog *dialog;
-	QVector<bool> v;
+	kshark_data_stream *stream;
+	QVector<int> streamIds;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	events_cb = new KsEventsCheckBoxWidget(_data.tep(), this);
-	dialog = new KsCheckBoxDialog(events_cb, this);
-	_presetCBWidget(kshark_ctx->show_event_filter,
-		        kshark_ctx->hide_event_filter,
-		        events_cb);
-
-	auto lamFilter = [=] (QVector<int> show) {
-		QVector<int> all = KsUtils::getEventIdList();
-		_applyFilter(all, show,
-			     LAMDA_FILTER(_data.applyPosEventFilter),
-			     LAMDA_FILTER(_data.applyNegEventFilter));
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	for (auto const &sd: streamIds) {
+		stream = kshark_ctx->stream[sd];
+		events_cbw = new KsEventsCheckBoxWidget(stream, this);
+		cbws.append(events_cbw);
+		_presetCBWidget(stream->show_event_filter,
+				stream->hide_event_filter,
+				events_cbw);
+	}
+
+	dialog = new KsCheckBoxDialog(cbws, this);
+
+	auto lamFilter = [=] (int sd, QVector<int> show) {
+		QVector<int> all = KsUtils::getEventIdList(sd);
+		_applyFilter(sd, all, show,
+			     LAMBDA_FILTER(_data.applyPosEventFilter),
+			     LAMBDA_FILTER(_data.applyNegEventFilter));
 	};
 
 	connect(dialog,		&KsCheckBoxDialog::apply, lamFilter);
@@ -761,24 +883,32 @@ void KsMainWindow::_showEvents()
 void KsMainWindow::_showTasks()
 {
 	kshark_context *kshark_ctx(nullptr);
-	KsCheckBoxWidget *tasks_cbd;
+	QVector<KsCheckBoxWidget *> cbws;
+	kshark_data_stream *stream;
+	KsCheckBoxWidget *tasks_cbw;
 	KsCheckBoxDialog *dialog;
-	QVector<bool> v;
+	QVector<int> streamIds;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	tasks_cbd = new KsTasksCheckBoxWidget(_data.tep(), true, this);
-	dialog = new KsCheckBoxDialog(tasks_cbd, this);
-	_presetCBWidget(kshark_ctx->show_task_filter,
-			kshark_ctx->hide_task_filter,
-			tasks_cbd);
-
-	auto lamFilter = [=] (QVector<int> show) {
-		QVector<int> all = KsUtils::getEventIdList();
-		_applyFilter(all, show,
-			     LAMDA_FILTER(_data.applyPosTaskFilter),
-			     LAMDA_FILTER(_data.applyNegTaskFilter));
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	for (auto const &sd: streamIds) {
+		stream = kshark_ctx->stream[sd];
+		tasks_cbw = new KsTasksCheckBoxWidget(stream, true, this);
+		cbws.append(tasks_cbw);
+		_presetCBWidget(stream->show_task_filter,
+				stream->hide_task_filter,
+				tasks_cbw);
+	}
+
+	dialog = new KsCheckBoxDialog(cbws, this);
+
+	auto lamFilter = [=] (int sd, QVector<int> show) {
+		QVector<int> all = KsUtils::getPidList(sd);
+		_applyFilter(sd, all, show,
+			     LAMBDA_FILTER(_data.applyPosTaskFilter),
+			     LAMBDA_FILTER(_data.applyNegTaskFilter));
 	};
 
 	connect(dialog,		&KsCheckBoxDialog::apply, lamFilter);
@@ -789,24 +919,32 @@ void KsMainWindow::_showTasks()
 void KsMainWindow::_showCPUs()
 {
 	kshark_context *kshark_ctx(nullptr);
-	KsCheckBoxWidget *cpu_cbd;
+	QVector<KsCheckBoxWidget *> cbws;
+	kshark_data_stream *stream;
+	KsCheckBoxWidget *cpus_cbw;
 	KsCheckBoxDialog *dialog;
-	QVector<bool> v;
+	QVector<int> streamIds;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
-	cpu_cbd = new KsCPUCheckBoxWidget(_data.tep(), this);
-	dialog = new KsCheckBoxDialog(cpu_cbd, this);
-	_presetCBWidget(kshark_ctx->show_cpu_filter,
-			kshark_ctx->hide_cpu_filter,
-			cpu_cbd);
-
-	auto lamFilter = [=] (QVector<int> show) {
-		QVector<int> all = KsUtils::getEventIdList();
-		_applyFilter(all, show,
-			     LAMDA_FILTER(_data.applyPosCPUFilter),
-			     LAMDA_FILTER(_data.applyNegCPUFilter));
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	for (auto const &sd: streamIds) {
+		stream = kshark_ctx->stream[sd];
+		cpus_cbw = new KsCPUCheckBoxWidget(stream, this);
+		cbws.append(cpus_cbw);
+		_presetCBWidget(stream->show_task_filter,
+				stream->hide_task_filter,
+				cpus_cbw);
+	}
+
+	dialog = new KsCheckBoxDialog(cbws, this);
+
+	auto lamFilter = [=] (int sd, QVector<int> show) {
+		QVector<int> all = KsUtils::getCPUList(sd);
+		_applyFilter(sd, all, show,
+			     LAMBDA_FILTER(_data.applyPosCPUFilter),
+			     LAMBDA_FILTER(_data.applyNegCPUFilter));
 	};
 
 	connect(dialog,		&KsCheckBoxDialog::apply, lamFilter);
@@ -818,18 +956,6 @@ void KsMainWindow::_advancedFiltering()
 {
 	KsAdvFilteringDialog *dialog;
 
-	if (!_data.tep()) {
-		QErrorMessage *em = new QErrorMessage(this);
-		QString text("Unable to open Advanced filtering dialog.");
-
-		text += " Tracing data has to be loaded first.";
-
-		em->showMessage(text, "advancedFiltering");
-		qCritical() << "ERROR: " << text;
-
-		return;
-	}
-
 	dialog = new KsAdvFilteringDialog(this);
 	connect(dialog,		&KsAdvFilteringDialog::dataReload,
 		&_data,		&KsDataStore::reload);
@@ -844,23 +970,37 @@ void KsMainWindow::_clearFilters()
 
 void KsMainWindow::_cpuSelect()
 {
-	KsCheckBoxWidget *cpus_cbd = new KsCPUCheckBoxWidget(_data.tep(), this);
-	KsCheckBoxDialog *dialog = new KsCheckBoxDialog(cpus_cbd, this);
+	kshark_context *kshark_ctx(nullptr);
+	QVector<KsCheckBoxWidget *> cbws;
+	kshark_data_stream *stream;
+	KsCheckBoxWidget *cpus_cbd;
+	KsCheckBoxDialog *dialog;
+	QVector<int> streamIds;
+	int nCPUs;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
 
-	if(_data.tep()) {
-		int nCPUs = tep_get_cpus(_data.tep());
-		if (nCPUs == _graph.glPtr()->cpuGraphCount()) {
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	for (auto const &sd: streamIds) {
+		stream = kshark_ctx->stream[sd];
+		cpus_cbd = new KsCPUCheckBoxWidget(stream, this);
+		cbws.append(cpus_cbd);
+
+		nCPUs = stream->n_cpus;
+		if (nCPUs == _graph.glPtr()->cpuGraphCount(sd)) {
 			cpus_cbd->setDefault(true);
 		} else {
-			QVector<bool> v(nCPUs, false);
-
-			for (auto const &cpu: _graph.glPtr()->_cpuList)
+			QVector<int> v(nCPUs, false);
+			for (auto const &cpu: _graph.glPtr()->_streamPlots[sd]._cpuList)
 				v[cpu] = true;
 
 			cpus_cbd->set(v);
 		}
 	}
 
+	dialog = new KsCheckBoxDialog(cbws, this);
+
 	connect(dialog,		&KsCheckBoxDialog::apply,
 		&_graph,	&KsTraceGraph::cpuReDraw);
 
@@ -869,29 +1009,46 @@ void KsMainWindow::_cpuSelect()
 
 void KsMainWindow::_taskSelect()
 {
-	KsCheckBoxWidget *tasks_cbd = new KsTasksCheckBoxWidget(_data.tep(),
-								true,
-								this);
-	KsCheckBoxDialog *dialog = new KsCheckBoxDialog(tasks_cbd, this);
-	QVector<int> pids = KsUtils::getPidList();
-	int nPids = pids.count();
-
-	if (nPids == _graph.glPtr()->taskGraphCount()) {
-		tasks_cbd->setDefault(true);
-	} else {
-		QVector<bool> v(nPids, false);
-		for (int i = 0; i < nPids; ++i) {
-			for (auto const &pid: _graph.glPtr()->_taskList) {
-				if (pids[i] == pid) {
-					v[i] = true;
-					break;
+	kshark_context *kshark_ctx(nullptr);
+	QVector<KsCheckBoxWidget *> cbws;
+	QVector<int> streamIds, pids;
+	kshark_data_stream *stream;
+	KsCheckBoxWidget *tasks_cbd;
+	KsCheckBoxDialog *dialog;
+	int nPids;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	for (auto const &sd: streamIds) {
+		stream = kshark_ctx->stream[sd];
+		tasks_cbd = new KsTasksCheckBoxWidget(stream, true, this);
+		cbws.append(tasks_cbd);
+
+		pids = KsUtils::getPidList(sd);
+		nPids = pids.count();
+		if (nPids == _graph.glPtr()->taskGraphCount(sd)) {
+			tasks_cbd->setDefault(true);
+		} else {
+			QVector<int> v(nPids, false);
+			for (int i = 0; i < nPids; ++i) {
+				QVector<int> plots =
+					_graph.glPtr()->_streamPlots[sd]._taskList;
+				for (auto const &pid: plots) {
+					if (pids[i] == pid) {
+						v[i] = true;
+						break;
+					}
 				}
 			}
-		}
 
-		tasks_cbd->set(v);
+			tasks_cbd->set(v);
+		}
 	}
 
+	dialog = new KsCheckBoxDialog(cbws, this);
+
 	connect(dialog,		&KsCheckBoxDialog::apply,
 		&_graph,	&KsTraceGraph::taskReDraw);
 
@@ -900,37 +1057,106 @@ void KsMainWindow::_taskSelect()
 
 void KsMainWindow::_pluginSelect()
 {
-	KsCheckBoxWidget *plugin_cbd;
+	QVector<int> streamIds, enabledPlugins, failedPlugins;
+	kshark_context *kshark_ctx(nullptr);
+	QVector<KsCheckBoxWidget *> cbws;
+	KsPluginCheckBoxWidget *plugin_cbw;
 	KsCheckBoxDialog *dialog;
-	QVector<bool> registeredPlugins;
-	QStringList plugins;
+	QStringList pluginList;
 
-	plugins << _plugins._ksPluginList << _plugins._userPluginList;
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	if (kshark_ctx->n_streams == 0) {
+		QString err("Data has to be loaded first.");
+		QMessageBox msgBox;
+		msgBox.critical(nullptr, "Error", err);
+
+		return;
+	}
+
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	for (auto const &sd: streamIds) {
+		pluginList = _plugins.getStreamPluginList(sd);
+		enabledPlugins = _plugins.getActivePlugins(sd);
+		failedPlugins =
+			_plugins.getPluginsByStatus(sd, KSHARK_PLUGIN_FAILED);
 
-	registeredPlugins << _plugins._registeredKsPlugins
-			  << _plugins._registeredUserPlugins;
+		plugin_cbw = new KsPluginCheckBoxWidget(sd, pluginList, this);
+		plugin_cbw->set(enabledPlugins);
+		plugin_cbw->setActive(failedPlugins, false);
 
-	plugin_cbd = new KsPluginCheckBoxWidget(plugins, this);
-	plugin_cbd->set(registeredPlugins);
+		cbws.append(plugin_cbw);
+	}
 
-	dialog = new KsCheckBoxDialog(plugin_cbd, this);
+	dialog = new KsPluginsCheckBoxDialog(cbws, &_data, this);
+	dialog->applyStatus();
 
 	connect(dialog,		&KsCheckBoxDialog::apply,
-		&_plugins,	&KsPluginManager::updatePlugins);
+		this,		&KsMainWindow::_pluginUpdate);
 
 	dialog->show();
+
+	_graph.update(&_data);
+}
+
+void KsMainWindow::_pluginUpdate(int sd, QVector<int> pluginStates)
+{
+	kshark_context *kshark_ctx(nullptr);
+	QVector<int> streamIds;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	_plugins.updatePlugins(sd, pluginStates);
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	if (streamIds.size() && streamIds.last() == sd) {
+		/* This is the last stream. Reload the data. */
+		if (_data.size())
+			_data.reload();
+	}
 }
 
 void KsMainWindow::_pluginAdd()
 {
+	kshark_context *kshark_ctx(nullptr);
 	QStringList fileNames;
+	QVector<int> streams;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	fileNames = KsUtils::getFiles(this,
+				      "Add KernelShark plugins",
+				      "KernelShark Plugins (*.so);;",
+				      _lastPluginFilePath);
+
+	if (!fileNames.isEmpty()) {
+		if (kshark_ctx->n_streams > 1) {
+			KsDStreamCheckBoxWidget *stream_cbw;
+			QVector<KsCheckBoxWidget *> cbws;
+			KsCheckBoxDialog *dialog;
+
+			stream_cbw = new KsDStreamCheckBoxWidget();
+			cbws.append(stream_cbw);
+			dialog = new KsCheckBoxDialog(cbws, this);
 
-	fileNames = KsUtils::getFiles(this, "Add KernelShark plugins",
-				     "KernelShark Plugins (*.so);;",
-				     _lastPluginFilePath);
+			auto lamStreams = [&streams] (int, QVector<int> s) {
+				streams = s;
+			};
 
-	if (!fileNames.isEmpty())
-		_plugins.addPlugins(fileNames);
+			connect(dialog, &KsCheckBoxDialog::apply, lamStreams);
+			dialog->exec();
+		}
+
+		_graph.startOfWork(KsDataWork::UpdatePlugins);
+
+		_plugins.addPlugins(fileNames, streams);
+		if (_data.size())
+			_data.reload();
+
+		_graph.endOfWork(KsDataWork::UpdatePlugins);
+	}
 }
 
 void KsMainWindow::_record()
@@ -950,13 +1176,25 @@ void KsMainWindow::_record()
 		message += " ./cmake_clean.sh <br> cmake .. <br> make <br>";
 		message += " sudo make install";
 
-		_error(message, "recordCantStart", false, false);
+		_error(message, "recordCantStart", false);
 		return;
 	}
 
 	_capture.start();
 }
 
+void KsMainWindow::_offset()
+{
+	KsTimeOffsetDialog *dialog = new KsTimeOffsetDialog(this);
+
+	auto lamApplyOffset = [&] (int sd, double ms) {
+		_data.setClockOffset(sd, ms * 1000);
+		_graph.update(&_data);
+	};
+
+	connect(dialog, &KsTimeOffsetDialog::apply, lamApplyOffset);
+}
+
 void KsMainWindow::_setColorPhase(int f)
 {
 	KsPlot::Color::setRainbowFrequency(f / 100.);
@@ -1005,14 +1243,13 @@ void KsMainWindow::_bugReport()
 	QDesktopServices::openUrl(bugs);
 }
 
-/** Load trace data for file. */
-void KsMainWindow::loadDataFile(const QString& fileName)
+void KsMainWindow::_load(const QString& fileName, bool append)
 {
-	char buff[FILENAME_MAX];
 	QString pbLabel("Loading    ");
 	bool loadDone = false;
 	struct stat st;
-	int ret;
+	double shift;
+	int ret, sd;
 
 	ret = stat(fileName.toStdString().c_str(), &st);
 	if (ret != 0) {
@@ -1020,16 +1257,21 @@ void KsMainWindow::loadDataFile(const QString& fileName)
 
 		text.append(fileName);
 		text.append(".");
-		_error(text, "loadDataErr1", true, true);
+		_error(text, "loadDataErr1", true);
 
 		return;
 	}
 
 	qInfo() << "Loading " << fileName;
 
-	_mState.reset();
-	_view.reset();
-	_graph.reset();
+	if (append) {
+		bool ok;
+		shift = KsTimeOffsetDialog::getValueNanoSec(fileName, &ok);
+		if (ok)
+			shift *= 1000.;
+		else
+			shift = 0.;
+	}
 
 	if (fileName.size() < 40) {
 		pbLabel += fileName;
@@ -1039,14 +1281,34 @@ void KsMainWindow::loadDataFile(const QString& fileName)
 	}
 
 	setWindowTitle("Kernel Shark");
-	KsProgressBar pb(pbLabel);
+	KsWidgetsLib::KsProgressBar pb(pbLabel);
 	QApplication::processEvents();
 
-	auto lamLoadJob = [&](KsDataStore *d) {
-		d->loadDataFile(fileName);
+	_view.reset();
+	_graph.reset();
+
+	auto lamLoadJob = [&, this] () {
+		QVector<kshark_dpi *> v;
+		for (auto const p: _plugins.getUserPlugins()) {
+			if (p->process_interface)
+				v.append(p->process_interface);
+		}
+
+		sd = _data.loadDataFile(fileName, v);
 		loadDone = true;
 	};
-	std::thread tload(lamLoadJob, &_data);
+
+	auto lamAppendJob = [&, this] () {
+		sd = _data.appendDataFile(fileName, shift);
+		loadDone = true;
+	};
+
+	std::thread job;
+	if (append) {
+		job = std::thread(lamAppendJob);
+	} else {
+		job = std::thread(lamLoadJob);
+	}
 
 	for (int i = 0; i < 160; ++i) {
 		/*
@@ -1060,33 +1322,40 @@ void KsMainWindow::loadDataFile(const QString& fileName)
 		usleep(150000);
 	}
 
-	tload.join();
+	job.join();
 
-	if (_data.size() < 1) {
-		QString text("No data was loaded from file ");
+	if (sd < 0 || !_data.size()) {
+		QString text("File ");
 
-		text.append(fileName + ".");
-		_error(text, "loadDataErr2", true, true);
-
-		return;
+		text.append(fileName);
+		text.append(" contains no data.");
+		_error(text, "loadDataErr2", true);
 	}
 
-	pb.setValue(165);
 	_view.loadData(&_data);
+	pb.setValue(175);
 
-	pb.setValue(180);
 	_graph.loadData(&_data);
 	pb.setValue(195);
+}
+
+/** Load trace data for file. */
+void KsMainWindow::loadDataFile(const QString& fileName)
+{
+	_mState.reset();
+	_load(fileName, false);
 	setWindowTitle("Kernel Shark (" + fileName + ")");
+}
 
-	if (realpath(fileName.toStdString().c_str(), buff)) {
-		QString path(buff);
-		_session.saveDataFile(path);
-	}
+/** Append trace data for file. */
+void KsMainWindow::appendDataFile(const QString& fileName)
+{
+	_load(fileName, true);
 }
 
-void KsMainWindow::_error(const QString &mesg, const QString &errCode,
-			  bool resize, bool unloadPlugins)
+void KsMainWindow::_error(const QString &mesg,
+			  const QString &errCode,
+			  bool resize)
 {
 	QErrorMessage *em = new QErrorMessage(this);
 	QString text = mesg;
@@ -1095,13 +1364,10 @@ void KsMainWindow::_error(const QString &mesg, const QString &errCode,
 	if (resize)
 		_resizeEmpty();
 
-	if (unloadPlugins)
-		_plugins.unloadAll();
-
 	text.replace("<br>", "\n", Qt::CaseInsensitive);
 	html.replace("\n", "<br>", Qt::CaseInsensitive);
 
-	qCritical().noquote() << "ERROR: " << text;
+	qCritical().noquote() << "ERROR:" << text;
 	em->showMessage(html, errCode);
 	em->exec();
 }
@@ -1114,6 +1380,7 @@ void KsMainWindow::_error(const QString &mesg, const QString &errCode,
 void KsMainWindow::loadSession(const QString &fileName)
 {
 	kshark_context *kshark_ctx(nullptr);
+	bool loadDone = false;
 	struct stat st;
 	int ret;
 
@@ -1126,59 +1393,70 @@ void KsMainWindow::loadSession(const QString &fileName)
 
 		text.append(fileName);
 		text.append("\n");
-		_error(text, "loadSessErr0", true, true);
+		_error(text, "loadSessErr0", true);
 
 		return;
 	}
 
+	KsWidgetsLib::KsProgressBar pb("Loading session settings ...");
+	pb.setValue(10);
+
+	_updateSessionSize = false;
 	if (!_session.importFromFile(fileName)) {
 		QString text("Unable to open session description file ");
 
 		text.append(fileName);
 		text.append(".\n");
-		_error(text, "loadSessErr1", true, true);
+		_error(text, "loadSessErr1", true);
 
 		return;
 	}
 
-	_session.loadPlugins(kshark_ctx, &_plugins);
+	_view.reset();
+	_graph.reset();
+	_data.clear();
 
-	QString dataFile(_session.getDataFile(kshark_ctx));
-	if (dataFile.isEmpty()) {
-		QString text("Unable to open trace data file for session ");
+	_session.loadUserPlugins(kshark_ctx, &_plugins);
+	pb.setValue(20);
 
-		text.append(fileName);
-		text.append("\n");
-		_error(text, "loadSessErr1", true, true);
+	auto lamLoadJob = [&] (KsDataStore *d) {
+		_session.loadDataStreams(kshark_ctx, &_data);
+		loadDone = true;
+	};
 
-		return;
-	}
+	std::thread job = std::thread(lamLoadJob, &_data);
 
-	loadDataFile(dataFile);
-	if (!_data.tep()) {
-		_plugins.unloadAll();
-		return;
+	for (int i = 0; i < 150; ++i) {
+		/*
+		 * TODO: The way this progress bar gets updated here is a pure
+		 * cheat. See if this can be implemented better.
+		*/
+		if (loadDone)
+			break;
+
+		pb.setValue(i);
+		usleep(300000);
 	}
 
-	KsProgressBar pb("Loading session settings ...");
-	pb.setValue(10);
+	job.join();
 
-	_session.loadGraphs(&_graph);
-	pb.setValue(20);
+	_view.loadData(&_data);
+	pb.setValue(155);
 
-	_session.loadFilters(kshark_ctx, &_data);
+	_graph.loadData(&_data);
 	_filterSyncCBoxUpdate(kshark_ctx);
-	pb.setValue(130);
+	pb.setValue(175);
 
 	_session.loadSplitterSize(&_splitter);
 	_session.loadMainWindowSize(this);
-	this->show();
-	pb.setValue(140);
+	_updateSessionSize = true;
+	pb.setValue(180);
 
 	_session.loadDualMarker(&_mState, &_graph);
 	_session.loadVisModel(_graph.glPtr()->model());
 	_mState.updateMarkers(_data, _graph.glPtr());
-	pb.setValue(170);
+	_session.loadGraphs(kshark_ctx, _graph);
+	pb.setValue(190);
 
 	_session.loadTable(&_view);
 	_colorPhaseSlider.setValue(_session.getColorScheme() * 100);
@@ -1268,7 +1546,7 @@ void KsMainWindow::_captureErrorMessage(QProcess *capture)
 	message += capture->errorString();
 	message += "<br>Standard Error: ";
 	message += capture->readAllStandardError();
-	_error(message, "captureFinishedErr", false, false);
+	_error(message, "captureFinishedErr", false);
 }
 
 void KsMainWindow::_readSocket()
@@ -1280,7 +1558,7 @@ void KsMainWindow::_readSocket()
 	auto lamSocketError = [&](QString message)
 	{
 		message = "ERROR from Local Server: " + message;
-		_error(message, "readSocketErr", false, false);
+		_error(message, "readSocketErr", false);
 	};
 
 	socket = _captureLocalServer.nextPendingConnection();
diff --git a/src/KsMainWindow.hpp b/src/KsMainWindow.hpp
index 2fac107..952a2ad 100644
--- a/src/KsMainWindow.hpp
+++ b/src/KsMainWindow.hpp
@@ -20,6 +20,7 @@
 #include "KsTraceViewer.hpp"
 #include "KsTraceGraph.hpp"
 #include "KsWidgetsLib.hpp"
+#include "KsPlugins.hpp"
 #include "KsSession.hpp"
 #include "KsUtils.hpp"
 
@@ -36,35 +37,61 @@ public:
 
 	void loadDataFile(const QString &fileName);
 
+	void appendDataFile(const QString &fileName);
+
 	void loadSession(const QString &fileName);
 
 	QString lastSessionFile();
 
 	/**
-	 * @brief
+	 * @brief Register a list of plugins.
+	 *
+	 * @param plugins: Provide here the names of the plugin (as in the
+ *			   CMake-generated header file) or the names of the
+ *			   plugin's library files (.so including path).
+ * 			   The names must be comma separated.
+	 */
+	void registerPlugins(const QString &plugins)
+	{
+		_plugins.registerPlugins(plugins);
+	}
+
+	/**
+	 * @brief Unregister a list pf plugins.
+	 *
+	 * @param pluginNames: Provide here a comma separated list of plugin
+	 *		       names (as in the CMake-generated header file).
+	 */
+	void unregisterPlugins(const QString &pluginNames)
+	{
+		_plugins.unregisterPlugins(pluginNames);
+	}
+
+	/**
+	 * @brief Register a given plugin to given Data streams.
 	 *
-	 * @param plugin: can be the name of the plugin or the plugin's library
-	 * file (including absolute or relative path).
+	 * @param pluginName: The name of the plugin to register.
+	 * @param streamIds: Vector of Data stream identifiers.
 	 */
-	void registerPlugin(const QString &plugin)
+	void registerPluginToStream(const QString &pluginName, QVector<int> streamIds)
 	{
-		_plugins.registerPlugin(plugin);
+		_plugins.registerPluginToStream(pluginName, streamIds);
 	}
 
 	/**
-	 * @brief
+	 * @brief Unregister a given plugin from given Data streams.
 	 *
-	 * @param plugin: can be the name of the plugin or the plugin's library
-	 * file (including absolute path).
+	 * @param pluginName: The name of the plugin to unregister.
+	 * @param streamIds: Vector of Data stream identifiers.
 	 */
-	void unregisterPlugin(const QString &plugin)
+	void unregisterPluginFromStream(const QString &pluginName, QVector<int> streamIds)
 	{
-		_plugins.unregisterPlugin(plugin);
+		_plugins.unregisterPluginFromStream(pluginName, streamIds);
 	}
 
-	void setCPUPlots(QVector<int> cpus);
+	void setCPUPlots(int sd, QVector<int> cpus);
 
-	void setTaskPlots(QVector<int> pids);
+	void setTaskPlots(int sd, QVector<int> pids);
 
 	void resizeEvent(QResizeEvent* event);
 
@@ -74,6 +101,21 @@ public:
 			_changeScreenMode();
 	}
 
+	void addPluginMenu(QString place, pluginActionFunc action);
+
+	/** Get the KsTraceGraph object. */
+	KsTraceGraph *graphPtr() {return &_graph;}
+
+	/** Get the KsTraceViewer object. */
+	KsTraceViewer *viewPtr() {return &_view;}
+
+	/** Get the KsWorkInProgress object. */
+	KsWidgetsLib::KsWorkInProgress *wipPtr() {return &_workInProgress;}
+
+	void markEntry(ssize_t row, DualMarkerState st);
+
+	void markEntry(const kshark_entry *e, DualMarkerState st);
+
 private:
 	QSplitter	_splitter;
 
@@ -104,6 +146,8 @@ private:
 	// File menu.
 	QAction		_openAction;
 
+	QAction		_appendAction;
+
 	QAction		_restoreSessionAction;
 
 	QAction		_importSessionAction;
@@ -113,10 +157,6 @@ private:
 	QAction		_quitAction;
 
 	// Filter menu.
-	QAction		_importFilterAction;
-
-	QAction		_exportFilterAction;
-
 	QCheckBox	*_graphFilterSyncCBox;
 
 	QCheckBox	*_listFilterSyncCBox;
@@ -143,6 +183,8 @@ private:
 
 	QAction		_captureAction;
 
+	QAction		_addOffcetAction;
+
 	QWidgetAction	_colorAction;
 
 	QWidget		_colSlider;
@@ -166,29 +208,34 @@ private:
 
 	QMetaObject::Connection		_captureErrorConnection;
 
+	// Status bar.
+	KsWidgetsLib::KsWorkInProgress	_workInProgress;
+
+	bool	_updateSessionSize;
+
+	void _load(const QString& fileName, bool append);
+
 	void _open();
 
+	void _append();
+
 	void _restoreSession();
 
 	void _importSession();
 
 	void _exportSession();
 
-	void _importFilter();
-
-	void _exportFilter();
-
 	void _listFilterSync(int state);
 
 	void _graphFilterSync(int state);
 
-	void _presetCBWidget(tracecmd_filter_id *showFilter,
-			     tracecmd_filter_id *hideFilter,
-			     KsCheckBoxWidget *cbw);
+	void _presetCBWidget(kshark_hash_id *showFilter,
+			     kshark_hash_id *hideFilter,
+			     KsWidgetsLib::KsCheckBoxWidget *cbw);
 
-	void _applyFilter(QVector<int> all, QVector<int> show,
-			  std::function<void(QVector<int>)> posFilter,
-			  std::function<void(QVector<int>)> negFilter);
+	void _applyFilter(int sd, QVector<int> all, QVector<int> show,
+			  std::function<void(int, QVector<int>)> posFilter,
+			  std::function<void(int, QVector<int>)> negFilter);
 
 	void _showEvents();
 
@@ -206,10 +253,14 @@ private:
 
 	void _pluginSelect();
 
+	void _pluginUpdate(int sd, QVector<int> pluginStates);
+
 	void _pluginAdd();
 
 	void _record();
 
+	void _offset();
+
 	void _setColorPhase(int);
 
 	void _changeScreenMode();
@@ -240,8 +291,9 @@ private:
 
 	inline void _resizeEmpty() {resize(SCREEN_WIDTH * .5, FONT_HEIGHT * 3);}
 
-	void _error(const QString &text, const QString &errCode,
-		    bool resize, bool unloadPlugins);
+	void _error(const QString &text,
+		    const QString &errCode,
+		    bool resize);
 
 	void _deselectActive();
 
diff --git a/src/KsPlugins.hpp b/src/KsPlugins.hpp
index a19bb9d..d41d094 100644
--- a/src/KsPlugins.hpp
+++ b/src/KsPlugins.hpp
@@ -16,9 +16,14 @@
 #include <functional>
 
 // KernelShark
+#include "libkshark-plugin.h"
 #include "libkshark-model.h"
 #include "KsPlotTools.hpp"
 
+class KsMainWindow;
+/** Function type used for launching of plugin control menus. */
+typedef void (pluginActionFunc) (KsMainWindow *);
+
 /**
  * Structure representing the vector of C++ arguments of the drawing function
  * of a plugin.
diff --git a/src/KsSession.cpp b/src/KsSession.cpp
index 786aa3e..8d489f7 100644
--- a/src/KsSession.cpp
+++ b/src/KsSession.cpp
@@ -13,6 +13,7 @@
 #include "libkshark.h"
 #include "libkshark-tepdata.h"
 #include "KsSession.hpp"
+#include "KsMainWindow.hpp"
 
 /** Create a KsSession object. */
 KsSession::KsSession()
@@ -193,6 +194,39 @@ void KsSession::saveMainWindowSize(const QMainWindow &window)
 	kshark_config_doc_add(_config, "MainWindow", windowConf);
 }
 
+/**
+ * @brief Load the KernelShark Main window size.
+ *
+ * @param window: Input location for the KsMainWindow widget.
+ */
+void KsSession::loadMainWindowSize(KsMainWindow *window)
+{
+	kshark_config_doc *windowConf = kshark_config_alloc(KS_CONFIG_JSON);
+	json_object *jwindow, *jwidth, *jheight;
+	int width, height;
+
+	if (!kshark_config_doc_get(_config, "MainWindow", windowConf))
+		return;
+
+	if (_config->format == KS_CONFIG_JSON) {
+		jwindow = KS_JSON_CAST(windowConf->conf_doc);
+		if (json_object_get_type(jwindow) == json_type_string &&
+		    QString(json_object_get_string(jwindow)) == "FullScreen") {
+			window->setFullScreenMode(true);
+			return;
+		}
+
+		jwidth = json_object_array_get_idx(jwindow, 0);
+		jheight = json_object_array_get_idx(jwindow, 1);
+
+		width = json_object_get_int(jwidth);
+		height = json_object_get_int(jheight);
+
+		window->setFullScreenMode(false);
+		window->resize(width, height);
+	}
+}
+
 /**
  * @brief Save the state of the Main window spliter.
  *
diff --git a/src/KsSession.hpp b/src/KsSession.hpp
index e1b7fd4..fd45270 100644
--- a/src/KsSession.hpp
+++ b/src/KsSession.hpp
@@ -20,6 +20,8 @@
 #include "KsTraceGraph.hpp"
 #include "KsTraceViewer.hpp"
 
+class KsMainWindow;
+
 /**
  * The KsSession class provides instruments for importing/exporting the state
  * of the different components of the GUI from/to Json documents. These
@@ -60,6 +62,8 @@ public:
 
 	void saveMainWindowSize(const QMainWindow &window);
 
+	void loadMainWindowSize(KsMainWindow *window);
+
 	void saveSplitterSize(const QSplitter &splitter);
 
 	void loadSplitterSize(QSplitter *splitter);
diff --git a/src/kernelshark.cpp b/src/kernelshark.cpp
index 0de80af..41ffbe7 100644
--- a/src/kernelshark.cpp
+++ b/src/kernelshark.cpp
@@ -17,14 +17,16 @@
 
 #define default_input_file (char*)"trace.dat"
 
-static char *input_file;
+static char *prior_input_file;
+QStringList appInputFiles;
 
 void usage(const char *prog)
 {
 	printf("Usage: %s\n", prog);
 	printf("  -h	Display this help message\n");
 	printf("  -v	Display version and exit\n");
-	printf("  -i	input_file, default is %s\n", default_input_file);
+	printf("  -i	prior input file, default is %s\n", default_input_file);
+	printf("  -a	input file to append to the prior\n");
 	printf("  -p	register plugin, use plugin name, absolute or relative path\n");
 	printf("  -u	unregister plugin, use plugin name or absolute path\n");
 	printf("  -s	import a session\n");
@@ -45,16 +47,18 @@ static option longOptions[] = {
 
 int main(int argc, char **argv)
 {
-	QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
-	QApplication a(argc, argv);
-
 	QVector<int> cpuPlots, taskPlots;
 	bool fromSession = false;
 	int optionIndex = 0;
-	KsMainWindow ks;
 	int c;
 
-	while ((c = getopt_long(argc, argv, "hvi:p:u:s:l",
+	QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
+	QApplication a(argc, argv);
+
+	KsMainWindow ks;
+	ks.show();
+
+	while ((c = getopt_long(argc, argv, "hvi:a:p:u:s:l",
 					    longOptions,
 					    &optionIndex)) != -1) {
 		switch(c) {
@@ -75,15 +79,19 @@ int main(int argc, char **argv)
 			return 0;
 
 		case 'i':
-			input_file = optarg;
+			prior_input_file = optarg;
+			break;
+
+		case 'a':
+			appInputFiles << QString(optarg).split(" ", QString::SkipEmptyParts);
 			break;
 
 		case 'p':
-			ks.registerPlugin(QString(optarg));
+			ks.registerPlugins(QString(optarg));
 			break;
 
 		case 'u':
-			ks.unregisterPlugin(QString(optarg));
+			ks.unregisterPlugins(QString(optarg));
 			break;
 
 		case 's':
@@ -103,19 +111,22 @@ int main(int argc, char **argv)
 
 	if (!fromSession) {
 		if ((argc - optind) >= 1) {
-			if (input_file)
+			if (prior_input_file)
 				usage(argv[0]);
-			input_file = argv[optind];
+			prior_input_file = argv[optind];
 		}
 
-		if (!input_file) {
+		if (!prior_input_file) {
 			struct stat st;
 			if (stat(default_input_file, &st) == 0)
-				input_file = default_input_file;
+				prior_input_file = default_input_file;
 		}
 
-		if (input_file)
-			ks.loadDataFile(QString(input_file));
+		if (prior_input_file)
+			ks.loadDataFile(QString(prior_input_file));
+
+		for (auto const &f: appInputFiles)
+			ks.appendDataFile(f);
 	}
 
 	auto lamOrderIds = [] (QVector<int> &ids) {
@@ -126,10 +137,10 @@ int main(int argc, char **argv)
 	};
 
 	if (cpuPlots.count() || taskPlots.count()) {
-		ks.setCPUPlots(lamOrderIds(cpuPlots));
-		ks.setTaskPlots(lamOrderIds(taskPlots));
+		ks.setCPUPlots(0, lamOrderIds(cpuPlots));
+		ks.setTaskPlots(0, lamOrderIds(taskPlots));
 	}
 
-	ks.show();
+	ks.raise();
 	return a.exec();
 }
-- 
2.25.1

