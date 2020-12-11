Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC7AC4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 807CD23F38
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392395AbgLKRMJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:12:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394809AbgLKRLm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 12:11:42 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2105223EF5
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 17:10:16 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knlvr-000Hio-5K
        for linux-trace-devel@vger.kernel.org; Fri, 11 Dec 2020 12:10:15 -0500
Message-ID: <20201211171015.035720645@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 11 Dec 2020 12:08:55 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 13/13] trace-cmd: Add warning if libtracefs or libtraceevent are not found
References: <20201211170842.611554918@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a warning notice if either or both libtraceevent or libtracefs is not
found on the system for linking. If the local version is being built,
display a notice and show where they can get the corresponding library.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                |  4 ++--
 lib/traceevent/Makefile | 14 ++++++++++++++
 lib/tracefs/Makefile    | 13 +++++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 1f7cab57cd7d..ab91ae777b83 100644
--- a/Makefile
+++ b/Makefile
@@ -369,7 +369,7 @@ trace-cmd: force $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACECMD_STATIC) $(LIBTRACEF
 
 $(LIBTRACEEVENT_STATIC): force $(obj)/lib/traceevent/plugins/trace_python_dir \
 			 $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
-	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
+	$(Q)$(MAKE) -C $(src)/lib/traceevent libtraceevent
 
 $(LIBTRACECMD_STATIC): force
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd $@
@@ -378,7 +378,7 @@ $(LIBTRACECMD_SHARED): force $(LIBTRACEEVENT_SHARED_BUILD)
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd libtracecmd.so
 
 $(LIBTRACEFS_STATIC): force
-	$(Q)$(MAKE) -C $(src)/lib/tracefs $@
+	$(Q)$(MAKE) -C $(src)/lib/tracefs libtracefs
 
 libtraceevent.a: $(LIBTRACEEVENT_STATIC)
 libtracecmd.a: $(LIBTRACECMD_STATIC)
diff --git a/lib/traceevent/Makefile b/lib/traceevent/Makefile
index edb2fccfff07..0dcd90c13328 100644
--- a/lib/traceevent/Makefile
+++ b/lib/traceevent/Makefile
@@ -29,9 +29,23 @@ $(bdir):
 $(OBJS): | $(bdir)
 $(DEPS): | $(bdir)
 
+.PHONY: warning
+warning:
+	@echo "********************************************"
+	@echo "** NOTICE: libtraceevent not found on system"
+	@echo "**"
+	@echo "** Building obsolete local version of libtraceevent"
+	@echo "** Consider installing the latest libtraceevent"
+	@echo "**"
+	@echo "**  https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/ "
+	@echo "**"
+	@echo "********************************************"
+
 $(bdir)/libtraceevent.a: $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
+libtraceevent: $(bdir)/libtraceevent.a warning
+
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
diff --git a/lib/tracefs/Makefile b/lib/tracefs/Makefile
index 33112690914d..021ae2b040de 100644
--- a/lib/tracefs/Makefile
+++ b/lib/tracefs/Makefile
@@ -26,9 +26,22 @@ $(DEPS): | $(bdir)
 
 LIBS = -L$(obj)/lib/traceevent -ltraceevent
 
+.PHONY: warning
+warning:
+	@echo "********************************************"
+	@echo "** NOTICE: libtracefs not found on system"
+	@echo "**"
+	@echo "** Building obsolete local version of libtracefs"
+	@echo "** Consider installing the latest libtracefs"
+	@echo "**"
+	@echo "**  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/ "
+	@echo "**"
+	@echo "********************************************"
+
 $(bdir)/libtracefs.a: $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
+libtracefs: $(bdir)/libtracefs.a warning
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
-- 
2.29.2


