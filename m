Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB4AC001DF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Aug 2023 17:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbjHAR3C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 13:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjHAR3B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 13:29:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AD3E0
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Aug 2023 10:29:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04C0361633
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Aug 2023 17:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35341C433CA;
        Tue,  1 Aug 2023 17:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690910939;
        bh=o1MR9OK79dV6qq/Fkm30SPyBa5OU0uzqQS77lPJt6W8=;
        h=From:To:Subject:Date:From;
        b=AZsPdJMxfKVT5zp6EE/2aHTg1fRTR/gfmj9N7IyXIUn1HPsFp00olzFW315VlgSzc
         hYBbF+UdxIvtomDXUJ4aGvS63XDCXiM+p2JDgeNc0cYbL4fbOlcIGtjgKr5i8jgMud
         zPWsHfd4O7/xQOxT488kM2IndROqBKrFxo61gt+TJV06esZBXwZPyy7j32PVfIpJxV
         gaxbncST/gHTT5e9G3jzlLvp9BCG7ewbM3jGKy8FZaPGRvKKy025yZAPW2xZGi8R73
         icbvEP9pDFIxeS01/82xGXX7dDBoDBuo6JAEiCX8F5bFhF/uT48s2T4+Z7dpTZa93W
         MltgXQghRM1RQ==
From:   Ross Zwisler <zwisler@kernel.org>
To:     zwisler@google.com, linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: fix cscope makefile rule
Date:   Tue,  1 Aug 2023 11:28:53 -0600
Message-ID: <20230801172857.702417-1-zwisler@kernel.org>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Ross Zwisler <zwisler@google.com>

The current 'make cscope' rule does not actually pass the filenames
gathered by 'find' to cscope.  cscope expects them either to be passed
on the command line, as this patch does with xargs, or via a
'cscope.files' intermediate file.   It doesn't read them from stdin.

As long as the file count is low, as it is in this library, the command
line version works fine.  Larger projects like the kernel need to use
the intermediate file.

Signed-off-by: Ross Zwisler <zwisler@google.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 9f377e9..80076aa 100644
--- a/Makefile
+++ b/Makefile
@@ -256,7 +256,7 @@ $(EMACS_TAGS): force
 
 $(CSCOPE_TAGS): force
 	$(RM) $(obj)/cscope*
-	$(call find_tag_files) | cscope -b -q
+	$(call find_tag_files) | xargs cscope -b -q
 
 tags: $(VIM_TAGS)
 TAGS: $(EMACS_TAGS)
-- 
2.41.0.585.gd2178a4bd4-goog

