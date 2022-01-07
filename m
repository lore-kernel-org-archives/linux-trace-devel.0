Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BFAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jan 2022 02:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344794AbiAGChq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 21:37:46 -0500
Received: from mga04.intel.com ([192.55.52.120]:30418 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345480AbiAGChq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 21:37:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641523066; x=1673059066;
  h=from:to:subject:date:message-id:in-reply-to:references;
  bh=SkdEQaNJY9iMxY8ZloKJnHGc+IfLV/u1rSyRSdJ8zMc=;
  b=aQK1YUtWV9q9wFT8W/MpwBRexyDmz9d4/8+NceXuWcUUhmHHLj7sDwQV
   ZbnehKwOvlwu4XpeiIqKORullV+vUJ4VJKEAJpTO9SEH5uzTlieEVlQO7
   QDGrFsW7sAYmAWiWzIMYxPF8aWc9WO3BHga3Fxcjmc1+lT1kUfQzCOoTL
   V5CFCXXqDC0rbqGqXxiygX/WqpYvqgLKhVLGebyfeRXMCFDEU5oHxtT+Z
   nhyVv5nlJ4CE2GGax+kVfAQt/fOTsaG7J8I3sFAoqzKlkQQDGTHNzM4it
   JJ4MsAUVhk/oVlBV/zdQ8jvZ7GYL1K5srkxEA+nD0SQ05XaOw904QvsyF
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="241609606"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="241609606"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 18:37:45 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="473166153"
Received: from intel-z97x-ud5h.sh.intel.com ([10.67.103.201])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 18:37:44 -0800
From:   Hongzhan Chen <hongzhan.chen@intel.com>
To:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: [PATCH 2/2] kernel-shark: Add plugin for handling Xenomai cobalt_context_switch
Date:   Thu,  6 Jan 2022 21:18:46 -0500
Message-Id: <20220107021846.893-2-hongzhan.chen@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220107021846.893-1-hongzhan.chen@intel.com>
References: <20220107021846.893-1-hongzhan.chen@intel.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

For Xenomai-cobalt enabled system, cobalt_switch_context means
that there is schedule and context switch in companion core(realtime
core), which we may need to do special treatment and take correct
action as main kernel sched_switch to visualize out-of-band state
of realtime tasks running in cobalt core. To achive our target,
we implement following:

  1. store corresponding cobalt_switch_context events into
     container data.
  2. modify pid stored in entry to be equal to next_pid to
     show correct color in cpu bar when cobalt_switch_context
     event happen.
  3. show blue hollow box to mark out-of-band state according to
     cobalt_switch_context events.
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
index 0000000..0f90842
--- /dev/null
+++ b/src/plugins/CobaltSwitchEvents.cpp
@@ -0,0 +1,156 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2021 Intel Inc, Hongzhan Chen <hongzhan.chen@intel.com>
+ */
+
+/**
+ *  @file    CobaltSwitchEvents.cpp
+ *  @brief   Defines a callback function for Xenomai Cobalt context switch
+ *           events used to plot in blue the out-of-band state of the task
+ */
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plugin.h"
+#include "plugins/xenomai_cobalt_switch_events.h"
+#include "KsPlotTools.hpp"
+#include "KsPlugins.hpp"
+#include "KsMainWindow.hpp"
+
+static KsMainWindow *ks_xenomai_ptr;
+
+/**
+ * @brief Provide the plugin with a pointer to the KsMainWindow object (the GUI
+ * itself) such that the plugin can manipulate the GUI.
+ */
+__hidden void *plugin_set_gui_ptr(void *gui_ptr)
+{
+	ks_xenomai_ptr = static_cast<KsMainWindow *>(gui_ptr);
+	return nullptr;
+}
+
+/**
+ * This class represents the graphical element visualizing OOB state between
+ *  two cobalt_switch_context events.
+ */
+class XenomaiSwitchBox : public LatencyBox
+{
+	/** On double click do. */
+	void _doubleClick() const override
+	{
+		ks_xenomai_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
+		ks_xenomai_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
+	}
+
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
+
+		/* we skip cobalt_switch_context that try to
+		 * switch into in-band state because we just handle
+		 * out-of-band
+		 */
+		if (switch_inband)
+			continue;
+		pid_rec = plugin_sched_get_pid(cSS->data[i]->field);
+		e = cSS->data[i]->entry;
+		if (!e->next || e->pid == 0 ||
+		    e->event_id == e->next->event_id ||
+		    pid_rec != e->next->pid)
+			continue;
+
+		e = e->next;
+		/* Find all trailing events. */
+		for (; e->next; e = e->next) {
+			if (e->pid == plugin_sched_get_pid(
+						cSS->data[i]->field)) {
+				/*
+				 * Change the "pid" to be equal to the "next
+				 * pid" of the cobalt_switch_context event
+				 * and leave a sign that you edited this
+				 * entry.
+				 */
+				e->pid = cSS->data[i]->entry->pid;
+				e->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
+
+				/*  This is the last trailing event, we finish
+				 *  this round.
+				 */
+				if (e->next->pid != plugin_sched_get_pid(
+						cSS->data[i]->field))
+					break;
+			}
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
+		return plugin_sched_get_pid(d->data[i]->field) == pid;
+	};
+
+	eventFieldIntervalPlot(argvCpp,
+			       plugin_ctx->cs_data, checkFieldCS,
+			       plugin_ctx->cs_data, checkEntryPid,
+			       makeLatencyBox<XenomaiSwitchBox>,
+			       {0, 0, 255}, // Blue
+			       -1);         // Default size
+}
diff --git a/src/plugins/xenomai_cobalt_switch_events.c b/src/plugins/xenomai_cobalt_switch_events.c
new file mode 100644
index 0000000..f285552
--- /dev/null
+++ b/src/plugins/xenomai_cobalt_switch_events.c
@@ -0,0 +1,174 @@
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
+//! @cond Doxygen_Suppress
+
+#define SWITCH_INBAND_SHIFT	PREV_STATE_SHIFT
+
+#define SWITCH_INBAND_MASK	PREV_STATE_MASK
+
+//! @endcond
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
+	plugin_ctx->second_pass_done = false;
+
+	plugin_ctx->cs_data = kshark_init_data_container();
+	if (!plugin_ctx->cs_data)
+		return false;
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
+		plugin_sched_set_pid(&ks_field, entry->pid);
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
+	return plugin_set_gui_ptr(gui_ptr);
+}
diff --git a/src/plugins/xenomai_cobalt_switch_events.h b/src/plugins/xenomai_cobalt_switch_events.h
new file mode 100644
index 0000000..4258401
--- /dev/null
+++ b/src/plugins/xenomai_cobalt_switch_events.h
@@ -0,0 +1,57 @@
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
+#include "plugins/common_sched.h"
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#define SWITCH_INBAND_STATE	1
+
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
+int plugin_cobalt_check_switch_inband(ks_num_field_t field);
+
+void plugin_cobalt_draw(struct kshark_cpp_argv *argv, int sd, int pid,
+		 int draw_action);
+
+void *plugin_set_gui_ptr(void *gui_ptr);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
-- 
2.17.1

