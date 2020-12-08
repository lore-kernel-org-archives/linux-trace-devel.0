Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CEFCC2BB48
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 21:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5DFC20C56
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 21:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgLHVzq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:55:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730397AbgLHVzq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 16:55:46 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDE282226A
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Dec 2020 21:55:05 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kmkwq-003st9-Uu
        for linux-trace-devel@vger.kernel.org; Tue, 08 Dec 2020 16:55:04 -0500
Message-ID: <20201208215504.757940690@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 08 Dec 2020 16:54:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/6] libtracefs: Move source files to new src/ directory
References: <20201208215404.135186972@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In cleaning up the directory structure, move the C files into their own
"src/" directory.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                                     | 28 ++++----------------
 tracefs-events.c => src/tracefs-events.c     |  0
 tracefs-instance.c => src/tracefs-instance.c |  0
 tracefs-utils.c => src/tracefs-utils.c       |  0
 4 files changed, 5 insertions(+), 23 deletions(-)
 rename tracefs-events.c => src/tracefs-events.c (100%)
 rename tracefs-instance.c => src/tracefs-instance.c (100%)
 rename tracefs-utils.c => src/tracefs-utils.c (100%)

diff --git a/Makefile b/Makefile
index 5a250eeb03b1..f6b6a9ede5c0 100644
--- a/Makefile
+++ b/Makefile
@@ -267,35 +267,17 @@ all: $(DEFAULT_TARGET)
 $(bdir):
 	@mkdir -p $(bdir)
 
-$(OBJS): | $(bdir)
-$(DEPS): | $(bdir)
-
 LIBS = -L$(obj)/lib/traceevent -ltraceevent
 
-$(LIBTRACEFS_STATIC): $(OBJS)
-	$(Q)$(call do_build_static_lib)
-
-$(LIBTRACEFS_SHARED): $(OBJS)
-	$(Q)$(call do_compile_shared_library)
-	@ln -sf $(@F) $(bdir)/libtracefs.so
-	@ln -sf $(@F) $(bdir)/libtracefs.so.$(TFS_VERSION)
-
-$(bdir)/%.o: %.c
-	$(Q)$(call do_fpic_compile)
-
-$(DEPS): $(bdir)/.%.d: %.c
-	$(Q)$(CC) -M -MT $(bdir)/$*.o $(CPPFLAGS) $(CFLAGS) $< > $@
+$(LIBTRACEFS_STATIC): force
+	$(Q)$(MAKE) -C $(src)/src $@
 
-$(OBJS): $(bdir)/%.o : $(bdir)/.%.d
-
-dep_includes := $(wildcard $(DEPS))
-
-ifneq ($(dep_includes),)
-  include $(dep_includes)
-endif
+$(bdir)/libtracefs.so.$(TRACEFS_VERSION): force
+	$(Q)$(MAKE) -C $(src)/src $@
 
 clean:
 	$(MAKE) -C $(src)/utest clean
+	$(MAKE) -C $(src)/src clean
 	$(RM) $(TARGETS) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d
 	$(RM) $(PKG_CONFIG_FILE)
 
diff --git a/tracefs-events.c b/src/tracefs-events.c
similarity index 100%
rename from tracefs-events.c
rename to src/tracefs-events.c
diff --git a/tracefs-instance.c b/src/tracefs-instance.c
similarity index 100%
rename from tracefs-instance.c
rename to src/tracefs-instance.c
diff --git a/tracefs-utils.c b/src/tracefs-utils.c
similarity index 100%
rename from tracefs-utils.c
rename to src/tracefs-utils.c
-- 
2.28.0


