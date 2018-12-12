Return-Path: <SRS0=dEKL=OV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr680042.outbound.protection.outlook.com ([40.107.68.42]:40896
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727681AbeLLQ7a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Dec 2018 11:59:30 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 3/5] kernel-shark-qt: Improuve the KsQuickContextMenu
Date: Wed, 12 Dec 2018 16:58:47 +0000
Message-ID: <20181212165826.8218-4-ykaradzhov@vmware.com>
References: <20181212165826.8218-1-ykaradzhov@vmware.com>
In-Reply-To: <20181212165826.8218-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In this patch the KsQuickContextMenu gets upgraded according
to the user feedback received from Steven. First of all a
"Show CPU X only" action is added to the version of the menu
that gets opened from the Table widget. In addition to this
"Apply filter to XX" check-boxes are added in order to control
the visibility of the filtered data.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsQuickContextMenu.cpp | 39 ++++++++++++++++++++++
 kernel-shark-qt/src/KsQuickContextMenu.hpp |  6 +++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/kernel-shark-qt/src/KsQuickContextMenu.cpp b/kernel-shark-qt/s=
rc/KsQuickContextMenu.cpp
index 815e4b9..c225269 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.cpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.cpp
@@ -50,11 +50,14 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *dat=
a, size_t row,
 : KsQuickMarkerMenu(dm, parent),
   _data(data),
   _row(row),
+  _graphSyncCBox(nullptr),
+  _listSyncCBox(nullptr),
   _hideTaskAction(this),
   _showTaskAction(this),
   _hideEventAction(this),
   _showEventAction(this),
   _hideCPUAction(this),
+  _showCPUAction(this),
   _addCPUPlotAction(this),
   _addTaskPlotAction(this),
   _removeCPUPlotAction(this),
@@ -85,6 +88,32 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data=
, size_t row,
 	parentName =3D parent->metaObject()->className();
=20
 	addSection("Pointer menu");
+
+	if (parentName =3D=3D "KsTraceViewer") {
+		_graphSyncCBox =3D
+			KsUtils::addCheckBoxToMenu(this, "Apply filters to Graph");
+
+		connect(_graphSyncCBox,	&QCheckBox::stateChanged,
+					&KsUtils::graphFilterSync);
+
+		bool state(false);
+		KsUtils::graphFilterSync(state);
+		_graphSyncCBox->setChecked(state);
+	}
+
+	if (parentName =3D=3D "KsTraceGraph" &&
+	    (graphs =3D dynamic_cast<KsTraceGraph *>(parent))) {
+		_listSyncCBox =3D
+			KsUtils::addCheckBoxToMenu(this, "Apply filters to Graph");
+
+		connect(_listSyncCBox,	&QCheckBox::stateChanged,
+					&KsUtils::listFilterSync);
+
+		bool state(false);
+		KsUtils::listFilterSync(state);
+		_listSyncCBox->setChecked(state);
+	}
+
 	descr =3D "Hide task [";
 	descr +=3D taskName;
 	descr +=3D "-";
@@ -113,6 +142,9 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *dat=
a, size_t row,
 	lamAddAction(&_hideCPUAction, &KsQuickContextMenu::_hideCPU);
=20
 	if (parentName =3D=3D "KsTraceViewer") {
+		descr =3D QString("Show CPU [%1] only").arg(cpu);
+		lamAddAction(&_showCPUAction, &KsQuickContextMenu::_showCPU);
+
 		descr =3D "Add [";
 		descr +=3D taskName;
 		descr +=3D "-";
@@ -198,6 +230,13 @@ void KsQuickContextMenu::_showEvent()
 	_data->applyPosEventFilter(QVector<int>(1, eventId));
 }
=20
+void KsQuickContextMenu::_showCPU()
+{
+	int cpu =3D _data->rows()[_row]->cpu;
+
+	_data->applyPosCPUFilter(QVector<int>(1, cpu));
+}
+
 void KsQuickContextMenu::_hideCPU()
 {
 	kshark_context *kshark_ctx(nullptr);
diff --git a/kernel-shark-qt/src/KsQuickContextMenu.hpp b/kernel-shark-qt/s=
rc/KsQuickContextMenu.hpp
index 6ca1b08..f5a2a78 100644
--- a/kernel-shark-qt/src/KsQuickContextMenu.hpp
+++ b/kernel-shark-qt/src/KsQuickContextMenu.hpp
@@ -71,6 +71,8 @@ private:
=20
 	void _showEvent();
=20
+	void _showCPU();
+
 	void _hideCPU();
=20
 	void _addCPUPlot();
@@ -87,11 +89,13 @@ private:
=20
 	size_t		_row;
=20
+	QCheckBox	*_graphSyncCBox, *_listSyncCBox;
+
 	QAction _hideTaskAction, _showTaskAction;
=20
 	QAction _hideEventAction, _showEventAction;
=20
-	QAction _hideCPUAction;
+	QAction _hideCPUAction, _showCPUAction;
=20
 	QAction _addCPUPlotAction;
=20
--=20
2.17.1
