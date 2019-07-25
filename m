Return-Path: <SRS0=vwbJ=VW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CE7C76186
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 01:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 296D32190F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jul 2019 01:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388458AbfGYBsQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Jul 2019 21:48:16 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47586 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388445AbfGYBsQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 21:48:16 -0400
Received: from chiana.gaikai.org (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id C841434888D
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jul 2019 01:48:15 +0000 (UTC)
From:   Patrick McLean <chutzpah@gentoo.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Generate proper soname
Date:   Wed, 24 Jul 2019 18:48:08 -0700
Message-Id: <20190725014808.3646716-1-chutzpah@gentoo.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Patrick McLean <patrick.mclean@sony.com>

The previous soname patch was an earlier version that included the full
path to the build output as the soname (not sure how that happened).
This just uses the basename as the soname, so ld will be able to
properly find the library.
---
 scripts/utils.mk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/utils.mk b/scripts/utils.mk
index 9eb127d..98d7b3c 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -54,7 +54,7 @@ do_build_static_lib =				\
 
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
-	$(CC) --shared $^ -Wl,-soname,$@ -o $@)
+	$(CC) --shared $^ -Wl,-soname,$(@F) -o $@)
 
 do_compile_plugin_obj =				\
 	($(print_plugin_obj_compile)		\
-- 
2.22.0

