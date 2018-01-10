Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f193.google.com ([209.85.128.193]:44365 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964976AbeAJP66 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 10:58:58 -0500
Received: by mail-wr0-f193.google.com with SMTP id w50so8612017wrc.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2018 07:58:58 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH 3/6] trace-cmd: Make libtracecmd buildable out-of-tree
Date: Wed, 10 Jan 2018 17:58:29 +0200
Message-Id: <20180110155832.15928-4-vladislav.valtchev@gmail.com>
In-Reply-To: <20180110155832.15928-1-vladislav.valtchev@gmail.com>
References: <20180110155832.15928-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch allows the libtracecmd to be buildable out-of-tree when the 'O'
variable is set at command line while invoking make.

At this stage, when the 'O' variable is set, the out-of-tree build will fail (as
it *already* does on the master branch) but with errors unrelated with
libtracecmd: with this patch the final goal of a fully working out-of-tree build
gets closer.

In successive steps, the remaining Makefiles will be made to support out-of-tree
builds, until everything works.

NOTE: the regular in-tree build of all targets clearly continues to work.
Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile               |  4 ++--
 lib/trace-cmd/Makefile | 27 ++++++++++++++++++---------
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/Makefile b/Makefile
index 73e14e8..3b71206 100644
--- a/Makefile
+++ b/Makefile
@@ -266,10 +266,10 @@ $(LIBTRACEEVENT_STATIC): force
 	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
 
 $(LIBTRACECMD_STATIC): force $(obj)/plugins/trace_plugin_dir
-	$(Q)$(MAKE) -C $(src)/lib/trace-cmd libtracecmd.a
+	$(Q)$(MAKE) -C $(src)/lib/trace-cmd $@
 
 $(LIBTRACECMD_SHARED): force $(obj)/plugins/trace_plugin_dir
-	$(Q)$(MAKE) -C $(src)/lib/trace-cmd libtracecmd.so
+	$(Q)$(MAKE) -C $(src)/lib/trace-cmd $@
 
 libtraceevent.so: $(LIBTRACEEVENT_SHARED)
 libtraceevent.a: $(LIBTRACEEVENT_STATIC)
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index e8fb088..ee09099 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -2,7 +2,9 @@
 
 include $(src)/scripts/utils.mk
 
-DEFAULT_TARGET = libtracecmd.a
+bdir:=$(obj)/lib/trace-cmd
+
+DEFAULT_TARGET = $(bdir)/libtracecmd.a
 
 OBJS =
 OBJS += trace-hash.o
@@ -15,25 +17,32 @@ OBJS += trace-util.o
 OBJS += trace-blk-hack.o
 OBJS += trace-ftrace.o
 
-DEPS := $(OBJS:%.o=.%.d)
+OBJS := $(OBJS:%.o=$(bdir)/%.o)
+DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 
 all: $(DEFAULT_TARGET)
 
-libtracecmd.a: $(OBJS)
+$(bdir):
+	@mkdir -p $(bdir)
+
+$(OBJS): | $(bdir)
+$(DEPS): | $(bdir)
+
+$(bdir)/libtracecmd.a: $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
-libtracecmd.so: $(OBJS)
+$(bdir)/libtracecmd.so: $(OBJS)
 	$(Q)$(call do_compile_shared_library)
 
-%.o: %.c
+$(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
-trace-util.o: $(obj)/plugins/trace_plugin_dir
+$(bdir)/trace-util.o: $(obj)/plugins/trace_plugin_dir
 
-$(DEPS): .%.d: %.c
+$(DEPS): $(bdir)/.%.d: %.c
 	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
 
-$(OBJS): %.o : .%.d
+$(OBJS): $(bdir)/%.o : $(bdir)/.%.d
 
 dep_includes := $(wildcard $(DEPS))
 
@@ -42,6 +51,6 @@ ifneq ($(dep_includes),)
 endif
 
 clean:
-	$(RM) *.a *.so *.o .*.d
+	$(RM) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d
 
 .PHONY: clean
-- 
2.14.1
