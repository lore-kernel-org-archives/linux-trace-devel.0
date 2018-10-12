Return-Path: <SRS0=pqkA=MY=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-co1nam03on0041.outbound.protection.outlook.com ([104.47.40.41]:22067
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728989AbeJLXri (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Oct 2018 19:47:38 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 09/10] kernel-shark-qt: Add Main Window widget gir the KernelShark GUI.
Date: Fri, 12 Oct 2018 19:13:17 +0300
Message-Id: <20181012161318.5302-10-ykaradzhov@vmware.com>
In-Reply-To: <20181012161318.5302-1-ykaradzhov@vmware.com>
References: <20181012161318.5302-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

The KsMainWindow class provides the Main window for the KernelShark
GUI. It implements the frame used by the two trace data viewing areas
(Graphs and Table) together withe the system of menus, used to perform
different actions.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/CMakeLists.txt       |   5 +
 kernel-shark-qt/src/CMakeLists.txt   |   2 +
 kernel-shark-qt/src/KsMainWindow.cpp | 909 +++++++++++++++++++++++++++
 kernel-shark-qt/src/KsMainWindow.hpp | 191 ++++++
 4 files changed, 1107 insertions(+)
 create mode 100644 kernel-shark-qt/src/KsMainWindow.cpp
 create mode 100644 kernel-shark-qt/src/KsMainWindow.hpp

diff --git a/kernel-shark-qt/CMakeLists.txt b/kernel-shark-qt/CMakeLists.txt
index 71a021e..0ccb61e 100644
--- a/kernel-shark-qt/CMakeLists.txt
+++ b/kernel-shark-qt/CMakeLists.txt
@@ -12,6 +12,11 @@ message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
 
 set(KS_DIR ${CMAKE_SOURCE_DIR})
 
+# Make a directory to hold configuration files. To change this do:
+# cmake .. -DKS_CONF_DIR=/your/preferred/path
+set(KS_CONF_DIR "${KS_DIR}/.ksconf" CACHE STRING "Directory for configuration files.")
+file(MAKE_DIRECTORY ${KS_CONF_DIR})
+
 include(${KS_DIR}/build/FindTraceCmd.cmake)
 include(${KS_DIR}/build/FindJSONC.cmake)
 
diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMakeLists.txt
index 192cd12..d8daada 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -38,6 +38,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                         KsWidgetsLib.hpp
                         KsTraceGraph.hpp
                         KsTraceViewer.hpp
+                        KsMainWindow.hpp
                         KsAdvFilteringDialog.hpp)
 
     QT5_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
@@ -50,6 +51,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                                                             KsWidgetsLib.cpp
                                                             KsTraceGraph.cpp
                                                             KsTraceViewer.cpp
