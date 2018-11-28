Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710043.outbound.protection.outlook.com ([40.107.71.43]:7840
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728732AbeK2CSs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:48 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 14/17] kernel-shark-qt: Add Hide CPU action to the Quick
 Context Menu
Date: Wed, 28 Nov 2018 15:16:25 +0000
Message-ID: <20181128151530.21965-15-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Now the Quick Context Menu can be used to hide all data from a CPU core.
The CPU Id value is added to the list of CPUs to be filtered-out.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsQuickContextMenu.cpp | 26 ++++++++++++++++++++++
 kernel-shark-qt/src/KsQuickContextMenu.hpp |  6 +++++
 2 files changed, 32 insertions(+)

diff --git a/kernel-shark-qt/src/KsQuickContextMenu.cpp b/kernel-shark-qt/s=
rc/KsQuickContextMenu.cpp
index 16b8d19..95ffc4f 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.cpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.cpp
@@ -54,6 +54,7 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data,=
 size_t row,
   _showTaskAction(this),
   _hideEventAction(this),
   _showEventAction(this),
+  _hideCPUAction(this),
   _addCPUPlotAction(this),
   _addTaskPlotAction(this),
   _removeCPUPlotAction(this),
@@ -108,6 +109,9 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *dat=
a, size_t row,
 	descr +=3D "] only";
 	lamAddAction(&_showEventAction, &KsQuickContextMenu::_showEvent);
=20
+	descr =3D QString("Hide CPU [%1]").arg(_data->rows()[_row]->cpu);
+	lamAddAction(&_hideCPUAction, &KsQuickContextMenu::_hideCPU);
+
 	if (parentName =3D=3D "KsTraceViewer") {
 		descr =3D "Add [";
 		descr +=3D taskName;
@@ -194,6 +198,28 @@ void KsQuickContextMenu::_showEvent()
 	_data->applyPosEventFilter(QVector<int>(1, eventId));
 }
=20
+void KsQuickContextMenu::_hideCPU()
+{
+	kshark_context *kshark_ctx(nullptr);
+	QVector<int> vec;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	vec =3D_getFilterVector(kshark_ctx->hide_cpu_filter,
+			      _data->rows()[_row]->cpu);
+	_data->applyNegCPUFilter(vec);
+}
+
+QVector<int> KsQuickContextMenu::_getFilterVector(tracecmd_filter_id *filt=
er, int newId)
+{
+	QVector<int> vec =3D KsUtils::getFilterIds(filter);
+	if (!vec.contains(newId))
+		vec.append(newId);
+
+	return vec;
+}
+
 void KsQuickContextMenu::_addTaskPlot()
 {
 	int pid =3D kshark_get_pid_easy(_data->rows()[_row]);
diff --git a/kernel-shark-qt/src/KsQuickContextMenu.hpp b/kernel-shark-qt/s=
rc/KsQuickContextMenu.hpp
index 040942f..6ca1b08 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.hpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.hpp
@@ -71,6 +71,8 @@ private:
=20
 	void _showEvent();
=20
+	void _hideCPU();
+
 	void _addCPUPlot();
=20
 	void _addTaskPlot();
@@ -79,6 +81,8 @@ private:
=20
 	void _removeTaskPlot();
=20
+	QVector<int> _getFilterVector(tracecmd_filter_id *filter, int newId);
+
 	KsDataStore	*_data;
=20
 	size_t		_row;
@@ -87,6 +91,8 @@ private:
=20
 	QAction _hideEventAction, _showEventAction;
=20
+	QAction _hideCPUAction;
+
 	QAction _addCPUPlotAction;
=20
 	QAction _addTaskPlotAction;
--=20
2.17.1
