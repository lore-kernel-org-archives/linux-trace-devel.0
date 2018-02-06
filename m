Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pl0-f66.google.com ([209.85.160.66]:36675 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752278AbeBFItt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:49 -0500
Received: by mail-pl0-f66.google.com with SMTP id v3so855183plg.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:49 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 20/24] trace-cmd: Make the plugins buildable out-of-tree
Date: Tue,  6 Feb 2018 10:49:02 +0200
Message-Id: <20180206084906.9854-21-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch allows the plugins to be buildable out-of-tree when the 'O' variable
is set at command line while invoking make.

At this stage, when the 'O' variable is set, the out-of-tree build will fail (as
it *already* does on the master branch) but with errors unrelated with the
plugins: with this patch the final goal of a fully working out-of-tree build
gets closer.

In successive steps, the remaining Makefiles will be made to support out-of-tree
builds, until everything works.

NOTE: the regular in-tree build of all targets clearly continues to work.
Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile         | 10 +++++-----
 plugins/Makefile | 37 ++++++++++++++++++++++---------------
 scripts/utils.mk |  2 +-
 3 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/Makefile b/Makefile
index 6cd54d9..df20885 100644
--- a/Makefile
+++ b/Makefile
@@ -261,10 +261,10 @@ trace-graph: force $(CMD_TARGETS)
 	$(Q)$(MAKE) -C $(src)/kernel-shark $@
 
 $(LIBTRACEEVENT_SHARED): force
-	$(Q)$(MAKE) -C $(src)/lib/traceevent $(obj)/lib/traceevent/libtraceevent.so
+	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
 
 $(LIBTRACEEVENT_STATIC): force
-	$(Q)$(MAKE) -C $(src)/lib/traceevent $(obj)/lib/traceevent/libtraceevent.a
+	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
 
 $(LIBTRACECMD_STATIC): force $(obj)/plugins/trace_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd libtracecmd.a
@@ -283,10 +283,10 @@ plugins: force $(obj)/plugins/trace_plugin_dir $(obj)/plugins/trace_python_dir
 	$(Q)$(MAKE) -C $(src)/plugins
 
 $(obj)/plugins/trace_plugin_dir: force
-	$(Q)$(MAKE) -C $(src)/plugins trace_plugin_dir
+	$(Q)$(MAKE) -C $(src)/plugins $@
 
 $(obj)/plugins/trace_python_dir: force
-	$(Q)$(MAKE) -C $(src)/plugins trace_python_dir
+	$(Q)$(MAKE) -C $(src)/plugins $@
 
 show_gui_make:
 	@echo "Note: to build the gui, type \"make gui\""
@@ -395,7 +395,7 @@ PHONY += python-plugin
 python-plugin: $(PYTHON_PLUGINS)
 
 plugin_python.so: force $(obj)/plugins/trace_python_dir
-	$(Q)$(MAKE) -C $(src)/plugins plugin_python.so
+	$(Q)$(MAKE) -C $(src)/plugins $(obj)/plugins/plugin_python.so
 
 dist:
 	git archive --format=tar --prefix=trace-cmd-$(TRACECMD_VERSION)/ HEAD \
diff --git a/plugins/Makefile b/plugins/Makefile
index 7a09b82..cff71f1 100644
--- a/plugins/Makefile
+++ b/plugins/Makefile
@@ -1,5 +1,7 @@
 include $(src)/scripts/utils.mk
 
+bdir:=$(obj)/plugins
+
 PLUGIN_OBJS =
 PLUGIN_OBJS += plugin_jbd2.o
 PLUGIN_OBJS += plugin_hrtimer.o
@@ -14,33 +16,38 @@ PLUGIN_OBJS += plugin_cfg80211.o
 PLUGIN_OBJS += plugin_blk.o
 PLUGIN_OBJS += plugin_tlb.o
 
-PLUGINS := $(PLUGIN_OBJS:.o=.so)
-DEPS := $(PLUGIN_OBJS:%.o=.%.d)
+PLUGIN_OBJS := $(PLUGIN_OBJS:%.o=$(bdir)/%.o)
+PLUGINS := $(PLUGIN_OBJS:$(bdir)/%.o=$(bdir)/%.so)
+DEPS := $(PLUGIN_OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 
 all: $(PLUGINS)
 
-$(PLUGIN_OBJS): %.o : %.c
+$(bdir):
+	@mkdir -p $(bdir)
+
+$(PLUGIN_OBJS): | $(bdir)
+$(DEPS): | $(bdir)
+
+$(PLUGIN_OBJS): $(bdir)/%.o : %.c
 	$(Q)$(do_compile_plugin_obj)
 
-$(PLUGINS): %.so: %.o
+$(PLUGINS): $(bdir)/%.so: $(bdir)/%.o
 	$(Q)$(do_plugin_build)
 
-$(DEPS): .%.d: %.c
+$(DEPS): $(bdir)/.%.d: %.c
 	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
 
-$(PLUGIN_OBJS): %.o : .%.d
+$(PLUGIN_OBJS): $(bdir)/%.o : $(bdir)/.%.d
 
-CFLAGS_plugin_python.o += $(PYTHON_DIR_SQ)
-
-plugin_python.o: %.o : %.c trace_python_dir
+$(bdir)/plugin_python.o: $(bdir)/%.o : %.c $(bdir)/trace_python_dir
 	$(Q)$(do_compile_python_plugin_obj)
 
-plugin_python.so: %.so: %.o
+$(bdir)/plugin_python.so: $(bdir)/%.so: $(bdir)/%.o
 	$(Q)$(do_python_plugin_build)
 
-PLUGINS_INSTALL = $(subst .so,.install,$(PLUGINS)) $(subst .so,.install,$(PYTHON_PLUGINS))
+PLUGINS_INSTALL = $(subst .so,.install,$(PLUGINS))
 
-$(PLUGINS_INSTALL): %.install : %.so force
+$(PLUGINS_INSTALL): $(bdir)/%.install : $(bdir)/%.so force
 	$(Q)$(call do_install_data,$<,$(plugin_dir_SQ))
 
 install_plugins: $(PLUGINS_INSTALL)
@@ -49,10 +56,10 @@ install_plugins: $(PLUGINS_INSTALL)
 # and $(PYTHON_DIR) change. Without them, a full clean build would necessary
 # in order to get the binaries updated.
 
-trace_plugin_dir: force
+$(bdir)/trace_plugin_dir: $(bdir) force
 	$(Q)$(N)$(call update_dir, 'PLUGIN_DIR=$(PLUGIN_DIR)')
 
-trace_python_dir: force
+$(bdir)/trace_python_dir: $(bdir) force
 	$(Q)$(N)$(call update_dir, 'PYTHON_DIR=$(PYTHON_DIR)')
 
 
@@ -63,7 +70,7 @@ ifneq ($(dep_includes),)
 endif
 
 clean:
-	$(RM) *.a *.so *.o .*.d trace_plugin_dir trace_python_dir
+	$(RM) -f $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d $(bdir)/trace_plugin_dir $(bdir)/trace_python_dir
 
 force:
 .PHONY: clean force
\ No newline at end of file
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 043a68a..06e8dc3 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -64,7 +64,7 @@ do_plugin_build =				\
 
 do_compile_python_plugin_obj =			\
 	($(print_plugin_obj_compile)		\
-	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(CFLAGS_$@) $(PYTHON_INCLUDES) -fPIC -o $@ $<)
+	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_DIR_SQ) $(PYTHON_INCLUDES) -fPIC -o $@ $<)
 
 do_python_plugin_build =			\
 	($(print_plugin_build)			\
-- 
2.14.1
