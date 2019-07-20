Return-Path: <SRS0=TfJx=VR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0194C76198
	for <linux-trace-devel@archiver.kernel.org>; Sat, 20 Jul 2019 03:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C20F22082F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 20 Jul 2019 03:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbfGTDD5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 23:03:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39666 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390400AbfGTDD5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 23:03:57 -0400
Received: from chiana.gaikai.org (unknown [100.42.98.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chutzpah)
        by smtp.gentoo.org (Postfix) with ESMTPSA id AFED4348118
        for <linux-trace-devel@vger.kernel.org>; Sat, 20 Jul 2019 03:03:56 +0000 (UTC)
From:   Patrick McLean <chutzpah@gentoo.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/4] trace-cmd: Set SONAME on shared libraries
Date:   Fri, 19 Jul 2019 20:03:44 -0700
Message-Id: <20190720030344.1991393-5-chutzpah@gentoo.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190720030344.1991393-1-chutzpah@gentoo.org>
References: <20190720030344.1991393-1-chutzpah@gentoo.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Patrick McLean <patrick.mclean@sony.com>

Currently trace-cmd installs some shared libraries, but does not set a
SONAME on these. This often violates distro policies, so it should at
least set something.

This patch sets it to the name of the file, which is somewhat naieve,
but works for many libraries. Generally it should be set to have an ABI
version as the extension, so when the developer breaks ABI, they can
change the soname.

Signed-off-by: Patrick McLean <patrick.mclean@sony.com>
---
 scripts/utils.mk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/utils.mk b/scripts/utils.mk
index 260023a..9eb127d 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -54,7 +54,7 @@ do_build_static_lib =				\
 
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
-	$(CC) --shared $^ -o $@)
+	$(CC) --shared $^ -Wl,-soname,$@ -o $@)
 
 do_compile_plugin_obj =				\
 	($(print_plugin_obj_compile)		\
-- 
2.22.0

