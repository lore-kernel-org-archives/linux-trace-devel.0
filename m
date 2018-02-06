Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pg0-f67.google.com ([74.125.83.67]:41227 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752298AbeBFItk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:40 -0500
Received: by mail-pg0-f67.google.com with SMTP id 141so827789pgd.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:39 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 16/24] trace-cmd: Move trace-cmd app files in tracecmd/
Date: Tue,  6 Feb 2018 10:48:58 +0200
Message-Id: <20180206084906.9854-17-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch moves all the remaining C files in the project's root directory to
tracecmd, a directory dedicated to the trace-cmd application itself. This patch
completes the bigger restructuring plan of trace-cmd's code base.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile                                           | 77 +++++-----------------
 tracecmd/Makefile                                  | 73 ++++++++++++++++++++
 .../trace-check-events.c                           |  0
 trace-cmd.bash => tracecmd/trace-cmd.bash          |  0
 trace-cmd.c => tracecmd/trace-cmd.c                |  0
 trace-hist.c => tracecmd/trace-hist.c              |  0
 trace-list.c => tracecmd/trace-list.c              |  0
 trace-listen.c => tracecmd/trace-listen.c          |  0
 trace-mem.c => tracecmd/trace-mem.c                |  0
 trace-msg.c => tracecmd/trace-msg.c                |  0
 trace-output.c => tracecmd/trace-output.c          |  0
 trace-profile.c => tracecmd/trace-profile.c        |  0
 trace-read.c => tracecmd/trace-read.c              |  0
 trace-record.c => tracecmd/trace-record.c          |  0
 trace-restore.c => tracecmd/trace-restore.c        |  0
 trace-show.c => tracecmd/trace-show.c              |  0
 trace-snapshot.c => tracecmd/trace-snapshot.c      |  0
 trace-split.c => tracecmd/trace-split.c            |  0
 trace-stack.c => tracecmd/trace-stack.c            |  0
 trace-stat.c => tracecmd/trace-stat.c              |  0
 trace-stream.c => tracecmd/trace-stream.c          |  0
 trace-usage.c => tracecmd/trace-usage.c            |  0
 22 files changed, 88 insertions(+), 62 deletions(-)
 create mode 100644 tracecmd/Makefile
 rename trace-check-events.c => tracecmd/trace-check-events.c (100%)
 rename trace-cmd.bash => tracecmd/trace-cmd.bash (100%)
 rename trace-cmd.c => tracecmd/trace-cmd.c (100%)
 rename trace-hist.c => tracecmd/trace-hist.c (100%)
 rename trace-list.c => tracecmd/trace-list.c (100%)
 rename trace-listen.c => tracecmd/trace-listen.c (100%)
 rename trace-mem.c => tracecmd/trace-mem.c (100%)
 rename trace-msg.c => tracecmd/trace-msg.c (100%)
 rename trace-output.c => tracecmd/trace-output.c (100%)
 rename trace-profile.c => tracecmd/trace-profile.c (100%)
 rename trace-read.c => tracecmd/trace-read.c (100%)
 rename trace-record.c => tracecmd/trace-record.c (100%)
 rename trace-restore.c => tracecmd/trace-restore.c (100%)
 rename trace-show.c => tracecmd/trace-show.c (100%)
 rename trace-snapshot.c => tracecmd/trace-snapshot.c (100%)
 rename trace-split.c => tracecmd/trace-split.c (100%)
 rename trace-stack.c => tracecmd/trace-stack.c (100%)
 rename trace-stat.c => tracecmd/trace-stat.c (100%)
 rename trace-stream.c => tracecmd/trace-stream.c (100%)
 rename trace-usage.c => tracecmd/trace-usage.c (100%)

diff --git a/Makefile b/Makefile
index 4e604b4..cc96534 100644
--- a/Makefile
+++ b/Makefile
@@ -3,6 +3,12 @@
 TC_VERSION = 2
 TC_PATCHLEVEL = 7
 TC_EXTRAVERSION =
