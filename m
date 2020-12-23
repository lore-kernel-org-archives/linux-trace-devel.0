Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E0D2C433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 15:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40A0921D79
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Dec 2020 15:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgLWPsw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Dec 2020 10:48:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:38706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgLWPsv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Dec 2020 10:48:51 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0850C21D79;
        Wed, 23 Dec 2020 15:48:10 +0000 (UTC)
Date:   Wed, 23 Dec 2020 10:48:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Jan Engelhardt <ej+bko@inai.de>
Subject: [PATCH] libtracefs: Do not install header as executable
Message-ID: <20201223104809.035a00dc@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

By default, install will set the mode of the files it installs as rwxr-xr-x,
but headers should not be executable. Set its mode to rw-r--r--.

Reported-by: Jan Engelhardt <ej+bko@inai.de>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=210873
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 5861d1f..10e78f6 100644
--- a/Makefile
+++ b/Makefile
@@ -244,7 +244,7 @@ endif # DESTDIR = ""
 install_libs: libs install_pkgconfig
 	$(Q)$(call do_install,$(LIBTRACEFS_SHARED),$(libdir_SQ)); \
 		cp -fpR $(LIB_INSTALL) $(DESTDIR)$(libdir_SQ)
-	$(Q)$(call do_install,$(src)/include/tracefs.h,$(includedir_SQ))
+	$(Q)$(call do_install,$(src)/include/tracefs.h,$(includedir_SQ),644)
 	$(Q)$(call install_ld_config)
 
 install: install_libs
-- 
2.25.4

