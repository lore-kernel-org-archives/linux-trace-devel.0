Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F9A2C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E4A623E1B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732914AbgLKRMK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:12:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391471AbgLKRLl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 12:11:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70DAE23EF1
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 17:10:15 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knlvq-000Hgs-Gc
        for linux-trace-devel@vger.kernel.org; Fri, 11 Dec 2020 12:10:14 -0500
Message-ID: <20201211171014.383612340@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 11 Dec 2020 12:08:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 09/13] trace-cmd: Move the installing of libtracecmd to the lib/trace-cmd
 Makefile
References: <20201211170842.611554918@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As a clean up, move the installation processing of libtracecmd libraries
into the lib/trace-cmd directory.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile               | 5 ++---
 lib/trace-cmd/Makefile | 4 ++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 041bd79b5aec..30528952740d 100644
--- a/Makefile
+++ b/Makefile
@@ -80,7 +80,7 @@ endif
 etcdir_SQ = '$(subst ','\'',$(etcdir))'
 
 export man_dir man_dir_SQ html_install html_install_SQ INSTALL
-export img_install img_install_SQ
+export img_install img_install_SQ libdir_SQ includedir_SQ
 export DESTDIR DESTDIR_SQ
 
 ifeq ($(prefix),$(HOME))
@@ -481,8 +481,7 @@ install_tracefs: $(LIBTRACEFS_STATIC_BUILD)
 	$(Q)$(call do_install,$(src)/include/tracefs/tracefs.h,$(includedir_SQ)/tracefs)
 
 install_libs: libs $(INSTALL_TRACEEVENT) $(INSTALL_TRACEFS)
-	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
-	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
+	$(Q)$(MAKE) -C $(src)/lib/trace-cmd/ $@
 
 doc:
 	$(MAKE) -C $(src)/Documentation all
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index cd66eaa8ea6c..96acdaf9aa27 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -59,6 +59,10 @@ $(DEPS): $(bdir)/.%.d: %.c
 
 $(OBJS): $(bdir)/%.o : $(bdir)/.%.d
 
+install_libs:
+	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
+	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
+
 dep_includes := $(wildcard $(DEPS))
 
 ifneq ($(dep_includes),)
-- 
2.29.2


