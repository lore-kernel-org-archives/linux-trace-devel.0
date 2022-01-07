Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC99C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jan 2022 02:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345478AbiAGChp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 21:37:45 -0500
Received: from mga04.intel.com ([192.55.52.120]:30418 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344794AbiAGChp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 21:37:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641523065; x=1673059065;
  h=from:to:subject:date:message-id;
  bh=ukSnilMKVV33AVgwdcvxoO6MZe/iS+/r0hjI18D5hkE=;
  b=Ek3xDOrLXyEOjZJIYGlpilkAag5rZASt07nwyrJvG9CULPcPkZH57s6r
   7XgNsO0hY4N0FiEwDHd1C1kiQlktSu/FMpxMzBN6WBeef6kFo1zmTLIbr
   OUPzWb17SAoM2T0kcwda+9XaZrYZCfm9P+eslFXePkmo9thE2KXGNY6no
   lqYMmxaYedpEwpPVBAEGEZjoFlI9z09eRtq1LPoKkJIdeclX9+zWlZ8dr
   SdT1xENO7C/Xh3zamqv+z6ib7GSIO90BPdCfPB6mS8cwnYaFt/q/2XmBd
   vPRAEiogHvXJ+AvgAlbE5/fE+TvKzw90+LcsOqAWSGiv3vuWEXoQG7oZY
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="241609605"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="241609605"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 18:37:44 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="473166152"
Received: from intel-z97x-ud5h.sh.intel.com ([10.67.103.201])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 18:37:43 -0800
From:   Hongzhan Chen <hongzhan.chen@intel.com>
To:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: [PATCH 1/2] kernel-shark: Move common APIs and definitions out to avoid duplication
Date:   Thu,  6 Jan 2022 21:18:45 -0500
Message-Id: <20220107021846.893-1-hongzhan.chen@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

To avoid code duplication, move some common APIs and definitions
out from plugin SchedEvent to share with other plugins.

Signed-off-by: Hongzhan Chen <hongzhan.chen@intel.com>

diff --git a/src/KsPlugins.hpp b/src/KsPlugins.hpp
index d41d094..4b29fa6 100644
--- a/src/KsPlugins.hpp
+++ b/src/KsPlugins.hpp
@@ -13,6 +13,7 @@
 #define _KS_PLUGINS_H
 
 // C++
+#include <vector>
 #include <functional>
 
 // KernelShark
@@ -101,4 +102,66 @@ void eventFieldIntervalPlot(KsCppArgV *argvCpp,
 			    KsPlot::Color col,
 			    float size);
 
+/**
+ * This class represents the graphical element visualizing the latency between
+ * two events such as sched_waking and sched_switch events for common Linux
+ * kernel or cobalt_switch_contexts for Xenomai.
+ */
+class LatencyBox : public KsPlot::Rectangle
+{
+	/** On double click do. */
+	void _doubleClick() const override {}
+
+public:
+	/** The trace record data that corresponds to this LatencyBox. */
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
+		if (y < pointY(0) || y > pointY(1))
+			return std::numeric_limits<double>::max();
+
+		return 0;
+	}
+};
+
+template<class T> KsPlot::PlotObject *
+makeLatencyBox(std::vector<const KsPlot::Graph *> graph,
+			     std::vector<int> bins,
+			     std::vector<kshark_data_field_int64 *> data,
+			     KsPlot::Color col, float size)
+{
+	LatencyBox *rec = new T;
+	rec->_data = data;
+
+	KsPlot::Point p0 = graph[0]->bin(bins[0])._base;
+	KsPlot::Point p1 = graph[0]->bin(bins[1])._base;
+	int height = graph[0]->height() * .3;
+
+	rec->setFill(false);
+	rec->setPoint(0, p0.x() - 1, p0.y() - height);
+	rec->setPoint(1, p0.x() - 1, p0.y() - 1);
+
+	rec->setPoint(3, p1.x() - 1, p1.y() - height);
+	rec->setPoint(2, p1.x() - 1, p1.y() - 1);
+
+	rec->_size = size;
+	rec->_color = col;
+
+	return rec;
+}
+
 #endif
