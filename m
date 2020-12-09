Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE35FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABDD223B5F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 04:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgLIEWC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 23:22:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726969AbgLIEWB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 23:22:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7597F23A79
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 04:21:21 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kmqye-0002za-G7
        for linux-trace-devel@vger.kernel.org; Tue, 08 Dec 2020 23:21:20 -0500
Message-ID: <20201209042120.367414155@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 08 Dec 2020 23:19:48 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/6] libtraceevent: Remove "src" and "obj" from Makefile
References: <20201209041946.131377586@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

"src" and "obj" variables are not used in the Makefile. There's no need to
export them.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile         | 2 +-
 plugins/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index e17e9674573b..3c2bd5619c3b 100644
--- a/Makefile
+++ b/Makefile
@@ -75,7 +75,7 @@ srctree := $(CURDIR)
 #$(info Determined 'srctree' to be $(srctree))
 endif
 
-export prefix libdir src obj
+export prefix libdir
 
 # Shell quotes
 libdir_SQ = $(subst ','\'',$(libdir))
diff --git a/plugins/Makefile b/plugins/Makefile
index f34bb5725cbc..8ae3882f9051 100644
--- a/plugins/Makefile
+++ b/plugins/Makefile
@@ -81,7 +81,7 @@ srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 #$(info Determined 'srctree' to be $(srctree))
 endif
 
-export prefix libdir src obj
+export prefix libdir
 
 # Shell quotes
 plugin_dir_SQ = $(subst ','\'',$(plugin_dir))
-- 
2.29.2


