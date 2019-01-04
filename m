Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-eopbgr790047.outbound.protection.outlook.com ([40.107.79.47]:5504
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726050AbfADT7r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Jan 2019 14:59:47 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 2/4] kernel-shark-qt: Cosmetic modifications in
 KsQuickContextMenu
Date: Fri, 4 Jan 2019 19:57:52 +0000
Message-ID: <20190104195726.24264-2-ykaradzhov@vmware.com>
References: <20190104195726.24264-1-ykaradzhov@vmware.com>
In-Reply-To: <20190104195726.24264-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch does the following minor modifications in
KsQuickContextMenu:
1. Removes the "Apply to list/graph" check-boxes.
2. Swaps the position of the Show / Hide actions
3. Adds "clear all filters" action.

The code that adds the check-boxes is commented out, because we may
change our opinion in the future.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsQuickContextMenu.cpp | 94 ++++++++++++----------
 kernel-shark-qt/src/KsQuickContextMenu.hpp |  4 +-
 2 files changed, 54 insertions(+), 44 deletions(-)

diff --git a/kernel-shark-qt/src/KsQuickContextMenu.cpp b/kernel-shark-qt/s=
rc/KsQuickContextMenu.cpp
index 6c9c9ef..3d190f3 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.cpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.cpp
@@ -62,7 +62,7 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data,=
 size_t row,
   _addTaskPlotAction(this),
   _removeCPUPlotAction(this),
   _removeTaskPlotAction(this),
