Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D144C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FC0523F29
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgLKRLF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:11:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:44526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393724AbgLKRLA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 12:11:00 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8586623EB1
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 17:10:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knlvp-000Hdy-HO
        for linux-trace-devel@vger.kernel.org; Fri, 11 Dec 2020 12:10:13 -0500
Message-ID: <20201211171013.400414478@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 11 Dec 2020 12:08:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 03/13] trace-cmd: Use $(LIBTRACECMD_STATIC) instead of open coding in
 Makefile
References: <20201211170842.611554918@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In lib/trace-cmd/Makefile, the libtracecmd.a library and its build path is
open coded is a few places. Use the $(LIBTRACECMD_STATIC) variable instead.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index a3a1075a7ebd..42f1f5c447eb 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -4,7 +4,7 @@ include $(src)/scripts/utils.mk
 
 bdir:=$(obj)/lib/trace-cmd
 
-DEFAULT_TARGET = $(bdir)/libtracecmd.a
+DEFAULT_TARGET = $(LIBTRACECMD_STATIC)
 
 OBJS =
 OBJS += trace-hash.o
@@ -35,7 +35,7 @@ $(bdir):
 $(OBJS): | $(bdir)
 $(DEPS): | $(bdir)
 
-$(bdir)/libtracecmd.a: $(OBJS)
+$(LIBTRACECMD_STATIC): $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
 LIBS = -L$(obj)/lib/traceevent -ltraceevent
-- 
2.29.2


