Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3132C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhLQFuw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbhLQFus (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:50:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609A5C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:50:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71199CE23AF
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7858CC36AE9;
        Fri, 17 Dec 2021 05:50:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my68h-00056t-Fi;
        Fri, 17 Dec 2021 00:50:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 08/15] libtracefs: Have make clean output cleaner
Date:   Fri, 17 Dec 2021 00:50:34 -0500
Message-Id: <20211217055041.19559-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217055041.19559-1-rostedt@goodmis.org>
References: <20211217055041.19559-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of showing the files being removed by make clean, just output a
command stating what directory the clean is happening in.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile         | 13 +++++++------
 samples/Makefile |  2 +-
 scripts/utils.mk |  8 ++++++++
 src/Makefile     |  2 +-
 utest/Makefile   |  2 +-
 5 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 2bd23c955d9a..bf085bfdb800 100644
--- a/Makefile
+++ b/Makefile
@@ -373,11 +373,12 @@ samples: $(LIBTRACEFS_STATIC) force
 	$(Q)$(call descend,$(src)/samples,all)
 
 clean:
-	$(MAKE) -C $(src)/utest clean
-	$(MAKE) -C $(src)/src clean
-	$(MAKE) -C $(src)/samples clean
-	$(RM) $(TARGETS) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.so.* $(bdir)/*.o $(bdir)/.*.d
-	$(RM) $(PKG_CONFIG_FILE)
-	$(RM) $(VERSION_FILE)
+	$(Q)$(MAKE) -C $(src)/utest clean
+	$(Q)$(MAKE) -C $(src)/src clean
+	$(Q)$(MAKE) -C $(src)/samples clean
+	$(Q)$(call do_clean, \
+	  $(TARGETS) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.so.* $(bdir)/*.o $(bdir)/.*.d \
+	  $(PKG_CONFIG_FILE) \
+	  $(VERSION_FILE))
 
 .PHONY: clean
diff --git a/samples/Makefile b/samples/Makefile
index 1e4fe7fb2144..033f1ca735f4 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -66,4 +66,4 @@ $(bdir)/%.o: $(bdir)/%.c
 	$(CC) -g -Wall -c $(CFLAGS) -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
 
 clean:
-	$(RM) $(bdir)/*
+	$(Q)$(call do_clean,$(bdir)/*)
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 404b929a2b5f..c9b908f1c5d9 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -2,9 +2,11 @@
 
 # Utils
 
+ PWD		:= $(shell /bin/pwd)
  GOBJ		= $(notdir $(strip $@))
  BASE1		= $(notdir $(strip $1))
  BASE2		= $(notdir $(strip $2))
+ BASEPWD	= $(notdir $(strip $(PWD)))
 
 
 ifeq ($(VERBOSE),1)
@@ -27,6 +29,7 @@ ifeq ($(findstring 1,$(SILENT)$(VERBOSE)),1)
   print_uninstall =
   print_update =
   print_descend =
+  print_clean =
 else
   print_compile =		echo '  COMPILE            '$(GOBJ);
   print_app_build =		echo '  BUILD              '$(GOBJ);
@@ -39,6 +42,7 @@ else
   print_uninstall =		echo '  UNINSTALL     $(DESTDIR_SQ)$1';
   print_update =		echo '  UPDATE             '$(GOBJ);
   print_descend =		echo '  DESCEND            '$(BASE1) $(BASE2);
+  print_clean =			echo '  CLEAN              '$(BASEPWD);
 endif
 
 do_fpic_compile =					\
@@ -78,6 +82,10 @@ do_python_plugin_build =			\
 	($(print_plugin_build)			\
 	$(CC) $< -shared $(LDFLAGS) $(PYTHON_LDFLAGS) -o $@)
 
+do_clean =					\
+	($(print_clean)				\
+	$(RM) $1)
+
 ifneq ($(findstring $(MAKEFLAGS), w),w)
 PRINT_DIR = --no-print-directory
 else
diff --git a/src/Makefile b/src/Makefile
index cda0a0cda6e3..8f258a218f97 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -61,7 +61,7 @@ $(OBJS): | $(bdir)
 $(DEPS): | $(bdir)
 
 clean:
-	$(RM) $(OBJS)
+	$(Q)$(call do_clean,$(OBJS))
 
 dep_includes := $(wildcard $(DEPS))
 
diff --git a/utest/Makefile b/utest/Makefile
index 48993650660c..d168b01a328c 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -40,4 +40,4 @@ dep_includes := $(wildcard $(DEPS))
 test: $(TARGETS)
 
 clean:
-	$(RM) $(TARGETS) $(bdir)/*.o $(bdir)/.*.d
+	$(Q)$(call do_clean,$(TARGETS) $(bdir)/*.o $(bdir)/.*.d)
-- 
2.33.0

