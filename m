Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E13BC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 16:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E06F523D3C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 16:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388371AbgLKPbV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:31:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:47760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392549AbgLKPbB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:31:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60A9522E01
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 15:30:20 +0000 (UTC)
Date:   Fri, 11 Dec 2020 10:30:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix soft links to have a proper order
Message-ID: <20201211103018.5f49ae1c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Currently the libraries created have both the .so and the .so.X soft links
pointing to the full verision .so.X.Y.Z. It's better to have them point
serially instead of directly, as it is more common and also makes it easier
to change the .so to point to a different .so.X if needed.

Now the links will be:

  .so -> .so.X
  .so.X -> .so.X.Y.Z

Also clean up the dependencies a little in the Makefile.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile     |  2 +-
 src/Makefile | 13 +++++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 035f4de..b4d0a72 100644
--- a/Makefile
+++ b/Makefile
@@ -293,7 +293,7 @@ $(LIBTRACEFS_STATIC): force
 
 $(bdir)/libtracefs.so.$(TRACEFS_VERSION): force
 	$(Q)mkdir -p $(bdir)
-	$(Q)$(MAKE) -C $(src)/src $@
+	$(Q)$(MAKE) -C $(src)/src libtracefs.so
 
 clean:
 	$(MAKE) -C $(src)/utest clean
diff --git a/src/Makefile b/src/Makefile
index 1b06655..52f17af 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -10,13 +10,22 @@ OBJS += tracefs-events.o
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
 
+LIBTRACEFS_SHARED_SO = $(bdir)/libtracefs.so
+LIBTRACEFS_SHARED_VERSION = $(bdir)/libtracefs.so.$(TFS_VERSION)
+
 $(LIBTRACEFS_STATIC): $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
 $(LIBTRACEFS_SHARED): $(OBJS)
 	$(Q)$(call do_compile_shared_library)
-	@ln -sf $(@F) $(bdir)/libtracefs.so
-	@ln -sf $(@F) $(bdir)/libtracefs.so.$(TFS_VERSION)
+
+$(LIBTRACEFS_SHARED_VERSION): $(LIBTRACEFS_SHARED)
+	@ln -sf $(<F) $@
+
+$(LIBTRACEFS_SHARED_SO): $(LIBTRACEFS_SHARED_VERSION)
+	@ln -sf $(<F) $@
+
+libtracefs.so: $(LIBTRACEFS_SHARED_SO)
 
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
-- 
2.25.4

