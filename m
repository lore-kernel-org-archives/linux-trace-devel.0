Return-Path: <SRS0=g7z+=NM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810044.outbound.protection.outlook.com ([40.107.81.44]:28016
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727151AbeKBGud (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Nov 2018 02:50:33 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 8/8] kernel-shark-qt: Remove duplicate code in
 KsWidgetsLib.cpp
Date: Thu, 1 Nov 2018 21:45:46 +0000
Message-ID: <20181101214512.18684-9-ykaradzhov@vmware.com>
References: <20181101214512.18684-1-ykaradzhov@vmware.com>
In-Reply-To: <20181101214512.18684-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Currently the "Task" and "CPU" checkbox widgets have their own
implementation of the code that generates the Rainbow color palettes
of the CPUs and Tasks. This patch make the two widgets to use the same
hash tables of colors used when plotting the graphs.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsWidgetsLib.cpp | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel-shark-qt/src/KsWidgetsLib.cpp b/kernel-shark-qt/src/KsW=
idgetsLib.cpp
index b4b62a4..dd6ab0f 100644
--- a/kernel-shark-qt/src/KsWidgetsLib.cpp
+++ b/kernel-shark-qt/src/KsWidgetsLib.cpp
@@ -622,7 +622,7 @@ KsCPUCheckBoxWidget::KsCPUCheckBoxWidget(struct tep_han=
dle *tep,
 : KsCheckBoxTreeWidget("CPUs", parent)
 {
 	int nCPUs(0), height(FONT_HEIGHT * 1.5);
-	KsPlot::Color cpuCol;
+	KsPlot::ColorTable colors;
 	QString style;
=20
 	style =3D QString("QTreeView::item { height: %1 ;}").arg(height);
@@ -635,16 +635,16 @@ KsCPUCheckBoxWidget::KsCPUCheckBoxWidget(struct tep_h=
andle *tep,
=20
 	_id.resize(nCPUs);
 	_cb.resize(nCPUs);
+	colors =3D KsPlot::getCPUColorTable();
=20
 	for (int i =3D 0; i < nCPUs; ++i) {
-		cpuCol.setRainbowColor(i);
 		QTreeWidgetItem *cpuItem =3D new QTreeWidgetItem;
 		cpuItem->setText(0, "  ");
 		cpuItem->setText(1, QString("CPU %1").arg(i));
 		cpuItem->setCheckState(0, Qt::Checked);
-		cpuItem->setBackgroundColor(0, QColor(cpuCol.r(),
-						      cpuCol.g(),
-						      cpuCol.b()));
+		cpuItem->setBackgroundColor(0, QColor(colors[i].r(),
+						      colors[i].g(),
+						      colors[i].b()));
 		_tree.addTopLevelItem(cpuItem);
 		_id[i] =3D i;
 		_cb[i] =3D cpuItem;
@@ -719,10 +719,10 @@ KsTasksCheckBoxWidget::KsTasksCheckBoxWidget(struct t=
ep_handle *pevent,
 {
 	kshark_context *kshark_ctx(nullptr);
 	QTableWidgetItem *pidItem, *comItem;
-	KsPlot::Color pidCol;
+	KsPlot::ColorTable colors;
 	QStringList headers;
 	const char *comm;
-	int nTasks;
+	int nTasks, pid;
=20
 	if (!kshark_instance(&kshark_ctx))
 		return;
@@ -735,24 +735,24 @@ KsTasksCheckBoxWidget::KsTasksCheckBoxWidget(struct t=
ep_handle *pevent,
 	_id =3D KsUtils::getPidList();
 	nTasks =3D _id.count();
 	_initTable(headers, nTasks);
+	colors =3D KsPlot::getTaskColorTable();
=20
 	for (int i =3D 0; i < nTasks; ++i) {
-		pidItem	=3D new QTableWidgetItem(tr("%1").arg(_id[i]));
+		pid =3D _id[i];
+		pidItem	=3D new QTableWidgetItem(tr("%1").arg(pid));
 		_table.setItem(i, 1, pidItem);
=20
-		comm =3D tep_data_comm_from_pid(kshark_ctx->pevent, _id[i]);
+		comm =3D tep_data_comm_from_pid(kshark_ctx->pevent, pid);
 		comItem =3D new QTableWidgetItem(tr(comm));
=20
-		pidItem->setBackgroundColor(QColor(pidCol.r(),
-						   pidCol.g(),
-						   pidCol.b()));
+		pidItem->setBackgroundColor(QColor(colors[pid].r(),
+						   colors[pid].g(),
+						   colors[pid].b()));
=20
 		if (_id[i] =3D=3D 0)
 			pidItem->setTextColor(Qt::white);
=20
 		_table.setItem(i, 2, comItem);
-
-		pidCol.setRainbowColor(i);
 	}
=20
 	_adjustSize();
--=20
2.17.1
