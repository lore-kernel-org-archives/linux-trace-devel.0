Return-Path: <SRS0=7BWw=MC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f45.google.com ([209.85.221.45]:40597 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbeITWkz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Sep 2018 18:40:55 -0400
Received: by mail-wr1-f45.google.com with SMTP id y8-v6so6482928wrh.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Sep 2018 09:56:29 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 8/8] kernel-shark-qt: Add a plugin for sched events.
Date: Thu, 20 Sep 2018 19:55:44 +0300
Message-Id: <20180920165544.17579-9-y.karadz@gmail.com>
In-Reply-To: <20180920165544.17579-1-y.karadz@gmail.com>
References: <20180920165544.17579-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The plugin is responsible for the following actions, specific for
"sched" events:

1. Changes the value of the "pid" field of the "sched_switch" entries.
   This alows the sched_switch entry to be plotted as part of the "next"
   task.

2. On "sched_switch" event, the plugin registers the "next" task (if not
   registered already).

3. Plots in green the wake up latency of the task and in red the time
   the task was preempted by another task.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/plugins/CMakeLists.txt  |   5 +
 kernel-shark-qt/src/plugins/SchedEvents.cpp | 263 +++++++++++++++++
 kernel-shark-qt/src/plugins/sched_events.c  | 305 ++++++++++++++++++++
 kernel-shark-qt/src/plugins/sched_events.h  |  76 +++++
 4 files changed, 649 insertions(+)
 create mode 100644 kernel-shark-qt/src/plugins/SchedEvents.cpp
 create mode 100644 kernel-shark-qt/src/plugins/sched_events.c
 create mode 100644 kernel-shark-qt/src/plugins/sched_events.h

diff --git a/kernel-shark-qt/src/plugins/CMakeLists.txt b/kernel-shark-qt/src/plugins/CMakeLists.txt
index 565f1cb..88fd93c 100644
--- a/kernel-shark-qt/src/plugins/CMakeLists.txt
+++ b/kernel-shark-qt/src/plugins/CMakeLists.txt
@@ -19,4 +19,9 @@ endfunction()
 
 set(PLUGIN_LIST "")
 
+BUILD_PLUGIN(NAME sched_events
+             SOURCE sched_events.c SchedEvents.cpp)
+list(APPEND PLUGIN_LIST "sched_events default") # This plugin will be loaded by default
+# list(APPEND PLUGIN_LIST "sched_events") # This plugin isn't loaded by default
+
 set(PLUGINS ${PLUGIN_LIST} PARENT_SCOPE)
