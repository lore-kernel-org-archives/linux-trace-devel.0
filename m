Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam01on0073.outbound.protection.outlook.com ([104.47.32.73]:27872
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727242AbeJPXoW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:44:22 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v2 06/23] kernel-shark-qt: Add widget for OpenGL rendering
Date: Tue, 16 Oct 2018 15:53:03 +0000
Message-ID: <20181016155232.5257-7-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

This patch defines the widget for rendering OpenGL graphics used
to plot trace graphs.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/CMakeLists.txt   |   2 +
 kernel-shark-qt/src/KsDualMarker.cpp |  12 +-
 kernel-shark-qt/src/KsDualMarker.hpp |   4 +-
 kernel-shark-qt/src/KsGLWidget.cpp   | 913 +++++++++++++++++++++++++++
 kernel-shark-qt/src/KsGLWidget.hpp   | 220 +++++++
 5 files changed, 1146 insertions(+), 5 deletions(-)
 create mode 100644 kernel-shark-qt/src/KsGLWidget.cpp
 create mode 100644 kernel-shark-qt/src/KsGLWidget.hpp

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMake=
Lists.txt
index 3f40930..2ca5187 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -33,6 +33,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
     message(STATUS "libkshark-gui")
     set (ks-guiLib_hdr  KsUtils.hpp
                         KsModels.hpp
+                        KsGLWidget.hpp
                         KsDualMarker.hpp
                         KsWidgetsLib.hpp
                         KsTraceViewer.hpp)
@@ -41,6 +42,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
=20
     add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp
                                                             KsModels.cpp
+                                                            KsGLWidget.cpp
                                                             KsDualMarker.c=
pp
                                                             KsWidgetsLib.c=
pp
                                                             KsTraceViewer.=
cpp)
diff --git a/kernel-shark-qt/src/KsDualMarker.cpp b/kernel-shark-qt/src/KsD=
ualMarker.cpp
index ae637aa..ef126f7 100644
--- a/kernel-shark-qt/src/KsDualMarker.cpp
+++ b/kernel-shark-qt/src/KsDualMarker.cpp
@@ -10,6 +10,7 @@
  */
=20
 #include "KsDualMarker.hpp"
+#include "KsGLWidget.hpp"
=20
 /**
  * @brief Create KsGraphMark object.
@@ -287,13 +288,16 @@ void KsDualMarkerSM::setState(DualMarkerState st) {
  *	  model has changed.
  *
  * @param data: Input location for the Data Store object.
- * @param histo: Input location for the model descriptor.
+ * @param glw: Input location for the OpenGL widget object.
  */
 void KsDualMarkerSM::updateMarkers(const KsDataStore &data,
-				   kshark_trace_histo *histo)
+				   KsGLWidget *glw)
 {
-	_markA.update(data, histo);
-	_markB.update(data, histo);
+	if(_markA.update(data, glw->model()->histo()))
+		glw->setMark(&_markA);
+
+	if(_markB.update(data, glw->model()->histo()))
+		glw->setMark(&_markB);
=20
 	updateLabels();
 }
diff --git a/kernel-shark-qt/src/KsDualMarker.hpp b/kernel-shark-qt/src/KsD=
ualMarker.hpp
index 401b41c..73d4f8a 100644
--- a/kernel-shark-qt/src/KsDualMarker.hpp
+++ b/kernel-shark-qt/src/KsDualMarker.hpp
@@ -19,6 +19,8 @@
 #include "KsUtils.hpp"
 #include "KsPlotTools.hpp"
=20
+class KsGLWidget;
+
 /** The KsGraphMark represents a marker for KernelShark GUI. */
 class KsGraphMark : public QObject
 {
@@ -124,7 +126,7 @@ public:
 	QState *stateBPtr() {return _stateB;}
=20
 	void updateMarkers(const KsDataStore &data,
-			   kshark_trace_histo *histo);
+			   KsGLWidget *glw);
=20
 	void updateLabels();
