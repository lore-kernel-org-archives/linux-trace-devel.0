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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE86C43462
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 15:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 299C961185
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 15:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240646AbhD2Ppa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 11:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbhD2Pp3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 11:45:29 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4827AC06138B
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Apr 2021 08:44:42 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g14so19433033edy.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Apr 2021 08:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fv/sh+kFBdecmIquebTkd5YiGtr3Jg8hE1D1j1UhGJM=;
        b=SC8ErQku4PQH70jTwmxXtJEclSAc7eRpbFhMuzBzA0fLp0U7FJZBH4ZhzYAwi0ar1Q
         WE4mID9pDjV8USrm5GXaswO2+k4Kt3yEX9sks5xPInCFsu/FzIMazWgXt8MluKbHMS8q
         I2A2PuXjT4K34PymfaENo8DnL7qICESEyd1ykebBi60lfedxlNrSTAw1B7KBrxwugCVH
         KTWz79K2L9UXCamcfEZaMQKGFwCY8x+T+nSzjlE6RosOBmC0j0MBd4w5y9pd2q4i8nEe
         nJ+q3U9HNOGZwY7pVkao+W3T3Lky3sUW7ob+Qzbz/8agkHu14EhNJBpyTyq3IaHUctKp
         /IOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fv/sh+kFBdecmIquebTkd5YiGtr3Jg8hE1D1j1UhGJM=;
        b=BYrk9MWqbeQBc/VxWPClnJvoxfICC9x6vtMAcvIKMkAOQeP/d55w5dsAWNb/s5fkz4
         y+J7QBgpJuSixB9R4ub7OuSz6abbn30RhHoHIeHY6kgg1hRVkc/eXMicAaHM7VnKNBRX
         OJ43uC6Q+6rQvSk0i2UKan3w6+7VjGfiKlqARhmA0znOWAfaeB6DrQKrSg9fsb5sHjZ8
         lcG7SdisNKdqVu+Y0pOvWRJ7ur+6/pj6/C21d3c1WyZmFLheBpxhMcPINPtHwi3qFaE+
         E/+kFbninYtYtGeuHXdTCEGof3ax1Z7IjMGwQANJQXRuexTR/o8kOUCD+rEndmiYRq/l
         k+5A==
X-Gm-Message-State: AOAM533YWYxbnrfM6BTPKur69+yUatMmA+dx8JAV+BMjUH9vOOXLZ1y+
        HaFZxkCjaVn49RZSdYc62Q9ty8oibiw=
X-Google-Smtp-Source: ABdhPJyTVrOcV1OEEKYehj9yvUsVEKNAcqXAqaLkbrwi1NOsfAmKt87ZfzfVgnkl2eDzBph/GpSYig==
X-Received: by 2002:aa7:c952:: with SMTP id h18mr175331edt.269.1619711080264;
        Thu, 29 Apr 2021 08:44:40 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id t15sm2650602edr.55.2021.04.29.08.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 08:44:39 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] kernel-shark: Add LatencyPlot plugin
Date:   Thu, 29 Apr 2021 18:44:21 +0300
Message-Id: <20210429154421.255872-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210429154421.255872-1-y.karadz@gmail.com>
References: <20210429154421.255872-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The plugin allows the user to visualize the latency between two
events under the condition that the values of given data fields
in the two events are identical (for example having the same PID).
The core logic that implements the processing of the data and
the visualization itself is implemented in:

src/plugins/latency_plot.h,
src/plugins/latency_plot.c and
src/plugins/LatencyPlot.cpp

The plugin also registers its own dialog, that allows the user to
select the events (and the matching field) to be visualized. The
widget of the dialog gets implemented in:

src/plugins/LatencyPlotDialog.hpp
src/plugins/LatencyPlotDialog.cpp

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/plugins/CMakeLists.txt        |   5 +
 src/plugins/LatencyPlot.cpp       | 305 ++++++++++++++++++++++++++++++
 src/plugins/LatencyPlotDialog.cpp | 184 ++++++++++++++++++
 src/plugins/LatencyPlotDialog.hpp |  59 ++++++
 src/plugins/latency_plot.c        | 168 ++++++++++++++++
 src/plugins/latency_plot.h        |  62 ++++++
 tests/libkshark-gui-tests.cpp     |   1 +
 7 files changed, 784 insertions(+)
 create mode 100644 src/plugins/LatencyPlot.cpp
 create mode 100644 src/plugins/LatencyPlotDialog.cpp
 create mode 100644 src/plugins/LatencyPlotDialog.hpp
 create mode 100644 src/plugins/latency_plot.c
 create mode 100644 src/plugins/latency_plot.h

diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
index 333f0da..2906dd4 100644
--- a/src/plugins/CMakeLists.txt
+++ b/src/plugins/CMakeLists.txt
@@ -49,6 +49,11 @@ if (Qt5Widgets_FOUND AND TT_FONT_FILE)
                      SOURCE event_field_plot.c EventFieldDialog.cpp EventFieldPlot.cpp)
     list(APPEND PLUGIN_LIST "event_field_plot")
 
+    BUILD_GUI_PLUGIN(NAME latency_plot
+                     MOC LatencyPlotDialog.hpp
+                     SOURCE latency_plot.c LatencyPlot.cpp LatencyPlotDialog.cpp)
+    list(APPEND PLUGIN_LIST "latency_plot")
+
 endif (Qt5Widgets_FOUND AND TT_FONT_FILE)
 
 BUILD_PLUGIN(NAME missed_events
diff --git a/src/plugins/LatencyPlot.cpp b/src/plugins/LatencyPlot.cpp
new file mode 100644
index 0000000..7dd0af0
--- /dev/null
+++ b/src/plugins/LatencyPlot.cpp
@@ -0,0 +1,305 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2020 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    LatencyPlot.cpp
+ *  @brief   Plugin for visualizing the latency between two trace events.
+ */
+
+// C
+#include <math.h>
+
+// C++
+#include <unordered_map>
+#include <iostream>
+
+// KernelShark
+#include "plugins/latency_plot.h"
+#include "KsPlotTools.hpp"
+#include "KsPlugins.hpp"
+
+/** A pair of events defining the latency. */
+typedef std::pair<kshark_entry *, kshark_entry *> LatencyPair;
+
+/** Hash table of latency pairs. */
+typedef std::unordered_multimap<int, LatencyPair> LatencyHashTable;
+
+/** Hash table storing the latency pairs per CPU.*/
+LatencyHashTable latencyCPUMap;
+
+/** Hash table storing the latency pairs per Task.*/
+LatencyHashTable latencyTaskMap;
+
+/**
+ * Macro used to forward the arguments and construct the pair directly into
+ * a hash table without unnecessary copies (or moves).
+ */
+#define LATENCY_EMPLACE(map, key ,eA, eB) \
+	map.emplace(std::piecewise_construct, \
+		    std::forward_as_tuple(key), \
+		    std::forward_as_tuple(eA, eB)); \
+
+using namespace KsPlot;
+
+/*
+ * A second pass over the data is used to populate the hash tables of latency
+ * pairs.
+ */
+static void secondPass(plugin_latency_context *plugin_ctx)
+{
+	kshark_data_field_int64	**dataA = plugin_ctx->data[0]->data;
+	kshark_data_field_int64	**dataB = plugin_ctx->data[1]->data;
+
+	size_t nEvtAs = plugin_ctx->data[0]->size;
+	size_t nEvtBs = plugin_ctx->data[1]->size;
+	int64_t timeA, timeANext, valFieldA;
+	size_t iB(0);
+
+	/*
+	 * The order of the events in the container is the same as in the raw
+	 * data in the file. This means the data is not sorted in time.
+	 */
+	kshark_data_container_sort(plugin_ctx->data[0]);
+	kshark_data_container_sort(plugin_ctx->data[1]);
+
+	latencyCPUMap.clear();
+	latencyTaskMap.clear();
+
+	for (size_t iA = 0; iA < nEvtAs; ++iA) {
+		timeA = dataA[iA]->entry->ts;
+		valFieldA = dataA[iA]->field;
+
+		/*
+		 * Find the time of the next "A event" having the same field
+		 * value.
+		 */
+		timeANext = INT64_MAX;
+		for (size_t i = iA + 1; i <nEvtAs; ++i) {
+			if (dataA[i]->field == valFieldA) {
+				timeANext = dataA[i]->entry->ts;
+				break;
+			}
+		}
+
+		for (size_t i = iB; i < nEvtBs; ++i) {
+			if (dataB[i]->entry->ts < timeA) {
+				/*
+				 * We only care about the "B evenys" that are
+				 * after (in time) the current "A event".
+				 * Skip these "B events", when you search to
+				 * pair the next "A event".
+				 */
+				++iB;
+				continue;
+			}
+
+			if (dataB[i]->entry->ts > timeANext) {
+				/*
+				 * We already bypassed in time the next
+				 * "A event" having the same field value.
+				 */
+				break;
+			}
+
+			if (dataB[i]->field == valFieldA) {
+				int64_t delta = dataB[i]->entry->ts - timeA;
+
+				if (delta > plugin_ctx->max_latency)
+					plugin_ctx->max_latency = delta;
+
+				/*
+				 * Store this pair of events in the hash
+				 * tables. Use the CPU Id as a key.
+				 */
+				LATENCY_EMPLACE(latencyCPUMap,
+						dataB[i]->entry->cpu,
+						dataA[iA]->entry,
+						dataB[i]->entry)
+
+				/*
+				 * Use the PID as a key.
+				 */
+				LATENCY_EMPLACE(latencyTaskMap,
+						dataB[i]->entry->pid,
+						dataA[iA]->entry,
+						dataB[i]->entry)
+				break;
+			}
+		}
+	}
+}
+
+//! @cond Doxygen_Suppress
+
+#define ORANGE {255, 165, 0}
+
+//! @endcond
+
+static void liftBase(Point *point, Graph *graph)
+{
+	point->setY(point->y() - graph->height() * .8);
+};
+
+static Line *baseLine(Graph *graph)
+{
+	Point p0, p1;
+	Line *l;
+
+	p0 = graph->bin(0)._base;
+	liftBase(&p0, graph);
+	p1 = graph->bin(graph->size() - 1)._base;
+	liftBase(&p1, graph);
+
+	l = new Line(p0, p1);
+	l->_color = ORANGE;
+	return l;
+}
+
+/**
+ * This class represents the graphical element visualizing the latency between
+ * two trace events.
+ */
+class LatencyTick : public Line {
+public:
+	/** Constructor. */
+	LatencyTick(const Point &p0, const Point &p1, const LatencyPair &l)
+	: Line(p0, p1), _l(l) {
+		_color = ORANGE;
+	}
+
+	/**
+	 * @brief Distance between the click and the shape. Used to decide if
+	 *	  the double click action must be executed.
+	 *
+	 * @param x: X coordinate of the click.
+	 * @param y: Y coordinate of the click.
+	 *
+	 * @returns If the click is inside the box, the distance is zero.
+	 *	    Otherwise infinity.
+	 */
+	double distance(int x, int y) const override
+	{
+		int dx, dy;
+
+		dx = pointX(0) - x;
+		dy = pointY(0) - y;
+
+		return sqrt(dx *dx + dy * dy);
+	}
+
+private:
+	LatencyTick() = delete;
+
+	LatencyPair _l;
+
+	/** On double click do. */
+	void _doubleClick() const override;
+
+};
+
+void LatencyTick::_doubleClick() const
+{
+	plugin_mark_entry(_l.first, 'A');
+	plugin_mark_entry(_l.second, 'B');
+}
+
+
+static LatencyTick *tick(Graph *graph, int bin, int height, const LatencyPair &l)
+{
+	Point p0, p1;
+
+	p0 = graph->bin(bin)._base;
+	liftBase(&p0, graph);
+	p1 = p0;
+	p1.setY(p1.y() - height);
+
+	return new LatencyTick(p0, p1, l);
+
+}
+
+/**
+ * @brief Plugin's draw function.
+ *
+ * @param argv_c: A C pointer to be converted to KsCppArgV (C++ struct).
+ * @param sd: Data stream identifier.
+ * @param val: Can be CPU Id or Process Id.
+ * @param draw_action: Draw action identifier.
+ */
+__hidden void draw_latency(struct kshark_cpp_argv *argv_c,
+			   int sd, int val, int draw_action)
+{
+	plugin_latency_context *plugin_ctx = __get_context(sd);
+	struct kshark_context *kshark_ctx(nullptr);
+	kshark_data_stream *stream;
+	kshark_trace_histo *histo;
+	LatencyHashTable *hash;
+	KsCppArgV *argvCpp;
+	PlotObjList *shapes;
+	Graph *thisGraph;
+	int graphHeight;
+
+	if (!plugin_ctx)
+		return;
+
+	if (!plugin_ctx->second_pass_done) {
+		/* The second pass is not done yet. */
+		secondPass(plugin_ctx);
+		plugin_ctx->second_pass_done = true;
+	}
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return;
+
+	/* Retrieve the arguments (C++ objects). */
+	argvCpp = KS_ARGV_TO_CPP(argv_c);
+	thisGraph = argvCpp->_graph;
+
+	if (thisGraph->size() == 0)
+		return;
+
+	graphHeight = thisGraph->height();
+	shapes = argvCpp->_shapes;
+	histo = argvCpp->_histo;
+
+	/* Start by drawing the base line of the Latency plot. */
+	shapes->push_front(baseLine(thisGraph));
+
+	auto lamScaledDelta = [=] (kshark_entry *eA, kshark_entry *eB) {
+		double height;
+
+		height = (eB->ts - eA->ts) / (double) plugin_ctx->max_latency;
+		height *= graphHeight * .6;
+		return height + 4;
+	};
+
+	auto lamPlotLat = [=] (auto p) {
+		kshark_entry *eA = p.second.first;
+		kshark_entry *eB = p.second.second;
+		int binB = ksmodel_get_bin(histo, eB);
+
+		if (binB >= 0)
+			shapes->push_front(tick(thisGraph,
+					   binB,
+					   lamScaledDelta(eA, eB),
+					   p.second));
+	};
+
+	/*
+	 * Use the latency hash tables to get all pairs that are relevant for
+	 * this plot.
+	 */
+	if (draw_action & KSHARK_CPU_DRAW)
+		hash = &latencyCPUMap;
+	else if (draw_action & KSHARK_TASK_DRAW)
+		hash = &latencyTaskMap;
+
+	auto range = hash->equal_range(val);
+	std::for_each(range.first, range.second, lamPlotLat);
+}
diff --git a/src/plugins/LatencyPlotDialog.cpp b/src/plugins/LatencyPlotDialog.cpp
new file mode 100644
index 0000000..1fe8c39
--- /dev/null
+++ b/src/plugins/LatencyPlotDialog.cpp
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2020 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    EventFieldDialog.cpp
+ *  @brief   Dialog class used by the LatencyPlot plugin.
+ */
+
+// C++
+#include <iostream>
+#include <vector>
+
+// KernelShark
+#include "KsMainWindow.hpp"
+#include "LatencyPlotDialog.hpp"
+
+/** The name of the menu item used to start the dialog of the plugin. */
+#define DIALOG_NAME "Plot Latency"
+
+/** Create plugin dialog widget. */
+LatencyPlotDialog::LatencyPlotDialog(QWidget *parent)
+: QDialog(parent),
+  _evtALabel("\tEvent A", this),
+  _evtBLabel("\tEvent B", this),
+  _applyButton("Apply", this),
+  _resetButton("Reset", this),
+  _cancelButton("Cancel", this)
+{
+	setWindowTitle(DIALOG_NAME);
+
+	_fieldSelectLayout.addWidget(&_evtALabel, 0, 0);
+	_fieldSelectLayout.addWidget(&_evtBLabel, 0, 1);
+
+	_fieldSelectLayout.addWidget(&_efsWidgetA, 1, 0);
+	_fieldSelectLayout.addWidget(&_efsWidgetB, 1, 1);
+	_topLayout.addLayout(&_fieldSelectLayout);
+
+	_buttonLayout.addWidget(&_applyButton);
+	_applyButton.setAutoDefault(false);
+
+	_buttonLayout.addWidget(&_resetButton);
+	_resetButton.setAutoDefault(false);
+
+	_buttonLayout.addWidget(&_cancelButton);
+	_cancelButton.setAutoDefault(false);
+
+	_buttonLayout.setAlignment(Qt::AlignLeft);
+	_topLayout.addLayout(&_buttonLayout);
+
+	connect(&_applyButton,	&QPushButton::pressed,
+		this,		&LatencyPlotDialog::_apply);
+
+	connect(&_applyButton,	&QPushButton::pressed,
+		this,		&QWidget::close);
+
+	connect(&_resetButton,	&QPushButton::pressed,
+		this,		&LatencyPlotDialog::_reset);
+
+	connect(&_resetButton,	&QPushButton::pressed,
+		this,		&QWidget::close);
+
+	connect(&_cancelButton,	&QPushButton::pressed,
+		this,		&QWidget::close);
+
+	setLayout(&_topLayout);
+}
+
+/** Update the dialog, using the current settings of the plugin. */
+void LatencyPlotDialog::update()
+{
+	_efsWidgetA.setStreamCombo();
+	_efsWidgetB.setStreamCombo();
+}
+
+static LatencyPlotDialog *lp_dialog(nullptr);
+
+/**
+ * Use the Events and Field names selected by the user to update the plugin's
+ * context.
+ */
+__hidden void plugin_set_event_fields(struct plugin_latency_context *plugin_ctx)
+{
+	std::string buff;
+	char *name;
+	int ret;
+
+	plugin_ctx->event_name[0] = plugin_ctx->event_name[1] = NULL;
+
+	buff = lp_dialog->_efsWidgetA.eventName().toStdString();
+	ret = asprintf(&name, "%s", buff.c_str());
+	if (ret > 0)
+		plugin_ctx->event_name[0] = name;
+
+	buff = lp_dialog->_efsWidgetB.eventName().toStdString();
+	ret = asprintf(&name, "%s", buff.c_str());
+	if (ret > 0)
+		plugin_ctx->event_name[1] = name;
+
+	plugin_ctx->field_name[0] = plugin_ctx->field_name[1] = NULL;
+
+	buff = lp_dialog->_efsWidgetA.fieldName().toStdString();
+	ret = asprintf(&name, "%s", buff.c_str());
+	if (ret > 0)
+		plugin_ctx->field_name[0] = name;
+
+	buff = lp_dialog->_efsWidgetB.fieldName().toStdString();
+	ret = asprintf(&name, "%s", buff.c_str());
+	if (ret > 0)
+		plugin_ctx->field_name[1] = name;
+}
+
+/**
+ * @brief Mark an entry in the KernelShark GUI.
+ *
+ * @param e: The entry to be selected ith the marker.
+ * @param mark: The marker to be used (A or B).
+ */
+__hidden void plugin_mark_entry(const struct kshark_entry *e, char mark)
+{
+	DualMarkerState st = DualMarkerState::A;
+	if (mark == 'B')
+		st = DualMarkerState::B;
+
+	lp_dialog->_gui_ptr->markEntry(e, st);
+}
+
+void LatencyPlotDialog::_apply()
+{
+	auto work = KsWidgetsLib::KsDataWork::UpdatePlugins;
+	int sdA = lp_dialog->_efsWidgetA.streamId();
+	int sdB = lp_dialog->_efsWidgetB.streamId();
+
+	/*
+	 * The plugin needs to process the data and this may take time
+	 * on large datasets. Show a "Work In Process" warning.
+	 */
+	_gui_ptr->wipPtr()->show(work);
+	_gui_ptr->registerPluginToStream("latency_plot", {sdA, sdB});
+	_gui_ptr->wipPtr()->hide(work);
+}
+
+void LatencyPlotDialog::_reset()
+{
+	auto work = KsWidgetsLib::KsDataWork::UpdatePlugins;
+	kshark_context *kshark_ctx(nullptr);
+	QVector<int> streamIds;
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	streamIds = KsUtils::getStreamIdList(kshark_ctx);
+
+	/*
+	 * The plugin needs to process the data and this may take time
+	 * on large datasets. Show a "Work In Process" warning.
+	 */
+	_gui_ptr->wipPtr()->show(work);
+	_gui_ptr->unregisterPluginFromStream("latency_plot", streamIds);
+	_gui_ptr->wipPtr()->hide(work);
+}
+
+static void showDialog(KsMainWindow *ks)
+{
+	lp_dialog->update();
+	lp_dialog->show();
+}
+
+/** Add the dialog of the plugin to the KernelShark menus. */
+__hidden void *plugin_latency_add_menu(void *ks_ptr)
+{
+	if (!lp_dialog) {
+		lp_dialog = new LatencyPlotDialog();
+		lp_dialog->_gui_ptr = static_cast<KsMainWindow *>(ks_ptr);
+	}
+
+	QString menu("Tools/");
+	menu += DIALOG_NAME;
+	lp_dialog->_gui_ptr->addPluginMenu(menu, showDialog);
+
+	return lp_dialog;
+}
diff --git a/src/plugins/LatencyPlotDialog.hpp b/src/plugins/LatencyPlotDialog.hpp
new file mode 100644
index 0000000..8451488
--- /dev/null
+++ b/src/plugins/LatencyPlotDialog.hpp
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2020 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    LatencyPlotDialog.hpp
+ *  @brief   Dialog class used by the LatencyPlot plugin.
+ */
+
+#ifndef _KS_EFP_DIALOG_H
+#define _KS_EFP_DIALOG_H
+
+// KernelShark
+#include "plugins/latency_plot.h"
+#include "KsWidgetsLib.hpp"
+
+class KsMainWindow;
+
+/**
+ * The LatencyPlotDialog class provides a widget for selecting Trace event field to
+ * be visualized.
+ */
+
+class LatencyPlotDialog : public QDialog
+{
+	Q_OBJECT
+public:
+	explicit LatencyPlotDialog(QWidget *parent = nullptr);
+
+	void update();
+
+	/** Widget for selecting Treace event A. */
+	KsWidgetsLib::KsEventFieldSelectWidget	_efsWidgetA;
+
+	/** Widget for selecting Treace event B. */
+	KsWidgetsLib::KsEventFieldSelectWidget	_efsWidgetB;
+
+	/** KernelShark GUI (main window) object. */
+	KsMainWindow	*_gui_ptr;
+
+private:
+	QVBoxLayout	_topLayout;
+
+	QGridLayout	_fieldSelectLayout;
+
+	QHBoxLayout	_buttonLayout;
+
+	QLabel		_evtALabel, _evtBLabel;
+
+	QPushButton	_applyButton, _resetButton, _cancelButton;
+
+	void _apply();
+
+	void _reset();
+};
+
+#endif
diff --git a/src/plugins/latency_plot.c b/src/plugins/latency_plot.c
new file mode 100644
index 0000000..09b1eca
--- /dev/null
+++ b/src/plugins/latency_plot.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2020 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    latency_plot.c
+ *  @brief   Plugin for visualizing the latency between two trace events.
+ */
+
+// C
+#ifndef _GNU_SOURCE
+/** Use GNU C Library. */
+#define _GNU_SOURCE
+#endif // _GNU_SOURCE
+
+#include <stdio.h>
+#include <assert.h>
+
+// KernelShark
+#include "plugins/latency_plot.h"
+
+static void latency_free_context(struct plugin_latency_context *plugin_ctx)
+{
+	if (!plugin_ctx)
+		return;
+
+	free(plugin_ctx->event_name[0]);
+	free(plugin_ctx->field_name[0]);
+
+	free(plugin_ctx->event_name[1]);
+	free(plugin_ctx->field_name[1]);
+
+	kshark_free_data_container(plugin_ctx->data[0]);
+	kshark_free_data_container(plugin_ctx->data[1]);
+}
+
+/** A general purpose macro is used to define plugin context. */
+KS_DEFINE_PLUGIN_CONTEXT(struct plugin_latency_context, latency_free_context);
+
+static bool plugin_latency_init_context(struct kshark_data_stream *stream,
+	struct plugin_latency_context *plugin_ctx)
+{
+	plugin_set_event_fields(plugin_ctx);
+
+	plugin_ctx->event_id[0] =
+		kshark_find_event_id(stream, plugin_ctx->event_name[0]);
+
+	if (plugin_ctx->event_id[0] < 0) {
+		fprintf(stderr, "Event %s not found in stream %s:%s\n",
+			plugin_ctx->event_name[0], stream->file, stream->name);
+		return false;
+	}
+
+	plugin_ctx->event_id[1] =
+		kshark_find_event_id(stream, plugin_ctx->event_name[1]);
+	if (plugin_ctx->event_id[1] < 0) {
+		fprintf(stderr, "Event %s not found in stream %s:%s\n",
+			plugin_ctx->event_name[1], stream->file, stream->name);
+		return false;
+	}
+
+	plugin_ctx->second_pass_done = false;
+	plugin_ctx->max_latency = INT64_MIN;
+
+	plugin_ctx->data[0] = kshark_init_data_container();
+	plugin_ctx->data[1] = kshark_init_data_container();
+	if (!plugin_ctx->data[0] || !plugin_ctx->data[1])
+		return false;
+
+	return true;
+}
+
+static void plugin_get_field(struct kshark_data_stream *stream, void *rec,
+			     struct kshark_entry *entry,
+			     char *field_name,
+			     struct kshark_data_container *data)
+{
+	int64_t val;
+
+	kshark_read_record_field_int(stream, rec, field_name, &val);
+	kshark_data_container_append(data, entry, val);
+}
+
+static void plugin_get_field_a(struct kshark_data_stream *stream, void *rec,
+			       struct kshark_entry *entry)
+{
+	struct plugin_latency_context *plugin_ctx;
+
+	plugin_ctx = __get_context(stream->stream_id);
+	if (!plugin_ctx)
+		return;
+
+	plugin_get_field(stream, rec, entry,
+			 plugin_ctx->field_name[0],
+			 plugin_ctx->data[0]);
+}
+
+static void plugin_get_field_b(struct kshark_data_stream *stream, void *rec,
+			       struct kshark_entry *entry)
+{
+	struct plugin_latency_context *plugin_ctx;
+
+	plugin_ctx = __get_context(stream->stream_id);
+	if (!plugin_ctx)
+		return;
+
+	plugin_get_field(stream, rec, entry,
+			 plugin_ctx->field_name[1],
+			 plugin_ctx->data[1]);
+}
+
+/** Load this plugin. */
+int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
+{
+	struct plugin_latency_context *plugin_ctx = __init(stream->stream_id);
+
+	if (!plugin_ctx || !plugin_latency_init_context(stream, plugin_ctx)) {
+		__close(stream->stream_id);
+		return 0;
+	}
+
+	/* Register Event handler to be executed during data loading. */
+	kshark_register_event_handler(stream,
+				      plugin_ctx->event_id[0],
+				      plugin_get_field_a);
+
+	kshark_register_event_handler(stream,
+				      plugin_ctx->event_id[1],
+				      plugin_get_field_b);
+
+	/* Register a drawing handler to plot on top of each Graph. */
+	kshark_register_draw_handler(stream, draw_latency);
+
+	return 1;
+}
+
+/** Unload this plugin. */
+int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
+{
+	struct plugin_latency_context *plugin_ctx = __get_context(stream->stream_id);
+	int ret = 0;
+
+	if (plugin_ctx) {
+		kshark_unregister_event_handler(stream,
+						plugin_ctx->event_id[0],
+						plugin_get_field_a);
+
+		kshark_unregister_event_handler(stream,
+						plugin_ctx->event_id[1],
+						plugin_get_field_b);
+
+		kshark_unregister_draw_handler(stream, draw_latency);
+
+		ret = 1;
+	}
+
+	__close(stream->stream_id);
+
+	return ret;
+}
+
+/** Initialize the control interface of the plugin. */
+void *KSHARK_MENU_PLUGIN_INITIALIZER(void *gui_ptr)
+{
+	return plugin_latency_add_menu(gui_ptr);
+}
diff --git a/src/plugins/latency_plot.h b/src/plugins/latency_plot.h
new file mode 100644
index 0000000..16d78ad
--- /dev/null
+++ b/src/plugins/latency_plot.h
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2020 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    latency_plot.h
+ *  @brief   Plugin for visualizing the latency between two trace events.
+ */
+
+#ifndef _KS_PLUGIN_LATENCY_PLOT_H
+#define _KS_PLUGIN_LATENCY_PLOT_H
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plugin.h"
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/** Structure representing a plugin-specific context. */
+struct plugin_latency_context {
+	/** Trace event names. */
+	char		*event_name[2];
+
+	/** Trace event identifiers. */
+	int		event_id[2];
+
+	/** Event field names. */
+	char		*field_name[2];
+
+	/** True if the second pass is already done. */
+	bool		second_pass_done;
+
+	/**
+	 * The maximum value of the latency between events A and B in this
+	 * data sample.
+	 */
+	int64_t		max_latency;
+
+	/** Container objects to store the trace event field's data. */
+	struct kshark_data_container	*data[2];
+};
+
+KS_DECLARE_PLUGIN_CONTEXT_METHODS(struct plugin_latency_context)
+
+void draw_latency(struct kshark_cpp_argv *argv_c,
+		  int sd, int pid, int draw_action);
+
+void *plugin_latency_add_menu(void *gui_ptr);
+
+void plugin_set_event_fields(struct plugin_latency_context *plugin_ctx);
+
+void plugin_mark_entry(const struct kshark_entry *e, char mark);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/tests/libkshark-gui-tests.cpp b/tests/libkshark-gui-tests.cpp
index a023c39..f96b3dd 100644
--- a/tests/libkshark-gui-tests.cpp
+++ b/tests/libkshark-gui-tests.cpp
@@ -148,6 +148,7 @@ BOOST_AUTO_TEST_CASE(KsUtils_getPluginList)
 {
 	QStringList plugins{"sched_events",
 			    "event_field_plot",
+			    "latency_plot",
 			    "missed_events"
 	};
 
-- 
2.27.0

