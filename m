Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DCEC4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D511F23F29
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393724AbgLKRLU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:11:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393784AbgLKRLA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 12:11:00 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A334623EB2
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 17:10:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knlvp-000HeS-MU
        for linux-trace-devel@vger.kernel.org; Fri, 11 Dec 2020 12:10:13 -0500
Message-ID: <20201211171013.568512006@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 11 Dec 2020 12:08:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 04/13] trace-cmd: Add versioning to libtracecmd.so
References: <20201211170842.611554918@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In preparation to installing libtracecmd.so as a system library, it is
required that it has a versioning in the name. Add three levels:

 LIBTC_VERSION : The main version level that is updated on breakage of apiS
 LIBTC_PATCHLEVEL: That is updated for new functionality
 LIBTC_EXTRAVERSION: That is updated for minor bug fixes

The main .so binary will have the full version which includes:

 libtracecmd.so.$(LIBTC_VERSION).$(LIBTC_PATCHLEVEL).$(LIBTC_EXTRAVERSION)

Then soft links will be created to this as follows:

 libtracecmd.so -> libtracecmd.so.$(LIBTC_VERSION)
 libtracecmd.so.$(LIBTC_VERSION) ->
      libtracecmd.so.$(LIBTC_VERSION).$(LIBTC_PATCHLEVEL).$(LIBTC_EXTRAVERSION)

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile               | 14 ++++++++++++--
 lib/trace-cmd/Makefile | 19 +++++++++++++++++--
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 8edd217b87b5..ea07e9ee7081 100644
--- a/Makefile
+++ b/Makefile
@@ -10,6 +10,16 @@ export TC_PATCHLEVEL
 export TC_EXTRAVERSION
 export TRACECMD_VERSION
 
+LIBTC_VERSION = 0
+LIBTC_PATCHLEVEL = 0
+LIBTC_EXTRAVERSION = 1
+LIBTRACECMD_VERSION = $(LIBTC_VERSION).$(LIBTC_PATCHLEVEL).$(LIBTC_EXTRAVERSION)
+
+export LIBTC_VERSION
+export LIBTC_PATCHLEVEL
+export LIBTC_EXTRAVERSION
+export LIBTRACECMD_VERSION
+
 MAKEFLAGS += --no-print-directory
 
 # Makefiles suck: This macro sets a default value of $(2) for the
@@ -200,7 +210,7 @@ LIBTRACEEVENT_SHARED = $(LIBTRACEEVENT_DIR)/libtraceevent.so
 
 LIBTRACECMD_DIR = $(obj)/lib/trace-cmd
 LIBTRACECMD_STATIC = $(LIBTRACECMD_DIR)/libtracecmd.a
-LIBTRACECMD_SHARED = $(LIBTRACECMD_DIR)/libtracecmd.so
+LIBTRACECMD_SHARED = $(LIBTRACECMD_DIR)/libtracecmd.so.$(LIBTRACECMD_VERSION)
 
 LIBTRACEFS=libtracefs
 LIBTRACEFS_DIR = $(obj)/lib/tracefs
@@ -347,7 +357,7 @@ $(LIBTRACECMD_STATIC): force
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd $@
 
 $(LIBTRACECMD_SHARED): force $(LIBTRACEEVENT_SHARED_BUILD)
-	$(Q)$(MAKE) -C $(src)/lib/trace-cmd $@
+	$(Q)$(MAKE) -C $(src)/lib/trace-cmd libtracecmd.so
 
 $(LIBTRACEFS_STATIC): force
 	$(Q)$(MAKE) -C $(src)/lib/tracefs $@
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 42f1f5c447eb..ec68831de610 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -40,7 +40,19 @@ $(LIBTRACECMD_STATIC): $(OBJS)
 
 LIBS = -L$(obj)/lib/traceevent -ltraceevent
 
-$(bdir)/libtracecmd.so: $(OBJS)
+LIBTRACECMD_SHARED_VERSION = $(shell echo $(LIBTRACECMD_SHARED) | sed -e 's/\(\.so\.[0-9]*\).*/\1/')
+
+LIBTRACECMD_SHARED_SO = $(shell echo $(LIBTRACECMD_SHARED) | sed -e 's/\(\.so\).*/\1/')
+
+$(LIBTRACECMD_SHARED_VERSION): $(LIBTRACECMD_SHARED)
+	@ln -sf $(<F) $@
+
+$(LIBTRACECMD_SHARED_SO): $(LIBTRACECMD_SHARED_VERSION)
+	@ln -sf $(<F) $@
+
+libtracecmd.so: force $(LIBTRACECMD_SHARED_SO)
+
+$(LIBTRACECMD_SHARED): $(OBJS)
 	$(Q)$(call do_compile_shared_library)
 
 $(bdir)/%.o: %.c
@@ -58,6 +70,9 @@ ifneq ($(dep_includes),)
 endif
 
 clean:
-	$(RM) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d
+	$(RM) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.so.* $(bdir)/*.o $(bdir)/.*.d
 
 .PHONY: clean
+
+PHONY += force
+force:
-- 
2.29.2


