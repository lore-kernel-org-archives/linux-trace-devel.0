Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4497C4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 23:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C999A61186
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 23:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbhHTXv2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Aug 2021 19:51:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51048 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhHTXv2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 19:51:28 -0400
Received: from usagi.middle.earth (not.afront.org [50.126.75.182])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id C80574D0F14A1;
        Fri, 20 Aug 2021 16:50:49 -0700 (PDT)
Received: from usagi.middle.earth (localhost [IPv6:::1])
        by usagi.middle.earth (Postfix) with ESMTP id 4C62929B3022;
        Fri, 20 Aug 2021 16:50:49 -0700 (PDT)
From:   "John 'Warthog9' Hawley (VMware)" <warthog9@eaglescrag.net>
To:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] libtracefs: sqlhist - fix build dependency
Date:   Fri, 20 Aug 2021 16:50:42 -0700
Message-Id: <20210820235043.1450620-2-warthog9@eaglescrag.net>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210820235043.1450620-1-warthog9@eaglescrag.net>
References: <20210820235043.1450620-1-warthog9@eaglescrag.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 20 Aug 2021 16:50:49 -0700 (PDT)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Minor race condition (that's shockingly hard to reproduce, though nearly
always reproducible in an rpmbuild) with sqlhist.tab.h being built after
it's needed by tracefs-sqlhist.c.  This just sets an explicit dependency
for tracefs-sqlhist.o on sqlhist.tab.h existing first

Signed-off-by: John 'Warthog9' Hawley (VMware) <warthog9@eaglescrag.net>
---
 src/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/Makefile b/src/Makefile
index 9248efc..314c16c 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -64,3 +64,5 @@ dep_includes := $(wildcard $(DEPS))
 ifneq ($(dep_includes),)
   include $(dep_includes)
 endif
+
+$(bdir)/tracefs-sqlhist.o tracefs-sqlhist.o: sqlhist.tab.h
-- 
2.26.3

