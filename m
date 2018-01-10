Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f194.google.com ([209.85.128.194]:32948 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964976AbeAJP7C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 10:59:02 -0500
Received: by mail-wr0-f194.google.com with SMTP id p6so17824163wrd.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2018 07:59:01 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH 6/6] trace-cmd: Make the GUI targets buildable out-of-tree
Date: Wed, 10 Jan 2018 17:58:32 +0200
Message-Id: <20180110155832.15928-7-vladislav.valtchev@gmail.com>
In-Reply-To: <20180110155832.15928-1-vladislav.valtchev@gmail.com>
References: <20180110155832.15928-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch allows the GUI targets to be buildable out-of-tree when the 'O'
variable is set at command line while invoking make.

With this final patch, the out-of-tree build of all targets works.

Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile              |  9 +++++----
 kernel-shark/Makefile | 40 ++++++++++++++++++++++++++--------------
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/Makefile b/Makefile
index 88f252e..e9fe243 100644
--- a/Makefile
+++ b/Makefile
@@ -189,6 +189,7 @@ INCLUDES += -I$(src)/lib/trace-cmd/include
 INCLUDES += -I$(src)/kernel-shark/include
 INCLUDES += -I$(src)/tracecmd/include
 INCLUDES += -I$(obj)/tracecmd/include
+INCLUDES += -I$(obj)/kernel-shark/include
 
 include $(src)/features.mk
 
@@ -228,7 +229,7 @@ LIBS += -laudit
 endif
 
 # Append required CFLAGS
-override CFLAGS += $(CONFIG_FLAGS) $(INCLUDES) $(PLUGIN_DIR_SQ) $(VAR_DIR)
+override CFLAGS += $(INCLUDES) $(PLUGIN_DIR_SQ) $(VAR_DIR)
 override CFLAGS += $(udis86-flags) $(blk-flags)
 
 
@@ -252,13 +253,13 @@ trace-cmd: force $(LIBTRACEEVENT_STATIC) $(LIBTRACECMD_STATIC)
 	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
 
 kernelshark: force $(CMD_TARGETS)
-	$(Q)$(MAKE) -C $(src)/kernel-shark $@
+	$(Q)$(MAKE) -C $(src)/kernel-shark $(obj)/kernel-shark/$@
 
 trace-view: force $(CMD_TARGETS)
-	$(Q)$(MAKE) -C $(src)/kernel-shark $@
+	$(Q)$(MAKE) -C $(src)/kernel-shark $(obj)/kernel-shark/$@
 
 trace-graph: force $(CMD_TARGETS)
-	$(Q)$(MAKE) -C $(src)/kernel-shark $@
+	$(Q)$(MAKE) -C $(src)/kernel-shark $(obj)/kernel-shark/$@
 
 $(LIBTRACEEVENT_SHARED): force
 	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
diff --git a/kernel-shark/Makefile b/kernel-shark/Makefile
index 8e3ba8b..8576f3d 100644
--- a/kernel-shark/Makefile
+++ b/kernel-shark/Makefile
@@ -5,6 +5,8 @@ PATCHLEVEL	= 2
 EXTRAVERSION	=
 KERNELSHARK_VERSION = $(VERSION).$(PATCHLEVEL).$(EXTRAVERSION)
 
+bdir:=$(obj)/kernel-shark
+
 BUILDGUI := 1
 include $(src)/scripts/utils.mk
 
@@ -21,9 +23,9 @@ CONFIG_LIBS = $(shell pkg-config --libs $(PACKAGES))
 
 CONFIG_FLAGS += $(HELP_DIR_SQ)
 
-KS_VERSION := $(obj)/kernel-shark/include/ks_version.h
+KS_VERSION := $(bdir)/include/ks_version.h
 
