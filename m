Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E41CCA479
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jul 2022 23:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbiGGXQg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jul 2022 19:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbiGGXQb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jul 2022 19:16:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8226B250
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jul 2022 16:16:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAE1A6257F
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jul 2022 23:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C85C341C0
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jul 2022 23:16:22 +0000 (UTC)
Date:   Thu, 7 Jul 2022 19:16:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Have tracecmd_write_guest_time_shift() handle
 NULL tsync
Message-ID: <20220707191621.77deba71@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the clock_context_init() fails, the ctx->instance->tsync will be NULL,
but it may be used in calling tracecmd_write_guest_time_shift(). This will
cause a SEGFAULT as that function expects it to be non NULL.

Test for tsync not NULL and return -1 if it is.

More should be done to warn when this happens, but for now prevent the
SEGFAULT. This makes the code more robust.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-timesync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index bc6430983a96..75c27babfe43 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -835,7 +835,7 @@ int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 	int i, j;
 	int ret = -1;
 
-	if (!tsync->vcpu_count)
+	if (!tsync || !tsync->vcpu_count)
 		return -1;
 	vcount = 3 + (5 * tsync->vcpu_count);
 	vector = calloc(vcount, sizeof(struct iovec));
-- 
2.35.1

