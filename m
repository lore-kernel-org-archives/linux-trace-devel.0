Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8798CC001DF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Aug 2023 17:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbjHAR1P (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 13:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbjHAR1O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 13:27:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA19DE0
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Aug 2023 10:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51C7061590
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Aug 2023 17:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6274EC433C8;
        Tue,  1 Aug 2023 17:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690910832;
        bh=o1MR9OK79dV6qq/Fkm30SPyBa5OU0uzqQS77lPJt6W8=;
        h=From:To:Cc:Subject:Date:From;
        b=bBIRd3jOpV9I3ZK0seM7RmeNSDqc98FtnWfTLIHWvJfbKdZQJ2/X+UGcXwgeYV+fx
         GvDHUn97qSr3qmxV/xW++UoqE1TUgJMCnnv3YtAaPOvbBGrXNDoNZipwqt0dUV92ZY
         5oQit/uB5+d+/Rc6QSqOzRfXgr51PU7quhzjCgmrIxh8lxoNyXADP9LGYFogX/fkhS
         H9nRi0nAmwqyp8P8Y1KWlQ/Zp2LjvWy47fYC/I8WkBcutovpIhUIsv/WDAJEUIZCe5
         bKJ/ssXl7Y608rF9mfEROluDXcsF4EPy6ggUNacd+Vx0IMP7YhFBwr88/vw8UhGKjg
         P3DrVE+GK9ErQ==
From:   Ross Zwisler <zwisler@kernel.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] libtracefs: fix cscope makefile rule
Date:   Tue,  1 Aug 2023 11:27:07 -0600
Message-ID: <20230801172709.681696-1-zwisler@kernel.org>
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

