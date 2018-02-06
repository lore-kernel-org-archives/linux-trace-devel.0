Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pl0-f67.google.com ([209.85.160.67]:39368 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752335AbeBFIt1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:27 -0500
Received: by mail-pl0-f67.google.com with SMTP id o13so847849pli.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:27 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 10/24] trace-cmd: Move GUI *.c files in kernel-shark/
Date: Tue,  6 Feb 2018 10:48:52 +0200
Message-Id: <20180206084906.9854-11-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch moves all the source files belonging to the GUI (kernelshark,
trace-view and trace-graph) into the dedicated directory kernel-shark/.
The build system has been updated to support this new directory structure by
adding a separate Makefile in kernel-shark/ and by making the parent Makefile
to invoke it.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile                                           | 190 ++++-----------------
 kernel-shark/Makefile                              |  84 +++++++++
 kernel-shark.c => kernel-shark/kernel-shark.c      |   0
 trace-capture.c => kernel-shark/trace-capture.c    |   0
 trace-compat.c => kernel-shark/trace-compat.c      |   0
 trace-dialog.c => kernel-shark/trace-dialog.c      |   0
 .../trace-filter-hash.c                            |   0
 trace-filter.c => kernel-shark/trace-filter.c      |   0
 .../trace-graph-main.c                             |   0
 trace-graph.c => kernel-shark/trace-graph.c        |   0
 trace-plot-cpu.c => kernel-shark/trace-plot-cpu.c  |   0
 .../trace-plot-task.c                              |   0
 trace-plot.c => kernel-shark/trace-plot.c          |   0
 .../trace-view-main.c                              |   0
 .../trace-view-store.c                             |   0
 trace-view.c => kernel-shark/trace-view.c          |   0
 trace-xml.c => kernel-shark/trace-xml.c            |   0
 scripts/utils.mk                                   |  21 +++
 18 files changed, 140 insertions(+), 155 deletions(-)
 create mode 100644 kernel-shark/Makefile
 rename kernel-shark.c => kernel-shark/kernel-shark.c (100%)
 rename trace-capture.c => kernel-shark/trace-capture.c (100%)
 rename trace-compat.c => kernel-shark/trace-compat.c (100%)
 rename trace-dialog.c => kernel-shark/trace-dialog.c (100%)
 rename trace-filter-hash.c => kernel-shark/trace-filter-hash.c (100%)
 rename trace-filter.c => kernel-shark/trace-filter.c (100%)
 rename trace-graph-main.c => kernel-shark/trace-graph-main.c (100%)
 rename trace-graph.c => kernel-shark/trace-graph.c (100%)
 rename trace-plot-cpu.c => kernel-shark/trace-plot-cpu.c (100%)
 rename trace-plot-task.c => kernel-shark/trace-plot-task.c (100%)
 rename trace-plot.c => kernel-shark/trace-plot.c (100%)
 rename trace-view-main.c => kernel-shark/trace-view-main.c (100%)
 rename trace-view-store.c => kernel-shark/trace-view-store.c (100%)
 rename trace-view.c => kernel-shark/trace-view.c (100%)
 rename trace-xml.c => kernel-shark/trace-xml.c (100%)

diff --git a/Makefile b/Makefile
index 2269a96..b6a023a 100644
--- a/Makefile
+++ b/Makefile
@@ -4,11 +4,6 @@ TC_VERSION = 2
 TC_PATCHLEVEL = 7
 TC_EXTRAVERSION =
 
-# Kernel Shark version
-KS_VERSION = 0
-KS_PATCHLEVEL = 2
-KS_EXTRAVERSION =
-
 # file format version
 FILE_VERSION = 6
 
@@ -147,27 +142,9 @@ BUILD_OUTPUT := $(shell cd $(BUILD_OUTPUT) && /bin/pwd)
 $(if $(BUILD_OUTPUT),, \
      $(error output directory "$(saved-output)" does not exist))
 
-all: sub-make
-
-gui: force
-	$(call build_output, all_cmd)
-	$(call build_output, BUILDGUI=1 all_gui)
-
-$(filter-out gui,$(MAKECMDGOALS)): sub-make
-
-sub-make: force
-	$(call build_output, $(MAKECMDGOALS))
-
-
-# Leave processing to above invocation of make
-skip-makefile := 1
-
 endif # BUILD_OUTPUT
 endif # BUILD_SRC
 
