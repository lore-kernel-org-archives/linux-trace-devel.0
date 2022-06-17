Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB3AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jun 2022 21:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbiFQVv4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jun 2022 17:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiFQVvz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jun 2022 17:51:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E4E5A083
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jun 2022 14:51:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20D3AB82BFB
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jun 2022 21:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7810CC3411B;
        Fri, 17 Jun 2022 21:51:51 +0000 (UTC)
Date:   Fri, 17 Jun 2022 17:51:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Wang ShaoBo <bobo.shaobowang@huawei.com>
Subject: [PATCH] libtraceevent: Fix memleak in make_bprint_args()
Message-ID: <20220617175149.7eb7366e@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

Release arg allocated from alloc_arg() when strdup failed in make_bprint_args().

Link: https://lkml.kernel.org/r/20220513023308.2400381-2-bobo.shaobowang@huawei.com

Fixes: 8b43424c32702 ("tools lib traceevent: Remove some die() calls")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 1ba2a78d20a9..4bbf29727e9f 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -4915,8 +4915,10 @@ static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, s
 				arg->next = NULL;
 				arg->type = TEP_PRINT_BSTRING;
 				arg->string.string = strdup(bptr);
-				if (!arg->string.string)
+				if (!arg->string.string) {
+					free(arg);
 					goto out_free;
+				}
 				bptr += strlen(bptr) + 1;
 				*next = arg;
 				next = &arg->next;
-- 
2.35.1

