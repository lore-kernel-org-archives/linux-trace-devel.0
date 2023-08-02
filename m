Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A462C04E69
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Aug 2023 17:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjHBRQu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 13:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjHBRQt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 13:16:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8F9D9
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Aug 2023 10:16:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 522BB61949
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Aug 2023 17:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6806FC433C8;
        Wed,  2 Aug 2023 17:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690996607;
        bh=4VEznqrKLLC2E9dswffCaCK+dKlDMmgv5ld3UwxJPjY=;
        h=From:To:Cc:Subject:Date:From;
        b=V9UYdhNuAlpnKjYmmSIakcnWlvcgTEpy6hhW+sGyou02jQRe5WiA8ZXNfsL43mB3W
         9izQK3Yb5wUeaYo2W0lWKgpRucdTzV2234CVKwhIqQKghZ7fow0CzdFtxHxwXQMrLn
         TvC3souQh7CVRQDim3M5DgsDIfHDulU+9ljwGlgvvu/ETHP1xd0JEUNzidPaZStdmC
         JfzT/05ra1Vz4l7NoABPy7+XU5Lnic6YXTn5kplhAcfpAABZR9eP6PPI2VazLjUcV1
         xOK1tAL9ZVKc+9TutmSw701B5o/EXdzM3NwLn7MkUcE8gljsfUt4vHT5StlVNNztSe
         zpG+jppOz96fQ==
From:   Ross Zwisler <zwisler@kernel.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] libtraceeval: fix cscope makefile rule
Date:   Wed,  2 Aug 2023 11:16:34 -0600
Message-ID: <20230802171637.3121112-1-zwisler@kernel.org>
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
index 3ea051c..5779c43 100644
--- a/Makefile
+++ b/Makefile
@@ -230,7 +230,7 @@ $(EMACS_TAGS): force
 
 $(CSCOPE_TAGS): force
 	$(RM) $(obj)/cscope*
-	$(call find_tag_files) | cscope -b -q
+	$(call find_tag_files) | xargs cscope -b -q
 
 tags: $(VIM_TAGS)
 TAGS: $(EMACS_TAGS)
-- 
2.41.0.585.gd2178a4bd4-goog

