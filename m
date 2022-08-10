Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975DAC00140
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Aug 2022 23:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbiHJXzk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Aug 2022 19:55:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43276 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbiHJXzi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Aug 2022 19:55:38 -0400
Received: from usagi.middle.earth (ethbase.usagi.not.afront.org [IPv6:2620:137:e001:0:1897:4108:901b:c660])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id DC462844734A;
        Wed, 10 Aug 2022 16:55:37 -0700 (PDT)
Received: from usagi.middle.earth (localhost [IPv6:::1])
        by usagi.middle.earth (Postfix) with ESMTP id A61F3417FD76;
        Wed, 10 Aug 2022 16:55:35 -0700 (PDT)
From:   "John 'Warthog9' Hawley (VMware)" <warthog9@eaglescrag.net>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtraceevent: Makefile - set LIBS as conditional assignment
Date:   Wed, 10 Aug 2022 16:55:35 -0700
Message-Id: <20220810235535.12887-1-warthog9@eaglescrag.net>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 10 Aug 2022 16:55:37 -0700 (PDT)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Need a way to override LIBS during certain compile operations (read:
clang seemingly), so adjusting this so that LIBS can be defined and
allow for overriding with specific intent to support package builds.

Signed-off-by: John 'Warthog9' Hawley (VMware) <warthog9@eaglescrag.net>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 4d9289d..a320523 100644
--- a/Makefile
+++ b/Makefile
@@ -130,7 +130,7 @@ else
   CFLAGS := -g -Wall
 endif
 
-LIBS = -ldl
+LIBS ?= -ldl
 export LIBS
 
 set_plugin_dir := 1
-- 
2.37.1

