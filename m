Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76CCECAAD4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Aug 2022 14:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344477AbiHZOdu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Aug 2022 10:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344484AbiHZOdt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Aug 2022 10:33:49 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7C9C9251
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Aug 2022 07:33:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D16F933682;
        Fri, 26 Aug 2022 14:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661524427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=fCan0Z4KXxMmCQX15xSA8FLnMoUTHaWgEyQY3K/htqI=;
        b=fM2y+un03EfI/DpnoHlbTqilhOYdecv+iXfNnYwXpwBoDYjP1iaZJPiHuQUV0YiqFAUdm5
        wNpBt6dvBMBwnENxbDj1SS8qUMHUNXT3De6IcCOBo7lme1c/t6P77uBSLtGbUziqvoQ+5J
        nO4vF90pXaVydK504qY3fDx3Rudsgk0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AC2C313A7E;
        Fri, 26 Aug 2022 14:33:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SHTWKMvZCGM6RwAAMHmgww
        (envelope-from <alexandre.vicenzi@suse.com>); Fri, 26 Aug 2022 14:33:47 +0000
From:   Alexandre Vicenzi <alexandre.vicenzi@suse.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Alexandre Vicenzi <alexandre.vicenzi@suse.com>
Subject: [PATCH 3/3] libtracefs: Add test instructions for openSUSE
Date:   Fri, 26 Aug 2022 16:33:42 +0200
Message-Id: <20220826143342.31420-1-alexandre.vicenzi@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add CUnit setup instructions for openSUSE and SLE.
---
 utest/README | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/utest/README b/utest/README
index ed92042..647e460 100644
--- a/utest/README
+++ b/utest/README
@@ -13,3 +13,6 @@ using a precompiled distro package:
 	libcunit1
 	libcunit1-doc
 	libcunit1-dev
+
+ openSUSE and SLE:
+	cunit-devel
-- 
2.34.1

