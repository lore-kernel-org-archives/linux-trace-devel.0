Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XeMULDTG"
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F2F182
	for <linux-trace-devel@vger.kernel.org>; Sun, 19 Nov 2023 09:45:23 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-32f7bd27c2aso2695746f8f.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 19 Nov 2023 09:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700415922; x=1701020722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p33dpruh+jVbgmvTTmquT4VFGOeic/Ba/AOEhHph4XQ=;
        b=XeMULDTGuyB9z7Q+ebnjBL4T9m9IuOHnJYb4NnbTZeV5uogjlIxD4qyXQNwCnQNm6R
         /X4xrtQCk9XAH+jzfs7V88pEld7ZUvFD8/5tuu9wfwVO2V1LWAOXHBr+2EV5zq6DBXEf
         R3E5l/0etgfYIo2p6F+Y5nmIsIwGExhETl2t1Y3EMBKDE9aJQZNLbNvT0vVnxPkY/+Yy
         TkrDBJYQroYQsSY4+LpCe6fHlXDEzKUdo0k3Gmz33u0HMALKefn1rgTEpHR0kJdDSHnY
         BNqB0/xLJaZlsFm2iaikIx6ZFjRhN9ZPGmAfmJ4KkSNu/YPDP/guy9YWMm17walezIwu
         jsPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700415922; x=1701020722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p33dpruh+jVbgmvTTmquT4VFGOeic/Ba/AOEhHph4XQ=;
        b=j6LBnkEc6fVTFvtYF6uNDO5O4ebecjU73MP8cQI95Q0vp1AjxbgUIWTDhOfq/+uQRl
         dxFHdds+Pri7pXItZpkGuPRaovfU23Z/i8BUkt23pL/3FSuoI7nKrg0bn1lBBujDt5R7
         TNemWElXoveGRfbSJa7tMRVTQfyyMcu/zjEFONxSAwNIfkd/sqd5+YBb6ca8gHSL2yen
         KPJTHdoIJ5hTlA6y4sx2mX/EaeL+B8QTJWr3x54rbEIXKt3yzF3BmaifYn2HG7J5Npm4
         dYU/9lhX+jQJ7ZIVZP2Zj/+D1k+Kcwxf4WI3vNXMWghKveMWAAaBtZeTY2bK3/I6qDkc
         iAZQ==
X-Gm-Message-State: AOJu0YwRyT6pK5+ik5j8Dt0WuwSgZCpym0pLHta2y7P+8FkRpqhxzU7W
	aT5m/gmGFhnGUWNPYR0E769qSnSzLug=
X-Google-Smtp-Source: AGHT+IF7Qms3cfL0r6KCXvnQlcMZr/eBDULltA1gzXr8SsWAVksYrVqaEJimXt2x8unb2+rr6c8eCQ==
X-Received: by 2002:a5d:47ab:0:b0:332:c514:641f with SMTP id 11-20020a5d47ab000000b00332c514641fmr1096945wrb.13.1700415921367;
        Sun, 19 Nov 2023 09:45:21 -0800 (PST)
Received: from belmeken.. (83-228-63-4.ip.btc-net.bg. [83.228.63.4])
        by smtp.gmail.com with ESMTPSA id az30-20020adfe19e000000b00332c36b6563sm2375869wrb.101.2023.11.19.09.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Nov 2023 09:45:20 -0800 (PST)
From: Yordan Karadzhov <y.karadz@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: Porting KernelShark to Qt 6
Date: Sun, 19 Nov 2023 19:45:16 +0200
Message-ID: <20231119174516.34045-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Addressing all changes to Qt from the previous version (Qt5) to Qt6.

Signed-off-by: Yordan Karadzhov <y.karadz@gmail.com>
---
 .github/workflows/main.yml     |  2 +-
 CMakeLists.txt                 | 21 ++-------------------
 README                         |  6 +++---
 build/cmake_clean.sh           |  1 +
 build/deff.h.cmake             |  4 ----
 examples/CMakeLists.txt        |  4 ++--
 src/CMakeLists.txt             | 12 +++++++-----
 src/KsAdvFilteringDialog.cpp   | 18 ++++++++----------
 src/KsAdvFilteringDialog.hpp   |  4 ++--
 src/KsCaptureDialog.cpp        |  5 ++---
 src/KsDualMarker.cpp           |  4 ++--
 src/KsDualMarker.hpp           |  1 +
 src/KsGLWidget.cpp             | 27 ++++++++-------------------
 src/KsGLWidget.hpp             |  1 +
 src/KsMainWindow.cpp           | 10 +++-------
 src/KsTraceViewer.cpp          | 16 ++++------------
 src/KsUtils.cpp                |  6 +++---
 src/KsUtils.hpp                | 19 +------------------
 src/KsWidgetsLib.cpp           | 25 +++++++++++++------------
 src/KsWidgetsLib.hpp           |  4 ++--
 src/kernelshark.cpp            |  1 -
 src/plugins/CMakeLists.txt     |  6 +++---
 src/plugins/KVMComboDialog.cpp |  7 ++++---
 src/plugins/KVMComboDialog.hpp |  2 +-
 tests/CMakeLists.txt           |  4 ++--
 25 files changed, 76 insertions(+), 134 deletions(-)

