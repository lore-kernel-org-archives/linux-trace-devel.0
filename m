Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wm0-f66.google.com ([74.125.82.66]:45337 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755687AbdLTSIH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Dec 2017 13:08:07 -0500
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH 06/18] trace-cmd: Move libtraceevent *.c files in lib/traceevent
Date: Wed, 20 Dec 2017 20:07:36 +0200
Message-Id: <20171220180748.17273-7-vladislav.valtchev@gmail.com>
In-Reply-To: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
References: <20171220180748.17273-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch moves all the files belonging to the traceevent lib in a dedicated
directory. The build system has been updated to support this by introducing
a Makefile in lib/traceevent and by making the parent Makefile to run it with
the classic recursive make approach.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile                                          | 42 ++++++++++++---------
 lib/traceevent/Makefile                           | 45 +++++++++++++++++++++++
 event-parse.c => lib/traceevent/event-parse.c     |  0
 event-plugin.c => lib/traceevent/event-plugin.c   |  0
 kbuffer-parse.c => lib/traceevent/kbuffer-parse.c |  0
 parse-filter.c => lib/traceevent/parse-filter.c   |  0
 parse-utils.c => lib/traceevent/parse-utils.c     |  0
 str_error_r.c => lib/traceevent/str_error_r.c     |  0
 trace-seq.c => lib/traceevent/trace-seq.c         |  0
 9 files changed, 70 insertions(+), 17 deletions(-)
 create mode 100644 lib/traceevent/Makefile
 rename event-parse.c => lib/traceevent/event-parse.c (100%)
 rename event-plugin.c => lib/traceevent/event-plugin.c (100%)
 rename kbuffer-parse.c => lib/traceevent/kbuffer-parse.c (100%)
 rename parse-filter.c => lib/traceevent/parse-filter.c (100%)
 rename parse-utils.c => lib/traceevent/parse-utils.c (100%)
 rename str_error_r.c => lib/traceevent/str_error_r.c (100%)
 rename trace-seq.c => lib/traceevent/trace-seq.c (100%)

diff --git a/Makefile b/Makefile
index 6f502e7..646ff2d 100644
--- a/Makefile
+++ b/Makefile
@@ -180,7 +180,11 @@ bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
 plugin_dir_SQ = $(subst ','\'',$(plugin_dir))
 python_dir_SQ = $(subst ','\'',$(python_dir))
 
-LIBS = -L. -ltracecmd -ldl
+LIBS = -L. -ldl
+LIBTRACEEVENT_DIR = $(obj)/lib/traceevent
+LIBTRACEEVENT_STATIC = $(LIBTRACEEVENT_DIR)/libtraceevent.a
+LIBTRACEEVENT_SHARED = $(LIBTRACEEVENT_DIR)/libtraceevent.so
+
 LIB_FILE = libtracecmd.a
 
 PACKAGES= gtk+-2.0 libxml-2.0 gthread-2.0
@@ -231,7 +235,7 @@ include scripts/utils.mk
 TRACECMD_VERSION = $(TC_VERSION).$(TC_PATCHLEVEL).$(TC_EXTRAVERSION)
 KERNELSHARK_VERSION = $(KS_VERSION).$(KS_PATCHLEVEL).$(KS_EXTRAVERSION)
 
-INCLUDES = -I. -I ./include -I $(srctree)/../../include $(CONFIG_INCLUDES)
+INCLUDES = -I$(src) -I $(src)/include -I $(srctree)/../../include $(CONFIG_INCLUDES)
 INCLUDES += -I$(src)/include/traceevent
 INCLUDES += -I$(src)/include/trace-cmd
 INCLUDES += -I$(src)/lib/traceevent/include
@@ -243,6 +247,8 @@ CFLAGS ?= -g -Wall
 CPPFLAGS ?=
 LDFLAGS ?=
 
+export CFLAGS
+
 # Required CFLAGS
 override CFLAGS += -D_GNU_SOURCE
 
@@ -302,12 +308,10 @@ TRACE_GRAPH_MAIN_OBJS = trace-graph-main.o $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS)
 KERNEL_SHARK_OBJS = $(TRACE_VIEW_OBJS) $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS) \
 	trace-capture.o kernel-shark.o
 
-TRACEEVENT_LIB_OBJS = event-parse.o trace-seq.o parse-filter.o parse-utils.o str_error_r.o
-TCMD_LIB_OBJS = $(TRACEEVENT_LIB_OBJS) trace-util.o trace-input.o trace-ftrace.o \
+TCMD_LIB_OBJS = trace-util.o trace-input.o trace-ftrace.o \
 			trace-output.o trace-recorder.o \
 			trace-usage.o trace-blk-hack.o \
-			kbuffer-parse.o event-plugin.o trace-hooks.o \
-			trace-msg.o
+			trace-hooks.o trace-msg.o
 
 PLUGIN_OBJS =
 PLUGIN_OBJS += plugin_jbd2.o
@@ -328,7 +332,7 @@ PLUGINS := $(PLUGIN_OBJS:.o=.so)
 ALL_OBJS = $(TRACE_CMD_OBJS) $(KERNEL_SHARK_OBJS) $(TRACE_VIEW_MAIN_OBJS) \
 	$(TRACE_GRAPH_MAIN_OBJS) $(TCMD_LIB_OBJS) $(PLUGIN_OBJS)
 
