Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46427 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730249AbfAINKC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Jan 2019 08:10:02 -0500
Received: by mail-wr1-f68.google.com with SMTP id l9so7566042wrt.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Jan 2019 05:10:01 -0800 (PST)
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/6] kernel-shark-qt: Cosmetic modifications in KsQuickContextMenu
Date: Wed,  9 Jan 2019 15:09:41 +0200
Message-Id: <20190109130945.28519-3-ykaradzhov@vmware.com>
In-Reply-To: <20190109130945.28519-1-ykaradzhov@vmware.com>
References: <20190109130945.28519-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The following minor modifications in KsQuickContextMenu are introduced:

1. Removes the "Apply to list/graph" check-boxes.
2. Swaps the position of the Show / Hide actions
3. Adds "clear all filters" action.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsQuickContextMenu.cpp | 63 +++++++---------------
 kernel-shark-qt/src/KsQuickContextMenu.hpp |  4 +-
 2 files changed, 23 insertions(+), 44 deletions(-)

diff --git a/kernel-shark-qt/src/KsQuickContextMenu.cpp b/kernel-shark-qt/src/KsQuickContextMenu.cpp
index 6c9c9ef..728ecbd 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.cpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.cpp
@@ -62,7 +62,7 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
   _addTaskPlotAction(this),
   _removeCPUPlotAction(this),
   _removeTaskPlotAction(this),
-  _deselectAction(this)
+  _clearAllFilters(this)
 {
 	typedef void (KsQuickContextMenu::*mfp)();
 	QString taskName, parentName, descr;
@@ -87,37 +87,14 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
 
 	parentName = parent->metaObject()->className();
 
-	addSection("Pointer menu");
+	addSection("Pointer filter menu");
 
-	if (parentName == "KsTraceViewer") {
-		_graphSyncCBox =
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
-	if (parentName == "KsTraceGraph" &&
-	    (graphs = dynamic_cast<KsTraceGraph *>(parent))) {
-		_listSyncCBox =
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
+	descr = "Show task [";
+	descr += taskName;
+	descr += "-";
+	descr += QString("%1").arg(pid);
+	descr += "] only";
+	lamAddAction(&_showTaskAction, &KsQuickContextMenu::_showTask);
 
 	descr = "Hide task [";
 	descr += taskName;
@@ -126,30 +103,30 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
 	descr += "]";
 	lamAddAction(&_hideTaskAction, &KsQuickContextMenu::_hideTask);
 
-	descr = "Show task [";
-	descr += taskName;
-	descr += "-";
-	descr += QString("%1").arg(pid);
+	descr = "Show event [";
+	descr += kshark_get_event_name_easy(_data->rows()[_row]);
 	descr += "] only";
-	lamAddAction(&_showTaskAction, &KsQuickContextMenu::_showTask);
+	lamAddAction(&_showEventAction, &KsQuickContextMenu::_showEvent);
 
 	descr = "Hide event [";
 	descr += kshark_get_event_name_easy(_data->rows()[_row]);
 	descr += "]";
 	lamAddAction(&_hideEventAction, &KsQuickContextMenu::_hideEvent);
 
-	descr = "Show event [";
-	descr += kshark_get_event_name_easy(_data->rows()[_row]);
-	descr += "] only";
-	lamAddAction(&_showEventAction, &KsQuickContextMenu::_showEvent);
+	if (parentName == "KsTraceViewer") {
+		descr = QString("Show CPU [%1] only").arg(cpu);
+		lamAddAction(&_showCPUAction, &KsQuickContextMenu::_showCPU);
+	}
 
 	descr = QString("Hide CPU [%1]").arg(_data->rows()[_row]->cpu);
 	lamAddAction(&_hideCPUAction, &KsQuickContextMenu::_hideCPU);
 
-	if (parentName == "KsTraceViewer") {
-		descr = QString("Show CPU [%1] only").arg(cpu);
-		lamAddAction(&_showCPUAction, &KsQuickContextMenu::_showCPU);
+	descr = "Clear all filters";
+	lamAddAction(&_clearAllFilters, &KsQuickContextMenu::_clearFilters);
 
+	addSection("Pointer plot menu");
+
+	if (parentName == "KsTraceViewer") {
 		descr = "Add [";
 		descr += taskName;
 		descr += "-";
diff --git a/kernel-shark-qt/src/KsQuickContextMenu.hpp b/kernel-shark-qt/src/KsQuickContextMenu.hpp
index f5a2a78..df8a65b 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.hpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.hpp
@@ -85,6 +85,8 @@ private:
 
 	QVector<int> _getFilterVector(tracecmd_filter_id *filter, int newId);
 
+	void _clearFilters() {_data->clearAllFilters();}
+
 	KsDataStore	*_data;
 
 	size_t		_row;
@@ -105,7 +107,7 @@ private:
 
 	QAction _removeTaskPlotAction;
 
-	QAction _deselectAction;
+	QAction _clearAllFilters;
 };
 
 /**
-- 
2.17.1
