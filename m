Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBA2C00144
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Jul 2022 20:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiG2Utu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Jul 2022 16:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiG2Utt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Jul 2022 16:49:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567BA85FB6
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jul 2022 13:49:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA6F562006
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jul 2022 20:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE40C433D6
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jul 2022 20:49:47 +0000 (UTC)
Date:   Fri, 29 Jul 2022 16:49:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record: Keep --proxy from being passed to agents
Message-ID: <20220729164940.233652b0@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If an agent (-A) is specified before a --proxy option, then the proxy
option will be passed to the agent, which should not be done. Keep that
from happening.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 2406489a..63be4069 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6180,7 +6180,7 @@ static void parse_record_options(int argc,
 		 * all the arguments for this instance.
 		 */
 		if (c != 'B' && (c != 'A' || is_proxy) && c != OPT_name &&
-		    is_guest(ctx->instance)) {
+		    is_guest(ctx->instance) && c != OPT_proxy) {
 			add_arg(ctx->instance, c, opts, long_options, optarg);
 			if (c == 'C')
 				ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
-- 
2.35.1