-GUI_TARGETS = $(KS_VERSION) trace-graph trace-view kernelshark
+GUI_TARGETS = $(KS_VERSION) $(bdir)/trace-graph $(bdir)/trace-view $(bdir)/kernelshark
 
 TRACE_GUI_OBJS = trace-filter.o trace-compat.o trace-filter-hash.o \
 		 trace-dialog.o trace-xml.o
@@ -34,16 +36,17 @@ TRACE_GRAPH_MAIN_OBJS = trace-graph-main.o $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS)
 KERNEL_SHARK_OBJS = $(TRACE_VIEW_OBJS) $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS) \
 	trace-capture.o kernel-shark.o
 
+KERNEL_SHARK_OBJS := $(KERNEL_SHARK_OBJS:%.o=$(bdir)/%.o)
+TRACE_VIEW_MAIN_OBJS := $(TRACE_VIEW_MAIN_OBJS:%.o=$(bdir)/%.o)
+TRACE_GRAPH_MAIN_OBJS := $(TRACE_GRAPH_MAIN_OBJS:%.o=$(bdir)/%.o)
+
 ALL_OBJS = $(KERNEL_SHARK_OBJS) $(TRACE_VIEW_MAIN_OBJS) $(TRACE_GRAPH_MAIN_OBJS)
 PIC_OBJS = $(TRACE_VIEW_OBJS)
 
 all_objs := $(sort $(ALL_OBJS))
 pic_objs = $(sort $(PIC_OBJS))
-all_deps := $(all_objs:%.o=.%.d)
+all_deps := $(all_objs:$(bdir)/%.o=$(bdir)/.%.d)
 
-# Temporary HACK!
-# This hack is OK only until the non-gui builds do not have any config_includes
-# nor config flags. In case they do, keeping this hack might be a problem.
 override CFLAGS += $(CONFIG_INCLUDES) $(CONFIG_FLAGS)
 
 LIBS += -L$(LIBTRACEEVENT_DIR) -L$(LIBTRACECMD_DIR)
@@ -51,29 +54,38 @@ LIBS += -ltracecmd -ltraceevent -ldl
 
 all: $(GUI_TARGETS)
 
-$(KS_VERSION): force
+$(bdir):
+	@mkdir -p $(bdir)
+
+$(bdir)/include: | $(bdir)
+	@mkdir -p $(bdir)/include
+
+$(all_objs): | $(bdir)
+$(all_deps): | $(bdir)
+
+$(KS_VERSION): force | $(bdir)/include
 	$(Q)$(call update_version.h)
 
-kernelshark: $(KERNEL_SHARK_OBJS)
+$(bdir)/kernelshark: $(KERNEL_SHARK_OBJS)
 	$(Q)$(do_app_build)
 
-trace-view: $(TRACE_VIEW_MAIN_OBJS)
+$(bdir)/trace-view: $(TRACE_VIEW_MAIN_OBJS)
 	$(Q)$(do_app_build)
 
-trace-graph: $(TRACE_GRAPH_MAIN_OBJS)
+$(bdir)/trace-graph: $(TRACE_GRAPH_MAIN_OBJS)
 	$(Q)$(do_app_build)
 
 $(pic_objs): GENERATE_PIC := 1
 
-%.o: %.c
+$(bdir)/%.o: %.c
 	$(Q)$(call do_compile)
 
-$(all_deps): .%.d: %.c
+$(all_deps): $(bdir)/.%.d: %.c
 	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
 
 $(all_deps): $(KS_VERSION)
 
-$(all_objs): %.o : .%.d
+$(all_objs): $(bdir)/%.o : $(bdir)/.%.d
 
 dep_includes := $(wildcard $(DEPS))
 
@@ -82,7 +94,7 @@ ifneq ($(dep_includes),)
 endif
 
 clean:
-	$(RM) *.a *.so *.o .*.d $(GUI_TARGETS)
+	$(RM) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d $(GUI_TARGETS)
 
 force:
 .PHONY: clean
-- 
2.14.1