+TRACECMD_VERSION = $(TC_VERSION).$(TC_PATCHLEVEL).$(TC_EXTRAVERSION)
+
+export TC_VERSION
+export TC_PATCHLEVEL
+export TC_EXTRAVERSION
+export TRACECMD_VERSION
 
 # file format version
 FILE_VERSION = 6
@@ -176,25 +182,14 @@ LIBTRACECMD_SHARED = $(LIBTRACECMD_DIR)/libtracecmd.so
 export LIBS
 export LIBTRACEEVENT_DIR LIBTRACECMD_DIR
 export LIBTRACECMD_STATIC LIBTRACECMD_SHARED
-
-CONFIG_INCLUDES = 
-CONFIG_LIBS	=
-CONFIG_FLAGS	=
-
-VERSION		= $(TC_VERSION)
-PATCHLEVEL	= $(TC_PATCHLEVEL)
-EXTRAVERSION	= $(TC_EXTRAVERSION)
-
-N		=
+export LIBTRACEEVENT_STATIC LIBTRACEEVENT_SHARED
 
 export Q VERBOSE EXT
 
 # Include the utils
 include scripts/utils.mk
 
-TRACECMD_VERSION = $(TC_VERSION).$(TC_PATCHLEVEL).$(TC_EXTRAVERSION)
-
-INCLUDES = -I$(src) -I $(src)/include -I $(srctree)/../../include $(CONFIG_INCLUDES)
+INCLUDES = -I$(src)/include -I$(src)/../../include
 INCLUDES += -I$(src)/include/traceevent
 INCLUDES += -I$(src)/include/trace-cmd
 INCLUDES += -I$(src)/lib/traceevent/include
@@ -243,27 +238,8 @@ endif
 override CFLAGS += $(CONFIG_FLAGS) $(INCLUDES) $(PLUGIN_DIR_SQ) $(VAR_DIR)
 override CFLAGS += $(udis86-flags) $(blk-flags)
 
-$(obj)/%.o: $(src)/%.c
-	$(Q)$(call do_compile)
 
-%.o: $(src)/%.c
-	$(Q)$(call do_compile)
-
-TRACE_CMD_OBJS = trace-cmd.o trace-record.o trace-read.o trace-split.o trace-listen.o \
-	 trace-stack.o trace-hist.o trace-mem.o trace-snapshot.o trace-stat.o \
-	 trace-profile.o trace-stream.o trace-record.o trace-restore.o \
-	 trace-check-events.o trace-show.o trace-list.o  \
-	 trace-output.o trace-usage.o trace-msg.o
-
-ALL_OBJS = $(TRACE_CMD_OBJS)
-
-CMD_TARGETS = tc_version.h trace-cmd $(BUILD_PYTHON)
-
-
-TARGETS = $(CMD_TARGETS)
-
-
-#	cpp $(INCLUDES)
+CMD_TARGETS = trace-cmd $(BUILD_PYTHON)
 
 ###
 #    Default we just build trace-cmd
@@ -279,10 +255,8 @@ gui: force $(CMD_TARGETS)
 	$(Q)$(MAKE) -C $(src)/kernel-shark; \
 	echo "gui build complete"
 
-trace-cmd: $(TRACE_CMD_OBJS)
-	$(Q)$(do_app_build)
-
-trace-cmd: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC)
+trace-cmd: force $(LIBTRACEEVENT_STATIC) $(LIBTRACECMD_STATIC)
+	$(Q)$(MAKE) -C $(src)/tracecmd $@
 
 kernelshark: force $(CMD_TARGETS)
 	$(Q)$(MAKE) -C $(src)/kernel-shark $@
@@ -315,34 +289,12 @@ libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED)
 plugins: force $(obj)/plugins/trace_plugin_dir $(obj)/plugins/trace_python_dir
 	$(Q)$(MAKE) -C $(src)/plugins
 
-tc_version.h: force
-	$(Q)$(N)$(call update_version.h)
-
 $(obj)/plugins/trace_plugin_dir: force
 	$(Q)$(MAKE) -C $(src)/plugins trace_plugin_dir
 
 $(obj)/plugins/trace_python_dir: force
 	$(Q)$(MAKE) -C $(src)/plugins trace_python_dir
 
