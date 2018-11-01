Return-Path: <SRS0=g7z+=NM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810044.outbound.protection.outlook.com ([40.107.81.44]:28016
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727001AbeKBGud (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Nov 2018 02:50:33 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 7/8] kernel-shark-qt: Change the color convention of the task
 graphs
Date: Thu, 1 Nov 2018 21:45:45 +0000
Message-ID: <20181101214512.18684-8-ykaradzhov@vmware.com>
References: <20181101214512.18684-1-ykaradzhov@vmware.com>
In-Reply-To: <20181101214512.18684-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

So far the Task graphs have used the same color convention as the
CPU graphs. Namely the vertical tick of the record was plotted by
using the CPU color and the horizontal strap was plotted by using
the task color. This patch reverts the color convention and now the
tick has the color of the task and the strap has the color of the
CPU. This change requires significant modification of the logic
used to create and draw the graphs.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/examples/dataplot.cpp |  30 +++--
 kernel-shark-qt/src/KsGLWidget.cpp    |  15 ++-
 kernel-shark-qt/src/KsGLWidget.hpp    |   2 +
 kernel-shark-qt/src/KsPlotTools.cpp   | 152 ++++++++++++++++----------
 kernel-shark-qt/src/KsPlotTools.hpp   |  45 ++++++--
 5 files changed, 162 insertions(+), 82 deletions(-)

diff --git a/kernel-shark-qt/examples/dataplot.cpp b/kernel-shark-qt/exampl=
es/dataplot.cpp
index 27a0125..94841e7 100644
--- a/kernel-shark-qt/examples/dataplot.cpp
+++ b/kernel-shark-qt/examples/dataplot.cpp
@@ -78,36 +78,42 @@ void drawShapes()
 /* An example function demonstrating Zoom In and Zoom Out. */
 void play()
 {
-	KsPlot::ColorTable colors =3D KsPlot::getColorTable();
+	KsPlot::ColorTable taskColors =3D KsPlot::getTaskColorTable();
+	KsPlot::ColorTable cpuColors =3D KsPlot::getCPUColorTable();
 	vector<KsPlot::Graph *>::iterator it;
 	vector<int> CPUs, Tasks;
-	KsPlot::Graph *graph;
 	bool zoomIn(true);
 	int base;
+	size_t i;
=20
 	CPUs =3D {3, 4, 6};
 	Tasks =3D {}; // Add valid pids here, if you want task plots.
=20
-	for (size_t i =3D 0; i < CPUs.size() + Tasks.size(); ++i) {
-		/* Make a new Graph. */
-		graph =3D new KsPlot::Graph(&histo, &colors);
-
+	auto lamAddGraph =3D [&] (KsPlot::Graph *g) {
 		/* Set the dimensions of the Graph. */
-		graph->setHeight(GRAPH_HEIGHT);
-		graph->setHMargin(GRAPH_H_MARGIN);
+		g->setHeight(GRAPH_HEIGHT);
+		g->setHMargin(GRAPH_H_MARGIN);
=20
 		/*
 		 * Set the Y coordinate of the Graph's base.
 		 * Remember that the "Y" coordinate is inverted.
 		 */
 		base =3D 1.7 * GRAPH_HEIGHT * (i + 1);
-		graph->setBase(base);
+		g->setBase(base);
=20
 		/* Add the Graph. */
-		graphs.push_back(graph);
-	}
+		graphs.push_back(g);
+	};
+
+	for (i =3D 0; i < CPUs.size(); ++i)
+		lamAddGraph(new KsPlot::Graph(&histo, &taskColors,
+						      &taskColors));
+
+	for (;i < CPUs.size() + Tasks.size(); ++i)
+		lamAddGraph(new KsPlot::Graph(&histo, &taskColors,
+						      &cpuColors));
=20
-	for (int i =3D 1; i < 1000; ++i) {
+	for (i =3D 1; i < 1000; ++i) {
 		it =3D graphs.begin();
=20
 		for (int const &cpu: CPUs)
diff --git a/kernel-shark-qt/src/KsGLWidget.cpp b/kernel-shark-qt/src/KsGLW=
idget.cpp
index 22cbd96..2a0b16b 100644
--- a/kernel-shark-qt/src/KsGLWidget.cpp
+++ b/kernel-shark-qt/src/KsGLWidget.cpp
@@ -356,7 +356,9 @@ void KsGLWidget::loadData(KsDataStore *data)
 void KsGLWidget::loadColors()
 {
 	_pidColors.clear();
-	_pidColors =3D KsPlot::getColorTable();
+	_pidColors =3D KsPlot::getTaskColorTable();
+	_cpuColors.clear();
+	_cpuColors =3D KsPlot::getCPUColorTable();
 }
=20
 /**
@@ -530,8 +532,12 @@ void KsGLWidget::_makePluginShapes(QVector<int> cpuLis=
t, QVector<int> taskList)
=20
 KsPlot::Graph *KsGLWidget::_newCPUGraph(int cpu)
 {
+	/* The CPU graph needs to know only the colors of the tasks. */
 	KsPlot::Graph *graph =3D new KsPlot::Graph(_model.histo(),
+						 &_pidColors,
 						 &_pidColors);
+	graph->setZeroSuppressed(true);
+
 	kshark_context *kshark_ctx(nullptr);
 	kshark_entry_collection *col;
=20
@@ -553,8 +559,13 @@ KsPlot::Graph *KsGLWidget::_newCPUGraph(int cpu)
=20
 KsPlot::Graph *KsGLWidget::_newTaskGraph(int pid)
 {
+	/*
+	 * The Task graph needs to know the colors of the tasks and the colors
+	 * of the CPUs.
+	 */
 	KsPlot::Graph *graph =3D new KsPlot::Graph(_model.histo(),
-						 &_pidColors);
+						 &_pidColors,
+						 &_cpuColors);
 	kshark_context *kshark_ctx(nullptr);
 	kshark_entry_collection *col;
=20
diff --git a/kernel-shark-qt/src/KsGLWidget.hpp b/kernel-shark-qt/src/KsGLW=
idget.hpp
index 5b8ff8c..662cd26 100644
--- a/kernel-shark-qt/src/KsGLWidget.hpp
+++ b/kernel-shark-qt/src/KsGLWidget.hpp
@@ -161,6 +161,8 @@ private:
=20
 	KsPlot::ColorTable	_pidColors;
=20
+	KsPlot::ColorTable	_cpuColors;
+
 	int		_hMargin, _vMargin;
=20
 	unsigned int	_vSpacing;
diff --git a/kernel-shark-qt/src/KsPlotTools.cpp b/kernel-shark-qt/src/KsPl=
otTools.cpp
index 0cd7a7d..816fa56 100644
--- a/kernel-shark-qt/src/KsPlotTools.cpp
+++ b/kernel-shark-qt/src/KsPlotTools.cpp
@@ -106,11 +106,11 @@ void Color::setRainbowColor(int n)
  *
  * @returns ColorTable instance.
  */
-ColorTable getColorTable()
+ColorTable getTaskColorTable()
 {
 	struct kshark_context *kshark_ctx(nullptr);
 	ColorTable colors;
-	int nTasks, pid, *pids;
+	int nTasks, pid, *pids, i(0);
=20
 	if (!kshark_instance(&kshark_ctx))
 		return colors;
@@ -122,10 +122,12 @@ ColorTable getColorTable()
 	std::vector<int> temp_pids(pids, pids + nTasks);
 	std::sort(temp_pids.begin(), temp_pids.end());
=20
-	/* The "Idle" process (pid =3D 0) will be plotted in black. */
-	colors[0] =3D {};
+	if (temp_pids[i] =3D=3D 0) {
+		/* The "Idle" process (pid =3D 0) will be plotted in black. */
+		colors[i++] =3D {};
+	}
=20
-	for (int i =3D 1; i < nTasks; ++i) {
+	for (; i < nTasks; ++i) {
 		pid =3D temp_pids[i];
 		colors[pid].setRainbowColor(i - 1);
 	}
@@ -133,6 +135,28 @@ ColorTable getColorTable()
 	return colors;
 }
=20
+/**
+ * @brief Create a Hash table of Rainbow colors. The CPU Ids are
+ *	  mapped to the palette of Rainbow colors.
+ *
+ * @returns ColorTable instance.
+ */
+ColorTable getCPUColorTable()
+{
+	struct kshark_context *kshark_ctx(nullptr);
+	ColorTable colors;
+	int nCPUs;
+
+	if (!kshark_instance(&kshark_ctx))
+		return colors;
+
+	nCPUs =3D  tep_get_cpus(kshark_ctx->pevent);
+	for (int i =3D 0; i < nCPUs; ++i)
+		colors[i].setRainbowColor(i);
+
+	return colors;
+}
+
 /**
  * @brief Search the Hash table of Rainbow colors for a particular key (pi=
d).
  *
@@ -142,7 +166,7 @@ ColorTable getColorTable()
  * @returns The Rainbow color of the key "pid". If "pid" does not exist, t=
he
  *	    returned color is Black.
  */
-Color getPidColor(ColorTable *colors, int pid)
+Color getColor(ColorTable *colors, int pid)
 {
 	auto item =3D colors->find(pid);
=20
@@ -499,8 +523,8 @@ void Mark::setTaskVisible(bool v)
  * @brief Create a default Bin.
  */
 Bin::Bin()
-: _pidFront(KS_EMPTY_BIN),
-  _pidBack(KS_EMPTY_BIN)
+: _idFront(KS_EMPTY_BIN),
+  _idBack(KS_EMPTY_BIN)
 {}
=20
 void Bin::_draw(const Color &col, float size) const
@@ -528,22 +552,27 @@ Graph::Graph()
   _size(0),
   _hMargin(30),
   _collectionPtr(nullptr),
-  _pidColors(nullptr)
+  _binColors(nullptr),
+  _ensembleColors(nullptr),
+  _zeroSuppress(false)
 {}
=20
 /**
  * @brief Create a Graph to represent the state of the Vis. model.
  *
  * @param histo: Input location for the model descriptor.
- * @param ct: Input location for the Hash table of Task's colors.
+ * @param bct: Input location for the Hash table of bin's colors.
+ * @param ect: Input location for the Hash table of ensemble's colors.
  */
-Graph::Graph(kshark_trace_histo *histo, KsPlot::ColorTable *ct)
+Graph::Graph(kshark_trace_histo *histo, KsPlot::ColorTable *bct, KsPlot::C=
olorTable *ect)
 : _histoPtr(histo),
   _bins(new(std::nothrow) Bin[histo->n_bins]),
   _size(histo->n_bins),
   _hMargin(30),
   _collectionPtr(nullptr),
-  _pidColors(ct)
+  _binColors(bct),
+  _ensembleColors(ect),
+  _zeroSuppress(false)
 {
 	if (!_bins) {
 		_size =3D 0;
@@ -678,8 +707,8 @@ void Graph::setBinValue(int bin, int val)
  */
 void Graph::setBinPid(int bin, int pidF, int pidB)
 {
-	_bins[bin]._pidFront =3D pidF;
-	_bins[bin]._pidBack =3D pidB;
+	_bins[bin]._idFront =3D pidF;
+	_bins[bin]._idBack =3D pidB;
 }
=20
 /**
@@ -782,7 +811,7 @@ void Graph::fillCPUGraph(int cpu)
 		if (pidFront !=3D KS_EMPTY_BIN || pidBack !=3D KS_EMPTY_BIN) {
 			/* This is a regular process. */
 			setBin(bin, pidFront, pidBack,
-			       getPidColor(_pidColors, pidFront), visMask);
+			       getColor(_binColors, pidFront), visMask);
 		} else {
 			/* The bin contens no data from this CPU. */
 			setBinPid(bin, KS_EMPTY_BIN, KS_EMPTY_BIN);
@@ -855,27 +884,26 @@ void Graph::fillCPUGraph(int cpu)
  */
 void Graph::fillTaskGraph(int pid)
 {
-	int cpu, pidFront(0), pidBack(0), lastCpu(-1), bin(0);
+	int cpuFront, cpuBack(0), pidFront(0), pidBack(0), lastCpu(-1), bin(0);
 	uint8_t visMask;
 	ssize_t index;
=20
 	auto lamSetBin =3D [&] (int bin)
 	{
-		if (cpu >=3D 0) {
-			KsPlot::Color col;
-			col.setRainbowColor(cpu);
+		if (cpuFront >=3D 0) {
+			KsPlot::Color col =3D getColor(_binColors, pid);
=20
 			/* Data from the Task has been found in this bin. */
 			if (pid =3D=3D pidFront && pid =3D=3D pidBack) {
 				/* No data from other tasks in this bin. */
-				setBin(bin, pid, pid, col, visMask);
+				setBin(bin, cpuFront, cpuBack, col, visMask);
 			} else if (pid !=3D pidFront && pid !=3D pidBack) {
 				/*
 				 * There is some data from other tasks at both
 				 * front and back sides of this bin. But we
 				 * still want to see this bin drawn.
 				 */
-				setBin(bin, pid, KS_FILTERED_BIN, col,
+				setBin(bin, cpuFront, KS_FILTERED_BIN, col,
 				       visMask);
 			} else {
 				if (pidFront !=3D pid) {
@@ -883,7 +911,7 @@ void Graph::fillTaskGraph(int pid)
 					 * There is some data from another
 					 * task at the front side of this bin.
 					 */
-					pidFront =3D KS_FILTERED_BIN;
+					cpuFront =3D KS_FILTERED_BIN;
 				}
=20
 				if (pidBack !=3D pid) {
@@ -891,13 +919,13 @@ void Graph::fillTaskGraph(int pid)
 					 * There is some data from another
 					 * task at the back side of this bin.
 					 */
-					pidBack =3D KS_FILTERED_BIN;
+					cpuBack =3D KS_FILTERED_BIN;
 				}
=20
-				setBin(bin, pidFront, pidBack, col, visMask);
+				setBin(bin, cpuFront, cpuBack, col, visMask);
 			}
=20
-			lastCpu =3D cpu;
+			lastCpu =3D cpuBack;
 		} else {
 			/*
 			 * No data from the Task in this bin. Check the CPU,
@@ -929,14 +957,20 @@ void Graph::fillTaskGraph(int pid)
 	auto lamGetPidCPU =3D [&] (int bin)
 	{
 		/* Get the CPU used by this task. */
-		cpu =3D ksmodel_get_cpu_front(_histoPtr, bin,
-						       pid,
-						       false,
-						       _collectionPtr,
-						       nullptr);
+		cpuFront =3D ksmodel_get_cpu_front(_histoPtr, bin,
+						 pid,
+						 false,
+						 _collectionPtr,
+						 nullptr);
+
+		cpuBack =3D ksmodel_get_cpu_back(_histoPtr, bin,
+					       pid,
+					       false,
+					       _collectionPtr,
+					       nullptr);
=20
-		if (cpu < 0) {
-			pidFront =3D pidBack =3D cpu;
+		if (cpuFront < 0) {
+			pidFront =3D pidBack =3D cpuFront;
 		} else {
 			/*
 			 * Get the process Id at the begining and at the end
@@ -944,14 +978,14 @@ void Graph::fillTaskGraph(int pid)
 			 */
 			pidFront =3D ksmodel_get_pid_front(_histoPtr,
 							 bin,
-							 cpu,
+							 cpuFront,
 							 false,
 							 _collectionPtr,
 							 nullptr);
=20
 			pidBack =3D ksmodel_get_pid_back(_histoPtr,
 						       bin,
-						       cpu,
+						       cpuBack,
 						       false,
 						       _collectionPtr,
 						       nullptr);
@@ -973,7 +1007,7 @@ void Graph::fillTaskGraph(int pid)
 	 */
 	lamGetPidCPU(bin);
=20
-	if (cpu >=3D 0) {
+	if (cpuFront >=3D 0) {
 		/* The Task is active. Set this bin. */
 		lamSetBin(bin);
 	} else {
@@ -981,9 +1015,9 @@ void Graph::fillTaskGraph(int pid)
 		 * No data from this Task in the very first bin. Use the Lower
 		 * Overflow Bin to retrieve the CPU used by the task (if any).
 		 */
-		cpu =3D ksmodel_get_cpu_back(_histoPtr, LOWER_OVERFLOW_BIN, pid,
+		cpuFront =3D ksmodel_get_cpu_back(_histoPtr, LOWER_OVERFLOW_BIN, pid,
 					   false, _collectionPtr, nullptr);
-		if (cpu >=3D 0) {
+		if (cpuFront >=3D 0) {
 			/*
 			 * The Lower Overflow Bin contains data from this Task.
 			 * Now look again in the Lower Overflow Bin and find
@@ -991,7 +1025,7 @@ void Graph::fillTaskGraph(int pid)
 			 */
 			int pidCpu =3D ksmodel_get_pid_back(_histoPtr,
 							  LOWER_OVERFLOW_BIN,
-							  cpu,
+							  cpuFront,
 							  false,
 							  _collectionPtr,
 							  nullptr);
@@ -1002,8 +1036,10 @@ void Graph::fillTaskGraph(int pid)
 				 * the very first bin is empty but we derive
 				 * the Process Id from the Lower Overflow Bin.
 				 */
-				setBinPid(bin, pid, pid);
-				lastCpu =3D cpu;
+				setBinPid(bin, cpuFront, cpuFront);
+				lastCpu =3D cpuFront;
+			} else {
+				setBinPid(bin, KS_EMPTY_BIN, KS_EMPTY_BIN);
 			}
 		}
 	}
@@ -1027,7 +1063,7 @@ void Graph::fillTaskGraph(int pid)
  */
 void Graph::draw(float size)
 {
-	int lastPid(0), b(0), boxH(_height * .3);
+	int lastPid(-1), b(0), boxH(_height * .3);
 	Rectangle taskBox;
=20
 	/*
@@ -1038,23 +1074,27 @@ void Graph::draw(float size)
=20
 	/* Draw as vartical lines all bins containing data. */
 	for (int i =3D 0; i < _size; ++i)
-		if (_bins[i]._pidFront >=3D 0 || _bins[i]._pidBack >=3D 0)
+		if (_bins[i]._idFront >=3D 0 || _bins[i]._idBack >=3D 0)
 			if (_bins[i]._visMask & KS_EVENT_VIEW_FILTER_MASK)
 				_bins[i].draw();
=20
+	auto lamCheckEnsblVal =3D [this] (int v) {
+		return v > 0 || (v =3D=3D 0 && !this->_zeroSuppress);
+	};
+
 	/*
 	 * Draw colored boxes for processes. First find the first bin, which
 	 * contains data and determine its PID.
 	 */
 	for (; b < _size; ++b) {
-		if (_bins[b]._pidBack > 0) {
-			lastPid =3D _bins[b]._pidFront;
+		if (lamCheckEnsblVal(_bins[b]._idBack)) {
+			lastPid =3D _bins[b]._idFront;
 			/*
 			 * Initialize a box starting from this bin.
 			 * The color of the taskBox corresponds to the Pid
 			 * of the process.
 			 */
-			taskBox._color =3D getPidColor(_pidColors, lastPid);
+			taskBox._color =3D getColor(_ensembleColors, lastPid);
 			taskBox.setPoint(0, _bins[b]._base.x(),
 					_bins[b]._base.y() - boxH);
 			taskBox.setPoint(1, _bins[b]._base.x(),
@@ -1064,8 +1104,8 @@ void Graph::draw(float size)
 	}
=20
 	for (; b < _size; ++b) {
-		if (_bins[b]._pidFront =3D=3D KS_EMPTY_BIN &&
-		    _bins[b]._pidBack =3D=3D KS_EMPTY_BIN) {
+		if (_bins[b]._idFront =3D=3D KS_EMPTY_BIN &&
+		    _bins[b]._idBack =3D=3D KS_EMPTY_BIN) {
 			/*
 			 * This bin is empty. If a colored taskBox is already
 			 * initialized, it will be extended.
@@ -1073,11 +1113,11 @@ void Graph::draw(float size)
 			continue;
 		}
=20
-		if (_bins[b]._pidFront !=3D _bins[b]._pidBack ||
-		    _bins[b]._pidFront !=3D lastPid ||
-		    _bins[b]._pidBack  !=3D lastPid) {
+		if (_bins[b]._idFront !=3D _bins[b]._idBack ||
+		    _bins[b]._idFront !=3D lastPid ||
+		    _bins[b]._idBack  !=3D lastPid) {
 			/* A new process starts here. */
-			if (lastPid > 0 && b > 0) {
+			if (b > 0 && lamCheckEnsblVal(lastPid)) {
 				/*
 				 * There is another process running up to this
 				 * point. Close its colored box here and draw.
@@ -1089,13 +1129,13 @@ void Graph::draw(float size)
 				taskBox.draw();
 			}
=20
-			if (_bins[b]._pidBack > 0) {
+			if (lamCheckEnsblVal(_bins[b]._idBack)) {
 				/*
 				 * This is a regular process. Initialize
 				 * colored box starting from this bin.
 				 */
-				taskBox._color =3D getPidColor(_pidColors,
-							 _bins[b]._pidBack);
+				taskBox._color =3D getColor(_ensembleColors,
+							 _bins[b]._idBack);
=20
 				taskBox.setPoint(0, _bins[b]._base.x() - 1,
 						_bins[b]._base.y() - boxH);
@@ -1103,11 +1143,11 @@ void Graph::draw(float size)
 						_bins[b]._base.y());
 			}
=20
-			lastPid =3D _bins[b]._pidBack;
+			lastPid =3D _bins[b]._idBack;
 		}
 	}
=20
-	if (lastPid > 0) {
+	if (lamCheckEnsblVal(lastPid) > 0) {
 		/*
 		 * This is the end of the Graph and we have a process running.
 		 * Close its colored box and draw.
diff --git a/kernel-shark-qt/src/KsPlotTools.hpp b/kernel-shark-qt/src/KsPl=
otTools.hpp
index d5779d6..11c49eb 100644
--- a/kernel-shark-qt/src/KsPlotTools.hpp
+++ b/kernel-shark-qt/src/KsPlotTools.hpp
@@ -74,9 +74,11 @@ private:
 /** Hash table of colors. */
 typedef std::unordered_map<int, KsPlot::Color> ColorTable;
=20
-ColorTable getColorTable();
+ColorTable getTaskColorTable();
=20
-Color getPidColor(ColorTable *colors, int pid);
+ColorTable getCPUColorTable();
+
+Color getColor(ColorTable *colors, int pid);
=20
 /** Represents an abstract graphical element. */
 class PlotObject {
@@ -359,16 +361,16 @@ public:
 	void setVal(int v) {_val.setY(_base.y() - v); }
=20
 	/**
-	 * The Process Id detected at the front (first in time) edge of
-	 * the bin.
+	 * The Id value (pid or cpu) detected at the front (first in time) edge
+	 * of the bin.
 	 */
-	int	_pidFront;
+	int	_idFront;
=20
 	/**
-	 * The Process Id detected at the back (last in time) edge of
-	 * the bin.
+	 * The Id value (pid or cpu) detected at the back (last in time) edge
+	 * of the bin.
 	 */
-	int	_pidBack;
+	int	_idBack;
=20
 	/** Lower finishing point of the line, representing the Bin. */
 	Point	_base;
@@ -397,7 +399,8 @@ public:
 	/* Disable moving. Same as copying.*/
 	Graph(Graph &&) =3D delete;
=20
-	Graph(kshark_trace_histo *histo, KsPlot::ColorTable *ct);
+	Graph(kshark_trace_histo *histo, KsPlot::ColorTable *bct,
+					 KsPlot::ColorTable *ect);
=20
 	/* Keep this destructor virtual. */
 	virtual ~Graph();
@@ -418,7 +421,7 @@ public:
 	}
=20
 	/** @brief Set the Hash table of Task's colors. */
-	void setColorTablePtr(KsPlot::ColorTable *ct) {_pidColors =3D ct;}
+	void setBinColorTablePtr(KsPlot::ColorTable *ct) {_binColors =3D ct;}
=20
 	void fillCPUGraph(int cpu);
=20
@@ -452,6 +455,19 @@ public:
=20
 	void setHMargin(int hMargin);
=20
+	/**
+	 * Check if this graph is Zero Suppressed. Zero Suppressed means that
+	 * bins having Id value =3D 0 (Idle task records) are not grouped
+	 * together.
+	 */
+	bool zeroSuppressed(bool zs) {return _zeroSuppress;}
+
+	/**
+	 * Set Zero Suppression. If True, the bins having Id value =3D 0 (Idle
+	 * task records) are not grouped together.
+	 */
+	void setZeroSuppressed(bool zs) {_zeroSuppress =3D zs;}
+
 private:
 	/** Pointer to the model descriptor object. */
 	kshark_trace_histo	*_histoPtr;
@@ -474,8 +490,13 @@ private:
 	/** Pointer to the data collection object. */
 	kshark_entry_collection	*_collectionPtr;
=20
-	/** Hash table of Task's colors. */
-	ColorTable		*_pidColors;
+	/** Hash table of bin's colors. */
+	ColorTable		*_binColors;
+
+	/** Hash table of ensemble's colors. */
+	ColorTable		*_ensembleColors;
+
+	bool			_zeroSuppress;
=20
 	void _initBins();
 };
--=20
2.17.1
