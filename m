Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710043.outbound.protection.outlook.com ([40.107.71.43]:7840
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727941AbeK2CSf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 21:18:35 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 09/17] kernel-shark-qt: Add centralized context menu for View
 and Graph widgets
Date: Wed, 28 Nov 2018 15:16:18 +0000
Message-ID: <20181128151530.21965-10-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
In-Reply-To: <20181128151530.21965-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch redesigns the context menu, used so far by the View
(table) widget. The goal is to make this menu universal and to
make possible to open it from both View and Graph widgets. The
context menu gets open by a right mouse click. The problem here
was, that so far the right mouse click in the Graph widget was
used for deselecting the Active marker. Now the Active marker
can be unset via the menu.

Because the new design of the Context menu requires significant
modification of the flow of signals between the widgets, the
changes cannot be broken into smaller patches. Also the
implementation of the menu is more complex now (much more code),
hence its source code has been moved from KsWidgetsLib into
separate header and source files.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/CMakeLists.txt         |   2 +
 kernel-shark-qt/src/KsGLWidget.cpp         |  46 ++--
 kernel-shark-qt/src/KsGLWidget.hpp         |  22 +-
 kernel-shark-qt/src/KsMainWindow.cpp       |  17 +-
 kernel-shark-qt/src/KsMainWindow.hpp       |   2 +
 kernel-shark-qt/src/KsQuickContextMenu.cpp | 274 +++++++++++++++++++++
 kernel-shark-qt/src/KsQuickContextMenu.hpp | 136 ++++++++++
 kernel-shark-qt/src/KsTraceGraph.cpp       |  94 +++++++
 kernel-shark-qt/src/KsTraceGraph.hpp       |  14 ++
 kernel-shark-qt/src/KsTraceViewer.cpp      |  30 ++-
 kernel-shark-qt/src/KsTraceViewer.hpp      |  32 ++-
 kernel-shark-qt/src/KsWidgetsLib.cpp       | 120 ---------
 kernel-shark-qt/src/KsWidgetsLib.hpp       |  44 ----
 13 files changed, 622 insertions(+), 211 deletions(-)
 create mode 100644 kernel-shark-qt/src/KsQuickContextMenu.cpp
 create mode 100644 kernel-shark-qt/src/KsQuickContextMenu.hpp

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMake=
Lists.txt
index ef0aa71..3eddaed 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -40,6 +40,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                         KsTraceViewer.hpp
                         KsMainWindow.hpp
                         KsCaptureDialog.hpp
+                        KsQuickContextMenu.hpp
                         KsAdvFilteringDialog.hpp)
=20
     QT5_WRAP_CPP(ks-guiLib_hdr_moc ${ks-guiLib_hdr})
@@ -54,6 +55,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                                                             KsTraceViewer.=
cpp
                                                             KsMainWindow.c=
pp
                                                             KsCaptureDialo=
g.cpp
+                                                            KsQuickContext=
Menu.cpp
                                                             KsAdvFiltering=
Dialog.cpp)
=20
     target_link_libraries(kshark-gui kshark-plot
diff --git a/kernel-shark-qt/src/KsGLWidget.cpp b/kernel-shark-qt/src/KsGLW=
idget.cpp
index 2a0b16b..917e86d 100644
--- a/kernel-shark-qt/src/KsGLWidget.cpp
+++ b/kernel-shark-qt/src/KsGLWidget.cpp
@@ -115,11 +115,6 @@ void KsGLWidget::mousePressEvent(QMouseEvent *event)
 	if (event->button() =3D=3D Qt::LeftButton) {
 		_posMousePress =3D _posInRange(event->pos().x());
 		_rangeBoundInit(_posMousePress);
-	} else if (event->button() =3D=3D Qt::RightButton) {
-		emit deselect();
-		_mState->activeMarker().remove();
-		_mState->updateLabels();
-		_model.update();
 	}
 }
=20
@@ -189,8 +184,8 @@ void KsGLWidget::mouseMoveEvent(QMouseEvent *event)
 		_rangeBoundStretched(_posInRange(event->pos().x()));
=20
 	bin =3D event->pos().x() - _hMargin;
-	cpu =3D _getCPU(event->pos().y());
-	pid =3D _getPid(event->pos().y());
+	cpu =3D getPlotCPU(event->pos());
+	pid =3D getPlotPid(event->pos());
=20
 	ret =3D _find(bin, cpu, pid, 5, false, &row);
 	if (ret) {
@@ -613,18 +608,30 @@ KsPlot::Graph *KsGLWidget::_newTaskGraph(int pid)
 	return graph;
 }
=20
-bool KsGLWidget::_find(QMouseEvent *event, int variance, bool joined,
-		       size_t *row)
+/**
+ * @brief Find the KernelShark entry under the the cursor.
+ *
+ * @param point: The position of the cursor.
+ * @param variance: The variance of the position (range) in which an entry=
 will
+ *		    be searched.
+ * @param joined: It True, search also in the associated CPU/Task graph.
+ * @param index: Output location for the index of the entry under the curs=
or.
+ * 		 If no entry has been found, the outputted value is zero.
+ *
+ * @returns True, if an entry has been found, otherwise False.
+ */
+bool KsGLWidget::find(const QPoint &point, int variance, bool joined,
+		      size_t *index)
 {
 	/*
 	 * Get the bin, pid and cpu numbers.
 	 * Remember that one bin corresponds to one pixel.
 	 */
-	int bin =3D event->pos().x() - _hMargin;
-	int cpu =3D _getCPU(event->pos().y());
-	int pid =3D _getPid(event->pos().y());
+	int bin =3D point.x() - _hMargin;
+	int cpu =3D getPlotCPU(point);
+	int pid =3D getPlotPid(point);
=20
-	return _find(bin, cpu, pid, variance, joined, row);
+	return _find(bin, cpu, pid, variance, joined, index);
 }
