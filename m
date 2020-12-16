Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44729C2BBD5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C27E2313C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgLPEnf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbgLPEnf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:35 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C775B23331
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:42:15 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOdi-000r2D-Qa
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:42:14 -0500
Message-ID: <20201216044214.680385146@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:42:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 10/12] trace-cmd: Add make uninstall
References: <20201216044150.375001748@goodmis.org>
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
 Makefile         | 30 ++++++++++++++++++++++++++++++
 scripts/utils.mk |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/Makefile b/Makefile
index c1192da4f049..ddceab3f45e7 100644
--- a/Makefile
+++ b/Makefile
@@ -484,6 +484,36 @@ clean:
 	if [ -f $(kshark-dir)/build/Makefile ]; then $(MAKE) -C $(kshark-dir)/build clean; fi
 	cd $(kshark-dir)/build; ./cmake_clean.sh
 
+define build_uninstall_script
+	$(Q)mkdir $(BUILD_OUTPUT)/tmp_build
+	$(Q)$(MAKE) -C $(src) DESTDIR=$(BUILD_OUTPUT)/tmp_build O=$(BUILD_OUTPUT) $1 > /dev/null
+	$(Q)find $(BUILD_OUTPUT)/tmp_build ! -type d -printf "%P\n" > $(BUILD_OUTPUT)/build_$2
+	$(Q)$(RM) -rf $(BUILD_OUTPUT)/tmp_build
+endef
+
+build_uninstall:
+	$(call build_uninstall_script,install,uninstall)
+
+$(BUILD_OUTPUT)/build_uninstall: build_uninstall
+
+build_libs_uninstall:
+	$(call build_uninstall_script,install_libs,libs_uninstall)
+
+$(BUILD_OUTPUT)/build_libs_uninstall: build_libs_uninstall
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
+uninstall_libs: $(BUILD_OUTPUT)/build_libs_uninstall
+	@$(foreach file,$(shell cat $(BUILD_OUTPUT)/build_libs_uninstall),$(call uninstall_file,$(file)))
+	$(Q)$(RM) $<
 
 ##### PYTHON STUFF #####
 
diff --git a/scripts/utils.mk b/scripts/utils.mk
index e166c6ae3f9d..c8ef44b3776a 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -30,6 +30,7 @@ ifeq ($(findstring 1,$(SILENT)$(VERBOSE)),1)
   print_plugin_obj_compile =
   print_plugin_build =
   print_install =
+  print_uninstall =
   print_update =
 else
   print_compile =		echo '  $(GUI)COMPILE            '$(GOBJ);
@@ -41,6 +42,7 @@ else
   print_static_lib_build =	echo '  $(GUI)BUILD STATIC LIB   '$(GOBJ);
   print_install =		echo '  $(GUI)INSTALL     '$(GSPACE)$1'	to	$(DESTDIR_SQ)$2';
   print_update =		echo '  $(GUI)UPDATE             '$(GOBJ);
+  print_uninstall =		echo '  $(GUI)UNINSTALLING $(DESTDIR_SQ)$1';
 endif
 
 do_fpic_compile =					\
-- 
2.29.2


