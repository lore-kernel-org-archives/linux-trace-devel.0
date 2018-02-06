Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33291 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752628AbeBFItq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:46 -0500
Received: by mail-pf0-f195.google.com with SMTP id u15so318206pfa.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:46 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 19/24] trace-cmd: Make libtraceevent builable out-of-tree
Date: Tue,  6 Feb 2018 10:49:01 +0200
Message-Id: <20180206084906.9854-20-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch allows the libtraceevent to be buildable out-of-tree when the 'O'
variable is set at command line while invoking make.

At this stage, when the 'O' variable is set, the out-of-tree build will fail
(as it *already* does on the master branch) but with errors unrelated with
libtraceevent: with this patch the final goal of a fully working out-of-tree
build gets significantly closer.

In successive steps, the remaining Makefiles will be made to support out-of-tree
builds, until everything works.

NOTE: the regular in-tree build of all targets clearly continues to work.
Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile                | 31 +++++++++++--------------------
 lib/traceevent/Makefile | 25 +++++++++++++++++--------
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/Makefile b/Makefile
index 4f17dd3..6cd54d9 100644
--- a/Makefile
+++ b/Makefile
@@ -145,27 +145,18 @@ endef
 blk-flags := $(call test-build,$(BLK_TC_FLUSH_SOURCE),-DHAVE_BLK_TC_FLUSH)
 
 ifeq ("$(origin O)", "command line")
-  BUILD_OUTPUT := $(O)
+
+  saved-output := $(O)
+  BUILD_OUTPUT := $(shell cd $(O) && /bin/pwd)
+  $(if $(BUILD_OUTPUT),, \
+    $(error output directory "$(saved-output)" does not exist))
+
+else
+  BUILD_OUTPUT = $(CURDIR)
 endif
 
-ifeq ($(BUILD_SRC),)
-ifneq ($(BUILD_OUTPUT),)
-
-define build_output
-	$(if $(VERBOSE:1=),@)$(MAKE) -C $(BUILD_OUTPUT) 	\
-	BUILD_SRC=$(CURDIR) -f $(CURDIR)/Makefile $1
-endef
-
-saved-output := $(BUILD_OUTPUT)
-BUILD_OUTPUT := $(shell cd $(BUILD_OUTPUT) && /bin/pwd)
-$(if $(BUILD_OUTPUT),, \
-     $(error output directory "$(saved-output)" does not exist))
-
-endif # BUILD_OUTPUT
-endif # BUILD_SRC
-
 srctree		:= $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR))
-objtree		:= $(CURDIR)
+objtree		:= $(BUILD_OUTPUT)
 src		:= $(srctree)
 obj		:= $(objtree)
 
@@ -270,10 +261,10 @@ trace-graph: force $(CMD_TARGETS)
 	$(Q)$(MAKE) -C $(src)/kernel-shark $@
 
 $(LIBTRACEEVENT_SHARED): force
-	$(Q)$(MAKE) -C $(src)/lib/traceevent libtraceevent.so
+	$(Q)$(MAKE) -C $(src)/lib/traceevent $(obj)/lib/traceevent/libtraceevent.so
 
 $(LIBTRACEEVENT_STATIC): force
-	$(Q)$(MAKE) -C $(src)/lib/traceevent libtraceevent.a
+	$(Q)$(MAKE) -C $(src)/lib/traceevent $(obj)/lib/traceevent/libtraceevent.a
 
 $(LIBTRACECMD_STATIC): force $(obj)/plugins/trace_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd libtracecmd.a
diff --git a/lib/traceevent/Makefile b/lib/traceevent/Makefile
index f9c595c..60246aa 100644
--- a/lib/traceevent/Makefile
+++ b/lib/traceevent/Makefile
@@ -2,7 +2,9 @@
 
 include $(src)/scripts/utils.mk
 
-DEFAULT_TARGET = libtraceevent.a
+bdir:=$(obj)/lib/traceevent
+
+DEFAULT_TARGET = $(bdir)/libtraceevent.a
 
 OBJS =
 OBJS += event-parse.o
@@ -15,23 +17,30 @@ OBJS += parse-utils.o
 # Additional util objects
 OBJS += str_error_r.o
 
-DEPS := $(OBJS:%.o=.%.d)
+OBJS := $(OBJS:%.o=$(bdir)/%.o)
+DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 
 all: $(DEFAULT_TARGET)
 
-libtraceevent.a: $(OBJS)
+$(bdir):
+	@mkdir -p $(bdir)
+
+$(OBJS): | $(bdir)
+$(DEPS): | $(bdir)
+
+$(bdir)/libtraceevent.a: $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
-libtraceevent.so: $(OBJS)
+$(bdir)/libtraceevent.so: $(OBJS)
 	$(Q)$(call do_compile_shared_library)
 
-%.o: %.c
+$(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
-$(DEPS): .%.d: %.c
+$(DEPS): $(bdir)/.%.d: %.c
 	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
 
-$(OBJS): %.o : .%.d
+$(OBJS): $(bdir)/%.o : $(bdir)/.%.d
 
 dep_includes := $(wildcard $(DEPS))
 
@@ -40,6 +49,6 @@ ifneq ($(dep_includes),)
 endif
 
 clean:
-	$(RM) *.a *.so *.o .*.d
+	$(RM) -f $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d
 
 .PHONY: clean
-- 
2.14.1
