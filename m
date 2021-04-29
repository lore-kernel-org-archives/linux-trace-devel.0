Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED65C43461
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 15:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B20761418
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 15:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbhD2Pp3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 11:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbhD2Pp2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 11:45:28 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800E2C06138C
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Apr 2021 08:44:41 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id w3so100619660ejc.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Apr 2021 08:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f3Bc7iDzzJtB+MFlpwH3dri4wnjWg1dYwLwraXmiMOk=;
        b=ALaIIg5A30koJ2EA2CGEI6S1vt3j4wNVcnf63X96MbZVCCmsB1ahx1lqNAOtrvwjt+
         IDpm4sppHuZFFkqAAmDWfG43Y5wjz+6RcwHk2VJgdXqQEmLE6N8Mrj/6ikBt3f/1Uhq3
         1H46rnxixVdL/CJUPEKMsgOSBEPSIj0cb2gZ6nqUriXLMB87QqHczoMvxS3VUAC1O8Py
         QPQhEMclNEfpX/FlMALpdex0HLVI9CcWgT1LtsxrFl5dpcezCBh9dC/doJgRdyljgB11
         hRTilPn3ozZdomXUanOzS+Q1XpiXExHmxt6RCHRz1C7tv1ZrXZns4Se3sdtOwfl6FLHx
         GNYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f3Bc7iDzzJtB+MFlpwH3dri4wnjWg1dYwLwraXmiMOk=;
        b=VEpBeI5Da43lSFc9IzrNUL6qT5RkG1516kfSdBXsEhBGklllmrcme0gpr+YYeTyDUx
         Eq57pydjkdfV2WloXQy+oJGa1v/8171dpxilRKdDkECN2ignIqawH9/i7CpYG26Xp6z6
         XLe3/Q7mJD9z1TaVtWcwisJX3b+C0IR/7r8EufHnmjccQik4HIZ8uwDg6PrXesSLuMUQ
         3OvsGrv6OBsZbaGKpVgVdwy+L5v/5bTHdn7dbOT31alPanIl58/TUjfgsDZntoDpqeUt
         F6SbcCzIN+aaSBzLKx4ycLFXiIY96JQ0dLtTlMNOGKOYEJRx6oyRGLrLhtrUO/tGVQDB
         ISEA==
X-Gm-Message-State: AOAM5303m1Fl2CAB5Xwa/Uwutjk7cTIWBfSir261WnFdv1XjwlXwcsJr
        bPYSSYXloC0aS52j9jLebj5IfzI9tSI=
X-Google-Smtp-Source: ABdhPJw2f4ILV6alTNKJ8OxJzU6YLlbIsqQEe/LGt/FQG+SLYsts8DPpzFwmyKIKKA+Pxw7XvoH8TQ==
X-Received: by 2002:a17:906:5052:: with SMTP id e18mr541739ejk.112.1619711079574;
        Thu, 29 Apr 2021 08:44:39 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id t15sm2650602edr.55.2021.04.29.08.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 08:44:39 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] kernel-shark: Add EventFieldPlot plugin
Date:   Thu, 29 Apr 2021 18:44:20 +0300
Message-Id: <20210429154421.255872-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210429154421.255872-1-y.karadz@gmail.com>
References: <20210429154421.255872-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The plugin allows the user to visualize the recorded value of a given
data field from a given trace event. The core logic that implements
the processing of the data and the visualization itself is rather
simple. It is implemented in:
event_field_plot.h,
event_field_plot.c and
EventFieldPlot.cpp

The plugin also registers its own dialog, that allows the user to
select the event and field to be visualized. The widget of the dialog
gets implemented in:
EventFieldDialog.hpp and
EventFieldDialog.cpp

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/plugins/CMakeLists.txt       |   5 +
 src/plugins/EventFieldDialog.cpp | 183 +++++++++++++++++++++++++++++++
 src/plugins/EventFieldDialog.hpp |  60 ++++++++++
 src/plugins/EventFieldPlot.cpp   | 109 ++++++++++++++++++
 src/plugins/event_field_plot.c   | 125 +++++++++++++++++++++
 src/plugins/event_field_plot.h   |  64 +++++++++++
 tests/libkshark-gui-tests.cpp    |   1 +
 7 files changed, 547 insertions(+)
 create mode 100644 src/plugins/EventFieldDialog.cpp
 create mode 100644 src/plugins/EventFieldDialog.hpp
 create mode 100644 src/plugins/EventFieldPlot.cpp
 create mode 100644 src/plugins/event_field_plot.c
 create mode 100644 src/plugins/event_field_plot.h

diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
index 5e28368..333f0da 100644
--- a/src/plugins/CMakeLists.txt
+++ b/src/plugins/CMakeLists.txt
@@ -44,6 +44,11 @@ if (Qt5Widgets_FOUND AND TT_FONT_FILE)
                      SOURCE sched_events.c SchedEvents.cpp)
     list(APPEND PLUGIN_LIST "sched_events")
 
+    BUILD_GUI_PLUGIN(NAME event_field_plot
+                     MOC EventFieldDialog.hpp
+                     SOURCE event_field_plot.c EventFieldDialog.cpp EventFieldPlot.cpp)
+    list(APPEND PLUGIN_LIST "event_field_plot")
+
 endif (Qt5Widgets_FOUND AND TT_FONT_FILE)
 
 BUILD_PLUGIN(NAME missed_events
diff --git a/src/plugins/EventFieldDialog.cpp b/src/plugins/EventFieldDialog.cpp
new file mode 100644
index 0000000..fbfe4cc
--- /dev/null
+++ b/src/plugins/EventFieldDialog.cpp
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2020 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    EventFieldDialog.cpp
+ *  @brief   Dialog class used by the EventFieldPlot plugin.
+ */
+
+// C++
+#include <iostream>
+#include <vector>
+
+// KernelShark
+#include "KsMainWindow.hpp"
+#include "EventFieldDialog.hpp"
+
+/** The name of the menu item used to start the dialog of the plugin. */
+#define DIALOG_NAME "Plot Event Field"
+
+/** Create plugin dialog widget. */
+KsEFPDialog::KsEFPDialog(QWidget *parent)
+: QDialog(parent),
+  _selectLabel("Show", this),
+  _applyButton("Apply", this),
+  _resetButton("Reset", this),
+  _cancelButton("Cancel", this)
+{
+	setWindowTitle(DIALOG_NAME);
+
+	_topLayout.addWidget(&_efsWidget);
+
+	_topLayout.addWidget(&_selectLabel);
+	_setSelectCombo();
+	_topLayout.addWidget(&_selectComboBox);
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
+		this,		&KsEFPDialog::_apply);
+
+	connect(&_applyButton,	&QPushButton::pressed,
+		this,		&QWidget::close);
+
+	connect(&_resetButton,	&QPushButton::pressed,
+		this,		&KsEFPDialog::_reset);
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
+void KsEFPDialog::_setSelectCombo()
+{
+	_selectComboBox.clear();
+	_selectComboBox.addItem("max. value", 0);
+	_selectComboBox.addItem("min. value", 1);
+}
+
+/** Select the plotting criteria. */
+void KsEFPDialog::selectCondition(plugin_efp_context *plugin_ctx)
+{
+	/* In the combo box "max" is 0 and "min" is 1. */
+	plugin_ctx->show_max = !_selectComboBox.currentData().toInt();
+}
+
+/** Update the dialog, using the current settings of the plugin. */
+void KsEFPDialog::update()
+{
+	_efsWidget.setStreamCombo();
+}
+
+static KsEFPDialog *efp_dialog(nullptr);
+
+static int plugin_get_stream_id()
+{
+	return efp_dialog->_efsWidget.streamId();
+}
+
+/** Use the Event name selected by the user to update the plugin's context. */
+__hidden void plugin_set_event_name(plugin_efp_context *plugin_ctx)
+{
+	QString buff = efp_dialog->_efsWidget.eventName();
+	char *event;
+
+	if (asprintf(&event, "%s", buff.toStdString().c_str()) >= 0) {
+		plugin_ctx->event_name = event;
+		return;
+	}
+
+	plugin_ctx->event_name = NULL;
+}
+
+/** Use the Field name selected by the user to update the plugin's context. */
+__hidden void plugin_set_field_name(plugin_efp_context *plugin_ctx)
+{
+	QString buff = efp_dialog->_efsWidget.fieldName();
+	char *field;
+
+	if (asprintf(&field, "%s", buff.toStdString().c_str()) >= 0) {
+		plugin_ctx->field_name = field;
+		return;
+	}
+
+	plugin_ctx->field_name = NULL;
+}
+
+/** Use the condition selected by the user to update the plugin's context. */
+__hidden void plugin_set_select_condition(plugin_efp_context *plugin_ctx)
+{
+	efp_dialog->selectCondition(plugin_ctx);
+}
+
+void KsEFPDialog::_apply()
+{
+	auto work = KsWidgetsLib::KsDataWork::UpdatePlugins;
+
+	/* The plugin needs to process the data and this may take time
+	 * on large datasets. Show a "Work In Process" warning.
+	 */
+	_gui_ptr->wipPtr()->show(work);
+	_gui_ptr->registerPluginToStream("event_field_plot",
+					 {plugin_get_stream_id()});
+	_gui_ptr->wipPtr()->hide(work);
+}
+
+void KsEFPDialog::_reset()
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
+	_gui_ptr->unregisterPluginFromStream("event_field_plot",
+					     streamIds);
+	_gui_ptr->wipPtr()->hide(work);
+}
+
+static void showDialog(KsMainWindow *ks)
+{
+	efp_dialog->update();
+	efp_dialog->show();
+}
+
+/** Add the dialog of the plugin to the KernelShark menus. */
+__hidden void *plugin_efp_add_menu(void *ks_ptr)
+{
+	if (!efp_dialog) {
+		efp_dialog = new KsEFPDialog();
+		efp_dialog->_gui_ptr = static_cast<KsMainWindow *>(ks_ptr);
+	}
+
+	QString menu("Tools/");
+	menu += DIALOG_NAME;
+	efp_dialog->_gui_ptr->addPluginMenu(menu, showDialog);
+
+	return efp_dialog;
+}
diff --git a/src/plugins/EventFieldDialog.hpp b/src/plugins/EventFieldDialog.hpp
new file mode 100644
index 0000000..46339b2
--- /dev/null
+++ b/src/plugins/EventFieldDialog.hpp
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2020 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    EventFieldDialog.hpp
+ *  @brief   Dialog class used by the EventFieldPlot plugin.
+ */
+
+#ifndef _KS_EFP_DIALOG_H
+#define _KS_EFP_DIALOG_H
+
+// KernelShark
+#include "plugins/event_field_plot.h"
+#include "KsWidgetsLib.hpp"
+
+class KsMainWindow;
+
+/**
+ * The KsEFPDialog class provides a widget for selecting Trace event field to
+ * be visualized.
+ */
+
+class KsEFPDialog : public QDialog
+{
+	Q_OBJECT
+public:
+	explicit KsEFPDialog(QWidget *parent = nullptr);
+
+	void update();
+
+	void selectCondition(plugin_efp_context *plugin_ctx);
+
+	/** Widget for selecting Treace event. */
+	KsWidgetsLib::KsEventFieldSelectWidget	_efsWidget;
+
+	/** KernelShark GUI (main window) object. */
+	KsMainWindow	*_gui_ptr;
+
+private:
+	QVBoxLayout	_topLayout;
+
+	QHBoxLayout	_buttonLayout;
+
+	QComboBox	_selectComboBox;
+
+	QLabel		_selectLabel;
+
+	QPushButton	_applyButton, _resetButton, _cancelButton;
+
+	void _setSelectCombo();
+
+	void _apply();
+
+	void _reset();
+};
+
+#endif
diff --git a/src/plugins/EventFieldPlot.cpp b/src/plugins/EventFieldPlot.cpp
new file mode 100644
index 0000000..1938d62
--- /dev/null
+++ b/src/plugins/EventFieldPlot.cpp
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2020 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    EventFieldPlot.cpp
+ *  @brief   Plugin for visualizing a given data field of a trace event.
+ */
+
+// C++
+#include <vector>
+
+// KernelShark
+#include "plugins/event_field_plot.h"
+#include "KsPlotTools.hpp"
+#include "KsPlugins.hpp"
+
+using namespace KsPlot;
+
+/**
+ * @brief Plugin's draw function.
+ *
+ * @param argv_c: A C pointer to be converted to KsCppArgV (C++ struct).
+ * @param sd: Data stream identifier.
+ * @param val: Can be CPU Id or Process Id.
+ * @param draw_action: Draw action identifier.
+ */
+__hidden void draw_event_field(kshark_cpp_argv *argv_c,
+			       int sd, int val, int draw_action)
+{
+	KsCppArgV *argvCpp = KS_ARGV_TO_CPP(argv_c);
+	Graph *graph = argvCpp->_graph;
+	plugin_efp_context *plugin_ctx;
+	IsApplicableFunc checkEntry;
+	int binSize(0), s0, s1;
+	int64_t norm;
+
+	if (!(draw_action & KSHARK_CPU_DRAW) &&
+	    !(draw_action & KSHARK_TASK_DRAW))
+		return;
+
+	plugin_ctx = __get_context(sd);
+	if (!plugin_ctx)
+		return;
+
+	/* Get the size of the graph's bins. */
+	for (int i = 0; i < graph->size(); ++i)
+		if (graph->bin(i).mod()) {
+			binSize = graph->bin(i)._size;
+			break;
+		}
+
+	s0 = graph->height() / 3;
+	s1 = graph->height() / 5;
+
+	norm = plugin_ctx->field_max - plugin_ctx->field_min;
+	/* Avoid division by zero. */
+	if (norm == 0)
+		++norm;
+
+	auto lamMakeShape = [=] (std::vector<const Graph *> graph,
+				 std::vector<int> bin,
+				 std::vector<kshark_data_field_int64 *> data,
+				 Color, float) {
+		int x, y, mod(binSize);
+		Color c;
+
+		x = graph[0]->bin(bin[0])._val.x();
+		y = graph[0]->bin(bin[0])._val.y() - s0;
+
+		if (plugin_ctx->show_max)
+			mod += s1 * (data[0]->field - plugin_ctx->field_min) / norm;
+		else
+			mod += s1 * (plugin_ctx->field_max - data[0]->field) / norm;
+
+		Point p0(x, y + mod), p1(x, y - mod);
+		Line *l = new Line(p0, p1);
+		c.setRainbowColor(mod - 1);
+		l->_size = binSize + 1;
+		l->_color = c;
+
+		return l;
+	};
+
+	if (draw_action & KSHARK_CPU_DRAW)
+		checkEntry = [=] (kshark_data_container *d, ssize_t i) {
+			return d->data[i]->entry->cpu == val;
+		};
+
+	else if (draw_action & KSHARK_TASK_DRAW)
+		checkEntry = [=] (kshark_data_container *d, ssize_t i) {
+			return d->data[i]->entry->pid == val;
+		};
+
+	if (plugin_ctx->show_max)
+		eventFieldPlotMax(argvCpp,
+				  plugin_ctx->data, checkEntry,
+				  lamMakeShape,
+				  {}, // Undefined color
+				  0); // Undefined size
+	else
+		eventFieldPlotMin(argvCpp,
+				  plugin_ctx->data, checkEntry,
+				  lamMakeShape,
+				  {}, // Undefined color
+				  0); // Undefined size
+}
diff --git a/src/plugins/event_field_plot.c b/src/plugins/event_field_plot.c
new file mode 100644
index 0000000..08b453f
--- /dev/null
+++ b/src/plugins/event_field_plot.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2020 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    event_field_plot.c
+ *  @brief   Plugin for visualizing a given data field of a trace event.
+ */
+
+// C
+#include <stdio.h>
+#include <assert.h>
+#include <limits.h>
+
+// KernelShark
+#include "plugins/event_field_plot.h"
+
+static void efp_free_context(struct plugin_efp_context *plugin_ctx)
+{
+	if (!plugin_ctx)
+		return;
+
+	free(plugin_ctx->event_name);
+	free(plugin_ctx->field_name);
+	kshark_free_data_container(plugin_ctx->data);
+}
+
+/** A general purpose macro is used to define plugin context. */
+KS_DEFINE_PLUGIN_CONTEXT(struct plugin_efp_context, efp_free_context);
+
+static bool plugin_efp_init_context(struct kshark_data_stream *stream,
+				    struct plugin_efp_context *plugin_ctx)
+{
+	plugin_set_event_name(plugin_ctx);
+	plugin_set_field_name(plugin_ctx);
+	plugin_set_select_condition(plugin_ctx);
+
+	plugin_ctx->field_max = INT64_MIN;
+	plugin_ctx->field_min = INT64_MAX;
+
+	plugin_ctx->event_id =
+		kshark_find_event_id(stream, plugin_ctx->event_name);
+
+	if (plugin_ctx->event_id < 0) {
+		fprintf(stderr, "Event %s not found in stream %s:%s\n",
+			plugin_ctx->event_name, stream->file, stream->name);
+		return false;
+	}
+
+	plugin_ctx->data = kshark_init_data_container();
+	if (!plugin_ctx->data)
+		return false;
+
+	return true;
+}
+
+static void plugin_get_field(struct kshark_data_stream *stream, void *rec,
+			     struct kshark_entry *entry)
+{
+	struct plugin_efp_context *plugin_ctx;
+	int64_t val;
+
+	plugin_ctx = __get_context(stream->stream_id);
+	if (!plugin_ctx)
+		return;
+
+	kshark_read_record_field_int(stream, rec,
+				     plugin_ctx->field_name,
+				     &val);
+
+	kshark_data_container_append(plugin_ctx->data, entry, val);
+
+	if (val > plugin_ctx->field_max)
+		plugin_ctx->field_max = val;
+
+	if (val < plugin_ctx->field_min)
+		plugin_ctx->field_min = val;
+}
+
+/** Load this plugin. */
+int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
+{
+	struct plugin_efp_context *plugin_ctx = __init(stream->stream_id);
+
+	if (!plugin_ctx || !plugin_efp_init_context(stream, plugin_ctx)) {
+		__close(stream->stream_id);
+		return 0;
+	}
+
+	kshark_register_event_handler(stream,
+				      plugin_ctx->event_id,
+				      plugin_get_field);
+
+	kshark_register_draw_handler(stream, draw_event_field);
+
+	return 1;
+}
+
+/** Unload this plugin. */
+int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
+{
+	struct plugin_efp_context *plugin_ctx = __get_context(stream->stream_id);
+	int ret = 0;
+
+	if (plugin_ctx) {
+		kshark_unregister_event_handler(stream,
+						plugin_ctx->event_id,
+						plugin_get_field);
+
+		kshark_unregister_draw_handler(stream, draw_event_field);
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
+	return plugin_efp_add_menu(gui_ptr);
+}
diff --git a/src/plugins/event_field_plot.h b/src/plugins/event_field_plot.h
new file mode 100644
index 0000000..43bbac2
--- /dev/null
+++ b/src/plugins/event_field_plot.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2020 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    event_field_plot.h
+ *  @brief   Plugin for visualizing a given data field of a trace event.
+ */
+
+#ifndef _KS_PLUGIN_EVENT_FIELD_H
+#define _KS_PLUGIN_EVENT_FIELD_H
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
+struct plugin_efp_context {
+	/** Trace event name. */
+	char 		*event_name;
+
+	/** Event field name. */
+	char 		*field_name;
+
+	/** The max value of the field in the data. */
+	int64_t		field_max;
+
+	/** The min value of the field in the data. */
+	int64_t		field_min;
+
+	/** Trace event identifier. */
+	int		event_id;
+
+	/** If true, highlight the max field value. Else highlight the min. */
+	bool		show_max;
+
+	/** Container object to store the trace event field's data. */
+	struct kshark_data_container	*data;
+};
+
+KS_DECLARE_PLUGIN_CONTEXT_METHODS(struct plugin_efp_context)
+
+void draw_event_field(struct kshark_cpp_argv *argv_c,
+		      int sd, int pid, int draw_action);
+
+void *plugin_efp_add_menu(void *gui_ptr);
+
+void plugin_set_event_name(struct plugin_efp_context *plugin_ctx);
+
+void plugin_set_field_name(struct plugin_efp_context *plugin_ctx);
+
+void plugin_set_select_condition(struct plugin_efp_context *plugin_ctx);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/tests/libkshark-gui-tests.cpp b/tests/libkshark-gui-tests.cpp
index bc49194..a023c39 100644
--- a/tests/libkshark-gui-tests.cpp
+++ b/tests/libkshark-gui-tests.cpp
@@ -147,6 +147,7 @@ BOOST_AUTO_TEST_CASE(KsUtils_KsDataStore)
 BOOST_AUTO_TEST_CASE(KsUtils_getPluginList)
 {
 	QStringList plugins{"sched_events",
+			    "event_field_plot",
 			    "missed_events"
 	};
 
-- 
2.27.0

