Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36304 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729044AbfAJNoe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jan 2019 08:44:34 -0500
Received: by mail-wm1-f66.google.com with SMTP id p6so12074488wmc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jan 2019 05:44:32 -0800 (PST)
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/5] kernel-shark-qt: Add "clear all filters" action to KsQuickContextMenu
Date: Thu, 10 Jan 2019 15:44:18 +0200
Message-Id: <20190110134419.20247-5-ykaradzhov@vmware.com>
In-Reply-To: <20190110134419.20247-1-ykaradzhov@vmware.com>
References: <20190110134419.20247-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

A quick access to this action can save time and be very useful.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsQuickContextMenu.cpp | 6 +++++-
 kernel-shark-qt/src/KsQuickContextMenu.hpp | 4 ++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel-shark-qt/src/KsQuickContextMenu.cpp b/kernel-shark-qt/src/KsQuickContextMenu.cpp
index 7ab5a5f..231ca38 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.cpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.cpp
@@ -61,7 +61,8 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
   _addCPUPlotAction(this),
   _addTaskPlotAction(this),
   _removeCPUPlotAction(this),
-  _removeTaskPlotAction(this)
+  _removeTaskPlotAction(this),
+  _clearAllFilters(this)
 {
 	typedef void (KsQuickContextMenu::*mfp)();
 	QString taskName, parentName, descr;
@@ -120,6 +121,9 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
 	descr = QString("Hide CPU [%1]").arg(_data->rows()[_row]->cpu);
 	lamAddAction(&_hideCPUAction, &KsQuickContextMenu::_hideCPU);
 
+	descr = "Clear all filters";
+	lamAddAction(&_clearAllFilters, &KsQuickContextMenu::_clearFilters);
+
 	if (parentName == "KsTraceViewer") {
 		descr = "Add [";
 		descr += taskName;
diff --git a/kernel-shark-qt/src/KsQuickContextMenu.hpp b/kernel-shark-qt/src/KsQuickContextMenu.hpp
index 670d010..df8a65b 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.hpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.hpp
@@ -85,6 +85,8 @@ private:
 
 	QVector<int> _getFilterVector(tracecmd_filter_id *filter, int newId);
 
+	void _clearFilters() {_data->clearAllFilters();}
+
 	KsDataStore	*_data;
 
 	size_t		_row;
@@ -104,6 +106,8 @@ private:
 	QAction _removeCPUPlotAction;
 
 	QAction _removeTaskPlotAction;
+
+	QAction _clearAllFilters;
 };
 
 /**
-- 
2.17.1
