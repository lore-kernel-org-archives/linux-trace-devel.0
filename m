Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518F0C43217
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhLQFuv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:50:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60316 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbhLQFus (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:50:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AFFFB82739
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A57C36AEC;
        Fri, 17 Dec 2021 05:50:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my68h-00056q-F5;
        Fri, 17 Dec 2021 00:50:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 07/15] libtracefs: Add "DESCEND" output when descending into directories during build
Date:   Fri, 17 Dec 2021 00:50:33 -0500
Message-Id: <20211217055041.19559-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217055041.19559-1-rostedt@goodmis.org>
References: <20211217055041.19559-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Copy from the Linux kernel a "DESCEND" output when descending into a
directory during the build. This makes the output of the build a little
more informative knowing what directory the build is currently in.

Also add the target and not just the directory, as the build will descend
into the src directory twice with different targets, and just showing that
it goes into the src directory twice looks weird.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile         | 16 ++++++++--------
 scripts/utils.mk | 20 ++++++++++++++++++++
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index 07c9496364bd..2bd23c955d9a 100644
--- a/Makefile
+++ b/Makefile
@@ -182,7 +182,7 @@ test: force $(LIBTRACEFS_STATIC)
 ifneq ($(CUNIT_INSTALLED),1)
 	$(error CUnit framework not installed, cannot build unit tests))
 endif
-	$(Q)$(MAKE) -C $(src)/$(UTEST_DIR) $@
+	$(Q)$(call descend,$(src)/$(UTEST_DIR),$@)
 
 test_mem: test
 ifeq (, $(VALGRIND))
@@ -279,13 +279,13 @@ install_pkgconfig: $(PKG_CONFIG_FILE)
 		$(call do_install_pkgconfig_file,$(prefix))
 
 doc:
-	$(MAKE) -C $(src)/Documentation all
+	$(Q)$(call descend,$(src)/Documentation,all)
 
 doc_clean:
-	$(MAKE) -C $(src)/Documentation clean
+	$(Q)$(call descend,$(src)/Documentation,clean)
 
 install_doc:
-	$(MAKE) -C $(src)/Documentation install
+	$(Q)$(call descend,$(src)/Documentation,install)
 
 define build_uninstall_script
 	$(Q)mkdir $(BUILD_OUTPUT)/tmp_build
@@ -358,19 +358,19 @@ $(VERSION_FILE): force
 
 $(LIBTRACEFS_STATIC): force
 	$(Q)mkdir -p $(bdir)
-	$(Q)$(MAKE) -C $(src)/src $@
+	$(Q)$(call descend,$(src)/src,$@)
 
 $(bdir)/libtracefs.so.$(TRACEFS_VERSION): force
 	$(Q)mkdir -p $(bdir)
-	$(Q)$(MAKE) -C $(src)/src libtracefs.so
+	$(Q)$(call descend,$(src)/src,libtracefs.so)
 
 samples/sqlhist: $(LIBTRACEFS_STATIC)
-	$(Q)$(MAKE) -C $(src)/samples sqlhist
+	$(Q)$(call descend,$(src)/samples,sqlhist)
 
 sqlhist: samples/sqlhist
 
 samples: $(LIBTRACEFS_STATIC) force
-	$(Q)$(MAKE) -C $(src)/samples all
+	$(Q)$(call descend,$(src)/samples,all)
 
 clean:
 	$(MAKE) -C $(src)/utest clean
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 0b3c0675b714..404b929a2b5f 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -3,6 +3,8 @@
 # Utils
 
  GOBJ		= $(notdir $(strip $@))
+ BASE1		= $(notdir $(strip $1))
+ BASE2		= $(notdir $(strip $2))
 
 
 ifeq ($(VERBOSE),1)
@@ -24,6 +26,7 @@ ifeq ($(findstring 1,$(SILENT)$(VERBOSE)),1)
   print_install =
   print_uninstall =
   print_update =
+  print_descend =
 else
   print_compile =		echo '  COMPILE            '$(GOBJ);
   print_app_build =		echo '  BUILD              '$(GOBJ);
@@ -35,6 +38,7 @@ else
   print_install =		echo '  INSTALL     '$1'	to	$(DESTDIR_SQ)$2';
   print_uninstall =		echo '  UNINSTALL     $(DESTDIR_SQ)$1';
   print_update =		echo '  UPDATE             '$(GOBJ);
+  print_descend =		echo '  DESCEND            '$(BASE1) $(BASE2);
 endif
 
 do_fpic_compile =					\
@@ -74,6 +78,22 @@ do_python_plugin_build =			\
 	($(print_plugin_build)			\
 	$(CC) $< -shared $(LDFLAGS) $(PYTHON_LDFLAGS) -o $@)
 
+ifneq ($(findstring $(MAKEFLAGS), w),w)
+PRINT_DIR = --no-print-directory
+else
+NO_SUBDIR = :
+endif
+
+#
+# Define a callable command for descending to a new directory
+#
+# Call by doing: $(call descend,directory[,target])
+#
+descend = \
+	($(print_descend)		\
+	$(MAKE) $(PRINT_DIR) -C $(1) $(2))
+
+
 define make_version.h
 	(echo '/* This file is automatically generated. Do not modify. */';		\
 	echo \#define VERSION_CODE $(shell						\
-- 
2.33.0

