Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07AE9C28D13
	for <linux-trace-devel@archiver.kernel.org>; Sat, 20 Aug 2022 02:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240190AbiHTCDA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Aug 2022 22:03:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43840 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiHTCC7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Aug 2022 22:02:59 -0400
Received: from usagi.middle.earth (ethbase.usagi.not.afront.org [IPv6:2620:137:e001:0:1897:4108:901b:c660])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 0C73D8404F8C;
        Fri, 19 Aug 2022 19:02:59 -0700 (PDT)
Received: from usagi.middle.earth (localhost [IPv6:::1])
        by usagi.middle.earth (Postfix) with ESMTP id 9C3BB420EC68;
        Fri, 19 Aug 2022 19:02:55 -0700 (PDT)
From:   "John 'Warthog9' Hawley (VMware)" <warthog9@eaglescrag.net>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org
Subject: [PATCH] libtracefs: allow pthread inclusion overrideable in Makefile
Date:   Fri, 19 Aug 2022 19:02:55 -0700
Message-Id: <20220820020255.754420-1-warthog9@eaglescrag.net>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 19 Aug 2022 19:02:59 -0700 (PDT)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

clang fails if you attempt to inclued -lpthread in the linking phase for
certain versions of clang (newer seems to be happier with it).  This
should allow for -lpthread to be overridden on the builds where it's
causing problems

Signed-off-by: John 'Warthog9' Hawley (VMware) <warthog9@eaglescrag.net>
---
 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index aa659b4..1d25c14 100644
--- a/Makefile
+++ b/Makefile
@@ -132,7 +132,8 @@ LIBTRACEFS_SHARED_VERSION = $(bdir)/libtracefs.so.$(TFS_VERSION)
 PKG_CONFIG_SOURCE_FILE = libtracefs.pc
 PKG_CONFIG_FILE := $(addprefix $(obj)/,$(PKG_CONFIG_SOURCE_FILE))
 
-LIBS = $(LIBTRACEEVENT_LIBS) -lpthread
+LPTHREAD ?= -lpthread
+LIBS = $(LIBTRACEEVENT_LIBS) $(LPTHREAD)
 
 export LIBS
 export LIBTRACEFS_STATIC LIBTRACEFS_SHARED
-- 
2.37.2

