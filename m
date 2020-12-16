Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D45C4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE8F23137
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgLPEmy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:42:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgLPEmy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:42:54 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DB5823130
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:42:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOdh-000qxq-3v
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:42:13 -0500
Message-ID: <20201216044212.967348881@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:41:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 01/12] trace-cmd: Move do_make_pkgconfig_file to utils.mk
References: <20201216044150.375001748@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The macro do_make_pkgconfig_file should be in utils.mk and not in the top
Makefile as utils.mk is where other similar macros are located.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile         | 8 --------
 scripts/utils.mk | 8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index ab91ae777b83..595c8443e572 100644
--- a/Makefile
+++ b/Makefile
@@ -208,14 +208,6 @@ obj		:= $(objtree)
 PKG_CONFIG_SOURCE_FILE = libtracecmd.pc
 PKG_CONFIG_FILE := $(addprefix $(BUILD_OUTPUT)/,$(PKG_CONFIG_SOURCE_FILE))
 
-define do_make_pkgconfig_file
-	cp -f $(srctree)/${PKG_CONFIG_SOURCE_FILE}.template ${PKG_CONFIG_FILE};	\
-	sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
-	sed -i "s|LIB_VERSION|${LIBTRACECMD_VERSION}|g" ${PKG_CONFIG_FILE}; \
-	sed -i "s|LIB_DIR|$(libdir)|g" ${PKG_CONFIG_FILE}; \
-	sed -i "s|HEADER_DIR|$(includedir)/trace-cmd|g" ${PKG_CONFIG_FILE};
-endef
-
 kshark-dir	= $(src)/kernel-shark
 
 export prefix bindir src obj kshark-dir
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 1d090d8ac001..98549af9a774 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -142,3 +142,11 @@ define do_install_pkgconfig_file
 		(echo Failed to locate pkg-config directory) 1>&2;		\
 	fi
 endef
+
+define do_make_pkgconfig_file
+	cp -f $(srctree)/${PKG_CONFIG_SOURCE_FILE}.template ${PKG_CONFIG_FILE};	\
+	sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
+	sed -i "s|LIB_VERSION|${LIBTRACECMD_VERSION}|g" ${PKG_CONFIG_FILE}; \
+	sed -i "s|LIB_DIR|$(libdir)|g" ${PKG_CONFIG_FILE}; \
+	sed -i "s|HEADER_DIR|$(includedir)/trace-cmd|g" ${PKG_CONFIG_FILE};
+endef
-- 
2.29.2


