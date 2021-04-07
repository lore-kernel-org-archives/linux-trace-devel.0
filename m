Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F235C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 18:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24D0161168
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 18:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345040AbhDGSxV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Apr 2021 14:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344788AbhDGSxV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Apr 2021 14:53:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 130A860FEF
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Apr 2021 18:53:10 +0000 (UTC)
Date:   Wed, 7 Apr 2021 14:53:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Set min version of libtracefs to 1.1
Message-ID: <20210407145309.240cbcbd@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

I noticed that the current development of trace-cmd has already started
using new APIs of libtracefs that are not part of libtracefs 1.0. Having
set the latest development of libtracefs to 1.1.dev, we can now start
utilizing all the 1.1 APIs, and up the minimum value the build checks for
to 1.1.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 7971f01c..6e330e47 100644
--- a/Makefile
+++ b/Makefile
@@ -21,7 +21,7 @@ export LIBTC_EXTRAVERSION
 export LIBTRACECMD_VERSION
 
 LIBTRACEEVENT_MIN_VERSION = 1.1
-LIBTRACEFS_MIN_VERSION = 1.0
+LIBTRACEFS_MIN_VERSION = 1.1
 
 MAKEFLAGS += --no-print-directory
 
-- 
2.29.2

