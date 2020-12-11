Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D69A8C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6B5323E1B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732770AbgLKRMK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:12:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394583AbgLKRLl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 12:11:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2626A23E1B
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 17:10:15 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knlvq-000Hfu-68
        for linux-trace-devel@vger.kernel.org; Fri, 11 Dec 2020 12:10:14 -0500
Message-ID: <20201211171014.051912406@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 11 Dec 2020 12:08:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 07/13] trace-cmd: Remove making of ld.so.conf.d/trace.conf
References: <20201211170842.611554918@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Updating the ld.conf.d directory is an unneeded maintenance burden for
installation. Simply make the libtracecmd.so be installed in the default
lib{64} directory instead, and not in its own trace-cmd/ directory within
the lib{64} directory.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile         |  4 ----
 scripts/utils.mk | 10 ----------
 2 files changed, 14 deletions(-)

diff --git a/Makefile b/Makefile
index 3e07be45f84e..0c5da92b54b6 100644
--- a/Makefile
+++ b/Makefile
@@ -111,7 +111,6 @@ HELP_DIR_SQ = '$(subst ','\'',$(HELP_DIR))'
 
 BASH_COMPLETE_DIR ?= $(etcdir)/bash_completion.d
 LD_SO_CONF_DIR ?= $(etcdir)/ld.so.conf.d
-TRACE_LD_FILE ?= trace.conf
 
 export PLUGIN_DIR_TRACEEVENT
 export PLUGIN_DIR_TRACECMD
@@ -468,17 +467,14 @@ install_traceevent: $(LIBTRACEEVENT_STATIC_BUILD)
 	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ)/traceevent)
 	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ)/traceevent)
 	$(Q)$(call do_install,$(src)/include/traceevent/trace-seq.h,$(includedir_SQ)/traceevent)
-	$(Q)$(call do_install_ld,$(TRACE_LD_FILE),$(LD_SO_CONF_DIR),$(libdir_SQ)/traceevent)
 
 install_tracefs: $(LIBTRACEFS_STATIC_BUILD)
 	$(Q)$(call do_install,$(LIBTRACEFS_SHARED),$(libdir_SQ)/tracefs)
 	$(Q)$(call do_install,$(src)/include/tracefs/tracefs.h,$(includedir_SQ)/tracefs)
-	$(Q)$(call do_install_ld,$(TRACE_LD_FILE),$(LD_SO_CONF_DIR),$(libdir_SQ)/tracefs)
 
 install_libs: libs $(INSTALL_TRACEEVENT) $(INSTALL_TRACEFS)
 	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ)/trace-cmd)
 	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
-	$(Q)$(call do_install_ld,$(TRACE_LD_FILE),$(LD_SO_CONF_DIR),$(libdir_SQ)/trace-cmd)
 
 doc:
 	$(MAKE) -C $(src)/Documentation all
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 2e79f1a6ca0e..1d090d8ac001 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -135,16 +135,6 @@ define do_install_data
 	$(INSTALL) -m 644 $1 '$(DESTDIR_SQ)$2'
 endef
 
-define do_install_ld
-	if [ -d '$(DESTDIR_SQ)$2' ]; then				\
-		$(print_install)					\
-		if ! grep -q $3 $(DESTDIR_SQ)$2/$1 2>/dev/null; then	\
-			echo '$3' >> $(DESTDIR_SQ)$2/$1;		\
-			ldconfig;					\
-		fi							\
-	fi
-endef
-
 define do_install_pkgconfig_file
 	if [ -n "${pkgconfig_dir}" ]; then 					\
 		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
-- 
2.29.2


