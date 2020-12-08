Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED4EC1B0D9
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 21:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87DCC20C56
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Dec 2020 21:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbgLHVzq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:55:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730419AbgLHVzp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 16:55:45 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 833BE22225
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Dec 2020 21:55:05 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kmkwq-003src-DX
        for linux-trace-devel@vger.kernel.org; Tue, 08 Dec 2020 16:55:04 -0500
Message-ID: <20201208215504.294115386@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 08 Dec 2020 16:54:05 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/6] libtracefs: Move features.mk into scripts directory
References: <20201208215404.135186972@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In order to clean up the directory structure, move the features.mk into the
scripts directory. That's where the helper files for the Makefile should
live anyway.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                           | 2 +-
 features.mk => scripts/features.mk | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename features.mk => scripts/features.mk (100%)

diff --git a/Makefile b/Makefile
index 284f8f2a17ab..e84b41408b54 100644
--- a/Makefile
+++ b/Makefile
@@ -142,7 +142,7 @@ include scripts/utils.mk
 INCLUDES = -I$(src)/include
 INCLUDES += -I$(src)/include/tracefs
 
-include $(src)/features.mk
+include $(src)/scripts/features.mk
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -Wall
diff --git a/features.mk b/scripts/features.mk
similarity index 100%
rename from features.mk
rename to scripts/features.mk
-- 
2.28.0