diff --git a/.github/workflows/main.yml b/.github/workflows/main.yml
index 925e235..2715381 100644
--- a/.github/workflows/main.yml
+++ b/.github/workflows/main.yml
@@ -23,7 +23,7 @@ jobs:
         sudo apt-get install build-essential git cmake libjson-c-dev -y
         sudo apt-get install freeglut3-dev libxmu-dev libxi-dev -y
         sudo apt-get install fonts-freefont-ttf
-        sudo apt-get install qtbase5-dev libboost-all-dev -y
+        sudo apt-get install qt6-base-dev qt6-scxml-dev libboost-all-dev -y
         git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
         cd libtraceevent
         make
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 2b9e5eb..9501db4 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -73,25 +73,8 @@ else (TT_FONT_FILE)
 
 endif (TT_FONT_FILE)
 
-find_package(Qt5Widgets 5.7.1)
-find_package(Qt5Network)
-if (Qt5Widgets_FOUND)
-
-    message(STATUS "Found Qt5Widgets:  (version ${Qt5Widgets_VERSION})")
-
-    if(Qt5Widgets_VERSION VERSION_LESS "5.11")
-
-        set(QT_VERSION_LESS_5_11 TRUE)
-
-    endif()
-
-    if(Qt5Widgets_VERSION VERSION_LESS "5.15")
-
-        set(QT_VERSION_LESS_5_15 TRUE)
-
-    endif()
-
-endif (Qt5Widgets_FOUND)
+find_package(Qt6Widgets 6.3.0)
+find_package(Qt6 COMPONENTS Network OpenGLWidgets StateMachine REQUIRED)
 
 find_package (Boost COMPONENTS unit_test_framework)
 
diff --git a/README b/README
index 1d8694a..d7019a3 100644
--- a/README
+++ b/README
@@ -7,7 +7,7 @@ The official repository is here:
 Third Party Software:
 ------------------------------------------------------------
 KernelShark has the following external dependencies:
-  Cmake, Json-C, OpenGL/Glut, Qt5Base, libtraceevent, libtracefs, trace-cmd
+  Cmake, Json-C, OpenGL/Glut, Qt6Base, libtraceevent, libtracefs, trace-cmd
   and FreeSans font.
 
 1. In order to install the packages on Ubuntu do the following:
@@ -15,7 +15,7 @@ KernelShark has the following external dependencies:
     sudo apt-get install freeglut3-dev libxmu-dev libxi-dev -y
     sudo apt-get install flex bison -y
     sudo apt-get install fonts-freefont-ttf -y
-    sudo apt-get install qtbase5-dev -y
+    sudo apt-get install qt6-base-dev qt6-scxml-dev -y
 
 1.1 If you want to be able to generate Doxygen documentation:
     sudo apt-get install graphviz doxygen-gui -y
@@ -26,7 +26,7 @@ KernelShark has the following external dependencies:
     sudo dnf install freeglut-devel redhat-rpm-config -y
     sudo dnf install flex bison -y
     sudo dnf install gnu-free-sans-fonts -y
-    sudo dnf install qt5-qtbase-devel -y
+    sudo dnf install qt6-qtbase-devel qt6-qtscxml-devel -y
 
 2.1 If you want to be able to generate Doxygen documentation:
     sudo dnf install graphviz doxygen -y
diff --git a/build/cmake_clean.sh b/build/cmake_clean.sh
index 8defa67..67afd6c 100755
--- a/build/cmake_clean.sh
+++ b/build/cmake_clean.sh
@@ -17,3 +17,4 @@ rm ../org.freedesktop.kshark-record.policy
 rm -f ../src/KsCmakeDef.hpp
 rm -f CMakeDoxyfile.in
 rm -f CMakeDoxygenDefaults.cmake
