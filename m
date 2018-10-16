Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-cys01nam02on0072.outbound.protection.outlook.com ([104.47.37.72]:24316
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727263AbeJPXq4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:46:56 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 21/23] kernel-shark-qt: Add Record dialog to KS GUI.
Date: Tue, 16 Oct 2018 15:53:22 +0000
Message-ID: <20181016155232.5257-22-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

A Record dialog is added to the Tools menu of the KernelShark GUI.
The Record dialog can be used only after installing the project
(sudo make install).

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsMainWindow.cpp | 128 +++++++++++++++++++++++++++
 kernel-shark-qt/src/KsMainWindow.hpp |  22 +++++
 2 files changed, 150 insertions(+)

diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsM=
ainWindow.cpp
index b9fb587..b3cbc3b 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -28,6 +28,7 @@
 #include "libkshark.h"
 #include "KsCmakeDef.hpp"
 #include "KsMainWindow.hpp"
+#include "KsCaptureDialog.hpp"
 #include "KsAdvFilteringDialog.hpp"
=20
 /** Create KernelShark Main window. */
@@ -39,6 +40,8 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _graph(this),
   _mState(this),
   _plugins(this),
+  _capture(this),
+  _captureLocalServer(this),
   _openAction("Open", this),
   _restorSessionAction("Restor Last Session", this),
   _importSessionAction("Import Session", this),
@@ -56,6 +59,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _cpuSelectAction("CPUs", this),
   _taskSelectAction("Tasks", this),
   _pluginsAction("Plugins", this),
+  _captureAction("Record", this),
   _colorAction(this),
   _colSlider(this),
   _colorPhaseSlider(Qt::Horizontal, this),
@@ -67,6 +71,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 	setWindowTitle("Kernel Shark");
 	_createActions();
 	_createMenus();
+	_initCapture();
=20
 	_splitter.addWidget(&_graph);
 	_splitter.addWidget(&_view);
@@ -215,6 +220,13 @@ void KsMainWindow::_createActions()
 	connect(&_pluginsAction,	&QAction::triggered,
 		this,			&KsMainWindow::_pluginSelect);
=20
+	_captureAction.setIcon(QIcon::fromTheme("media-record"));
+	_captureAction.setShortcut(tr("Ctrl+R"));
+	_captureAction.setStatusTip("Capture trace data");
+
+	connect(&_captureAction,	&QAction::triggered,
+		this,			&KsMainWindow::_record);
+
 	_colorPhaseSlider.setMinimum(20);
 	_colorPhaseSlider.setMaximum(180);
 	_colorPhaseSlider.setValue(KsPlot::Color::getRainbowFrequency() * 100);
@@ -321,6 +333,7 @@ void KsMainWindow::_createMenus()
 	/* Tools menu */
 	tools =3D menuBar()->addMenu("Tools");
 	tools->addAction(&_pluginsAction);
+	tools->addAction(&_captureAction);
 	tools->addSeparator();
 	tools->addAction(&_colorAction);
 	tools->addAction(&_fullScreenModeAction);
@@ -690,6 +703,29 @@ void KsMainWindow::_pluginSelect()
 	dialog->show();
 }
=20
+void KsMainWindow::_record()
+{
+#ifndef DO_AS_ROOT
+
+	QErrorMessage *em =3D new QErrorMessage(this);
+	QString message;
+
+	message =3D "Record is currently not supported.";
+	message +=3D " Install \"pkexec\" and then do:<br>";
+	message +=3D " cd build <br> sudo ./cmake_uninstall.sh <br>";
+	message +=3D " ./cmake_clean.sh <br> cmake .. <br> make <br>";
+	message +=3D " sudo make install";
+
+	em->showMessage(message);
+	qCritical() << "ERROR: " << message;
+
+	return;
+
+#endif
+
+	_capture.start();
+}
+
 void KsMainWindow::_setColorPhase(int f)
 {
 	KsPlot::Color::setRainbowFrequency(f / 100.);
@@ -895,6 +931,98 @@ void KsMainWindow::loadSession(const QString &fileName=
)
 	_colorPhaseSlider.setValue(_session.getColorScheme() * 100);
 }