diff --git a/src/plugins/SchedEvents.cpp b/src/plugins/SchedEvents.cpp
index b73e45f..573e4e3 100644
--- a/src/plugins/SchedEvents.cpp
+++ b/src/plugins/SchedEvents.cpp
@@ -11,9 +11,6 @@
  *	     preempted by another task.
  */
 
-// C++
-#include <vector>
-
 // KernelShark
 #include "libkshark.h"
 #include "libkshark-plugin.h"
@@ -24,7 +21,7 @@
 
 using namespace KsPlot;
 
-static KsMainWindow *ks_ptr;
+static KsMainWindow *ks_schedevent_ptr;
 
 /**
  * @brief Provide the plugin with a pointer to the KsMainWindow object (the GUI
@@ -32,7 +29,7 @@ static KsMainWindow *ks_ptr;
  */
 __hidden void *plugin_set_gui_ptr(void *gui_ptr)
 {
-	ks_ptr = static_cast<KsMainWindow *>(gui_ptr);
+	ks_schedevent_ptr = static_cast<KsMainWindow *>(gui_ptr);
 	return nullptr;
 }
 
@@ -40,64 +37,15 @@ __hidden void *plugin_set_gui_ptr(void *gui_ptr)
  * This class represents the graphical element visualizing the latency between
  *  sched_waking and sched_switch events.
  */
-class LatencyBox : public Rectangle
+class SchedLatencyBox : public LatencyBox
 {
 	/** On double click do. */
 	void _doubleClick() const override
 	{
-		ks_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
-		ks_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
+		ks_schedevent_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
+		ks_schedevent_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
 	}
 
-public:
-	/** The trace record data that corresponds to this LatencyBox. */
-	std::vector<kshark_data_field_int64 *>	_data;
-
-	/**
-	 * @brief Distance between the click and the shape. Used to decide if
-	 *	  the double click action must be executed.
-	 *
-	 * @param x: X coordinate of the click.
-	 * @param y: Y coordinate of the click.
-	 *
-	 * @returns If the click is inside the box, the distance is zero.
-	 *	    Otherwise infinity.
-	 */
-	double distance(int x, int y) const override
-	{
-		if (x < pointX(0) || x > pointX(2))
-			return std::numeric_limits<double>::max();
-
-		if (y < pointY(0) || y > pointY(1))
-			return std::numeric_limits<double>::max();
-
-		return 0;
-	}
-};
-
-static PlotObject *makeShape(std::vector<const Graph *> graph,
-			     std::vector<int> bins,
-			     std::vector<kshark_data_field_int64 *> data,
-			     Color col, float size)
-{
-	LatencyBox *rec = new LatencyBox;
-	rec->_data = data;
-
-	Point p0 = graph[0]->bin(bins[0])._base;
-	Point p1 = graph[0]->bin(bins[1])._base;
-	int height = graph[0]->height() * .3;
-
-	rec->setFill(false);
-	rec->setPoint(0, p0.x() - 1, p0.y() - height);
-	rec->setPoint(1, p0.x() - 1, p0.y() - 1);
-
-	rec->setPoint(3, p1.x() - 1, p1.y() - height);
-	rec->setPoint(2, p1.x() - 1, p1.y() - 1);
-
-	rec->_size = size;
-	rec->_color = col;
-
-	return rec;
 };
 
 /*
@@ -191,14 +139,14 @@ __hidden void plugin_draw(kshark_cpp_argv *argv_c,
 	eventFieldIntervalPlot(argvCpp,
 			       plugin_ctx->sw_data, checkFieldSW,
 			       plugin_ctx->ss_data, checkEntryPid,
-			       makeShape,
+			       makeLatencyBox<SchedLatencyBox>,
 			       {0, 255, 0}, // Green
 			       -1);         // Default size
 
 	eventFieldIntervalPlot(argvCpp,
 			       plugin_ctx->ss_data, checkFieldSS,
 			       plugin_ctx->ss_data, checkEntryPid,
-			       makeShape,
+			       makeLatencyBox<SchedLatencyBox>,
 			       {255, 0, 0}, // Red
 			       -1);         // Default size
 }
diff --git a/src/plugins/common_sched.h b/src/plugins/common_sched.h
new file mode 100644
index 0000000..1d564c0
--- /dev/null
+++ b/src/plugins/common_sched.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2021 Intel Inc, Hongzhan Chen <hongzhan.chen@intel.com>
+ */
+
+/**
+ *  @file    common_sched.h
+ *  @brief   Plugin for common sched.
+ */
+
+#ifndef _KS_PLUGIN_COMMON_SCHED_H
+#define _KS_PLUGIN_COMMON_SCHED_H
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+typedef unsigned long long tep_num_field_t;
+
+/** The type of the data field stored in the kshark_data_container object. */
+typedef int64_t ks_num_field_t;
+
+#define PREV_STATE_SHIFT	((int) ((sizeof(ks_num_field_t) - 1) * 8))
+
+#define PREV_STATE_MASK		(((ks_num_field_t) 1 << 8) - 1)
+
+#define PID_MASK		(((ks_num_field_t) 1 << PREV_STATE_SHIFT) - 1)
+
+static inline void plugin_sched_set_pid(ks_num_field_t *field,
+				 tep_num_field_t pid)
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
+static inline int plugin_sched_get_pid(ks_num_field_t field)
+{
+	return field & PID_MASK;
+}
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index 198ed49..3bb9bc2 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -22,36 +22,6 @@
 
 /** Plugin context instance. */
 