=20
 int KsGLWidget::_getNextCPU(int pid, int bin)
@@ -766,9 +773,8 @@ bool KsGLWidget::_find(int bin, int cpu, int pid,
 bool KsGLWidget::_findAndSelect(QMouseEvent *event)
 {
 	size_t row;
-	bool found =3D _find(event, 10, true, &row);
+	bool found =3D find(event->pos(), 10, true, &row);
=20
-	emit deselect();
 	if (found) {
 		emit select(row);
 		emit updateView(row, true);
@@ -892,9 +898,10 @@ int KsGLWidget::_posInRange(int x)
 	return posX;
 }
=20
-int KsGLWidget::_getCPU(int y)
+/** Get the CPU Id of the Graph plotted at given position. */
+int KsGLWidget::getPlotCPU(const QPoint &point)
 {
-	int cpuId;
+	int cpuId, y =3D point.y();
=20
 	if (_cpuList.count() =3D=3D 0)
 		return -1;
@@ -906,9 +913,10 @@ int KsGLWidget::_getCPU(int y)
 	return _cpuList[cpuId];
 }
=20
-int KsGLWidget::_getPid(int y)
+/** Get the CPU Id of the Graph plotted at given position. */
+int KsGLWidget::getPlotPid(const QPoint &point)
 {
-	int pidId;
+	int pidId, y =3D point.y();
=20
 	if (_taskList.count() =3D=3D 0)
 		return -1;
diff --git a/kernel-shark-qt/src/KsGLWidget.hpp b/kernel-shark-qt/src/KsGLW=
idget.hpp
index 662cd26..6fbf534 100644
--- a/kernel-shark-qt/src/KsGLWidget.hpp
+++ b/kernel-shark-qt/src/KsGLWidget.hpp
@@ -98,6 +98,13 @@ public:
 			  int *graphCPU,
 			  int *graphTask);
=20
+	bool find(const QPoint &point, int variance, bool joined,
+		  size_t *index);
+
+	int getPlotCPU(const QPoint &point);
+
+	int getPlotPid(const QPoint &point);
+
 	/** CPUs to be plotted. */
 	QVector<int>	_cpuList;
=20
@@ -141,13 +148,6 @@ signals:
 	 */
 	void select(size_t pos);
=20
-	/**
-	 * This signal is emitted in the case of a right mouse button click or
-	 * in the case of a double click over an empty area (no visible
-	 * KernelShark entries).
-	 */
-	void deselect();
-
 	/**
 	 * This signal is emitted when the KsTraceViewer widget needs to be
 	 * updated.
@@ -195,10 +195,6 @@ private:
=20
 	int _posInRange(int x);
=20
-	int _getCPU(int y);
-
-	int _getPid(int y);
-
 	void _rangeBoundInit(int x);
=20
 	void _rangeBoundStretched(int x);
@@ -207,8 +203,6 @@ private:
=20
 	bool _findAndSelect(QMouseEvent *event);
=20
-	bool _find(QMouseEvent *event, int variance, bool joined, size_t *row);
-
 	bool _find(int bin, int cpu, int pid,
 		   int variance, bool joined, size_t *row);
=20
@@ -217,6 +211,8 @@ private:
 	int _getLastTask(struct kshark_trace_histo *histo, int bin, int cpu);
=20
 	int _getLastCPU(struct kshark_trace_histo *histo, int bin, int pid);
+
+	void _deselect();
 };
=20
 #endif
diff --git a/kernel-shark-qt/src/KsMainWindow.cpp b/kernel-shark-qt/src/KsM=
ainWindow.cpp
index 8e8484f..5c9a0fa 100644
--- a/kernel-shark-qt/src/KsMainWindow.cpp
+++ b/kernel-shark-qt/src/KsMainWindow.cpp
@@ -93,14 +93,17 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 	connect(&_view,		&KsTraceViewer::select,
 		&_graph,	&KsTraceGraph::markEntry);
=20
-	connect(&_view,		&KsTraceViewer::plotTask,
+	connect(&_view,		&KsTraceViewer::addTaskPlot,
 		&_graph,	&KsTraceGraph::addTaskPlot);
=20
 	connect(_graph.glPtr(), &KsGLWidget::updateView,
 		&_view,		&KsTraceViewer::showRow);
=20
-	connect(_graph.glPtr(), &KsGLWidget::deselect,
-		&_view,		&KsTraceViewer::deselect);
+	connect(&_graph,	&KsTraceGraph::deselect,
+		this,		&KsMainWindow::_deselect);
+
+	connect(&_view,		&KsTraceViewer::deselect,
+		this,		&KsMainWindow::_deselect);
=20
 	connect(&_data,		&KsDataStore::updateWidgets,
 		&_view,		&KsTraceViewer::update);
@@ -1040,3 +1043,11 @@ void KsMainWindow::_splitterMoved(int pos, int index=
)
 {
 	_session.saveSplitterSize(_splitter);
 }
+
+void KsMainWindow::_deselect()
+{
+	_view.clearSelection();
+	_mState.activeMarker().remove();
+	_mState.updateLabels();
+	_graph.glPtr()->model()->update();
+}
diff --git a/kernel-shark-qt/src/KsMainWindow.hpp b/kernel-shark-qt/src/KsM=
ainWindow.hpp
index d711ec1..b9b681f 100644
--- a/kernel-shark-qt/src/KsMainWindow.hpp
+++ b/kernel-shark-qt/src/KsMainWindow.hpp
@@ -210,6 +210,8 @@ private:
 	void _error(const QString &text, const QString &errCode,
 		    bool resize, bool unloadPlugins);
=20
+	void _deselect();
+
 private slots:
 	void _captureFinished(int, QProcess::ExitStatus);
 };
diff --git a/kernel-shark-qt/src/KsQuickContextMenu.cpp b/kernel-shark-qt/s=
rc/KsQuickContextMenu.cpp
new file mode 100644
index 0000000..0a8e527
--- /dev/null
+++ b/kernel-shark-qt/src/KsQuickContextMenu.cpp
@@ -0,0 +1,274 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsQuickContextMenu.cpp
+ *  @brief   Quick Context Menus for KernelShark.
+ */
+
+#include "KsQuickContextMenu.hpp"
+#include "KsTraceGraph.hpp"
+
+/**
+ * @brief Create KsQuickMarkerMenu.
+ *
+ * @param dm: The State machine of the Dual marker.
+ * @param parent: The parent of this widget.
+ */
+KsQuickMarkerMenu::KsQuickMarkerMenu(KsDualMarkerSM *dm, QWidget *parent)
+: QMenu("Context Menu", parent),
+  _dm(dm),
+  _deselectAction(this)
+{
+	if (dm->activeMarker()._isSet) {
+		addSection("Marker menu");
+		_deselectAction.setText("Deselect");
+
+		connect(&_deselectAction,	&QAction::triggered,
+			this,			&KsQuickMarkerMenu::deselect);
+
+		addAction(&_deselectAction);
+	}
+}
+
+/**
+ * @brief Create KsQuickContextMenu.
+ *
+ * @param data: Input location for the KsDataStore object.
+ * @param row: The index of the entry used to initialize the menu.
+ * @param dm: The State machine of the Dual marker.
+ * @param parent: The parent of this widget.
+ */
+KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
+				       KsDualMarkerSM *dm,
+				       QWidget *parent)
+: KsQuickMarkerMenu(dm, parent),
+  _data(data),
+  _row(row),
+  _hideTaskAction(this),
+  _showTaskAction(this),
+  _hideEventAction(this),
+  _showEventAction(this),
+  _addCPUPlotAction(this),
+  _addTaskPlotAction(this),
+  _removeCPUPlotAction(this),
+  _removeTaskPlotAction(this),
+  _deselectAction(this)
+{
+	typedef void (KsQuickContextMenu::*mfp)();
+	QString taskName, parentName, descr;
+	KsTraceGraph *graphs;
+	int pid, cpu;
+
+	if (!parent || !_data)
+		return;
+
+	taskName =3D kshark_get_task_easy(_data->rows()[_row]);
+	pid =3D kshark_get_pid_easy(_data->rows()[_row]);
+	cpu =3D _data->rows()[_row]->cpu;
+
+	auto lamAddAction =3D [this, &descr] (QAction *action, mfp mf) {
+		action->setText(descr);
+
+		connect(action,	&QAction::triggered,
+			this,	mf);
+
+		addAction(action);
+	};
+
+	parentName =3D parent->metaObject()->className();
+
+	addSection("Pointer menu");
+	descr =3D "Hide task [";
+	descr +=3D taskName;
+	descr +=3D "-";
+	descr +=3D QString("%1").arg(pid);
+	descr +=3D "]";
+	lamAddAction(&_hideTaskAction, &KsQuickContextMenu::_hideTask);
+
+	descr =3D "Show task [";
+	descr +=3D taskName;
+	descr +=3D "-";
+	descr +=3D QString("%1").arg(pid);
+	descr +=3D "] only";
+	lamAddAction(&_showTaskAction, &KsQuickContextMenu::_showTask);
+
+	descr =3D "Hide event [";
+	descr +=3D kshark_get_event_name_easy(_data->rows()[_row]);
+	descr +=3D "]";
+	lamAddAction(&_hideEventAction, &KsQuickContextMenu::_hideEvent);
+
+	descr =3D "Show event [";
+	descr +=3D kshark_get_event_name_easy(_data->rows()[_row]);
+	descr +=3D "] only";
+	lamAddAction(&_showEventAction, &KsQuickContextMenu::_showEvent);
+
+	if (parentName =3D=3D "KsTraceViewer") {
+		descr =3D "Add [";
+		descr +=3D taskName;
+		descr +=3D "-";
+		descr +=3D QString("%1").arg(pid);
+		descr +=3D "] plot";
+		lamAddAction(&_addTaskPlotAction,
+			     &KsQuickContextMenu::_addTaskPlot);
+	}
+
+	if (parentName =3D=3D "KsTraceGraph" &&
+	    (graphs =3D dynamic_cast<KsTraceGraph *>(parent))) {
+		if (graphs->glPtr()->_taskList.contains(pid)) {
+			descr =3D "Remove [";
+			descr +=3D taskName;
+			descr +=3D "-";
+			descr +=3D QString("%1").arg(_data->rows()[_row]->pid);
+			descr +=3D "] plot";
+			lamAddAction(&_removeTaskPlotAction,
+				     &KsQuickContextMenu::_removeTaskPlot);
+		} else {
+			descr =3D "Add [";
+			descr +=3D taskName;
+			descr +=3D "-";
+			descr +=3D QString("%1").arg(_data->rows()[_row]->pid);
+			descr +=3D "] plot";
+			lamAddAction(&_addTaskPlotAction,
+				     &KsQuickContextMenu::_addTaskPlot);
+		}
+
+		if (graphs->glPtr()->_cpuList.contains(cpu)) {
+			descr =3D "Remove [CPU ";
+			descr +=3D QString("%1").arg(cpu);
+			descr +=3D "] plot";
+			lamAddAction(&_removeCPUPlotAction,
+				     &KsQuickContextMenu::_removeCPUPlot);
+		} else {
+			descr =3D "Add [CPU ";
+			descr +=3D QString("%1").arg(cpu);
+			descr +=3D "] plot";
+			lamAddAction(&_addCPUPlotAction,
+				     &KsQuickContextMenu::_addCPUPlot);
+		}
+	}
+}
+
+void KsQuickContextMenu::_hideTask()
+{
+	int pid =3D kshark_get_pid_easy(_data->rows()[_row]);
+	kshark_context *kshark_ctx(nullptr);
+	QVector<int> vec;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	vec =3D_getFilterVector(kshark_ctx->hide_task_filter, pid);
+	_data->applyPosTaskFilter(vec);
+}
+
+void KsQuickContextMenu::_showTask()
+{
+	int pid =3D kshark_get_pid_easy(_data->rows()[_row]);
+
+	_data->applyPosTaskFilter(QVector<int>(1, pid));
+}
+
+void KsQuickContextMenu::_hideEvent()
+{
+	int eventId =3D kshark_get_event_id_easy(_data->rows()[_row]);
+	kshark_context *kshark_ctx(nullptr);
+	QVector<int> vec;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	vec =3D_getFilterVector(kshark_ctx->hide_event_filter, eventId);
+	_data->applyNegEventFilter(vec);
+}
+
+void KsQuickContextMenu::_showEvent()
+{
+	int eventId =3D kshark_get_event_id_easy(_data->rows()[_row]);
+
+	_data->applyPosEventFilter(QVector<int>(1, eventId));
+}
+
+void KsQuickContextMenu::_addTaskPlot()
+{
+	int pid =3D kshark_get_pid_easy(_data->rows()[_row]);
+
+	emit addTaskPlot(pid);
+}
+
+void KsQuickContextMenu::_addCPUPlot()
+{
+	emit addCPUPlot(_data->rows()[_row]->cpu);
+}
+
+void KsQuickContextMenu::_removeTaskPlot()
+{
+	int pid =3D kshark_get_pid_easy(_data->rows()[_row]);
+
+	emit removeTaskPlot(pid);
+}
+
+void KsQuickContextMenu::_removeCPUPlot()
+{
+	emit removeCPUPlot(_data->rows()[_row]->cpu);
+}
+
+/**
+ * @brief Create KsRmPlotContextMenu.
+ *
+ * @param dm: The State machine of the Dual marker.
+ * @param parent: The parent of this widget.
+ */
+KsRmPlotContextMenu::KsRmPlotContextMenu(KsDualMarkerSM *dm,
+					 QWidget *parent)
+: KsQuickMarkerMenu(dm, parent),
+  _removePlotAction(this)
+{
+	addSection("Plots");
+
+	connect(&_removePlotAction,	&QAction::triggered,
+		this,			&KsRmPlotContextMenu::removePlot);
+
+	addAction(&_removePlotAction);
+}
+
+/**
+ * @brief Create KsRmCPUPlotMenu.
+ *
+ * @param dm: The State machine of the Dual marker.
+ * @param cpu : CPU Id.
+ * @param parent: The parent of this widget.
+ */
+KsRmCPUPlotMenu::KsRmCPUPlotMenu(KsDualMarkerSM *dm, int cpu,
+				 QWidget *parent)
+: KsRmPlotContextMenu(dm, parent)
+{
+	_removePlotAction.setText(QString("Remove [CPU %1]").arg(cpu));
+}
+
+/**
+ * @brief Create KsRmTaskPlotMenu.
+ *
+ * @param dm: The State machine of the Dual marker.
+ * @param pid: Process Id.
+ * @param parent: The parent of this widget.
+ */
+KsRmTaskPlotMenu::KsRmTaskPlotMenu(KsDualMarkerSM *dm, int pid,
+				   QWidget *parent)
+: KsRmPlotContextMenu(dm, parent)
+{
+	kshark_context *kshark_ctx(nullptr);
+	QString descr("Remove [ ");
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	descr +=3D tep_data_comm_from_pid(kshark_ctx->pevent, pid);
+	descr +=3D "-";
+	descr +=3D QString("%1").arg(pid);
+	descr +=3D "] plot";
+	_removePlotAction.setText(descr);
+}
diff --git a/kernel-shark-qt/src/KsQuickContextMenu.hpp b/kernel-shark-qt/s=
rc/KsQuickContextMenu.hpp
new file mode 100644
index 0000000..040942f
--- /dev/null
+++ b/kernel-shark-qt/src/KsQuickContextMenu.hpp
@@ -0,0 +1,136 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    KsQuickContextMenu.hpp
+ *  @brief   Quick Context Menus for KernelShark.
+ */
+
+#ifndef _KS_QUICK_CTX_MENU_H
+#define _KS_QUICK_CTX_MENU_H
+
+#include "KsDualMarker.hpp"
+#include "KsUtils.hpp"
+#include "KsGLWidget.hpp"
+
+/**
+ * The KsQuickMarkerMenu class provides menu for quick Dual Marker related
+ * actions.
+ */
+class KsQuickMarkerMenu : public QMenu {
+	Q_OBJECT
+public:
+	KsQuickMarkerMenu(KsDualMarkerSM *dm, QWidget *parent =3D nullptr);
+
+signals:
+	/** Signal to deselect the active marker. */
+	void deselect();
+
+private:
+	KsDualMarkerSM	*_dm;
+
+	QAction _deselectAction;
+};
+
+/**
+ * The KsQuickFilterMenu class provides a menu for easy filtering and plot=
ting.
+ * The menu is initialized from a single kshark_entry and uses the content=
 of
+ * this entry to provides quick actions for filtering and plottin.
+ */
+class KsQuickContextMenu : public KsQuickMarkerMenu {
+	Q_OBJECT
+public:
+	KsQuickContextMenu() =3D delete;
+
+	KsQuickContextMenu(KsDataStore *data, size_t row,
+			   KsDualMarkerSM *dm,
+			   QWidget *parent =3D nullptr);
+
+signals:
+	/** Signal to add a task plot. */
+	void addTaskPlot(int);
+
+	/** Signal to add a CPU plot. */
+	void addCPUPlot(int);
+
+	/** Signal to remove a task plot. */
+	void removeTaskPlot(int);
+
+	/** Signal to remove a CPU plot. */
+	void removeCPUPlot(int);
+
+private:
+	void _hideTask();
+
+	void _showTask();
+
+	void _hideEvent();
+
+	void _showEvent();
+
+	void _addCPUPlot();
+
+	void _addTaskPlot();
+
+	void _removeCPUPlot();
+
+	void _removeTaskPlot();
+
+	KsDataStore	*_data;
+
+	size_t		_row;
+
+	QAction _hideTaskAction, _showTaskAction;
+
+	QAction _hideEventAction, _showEventAction;
+
+	QAction _addCPUPlotAction;
+
+	QAction _addTaskPlotAction;
+
+	QAction _removeCPUPlotAction;
+
+	QAction _removeTaskPlotAction;
+
+	QAction _deselectAction;
+};
+
+/**
+ * The KsQuickMarkerMenu is a baser class for Remove Plot menus.
+ */
+class KsRmPlotContextMenu : public KsQuickMarkerMenu {
+	Q_OBJECT
+public:
+	KsRmPlotContextMenu() =3D delete;
+
+	KsRmPlotContextMenu(KsDualMarkerSM *dm, QWidget *parent =3D nullptr);
+
+signals:
+	/** Signal to remove a plot. */
+	void removePlot(int);
+
+protected:
+	/** Menu action. */
+	QAction _removePlotAction;
+};
+
+/**
+ * The KsQuickMarkerMenu class provides CPU Plot remove menus.
+ */
+struct KsRmCPUPlotMenu : public KsRmPlotContextMenu {
+	KsRmCPUPlotMenu(KsDualMarkerSM *dm, int cpu,
+			QWidget *parent =3D nullptr);
+};
+
+/**
+ * The KsQuickMarkerMenu class provides Task Plot remove menus.
+ */
+struct KsRmTaskPlotMenu : public KsRmPlotContextMenu {
+	KsRmTaskPlotMenu(KsDualMarkerSM *dm, int pid,
+			 QWidget *parent =3D nullptr);
+};
+
+#endif
diff --git a/kernel-shark-qt/src/KsTraceGraph.cpp b/kernel-shark-qt/src/KsT=
raceGraph.cpp
index 29a5950..09b322a 100644
--- a/kernel-shark-qt/src/KsTraceGraph.cpp
+++ b/kernel-shark-qt/src/KsTraceGraph.cpp
@@ -13,6 +13,7 @@
 #include "KsUtils.hpp"
 #include "KsDualMarker.hpp"
 #include "KsTraceGraph.hpp"
+#include "KsQuickContextMenu.hpp"
=20
 /** Create a default (empty) Trace graph widget. */
 KsTraceGraph::KsTraceGraph(QWidget *parent)
@@ -134,6 +135,10 @@ KsTraceGraph::KsTraceGraph(QWidget *parent)
 	connect(_glWindow.model(),	&KsGraphModel::modelReset,
 		this,			&KsTraceGraph::_updateTimeLegends);
=20
+	_glWindow.setContextMenuPolicy(Qt::CustomContextMenu);
+	connect(&_glWindow,	&QTableView::customContextMenuRequested,
+		this,		&KsTraceGraph::_onCustomContextMenu);
+
 	_scrollArea.setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
 	_scrollArea.setWidget(&_drawWindow);
=20
@@ -447,6 +452,26 @@ void KsTraceGraph::addTaskPlot(int pid)
 	_selfUpdate();
 }
