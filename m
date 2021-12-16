Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C821EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 02:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhLPCfd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 21:35:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:38024 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230037AbhLPCfd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 21:35:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639622133; x=1671158133;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=ENMh6Zq7vMe6WW/6oL0DdCYzxs/Q6o5+VF1Ry1uhqmI=;
  b=RImkW5cSySQsP/GblpW3qffeyWhxdPKk2MJFyTZPjMi6VzqNIdlSLKO1
   j4eMFqmik37bUsRCM05lUKsV9SY7vJquMAtXgNcUsFBFbmpDxpHBl696i
   Ihig6mjmwbvV1dkbgkYjstirCtBUJs8MAkNTCf3QhUzJO9yO0gQdNloyL
   ykpGXM1kiqRasPzsWDHtD7TwqSY0sWb+oEDT0/iJbXHBSmXzDJ5vpN/Us
   4+U0NONwQnTz2Uq4QhToRotpUb+P/bs0TFEf8pacrLNpuenaaTWdNoKm9
   iPU6NpZLt1zK51+EpypBg83UKuin/qNNCyhKeSRDNwYeKaxU5VmelSdcI
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="226668743"
X-IronPort-AV: E=Sophos;i="5.88,210,1635231600"; 
   d="scan'208";a="226668743"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 18:35:32 -0800
X-IronPort-AV: E=Sophos;i="5.88,210,1635231600"; 
   d="scan'208";a="662188849"
Received: from intel-z97x-ud5h.sh.intel.com ([10.67.103.201])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 18:35:31 -0800
From:   Hongzhan Chen <hongzhan.chen@intel.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     jan.kiszka@siemens.com
Subject: [RFC PATCH 1/1] kernel-shark: Add plugin for handling Xenomai cobalt_context_switch
Date:   Wed, 15 Dec 2021 21:16:49 -0500
Message-Id: <20211216021649.7273-2-hongzhan.chen@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211216021649.7273-1-hongzhan.chen@intel.com>
References: <20211216021649.7273-1-hongzhan.chen@intel.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

For Xenomai-cobalt enabled system, cobalt_switch_context means
that there is context switch in companion core(realtime core),
which we may need to do special treatment and take correct action
as main kernel sched_switch to visualize out-of-band state of
realtime tasks running in cobalt core. To achive our target,
we implement following:

  1. store corresponding cobalt_switch_context events into
     container data.
  2. modify pid stored in entry to be equal to next_pid to
     show correct color in cpu bar when cobalt_switch_context
     event happen.
  3. show blue hollow box to mark out-of-band state underneath
     the baseline of task plots according to cobalt_switch_context
     events.
  4. clickable cobalt_switch_context plugin shapes.

Signed-off-by: Hongzhan Chen <hongzhan.chen@intel.com>

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 9740ed9..e933b39 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1208,6 +1208,7 @@ static void kshark_tep_init_methods(struct kshark_generic_stream_interface *inte
 /** A list of built in default plugins for FTRACE (trace-cmd) data. */
 const char *tep_plugin_names[] = {
 	"sched_events",
+	"xenomai_cobalt_switch_events",
 	"missed_events",
 	"kvm_combo",
 };
diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
index 3e170fa..16f080b 100644
--- a/src/plugins/CMakeLists.txt
+++ b/src/plugins/CMakeLists.txt
@@ -44,6 +44,10 @@ if (Qt5Widgets_FOUND AND TT_FONT_FILE)
                      SOURCE sched_events.c SchedEvents.cpp)
     list(APPEND PLUGIN_LIST "sched_events")
 
+    BUILD_GUI_PLUGIN(NAME xenomai_cobalt_switch_events
+                     SOURCE xenomai_cobalt_switch_events.c CobaltSwitchEvents.cpp)
+    list(APPEND PLUGIN_LIST "xenomai_cobalt_switch_events")
+
     BUILD_GUI_PLUGIN(NAME event_field_plot
                      MOC EventFieldDialog.hpp
                      SOURCE event_field_plot.c EventFieldDialog.cpp EventFieldPlot.cpp)
