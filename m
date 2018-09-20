Return-Path: <SRS0=7BWw=MC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f48.google.com ([209.85.221.48]:39210 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbeITWkm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Sep 2018 18:40:42 -0400
Received: by mail-wr1-f48.google.com with SMTP id s14-v6so10119722wrw.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Sep 2018 09:56:18 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 3/8] kernel-shark-qt: Add C++/C conversion for args of a plugin draw function.
Date: Thu, 20 Sep 2018 19:55:39 +0300
Message-Id: <20180920165544.17579-4-y.karadz@gmail.com>
In-Reply-To: <20180920165544.17579-1-y.karadz@gmail.com>
References: <20180920165544.17579-1-y.karadz@gmail.com>
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
index 0000000..3955cdf
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
