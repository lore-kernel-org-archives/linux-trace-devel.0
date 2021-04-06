Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 629F7C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 19:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10A66613C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 19:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347143AbhDFT7I (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 15:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347124AbhDFT7G (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 15:59:06 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34F2A613BF
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Apr 2021 19:58:58 +0000 (UTC)
Date:   Tue, 6 Apr 2021 15:58:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Use pkg-config --atleast-version to check
 versions of libraries
Message-ID: <20210406155856.7735875a@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When checking for libtraceevent and libtracefs, instead of using
pkg-config to simply check if the libraries exist, also make sure the
version for this build exists, as trace-cmd will start needing new
features from these libraries that are not yet implemented.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index e1b10042..7971f01c 100644
--- a/Makefile
+++ b/Makefile
@@ -20,6 +20,9 @@ export LIBTC_PATCHLEVEL
 export LIBTC_EXTRAVERSION
 export LIBTRACECMD_VERSION
 
+LIBTRACEEVENT_MIN_VERSION = 1.1
+LIBTRACEFS_MIN_VERSION = 1.0
+
 MAKEFLAGS += --no-print-directory
 
 # Makefiles suck: This macro sets a default value of $(2) for the
@@ -227,8 +230,8 @@ export LIBTRACECMD_SHARED_VERSION LIBTRACECMD_SHARED_SO
 LIBTRACEEVENT=libtraceevent
 LIBTRACEFS=libtracefs
 
-TEST_LIBTRACEEVENT = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y")
-TEST_LIBTRACEFS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEFS) > /dev/null 2>&1 && echo y")
+TEST_LIBTRACEEVENT = $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEEVENT_MIN_VERSION) $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y")
+TEST_LIBTRACEFS = $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEFS_MIN_VERSION) $(LIBTRACEFS) > /dev/null 2>&1 && echo y")
 
 ifeq ("$(TEST_LIBTRACEEVENT)", "y")
 LIBTRACEEVENT_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT)")
@@ -237,7 +240,7 @@ else
 .PHONY: warning
 warning:
 	@echo "********************************************"
-	@echo "** NOTICE: libtraceevent not found on system"
+	@echo "** NOTICE: libtraceevent version $(LIBTRACEEVENT_MIN_VERSION) or higher not found on system"
 	@echo "**"
 	@echo "** Consider installing the latest libtraceevent from your"
 	@echo "** distribution, or from source:"
@@ -256,7 +259,7 @@ else
 .PHONY: warning
 warning:
 	@echo "********************************************"
-	@echo "** NOTICE: libtracefs not found on system"
+	@echo "** NOTICE: libtracefs version $(LIBTRACEFS_MIN_VERSION) or higher not found on system"
 	@echo "**"
 	@echo "** Consider installing the latest libtracefs from your"
 	@echo "** distribution, or from source:"
-- 
2.29.2

