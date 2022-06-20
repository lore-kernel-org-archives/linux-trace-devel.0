Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E12C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Jun 2022 15:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242745AbiFTPOp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Jun 2022 11:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243658AbiFTPM5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Jun 2022 11:12:57 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830CB6562
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Jun 2022 08:03:18 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id AA3DC587298BB; Mon, 20 Jun 2022 17:03:16 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 7B323587298BA
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Jun 2022 17:03:16 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: avoid pointless extra DEP stage
Date:   Mon, 20 Jun 2022 17:03:16 +0200
Message-Id: <20220620150316.21022-1-jengelh@inai.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Call the compiler only once per source file.
Reduces build time from 0.85 to 0.75 seconds for me.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 scripts/utils.mk |  4 ++--
 src/Makefile     | 14 ++------------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/scripts/utils.mk b/scripts/utils.mk
index 5f43de1..b8a32a3 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -53,12 +53,12 @@ endif
 
 do_fpic_compile =					\
 	($(print_fpic_compile)				\
-	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) -fPIC $< -o $@)
+	$(CC) -MMD -MP -c $(CPPFLAGS) $(CFLAGS) $(EXT) -fPIC $< -o $@)
 
 do_compile =							\
 	($(if $(GENERATE_PIC), $(do_fpic_compile),		\
 	 $(print_compile)					\
-	 $(CC) -c $(CPPFLAGS) $(CFLAGS) $(EXT) $< -o $@))
+	 $(CC) -MMD -MP -c $(CPPFLAGS) $(CFLAGS) $(EXT) $< -o $@))
 
 do_app_build =						\
 	($(print_app_build)				\
diff --git a/src/Makefile b/src/Makefile
index 645d518..3cd4263 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -48,24 +48,14 @@ sqlhist-lex.c: sqlhist.l sqlhist.tab.c
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
-	$(Q)$(call do_clean,$(OBJS) .*.d)
+	$(Q)$(call do_clean,$(OBJS) *.d)
 
-dep_includes := $(wildcard $(DEPS))
-
-ifneq ($(dep_includes),)
-  include $(dep_includes)
-endif
+-include *.d
 
 $(bdir)/tracefs-sqlhist.o tracefs-sqlhist.o: sqlhist.tab.h
 
-- 
2.36.1

