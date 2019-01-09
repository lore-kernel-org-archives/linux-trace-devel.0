Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35611 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730250AbfAINKB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Jan 2019 08:10:01 -0500
Received: by mail-wr1-f65.google.com with SMTP id 96so7627234wrb.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Jan 2019 05:10:00 -0800 (PST)
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/6] kernel-shark-qt: Rearrange the "Filter" top menu
Date: Wed,  9 Jan 2019 15:09:40 +0200
Message-Id: <20190109130945.28519-2-ykaradzhov@vmware.com>
In-Reply-To: <20190109130945.28519-1-ykaradzhov@vmware.com>
References: <20190109130945.28519-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Now the "Filter" top menu contains only "Show Task" and "Show CPU"
menu actions ("Hide" versions are removed).

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsMainWindow.cpp | 46 ++++++++++++++++++++++------
 kernel-shark-qt/src/KsMainWindow.hpp |  6 ++--
 2 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsMainWindow.cpp
index a375126..8bb51a3 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -53,8 +53,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _listFilterSyncCBox(nullptr),
   _showEventsAction("Show events", this),
   _showTasksAction("Show tasks", this),
-  _hideTasksAction("Hide tasks", this),
-  _hideCPUsAction("Hide CPUs", this),
+  _showCPUsAction("Show CPUs", this),
   _advanceFilterAction("Advance Filtering", this),
   _clearAllFilters("Clear all filters", this),
   _cpuSelectAction("CPUs", this),
@@ -205,11 +204,8 @@ void KsMainWindow::_createActions()
 	connect(&_showTasksAction,	&QAction::triggered,
 		this,			&KsMainWindow::_showTasks);
 
-	connect(&_hideTasksAction,	&QAction::triggered,
-		this,			&KsMainWindow::_hideTasks);
-
-	connect(&_hideCPUsAction,	&QAction::triggered,
-		this,			&KsMainWindow::_hideCPUs);
+	connect(&_showCPUsAction,	&QAction::triggered,
+		this,			&KsMainWindow::_showCPUs);
 
 	connect(&_advanceFilterAction,	&QAction::triggered,
 		this,			&KsMainWindow::_advancedFiltering);
@@ -322,8 +318,7 @@ void KsMainWindow::_createMenus()
 
 	filter->addAction(&_showEventsAction);
 	filter->addAction(&_showTasksAction);
-	filter->addAction(&_hideTasksAction);
-	filter->addAction(&_hideCPUsAction);
+	filter->addAction(&_showCPUsAction);
 	filter->addAction(&_advanceFilterAction);
 	filter->addAction(&_clearAllFilters);
 
@@ -621,6 +616,39 @@ void KsMainWindow::_hideTasks()
 	dialog->show();
 }
 
+void KsMainWindow::_showCPUs()
+{
+	kshark_context *kshark_ctx(nullptr);
+	KsCheckBoxWidget *cpu_cbd;
+	KsCheckBoxDialog *dialog;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	cpu_cbd = new KsCPUCheckBoxWidget(_data.tep(), this);
+	dialog = new KsCheckBoxDialog(cpu_cbd, this);
+
+	if (!kshark_ctx->show_cpu_filter ||
+	    !kshark_ctx->show_cpu_filter->count) {
+		cpu_cbd->setDefault(true);
+	} else {
+		int nCPUs = tep_get_cpus(_data.tep());
+		QVector<bool> v(nCPUs, false);
+
+		for (int i = 0; i < nCPUs; ++i) {
+			if (tracecmd_filter_id_find(kshark_ctx->show_cpu_filter, i))
+				v[i] = true;
+		}
+
+		cpu_cbd->set(v);
+	}
+
+	connect(dialog,		&KsCheckBoxDialog::apply,
+		&_data,		&KsDataStore::applyPosCPUFilter);
+
+	dialog->show();
+}
+
 void KsMainWindow::_hideCPUs()
 {
 	kshark_context *kshark_ctx(nullptr);
diff --git a/kernel-shark-qt/src/KsMainWindow.hpp b/kernel-shark-qt/src/KsMainWindow.hpp
index 301acc9..44f7dd7 100644
--- a/kernel-shark-qt/src/KsMainWindow.hpp
+++ b/kernel-shark-qt/src/KsMainWindow.hpp
@@ -118,9 +118,7 @@ private:
 
 	QAction		_showTasksAction;
 
-	QAction		_hideTasksAction;
-
-	QAction		_hideCPUsAction;
+	QAction		_showCPUsAction;
 
 	QAction		_advanceFilterAction;
 
@@ -173,6 +171,8 @@ private:
 
 	void _hideTasks();
 
+	void _showCPUs();
+
 	void _hideCPUs();
 
 	void _advancedFiltering();
-- 
2.17.1
