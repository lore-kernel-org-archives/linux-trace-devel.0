Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FC2C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 19:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3125221ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 19:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgLCTIX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 14:08:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbgLCTIX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 14:08:23 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71DD3221E7
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Dec 2020 19:07:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kktx7-002s0Q-4x
        for linux-trace-devel@vger.kernel.org; Thu, 03 Dec 2020 14:07:41 -0500
Message-ID: <20201203190741.005563058@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 03 Dec 2020 14:06:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] libtracefs: Remove useless LIBS = -ldl in Makefile
References: <20201203190652.568672226@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The Makefile includes a LIBS = -ldl, which was copied over from trace-cmd
and is not needed for libtracefs as there's no dynamic linking going on.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Makefile b/Makefile
index c5b13ca869b7..ff95748c0684 100644
--- a/Makefile
+++ b/Makefile
@@ -124,8 +124,6 @@ bdir		:= $(obj)/lib/tracefs
 
 export prefix bindir src obj
 
-LIBS = -ldl
-
 LIBTRACEFS_DIR = $(obj)/lib/tracefs
 LIBTRACEFS_STATIC = $(LIBTRACEFS_DIR)/libtracefs.a
 LIBTRACEFS_SHARED = $(LIBTRACEFS_DIR)/libtracefs.so.$(TRACEFS_VERSION)
-- 
2.28.0


