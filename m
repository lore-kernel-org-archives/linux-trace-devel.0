Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D66C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 18 Dec 2021 02:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhLRC6o (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 21:58:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43522 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhLRC6o (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 21:58:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E0B562308
        for <linux-trace-devel@vger.kernel.org>; Sat, 18 Dec 2021 02:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22173C36AE7
        for <linux-trace-devel@vger.kernel.org>; Sat, 18 Dec 2021 02:58:43 +0000 (UTC)
Date:   Fri, 17 Dec 2021 21:58:41 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: PATCH] libtracefs: Remove dependency files on make clean
Message-ID: <20211217215841.51753c6a@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Make clean left behind the dependency files .*.d on make clean, which can
cause havoc when trying to build after doing a checkout to another branch.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 src/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/Makefile b/src/Makefile
index 985744ba1118..e8afab50bafb 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -58,7 +58,7 @@ $(OBJS): | $(bdir)
 $(DEPS): | $(bdir)
 
 clean:
-	$(Q)$(call do_clean,$(OBJS))
+	$(Q)$(call do_clean,$(OBJS) .*.d)
 
 dep_includes := $(wildcard $(DEPS))
 
-- 
2.33.0