-# We process the rest of the Makefile if this is the final invocation of make
-ifeq ($(skip-makefile),)
-
 srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
 objtree		:= $(CURDIR)
 src		:= $(srctree)
@@ -181,7 +158,8 @@ bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
 plugin_dir_SQ = $(subst ','\'',$(plugin_dir))
 python_dir_SQ = $(subst ','\'',$(python_dir))
 
-LIBS = -L. -ldl
+LIBS = -ldl
+
 LIBTRACEEVENT_DIR = $(obj)/lib/traceevent
 LIBTRACEEVENT_STATIC = $(LIBTRACEEVENT_DIR)/libtraceevent.a
 LIBTRACEEVENT_SHARED = $(LIBTRACEEVENT_DIR)/libtraceevent.so
@@ -190,32 +168,8 @@ LIBTRACECMD_DIR = $(obj)/lib/trace-cmd
 LIBTRACECMD_STATIC = $(LIBTRACECMD_DIR)/libtracecmd.a
 LIBTRACECMD_SHARED = $(LIBTRACECMD_DIR)/libtracecmd.so
 
-PACKAGES= gtk+-2.0 libxml-2.0 gthread-2.0
-
-ifndef BUILDGUI
- BUILDGUI = 0
-endif
-
-ifeq ($(BUILDGUI), 1)
-
-CONFIG_INCLUDES = $(shell pkg-config --cflags $(PACKAGES)) -I$(obj)
-
-CONFIG_FLAGS = -DBUILDGUI \
-	-DGTK_VERSION=$(shell pkg-config --modversion gtk+-2.0 | \
-	awk 'BEGIN{FS="."}{ a = ($$1 * (2^16)) + $$2 * (2^8) + $$3; printf ("%d", a);}')
-
-CONFIG_LIBS = $(shell pkg-config --libs $(PACKAGES))
-
-VERSION		= $(KS_VERSION)
-PATCHLEVEL	= $(KS_PATCHLEVEL)
-EXTRAVERSION	= $(KS_EXTRAVERSION)
-
-REBUILD_GUI	= /bin/true
-G		=
-N 		= @/bin/true ||
-
-CONFIG_FLAGS	+= $(HELP_DIR_SQ)
-else
+export LIBS
+export LIBTRACEEVENT_DIR LIBTRACECMD_DIR
 
 CONFIG_INCLUDES = 
 CONFIG_LIBS	=
@@ -225,18 +179,14 @@ VERSION		= $(TC_VERSION)
 PATCHLEVEL	= $(TC_PATCHLEVEL)
 EXTRAVERSION	= $(TC_EXTRAVERSION)
 
-REBUILD_GUI	= $(MAKE) -f $(src)/Makefile BUILDGUI=1 $@
-G		= $(REBUILD_GUI); /bin/true ||
 N		=
-endif
 
-export Q VERBOSE
+export Q VERBOSE EXT
 
 # Include the utils
 include scripts/utils.mk
 
 TRACECMD_VERSION = $(TC_VERSION).$(TC_PATCHLEVEL).$(TC_EXTRAVERSION)
-KERNELSHARK_VERSION = $(KS_VERSION).$(KS_PATCHLEVEL).$(KS_EXTRAVERSION)
 
 INCLUDES = -I$(src) -I $(src)/include -I $(srctree)/../../include $(CONFIG_INCLUDES)
 INCLUDES += -I$(src)/include/traceevent
@@ -253,6 +203,7 @@ CPPFLAGS ?=
 LDFLAGS ?=
 
 export CFLAGS
+export INCLUDES
 
 # Required CFLAGS
 override CFLAGS += -D_GNU_SOURCE
@@ -285,34 +236,21 @@ endif
 override CFLAGS += $(CONFIG_FLAGS) $(INCLUDES) $(PLUGIN_DIR_SQ) $(VAR_DIR)
 override CFLAGS += $(udis86-flags) $(blk-flags)
 
-define check_gui
-	if [ $(BUILDGUI) -ne 1 -a ! -z "$(filter $(gui_objs),$(@))" ];	then	\
-		$(REBUILD_GUI);							\
-	else									\
-		$(print_compile)						\
-		$(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) $< -o $(obj)/$@;		\
-	fi;
-endef
-
 $(obj)/%.o: $(src)/%.c
-	$(Q)$(call check_gui)
+	$(Q)$(call do_compile)
 
 %.o: $(src)/%.c
