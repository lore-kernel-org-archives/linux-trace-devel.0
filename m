Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519DBC433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 23:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E07C23A22
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 23:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbgLIXKV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 18:10:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgLIXKV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 18:10:21 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F3DB23A22
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 23:09:40 +0000 (UTC)
Date:   Wed, 9 Dec 2020 18:09:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Force creation of lib/tracefs directory
Message-ID: <20201209180938.1d69f169@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If the $(obj)/lib/tracefs directory does not exist, create it before
building the libraries. Otherwise the build will fail due to the directory
not existing.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index 5d11abc..02b3d25 100644
--- a/Makefile
+++ b/Makefile
@@ -277,9 +277,11 @@ $(bdir):
 LIBS = -L$(obj)/lib/traceevent -ltraceevent
 
 $(LIBTRACEFS_STATIC): force
+	$(Q)mkdir -p $(bdir)
 	$(Q)$(MAKE) -C $(src)/src $@
 
 $(bdir)/libtracefs.so.$(TRACEFS_VERSION): force
+	$(Q)mkdir -p $(bdir)
 	$(Q)$(MAKE) -C $(src)/src $@
 
 clean:
-- 
2.25.4

