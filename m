Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-eopbgr790047.outbound.protection.outlook.com ([40.107.79.47]:5504
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725930AbfADT5y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Jan 2019 14:57:54 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 1/4] kernel-shark-qt: Rearrange the "Filter" top menu
Date: Fri, 4 Jan 2019 19:57:51 +0000
Message-ID: <20190104195726.24264-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The "Filter" top menu contains only "Show Task" and "Show CPU"
menu actions ("Hide" versions are removed). The code that adds
the "Hide" actions is only commented out, because we may change
our opinion in the future.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsMainWindow.cpp | 42 ++++++++++++++++++++++++++--
 kernel-shark-qt/src/KsMainWindow.hpp |  4 +++
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsM=
ainWindow.cpp
index a375126..3eb3692 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -54,6 +54,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
   _showEventsAction("Show events", this),
   _showTasksAction("Show tasks", this),
   _hideTasksAction("Hide tasks", this),
+  _showCPUsAction("Show CPUs", this),
   _hideCPUsAction("Hide CPUs", this),
   _advanceFilterAction("Advance Filtering", this),
   _clearAllFilters("Clear all filters", this),
@@ -208,6 +209,9 @@ void KsMainWindow::_createActions()
 	connect(&_hideTasksAction,	&QAction::triggered,
 		this,			&KsMainWindow::_hideTasks);
=20
+	connect(&_showCPUsAction,	&QAction::triggered,
+		this,			&KsMainWindow::_showCPUs);
+
 	connect(&_hideCPUsAction,	&QAction::triggered,
 		this,			&KsMainWindow::_hideCPUs);
=20
@@ -322,8 +326,9 @@ void KsMainWindow::_createMenus()
=20
 	filter->addAction(&_showEventsAction);
 	filter->addAction(&_showTasksAction);
-	filter->addAction(&_hideTasksAction);
-	filter->addAction(&_hideCPUsAction);
+// 	filter->addAction(&_hideTasksAction);
+	filter->addAction(&_showCPUsAction);
+// 	filter->addAction(&_hideCPUsAction);
 	filter->addAction(&_advanceFilterAction);
 	filter->addAction(&_clearAllFilters);
=20
@@ -621,6 +626,39 @@ void KsMainWindow::_hideTasks()
 	dialog->show();
 }
=20
+void KsMainWindow::_showCPUs()
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
+	if (!kshark_ctx->show_cpu_filter ||
+	    !kshark_ctx->show_cpu_filter->count) {
+		cpu_cbd->setDefault(true);
+	} else {
+		int nCPUs =3D tep_get_cpus(_data.tep());
+		QVector<bool> v(nCPUs, false);
+
+		for (int i =3D 0; i < nCPUs; ++i) {
+			if (tracecmd_filter_id_find(kshark_ctx->show_cpu_filter, i))
+				v[i] =3D true;
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
diff --git a/kernel-shark-qt/src/KsMainWindow.hpp b/kernel-shark-qt/src/KsM=
ainWindow.hpp
index 301acc9..c29829a 100644
--- a/kernel-shark-qt/src/KsMainWindow.hpp
+++ b/kernel-shark-qt/src/KsMainWindow.hpp
@@ -120,6 +120,8 @@ private:
=20
 	QAction		_hideTasksAction;
=20
+	QAction		_showCPUsAction;
+
 	QAction		_hideCPUsAction;
=20
 	QAction		_advanceFilterAction;
@@ -173,6 +175,8 @@ private:
=20
 	void _hideTasks();
=20
+	void _showCPUs();
+
 	void _hideCPUs();
=20
 	void _advancedFiltering();
--=20
2.17.1
