Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F17C19425
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A97723C81
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgLJCbH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 21:31:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728620AbgLJCbG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 21:31:06 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59EAF23D50
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Dec 2020 02:29:45 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knBiC-0004CF-Am
        for linux-trace-devel@vger.kernel.org; Wed, 09 Dec 2020 21:29:44 -0500
Message-ID: <20201210022944.212527059@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 09 Dec 2020 21:29:15 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 9/9] trace-cmd: Only install libtraceevent and libtracefs if not in system
References: <20201210022906.112066412@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If libtraceevent and libtracefs are not built locally, because they are
already on the local system, do not install them either.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index 8d82db567a52..022b7c3d89d4 100644
--- a/Makefile
+++ b/Makefile
@@ -213,6 +213,7 @@ else
 LIBTRACEEVENT_CFLAGS = -I$(src)/include/traceevent -I$(src)/lib/traceevent/include
 LIBTRACEEVENT_LDLAGS = -L$(LIBTRACEEVENT_DIR) -ltraceevent
 LIBTRACEEVENT_STATIC_BUILD = $(LIBTRACEEVENT_STATIC)
+INSTALL_TRACEEVENT = install_traceevent
 endif
 
 export LIBTRACEEVENT_CFLAGS LIBTRACEEVENT_LDLAGS
@@ -224,6 +225,7 @@ else
 LIBTRACEFS_CFLAGS = -I$(src)/include/tracefs
 LIBTRACEFS_LDLAGS = -L$(LIBTRACEFS_DIR) -ltracefs
 LIBTRACEFS_STATIC_BUILD = $(LIBTRACEFS_STATIC)
+INSTALL_TRACEFS = install_tracefs
 endif
 
 export LIBTRACEFS_CFLAGS LIBTRACEFS_LDLAGS
@@ -343,7 +345,7 @@ $(LIBTRACEEVENT_STATIC): force $(obj)/lib/traceevent/plugins/trace_python_dir \
 $(LIBTRACECMD_STATIC): force
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd $@
 
-$(LIBTRACECMD_SHARED): force $(LIBTRACEEVENT_SHARED)
+$(LIBTRACECMD_SHARED): force $(LIBTRACEEVENT_SHARED_BUILD)
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd $@
 
 $(LIBTRACEFS_STATIC): force
@@ -359,7 +361,7 @@ libtracecmd.so: $(LIBTRACECMD_SHARED)
 libtracefs.a: $(LIBTRACEFS_STATIC)
 libtracefs.so: $(LIBTRACEFS_SHARED)
 
-libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED) $(LIBTRACEFS_SHARED)
+libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED_BUILD) $(LIBTRACEFS_SHARED_BUILD)
 
 test: force $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACEFS_STATIC_BUILD) $(LIBTRACECMD_STATIC)
 ifneq ($(CUNIT_INSTALLED),1)
@@ -432,18 +434,22 @@ install: install_cmd
 install_gui: install_cmd gui
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build install
 
-install_libs: libs
-	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ)/trace-cmd)
+install_traceevent: $(LIBTRACEEVENT_STATIC_BUILD)
 	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ)/traceevent)
-	$(Q)$(call do_install,$(LIBTRACEFS_SHARED),$(libdir_SQ)/tracefs)
 	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ)/traceevent)
 	$(Q)$(call do_install,$(src)/include/traceevent/trace-seq.h,$(includedir_SQ)/traceevent)
-	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
-	$(Q)$(call do_install,$(src)/include/tracefs/tracefs.h,$(includedir_SQ)/tracefs)
-	$(Q)$(call do_install_ld,$(TRACE_LD_FILE),$(LD_SO_CONF_DIR),$(libdir_SQ)/trace-cmd)
 	$(Q)$(call do_install_ld,$(TRACE_LD_FILE),$(LD_SO_CONF_DIR),$(libdir_SQ)/traceevent)
+
+install_tracefs: $(LIBTRACEFS_STATIC_BUILD)
+	$(Q)$(call do_install,$(LIBTRACEFS_SHARED),$(libdir_SQ)/tracefs)
+	$(Q)$(call do_install,$(src)/include/tracefs/tracefs.h,$(includedir_SQ)/tracefs)
 	$(Q)$(call do_install_ld,$(TRACE_LD_FILE),$(LD_SO_CONF_DIR),$(libdir_SQ)/tracefs)
 
+install_libs: libs $(INSTALL_TRACEEVENT) $(INSTALL_TRACEFS)
+	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ)/trace-cmd)
+	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
+	$(Q)$(call do_install_ld,$(TRACE_LD_FILE),$(LD_SO_CONF_DIR),$(libdir_SQ)/trace-cmd)
+
 doc:
 	$(MAKE) -C $(src)/Documentation all
 doc_gui:
-- 
2.29.2


