Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 639EAC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 Jan 2022 04:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiAJEoL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 23:44:11 -0500
Received: from mga05.intel.com ([192.55.52.43]:46025 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229841AbiAJEoK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 23:44:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641789850; x=1673325850;
  h=from:to:subject:date:message-id:in-reply-to:references;
  bh=4Jugqmk8ufb5EJ+AfwvGsKvZPVAjL4NMgxxxbxJZyqU=;
  b=Df6GRlvRZWpnUskZXmTt6EetivsBd/SmHN1bI0F2+jfS6crlSluAbY1h
   NuI8/RiIj4731aBE/UF8Jg+Qk4YWtkqFOAgSHWwbeWpGl9bbUn4+gUAPq
   juId9Sdyd6Uv0wggMc3F1ggnIlSxzd0LgkyfnmWGTLBVW/Y0i8gPR5owp
   UYGPTmW/7jajru9tcMYbLhxZHnKdpi03bX4kWdgVbP0eFkU59Bc95bTQd
   z8XOqZpwz9/ShcZDPWD+fRcvL5WqPjlrGg3BzsYLXoFkNwzpZ0+mKiMIL
   tVpTayJ6Ez90kdTLp0o/UZ8UniODEKDJHe3XMFA54z+Wbrr2WSiFLca6P
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="329492936"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="329492936"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 20:44:10 -0800
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="514542354"
Received: from intel-z97x-ud5h.sh.intel.com ([10.67.103.201])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 20:44:09 -0800
From:   Hongzhan Chen <hongzhan.chen@intel.com>
To:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: [PATCH V4 2/3] kernel-shark: Move common APIs and definitions out to avoid duplication
Date:   Sun,  9 Jan 2022 23:25:17 -0500
Message-Id: <20220110042518.9376-2-hongzhan.chen@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220110042518.9376-1-hongzhan.chen@intel.com>
References: <20220110042518.9376-1-hongzhan.chen@intel.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

To avoid code duplication, move some common APIs and definitions
out from plugin SchedEvent to share with other plugins.

Signed-off-by: Hongzhan Chen <hongzhan.chen@intel.com>

diff --git a/src/KsPlugins.cpp b/src/KsPlugins.cpp
index ad9f478..a288018 100644
--- a/src/KsPlugins.cpp
+++ b/src/KsPlugins.cpp
@@ -414,3 +414,24 @@ void eventFieldIntervalPlot(KsCppArgV *argvCpp,
 			  << exc.what() << std::endl;
 	}
 }
+
+/**
+ * @brief Distance between the click and the shape. Used to decide if
+ *	  the double click action must be executed.
+ *
+ * @param x: X coordinate of the click.
+ * @param y: Y coordinate of the click.
+ *
+ * @returns If the click is inside the box, the distance is zero.
+ *	    Otherwise infinity.
+ */
+double LatencyBox::distance(int x, int y) const
+{
+	if (x < pointX(0) || x > pointX(2))
+		return std::numeric_limits<double>::max();
+
+	if (y < pointY(0) || y > pointY(1))
+		return std::numeric_limits<double>::max();
+
+	return 0;
+}
diff --git a/src/KsPlugins.hpp b/src/KsPlugins.hpp
index d41d094..5288f57 100644
--- a/src/KsPlugins.hpp
+++ b/src/KsPlugins.hpp
@@ -13,6 +13,7 @@
 #define _KS_PLUGINS_H
 
 // C++
+#include <vector>
 #include <functional>
 
 // KernelShark
@@ -101,4 +102,57 @@ void eventFieldIntervalPlot(KsCppArgV *argvCpp,
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
+	double distance(int x, int y) const override;
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
index b73e45f..9119998 100644
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
+static KsMainWindow *ks4sched_ptr;
 
 /**
  * @brief Provide the plugin with a pointer to the KsMainWindow object (the GUI
@@ -32,72 +29,24 @@ static KsMainWindow *ks_ptr;
  */
 __hidden void *plugin_set_gui_ptr(void *gui_ptr)
 {
-	ks_ptr = static_cast<KsMainWindow *>(gui_ptr);
+	ks4sched_ptr = static_cast<KsMainWindow *>(gui_ptr);
 	return nullptr;
 }
 
 /**
- * This class represents the graphical element visualizing the latency between
- *  sched_waking and sched_switch events.
+ * This child class represents the graphical element visualizing the latency
+ * between sched_waking and sched_switch events. It is defined to re-implement
+ * the handler for double-click.
  */
-class LatencyBox : public Rectangle
+class SchedLatencyBox : public LatencyBox
 {
 	/** On double click do. */
 	void _doubleClick() const override
 	{
-		ks_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
-		ks_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
+		ks4sched_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
+		ks4sched_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
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
@@ -191,14 +140,14 @@ __hidden void plugin_draw(kshark_cpp_argv *argv_c,
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
index 0000000..40f6532
--- /dev/null
+++ b/src/plugins/common_sched.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ *               2021 Intel Inc, Hongzhan Chen <hongzhan.chen@intel.com>
+ */
+
+/**
+ *  @file    common_sched.h
+ *  @brief   Common definitions for sched plugins.
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
+	*field |= pid & PID_MASK;
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
index a2ba4b4..1032075 100644
--- a/src/plugins/sched_events.h
+++ b/src/plugins/sched_events.h
@@ -15,6 +15,7 @@
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

