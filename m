Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38867C001DF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Aug 2023 13:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbjHDNwu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 09:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbjHDNwn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 09:52:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDBC1BD5
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 06:52:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 476D362033
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 13:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C61DC433C7;
        Fri,  4 Aug 2023 13:52:22 +0000 (UTC)
Date:   Fri, 4 Aug 2023 09:52:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: [PATCH] traceeval: Remove free_results()
Message-ID: <20230804095219.41d66349@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The static function free_results() was never used. I kept it around for
when I was going to add it (and to remind myself not to forgot about it,
which is why I left the warning). But now that the code is being
rewritten, there's no more need to keep he warning around to remind me to
attach it. Get rid of it, all that code is going away anyway.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/trace-analysis.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/src/trace-analysis.c b/src/trace-analysis.c
index 0f68b9941b1e..ba4e1c75d634 100644
--- a/src/trace-analysis.c
+++ b/src/trace-analysis.c
@@ -197,12 +197,6 @@ static int cmp_keys(struct traceeval_key_info_array *tarray,
 	return 0;
 }
 
-static void free_results (struct traceeval *teval)
-{
-	free(teval->results);
-	teval->results = NULL;
-}
-
 static int make_key(struct traceeval *teval, const struct traceeval_key *keys, int *err)
 {
 	struct traceeval_key_info *kinfo;
-- 
2.40.1