-	$(Q)$(call check_gui)
+	$(Q)$(call do_compile)
+
+TRACE_VIEW_OBJS =
+TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view.o
+TRACE_VIEW_OBJS += $(obj)/kernel-shark/trace-view-store.o
 
-TRACE_GUI_OBJS = trace-filter.o trace-compat.o trace-filter-hash.o trace-dialog.o \
-		trace-xml.o
 TRACE_CMD_OBJS = trace-cmd.o trace-record.o trace-read.o trace-split.o trace-listen.o \
 	 trace-stack.o trace-hist.o trace-mem.o trace-snapshot.o trace-stat.o \
 	 trace-profile.o trace-stream.o trace-record.o trace-restore.o \
 	 trace-check-events.o trace-show.o trace-list.o  \
 	 trace-output.o trace-usage.o trace-msg.o
-TRACE_VIEW_OBJS = trace-view.o trace-view-store.o
-TRACE_GRAPH_OBJS = trace-graph.o trace-plot.o trace-plot-cpu.o trace-plot-task.o
-TRACE_VIEW_MAIN_OBJS = trace-view-main.o $(TRACE_VIEW_OBJS) $(TRACE_GUI_OBJS)
-TRACE_GRAPH_MAIN_OBJS = trace-graph-main.o $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS)
-KERNEL_SHARK_OBJS = $(TRACE_VIEW_OBJS) $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS) \
-	trace-capture.o kernel-shark.o
 
 PLUGIN_OBJS =
 PLUGIN_OBJS += plugin_jbd2.o
@@ -330,15 +268,13 @@ PLUGIN_OBJS += plugin_tlb.o
 
 PLUGINS := $(PLUGIN_OBJS:.o=.so)
 
-ALL_OBJS = $(TRACE_CMD_OBJS) $(KERNEL_SHARK_OBJS) $(TRACE_VIEW_MAIN_OBJS) \
-	$(TRACE_GRAPH_MAIN_OBJS) $(PLUGIN_OBJS)
+ALL_OBJS = $(TRACE_CMD_OBJS) $(PLUGIN_OBJS)
 
 CMD_TARGETS = trace_plugin_dir trace_python_dir tc_version.h \
 	trace-cmd  $(PLUGINS) $(BUILD_PYTHON)
 
-GUI_TARGETS = ks_version.h trace-graph trace-view kernelshark
 
-TARGETS = $(CMD_TARGETS) $(GUI_TARGETS)
+TARGETS = $(CMD_TARGETS)
 
 
 #	cpp $(INCLUDES)
@@ -353,31 +289,23 @@ all: all_cmd show_gui_make
 
 all_cmd: $(CMD_TARGETS)
 
-gui: $(CMD_TARGETS)
-	$(Q)$(MAKE) -f $(src)/Makefile BUILDGUI=1 all_gui
-
-all_gui: $(GUI_TARGETS) show_gui_done
-
-GUI_OBJS = $(KERNEL_SHARK_OBJS) $(TRACE_VIEW_MAIN_OBJS) $(TRACE_GRAPH_MAIN_OBJS)
-
-gui_objs := $(sort $(GUI_OBJS))
+gui: force $(CMD_TARGETS)
+	$(Q)$(MAKE) -C $(src)/kernel-shark; \
+	echo "gui build complete"
 
 trace-cmd: $(TRACE_CMD_OBJS)
 	$(Q)$(do_app_build)
 
-kernelshark: $(KERNEL_SHARK_OBJS)
-	$(Q)$(G)$(do_app_build)
-
-trace-view: $(TRACE_VIEW_MAIN_OBJS)
-	$(Q)$(G)$(do_app_build)
-
-trace-graph: $(TRACE_GRAPH_MAIN_OBJS)
-	$(Q)$(G)$(do_app_build)
-
 trace-cmd: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC)
-kernelshark: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC)
-trace-view: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC)
-trace-graph: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC)
+
+kernelshark: force $(CMD_TARGETS)
+	$(Q)$(MAKE) -C $(src)/kernel-shark $@
+
+trace-view: force $(CMD_TARGETS)
+	$(Q)$(MAKE) -C $(src)/kernel-shark $@
+
+trace-graph: force $(CMD_TARGETS)
+	$(Q)$(MAKE) -C $(src)/kernel-shark $@
 
 $(LIBTRACEEVENT_SHARED): force
 	$(Q)$(MAKE) -C $(src)/lib/traceevent libtraceevent.so
@@ -404,29 +332,6 @@ $(PLUGIN_OBJS): %.o : $(src)/%.c
 $(PLUGINS): %.so: %.o
 	$(Q)$(do_plugin_build)
 
