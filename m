Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C0BCCA47F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jun 2022 14:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241794AbiFHOwD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 10:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243331AbiFHOsl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 10:48:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9787265F87
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 07:48:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E0A7B827E7
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 14:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA71EC34116
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Jun 2022 14:48:07 +0000 (UTC)
Date:   Wed, 8 Jun 2022 10:48:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Fix chunk_cmp()
Message-ID: <20220608104806.27edb40b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The binary search looking for an address in the compressed chunks was
failing when it should have found a chunk. The reason is that the order of
the offsets is in ascending order, but the search was looking as if it was
in descending order.

Fixes: 6a724f21bbbe1 ("trace-cmd library: Add logic for in-memory decompression")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e2ceff331869..fea991ce732c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1285,7 +1285,7 @@ static int chunk_cmp(const void *A, const void *B)
 	if (CHUNK_CHECK_OFFSET(b, a->offset))
 		return 0;
 
-	if (b->offset < a->offset)
+	if (a->offset < b->offset)
 		return -1;
 
 	return 1;
-- 
2.35.1