diff --git a/src/plugins/CobaltSwitchEvents.cpp b/src/plugins/CobaltSwitchEvents.cpp
new file mode 100644
index 0000000..26a0bcb
--- /dev/null
+++ b/src/plugins/CobaltSwitchEvents.cpp
@@ -0,0 +1,204 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2018 Intel Inc, Hongzhan Chen<hongzhan.chen@intel.com>
+ */
+
+/**
+ *  @file    CobaltSwitchEvents.cpp
+ *  @brief   Defines a callback function for Xenomai Cobalt context switch
+ *           events used to plot in blue the out-of-band state of the task
+ */
+
+// C++
+#include <vector>
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plugin.h"
+#include "plugins/xenomai_cobalt_switch_events.h"
+#include "KsPlotTools.hpp"
+#include "KsPlugins.hpp"
+#include "KsMainWindow.hpp"
+
+using namespace KsPlot;
+
+static KsMainWindow *ks_ptr;
+
+/**
+ * @brief Provide the plugin with a pointer to the KsMainWindow object (the GUI
+ * itself) such that the plugin can manipulate the GUI.
+ */
+__hidden void *plugin_cobalt_set_gui_ptr(void *gui_ptr)
+{
+	ks_ptr = static_cast<KsMainWindow *>(gui_ptr);
+	return nullptr;
+}
+
+/**
+ * This class represents the graphical element visualizing out-of-band state
+ * that the task is running on
+ */
+class CobaltOobBox : public Rectangle
+{
+	/** On double click do. */
+	void _doubleClick() const override
+	{
+		ks_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
+		ks_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
+	}
+
+public:
+	/** The trace record data that corresponds to this CobaltOobBox. */
+	std::vector<kshark_data_field_int64 *>	_data;
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
+		if (x < pointX(0) || x > pointX(2))
+			return std::numeric_limits<double>::max();
+
+		if (y > pointY(0) || y < pointY(1))
+			return std::numeric_limits<double>::max();
+
+		return 0;
+	}
+};
+
+static PlotObject *makeShape(std::vector<const Graph *> graph,
+			     std::vector<int> bins,
+			     std::vector<kshark_data_field_int64 *> data,
+			     Color col, float size)
+{
+	CobaltOobBox *rec = new CobaltOobBox;
+	rec->_data = data;
+
+	Point p0 = graph[0]->bin(bins[0])._base;
+	Point p1 = graph[0]->bin(bins[1])._base;
+	int height = graph[0]->height() * .3;
+
+	rec->setFill(false);
+	rec->setPoint(0, p0.x() - 1, p0.y() + height);
+	rec->setPoint(1, p0.x() - 1, p0.y() + 1);
+
+	rec->setPoint(3, p1.x() - 1, p1.y() + height);
+	rec->setPoint(2, p1.x() - 1, p1.y() + 1);
+
+	rec->_size = size;
+	rec->_color = col;
+
+	return rec;
+};
+
+/*
+ * Ideally, the cobalt_switch_context has to be the last trace event recorded before
+ * the task is preempted. Because of this, when the data is loaded (the first pass),
+ * the "pid" field of the cobalt_switch_context entries gets edited by this plugin
+ * to be equal to the "next pid" of the cobalt_switch_context event. However, in
+ * reality the cobalt_switch_context event may be followed by some trailing events
+ * from the same task (printk events for example). This has the effect of extending
+ * the graph of the task outside of the actual duration of the task. The "second
+ * pass" over the data is used to fix this problem. It takes advantage of the
+ * "next" field of the entry (this field is set during the first pass) to search
+ * for trailing events after the "cobalt_switch_context". In addition, when
+ * we find that it try to switch in-band because next-pid is zero, we prefer to
+ * skip this event because it try to leave oob not enterring.
+ */
+static void secondPass(plugin_cobalt_context *plugin_ctx)
+{
+	kshark_data_container *cSS;
+	kshark_entry *e;
+	int pid_rec, switch_inband;
+
+	cSS = plugin_ctx->cs_data;
+	for (ssize_t i = 0; i < cSS->size; ++i) {
+		switch_inband = plugin_cobalt_check_switch_inband(
+				cSS->data[i]->field);
+		if (switch_inband)
+			continue;
+		pid_rec = plugin_cobalt_get_pid(cSS->data[i]->field);
+		e = cSS->data[i]->entry;
+		if (!e->next || e->pid == 0 ||
+		    e->event_id == e->next->event_id ||
+		    pid_rec != e->next->pid)
+			continue;
+
+		e = e->next;
+		/* Find the very last trailing event. */
+		for (; e->next; e = e->next) {
+			if (e->pid == plugin_cobalt_get_pid(
+						cSS->data[i]->field)) {
+				/*
+				 * Change the "pid" to be equal to the "next
+				 * pid" of the cobalt_switch_context event
+				 * and leave a sign that you edited this
+				 * entry.
+				 */
+				e->pid = cSS->data[i]->entry->pid;
+				e->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
+			}
+			/*  This is the last trailing event, we finish
+			 *  this round.
+			 */
+			if (e->next->pid != plugin_cobalt_get_pid(
+						cSS->data[i]->field))
+				break;
+		}
+	}
+}
+
+/**
+ * @brief Plugin's draw function.
+ *
+ * @param argv_c: A C pointer to be converted to KsCppArgV (C++ struct).
+ * @param sd: Data stream identifier.
+ * @param pid: Process Id.
+ * @param draw_action: Draw action identifier.
+ */
+__hidden void plugin_cobalt_draw(kshark_cpp_argv *argv_c,
+			  int sd, int pid, int draw_action)
+{
+	plugin_cobalt_context *plugin_ctx;
+
+	if (!(draw_action & KSHARK_TASK_DRAW) || pid == 0)
+		return;
+
+	plugin_ctx = __get_context(sd);
+	if (!plugin_ctx)
+		return;
+
+	KsCppArgV *argvCpp = KS_ARGV_TO_CPP(argv_c);
+
+	if (!plugin_ctx->second_pass_done) {
+		/* The second pass is not done yet. */
+		secondPass(plugin_ctx);
+		plugin_ctx->second_pass_done = true;
+	}
+
+	IsApplicableFunc checkFieldCS = [=] (kshark_data_container *d,
+					     ssize_t i) {
+		return !(plugin_cobalt_check_switch_inband(d->data[i]->field)) &&
+			d->data[i]->entry->pid == pid;
+	};
+
+	IsApplicableFunc checkEntryPid = [=] (kshark_data_container *d,
+					      ssize_t i) {
+		return plugin_cobalt_get_pid(d->data[i]->field) == pid;
+	};
+
+	eventFieldIntervalPlot(argvCpp,
+			       plugin_ctx->cs_data, checkFieldCS,
+			       plugin_ctx->cs_data, checkEntryPid,
+			       makeShape,
+			       {0, 0, 255}, // Blue
+			       -1);         // Default size
+}
diff --git a/src/plugins/xenomai_cobalt_switch_events.c b/src/plugins/xenomai_cobalt_switch_events.c
new file mode 100644
index 0000000..51d5dab
--- /dev/null
+++ b/src/plugins/xenomai_cobalt_switch_events.c
@@ -0,0 +1,198 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2021 Intel Inc, Hongzhan Chen <hongzhan.chen@intel.com>
+ */
+
+/**
+ *  @file    xenomai_cobalt_switch_events.c
+ *  @brief   handle xenomai cobalt switch context event
+ */
+
+// C
+#include <stdlib.h>
+#include <stdio.h>
+
+// trace-cmd
+#include <trace-cmd.h>
+
+// KernelShark
+#include "plugins/xenomai_cobalt_switch_events.h"
+#include "libkshark-tepdata.h"
+
+/** Plugin context instance. */
+
+#define SWITCH_INBAND_SHIFT	((int) ((sizeof(ks_num_field_t) - 1) * 8))
+
+#define SWITCH_INBAND_MASK		(((ks_num_field_t) 1 << 8) - 1)
+
+#define PID_MASK	(((ks_num_field_t) 1 << SWITCH_INBAND_SHIFT) - 1)
+
+//! @endcond
+
+static void plugin_cobalt_set_pid(ks_num_field_t *field,
+				 unsigned long long pid)
+{
+	*field &= ~PID_MASK;
+	*field = pid & PID_MASK;
+}
+
+/**
+ * @brief Retrieve the PID value from the data field stored in the
+ *	  kshark_data_container object.
+ *
+ * @param field: Input location for the data field.
+ */
+__hidden int plugin_cobalt_get_pid(ks_num_field_t field)
+{
+	return field & PID_MASK;
+}
+
+static void cobalt_free_context(struct plugin_cobalt_context *plugin_ctx)
+{
+	if (!plugin_ctx)
+		return;
+
+	kshark_free_data_container(plugin_ctx->cs_data);
+}
+
+/* Use the most significant byte to store state marking switch in-band. */
+static void plugin_cobalt_set_switch_inband_state(ks_num_field_t *field,
+					ks_num_field_t inband_state)
+{
+	unsigned long long mask = SWITCH_INBAND_MASK << SWITCH_INBAND_SHIFT;
+	*field &= ~mask;
+	*field |= (inband_state & SWITCH_INBAND_MASK) << SWITCH_INBAND_SHIFT;
+}
+
+/**
+ * @brief Retrieve the state of switch-in-band from the data field stored in
+ *        the kshark_data_container object.
+ *
+ * @param field: Input location for the data field.
+ */
+__hidden int plugin_cobalt_check_switch_inband(ks_num_field_t field)
+{
+	unsigned long long mask = SWITCH_INBAND_MASK << SWITCH_INBAND_SHIFT;
+
+	return (field & mask) >> SWITCH_INBAND_SHIFT;
+}
+
+/** A general purpose macro is used to define plugin context. */
+KS_DEFINE_PLUGIN_CONTEXT(struct plugin_cobalt_context, cobalt_free_context);
+
+static bool plugin_cobalt_init_context(struct kshark_data_stream *stream,
+				      struct plugin_cobalt_context *plugin_ctx)
+{
+	struct tep_event *event;
+
+	if (!kshark_is_tep(stream))
+		return false;
+
+	plugin_ctx->tep = kshark_get_tep(stream);
+
+	event = tep_find_event_by_name(plugin_ctx->tep,
+					"cobalt_core", "cobalt_switch_context");
+	if (!event)
+		return false;
+
+	plugin_ctx->cobalt_switch_event = event;
+	plugin_ctx->cobalt_switch_next_field =
+		tep_find_any_field(event, "next_pid");
+
+	plugin_ctx->cobalt_switch_prev_state_field =
+		tep_find_field(event, "prev_state");
+
+	plugin_ctx->second_pass_done = false;
+
+	plugin_ctx->cs_data = kshark_init_data_container();
+	if (!plugin_ctx->cs_data)
+		return false;
+
+
+	return true;
+}
+
+static void plugin_cobalt_switch_action(struct kshark_data_stream *stream,
+				      void *rec, struct kshark_entry *entry)
+{
+	struct tep_record *record = (struct tep_record *) rec;
+	struct plugin_cobalt_context *plugin_ctx;
+	unsigned long long next_pid;
+	ks_num_field_t ks_field;
+	int ret;
+
+	plugin_ctx = __get_context(stream->stream_id);
+	if (!plugin_ctx)
+		return;
+
+	ret = tep_read_number_field(plugin_ctx->cobalt_switch_next_field,
+				    record->data, &next_pid);
+
+	if (ret == 0 && next_pid >= 0) {
+		plugin_cobalt_set_pid(&ks_field, entry->pid);
+		if (next_pid == 0) {
+			plugin_cobalt_set_switch_inband_state(&ks_field,
+					SWITCH_INBAND_STATE);
+		}
+
+		kshark_data_container_append(plugin_ctx->cs_data,
+				entry, ks_field);
+
+		if (next_pid > 0)
+			entry->pid = next_pid;
+
+
+	}
+}
+
+/** Load this plugin. */
+int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
+{
+	struct plugin_cobalt_context *plugin_ctx;
+
+	plugin_ctx = __init(stream->stream_id);
+	if (!plugin_ctx || !plugin_cobalt_init_context(stream, plugin_ctx)) {
+		__close(stream->stream_id);
+		return 0;
+	}
+
+	if (plugin_ctx->cobalt_switch_event) {
+		kshark_register_event_handler(stream,
+						plugin_ctx->cobalt_switch_event->id,
+						plugin_cobalt_switch_action);
+	}
+
+	kshark_register_draw_handler(stream, plugin_cobalt_draw);
+
+	return 1;
+}
+
+/** Unload this plugin. */
+int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
+{
+	struct plugin_cobalt_context *plugin_ctx = __get_context(stream->stream_id);
+	int ret = 0;
+
+	if (plugin_ctx) {
+		if (plugin_ctx->cobalt_switch_event) {
+			kshark_unregister_event_handler(stream,
+							plugin_ctx->cobalt_switch_event->id,
+							plugin_cobalt_switch_action);
+		}
+
+		kshark_unregister_draw_handler(stream, plugin_cobalt_draw);
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
+	return plugin_cobalt_set_gui_ptr(gui_ptr);
+}
diff --git a/src/plugins/xenomai_cobalt_switch_events.h b/src/plugins/xenomai_cobalt_switch_events.h
new file mode 100644
index 0000000..9e1e030
--- /dev/null
+++ b/src/plugins/xenomai_cobalt_switch_events.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2021 Intel Inc, Hongzhan Chen<hongzhan.chen@intel.com>
+ */
+
+/**
+ *  @file    xenomai_cobalt_switch_events.h
+ *  @brief   Plugin for xenomai cobalt switch context event
+ */
+
+#ifndef _KS_PLUGIN_SHED_H
+#define _KS_PLUGIN_SHED_H
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plugin.h"
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#define SWITCH_INBAND_STATE	1
+/** Structure representing a plugin-specific context. */
+struct plugin_cobalt_context {
+	/** Page event used to parse the page. */
+	struct tep_handle	*tep;
+
+	/** Pointer to the cobalt_switch_event object. */
+	struct tep_event	*cobalt_switch_event;
+
+	 /** Pointer to the cobalt_switch_next_field format descriptor. */
+	struct tep_format_field *cobalt_switch_next_field;
+
+	/** Pointer to the cobalt_switch_prev_state_field format descriptor. */
+	struct tep_format_field *cobalt_switch_prev_state_field;
+
+	/** True if the second pass is already done. */
+	bool	second_pass_done;
+
+	/** Data container for cobalt_switch_context data. */
+	struct kshark_data_container	*cs_data;
+
+};
+
+KS_DECLARE_PLUGIN_CONTEXT_METHODS(struct plugin_cobalt_context)
+
+/** The type of the data field stored in the kshark_data_container object. */
+typedef int64_t ks_num_field_t;
+
+int plugin_cobalt_get_pid(ks_num_field_t field);
+
+int plugin_cobalt_check_switch_inband(ks_num_field_t field);
+
+void plugin_cobalt_draw(struct kshark_cpp_argv *argv, int sd, int pid,
+		 int draw_action);
+
+void *plugin_cobalt_set_gui_ptr(void *gui_ptr);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
-- 
2.17.1