-define make_version.h
-	(echo '/* This file is automatically generated. Do not modify. */';		\
-	echo \#define VERSION_CODE $(shell						\
-	expr $(VERSION) \* 256 + $(PATCHLEVEL));					\
-	echo '#define EXTRAVERSION ' $(EXTRAVERSION);					\
-	echo '#define VERSION_STRING "'$(VERSION).$(PATCHLEVEL).$(EXTRAVERSION)'"';	\
-	echo '#define FILE_VERSION '$(FILE_VERSION);					\
-	) > $1
-endef
-
-define update_version.h
-	($(call make_version.h, $@.tmp);		\
-	if [ -r $@ ] && cmp -s $@ $@.tmp; then		\
-		rm -f $@.tmp;				\
-	else						\
-		echo '  UPDATE                 $@';	\
-		mv -f $@.tmp $@;			\
-	fi);
-endef
-
-ks_version.h: force
-	$(Q)$(G)$(call update_version.h)
-
 tc_version.h: force
 	$(Q)$(N)$(call update_version.h)
 
@@ -450,36 +355,15 @@ trace_python_dir: force
 
 all_objs := $(sort $(ALL_OBJS))
 all_deps := $(all_objs:%.o=.%.d)
-gui_deps := $(gui_objs:%.o=.%.d)
-non_gui_deps = $(filter-out $(gui_deps),$(all_deps))
 
-define check_gui_deps
-	if [ ! -z "$(filter $(gui_deps),$(@))" ];	then	\
-		if [ $(BUILDGUI) -ne 1 ]; then			\
-			$(REBUILD_GUI);				\
-		else						\
-			$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@;	\
-		fi						\
-	elif [ $(BUILDGUI) -eq 0 ]; then			\
-		$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@;		\
-	else							\
-		echo SKIPPING $@;				\
-	fi;
-endef
-
-$(gui_deps): ks_version.h
-$(non_gui_deps): tc_version.h
+$(all_deps): tc_version.h
 
 $(all_deps): .%.d: $(src)/%.c
-	$(Q)$(call check_gui_deps)
+	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@;
 
 $(all_objs) : %.o : .%.d
 
-ifeq ($(BUILDGUI), 1)
-dep_includes := $(wildcard $(gui_deps))
-else
-dep_includes := $(wildcard $(non_gui_deps))
-endif
+dep_includes := $(wildcard $(all_deps))
 
 ifneq ($(dep_includes),)
  include $(dep_includes)
@@ -489,9 +373,6 @@ show_gui_make:
 	@echo "Note: to build the gui, type \"make gui\""
 	@echo "      to build man pages, type \"make doc\""
 
-show_gui_done:
-	@echo "gui build complete"
-
 PHONY += show_gui_make
 
 define find_tag_files
@@ -559,9 +440,9 @@ install: install_cmd
 	@echo "      to install man pages, type \"make install_doc\""
 
 install_gui: install_cmd gui
-	$(Q)$(call do_install,trace-view,$(bindir_SQ))
-	$(Q)$(call do_install,trace-graph,$(bindir_SQ))
-	$(Q)$(call do_install,kernelshark,$(bindir_SQ))
+	$(Q)$(call do_install,$(obj)/kernel-shark/trace-view,$(bindir_SQ))
+	$(Q)$(call do_install,$(obj)/kernel-shark/trace-graph,$(bindir_SQ))
+	$(Q)$(call do_install,$(obj)/kernel-shark/kernelshark,$(bindir_SQ))
 
 install_libs: libs
 	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
@@ -583,6 +464,7 @@ clean:
 	$(RM) tags TAGS cscope*
 	$(MAKE) -C $(src)/lib/traceevent clean
 	$(MAKE) -C $(src)/lib/trace-cmd clean
+	$(MAKE) -C $(src)/kernel-shark clean
 
 
 ##### PYTHON STUFF #####
@@ -602,10 +484,10 @@ ctracecmd.so: $(TCMD_LIB_OBJS) ctracecmd.i
 	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
 	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so
 
-ctracecmdgui.so: $(TRACE_VIEW_OBJS) $(LIBTRACECMD_STATIC)
+ctracecmdgui.so: trace-view $(LIBTRACECMD_STATIC)
 	swig -Wall -python -noproxy -I$(src)/kernel-shark/include ctracecmdgui.i
 	$(CC) -fpic -c  $(CPPFLAGS) $(CFLAGS) $(INCLUDES) $(PYTHON_INCLUDES) $(PYGTK_CFLAGS) ctracecmdgui_wrap.c
