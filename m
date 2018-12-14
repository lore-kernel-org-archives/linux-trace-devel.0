Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr800084.outbound.protection.outlook.com ([40.107.80.84]:60384
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729816AbeLNMwn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 07:52:43 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 5/8] kernel-shark-qt: Create "Apply filter XX" checkboxes
 in KsUtils
Date: Fri, 14 Dec 2018 12:52:39 +0000
Message-ID: <20181214125212.9637-6-ykaradzhov@vmware.com>
References: <20181214125212.9637-1-ykaradzhov@vmware.com>
In-Reply-To: <20181214125212.9637-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The code responsible for the creation of the "Apply filters to Graph"
and "Apply filters to List" checkboxes (showing in the "Filtering" menu),
has been moved outside of the KsMainWindow class and is now available
in KsUtils. This is done because we want to have the same checkboxes
available in the KsQuickContextMenu.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsMainWindow.cpp | 39 +++++++++++++---------------
 kernel-shark-qt/src/KsMainWindow.hpp |  6 ++---
 kernel-shark-qt/src/KsUtils.cpp      | 25 ++++++++++++++++++
 kernel-shark-qt/src/KsUtils.hpp      |  2 ++
 4 files changed, 47 insertions(+), 25 deletions(-)

diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsM=
ainWindow.cpp
index 7213c01..142cd1f 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -49,9 +49,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _quitAction("Quit", this),
   _importFilterAction("Import Filter", this),
   _exportFilterAction("Export Filter", this),
-  _graphFilterSyncAction(this),
   _graphFilterSyncCBox(nullptr),
-  _listFilterSyncAction(this),
   _listFilterSyncCBox(nullptr),
   _showEventsAction("Show events", this),
   _showTasksAction("Show tasks", this),
@@ -292,22 +290,13 @@ void KsMainWindow::_createMenus()
=20
 	/* Filter menu */
 	filter =3D menuBar()->addMenu("Filter");
+
+	connect(filter, 		&QMenu::aboutToShow,
+		this,			&KsMainWindow::_updateFilterMenu);
+
 	filter->addAction(&_importFilterAction);
 	filter->addAction(&_exportFilterAction);