-
-## make deps
-
-all_objs := $(sort $(ALL_OBJS))
-all_deps := $(all_objs:%.o=.%.d)
-
-$(all_deps): tc_version.h
-
-$(all_deps): .%.d: $(src)/%.c
-	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@;
-
-$(all_objs) : %.o : .%.d
-
-dep_includes := $(wildcard $(all_deps))
-
-ifneq ($(dep_includes),)
- include $(dep_includes)
-endif
-
 show_gui_make:
 	@echo "Note: to build the gui, type \"make gui\""
 	@echo "      to build man pages, type \"make doc\""
@@ -373,10 +325,10 @@ install_python: force
 	$(Q)$(MAKE) -C $(src)/python $@
 
 install_bash_completion: force
-	$(Q)$(call do_install_data,trace-cmd.bash,$(BASH_COMPLETE_DIR))
+	$(Q)$(call do_install_data,$(src)/tracecmd/trace-cmd.bash,$(BASH_COMPLETE_DIR))
 
 install_cmd: all_cmd install_plugins install_python install_bash_completion
-	$(Q)$(call do_install,trace-cmd,$(bindir_SQ))
+	$(Q)$(call do_install,$(obj)/tracecmd/trace-cmd,$(bindir_SQ))
 
 install: install_cmd
 	@echo "Note: to install the gui, type \"make install_gui\""
@@ -403,13 +355,14 @@ install_doc:
 	$(MAKE) -C $(src)/Documentation install
 
 clean:
-	$(RM) *.o *~ $(TARGETS) *.a *.so .*.d
+	$(RM) *.o *~ *.a *.so .*.d
 	$(RM) tags TAGS cscope*
 	$(MAKE) -C $(src)/lib/traceevent clean
 	$(MAKE) -C $(src)/lib/trace-cmd clean
 	$(MAKE) -C $(src)/kernel-shark clean
 	$(MAKE) -C $(src)/plugins clean
 	$(MAKE) -C $(src)/python clean