-	$(CC) --shared $^ $(LDFLAGS) $(LIBS) $(CONFIG_LIBS) ctracecmdgui_wrap.o -o ctracecmdgui.so
+	$(CC) --shared $(TRACE_VIEW_OBJS) $(LIBTRACECMD_STATIC) $(LDFLAGS) $(LIBS) $(CONFIG_LIBS) ctracecmdgui_wrap.o -o ctracecmdgui.so
 
 PHONY += python
 python: $(PYTHON)
@@ -632,8 +514,6 @@ plugin_python.o: %.o : $(src)/%.c trace_python_dir
 plugin_python.so: %.so: %.o
 	$(Q)$(do_python_plugin_build)
 
-endif # skip-makefile
-
 dist:
 	git archive --format=tar --prefix=trace-cmd-$(TRACECMD_VERSION)/ HEAD \
 		> ../trace-cmd-$(TRACECMD_VERSION).tar
diff --git a/kernel-shark/Makefile b/kernel-shark/Makefile
new file mode 100644
index 0000000..247f4d1
--- /dev/null
+++ b/kernel-shark/Makefile
@@ -0,0 +1,84 @@
+# Kernel Shark version
+
+VERSION		= 0
+PATCHLEVEL	= 2
+EXTRAVERSION	=
+KERNELSHARK_VERSION = $(VERSION).$(PATCHLEVEL).$(EXTRAVERSION)
+
+BUILDGUI := 1
+include $(src)/scripts/utils.mk
+
+
+PACKAGES = gtk+-2.0 libxml-2.0 gthread-2.0
+
+CONFIG_INCLUDES = $(shell pkg-config --cflags $(PACKAGES)) -I$(obj)
+
+CONFIG_FLAGS = -DBUILDGUI \
+	-DGTK_VERSION=$(shell pkg-config --modversion gtk+-2.0 | \
+	awk 'BEGIN{FS="."}{ a = ($$1 * (2^16)) + $$2 * (2^8) + $$3; printf ("%d", a);}')
+
+CONFIG_LIBS = $(shell pkg-config --libs $(PACKAGES))
+
+CONFIG_FLAGS += $(HELP_DIR_SQ)
+
+KS_VERSION := $(obj)/kernel-shark/include/ks_version.h
+
+GUI_TARGETS = $(KS_VERSION) trace-graph trace-view kernelshark
+
+TRACE_GUI_OBJS = trace-filter.o trace-compat.o trace-filter-hash.o \
+		 trace-dialog.o trace-xml.o
+TRACE_VIEW_OBJS = trace-view.o trace-view-store.o
+TRACE_GRAPH_OBJS = trace-graph.o trace-plot.o trace-plot-cpu.o trace-plot-task.o
+TRACE_VIEW_MAIN_OBJS = trace-view-main.o $(TRACE_VIEW_OBJS) $(TRACE_GUI_OBJS)
+TRACE_GRAPH_MAIN_OBJS = trace-graph-main.o $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS)
+KERNEL_SHARK_OBJS = $(TRACE_VIEW_OBJS) $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS) \
+	trace-capture.o kernel-shark.o
+
+GUI_OBJS = $(KERNEL_SHARK_OBJS) $(TRACE_VIEW_MAIN_OBJS) $(TRACE_GRAPH_MAIN_OBJS)
+
+all_objs := $(sort $(GUI_OBJS))
+all_deps := $(all_objs:%.o=.%.d)
+
+# Temporary HACK!
+# This hack is OK only until the non-gui builds do not have any config_includes
+# nor config flags. In case they do, keeping this hack might be a problem.
+override CFLAGS += $(CONFIG_INCLUDES) $(CONFIG_FLAGS)
+
+LIBS += -L$(LIBTRACEEVENT_DIR) -L$(LIBTRACECMD_DIR)
+LIBS += -ltracecmd -ltraceevent -ldl
+
+all: $(GUI_TARGETS)
+
+$(KS_VERSION): force
+	$(Q)$(call update_version.h)
+
+kernelshark: $(KERNEL_SHARK_OBJS)
+	$(Q)$(do_app_build)
+
+trace-view: $(TRACE_VIEW_MAIN_OBJS)
+	$(Q)$(do_app_build)
+
+trace-graph: $(TRACE_GRAPH_MAIN_OBJS)
+	$(Q)$(do_app_build)
+
+%.o: %.c
+	$(Q)$(call do_compile)
+
+$(all_deps): .%.d: %.c
+	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
+
+$(all_deps): $(KS_VERSION)
+
+$(GUI_OBJS): %.o : .%.d
+
+dep_includes := $(wildcard $(DEPS))
+
+ifneq ($(dep_includes),)
+  include $(dep_includes)
+endif
+
+clean:
+	$(RM) *.a *.so *.o .*.d $(GUI_TARGETS)
+
+force:
+.PHONY: clean
diff --git a/kernel-shark.c b/kernel-shark/kernel-shark.c
similarity index 100%
rename from kernel-shark.c
rename to kernel-shark/kernel-shark.c
diff --git a/trace-capture.c b/kernel-shark/trace-capture.c
similarity index 100%
rename from trace-capture.c
rename to kernel-shark/trace-capture.c
diff --git a/trace-compat.c b/kernel-shark/trace-compat.c
similarity index 100%
rename from trace-compat.c
rename to kernel-shark/trace-compat.c
diff --git a/trace-dialog.c b/kernel-shark/trace-dialog.c
similarity index 100%
rename from trace-dialog.c
rename to kernel-shark/trace-dialog.c
diff --git a/trace-filter-hash.c b/kernel-shark/trace-filter-hash.c
similarity index 100%
rename from trace-filter-hash.c
rename to kernel-shark/trace-filter-hash.c
diff --git a/trace-filter.c b/kernel-shark/trace-filter.c
similarity index 100%
rename from trace-filter.c
rename to kernel-shark/trace-filter.c
diff --git a/trace-graph-main.c b/kernel-shark/trace-graph-main.c
similarity index 100%
rename from trace-graph-main.c
rename to kernel-shark/trace-graph-main.c
diff --git a/trace-graph.c b/kernel-shark/trace-graph.c
similarity index 100%
rename from trace-graph.c
rename to kernel-shark/trace-graph.c
diff --git a/trace-plot-cpu.c b/kernel-shark/trace-plot-cpu.c
similarity index 100%
rename from trace-plot-cpu.c
rename to kernel-shark/trace-plot-cpu.c
diff --git a/trace-plot-task.c b/kernel-shark/trace-plot-task.c
similarity index 100%
rename from trace-plot-task.c
rename to kernel-shark/trace-plot-task.c
diff --git a/trace-plot.c b/kernel-shark/trace-plot.c
similarity index 100%
rename from trace-plot.c
rename to kernel-shark/trace-plot.c
diff --git a/trace-view-main.c b/kernel-shark/trace-view-main.c
similarity index 100%
rename from trace-view-main.c
rename to kernel-shark/trace-view-main.c
diff --git a/trace-view-store.c b/kernel-shark/trace-view-store.c
similarity index 100%
rename from trace-view-store.c
rename to kernel-shark/trace-view-store.c
diff --git a/trace-view.c b/kernel-shark/trace-view.c
similarity index 100%
rename from trace-view.c
rename to kernel-shark/trace-view.c
diff --git a/trace-xml.c b/kernel-shark/trace-xml.c
similarity index 100%
rename from trace-xml.c
rename to kernel-shark/trace-xml.c
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 39cb387..abfe115 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -62,3 +62,24 @@ do_plugin_build =				\
 	($(print_plugin_build)			\
 	$(CC) $(CFLAGS) $(LDFLAGS) -shared -nostartfiles -o $@ $<)
 
+
+define make_version.h
+	(echo '/* This file is automatically generated. Do not modify. */';		\
+	echo \#define VERSION_CODE $(shell						\
+	expr $(VERSION) \* 256 + $(PATCHLEVEL));					\
+	echo '#define EXTRAVERSION ' $(EXTRAVERSION);					\
+	echo '#define VERSION_STRING "'$(VERSION).$(PATCHLEVEL).$(EXTRAVERSION)'"';	\
+	echo '#define FILE_VERSION '$(FILE_VERSION);					\
+	) > $1
+endef
+
+define update_version.h
+	($(call make_version.h, $@.tmp);		\
+	if [ -r $@ ] && cmp -s $@ $@.tmp; then		\
+		rm -f $@.tmp;				\
+	else						\
+		echo '  UPDATE                 $@';	\
+		mv -f $@.tmp $@;			\
+	fi);
+endef
+
-- 
2.14.1
