Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C56C63798
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 07:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7982121D7F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Nov 2020 07:27:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fpdGFlhL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbgKZH1Y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 26 Nov 2020 02:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727690AbgKZH1Y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 26 Nov 2020 02:27:24 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC036C0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 23:27:23 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id g14so971680wrm.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2020 23:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kSjkhMfrhIkEpE1aQj9FeMNNB5BEE5DqGRTqyI0IVlM=;
        b=fpdGFlhLFe09a0lweJbfmHi4Moq6hCzNh9c0nJ+1VCMnG3AWb3rJA94CwUuFK1Qgml
         sgacXpMJpTT/8IlYaOPUvk4268PT1b/f93yWku4q3E+52Ix8UnA9nlL7pQ6Nxkr6yvnc
         6WAMWbIEzzcK6Hbggs16PLvwXNVMehHm3BiiXF+Tpidf6jWskewEgQxT7iUyv3JmvVur
         c26jE8DNIuh0fTz4c7HSnX95SNaFy/Aztg0LtkDDC4O3tsRCdnOa60CdBTgQyIEYvPl5
         fZ9EdbxGG/7IUN/HllkyZaTxDc89+UymYlIaiCqYfdWwaJo1Sc1omNhvCr8B9SEzSb2f
         7zxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kSjkhMfrhIkEpE1aQj9FeMNNB5BEE5DqGRTqyI0IVlM=;
        b=SCY+r49OGqUFsp8Of3+GiGqxs6tD5wm/U+iSliICDbvbhEXKFtyYoplsTa5x8GLYM5
         NwtkPD2J98VD6vf64717jSDRzDbMVVzyEfsoR+JRy4yU8SB2vSb4P9HONNKO+4CEv/PE
         lYgGm9x6yI9OorhoOQhTrloxFOWD+bIwk08K5oDfMQn5jbmITkRVS9fXAiE+zH+A0+lS
         ijn1f5J3Nk+tPWDL/nLEZbEeCRTK8Shj4wP6rdKDjWC3/uei1ueXwjtIpWlCMT56txRN
         W2rBz4FsKanpmv8V4dhhvOSSttBSCkK1LP0B6vYVnHOoELAwercdUgueYnNq5wXCab8V
         t2zA==
X-Gm-Message-State: AOAM533iTL+Ng3369IqE732wBQdkJ5zfoLMYHRbkiPUL19LH7c3xGYFL
        mJVhQ8J0EN2YgJ1c3ZzKtmffq7hxQlYkaQo2
X-Google-Smtp-Source: ABdhPJzMcc0/+lu7LLHbJKKB7zA7zuHGB0A2ECJLNnzQP+bFWM1/i0LtQ4BbCAdo5DvqNM3lxrag7A==
X-Received: by 2002:adf:f607:: with SMTP id t7mr2032465wrp.169.1606375642495;
        Wed, 25 Nov 2020 23:27:22 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n4sm7269659wmc.30.2020.11.25.23.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 23:27:21 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] libtracefs: Add support for pkg-config
Date:   Thu, 26 Nov 2020 09:27:17 +0200
Message-Id: <20201126072719.906443-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201126072719.906443-1-tz.stoyanov@gmail.com>
References: <20201126072719.906443-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

The pkg-config file is used by the library users to check if the
library is installed on the system and get required CFLAGS and LDFLAGS
in order to use it.

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 Makefile               | 35 ++++++++++++++++++++++++++++++++---
 libtracefs.pc.template | 10 ++++++++++
 2 files changed, 42 insertions(+), 3 deletions(-)
 create mode 100644 libtracefs.pc.template

diff --git a/Makefile b/Makefile
index 468f908..dc7deb1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,4 +1,3 @@
-# SPDX-License-Identifier: LGPL-2.1
 # libtracefs version
 TFS_VERSION = 0
 TFS_PATCHLEVEL = 1
@@ -27,6 +26,7 @@ endef
 # Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
 $(call allow-override,CC,$(CROSS_COMPILE)gcc)
 $(call allow-override,AR,$(CROSS_COMPILE)ar)
