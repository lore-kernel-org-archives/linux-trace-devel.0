Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC77C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Dec 2020 08:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84837225AB
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Dec 2020 08:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgLDIn5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Dec 2020 03:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbgLDIn5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Dec 2020 03:43:57 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EB6C061A4F
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Dec 2020 00:43:17 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id g185so6276926wmf.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 04 Dec 2020 00:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p7fwOg18MND4ITgrxR9oOFWIirzN2Gur5ERe5ttAdaQ=;
        b=FWtaFOrzzU0447ST17UlmNGboEAZPugFfSfvdIU6g7l4KoL3ApiNQ0EG0N++vNw1zr
         t7yTWpu1t5j6t4J1df3db2hf9kJQXGPLCCFSv2DvcLDmAJ88fKL2DadINh0cM9T9P+1y
         KEiXeCPA5yNizgN6GaDlQh6rE77dlDYvoVFctMif4TtA+jcBTGDhtANaABYwj8oRobxI
         Na4hN/fc36KL4W0PbrTNob71iy6PXn5PM+sQ9KUnHyLJLUbS1JAWWmnyYlh6RLWE0X5S
         mcPeJm4z5iesdqYBPX+5ETR3kQSnslMU+KxoWOnH21yi+rzVmMaarYORn4PxYxuSWZQO
         8bRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p7fwOg18MND4ITgrxR9oOFWIirzN2Gur5ERe5ttAdaQ=;
        b=jEIFNobnsgyrBkjRoPlWv1uh9eEUQCpVHOYJWuGNZDNG5VyggWDFtk3Gelxh7Fd5Cz
         Gs3uzM3Pci0WBx6+SpBohdHX7dCzJhdA3fE5wdIOWdxMJP4M3wgUN9v7qUY2WnAXVyiL
         9fZp6/YwAI7P8LcCL5PI4zBMxysHW/+8VDAJw6ysbOhCaloLygqN8lqvkXw8O0TKAIxn
         mJbsQJ3dBr/AQFmydmUZnET+ap8OIBf5vyeoSY4Gru57uOLjRrDIwCSRML1VvpK2F2nm
         f2SXkmGw3V9sAT+dRod4/d6KJUXxwWwp9qtw2udYi2/EeWAfskYoOnNfI9nVMKv1c7vo
         B3/A==
X-Gm-Message-State: AOAM532oJn/lYk779hNPeFS4NYN/lr2yBOm55IJZ9gt/gIXfjCQibAWV
        9z+2k17JLG0N7QNt1nwakOzAe6Llq2r1S7fV
X-Google-Smtp-Source: ABdhPJxRJjHuuolswNnkED70gKfGp3pBK2H6NKtP+3QvZ0A+XbbVc7Ly/cmzKG7qCL44nvR7E0YndQ==
X-Received: by 2002:a1c:41c5:: with SMTP id o188mr2287647wma.18.1607071395785;
        Fri, 04 Dec 2020 00:43:15 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f14sm2417870wme.14.2020.12.04.00.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 00:43:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] libtracefs: Add support for pkg-config
Date:   Fri,  4 Dec 2020 10:43:12 +0200
Message-Id: <20201204084312.554771-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
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
v2 changes:
 Added "SPDX-License-Identifier" in the Makefile, deleted by mistake in v1.


 Makefile               | 34 ++++++++++++++++++++++++++++++++--
 libtracefs.pc.template | 10 ++++++++++
 2 files changed, 42 insertions(+), 2 deletions(-)
 create mode 100644 libtracefs.pc.template

diff --git a/Makefile b/Makefile
index 468f908..3bb1564 100644
--- a/Makefile
+++ b/Makefile
@@ -27,6 +27,7 @@ endef
 # Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
 $(call allow-override,CC,$(CROSS_COMPILE)gcc)
 $(call allow-override,AR,$(CROSS_COMPILE)ar)
+$(call allow-override,PKG_CONFIG,pkg-config)
 
 EXT = -std=gnu99
 INSTALL = install
@@ -47,6 +48,11 @@ libdir ?= $(prefix)/lib
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
@@ -157,7 +163,7 @@ LIB_INSTALL := $(addprefix $(bdir)/,$(LIB_INSTALL))
 
 TARGETS = $(LIBTRACEFS_SHARED) $(LIBTRACEFS_STATIC)
 
-all_cmd: $(TARGETS)
+all_cmd: $(TARGETS) $(PKG_CONFIG_FILE)
 
 libtracefs.a: $(LIBTRACEFS_STATIC)
 libtracefs.so: $(LIBTRACEFS_SHARED)
@@ -175,6 +181,25 @@ define find_tag_files
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
@@ -187,7 +212,7 @@ cscope: force
 	$(RM) cscope*
 	$(call find_tag_files) | cscope -b -q
 
-install_libs: libs
+install_libs: libs install_pkgconfig
 	$(Q)$(call do_install,$(LIBTRACEFS_SHARED),$(libdir_SQ)/tracefs); \
 		cp -fpR $(LIB_INSTALL) $(DESTDIR)$(libdir_SQ)/tracefs
 	$(Q)$(call do_install,$(src)/include/tracefs.h,$(includedir_SQ)/tracefs)
@@ -195,6 +220,10 @@ install_libs: libs
 
 install: install_libs
 
+install_pkgconfig: $(PKG_CONFIG_FILE)
+	$(Q)$(call , $(PKG_CONFIG_FILE)) \
+		$(call do_install_pkgconfig_file,$(prefix))
+
 doc:
 	$(MAKE) -C $(src)/Documentation all
 doc_gui:
@@ -262,5 +291,6 @@ endif
 
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

