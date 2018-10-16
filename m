Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam01on0073.outbound.protection.outlook.com ([104.47.32.73]:27872
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726778AbeJPXoY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:44:24 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v2 14/23] kernel-shark-qt: Add dialog for of trace data
 recording
Date: Tue, 16 Oct 2018 15:53:13 +0000
Message-ID: <20181016155232.5257-15-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

This patch defines a dialog to be used for trace data recording.
The dialog has two main areas: a Control panel and a terminal-like
widget for monitoring the recording process.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/CMakeLists.txt      |   2 +
 kernel-shark-qt/src/KsCaptureDialog.cpp | 562 ++++++++++++++++++++++++
 kernel-shark-qt/src/KsCaptureDialog.hpp | 185 ++++++++
 3 files changed, 749 insertions(+)
 create mode 100644 kernel-shark-qt/src/KsCaptureDialog.cpp
 create mode 100644 kernel-shark-qt/src/KsCaptureDialog.hpp

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMake=
Lists.txt
index b51980f..3c9e1bf 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -39,6 +39,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                         KsTraceGraph.hpp
                         KsTraceViewer.hpp
                         KsMainWindow.hpp
+                        KsCaptureDialog.hpp
                         KsAdvFilteringDialog.hpp)
=20
     QT5_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
@@ -52,6 +53,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                                                             KsTraceGraph.c=
pp
                                                             KsTraceViewer.=
cpp
                                                             KsMainWindow.c=
pp
+                                                            KsCaptureDialo=
g.cpp
                                                             KsAdvFiltering=