-CMD_TARGETS = trace_plugin_dir trace_python_dir tc_version.h libtraceevent.a $(LIB_FILE) \
+CMD_TARGETS = trace_plugin_dir trace_python_dir tc_version.h $(LIB_FILE) \
 	trace-cmd  $(PLUGINS) $(BUILD_PYTHON)
 
 GUI_TARGETS = ks_version.h trace-graph trace-view kernelshark
@@ -369,16 +373,19 @@ trace-view: $(TRACE_VIEW_MAIN_OBJS)
 trace-graph: $(TRACE_GRAPH_MAIN_OBJS)
 	$(Q)$(G)$(do_app_build)
 
-trace-cmd: libtracecmd.a
-kernelshark: libtracecmd.a
-trace-view: libtracecmd.a
-trace-graph: libtracecmd.a
+trace-cmd: libtracecmd.a $(LIBTRACEEVENT_STATIC)
+kernelshark: libtracecmd.a $(LIBTRACEEVENT_STATIC)
+trace-view: libtracecmd.a $(LIBTRACEEVENT_STATIC)
+trace-graph: libtracecmd.a $(LIBTRACEEVENT_STATIC)
 
-libtraceevent.so: $(TRACEEVENT_LIB_OBJS)
-	$(Q)$(do_compile_shared_library)
+$(LIBTRACEEVENT_SHARED): force
+	$(Q)$(MAKE) -C $(src)/lib/traceevent libtraceevent.so
 
-libtraceevent.a: $(TRACEEVENT_LIB_OBJS)
-	$(Q)$(do_build_static_lib)
+$(LIBTRACEEVENT_STATIC): force
+	$(Q)$(MAKE) -C $(src)/lib/traceevent libtraceevent.a
+
+libtraceevent.so: $(LIBTRACEEVENT_SHARED)
+libtraceevent.a: $(LIBTRACEEVENT_STATIC)
 
 $(TCMD_LIB_OBJS): %.o: $(src)/%.c
 	$(Q)$(do_fpic_compile)
@@ -389,7 +396,7 @@ libtracecmd.so: $(TCMD_LIB_OBJS)
 libtracecmd.a: $(TCMD_LIB_OBJS)
 	$(Q)$(do_build_static_lib)
 
-libs: libtracecmd.so libtraceevent.so
+libs: libtracecmd.so $(LIBTRACEEVENT_SHARED)
 
 trace-util.o: trace_plugin_dir
 
@@ -555,7 +562,7 @@ install_gui: install_cmd gui
 
 install_libs: libs
 	$(Q)$(call do_install,libtracecmd.so,$(libdir_SQ))
-	$(Q)$(call do_install,libtraceevent.so,$(libdir_SQ))
+	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ))
 	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ))
 	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ))
 
@@ -571,6 +578,7 @@ install_doc:
 clean:
 	$(RM) *.o *~ $(TARGETS) *.a *.so ctracecmd_wrap.c .*.d
 	$(RM) tags TAGS cscope*
+	$(MAKE) -C $(src)/lib/traceevent clean
 
 
 ##### PYTHON STUFF #####
diff --git a/lib/traceevent/Makefile b/lib/traceevent/Makefile
new file mode 100644
index 0000000..f9c595c
--- /dev/null
+++ b/lib/traceevent/Makefile
@@ -0,0 +1,45 @@
+
+
+include $(src)/scripts/utils.mk
+
+DEFAULT_TARGET = libtraceevent.a
+
+OBJS =
+OBJS += event-parse.o
+OBJS += event-plugin.o
+OBJS += kbuffer-parse.o
+OBJS += trace-seq.o
+OBJS += parse-filter.o
+OBJS += parse-utils.o
+
+# Additional util objects
+OBJS += str_error_r.o
+
+DEPS := $(OBJS:%.o=.%.d)
+
+all: $(DEFAULT_TARGET)
+
+libtraceevent.a: $(OBJS)
+	$(Q)$(call do_build_static_lib)
+
+libtraceevent.so: $(OBJS)
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
diff --git a/event-parse.c b/lib/traceevent/event-parse.c
similarity index 100%
rename from event-parse.c
rename to lib/traceevent/event-parse.c
diff --git a/event-plugin.c b/lib/traceevent/event-plugin.c
similarity index 100%
rename from event-plugin.c
rename to lib/traceevent/event-plugin.c
diff --git a/kbuffer-parse.c b/lib/traceevent/kbuffer-parse.c
similarity index 100%
rename from kbuffer-parse.c
rename to lib/traceevent/kbuffer-parse.c
diff --git a/parse-filter.c b/lib/traceevent/parse-filter.c
similarity index 100%
rename from parse-filter.c
rename to lib/traceevent/parse-filter.c
diff --git a/parse-utils.c b/lib/traceevent/parse-utils.c
similarity index 100%
rename from parse-utils.c
rename to lib/traceevent/parse-utils.c
diff --git a/str_error_r.c b/lib/traceevent/str_error_r.c
similarity index 100%
rename from str_error_r.c
rename to lib/traceevent/str_error_r.c
diff --git a/trace-seq.c b/lib/traceevent/trace-seq.c
similarity index 100%
rename from trace-seq.c
rename to lib/traceevent/trace-seq.c
-- 
2.14.1
