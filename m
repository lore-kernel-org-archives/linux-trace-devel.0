Return-Path: <SRS0=o0t1=NS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bl2nam02on0067.outbound.protection.outlook.com ([104.47.38.67]:36896
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727630AbeKHBqS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 20:46:18 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 7/8] kernel-shark-qt: Add "Missed events" plugin for
 KernelShark
Date: Wed, 7 Nov 2018 16:14:39 +0000
Message-ID: <20181107161410.22507-8-ykaradzhov@vmware.com>
References: <20181107161410.22507-1-ykaradzhov@vmware.com>
In-Reply-To: <20181107161410.22507-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The "Missed events" plugin displays a special marker that indicates
the position (in time) of the missed (overwritten) data.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/plugins/CMakeLists.txt   |   6 +-
 kernel-shark-qt/src/plugins/MissedEvents.cpp | 149 +++++++++++++++++++
 kernel-shark-qt/src/plugins/missed_events.c  |  41 +++++
 kernel-shark-qt/src/plugins/missed_events.h  |  30 ++++
 4 files changed, 225 insertions(+), 1 deletion(-)
 create mode 100644 kernel-shark-qt/src/plugins/MissedEvents.cpp
 create mode 100644 kernel-shark-qt/src/plugins/missed_events.c
 create mode 100644 kernel-shark-qt/src/plugins/missed_events.h

