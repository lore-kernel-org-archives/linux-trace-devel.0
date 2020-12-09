Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D99EC4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 23:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C17323A22
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 23:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388102AbgLIXPf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 18:15:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728403AbgLIXPf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 18:15:35 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93D83238EB
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 23:14:54 +0000 (UTC)
Date:   Wed, 9 Dec 2020 18:14:52 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add Makefile to the src directory
Message-ID: <20201209181452.6b7c5e8a@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

It appears that I forgot to 'git add src/Makefile' when committing
commit 45b174f478 ("libtracefs: Move source files to new src/ directory")

And this will not build without it!

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/Makefile | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 src/Makefile

diff --git a/src/Makefile b/src/Makefile
new file mode 100644
index 0000000..1dbbf64
--- /dev/null
+++ b/src/Makefile
@@ -0,0 +1,38 @@
+
+include $(src)/scripts/utils.mk
+
+OBJS =
+OBJS += tracefs-utils.o
+OBJS += tracefs-instance.o
+OBJS += tracefs-events.o
+
+OBJS := $(OBJS:%.o=$(bdir)/%.o)
+DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
+
+$(LIBTRACEFS_STATIC): $(OBJS)
+	$(Q)$(call do_build_static_lib)
+
+$(LIBTRACEFS_SHARED): $(OBJS)
+	$(Q)$(call do_compile_shared_library)
+	@ln -sf $(@F) $(bdir)/libtracefs.so
+	@ln -sf $(@F) $(bdir)/libtracefs.so.$(TFS_VERSION)
+
+$(bdir)/%.o: %.c
+	$(Q)$(call do_fpic_compile)
+
+$(DEPS): $(bdir)/.%.d: %.c
+	$(Q)$(CC) -M -MT $(bdir)/$*.o $(CPPFLAGS) $(CFLAGS) $< > $@
+
+$(OBJS): $(bdir)/%.o : $(bdir)/.%.d
+
+$(OBJS): | $(bdir)
+$(DEPS): | $(bdir)
+
+clean:
+	$(RM) $(OBJS)
+
+dep_includes := $(wildcard $(DEPS))
+
+ifneq ($(dep_includes),)
+  include $(dep_includes)
+endif
-- 
2.25.4