-//! @cond Doxygen_Suppress
-
-typedef unsigned long long tep_num_field_t;
-
-#define PREV_STATE_SHIFT	((int) ((sizeof(ks_num_field_t) - 1) * 8))
-
-#define PREV_STATE_MASK		(((ks_num_field_t) 1 << 8) - 1)
-
-#define PID_MASK		(((ks_num_field_t) 1 << PREV_STATE_SHIFT) - 1)
-
-//! @endcond
-
-static void plugin_sched_set_pid(ks_num_field_t *field,
-				 tep_num_field_t pid)
-{
-	*field &= ~PID_MASK;
-	*field = pid & PID_MASK;
-}
-
-/**
- * @brief Retrieve the PID value from the data field stored in the
- *	  kshark_data_container object.
- *
- * @param field: Input location for the data field.
- */
-__hidden int plugin_sched_get_pid(ks_num_field_t field)
-{
-	return field & PID_MASK;
-}
-
 /* Use the most significant byte to store the value of "prev_state". */
 static void plugin_sched_set_prev_state(ks_num_field_t *field,
 					tep_num_field_t prev_state)
diff --git a/src/plugins/sched_events.h b/src/plugins/sched_events.h
index 2c540fd..1032075 100644
--- a/src/plugins/sched_events.h
+++ b/src/plugins/sched_events.h
@@ -9,12 +9,13 @@
  *  @brief   Plugin for Sched events.
  */
 
-#ifndef _KS_PLUGIN_SHED_H
-#define _KS_PLUGIN_SHED_H
+#ifndef _KS_PLUGIN_SCHED_H
+#define _KS_PLUGIN_SCHED_H
 
 // KernelShark
 #include "libkshark.h"
 #include "libkshark-plugin.h"
+#include "plugins/common_sched.h"
 
 #ifdef __cplusplus
 extern "C" {
@@ -55,10 +56,6 @@ struct plugin_sched_context {
 
 KS_DECLARE_PLUGIN_CONTEXT_METHODS(struct plugin_sched_context)
 
-/** The type of the data field stored in the kshark_data_container object. */
-typedef int64_t ks_num_field_t;
-
-int plugin_sched_get_pid(ks_num_field_t field);
 
 int plugin_sched_get_prev_state(ks_num_field_t field);
 
-- 
2.17.1

