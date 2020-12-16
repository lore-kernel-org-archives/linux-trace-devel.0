Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDC7C2BBCD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2DA623124
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgLPEkD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgLPEkD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:40:03 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C55A23130
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:39:22 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOav-000qnY-J4
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:39:21 -0500
Message-ID: <20201216043921.431779685@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:38:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/5] libtracefs: Remove obsolete do_install_ld call
References: <20201216043852.168982058@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Now that there's a test to install the ld.so.conf.d config file only if
needed, remove the unused do_install_ld references and the variables it
used. As do_install_ld is not even defined.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Makefile b/Makefile
index 92e682b68b40..5094966f4d06 100644
--- a/Makefile
+++ b/Makefile
@@ -89,8 +89,6 @@ HELP_DIR_SQ = '$(subst ','\'',$(HELP_DIR))'
 #' emacs highlighting gets confused by the above escaped quote.
 
 BASH_COMPLETE_DIR ?= $(etcdir)/bash_completion.d
-LD_SO_CONF_DIR ?= $(etcdir)/ld.so.conf.d
-TRACE_LD_FILE ?= trace.conf
 
 # copy a bit from Linux kbuild
 
@@ -242,7 +240,6 @@ install_libs: libs install_pkgconfig
 	$(Q)$(call do_install,$(LIBTRACEFS_SHARED),$(libdir_SQ)); \
 		cp -fpR $(LIB_INSTALL) $(DESTDIR)$(libdir_SQ)
 	$(Q)$(call do_install,$(src)/include/tracefs.h,$(includedir_SQ))
-	$(Q)$(call do_install_ld,$(TRACE_LD_FILE),$(LD_SO_CONF_DIR),$(libdir_SQ))
 	$(Q)$(call install_ld_config)
 
 install: install_libs
-- 
2.29.2