=20
+/** Remove a CPU graph from the existing list of CPU graphs. */
+void KsTraceGraph::removeCPUPlot(int cpu)
+{
+	if (!_glWindow._cpuList.contains(cpu))
+		return;
+
+	_glWindow._cpuList.removeAll(cpu);
+	_selfUpdate();
+}
+
+/** Remove a Task graph from the existing list of Task graphs. */
+void KsTraceGraph::removeTaskPlot(int pid)
+{
+	if (!_glWindow._taskList.contains(pid))
+		return;
+
+	_glWindow._taskList.removeAll(pid);
+	_selfUpdate();
+}
+
 /** Update the content of all graphs. */
 void KsTraceGraph::update(KsDataStore *data)
 {
@@ -689,3 +714,72 @@ void KsTraceGraph::_updateGraphs(GraphActions action)
 		QCoreApplication::processEvents();
 	}
 }
+
+void KsTraceGraph::_onCustomContextMenu(const QPoint &point)
+{
+	KsQuickMarkerMenu *menu(nullptr);
+	int cpu, pid;
+	size_t row;
+	bool found;
+
+	found =3D _glWindow.find(point, 20, true, &row);
+	if (found) {
+		/* KernelShark entry has been found under the cursor. */
+		KsQuickContextMenu *entryMenu;
+		menu =3D entryMenu =3D new KsQuickContextMenu(_data, row,
+							  _mState, this);
+
+		connect(entryMenu,	&KsQuickContextMenu::addTaskPlot,
+			this,		&KsTraceGraph::addTaskPlot);
+
+		connect(entryMenu,	&KsQuickContextMenu::addCPUPlot,
+			this,		&KsTraceGraph::addCPUPlot);
+
+		connect(entryMenu,	&KsQuickContextMenu::removeTaskPlot,
+			this,		&KsTraceGraph::removeTaskPlot);
+
+		connect(entryMenu,	&KsQuickContextMenu::removeCPUPlot,
+			this,		&KsTraceGraph::removeCPUPlot);
+	} else {
+		cpu =3D _glWindow.getPlotCPU(point);
+		if (cpu >=3D 0) {
+			/*
+			 * This is a CPU plot, but we do not have an entry
+			 * under the cursor.
+			 */
+			KsRmCPUPlotMenu *rmMenu;
+			menu =3D rmMenu =3D new KsRmCPUPlotMenu(_mState, cpu, this);
+
+			auto lamRmPlot =3D [&cpu, this] () {
+				removeCPUPlot(cpu);
+			};
+
+			connect(rmMenu, &KsRmPlotContextMenu::removePlot,
+				lamRmPlot);
+		}
+
+		pid =3D _glWindow.getPlotPid(point);
+		if (pid >=3D 0) {
+			/*
+			 * This is a Task plot, but we do not have an entry
+			 * under the cursor.
+			 */
+			KsRmTaskPlotMenu *rmMenu;
+			menu =3D rmMenu =3D new KsRmTaskPlotMenu(_mState, pid, this);
+
+			auto lamRmPlot =3D [&pid, this] () {
+				removeTaskPlot(pid);
+			};
+
+			connect(rmMenu, &KsRmPlotContextMenu::removePlot,
+				lamRmPlot);
+		}
+	}
+
+	if (menu) {
+		connect(menu,	&KsQuickMarkerMenu::deselect,
+			this,	&KsTraceGraph::deselect);
+
+		menu->exec(mapToGlobal(point));
+	}
+}
diff --git a/kernel-shark-qt/src/KsTraceGraph.hpp b/kernel-shark-qt/src/KsT=
raceGraph.hpp
index 395cc1b..c53258c 100644
--- a/kernel-shark-qt/src/KsTraceGraph.hpp
+++ b/kernel-shark-qt/src/KsTraceGraph.hpp
@@ -60,6 +60,10 @@ public:
=20
 	void addTaskPlot(int);
