Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7367BC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45AC223F29
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393493AbgLKRMJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:12:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394876AbgLKRLl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 12:11:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B62E23EF2
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 17:10:15 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knlvq-000HhM-Lk
        for linux-trace-devel@vger.kernel.org; Fri, 11 Dec 2020 12:10:14 -0500
Message-ID: <20201211171014.547091932@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 11 Dec 2020 12:08:52 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 10/13] trace-cmd: Install the soft links for libtracecmd.so
References: <20201211170842.611554918@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The libtracecmd.so.$(LIBTRACECMD_VERSION) was being installed into the lib/
directory, but that is not enough for applications to use. It also needs the
libtracecmd.so and libtracecmd.so.$(LIBTC_VERSION) soft links to be
installed too.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 96acdaf9aa27..838a59ddf332 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -61,6 +61,8 @@ $(OBJS): $(bdir)/%.o : $(bdir)/.%.d
 
 install_libs:
 	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
+	cp -fpR $(LIBTRACECMD_SHARED_VERSION) $(DESTDIR)$(libdir_SQ)
+	cp -fpR $(LIBTRACECMD_SHARED_SO) $(DESTDIR)$(libdir_SQ)
 	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
 
 dep_includes := $(wildcard $(DEPS))
-- 
2.29.2


