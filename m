Return-Path: <SRS0=NWCu=LL=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:40847 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbeH1RAn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Aug 2018 13:00:43 -0400
Received: by mail-wm0-f67.google.com with SMTP id 207-v6so1934984wme.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Aug 2018 06:09:07 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 4/4] kernel-shark-qt: Add an example showing how to draw shapes and Graphs.
Date: Tue, 28 Aug 2018 16:08:38 +0300
Message-Id: <20180828130838.30790-5-y.karadz@gmail.com>
In-Reply-To: <20180828130838.30790-1-y.karadz@gmail.com>
References: <20180828130838.30790-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch introduces a basic example, showing how to initialize OpenGL
and how to use the C++ API in order to draw simple shapes or to show
animated Graphs.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/examples/CMakeLists.txt |   4 +
 kernel-shark-qt/examples/dataplot.cpp   | 231 ++++++++++++++++++++++++
 2 files changed, 235 insertions(+)
 create mode 100644 kernel-shark-qt/examples/dataplot.cpp

diff --git a/kernel-shark-qt/examples/CMakeLists.txt b/kernel-shark-qt/examples/CMakeLists.txt
index a3745fa..0c83293 100644
--- a/kernel-shark-qt/examples/CMakeLists.txt
+++ b/kernel-shark-qt/examples/CMakeLists.txt
@@ -15,3 +15,7 @@ target_link_libraries(dhisto   kshark)
 message(STATUS "confogio")
 add_executable(confio          configio.c)
 target_link_libraries(confio   kshark)
