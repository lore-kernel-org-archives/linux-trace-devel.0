Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99EAC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BFF464EA9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhBARZw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhBARZn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:25:43 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42263C0617A9
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:27 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id p20so6260424ejb.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mk7RKVqltUL8uHv6iXoM+w2VJPqVIq3/xp5TZZFUx4Y=;
        b=g8qIX5F+tBtohn5a3HxNyUmmKD2dAItgrxrvRhAKIifiW+LKo+wNT/1VgPM0pLP1y6
         BArOy+gcJ7wpxnUcdOHg0J1oQ8W3hgtdC6LgobPWaeca1lALfndUx4/jKMpMIwiYwxof
         mAu4mO/8J0oWp9k5/Ne3XfOB+Z3XHCrlgHJ9SDISMNCq/ccrZcvY/MSCTMPb6ZPX8yMM
         m/fyIgFJLbNXtUcXjIDCjjkiOZv+ZjyGwMOyl8kXKqeIsoIkwiwpLbDCEP7vCx8DSQ12
         Z4jELaCx9nd6z3LQDtOO5RC1qiyLW1cz4tj/oNkxkpo/PgXhi4M2dyLVcx0MkJKznPUk
         ZFOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mk7RKVqltUL8uHv6iXoM+w2VJPqVIq3/xp5TZZFUx4Y=;
        b=FC35xVRIHSwtnbU6Ex7BHc8PCq6Scfan+EtvLNJd/DfD3ddTBV7UY8jQTrU4uMmMkr
         Z2O6+7TO3rlFIQX+N+oeAapjyPztyMOSLkh+kZqIpObjmYUyTtip8JP9smKrDcvQckvS
         jTLNEKc92OwkDx95Ds1+uP7Eetm8BJoU4NlHE9QJ97LC7qyVXh6DEdQvcFW62Hz1+1Bz
         ZLLnyNqZHtzuV+KHYare7pxCBxSX+ldQONjbIlmqfYoiuNVkW0duUe1EQuAxFqXHtItX
         gkuWUW0nJFTpV5KovznB2uXU2fT7x6yF1YkJNW0wvq0lI/S8C9wSDGlhaSqWG5ovTHit
         p8bw==
X-Gm-Message-State: AOAM533EV5eYOxjzuJgW0gdb2j6G9aYPUpzMFaVj8VFYAdJbAMMCfmPL
        wOEf9kyqKr6/ikjVM68ZE59RkCBqvdY=
X-Google-Smtp-Source: ABdhPJzjBmgO+9Z5vfgmSMSh2sU+V7lAUtQhQBxCuxk/PJkfApWFBt9gwbqgXxYVtxd62CBi4QX1xw==
X-Received: by 2002:a17:906:7a42:: with SMTP id i2mr19255417ejo.27.1612200265954;
        Mon, 01 Feb 2021 09:24:25 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:25 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 14/24] kernel-shark: Update the plotting example
Date:   Mon,  1 Feb 2021 19:23:48 +0200
Message-Id: <20210201172358.175407-15-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The compilation of the plotting example is re-enabled and it is
made compatible with the new version of the C API of libkshark
(KernelShark 2.0).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/CMakeLists.txt |  6 +--
 examples/dataplot.cpp   | 88 ++++++++++++++++++++++++++++-------------
 2 files changed, 63 insertions(+), 31 deletions(-)

diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
index 8360841..e6af5f2 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
@@ -20,9 +20,9 @@ message(STATUS "confogio")
 add_executable(confio          configio.c)
 target_link_libraries(confio   kshark)
 
-# message(STATUS "dataplot")
-# add_executable(dplot          dataplot.cpp)
-# target_link_libraries(dplot   kshark-plot)
+message(STATUS "dataplot")
+add_executable(dplot          dataplot.cpp)
+target_link_libraries(dplot   kshark-plot)
 
 if (Qt5Widgets_FOUND)
 
diff --git a/examples/dataplot.cpp b/examples/dataplot.cpp
index 94841e7..b3ff29f 100644
--- a/examples/dataplot.cpp
+++ b/examples/dataplot.cpp
@@ -10,6 +10,7 @@
 // C++
 #include <vector>
 #include <iostream>
