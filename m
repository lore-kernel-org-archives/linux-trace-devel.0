Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0C7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Dec 2021 06:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbhLVG7X (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Dec 2021 01:59:23 -0500
Received: from mga03.intel.com ([134.134.136.65]:44048 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235912AbhLVG7W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Dec 2021 01:59:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640156362; x=1671692362;
  h=from:to:subject:date:message-id:in-reply-to:references;
  bh=hc8RSt4C1jjoZiNII/uTHR3kaMlz6KShZAYNvT0pdcA=;
  b=F2Pnrra0Qnpeb23Bg6MzTx7gnamCys4EwTiKO7cAWPRyw+VTPk6XURWK
   2CwTG8owTs5OkzmSVB3+YV1C6oLXZ5Is9Zlxla+8fmNf0lNt4VRQxpaop
   CP6mrF7NZqfsvxqalmgdfFxzrJaFBmgPFoHNevtvqHsHLQXXmtmGjdgNN
   MHRmLgls4BPU4noc8oq2x5VA7BjQMGKVccBLWmpRkcy8Rl6tObAKK2edv
   qqUwFqQo6lN8NBWEd4jHFxNlIXAEaS/ilwGPTHqIzDa2DChQDNtswwK5g
   wbhVpZOBsh2UB8O8tvoIQnh6aejLsVyxcFjJNjRb6uR0rVqlKc5w7Tqna
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240513543"
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="240513543"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 22:59:22 -0800
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="607310454"
Received: from intel-z97x-ud5h.sh.intel.com ([10.67.103.201])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 22:59:21 -0800
From:   Hongzhan Chen <hongzhan.chen@intel.com>
To:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: [PATCH v2 1/2] kernel-shark: Move common APIs and definitions out to avoid duplication
Date:   Wed, 22 Dec 2021 01:40:13 -0500
Message-Id: <20211222064014.4471-2-hongzhan.chen@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211222064014.4471-1-hongzhan.chen@intel.com>
References: <20211222064014.4471-1-hongzhan.chen@intel.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

To avoid code duplication, move some common APIs and definitions
out to create new files and share with other plugins.

Signed-off-by: Hongzhan Chen <hongzhan.chen@intel.com>
---
 src/plugins/CMakeLists.txt  |  2 +-
 src/plugins/CommonSched.hpp | 99 +++++++++++++++++++++++++++++++++++++
 src/plugins/SchedEvents.cpp | 87 +-------------------------------
 src/plugins/common_sched.c  | 37 ++++++++++++++
 src/plugins/common_sched.h  | 50 +++++++++++++++++++
 src/plugins/sched_events.c  | 37 +-------------
 src/plugins/sched_events.h  | 12 ++---
 7 files changed, 192 insertions(+), 132 deletions(-)
 create mode 100644 src/plugins/CommonSched.hpp
 create mode 100644 src/plugins/common_sched.c
 create mode 100644 src/plugins/common_sched.h

diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
index 3e170fa..15d71d3 100644
--- a/src/plugins/CMakeLists.txt
+++ b/src/plugins/CMakeLists.txt
@@ -41,7 +41,7 @@ set(PLUGIN_LIST "")
 if (Qt5Widgets_FOUND AND TT_FONT_FILE)
 
     BUILD_GUI_PLUGIN(NAME sched_events
-                     SOURCE sched_events.c SchedEvents.cpp)
+                     SOURCE common_sched.c sched_events.c SchedEvents.cpp)
     list(APPEND PLUGIN_LIST "sched_events")
 
     BUILD_GUI_PLUGIN(NAME event_field_plot
diff --git a/src/plugins/CommonSched.hpp b/src/plugins/CommonSched.hpp
new file mode 100644
index 0000000..e1b88e4
--- /dev/null
+++ b/src/plugins/CommonSched.hpp
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2021 Intel Inc, Hongzhan Chen <hongzhan.chen@intel.com>
+ */
+
+/**
+ *  @file    CommonSched.hpp
+ *  @brief   Tools for plot common sched.
+ */
+
+// C++
+#include <vector>
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plugin.h"
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
+__hidden void *plugin_set_gui_ptr(void *gui_ptr)
+{
+	ks_ptr = static_cast<KsMainWindow *>(gui_ptr);
+	return nullptr;
+}
+
+/**
+ * This class represents the graphical element visualizing the latency between
+ * two events such as sched_waking and sched_switch events for common Linux
+ * kernel or cobalt_switch_contexts for Xenomai.
+ */
+class LatencyBox : public Rectangle
+{
+	/** On double click do. */
+	void _doubleClick() const override
+	{
+		ks_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
+		ks_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
+	}
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
+static PlotObject *makeShape(std::vector<const Graph *> graph,
+			     std::vector<int> bins,
+			     std::vector<kshark_data_field_int64 *> data,
+			     Color col, float size)
+{
+	LatencyBox *rec = new LatencyBox;
+	rec->_data = data;
+
+	Point p0 = graph[0]->bin(bins[0])._base;
+	Point p1 = graph[0]->bin(bins[1])._base;
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
diff --git a/src/plugins/SchedEvents.cpp b/src/plugins/SchedEvents.cpp
index b73e45f..b0fb29c 100644
--- a/src/plugins/SchedEvents.cpp
+++ b/src/plugins/SchedEvents.cpp
@@ -11,94 +11,9 @@
  *	     preempted by another task.
  */
 
-// C++
-#include <vector>
-
 // KernelShark
-#include "libkshark.h"
-#include "libkshark-plugin.h"
 #include "plugins/sched_events.h"
-#include "KsPlotTools.hpp"
-#include "KsPlugins.hpp"
-#include "KsMainWindow.hpp"
-
-using namespace KsPlot;
-
-static KsMainWindow *ks_ptr;
-
-/**
- * @brief Provide the plugin with a pointer to the KsMainWindow object (the GUI
- * itself) such that the plugin can manipulate the GUI.
- */
-__hidden void *plugin_set_gui_ptr(void *gui_ptr)
-{
-	ks_ptr = static_cast<KsMainWindow *>(gui_ptr);
-	return nullptr;
-}
-
-/**
- * This class represents the graphical element visualizing the latency between
- *  sched_waking and sched_switch events.
- */
-class LatencyBox : public Rectangle
-{
-	/** On double click do. */
-	void _doubleClick() const override
-	{
-		ks_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
-		ks_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
-	}
-
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
-};
+#include "plugins/CommonSched.hpp"
 
 /*
  * Ideally, the sched_switch has to be the last trace event recorded before the
diff --git a/src/plugins/common_sched.c b/src/plugins/common_sched.c
new file mode 100644
index 0000000..446adc8
--- /dev/null
+++ b/src/plugins/common_sched.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2021 Intel Inc, Hongzhan Chen <hongzhan.chen@intel.com>
+ */
+
+/**
+ *  @file    common_sched.c
+ *  @brief
+ */
+
+// KernelShark
+#include "plugins/common_sched.h"
+
+void plugin_sched_set_pid(ks_num_field_t *field,
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
+__hidden int plugin_sched_get_pid(ks_num_field_t field)
+{
+	return field & PID_MASK;
+}
+
+/** Initialize the control interface of the plugin. */
+void *KSHARK_MENU_PLUGIN_INITIALIZER(void *gui_ptr)
+{
+	return plugin_set_gui_ptr(gui_ptr);
+}
diff --git a/src/plugins/common_sched.h b/src/plugins/common_sched.h
new file mode 100644
index 0000000..c504f3e
--- /dev/null
+++ b/src/plugins/common_sched.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2021 Intel Inc, Hongzhan Chen<hongzhan.chen@intel.com>
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
+// KernelShark
+#include "libkshark-plugin.h"
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
+void plugin_sched_set_pid(ks_num_field_t *field,
+				 tep_num_field_t pid);
+
+/**
+ * @brief Retrieve the PID value from the data field stored in the
+ *	  kshark_data_container object.
+ *
+ * @param field: Input location for the data field.
+ */
+int plugin_sched_get_pid(ks_num_field_t field);
+
+void *plugin_set_gui_ptr(void *gui_ptr);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index 198ed49..6add092 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -17,41 +17,12 @@
 #include <trace-cmd.h>
 
 // KernelShark
+#include "plugins/common_sched.h"
 #include "plugins/sched_events.h"
 #include "libkshark-tepdata.h"
 
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
@@ -230,9 +201,3 @@ int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
 
 	return ret;
 }
-
-/** Initialize the control interface of the plugin. */
-void *KSHARK_MENU_PLUGIN_INITIALIZER(void *gui_ptr)
-{
-	return plugin_set_gui_ptr(gui_ptr);
-}
diff --git a/src/plugins/sched_events.h b/src/plugins/sched_events.h
index 2c540fd..c2b0ff7 100644
--- a/src/plugins/sched_events.h
+++ b/src/plugins/sched_events.h
@@ -9,12 +9,12 @@
  *  @brief   Plugin for Sched events.
  */
 
-#ifndef _KS_PLUGIN_SHED_H
-#define _KS_PLUGIN_SHED_H
+#ifndef _KS_PLUGIN_SCHED_H
+#define _KS_PLUGIN_SCHED_H
 
 // KernelShark
 #include "libkshark.h"
-#include "libkshark-plugin.h"
+#include "plugins/common_sched.h"
 
 #ifdef __cplusplus
 extern "C" {
@@ -55,18 +55,12 @@ struct plugin_sched_context {
 
 KS_DECLARE_PLUGIN_CONTEXT_METHODS(struct plugin_sched_context)
 
-/** The type of the data field stored in the kshark_data_container object. */
-typedef int64_t ks_num_field_t;
-
-int plugin_sched_get_pid(ks_num_field_t field);
 
 int plugin_sched_get_prev_state(ks_num_field_t field);
 
 void plugin_draw(struct kshark_cpp_argv *argv, int sd, int pid,
 		 int draw_action);
 
-void *plugin_set_gui_ptr(void *gui_ptr);
-
 #ifdef __cplusplus
 }
 #endif
-- 
2.17.1

