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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA84C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C928064E95
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhBKKh4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhBKKfp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:35:45 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C78FC061356
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:36 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id y8so6400868ede.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mk7RKVqltUL8uHv6iXoM+w2VJPqVIq3/xp5TZZFUx4Y=;
        b=ZCV6gJVVhRR9iD4Bd5DEVOsvNOIB8pUPhlJJhy1Ie0KrE650lfICKNPzd6wzHHZWcL
         nUO6lFtQeB1qfizVyTMevLBG6/JwHC5TxwKtqpHszHEuInab/8ciAlpJS4SXhqWMX88+
         9NwjSr/RM0Oeb9BWb3Ce14b+zQxVSOeQ3ebNbavwEHCN+7ED8LKlPhNbHWnz9ND58b/+
         ebnDIsM0JNgag3a7qu+nGvzefyXQ1glQd8snxOfKEXTyBDQsu0vJpMB7sqNhcElGugyQ
         O+QjMNhDpfUTEyRTZtJ7BEP1zxIAv2pDOpNGMI3VS1OimTWwpSEr5uu8tIjhGJnxBmNN
         P6+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mk7RKVqltUL8uHv6iXoM+w2VJPqVIq3/xp5TZZFUx4Y=;
        b=Xe8B1BbAlDxpVTKE8AXFLVQ+oaYxXB6OGnOrwh6BN0KWl6np8cxB996yPITTjBkIh5
         s8Kr/MLo+BNN9vOhMphpG7tJuDu1oUQG0HTK3ClAw6Jo1FcYn9RQ5dlxTYJBJJr9XVWK
         c8FzO0rr0J8m/XiMzxJ6V+IDecdJ/MUUtqVaNbLYqB7aKMhXUCK23W1lcRr8mMWMocKG
         whcG99RYCO53NQGAyQ7IezoiI5BEAa1+aUxf/rznpuA4UanCNcHN4bhy/0nCHQjC7T+C
         jJxFkaqG223KdB+ozrjEhCNwmZOHbNp0XlMHyURmmM2H5QBJf7xXhI7BxykKZJv6EXI1
         WiRg==
X-Gm-Message-State: AOAM530sRqKGqi+NbN4UmBp1Q8aon61eafRWEBn8je0PMeAdgnPKmrvM
        ykz7jY3GeqZAv7G6DOO38sY=
X-Google-Smtp-Source: ABdhPJyP7LYGgw1VRvtb853EVpSyc9O4wY8qTI9ofSTyLEjpFc60AeeI5U58WzDT1VJF5vESk6b18Q==
X-Received: by 2002:aa7:d692:: with SMTP id d18mr7829208edr.327.1613039554963;
        Thu, 11 Feb 2021 02:32:34 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:34 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 14/27] kernel-shark: Update the plotting example
Date:   Thu, 11 Feb 2021 12:31:52 +0200
Message-Id: <20210211103205.418588-15-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
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

