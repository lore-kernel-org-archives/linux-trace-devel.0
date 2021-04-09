Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3EE4C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 21:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7927461182
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 21:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhDIVrp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 17:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234079AbhDIVrp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 17:47:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5417361006
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Apr 2021 21:47:31 +0000 (UTC)
Date:   Fri, 9 Apr 2021 17:47:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Update libtraceevent.pc when version changes
Message-ID: <20210409174729.780143e7@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When the libtraceevent version changes, the libtraceevent.pc needs to be
updated, otherwise it may install the wrong version number.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .gitignore | 1 +
 Makefile   | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index c312a39..e203d72 100644
--- a/.gitignore
+++ b/.gitignore
@@ -10,3 +10,4 @@ build_uninstall
 *.cmd
 *.so
 .*.d
+ep_version.h
diff --git a/Makefile b/Makefile
index b617baa..3a1eddb 100644
--- a/Makefile
+++ b/Makefile
@@ -273,7 +273,7 @@ define do_make_pkgconfig_file
 	sed -i "s|HEADER_DIR|$(includedir_relative)|g" ${PKG_CONFIG_FILE};
 endef
 
-$(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template $(BUILD_PREFIX)
+$(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template $(BUILD_PREFIX) $(VERSION_FILES)
 	$(QUIET_GEN) $(call do_make_pkgconfig_file,$(prefix))
 
 define do_install_pkgconfig_file
-- 
2.29.2

