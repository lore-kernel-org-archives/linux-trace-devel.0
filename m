Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pg0-f65.google.com ([74.125.83.65]:44980 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752278AbeBFItJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:09 -0500
Received: by mail-pg0-f65.google.com with SMTP id r1so820523pgn.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:09 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 01/24] trace-cmd: Rename libparsevent to libtraceevent
Date: Tue,  6 Feb 2018 10:48:43 +0200
Message-Id: <20180206084906.9854-2-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This simple patch renames libparsevent to libtraceevent in order to trace-cmd to
be consistent with the kernel.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index a5d2c38..a3a60bf 100644
--- a/Makefile
+++ b/Makefile
@@ -351,8 +351,8 @@ TRACE_GRAPH_MAIN_OBJS = trace-graph-main.o $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS)
 KERNEL_SHARK_OBJS = $(TRACE_VIEW_OBJS) $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS) \
 	trace-capture.o kernel-shark.o
 
-PEVENT_LIB_OBJS = event-parse.o trace-seq.o parse-filter.o parse-utils.o str_error_r.o
-TCMD_LIB_OBJS = $(PEVENT_LIB_OBJS) trace-util.o trace-input.o trace-ftrace.o \
+TRACEEVENT_LIB_OBJS = event-parse.o trace-seq.o parse-filter.o parse-utils.o str_error_r.o
+TCMD_LIB_OBJS = $(TRACEEVENT_LIB_OBJS) trace-util.o trace-input.o trace-ftrace.o \
 			trace-output.o trace-recorder.o \
 			trace-usage.o trace-blk-hack.o \
 			kbuffer-parse.o event-plugin.o trace-hooks.o \
@@ -377,7 +377,7 @@ PLUGINS := $(PLUGIN_OBJS:.o=.so)
 ALL_OBJS = $(TRACE_CMD_OBJS) $(KERNEL_SHARK_OBJS) $(TRACE_VIEW_MAIN_OBJS) \
 	$(TRACE_GRAPH_MAIN_OBJS) $(TCMD_LIB_OBJS) $(PLUGIN_OBJS)
 
-CMD_TARGETS = trace_plugin_dir trace_python_dir tc_version.h libparsevent.a $(LIB_FILE) \
+CMD_TARGETS = trace_plugin_dir trace_python_dir tc_version.h libtraceevent.a $(LIB_FILE) \
 	trace-cmd  $(PLUGINS) $(BUILD_PYTHON)
 
 GUI_TARGETS = ks_version.h trace-graph trace-view kernelshark
@@ -423,10 +423,10 @@ kernelshark: libtracecmd.a
 trace-view: libtracecmd.a
 trace-graph: libtracecmd.a
 
-libparsevent.so: $(PEVENT_LIB_OBJS)
+libtraceevent.so: $(TRACEEVENT_LIB_OBJS)
 	$(Q)$(do_compile_shared_library)
 
-libparsevent.a: $(PEVENT_LIB_OBJS)
+libtraceevent.a: $(TRACEEVENT_LIB_OBJS)
 	$(Q)$(do_build_static_lib)
 
 $(TCMD_LIB_OBJS): %.o: $(src)/%.c
@@ -438,7 +438,7 @@ libtracecmd.so: $(TCMD_LIB_OBJS)
 libtracecmd.a: $(TCMD_LIB_OBJS)
 	$(Q)$(do_build_static_lib)
 
-libs: libtracecmd.so libparsevent.so
+libs: libtracecmd.so libtraceevent.so
 
 trace-util.o: trace_plugin_dir
 
@@ -609,7 +609,7 @@ install_gui: install_cmd gui
 
 install_libs: libs
 	$(Q)$(call do_install,libtracecmd.so,$(libdir_SQ))
-	$(Q)$(call do_install,libparsevent.so,$(libdir_SQ))
+	$(Q)$(call do_install,libtraceevent.so,$(libdir_SQ))
 	$(Q)$(call do_install,event-parse.h,$(includedir_SQ))
 	$(Q)$(call do_install,trace-cmd.h,$(includedir_SQ))
 
-- 
2.14.1