+                                                            KsMainWindow.cpp
                                                             KsAdvFilteringDialog.cpp)
 
     target_link_libraries(kshark-gui kshark-plot
diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsMainWindow.cpp
new file mode 100644
index 0000000..38e47e6
--- /dev/null
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -0,0 +1,909 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsSession.cpp
+ *  @brief   KernelShark GUI main window.
+ */
+
+// C
+#include <sys/stat.h>
+#include <unistd.h>
+#include <pwd.h>
+
+// C++11
+#include <thread>
+
+// Qt
+#include <QMenu>
+#include <QFileDialog>
+#include <QMenuBar>
+#include <QLabel>
+#include <QLocalSocket>
+
+// KernelShark
+#include "libkshark.h"
+#include "KsCmakeDef.hpp"
+#include "KsMainWindow.hpp"
+#include "KsAdvFilteringDialog.hpp"
+
+/** Create KernelShark Main window. */
+KsMainWindow::KsMainWindow(QWidget *parent)
+: QMainWindow(parent),
+  _splitter(Qt::Vertical, this),
+  _data(this),
+  _view(this),
+  _graph(this),
+  _mState(this),
+  _plugins(this),
+  _openAction("Open", this),
+  _restorSessionAction("Restor Last Session", this),
+  _importSessionAction("Import Session", this),
+  _exportSessionAction("Export Sassion", this),
+  _quitAction("Quit", this),
+  _importFilterAction("Import Filter", this),
+  _exportFilterAction("Export Filter", this),
+  _graphFilterSyncAction(this),
+  _listFilterSyncAction(this),
+  _showEventsAction("Show events", this),
+  _showTasksAction("Show tasks", this),
+  _hideTasksAction("Hide tasks", this),
+  _advanceFilterAction("Advance Filtering", this),
+  _clearAllFilters("Clear all filters", this),
+  _cpuSelectAction("CPUs", this),
+  _taskSelectAction("Tasks", this),
+  _pluginsAction("Plugins", this),
+  _colorAction(this),
+  _colSlider(this),
+  _colorPhaseSlider(Qt::Horizontal, this),
+  _fullScreenModeAction("Full Screen Mode", this),
+  _isFullScreen(false),
+  _aboutAction("About", this),
+  _contentsAction("Contents", this)
+{
+	setWindowTitle("Kernel Shark");
+	_createActions();
+	_createMenus();
+
+	_splitter.addWidget(&_graph);
+	_splitter.addWidget(&_view);
+	setCentralWidget(&_splitter);
+	connect(&_splitter,	&QSplitter::splitterMoved,
+		this,		&KsMainWindow::_splitterMoved);
+
+	_view.setMarkerSM(&_mState);
+	connect(&_mState,	&KsDualMarkerSM::markSwitchForView,
+		&_view,		&KsTraceViewer::markSwitch);
+
+	_graph.setMarkerSM(&_mState);
+
+	connect(&_mState,	&KsDualMarkerSM::updateGraph,
+		&_graph,	&KsTraceGraph::markEntry);
+
+	connect(&_mState,	&KsDualMarkerSM::updateView,
+		&_view,		&KsTraceViewer::showRow);
+
+	connect(&_view,		&KsTraceViewer::select,
+		&_graph,	&KsTraceGraph::markEntry);
+
+	connect(&_view,		&KsTraceViewer::plotTask,
+		&_graph,	&KsTraceGraph::addTaskPlot);
+
+	connect(_graph.glPtr(), &KsGLWidget::updateView,
+		&_view,		&KsTraceViewer::showRow);
+
+	connect(_graph.glPtr(), &KsGLWidget::deselect,
+		&_view,		&KsTraceViewer::deselect);
+
+	connect(&_data,		&KsDataStore::updateWidgets,
+		&_view,		&KsTraceViewer::update);
+
+	connect(&_data,		&KsDataStore::updateWidgets,
+		&_graph,	&KsTraceGraph::update);
+
+	connect(&_plugins,	&KsPluginManager::dataReload,
+		&_data,		&KsDataStore::reload);
+
+	_resizeEmpty();
+}
+
+/** Destroy KernelShark Main window. */
+KsMainWindow::~KsMainWindow()
+{
+	kshark_context *kshark_ctx(nullptr);
+	QString file = KS_CONF_DIR;
+
+	file += "/lastsession.json";
+
+	_updateSession();
+	kshark_save_config_file(file.toLocal8Bit().data(),
+				_session.getConfDocPtr());
+
+	_data.clear();
+
+	if (kshark_instance(&kshark_ctx))
+		kshark_free(kshark_ctx);
+}
+
+/**
+ * Reimplemented event handler used to update the geometry of the window on
+ * resize events.
+ */
+void KsMainWindow::resizeEvent(QResizeEvent* event)
+{
+	QMainWindow::resizeEvent(event);
+
+	_session.saveMainWindowSize(*this);
+	_session.saveSplitterSize(_splitter);
+}
+
+void KsMainWindow::_createActions()
+{
+	/* File menu */
+	_openAction.setIcon(QIcon::fromTheme("document-open"));
+	_openAction.setShortcut(tr("Ctrl+O"));
+	_openAction.setStatusTip("Open an existing data file");
+
+	connect(&_openAction,	&QAction::triggered,
+		this,		&KsMainWindow::_open);
+
+	_restorSessionAction.setIcon(QIcon::fromTheme("document-open-recent"));
+	connect(&_restorSessionAction,	&QAction::triggered,
+		this,			&KsMainWindow::_restorSession);
+
+	_importSessionAction.setIcon(QIcon::fromTheme("document-send"));
+	_importSessionAction.setStatusTip("Load a session");
+
+	connect(&_importSessionAction,	&QAction::triggered,
+		this,			&KsMainWindow::_importSession);
+
+	_exportSessionAction.setIcon(QIcon::fromTheme("document-revert"));
+	_exportSessionAction.setStatusTip("Export this session");
+
+	connect(&_exportSessionAction,	&QAction::triggered,
+		this,			&KsMainWindow::_exportSession);
+
+	_quitAction.setIcon(QIcon::fromTheme("window-close"));
+	_quitAction.setShortcut(tr("Ctrl+Q"));
+	_quitAction.setStatusTip("Exit KernelShark");
+
+	connect(&_quitAction,	&QAction::triggered,
+		this,		&KsMainWindow::close);
+
+	/* Filter menu */
+	_importFilterAction.setIcon(QIcon::fromTheme("document-send"));
+	_importFilterAction.setStatusTip("Load a filter");
+
+	connect(&_importFilterAction,	&QAction::triggered,
+		this,			&KsMainWindow::_importFilter);
+
+	_exportFilterAction.setIcon(QIcon::fromTheme("document-revert"));
+	_exportFilterAction.setStatusTip("Export a filter");
+
+	connect(&_exportFilterAction,	&QAction::triggered,
+		this,			&KsMainWindow::_exportFilter);
+
+	connect(&_showEventsAction,	&QAction::triggered,
+		this,			&KsMainWindow::_showEvents);
+
+	connect(&_showTasksAction,	&QAction::triggered,
+		this,			&KsMainWindow::_showTasks);
+
+	connect(&_hideTasksAction,	&QAction::triggered,
+		this,			&KsMainWindow::_hideTasks);
+
+	connect(&_advanceFilterAction,	&QAction::triggered,
+		this,			&KsMainWindow::_advancedFiltering);
+
+	connect(&_clearAllFilters,	&QAction::triggered,
+		this,			&KsMainWindow::_clearFilters);
+
+	/* Plot menu */
+	connect(&_cpuSelectAction,	&QAction::triggered,
+		this,			&KsMainWindow::_cpuSelect);
+
+	connect(&_taskSelectAction,	&QAction::triggered,
+		this,			&KsMainWindow::_taskSelect);
+
+	/* Tools menu */
+	_pluginsAction.setShortcut(tr("Ctrl+P"));
+	_pluginsAction.setStatusTip("Manage plugins");
+
+	connect(&_pluginsAction,	&QAction::triggered,
+		this,			&KsMainWindow::_pluginSelect);
+
+	_colorPhaseSlider.setMinimum(20);
+	_colorPhaseSlider.setMaximum(180);
+	_colorPhaseSlider.setValue(KsPlot::Color::getRainbowFrequency() * 100);
+	_colorPhaseSlider.setFixedWidth(FONT_WIDTH * 15);
+
+	connect(&_colorPhaseSlider,	&QSlider::valueChanged,
+		this,			&KsMainWindow::_setColorPhase);
+
+	_colSlider.setLayout(new QHBoxLayout);
+	_colSlider.layout()->addWidget(new QLabel("Color scheme", this));
+	_colSlider.layout()->addWidget(&_colorPhaseSlider);
+	_colorAction.setDefaultWidget(&_colSlider);
+
+	_fullScreenModeAction.setIcon(QIcon::fromTheme("view-fullscreen"));
+	_fullScreenModeAction.setShortcut(tr("Ctrl+Shift+F"));
+	_fullScreenModeAction.setStatusTip("Full Screen Mode");
+
+	connect(&_fullScreenModeAction,	&QAction::triggered,
+		this,			&KsMainWindow::_fullScreenMode);
+
+	/* Help menu */
+	_aboutAction.setIcon(QIcon::fromTheme("help-about"));
+
+	connect(&_aboutAction,		&QAction::triggered,
+		this,			&KsMainWindow::_aboutInfo);
+
+	_contentsAction.setIcon(QIcon::fromTheme("help-contents"));
+	connect(&_contentsAction,	&QAction::triggered,
+		this,			&KsMainWindow::_contents);
+}
+
+void KsMainWindow::_createMenus()
+{
+	QMenu *file, *sessions, *filter, *plots, *tools, *help;
+	kshark_context *kshark_ctx(nullptr);
+	QCheckBox *cbf2g, *cbf2l;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	/* File menu */
+	file = menuBar()->addMenu("File");
+	file->addAction(&_openAction);
+
+	sessions = file->addMenu("Sessions");
+	sessions->setIcon(QIcon::fromTheme("document-properties"));
+	sessions->addAction(&_restorSessionAction);
+	sessions->addAction(&_importSessionAction);
+	sessions->addAction(&_exportSessionAction);
+	file->addAction(&_quitAction);
+
+	/* Filter menu */
+	filter = menuBar()->addMenu("Filter");
+	filter->addAction(&_importFilterAction);
+	filter->addAction(&_exportFilterAction);
+
+	auto lamMakeCBAction = [&](QWidgetAction *action, QString name)
+	{
+		QWidget  *containerWidget = new QWidget(filter);
+		containerWidget->setLayout(new QHBoxLayout());
+		containerWidget->layout()->setContentsMargins(FONT_WIDTH, FONT_HEIGHT/5,
+							      FONT_WIDTH, FONT_HEIGHT/5);
+		QCheckBox *checkBox = new QCheckBox(name, filter);
+		checkBox->setChecked(true);
+		containerWidget->layout()->addWidget(checkBox);
+		action->setDefaultWidget(containerWidget);
+		return checkBox;
+	};
+
+	/*
+	 * Set the default filter mask. Filter will apply to both View and
+	 * Graph.
+	 */
+	kshark_ctx->filter_mask =
+		KS_TEXT_VIEW_FILTER_MASK | KS_GRAPH_VIEW_FILTER_MASK;
+
+	kshark_ctx->filter_mask |= KS_EVENT_VIEW_FILTER_MASK;
+
+	cbf2g = lamMakeCBAction(&_graphFilterSyncAction,
+				"Apply filters to Graph");
+
+	connect(cbf2g,	&QCheckBox::stateChanged,
+		this,	&KsMainWindow::_graphFilterSync);
+
+	cbf2l = lamMakeCBAction(&_listFilterSyncAction,
+				"Apply filters to List");
+
+	connect(cbf2l,	&QCheckBox::stateChanged,
+		this,	&KsMainWindow::_listFilterSync);
+
+	filter->addAction(&_graphFilterSyncAction);
+	filter->addAction(&_listFilterSyncAction);
+	filter->addAction(&_showEventsAction);
+	filter->addAction(&_showTasksAction);
+	filter->addAction(&_hideTasksAction);
+	filter->addAction(&_advanceFilterAction);
+	filter->addAction(&_clearAllFilters);
+
+	/* Plot menu */
+	plots = menuBar()->addMenu("Plots");
+	plots->addAction(&_cpuSelectAction);
+	plots->addAction(&_taskSelectAction);
+
+	/* Tools menu */
+	tools = menuBar()->addMenu("Tools");
+	tools->addAction(&_pluginsAction);
+	tools->addSeparator();
+	tools->addAction(&_colorAction);
+	tools->addAction(&_fullScreenModeAction);
+
+	/* Help menu */
+	help = menuBar()->addMenu("Help");
+	help->addAction(&_aboutAction);
+	help->addAction(&_contentsAction);
+}
+
+void KsMainWindow::_open()
+{
+	QString fileName =
+		QFileDialog::getOpenFileName(this,
+					     "Open File",
+					     KS_DIR,
+					     "trace-cmd files (*.dat);;All files (*)");
+
+	if (!fileName.isEmpty())
+		loadDataFile(fileName);
+}
+
+void KsMainWindow::_restorSession()
+{
+	QString file = KS_CONF_DIR;
+	file += "/lastsession.json";
+
+	loadSession(file);
+	_graph.updateGeom();
+}
+
+void KsMainWindow::_importSession()
+{
+	QString fileName =
+		QFileDialog::getOpenFileName(this,
+					     "Import Session",
+					     KS_DIR,
+					     "Kernel Shark Config files (*.json);;");
+
+	if (fileName.isEmpty())
+		return;
+
+	loadSession(fileName);
+	_graph.updateGeom();
+}
+
+void KsMainWindow::_updateSession()
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	_session.saveGraphs(*_graph.glPtr());
+	_session.saveVisModel(_graph.glPtr()->model()->histo());
+	_session.saveFilters(kshark_ctx);
+	_session.saveDualMarker(&_mState);
+	_session.saveTable(_view);
+	_session.saveColorScheme();
+	_session.savePlugins(_plugins);
+}
+
+void KsMainWindow::_exportSession()
+{
+	QString fileName =
+		QFileDialog::getSaveFileName(this,
+					     "Export Filter",
+					     KS_DIR,
+					     "Kernel Shark Config files (*.json);;");
+
+	if (fileName.isEmpty())
+		return;
+
+	if (!fileName.endsWith(".json")) {
+		fileName += ".json";
+		if (QFileInfo(fileName).exists()) {
+			QString msg("A file ");
+			QMessageBox msgBox;
+
+			msg += fileName;
+			msg += " already exists.";
+			msgBox.setText(msg);
+			msgBox.setInformativeText("Do you want to replace it?");
+
+			msgBox.setStandardButtons(QMessageBox::Save |
+						  QMessageBox::Cancel);
+
+			msgBox.setDefaultButton(QMessageBox::Cancel);
+
+			if (msgBox.exec() == QMessageBox::Cancel)
+				return;
+		}
+	}
+
+	_updateSession();
+	_session.exportToFile(fileName);
+}
+
+void KsMainWindow::_importFilter()
+{
+	kshark_context *kshark_ctx(nullptr);
+	kshark_config_doc *conf;
+	QString fileName;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	fileName = QFileDialog::getOpenFileName(this, "Import Filter", KS_DIR,
+						"Kernel Shark Config files (*.json);;");
+
+	if (fileName.isEmpty())
+		return;
+
+	conf = kshark_open_config_file(fileName.toStdString().c_str(),
+				       "kshark.config.filter");
+	if (!conf)
+		return;
+
+	kshark_import_all_event_filters(kshark_ctx, conf);
+	kshark_free_config_doc(conf);
+
+	kshark_filter_entries(kshark_ctx, _data.rows(), _data.size());
+	emit _data.updateWidgets(&_data);
+}
+
+void KsMainWindow::_exportFilter()
+{
+	kshark_context *kshark_ctx(nullptr);
+	kshark_config_doc *conf(nullptr);
+	QString fileName;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	fileName = QFileDialog::getSaveFileName(this, "Export Filter", KS_DIR,
+						"Kernel Shark Config files (*.json);;");
+
+	if (fileName.isEmpty())
+		return;
+
+	if (!fileName.endsWith(".json"))
+		fileName += ".json";
+
+	kshark_export_all_event_filters(kshark_ctx, &conf);
+	kshark_save_config_file(fileName.toStdString().c_str(), conf);
+	kshark_free_config_doc(conf);
+}
+
+void KsMainWindow::_listFilterSync(int state)
+{
+	KsUtils::listFilterSync(state);
+	_data.update();
+}
+
+void KsMainWindow::_graphFilterSync(int state)
+{
+	KsUtils::graphFilterSync(state);
+	_data.update();
+}
+
+void KsMainWindow::_showEvents()
+{
+	kshark_context *kshark_ctx(nullptr);
+	KsCheckBoxWidget *events_cb;
+	KsCheckBoxDialog *dialog;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	events_cb = new KsEventsCheckBoxWidget(_data.tep(), this);
+	dialog = new KsCheckBoxDialog(events_cb, this);
+
+	if (!kshark_ctx->show_event_filter ||
+	    !kshark_ctx->show_event_filter->count) {
+		events_cb->setDefault(true);
+	} else {
+		/*
+		 * The event filter contains IDs. Make this visible in the
+		 * CheckBox Widget.
+		 */
+		tep_event_format **events =
+			tep_list_events(_data.tep(), TEP_EVENT_SORT_SYSTEM);
+		int nEvts = tep_get_events_count(_data.tep());
+		QVector<bool> v(nEvts, false);
+
+		for (int i = 0; i < nEvts; ++i) {
+			if (tracecmd_filter_id_find(kshark_ctx->show_event_filter,
+						    events[i]->id))
+				v[i] = true;
+		}
+
+		events_cb->set(v);
+	}
+
+	connect(dialog,		&KsCheckBoxDialog::apply,
+		&_data,		&KsDataStore::applyPosEventFilter);
+
+	dialog->show();
+}
+
+void KsMainWindow::_showTasks()
+{
+	kshark_context *kshark_ctx(nullptr);
+	KsCheckBoxWidget *tasks_cbd;
+	KsCheckBoxDialog *dialog;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	tasks_cbd = new KsTasksCheckBoxWidget(_data.tep(), true, this);
+	dialog = new KsCheckBoxDialog(tasks_cbd, this);
+
+	if (!kshark_ctx->show_task_filter ||
+	    !kshark_ctx->show_task_filter->count) {
+		tasks_cbd->setDefault(true);
+	} else {
+		QVector<int> pids = KsUtils::getPidList();
+		int nPids = pids.count();
+		QVector<bool> v(nPids, false);
+
+		for (int i = 0; i < nPids; ++i) {
+			if (tracecmd_filter_id_find(kshark_ctx->show_task_filter,
+						    pids[i]))
+				v[i] = true;
+		}
+
+		tasks_cbd->set(v);
+	}
+
+	connect(dialog,		&KsCheckBoxDialog::apply,
+		&_data,		&KsDataStore::applyPosTaskFilter);
+
+	dialog->show();
+}
+
+void KsMainWindow::_hideTasks()
+{
+	kshark_context *kshark_ctx(nullptr);
+	KsCheckBoxWidget *tasks_cbd;
+	KsCheckBoxDialog *dialog;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	tasks_cbd = new KsTasksCheckBoxWidget(_data.tep(), false, this);
+	dialog = new KsCheckBoxDialog(tasks_cbd, this);
+
+	if (!kshark_ctx->hide_task_filter ||
+	    !kshark_ctx->hide_task_filter->count) {
+		tasks_cbd->setDefault(false);
+	} else {
+		QVector<int> pids = KsUtils::getPidList();
+		int nPids = pids.count();
+		QVector<bool> v(nPids, false);
+
+		for (int i = 0; i < nPids; ++i) {
+			if (tracecmd_filter_id_find(kshark_ctx->hide_task_filter,
+						    pids[i]))
+				v[i] = true;
+		}
+
+		tasks_cbd->set(v);
+	}
+
+	connect(dialog,		&KsCheckBoxDialog::apply,
+		&_data,		&KsDataStore::applyNegTaskFilter);
+
+	dialog->show();
+}
+
+void KsMainWindow::_advancedFiltering()
+{
+	KsAdvFilteringDialog *dialog;
+
+	if (!_data.tep()) {
+		QErrorMessage *em = new QErrorMessage(this);
+		QString text("Unable to open Advanced filtering dialog.");
+
+		text += " Tracing data has to be loaded first.";
+
+		em->showMessage(text, "advancedFiltering");
+		qCritical() << "ERROR: " << text;
+
+		return;
+	}
+
+	dialog = new KsAdvFilteringDialog(this);
+	connect(dialog,		&KsAdvFilteringDialog::dataReload,
+		&_data,		&KsDataStore::reload);
+
+	dialog->show();
+}
+
+void KsMainWindow::_clearFilters()
+{
+	_data.clearAllFilters();
+}
+
+void KsMainWindow::_cpuSelect()
+{
+	KsCheckBoxWidget *cpus_cbd = new KsCPUCheckBoxWidget(_data.tep(), this);
+	KsCheckBoxDialog *dialog = new KsCheckBoxDialog(cpus_cbd, this);
+
+	if(_data.tep()) {
+		int nCPUs = tep_get_cpus(_data.tep());
+		if (nCPUs == _graph.glPtr()->cpuGraphCount()) {
+			cpus_cbd->setDefault(true);
+		} else {
+			QVector<bool> v(nCPUs, false);
+
+			for (auto const &cpu: _graph.glPtr()->_cpuList)
+				v[cpu] = true;
+
+			cpus_cbd->set(v);
+		}
+	}
+
+	connect(dialog,		&KsCheckBoxDialog::apply,
+		&_graph,	&KsTraceGraph::cpuReDraw);
+
+	dialog->show();
+}
+
+void KsMainWindow::_taskSelect()
+{
+	KsCheckBoxWidget *tasks_cbd = new KsTasksCheckBoxWidget(_data.tep(),
+								true,
+								this);
+	KsCheckBoxDialog *dialog = new KsCheckBoxDialog(tasks_cbd, this);
+	QVector<int> pids = KsUtils::getPidList();
+	int nPids = pids.count();
+
+	if (nPids == _graph.glPtr()->taskGraphCount()) {
+		tasks_cbd->setDefault(true);
+	} else {
+		QVector<bool> v(nPids, false);
+		for (int i = 0; i < nPids; ++i) {
+			for (auto const &pid: _graph.glPtr()->_taskList) {
+				if (pids[i] == pid) {
+					v[i] = true;
+					break;
+				}
+			}
+		}
+
+		tasks_cbd->set(v);
+	}
+
+	connect(dialog,		&KsCheckBoxDialog::apply,
+		&_graph,	&KsTraceGraph::taskReDraw);
+
+	dialog->show();
+}
+
+void KsMainWindow::_pluginSelect()
+{
+	KsCheckBoxWidget *plugin_cbd;
+	KsCheckBoxDialog *dialog;
+	QVector<bool> registeredPlugins;
+	QStringList plugins;
+
+	plugins << _plugins._ksPluginList << _plugins._userPluginList;
+
+	registeredPlugins << _plugins._registeredKsPlugins
+			  << _plugins._registeredUserPlugins;
+
+	plugin_cbd = new KsPluginCheckBoxWidget(plugins, this);
+	plugin_cbd->set(registeredPlugins);
+
+	dialog = new KsCheckBoxDialog(plugin_cbd, this);
+
+	connect(dialog,		&KsCheckBoxDialog::apply,
+		&_plugins,	&KsPluginManager::updatePlugins);
+
+	dialog->show();
+}
+
+void KsMainWindow::_setColorPhase(int f)
+{
+	KsPlot::Color::setRainbowFrequency(f / 100.);
+	_graph.glPtr()->model()->update();
+}
+
+void KsMainWindow::_fullScreenMode()
+{
+	if (_isFullScreen) {
+		_fullScreenModeAction.setText("Full Screen Mode");
+		_fullScreenModeAction.setIcon(QIcon::fromTheme("view-fullscreen"));
+		showNormal();
+		_isFullScreen = false;
+	} else {
+		_fullScreenModeAction.setText("Exit Full Screen Mode");
+		_fullScreenModeAction.setIcon(QIcon::fromTheme("view-restore"));
+		showFullScreen();
+		_isFullScreen = true;
+	}
+}
+
+void KsMainWindow::_aboutInfo()
+{
+	KsMessageDialog *message;
+	QString text;
+
+	text.append(" KernelShark\n\n version: ");
+	text.append(KS_VERSION_STRING);
+	text.append("\n");
+
+	message = new KsMessageDialog(text);
+	message->setWindowTitle("About");
+	message->show();
+}
+
+void KsMainWindow::_contents()
+{
+	QDesktopServices::openUrl(QUrl("https://www.google.bg/search?q=kernelshark",
+				  QUrl::TolerantMode));
+}
+
+/** Load trace data for file. */
+void KsMainWindow::loadDataFile(const QString& fileName)
+{
+	char buff[FILENAME_MAX];
+	QString pbLabel("Loading    ");
+	bool loadDone = false;
+	struct stat st;
+	int ret;
+
+	ret = stat(fileName.toStdString().c_str(), &st);
+	if (ret != 0) {
+		QString text("Unable to find file ");
+
+		text.append(fileName);
+		text.append(".");
+		_error(text, "loadDataErr1", true, true);
+
+		return;
+	}
+
+	qInfo() << "Loading " << fileName;
+
+	_mState.reset();
+	_view.reset();
+	_graph.reset();
+
+	if (fileName.size() < 40) {
+		pbLabel += fileName;
+	} else {
+		pbLabel += "...";
+		pbLabel += fileName.mid(fileName.size() - 37, 37);
+	}
+
+	setWindowTitle("Kernel Shark");
+	KsProgressBar pb(pbLabel);
+	QApplication::processEvents();
+
+	auto lamLoadJob = [&](KsDataStore *d) {
+		d->loadDataFile(fileName);
+		loadDone = true;
+	};
+	std::thread tload(lamLoadJob, &_data);
+
+	for (int i = 0; i < 160; ++i) {
+		/*
+		 * TODO: The way this progress bar gets updated here is a pure
+		 * cheat. See if this can be implemented better.
+		*/
+		if (loadDone)
+			break;
+
+		pb.setValue(i);
+		usleep(150000);
+	}
+
+	tload.join();
+
+	if (!_data.size()) {
+		QString text("File ");
+
+		text.append(fileName);
+		text.append(" contains no data.");
+		_error(text, "loadDataErr2", true, true);
+
+		return;
+	}
+
+	pb.setValue(165);
+	_view.loadData(&_data);
+
+	pb.setValue(180);
+	_graph.loadData(&_data);
+	pb.setValue(195);
+	setWindowTitle("Kernel Shark (" + fileName + ")");
+
+	if (realpath(fileName.toStdString().c_str(), buff)) {
+		QString path(buff);
+		_session.saveDataFile(path);
+	}
+}
+
+void KsMainWindow::_error(const QString &text, const QString &errCode,
+			  bool resize, bool unloadPlugins)
+{
+	QErrorMessage *em = new QErrorMessage(this);
+
+	if (resize)
+		_resizeEmpty();
+
+	if (unloadPlugins)
+		_plugins.unloadAll();
+
+	em->showMessage(text, errCode);
+	qCritical() << "ERROR: " << text;
+}
+
+/**
+ * @brief Load user session.
+ *
+ * @param fileName: Json file containing the description of the session.
+ */
+void KsMainWindow::loadSession(const QString &fileName)
+{
+	kshark_context *kshark_ctx(nullptr);
+	struct stat st;
+	int ret;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	ret = stat(fileName.toStdString().c_str(), &st);
+	if (ret != 0) {
+		QString text("Unable to find session file ");
+
+		text.append(fileName);
+		text.append("\n");
+		_error(text, "loadSessErr0", true, true);
+
+		return;
+	}
+
+	_session.importFromFile(fileName);
+	_session.loadPlugins(kshark_ctx, &_plugins);
+
+	QString dataFile(_session.getDataFile(kshark_ctx));
+	if (dataFile.isEmpty()) {
+		QString text("Unable to open trace data file for session ");
+
+		text.append(fileName);
+		text.append("\n");
+		_error(text, "loadSessErr1", true, true);
+
+		return;
+	}
+
+	loadDataFile(dataFile);
+	if (!_data.tep()) {
+		_plugins.unloadAll();
+		return;
+	}
+
+	KsProgressBar pb("Loading session settings ...");
+	pb.setValue(10);
+
+	_session.loadGraphs(&_graph);
+	pb.setValue(20);
+
+	_session.loadFilters(kshark_ctx, &_data);
+	pb.setValue(130);
+
+	_session.loadSplitterSize(&_splitter);
+	_session.loadMainWindowSize(this);
+	this->show();
+	pb.setValue(140);
+
+	_session.loadDualMarker(&_mState, &_graph);
+	_session.loadVisModel(_graph.glPtr()->model());
+	_mState.updateMarkers(_data, _graph.glPtr());
+	pb.setValue(170);
+
+	_session.loadTable(&_view);
+	_colorPhaseSlider.setValue(_session.getColorScheme() * 100);
+}
+
+void KsMainWindow::_splitterMoved(int pos, int index)
+{
+	_session.saveSplitterSize(_splitter);
+}
diff --git a/kernel-shark-qt/src/KsMainWindow.hpp b/kernel-shark-qt/src/KsMainWindow.hpp
new file mode 100644
index 0000000..cee68db
--- /dev/null
+++ b/kernel-shark-qt/src/KsMainWindow.hpp
@@ -0,0 +1,191 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsSession.hpp
+ *  @brief   KernelShark GUI main window.
+ */
+
+#ifndef _KS_MAINWINDOW_H
+#define _KS_MAINWINDOW_H
+
+// Qt
+#include <QMainWindow>
+
+// KernelShark
+#include "KsTraceViewer.hpp"
+#include "KsTraceGraph.hpp"
+#include "KsSession.hpp"
+#include "KsUtils.hpp"
+
+/**
+ * The KsMainWindow class provides Main window for the KernelShark GUI.
+ */
+class KsMainWindow : public QMainWindow
+{
+	Q_OBJECT
+public:
+	explicit KsMainWindow(QWidget *parent = nullptr);
+
+	~KsMainWindow();
+
+	void loadDataFile(const QString &fileName);
+
+	void loadSession(const QString &fileName);
+
+	/**
+	 * @brief
+	 *
+	 * @param plugin: can be the name of the plugin or the plugin's library
+	 * file (including absolute or relative path).
+	 */
+	void registerPlugin(const QString &plugin)
+	{
+		_plugins.registerPlugin(plugin);
+	}
+
+	/**
+	 * @brief
+	 *
+	 * @param plugin: can be the name of the plugin or the plugin's library
+	 * file (including absolute path).
+	 */
+	void unregisterPlugin(const QString &plugin)
+	{
+		_plugins.unregisterPlugin(plugin);
+	}
+
+	void resizeEvent(QResizeEvent* event);
+
+private:
+	QSplitter	_splitter;
+
+	/** GUI session. */
+	KsSession	_session;
+
+	/** Data Manager. */
+	KsDataStore	_data;
+
+	/** Widget for reading and searching in the trace data. */
+	KsTraceViewer	_view;
+
+	/** Widget for graphical visualization of the trace data. */
+	KsTraceGraph	_graph;
+
+	/** Dual Marker State Machine. */
+	KsDualMarkerSM	_mState;
+
+	/** Plugin manager. */
+	KsPluginManager	_plugins;
+
+	// File menu.
+	QAction		_openAction;
+
+	QAction		_restorSessionAction;
+
+	QAction		_importSessionAction;
+
+	QAction		_exportSessionAction;
+
+	QAction		_quitAction;
+
+	// Filter menu.
+	QAction		_importFilterAction;
+
+	QAction		_exportFilterAction;
+
+	QWidgetAction	_graphFilterSyncAction;
+
+	QWidgetAction	_listFilterSyncAction;
+
+	QAction		_showEventsAction;
+
+	QAction		_showTasksAction;
+
+	QAction		_hideTasksAction;
+
+	QAction		_advanceFilterAction;
+
+	QAction		_clearAllFilters;
+
+	// Plots menu.
+	QAction		_cpuSelectAction;
+
+	QAction		_taskSelectAction;
+
+	// Tools menu.
+	QAction		_pluginsAction;
+
+	QWidgetAction	_colorAction;
+
+	QWidget		_colSlider;
+
+	QSlider		_colorPhaseSlider;
+
+	QAction		_fullScreenModeAction;
+
+	bool		_isFullScreen;
+
+	// Help menu.
+	QAction		_aboutAction;
+
+	QAction		_contentsAction;
+
+	void _open();
+
+	void _restorSession();
+
+	void _importSession();
+
+	void _exportSession();
+
+	void _importFilter();
+
+	void _exportFilter();
+
+	void _listFilterSync(int state);
+
+	void _graphFilterSync(int state);
+
+	void _showEvents();
+
+	void _showTasks();
+
+	void _hideTasks();
+
+	void _advancedFiltering();
+
+	void _clearFilters();
+
+	void _cpuSelect();
+
+	void _taskSelect();
+
+	void _pluginSelect();
+
+	void _setColorPhase(int);
+
+	void _fullScreenMode();
+
+	void _aboutInfo();
+
+	void _contents();
+
+	void _splitterMoved(int pos, int index);
+
+	void _createActions();
+
+	void _createMenus();
+
+	void _updateSession();
+
+	inline void _resizeEmpty() {resize(SCREEN_WIDTH * .5, FONT_HEIGHT * 3);}
+
+	void _error(const QString &text, const QString &errCode,
+		    bool resize, bool unloadPlugins);
+};
+
+#endif // _KS_MAINWINDOW_H
-- 
2.17.1
