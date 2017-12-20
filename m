Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33650 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755946AbdLTSIK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 13:08:10 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH 08/18] trace-cmd: Move libtracecmd *.c files in lib/trace-cmd
Date: Wed, 20 Dec 2017 20:07:38 +0200
Message-Id: <20171220180748.17273-9-vladislav.valtchev@gmail.com>
In-Reply-To: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
References: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch moves all the source files belonging to the trace-cmd library into
the dedicated directory lib/trace-cmd. The build system has been updated to
support this new directory structure by adding a dedicated Makefile in
lib/trace-cmd and by making the parent Makefile to invoke it.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile                                           | 54 ++++++++++------------
 lib/trace-cmd/Makefile                             | 45 ++++++++++++++++++
 trace-blk-hack.c => lib/trace-cmd/trace-blk-hack.c |  0
 trace-ftrace.c => lib/trace-cmd/trace-ftrace.c     |  0
 trace-hash.c => lib/trace-cmd/trace-hash.c         |  0
 trace-hooks.c => lib/trace-cmd/trace-hooks.c       |  0
 trace-input.c => lib/trace-cmd/trace-input.c       |  0
 trace-recorder.c => lib/trace-cmd/trace-recorder.c |  0
 trace-util.c => lib/trace-cmd/trace-util.c         |  0
 9 files changed, 70 insertions(+), 29 deletions(-)
 create mode 100644 lib/trace-cmd/Makefile
 rename trace-blk-hack.c => lib/trace-cmd/trace-blk-hack.c (100%)
 rename trace-ftrace.c => lib/trace-cmd/trace-ftrace.c (100%)
 rename trace-hash.c => lib/trace-cmd/trace-hash.c (100%)
 rename trace-hooks.c => lib/trace-cmd/trace-hooks.c (100%)
 rename trace-input.c => lib/trace-cmd/trace-input.c (100%)
 rename trace-recorder.c => lib/trace-cmd/trace-recorder.c (100%)
 rename trace-util.c => lib/trace-cmd/trace-util.c (100%)

diff --git a/Makefile b/Makefile
index a3cce82..8b34705 100644
--- a/Makefile
+++ b/Makefile
@@ -185,7 +185,9 @@ LIBTRACEEVENT_DIR = $(obj)/lib/traceevent
 LIBTRACEEVENT_STATIC = $(LIBTRACEEVENT_DIR)/libtraceevent.a
 LIBTRACEEVENT_SHARED = $(LIBTRACEEVENT_DIR)/libtraceevent.so
 
-LIB_FILE = libtracecmd.a
+LIBTRACECMD_DIR = $(obj)/lib/trace-cmd
+LIBTRACECMD_STATIC = $(LIBTRACECMD_DIR)/libtracecmd.a
+LIBTRACECMD_SHARED = $(LIBTRACECMD_DIR)/libtracecmd.so
 
 PACKAGES= gtk+-2.0 libxml-2.0 gthread-2.0
 
@@ -300,8 +302,9 @@ TRACE_GUI_OBJS = trace-filter.o trace-compat.o trace-filter-hash.o trace-dialog.
 		trace-xml.o
 TRACE_CMD_OBJS = trace-cmd.o trace-record.o trace-read.o trace-split.o trace-listen.o \
 	 trace-stack.o trace-hist.o trace-mem.o trace-snapshot.o trace-stat.o \
-	 trace-hash.o trace-profile.o trace-stream.o trace-record.o trace-restore.o \
-	 trace-check-events.o trace-show.o trace-list.o
+	 trace-profile.o trace-stream.o trace-record.o trace-restore.o \
+	 trace-check-events.o trace-show.o trace-list.o  \
+	 trace-output.o trace-usage.o trace-msg.o
 TRACE_VIEW_OBJS = trace-view.o trace-view-store.o
 TRACE_GRAPH_OBJS = trace-graph.o trace-plot.o trace-plot-cpu.o trace-plot-task.o
 TRACE_VIEW_MAIN_OBJS = trace-view-main.o $(TRACE_VIEW_OBJS) $(TRACE_GUI_OBJS)
