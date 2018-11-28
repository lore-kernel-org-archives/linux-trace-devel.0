Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710075.outbound.protection.outlook.com ([40.107.71.75]:2944
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728732AbeK2CS3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:29 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 10/17] kernel-shark-qt: Add keyboard shortcuts for deselecting
 the marker
Date: Wed, 28 Nov 2018 15:16:19 +0000
Message-ID: <20181128151530.21965-11-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The active marker can now be deselected by pressing "Ctrl + D".

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsMainWindow.cpp       | 7 ++++++-
 kernel-shark-qt/src/KsMainWindow.hpp       | 2 ++
 kernel-shark-qt/src/KsQuickContextMenu.cpp | 2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsM=
ainWindow.cpp
index 5c9a0fa..f4804bd 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -65,7 +65,8 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _colorPhaseSlider(Qt::Horizontal, this),
   _fullScreenModeAction("Full Screen Mode", this),
   _aboutAction("About", this),
-  _contentsAction("Contents", this)
+  _contentsAction("Contents", this),
+  _deselectShortcut(this)
 {
 	setWindowTitle("Kernel Shark");
 	_createActions();
@@ -114,6 +115,10 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 	connect(&_plugins,	&KsPluginManager::dataReload,
 		&_data,		&KsDataStore::reload);
=20
+	_deselectShortcut.setKey(Qt::CTRL + Qt::Key_D);
+	connect(&_deselectShortcut,	&QShortcut::activated,
+		this,			&KsMainWindow::_deselect);
+
 	_resizeEmpty();
 }
=20
diff --git a/kernel-shark-qt/src/KsMainWindow.hpp b/kernel-shark-qt/src/KsM=
ainWindow.hpp
index b9b681f..5938a25 100644
--- a/kernel-shark-qt/src/KsMainWindow.hpp
+++ b/kernel-shark-qt/src/KsMainWindow.hpp
@@ -147,6 +147,8 @@ private:
=20
 	QAction		_contentsAction;
=20
+	QShortcut        _deselectShortcut;
+
 	void _open();
=20
 	void _restorSession();
diff --git a/kernel-shark-qt/src/KsQuickContextMenu.cpp b/kernel-shark-qt/s=
rc/KsQuickContextMenu.cpp
index 0a8e527..16b8d19 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.cpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.cpp
@@ -26,6 +26,8 @@ KsQuickMarkerMenu::KsQuickMarkerMenu(KsDualMarkerSM *dm, =
QWidget *parent)
 	if (dm->activeMarker()._isSet) {
 		addSection("Marker menu");
 		_deselectAction.setText("Deselect");
+		_deselectAction.setShortcut(tr("Ctrl+D"));
+		_deselectAction.setStatusTip(tr("Deselect marker"));
=20
 		connect(&_deselectAction,	&QAction::triggered,
 			this,			&KsQuickMarkerMenu::deselect);
--=20
2.17.1