=20
-	auto lamMakeCBAction =3D [&](QWidgetAction *action, QString name)
-	{
-		QWidget  *containerWidget =3D new QWidget(filter);
-		containerWidget->setLayout(new QHBoxLayout());
-		containerWidget->layout()->setContentsMargins(FONT_WIDTH, FONT_HEIGHT/5,
-							      FONT_WIDTH, FONT_HEIGHT/5);
-		QCheckBox *checkBox =3D new QCheckBox(name, filter);
-		checkBox->setChecked(true);
-		containerWidget->layout()->addWidget(checkBox);
-		action->setDefaultWidget(containerWidget);
-		return checkBox;
-	};
-
 	/*
 	 * Set the default filter mask. Filter will apply to both View and
 	 * Graph.
@@ -317,20 +306,20 @@ void KsMainWindow::_createMenus()
=20
 	kshark_ctx->filter_mask |=3D KS_EVENT_VIEW_FILTER_MASK;
=20
-	_graphFilterSyncCBox =3D lamMakeCBAction(&_graphFilterSyncAction,
-					       "Apply filters to Graph");
+	_graphFilterSyncCBox =3D
+		KsUtils::addCheckBoxToMenu(filter, "Apply filters to Graph");
+	_graphFilterSyncCBox->setChecked(true);
=20
 	connect(_graphFilterSyncCBox,	&QCheckBox::stateChanged,
 		this,			&KsMainWindow::_graphFilterSync);
=20
-	_listFilterSyncCBox =3D lamMakeCBAction(&_listFilterSyncAction,
-					      "Apply filters to List");
+	_listFilterSyncCBox =3D
+		KsUtils::addCheckBoxToMenu(filter, "Apply filters to List");
+	_listFilterSyncCBox->setChecked(true);
=20
 	connect(_listFilterSyncCBox,	&QCheckBox::stateChanged,
 		this,			&KsMainWindow::_listFilterSync);
=20
-	filter->addAction(&_graphFilterSyncAction);
-	filter->addAction(&_listFilterSyncAction);
 	filter->addAction(&_showEventsAction);
 	filter->addAction(&_showTasksAction);
 	filter->addAction(&_hideTasksAction);
@@ -446,6 +435,14 @@ void KsMainWindow::_filterSyncCBoxUpdate(kshark_contex=
t *kshark_ctx)
 		_graphFilterSyncCBox->setChecked(false);
 }
=20
+void KsMainWindow::_updateFilterMenu()
+{
+	kshark_context *kshark_ctx(nullptr);
+
+	if (kshark_instance(&kshark_ctx))
+		_filterSyncCBoxUpdate(kshark_ctx);
+}
+
 void KsMainWindow::_importFilter()
 {
 	kshark_context *kshark_ctx(nullptr);
diff --git a/kernel-shark-qt/src/KsMainWindow.hpp b/kernel-shark-qt/src/KsM=
ainWindow.hpp
index 72f7059..301acc9 100644
--- a/kernel-shark-qt/src/KsMainWindow.hpp
+++ b/kernel-shark-qt/src/KsMainWindow.hpp
@@ -110,12 +110,8 @@ private:
=20
 	QAction		_exportFilterAction;
=20
-	QWidgetAction	_graphFilterSyncAction;
-
 	QCheckBox	*_graphFilterSyncCBox;
=20
-	QWidgetAction	_listFilterSyncAction;
-
 	QCheckBox	*_listFilterSyncCBox;
=20
 	QAction		_showEventsAction;
@@ -222,6 +218,8 @@ private:
=20
 	void _deselect();
=20
+	void _updateFilterMenu();
+
 	void _filterSyncCBoxUpdate(kshark_context *kshark_ctx);
=20
 private slots:
diff --git a/kernel-shark-qt/src/KsUtils.cpp b/kernel-shark-qt/src/KsUtils.=
cpp
index 2ebbae3..0298010 100644
--- a/kernel-shark-qt/src/KsUtils.cpp
+++ b/kernel-shark-qt/src/KsUtils.cpp
@@ -95,6 +95,31 @@ void graphFilterSync(bool state)
 	}
 }
=20
+
+/**
+ * @brief Add a checkbox to a menu.
+ *
+ * @param menu: Input location for the menu object, to which the checkbox =
will be added.
+ * @param name: The name of the checkbox.
+ *
+ * @returns The checkbox object;
+ */
+QCheckBox *addCheckBoxToMenu(QMenu *menu, QString name)
+{
+	QWidget  *containerWidget =3D new QWidget(menu);
+	containerWidget->setLayout(new QHBoxLayout());
+	containerWidget->layout()->setContentsMargins(FONT_WIDTH, FONT_HEIGHT/5,
+						      FONT_WIDTH, FONT_HEIGHT/5);
+	QCheckBox *checkBox =3D new QCheckBox(name, menu);
+	containerWidget->layout()->addWidget(checkBox);
+
+	QWidgetAction *action =3D new QWidgetAction(menu);
+	action->setDefaultWidget(containerWidget);
+	menu->addAction(action);
+
+	return checkBox;
+}
+
 /**
  * @brief Simple CPU matching function to be user for data collections.
  *
diff --git a/kernel-shark-qt/src/KsUtils.hpp b/kernel-shark-qt/src/KsUtils.=
hpp
index 052cc71..cb95b4f 100644
--- a/kernel-shark-qt/src/KsUtils.hpp
+++ b/kernel-shark-qt/src/KsUtils.hpp
@@ -93,6 +93,8 @@ void listFilterSync(bool state);
=20
 void graphFilterSync(bool state);
=20
+QCheckBox *addCheckBoxToMenu(QMenu *menu, QString name);
+
 /** @brief Convert the timestamp of the trace record into a string showing
  *	   the time in seconds.
  *
--=20
2.17.1
