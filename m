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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3D9C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D9BF64E9A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhBKKig (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhBKKfs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:35:48 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9E4C06121D
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:38 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id i8so9257107ejc.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CTTjv0HS6rHH6gl/Dq9BngtCA6ve2sCn45fKULW5A6w=;
        b=KpeYVy/KXMSdL1wrAcVXjf/YG5iMpBEPGjkMAr5kENgCBKP1g+g8G5plD7do3Nlsut
         FHsUAwRXvCxBgj3wQUTcAq8mAU3g3rrk1TkDr7pFDV+RXK7hJ8tivhLhRbnWOaCpaT5Z
         SwJSKYvZIO6SRLTYr19BRt7CJd16S7S0qGztPXZR8/20HOgOMq1CY/fcrEKhrfueAwav
         hIHgoVXDMycK5rcaLAWiB7cUXIe8iMGxcWxD90YUbpEAnkfDzfCgwt0IhoKOVTMNM2Gq
         kEY5+o5xcCB/L+SGAkdW9Pt0I17J4tF7znO0LNVwl2lwhLiWqyYbX381kKZq5yNYf2yC
         BtbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CTTjv0HS6rHH6gl/Dq9BngtCA6ve2sCn45fKULW5A6w=;
        b=hnx6auZGgcgs04Cp40BXEXWewYtelsYIwYK9rucQ91rlu7E7bIawkAeNzSsvRcD4Q/
         1Ukv3YfiWhM0zKQuuYFRqP07W6WjpHQ0UeASI+OT6/XMkBFbxhpk3zVhqE0rGLxRwPob
         9nErdV+TZUEgHZq1K1xXJlCgtxcWZmzV5vQ+cxQJjfmrsKcXDnlVq/TWXyTTl52IJRGU
         CDpsiLS78JqumKqZDtveKvLO5mwum4OQG99vYWACfM17Gu3h1KUa3fH6E8Q6w66r3EFh
         gDPxmou0DW77Q/Sc44tqaUGI7PWbq4coOa6CkKWlGcXjCbEuRIoAC/xVirA9QhjHw2sd
         otFw==
X-Gm-Message-State: AOAM531wOwzJBJXSDTqFfSOCTci40m9TImrRZYgXz0J+44zacmRIooX/
        QPMlALJKXNHj1xM2z0Q82yo=
X-Google-Smtp-Source: ABdhPJzjnIhLfEJW+qo5nEwKpNR0w9blgJqXZjaOxJSy875mS6s7nBMiUVNfCXiqKiIf5X0bXzaQQA==
X-Received: by 2002:a17:907:96aa:: with SMTP id hd42mr7651011ejc.526.1613039557053;
        Thu, 11 Feb 2021 02:32:37 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:36 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 16/27] kernel-shark: Update KsDualMarker and KsGLWidget
Date:   Thu, 11 Feb 2021 12:31:54 +0200
Message-Id: <20210211103205.418588-17-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The compilation of KsDualMarker.cpp and KsGLWidget.cpp is re-enabled
and all functionalities are made compatible with the new version of
the C API of libkshark (KernelShark 2.0). The two source files are
updated in a single patch because of their interdependence.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt   |   8 +-
 src/KsDualMarker.cpp |  23 +-
 src/KsDualMarker.hpp |  16 +-
 src/KsGLWidget.cpp   | 696 +++++++++++++++++++++++++++++--------------
 src/KsGLWidget.hpp   | 187 +++++++++---
 5 files changed, 629 insertions(+), 301 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 6c02d82..3dc7213 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -68,9 +68,9 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
     message(STATUS "libkshark-gui")
     set (ks-guiLib_hdr  KsUtils.hpp
                         KsModels.hpp
-#                         KsGLWidget.hpp
+                        KsGLWidget.hpp
                         KsSearchFSM.hpp
-#                         KsDualMarker.hpp
+                        KsDualMarker.hpp
                         KsWidgetsLib.hpp)
 #                         KsTraceGraph.hpp
 #                         KsTraceViewer.hpp
@@ -84,9 +84,9 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
     add_library(kshark-gui  SHARED  ${ks-guiLib_hdr_moc}    KsUtils.cpp
                                                             KsModels.cpp
 #                                                             KsSession.cpp
-#                                                             KsGLWidget.cpp
+                                                            KsGLWidget.cpp
                                                             KsSearchFSM.cpp
-#                                                             KsDualMarker.cpp
+                                                            KsDualMarker.cpp
                                                             KsWidgetsLib.cpp)
 #                                                             KsTraceGraph.cpp
 #                                                             KsTraceViewer.cpp
diff --git a/src/KsDualMarker.cpp b/src/KsDualMarker.cpp
index 90c5373..9fb68e7 100644
--- a/src/KsDualMarker.cpp
+++ b/src/KsDualMarker.cpp
@@ -59,10 +59,8 @@ void KsGraphMark::reset()
 {
 	_isSet = false;
 	_bin = -1;
-	_cpu = -1;
-	_task = -1;
 	_pos = 0;
-
+	_sd = 0;
 	_mark._visible = false;
 }
 
@@ -72,17 +70,17 @@ void KsGraphMark::reset()
  * @param data: Input location for the Data Store object.
  * @param histo: Input location for the model descriptor.
  * @param pos: The index inside the data array this marker will points to.
