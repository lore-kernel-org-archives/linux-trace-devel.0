Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 228E9C4320A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 23:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 092F8611AF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 23:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhHTXv2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Aug 2021 19:51:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51050 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbhHTXv2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 19:51:28 -0400
Received: from usagi.middle.earth (not.afront.org [50.126.75.182])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id CEE1B4D0F14A2;
        Fri, 20 Aug 2021 16:50:49 -0700 (PDT)
Received: from usagi.middle.earth (localhost [IPv6:::1])
        by usagi.middle.earth (Postfix) with ESMTP id 580A729B3023;
        Fri, 20 Aug 2021 16:50:49 -0700 (PDT)
From:   "John 'Warthog9' Hawley (VMware)" <warthog9@eaglescrag.net>
To:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] libtracefs: make the libtracefs.a gen more robust
Date:   Fri, 20 Aug 2021 16:50:43 -0700
Message-Id: <20210820235043.1450620-3-warthog9@eaglescrag.net>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210820235043.1450620-1-warthog9@eaglescrag.net>
References: <20210820235043.1450620-1-warthog9@eaglescrag.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 20 Aug 2021 16:50:49 -0700 (PDT)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There apparently is a possibility (during an SMP compile) of ar getting
confused about what's going on with libtracefs.a, and throwing a hard to
track down error and truncating the file.  Making the rm operation a bit
 more atomic seems to alleviate this error

Signed-off-by: John 'Warthog9' Hawley (VMware) <warthog9@eaglescrag.net>
---
 scripts/utils.mk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/utils.mk b/scripts/utils.mk
index 32a9b3c..7a88b10 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -52,7 +52,7 @@ do_app_build =						\
 
 do_build_static_lib =				\
 	($(print_static_lib_build)		\
-	$(RM) $@;  $(AR) rcs $@ $^)
+	mv $@ $@.rm; $(RM) $@.rm;  $(AR) rcs $@ $^)
 
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
-- 
2.26.3