diff --git a/kernel-shark-qt/src/plugins/SchedEvents.cpp b/kernel-shark-qt/src/plugins/SchedEvents.cpp
new file mode 100644
index 0000000..713feb4
--- /dev/null
+++ b/kernel-shark-qt/src/plugins/SchedEvents.cpp
@@ -0,0 +1,263 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    SchedEvents.cpp
+ *  @brief   Defines a callback function for Sched events used to plot in green
+ *	     the wake up latency of the task and in red the time the task was
+ *	     preempted by another task.
+ */
+
+// C++
+#include<iostream>
+
+// C++ 11
+#include<functional>
+
+// KernelShark
+#include "libkshark.h"
+#include "plugins/sched_events.h"
+#include "KsPlotTools.hpp"
+#include "KsPlugins.hpp"
+
+//! @cond Doxygen_Suppress
+
+#define PLUGIN_MIN_BOX_SIZE 4
+
+#define PLUGIN_MAX_ENTRIES_PER_BIN 500
+
+//! @endcond
+
+extern struct plugin_sched_context *plugin_sched_context_handler;
+
+static int plugin_get_wakeup_pid(kshark_context *kshark_ctx,
+				 plugin_sched_context *plugin_ctx,
+				 const struct kshark_entry *e)
+{
+	struct tep_record *record;
+	unsigned long long val;
+
+	record = kshark_read_at(kshark_ctx, e->offset);
+	tep_read_number_field(plugin_ctx->sched_wakeup_pid_field,
+			      record->data, &val);
+	free_record(record);
+
+	return val;
+}
+
+/** Sched Event identifier. */
+enum class SchedEvent {
+	/** Sched Switch Event. */
+	Switch,
+
+	/** Sched Wakeup Event. */
+	Wakeup,
+};
+
+static void pluginDraw(plugin_sched_context *plugin_ctx,
+		       kshark_context *kshark_ctx,
+		       kshark_trace_histo *histo,
+		       kshark_entry_collection *col,
+		       SchedEvent e,
+		       int pid,
+		       KsPlot::Graph *graph,
+		       KsPlot::PlotObjList *shapes)
+{
+	std::function<void(int)> ifSchedBack;
+	KsPlot::Rectangle *rec = nullptr;
+	int height = graph->getHeight() * .3;
+
+	auto openBox = [&] (const KsPlot::Point &p)
+	{
+		/*
+		 * First check if we already have an open box. If we don't
+		 * have, open a new one.
+		 */
+		if (!rec)
+			rec = new KsPlot::Rectangle;
+
+		rec->setFill(false);
+		rec->setPoint(0, p.x() - 1, p.y() - height);
+		rec->setPoint(1, p.x() - 1, p.y() - 1);
+	};
+
+	auto closeBox = [&] (const KsPlot::Point &p)
+	{
+		if (rec == nullptr)
+			return;
+
+		int boxSize = rec->getPoint(0)->x;
+		if (boxSize < PLUGIN_MIN_BOX_SIZE) {
+			/* This box is too small. Don't try to plot it. */
+			delete rec;
+			rec = nullptr;
+			return;
+		}
+
+		rec->setPoint(3, p.x() - 1, p.y() - height);
+		rec->setPoint(2, p.x() - 1, p.y() - 1);
+
+		shapes->push_front(rec);
+		rec = nullptr;
+	};
+
+	auto lamIfSchSwitchFront = [&] (int bin)
+	{
+		/*
+		 * Starting from the first element in this bin, go forward
+		 * in time until you find a trace entry that satisfies the
+		 * condition defined by kshark_match_pid.
+		 */
+		const kshark_entry *entryF =
+			ksmodel_get_entry_front(histo, bin, false,
+						kshark_match_pid, pid,
+						col, nullptr);
+
+		if (entryF &&
+		    entryF->pid == pid &&
+		    plugin_ctx->sched_switch_event &&
+		    entryF->event_id == plugin_ctx->sched_switch_event->id) {
+			/*
+			 * entryF is sched_switch_event. Close the box and add
+			 * it to the list of shapes to be ploted.
+			 */
+			closeBox(graph->getBin(bin)._base);
+		}
+	};
+
+	auto lamIfSchWakeupBack = [&] (int bin)
+	{
+		/*
+		 * Starting from the last element in this bin, go backward
+		 * in time until you find a trace entry that satisfies the
+		 * condition defined by plugin_wakeup_match_pid.
+		 */
+		const kshark_entry *entryB =
+			ksmodel_get_entry_back(histo, bin, false,
+					       plugin_wakeup_match_pid, pid,
+					       col, nullptr);
+		int wakeup_pid;
+
+		if (entryB &&
+		    plugin_ctx->sched_wakeup_event &&
+		    entryB->event_id == plugin_ctx->sched_wakeup_event->id) {
+			wakeup_pid =
+				plugin_get_wakeup_pid(kshark_ctx, plugin_ctx, entryB);
+			if (wakeup_pid == pid) {
+				/*
+				 * entryB is a sched_wakeup_event. Open a
+				 * green box here.
+				 */
+				openBox(graph->getBin(bin)._base);
+
+				 /* Green */
+				rec->_color = KsPlot::Color(0, 255, 0);
+			}
+		}
+	};
+
+	auto lamIfSchSwitchBack = [&] (int bin)
+	{
+		/*
+		 * Starting from the last element in this bin, go backward
+		 * in time until you find a trace entry that satisfies the
+		 * condition defined by plugin_switch_match_pid.
+		 */
+		const kshark_entry *entryB =
+			ksmodel_get_entry_back(histo, bin, false,
+					       plugin_switch_match_pid, pid,
+					       col, nullptr);
+
+		if (entryB &&
+		    entryB->pid != pid &&
+		    plugin_ctx->sched_switch_event &&
+		    entryB->event_id == plugin_ctx->sched_switch_event->id) {
+			/*
+			 * entryB is a sched_switch_event. Open a
+			 * red box here.
+			 */
+			openBox(graph->getBin(bin)._base);
+
+			/* Red */
+			rec->_color = KsPlot::Color(255, 0, 0);
+		}
+	};
+
+	if (e == SchedEvent::Switch)
+		ifSchedBack = lamIfSchSwitchBack;
+	else
+		ifSchedBack = lamIfSchWakeupBack;
+
+	for (int bin = 0; bin < graph->size(); ++bin) {
+		/**
+		 * Plotting the latencies makes sense only in the case of a
+		 * deep zoom. Here we set a naive threshold based on the number
+		 * of entries inside the current bin. This cut seems to work
+		 * well in all cases I tested so far, but it may result in
+		 * unexpected behavior with some unusual trace data-sets.
+		 * TODO: find a better criteria for deciding when to start
+		 * plotting latencies.
+		 */
+		if (ksmodel_bin_count(histo, bin) > PLUGIN_MAX_ENTRIES_PER_BIN)
+			continue;
+
+		lamIfSchSwitchFront(bin);
+
+		ifSchedBack(bin);
+	}
+
+	if (rec)
+		delete rec;
+
+	return;
+}
+
+/**
+ * @brief Plugin's draw function.
+ *
+ * @param argv_c: A C pointer to be converted to KsCppArgV (C++ struct).
+ * @param pid: Process Id.
+ * @param draw_action: Draw action identifier.
+ *
+ * @returns True if the Pid of the entry matches the value of "pid".
+ *	    Otherwise false.
+ */
+void plugin_draw(kshark_cpp_argv *argv_c, int pid, int draw_action)
+{
+	plugin_sched_context *plugin_ctx;
+	kshark_context *kshark_ctx(NULL);
+	kshark_entry_collection *col;
+
+	if (draw_action != KSHARK_PLUGIN_TASK_DRAW || pid == 0)
+		return;
+
+	plugin_ctx = plugin_sched_context_handler;
+	if (!plugin_ctx || !kshark_instance(&kshark_ctx))
+		return;
+
+	KsCppArgV *argvCpp = KS_ARGV_TO_CPP(argv_c);
+
+	/*
+	 * Try to find a collections for this task. It is OK if
+	 * coll = NULL.
+	 */
+	col = kshark_find_data_collection(kshark_ctx->collections,
+					  kshark_match_pid, pid);
+
+	try {
+		pluginDraw(plugin_ctx, kshark_ctx,
+			   argvCpp->_histo, col,
+			   SchedEvent::Switch, pid,
+			   argvCpp->_graph, argvCpp->_shapes);
+
+		pluginDraw(plugin_ctx, kshark_ctx,
+			   argvCpp->_histo, col,
+			   SchedEvent::Wakeup, pid,
+			   argvCpp->_graph, argvCpp->_shapes);
+	} catch (const std::exception &exc) {
+		std::cerr << "Exception in SchedEvents\n" << exc.what();
+	}
+}
diff --git a/kernel-shark-qt/src/plugins/sched_events.c b/kernel-shark-qt/src/plugins/sched_events.c
new file mode 100644
index 0000000..ffc8333
--- /dev/null
+++ b/kernel-shark-qt/src/plugins/sched_events.c
@@ -0,0 +1,305 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    sched_events.c
+ *  @brief   Defines a callback function for Sched events used to registers the
+ *	     "next" task (if not registered already) and to changes the value
+ *	     of the "pid" field of the "sched_switch" entries such that, it
+ *	     will be ploted as part of the "next" task.
+ */
+
+// C
+#include <stdlib.h>
+#include <stdio.h>
+#include <assert.h>
+
+// KernelShark
+#include "plugins/sched_events.h"
+
+/** Plugin context instance. */
+struct plugin_sched_context *plugin_sched_context_handler = NULL;
+
+static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
+{
+	struct plugin_sched_context *plugin_ctx;
+	struct event_format *event;
+
+	/* No context should exist when we initialize the plugin. */
+	assert(plugin_sched_context_handler == NULL);
+
+	plugin_sched_context_handler =
+		malloc(sizeof(*plugin_sched_context_handler));
+	if (!plugin_sched_context_handler) {
+		fprintf(stderr,
+			"Failed to allocate memory for plugin_sched_context.\n");
+		return false;
+	}
+
+	plugin_ctx = plugin_sched_context_handler;
+	plugin_ctx->handle = kshark_ctx->handle;
+	plugin_ctx->pevent = kshark_ctx->pevent;
+
+	event = tep_find_event_by_name(plugin_ctx->pevent,
+				       "sched", "sched_switch");
+	if (!event)
+		return false;
+
+	plugin_ctx->sched_switch_event = event;
+	plugin_ctx->sched_switch_next_field =
+		tep_find_any_field(event, "next_pid");
+
+	plugin_ctx->sched_switch_comm_field =
+		tep_find_field(event, "next_comm");
+
+	event = tep_find_event_by_name(plugin_ctx->pevent,
+				      "sched", "sched_wakeup");
+	if (!event)
+		return false;
+
+	plugin_ctx->sched_wakeup_event = event;
+	plugin_ctx->sched_wakeup_pid_field =
+		tep_find_any_field(event, "pid");
+
+	plugin_ctx->sched_wakeup_success_field =
+		tep_find_field(event, "success");
+
+	event = tep_find_event_by_name(plugin_ctx->pevent,
+				       "sched", "sched_wakeup_new");
+	if (!event)
+		return false;
+
+	plugin_ctx->sched_wakeup_new_event = event;
+	plugin_ctx->sched_wakeup_new_pid_field =
+		tep_find_any_field(event, "pid");
+
+	plugin_ctx->sched_wakeup_new_success_field =
+		tep_find_field(event, "success");
+
+	return true;
+}
+
+/**
+ * @brief Get the Process Id of the next scheduled task.
+ *
+ * @param record: Input location for a sched_switch record.
+ */
+int plugin_get_next_pid(struct tep_record *record)
+{
+	struct plugin_sched_context *plugin_ctx =
+		plugin_sched_context_handler;
+	unsigned long long val;
+
+	tep_read_number_field(plugin_ctx->sched_switch_next_field,
+			      record->data, &val);
+	return val;
+}
+
+/**
+ * @brief Get the Process Id of the task being woke up.
+ *
+ * @param record: Input location for a sched_wakeup record.
+ */
+int plugin_get_wakeup_pid(struct tep_record *record)
+{
+	struct plugin_sched_context *plugin_ctx =
+		plugin_sched_context_handler;
+	unsigned long long val;
+
+	tep_read_number_field(plugin_ctx->sched_wakeup_pid_field,
+			      record->data, &val);
+	return val;
+}
+
+static void plugin_register_command(struct kshark_context *kshark_ctx,
+				    struct tep_record *record,
+				    int pid)
+{
+	struct plugin_sched_context *plugin_ctx =
+		plugin_sched_context_handler;
+	const char *comm;
+
+	if (!plugin_ctx->sched_switch_comm_field)
+		return;
+
+	comm = record->data + plugin_ctx->sched_switch_comm_field->offset;
+	/*
+	 * TODO: The retrieve of the name of the command above needs to be
+	 * implemented as a wrapper function in libtracevent.
+	 */
+
+	if (!tep_pid_is_registered(kshark_ctx->pevent, pid))
+			tep_register_comm(kshark_ctx->pevent, comm, pid);
+}
+
+static int plugin_get_wakeup_new_pid(struct tep_record *record)
+{
+	struct plugin_sched_context *plugin_ctx =
+		plugin_sched_context_handler;
+	unsigned long long val;
+
+	tep_read_number_field(plugin_ctx->sched_wakeup_new_pid_field,
+				 record->data, &val);
+
+	return val;
+}
+
+/**
+ * @brief Process Id matching function adapted for sched_wakeup and
+ *	  sched_wakeup_new events.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param e: kshark_entry to be checked.
+ * @param pid: Matching condition value.
+ *
+ * @returns True if the Pid of the entry matches the value of "pid".
+ *	    Otherwise false.
+ */
+bool plugin_wakeup_match_pid(struct kshark_context *kshark_ctx,
+			     struct kshark_entry *e,
+			     int pid)
+{
+	struct plugin_sched_context *plugin_ctx;
+	struct tep_record *record = NULL;
+	unsigned long long val;
+	int wakeup_pid = -1;
+
+	if (e->pid == pid)
+		return true;
+
+	plugin_ctx = plugin_sched_context_handler;
+	if (!plugin_ctx)
+		return false;
+
+	if (plugin_ctx->sched_wakeup_event &&
+	    e->event_id == plugin_ctx->sched_wakeup_event->id) {
+		record = kshark_read_at(kshark_ctx, e->offset);
+
+		/* We only want those that actually woke up the task. */
+		tep_read_number_field(plugin_ctx->sched_wakeup_success_field,
+				      record->data, &val);
+
+		if (val)
+			wakeup_pid = plugin_get_wakeup_pid(record);
+	}
+
+	if (plugin_ctx->sched_wakeup_new_event &&
+	    e->event_id == plugin_ctx->sched_wakeup_new_event->id) {
+		record = kshark_read_at(kshark_ctx, e->offset);
+
+		/* We only want those that actually woke up the task. */
+		tep_read_number_field(plugin_ctx->sched_wakeup_new_success_field,
+				      record->data, &val);
+
+		if (val)
+			wakeup_pid = plugin_get_wakeup_new_pid(record);
+	}
+
+	free_record(record);
+
+	if (wakeup_pid >= 0 && wakeup_pid == pid)
+		return true;
+
+	return false;
+}
+
+/**
+ * @brief Process Id matching function adapted for sched_switch events.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param e: kshark_entry to be checked.
+ * @param pid: Matching condition value.
+ *
+ * @returns True if the Pid of the entry matches the value of "pid".
+ *	    Otherwise false.
+ */
+bool plugin_switch_match_pid(struct kshark_context *kshark_ctx,
+			     struct kshark_entry *e,
+			     int pid)
+{
+	struct plugin_sched_context *plugin_ctx;
+	struct tep_record *record = NULL;
+	int switch_pid = -1;
+
+	if (e->pid == pid)
+		return true;
+
+	plugin_ctx = plugin_sched_context_handler;
+
+	if (plugin_ctx->sched_switch_event &&
+	    e->event_id == plugin_ctx->sched_switch_event->id) {
+		record = kshark_read_at(kshark_ctx, e->offset);
+
+		switch_pid = tep_data_pid(plugin_ctx->pevent, record);
+	}
+
+	free_record(record);
+
+	if (switch_pid >= 0 && switch_pid == pid)
+		return true;
+
+	return false;
+}
+
+static void plugin_sched_action(struct kshark_context *kshark_ctx,
+				struct tep_record *rec,
+				struct kshark_entry *entry)
+{
+	entry->pid = plugin_get_next_pid(rec);
+	plugin_register_command(kshark_ctx, rec, entry->pid);
+}
+
+static int plugin_sched_init(struct kshark_context *kshark_ctx)
+{
+	struct plugin_sched_context *plugin_ctx;
+
+	if (!plugin_sched_init_context(kshark_ctx)) {
+		free(plugin_sched_context_handler);
+		plugin_sched_context_handler = NULL;
+		return 0;
+	}
+
+	plugin_ctx = plugin_sched_context_handler;
+
+	kshark_register_event_handler(&kshark_ctx->event_handlers,
+				      plugin_ctx->sched_switch_event->id,
+				      plugin_sched_action,
+				      plugin_draw);
+
+	return 1;
+}
+
+static int plugin_sched_close(struct kshark_context *kshark_ctx)
+{
+	struct plugin_sched_context *plugin_ctx;
+
+	if (!plugin_sched_context_handler)
+		return 0;
+
+	plugin_ctx = plugin_sched_context_handler;
+
+	kshark_unregister_event_handler(&kshark_ctx->event_handlers,
+					plugin_ctx->sched_switch_event->id,
+					plugin_sched_action,
+					plugin_draw);
+
+	free(plugin_ctx);
+	plugin_sched_context_handler = NULL;
+
+	return 1;
+}
+
+/** Load this plugin. */
+int KSHARK_PLUGIN_INITIALIZER(struct kshark_context *kshark_ctx)
+{
+	return plugin_sched_init(kshark_ctx);
+}
+
+/** Unload this plugin. */
+int KSHARK_PLUGIN_DEINITIALIZER(struct kshark_context *kshark_ctx)
+{
+	return plugin_sched_close(kshark_ctx);
+}
diff --git a/kernel-shark-qt/src/plugins/sched_events.h b/kernel-shark-qt/src/plugins/sched_events.h
new file mode 100644
index 0000000..673f5cf
--- /dev/null
+++ b/kernel-shark-qt/src/plugins/sched_events.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    sched_events.h
+ *  @brief   Plugin for Sched events.
+ */
+
+#ifndef _KS_PLUGIN_SHED_H
+#define _KS_PLUGIN_SHED_H
+
+// KernelShark
+#include "libkshark.h"
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/** Structure representing a plugin-specific context. */
+struct plugin_sched_context {
+	/** Input handle for the trace data file. */
+	struct tracecmd_input	*handle;
+
+	/** Page event used to parse the page. */
+	struct tep_handle	*pevent;
+
+	/** Pointer to the sched_switch_event object. */
+	struct event_format	*sched_switch_event;
+
+	/** Pointer to the sched_switch_next_field format descriptor. */
+	struct format_field	*sched_switch_next_field;
+
+	/** Pointer to the sched_switch_comm_field format descriptor. */
+	struct format_field	*sched_switch_comm_field;
+
+	/** Pointer to the sched_wakeup_event object. */
+	struct event_format	*sched_wakeup_event;
+
+	/** Pointer to the sched_wakeup_pid_field format descriptor. */
+	struct format_field	*sched_wakeup_pid_field;
+
+	/** Pointer to the sched_wakeup_success_field format descriptor. */
+	struct format_field	*sched_wakeup_success_field;
+
+	/** Pointer to the sched_wakeup_new_event object. */
+	struct event_format	*sched_wakeup_new_event;
+
+	/** Pointer to the sched_wakeup_new_pid_field format descriptor. */
+	struct format_field	*sched_wakeup_new_pid_field;
+
+	/**
+	 * Pointer to the sched_wakeup_new_success_field format descriptor.
+	 */
+	struct format_field	*sched_wakeup_new_success_field;
+};
+
+int plugin_get_next_pid(struct tep_record *record);
+
+int plugin_get_wakeup_pid(struct tep_record *record);
+
+bool plugin_wakeup_match_pid(struct kshark_context *kshark_ctx,
+			     struct kshark_entry *e, int pid);
+
+bool plugin_switch_match_pid(struct kshark_context *kshark_ctx,
+			     struct kshark_entry *e, int pid);
+
+void plugin_draw(struct kshark_cpp_argv *argv, int pid, int draw_action);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
-- 
2.17.1
