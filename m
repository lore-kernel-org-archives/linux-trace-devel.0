Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710075.outbound.protection.outlook.com ([40.107.71.75]:2944
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728413AbeK2CSw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:52 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 16/17] kernel-shark-qt: Add "Hide CPU" checkbox dialog to the
 Main window menu
Date: Wed, 28 Nov 2018 15:16:27 +0000
Message-ID: <20181128151530.21965-17-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

"Hide CPU" checkbox dialog is added to Menu/Filtering. This dialog is
complementary to the "Hide CPU" action of the Quick Context Menu.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsMainWindow.cpp | 39 ++++++++++++++++++++++++++++
 kernel-shark-qt/src/KsMainWindow.hpp |  4 +++
 2 files changed, 43 insertions(+)

diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsM=
ainWindow.cpp
index f4804bd..16ba8bb 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -54,6 +54,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _showEventsAction("Show events", this),
   _showTasksAction("Show tasks", this),
   _hideTasksAction("Hide tasks", this),
+  _hideCPUsAction("Hide CPUs", this),
   _advanceFilterAction("Advance Filtering", this),
   _clearAllFilters("Clear all filters", this),
   _cpuSelectAction("CPUs", this),
@@ -207,6 +208,9 @@ void KsMainWindow::_createActions()
 	connect(&_hideTasksAction,	&QAction::triggered,
 		this,			&KsMainWindow::_hideTasks);
=20
+	connect(&_hideCPUsAction,	&QAction::triggered,
+		this,			&KsMainWindow::_hideCPUs);
+
 	connect(&_advanceFilterAction,	&QAction::triggered,
 		this,			&KsMainWindow::_advancedFiltering);
=20
@@ -329,6 +333,7 @@ void KsMainWindow::_createMenus()
 	filter->addAction(&_showEventsAction);
 	filter->addAction(&_showTasksAction);
 	filter->addAction(&_hideTasksAction);
+	filter->addAction(&_hideCPUsAction);
 	filter->addAction(&_advanceFilterAction);
 	filter->addAction(&_clearAllFilters);
=20
@@ -603,6 +608,40 @@ void KsMainWindow::_hideTasks()
 	dialog->show();
 }
=20
+void KsMainWindow::_hideCPUs()
+{
+	kshark_context *kshark_ctx(nullptr);
+	KsCheckBoxWidget *cpu_cbd;
+	KsCheckBoxDialog *dialog;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	cpu_cbd =3D new KsCPUCheckBoxWidget(_data.tep(), this);
+	dialog =3D new KsCheckBoxDialog(cpu_cbd, this);
+
+	if (!kshark_ctx->hide_cpu_filter ||
+	    !kshark_ctx->hide_cpu_filter->count) {
+		cpu_cbd->setDefault(false);
+	} else {
+		int nCPUs =3D tep_get_cpus(_data.tep());
+		QVector<bool> v(nCPUs, false);
+
+		for (int i =3D 0; i < nCPUs; ++i) {
+			if (tracecmd_filter_id_find(kshark_ctx->hide_cpu_filter,
+						    i))
+				v[i] =3D true;
+		}
+
+		cpu_cbd->set(v);
+	}
+
+	connect(dialog,		&KsCheckBoxDialog::apply,
+		&_data,		&KsDataStore::applyNegCPUFilter);
+
+	dialog->show();
+}
+
 void KsMainWindow::_advancedFiltering()
 {
 	KsAdvFilteringDialog *dialog;
diff --git a/kernel-shark-qt/src/KsMainWindow.hpp b/kernel-shark-qt/src/KsM=
ainWindow.hpp
index 5938a25..b231b52 100644
--- a/kernel-shark-qt/src/KsMainWindow.hpp
+++ b/kernel-shark-qt/src/KsMainWindow.hpp
@@ -120,6 +120,8 @@ private:
=20
 	QAction		_hideTasksAction;
=20
+	QAction		_hideCPUsAction;
+
 	QAction		_advanceFilterAction;
=20
 	QAction		_clearAllFilters;
@@ -171,6 +173,8 @@ private:
=20
 	void _hideTasks();
=20
+	void _hideCPUs();
+
 	void _advancedFiltering();
=20
 	void _clearFilters();
--=20
2.17.1
