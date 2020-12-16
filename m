Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE47C0018C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 106FC23719
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgLPUM4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:12:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728689AbgLPUM4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 15:12:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5457723730
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 20:11:36 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpd95-000vwT-BC
        for linux-trace-devel@vger.kernel.org; Wed, 16 Dec 2020 15:11:35 -0500
Message-ID: <20201216201135.151891625@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 15:11:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 7/8] libtracefs: Have only one definition of overriding CFLAGS
References: <20201216201106.170659791@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

For some reason, there's two places CFLAGS gets overridden. There only needs
to be one. Consolidate them.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index a8b888958614..47ac4f5e8c8c 100644
--- a/Makefile
+++ b/Makefile
@@ -158,11 +158,8 @@ export CUNIT_INSTALLED
 export CFLAGS
 export INCLUDES
 
-# Required CFLAGS
-override CFLAGS += -D_GNU_SOURCE $(LIBTRACEEVENT_INCLUDES)
-
 # Append required CFLAGS
-override CFLAGS += $(INCLUDES)
+override CFLAGS += -D_GNU_SOURCE $(LIBTRACEEVENT_INCLUDES) $(INCLUDES)
 
 all: all_cmd
 
-- 
2.29.2


