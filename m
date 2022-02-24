Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59EC5C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 19:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiBXTZO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 14:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiBXTZO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 14:25:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC126246341
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 11:24:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5714B615F8
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 19:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71998C340F1;
        Thu, 24 Feb 2022 19:24:42 +0000 (UTC)
Date:   Thu, 24 Feb 2022 14:24:40 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] trace-cmd: Add build message if the best compression 
 algorithm is not avaiable
Message-ID: <20220224142440.3d5dbf83@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the best compression package is not available at build time, give a
message stating so. This can help users know that hey should install the
compression developer package.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Depends on: https://lore.kernel.org/all/YhOVEG2AjVPJEw0q@breakpoint.cc/

 Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Makefile b/Makefile
index b4b08b8858aa..3009c2d74592 100644
--- a/Makefile
+++ b/Makefile
@@ -315,6 +315,10 @@ LIBZSTD_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs libzstd")
 CFLAGS += -DHAVE_ZSTD
 ZSTD_INSTALLED=1
 $(info    Have ZSTD compression support)
+else
+$(info	  *************************************************************)
+$(info	  ZSTD package not found, best compression algorithm not in use)
+$(info	  *************************************************************)
 endif
 
 export LIBZSTD_CFLAGS LIBZSTD_LDLAGS ZSTD_INSTALLED
-- 
2.34.1

