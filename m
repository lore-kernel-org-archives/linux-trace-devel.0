Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590DFC2BBCD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35FE6235F9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgLPUM4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:12:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727430AbgLPUM4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 15:12:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED33023715
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 20:11:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpd94-000vvV-UM
        for linux-trace-devel@vger.kernel.org; Wed, 16 Dec 2020 15:11:34 -0500
Message-ID: <20201216201134.772542934@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 15:11:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/8] libtracefs: Allow the pkg-config libs and cflags prefix to be
 overwritten
References: <20201216201106.170659791@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In case libtracecmd needs to be built in a destination directory where
libtracefs will be located, and not on the host machine, it will need a
way to override the location of the include and library directories.
Facilitate this by having them use the ${prefix} variable.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile               | 7 ++++---
 libtracefs.pc.template | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index ab64ef3e4f54..142b824ca421 100644
--- a/Makefile
+++ b/Makefile
@@ -56,7 +56,8 @@ man_dir = $(prefix)/share/man
 man_dir_SQ = '$(subst ','\'',$(man_dir))'
 libdir = $(prefix)/$(libdir_relative)
 libdir_SQ = '$(subst ','\'',$(libdir))'
-includedir = $(prefix)/include/tracefs
+includedir_relative ?= include/tracefs
+includedir = $(prefix)/$(includedir_relative)
 includedir_SQ = '$(subst ','\'',$(includedir))'
 pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
 			--variable pc_path pkg-config | tr ":" " "))
@@ -193,8 +194,8 @@ define do_make_pkgconfig_file
 	cp -f ${PKG_CONFIG_SOURCE_FILE}.template ${PKG_CONFIG_FILE};	\
 	sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
 	sed -i "s|LIB_VERSION|${TRACEFS_VERSION}|g" ${PKG_CONFIG_FILE}; \
-	sed -i "s|LIB_DIR|${libdir}|g" ${PKG_CONFIG_FILE}; \
-	sed -i "s|HEADER_DIR|$(includedir)|g" ${PKG_CONFIG_FILE};
+	sed -i "s|LIB_DIR|${libdir_relative}|g" ${PKG_CONFIG_FILE}; \
+	sed -i "s|HEADER_DIR|$(includedir_relative)|g" ${PKG_CONFIG_FILE};
 endef
 
 BUILD_PREFIX := $(BUILD_OUTPUT)/build_prefix
diff --git a/libtracefs.pc.template b/libtracefs.pc.template
index 5e7d54a4456c..a674fee24007 100644
--- a/libtracefs.pc.template
+++ b/libtracefs.pc.template
@@ -1,6 +1,6 @@
 prefix=INSTALL_PREFIX
-libdir=LIB_DIR
-includedir=HEADER_DIR
+libdir=${prefix}/LIB_DIR
+includedir=${prefix}/HEADER_DIR
 
 Name: libtracefs
 URL: https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
-- 
2.29.2


