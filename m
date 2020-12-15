Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDE8C2BB9A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Dec 2020 16:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11E3F223D6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Dec 2020 16:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgLOQlt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 11:41:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbgLOQlt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 11:41:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05C8622573
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Dec 2020 16:41:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpDNr-000nHM-PI
        for linux-trace-devel@vger.kernel.org; Tue, 15 Dec 2020 11:41:07 -0500
Message-ID: <20201215164107.647287878@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 15 Dec 2020 11:40:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] libtracefs: Print installing messages
References: <20201215164030.520449524@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The make install did not show anything being installed. When files are being
installed, they should be printed that they are being installed.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 scripts/utils.mk | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/utils.mk b/scripts/utils.mk
index 71985e6a28b1..ad73814c5664 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -126,6 +126,7 @@ define do_install_mkdir
 endef
 
 define do_install
+	$(print_install)				\
 	$(call do_install_mkdir,$2);			\
 	$(INSTALL) $(if $3,-m $3,) $1 '$(DESTDIR_SQ)$2'
 endef
-- 
2.29.2


