Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EAAC4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F190A233A0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgLPUeV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:34:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726902AbgLPUeV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 15:34:21 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7227B238EC
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 20:33:40 +0000 (UTC)
Date:   Wed, 16 Dec 2020 15:33:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Remove Makfefile targets that reference "gui"
Message-ID: <20201216153338.1d47c93b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

libtracefs was taken from trace-cmd which held kernelshark at the time, and
to build kernelshark, "make gui" and other targets were used. These were
mistakenly copied over to the Makefile to build the stand alone libtracefs.
Remove them.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/Makefile b/Makefile
index 47ac4f5..daaf347 100644
--- a/Makefile
+++ b/Makefile
@@ -253,19 +253,12 @@ install_pkgconfig: $(PKG_CONFIG_FILE)
 
 doc:
 	$(MAKE) -C $(src)/Documentation all
-doc_gui:
-	$(MAKE) -C $(kshark-dir)/Documentation all
-
 
 doc_clean:
 	$(MAKE) -C $(src)/Documentation clean
-doc_gui_clean:
-	$(MAKE) -C $(kshark-dir)/Documentation clean
 
 install_doc:
 	$(MAKE) -C $(src)/Documentation install
-install_doc_gui:
-	$(MAKE) -C $(kshark-dir)/Documentation install
 
 define build_uninstall_script
 	$(Q)mkdir $(BUILD_OUTPUT)/tmp_build
-- 
2.25.4

