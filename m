Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6883FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Jul 2022 20:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiGKUwS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 16:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiGKUwQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 16:52:16 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076A852E79
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jul 2022 13:52:15 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 9DEA35868BB02; Mon, 11 Jul 2022 22:52:14 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 3C7665868BB00;
        Mon, 11 Jul 2022 22:52:14 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] libtracefs: avoid pointless extra DEP stage
Date:   Mon, 11 Jul 2022 22:52:14 +0200
Message-Id: <20220711205214.20847-1-jengelh@inai.de>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <sso89r95-no6o-3p97-582p-n674pn78qsp5@vanv.qr>
References: <sso89r95-no6o-3p97-582p-n674pn78qsp5@vanv.qr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Call the compiler only once per source file.
Reduces build time from 0.85 to 0.75 seconds for me.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 .gitignore       |  2 +-
 Makefile         |  1 -
 scripts/utils.mk |  4 ++--
 src/Makefile     | 13 +------------
 utest/Makefile   | 10 +---------
 5 files changed, 5 insertions(+), 25 deletions(-)

diff --git a/.gitignore b/.gitignore
index 88c9b42..3e72a58 100644
--- a/.gitignore
+++ b/.gitignore
@@ -11,5 +11,5 @@ build_prefix
 build_uninstall
 tfs_version.h
 *.o
-*.d
+.*.d
 sqlhist
diff --git a/Makefile b/Makefile
index 0044656..941ffff 100644
--- a/Makefile
+++ b/Makefile
@@ -330,7 +330,6 @@ OBJS += tracefs-instance.o
 OBJS += tracefs-events.o
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
-DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 
 all: $(DEFAULT_TARGET)
 
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 5f43de1..b432e67 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -53,12 +53,12 @@ endif
 
 do_fpic_compile =					\
 	($(print_fpic_compile)				\
-	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) -fPIC $< -o $@)
+	$(CC) -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@ -MP -c $(CPPFLAGS) $(CFLAGS) $(EXT) -fPIC $< -o $@)
 
 do_compile =							\
 	($(if $(GENERATE_PIC), $(do_fpic_compile),		\
 	 $(print_compile)					\
-	 $(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) $< -o $@))
+	 $(CC) -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@ -MP -c $(CPPFLAGS) $(CFLAGS) $(EXT) $< -o $@))
 
 do_app_build =						\
 	($(print_app_build)				\
diff --git a/src/Makefile b/src/Makefile
index 645d518..d28b8f4 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -21,7 +21,6 @@ OBJS += sqlhist.tab.o
 OBJS += tracefs-sqlhist.o
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
-DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 
 $(LIBTRACEFS_STATIC): $(OBJS)
 	$(Q)$(call do_build_static_lib)
@@ -48,24 +47,14 @@ sqlhist-lex.c: sqlhist.l sqlhist.tab.c
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
-$(DEPS): $(bdir)/.%.d: %.c
-	$(Q)$(CC) -M -MT $(bdir)/$*.o $(CPPFLAGS) $(CFLAGS) $< > $@
-
-$(OBJS): $(bdir)/%.o : $(bdir)/.%.d
-
 tracefs-sqlhist.o: sqlhist.tab.h
 
 $(OBJS): | $(bdir)
-$(DEPS): | $(bdir)
 
 clean:
 	$(Q)$(call do_clean,$(OBJS) .*.d)
 
-dep_includes := $(wildcard $(DEPS))
-
-ifneq ($(dep_includes),)
-  include $(dep_includes)
-endif
+-include .*.d
 
 $(bdir)/tracefs-sqlhist.o tracefs-sqlhist.o: sqlhist.tab.h
 
diff --git a/utest/Makefile b/utest/Makefile
index 74bf7e6..ee0020a 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -15,13 +15,11 @@ LIBS += -lcunit				\
 	$(obj)/lib/libtracefs.a
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
-DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 
 $(bdir):
 	@mkdir -p $(bdir)
 
 $(OBJS): | $(bdir)
-$(DEPS): | $(bdir)
 
 $(bdir)/trace-utest: $(OBJS)
 	$(Q)$(do_app_build)
@@ -29,13 +27,7 @@ $(bdir)/trace-utest: $(OBJS)
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
-$(DEPS): $(bdir)/.%.d: %.c
-	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
-	$(Q)$(CC) -M -MT $(bdir)/$*.o $(CPPFLAGS) $(CFLAGS) $< > $@
-
-$(OBJS): $(bdir)/%.o : $(bdir)/.%.d
-
-dep_includes := $(wildcard $(DEPS))
+-include .*.d
 
 test: $(TARGETS)
 
-- 
2.36.1