+rm -rf .qt/
diff --git a/build/deff.h.cmake b/build/deff.h.cmake
index 4302f00..c3aea29 100644
--- a/build/deff.h.cmake
+++ b/build/deff.h.cmake
@@ -32,10 +32,6 @@
 /** Truetype font file. */
 #cmakedefine TT_FONT_FILE "@TT_FONT_FILE@"
 
-/** Qt - old version detected. */
-#cmakedefine QT_VERSION_LESS_5_11
-#cmakedefine QT_VERSION_LESS_5_15
-
 /** Location of the KernelShark tests. */
 #cmakedefine KS_TEST_DIR "@KS_TEST_DIR@"
 
diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
index c2f4c01..aad2543 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
@@ -28,7 +28,7 @@ if (OPENGL_FOUND AND GLUT_FOUND)
 
 endif (OPENGL_FOUND AND GLUT_FOUND)
 
-if (Qt5Widgets_FOUND AND TT_FONT_FILE)
+if (Qt6Widgets_FOUND AND TT_FONT_FILE)
 
     message(STATUS "widgetdemo")
     add_executable(widgetdemo          widgetdemo.cpp)
@@ -38,4 +38,4 @@ if (Qt5Widgets_FOUND AND TT_FONT_FILE)
     add_executable(cmd_split           cmd_split.cpp)
     target_link_libraries(cmd_split    kshark-gui)
 
-endif (Qt5Widgets_FOUND AND TT_FONT_FILE)
+endif ()
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 0ee62c8..0643365 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -77,7 +77,7 @@ if (OPENGL_FOUND)
 
 endif (OPENGL_FOUND)
 
-if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
+if (Qt6Widgets_FOUND AND TT_FONT_FILE)
 
     message(STATUS "libkshark-gui")
     set (ks-guiLib_hdr  KsUtils.hpp
@@ -93,7 +93,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
                         KsQuickContextMenu.hpp
                         KsAdvFilteringDialog.hpp)
 
-    QT5_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
+    QT6_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
 
     add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp
                                                             KsModels.cpp
@@ -111,8 +111,10 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
                                                             KsAdvFilteringDialog.cpp)
 
     target_link_libraries(kshark-gui kshark-plot
-                                     Qt5::Widgets
-                                     Qt5::Network)
+                                     Qt6::Widgets
+                                     Qt6::Network
+                                     Qt6::OpenGLWidgets
+                                     Qt6::StateMachine)
 
 
     set_target_properties(kshark-gui PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
@@ -157,4 +159,4 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
 
     find_program(DO_AS_ROOT pkexec)
 
-endif (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
+endif ()
diff --git a/src/KsAdvFilteringDialog.cpp b/src/KsAdvFilteringDialog.cpp
index 20412a7..b934db6 100644
--- a/src/KsAdvFilteringDialog.cpp
+++ b/src/KsAdvFilteringDialog.cpp
@@ -88,15 +88,11 @@ KsAdvFilteringDialog::KsAdvFilteringDialog(QWidget *parent)
 	_condToolBar1.addWidget(&_systemComboBox);
 	_condToolBar1.addWidget(&_eventComboBox);
 
-	/*
-	 * Using the old Signal-Slot syntax because QComboBox::currentIndexChanged
-	 * has overloads.
-	 */
-	connect(&_systemComboBox,	SIGNAL(currentIndexChanged(const QString&)),
-		this,			SLOT(_systemChanged(const QString&)));
+	connect(&_systemComboBox,	&QComboBox::currentIndexChanged,
+		this,			&KsAdvFilteringDialog::_systemChanged);
 
-	connect(&_eventComboBox,	SIGNAL(currentIndexChanged(const QString&)),
-		this,			SLOT(_eventChanged(const QString&)));
+	connect(&_eventComboBox,	&QComboBox::currentIndexChanged,
+		this,			&KsAdvFilteringDialog::_eventChanged);
 
 	_setSystemCombo(kshark_ctx);
 
@@ -320,8 +316,9 @@ void KsAdvFilteringDialog::_help()
 	}
 }
 
-void KsAdvFilteringDialog::_systemChanged(const QString &sysName)
+void KsAdvFilteringDialog::_systemChanged(int)
 {
+	QString sysName = _systemComboBox.currentText();
 	kshark_context *kshark_ctx(NULL);
 	kshark_data_stream *stream;
 	QStringList evtsList, name;
@@ -372,9 +369,10 @@ KsAdvFilteringDialog::_getEventFields(int eventId)
 	return fieldList;
 }
 