Dialog.cpp)
=20
     target_link_libraries(kshark-gui kshark-plot
diff --git a/kernel-shark-qt/src/KsCaptureDialog.cpp b/kernel-shark-qt/src/=
KsCaptureDialog.cpp
new file mode 100644
index 0000000..ee1abc3
--- /dev/null
+++ b/kernel-shark-qt/src/KsCaptureDialog.cpp
@@ -0,0 +1,562 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsCaptureDialog.cpp
+ *  @brief   Dialog for trace data recording.
+ */
+
+// Qt
+#include <QLocalSocket>
+
+// KernelShark
+#include "libkshark.h"
+#include "KsUtils.hpp"
+#include "KsCmakeDef.hpp"
+#include "KsCaptureDialog.hpp"
+
+static inline tep_handle *local_events()
+{
+	return tracecmd_local_events(tracecmd_get_tracing_dir());
+}
+
+/** @brief Create KsCaptureControl widget. */
+KsCaptureControl::KsCaptureControl(QWidget *parent)
+: QWidget(parent),
+  _localTEP(local_events()),
+  _eventsWidget(_localTEP, this),
+  _pluginsLabel("Plugin: ", this),
+  _outputLabel("Output file: ", this),
+  _commandLabel("Command: ", this),
+  _outputLineEdit("trace.dat", this),
+  _commandLineEdit("sleep 0.1", this),
+  _settingsToolBar(this),
+  _controlToolBar(this),
+  _pluginsComboBox(this),
+  _importSettingsButton("Import Settings", this),
+  _exportSettingsButton("Export Settings", this),
+  _outputBrowseButton("Browse", this),
+  _commandCheckBox("Display output", this),
+  _captureButton("Capture", &_controlToolBar),
+  _applyButton("Apply", &_controlToolBar),
+  _closeButton("Close", &_controlToolBar)
+{
+	QStringList pluginList =3D _getPlugins();
+	int row(0);
+
+	auto lamAddLine =3D [&] {
+		QFrame* line =3D new QFrame();
+
+		line->setFrameShape(QFrame::HLine);
+		line->setFrameShadow(QFrame::Sunken);
+		_topLayout.addWidget(line);
+	};
+
+	if (pluginList.count() =3D=3D 0) {
+		/*
+		 * No plugins have been found. Most likely this is because
+		 * the process has no Root privileges.
+		 */
+		QString message("Error: No events or plugins found.\n");
+		message +=3D "Root privileges are required.";
+		QLabel *errorLabel =3D new QLabel(message);
+
+		errorLabel->setStyleSheet("QLabel {color : red;}");
+		_topLayout.addWidget(errorLabel);
+
+		lamAddLine();
+	}
+
+	pluginList.prepend("nop");
+
+	_settingsToolBar.addWidget(&_importSettingsButton);
+	_settingsToolBar.addSeparator();
+	_settingsToolBar.addWidget(&_exportSettingsButton);
+	_topLayout.addWidget(&_settingsToolBar);
+
+	lamAddLine();
+
+	_eventsWidget.setDefault(false);
+	_eventsWidget.setMinimumHeight(25 * FONT_HEIGHT);
+	_topLayout.addWidget(&_eventsWidget);
+
+	_pluginsLabel.adjustSize();
+	_execLayout.addWidget(&_pluginsLabel, row, 0);
+
+	_pluginsComboBox.addItems(pluginList);
+	_execLayout.addWidget(&_pluginsComboBox, row++, 1);
+
+	_outputLabel.adjustSize();
+	_execLayout.addWidget(&_outputLabel, row, 0);
+	_outputLineEdit.setFixedWidth(FONT_WIDTH * 30);
+	_execLayout.addWidget(&_outputLineEdit, row, 1);
+	_outputBrowseButton.adjustSize();
+	_execLayout.addWidget(&_outputBrowseButton, row++, 2);
+
+	_commandLabel.adjustSize();
+	_commandLabel.setFixedWidth(_outputLabel.width());
+	_execLayout.addWidget(&_commandLabel, row, 0);
+	_commandLineEdit.setFixedWidth(FONT_WIDTH * 30);
+	_execLayout.addWidget(&_commandLineEdit, row, 1);
+	_commandCheckBox.setCheckState(Qt::Unchecked);
+	_commandCheckBox.adjustSize();
+	_execLayout.addWidget(&_commandCheckBox, row++, 2);
+
+	_topLayout.addLayout(&_execLayout);
+
+	lamAddLine();
+
+	_captureButton.setFixedWidth(STRING_WIDTH("_Capture_") + FONT_WIDTH * 2);
+	_applyButton.setFixedWidth(_captureButton.width());
+	_closeButton.setFixedWidth(_captureButton.width());
+
+	_controlToolBar.addWidget(&_captureButton);
+	_controlToolBar.addWidget(&_applyButton);
+	_controlToolBar.addWidget(&_closeButton);
+	_topLayout.addWidget(&_controlToolBar);
+
+	setLayout(&_topLayout);
+
+	connect(&_importSettingsButton,	&QPushButton::pressed,
+		this,			&KsCaptureControl::_importSettings);
+
+	connect(&_exportSettingsButton,	&QPushButton::pressed,
+		this,			&KsCaptureControl::_exportSettings);
+
+	connect(&_outputBrowseButton,	&QPushButton::pressed,
+		this,			&KsCaptureControl::_browse);
+
+	connect(&_applyButton,		&QPushButton::pressed,
+		this,			&KsCaptureControl::_apply);
+}
+
+/**
+ * Use the settings of the Control panel to generate a list of command lin=
e
+ * arguments for trace-cmd.
+ */
+QStringList KsCaptureControl::getArgs()
+{
+	QStringList argv;
+
+	argv << "record";
+	argv << "-p" << _pluginsComboBox.currentText();
+
+	if (_eventsWidget.all()) {
+		argv << "-e" << "all";
+	} else {
+		QVector<int> evtIds =3D _eventsWidget.getCheckedIds();
+		tep_event_format *event;
+
+		for (auto const &id: evtIds) {
+			event =3D tep_find_event(_localTEP, id);
+			if (!event)
+				continue;
+
+			argv << "-e" + QString(event->system) +
+				":" + QString(event->name);
+		}
+	}
+
+	argv << "-o" << outputFileName();
+	argv << _commandLineEdit.text().split(" ");
+
+	return argv;
+}
+
+QStringList KsCaptureControl::_getPlugins()
+{
+	QStringList pluginList;
+	char **all_plugins;
+
+	all_plugins =3D tracecmd_local_plugins(tracecmd_get_tracing_dir());
+
+	if (!all_plugins)
+		return pluginList;
+
+	for (int i =3D 0; all_plugins[i]; ++i) {
+		/*
+		 * TODO plugin selection here.
+		 * printf("plugin %i %s\n", i, all_plugins[i]);
+		 */
+		pluginList << all_plugins[i];
+		free(all_plugins[i]);
+	}
+
+	free (all_plugins);
+	qSort(pluginList);
+
+	return pluginList;
+}
+
+void KsCaptureControl::_importSettings()
+{
+	int nEvts =3D tep_get_events_count(_localTEP);
+	kshark_config_doc *conf, *jevents, *temp;
+	QVector<bool> v(nEvts, false);
+	tracecmd_filter_id *eventHash;
+	tep_event_format **events;
+	QString fileName;
+
+
+	/** Get all available events. */
+	events =3D tep_list_events(_localTEP, TEP_EVENT_SORT_SYSTEM);
+
+	/* Get the configuration document. */
+	fileName =3D QFileDialog::getOpenFileName(this,
+						"Import from Filter",
+						KS_DIR,
+						"Kernel Shark Config files (*.json);;");
+
+	if (fileName.isEmpty())
+		return;
+
+	conf =3D kshark_open_config_file(fileName.toStdString().c_str(),
+				       "kshark.config.record");
+	if (!conf)
+		return;
+
+	/*
+	 * Load the hash table of selected events from the configuration
+	 * document.
+	 */
+	jevents =3D kshark_config_alloc(KS_CONFIG_JSON);
+	if (!kshark_config_doc_get(conf, "Events", jevents))
+		return;
+
+	eventHash =3D tracecmd_filter_id_hash_alloc();
+	kshark_import_event_filter(_localTEP, eventHash, "Events", jevents);
+	for (int i =3D 0; i < nEvts; ++i) {
+		if (tracecmd_filter_id_find(eventHash, events[i]->id))
+			v[i] =3D true;
+	}
+
+	_eventsWidget.set(v);
+	tracecmd_filter_id_hash_free(eventHash);
+
+	/** Get all available plugins. */
+	temp =3D kshark_string_config_alloc();
+
+	if (kshark_config_doc_get(conf, "Plugin", temp))
+		_pluginsComboBox.setCurrentText(KS_C_STR_CAST(temp->conf_doc));
+
+	if (kshark_config_doc_get(conf, "Output", temp))
+		_outputLineEdit.setText(KS_C_STR_CAST(temp->conf_doc));
+
+	if (kshark_config_doc_get(conf, "Command", temp))
+		_commandLineEdit.setText(KS_C_STR_CAST(temp->conf_doc));
+}
+
+void KsCaptureControl::_exportSettings()
+{
+	kshark_config_doc *conf, *events;
+	json_object *jplugin;
+	QString plugin, out, comm;
+	QVector<int> ids;
+	QString fileName =3D
+		QFileDialog::getSaveFileName(this,
+					     "Export to File",
+					     KS_DIR,
+					     "Kernel Shark Config files (*.json);;");
+
+	if (fileName.isEmpty())
+		return;
+
+	if (!fileName.endsWith(".json")) {
+		fileName +=3D ".json";
+		if (QFileInfo(fileName).exists()) {
+			if (!KsWidgetsLib::fileExistsDialog(fileName))
+				return;
+		}
+	}
+
+	/* Create a configuration document. */
+	conf =3D kshark_record_config_new(KS_CONFIG_JSON);
+	events =3D kshark_filter_config_new(KS_CONFIG_JSON);
+
+	/*
+	 * Use the tracecmd_filter_id to save all selected events in the
+	 * configuration file.
+	 */
+	ids =3D _eventsWidget.getCheckedIds();
+	tracecmd_filter_id *eventHash =3D tracecmd_filter_id_hash_alloc();
+	for (auto const &id: ids)
+		tracecmd_filter_id_add(eventHash, id);
+
+	kshark_export_event_filter(_localTEP, eventHash, "Events", events);
+	kshark_config_doc_add(conf, "Events", events);
+
+	tracecmd_filter_id_hash_free(eventHash);
+
+	/* Save the plugin. */
+	plugin =3D _pluginsComboBox.currentText();
+	jplugin =3D json_object_new_string(plugin.toStdString().c_str());
+	kshark_config_doc_add(conf, "Plugin", kshark_json_to_conf(jplugin));
+
+	/* Save the output file. */
+	out =3D outputFileName();
+	json_object *jout =3D json_object_new_string(out.toStdString().c_str());
+	kshark_config_doc_add(conf, "Output", kshark_json_to_conf(jout));
+
+	/* Save the command. */
+	comm =3D _commandLineEdit.text();
+	json_object *jcomm =3D json_object_new_string(comm.toStdString().c_str())=
;
+	kshark_config_doc_add(conf, "Command", kshark_json_to_conf(jcomm));
+
+	kshark_save_config_file(fileName.toStdString().c_str(), conf);
+}
+
+void KsCaptureControl::_browse()
+{
+	QString fileName =3D
+		QFileDialog::getSaveFileName(this,
+					     "Save File",
+					     KS_DIR,
+					     "trace-cmd files (*.dat);;All files (*)");
+
+	if (!fileName.isEmpty())
+		_outputLineEdit.setText(fileName);
+}
+
+void KsCaptureControl::_apply()
+{
+	emit argsReady(getArgs().join(" "));
+}
+
+/** @brief Create KsCaptureMonitor widget. */
+KsCaptureMonitor::KsCaptureMonitor(QWidget *parent)
+: QWidget(parent),
+  _mergedChannels(false),
+  _argsModified(false),
+  _panel(this),
+  _name("Output display", this),
+  _space("max size ", this),
+  _readOnlyCB("read only", this),
+  _maxLinNumEdit(QString("%1").arg(KS_CAP_MON_MAX_LINE_NUM), this),
+  _consolOutput("", this)
+{
+	_panel.setMaximumHeight(FONT_HEIGHT * 1.75);
+	_panel.addWidget(&_name);
+
+	_space.setAlignment(Qt::AlignRight);
+	_panel.addWidget(&_space);
+
+	_maxLinNumEdit.setFixedWidth(FONT_WIDTH * 7);
+	_panel.addWidget(&_maxLinNumEdit);
+	_panel.addSeparator();
+	_readOnlyCB.setCheckState(Qt::Checked);
+	_panel.addWidget(&_readOnlyCB);
+	_layout.addWidget(&_panel);
+
+	_consolOutput.setStyleSheet("QLabel {background-color : white;}");
+	_consolOutput.setMinimumWidth(FONT_WIDTH * 60);
+	_consolOutput.setMinimumHeight(FONT_HEIGHT * 10);
+	_consolOutput.setMaximumBlockCount(KS_CAP_MON_MAX_LINE_NUM);
+
+	_space.setMinimumWidth(FONT_WIDTH * 50 - _name.width() - _readOnlyCB.widt=
h());
+	_consolOutput.setReadOnly(true);
+	_layout.addWidget(&_consolOutput);
+
+	this->setLayout(&_layout);
+
+	connect(&_maxLinNumEdit,	&QLineEdit::textChanged,
+		this,			&KsCaptureMonitor::_maxLineNumber);
+
+	connect(&_readOnlyCB,		&QCheckBox::stateChanged,
+		this,			&KsCaptureMonitor::_readOnly);
+
+	connect(&_consolOutput,		&QPlainTextEdit::textChanged,
+		this,			&KsCaptureMonitor::_argVModified);
+
+	this->show();
+}
+
+void KsCaptureMonitor::_maxLineNumber(const QString &test)
+{
+	bool ok;
+	int max =3D test.toInt(&ok);
+
+	if (ok)
+		_consolOutput.setMaximumBlockCount(max);
+}
+
+void KsCaptureMonitor::_readOnly(int state)
+{
+	if (state =3D=3D Qt::Checked)
+		_consolOutput.setReadOnly(true);
+	else
+		_consolOutput.setReadOnly(false);
+}
+
+void KsCaptureMonitor::_argsReady(const QString &args)
+{
+	_name.setText("Capture options:");
+	_consolOutput.setPlainText(args);
+	_argsModified =3D false;
+}
+
+void KsCaptureMonitor::_argVModified()
+{
+	_argsModified =3D true;
+}
+
+void KsCaptureMonitor::_printAllStandardError()
+{
+	QProcess *_capture =3D (QProcess*) sender();
+
+	_consolOutput.moveCursor(QTextCursor::End);
+	_consolOutput.insertPlainText(_capture->readAllStandardError());
+	_consolOutput.moveCursor(QTextCursor::End);
+	QCoreApplication::processEvents();
+}
+
+void KsCaptureMonitor::_printAllStandardOutput()
+{
+	QProcess *_capture =3D (QProcess*) sender();
+
+	if (!_mergedChannels)
+		return;
+
+	_consolOutput.appendPlainText(_capture->readAllStandardOutput());
+	QCoreApplication::processEvents();
+}
+
+/**
+ * Connect the Capture monitor widget to the signals of the recording proc=
ess.
+ */
+void KsCaptureMonitor::connectMe(QProcess *proc, KsCaptureControl *ctrl)
+{
+	connect(proc,	&QProcess::started,
+		this,	&KsCaptureMonitor::_captureStarted);
+
+	/* Using the old Signal-Slot syntax because QProcess::finished has overlo=
ads. */
+	connect(proc,	SIGNAL(finished(int, QProcess::ExitStatus)),
+		this,	SLOT(_captureFinished(int, QProcess::ExitStatus)));
+
+	connect(proc,	&QProcess::readyReadStandardError,
+		this,	&KsCaptureMonitor::_printAllStandardError);
+
+	connect(proc,	&QProcess::readyReadStandardOutput,
+		this,	&KsCaptureMonitor::_printAllStandardOutput);
+
+	connect(ctrl,	&KsCaptureControl::argsReady,
+		this,	&KsCaptureMonitor::_argsReady);
+}
+
+void KsCaptureMonitor::_captureStarted()
+{
+	_name.setText("Terminal output:");
+	_readOnlyCB.setCheckState(Qt::Checked);
+
+	QCoreApplication::processEvents();
+}
+
+void KsCaptureMonitor::_captureFinished(int exit, QProcess::ExitStatus sta=
tus)
+{
+	QProcess *_capture =3D (QProcess *)sender();
+
+	if (exit !=3D 0 || status !=3D QProcess::NormalExit) {
+		QString errMessage("Capture process failed: ");
+
+		errMessage +=3D _capture->errorString();
+		_consolOutput.appendPlainText(errMessage);
+
+		QCoreApplication::processEvents();
+	}
+}
+
+/** Print a message. */
+void KsCaptureMonitor::print(const QString &message)
+{
+	_consolOutput.appendPlainText(message);
+}
+
+/** @brief Create KsCaptureDialog widget. */
+KsCaptureDialog::KsCaptureDialog(QWidget *parent)
+: QWidget(parent),
+  _captureCtrl(this),
+  _captureMon(this),
+  _captureProc(this)
+{
+	QString captureExe(TRACECMD_BIN_DIR);
+
+	this->setWindowTitle("Capture");
+	_layout.addWidget(&_captureCtrl);
+	_layout.addWidget(&_captureMon);
+	this->setLayout(&_layout);
+
+	connect(&_captureCtrl._commandCheckBox,	&QCheckBox::stateChanged,
+		this,				&KsCaptureDialog::_setChannelMode);
+
+	connect(&_captureCtrl._captureButton,	&QPushButton::pressed,
+		this,				&KsCaptureDialog::_capture);
+
+	connect(&_captureCtrl._closeButton,	&QPushButton::pressed,
+		this,				&KsCaptureDialog::close);
+
+	captureExe +=3D "/trace-cmd";
+	_captureProc.setProgram(captureExe);
+
+	_captureMon.connectMe(&_captureProc, &_captureCtrl);
+}
+
+void KsCaptureDialog::_capture()
+{
+	QStringList argv;
+	int argc;
+
+	if(_captureMon._argsModified) {
+		argv =3D _captureMon.text().split(" ");
+	} else {
+		argv =3D _captureCtrl.getArgs();
+	}
+
+	_captureMon.print("\n");
+	_captureMon.print(QString("trace-cmd " + argv.join(" ") + "\n"));
+	_captureProc.setArguments(argv);
+	_captureProc.start();
+	_captureProc.waitForFinished();
+
+	argc =3D argv.count();
+	for (int i =3D 0; i < argc; ++i) {
+		if (argv[i] =3D=3D "-o") {
+			_sendOpenReq(argv[i + 1]);
+			break;
+		}
+	}
+
+	/* Reset the _argsModified flag. */
+	_captureMon._argsModified =3D false;
+}
+
+void KsCaptureDialog::_setChannelMode(int state)
+{
+	if (state > 0) {
+		_captureMon._mergedChannels =3D true;
+	} else {
+		_captureMon._mergedChannels =3D false;
+	}
+}
+
+void KsCaptureDialog::_sendOpenReq(const QString &fileName)
+{
+	QLocalSocket *socket =3D new QLocalSocket(this);
+
+	socket->connectToServer("KSCapture", QIODevice::WriteOnly);
+	if (socket->waitForConnected()) {
+		QByteArray block;
+		QDataStream out(&block, QIODevice::WriteOnly);
+		const QString message =3D fileName;
+
+		out << quint32(message.size());
+		out << message;
+
+		socket->write(block);
+		socket->flush();
+		socket->disconnectFromServer();
+	} else {
+		_captureMon.print(socket->errorString());
+	}
+}
diff --git a/kernel-shark-qt/src/KsCaptureDialog.hpp b/kernel-shark-qt/src/=
KsCaptureDialog.hpp
new file mode 100644
index 0000000..d65f475
--- /dev/null
+++ b/kernel-shark-qt/src/KsCaptureDialog.hpp
@@ -0,0 +1,185 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsCaptureDialog.hpp
+ *  @brief   Dialog for trace data recording.
+ */
+
+#ifndef _KS_CAPTURE_H
+#define _KS_CAPTURE_H
+
+// Qt
+#include <QtWidgets>
+
+// KernelShark
+#include "KsWidgetsLib.hpp"
+
+/**
+ * The KsCaptureControl class provides a control panel for the KernelShark
+ * Capture dialog.
+ */
+class KsCaptureControl : public QWidget
+{
+	Q_OBJECT
+public:
+	explicit KsCaptureControl(QWidget *parent =3D 0);
+
+	QStringList getArgs();
+
+	/** Get the name of the tracing data output file. */
+	QString outputFileName() const {return _outputLineEdit.text();}
+
+	/** Set the name of the tracing data output file. */
+	void setOutputFileName(const QString &f) {_outputLineEdit.setText(f);}
+
+signals:
+	/** This signal is emitted when the "Apply" button is pressed. */
+	void argsReady(const QString &args);
+
+private:
+	tep_handle		*_localTEP;
+
+	KsEventsCheckBoxWidget	_eventsWidget;
+
+	QVBoxLayout	_topLayout;
+
+	QGridLayout	_execLayout;
+
+	QLabel		_pluginsLabel, _outputLabel, _commandLabel;
+
+	QLineEdit	_outputLineEdit, _commandLineEdit;
+
+	QToolBar	_settingsToolBar, _controlToolBar;
+
+	QComboBox	_pluginsComboBox;
+
+	QPushButton	_importSettingsButton, _exportSettingsButton;
+
+	QPushButton	_outputBrowseButton;
+
+	QStringList _getPlugins();
+
+	void _importSettings();
+
+	void _exportSettings();
+
+	void _browse();
+
+	void _apply();
+
+public:
+	/**
+	 * A Check box used to indicate if the output of the command needs to
+	 * be shown by the KsCaptureMonitor widget.
+	 */
+	QCheckBox	_commandCheckBox;
+
+	/** Capture button for the control panel. */
+	QPushButton	_captureButton;
+
+	/** Apply button for the control panel. */
+	QPushButton	_applyButton;
+
+	/** Close button for the control panel. */
+	QPushButton	_closeButton;
+};
+
+/**
+ * The KsCaptureMonitor class provides a terminal-like widget for monitori=
ng
+ * the tracing data recording process.
+ */
+class KsCaptureMonitor : public QWidget
+{
+	Q_OBJECT
+public:
+	explicit KsCaptureMonitor(QWidget *parent =3D 0);
+
+	/** Get the text shown by the widget. */
+	QString text() const {return _consolOutput.toPlainText();}
+
+	/** Clear the text shown by the widget. */
+	void clear() {_consolOutput.clear();}
+
+	void print(const QString &message);
+
+	void connectMe(QProcess *proc, KsCaptureControl *ctrl);
+
+	/** A flag indicating if the stdout and stderr channels are _merged. */
+	bool		_mergedChannels;
+
+	/**
+	 * A flag indicating, if the list of the command line arguments for trace=
-cmd
+	 * has been edited by the user.
+	 */
+	bool		_argsModified;
+
+private:
+	QVBoxLayout	_layout;
+
+	QToolBar	_panel;
+
+	QLabel		_name, _space;
+
+	QCheckBox	_readOnlyCB;
+
+	QLineEdit	_maxLinNumEdit;
+
+	QPlainTextEdit	_consolOutput;
+
+	void _argsReady(const QString &test);
+
+	void _maxLineNumber(const QString &test);
+
+	void _readOnly(int);
+
+	void _argVModified();
+
+	void _captureStarted();
+
+	void _printAllStandardError();
+
+	void _printAllStandardOutput();
+
+private slots:
+	void _captureFinished(int, QProcess::ExitStatus);
+};
+
+/** Default number of lines shown by the KsCaptureMonitor widget. */
+#define KS_CAP_MON_MAX_LINE_NUM 200
+
+/**
+ * The KsCaptureDialog class provides a dialog for recording of tracing da=
ta.
+ */
+class KsCaptureDialog : public QWidget
+{
+	Q_OBJECT
+public:
+	explicit KsCaptureDialog(QWidget *parent =3D 0);
+
+	/** Set the name of the tracing data output file. */
+	void setOutputFileName(const QString &f)
+	{
+		_captureCtrl.setOutputFileName(f);
+	}
+
+private:
+	QHBoxLayout		_layout;
+
+	KsCaptureControl	_captureCtrl;
+
+	KsCaptureMonitor	_captureMon;
+
+	QProcess		_captureProc;
+
+	void _capture();
+
+	void _setChannelMode(int state);
+
+	void _sendOpenReq(const QString &fileName);
+};
+
+#endif // _KS_CAPTURE_H
--=20
2.17.1
