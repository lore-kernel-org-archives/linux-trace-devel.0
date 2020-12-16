Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D90C0018C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 353F32312E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbgLPEh6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:37:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgLPEh6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:37:58 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D3E82312E
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:37:18 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOYu-000qg3-VE
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:37:16 -0500
Message-ID: <20201216043716.818873731@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:36:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] libtraceevent: Add a way to uninstall
References: <20201216043637.453360298@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add an uninstall target. The way this works is to create a temp directory,
build and install into it. The examine the files in that directory, to know
what files need to be removed. The DESTDIR and prefix need to be the same as
how the install happened.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                 | 26 ++++++++++++++++++++++++++
 scripts/Makefile.include |  1 +
 2 files changed, 27 insertions(+)

diff --git a/Makefile b/Makefile
index 12ae490276f4..c85114beef96 100644
--- a/Makefile
+++ b/Makefile
@@ -292,6 +292,32 @@ clean: clean_plugins clean_src
 		$(RM) $(OUTPUT)*.o $(OUTPUT)*~ $(TARGETS) $(OUTPUT)*.a $(OUTPUT)*.so $(VERSION_FILES) $(OUTPUT).*.d $(OUTPUT).*.cmd; \
 		$(RM) TRACEEVENT-CFLAGS $(OUTPUT)tags $(OUTPUT)TAGS; \
 		$(RM) $(PKG_CONFIG_FILE)
+ifneq ($(OUTPUT),)
+else
+BUILD_OUTPUT := $(shell pwd)
+endif
+
+define build_uninstall_script
+	$(Q)mkdir $(BUILD_OUTPUT)/tmp_build
+	$(Q)$(MAKE) -C $(srctree) DESTDIR=$(BUILD_OUTPUT)/tmp_build/ O=$(BUILD_OUTPUT) $1 > /dev/null
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
+		$(call PRINT_UNINST,$(DESTDIR)$1)$(RM) $(DESTDIR)/$1; \
+	fi;
+endef
+
+uninstall: $(BUILD_OUTPUT)/build_uninstall
+	@$(foreach file,$(shell cat $(BUILD_OUTPUT)/build_uninstall),$(call uninstall_file,$(file)))
+	$(Q)$(RM) $<
 
 PHONY += doc
 doc:
diff --git a/scripts/Makefile.include b/scripts/Makefile.include
index 5257bd6637a9..d505b2f20b92 100644
--- a/scripts/Makefile.include
+++ b/scripts/Makefile.include
@@ -124,6 +124,7 @@ ifneq ($(silent),1)
 		$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1) $(2)
 
 	PRINT_INSTALL  = printf '  INSTALL  %s\n' $1;
+	PRINT_UNINST   = printf '  UNINST   %s\n' $1;
 	QUIET_CLEAN    = @printf '  CLEAN    %s\n' $1;
 	QUIET_INSTALL  = @printf '  INSTALL  %s\n' $1;
 	QUIET_UNINST   = @printf '  UNINST   %s\n' $1;
-- 
2.29.2