-void KsAdvFilteringDialog::_eventChanged(const QString &evtName)
+void KsAdvFilteringDialog::_eventChanged(int)
 {
 	QString sysName = _systemComboBox.currentText();
+	QString evtName = _eventComboBox.currentText();
 	QStringList fieldList, eventName;
 	kshark_context *kshark_ctx(NULL);
 	kshark_data_stream *stream;
diff --git a/src/KsAdvFilteringDialog.hpp b/src/KsAdvFilteringDialog.hpp
index a1db90b..a23e8d9 100644
--- a/src/KsAdvFilteringDialog.hpp
+++ b/src/KsAdvFilteringDialog.hpp
@@ -89,9 +89,9 @@ private:
 	kshark_data_stream *_getCurrentStream(kshark_context *kshark_ctx);
 
 private slots:
-	void _systemChanged(const QString&);
+	void _systemChanged(int);
 
-	void _eventChanged(const QString&);
+	void _eventChanged(int);
 };
 
 #endif // _KS_ADV_FILTERING_DIALOG_H
diff --git a/src/KsCaptureDialog.cpp b/src/KsCaptureDialog.cpp
index 651f811..973fafb 100644
--- a/src/KsCaptureDialog.cpp
+++ b/src/KsCaptureDialog.cpp
@@ -492,9 +492,8 @@ void KsCaptureMonitor::connectMe(QProcess *proc, KsCaptureControl *ctrl)
 	connect(proc,	&QProcess::started,
 		this,	&KsCaptureMonitor::_captureStarted);
 
-	/* Using the old Signal-Slot syntax because QProcess::finished has overloads. */
-	connect(proc,	SIGNAL(finished(int, QProcess::ExitStatus)),
-		this,	SLOT(_captureFinished(int, QProcess::ExitStatus)));
+	connect(proc,	&QProcess::finished,
+		this,	&KsCaptureMonitor::_captureFinished);
 
 	connect(proc,	&QProcess::readyReadStandardError,
 		this,	&KsCaptureMonitor::_printAllStandardError);
diff --git a/src/KsDualMarker.cpp b/src/KsDualMarker.cpp
index 9fb68e7..c02614c 100644
--- a/src/KsDualMarker.cpp
+++ b/src/KsDualMarker.cpp
@@ -179,7 +179,7 @@ KsDualMarkerSM::KsDualMarkerSM(QWidget *parent)
 	/* Define transitions from State A to State B. */
 	_stateA->addTransition(this,	&KsDualMarkerSM::machineToB, _stateB);
 