+	$(MAKE) -C $(src)/tracecmd clean
 
 
 ##### PYTHON STUFF #####
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
new file mode 100644
index 0000000..860dc89
--- /dev/null
+++ b/tracecmd/Makefile
@@ -0,0 +1,73 @@
+
+VERSION := $(TC_VERSION)
+PATCHLEVEL := $(TC_PATCHLEVEL)
+EXTRAVERSION := $(TC_EXTRAVERSION)
+
+TC_VERSION := $(obj)/tracecmd/include/tc_version.h
+TARGETS = trace-cmd $(TC_VERSION)
+
+BUILDGUI := 0
+include $(src)/scripts/utils.mk
+
+TRACE_CMD_OBJS =
+TRACE_CMD_OBJS += trace-cmd.o
+TRACE_CMD_OBJS += trace-record.o
+TRACE_CMD_OBJS += trace-read.o
+TRACE_CMD_OBJS += trace-split.o
+TRACE_CMD_OBJS += trace-listen.o
+TRACE_CMD_OBJS += trace-stack.o
+TRACE_CMD_OBJS += trace-hist.o
+TRACE_CMD_OBJS += trace-mem.o
+TRACE_CMD_OBJS += trace-snapshot.o
+TRACE_CMD_OBJS += trace-stat.o
+TRACE_CMD_OBJS += trace-profile.o
+TRACE_CMD_OBJS += trace-stream.o
+TRACE_CMD_OBJS += trace-record.o
+TRACE_CMD_OBJS += trace-restore.o
+TRACE_CMD_OBJS += trace-check-events.o
+TRACE_CMD_OBJS += trace-show.o
+TRACE_CMD_OBJS += trace-list.o
+TRACE_CMD_OBJS += trace-output.o
+TRACE_CMD_OBJS += trace-usage.o
+TRACE_CMD_OBJS += trace-msg.o
+
+ALL_OBJS = $(TRACE_CMD_OBJS)
+
+all_objs := $(sort $(ALL_OBJS))
+all_deps := $(all_objs:%.o=.%.d)
+
+CONFIG_INCLUDES =
+CONFIG_LIBS	=
+CONFIG_FLAGS	=
+
+all: $(TARGETS)
+
+$(TC_VERSION): force
+	$(Q)$(call update_version.h)
+
+trace-cmd: $(ALL_OBJS)
+	$(Q)$(do_app_build)
+
+trace-cmd: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC)
+
+%.o: %.c
+	$(Q)$(call do_compile)
+
+$(all_deps): .%.d: %.c
+	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
+
+$(all_deps): $(TC_VERSION)
+
+$(all_objs): %.o : .%.d
+
+dep_includes := $(wildcard $(DEPS))
+
+ifneq ($(dep_includes),)
+  include $(dep_includes)
+endif
+
+clean:
+	$(RM) *.a *.so *.o .*.d $(TARGETS)
+
+force:
+.PHONY: clean
diff --git a/trace-check-events.c b/tracecmd/trace-check-events.c
similarity index 100%
rename from trace-check-events.c
rename to tracecmd/trace-check-events.c
diff --git a/trace-cmd.bash b/tracecmd/trace-cmd.bash
similarity index 100%
rename from trace-cmd.bash
rename to tracecmd/trace-cmd.bash
diff --git a/trace-cmd.c b/tracecmd/trace-cmd.c
similarity index 100%
rename from trace-cmd.c
rename to tracecmd/trace-cmd.c
diff --git a/trace-hist.c b/tracecmd/trace-hist.c
similarity index 100%
rename from trace-hist.c
rename to tracecmd/trace-hist.c
diff --git a/trace-list.c b/tracecmd/trace-list.c
similarity index 100%
rename from trace-list.c
rename to tracecmd/trace-list.c
diff --git a/trace-listen.c b/tracecmd/trace-listen.c
similarity index 100%
rename from trace-listen.c
rename to tracecmd/trace-listen.c
diff --git a/trace-mem.c b/tracecmd/trace-mem.c
similarity index 100%
rename from trace-mem.c
rename to tracecmd/trace-mem.c
diff --git a/trace-msg.c b/tracecmd/trace-msg.c
similarity index 100%
rename from trace-msg.c
rename to tracecmd/trace-msg.c
diff --git a/trace-output.c b/tracecmd/trace-output.c
similarity index 100%
rename from trace-output.c
rename to tracecmd/trace-output.c
diff --git a/trace-profile.c b/tracecmd/trace-profile.c
similarity index 100%
rename from trace-profile.c
rename to tracecmd/trace-profile.c
diff --git a/trace-read.c b/tracecmd/trace-read.c
similarity index 100%
rename from trace-read.c
rename to tracecmd/trace-read.c
diff --git a/trace-record.c b/tracecmd/trace-record.c
similarity index 100%
rename from trace-record.c
rename to tracecmd/trace-record.c
diff --git a/trace-restore.c b/tracecmd/trace-restore.c
similarity index 100%
rename from trace-restore.c
rename to tracecmd/trace-restore.c
diff --git a/trace-show.c b/tracecmd/trace-show.c
similarity index 100%
rename from trace-show.c
rename to tracecmd/trace-show.c
diff --git a/trace-snapshot.c b/tracecmd/trace-snapshot.c
similarity index 100%
rename from trace-snapshot.c
rename to tracecmd/trace-snapshot.c
diff --git a/trace-split.c b/tracecmd/trace-split.c
similarity index 100%
rename from trace-split.c
rename to tracecmd/trace-split.c
diff --git a/trace-stack.c b/tracecmd/trace-stack.c
similarity index 100%
rename from trace-stack.c
rename to tracecmd/trace-stack.c
diff --git a/trace-stat.c b/tracecmd/trace-stat.c
similarity index 100%
rename from trace-stat.c
rename to tracecmd/trace-stat.c
diff --git a/trace-stream.c b/tracecmd/trace-stream.c
similarity index 100%
rename from trace-stream.c
rename to tracecmd/trace-stream.c
diff --git a/trace-usage.c b/tracecmd/trace-usage.c
similarity index 100%
rename from trace-usage.c
rename to tracecmd/trace-usage.c
-- 
2.14.1