=20
+void KsMainWindow::_initCapture()
+{
+#ifdef DO_AS_ROOT
+
+	_capture.setProgram("kshark-su-record");
+
+	connect(&_capture,	&QProcess::started,
+		this,		&KsMainWindow::_captureStarted);
+
+	/*
+	 * Using the old Signal-Slot syntax because QProcess::finished has
+	 * overloads.
+	 */
+	connect(&_capture,	SIGNAL(finished(int, QProcess::ExitStatus)),
+		this,		SLOT(_captureFinished(int, QProcess::ExitStatus)));
+
+	connect(&_capture,	&QProcess::errorOccurred,
+		this,		&KsMainWindow::_captureError);
+
+	connect(&_captureLocalServer,	&QLocalServer::newConnection,
+		this,			&KsMainWindow::_readSocket);
+
+#endif
+}
+
+void KsMainWindow::_captureStarted()
+{
+	_captureLocalServer.listen("KSCapture");
+}
+
+void KsMainWindow::_captureFinished(int exit, QProcess::ExitStatus st)
+{
+	QProcess *capture =3D (QProcess *)sender();
+
+	_captureLocalServer.close();
+
+	if (exit !=3D 0 || st !=3D QProcess::NormalExit) {
+		QString message =3D "Capture process failed:<br>";
+
+		message +=3D capture->errorString();
+		message +=3D "<br>Try doing:<br> sudo make install";
+
+		_error(message, "captureFinishedErr", false, false);
+	}
+}
+
+void KsMainWindow::_captureError(QProcess::ProcessError error)
+{
+	QProcess *capture =3D (QProcess *)sender();
+	QString message =3D "Capture process failed:<br>";
+
+	message +=3D capture->errorString();
+	message +=3D "<br>Try doing:<br> sudo make install";
+
+	_error(message, "captureFinishedErr", false, false);
+}
+
+void KsMainWindow::_readSocket()
+{
+	QLocalSocket *socket;
+	quint32 blockSize;
+	QString fileName;
+
+	auto lamSocketError =3D [&](QString message)
+	{
+		message =3D "ERROR from Local Server: " + message;
+		_error(message, "readSocketErr", false, false);
+	};
+
+	socket =3D _captureLocalServer.nextPendingConnection();
+	if (!socket) {
+		lamSocketError("Pending connectio not found!");
+		return;
+	}
+
+	QDataStream in(socket);
+	socket->waitForReadyRead();
+	if (socket->bytesAvailable() < (int)sizeof(quint32)) {
+		lamSocketError("Message size is corrupted!");
+		return;
+	};
+
+	in >> blockSize;
+	if (socket->bytesAvailable() < blockSize || in.atEnd()) {
+		lamSocketError("Message is corrupted!");
+		return;
+	}
+
+	in >> fileName;
+	loadDataFile(fileName);
+}
+
 void KsMainWindow::_splitterMoved(int pos, int index)
 {
 	_session.saveSplitterSize(_splitter);
diff --git a/kernel-shark-qt/src/KsMainWindow.hpp b/kernel-shark-qt/src/KsM=
ainWindow.hpp
index 6e3f864..0e14c80 100644
--- a/kernel-shark-qt/src/KsMainWindow.hpp
+++ b/kernel-shark-qt/src/KsMainWindow.hpp
@@ -14,6 +14,7 @@
=20
 // Qt
 #include <QMainWindow>
+#include <QLocalServer>
=20
 // KernelShark
 #include "KsTraceViewer.hpp"
@@ -81,6 +82,12 @@ private:
 	/** Plugin manager. */
 	KsPluginManager	_plugins;
=20
+	/** The process used to record trace data. */
+	QProcess	_capture;
+
+	/** Local Server used for comunucation with the Capture process. */
+	QLocalServer	_captureLocalServer;
+
 	// File menu.
 	QAction		_openAction;
=20
@@ -119,6 +126,8 @@ private:
 	// Tools menu.
 	QAction		_pluginsAction;
=20
+	QAction		_captureAction;
+
 	QWidgetAction	_colorAction;
=20
 	QWidget		_colSlider;
@@ -166,6 +175,8 @@ private:
=20
 	void _pluginSelect();
=20
+	void _record();
+
 	void _setColorPhase(int);
=20
 	void _fullScreenMode();
@@ -174,18 +185,29 @@ private:
=20
 	void _contents();
=20
+	void _captureStarted();
+
+	void _captureError(QProcess::ProcessError error);
+
+	void _readSocket();
+
 	void _splitterMoved(int pos, int index);
=20
 	void _createActions();
=20
 	void _createMenus();
=20
+	void _initCapture();
+
 	void _updateSession();
=20
 	inline void _resizeEmpty() {resize(SCREEN_WIDTH * .5, FONT_HEIGHT * 3);}
=20
 	void _error(const QString &text, const QString &errCode,
 		    bool resize, bool unloadPlugins);
+
+private slots:
+	void _captureFinished(int, QProcess::ExitStatus);
 };
=20
 #endif // _KS_MAINWINDOW_H
--=20
2.17.1
