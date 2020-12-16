Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3DCCC2BBCA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A71D23787
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 20:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgLPUMQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:12:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:35176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727425AbgLPUMP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 15:12:15 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E21923619
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 20:11:35 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpd94-000vuX-Hg
        for linux-trace-devel@vger.kernel.org; Wed, 16 Dec 2020 15:11:34 -0500
Message-ID: <20201216201134.384206582@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 15:11:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/8] libtracefs: Do not hardcode location of libtraceevent
References: <20201216201106.170659791@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The Makefile has LIBS = -L$(obj)/lib/traceevent, which can be incorrect and
should not be used. Remove it.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Makefile b/Makefile
index f675d5e60db1..dec05e3e3a6a 100644
--- a/Makefile
+++ b/Makefile
@@ -312,8 +312,6 @@ all: $(DEFAULT_TARGET)
 $(bdir):
 	@mkdir -p $(bdir)
 
-LIBS = -L$(obj)/lib/traceevent -ltraceevent
-
 $(LIBTRACEFS_STATIC): force
 	$(Q)mkdir -p $(bdir)
 	$(Q)$(MAKE) -C $(src)/src $@
-- 
2.29.2


