Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B722C2BBD4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D07F23130
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgLPEkD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgLPEkD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:40:03 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF85E23133
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:39:22 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOav-000qo2-Pg
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:39:21 -0500
Message-ID: <20201216043921.621289635@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:38:55 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/5] libtracefs: Add make uninstall
References: <20201216043852.168982058@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Create the logic to remove the files that would normally be installed.

Note, this does take the DESTDIR and prefix variables into account. Where
the uninstall may only work for an install with the same variables.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile         | 22 ++++++++++++++++++++++
 scripts/utils.mk |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/Makefile b/Makefile
index 5094966f4d06..653fdc448f45 100644
--- a/Makefile
+++ b/Makefile
@@ -264,6 +264,28 @@ install_doc:
 install_doc_gui:
 	$(MAKE) -C $(kshark-dir)/Documentation install
 
+define build_uninstall_script
+	$(Q)mkdir $(BUILD_OUTPUT)/tmp_build
+	$(Q)$(MAKE) -C $(src) DESTDIR=$(BUILD_OUTPUT)/tmp_build/ O=$(BUILD_OUTPUT) $1 > /dev/null
+	$(Q)find $(BUILD_OUTPUT)/tmp_build ! -type d -printf "%P\n" > $(BUILD_OUTPUT)/build_$2
+	$(Q)$(RM) -rf $(BUILD_OUTPUT)/tmp_build
+endef
+
+build_uninstall:
+	$(call build_uninstall_script,install,uninstall)
+
+$(BUILD_OUTPUT)/build_uninstall: build_uninstall
+
+define uninstall_file
+	if [ -f $(DESTDIR)/$1 -o -h $(DESTDIR)/$1 ]; then \
+		$(call print_uninstall,$(DESTDIR)/$1)$(RM) $(DESTDIR)/$1; \
+	fi;
+endef
+
+uninstall: $(BUILD_OUTPUT)/build_uninstall
+	@$(foreach file,$(shell cat $(BUILD_OUTPUT)/build_uninstall),$(call uninstall_file,$(file)))
+	$(Q)$(RM) $<
+
 PHONY += force
 force:
 
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 398b88a75bfb..74b138eefed6 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -22,6 +22,7 @@ ifeq ($(findstring 1,$(SILENT)$(VERBOSE)),1)
   print_plugin_obj_compile =
   print_plugin_build =
   print_install =
+  print_uninstall =
   print_update =
 else
   print_compile =		echo '  COMPILE            '$(GOBJ);
@@ -32,6 +33,7 @@ else
   print_plugin_build =		echo '  BUILD PLUGIN       '$(GOBJ);
   print_static_lib_build =	echo '  BUILD STATIC LIB   '$(GOBJ);
   print_install =		echo '  INSTALL     '$1'	to	$(DESTDIR_SQ)$2';
+  print_uninstall =		echo '  UNINSTALL     $(DESTDIR_SQ)$1';
   print_update =		echo '  UPDATE             '$(GOBJ);
 endif
 
-- 
2.29.2


