Return-Path: <SRS0=wogL=LF=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42959 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728958AbeHVTHk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Aug 2018 15:07:40 -0400
Received: by mail-wr1-f68.google.com with SMTP id v17-v6so1990523wrr.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Aug 2018 08:42:15 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/5] kernel-shark-qt: Add C++ API for drawing of Graphs
Date: Wed, 22 Aug 2018 18:41:38 +0300
Message-Id: <20180822154140.3748-4-y.karadz@gmail.com>
In-Reply-To: <20180822154140.3748-1-y.karadz@gmail.com>
References: <20180822154140.3748-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch extends the KernelShark Plotting library, by adding
a C++ API for drawing CPU and Task Graphs.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/CMakeLists.txt  |    3 +-
 kernel-shark-qt/src/KsPlotTools.cpp | 1009 +++++++++++++++++++++++++++
 kernel-shark-qt/src/KsPlotTools.hpp |  440 ++++++++++++
 3 files changed, 1451 insertions(+), 1 deletion(-)
 create mode 100644 kernel-shark-qt/src/KsPlotTools.cpp
 create mode 100644 kernel-shark-qt/src/KsPlotTools.hpp

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMakeLists.txt
index 9c74bc0..ac2847a 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -16,7 +16,8 @@ set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
 if (OPENGL_FOUND AND GLUT_FOUND)
 
     message(STATUS "libkshark-plot")