-	_scCtrlA.setKey(Qt::CTRL + Qt::Key_A);
+	_scCtrlA.setKey(Qt::SHIFT | Qt::Key_A);
 	_stateA->addTransition(&_scCtrlB, &QShortcut::activated, _stateB);
 
 	connect(&_scCtrlA,	&QShortcut::activated,
@@ -196,7 +196,7 @@ KsDualMarkerSM::KsDualMarkerSM(QWidget *parent)
 	/* Define transitions from State B to State A. */
 	_stateB->addTransition(this,	&KsDualMarkerSM::machineToA, _stateA);
 
-	_scCtrlB.setKey(Qt::CTRL + Qt::Key_B);
+	_scCtrlB.setKey(Qt::SHIFT | Qt::Key_B);
 	_stateB->addTransition(&_scCtrlA, &QShortcut::activated, _stateA);
 
 	connect(&_scCtrlB,	&QShortcut::activated,
diff --git a/src/KsDualMarker.hpp b/src/KsDualMarker.hpp
index 39c0ce2..73c3960 100644
--- a/src/KsDualMarker.hpp
+++ b/src/KsDualMarker.hpp
@@ -14,6 +14,7 @@
 
 // Qt
 #include <QtWidgets>
+#include <QStateMachine>
 
 // KernelShark
 #include "KsUtils.hpp"
diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
index 1c71ecb..023d1c8 100644
--- a/src/KsGLWidget.cpp
+++ b/src/KsGLWidget.cpp
@@ -52,11 +52,8 @@ KsGLWidget::KsGLWidget(QWidget *parent)
 {
 	setMouseTracking(true);
 
-	/*
-	 * Using the old Signal-Slot syntax because QWidget::update has
-	 * overloads.
-	 */
-	connect(&_model, SIGNAL(modelReset()), this, SLOT(update()));
+	connect(&_model,	&QAbstractTableModel::modelReset,
+		this,		&KsGLWidget::update);
 }
 
 void KsGLWidget::_freeGraphs()
@@ -86,7 +83,7 @@ KsGLWidget::~KsGLWidget()
 /** Reimplemented function used to set up all required OpenGL resources. */
 void KsGLWidget::initializeGL()
 {
-	_dpr = QApplication::desktop()->devicePixelRatio();
+	_dpr = QApplication::primaryScreen()->devicePixelRatio();
 	ksplot_init_opengl(_dpr);
 
 	ksplot_init_font(&_font, 15, TT_FONT_FILE);
@@ -345,15 +342,7 @@ void KsGLWidget::wheelEvent(QWheelEvent * event)
 		 * Use the position of the mouse as a focus point for the
 		 * zoom.
 		 */
-#ifdef QT_VERSION_LESS_5_15
-
-	zoomFocus = event->pos().x() - _bin0Offset();
-
-#else
-
-	zoomFocus = event->position().x() - _bin0Offset();
-
-#endif // QT_VERSION_LESS_5_15
+		zoomFocus = event->position().x() - _bin0Offset();
 	}
 
 	if (event->angleDelta().y() > 0) {
@@ -627,12 +616,12 @@ int KsGLWidget::_getMaxLabelSize()
 		int sd = it.key();
 		for (auto const &pid: it.value()._taskList) {
 			size = _font.char_width *
-			       KsUtils::taskPlotName(sd, pid).count();
+			       KsUtils::taskPlotName(sd, pid).size();
 			max = (size > max) ? size : max;
 		}
 
 		for (auto const &cpu: it.value()._cpuList) {
-			size = _font.char_width * KsUtils::cpuPlotName(cpu).count();
+			size = _font.char_width * KsUtils::cpuPlotName(cpu).size();
 			max = (size > max) ? size : max;
 		}
 	}
@@ -641,12 +630,12 @@ int KsGLWidget::_getMaxLabelSize()
 		for (auto const &p: c) {
 			if (p._type & KSHARK_TASK_DRAW) {
 				size = _font.char_width *
-					KsUtils::taskPlotName(p._streamId, p._id).count();
+					KsUtils::taskPlotName(p._streamId, p._id).size();
 
 				max = (size > max) ? size : max;
 			} else if (p._type & KSHARK_CPU_DRAW) {
 				size = _font.char_width *
-				       KsUtils::cpuPlotName(p._id).count();
+				       KsUtils::cpuPlotName(p._id).size();
 
 				max = (size > max) ? size : max;
 			}
diff --git a/src/KsGLWidget.hpp b/src/KsGLWidget.hpp
index 6a72a35..03bd5eb 100644
--- a/src/KsGLWidget.hpp
+++ b/src/KsGLWidget.hpp
@@ -14,6 +14,7 @@
 
 // Qt
 #include <QRubberBand>
+#include <QOpenGLWidget>
 
 // KernelShark
 #include "KsUtils.hpp"
diff --git a/src/KsMainWindow.cpp b/src/KsMainWindow.cpp
index da1c0af..ef15b20 100644
--- a/src/KsMainWindow.cpp
+++ b/src/KsMainWindow.cpp
@@ -144,7 +144,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 	connect(&_plugins,	&KsPluginManager::dataReload,
 		&_data,		&KsDataStore::reload);
 
-	_deselectShortcut.setKey(Qt::CTRL + Qt::Key_D);
+	_deselectShortcut.setKey(Qt::CTRL | Qt::Key_D);
 	connect(&_deselectShortcut,	&QShortcut::activated,
 		this,			&KsMainWindow::_deselectActive);
 
@@ -1502,12 +1502,8 @@ void KsMainWindow::_initCapture()
 	connect(&_capture,	&QProcess::started,
 		this,		&KsMainWindow::_captureStarted);
 
-	/*
-	 * Using the old Signal-Slot syntax because QProcess::finished has
-	 * overloads.
-	 */
-	connect(&_capture,	SIGNAL(finished(int, QProcess::ExitStatus)),
-		this,		SLOT(_captureFinished(int, QProcess::ExitStatus)));
+	connect(&_capture,	&QProcess::finished,
+		this,		&KsMainWindow::_captureFinished);
 
 	_captureErrorConnection =
 		connect(&_capture,	&QProcess::errorOccurred,
diff --git a/src/KsTraceViewer.cpp b/src/KsTraceViewer.cpp
index 05f5461..d4c9dd9 100644
--- a/src/KsTraceViewer.cpp
+++ b/src/KsTraceViewer.cpp
@@ -93,19 +93,11 @@ KsTraceViewer::KsTraceViewer(QWidget *parent)
 	_toolbar.addWidget(&_labelSearch);
 	_searchFSM._columnComboBox.addItems(_model.header());
 
-	/*
-	 * Using the old Signal-Slot syntax because
-	 * QComboBox::currentIndexChanged has overloads.
-	 */
-	connect(&_searchFSM._columnComboBox,	SIGNAL(currentIndexChanged(int)),
-		this,				SLOT(_searchEdit(int)));
+	connect(&_searchFSM._columnComboBox,	&QComboBox::currentIndexChanged,
+		this,				&KsTraceViewer::_searchEdit);
 
-	/*
-	 * Using the old Signal-Slot syntax because
-	 * QComboBox::currentIndexChanged has overloads.
-	 */
-	connect(&_searchFSM._selectComboBox,	SIGNAL(currentIndexChanged(int)),
-		this,				SLOT(_searchEdit(int)));
+	connect(&_searchFSM._selectComboBox,	&QComboBox::currentIndexChanged,
+		this,				&KsTraceViewer::_searchEdit);
 
 	/* On the toolbar, make a Line edit field for search. */
 	_searchFSM._searchLineEdit.setMaximumWidth(FONT_WIDTH * 20);
diff --git a/src/KsUtils.cpp b/src/KsUtils.cpp
index e3e16ae..a68e4c1 100644
--- a/src/KsUtils.cpp
+++ b/src/KsUtils.cpp
@@ -489,12 +489,12 @@ QStringList splitArguments(QString cmd)
 	auto opt = KS_SPLIT_SkipEmptyParts;
 	int i, progress = 0, size;
 	QStringList argv;
-	QChar quote = 0;
+	QChar quote{'\0'};
 
 	/* Remove all new lines. */
 	cmd.replace("\\\n", " ");
 
-	size = cmd.count();
+	size = cmd.size();
 	auto lamMid = [&] () {return cmd.mid(progress, i - progress);};
 	for (i = 0; i < size; ++i) {
 		if (cmd[i] == '\\') {
@@ -510,7 +510,7 @@ QStringList splitArguments(QString cmd)
 				progress = i;
 			} else if (quote == cmd[i]) {
 				argv << lamMid();
-				quote = 0;
+				quote = {'\0'};
 				progress = ++i;
 			}
 		}
diff --git a/src/KsUtils.hpp b/src/KsUtils.hpp
index e42b6da..85f81c3 100644
--- a/src/KsUtils.hpp
+++ b/src/KsUtils.hpp
@@ -44,16 +44,7 @@ static auto stringWidth = [](QString s)
 {
 	QFont font;
 	QFontMetrics fm(font);
-
-#ifdef QT_VERSION_LESS_5_11
-
-	return fm.width(s);
-
-#else
-
 	return fm.horizontalAdvance(s);
-
-#endif // QT_VERSION_LESS_5_11
 };
 
 //! @endcond
@@ -86,15 +77,7 @@ typedef std::chrono::high_resolution_clock::time_point  hd_time;
 std::chrono::duration_cast<std::chrono::duration<double>>( \
 std::chrono::high_resolution_clock::now() - t0).count()
 
-#ifdef QT_VERSION_LESS_5_15
-
-	#define KS_SPLIT_SkipEmptyParts QString::SkipEmptyParts
-
-#else
-
-	#define KS_SPLIT_SkipEmptyParts Qt::SkipEmptyParts
-
-#endif // QT_VERSION_LESS_5_15
+#define KS_SPLIT_SkipEmptyParts Qt::SkipEmptyParts
 
 //! @endcond
 
diff --git a/src/KsWidgetsLib.cpp b/src/KsWidgetsLib.cpp
index 7b3192d..3ad93fa 100644
--- a/src/KsWidgetsLib.cpp
+++ b/src/KsWidgetsLib.cpp
@@ -253,13 +253,13 @@ KsTimeOffsetDialog::KsTimeOffsetDialog(QWidget *parent)
 	connect(&_input,	&QDialog::rejected,
 		this,		&QWidget::close);
 
-	connect(&_streamCombo,	SIGNAL(currentIndexChanged(int)),
-		SLOT(_setDefault(int)));
+	connect(&_streamCombo,	&QComboBox::currentIndexChanged,
+		this,		&KsTimeOffsetDialog::_setDefault);
 
 	show();
 }
 
-void KsTimeOffsetDialog::_setDefault(int index) {
+void KsTimeOffsetDialog::_setDefault(int) {
 	int sd = _streamCombo.currentData().toInt();
 	kshark_context *kshark_ctx(nullptr);
 	struct kshark_data_stream *stream;
@@ -1174,7 +1174,7 @@ KsPluginCheckBoxWidget::KsPluginCheckBoxWidget(int sd, QStringList pluginList,
 	_id.resize(nPlgins);
 
 	for (int i = 0; i < nPlgins; ++i) {
-		if (pluginList[i] < 30) {
+		if (pluginList[i].size() < 30) {
 			nameItem = new QTableWidgetItem(pluginList[i]);
 		} else {
 			QLabel l;
@@ -1257,7 +1257,7 @@ KsDStreamCheckBoxWidget::KsDStreamCheckBoxWidget(QWidget *parent)
 	for (int i = 0; i < nStreams; ++i) {
 		stream = kshark_ctx->stream[streamIds[i]];
 		QString name = KsUtils::streamDescription(stream);
-		if (name < 40) {
+		if (name.size() < 40) {
 			nameItem = new QTableWidgetItem(name);
 		} else {
 			QLabel l;
@@ -1303,8 +1303,8 @@ KsEventFieldSelectWidget::KsEventFieldSelectWidget(QWidget *parent)
 	 * Using the old Signal-Slot syntax because QComboBox::currentIndexChanged
 	 * has overloads.
 	 */
-	connect(&_streamComboBox,	SIGNAL(currentIndexChanged(const QString&)),
-		this,			SLOT(_streamChanged(const QString&)));
+	connect(&_streamComboBox,	&QComboBox::currentIndexChanged,
+		this,			&KsEventFieldSelectWidget::_streamChanged);
 
 	lamAddLine();
 
@@ -1318,8 +1318,8 @@ KsEventFieldSelectWidget::KsEventFieldSelectWidget(QWidget *parent)
 	 * Using the old Signal-Slot syntax because QComboBox::currentIndexChanged
 	 * has overloads.
 	 */
-	connect(&_eventComboBox,	SIGNAL(currentIndexChanged(const QString&)),
-		this,			SLOT(_eventChanged(const QString&)));
+	connect(&_eventComboBox,	&QComboBox::currentIndexChanged,
+		this,			&KsEventFieldSelectWidget::_eventChanged);
 
 	lamAddLine();
 
@@ -1349,7 +1349,7 @@ void KsEventFieldSelectWidget::setStreamCombo()
 	}
 }
 
-void KsEventFieldSelectWidget::_streamChanged(const QString &streamFile)
+void KsEventFieldSelectWidget::_streamChanged(int)
 {
 	int sd = _streamComboBox.currentData().toInt();
 	QVector<int> eventIds = KsUtils::getEventIdList(sd);
@@ -1364,10 +1364,11 @@ void KsEventFieldSelectWidget::_streamChanged(const QString &streamFile)
 	_eventComboBox.addItems(evtsList);
 }
 
-void KsEventFieldSelectWidget::_eventChanged(const QString &eventName)
+void KsEventFieldSelectWidget::_eventChanged(int)
 {
 	int sd = _streamComboBox.currentData().toInt();
-	int eventId = KsUtils::getEventId(sd, eventName);
+	QString evtName = _eventComboBox.currentText();
+	int eventId = KsUtils::getEventId(sd, evtName);
 	QStringList fieldsList = KsUtils::getEventFieldsList(sd, eventId);
 
 	auto lamIsValide = [&] (const QString &f) {
diff --git a/src/KsWidgetsLib.hpp b/src/KsWidgetsLib.hpp
index 2cc3535..cc2dc99 100644
--- a/src/KsWidgetsLib.hpp
+++ b/src/KsWidgetsLib.hpp
@@ -635,9 +635,9 @@ public:
 	void setStreamCombo();
 
 private slots:
-	void _streamChanged(const QString &stream);
+	void _streamChanged(int);
 
-	void _eventChanged(const QString &event);
+	void _eventChanged(int);
 
 private:
 	QVBoxLayout	_topLayout;
diff --git a/src/kernelshark.cpp b/src/kernelshark.cpp
index 1ad15f4..2ec7b1c 100644
--- a/src/kernelshark.cpp
+++ b/src/kernelshark.cpp
@@ -55,7 +55,6 @@ int main(int argc, char **argv)
 	QString taskList;
 	int c;
 
-	QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
 	QApplication::setDesktopFileName(KS_APP_NAME);
 	QApplication a(argc, argv);
 
diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
index 49aee3e..53c4b2e 100644
--- a/src/plugins/CMakeLists.txt
+++ b/src/plugins/CMakeLists.txt
@@ -28,7 +28,7 @@ function(BUILD_GUI_PLUGIN)
 
     message(STATUS ${ADD_PLUGIN_NAME})
 
-    QT5_WRAP_CPP(plugin_moc ${ADD_PLUGIN_MOC})
+    QT6_WRAP_CPP(plugin_moc ${ADD_PLUGIN_MOC})
 
     add_library(${ADD_PLUGIN_NAME} SHARED ${plugin_moc} ${ADD_PLUGIN_SOURCE})
     set_target_properties(${ADD_PLUGIN_NAME} PROPERTIES PREFIX "plugin-")
@@ -38,7 +38,7 @@ endfunction()
 
 set(PLUGIN_LIST "")
 
-if (Qt5Widgets_FOUND AND TT_FONT_FILE)
+if (Qt6Widgets_FOUND AND TT_FONT_FILE)
 
     BUILD_GUI_PLUGIN(NAME sched_events
                      SOURCE sched_events.c SchedEvents.cpp)
@@ -59,7 +59,7 @@ if (Qt5Widgets_FOUND AND TT_FONT_FILE)
                      SOURCE kvm_combo.c KVMCombo.cpp KVMComboDialog.cpp)
     list(APPEND PLUGIN_LIST "kvm_combo")
 
-endif (Qt5Widgets_FOUND AND TT_FONT_FILE)
+endif ()
 
 BUILD_GUI_PLUGIN(NAME missed_events
 		 SOURCE missed_events.c MissedEvents.cpp)
diff --git a/src/plugins/KVMComboDialog.cpp b/src/plugins/KVMComboDialog.cpp
index b3ec846..2b95a53 100644
--- a/src/plugins/KVMComboDialog.cpp
+++ b/src/plugins/KVMComboDialog.cpp
@@ -197,8 +197,8 @@ KsComboPlotDialog::KsComboPlotDialog(QWidget *parent)
 	 * Using the old Signal-Slot syntax because QComboBox::currentIndexChanged
 	 * has overloads.
 	 */
-	connect(&_guestStreamComboBox,	SIGNAL(currentIndexChanged(const QString &)),
-		this,			SLOT(_guestStreamChanged(const QString &)));
+	connect(&_guestStreamComboBox,	&QComboBox::currentIndexChanged,
+		this,			&KsComboPlotDialog::_guestStreamChanged);
 
 	setLayout(&_topLayout);
 
@@ -333,8 +333,9 @@ void KsComboPlotDialog::_setCurrentPlots(int sdGuest)
 	_vcpuTree.set(vcpuCBs);
 }
 
-void KsComboPlotDialog::_guestStreamChanged(const QString &sdStr)
+void KsComboPlotDialog::_guestStreamChanged(int)
 {
+	QString sdStr = _guestStreamComboBox.currentText();
 	if (sdStr.isEmpty())
 		return;
 
diff --git a/src/plugins/KVMComboDialog.hpp b/src/plugins/KVMComboDialog.hpp
index 52e7e92..b3047a0 100644
--- a/src/plugins/KVMComboDialog.hpp
+++ b/src/plugins/KVMComboDialog.hpp
@@ -83,7 +83,7 @@ private:
 
 private slots:
 
-	void _guestStreamChanged(const QString&);
+	void _guestStreamChanged(int);
 };
 
 #endif
diff --git a/tests/CMakeLists.txt b/tests/CMakeLists.txt
index 1814c72..eb7ccd5 100644
--- a/tests/CMakeLists.txt
+++ b/tests/CMakeLists.txt
@@ -38,7 +38,7 @@ add_test(NAME              "libkshark_tests"
          COMMAND           ${KS_TEST_DIR}/kshark-tests --log_format=HRF
          WORKING_DIRECTORY ${KS_TEST_DIR})
 
-if (Qt5Widgets_FOUND AND TT_FONT_FILE)
+if (Qt6Widgets_FOUND AND TT_FONT_FILE)
 
     add_executable(kshark-gui-tests          libkshark-gui-tests.cpp)
     target_include_directories(kshark-gui-tests PRIVATE ${Boost_INCLUDE_DIRS})
@@ -51,4 +51,4 @@ if (Qt5Widgets_FOUND AND TT_FONT_FILE)
              COMMAND           ${KS_TEST_DIR}/kshark-gui-tests --log_format=HRF
              WORKING_DIRECTORY ${KS_TEST_DIR})
 
-endif (Qt5Widgets_FOUND AND TT_FONT_FILE)
+endif ()
-- 
2.41.0

