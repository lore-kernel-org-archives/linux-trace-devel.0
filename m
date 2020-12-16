Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B82C3526B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B4212332A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgLPEnf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgLPEnf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:35 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AC6723333
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:42:16 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOdj-000r3B-75
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:42:15 -0500
Message-ID: <20201216044215.050645958@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:42:02 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 12/12] trace-cmd: Keep build_install files around
References: <20201216044150.375001748@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of rebuilding the build_install and build_libs_install files every
time the uninstall is created, make it depend on the prefix, as if the
prefix is the same, then the uninstall should be the same.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .gitignore | 2 ++
 Makefile   | 6 ++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/.gitignore b/.gitignore
index 9ce25c8e031e..af9bf6c09a24 100644
--- a/.gitignore
+++ b/.gitignore
@@ -25,3 +25,5 @@ trace_python_dir
 tracecmd_plugin_dir
 libtracecmd.pc
 build_prefix
+build_install
+build_libs_install
diff --git a/Makefile b/Makefile
index 396a6795bad1..662d24ba288f 100644
--- a/Makefile
+++ b/Makefile
@@ -496,12 +496,12 @@ define build_uninstall_script
 	$(Q)$(RM) -rf $(BUILD_OUTPUT)/tmp_build
 endef
 
-build_uninstall:
+build_uninstall: $(BUILD_PREFIX)
 	$(call build_uninstall_script,install,uninstall)
 
 $(BUILD_OUTPUT)/build_uninstall: build_uninstall
 
-build_libs_uninstall:
+build_libs_uninstall: $(BUILD_PREFIX)
 	$(call build_uninstall_script,install_libs,libs_uninstall)
 
 $(BUILD_OUTPUT)/build_libs_uninstall: build_libs_uninstall
@@ -514,11 +514,9 @@ endef
 
 uninstall: $(BUILD_OUTPUT)/build_uninstall
 	@$(foreach file,$(shell cat $(BUILD_OUTPUT)/build_uninstall),$(call uninstall_file,$(file)))
-	$(Q)$(RM) $<
 
 uninstall_libs: $(BUILD_OUTPUT)/build_libs_uninstall
 	@$(foreach file,$(shell cat $(BUILD_OUTPUT)/build_libs_uninstall),$(call uninstall_file,$(file)))
-	$(Q)$(RM) $<
 
 ##### PYTHON STUFF #####
 
-- 
2.29.2


