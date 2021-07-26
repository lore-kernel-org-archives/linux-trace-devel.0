Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3747FC432BE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 16:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25D7560F93
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 16:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238999AbhGZPsm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 11:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238345AbhGZPsb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 11:48:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 069E160F57;
        Mon, 26 Jul 2021 16:29:00 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m83TO-0022l2-Lf; Mon, 26 Jul 2021 12:28:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] trace-cmd: Remove remnants of KernelShark build
Date:   Mon, 26 Jul 2021 12:28:57 -0400
Message-Id: <20210726162857.487153-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726162857.487153-1-rostedt@goodmis.org>
References: <20210726162857.487153-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

There were still some KernelShark make commands for building the gui and
cleaning up the files. Remove them as KernelShark is lives in its own
repository now.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/Makefile b/Makefile
index 951e717e1d87..91f628593ee4 100644
--- a/Makefile
+++ b/Makefile
@@ -70,9 +70,7 @@ bindir_relative = bin
 bindir = $(prefix)/$(bindir_relative)
 man_dir = $(prefix)/share/man
 man_dir_SQ = '$(subst ','\'',$(man_dir))'
-html_install = $(prefix)/share/kernelshark/html
 html_install_SQ = '$(subst ','\'',$(html_install))'
-img_install = $(prefix)/share/kernelshark/html/images
 img_install_SQ = '$(subst ','\'',$(img_install))'
 libdir = $(prefix)/$(libdir_relative)
 libdir_SQ = '$(subst ','\'',$(libdir))'
@@ -207,9 +205,7 @@ PKG_CONFIG_FILE := $(addprefix $(BUILD_OUTPUT)/,$(PKG_CONFIG_SOURCE_FILE))
 
 export pkgconfig_dir PKG_CONFIG_FILE
 
-kshark-dir	= $(src)/kernel-shark
-
-export prefix bindir src obj kshark-dir
+export prefix bindir src obj
 
 LIBS = -ldl
 
@@ -355,11 +351,6 @@ all: all_cmd plugins show_other_make
 
 all_cmd: $(CMD_TARGETS)
 
-CMAKE_COMMAND = /usr/bin/cmake
-
-# Build with "BUILD_TYPE=Release" to remove cmake debug info
-BUILD_TYPE ?= RelWithDebInfo
-
 BUILD_PREFIX := $(BUILD_OUTPUT)/build_prefix
 
 $(BUILD_PREFIX): force
@@ -368,9 +359,6 @@ $(BUILD_PREFIX): force
 $(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template $(BUILD_PREFIX) $(VERSION_FILE)
 	$(Q) $(call do_make_pkgconfig_file,$(prefix))
 
-$(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
-	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) -D_LIBDIR=$(libdir) ..
-
 trace-cmd: force $(LIBTRACECMD_STATIC) \
 	force $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir
 	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
@@ -496,8 +484,6 @@ clean:
 	$(MAKE) -C $(src)/utest clean
 	$(MAKE) -C $(src)/python clean
 	$(MAKE) -C $(src)/tracecmd clean
-	if [ -f $(kshark-dir)/build/Makefile ]; then $(MAKE) -C $(kshark-dir)/build clean; fi
-	cd $(kshark-dir)/build; ./cmake_clean.sh
 
 define build_uninstall_script
 	$(Q)mkdir $(BUILD_OUTPUT)/tmp_build
-- 
2.30.2