=20
diff --git a/kernel-shark-qt/src/KsGLWidget.cpp b/kernel-shark-qt/src/KsGLW=
idget.cpp
new file mode 100644
index 0000000..22cbd96
--- /dev/null
+++ b/kernel-shark-qt/src/KsGLWidget.cpp
@@ -0,0 +1,913 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+ /**
+ *  @file    KsGLWidget.cpp
+ *  @brief   OpenGL widget for plotting trace graphs.
+ */
+
+// OpenGL
+#include <GL/glut.h>
+#include <GL/gl.h>
+
+// KernelShark
+#include "KsGLWidget.hpp"
+#include "KsUtils.hpp"
+#include "KsPlugins.hpp"
+#include "KsDualMarker.hpp"
+
+/** Create a default (empty) OpenGL widget. */
+KsGLWidget::KsGLWidget(QWidget *parent)
+: QOpenGLWidget(parent),
+  _hMargin(20),
+  _vMargin(30),
+  _vSpacing(20),
+  _mState(nullptr),
+  _data(nullptr),
+  _rubberBand(QRubberBand::Rectangle, this),
+  _rubberBandOrigin(0, 0),
+  _dpr(1)
+{
+	setMouseTracking(true);
+
+	/*
+	 * Using the old Signal-Slot syntax because QWidget::update has
+	 * overloads.
+	 */
+	connect(&_model, SIGNAL(modelReset()), this, SLOT(update()));
+}
+
+/** Reimplemented function used to set up all required OpenGL resources. *=
/
+void KsGLWidget::initializeGL()
+{
+	_dpr =3D QApplication::desktop()->devicePixelRatio();
+	ksplot_init_opengl(_dpr);
+}
+
+/**
+ * Reimplemented function used to reprocess all graphs whene the widget ha=
s
+ * been resized.
+ */
+void KsGLWidget::resizeGL(int w, int h)
+{
+	ksplot_resize_opengl(w, h);
+	if(!_data)
+		return;
+
+	/*
+	 * From the size of the widget, calculate the number of bins.
+	 * One bin will correspond to one pixel.
+	 */
+	int nBins =3D width() - _hMargin * 2;
+
+	/*
+	 * Reload the data. The range of the histogram is the same
+	 * but the number of bins changes.
+	 */
+	ksmodel_set_bining(_model.histo(),
+			   nBins,
+			   _model.histo()->min,
+			   _model.histo()->max);
+
+	_model.fill(_data->rows(), _data->size());
+}
+
+/** Reimplemented function used to plot trace graphs. */
+void KsGLWidget::paintGL()
+{
+	glClear(GL_COLOR_BUFFER_BIT);
+
+	loadColors();
+
+	/* Draw the time axis. */
+	if(_data)
+		_drawAxisX();
+
+	/* Process and draw all graphs by using the built-in logic. */
+	_makeGraphs(_cpuList, _taskList);
+	for (auto const &g: _graphs)
+		g->draw(1.5 * _dpr);
+
+	/* Process and draw all plugin-specific shapes. */
+	_makePluginShapes(_cpuList, _taskList);
+	while (!_shapes.empty()) {
+		auto s =3D _shapes.front();
+		s->draw();
+		delete s;
+		_shapes.pop_front();
+	}
+
+	/*
+	 * Update and draw the markers. Make sure that the active marker
+	 * is drawn on top.
+	 */
+	_mState->updateMarkers(*_data, this);
+	_mState->passiveMarker().draw();
+	_mState->activeMarker().draw();
+}
+
+/** Reimplemented event handler used to receive mouse press events. */
+void KsGLWidget::mousePressEvent(QMouseEvent *event)
+{
+	if (event->button() =3D=3D Qt::LeftButton) {
+		_posMousePress =3D _posInRange(event->pos().x());
+		_rangeBoundInit(_posMousePress);
+	} else if (event->button() =3D=3D Qt::RightButton) {
+		emit deselect();
+		_mState->activeMarker().remove();
+		_mState->updateLabels();
+		_model.update();
+	}
+}
+
+int KsGLWidget::_getLastTask(struct kshark_trace_histo *histo,
+			     int bin, int cpu)
+{
+	kshark_context *kshark_ctx(nullptr);
+	kshark_entry_collection *col;
+	int pid;
+
+	if (!kshark_instance(&kshark_ctx))
+		return KS_EMPTY_BIN;
+
+	col =3D kshark_find_data_collection(kshark_ctx->collections,
+					  KsUtils::matchCPUVisible,
+					  cpu);
+
+	for (int b =3D bin; b >=3D 0; --b) {
+		pid =3D ksmodel_get_pid_back(histo, b, cpu, false, col, nullptr);
+		if (pid >=3D 0)
+			return pid;
+	}
+
+	return ksmodel_get_pid_back(histo, LOWER_OVERFLOW_BIN,
+					   cpu,
+					   false,
+					   col,
+					   nullptr);
+}
+
+int KsGLWidget::_getLastCPU(struct kshark_trace_histo *histo,
+			     int bin, int pid)
+{
+	kshark_context *kshark_ctx(nullptr);
+	kshark_entry_collection *col;
+	int cpu;
+
+	if (!kshark_instance(&kshark_ctx))
+		return KS_EMPTY_BIN;
+
+	col =3D kshark_find_data_collection(kshark_ctx->collections,
+					  kshark_match_pid,
+					  pid);
+
+	for (int b =3D bin; b >=3D 0; --b) {
+		cpu =3D ksmodel_get_cpu_back(histo, b, pid, false, col, nullptr);
+		if (cpu >=3D 0)
+			return cpu;
+	}
+
+	return ksmodel_get_cpu_back(histo, LOWER_OVERFLOW_BIN,
+					   pid,
+					   false,
+					   col,
+					   nullptr);
+
+}
+
+/** Reimplemented event handler used to receive mouse move events. */
+void KsGLWidget::mouseMoveEvent(QMouseEvent *event)
+{
+	int bin, cpu, pid;
+	size_t row;
+	bool ret;
+
+	if (_rubberBand.isVisible())
+		_rangeBoundStretched(_posInRange(event->pos().x()));
+
+	bin =3D event->pos().x() - _hMargin;
+	cpu =3D _getCPU(event->pos().y());
+	pid =3D _getPid(event->pos().y());
+
+	ret =3D _find(bin, cpu, pid, 5, false, &row);
+	if (ret) {
+		emit found(row);
+	} else {
+		if (cpu >=3D 0) {
+			pid =3D _getLastTask(_model.histo(), bin, cpu);
+		}
+
+		if (pid > 0) {
+			cpu =3D _getLastCPU(_model.histo(), bin, pid);
+		}
+
+		emit notFound(ksmodel_bin_ts(_model.histo(), bin), cpu, pid);
+	}
+}
+
+/** Reimplemented event handler used to receive mouse release events. */
+void KsGLWidget::mouseReleaseEvent(QMouseEvent *event)
+{
+	if (event->button() =3D=3D Qt::LeftButton) {
+		size_t posMouseRel =3D _posInRange(event->pos().x());
+		int min, max;
+		if (_posMousePress < posMouseRel) {
+			min =3D _posMousePress - _hMargin;
+			max =3D posMouseRel - _hMargin;
+		} else {
+			max =3D _posMousePress - _hMargin;
+			min =3D posMouseRel - _hMargin;
+		}
+
+		_rangeChanged(min, max);
+	}
+}
+
+/** Reimplemented event handler used to receive mouse double click events.=
 */
