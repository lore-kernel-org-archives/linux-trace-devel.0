Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-pg0-f68.google.com ([74.125.83.68]:46674 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752539AbeBFItw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 03:49:52 -0500
Received: by mail-pg0-f68.google.com with SMTP id a11so534379pgu.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Feb 2018 00:49:52 -0800 (PST)
From: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Subject: [PATCH v2 22/24] trace-cmd: Make the trace-cmd target buildable out-of-tree
Date: Tue,  6 Feb 2018 10:49:04 +0200
Message-Id: <20180206084906.9854-23-vladislav.valtchev@gmail.com>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch allows the trace-cmd app to be buildable out-of-tree when the 'O'
variable is set at command line while invoking make.

At this stage, when the 'O' variable is set, the out-of-tree build will fail
for some targets like 'gui' (as it *already* happens on the master branch): with
this patch the final goal of a fully working out-of-tree build gets closer.

In successive steps, the remaining Makefiles will be made to support out-of-tree
builds, until everything works.

NOTE: the regular in-tree build of all targets clearly continues to work.
Signed-off-by: Vladislav Valtchev (VMware) <vladislav.valtchev@gmail.com>
---
 Makefile          |  3 ++-
 tracecmd/Makefile | 33 ++++++++++++++++++++++-----------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
index a40bf28..edb83c3 100644
--- a/Makefile
+++ b/Makefile
@@ -189,6 +189,7 @@ INCLUDES += -I$(src)/lib/traceevent/include
 INCLUDES += -I$(src)/lib/trace-cmd/include
 INCLUDES += -I$(src)/kernel-shark/include
 INCLUDES += -I$(src)/tracecmd/include
+INCLUDES += -I$(obj)/tracecmd/include
 
 include $(src)/features.mk
 
@@ -249,7 +250,7 @@ gui: force $(CMD_TARGETS)
 	echo "gui build complete"
 
 trace-cmd: force $(LIBTRACEEVENT_STATIC) $(LIBTRACECMD_STATIC)
-	$(Q)$(MAKE) -C $(src)/tracecmd $@
+	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
 
 kernelshark: force $(CMD_TARGETS)
 	$(Q)$(MAKE) -C $(src)/kernel-shark $@
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 860dc89..3a11024 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -3,8 +3,10 @@ VERSION := $(TC_VERSION)
 PATCHLEVEL := $(TC_PATCHLEVEL)
 EXTRAVERSION := $(TC_EXTRAVERSION)
 
-TC_VERSION := $(obj)/tracecmd/include/tc_version.h
-TARGETS = trace-cmd $(TC_VERSION)
+bdir:=$(obj)/tracecmd
+
+TC_VERSION := $(bdir)/include/tc_version.h
+TARGETS = $(bdir)/trace-cmd $(TC_VERSION)
 
 BUILDGUI := 0
 include $(src)/scripts/utils.mk
@@ -31,10 +33,10 @@ TRACE_CMD_OBJS += trace-output.o
 TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-msg.o
 
-ALL_OBJS = $(TRACE_CMD_OBJS)
+ALL_OBJS := $(TRACE_CMD_OBJS:%.o=$(bdir)/%.o)
 
 all_objs := $(sort $(ALL_OBJS))
-all_deps := $(all_objs:%.o=.%.d)
+all_deps := $(all_objs:$(bdir)/%.o=$(bdir)/.%.d)
 
 CONFIG_INCLUDES =
 CONFIG_LIBS	=
@@ -42,23 +44,32 @@ CONFIG_FLAGS	=
 
 all: $(TARGETS)
 
-$(TC_VERSION): force
+$(bdir):
+	@mkdir -p $(bdir)
+
+$(bdir)/include: | $(bidr)
+	@mkdir -p $(bdir)/include
+
+$(TC_VERSION): force | $(bdir)/include
 	$(Q)$(call update_version.h)
 
-trace-cmd: $(ALL_OBJS)
+$(all_deps): | $(bdir)
+$(all_objs): | $(bdir)
+
+$(bdir)/trace-cmd: $(ALL_OBJS)
 	$(Q)$(do_app_build)
 
-trace-cmd: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC)
+$(bdir)/trace-cmd: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC)
 
-%.o: %.c
+$(bdir)/%.o: %.c
 	$(Q)$(call do_compile)
 
-$(all_deps): .%.d: %.c
+$(all_deps): $(bdir)/.%.d: %.c
 	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
 
 $(all_deps): $(TC_VERSION)
 
-$(all_objs): %.o : .%.d
+$(all_objs): $(bdir)/%.o : $(bdir)/.%.d
 
 dep_includes := $(wildcard $(DEPS))
 
@@ -67,7 +78,7 @@ ifneq ($(dep_includes),)
 endif
 
 clean:
-	$(RM) *.a *.so *.o .*.d $(TARGETS)
+	$(RM) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d $(TARGETS)
 
 force:
 .PHONY: clean
-- 
2.14.1
