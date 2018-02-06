Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pl0-f67.google.com ([209.85.160.67]:46904 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752263AbeBFIta (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:30 -0500
Received: by mail-pl0-f67.google.com with SMTP id 36so834623ple.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:29 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 11/24] trace-cmd: Move plugin_* files in plugins/
Date: Tue,  6 Feb 2018 10:48:53 +0200
Message-Id: <20180206084906.9854-12-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch moves the source files of all plugins to a dedicated directory, as
part of a bigger restructuring plan of trace-cmd's code base.
The build system has been updated to support this new directory structure by
adding a separate Makefile in plugins/ and by making the parent Makefile
to invoke it.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile                                           | 115 ++++++---------------
 lib/trace-cmd/Makefile                             |   2 +
 plugins/Makefile                                   |  69 +++++++++++++
 plugin_blk.c => plugins/plugin_blk.c               |   0
 plugin_cfg80211.c => plugins/plugin_cfg80211.c     |   0
 plugin_function.c => plugins/plugin_function.c     |   0
 plugin_hrtimer.c => plugins/plugin_hrtimer.c       |   0
 plugin_jbd2.c => plugins/plugin_jbd2.c             |   0
 plugin_kmem.c => plugins/plugin_kmem.c             |   0
 plugin_kvm.c => plugins/plugin_kvm.c               |   0
 plugin_mac80211.c => plugins/plugin_mac80211.c     |   0
 plugin_python.c => plugins/plugin_python.c         |   0
 .../plugin_sched_switch.c                          |   0
 plugin_scsi.c => plugins/plugin_scsi.c             |   0
 plugin_tlb.c => plugins/plugin_tlb.c               |   0
 plugin_xen.c => plugins/plugin_xen.c               |   0
 scripts/utils.mk                                   |  32 ++++++
 17 files changed, 135 insertions(+), 83 deletions(-)
 create mode 100644 plugins/Makefile
 rename plugin_blk.c => plugins/plugin_blk.c (100%)
 rename plugin_cfg80211.c => plugins/plugin_cfg80211.c (100%)
 rename plugin_function.c => plugins/plugin_function.c (100%)
 rename plugin_hrtimer.c => plugins/plugin_hrtimer.c (100%)
 rename plugin_jbd2.c => plugins/plugin_jbd2.c (100%)
 rename plugin_kmem.c => plugins/plugin_kmem.c (100%)
 rename plugin_kvm.c => plugins/plugin_kvm.c (100%)
 rename plugin_mac80211.c => plugins/plugin_mac80211.c (100%)
 rename plugin_python.c => plugins/plugin_python.c (100%)
 rename plugin_sched_switch.c => plugins/plugin_sched_switch.c (100%)
 rename plugin_scsi.c => plugins/plugin_scsi.c (100%)
 rename plugin_tlb.c => plugins/plugin_tlb.c (100%)
 rename plugin_xen.c => plugins/plugin_xen.c (100%)

diff --git a/Makefile b/Makefile
index b6a023a..2dfb8fd 100644
--- a/Makefile
+++ b/Makefile
@@ -66,6 +66,12 @@ PYTHON_DIR_SQ = '$(subst ','\'',$(PYTHON_DIR))'
 var_dir = /var
 endif
 
+# Shell quotes
+bindir_SQ = $(subst ','\'',$(bindir))
+bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
+plugin_dir_SQ = $(subst ','\'',$(plugin_dir))
+python_dir_SQ = $(subst ','\'',$(python_dir))
+
 VAR_DIR = -DVAR_DIR="$(var_dir)"
 VAR_DIR_SQ = '$(subst ','\'',$(VAR_DIR))'
 var_dir_SQ = '$(subst ','\'',$(var_dir))'
@@ -76,6 +82,10 @@ HELP_DIR_SQ = '$(subst ','\'',$(HELP_DIR))'
 
 BASH_COMPLETE_DIR ?= /etc/bash_completion.d
 
