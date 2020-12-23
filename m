Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E535DC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 16:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B108D20897
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 16:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgLWQ1l (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Dec 2020 11:27:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbgLWQ1l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Dec 2020 11:27:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98CF122BF3
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Dec 2020 16:27:00 +0000 (UTC)
Date:   Wed, 23 Dec 2020 11:26:59 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Do not install trace-cmd.h as executable
Message-ID: <20201223112659.2de0d8bd@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The trace-cmd.h file is being installed via "install" which by default sets
the mode to rwxr-xr-x, but a header file should be set to rw-r--r-- instead.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/Makefile | 2 +-
 scripts/utils.mk       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index ec6ab299..841c84f1 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -93,7 +93,7 @@ install_libs: install_pkgconfig
 	$(Q)cp -fpR $(LIBTRACECMD_SHARED_VERSION) $(DESTDIR)$(libdir_SQ)
 	$(Q)$(call print_install,$(LIBTRACECMD_SHARED_SO),$(DESTDIR)$(libdir_SQ))
 	$(Q)cp -fpR $(LIBTRACECMD_SHARED_SO) $(DESTDIR)$(libdir_SQ)
-	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
+	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd,644)
 	$(Q)$(call install_ld_config)
 
 dep_includes := $(wildcard $(DEPS))
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 03389126..7372d76f 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -136,7 +136,7 @@ define do_install
 	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
 	fi;						\
-	$(INSTALL) $1 '$(DESTDIR_SQ)$2'
+	$(INSTALL) $(if $3,-m $3,) $1 '$(DESTDIR_SQ)$2'
 endef
 
 define do_install_data
-- 
2.25.4