+
+message(STATUS "dataplot")
+add_executable(dplot          dataplot.cpp)
+target_link_libraries(dplot   kshark-plot)
diff --git a/kernel-shark-qt/examples/dataplot.cpp b/kernel-shark-qt/examples/dataplot.cpp
new file mode 100644
index 0000000..27a0125
--- /dev/null
+++ b/kernel-shark-qt/examples/dataplot.cpp
@@ -0,0 +1,231 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+// C
+#include <getopt.h>
+
+// C++
+#include <vector>
+#include <iostream>
+
+// OpenGL
+#include <GL/freeglut.h>
+
+// KernelShark
+#include "libkshark.h"
+#include "KsPlotTools.hpp"
+
+using namespace std;
+
+#define GRAPH_HEIGHT	40   // width of the graph in pixels
+#define GRAPH_H_MARGIN	50   // size of the white space surrounding the graph
+#define WINDOW_WIDTH	800  // width of the screen window in pixels
+#define WINDOW_HEIGHT	480  // height of the scrren window in pixels
+
+#define default_file (char*)"trace.dat"
+
+struct kshark_trace_histo	histo;
+vector<KsPlot::Graph *>		graphs;
+
+void usage(const char *prog)
+{
+	cout << "Usage: " << prog << endl;
+	cout << "  -h	Display this help message\n";
+	cout << "  -s	Draw shapes. This demonstrates how to draw simple "
+	     << "geom. shapes.\n";
+	cout << "  -i	<file>	Input file and draw animated graphs.\n";
+	cout << "  No args.	Import " << default_file
+	     << "and draw animated graphs.\n";
+}
+
+/* An example function drawing something. */
+void drawShapes()
+{
+	/* Clear the screen. */
+	glClear(GL_COLOR_BUFFER_BIT);
+
+	KsPlot::Triangle t;
+	KsPlot::Point a(200, 100), b(200, 300), c(400, 100);
+	t.setPoint(0, a);
+	t.setPoint(1, b);
+	t.setPoint(2, c);
+
+	/* Set RGB color. */
+	t._color = {100, 200, 50};
+	t.draw();
+
+	KsPlot::Rectangle r;
+	KsPlot::Point d(400, 200), e(400, 300), f(500, 300), g(500, 200);
+	r.setPoint(0, d);
+	r.setPoint(1, e);
+	r.setPoint(2, f);
+	r.setPoint(3, g);
+
+	/* Set RGB color. */
+	r._color = {150, 50, 250};
+	r._size = 3;
+
+	/* Do not fiil the rectangle. Draw the contour only. */
+	r.setFill(false);
+	r.draw();
+
+	glFlush();
+}
+
+/* An example function demonstrating Zoom In and Zoom Out. */
+void play()
+{
+	KsPlot::ColorTable colors = KsPlot::getColorTable();
+	vector<KsPlot::Graph *>::iterator it;
+	vector<int> CPUs, Tasks;
+	KsPlot::Graph *graph;
+	bool zoomIn(true);
+	int base;
+
+	CPUs = {3, 4, 6};
+	Tasks = {}; // Add valid pids here, if you want task plots.
+
+	for (size_t i = 0; i < CPUs.size() + Tasks.size(); ++i) {
+		/* Make a new Graph. */
+		graph = new KsPlot::Graph(&histo, &colors);
+
+		/* Set the dimensions of the Graph. */
+		graph->setHeight(GRAPH_HEIGHT);
+		graph->setHMargin(GRAPH_H_MARGIN);
+
+		/*
+		 * Set the Y coordinate of the Graph's base.
+		 * Remember that the "Y" coordinate is inverted.
+		 */
+		base = 1.7 * GRAPH_HEIGHT * (i + 1);
+		graph->setBase(base);
+
+		/* Add the Graph. */
+		graphs.push_back(graph);
+	}
+
+	for (int i = 1; i < 1000; ++i) {
+		it = graphs.begin();
+
+		for (int const &cpu: CPUs)
+			(*it++)->fillCPUGraph(cpu);
+
+		for (int const &pid: Tasks)
+			(*it++)->fillTaskGraph(pid);
+
+		/* Clear the screen. */
+		glClear(GL_COLOR_BUFFER_BIT);
+
+		/* Draw all graphs. */
+		for (auto &g: graphs)
+			g->draw();
+
+		glFlush();
+
+		if (!(i % 250))
+			zoomIn = !zoomIn;
+
+		if (zoomIn)
+			ksmodel_zoom_in(&histo, .01, -1);
+		else
+			ksmodel_zoom_out(&histo, .01, -1);
+	}
+}
+
+int main(int argc, char **argv)
+{
+	struct kshark_context *kshark_ctx(nullptr);
+	struct kshark_entry **data(nullptr);
+	static char *input_file(nullptr);
+	bool status, shapes(false);
+	size_t r, nRows;
+	int c, nBins;
+
+	while ((c = getopt(argc, argv, "hsi:")) != -1) {
+		switch(c) {
+		case 'h':
+			usage(argv[0]);
+			return 1;
+		case 'i':
+			input_file = optarg;
+			break;
+		case 's':
+			shapes = true;
+
+		default:
+			break;
+		}
+	}
+
+	auto lamDraw = [&] (void (*func)(void)) {
+		/* Initialize OpenGL/Glut. */
+		glutInit(&argc, argv);
+		ksplot_make_scene(WINDOW_WIDTH, WINDOW_HEIGHT);
+		ksplot_init_opengl(1);
+
+		/* Display something. */
+		glutDisplayFunc(func);
+		glutMainLoop();
+	};
+
+	if (shapes) {
+		/* Draw simple shapes. */
+		lamDraw(drawShapes);
+		return 0;
+	}
+
+	/* Create a new kshark session. */
+	if (!kshark_instance(&kshark_ctx))
+		return 1;
+
+	/* Open a trace data file produced by trace-cmd. */
+	if (!input_file)
+		input_file = default_file;
+
+	status = kshark_open(kshark_ctx, input_file);
+	if (!status) {
+		kshark_free(kshark_ctx);
+		usage(argv[0]);
+		cerr << "\nFailed to open file " << input_file << endl;
+
+		return 1;
+	}
+
+	/* Load the content of the file into an array of entries. */
+	nRows = kshark_load_data_entries(kshark_ctx, &data);
+
+	/* Initialize the Visualization Model. */
+	ksmodel_init(&histo);
+
+	nBins = WINDOW_WIDTH - 2 * GRAPH_HEIGHT;
+	ksmodel_set_bining(&histo, nBins, data[0]->ts,
+					  data[nRows - 1]->ts);
+
+	/* Fill the model with data and calculate its state. */
+	ksmodel_fill(&histo, data, nRows);
+
+	/* Play animated Graph. */
+	lamDraw(play);
+
+	/* Free the memory. */
+	for (auto &g: graphs)
+		delete g;
+
+	for (r = 0; r < nRows; ++r)
+		free(data[r]);
+	free(data);
+
+	/* Reset (clear) the model. */
+	ksmodel_clear(&histo);
+
+	/* Close the file. */
+	kshark_close(kshark_ctx);
+
+	/* Close the session. */
+	kshark_free(kshark_ctx);
+
+	return 0;
+}
-- 
2.17.1
