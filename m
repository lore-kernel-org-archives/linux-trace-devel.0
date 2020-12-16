Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9AE8C2BBD4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EE3423159
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 04:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgLPEnf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:43:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgLPEne (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 23:43:34 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CCD52313C
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 04:42:15 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpOdi-000r0H-1k
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 23:42:14 -0500
Message-ID: <20201216044213.915594804@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 23:41:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 06/12] libtracecmd: Make installing show a nice INSTALL output
References: <20201216044150.375001748@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Currently, when doing "make install_libs" the output looks like:

    INSTALL         /tmp/build/lib/trace-cmd/libtracecmd.so.0.0.1	to	/usr/local/lib64
  cp -fpR /tmp/build/lib/trace-cmd/libtracecmd.so.0 '/usr/local/lib64'
  cp -fpR /tmp/build/lib/trace-cmd/libtracecmd.so '/usr/local/lib64'
    INSTALL         /work/git/trace-cmd.git/include/trace-cmd/trace-cmd.h	to	/usr/local/include/trace-cmd

Have it look like:

  INSTALL         /tmp/build/lib/trace-cmd/libtracecmd.so.0.0.1	to	/usr/local/lib64
  INSTALL         /tmp/build/lib/trace-cmd/libtracecmd.so.0	to	/usr/local/lib64
  INSTALL         /tmp/build/lib/trace-cmd/libtracecmd.so	to	/usr/local/lib64
  INSTALL         /work/git/trace-cmd.git/include/trace-cmd/trace-cmd.h	to	/usr/local/include/trace-cmd

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index a26b989a2c82..3b8087f66db5 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -86,8 +86,10 @@ endif # DESTDIR = ""
 
 install_libs:
 	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
-	cp -fpR $(LIBTRACECMD_SHARED_VERSION) $(DESTDIR)$(libdir_SQ)
-	cp -fpR $(LIBTRACECMD_SHARED_SO) $(DESTDIR)$(libdir_SQ)
+	$(Q)$(call print_install,$(LIBTRACECMD_SHARED_VERSION),$(DESTDIR)$(libdir_SQ))
+	$(Q)cp -fpR $(LIBTRACECMD_SHARED_VERSION) $(DESTDIR)$(libdir_SQ)
+	$(Q)$(call print_install,$(LIBTRACECMD_SHARED_SO),$(DESTDIR)$(libdir_SQ))
+	$(Q)cp -fpR $(LIBTRACECMD_SHARED_SO) $(DESTDIR)$(libdir_SQ)
 	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
 	$(Q)$(call install_ld_config)
 
-- 
2.29.2