=20
+	void removeCPUPlot(int);
+
+	void removeTaskPlot(int);
+
 	void update(KsDataStore *data);
=20
 	void updateGeom();
@@ -68,6 +72,14 @@ public:
=20
 	bool eventFilter(QObject* obj, QEvent* evt) override;
=20
+signals:
+	/**
+	 * This signal is emitted in the case of a right mouse button click or
+	 * in the case of a double click over an empty area (no visible
+	 * KernelShark entries).
+	 */
+	void deselect();
+
 private:
=20
 	void _zoomIn();
@@ -105,6 +117,8 @@ private:
=20
 	void _updateGraphs(GraphActions action);
=20
+	void _onCustomContextMenu(const QPoint &point);
+
 	QToolBar	_pointerBar, _navigationBar;
=20
 	QPushButton	_zoomInButton, _quickZoomInButton;
diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/Ks=
TraceViewer.cpp
index 64c9fb7..d52d7e3 100644
--- a/kernel-shark-qt/src/KsTraceViewer.cpp
+++ b/kernel-shark-qt/src/KsTraceViewer.cpp
@@ -14,9 +14,22 @@
 #include <future>
=20
 // KernelShark
+#include "KsQuickContextMenu.hpp"
 #include "KsTraceViewer.hpp"
 #include "KsWidgetsLib.hpp"
