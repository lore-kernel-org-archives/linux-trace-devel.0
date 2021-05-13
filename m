Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9BBC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 13:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD6A611BF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 13:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbhEMNbm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 May 2021 09:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234047AbhEMNb0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 May 2021 09:31:26 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 937846143B
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 May 2021 13:30:16 +0000 (UTC)
Date:   Thu, 13 May 2021 09:30:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Up the min version of libtraceevent to 1.3 and
 libtracefs to 1.2
Message-ID: <20210513093015.08580db6@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Allow trace-cmd to use the new API of libtraceevent 1.3 (namely the new
logging functions) and the API of libtracefs (have access to some of the
writing functions).

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 0d8fea0d..b7783d60 100644
--- a/Makefile
+++ b/Makefile
@@ -22,8 +22,8 @@ export LIBTRACECMD_VERSION
 
 VERSION_FILE = ltc_version.h
 
-LIBTRACEEVENT_MIN_VERSION = 1.2
-LIBTRACEFS_MIN_VERSION = 1.1
+LIBTRACEEVENT_MIN_VERSION = 1.3
+LIBTRACEFS_MIN_VERSION = 1.2
 
 MAKEFLAGS += --no-print-directory
 
-- 
2.29.2

