Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9EAC4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 000FB23E1B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391471AbgLKRMK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:12:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732770AbgLKRLl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 12:11:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46E8D23ED0
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 17:10:15 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knlvq-000HgO-BR
        for linux-trace-devel@vger.kernel.org; Fri, 11 Dec 2020 12:10:14 -0500
Message-ID: <20201211171014.219970193@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 11 Dec 2020 12:08:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 08/13] trace-cmd: Install libtracecmd in the proper lib directory
References: <20201211170842.611554918@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of installing libtracecmd library into its own directory under lib/,
where the dynamic linker ld has trouble finding it, use the appropriate lib
path (lib or lib64) to place libtracecmd.*

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 0c5da92b54b6..041bd79b5aec 100644
--- a/Makefile
+++ b/Makefile
@@ -48,6 +48,14 @@ INSTALL = install
 DESTDIR ?=
 DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
 
+LP64 := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
+ifeq ($(LP64), 1)
+  libdir_relative_temp = lib64
+else
+  libdir_relative_temp = lib
+endif
+
+libdir_relative ?= $(libdir_relative_temp)
 prefix ?= /usr/local
 bindir_relative = bin
 bindir = $(prefix)/$(bindir_relative)
@@ -57,7 +65,7 @@ html_install = $(prefix)/share/kernelshark/html
 html_install_SQ = '$(subst ','\'',$(html_install))'
 img_install = $(prefix)/share/kernelshark/html/images
 img_install_SQ = '$(subst ','\'',$(img_install))'
-libdir ?= $(prefix)/lib
+libdir = $(prefix)/$(libdir_relative)
 libdir_SQ = '$(subst ','\'',$(libdir))'
 includedir = $(prefix)/include
 includedir_SQ = '$(subst ','\'',$(includedir))'
@@ -473,7 +481,7 @@ install_tracefs: $(LIBTRACEFS_STATIC_BUILD)
 	$(Q)$(call do_install,$(src)/include/tracefs/tracefs.h,$(includedir_SQ)/tracefs)
 
 install_libs: libs $(INSTALL_TRACEEVENT) $(INSTALL_TRACEFS)
-	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ)/trace-cmd)
+	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
 	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
 
 doc:
-- 
2.29.2


