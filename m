Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA132C2BBCF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C5B2313C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgLPEnf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgLPEne (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:34 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E39E23159
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:42:15 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOdi-000r1F-EX
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:42:14 -0500
Message-ID: <20201216044214.305249156@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:41:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 08/12] libtracecmd: Show building of libtracecmd.pc
References: <20201216044150.375001748@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add printing a nice message "BUILD libtracecmd.pc" when it is being created.

And also add it to the .gitignore file.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .gitignore       | 1 +
 scripts/utils.mk | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index ca6c9cb68f6f..1e8c1d4f5734 100644
--- a/.gitignore
+++ b/.gitignore
@@ -23,3 +23,4 @@ cscope*
 traceevent_plugin_dir
 trace_python_dir
 tracecmd_plugin_dir
+libtracecmd.pc
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 98549af9a774..e166c6ae3f9d 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -144,7 +144,8 @@ define do_install_pkgconfig_file
 endef
 
 define do_make_pkgconfig_file
-	cp -f $(srctree)/${PKG_CONFIG_SOURCE_FILE}.template ${PKG_CONFIG_FILE};	\
+	$(print_app_build)
+	$(Q)cp -f $(srctree)/${PKG_CONFIG_SOURCE_FILE}.template ${PKG_CONFIG_FILE};	\
 	sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
 	sed -i "s|LIB_VERSION|${LIBTRACECMD_VERSION}|g" ${PKG_CONFIG_FILE}; \
 	sed -i "s|LIB_DIR|$(libdir)|g" ${PKG_CONFIG_FILE}; \
-- 
2.29.2