- * @param cpuGraph: The index of the CPU Graph this marker points to.
- * @param taskGraph: The index of the Task Graph this marker points to.
+ * @param sd: Data stream identifier.
  */
 bool KsGraphMark::set(const KsDataStore &data,
 		      kshark_trace_histo *histo,
-		      size_t pos, int cpuGraph, int taskGraph)
+		      ssize_t pos, int sd)
 {
 	uint8_t visFlags;
 
 	_isSet = true;
 	_pos = pos;
+	_sd = sd;
 	_ts = data.rows()[_pos]->ts;
 	visFlags = data.rows()[_pos]->visible;
 
@@ -92,9 +90,6 @@ bool KsGraphMark::set(const KsDataStore &data,
 	else
 		_mark.setDashed(true);
 
-	_cpu = cpuGraph;
-	_task = taskGraph;
-
 	if (_ts > histo->max || _ts < histo->min) {
 		_bin = -1;
 		_mark._visible = false;
@@ -119,7 +114,7 @@ bool KsGraphMark::update(const KsDataStore &data, kshark_trace_histo *histo)
 	if (!_isSet)
 		return false;
 
-	return set(data, histo, this->_pos, this->_cpu, this->_task);
+	return set(data, histo, this->_pos, this->_sd);
 }
 
 /** Unset the Marker and make it invisible. */
@@ -151,8 +146,8 @@ KsDualMarkerSM::KsDualMarkerSM(QWidget *parent)
 {
 	QString styleSheetA, styleSheetB;
 
-	_buttonA.setFixedWidth(STRING_WIDTH(" Marker A "));
-	_buttonB.setFixedWidth(STRING_WIDTH(" Marker B "));
+	_buttonA.setFixedWidth(STRING_WIDTH(" Marker A ") + FONT_WIDTH);
+	_buttonB.setFixedWidth(STRING_WIDTH(" Marker B ") + FONT_WIDTH);
 
 	for (auto const &l: {&_labelMA, &_labelMB, &_labelDelta}) {
 		l->setFrameStyle(QFrame::Panel | QFrame::Sunken);
@@ -318,10 +313,10 @@ void KsDualMarkerSM::updateMarkers(const KsDataStore &data,
 				   KsGLWidget *glw)
 {
 	if(_markA.update(data, glw->model()->histo()))
-		glw->setMark(&_markA);
+		glw->setMarkPoints(data, &_markA);
 
 	if(_markB.update(data, glw->model()->histo()))
-		glw->setMark(&_markB);
+		glw->setMarkPoints(data, &_markB);
 
 	updateLabels();
 }
diff --git a/src/KsDualMarker.hpp b/src/KsDualMarker.hpp
index 597bddb..0dcaf93 100644
--- a/src/KsDualMarker.hpp
+++ b/src/KsDualMarker.hpp
@@ -66,9 +66,7 @@ public:
 
 	bool set(const KsDataStore &data,
 		 kshark_trace_histo *histo,
-		 size_t pos,
-		 int cpuGraph,
-		 int taskGraph);
+		 ssize_t pos, int sd);
 
 	bool update(const KsDataStore &data, kshark_trace_histo *histo);
 
@@ -83,24 +81,20 @@ public:
 
 	void remove();
 
-public:
 	/** Is this marker set. */
 	bool		_isSet;
 
 	/** The number of the bin this marker points to. */
 	int		_bin;
 
-	/** The index of the CPU Graph this marker points to. */
-	int		_cpu;
-
-	/** The  index of the Task Graph this marker points to. */
-	int		_task;
+	/** Data stream identifier of the Graph this marker points to. */
+	int		_sd;
 
 	/** The index inside the data array this marker points to. */
-	size_t		_pos;
+	ssize_t		_pos;
 
 	/** The timestamp of the marker. */
-	uint64_t	_ts;
+	int64_t		_ts;
 
 	/** The RGB color of the marker. */
 	QColor		_color;
diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
index 78ded33..9f8e43b 100644
--- a/src/KsGLWidget.cpp
+++ b/src/KsGLWidget.cpp
@@ -14,16 +14,35 @@
 #include <GL/gl.h>
 
 // KernelShark
+#include "libkshark-plugin.h"
 #include "KsGLWidget.hpp"
 #include "KsUtils.hpp"
 #include "KsPlugins.hpp"
-#include "KsDualMarker.hpp"
+
+/** A stream operator for converting vector of integers into KsPlotEntry. */
+KsPlotEntry &operator <<(KsPlotEntry &plot, QVector<int> &v)
+{
+	plot._streamId = v.takeFirst();
+	plot._type = v.takeFirst();
+	plot._id = v.takeFirst();
+
+	return plot;
+}
+
+/** A stream operator for converting KsPlotEntry into vector of integers. */
+void operator >>(const KsPlotEntry &plot, QVector<int> &v)
+{
+	v.append(plot._streamId);
+	v.append(plot._type);
+	v.append(plot._id);
+}
 
 /** Create a default (empty) OpenGL widget. */
 KsGLWidget::KsGLWidget(QWidget *parent)
 : QOpenGLWidget(parent),
-  _hMargin(20),
-  _vMargin(30),
+  _labelSize(100),
+  _hMargin(15),
+  _vMargin(25),
   _vSpacing(20),
   _mState(nullptr),
   _data(nullptr),
@@ -40,10 +59,28 @@ KsGLWidget::KsGLWidget(QWidget *parent)
 	connect(&_model, SIGNAL(modelReset()), this, SLOT(update()));
 }
 
+void KsGLWidget::_freeGraphs()
+{
+	for (auto &stream: _graphs) {
+		for (auto &g: stream)
+			delete g;
+		stream.resize(0);
+	}
+}
+
+void KsGLWidget::freePluginShapes()
+{
+	while (!_shapes.empty()) {
+		auto s = _shapes.front();
+		_shapes.pop_front();
+		delete s;
+	}
+}
+
 KsGLWidget::~KsGLWidget()
 {
-	for (auto &g: _graphs)
-		delete g;
+	_freeGraphs();
+	freePluginShapes();
 }
 
 /** Reimplemented function used to set up all required OpenGL resources. */
@@ -51,6 +88,11 @@ void KsGLWidget::initializeGL()
 {
 	_dpr = QApplication::desktop()->devicePixelRatio();
 	ksplot_init_opengl(_dpr);
+
+	ksplot_init_font(&_font, 15, TT_FONT_FILE);
+
+	_labelSize = _getMaxLabelSize() + FONT_WIDTH * 2;
+	update();
 }
 
 /**
@@ -67,7 +109,9 @@ void KsGLWidget::resizeGL(int w, int h)
 	 * From the size of the widget, calculate the number of bins.
 	 * One bin will correspond to one pixel.
 	 */
-	int nBins = width() - _hMargin * 2;
+	int nBins = width() - _bin0Offset() - _hMargin;
+	if (nBins <= 0)
+		return;
 
 	/*
 	 * Reload the data. The range of the histogram is the same
@@ -78,7 +122,7 @@ void KsGLWidget::resizeGL(int w, int h)
 			   _model.histo()->min,
 			   _model.histo()->max);
 
-	_model.fill(_data->rows(), _data->size());
+	_model.fill(_data);
 }
 
 /** Reimplemented function used to plot trace graphs. */
@@ -91,24 +135,23 @@ void KsGLWidget::paintGL()
 	if (isEmpty())
 		return;
 
+	render();
+
 	/* Draw the time axis. */
 	_drawAxisX(size);
 
-	/* Process and draw all graphs by using the built-in logic. */
-	_makeGraphs(_cpuList, _taskList);
-	for (auto const &g: _graphs)
-		g->draw(size);
+	for (auto const &stream: _graphs)
+		for (auto const &g: stream)
+			g->draw(size);
 
-	/* Process and draw all plugin-specific shapes. */
-	_makePluginShapes(_cpuList, _taskList);
-	while (!_shapes.empty()) {
-		auto s = _shapes.front();
-		_shapes.pop_front();
+	for (auto const &s: _shapes) {
+		if (!s)
+			continue;
 
-		s->_size = size;
-		s->draw();
+		if (s->_size < 0)
+			s->_size = size + abs(s->_size + 1);
 
-		delete s;
+		s->draw();
 	}
 
 	/*
@@ -120,22 +163,25 @@ void KsGLWidget::paintGL()
 	_mState->activeMarker().draw();
 }
 
+/** Process and draw all graphs. */
+void KsGLWidget::render()
+{
+	/* Process and draw all graphs by using the built-in logic. */
+	_makeGraphs();
+
+	/* Process and draw all plugin-specific shapes. */
+	_makePluginShapes();
+};
+
 /** Reset (empty) the widget. */
 void KsGLWidget::reset()
 {
-	_cpuList = {};
-	_taskList = {};
+	_streamPlots.clear();
+	_comboPlots.clear();
 	_data = nullptr;
 	_model.reset();
 }
 
-/** Check if the widget is empty (not showing anything). */
-bool KsGLWidget::isEmpty() const {
-	return !_data ||
-	       !_data->size() ||
-	       (!_cpuList.size() && !_taskList.size());
-}
-
 /** Reimplemented event handler used to receive mouse press events. */
 void KsGLWidget::mousePressEvent(QMouseEvent *event)
 {
@@ -146,7 +192,7 @@ void KsGLWidget::mousePressEvent(QMouseEvent *event)
 }
 
 int KsGLWidget::_getLastTask(struct kshark_trace_histo *histo,
-			     int bin, int cpu)
+			     int bin, int sd, int cpu)
 {
 	kshark_context *kshark_ctx(nullptr);
 	kshark_entry_collection *col;
@@ -157,15 +203,17 @@ int KsGLWidget::_getLastTask(struct kshark_trace_histo *histo,
 
 	col = kshark_find_data_collection(kshark_ctx->collections,
 					  KsUtils::matchCPUVisible,
-					  cpu);
+					  sd, &cpu, 1);
 
 	for (int b = bin; b >= 0; --b) {
-		pid = ksmodel_get_pid_back(histo, b, cpu, false, col, nullptr);
+		pid = ksmodel_get_pid_back(histo, b, sd, cpu,
+					   false, col, nullptr);
 		if (pid >= 0)
 			return pid;
 	}
 
 	return ksmodel_get_pid_back(histo, LOWER_OVERFLOW_BIN,
+					   sd,
 					   cpu,
 					   false,
 					   col,
@@ -173,7 +221,7 @@ int KsGLWidget::_getLastTask(struct kshark_trace_histo *histo,
 }
 
 int KsGLWidget::_getLastCPU(struct kshark_trace_histo *histo,
-			     int bin, int pid)
+			    int bin, int sd, int pid)
 {
 	kshark_context *kshark_ctx(nullptr);
 	kshark_entry_collection *col;
@@ -184,15 +232,17 @@ int KsGLWidget::_getLastCPU(struct kshark_trace_histo *histo,
 
 	col = kshark_find_data_collection(kshark_ctx->collections,
 					  kshark_match_pid,
-					  pid);
+					  sd, &pid, 1);
 
 	for (int b = bin; b >= 0; --b) {
-		cpu = ksmodel_get_cpu_back(histo, b, pid, false, col, nullptr);
+		cpu = ksmodel_get_cpu_back(histo, b, sd, pid,
+					   false, col, nullptr);
 		if (cpu >= 0)
 			return cpu;
 	}
 
 	return ksmodel_get_cpu_back(histo, LOWER_OVERFLOW_BIN,
+					   sd,
 					   pid,
 					   false,
 					   col,
@@ -203,7 +253,7 @@ int KsGLWidget::_getLastCPU(struct kshark_trace_histo *histo,
 /** Reimplemented event handler used to receive mouse move events. */
 void KsGLWidget::mouseMoveEvent(QMouseEvent *event)
 {
-	int bin, cpu, pid;
+	int bin, sd, cpu, pid;
 	size_t row;
 	bool ret;
 
@@ -213,23 +263,22 @@ void KsGLWidget::mouseMoveEvent(QMouseEvent *event)
 	if (_rubberBand.isVisible())
 		_rangeBoundStretched(_posInRange(event->pos().x()));
 
-	bin = event->pos().x() - _hMargin;
-	cpu = getPlotCPU(event->pos());
-	pid = getPlotPid(event->pos());
+	bin = event->pos().x() - _bin0Offset();
+	getPlotInfo(event->pos(), &sd, &cpu, &pid);
 
-	ret = _find(bin, cpu, pid, 5, false, &row);
+	ret = _find(bin, sd, cpu, pid, 5, false, &row);
 	if (ret) {
 		emit found(row);
 	} else {
 		if (cpu >= 0) {
-			pid = _getLastTask(_model.histo(), bin, cpu);
+			pid = _getLastTask(_model.histo(), bin, sd, cpu);
 		}
 
 		if (pid > 0) {
-			cpu = _getLastCPU(_model.histo(), bin, pid);
+			cpu = _getLastCPU(_model.histo(), bin, sd, pid);
 		}
 
-		emit notFound(ksmodel_bin_ts(_model.histo(), bin), cpu, pid);
+		emit notFound(ksmodel_bin_ts(_model.histo(), bin), sd, cpu, pid);
 	}
 }
 
@@ -243,11 +292,11 @@ void KsGLWidget::mouseReleaseEvent(QMouseEvent *event)
 		size_t posMouseRel = _posInRange(event->pos().x());
 		int min, max;
 		if (_posMousePress < posMouseRel) {
-			min = _posMousePress - _hMargin;
-			max = posMouseRel - _hMargin;
+			min = _posMousePress - _bin0Offset();
+			max = posMouseRel - _bin0Offset();
 		} else {
-			max = _posMousePress - _hMargin;
-			min = posMouseRel - _hMargin;
+			max = _posMousePress - _bin0Offset();
+			min = posMouseRel - _bin0Offset();
 		}
 
 		_rangeChanged(min, max);
@@ -257,7 +306,21 @@ void KsGLWidget::mouseReleaseEvent(QMouseEvent *event)
 /** Reimplemented event handler used to receive mouse double click events. */
 void KsGLWidget::mouseDoubleClickEvent(QMouseEvent *event)
 {
-	if (event->button() == Qt::LeftButton)
+	KsPlot::PlotObject *pluginClicked(nullptr);
+	double distance, distanceMin = FONT_HEIGHT;
+
+	for (auto const &s: _shapes) {
+		distance = s->distance(event->pos().x(), event->pos().y());
+		if (distance < distanceMin) {
+			distanceMin = distance;
+			pluginClicked = s;
+		}
+	}
+
+	if (pluginClicked)
+		pluginClicked->doubleClick();
+
+	else if (event->button() == Qt::LeftButton)
 		_findAndSelect(event);
 }
 
@@ -266,7 +329,8 @@ void KsGLWidget::wheelEvent(QWheelEvent * event)
 {
 	int zoomFocus;
 
-	if (isEmpty())
+	if (QApplication::keyboardModifiers() != Qt::ControlModifier ||
+	    isEmpty())
 		return;
 
 	if (_mState->activeMarker()._isSet &&
@@ -281,7 +345,7 @@ void KsGLWidget::wheelEvent(QWheelEvent * event)
 		 * Use the position of the mouse as a focus point for the
 		 * zoom.
 		 */
-		zoomFocus = event->pos().x() - _hMargin;
+		zoomFocus = event->pos().x() - _bin0Offset();
 	}
 
 	if (event->delta() > 0) {
@@ -353,40 +417,53 @@ void KsGLWidget::keyReleaseEvent(QKeyEvent *event)
  */
 void KsGLWidget::loadData(KsDataStore *data)
 {
+	kshark_context *kshark_ctx(nullptr);
+	QVector<int> streamIds, plotVec;
 	uint64_t tMin, tMax;
 	int nCPUs, nBins;
 
+	if (!kshark_instance(&kshark_ctx) || !kshark_ctx->n_streams)
+		return;
+
+	loadColors();
+
 	_data = data;
+	_model.reset();
+	_streamPlots.clear();
+
+	/*
+	 * Make default CPU and Task lists. All CPUs from all Data streams will
+	 * be plotted. No tasks will be plotted.
+	 */
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+	for (auto const &sd: streamIds) {
+		nCPUs = kshark_ctx->stream[sd]->n_cpus;
+		plotVec.clear();
+
+		/* If the number of CPUs is too big show only the first 16. */
+		if (nCPUs > KS_MAX_START_PLOTS / kshark_ctx->n_streams)
+			nCPUs = KS_MAX_START_PLOTS / kshark_ctx->n_streams;
+
+		for (int i = 0; i < nCPUs; ++i)
+			plotVec.append(i);
+
+		_streamPlots[sd]._cpuList = plotVec;
+		_streamPlots[sd]._taskList = {};
+	}
 
 	/*
 	 * From the size of the widget, calculate the number of bins.
 	 * One bin will correspond to one pixel.
 	 */
-	nBins = width() - _hMargin * 2;
-
-	_model.reset();
+	nBins = width() - _bin0Offset() - _hMargin;
+	if (nBins < 0)
+		nBins = 0;
 
 	/* Now load the entire set of trace data. */
 	tMin = _data->rows()[0]->ts;
 	tMax = _data->rows()[_data->size() - 1]->ts;
 	ksmodel_set_bining(_model.histo(), nBins, tMin, tMax);
-	_model.fill(_data->rows(), _data->size());
-
-	/* Make a default CPU list. All CPUs (or the first N_max) will be plotted. */
-	_cpuList = {};
-
-	nCPUs = tep_get_cpus(_data->tep());
-	if (nCPUs > KS_MAX_START_PLOTS)
-		nCPUs = KS_MAX_START_PLOTS;
-
-	for (int i = 0; i < nCPUs; ++i)
-		_cpuList.append(i);
-
-	/* Make a default task list. No tasks will be plotted. */
-	_taskList = {};
-
-	loadColors();
-	_makeGraphs(_cpuList, _taskList);
+	_model.fill(_data);
 }
 
 /**
@@ -396,96 +473,78 @@ void KsGLWidget::loadData(KsDataStore *data)
 void KsGLWidget::loadColors()
 {
 	_pidColors.clear();
-	_pidColors = KsPlot::getTaskColorTable();
+	_pidColors = KsPlot::taskColorTable();
 	_cpuColors.clear();
-	_cpuColors = KsPlot::getCPUColorTable();
+	_cpuColors = KsPlot::CPUColorTable();
+	_streamColors.clear();
+	_streamColors = KsPlot::streamColorTable();
 }
 
 /**
  * Position the graphical elements of the marker according to the current
  * position of the graphs inside the GL widget.
  */
-void KsGLWidget::setMark(KsGraphMark *mark)
+void KsGLWidget::setMarkPoints(const KsDataStore &data, KsGraphMark *mark)
 {
-	mark->_mark.setDPR(_dpr);
-	mark->_mark.setX(mark->_bin + _hMargin);
-	mark->_mark.setY(_vMargin / 2 + 2, height() - _vMargin);
-
-	if (mark->_cpu >= 0) {
-		mark->_mark.setCPUY(_graphs[mark->_cpu]->getBase());
-		mark->_mark.setCPUVisible(true);
-	} else {
-		mark->_mark.setCPUVisible(false);
-	}
+	const kshark_entry *e = data.rows()[mark->_pos];
+	int sd = e->stream_id;
 
-	if (mark->_task >= 0) {
-		mark->_mark.setTaskY(_graphs[mark->_task]->getBase());
-		mark->_mark.setTaskVisible(true);
-	} else {
-		mark->_mark.setTaskVisible(false);
-	}
-}
+	mark->_mark.setDPR(_dpr);
+	mark->_mark.setX(mark->_bin + _bin0Offset());
+	mark->_mark.setY(_vMargin * 3 / 2 + 2, height() - _vMargin / 4);
 
-/**
- * @brief Check if a given KernelShark entry is ploted.
- *
- * @param e: Input location for the KernelShark entry.
- * @param graphCPU: Output location for index of the CPU graph to which this
- *		    entry belongs. If such a graph does not exist the outputted
- *		    value is "-1".
- * @param graphTask: Output location for index of the Task graph to which this
- *		     entry belongs. If such a graph does not exist the
- *		     outputted value is "-1".
- */
-void KsGLWidget::findGraphIds(const kshark_entry &e,
-			      int *graphCPU,
-			      int *graphTask)
-{
-	int graph(0);
-	bool cpuFound(false), taskFound(false);
+	mark->_mark.setCPUVisible(false);
+	mark->_mark.setTaskVisible(false);
+	mark->_mark.setComboVisible(false);
 
-	/*
-	 * Loop over all CPU graphs and try to find the one that
-	 * contains the entry.
-	 */
-	for (auto const &c: _cpuList) {
-		if (c == e.cpu) {
-			cpuFound = true;
-			break;
+	for (int i = 0; i < _streamPlots[sd]._cpuList.count(); ++i) {
+		if (_streamPlots[sd]._cpuList[i] == e->cpu) {
+			mark->_mark.setCPUY(_streamPlots[sd]._cpuGraphs[i]->base());
+			mark->_mark.setCPUVisible(true);
 		}
-		++graph;
 	}
 
-	if (cpuFound)
-		*graphCPU = graph;
-	else
-		*graphCPU = -1;
-
-	/*
-	 * Loop over all Task graphs and try to find the one that
-	 * contains the entry.
-	 */
-	graph = _cpuList.count();
-	for (auto const &p: _taskList) {
-		if (p == e.pid) {
-			taskFound = true;
-			break;
+	for (int i = 0; i < _streamPlots[sd]._taskList.count(); ++i) {
+		if (_streamPlots[sd]._taskList[i] == e->pid) {
+			mark->_mark.setTaskY(_streamPlots[sd]._taskGraphs[i]->base());
+			mark->_mark.setTaskVisible(true);
 		}
-		++graph;
 	}
 
-	if (taskFound)
-		*graphTask = graph;
-	else
-		*graphTask = -1;
+	for (auto const &c: _comboPlots)
+		for (auto const &p: c) {
+			if (p._streamId != e->stream_id)
+				continue;
+
+			if (p._type & KSHARK_CPU_DRAW &&
+			    p._id == e->cpu) {
+				mark->_mark.setComboY(p.base());
+				mark->_mark.setComboVisible(true);
+			} else if (p._type & KSHARK_TASK_DRAW &&
+				   p._id == e->pid) {
+				mark->_mark.setComboY(p.base());
+				mark->_mark.setComboVisible(true);
+			}
+		}
 }
 
 void KsGLWidget::_drawAxisX(float size)
 {
-	KsPlot::Point a0(_hMargin, _vMargin / 4), a1(_hMargin, _vMargin / 2);
-	KsPlot::Point b0(width() / 2, _vMargin / 4), b1(width() / 2, _vMargin / 2);
-	KsPlot::Point c0(width() - _hMargin, _vMargin / 4),
-			 c1(width() - _hMargin, _vMargin / 2);
+	int64_t model_min = model()->histo()->min;
+	int64_t model_max = model()->histo()->max;
+	uint64_t sec, usec, tsMid;
+	char *tMin, *tMid, *tMax;
+	int mid = (width() - _bin0Offset() - _hMargin) / 2;
+	int y_1 = _vMargin * 5 / 4;
+	int y_2 = _vMargin * 6 / 4;
+	int count;
+
+	KsPlot::Point a0(_bin0Offset(), y_1);
+	KsPlot::Point a1(_bin0Offset(), y_2);
+	KsPlot::Point b0(_bin0Offset() + mid, y_1);
+	KsPlot::Point b1(_bin0Offset() + mid, y_2);
+	KsPlot::Point c0(width() - _hMargin, y_1);
+	KsPlot::Point c1(width() - _hMargin, y_2);
 
 	a0._size = c0._size = _dpr;
 
@@ -495,109 +554,265 @@ void KsGLWidget::_drawAxisX(float size)
 	KsPlot::drawLine(b0, b1, {}, size);
 	KsPlot::drawLine(c0, c1, {}, size);
 	KsPlot::drawLine(a0, c0, {}, size);
+
+	if (model_min < 0)
+		model_min = 0;
+
+	kshark_convert_nano(model_min, &sec, &usec);
+	count = asprintf(&tMin,"%" PRIu64 ".%06" PRIu64 "", sec, usec);
+	if (count <= 0)
+		return;
+
+	tsMid = (model_min + model_max) / 2;
+	kshark_convert_nano(tsMid, &sec, &usec);
+	count = asprintf(&tMid, "%" PRIu64 ".%06" PRIu64 "", sec, usec);
+	if (count <= 0)
+		return;
+
+	kshark_convert_nano(model_max, &sec, &usec);
+	count = asprintf(&tMax, "%" PRIu64 ".%06" PRIu64 "", sec, usec);
+	if (count <= 0)
+		return;
+
+	ksplot_print_text(&_font, nullptr,
+			  a0.x(),
+			  a0.y() - _hMargin / 2,
+			  tMin);
+
+	ksplot_print_text(&_font, nullptr,
+			  b0.x() - _font.char_width * count / 2,
+			  b0.y() - _hMargin / 2,
+			  tMid);
+
+	ksplot_print_text(&_font, nullptr,
+			  c0.x() - _font.char_width * count,
+			  c0.y() - _hMargin / 2,
+			  tMax);
+
+	free(tMin);
+	free(tMid);
+	free(tMax);
 }
 
-void KsGLWidget::_makeGraphs(QVector<int> cpuList, QVector<int> taskList)
+int KsGLWidget::_getMaxLabelSize()
 {
+	int size, max(0);
+
+	for (auto it = _streamPlots.begin(); it != _streamPlots.end(); ++it) {
+		int sd = it.key();
+		for (auto const &pid: it.value()._taskList) {
+			size = _font.char_width *
+			       KsUtils::taskPlotName(sd, pid).count();
+			max = (size > max) ? size : max;
+		}
+
+		for (auto const &cpu: it.value()._cpuList) {
+			size = _font.char_width * KsUtils::cpuPlotName(cpu).count();
+			max = (size > max) ? size : max;
+		}
+	}
+
+	for (auto &c: _comboPlots)
+		for (auto const &p: c) {
+			if (p._type & KSHARK_TASK_DRAW) {
+				size = _font.char_width *
+					KsUtils::taskPlotName(p._streamId, p._id).count();
+
+				max = (size > max) ? size : max;
+			} else if (p._type & KSHARK_CPU_DRAW) {
+				size = _font.char_width *
+				       KsUtils::cpuPlotName(p._id).count();
+
+				max = (size > max) ? size : max;
+			}
+		}
+
+	return max;
+}
+
+void KsGLWidget::_makeGraphs()
+{
+	int base(_vMargin * 2 + KS_GRAPH_HEIGHT), sd;
+	KsPlot::Graph *g;
+
 	/* The very first thing to do is to clean up. */
-	for (auto &g: _graphs)
-		delete g;
-	_graphs.resize(0);
+	_freeGraphs();
 
 	if (!_data || !_data->size())
 		return;
 
-	auto lamAddGraph = [&](KsPlot::Graph *graph) {
-		/*
-		* Calculate the base level of the CPU graph inside the widget.
-		* Remember that the "Y" coordinate is inverted.
-		*/
+	_labelSize = _getMaxLabelSize() + FONT_WIDTH * 2;
+
+	auto lamAddGraph = [&](int sd, KsPlot::Graph *graph, int vSpace=0) {
 		if (!graph)
-			return;
+			return graph;
 
-		int base = _vMargin +
-			   _vSpacing * _graphs.count() +
-			   KS_GRAPH_HEIGHT * (_graphs.count() + 1);
+		KsPlot::Color color = {255, 255, 255}; // White
+		/*
+		 * Calculate the base level of the CPU graph inside the widget.
+		 * Remember that the "Y" coordinate is inverted.
+		 */
 
 		graph->setBase(base);
-		_graphs.append(graph);
+
+		/*
+		 * If we have multiple Data streams use the color of the stream
+		 * for the label of the graph.
+		 */
+		if (KsUtils::getNStreams() > 1)
+			color = KsPlot::getColor(&_streamColors, sd);
+
+		graph->setLabelAppearance(&_font,
+					  color,
+					  _labelSize,
+					  _hMargin);
+
+		_graphs[sd].append(graph);
+		base += graph->height() + vSpace;
+
+		return graph;
 	};
 
-	/* Create CPU graphs according to the cpuList. */
-	for (auto const &cpu: cpuList)
-		lamAddGraph(_newCPUGraph(cpu));
+	for (auto it = _streamPlots.begin(); it != _streamPlots.end(); ++it) {
+		sd = it.key();
+		/* Create CPU graphs according to the cpuList. */
+		it.value()._cpuGraphs = {};
+		for (auto const &cpu: it.value()._cpuList) {
+			g = lamAddGraph(sd, _newCPUGraph(sd, cpu), _vSpacing);
+			it.value()._cpuGraphs.append(g);
+		}
+
+		/* Create Task graphs according to the taskList. */
+		it.value()._taskGraphs = {};
+		for (auto const &pid: it.value()._taskList) {
+			g = lamAddGraph(sd, _newTaskGraph(sd, pid), _vSpacing);
+			it.value()._taskGraphs.append(g);
+		}
+	}
 
-	/* Create Task graphs taskList to the taskList. */
-	for (auto const &pid: taskList)
-		lamAddGraph(_newTaskGraph(pid));
+	for (auto &c: _comboPlots) {
+		int n = c.count();
+		for (int i = 0; i < n; ++i) {
+			sd = c[i]._streamId;
+			if (c[i]._type & KSHARK_TASK_DRAW) {
+				c[i]._graph = lamAddGraph(sd, _newTaskGraph(sd, c[i]._id));
+			} else if (c[i]._type & KSHARK_CPU_DRAW) {
+				c[i]._graph = lamAddGraph(sd, _newCPUGraph(sd, c[i]._id));
+			} else {
+				c[i]._graph = nullptr;
+			}
+
+			if (c[i]._graph && i < n - 1)
+				c[i]._graph->setDrawBase(false);
+		}
+
+		base += _vSpacing;
+	}
 }
 
-void KsGLWidget::_makePluginShapes(QVector<int> cpuList, QVector<int> taskList)
+void KsGLWidget::_makePluginShapes()
 {
 	kshark_context *kshark_ctx(nullptr);
-	kshark_event_handler *evt_handlers;
+	kshark_draw_handler *draw_handlers;
+	struct kshark_data_stream *stream;
 	KsCppArgV cppArgv;
+	int sd;
 
 	if (!kshark_instance(&kshark_ctx))
 		return;
 
+	/* The very first thing to do is to clean up. */
+	freePluginShapes();
+
 	cppArgv._histo = _model.histo();
 	cppArgv._shapes = &_shapes;
 
-	for (int g = 0; g < cpuList.count(); ++g) {
-		cppArgv._graph = _graphs[g];
-		evt_handlers = kshark_ctx->event_handlers;
-		while (evt_handlers) {
-			evt_handlers->draw_func(cppArgv.toC(),
-						cpuList[g],
-						KSHARK_PLUGIN_CPU_DRAW);
+	for (auto it = _streamPlots.constBegin(); it != _streamPlots.constEnd(); ++it) {
+		sd = it.key();
+		stream = kshark_get_data_stream(kshark_ctx, sd);
+		if (!stream)
+			continue;
+
+		for (int g = 0; g < it.value()._cpuList.count(); ++g) {
+			cppArgv._graph = it.value()._cpuGraphs[g];
+			draw_handlers = stream->draw_handlers;
+			while (draw_handlers) {
+				draw_handlers->draw_func(cppArgv.toC(),
+							sd,
+							it.value()._cpuList[g],
+							KSHARK_CPU_DRAW);
+
+				draw_handlers = draw_handlers->next;
+			}
+		}
 
-			evt_handlers = evt_handlers->next;
+		for (int g = 0; g < it.value()._taskList.count(); ++g) {
+			cppArgv._graph = it.value()._taskGraphs[g];
+			draw_handlers = stream->draw_handlers;
+			while (draw_handlers) {
+				draw_handlers->draw_func(cppArgv.toC(),
+							sd,
+							it.value()._taskList[g],
+							KSHARK_TASK_DRAW);
+
+				draw_handlers = draw_handlers->next;
+			}
 		}
 	}
 
-	for (int g = 0; g < taskList.count(); ++g) {
-		cppArgv._graph = _graphs[cpuList.count() + g];
-		evt_handlers = kshark_ctx->event_handlers;
-		while (evt_handlers) {
-			evt_handlers->draw_func(cppArgv.toC(),
-						taskList[g],
-						KSHARK_PLUGIN_TASK_DRAW);
-
-			evt_handlers = evt_handlers->next;
+	for (auto const &c: _comboPlots) {
+		for (auto const &p: c) {
+			stream = kshark_get_data_stream(kshark_ctx, p._streamId);
+			draw_handlers = stream->draw_handlers;
+			cppArgv._graph = p._graph;
+			while (draw_handlers) {
+				draw_handlers->draw_func(cppArgv.toC(),
+							 p._streamId,
+							 p._id,
+							 p._type);
+
+				draw_handlers = draw_handlers->next;
+			}
 		}
 	}
 }
 
-KsPlot::Graph *KsGLWidget::_newCPUGraph(int cpu)
+KsPlot::Graph *KsGLWidget::_newCPUGraph(int sd, int cpu)
 {
+	QString name;
 	/* The CPU graph needs to know only the colors of the tasks. */
 	KsPlot::Graph *graph = new KsPlot::Graph(_model.histo(),
 						 &_pidColors,
 						 &_pidColors);
-	graph->setZeroSuppressed(true);
 
 	kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
 	kshark_entry_collection *col;
 
 	if (!kshark_instance(&kshark_ctx))
 		return nullptr;
 
-	graph->setHMargin(_hMargin);
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return nullptr;
+
+	graph->setIdleSuppressed(true, stream->idle_pid);
 	graph->setHeight(KS_GRAPH_HEIGHT);
+	graph->setLabelText(KsUtils::cpuPlotName(cpu).toStdString());
 
 	col = kshark_find_data_collection(kshark_ctx->collections,
 					  KsUtils::matchCPUVisible,
-					  cpu);
+					  sd, &cpu, 1);
 
 	graph->setDataCollectionPtr(col);
-	graph->fillCPUGraph(cpu);
+	graph->fillCPUGraph(sd, cpu);
 
 	return graph;
 }
 
-KsPlot::Graph *KsGLWidget::_newTaskGraph(int pid)
+KsPlot::Graph *KsGLWidget::_newTaskGraph(int sd, int pid)
 {
+	QString name;
 	/*
 	 * The Task graph needs to know the colors of the tasks and the colors
 	 * of the CPUs.
@@ -607,15 +822,21 @@ KsPlot::Graph *KsGLWidget::_newTaskGraph(int pid)
 						 &_cpuColors);
 	kshark_context *kshark_ctx(nullptr);
 	kshark_entry_collection *col;
+	kshark_data_stream *stream;
 
 	if (!kshark_instance(&kshark_ctx))
 		return nullptr;
 
-	graph->setHMargin(_hMargin);
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return nullptr;
+
 	graph->setHeight(KS_GRAPH_HEIGHT);
+	graph->setLabelText(KsUtils::taskPlotName(sd, pid).toStdString());
 
 	col = kshark_find_data_collection(kshark_ctx->collections,
-					  kshark_match_pid, pid);
+					  kshark_match_pid, sd, &pid, 1);
+
 	if (!col) {
 		/*
 		 * If a data collection for this task does not exist,
@@ -624,7 +845,8 @@ KsPlot::Graph *KsGLWidget::_newTaskGraph(int pid)
 		col = kshark_register_data_collection(kshark_ctx,
 						      _data->rows(),
 						      _data->size(),
-						      kshark_match_pid, pid,
+						      kshark_match_pid,
+						      sd, &pid, 1,
 						      25);
 	}
 
@@ -647,7 +869,7 @@ KsPlot::Graph *KsGLWidget::_newTaskGraph(int pid)
 	}
 
 	graph->setDataCollectionPtr(col);
-	graph->fillTaskGraph(pid);
+	graph->fillTaskGraph(sd, pid);
 
 	return graph;
 }
@@ -667,18 +889,19 @@ KsPlot::Graph *KsGLWidget::_newTaskGraph(int pid)
 bool KsGLWidget::find(const QPoint &point, int variance, bool joined,
 		      size_t *index)
 {
+	int bin, sd, cpu, pid;
+
 	/*
 	 * Get the bin, pid and cpu numbers.
 	 * Remember that one bin corresponds to one pixel.
 	 */
-	int bin = point.x() - _hMargin;
-	int cpu = getPlotCPU(point);
-	int pid = getPlotPid(point);
+	bin = point.x() - _bin0Offset();
+	getPlotInfo(point, &sd, &cpu, &pid);
 
-	return _find(bin, cpu, pid, variance, joined, index);
+	return _find(bin, sd, cpu, pid, variance, joined, index);
 }
 
-int KsGLWidget::_getNextCPU(int pid, int bin)
+int KsGLWidget::_getNextCPU(int bin, int sd, int pid)
 {
 	kshark_context *kshark_ctx(nullptr);
 	kshark_entry_collection *col;
@@ -689,12 +912,12 @@ int KsGLWidget::_getNextCPU(int pid, int bin)
 
 	col = kshark_find_data_collection(kshark_ctx->collections,
 					  kshark_match_pid,
-					  pid);
+					  sd, &pid, 1);
 	if (!col)
 		return KS_EMPTY_BIN;
 
 	for (int i = bin; i < _model.histo()->n_bins; ++i) {
-		cpu = ksmodel_get_cpu_front(_model.histo(), i, pid,
+		cpu = ksmodel_get_cpu_front(_model.histo(), i, sd, pid,
 					    false, col, nullptr);
 		if (cpu >= 0)
 			return cpu;
@@ -703,7 +926,7 @@ int KsGLWidget::_getNextCPU(int pid, int bin)
 	return KS_EMPTY_BIN;
 }
 
-bool KsGLWidget::_find(int bin, int cpu, int pid,
+bool KsGLWidget::_find(int bin, int sd, int cpu, int pid,
 		       int variance, bool joined, size_t *row)
 {
 	int hSize = _model.histo()->n_bins;
@@ -721,7 +944,7 @@ bool KsGLWidget::_find(int bin, int cpu, int pid,
 	auto lamGetEntryByCPU = [&](int b) {
 		/* Get the first data entry in this bin. */
 		found = ksmodel_first_index_at_cpu(_model.histo(),
-							   b, cpu);
+						   b, sd, cpu);
 		if (found < 0) {
 			/*
 			 * The bin is empty or the entire connect of the bin
@@ -737,7 +960,7 @@ bool KsGLWidget::_find(int bin, int cpu, int pid,
 	auto lamGetEntryByPid = [&](int b) {
 		/* Get the first data entry in this bin. */
 		found = ksmodel_first_index_at_pid(_model.histo(),
-							   b, pid);
+						   b, sd, pid);
 		if (found < 0) {
 			/*
 			 * The bin is empty or the entire connect of the bin
@@ -803,7 +1026,7 @@ bool KsGLWidget::_find(int bin, int cpu, int pid,
 		 * for an entry on the next CPU used by this task.
 		 */
 		if (!ret && joined) {
-			cpu = _getNextCPU(pid, bin);
+			cpu = _getNextCPU(sd, bin, pid);
 			ret = lamFindEntryByCPU(bin);
 		}
 
@@ -901,7 +1124,7 @@ void KsGLWidget::_rangeChanged(int binMin, int binMax)
 
 	/* Recalculate the model and update the markers. */
 	ksmodel_set_bining(_model.histo(), nBins, min, max);
-	_model.fill(_data->rows(), _data->size());
+	_model.fill(_data);
 	_mState->updateMarkers(*_data, this);
 
 	/*
@@ -932,8 +1155,8 @@ void KsGLWidget::_rangeChanged(int binMin, int binMax)
 int KsGLWidget::_posInRange(int x)
 {
 	int posX;
-	if (x < _hMargin)
-		posX = _hMargin;
+	if (x < _bin0Offset())
+		posX = _bin0Offset();
 	else if (x > (width() - _hMargin))
 		posX = width() - _hMargin;
 	else
@@ -942,35 +1165,62 @@ int KsGLWidget::_posInRange(int x)
 	return posX;
 }
 
-/** Get the CPU Id of the Graph plotted at given position. */
-int KsGLWidget::getPlotCPU(const QPoint &point)
+/**
+ * @brief Get information about the graph plotted at given position (under the mouse).
+ *
+ * @param point: The position to be inspected.
+ * @param sd: Output location for the Data stream Identifier of the graph.
+ * @param cpu: Output location for the CPU Id of the graph, or -1 if this is
+ *	       a Task graph.
+ * @param pid: Output location for the Process Id of the graph, or -1 if this is
+ *	       a CPU graph.
+ */
+bool KsGLWidget::getPlotInfo(const QPoint &point, int *sd, int *cpu, int *pid)
 {
-	int cpuId, y = point.y();
+	int base, n;
 
-	if (_cpuList.count() == 0)
-		return -1;
+	*sd = *cpu = *pid = -1;
 
-	cpuId = (y - _vMargin + _vSpacing / 2) / (_vSpacing + KS_GRAPH_HEIGHT);
-	if (cpuId < 0 || cpuId >= _cpuList.count())
-		return -1;
+	for (auto it = _streamPlots.constBegin(); it != _streamPlots.constEnd(); ++it) {
+		n = it.value()._cpuList.count();
+		for (int i = 0; i < n; ++i) {
+			base = it.value()._cpuGraphs[i]->base();
+			if (base - KS_GRAPH_HEIGHT < point.y() &&
+			    point.y() < base) {
+				*sd = it.key();
+				*cpu = it.value()._cpuList[i];
 
-	return _cpuList[cpuId];
-}
+				return true;
+			}
+		}
 
-/** Get the CPU Id of the Graph plotted at given position. */
-int KsGLWidget::getPlotPid(const QPoint &point)
-{
-	int pidId, y = point.y();
+		n = it.value()._taskList.count();
+		for (int i = 0; i < n; ++i) {
+			base = it.value()._taskGraphs[i]->base();
+			if (base - KS_GRAPH_HEIGHT < point.y() &&
+			    point.y() < base) {
+				*sd = it.key();
+				*pid = it.value()._taskList[i];
 
-	if (_taskList.count() == 0)
-		return -1;
+				return true;
+			}
+		}
+	}
 
-	pidId = (y - _vMargin -
-		     _cpuList.count()*(KS_GRAPH_HEIGHT + _vSpacing) +
-		     _vSpacing / 2) / (_vSpacing + KS_GRAPH_HEIGHT);
+	for (auto const &c: _comboPlots) {
+		for (auto const &p: c) {
+			base = p.base();
+			if (base - KS_GRAPH_HEIGHT < point.y() && point.y() < base) {
+				*sd = p._streamId;
+				if (p._type & KSHARK_CPU_DRAW)
+					*cpu = p._id;
+				else if (p._type & KSHARK_TASK_DRAW)
+					*pid = p._id;
 
-	if (pidId < 0 || pidId >= _taskList.count())
-		return -1;
+				return true;
+			}
+		}
+	}
 
-	return _taskList[pidId];
+	return false;
 }
diff --git a/src/KsGLWidget.hpp b/src/KsGLWidget.hpp
index c6fd787..629ae37 100644
--- a/src/KsGLWidget.hpp
+++ b/src/KsGLWidget.hpp
@@ -17,10 +17,51 @@
 
 // KernelShark
 #include "KsUtils.hpp"
+#include "KsWidgetsLib.hpp"
 #include "KsPlotTools.hpp"
 #include "KsModels.hpp"
 #include "KsDualMarker.hpp"
 
+/** Structure describing all graphs to be plotted for a given Data stream. */
+struct KsPerStreamPlots {
+	/** CPUs to be plotted. */
+	QVector<int>			_cpuList;
+
+	/** "Y" coordinates of the bases of all CPU plots for this stream. */
+	QVector<KsPlot::Graph *>	_cpuGraphs;
+
+	/** Tasks to be plotted. */
+	QVector<int>			_taskList;
+
+	/** "Y" coordinates of the bases of all CPU plots for this stream. */
+	QVector<KsPlot::Graph *>	_taskGraphs;
+};
+
+/** Structure describing a plot. */
+struct KsPlotEntry {
+	/** The Data stream identifier of the plot. */
+	int	_streamId;
+
+	/** Plotting action identifier (Task or CPU plot). */
+	int	_type;
+
+	/** Identifier of the plot (can be PID or CPU number). */
+	int	_id;
+
+	/** Graph pointer. */
+	KsPlot::Graph	*_graph;
+
+	/** "Y" coordinates of the bases of the plot. */
+	int base() const {return _graph->base();}
+};
+
+KsPlotEntry &operator <<(KsPlotEntry &plot, QVector<int> &v);
+
+void operator >>(const KsPlotEntry &plot, QVector<int> &v);
+
+/** Vector of KsPlotEntry used to describe a Combo plot. */
+typedef QVector<KsPlotEntry>	KsComboPlot;
+
 /**
  * The KsGLWidget class provides a widget for rendering OpenGL graphics used
  * to plot trace graphs.
@@ -39,9 +80,9 @@ public:
 
 	void paintGL() override;
 
-	void reset();
+	void render();
 
-	bool isEmpty() const;
+	void reset();
 
 	/** Reprocess all graphs. */
 	void update() {resizeGL(width(), height());}
@@ -64,24 +105,6 @@ public:
 
 	void loadColors();
 
-	/**
-	 * Reimplementing the event handler of the focus event, in order to
-	 * avoid the update (redrawing) of the graphs every time when the
-	 * widget grabs the focus of the keyboard. This is done because we do
-	 * not need to redraw, while on the other hand on large data-sets,
-	 * redrawing can take a lot of time.
-	 */
-	void focusInEvent(QFocusEvent* e) override {}
-
-	/**
-	 * Reimplementing the event handler of the focus event, in order to
-	 * avoid the update (redrawing) of the graphs every time when the
-	 * widget releases the focus of the keyboard. This is done because we
-	 * do not need to redraw, while on the other hand on large data-sets,
-	 * redrawing can take a lot of time.
-	 */
-	void focusOutEvent(QFocusEvent* e) override {}
-
 	/**
 	 * Provide the widget with a pointer to the Dual Marker state machine
 	 * object.
@@ -91,19 +114,68 @@ public:
 	/** Get the KsGraphModel object. */
 	KsGraphModel *model() {return &_model;}
 
-	/** Get the number of CPU graphs. */
-	int cpuGraphCount() const {return _cpuList.count();}
+	/** Get the number of CPU graphs for a given Data stream. */
+	int cpuGraphCount(int sd) const
+	{
+		auto it = _streamPlots.find(sd);
+		if (it != _streamPlots.end())
+			return it.value()._cpuList.count();
+		return 0;
+	}
+
+	/** Get the number of Task graphs for a given Data stream. */
+	int taskGraphCount(int sd) const
+	{
+		auto it = _streamPlots.find(sd);
+		if (it != _streamPlots.end())
+			return it.value()._taskList.count();
+		return 0;
+	}
 
-	/** Get the number of Task graphs. */
-	int taskGraphCount() const {return _taskList.count();}
+	/** Get the total number of graphs for a given Data stream. */
+	int graphCount(int sd) const
+	{
+		auto it = _streamPlots.find(sd);
+		if (it != _streamPlots.end())
+			return it.value()._taskList.count() +
+			       it.value()._cpuList.count();
+		return 0;
+	}
 
-	/** Get the total number of graphs. */
-	int graphCount() const {return _cpuList.count() + _taskList.count();}
+	/**
+	 * Get the total number of graphs for all Data stream. The Combo plots
+	 * are not counted.
+	 */
+	int totGraphCount() const
+	{
+		int count(0);
+		for (auto const &s: _streamPlots)
+			count += s._taskList.count() +
+				 s._cpuList.count();
+		return count;
+	}
+
+	/** Get the number of plots in Combos. */
+	int comboGraphCount() const {
+		int count(0);
+		for (auto const &c: _comboPlots)
+			count += c.count();
+		return count;
+	}
+
+	/** Check if the widget is empty (not showing anything). */
+	bool isEmpty() const
+	{
+		return !_data || !_data->size() ||
+		       (!totGraphCount() && !comboGraphCount());
+	}
 
 	/** Get the height of the widget. */
 	int height() const
 	{
-		return graphCount() * (KS_GRAPH_HEIGHT + _vSpacing) +
+		return totGraphCount() * (KS_GRAPH_HEIGHT + _vSpacing) +
+		       comboGraphCount() * KS_GRAPH_HEIGHT +
+		       _comboPlots.count() * _vSpacing +
 		       _vMargin * 2;
 	}
 
@@ -119,24 +191,27 @@ public:
 	/** Get the size of the vertical spaceing between the graphs. */
 	int vSpacing()	const {return _vSpacing;}
 
-	void setMark(KsGraphMark *mark);
-
-	void findGraphIds(const kshark_entry &e,
-			  int *graphCPU,
-			  int *graphTask);
+	void setMarkPoints(const KsDataStore &data, KsGraphMark *mark);
 
 	bool find(const QPoint &point, int variance, bool joined,
 		  size_t *index);
 
-	int getPlotCPU(const QPoint &point);
+	bool getPlotInfo(const QPoint &point, int *sd, int *cpu, int *pid);
 
-	int getPlotPid(const QPoint &point);
+	/** CPUs and Tasks graphs (per data stream) to be plotted. */
+	QMap<int, KsPerStreamPlots>	_streamPlots;
 
-	/** CPUs to be plotted. */
-	QVector<int>	_cpuList;
+	/** Combo graphs to be plotted. */
+	QVector<KsComboPlot>		_comboPlots;
 
-	/** Tasks to be plotted. */
-	QVector<int>	_taskList;
+	/** Set the pointer to the WorkInProgress widget. */
+	void setWipPtr(KsWidgetsLib::KsWorkInProgress *wip)
+	{
+		_workInProgress = wip;
+	}
+
+	/** Free the list of plugin-defined shapes. */
+	void freePluginShapes();
 
 signals:
 	/**
@@ -149,7 +224,7 @@ signals:
 	 * This signal is emitted when the mouse moves but there is no visible
 	 * KernelShark entry under the cursor.
 	 */
-	void notFound(uint64_t ts, int cpu, int pid);
+	void notFound(uint64_t ts, int sd, int cpu, int pid);
 
 	/** This signal is emitted when the Plus key is pressed. */
 	void zoomIn();
@@ -182,7 +257,7 @@ signals:
 	void updateView(size_t pos, bool mark);
 
 private:
-	QVector<KsPlot::Graph*>	_graphs;
+	QMap<int, QVector<KsPlot::Graph *>>	_graphs;
 
 	KsPlot::PlotObjList	_shapes;
 
@@ -190,7 +265,11 @@ private:
 
 	KsPlot::ColorTable	_cpuColors;
 
-	int		_hMargin, _vMargin;
+	KsPlot::ColorTable	_streamColors;
+
+	KsWidgetsLib::KsWorkInProgress	*_workInProgress;
+
+	int	_labelSize, _hMargin, _vMargin;
 
 	unsigned int	_vSpacing;
 
@@ -210,15 +289,21 @@ private:
 
 	int 		_dpr;
 
+	ksplot_font	_font;
+
+	void _freeGraphs();
+
 	void _drawAxisX(float size);
 
-	void _makeGraphs(QVector<int> cpuMask, QVector<int> taskMask);
+	int _getMaxLabelSize();
+
+	void _makeGraphs();
 
-	KsPlot::Graph *_newCPUGraph(int cpu);
+	KsPlot::Graph *_newCPUGraph(int sd, int cpu);
 
-	KsPlot::Graph *_newTaskGraph(int pid);
+	KsPlot::Graph *_newTaskGraph(int sd, int pid);
 
-	void _makePluginShapes(QVector<int> cpuMask, QVector<int> taskMask);
+	void _makePluginShapes();
 
 	int _posInRange(int x);
 
@@ -230,16 +315,20 @@ private:
 
 	bool _findAndSelect(QMouseEvent *event);
 
-	bool _find(int bin, int cpu, int pid,
+	bool _find(int bin, int sd, int cpu, int pid,
 		   int variance, bool joined, size_t *row);
 
-	int _getNextCPU(int pid, int bin);
+	int _getNextCPU(int bin, int sd, int pid);
 
-	int _getLastTask(struct kshark_trace_histo *histo, int bin, int cpu);
+	int _getLastTask(struct kshark_trace_histo *histo,
+			 int bin, int sd, int cpu);
 
-	int _getLastCPU(struct kshark_trace_histo *histo, int bin, int pid);
+	int _getLastCPU(struct kshark_trace_histo *histo,
+			int bin, int sd, int pid);
 
 	void _deselect();
+
+	int _bin0Offset() {return _labelSize + 2 * _hMargin;}
 };
 
 #endif
-- 
2.25.1