=20
+/**
+ * Reimplemented handler for mouse press events. Right mouse click events =
will
+ * be ignored. This is done because we want the Right click is being used =
to
+ * open a Context menu.
+ */
+void KsTableView::mousePressEvent(QMouseEvent *e) {
+	if(e->button() =3D=3D Qt::RightButton)
+		return;
+
+	QTableView::mousePressEvent(e);
+}
+
 /** Create a default (empty) Trace viewer widget. */
 KsTraceViewer::KsTraceViewer(QWidget *parent)
 : QWidget(parent),
@@ -248,10 +261,13 @@ void KsTraceViewer::_onCustomContextMenu(const QPoint=
 &point)
 		 * of the row number in the source model.
 		 */
 		size_t row =3D _proxyModel.mapRowFromSource(i.row());
-		KsQuickEntryMenu menu(_data, row, this);
+		KsQuickContextMenu menu(_data, row, _mState, this);
=20
-		connect(&menu,	&KsQuickEntryMenu::plotTask,
-			this,	&KsTraceViewer::plotTask);
+		connect(&menu,	&KsQuickContextMenu::addTaskPlot,
+			this,	&KsTraceViewer::addTaskPlot);
+
+		connect(&menu,	&KsQuickMarkerMenu::deselect,
+			this,	&KsTraceViewer::deselect);
=20
 		menu.exec(mapToGlobal(point));
 	}
