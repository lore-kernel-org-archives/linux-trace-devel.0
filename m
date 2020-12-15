Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69981C2BB48
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Dec 2020 16:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 284B82251E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Dec 2020 16:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgLOQlt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 11:41:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgLOQlt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 11:41:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2D75207E8
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Dec 2020 16:41:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpDNr-000nGs-Ji
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 11:41:07 -0500
Message-ID: <20201215164107.465848331@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 11:40:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] libtracefs: Move do_install_* macros to utils.mk
References: <20201215164030.520449524@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The do_install_* macros are in the main Makefile, and they overwrite some of
the same macros in utils.mk. Move those macros into the utils.mk and delete
the ones that were not used.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile         | 19 -------------------
 scripts/utils.mk | 25 ++++++++++++++-----------
 2 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/Makefile b/Makefile
index 5e7831407427..5a9d33455143 100644
--- a/Makefile
+++ b/Makefile
@@ -206,25 +206,6 @@ endef
 $(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template
 	$(Q) $(call do_make_pkgconfig_file,$(prefix))
 
-define do_install_mkdir
-	if [ ! -d '$(DESTDIR_SQ)$1' ]; then		\
-		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$1';	\
-	fi
-endef
-
-define do_install
-	$(call do_install_mkdir,$2);			\
-	$(INSTALL) $(if $3,-m $3,) $1 '$(DESTDIR_SQ)$2'
-endef
-
-define do_install_pkgconfig_file
-	if [ -n "${pkgconfig_dir}" ]; then 					\
-		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
-	else 									\
-		(echo Failed to locate pkg-config directory) 1>&2;		\
-	fi
-endef
-
 tags:	force
 	$(RM) tags
 	$(call find_tag_files) | xargs ctags --extra=+f --c-kinds=+px
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 7967a4f290d2..71985e6a28b1 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -119,18 +119,21 @@ define update_dir
 	fi);
 endef
 
+define do_install_mkdir
+	if [ ! -d '$(DESTDIR_SQ)$1' ]; then		\
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$1';	\
+	fi
+endef
+
 define do_install
-	$(print_install)				\
-	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
-		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
-	fi;						\
-	$(INSTALL) $1 '$(DESTDIR_SQ)$2'
+	$(call do_install_mkdir,$2);			\
+	$(INSTALL) $(if $3,-m $3,) $1 '$(DESTDIR_SQ)$2'
 endef
 
-define do_install_data
-	$(print_install)				\
-	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
-		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
-	fi;						\
-	$(INSTALL) -m 644 $1 '$(DESTDIR_SQ)$2'
+define do_install_pkgconfig_file
+	if [ -n "${pkgconfig_dir}" ]; then 					\
+		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
+	else 									\
+		(echo Failed to locate pkg-config directory) 1>&2;		\
+	fi
 endef
-- 
2.29.2


