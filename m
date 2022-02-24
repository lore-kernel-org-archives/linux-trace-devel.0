Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0435C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 03:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiBXDLT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 22:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiBXDLS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 22:11:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291EA192E1E
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 19:10:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDA6FB821B2
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 03:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5F3C340E7
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 03:10:47 +0000 (UTC)
Date:   Wed, 23 Feb 2022 22:10:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Make libtracefs 1.3 be the minimum version of
 the library
Message-ID: <20220223221045.47597d08@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now that libtracecfs 1.3 is out, we can make that the minimum version of
the library needed to build trace-cmd, which makes sense, since it already
depends on features only in 1.3 and beyond.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index c9faf8db890b..b0d2a460c6b9 100644
--- a/Makefile
+++ b/Makefile
@@ -23,7 +23,7 @@ export LIBTRACECMD_VERSION
 VERSION_FILE = ltc_version.h
 
 LIBTRACEEVENT_MIN_VERSION = 1.3
-LIBTRACEFS_MIN_VERSION = 1.2
+LIBTRACEFS_MIN_VERSION = 1.3
 
 MAKEFLAGS += --no-print-directory
 
-- 
2.34.1

