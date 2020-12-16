Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 576D3C2BBCA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A77523130
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgLPEh6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:37:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgLPEh6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:37:58 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CFAF23133
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:37:18 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOYv-000qh3-AO
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:37:17 -0500
Message-ID: <20201216043717.176014003@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:36:40 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] libtraceevent: Keep build_install file around
References: <20201216043637.453360298@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of rebuilding the build_install files every time the uninstall is
created, make it depend on the prefix, as if the prefix is the same, then
the uninstall should be the same.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index f795e05d22a7..f96232b99e40 100644
--- a/Makefile
+++ b/Makefile
@@ -319,7 +319,7 @@ define build_uninstall_script
 	$(Q)$(RM) -rf $(BUILD_OUTPUT)/tmp_build
 endef
 
-build_uninstall:
+build_uninstall: $(BUILD_PREFIX)
 	$(call build_uninstall_script,install,uninstall)
 
 $(BUILD_OUTPUT)/build_uninstall: build_uninstall
@@ -332,7 +332,6 @@ endef
 
 uninstall: $(BUILD_OUTPUT)/build_uninstall
 	@$(foreach file,$(shell cat $(BUILD_OUTPUT)/build_uninstall),$(call uninstall_file,$(file)))
-	$(Q)$(RM) $<
 
 PHONY += doc
 doc:
-- 
2.29.2


