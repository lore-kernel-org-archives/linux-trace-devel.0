Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60401C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 20:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26419216C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 20:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbhADUyn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 15:54:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbhADUym (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 15:54:42 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 352FA216C4
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 20:54:02 +0000 (UTC)
Date:   Mon, 4 Jan 2021 15:54:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Remove extra DESTDIR in install_doc
Message-ID: <20210104155400.267717c1@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The do_install macro already adds the prefix of DESTDIR to the files that it
is installing, but the install_doc added it as well, which caused it to be
added twice and making the DESTDIR path within the DESTDIR where it
installed.

Remove it.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 72b6939..ae38905 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -146,12 +146,13 @@ ifdef missing_tools
 endif
 
 do-install-man: man
-	$(Q)$(call do_install,$(OUTPUT)*.3,$(DESTDIR)$(man3dir),644);
+	@echo "man:$(man3dir) dest:$(DESTDIR) prefix:$(prefix)"
+	$(Q)$(call do_install,$(OUTPUT)*.3,$(man3dir),644);
 
 install-man: man do-install-man
 
 do-install-html: html
-	$(Q)$(call do_install,$(OUTPUT)*.html,$(DESTDIR)$(htmldir),644);
+	$(Q)$(call do_install,$(OUTPUT)*.html,$(htmldir),644);
 
 install-html: html do-install-html
 
-- 
2.25.4