-  _deselectAction(this)
+  _clearAllFilters(this)
 {
 	typedef void (KsQuickContextMenu::*mfp)();
 	QString taskName, parentName, descr;
@@ -87,37 +87,45 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *dat=
a, size_t row,
=20
 	parentName =3D parent->metaObject()->className();
=20
-	addSection("Pointer menu");
+	addSection("Pointer filter menu");
+
+// 	if (parentName =3D=3D "KsTraceViewer" &&
+// 	    list =3D dynamic_cast<KsTraceViewer *>(parent))) {
+// 		_graphSyncCBox =3D
+// 			KsUtils::addCheckBoxToMenu(this, "Apply filters to Graph");
+//
+// 		connect(_graphSyncCBox,	&QCheckBox::stateChanged,
+// 					&KsUtils::graphFilterSync);
+//
+// 		/*
+// 		 * By defauls the filters will be append to the List (Table)
+// 		 * only.
+// 		 */
+// 		KsUtils::listFilterSync(true);
+// 		KsUtils::graphFilterSync(false);
+// 		_graphSyncCBox->setChecked(false);
+// 	}
+
+// 	if (parentName =3D=3D "KsTraceGraph" &&
+// 	    (graphs =3D dynamic_cast<KsTraceGraph *>(parent))) {
+// 		_listSyncCBox =3D
+// 			KsUtils::addCheckBoxToMenu(this, "Apply filters to List");
+//
+// 		connect(_listSyncCBox,	&QCheckBox::stateChanged,
+// 					&KsUtils::listFilterSync);
+//
+// 		/* By defauls the filters will be append to the Graph only. */
+// 		KsUtils::graphFilterSync(true);
+// 		KsUtils::listFilterSync(false);
+// 		_listSyncCBox->setChecked(false);
+// 	}
=20
-	if (parentName =3D=3D "KsTraceViewer") {
-		_graphSyncCBox =3D
-			KsUtils::addCheckBoxToMenu(this, "Apply filters to Graph");
-
-		connect(_graphSyncCBox,	&QCheckBox::stateChanged,
-					&KsUtils::graphFilterSync);
-
-		/*
-		 * By defauls the filters will be append to the List (Table)
-		 * only.
-		 */
-		KsUtils::listFilterSync(true);
-		KsUtils::graphFilterSync(false);
-		_graphSyncCBox->setChecked(false);
-	}
-
-	if (parentName =3D=3D "KsTraceGraph" &&
-	    (graphs =3D dynamic_cast<KsTraceGraph *>(parent))) {
-		_listSyncCBox =3D
-			KsUtils::addCheckBoxToMenu(this, "Apply filters to List");
-
-		connect(_listSyncCBox,	&QCheckBox::stateChanged,
-					&KsUtils::listFilterSync);
-
-		/* By defauls the filters will be append to the Graph only. */
-		KsUtils::graphFilterSync(true);
-		KsUtils::listFilterSync(false);
-		_listSyncCBox->setChecked(false);
-	}
+	descr =3D "Show task [";
+	descr +=3D taskName;
+	descr +=3D "-";
+	descr +=3D QString("%1").arg(pid);
+	descr +=3D "] only";
+	lamAddAction(&_showTaskAction, &KsQuickContextMenu::_showTask);
=20
 	descr =3D "Hide task [";
 	descr +=3D taskName;
@@ -126,30 +134,30 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *d=
ata, size_t row,
 	descr +=3D "]";
 	lamAddAction(&_hideTaskAction, &KsQuickContextMenu::_hideTask);
=20
-	descr =3D "Show task [";
-	descr +=3D taskName;
-	descr +=3D "-";
-	descr +=3D QString("%1").arg(pid);
+	descr =3D "Show event [";
+	descr +=3D kshark_get_event_name_easy(_data->rows()[_row]);
 	descr +=3D "] only";
-	lamAddAction(&_showTaskAction, &KsQuickContextMenu::_showTask);
+	lamAddAction(&_showEventAction, &KsQuickContextMenu::_showEvent);
=20
 	descr =3D "Hide event [";
 	descr +=3D kshark_get_event_name_easy(_data->rows()[_row]);
 	descr +=3D "]";
 	lamAddAction(&_hideEventAction, &KsQuickContextMenu::_hideEvent);
=20
-	descr =3D "Show event [";
-	descr +=3D kshark_get_event_name_easy(_data->rows()[_row]);
-	descr +=3D "] only";
-	lamAddAction(&_showEventAction, &KsQuickContextMenu::_showEvent);
+	if (parentName =3D=3D "KsTraceViewer") {
+		descr =3D QString("Show CPU [%1] only").arg(cpu);
+		lamAddAction(&_showCPUAction, &KsQuickContextMenu::_showCPU);
+	}
=20
 	descr =3D QString("Hide CPU [%1]").arg(_data->rows()[_row]->cpu);
 	lamAddAction(&_hideCPUAction, &KsQuickContextMenu::_hideCPU);
=20
-	if (parentName =3D=3D "KsTraceViewer") {
-		descr =3D QString("Show CPU [%1] only").arg(cpu);
-		lamAddAction(&_showCPUAction, &KsQuickContextMenu::_showCPU);
+	descr =3D "Clear all filters";
+	lamAddAction(&_clearAllFilters, &KsQuickContextMenu::_clearFilters);
=20
+	addSection("Pointer plot menu");
+
+	if (parentName =3D=3D "KsTraceViewer") {
 		descr =3D "Add [";
 		descr +=3D taskName;
 		descr +=3D "-";
diff --git a/kernel-shark-qt/src/KsQuickContextMenu.hpp b/kernel-shark-qt/s=
rc/KsQuickContextMenu.hpp
index f5a2a78..df8a65b 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.hpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.hpp
@@ -85,6 +85,8 @@ private:
=20
 	QVector<int> _getFilterVector(tracecmd_filter_id *filter, int newId);
=20
+	void _clearFilters() {_data->clearAllFilters();}
+
 	KsDataStore	*_data;
=20
 	size_t		_row;
@@ -105,7 +107,7 @@ private:
=20
 	QAction _removeTaskPlotAction;
=20
-	QAction _deselectAction;
+	QAction _clearAllFilters;
 };
=20
 /**
--=20
2.17.1