diff --git a/kernel-shark-qt/src/plugins/CMakeLists.txt b/kernel-shark-qt/s=
rc/plugins/CMakeLists.txt
index 2d7251d..853214e 100644
--- a/kernel-shark-qt/src/plugins/CMakeLists.txt
+++ b/kernel-shark-qt/src/plugins/CMakeLists.txt
@@ -24,7 +24,11 @@ BUILD_PLUGIN(NAME sched_events
 list(APPEND PLUGIN_LIST "sched_events default") # This plugin will be load=
ed by default
 # list(APPEND PLUGIN_LIST "sched_events") # This plugin isn't loaded by de=
fault
=20
-install(TARGETS sched_events
+BUILD_PLUGIN(NAME missed_events
+             SOURCE missed_events.c MissedEvents.cpp)
+list(APPEND PLUGIN_LIST "missed_events default") # This plugin will be loa=
ded by default
+
+install(TARGETS sched_events missed_events
         LIBRARY DESTINATION /usr/local/lib/kshark/)
=20
 set(PLUGINS ${PLUGIN_LIST} PARENT_SCOPE)
diff --git a/kernel-shark-qt/src/plugins/MissedEvents.cpp b/kernel-shark-qt=
/src/plugins/MissedEvents.cpp
new file mode 100644
index 0000000..05dfcb5
--- /dev/null
+++ b/kernel-shark-qt/src/plugins/MissedEvents.cpp
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    MissedEvents.cpp
+ *  @brief   Plugin for visualization of events, missed due to overflow of=
 the ring buffer.
+ */
+
+// C++
+#include<iostream>
+
+// KernelShark
+#include "libkshark.h"
+#include "plugins/missed_events.h"
+#include "KsPlotTools.hpp"
+#include "KsPlugins.hpp"
+
+using namespace KsPlot;
+
+/**
+ * This class represents the graphical element of the KernelShark marker f=
or
+ * Missed events.
+ */
+class MissedEventsMark : public PlotObject {
+public:
+	/** Create a default Missed events marker. */
+	MissedEventsMark() : _base(0, 0), _height(0)
+	{
+		_color =3D {0, 0, 255};
+		_size =3D 2;
+	}
+
+	/**
+	 * @brief Create and position a Missed events marker.
+	 *
+	 * @param p: Base point of the marker.
+	 * @param h: vertical size (height) of the marker.
+	 */
+	MissedEventsMark(const Point &p, int h)
+	: _base(p.x(), p.y()), _height(h)
+	{
+		_color =3D {0, 0, 255};
+		_size =3D 2;
+	}
+
+	/** Set the Base point of the marker. */
+	void setBase(const Point &p) {_base.set(p.x(), p.y());}
+
+	/** Set the vertical size (height) point of the marker. */
+	void setHeight(int h) {_height =3D h;}
+
+private:
+	/** Base point of the Mark's line. */
+	Point	_base;
+
+	/** The vertical size (height) of the Mark. */
+	int	_height;
+
+	void _draw(const Color &col, float size =3D 1.) const override;
+};
+
+void MissedEventsMark::_draw(const Color &col, float size) const
+{
+	Point p(_base.x(), _base.y() - _height);
+	drawLine(_base, p, col, size);
+
+	Rectangle rec;
+	rec.setPoint(0, p.x(), p.y());
+	rec.setPoint(1, p.x() - _height / 4, p.y());
+	rec.setPoint(2, p.x() - _height / 4, p.y() + _height / 4);
+	rec.setPoint(3, p.x(), p.y() + _height / 4);
+	rec._color =3D col;
+	rec.draw();
+}
+
+//! @cond Doxygen_Suppress
+
+#define PLUGIN_MAX_ENTRIES		10000
+
+#define KS_TASK_COLLECTION_MARGIN	25
+
+//! @endcond
+
+static void pluginDraw(kshark_context *kshark_ctx,
+		       KsCppArgV *argvCpp,
+		       int val, int draw_action)
+{
+	int height =3D argvCpp->_graph->getHeight();
+	const kshark_entry *entry(nullptr);
+	MissedEventsMark *mark;
+	ssize_t index;
+
+	int nBins =3D argvCpp->_graph->size();
+	for (int bin =3D 0; bin < nBins; ++bin) {
+		if (draw_action =3D=3D KSHARK_PLUGIN_TASK_DRAW)
+			entry =3D ksmodel_get_task_missed_events(argvCpp->_histo,
+							       bin, val,
+							       nullptr,
+							       &index);
+		if (draw_action =3D=3D KSHARK_PLUGIN_CPU_DRAW)
+			entry =3D ksmodel_get_cpu_missed_events(argvCpp->_histo,
+							      bin, val,
+							      nullptr,
+							      &index);
+
+		if (entry) {
+			mark =3D new MissedEventsMark(argvCpp->_graph->getBin(bin)._base,
+						    height);
+
+			argvCpp->_shapes->push_front(mark);
+		}
+	}
+}
+
+/**
+ * @brief Plugin's draw function.
+ *
+ * @param argv_c: A C pointer to be converted to KsCppArgV (C++ struct).
+ * @param val: Process or CPU Id value.
+ * @param draw_action: Draw action identifier.
+ */
+void draw_missed_events(kshark_cpp_argv *argv_c,
+			int val, int draw_action)
+{
+	kshark_context *kshark_ctx(NULL);
+
+	if (!kshark_instance(&kshark_ctx))
+		return;
+
+	KsCppArgV *argvCpp =3D KS_ARGV_TO_CPP(argv_c);
+
+	/*
+	 * Plotting the "Missed events" makes sense only in the case of a deep
+	 * zoom. Here we set a threshold based on the total number of entries
+	 * being visualized by the model.
+	 * Don't be afraid to play with different values for this threshold.
+	 */
+	if (argvCpp->_histo->tot_count > PLUGIN_MAX_ENTRIES)
+		return;
+
+	try {
+		pluginDraw(kshark_ctx, argvCpp, val, draw_action);
+	} catch (const std::exception &exc) {
+		std::cerr << "Exception in MissedEvents\n" << exc.what();
+	}
+}
diff --git a/kernel-shark-qt/src/plugins/missed_events.c b/kernel-shark-qt/=
src/plugins/missed_events.c
new file mode 100644
index 0000000..cf652bf
--- /dev/null
+++ b/kernel-shark-qt/src/plugins/missed_events.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+/**
+ *  @file    missed_events.c
+ *  @brief   Plugin for visualization of missed events due to overflow of =
the
+ *	     ring buffer.
+ */
+
+// KernelShark
+#include "plugins/missed_events.h"
+
+static void nop_action(struct kshark_context *kshark_ctx,
+				struct tep_record *record,
+				struct kshark_entry *entry)
+{}
+
+/** Load this plugin. */
+int KSHARK_PLUGIN_INITIALIZER(struct kshark_context *kshark_ctx)
+{
+	kshark_register_event_handler(&kshark_ctx->event_handlers,
+				      KS_EVENT_OVERFLOW,
+				      nop_action,
+				      draw_missed_events);
+
+	return 1;
+}
+
+/** Unload this plugin. */
+int KSHARK_PLUGIN_DEINITIALIZER(struct kshark_context *kshark_ctx)
+{
+	kshark_unregister_event_handler(&kshark_ctx->event_handlers,
+					KS_EVENT_OVERFLOW,
+					nop_action,
+					draw_missed_events);
+
+	return 1;
+}
diff --git a/kernel-shark-qt/src/plugins/missed_events.h b/kernel-shark-qt/=
src/plugins/missed_events.h
new file mode 100644
index 0000000..e05d79a
--- /dev/null
+++ b/kernel-shark-qt/src/plugins/missed_events.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <ykaradzov@vmware.com>
+ */
+
+/**
+ *  @file    missed_events.h
+ *  @brief   Plugin for visualization of missed events due to overflow of =
the
+ *	     ring buffer.
+ */
+
+#ifndef _KS_PLUGIN_M_EVTS_H
+#define _KS_PLUGIN_M_EVTS_H
+
+// KernelShark
+#include "libkshark.h"
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void draw_missed_events(struct kshark_cpp_argv *argv,
+			int pid, int draw_action);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
--=20
2.17.1