-    add_library(kshark-plot  SHARED  libkshark-plot.c)
+    add_library(kshark-plot  SHARED  libkshark-plot.c
+                                     KsPlotTools.cpp)
 
     target_link_libraries(kshark-plot  kshark
                                        ${OPENGL_LIBRARIES}
diff --git a/kernel-shark-qt/src/KsPlotTools.cpp b/kernel-shark-qt/src/KsPlotTools.cpp
new file mode 100644
index 0000000..2e3029b
--- /dev/null
+++ b/kernel-shark-qt/src/KsPlotTools.cpp
@@ -0,0 +1,1009 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    KsPlotTools.cpp
+ *  @brief   KernelShark Plot tools.
+ */
+
+// C
+#include <math.h>
+
+// C++
+#include <algorithm>
+#include <vector>
+
+// OpenGL
+#include <GL/freeglut.h>
+#include <GL/gl.h>
+
+// KernelShark
+#include "KsPlotTools.hpp"
+
+namespace KsPlot
+{
+
+float Color::_frequency = .75;
+
+/**
+ * @brief Create a default color (black).
+ */
+Color::Color()
+{
+	_col_c.red = _col_c.green = _col_c.blue = 0;
+}
+
+/**
+ * @brief Constructs a RGB color object.
+ *
+ * @param r: The red component of the color.
+ * @param g: The green component of the color.
+ * @param b: The blue component of the color
+ */
+Color::Color(uint8_t r, uint8_t g, uint8_t b)
+{
+	set(r, g, b);
+}
+
+/**
+ * @brief Constructs a RGB color object.
+ *
+ * @param rgb: RGB value.
+ */
+Color::Color(int rgb)
+{
+	set(rgb);
+}
+
+/**
+ * @brief Sets the color.
+ *
+ * @param r: The red component of the color.
+ * @param g: The green component of the color.
+ * @param b: The blue component of the color
+ */
+void Color::set(uint8_t r, uint8_t g, uint8_t b)
+{
+	_col_c.red = r;
+	_col_c.green = g;
+	_col_c.blue = b;
+}
+
+/**
+ * @brief Sets the color.
+ *
+ * @param rgb: RGB value.
+ */
+void Color::set(int rgb)
+{
+	int r = rgb & 0xFF;
+	int g = (rgb >> 8) & 0xFF;
+	int b = (rgb >> 16) & 0xFF;
+
+	set(r, g, b);
+}
+
+/**
+ * @brief The color is selected from the Rainbow palette.
+ *
+ * @param n: index of the color inside the Rainbow palette.
+ */
+void Color::setRainbowColor(int n)
+{
+	int r = sin(_frequency * n + 0) * 127 + 128;
+	int g = sin(_frequency * n + 2) * 127 + 128;
+	int b = sin(_frequency * n + 4) * 127 + 128;
+
+	set(r, g, b);
+}
+
+/**
+ * @brief Create a Hash table of Rainbow colors. The sorted Pid values are
+ *	  mapped to the palette of Rainbow colors.
+ *
+ * @returns ColorTable instance.
+ */
+ColorTable getColorTable()
+{
+	struct kshark_context *kshark_ctx(nullptr);
+	ColorTable colors;
+	int nTasks, pid, *pids;
+
+	if (!kshark_instance(&kshark_ctx))
+		return colors;
+
+	nTasks = kshark_get_task_pids(kshark_ctx, &pids);
+	if (!nTasks)
+		return colors;
+
+	std::vector<int> temp_pids(pids, pids + nTasks);
+	std::sort(temp_pids.begin(), temp_pids.end());
+
+	/* The "Idle" process (pid = 0) will be plotted in black. */
+	colors[0] = {};
+
+	for (int i = 1; i < nTasks; ++i) {
+		pid = temp_pids[i];
+		colors[pid].setRainbowColor(i - 1);
+	}
+
+	return colors;
+}
+
+/**
+ * @brief Search the Hash table of Rainbow colors for a particular key (pid).
+ *
+ * @param colors: Input location for the ColorTable instance.
+ * @param pid: the Process Id to search for.
+ *
+ * @returns The Rainbow color of the key "pid". If "pid" does not exist, the
+ *	    returned color is Black.
+ */
+Color getPidColor(ColorTable *colors, int pid)
+{
+	auto item = colors->find(pid);
+
+	if (item != colors->end())
+		return item->second;
+
+	return {};
+}
+
+/**
+ * @brief Create a default point.
+ */
+Point::Point()
+{
+	set(0, 0);
+}
+
+/**
+ * @brief Create a point.
+ *
+ * @param x: X coordinate of the point in pixels.
+ * @param y: Y coordinate of the point in pixels.
+ */
+Point::Point(int x, int y)
+{
+	set(x, y);
+}
+
+void Point::_draw(const Color &col, float size) const
+{
+	ksplot_draw_point(&_point_c, col.color_c_ptr(), size);
+}
+
+/**
+ * @brief Draw a line between point "a" and point "b".
+ *
+ * @param a: The first finishing point of the line.
+ * @param b: The second finishing point of the line.
+ * @param col: The color of the line.
+ * @param size: The size of the line.
+ */
+void drawLine(const Point &a, const Point &b,
+	      const Color &col, float size)
+{
+	ksplot_draw_line(a.point_c_ptr(),
+			 b.point_c_ptr(),
+			 col.color_c_ptr(),
+			 size);
+}
+
+/**
+ * @brief Create a default line.
+ */
+Line::Line()
+{
+	setA(0, 0);
+	setB(0, 0);
+}
+
+/**
+ * @brief Create a line between the point "a" and point "b".
+ *
+ * @param a: first finishing point of the line.
+ * @param b: second finishing point of the line.
+ */
+Line::Line(const Point &a, const Point &b)
+{
+	setA(a.x(), a.y());
+	setB(b.x(), b.y());
+}
+
+void Line::_draw(const Color &col, float size) const
+{
+	ksplot_draw_line(&_a, &_b, col.color_c_ptr(), size);
+}
+
+/**
+ * @brief Create a default line. The polygon object has the ownership of the
+ * 	  array of point used to define its shape.
+ *
+ * @param n: Number of edges in the polyhedron.
+ */
+Polygon::Polygon(size_t n)
+: _nPoints(n),
+  _points(new ksplot_point[n]),
+  _fill(true)
+{
+	if (!_points)
+		_nPoints = 0;
+}
+
+/**
+ * @brief Destroy the polygon object.
+ */
+Polygon::~Polygon()
+{
+	delete[] _points;
+}
+
+/**
+ * @brief Set the point of the polygon indexed by "i".
+ *
+ * @param i: the indexed of the point to be set.
+ * @param x: X coordinate of the point in pixels.
+ * @param y: Y coordinate of the point in pixels.
+ */
+void Polygon::setPoint(size_t i, int x, int y)
+{
+	_points[i].x = x;
+	_points[i].y = y;
+}
+
+/**
+ * @brief Set the point of the polygon indexed by "i".
+ *
+ * @param i: the indexed of the point to be set.
+ * @param p: A Point object used to provide coordinate values.
+ */
+void Polygon::setPoint(size_t i, const Point &p)
+{
+	setPoint(i, p.x(), p.y());
+}
+
+void Polygon::_draw(const Color &col, float size) const
+{
+	if (_fill)
+		ksplot_draw_polygon(_points, _nPoints,
+				    col.color_c_ptr(),
+				    size);
+	else
+		ksplot_draw_polygon_contour(_points, _nPoints,
+					    col.color_c_ptr(),
+					    size);
+}
+
+/**
+ * @brief Create a default Mark.
+ */
+Mark::Mark()
+{
+	_visible = false;
+	_cpu._color = Color(225, 255, 100);
+	_cpu._size = 5.5f;
+	_task._color = Color(0, 255, 0);
+	_task._size = 5.5f;
+}
+
+void Mark::_draw(const Color &col, float size) const
+{
+	drawLine(_a, _b, col, size);
+	_cpu.draw();
+	_task.draw();
+}
+
+/**
+ * @brief Set the device pixel ratio.
+ *
+ * @param dpr: device pixel ratio value.
+ */
+void Mark::setDPR(int dpr)
+{
+	_size = 1.5 * dpr;
+	_task._size = _cpu._size = 1.5 + 4.0 * dpr;
+}
+
+/**
+ * @brief Set the X coordinate (horizontal) of the Mark.
+ *
+ * @param x: X coordinate of the Makr in pixels.
+ */
+void Mark::setX(int x)
+{
+	_a.setX(x);
+	_b.setX(x);
+	_cpu.setX(x);
+	_task.setX(x);
+}
+
+/**
+ * @brief Set the Y coordinates (vertical) of the Mark's finishing points.
+ *
+ * @param yA: Y coordinate of the first finishing point of the Mark's line.
+ * @param yB: Y coordinate of the second finishing point of the Mark's line.
+ */
+void Mark::setY(int yA, int yB)
+{
+	_a.setY(yA);
+	_b.setY(yB);
+}
+
+/**
+ * @brief Set the Y coordinates (vertical) of the Mark's CPU points.
+ *
+ * @param yCPU: Y coordinate of the Mark's CPU point.
+ */
+void Mark::setCPUY(int yCPU)
+{
+	_cpu.setY(yCPU);
+}
+
+/**
+ * @brief Set the visiblity of the Mark's CPU points.
+ *
+ * @param v: If True, the CPU point will be visible.
+ */
+void Mark::setCPUVisible(bool v)
+{
+	_cpu._visible = v;
+}
+
+/**
+ * @brief Set the Y coordinates (vertical) of the Mark's Task points.
+ *
+ * @param yTask: Y coordinate of the Mark's Task point.
+ */
+void Mark::setTaskY(int yTask)
+{
+	_task.setY(yTask);
+}
+
+/**
+ * @brief Set the visiblity of the Mark's Task points.
+ *
+ * @param v: If True, the Task point will be visible.
+ */
+void Mark::setTaskVisible(bool v)
+{
+	_task._visible = v;
+}
+
+/**
+ * @brief Create a default Bin.
+ */
+Bin::Bin()
+: _pidFront(KS_EMPTY_BIN),
+  _pidBack(KS_EMPTY_BIN)
+{}
+
+void Bin::_draw(const Color &col, float size) const
+{
+	drawLine(_base, _val, col, size);
+}
+
+/**
+ * @brief Draw only the "val" Point og the Bin.
+ *
+ * @param size: The size of the point.
+ */
+void Bin::drawVal(float size)
+{
+	_val._size = size;
+	_val.draw();
+}
+
+/**
+ * @brief Create a default (empty) Graph.
+ */
+Graph::Graph()
+: _histoPtr(nullptr),
+  _bins(nullptr),
+  _size(0),
+  _hMargin(30),
+  _collectionPtr(nullptr),
+  _pidColors(nullptr)
+{}
+
+/**
+ * @brief Create a Graph to represent the state of the Vis. model.
+ *
+ * @param histo: Input location for the model descriptor.
+ * @param ct: Input location for the Hash table of Task's colors.
+ */
+Graph::Graph(kshark_trace_histo *histo, KsPlot::ColorTable *ct)
+: _histoPtr(histo),
+  _bins(new Bin[histo->n_bins]),
+  _size(histo->n_bins),
+  _hMargin(30),
+  _collectionPtr(nullptr),
+  _pidColors(ct)
+{
+	if (!_bins) {
+		_size = 0;
+		fprintf(stderr, "Failed to allocate memory graph's bins.\n");
+	}
+
+	_initBins();
+}
+
+/**
+ * @brief Destroy the Graph object.
+ */
+Graph::~Graph()
+{
+	delete[] _bins;
+}
+
+void Graph::_initBins()
+{
+	for (int i = 0; i < _size; ++i) {
+		_bins[i]._base.setX(i + _hMargin);
+		_bins[i]._base.setY(0);
+		_bins[i]._val.setX(_bins[i]._base.x());
+		_bins[i]._val.setY(_bins[i]._base.y());
+	}
+}
+
+/**
+ *  Get the number of bins.
+ */
+int Graph::size()
+{
+	return _size;
+}
+
+/**
+ * @brief Reinitialize the Graph according to the Vis. model.
+ *
+ * @param histo: Input location for the model descriptor.
+ */
+void Graph::setModelPtr(kshark_trace_histo *histo)
+{
+	if (_size != histo->n_bins) {
+		delete[] _bins;
+		_size = histo->n_bins;
+		_bins = new Bin[_size];
+		if (!_bins) {
+			_size = 0;
+			fprintf(stderr,
+				"Failed to allocate memory graph's bins.\n");
+		}
+	}
+
+	_histoPtr = histo;
+	_initBins();
+}
+
+/**
+ * @brief This function will set the Y (vertical) coordinate of the Graph's
+ *	  base. It is safe to use this function even if the Graph contains
+ *	  data.
+ *
+ * @param b: Y coordinate of the Graph's base in pixels.
+ */
+void Graph::setBase(int b)
+{
+	int mod;
+
+	if (!_size)
+		return;
+
+	if (b == _bins[0]._base.y()) // Nothing to do.
+		return;
+
+	for (int i = 0; i < _size; ++i) {
+		mod = _bins[i].mod();
+		_bins[i]._base.setY(b);
+		_bins[i]._val.setY(b + mod);
+	}
+}
+
+/**
+ * @brief Set the vertical size (height) of the Graph.
+ *
+ * @param h: the height of the Graph in pixels.
+ */
+void Graph::setHeight(int h)
+{
+	_height = h;
+}
+
+/**
+ * @brief Set the size of the white space added on both sides of the Graph.
+ *
+ * @param hMargin: the size of the white space in pixels.
+ */
+void Graph::setHMargin(int hMargin)
+{
+	if (!_size)
+		return;
+
+	if (hMargin == _bins[0]._base.x()) // Nothing to do.
+		return;
+
+	for (int i = 0; i < _size; ++i) {
+		_bins[i]._base.setX(i + hMargin);
+		_bins[i]._val.setX(_bins[i]._base.x());
+	}
+
+	_hMargin = hMargin;
+}
+
+/**
+ * @brief Set the value of a given bin.
+ *
+ * @param bin: Bin Id.
+ * @param val: Bin height in pixels.
+ */
+void Graph::setBinValue(int bin, int val)
+{
+	_bins[bin].setVal(val);
+}
+
+/**
+ * @brief Set the Process Id (Front and Back) a given bin.
+ *
+ * @param bin: Bin Id.
+ * @param pidF: The Process Id detected at the from (first in time) edge of
+ *	  the bin.
+ * @param pidB: The Process Id detected at the back (last in time) edge of
+ *	  the bin.
+ */
+void Graph::setBinPid(int bin, int pidF, int pidB)
+{
+	_bins[bin]._pidFront = pidF;
+	_bins[bin]._pidBack = pidB;
+}
+
+/**
+ * @brief Set the color of a given bin.
+ *
+ * @param bin: Bin Id.
+ * @param col: the color of the bin.
+ */
+void Graph::setBinColor(int bin, const Color &col)
+{
+	_bins[bin]._color = col;
+}
+
+/**
+ * @brief Set the visiblity mask of a given bin.
+ *
+ * @param bin: Bin Id.
+ * @param m: the visiblity mask.
+ */
+void Graph::setBinVisMask(int bin, uint8_t m)
+{
+	_bins[bin]._visMask = m;
+}
+
+/**
+ * @brief Set all fields of a given bin.
+ *
+ * @param bin: Bin Id.
+ * @param pidF: The Process Id detected at the from (first in time) edge of
+ *	  the bin.
+ * @param pidB: The Process Id detected at the back (last in time) edge of
+ *	  the bin.
+ * @param col: the color of the bin.
+ * @param m: the visiblity mask.
+ */
+void Graph::setBin(int bin, int pidF, int pidB, const Color &col, uint8_t m)
+{
+	setBinPid(bin, pidF, pidB);
+	setBinValue(bin, _height * .7);
+	setBinColor(bin, col);
+	setBinVisMask(bin, m);
+}
+
+/**
+ * @brief Process a CPU Graph.
+ *
+ * @param cpu: The CPU core.
+ */
+void Graph::fillCPUGraph(int cpu)
+{
+	struct kshark_entry *eFront;
+	int pidFront(0), pidBack(0);
+	int pidBackNoFilter;
+	uint8_t visMask;
+	ssize_t index;
+	int bin;
+
+	auto get_pid = [&] (int bin)
+	{
+		eFront = nullptr;
+
+		pidFront = ksmodel_get_pid_front(_histoPtr, bin,
+							    cpu,
+							    true,
+							    _collectionPtr,
+							    &index);
+
+		if (index >= 0)
+			eFront = _histoPtr->data[index];
+
+		pidBack = ksmodel_get_pid_back(_histoPtr, bin,
+							  cpu,
+							  true,
+							  _collectionPtr,
+							  nullptr);
+
+		if (_collectionPtr && _collectionPtr->size) {
+			pidBackNoFilter =
+				ksmodel_get_pid_back(_histoPtr, bin,
+								cpu,
+								false,
+								_collectionPtr,
+								nullptr);
+
+			if (pidBack != pidBackNoFilter)
+				pidBack = KS_FILTERED_BIN;
+		}
+
+		visMask = 0x0;
+		if (ksmodel_cpu_visible_event_exist(_histoPtr, bin,
+							       cpu,
+							       _collectionPtr,
+							       &index))
+
+			visMask = _histoPtr->data[index]->visible;
+		else if (eFront)
+			visMask = eFront->visible;
+	};
+
+	auto set_bin = [&] (int bin)
+	{
+		if (pidFront != KS_EMPTY_BIN || pidBack != KS_EMPTY_BIN) {
+			/* This is a regular process. */
+			setBin(bin, pidFront, pidBack,
+			       getPidColor(_pidColors, pidFront), visMask);
+		} else {
+			/*
+			 * The bin contens no data from this Cpu or the data
+			 * has been filtered. Whene the graph is ploter the
+			 * Process Id of the bin will be derived from the
+			 * previous bin.
+			 */
+			setBinPid(bin, KS_EMPTY_BIN, KS_EMPTY_BIN);
+		}
+	};
+
+	/*
+	 * Check the content of the very firs bin and see if the Cpu is
+	 * active.
+	 */
+	bin = 0;
+	get_pid(bin);
+	if (pidFront >= 0) {
+		/*
+		 * The Cpu is active and this is a regular process.
+		 * Set this bin.
+		 */
+		set_bin(bin);
+	} else {
+		/*
+		 * No data from this Cpu in the very firs bin. Use the Lower
+		 * Overflow Bin to retrieve the Process Id (if any). First
+		 * get the Pid back, ignoring the filters.
+		 */
+		pidBackNoFilter = ksmodel_get_pid_back(_histoPtr,
+						       LOWER_OVERFLOW_BIN,
+						       cpu,
+						       false,
+						       _collectionPtr,
+						       nullptr);
+
+		/* Now get the Pid back, applying filters. */
+		pidBack = ksmodel_get_pid_back(_histoPtr,
+					       LOWER_OVERFLOW_BIN,
+					       cpu,
+					       true,
+					       _collectionPtr,
+					       nullptr);
+
+		if (pidBack != pidBackNoFilter) {
+			/* The Lower Overflow Bin ends with filtered data. */
+			setBinPid(bin, KS_FILTERED_BIN, KS_FILTERED_BIN);
+		} else {
+			/*
+			 * The Lower Overflow Bin ends with data which has
+			 * to be plotted.
+			 */
+			setBinPid(bin, pidBack, pidBack);
+		}
+	}
+
+	/*
+	 * The first bin is already processed. The loop starts from the second
+	 * bin.
+	 */
+	for (bin = 1; bin < _histoPtr->n_bins; ++bin) {
+		/*
+		 * Check the content of this bin and see if the Cpu is active.
+		 * If yes, retrieve the Process Id. If not, derive from the
+		 * previous bin.
+		 */
+		get_pid(bin);
+		set_bin(bin);
+	}
+}
+
+/**
+ * @brief Process a Task Graph.
+ *
+ * @param pid: The Process Id of the Task.
+ */
+void Graph::fillTaskGraph(int pid)
+{
+	int cpu, pidFront(0), pidBack(0), lastCpu(-1), bin(0);
+	uint8_t visMask;
+	ssize_t index;
+
+	auto set_bin = [&] (int bin)
+	{
+		if (cpu >= 0) {
+			KsPlot::Color col;
+			col.setRainbowColor(cpu);
+
+			/* Data from the Task has been found in this bin. */
+			if (pid == pidFront && pid == pidBack) {
+				/* No data from other tasks in this bin. */
+				setBin(bin, pid, pid, col, visMask);
+			} else if (pid != pidFront && pid != pidBack) {
+				/*
+				 * There is some data from another tasks at
+				 * both front and back sides of this bin. But
+				 * we still want to see this bin drawn.
+				 */
+				setBin(bin, pid, KS_FILTERED_BIN, col,
+				       visMask);
+			} else {
+				if (pidFront != pid) {
+					/*
+					 * There is some data from another
+					 * task at the front side of this bin.
+					 */
+					pidFront = KS_FILTERED_BIN;
+				}
+
+				if (pidBack != pid) {
+					/*
+					 * There is some data from another
+					 * task at the back side of this bin.
+					 */
+					pidBack = KS_FILTERED_BIN;
+				}
+
+				setBin(bin, pidFront, pidBack, col, visMask);
+			}
+
+			lastCpu = cpu;
+		} else {
+			/*
+			 * No data from the Task in this bin. Check the Cpu,
+			 * previously used by the task.
+			 */
+			int cpuPid = ksmodel_get_pid_back(_histoPtr,
+							  bin,
+							  lastCpu,
+							  false,
+							  _collectionPtr,
+							  nullptr);
+
+			if (cpuPid != KS_EMPTY_BIN) {
+				/*
+				 * If the Cpu is active and works on another
+				 * task break the graph here.
+				 */
+				setBinPid(bin, KS_FILTERED_BIN, KS_EMPTY_BIN);
+			} else {
+				/*
+				 * No data from this Cpu in the bin.
+				 * Continue the graph.
+				 */
+				setBinPid(bin, KS_EMPTY_BIN, KS_EMPTY_BIN);
+			}
+		}
+	};
+
+	auto get_pid_cpu = [&] (int bin)
+	{
+		/* Get the CPU used by this task. */
+		cpu = ksmodel_get_cpu_front(_histoPtr, bin,
+						       pid,
+						       false,
+						       _collectionPtr,
+						       nullptr);
+
+		if (cpu < 0) {
+			pidFront = pidBack = cpu;
+		} else {
+			/*
+			 * Get the process Id at the begining and at the end
+			 * of the bin.
+			 */
+			pidFront = ksmodel_get_pid_front(_histoPtr,
+							 bin,
+							 cpu,
+							 false,
+							 _collectionPtr,
+							 nullptr);
+
+			pidBack = ksmodel_get_pid_back(_histoPtr,
+						       bin,
+						       cpu,
+						       false,
+						       _collectionPtr,
+						       nullptr);
+
+			visMask = 0x0;
+			if (ksmodel_task_visible_event_exist(_histoPtr,
+							     bin,
+							     pid,
+							     _collectionPtr,
+							     &index)) {
+				visMask = _histoPtr->data[index]->visible;
+			}
+		}
+	};
+
+	/*
+	 * Check the content of the very firs bin and see if the Task is
+	 * active.
+	 */
+	get_pid_cpu(bin);
+
+	if (cpu >= 0) {
+		/* The Task is active. Set this bin. */
+		set_bin(bin);
+	} else {
+		/*
+		 * No data from this Task in the very firs bin. Use the Lower
+		 * Overflow Bin to retrieve the Cpu used by the task (if any).
+		 */
+		cpu = ksmodel_get_cpu_back(_histoPtr, LOWER_OVERFLOW_BIN, pid,
+					   false, _collectionPtr, nullptr);
+		if (cpu >= 0) {
+			/*
+			 * The Lower Overflow Bin contains data from this Task.
+			 * Now look again in the Lower Overflow Bin and find
+			 * the Pid of the last active task on the same Cpu.
+			 */
+			int pidCpu = ksmodel_get_pid_back(_histoPtr,
+							  LOWER_OVERFLOW_BIN,
+							  cpu,
+							  false,
+							  _collectionPtr,
+							  nullptr);
+			if (pidCpu == pid) {
+				/*
+				 * The Task is the last one running on this
+				 * Cpu. Set the Pid of the bin. In this case
+				 * the very firs bin is empty but we derive
+				 * the Process Id from the Lower Overflow Bin.
+				 */
+				setBinPid(bin, pid, pid);
+				lastCpu = cpu;
+			}
+		}
+	}
+
+	/*
+	 * The first bin is already processed. The loop starts from the second
+	 * bin.
+	 */
+	for (bin = 1; bin < _histoPtr->n_bins; ++bin) {
+		get_pid_cpu(bin);
+
+		/* Set the bin accordingly. */
+		set_bin(bin);
+	}
+}
+
+/**
+ * @brief Draw the Graph
+ *
+ * @param size: The size of the lines of the individual Bins.
+ */
+void Graph::draw(float size)
+{
+	int lastPid(0), b(0), boxH(_height * .3);
+	Rectangle taskBox;
+
+	/*
+	 * Start by drawing a line between the base points of the first and
+	 * the last bin.
+	 */
+	drawLine(_bins[0]._base, _bins[_size - 1]._base, {}, size);
+
+	/* Draw as vartical lines all bins containing data. */
+	for (int i = 0; i < _size; ++i)
+		if (_bins[i]._pidFront >= 0 || _bins[i]._pidBack >= 0)
+			if (_bins[i]._visMask & KS_EVENT_VIEW_FILTER_MASK)
+				_bins[i].draw();
+
+	/*
+	 * Draw colored boxes for processes. First find the first bin, which
+	 * contains data and determine its PID.
+	 */
+	for (; b < _size; ++b) {
+		if (_bins[b]._pidBack > 0) {
+			lastPid = _bins[b]._pidFront;
+			/*
+			 * Initialize a box starting from this bin.
+			 * The color of the taskBox corresponds to the Pid
+			 * of the process.
+			 */
+			taskBox._color = getPidColor(_pidColors, lastPid);
+			taskBox.setPoint(0, _bins[b]._base.x(),
+					_bins[b]._base.y() - boxH);
+			taskBox.setPoint(1, _bins[b]._base.x(),
+					_bins[b]._base.y());
+			break;
+		}
+	}
+
+	for (; b < _size; ++b) {
+		if (_bins[b]._pidFront == KS_EMPTY_BIN &&
+		    _bins[b]._pidBack == KS_EMPTY_BIN) {
+			/*
+			 * This bin is empty. If a colored taskBox is already
+			 * initialized, it will be extended.
+			 */
+			continue;
+		}
+
+		if (_bins[b]._pidFront != _bins[b]._pidBack ||
+		    _bins[b]._pidFront != lastPid ||
+		    _bins[b]._pidBack  != lastPid) {
+			/* A new process starts here. */
+			if (lastPid > 0 && b > 0) {
+				/*
+				 * There is another process running up to this
+				 * point. Close its colored box here and draw.
+				 */
+				taskBox.setPoint(3, _bins[b]._base.x() - 1,
+						_bins[b]._base.y() - boxH);
+				taskBox.setPoint(2, _bins[b]._base.x() - 1,
+						_bins[b]._base.y());
+				taskBox.draw();
+			}
+
+			if (_bins[b]._pidBack > 0) {
+				/*
+				 * This is a regular process. Initialize
+				 * colored box starting from this bin.
+				 */
+				taskBox._color = getPidColor(_pidColors,
+							 _bins[b]._pidBack);
+
+				taskBox.setPoint(0, _bins[b]._base.x() - 1,
+						_bins[b]._base.y() - boxH);
+				taskBox.setPoint(1, _bins[b]._base.x() - 1,
+						_bins[b]._base.y());
+			}
+
+			lastPid = _bins[b]._pidBack;
+		}
+	}
+
+	if (lastPid > 0) {
+		/*
+		 * This is the end of the Graph and we have a process running.
+		 * Close its colored box and draw.
+		 */
+		taskBox.setPoint(3, _bins[_size - 1]._base.x(),
+				_bins[_size - 1]._base.y() - boxH);
+		taskBox.setPoint(2, _bins[_size - 1]._base.x(),
+				_bins[_size - 1]._base.y());
+		taskBox.draw();
+	}
+}
+
+}; // KsPlot
diff --git a/kernel-shark-qt/src/KsPlotTools.hpp b/kernel-shark-qt/src/KsPlotTools.hpp
new file mode 100644
index 0000000..0243cf3
--- /dev/null
+++ b/kernel-shark-qt/src/KsPlotTools.hpp
@@ -0,0 +1,440 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+ /**
+ *  @file    KsPlotTools.hpp
+ *  @brief   KernelShark Plot tools.
+ */
+
+#ifndef _KS_PLOT_TOOLS_H
+#define _KS_PLOT_TOOLS_H
+
+// C++
+#include <unordered_map>
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plot.h"
+#include "libkshark-model.h"
+
+namespace KsPlot {
+
+/** This class represents a RGB color. */
+class Color {
+public:
+	Color();
+
+	Color(uint8_t r, uint8_t g, uint8_t b);
+
+	Color(int rgb);
+
+	/** @brief Get the Red coordinate of the color. */
+	uint8_t r() const {return _col_c.red;}
+
+	/** @brief Get the Green coordinate of the color. */
+	uint8_t g() const {return _col_c.green;}
+
+	/** @brief Get the Blue coordinate of the color. */
+	uint8_t b() const {return _col_c.blue;}
+
+	void set(uint8_t r, uint8_t g, uint8_t b);
+
+	void set(int rgb);
+
+	void setRainbowColor(int n);
+
+	/**
+	 * @brief Get the C struct defining the RGB color.
+	 */
+	const ksplot_color *color_c_ptr() const {return &_col_c;}
+
+	/**
+	 * @brief Set the frequency value used to generate the Rainbow
+	 * palette.
+	 */
+	static void setRainbowFrequency(float f) {_frequency = f;}
+
+	/**
+	 * @brief Get the frequency value used to generate the Rainbow
+	 * palette.
+	 */
+	static float getRainbowFrequency() {return _frequency;}
+
+private:
+	ksplot_color _col_c;
+
+	/** The frequency value used to generate the Rainbow palette. */
+	static float _frequency;
+};
+
+/** Hash table of colors. */
+typedef std::unordered_map<int, KsPlot::Color> ColorTable;
+
+ColorTable getColorTable();
+
+Color getPidColor(ColorTable *colors, int pid);
+
+/** Represents an abstract shape. */
+class Shape {
+public:
+	Shape() : _visible(true), _size(2.) {}
+
+	/**
+	* @brief Destroy the Line object. Keep this destructor virtual.
+	*/
+	virtual ~Shape() {}
+
+	/** Generic function used to draw different shapes. */
+	void draw() const {
+		if (_visible)
+			_draw(_color, _size);
+	}
+
+	/** Is this shape visible. */
+	bool	_visible;
+
+	/** The color of the shape. */
+	Color	_color;
+
+	/** The size of the shape. */
+	float	_size;
+
+private:
+	virtual void _draw(const Color &col, float s) const = 0;
+};
+
+/** This class represents a 2D poin. */
+class Point : public Shape {
+public:
+	Point();
+
+	Point(int x, int y);
+
+	/**
+	* @brief Destroy the Line object. Keep this destructor virtual.
+	*/
+	virtual ~Point() {}
+
+	/** @brief Get the horizontal coordinate of the point. */
+	int x() const {return _point_c.x;}
+
+	/** @brief Get the vertical coordinate of the point. */
+	int y() const {return _point_c.y;}
+
+	/** @brief Set the horizontal coordinate of the point. */
+	void setX(int x) {_point_c.x = x;}
+
+	/** @brief Set the vertical coordinate of the point. */
+	void setY(int y) {_point_c.y = y;}
+
+	/**
+	 * @brief Set the coordinats of the point.
+	 *
+	 * @param x: horizontal coordinate of the point in pixels.
+	 * @param y: vertical coordinate of the point in pixels.
+	 */
+	void set(int x, int y) {
+		_point_c.x = x;
+		_point_c.y = y;
+	}
+
+	/**
+	 * @brief Get the C struct defining the point.
+	 */
+	const ksplot_point *point_c_ptr() const {return &_point_c;}
+
+private:
+	/** The coordinates in pixels. */
+	ksplot_point _point_c;
+
+	void _draw(const Color &col, float size = 1.) const override;
+};
+
+void drawLine(const Point &a, const Point &b,
+	      const Color &col, float s);
+
+/** This class represents a straight line. */
+class Line : public Shape {
+public:
+	Line();
+
+	Line(const Point &a, const Point &b);
+
+	/**
+	* @brief Destroy the Line object. Keep this destructor virtual.
+	*/
+	virtual ~Line() {}
+
+	/**
+	 * @brief Set the coordinats of point A.
+	 *
+	 * @param x: horizontal coordinate of the point in pixels.
+	 * @param y: vertical coordinate of the point in pixels.
+	 */
+	void setA(int x, int y) {
+		  _a.x = x;
+		  _a.y = y;
+	}
+
+	/**
+	 * @brief Set the coordinats of point B.
+	 *
+	 * @param x: horizontal coordinate of the point in pixels.
+	 * @param y: vertical coordinate of the point in pixels.
+	 */
+	void setB(int x, int y) {
+		  _b.x = x;
+		  _b.y = y;
+	}
+
+	/**
+	 * First finishing point of the line.
+	 */
+	ksplot_point _a;
+
+	/**
+	 *Second finishing point of the line.
+	 */
+	ksplot_point _b;
+
+private:
+	void _draw(const Color &col, float size = 1.) const override;
+};
+
+/** This class represents a polygon. */
+class Polygon : public Shape {
+public:
+	Polygon(size_t n);
+
+	/* Disable copying. */
+	Polygon(const Polygon &) = delete;
+
+	/* Disable moving. */
+	Polygon(Polygon &&) = delete;
+
+	virtual ~Polygon();
+
+	void setPoint(size_t i, int x, int y);
+
+	void setPoint(size_t i, const Point &p);
+
+	/**
+	 * @brief Specify the way the polygon will be drawn.
+	 *
+	 * @param f: If True, the area of the polygon will be colored.
+	 *	  Otherwise only the contour of the polygon will be plotted.
+	 */
+	void setFill(bool f) {_fill = f;}
+
+	/**
+	 * @brief Get the number of point used to define the polygon.
+	 */
+	size_t pointCount() const {return _nPoints;}
+
+private:
+	Polygon() = delete;
+
+	void _draw(const Color &, float size = 1.) const override;
+
+	/** The number of point used to define the polygon. */
+	size_t		_nPoints;
+
+	/** The array of point used to define the polygon. */
+	ksplot_point	*_points;
+
+	/**
+	 * If True, the area of the polygon will be colored. Otherwise only
+	 * the contour of the polygon will be plotted.
+	 */
+	bool		_fill;
+};
+
+/** This class represents a triangle. */
+class Triangle : public Polygon {
+public:
+	Triangle() : Polygon(3) {}
+};
+
+/** This class represents a rectangle. */
+class Rectangle : public Polygon {
+public:
+	Rectangle() : Polygon(4) {}
+};
+
+/**
+ * This class represents the graphical element of the KernelShark GUI marker.
+ */
+class Mark : public Shape {
+public:
+	Mark();
+
+	/**
+	* @brief Destroy the Mark object. Keep this destructor virtual.
+	*/
+	virtual ~Mark() {}
+
+	void setDPR(int dpr);
+
+	void setX(int x);
+
+	void setY(int yA, int yB);
+
+	void setCPUY(int yCPU);
+
+	void setCPUVisible(bool v);
+
+	void setTaskY(int yTask);
+
+	void setTaskVisible(bool v);
+
+private:
+	void _draw(const Color &col, float size = 1.) const override;
+
+	/** First finishing point of the Mark's line. */
+	Point _a;
+
+	/** Second finishing point of the Mark's line. */
+	Point _b;
+
+	/** A point indicating the position of the Mark in a CPU graph. */
+	Point _cpu;
+
+	/** A point indicating the position of the Mark in a Task graph. */
+	Point _task;
+};
+
+/** This class represents a KernelShark graph's bin. */
+class Bin : public Shape  {
+public:
+	Bin();
+
+	void drawVal(float size = 2.);
+
+	/** Get the height (module) of the line, representing the Bin. */
+	int mod() {return _val.y() - _base.y();}
+
+	/** @brief Set the vertical coordinate of the "val" Point. */
+	void setVal(int v) {_val.setY(_base.y() - v); }
+
+	/**
+	 * The Process Id detected at the front (first in time) edge of
+	 * the bin.
+	 */
+	int	_pidFront;
+
+	/**
+	 * The Process Id detected at the back (last in time) edge of
+	 * the bin.
+	 */
+	int	_pidBack;
+
+	/**
+	 * Lower finishing point of the line, representing the Bin.
+	 */
+	Point	_base;
+
+	/**
+	 * Upper finishing point of the line, representing the Bin.
+	 */
+	Point	_val;
+
+	/** A bit mask controlling the visibility of the Bin. */
+	uint8_t	_visMask;
+
+private:
+	void _draw(const Color &col, float size = 1.) const override;
+};
+
+/** This class represents a KernelShark graph. */
+class Graph {
+public:
+	Graph();
+
+	/* Disable copying. */
+	Graph(const Graph &) = delete;
+
+	/* Disable moving. */
+	Graph(Graph &&) = delete;
+
+	Graph(kshark_trace_histo *histo, KsPlot::ColorTable *ct);
+
+	~Graph();
+
+	int size();
+
+	void setModelPtr(kshark_trace_histo *histo);
+
+	/**
+	 * @brief Provide the Graph with a Data Collection. The collection
+	 *	  will be used to optimise the processing of the content of
+	 *	  the bins.
+	 *
+	 * @param col: Input location for the data collection descriptor.
+	 */
+	void setDataCollectionPtr(kshark_entry_collection *col) {
+		_collectionPtr = col;
+	}
+
+	/** @brief Set the Hash table of Task's colors. */
+	void setColorTablePtr(KsPlot::ColorTable *ct) {_pidColors = ct;}
+
+	void fillCPUGraph(int cpu);
+
+	void fillTaskGraph(int pid);
+
+	void draw(float s = 1);
+
+	void setBase(int b);
+
+	/** @brief Get the vertical coordinate of the Graph's base. */
+	int getBase() const {return _bins[0]._base.y();}
+
+	void setHeight(int h);
+
+	void setBinValue(int bin, int val);
+
+	void setBinPid(int bin, int pidF, int pidB);
+
+	void setBinColor(int bin, const Color &col);
+
+	void setBinVisMask(int bin, uint8_t m);
+
+	void setBin(int bin, int pidF, int pidB,
+		    const Color &col, uint8_t m);
+
+	void setHMargin(int hMargin);
+
+private:
+	/** Pointer to the model descriptor object. */
+	kshark_trace_histo	*_histoPtr;
+
+	/** An array of Bins. */
+	Bin			*_bins;
+
+	/** The number of Bins. */
+	int			_size;
+
+	/**
+	 * The size (in pixels) of the white space added on both sides of
+	 * the Graph.
+	 */
+	int			_hMargin;
+
+	/** The vertical size (height) of the Graph. */
+	int			_height;
+
+	/** Pointer to the data collection object. */
+	kshark_entry_collection	*_collectionPtr;
+
+	/** Hash table of Task's colors. */
+	ColorTable		*_pidColors;
+
+	void _initBins();
+};
+
+}; // KsPlot
+
+#endif  /* _KS_PLOT_TOOLS_H */
-- 
2.17.1