@@ -424,8 +440,10 @@ void KsTraceViewer::_clicked(const QModelIndex& i)
 	 */
 	size_t row =3D _proxyModel.mapRowFromSource(i.row());
=20
-	_setSearchIterator(row);
-	_updateSearchCount();
+	if (_searchDone && _matchList.count()) {
+		_setSearchIterator(row);
+		_updateSearchCount();
+	}
=20
 	if (_graphFollows)
 		emit select(row); // Send a signal to the Graph widget.
@@ -460,7 +478,7 @@ void KsTraceViewer::showRow(size_t r, bool mark)
 }
=20
 /** Deselects the selected items (row) if any. */
-void KsTraceViewer::deselect()
+void KsTraceViewer::clearSelection()
 {
 	_view.clearSelection();
 }
diff --git a/kernel-shark-qt/src/KsTraceViewer.hpp b/kernel-shark-qt/src/Ks=
TraceViewer.hpp
index 50c9115..4e35c17 100644
--- a/kernel-shark-qt/src/KsTraceViewer.hpp
+++ b/kernel-shark-qt/src/KsTraceViewer.hpp
@@ -20,6 +20,21 @@
 #include "KsModels.hpp"
 #include "KsDualMarker.hpp"
=20
+/**
+ * Table View class, needed in order to reimplemented the handler for mous=
e
+ * press events.
+ */
+class KsTableView : public QTableView
+{
+	Q_OBJECT
+public:
+	/** Create KsTableView. */
+	explicit KsTableView(QWidget *parent =3D nullptr)
+	: QTableView(parent) {};
+
+	void mousePressEvent(QMouseEvent *event) override;
+};
+
 /**
  * The KsTraceViewer class provides a widget for browsing in the trace dat=
a
  * shown in a text form.
@@ -48,7 +63,7 @@ public:
=20
 	void showRow(size_t r, bool mark);
=20
-	void deselect();
+	void clearSelection();
=20
 	void update(KsDataStore *data);
=20
@@ -57,15 +72,21 @@ signals:
 	void select(size_t);
=20
 	/**
-	 * This signal is used to re-emitted the plotTask signal of the
-	 * KsQuickEntryMenu.
+	 * This signal is used to re-emitted the addTaskPlot signal of the
+	 * KsQuickContextMenu.
 	 */
