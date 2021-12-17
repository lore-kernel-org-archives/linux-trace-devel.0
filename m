Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4EF7C4321E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 00:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhLQAmX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 19:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhLQAmV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 19:42:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCECC061746
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 16:42:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72D7BB8268F
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 00:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FC8C36AF0;
        Fri, 17 Dec 2021 00:42:16 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my1KB-0004DM-T1;
        Thu, 16 Dec 2021 19:42:15 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 8/9] libtracefs: Have sample build look cleaner
Date:   Thu, 16 Dec 2021 19:42:13 -0500
Message-Id: <20211217004214.16074-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217004214.16074-1-rostedt@goodmis.org>
References: <20211217004214.16074-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The build of the samples directory just showed the raw commands. This is
inconsistent with the rest of the build system. Make it cleaner by showing
EXTRACT, COMPILE SAMPLE OBJ and COMPILE SAMPLE for the samples being
extracted and built.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 samples/Makefile |  9 +++++----
 scripts/utils.mk | 18 ++++++++++++++++++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/samples/Makefile b/samples/Makefile
index 8e2b53bbdfae..8b2267482fbf 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -28,8 +28,9 @@ bdir := $(obj)/bin
 
 all: $(TARGETS)
 
-extract_example = \
-	cat $1 | sed -ne '/^EXAMPLE/,/FILES/ { /EXAMPLE/,+2d ; /^FILES/d ;  /^--/d ; p}' > $2
+ifeq ($(findstring 1,$(SILENT)$(VERBOSE)),1)
+else
+endif
 
 $(bdir)/sqlhist.c: ../Documentation/libtracefs-sql.txt
 	$(call extract_example,$<,$@)
@@ -50,7 +51,7 @@ $(TARGETS): $(bdir)
 sqlhist: $(bdir)/sqlhist
 
 $(bdir)/%: $(bdir)/%.o
-	$(CC) -o $@ $^ $(LIBTRACEFS_STATIC) $(LIBTRACEEVENT_LIBS)
+	$(call do_sample_build,$@,$^)
 
 $(EXAMPLES): $(patsubst %,$(bdir)/%,$(TARGETS))
 
@@ -63,7 +64,7 @@ $(EXAMPLES): $(patsubst %,$(bdir)/%,$(TARGETS))
 #	$(CC) -g -Wall $(CFLAGS) -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
 
 %.o: %.c
-	$(CC) -g -Wall $(CFLAGS) -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
+	$(call do_sample_obj,$@,$^)
 
 clean:
 	$(Q)$(call do_clean,$(bdir)/*)
diff --git a/scripts/utils.mk b/scripts/utils.mk
index af0f14fcbfa7..41b996008a73 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -30,6 +30,9 @@ ifeq ($(findstring 1,$(SILENT)$(VERBOSE)),1)
   print_update =
   print_descend =
   print_clean =
+  print_extract =
+  print_sample_build =
+  print_sample_obj =
 else
   print_compile =		echo '  COMPILE            '$(GOBJ);
   print_app_build =		echo '  BUILD              '$(GOBJ);
@@ -43,6 +46,9 @@ else
   print_update =		echo '  UPDATE             '$(GOBJ);
   print_descend =		echo '  DESCEND            '$(BASE1) $(BASE2);
   print_clean =			echo '  CLEAN              '$(BASEPWD);
+  print_extract =		echo '  EXTRACT            '$(GOBJ);
+  print_sample_build =		echo '  COMPILE SAMPLE     '$(GOBJ);
+  print_sample_obj =		echo '  COMPILE SAMPLE OBJ '$(GOBJ);
 endif
 
 do_fpic_compile =					\
@@ -89,6 +95,18 @@ do_clean =					\
 	($(print_clean)				\
 	$(RM) $1)
 
+extract_example =				\
+	$(Q)($(print_extract)			\
+	cat $1 | sed -ne '/^EXAMPLE/,/FILES/ { /EXAMPLE/,+2d ; /^FILES/d ;  /^--/d ; p}' > $2)
+
+do_sample_build =							\
+	$(Q)($(print_sample_build)					\
+	$(CC) -o $1 $2 $(LIBTRACEFS_STATIC) $(LIBTRACEEVENT_LIBS))
+
+do_sample_obj =									\
+	$(Q)($(print_sample_obj)						\
+	$(CC) -g -Wall $(CFLAGS) -c -o $1 $2 -I../include/ $(LIBTRACEEVENT_INCLUDES))
+
 ifneq ($(findstring $(MAKEFLAGS), w),w)
 PRINT_DIR = --no-print-directory
 else
-- 
2.33.0