+export PLUGIN_DIR
+export PYTHON_DIR
+export PYTHON_DIR_SQ
+export plugin_dir_SQ
 export var_dir
 
 # copy a bit from Linux kbuild
@@ -109,6 +119,8 @@ ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_VERS) > /dev/null 2>&1 && whic
 endif
 endif # NO_PYTHON
 
+export PYTHON_PLUGINS
+
 # $(call test-build, snippet, ret) -> ret if snippet compiles
 #                                  -> empty otherwise
 test-build = $(if $(shell sh -c 'echo "$(1)" | \
@@ -152,12 +164,6 @@ obj		:= $(objtree)
 
 export prefix bindir src obj
 
-# Shell quotes
-bindir_SQ = $(subst ','\'',$(bindir))
-bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
-plugin_dir_SQ = $(subst ','\'',$(plugin_dir))
-python_dir_SQ = $(subst ','\'',$(python_dir))
-
 LIBS = -ldl
 
 LIBTRACEEVENT_DIR = $(obj)/lib/traceevent
@@ -252,26 +258,9 @@ TRACE_CMD_OBJS = trace-cmd.o trace-record.o trace-read.o trace-split.o trace-lis
 	 trace-check-events.o trace-show.o trace-list.o  \
 	 trace-output.o trace-usage.o trace-msg.o
 
-PLUGIN_OBJS =
-PLUGIN_OBJS += plugin_jbd2.o
-PLUGIN_OBJS += plugin_hrtimer.o
-PLUGIN_OBJS += plugin_kmem.o
-PLUGIN_OBJS += plugin_kvm.o
-PLUGIN_OBJS += plugin_mac80211.o
-PLUGIN_OBJS += plugin_sched_switch.o
-PLUGIN_OBJS += plugin_function.o
-PLUGIN_OBJS += plugin_xen.o
-PLUGIN_OBJS += plugin_scsi.o
-PLUGIN_OBJS += plugin_cfg80211.o
-PLUGIN_OBJS += plugin_blk.o
-PLUGIN_OBJS += plugin_tlb.o
+ALL_OBJS = $(TRACE_CMD_OBJS)
 
-PLUGINS := $(PLUGIN_OBJS:.o=.so)
-
-ALL_OBJS = $(TRACE_CMD_OBJS) $(PLUGIN_OBJS)
-
-CMD_TARGETS = trace_plugin_dir trace_python_dir tc_version.h \
-	trace-cmd  $(PLUGINS) $(BUILD_PYTHON)
+CMD_TARGETS = tc_version.h trace-cmd $(BUILD_PYTHON)
 
 
 TARGETS = $(CMD_TARGETS)
@@ -285,7 +274,7 @@ TARGETS = $(CMD_TARGETS)
 #    If you want kernelshark, then do:  make gui
 ###
 
-all: all_cmd show_gui_make
+all: all_cmd plugins show_gui_make
 
 all_cmd: $(CMD_TARGETS)
 
@@ -313,10 +302,10 @@ $(LIBTRACEEVENT_SHARED): force
 $(LIBTRACEEVENT_STATIC): force
 	$(Q)$(MAKE) -C $(src)/lib/traceevent libtraceevent.a
 
-$(LIBTRACECMD_STATIC): force trace_plugin_dir
+$(LIBTRACECMD_STATIC): force $(obj)/plugins/trace_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd libtracecmd.a
 
-$(LIBTRACECMD_SHARED): force trace_plugin_dir
+$(LIBTRACECMD_SHARED): force $(obj)/plugins/trace_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd libtracecmd.so
 
 libtraceevent.so: $(LIBTRACEEVENT_SHARED)
@@ -326,30 +315,18 @@ libtracecmd.so: $(LIBTRACECMD_SHARED)
 
 libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED)
 
-$(PLUGIN_OBJS): %.o : $(src)/%.c
-	$(Q)$(do_compile_plugin_obj)
-
-$(PLUGINS): %.so: %.o
-	$(Q)$(do_plugin_build)
+plugins: force $(obj)/plugins/trace_plugin_dir $(obj)/plugins/trace_python_dir
+	$(Q)$(MAKE) -C $(src)/plugins
 
 tc_version.h: force
 	$(Q)$(N)$(call update_version.h)
 
-define update_dir
-	(echo $1 > $@.tmp;	\
-	if [ -r $@ ] && cmp -s $@ $@.tmp; then		\
-		rm -f $@.tmp;				\
-	else						\
-		echo '  UPDATE                 $@';	\
-		mv -f $@.tmp $@;			\
-	fi);
-endef
+$(obj)/plugins/trace_plugin_dir: force
+	$(Q)$(MAKE) -C $(src)/plugins trace_plugin_dir
 
-trace_plugin_dir: force
-	$(Q)$(N)$(call update_dir, 'PLUGIN_DIR=$(PLUGIN_DIR)')
+$(obj)/plugins/trace_python_dir: force
+	$(Q)$(MAKE) -C $(src)/plugins trace_python_dir
 
-trace_python_dir: force
-	$(Q)$(N)$(call update_dir, 'PYTHON_DIR=$(PYTHON_DIR)')
 
 ## make deps
 
@@ -392,28 +369,8 @@ cscope: force
 	$(RM) cscope*
 	$(call find_tag_files) | cscope -b -q
 
-PLUGINS_INSTALL = $(subst .so,.install,$(PLUGINS)) $(subst .so,.install,$(PYTHON_PLUGINS))
-
-define do_install
-	$(print_install)				\
-	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
-		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
-	fi;						\
-	$(INSTALL) $1 '$(DESTDIR_SQ)$2'
-endef
-
-define do_install_data
-	$(print_install)				\
-	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
-		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
-	fi;						\
-	$(INSTALL) -m 644 $1 '$(DESTDIR_SQ)$2'
-endef
-
-$(PLUGINS_INSTALL): %.install : %.so force
-	$(Q)$(call do_install_data,$<,$(plugin_dir_SQ))
-
-install_plugins: $(PLUGINS_INSTALL)
+install_plugins: force
+	$(Q)$(MAKE) -C $(src)/plugins $@
 
 $(PYTHON_SO_INSTALL): %.install : %.so force
 	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
@@ -465,6 +422,7 @@ clean:
 	$(MAKE) -C $(src)/lib/traceevent clean
 	$(MAKE) -C $(src)/lib/trace-cmd clean
 	$(MAKE) -C $(src)/kernel-shark clean
+	$(MAKE) -C $(src)/plugins clean
 
 
 ##### PYTHON STUFF #####
@@ -479,6 +437,10 @@ PYTHON_LDFLAGS = `pkg-config --libs $(PYTHON_VERS)` \
 		$(shell python2 -c "import distutils.sysconfig; print distutils.sysconfig.get_config_var('LINKFORSHARED')")
 PYGTK_CFLAGS = `pkg-config --cflags pygtk-2.0`
 
+export PYTHON_INCLUDES
+export PYTHON_LDFLAGS
+export PYGTK_CFLAGS
+
 ctracecmd.so: $(TCMD_LIB_OBJS) ctracecmd.i
 	swig -Wall -python -noproxy -I$(src)/include/traceevent -I$(src)/include/trace-cmd ctracecmd.i
 	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
@@ -498,21 +460,8 @@ python-gui: $(PYTHON_GUI)
 PHONY += python-plugin
 python-plugin: $(PYTHON_PLUGINS)
 
-CFLAGS_plugin_python.o += $(PYTHON_DIR_SQ)
-
-do_compile_python_plugin_obj =			\
-	($(print_plugin_obj_compile)		\
-	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(CFLAGS_$@) $(PYTHON_INCLUDES) -fPIC -o $@ $<)
-
-do_python_plugin_build =			\
-	($(print_plugin_build)			\
-	$(CC) $< -shared $(LDFLAGS) $(PYTHON_LDFLAGS) -o $@)
-
-plugin_python.o: %.o : $(src)/%.c trace_python_dir
-	$(Q)$(do_compile_python_plugin_obj)
-
-plugin_python.so: %.so: %.o
-	$(Q)$(do_python_plugin_build)
+plugin_python.so: force $(obj)/plugins/trace_python_dir
+	$(Q)$(MAKE) -C $(src)/plugins plugin_python.so
 
 dist:
 	git archive --format=tar --prefix=trace-cmd-$(TRACECMD_VERSION)/ HEAD \
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index dcb5cd5..e8fb088 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -28,6 +28,8 @@ libtracecmd.so: $(OBJS)
 %.o: %.c
 	$(Q)$(call do_fpic_compile)
 
+trace-util.o: $(obj)/plugins/trace_plugin_dir
+
 $(DEPS): .%.d: %.c
 	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
 
diff --git a/plugins/Makefile b/plugins/Makefile
new file mode 100644
index 0000000..7a09b82
--- /dev/null
+++ b/plugins/Makefile
@@ -0,0 +1,69 @@
+include $(src)/scripts/utils.mk
+
+PLUGIN_OBJS =
+PLUGIN_OBJS += plugin_jbd2.o
+PLUGIN_OBJS += plugin_hrtimer.o
+PLUGIN_OBJS += plugin_kmem.o
+PLUGIN_OBJS += plugin_kvm.o
+PLUGIN_OBJS += plugin_mac80211.o
+PLUGIN_OBJS += plugin_sched_switch.o
+PLUGIN_OBJS += plugin_function.o
+PLUGIN_OBJS += plugin_xen.o
+PLUGIN_OBJS += plugin_scsi.o
+PLUGIN_OBJS += plugin_cfg80211.o
+PLUGIN_OBJS += plugin_blk.o
+PLUGIN_OBJS += plugin_tlb.o
+
+PLUGINS := $(PLUGIN_OBJS:.o=.so)
+DEPS := $(PLUGIN_OBJS:%.o=.%.d)
+
+all: $(PLUGINS)
+
+$(PLUGIN_OBJS): %.o : %.c
+	$(Q)$(do_compile_plugin_obj)
+
+$(PLUGINS): %.so: %.o
+	$(Q)$(do_plugin_build)
+
+$(DEPS): .%.d: %.c
+	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
+
+$(PLUGIN_OBJS): %.o : .%.d
+
+CFLAGS_plugin_python.o += $(PYTHON_DIR_SQ)
+
+plugin_python.o: %.o : %.c trace_python_dir
+	$(Q)$(do_compile_python_plugin_obj)
+
+plugin_python.so: %.so: %.o
+	$(Q)$(do_python_plugin_build)
+
+PLUGINS_INSTALL = $(subst .so,.install,$(PLUGINS)) $(subst .so,.install,$(PYTHON_PLUGINS))
+
+$(PLUGINS_INSTALL): %.install : %.so force
+	$(Q)$(call do_install_data,$<,$(plugin_dir_SQ))
+
+install_plugins: $(PLUGINS_INSTALL)
+
+# The following targets are necessary to trigger a rebuild when $(PLUGIN_DIR)
+# and $(PYTHON_DIR) change. Without them, a full clean build would necessary
+# in order to get the binaries updated.
+
+trace_plugin_dir: force
+	$(Q)$(N)$(call update_dir, 'PLUGIN_DIR=$(PLUGIN_DIR)')
+
+trace_python_dir: force
+	$(Q)$(N)$(call update_dir, 'PYTHON_DIR=$(PYTHON_DIR)')
+
+
+dep_includes := $(wildcard $(DEPS))
+
+ifneq ($(dep_includes),)
+  include $(dep_includes)
+endif
+
+clean:
+	$(RM) *.a *.so *.o .*.d trace_plugin_dir trace_python_dir
+
+force:
+.PHONY: clean force
\ No newline at end of file
diff --git a/plugin_blk.c b/plugins/plugin_blk.c
similarity index 100%
rename from plugin_blk.c
rename to plugins/plugin_blk.c
diff --git a/plugin_cfg80211.c b/plugins/plugin_cfg80211.c
similarity index 100%
rename from plugin_cfg80211.c
rename to plugins/plugin_cfg80211.c
diff --git a/plugin_function.c b/plugins/plugin_function.c
similarity index 100%
rename from plugin_function.c
rename to plugins/plugin_function.c
diff --git a/plugin_hrtimer.c b/plugins/plugin_hrtimer.c
similarity index 100%
rename from plugin_hrtimer.c
rename to plugins/plugin_hrtimer.c
diff --git a/plugin_jbd2.c b/plugins/plugin_jbd2.c
similarity index 100%
rename from plugin_jbd2.c
rename to plugins/plugin_jbd2.c
diff --git a/plugin_kmem.c b/plugins/plugin_kmem.c
similarity index 100%
rename from plugin_kmem.c
rename to plugins/plugin_kmem.c
diff --git a/plugin_kvm.c b/plugins/plugin_kvm.c
similarity index 100%
rename from plugin_kvm.c
rename to plugins/plugin_kvm.c
diff --git a/plugin_mac80211.c b/plugins/plugin_mac80211.c
similarity index 100%
rename from plugin_mac80211.c
rename to plugins/plugin_mac80211.c
diff --git a/plugin_python.c b/plugins/plugin_python.c
similarity index 100%
rename from plugin_python.c
rename to plugins/plugin_python.c
diff --git a/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
similarity index 100%
rename from plugin_sched_switch.c
rename to plugins/plugin_sched_switch.c
diff --git a/plugin_scsi.c b/plugins/plugin_scsi.c
similarity index 100%
rename from plugin_scsi.c
rename to plugins/plugin_scsi.c
diff --git a/plugin_tlb.c b/plugins/plugin_tlb.c
similarity index 100%
rename from plugin_tlb.c
rename to plugins/plugin_tlb.c
diff --git a/plugin_xen.c b/plugins/plugin_xen.c
similarity index 100%
rename from plugin_xen.c
rename to plugins/plugin_xen.c
diff --git a/scripts/utils.mk b/scripts/utils.mk
index abfe115..31fc9e9 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -62,6 +62,13 @@ do_plugin_build =				\
 	($(print_plugin_build)			\
 	$(CC) $(CFLAGS) $(LDFLAGS) -shared -nostartfiles -o $@ $<)
 
+do_compile_python_plugin_obj =			\
+	($(print_plugin_obj_compile)		\
+	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(CFLAGS_$@) $(PYTHON_INCLUDES) -fPIC -o $@ $<)
+
+do_python_plugin_build =			\
+	($(print_plugin_build)			\
+	$(CC) $< -shared $(LDFLAGS) $(PYTHON_LDFLAGS) -o $@)
 
 define make_version.h
 	(echo '/* This file is automatically generated. Do not modify. */';		\
@@ -83,3 +90,28 @@ define update_version.h
 	fi);
 endef
 
+define update_dir
+	(echo $1 > $@.tmp;	\
+	if [ -r $@ ] && cmp -s $@ $@.tmp; then		\
+		rm -f $@.tmp;				\
+	else						\
+		echo '  UPDATE                 $@';	\
+		mv -f $@.tmp $@;			\
+	fi);
+endef
+
+define do_install
+	$(print_install)				\
+	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
+	fi;						\
+	$(INSTALL) $1 '$(DESTDIR_SQ)$2'
+endef
+
+define do_install_data
+	$(print_install)				\
+	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
+	fi;						\
+	$(INSTALL) -m 644 $1 '$(DESTDIR_SQ)$2'
+endef
-- 
2.14.1