@@ -309,11 +312,6 @@ TRACE_GRAPH_MAIN_OBJS = trace-graph-main.o $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS)
 KERNEL_SHARK_OBJS = $(TRACE_VIEW_OBJS) $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS) \
 	trace-capture.o kernel-shark.o
 
-TCMD_LIB_OBJS = trace-util.o trace-input.o trace-ftrace.o \
-			trace-output.o trace-recorder.o \
-			trace-usage.o trace-blk-hack.o \
-			trace-hooks.o trace-msg.o
-
 PLUGIN_OBJS =
 PLUGIN_OBJS += plugin_jbd2.o
 PLUGIN_OBJS += plugin_hrtimer.o
@@ -331,9 +329,9 @@ PLUGIN_OBJS += plugin_tlb.o
 PLUGINS := $(PLUGIN_OBJS:.o=.so)
 
 ALL_OBJS = $(TRACE_CMD_OBJS) $(KERNEL_SHARK_OBJS) $(TRACE_VIEW_MAIN_OBJS) \
-	$(TRACE_GRAPH_MAIN_OBJS) $(TCMD_LIB_OBJS) $(PLUGIN_OBJS)
+	$(TRACE_GRAPH_MAIN_OBJS) $(PLUGIN_OBJS)
 
-CMD_TARGETS = trace_plugin_dir trace_python_dir tc_version.h $(LIB_FILE) \
+CMD_TARGETS = trace_plugin_dir trace_python_dir tc_version.h \
 	trace-cmd  $(PLUGINS) $(BUILD_PYTHON)
 
 GUI_TARGETS = ks_version.h trace-graph trace-view kernelshark
@@ -374,10 +372,10 @@ trace-view: $(TRACE_VIEW_MAIN_OBJS)
 trace-graph: $(TRACE_GRAPH_MAIN_OBJS)
 	$(Q)$(G)$(do_app_build)
 
-trace-cmd: libtracecmd.a $(LIBTRACEEVENT_STATIC)
-kernelshark: libtracecmd.a $(LIBTRACEEVENT_STATIC)
-trace-view: libtracecmd.a $(LIBTRACEEVENT_STATIC)
-trace-graph: libtracecmd.a $(LIBTRACEEVENT_STATIC)
+trace-cmd: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC)
+kernelshark: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC)
+trace-view: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC)
+trace-graph: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC)
 
 $(LIBTRACEEVENT_SHARED): force
 	$(Q)$(MAKE) -C $(src)/lib/traceevent libtraceevent.so
@@ -385,21 +383,18 @@ $(LIBTRACEEVENT_SHARED): force
 $(LIBTRACEEVENT_STATIC): force
 	$(Q)$(MAKE) -C $(src)/lib/traceevent libtraceevent.a
 
+$(LIBTRACECMD_STATIC): force trace_plugin_dir
+	$(Q)$(MAKE) -C $(src)/lib/trace-cmd libtracecmd.a
+
+$(LIBTRACECMD_SHARED): force trace_plugin_dir
+	$(Q)$(MAKE) -C $(src)/lib/trace-cmd libtracecmd.so
+
 libtraceevent.so: $(LIBTRACEEVENT_SHARED)
 libtraceevent.a: $(LIBTRACEEVENT_STATIC)
+libtracecmd.a: $(LIBTRACECMD_STATIC)
+libtracecmd.so: $(LIBTRACECMD_SHARED)
 
-$(TCMD_LIB_OBJS): %.o: $(src)/%.c
-	$(Q)$(do_fpic_compile)
-
-libtracecmd.so: $(TCMD_LIB_OBJS)
-	$(Q)$(do_compile_shared_library)
-
-libtracecmd.a: $(TCMD_LIB_OBJS)
-	$(Q)$(do_build_static_lib)
-
-libs: libtracecmd.so $(LIBTRACEEVENT_SHARED)
-
-trace-util.o: trace_plugin_dir
+libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED)
 
 $(PLUGIN_OBJS): %.o : $(src)/%.c
 	$(Q)$(do_compile_plugin_obj)
@@ -562,7 +557,7 @@ install_gui: install_cmd gui
 	$(Q)$(call do_install,kernelshark,$(bindir_SQ))
 
 install_libs: libs
-	$(Q)$(call do_install,libtracecmd.so,$(libdir_SQ))
+	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
 	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ))
 	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ))
 	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ))