+#include <sstream>
 
 // OpenGL
 #include <GL/freeglut.h>
@@ -20,25 +21,29 @@
 
 using namespace std;
 
-#define GRAPH_HEIGHT	40   // width of the graph in pixels
-#define GRAPH_H_MARGIN	50   // size of the white space surrounding the graph
-#define WINDOW_WIDTH	800  // width of the screen window in pixels
-#define WINDOW_HEIGHT	480  // height of the scrren window in pixels
+#define GRAPH_HEIGHT		40   // width of the graph in pixels
+#define GRAPH_H_MARGIN		15   // size of the white space surrounding
+				     // the graph
+#define GRAPH_LABEL_WIDTH	80   // width of the graph's label in pixels
+#define WINDOW_WIDTH		800  // width of the screen window in pixels
+#define WINDOW_HEIGHT		480  // height of the scrren window in pixels
 
 #define default_file (char*)"trace.dat"
 
 struct kshark_trace_histo	histo;
 vector<KsPlot::Graph *>		graphs;
+struct ksplot_font		font;
+int stream_id;
 
 void usage(const char *prog)
 {
 	cout << "Usage: " << prog << endl;
-	cout << "  -h	Display this help message\n";
+	cout << "  -h	Display this help message.\n";
 	cout << "  -s	Draw shapes. This demonstrates how to draw simple "
 	     << "geom. shapes.\n";
 	cout << "  -i	<file>	Input file and draw animated graphs.\n";
 	cout << "  No args.	Import " << default_file
-	     << "and draw animated graphs.\n";
+	     << " and draw animated graphs.\n";
 }
 
 /* An example function drawing something. */
@@ -57,6 +62,11 @@ void drawShapes()
 	t._color = {100, 200, 50};
 	t.draw();
 
+	/* Print/draw "Hello Kernel!". */
+	KsPlot::Color col = {50, 150, 255};
+	KsPlot::TextBox tb(&font, "Hello Kernel!", col, {250, 70}, 250);
+	tb.draw();
+
 	KsPlot::Rectangle r;
 	KsPlot::Point d(400, 200), e(400, 300), f(500, 300), g(500, 200);
 	r.setPoint(0, d);
@@ -78,13 +88,14 @@ void drawShapes()
 /* An example function demonstrating Zoom In and Zoom Out. */
 void play()
 {
-	KsPlot::ColorTable taskColors = KsPlot::getTaskColorTable();
-	KsPlot::ColorTable cpuColors = KsPlot::getCPUColorTable();
+	KsPlot::ColorTable taskColors = KsPlot::taskColorTable();
+	KsPlot::ColorTable cpuColors = KsPlot::CPUColorTable();
 	vector<KsPlot::Graph *>::iterator it;
+	KsPlot::Graph *graph;
 	vector<int> CPUs, Tasks;
 	bool zoomIn(true);
 	int base;
-	size_t i;
+	size_t i(1);
 
 	CPUs = {3, 4, 6};
 	Tasks = {}; // Add valid pids here, if you want task plots.
@@ -92,35 +103,47 @@ void play()
 	auto lamAddGraph = [&] (KsPlot::Graph *g) {
 		/* Set the dimensions of the Graph. */
 		g->setHeight(GRAPH_HEIGHT);
-		g->setHMargin(GRAPH_H_MARGIN);
 
 		/*
 		 * Set the Y coordinate of the Graph's base.
 		 * Remember that the "Y" coordinate is inverted.
 		 */
-		base = 1.7 * GRAPH_HEIGHT * (i + 1);
+		base = 1.7 * GRAPH_HEIGHT * (i++);
 		g->setBase(base);
 
+		g->setLabelAppearance(&font, {160, 255, 255}, GRAPH_LABEL_WIDTH,
+							      GRAPH_H_MARGIN);
+
 		/* Add the Graph. */
 		graphs.push_back(g);
 	};
 
-	for (i = 0; i < CPUs.size(); ++i)
-		lamAddGraph(new KsPlot::Graph(&histo, &taskColors,
-						      &taskColors));
+	for (auto const &cpu: CPUs) {
+		std::stringstream ss;
+		ss << "CPU " << cpu;
+
+		graph = new KsPlot::Graph(&histo, &taskColors, &taskColors);
+		graph->setLabelText(ss.str());
+		lamAddGraph(graph);
+	}
+
+	for (auto const &pid: Tasks) {
+		std::stringstream ss;
+		ss << "PID " << pid;
 
-	for (;i < CPUs.size() + Tasks.size(); ++i)
-		lamAddGraph(new KsPlot::Graph(&histo, &taskColors,
-						      &cpuColors));
+		graph = new KsPlot::Graph(&histo, &taskColors, &cpuColors);
+		graph->setLabelText(ss.str());
+		lamAddGraph(graph);
+	}
 
 	for (i = 1; i < 1000; ++i) {
 		it = graphs.begin();
 
 		for (int const &cpu: CPUs)
-			(*it++)->fillCPUGraph(cpu);
+			(*it++)->fillCPUGraph(stream_id, cpu);
 
 		for (int const &pid: Tasks)
-			(*it++)->fillTaskGraph(pid);
+			(*it++)->fillTaskGraph(stream_id, pid);
 
 		/* Clear the screen. */
 		glClear(GL_COLOR_BUFFER_BIT);
@@ -146,7 +169,8 @@ int main(int argc, char **argv)
 	struct kshark_context *kshark_ctx(nullptr);
 	struct kshark_entry **data(nullptr);
 	static char *input_file(nullptr);
-	bool status, shapes(false);
+	bool shapes(false);
+	char *font_file;
 	size_t r, nRows;
 	int c, nBins;
 
@@ -166,11 +190,20 @@ int main(int argc, char **argv)
 		}
 	}
 