-	void plotTask(int pid);
+	void addTaskPlot(int pid);
+
+	/**
+	 * This signal is used to re-emitted the deselect signal of the
+	 * KsQuickMarkerMenu.
+	 */
+	void deselect();
=20
 private:
 	QVBoxLayout	_layout;
=20
-	QTableView	_view;
+	KsTableView	_view;
=20
 	KsViewModel		_model;
=20
@@ -145,7 +166,6 @@ private:
 	int _getSelectedDataRow();
=20
 private slots:
-
 	void _searchEdit(int);
 };
=20
diff --git a/kernel-shark-qt/src/KsWidgetsLib.cpp b/kernel-shark-qt/src/KsW=
idgetsLib.cpp
index 191ea7d..4b41f86 100644
--- a/kernel-shark-qt/src/KsWidgetsLib.cpp
+++ b/kernel-shark-qt/src/KsWidgetsLib.cpp
@@ -798,123 +798,3 @@ KsPluginCheckBoxWidget::KsPluginCheckBoxWidget(QStrin=
gList pluginList,
=20
 	_adjustSize();
 }
-
-/**
- * @brief Create KsQuickEntryMenu.
- *
- * @param data: Input location for the KsDataStore object.
- * @param row: The index of the entry used to initialize the menu.
- * @param parent: The parent of this widget.
- */
-KsQuickEntryMenu::KsQuickEntryMenu(KsDataStore *data, size_t row,
-				   QWidget *parent)
-: QMenu("Entry menu", parent),
-  _data(data),
-  _row(row),
-  _hideTaskAction(this),
-  _showTaskAction(this),
-  _hideEventAction(this),
-  _showEventAction(this),
-  _addTaskPlotAction(this)
-{
-	QString descr;
-
-	addSection("Quick Filter menu");
-
-	descr =3D "Hide task [";
-	descr +=3D kshark_get_task_easy(_data->rows()[_row]);
-	descr +=3D "-";
-	descr +=3D QString("%1").arg(_data->rows()[_row]->pid);
-	descr +=3D "]";
-
-	_hideTaskAction.setText(descr);
-
-	connect(&_hideTaskAction,	&QAction::triggered,
-		this,			&KsQuickEntryMenu::_hideTask);
-
-	addAction(&_hideTaskAction);
-
-	descr =3D "Show task [";
-	descr +=3D kshark_get_task_easy(_data->rows()[_row]);
-	descr +=3D "-";
-	descr +=3D QString("%1").arg(_data->rows()[_row]->pid);
-	descr +=3D "] only";
-
-	_showTaskAction.setText(descr);
-
-	connect(&_showTaskAction,	&QAction::triggered,
-		this,			&KsQuickEntryMenu::_showTask);
-
-	addAction(&_showTaskAction);
-
-	descr =3D "Hide event [";
-	descr +=3D kshark_get_event_name_easy(_data->rows()[_row]);
-	descr +=3D "]";
-
-	_hideEventAction.setText(descr);
-
-	connect(&_hideEventAction,	&QAction::triggered,
-		this,			&KsQuickEntryMenu::_hideEvent);
-
-	addAction(&_hideEventAction);
-
-	descr =3D "Show event [";
-	descr +=3D kshark_get_event_name_easy(_data->rows()[_row]);
-	descr +=3D "] only";
-
-	_showEventAction.setText(descr);
-
-	connect(&_showEventAction,	&QAction::triggered,
-		this,			&KsQuickEntryMenu::_showEvent);
-
-	addAction(&_showEventAction);
-
-	addSection("Quick Plot menu");
-	descr =3D "Add [";
-	descr +=3D kshark_get_task_easy(_data->rows()[_row]);
-	descr +=3D "-";
-	descr +=3D QString("%1").arg(_data->rows()[_row]->pid);
-	descr +=3D "] plot";
-
-	_addTaskPlotAction.setText(descr);
-
-	connect(&_addTaskPlotAction,	&QAction::triggered,
-		this,			&KsQuickEntryMenu::_addTaskPlot);
-
-	addAction(&_addTaskPlotAction);
-}
-
-void KsQuickEntryMenu::_hideTask()
-{
-	int pid =3D kshark_get_pid_easy(_data->rows()[_row]);
-
-	_data->applyNegTaskFilter(QVector<int>(1, pid));
-}
-
-void KsQuickEntryMenu::_showTask()
-{
-	int pid =3D kshark_get_pid_easy(_data->rows()[_row]);
-
-	_data->applyPosTaskFilter(QVector<int>(1, pid));
-}
-
-void KsQuickEntryMenu::_hideEvent()
-{
-	int eventId =3D kshark_get_event_id_easy(_data->rows()[_row]);
-
-	_data->applyNegEventFilter(QVector<int>(1, eventId));
-}
-
-void KsQuickEntryMenu::_showEvent()
-{
-	int eventId =3D kshark_get_event_id_easy(_data->rows()[_row]);
-
-	_data->applyPosEventFilter(QVector<int>(1, eventId));
-}
-
-void KsQuickEntryMenu::_addTaskPlot()
-{
-	int pid =3D kshark_get_pid_easy(_data->rows()[_row]);
-
-	emit plotTask(pid);
-}
diff --git a/kernel-shark-qt/src/KsWidgetsLib.hpp b/kernel-shark-qt/src/KsW=
idgetsLib.hpp
index c09bcd5..6f22374 100644
--- a/kernel-shark-qt/src/KsWidgetsLib.hpp
+++ b/kernel-shark-qt/src/KsWidgetsLib.hpp
@@ -347,48 +347,4 @@ struct KsPluginCheckBoxWidget : public KsCheckBoxTable=
Widget
 			       QWidget *parent =3D nullptr);
 };
=20
-class KsDataStore;
-class KsGLWidget;
-
-/**
- * The KsQuickFilterMenu class provides a menu for easy filtering and plot=
ting.
- * The menu is initialized from a single kshark_entry and uses the content=
 of
- * this entry to provides quick actions for filtering and plottin.
- */
-class KsQuickEntryMenu : public QMenu
-{
-	Q_OBJECT
-public:
-	KsQuickEntryMenu() =3D delete;
-
-	explicit KsQuickEntryMenu(KsDataStore *data,
-				  size_t row,
-				  QWidget *parent =3D nullptr);
-
-signals:
-	/** Signal to add a task plot. */
-	void plotTask(int);
-
-private:
-	void _hideTask();
-
-	void _showTask();
-
-	void _hideEvent();
-
-	void _showEvent();
-
-	void _addTaskPlot();
-
-	KsDataStore	*_data;
-
-	size_t		 _row;
-
-	QAction _hideTaskAction, _showTaskAction;
-
-	QAction _hideEventAction, _showEventAction;
-
-	QAction _addTaskPlotAction;
-};
-
 #endif
--=20
2.17.1