+void KsGLWidget::mouseDoubleClickEvent(QMouseEvent *event)
+{
+	if (event->button() =3D=3D Qt::LeftButton)
+		_findAndSelect(event);
+}
+
+/** Reimplemented event handler used to receive mouse wheel events. */
+void KsGLWidget::wheelEvent(QWheelEvent * event)
+{
+	int zoomFocus;
+
+	if (_mState->activeMarker()._isSet &&
+	    _mState->activeMarker().isVisible()) {
+		/*
+		 * Use the position of the marker as a focus point for the
+		 * zoom.
+		 */
+		zoomFocus =3D _mState->activeMarker()._bin;
+	} else {
+		/*
+		 * Use the position of the mouse as a focus point for the
+		 * zoom.
+		 */
+		zoomFocus =3D event->pos().x() - _hMargin;
+	}
+
+	if (event->delta() > 0) {
+		_model.zoomIn(.05, zoomFocus);
+	} else {
+		_model.zoomOut(.05, zoomFocus);
+	}
+
+	_mState->updateMarkers(*_data, this);
+}
+
+/** Reimplemented event handler used to receive key press events. */
+void KsGLWidget::keyPressEvent(QKeyEvent *event)
+{
+	if (event->isAutoRepeat())
+		return;
+
+	switch (event->key()) {
+	case Qt::Key_Plus:
+		emit zoomIn();
+		return;
+
+	case Qt::Key_Minus:
+		emit zoomOut();
+		return;
+
+	case Qt::Key_Left:
+		emit scrollLeft();
+		return;
+
+	case Qt::Key_Right:
+		emit scrollRight();
+		return;
+
+	default:
+		QOpenGLWidget::keyPressEvent(event);
+		return;
+	}
+}
+
+/** Reimplemented event handler used to receive key release events. */
+void KsGLWidget::keyReleaseEvent(QKeyEvent *event)
+{
+	if (event->isAutoRepeat())
+		return;
+
+	if(event->key() =3D=3D Qt::Key_Plus ||
+	   event->key() =3D=3D Qt::Key_Minus ||
+	   event->key() =3D=3D Qt::Key_Left ||
+	   event->key() =3D=3D Qt::Key_Right) {
+		emit stopUpdating();
+		return;
+	}
+
+	QOpenGLWidget::keyPressEvent(event);
+	return;
+}
+
+/**
+ * @brief Load and show trace data.
+ *
+ * @param data: Input location for the KsDataStore object.
+ *	  KsDataStore::loadDataFile() must be called first.
+ */
+void KsGLWidget::loadData(KsDataStore *data)
+{
+	uint64_t tMin, tMax;
+	int nCPUs, nBins;
+
+	_data =3D data;
+
+	/*
+	 * From the size of the widget, calculate the number of bins.
+	 * One bin will correspond to one pixel.
+	 */
+	nBins =3D width() - _hMargin * 2;
+	nCPUs =3D tep_get_cpus(_data->tep());
+
+	_model.reset();
+
+	/* Now load the entire set of trace data. */
+	tMin =3D _data->rows()[0]->ts;
+	tMax =3D _data->rows()[_data->size() - 1]->ts;
+	ksmodel_set_bining(_model.histo(), nBins, tMin, tMax);
+	_model.fill(_data->rows(), _data->size());
+
+	/* Make a default CPU list. All CPUs will be plotted. */
+	_cpuList =3D {};
+	for (int i =3D 0; i < nCPUs; ++i)
+		_cpuList.append(i);
+
+	/* Make a default task list. No tasks will be plotted. */
+	_taskList =3D {};
+
+	loadColors();
+	_makeGraphs(_cpuList, _taskList);
+}
+
+/**
+ * Create a Hash table of Rainbow colors. The sorted Pid values are mapped=
 to
+ * the palette of Rainbow colors.
+ */
+void KsGLWidget::loadColors()
+{
+	_pidColors.clear();
+	_pidColors =3D KsPlot::getColorTable();
+}
+
+/**
+ * Position the graphical elements of the marker according to the current
+ * position of the graphs inside the GL widget.
+ */
+void KsGLWidget::setMark(KsGraphMark *mark)
+{
+	mark->_mark.setDPR(_dpr);
+	mark->_mark.setX(mark->_bin + _hMargin);
+	mark->_mark.setY(_vMargin / 2 + 2, height() - _vMargin);
+
+	if (mark->_cpu >=3D 0) {
+		mark->_mark.setCPUY(_graphs[mark->_cpu]->getBase());
+		mark->_mark.setCPUVisible(true);
+	} else {
+		mark->_mark.setCPUVisible(false);
+	}
+
+	if (mark->_task >=3D 0) {
+		mark->_mark.setTaskY(_graphs[mark->_task]->getBase());
+		mark->_mark.setTaskVisible(true);
+	} else {
+		mark->_mark.setTaskVisible(false);
+	}
+}
+
+/**
+ * @brief Check if a given KernelShark entry is ploted.
+ *
+ * @param e: Input location for the KernelShark entry.
+ * @param graphCPU: Output location for index of the CPU graph to which th=
is
+ *		    entry belongs. If such a graph does not exist the outputted
+ *		    value is "-1".
+ * @param graphTask: Output location for index of the Task graph to which =
this
+ *		     entry belongs. If such a graph does not exist the
+ *		     outputted value is "-1".
+ */
+void KsGLWidget::findGraphIds(const kshark_entry &e,
+			      int *graphCPU,
+			      int *graphTask)
+{
+	int graph(0);
+	bool cpuFound(false), taskFound(false);
+
+	/*
+	 * Loop over all CPU graphs and try to find the one that
+	 * contains the entry.
+	 */
+	for (auto const &c: _cpuList) {
+		if (c =3D=3D e.cpu) {
+			cpuFound =3D true;
+			break;
+		}
+		++graph;
+	}
+
+	if (cpuFound)
+		*graphCPU =3D graph;
+	else
+		*graphCPU =3D -1;
+
+	/*
+	 * Loop over all Task graphs and try to find the one that
+	 * contains the entry.
+	 */
+	graph =3D _cpuList.count();
+	for (auto const &p: _taskList) {
+		if (p =3D=3D e.pid) {
+			taskFound =3D true;
+			break;
+		}
+		++graph;
+	}
+
+	if (taskFound)
+		*graphTask =3D graph;
+	else
+		*graphTask =3D -1;
+}
+
+void KsGLWidget::_drawAxisX()
+{
+	KsPlot::Point a0(_hMargin, _vMargin / 4), a1(_hMargin, _vMargin / 2);
+	KsPlot::Point b0(width()/2, _vMargin / 4), b1(width() / 2, _vMargin / 2);
+	KsPlot::Point c0(width() - _hMargin, _vMargin / 4),
+			 c1(width() - _hMargin, _vMargin / 2);
+	int lineSize =3D 2 * _dpr;
+
+	a0._size =3D c0._size =3D _dpr;
+
+	a0.draw();
+	c0.draw();
+	KsPlot::drawLine(a0, a1, {}, lineSize);
+	KsPlot::drawLine(b0, b1, {}, lineSize);
+	KsPlot::drawLine(c0, c1, {}, lineSize);
+	KsPlot::drawLine(a0, c0, {}, lineSize);
+}
+
+void KsGLWidget::_makeGraphs(QVector<int> cpuList, QVector<int> taskList)
+{
+	/* The very first thing to do is to clean up. */
+	for (auto &g: _graphs)
+		delete g;
+	_graphs.resize(0);
+
+	if (!_data || !_data->size())
+		return;
+
+	auto lamAddGraph =3D [&](KsPlot::Graph *graph) {
+		/*
+		* Calculate the base level of the CPU graph inside the widget.
+		* Remember that the "Y" coordinate is inverted.
+		*/
+		if (!graph)
+			return;
+
+		int base =3D _vMargin +
+			   _vSpacing * _graphs.count() +
+			   KS_GRAPH_HEIGHT * (_graphs.count() + 1);
+
+		graph->setBase(base);
+		_graphs.append(graph);
+	};
+
+	/* Create CPU graphs according to the cpuList. */
+	for (auto const &cpu: cpuList)
+		lamAddGraph(_newCPUGraph(cpu));
+
+	/* Create Task graphs taskList to the taskList. */
+	for (auto const &pid: taskList)
+		lamAddGraph(_newTaskGraph(pid));
+}
+
+void KsGLWidget::_makePluginShapes(QVector<int> cpuList, QVector<int> task=
List)
+{
+	kshark_context *kshark_ctx(nullptr);
+	kshark_event_handler *evt_handlers;
+	KsCppArgV cppArgv;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	cppArgv._histo =3D _model.histo();
+	cppArgv._shapes =3D &_shapes;
+
+	for (int g =3D 0; g < cpuList.count(); ++g) {
+		cppArgv._graph =3D _graphs[g];
+		evt_handlers =3D kshark_ctx->event_handlers;
+		while (evt_handlers) {
+			evt_handlers->draw_func(cppArgv.toC(),
+						cpuList[g],
+						KSHARK_PLUGIN_CPU_DRAW);
+
+			evt_handlers =3D evt_handlers->next;
+		}
+	}
+
+	for (int g =3D 0; g < taskList.count(); ++g) {
+		cppArgv._graph =3D _graphs[cpuList.count() + g];
+		evt_handlers =3D kshark_ctx->event_handlers;
+		while (evt_handlers) {
+			evt_handlers->draw_func(cppArgv.toC(),
+						taskList[g],
+						KSHARK_PLUGIN_TASK_DRAW);
+
+			evt_handlers =3D evt_handlers->next;
+		}
+	}
+}
+
+KsPlot::Graph *KsGLWidget::_newCPUGraph(int cpu)
+{
+	KsPlot::Graph *graph =3D new KsPlot::Graph(_model.histo(),
+						 &_pidColors);
+	kshark_context *kshark_ctx(nullptr);
+	kshark_entry_collection *col;
+
+	if (!kshark_instance(&kshark_ctx))
+		return nullptr;
+
+	graph->setHMargin(_hMargin);
+	graph->setHeight(KS_GRAPH_HEIGHT);
+
+	col =3D kshark_find_data_collection(kshark_ctx->collections,
+					  KsUtils::matchCPUVisible,
+					  cpu);
+
+	graph->setDataCollectionPtr(col);
+	graph->fillCPUGraph(cpu);
+
+	return graph;
+}
+
+KsPlot::Graph *KsGLWidget::_newTaskGraph(int pid)
+{
+	KsPlot::Graph *graph =3D new KsPlot::Graph(_model.histo(),
+						 &_pidColors);
+	kshark_context *kshark_ctx(nullptr);
+	kshark_entry_collection *col;
+
+	if (!kshark_instance(&kshark_ctx))
+		return nullptr;
+
+	graph->setHMargin(_hMargin);
+	graph->setHeight(KS_GRAPH_HEIGHT);
+
+	col =3D kshark_find_data_collection(kshark_ctx->collections,
+					  kshark_match_pid, pid);
+	if (!col) {
+		/*
+		 * If a data collection for this task does not exist,
+		 * register a new one.
+		 */
+		col =3D kshark_register_data_collection(kshark_ctx,
+						      _data->rows(),
+						      _data->size(),
+						      kshark_match_pid, pid,
+						      25);
+	}
+
+	/*
+	 * Data collections are efficient only when used on graphs, having a
+	 * lot of empty bins.
+	 * TODO: Determine the optimal criteria to decide whether to use or
+	 * not use data collection for this graph.
+	 */
+	if (_data->size() < 1e6 &&
+	    col && col->size &&
+	    _data->size() / col->size < 100) {
+		/*
+		 * No need to use collection in this case. Free the collection
+		 * data, but keep the collection registered. This will prevent
+		 * from recalculating the same collection next time when this
+		 * task is ploted.
+		 */
+		kshark_reset_data_collection(col);
+	}
+
+	graph->setDataCollectionPtr(col);
+	graph->fillTaskGraph(pid);
+
+	return graph;
+}
+
+bool KsGLWidget::_find(QMouseEvent *event, int variance, bool joined,
+		       size_t *row)
+{
+	/*
+	 * Get the bin, pid and cpu numbers.
+	 * Remember that one bin corresponds to one pixel.
+	 */
+	int bin =3D event->pos().x() - _hMargin;
+	int cpu =3D _getCPU(event->pos().y());
+	int pid =3D _getPid(event->pos().y());
+
+	return _find(bin, cpu, pid, variance, joined, row);
+}
+
+int KsGLWidget::_getNextCPU(int pid, int bin)
+{
+	kshark_context *kshark_ctx(nullptr);
+	kshark_entry_collection *col;
+	int cpu;
+
+	if (!kshark_instance(&kshark_ctx))
+		return KS_EMPTY_BIN;
+
+	col =3D kshark_find_data_collection(kshark_ctx->collections,
+					  kshark_match_pid,
+					  pid);
+	if (!col)
+		return KS_EMPTY_BIN;
+
+	for (int i =3D bin; i < _model.histo()->n_bins; ++i) {
+		cpu =3D ksmodel_get_cpu_front(_model.histo(), i, pid,
+					    false, col, nullptr);
+		if (cpu >=3D 0)
+			return cpu;
+	}
+
+	return KS_EMPTY_BIN;
+}
+
+bool KsGLWidget::_find(int bin, int cpu, int pid,
+		       int variance, bool joined, size_t *row)
+{
+	int hSize =3D _model.histo()->n_bins;
+	ssize_t found;
+
+	if (bin < 0 || bin > hSize || (cpu < 0 && pid < 0)) {
+		/*
+		 * The click is outside of the range of the histogram.
+		 * Do nothing.
+		 */
+		*row =3D 0;
+		return false;
+	}
+
+	auto lamGetEntryByCPU =3D [&](int b) {
+		/* Get the first data entry in this bin. */
+		found =3D ksmodel_first_index_at_cpu(_model.histo(),
+							   b, cpu);
+		if (found < 0) {
+			/*
+			 * The bin is empty or the entire connect of the bin
+			 * has been filtered.
+			 */
+			return false;
+		}
+
+		*row =3D found;
+		return true;
+	};
+
+	auto lamGetEntryByPid =3D [&](int b) {
+		/* Get the first data entry in this bin. */
+		found =3D ksmodel_first_index_at_pid(_model.histo(),
+							   b, pid);
+		if (found < 0) {
+			/*
+			 * The bin is empty or the entire connect of the bin
+			 * has been filtered.
+			 */
+			return false;
+		}
+
+		*row =3D found;
+		return true;
+	};
+
+	auto lamFindEntryByCPU =3D [&](int b) {
+		/*
+		 * The click is over the CPU graphs. First try the exact
+		 * match.
+		 */
+		if (lamGetEntryByCPU(bin))
+			return true;
+
+		/* Now look for a match, nearby the position of the click. */
+		for (int i =3D 1; i < variance; ++i) {
+			if (bin + i <=3D hSize && lamGetEntryByCPU(bin + i))
+				return true;
+
+			if (bin - i >=3D 0 && lamGetEntryByCPU(bin - i))
+				return true;
+		}
+
+		*row =3D 0;
+		return false;
+	};
+
+	auto lamFindEntryByPid =3D [&](int b) {
+		/*
+		 * The click is over the Task graphs. First try the exact
+		 * match.
+		 */
+		if (lamGetEntryByPid(bin))
+			return true;
+
+		/* Now look for a match, nearby the position of the click. */
+		for (int i =3D 1; i < variance; ++i) {
+			if ((bin + i <=3D hSize) && lamGetEntryByPid(bin + i))
+				return true;
+
+			if ((bin - i >=3D 0) && lamGetEntryByPid(bin - i))
+				return true;
+		}
+
+		*row =3D 0;
+		return false;
+	};
+
+	if (cpu >=3D 0)
+		return lamFindEntryByCPU(bin);
+
+	if (pid >=3D 0) {
+		bool ret =3D lamFindEntryByPid(bin);
+
+		/*
+		 * If no entry has been found and we have a joined search, look
+		 * for an entry on the next CPU used by this task.
+		 */
+		if (!ret && joined) {
+			cpu =3D _getNextCPU(pid, bin);
+			ret =3D lamFindEntryByCPU(bin);
+		}
+
+		return ret;
+	}
+
+	*row =3D 0;
+	return false;
+}
+
+bool KsGLWidget::_findAndSelect(QMouseEvent *event)
+{
+	size_t row;
+	bool found =3D _find(event, 10, true, &row);
+
+	emit deselect();
+	if (found) {
+		emit select(row);
+		emit updateView(row, true);
+	}
+
+	return found;
+}
+
+void KsGLWidget::_rangeBoundInit(int x)
+{
+	/*
+	 * Set the origin of the rubber band that shows the new range. Only
+	 * the X coordinate of the origin matters. The Y coordinate will be
+	 * set to zero.
+	 */
+	_rubberBandOrigin.rx() =3D x;
+	_rubberBandOrigin.ry() =3D 0;
+
+	_rubberBand.setGeometry(_rubberBandOrigin.x(),
+				_rubberBandOrigin.y(),
+				0, 0);
+
+	/* Make the rubber band visible, although its size is zero. */
+	_rubberBand.show();
+}
+
+void KsGLWidget::_rangeBoundStretched(int x)
+{
+	QPoint pos;
+
+	pos.rx() =3D x;
+	pos.ry() =3D this->height();
+
+	/*
+	 * Stretch the rubber band between the origin position and the current
+	 * position of the mouse. Only the X coordinate matters. The Y
+	 * coordinate will be the height of the widget.
+	 */
+	if (_rubberBandOrigin.x() < pos.x()) {
+		_rubberBand.setGeometry(QRect(_rubberBandOrigin.x(),
+					      _rubberBandOrigin.y(),
+					      pos.x() - _rubberBandOrigin.x(),
+					      pos.y() - _rubberBandOrigin.y()));
+	} else {
+		_rubberBand.setGeometry(QRect(pos.x(),
+					      _rubberBandOrigin.y(),
+					      _rubberBandOrigin.x() - pos.x(),
+					      pos.y() - _rubberBandOrigin.y()));
+	}
+}
+
+void KsGLWidget::_rangeChanged(int binMin, int binMax)
+{
+	size_t nBins =3D _model.histo()->n_bins;
+	int binMark =3D _mState->activeMarker()._bin;
+	uint64_t min, max;
+
+	/* The rubber band is no longer needed. Make it invisible. */
+	_rubberBand.hide();
+
+	if ( (binMax - binMin) < 4) {
+		/* Most likely this is an accidental click. Do nothing. */
+		return;
+	}
+
+	/*
+	 * Calculate the new range of the histogram. The number of bins will
+	 * stay the same.
+	 */
+
+	min =3D ksmodel_bin_ts(_model.histo(), binMin);
+	max =3D ksmodel_bin_ts(_model.histo(), binMax);
+	if (max - min < nBins) {
+		/*
+		 * The range cannot be smaller than the number of bins.
+		 * Do nothing.
+		 */
+		return;
+	}
+
+	/* Recalculate the model and update the markers. */
+	ksmodel_set_bining(_model.histo(), nBins, min, max);
+	_model.fill(_data->rows(), _data->size());
+	_mState->updateMarkers(*_data, this);
+
+	/*
+	 * If the Marker is inside the new range, make sure that it will
+	 * be visible in the table. Note that for this check we use the
+	 * bin number of the marker, retrieved before its update.
+	 */
+	if (_mState->activeMarker()._isSet &&
+	    binMark < binMax && binMark > binMin) {
+		emit updateView(_mState->activeMarker()._pos, true);
+		return;
+	}
+
+	/*
+	 * Find the first bin which contains unfiltered data and send a signal
+	 * to the View widget to make this data visible.
+	 */
+	for (int bin =3D 0; bin < _model.histo()->n_bins; ++bin) {
+		int64_t row =3D ksmodel_first_index_at_bin(_model.histo(), bin);
+		if (row !=3D KS_EMPTY_BIN &&
+		    (_data->rows()[row]->visible & KS_TEXT_VIEW_FILTER_MASK)) {
+			emit updateView(row, false);
+			return;
+		}
+	}
+}
+
+int KsGLWidget::_posInRange(int x)
+{
+	int posX;
+	if (x < _hMargin)
+		posX =3D _hMargin;
+	else if (x > (width() - _hMargin))
+		posX =3D width() - _hMargin;
+	else
+		posX =3D x;
+
+	return posX;
+}
+
+int KsGLWidget::_getCPU(int y)
+{
+	int cpuId;
+
+	if (_cpuList.count() =3D=3D 0)
+		return -1;
+
+	cpuId =3D (y - _vMargin + _vSpacing / 2) / (_vSpacing + KS_GRAPH_HEIGHT);
+	if (cpuId < 0 || cpuId >=3D _cpuList.count())
+		return -1;
+
+	return _cpuList[cpuId];
+}
+
+int KsGLWidget::_getPid(int y)
+{
+	int pidId;
+
+	if (_taskList.count() =3D=3D 0)
+		return -1;
+
+	pidId =3D (y - _vMargin -
+		     _cpuList.count()*(KS_GRAPH_HEIGHT + _vSpacing) +
+		     _vSpacing / 2) / (_vSpacing + KS_GRAPH_HEIGHT);
+
+	if (pidId < 0 || pidId >=3D _taskList.count())
+		return -1;
+
+	return _taskList[pidId];
+}
diff --git a/kernel-shark-qt/src/KsGLWidget.hpp b/kernel-shark-qt/src/KsGLW=
idget.hpp
new file mode 100644
index 0000000..5b8ff8c
--- /dev/null
+++ b/kernel-shark-qt/src/KsGLWidget.hpp
@@ -0,0 +1,220 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+ /**
+ *  @file    KsGLWidget.hpp
+ *  @brief   OpenGL widget for plotting trace graphs.
+ */
+
+#ifndef _KS_GLWIDGET_H
+#define _KS_GLWIDGET_H
+
+// Qt
+#include <QRubberBand>
+
+// KernelShark
+#include "KsUtils.hpp"
+#include "KsPlotTools.hpp"
+#include "KsModels.hpp"
+#include "KsDualMarker.hpp"
+
+/**
+ * The KsGLWidget class provides a widget for rendering OpenGL graphics us=
ed
+ * to plot trace graphs.
+ */
+class KsGLWidget : public QOpenGLWidget
+{
+	Q_OBJECT
+public:
+	explicit KsGLWidget(QWidget *parent =3D NULL);
+
+	void initializeGL() override;
+
+	void resizeGL(int w, int h) override;
+
+	void paintGL() override;
+
+	void mousePressEvent(QMouseEvent *event);
+
+	void mouseMoveEvent(QMouseEvent *event);
+
+	void mouseReleaseEvent(QMouseEvent *event);
+
+	void mouseDoubleClickEvent(QMouseEvent *event);
+
+	void wheelEvent(QWheelEvent * event);
+
+	void keyPressEvent(QKeyEvent *event);
+
+	void keyReleaseEvent(QKeyEvent *event);
+
+	void loadData(KsDataStore *data);
+
+	void loadColors();
+
+	/**
+	 * Provide the widget with a pointer to the Dual Marker state machine
+	 * object.
+	 */
+	void setMarkerSM(KsDualMarkerSM *m) {_mState =3D m;}
+
+	/** Get the KsGraphModel object. */
+	KsGraphModel *model() {return &_model;}
+
+	/** Get the number of CPU graphs. */
+	int cpuGraphCount() const {return _cpuList.count();}
+
+	/** Get the number of Task graphs. */
+	int taskGraphCount() const {return _taskList.count();}
+
+	/** Get the total number of graphs. */
+	int graphCount() const {return _cpuList.count() + _taskList.count();}
+
+	/** Get the height of the widget. */
+	int height() const
+	{
+		return graphCount() * (KS_GRAPH_HEIGHT + _vSpacing) +
+		       _vMargin * 2;
+	}
+
+	/** Get the device pixel ratio. */
+	int dpr() const {return _dpr;}
+
+	/** Get the size of the horizontal margin space. */
+	int hMargin()	const {return _hMargin;}
+
+	/** Get the size of the vertical margin space. */
+	int vMargin()	const {return _vMargin;}
+
+	/** Get the size of the vertical spaceing between the graphs. */
+	int vSpacing()	const {return _vSpacing;}
+
+	void setMark(KsGraphMark *mark);
+
+	void findGraphIds(const kshark_entry &e,
+			  int *graphCPU,
+			  int *graphTask);
+
+	/** CPUs to be plotted. */
+	QVector<int>	_cpuList;
+
+	/** Tasks to be plotted. */
+	QVector<int>	_taskList;
+
+signals:
+	/**
+	 * This signal is emitted when the mouse moves over a visible
+	 * KernelShark entry.
+	 */
+	void found(size_t pos);
+
+	/**
+	 * This signal is emitted when the mouse moves but there is no visible
+	 * KernelShark entry under the cursor.
+	 */
+	void notFound(uint64_t ts, int cpu, int pid);
+
+	/** This signal is emitted when the Plus key is pressed. */
+	void zoomIn();
+
+	/** This signal is emitted when the Minus key is pressed. */
+	void zoomOut();
+
+	/** This signal is emitted when the Left Arrow key is pressed. */
+	void scrollLeft();
+
+	/** This signal is emitted when the Right Arrow key is pressed. */
+	void scrollRight();
+
+	/**
+	 * This signal is emitted when one of the 4 Action keys is release
+	 * (after being pressed).
+	 */
+	void stopUpdating();
+
+	/**
+	 * This signal is emitted in the case of a double click over a visible
+	 * KernelShark entry.
+	 */
+	void select(size_t pos);
+
+	/**
+	 * This signal is emitted in the case of a right mouse button click or
+	 * in the case of a double click over an empty area (no visible
+	 * KernelShark entries).
+	 */
+	void deselect();
+
+	/**
+	 * This signal is emitted when the KsTraceViewer widget needs to be
+	 * updated.
+	 */
+	void updateView(size_t pos, bool mark);
+
+private:
+	QVector<KsPlot::Graph*>	_graphs;
+
+	KsPlot::PlotObjList	_shapes;
+
+	KsPlot::ColorTable	_pidColors;
+
+	int		_hMargin, _vMargin;
+
+	unsigned int	_vSpacing;
+
+	KsGraphModel	 _model;
+
+	KsDualMarkerSM	*_mState;
+
+	KsDataStore	*_data;
+
+	QRubberBand	_rubberBand;
+
+	QPoint		_rubberBandOrigin;
+
+	size_t		_posMousePress;
+
+	bool		_keyPressed;
+
+	int 		_dpr;
+
+	void _drawAxisX();
+
+	void _makeGraphs(QVector<int> cpuMask, QVector<int> taskMask);
+
+	KsPlot::Graph *_newCPUGraph(int cpu);
+
+	KsPlot::Graph *_newTaskGraph(int pid);
+
+	void _makePluginShapes(QVector<int> cpuMask, QVector<int> taskMask);
+
+	int _posInRange(int x);
+
+	int _getCPU(int y);
+
+	int _getPid(int y);
+
+	void _rangeBoundInit(int x);
+
+	void _rangeBoundStretched(int x);
+
+	void _rangeChanged(int binMin, int binMax);
+
+	bool _findAndSelect(QMouseEvent *event);
+
+	bool _find(QMouseEvent *event, int variance, bool joined, size_t *row);
+
+	bool _find(int bin, int cpu, int pid,
+		   int variance, bool joined, size_t *row);
+
+	int _getNextCPU(int pid, int bin);
+
+	int _getLastTask(struct kshark_trace_histo *histo, int bin, int cpu);
+
+	int _getLastCPU(struct kshark_trace_histo *histo, int bin, int pid);
+};
+
+#endif
--=20
2.17.1