+$(call allow-override,PKG_CONFIG,pkg-config)
 
 EXT = -std=gnu99
 INSTALL = install
@@ -47,6 +47,11 @@ libdir ?= $(prefix)/lib
 libdir_SQ = '$(subst ','\'',$(libdir))'
 includedir = $(prefix)/include
 includedir_SQ = '$(subst ','\'',$(includedir))'
+pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
+			--variable pc_path pkg-config | tr ":" " "))
+
+PKG_CONFIG_SOURCE_FILE = libtracefs.pc
+PKG_CONFIG_FILE := $(addprefix $(OUTPUT),$(PKG_CONFIG_SOURCE_FILE))
 
 ifeq ($(prefix),/usr/local)
 etcdir ?= /etc
@@ -157,7 +162,7 @@ LIB_INSTALL := $(addprefix $(bdir)/,$(LIB_INSTALL))
 
 TARGETS = $(LIBTRACEFS_SHARED) $(LIBTRACEFS_STATIC)
 
-all_cmd: $(TARGETS)
+all_cmd: $(TARGETS) $(PKG_CONFIG_FILE)
 
 libtracefs.a: $(LIBTRACEFS_STATIC)
 libtracefs.so: $(LIBTRACEFS_SHARED)
@@ -175,6 +180,25 @@ define find_tag_files
 		! -name '\.#' -print
 endef
 
+define do_make_pkgconfig_file
+	cp -f ${PKG_CONFIG_SOURCE_FILE}.template ${PKG_CONFIG_FILE};	\
+	sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
+	sed -i "s|LIB_VERSION|${TRACEFS_VERSION}|g" ${PKG_CONFIG_FILE}; \
+	sed -i "s|LIB_DIR|${libdir}|g" ${PKG_CONFIG_FILE}; \
+	sed -i "s|HEADER_DIR|$(includedir)|g" ${PKG_CONFIG_FILE};
+endef
+
+$(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template
+	$(Q) $(call do_make_pkgconfig_file,$(prefix))
+
+define do_install_pkgconfig_file
+	if [ -n "${pkgconfig_dir}" ]; then 					\
+		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
+	else 									\
+		(echo Failed to locate pkg-config directory) 1>&2;		\
+	fi
+endef
+
 tags:	force
 	$(RM) tags
 	$(call find_tag_files) | xargs ctags --extra=+f --c-kinds=+px
@@ -187,7 +211,7 @@ cscope: force
 	$(RM) cscope*
 	$(call find_tag_files) | cscope -b -q
 
-install_libs: libs
+install_libs: libs install_pkgconfig
 	$(Q)$(call do_install,$(LIBTRACEFS_SHARED),$(libdir_SQ)/tracefs); \
 		cp -fpR $(LIB_INSTALL) $(DESTDIR)$(libdir_SQ)/tracefs
 	$(Q)$(call do_install,$(src)/include/tracefs.h,$(includedir_SQ)/tracefs)
@@ -195,6 +219,10 @@ install_libs: libs
 
 install: install_libs
 
+install_pkgconfig: $(PKG_CONFIG_FILE)
+	$(Q)$(call , $(PKG_CONFIG_FILE)) \
+		$(call do_install_pkgconfig_file,$(prefix))
+
 doc:
 	$(MAKE) -C $(src)/Documentation all
 doc_gui:
@@ -262,5 +290,6 @@ endif
 
 clean:
 	$(RM) $(TARGETS) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d
+	$(RM) $(PKG_CONFIG_FILE)
 
 .PHONY: clean
diff --git a/libtracefs.pc.template b/libtracefs.pc.template
new file mode 100644
index 0000000..5e7d54a
--- /dev/null
+++ b/libtracefs.pc.template
@@ -0,0 +1,10 @@
+prefix=INSTALL_PREFIX
+libdir=LIB_DIR
+includedir=HEADER_DIR
+
+Name: libtracefs
+URL: https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+Description: Library for accessing ftrace file system
+Version: LIB_VERSION
+Cflags: -I${includedir}
+Libs: -L${libdir} -ltracefs
-- 
2.28.0

