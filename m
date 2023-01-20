Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73222C05027
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Jan 2023 07:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjATHRR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Jan 2023 02:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjATHRR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Jan 2023 02:17:17 -0500
X-Greylist: delayed 525 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 Jan 2023 23:17:15 PST
Received: from fulda116.server4you.de (mister-muffin.de [144.76.155.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B4F88198B
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Jan 2023 23:17:14 -0800 (PST)
Received: from localhost (unknown [31.16.250.226])
        by mister-muffin.de (Postfix) with ESMTPSA id B9BAE1F4;
        Fri, 20 Jan 2023 08:08:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mister-muffin.de;
        s=mail; t=1674198508;
        bh=zxq8uAifScLg/KuxnXeG6bxEjJxJ7RmlIJDoCxDmw58=;
        h=From:To:Cc:Subject:Date:From;
        b=PjMuYax4zYiZ7e9aWxUPT+nLqwEnt4tdwq/v30k29aOMnCq2ns18F2JWGrgtlaqPL
         oIHFZZ9CtT4WBhS9kSKe5CKQbVlhOBRR9A35xk3k+Bt9TpLwmfm0bVKHkuC3KlNk1B
         ZEERSijCpC/XD8OCUOrtT7upLNqytKgDR8ZknEKQ=
From:   Johannes Schauer Marin Rodrigues <josch@mister-muffin.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Johannes Schauer Marin Rodrigues <josch@mister-muffin.de>
Subject: [PATCH] rtla: Fix cross building
Date:   Fri, 20 Jan 2023 08:08:09 +0100
Message-Id: <20230120070809.6169-1-josch@mister-muffin.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

For a successful cross-build, the host-architecture version of
pkg-config must be used or otherwise host architecture headers of
libtracefs and libtraceevent will not be found.

Signed-off-by: Johannes Schauer Marin Rodrigues <josch@mister-muffin.de>
---
 tools/tracing/rtla/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
index 22e28b76f800..26ebd46ec29c 100644
--- a/tools/tracing/rtla/Makefile
+++ b/tools/tracing/rtla/Makefile
@@ -18,7 +18,7 @@ endef
 $(call allow-override,CC,$(CROSS_COMPILE)gcc)
 $(call allow-override,AR,$(CROSS_COMPILE)ar)
 $(call allow-override,STRIP,$(CROSS_COMPILE)strip)
-$(call allow-override,PKG_CONFIG,pkg-config)
+$(call allow-override,PKG_CONFIG,$(CROSS_COMPILE)pkg-config)
 $(call allow-override,LD_SO_CONF_PATH,/etc/ld.so.conf.d/)
 $(call allow-override,LDCONFIG,ldconfig)
 
-- 
2.39.0

