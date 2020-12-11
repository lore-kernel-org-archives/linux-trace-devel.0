Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A5FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84B5F23E1B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393784AbgLKRMJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:12:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732914AbgLKRLm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 12:11:42 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD48F23EB3
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 17:10:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knlvp-000Hew-Rh
        for linux-trace-devel@vger.kernel.org; Fri, 11 Dec 2020 12:10:13 -0500
Message-ID: <20201211171013.726936743@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 11 Dec 2020 12:08:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 05/13] trace-cmd: Add pkg-config configuration for libtracecmd.so
References: <20201211170842.611554918@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add pkg-config setup to install for pkg-config libtracecmd to return the
proper CFLAGS and LIB flags for building against libtracecmd.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                | 24 ++++++++++++++++++++++--
 libtracecmd.pc.template | 10 ++++++++++
 scripts/utils.mk        |  8 ++++++++
 3 files changed, 40 insertions(+), 2 deletions(-)
 create mode 100644 libtracecmd.pc.template

diff --git a/Makefile b/Makefile
index ea07e9ee7081..24b2b8f652f7 100644
--- a/Makefile
+++ b/Makefile
@@ -61,6 +61,8 @@ libdir ?= $(prefix)/lib
 libdir_SQ = '$(subst ','\'',$(libdir))'
 includedir = $(prefix)/include
 includedir_SQ = '$(subst ','\'',$(includedir))'
+pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
+			--variable pc_path pkg-config | tr ":" " "))
 
 ifeq ($(prefix),/usr/local)
 etcdir ?= /etc
@@ -196,6 +198,17 @@ objtree		:= $(BUILD_OUTPUT)
 src		:= $(srctree)
 obj		:= $(objtree)
 
+PKG_CONFIG_SOURCE_FILE = libtracecmd.pc
+PKG_CONFIG_FILE := $(addprefix $(BUILD_OUTPUT)/,$(PKG_CONFIG_SOURCE_FILE))
+
+define do_make_pkgconfig_file
+	cp -f $(srctree)/${PKG_CONFIG_SOURCE_FILE}.template ${PKG_CONFIG_FILE};	\
+	sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
+	sed -i "s|LIB_VERSION|${LIBTRACECMD_VERSION}|g" ${PKG_CONFIG_FILE}; \
+	sed -i "s|LIB_DIR|$(libdir)|g" ${PKG_CONFIG_FILE}; \
+	sed -i "s|HEADER_DIR|$(includedir)/trace-cmd|g" ${PKG_CONFIG_FILE};
+endef
+
 kshark-dir	= $(src)/kernel-shark
 
 export prefix bindir src obj kshark-dir
@@ -331,6 +344,9 @@ CMAKE_COMMAND = /usr/bin/cmake
 # Build with "BUILD_TYPE=Release" to remove cmake debug info
 BUILD_TYPE ?= RelWithDebInfo
 
+$(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template
+	$(Q) $(call do_make_pkgconfig_file,$(prefix))
+
 $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
 	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) -D_LIBDIR=$(libdir) ..
 
@@ -435,7 +451,7 @@ install_python: force
 install_bash_completion: force
 	$(Q)$(call do_install_data,$(src)/tracecmd/trace-cmd.bash,$(BASH_COMPLETE_DIR))
 
-install_cmd: all_cmd install_plugins install_python install_bash_completion
+install_cmd: all_cmd install_plugins install_python install_bash_completion install_pkgconfig
 	$(Q)$(call do_install,$(obj)/tracecmd/trace-cmd,$(bindir_SQ))
 
 install: install_cmd
@@ -477,9 +493,13 @@ install_doc:
 install_doc_gui:
 	$(MAKE) -C $(kshark-dir)/Documentation install
 
+install_pkgconfig: $(PKG_CONFIG_FILE)
+	$(Q)$(call , $(PKG_CONFIG_FILE)) \
+		$(call do_install_pkgconfig_file,$(prefix))
+
 clean:
 	$(RM) *.o *~ *.a *.so .*.d
-	$(RM) tags TAGS cscope*
+	$(RM) tags TAGS cscope* $(PKG_CONFIG_SOURCE_FILE)
 	$(MAKE) -C $(src)/lib/traceevent clean
 	$(MAKE) -C $(src)/lib/trace-cmd clean
 	$(MAKE) -C $(src)/lib/tracefs clean
diff --git a/libtracecmd.pc.template b/libtracecmd.pc.template
new file mode 100644
index 000000000000..dc41076ece7d
--- /dev/null
+++ b/libtracecmd.pc.template
@@ -0,0 +1,10 @@
+prefix=INSTALL_PREFIX
+libdir=LIB_DIR
+includedir=HEADER_DIR
+
+Name: libtracecmd
+URL: https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+Description: Library for creating and reading trace-cmd data files
+Version: LIB_VERSION
+Cflags: -I${includedir}
+Libs: -L${libdir} -ltracecmd
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 5c47cb420af0..2e79f1a6ca0e 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -144,3 +144,11 @@ define do_install_ld
 		fi							\
 	fi
 endef
+
+define do_install_pkgconfig_file
+	if [ -n "${pkgconfig_dir}" ]; then 					\
+		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
+	else 									\
+		(echo Failed to locate pkg-config directory) 1>&2;		\
+	fi
+endef
-- 
2.29.2