@@ -580,6 +575,7 @@ clean:
 	$(RM) *.o *~ $(TARGETS) *.a *.so ctracecmd_wrap.c .*.d
 	$(RM) tags TAGS cscope*
 	$(MAKE) -C $(src)/lib/traceevent clean
+	$(MAKE) -C $(src)/lib/trace-cmd clean
 
 
 ##### PYTHON STUFF #####
@@ -597,9 +593,9 @@ PYGTK_CFLAGS = `pkg-config --cflags pygtk-2.0`
 ctracecmd.so: $(TCMD_LIB_OBJS) ctracecmd.i
 	swig -Wall -python -noproxy -I$(src)/include/traceevent -I$(src)/include/trace-cmd ctracecmd.i
 	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
-	$(CC) --shared $(TCMD_LIB_OBJS) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so
+	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so
 
-ctracecmdgui.so: $(TRACE_VIEW_OBJS) $(LIB_FILE)
+ctracecmdgui.so: $(TRACE_VIEW_OBJS) $(LIBTRACECMD_STATIC)
 	swig -Wall -python -noproxy ctracecmdgui.i
 	$(CC) -fpic -c  $(CPPFLAGS) $(CFLAGS) $(INCLUDES) $(PYTHON_INCLUDES) $(PYGTK_CFLAGS) ctracecmdgui_wrap.c
 	$(CC) --shared $^ $(LDFLAGS) $(LIBS) $(CONFIG_LIBS) ctracecmdgui_wrap.o -o ctracecmdgui.so
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
new file mode 100644
index 0000000..dcb5cd5
--- /dev/null
+++ b/lib/trace-cmd/Makefile
@@ -0,0 +1,45 @@
+
+
+include $(src)/scripts/utils.mk
+
+DEFAULT_TARGET = libtracecmd.a
+
+OBJS =
+OBJS += trace-hash.o
+OBJS += trace-hooks.o
+OBJS += trace-input.o
+OBJS += trace-recorder.o
+OBJS += trace-util.o
+
+# Additional util objects
+OBJS += trace-blk-hack.o
+OBJS += trace-ftrace.o
+
+DEPS := $(OBJS:%.o=.%.d)
+
+all: $(DEFAULT_TARGET)
+
+libtracecmd.a: $(OBJS)
+	$(Q)$(call do_build_static_lib)
+
+libtracecmd.so: $(OBJS)
+	$(Q)$(call do_compile_shared_library)
+
+%.o: %.c
+	$(Q)$(call do_fpic_compile)
+
+$(DEPS): .%.d: %.c
+	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
+
+$(OBJS): %.o : .%.d
+
+dep_includes := $(wildcard $(DEPS))
+
+ifneq ($(dep_includes),)
+  include $(dep_includes)
+endif
+
+clean:
+	$(RM) *.a *.so *.o .*.d
+
+.PHONY: clean
diff --git a/trace-blk-hack.c b/lib/trace-cmd/trace-blk-hack.c
similarity index 100%
rename from trace-blk-hack.c
rename to lib/trace-cmd/trace-blk-hack.c
diff --git a/trace-ftrace.c b/lib/trace-cmd/trace-ftrace.c
similarity index 100%
rename from trace-ftrace.c
rename to lib/trace-cmd/trace-ftrace.c
diff --git a/trace-hash.c b/lib/trace-cmd/trace-hash.c
similarity index 100%
rename from trace-hash.c
rename to lib/trace-cmd/trace-hash.c
diff --git a/trace-hooks.c b/lib/trace-cmd/trace-hooks.c
similarity index 100%
rename from trace-hooks.c
rename to lib/trace-cmd/trace-hooks.c
diff --git a/trace-input.c b/lib/trace-cmd/trace-input.c
similarity index 100%
rename from trace-input.c
rename to lib/trace-cmd/trace-input.c
diff --git a/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
similarity index 100%
rename from trace-recorder.c
rename to lib/trace-cmd/trace-recorder.c
diff --git a/trace-util.c b/lib/trace-cmd/trace-util.c
similarity index 100%
rename from trace-util.c
rename to lib/trace-cmd/trace-util.c
-- 
2.14.1