+	font_file = ksplot_find_font_file("FreeMono", "FreeMonoBold");
+	if (!font_file)
+		return 1;
+
 	auto lamDraw = [&] (void (*func)(void)) {
-		/* Initialize OpenGL/Glut. */
+		/* Initialize Glut. */
 		glutInit(&argc, argv);
 		ksplot_make_scene(WINDOW_WIDTH, WINDOW_HEIGHT);
+
+		/* Initialize OpenGL. */
 		ksplot_init_opengl(1);
+		ksplot_resize_opengl(WINDOW_WIDTH, WINDOW_HEIGHT);
+
+		ksplot_init_font(&font, 18, font_file);
 
 		/* Display something. */
 		glutDisplayFunc(func);
@@ -191,8 +224,8 @@ int main(int argc, char **argv)
 	if (!input_file)
 		input_file = default_file;
 
-	status = kshark_open(kshark_ctx, input_file);
-	if (!status) {
+	stream_id = kshark_open(kshark_ctx, input_file);
+	if (stream_id < 0) {
 		kshark_free(kshark_ctx);
 		usage(argv[0]);
 		cerr << "\nFailed to open file " << input_file << endl;
@@ -201,12 +234,12 @@ int main(int argc, char **argv)
 	}
 
 	/* Load the content of the file into an array of entries. */
-	nRows = kshark_load_data_entries(kshark_ctx, &data);
+	nRows = kshark_load_entries(kshark_ctx, stream_id, &data);
 
 	/* Initialize the Visualization Model. */
 	ksmodel_init(&histo);
 
-	nBins = WINDOW_WIDTH - 2 * GRAPH_HEIGHT;
+	nBins = WINDOW_WIDTH - GRAPH_LABEL_WIDTH - 3 * GRAPH_H_MARGIN;
 	ksmodel_set_bining(&histo, nBins, data[0]->ts,
 					  data[nRows - 1]->ts);
 
@@ -216,6 +249,8 @@ int main(int argc, char **argv)
 	/* Play animated Graph. */
 	lamDraw(play);
 
+	free(font_file);
+
 	/* Free the memory. */
 	for (auto &g: graphs)
 		delete g;
@@ -227,9 +262,6 @@ int main(int argc, char **argv)
 	/* Reset (clear) the model. */
 	ksmodel_clear(&histo);
 
-	/* Close the file. */
-	kshark_close(kshark_ctx);
-
 	/* Close the session. */
 	kshark_free(kshark_ctx);
 
-- 
2.25.1

