Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E340C4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0395F23F38
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392307AbgLKRMJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:12:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394869AbgLKRLm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 12:11:42 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF7EC23EF4
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 17:10:15 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knlvr-000HiK-02
        for linux-trace-devel@vger.kernel.org; Fri, 11 Dec 2020 12:10:15 -0500
Message-ID: <20201211171014.867885861@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 11 Dec 2020 12:08:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 12/13] trace-cmd: Do not build shared libraries for libtracefs and
 libtraceevent
References: <20201211170842.611554918@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As libtraceevent and libtracefs are now packaged separately and are built
from their own corresponding repos, the local copy that trace-cmd uses is
only in the case that the libraries are not present on the local system.
In this case, trace-cmd should build its wont static library and link to
that. This will be deprecated in the future and trace-cmd will eventually
depend on the external libraries for libtracefs and libtraceevent.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                | 13 +------------
 lib/traceevent/Makefile |  5 +----
 lib/tracefs/Makefile    |  5 +----
 3 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/Makefile b/Makefile
index 737e54d82697..1f7cab57cd7d 100644
--- a/Makefile
+++ b/Makefile
@@ -234,12 +234,10 @@ export LIBTRACECMD_SHARED_VERSION LIBTRACECMD_SHARED_SO
 LIBTRACEEVENT=libtraceevent
 LIBTRACEEVENT_DIR = $(obj)/lib/traceevent
 LIBTRACEEVENT_STATIC = $(LIBTRACEEVENT_DIR)/libtraceevent.a
-LIBTRACEEVENT_SHARED = $(LIBTRACEEVENT_DIR)/libtraceevent.so
 
 LIBTRACEFS=libtracefs
 LIBTRACEFS_DIR = $(obj)/lib/tracefs
 LIBTRACEFS_STATIC = $(LIBTRACEFS_DIR)/libtracefs.a
-LIBTRACEFS_SHARED = $(LIBTRACEFS_DIR)/libtracefs.so
 
 ifeq ($(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y"), y)
 LIBTRACEEVENT_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT)")
@@ -369,10 +367,6 @@ trace-cmd: force $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACECMD_STATIC) $(LIBTRACEF
 	force $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir
 	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
 
-$(LIBTRACEEVENT_SHARED): force $(obj)/lib/traceevent/plugins/trace_python_dir \
-			 $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
-	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
-
 $(LIBTRACEEVENT_STATIC): force $(obj)/lib/traceevent/plugins/trace_python_dir \
 			 $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
@@ -386,17 +380,12 @@ $(LIBTRACECMD_SHARED): force $(LIBTRACEEVENT_SHARED_BUILD)
 $(LIBTRACEFS_STATIC): force
 	$(Q)$(MAKE) -C $(src)/lib/tracefs $@
 
-$(LIBTRACEFS_SHARED): force
-	$(Q)$(MAKE) -C $(src)/lib/tracefs $@
-
-libtraceevent.so: $(LIBTRACEEVENT_SHARED)
 libtraceevent.a: $(LIBTRACEEVENT_STATIC)
 libtracecmd.a: $(LIBTRACECMD_STATIC)
 libtracecmd.so: $(LIBTRACECMD_SHARED)
 libtracefs.a: $(LIBTRACEFS_STATIC)
-libtracefs.so: $(LIBTRACEFS_SHARED)
 
-libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED_BUILD) $(LIBTRACEFS_SHARED_BUILD)
+libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACEFS_STATIC_BUILD)
 
 test: force $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACEFS_STATIC_BUILD) $(LIBTRACECMD_STATIC)
 ifneq ($(CUNIT_INSTALLED),1)
diff --git a/lib/traceevent/Makefile b/lib/traceevent/Makefile
index 0f9e5db8f7df..edb2fccfff07 100644
--- a/lib/traceevent/Makefile
+++ b/lib/traceevent/Makefile
@@ -32,9 +32,6 @@ $(DEPS): | $(bdir)
 $(bdir)/libtraceevent.a: $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
-$(bdir)/libtraceevent.so: $(OBJS)
-	$(Q)$(call do_compile_shared_library)
-
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
@@ -50,6 +47,6 @@ ifneq ($(dep_includes),)
 endif
 
 clean:
-	$(RM) -f $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d
+	$(RM) -f $(bdir)/*.a $(bdir)/*.o $(bdir)/.*.d
 
 .PHONY: clean
diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
index 590a0ffed91a..33112690914d 100644
--- a/lib/tracefs/Makefile
+++ b/lib/tracefs/Makefile
@@ -29,9 +29,6 @@ LIBS = -L$(obj)/lib/traceevent -ltraceevent
 $(bdir)/libtracefs.a: $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
-$(bdir)/libtracefs.so: $(OBJS)
-	$(Q)$(call do_compile_shared_library)
-
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
@@ -47,6 +44,6 @@ ifneq ($(dep_includes),)
 endif
 
 clean:
-	$(RM) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d
+	$(RM) $(bdir)/*.a $(bdir)/*.o $(bdir)/.*.d
 
 .PHONY: clean
-- 
2.29.2


