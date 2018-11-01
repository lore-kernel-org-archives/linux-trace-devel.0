Return-Path: <SRS0=g7z+=NM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810081.outbound.protection.outlook.com ([40.107.81.81]:10264
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727001AbeKBGub (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Nov 2018 02:50:31 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 6/8] kernel-shark-qt: Fix bug when resizing the KS window for
 session
Date: Thu, 1 Nov 2018 21:45:43 +0000
Message-ID: <20181101214512.18684-7-ykaradzhov@vmware.com>
References: <20181101214512.18684-1-ykaradzhov@vmware.com>
In-Reply-To: <20181101214512.18684-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Currently the session export/import code cannot deal with the case when
the KernelShark GUI is in Full Screen mode. This patch fixes this.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsMainWindow.cpp |  9 +++------
 kernel-shark-qt/src/KsMainWindow.hpp | 10 +++++++---
 kernel-shark-qt/src/KsSession.cpp    | 21 +++++++++++++++++----
 kernel-shark-qt/src/KsSession.hpp    |  4 +++-
 4 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsM=
ainWindow.cpp
index 4f9a6e2..89b1b58 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -64,7 +64,6 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _colSlider(this),
   _colorPhaseSlider(Qt::Horizontal, this),
   _fullScreenModeAction("Full Screen Mode", this),
-  _isFullScreen(false),
   _aboutAction("About", this),
   _contentsAction("Contents", this)
 {
@@ -245,7 +244,7 @@ void KsMainWindow::_createActions()
 	_fullScreenModeAction.setStatusTip("Full Screen Mode");
=20
 	connect(&_fullScreenModeAction,	&QAction::triggered,
-		this,			&KsMainWindow::_fullScreenMode);
+		this,			&KsMainWindow::_changeScreenMode);
=20
 	/* Help menu */
 	_aboutAction.setIcon(QIcon::fromTheme("help-about"));
@@ -732,18 +731,16 @@ void KsMainWindow::_setColorPhase(int f)
 	_graph.glPtr()->model()->update();
 }
=20
-void KsMainWindow::_fullScreenMode()
+void KsMainWindow::_changeScreenMode()
 {
-	if (_isFullScreen) {
+	if (isFullScreen()) {
 		_fullScreenModeAction.setText("Full Screen Mode");
 		_fullScreenModeAction.setIcon(QIcon::fromTheme("view-fullscreen"));
 		showNormal();
-		_isFullScreen =3D false;
 	} else {
 		_fullScreenModeAction.setText("Exit Full Screen Mode");
 		_fullScreenModeAction.setIcon(QIcon::fromTheme("view-restore"));
 		showFullScreen();
-		_isFullScreen =3D true;
 	}
 }
=20
diff --git a/kernel-shark-qt/src/KsMainWindow.hpp b/kernel-shark-qt/src/KsM=
ainWindow.hpp
index 0e14c80..d711ec1 100644
--- a/kernel-shark-qt/src/KsMainWindow.hpp
+++ b/kernel-shark-qt/src/KsMainWindow.hpp
@@ -61,6 +61,12 @@ public:
=20
 	void resizeEvent(QResizeEvent* event);
=20
+	/** Set the Full Screen mode. */
+	void setFullScreenMode(bool f) {
+		if ((!isFullScreen() && f) || (isFullScreen() && !f) )
+			_changeScreenMode();
+	}
+
 private:
 	QSplitter	_splitter;
=20
@@ -136,8 +142,6 @@ private:
=20
 	QAction		_fullScreenModeAction;
=20
-	bool		_isFullScreen;
-
 	// Help menu.
 	QAction		_aboutAction;
=20
@@ -179,7 +183,7 @@ private:
=20
 	void _setColorPhase(int);
=20
-	void _fullScreenMode();
+	void _changeScreenMode();
=20
 	void _aboutInfo();
=20
diff --git a/kernel-shark-qt/src/KsSession.cpp b/kernel-shark-qt/src/KsSess=
ion.cpp
index b7ef81c..2242a12 100644
--- a/kernel-shark-qt/src/KsSession.cpp
+++ b/kernel-shark-qt/src/KsSession.cpp
@@ -12,6 +12,7 @@
 // KernelShark
 #include "libkshark.h"
 #include "KsSession.hpp"
+#include "KsMainWindow.hpp"
=20
 /** Create a KsSession object. */
 KsSession::KsSession()
@@ -175,10 +176,15 @@ void KsSession::saveMainWindowSize(const QMainWindow =
&window)
 {
 	kshark_config_doc *windowConf =3D kshark_config_alloc(KS_CONFIG_JSON);
 	int width =3D window.width(), height =3D window.height();
-	json_object *jwindow =3D json_object_new_array();
+	json_object *jwindow;
=20
-	json_object_array_put_idx(jwindow, 0, json_object_new_int(width));
-	json_object_array_put_idx(jwindow, 1, json_object_new_int(height));
+	if (window.isFullScreen()) {
+		jwindow =3D json_object_new_string("FullScreen");
+	} else {
+		jwindow =3D json_object_new_array();
+		json_object_array_put_idx(jwindow, 0, json_object_new_int(width));
+		json_object_array_put_idx(jwindow, 1, json_object_new_int(height));
+	}
=20
 	windowConf->conf_doc =3D jwindow;
 	kshark_config_doc_add(_config, "MainWindow", windowConf);
@@ -189,7 +195,7 @@ void KsSession::saveMainWindowSize(const QMainWindow &w=
indow)
  *
  * @param window: Input location for the KsMainWindow widget.
  */
-void KsSession::loadMainWindowSize(QMainWindow *window)
+void KsSession::loadMainWindowSize(KsMainWindow *window)
 {
 	kshark_config_doc *windowConf =3D kshark_config_alloc(KS_CONFIG_JSON);
 	json_object *jwindow, *jwidth, *jheight;
@@ -200,12 +206,19 @@ void KsSession::loadMainWindowSize(QMainWindow *windo=
w)
=20
 	if (_config->format =3D=3D KS_CONFIG_JSON) {
 		jwindow =3D KS_JSON_CAST(windowConf->conf_doc);
+		if (json_object_get_type(jwindow) =3D=3D json_type_string &&
+		    QString(json_object_get_string(jwindow)) =3D=3D "FullScreen") {
+			window->setFullScreenMode(true);
+			return;
+		}
+
 		jwidth =3D json_object_array_get_idx(jwindow, 0);
 		jheight =3D json_object_array_get_idx(jwindow, 1);
=20
 		width =3D json_object_get_int(jwidth);
 		height =3D json_object_get_int(jheight);
=20
+		window->setFullScreenMode(false);
 		window->resize(width, height);
 	}
 }
diff --git a/kernel-shark-qt/src/KsSession.hpp b/kernel-shark-qt/src/KsSess=
ion.hpp
index 4f5a2c4..f5ed5a1 100644
--- a/kernel-shark-qt/src/KsSession.hpp
+++ b/kernel-shark-qt/src/KsSession.hpp
@@ -20,6 +20,8 @@
 #include "KsTraceGraph.hpp"
 #include "KsTraceViewer.hpp"
=20
+class KsMainWindow;
+
 /**
  * The KsSession class provides instruments for importing/exporting the st=
ate
  * of the different components of the GUI from/to Json documents. These
@@ -57,7 +59,7 @@ public:
=20
 	void saveMainWindowSize(const QMainWindow &window);
=20
-	void loadMainWindowSize(QMainWindow *window);
+	void loadMainWindowSize(KsMainWindow *window);
=20
 	void saveSplitterSize(const QSplitter &splitter);
=20
--=20
2.17.1
