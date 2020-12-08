Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C386FC2BB40
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 21:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A044D22262
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 21:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbgLHVzq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:55:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730429AbgLHVzq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 16:55:46 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFAEE22262
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Dec 2020 21:55:05 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kmkwq-003ssf-Np
        for linux-trace-devel@vger.kernel.org; Tue, 08 Dec 2020 16:55:04 -0500
Message-ID: <20201208215504.599269685@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 08 Dec 2020 16:54:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/6] libtracefs: Use LIBTRACEFS_STATIC/SHARED instead of open coding them
References: <20201208215404.135186972@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The macros LIBTRACEFS_STATIC is defined as $(bdir)/libtracefs.a and
LIBTRACEFS_SHARED is defined as $(bdir)/libtracefs.so.$(TRACE_VERSION).
Instead of open coding them elsewhere in the file, simply use the defined
macros.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 5aa2ba4b5145..5a250eeb03b1 100644
--- a/Makefile
+++ b/Makefile
@@ -252,7 +252,7 @@ force:
 # information in a variable so we can use it in if_changed and friends.
 .PHONY: $(PHONY)
 
-DEFAULT_TARGET = $(bdir)/libtracefs.a
+DEFAULT_TARGET = $(LIBTRACEFS_STATIC)
 
 OBJS =
 OBJS += tracefs-utils.o
@@ -272,10 +272,10 @@ $(DEPS): | $(bdir)
 
 LIBS = -L$(obj)/lib/traceevent -ltraceevent
 
-$(bdir)/libtracefs.a: $(OBJS)
+$(LIBTRACEFS_STATIC): $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
-$(bdir)/libtracefs.so.$(TRACEFS_VERSION): $(OBJS)
+$(LIBTRACEFS_SHARED): $(OBJS)
 	$(Q)$(call do_compile_shared_library)
 	@ln -sf $(@F) $(bdir)/libtracefs.so
 	@ln -sf $(@F) $(bdir)/libtracefs.so.$(TFS_VERSION)
-- 
2.28.0


