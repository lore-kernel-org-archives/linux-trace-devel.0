Return-Path: <SRS0=L+0X=LS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34925 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbeIDUS1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 Sep 2018 16:18:27 -0400
Received: by mail-wm0-f44.google.com with SMTP id o18-v6so4820563wmc.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 04 Sep 2018 08:52:44 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/7] kernel-shark-qt: Add C++/C conversion for args of a plugin draw function.
Date: Tue,  4 Sep 2018 18:52:14 +0300
Message-Id: <20180904155218.32518-4-y.karadz@gmail.com>
In-Reply-To: <20180904155218.32518-1-y.karadz@gmail.com>
References: <20180904155218.32518-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The draw function of a plugin has a type declared in C. However, the
function needs to access some high level objects, defined in the C++
libraries. This patch adds instruments for converting the arguments
of the plugin's draw function from C++ to C and from C to C++.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/KsPlugins.hpp | 51 +++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 kernel-shark-qt/src/KsPlugins.hpp

diff --git a/kernel-shark-qt/src/KsPlugins.hpp b/kernel-shark-qt/src/KsPlugins.hpp
new file mode 100644
index 00000000..3955cdfd
--- /dev/null
+++ b/kernel-shark-qt/src/KsPlugins.hpp
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+/**
+  *  @file    KsPlugins.hpp
+  *  @brief   KernelShark C++ plugin declarations.
+  */
+
+#ifndef _KS_PLUGINS_H
+#define _KS_PLUGINS_H
+
+// KernelShark
+#include "libkshark-model.h"
+#include "KsPlotTools.hpp"
+
+/**
+ * Structure representing the vector of C++ arguments of the drawing function
+ * of a plugin.
+ */
+struct KsCppArgV {
+	/** Pointer to the model descriptor object. */
+	kshark_trace_histo	*_histo;
+
+	/** Pointer to the graph object. */
+	KsPlot::Graph		*_graph;
+
+	/**
+	 * Pointer to the list of shapes. All shapes created by the plugin
+	 * will be added to this list.
+	 */
+	KsPlot::PlotObjList	*_shapes;
+
+	/**
+	 * Convert the "this" pointer of the C++ argument vector into a
+	 * C pointer.
+	 */
+	kshark_cpp_argv *toC()
+	{
+		return reinterpret_cast<kshark_cpp_argv *>(this);
+	}
+};
+
+/**
+ * Macro used to convert a C pointer into a pointer to KsCppArgV (C++ struct).
+ */
+#define KS_ARGV_TO_CPP(a) (reinterpret_cast<KsCppArgV *>(a))
+
+#endif
-- 
2.17.1
