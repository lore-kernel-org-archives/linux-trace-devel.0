Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02464EB64DC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Jun 2023 17:11:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237974AbjFORLl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Jun 2023 13:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237963AbjFORLk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Jun 2023 13:11:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6389199
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Jun 2023 10:11:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EBA462286
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Jun 2023 17:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A425C433C8
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Jun 2023 17:11:37 +0000 (UTC)
Date:   Thu, 15 Jun 2023 13:11:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd library: Have callbacks exit out of the iterator
Message-ID: <20230615131135.123e38af@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In the man page for tracecmd_iterate_events() it states that if the
callback() returns anything other than zero, it will exit the iterator.
But this is not true. It only exits if the callback returns less than
zero. This is a bug as the code should do what the man page states. Have
it exit the loop if the callback returns non zero.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 145c02eeb718..51420c13c750 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2816,7 +2816,7 @@ int tracecmd_iterate_events(struct tracecmd_input *handle,
 			records[next_cpu] = tracecmd_peek_data(handle, next_cpu);
 			tracecmd_free_record(record);
 		}
-	} while (next_cpu >= 0 && ret >= 0);
+	} while (next_cpu >= 0 && ret == 0);
 
 	/* Need to unlock and free the records */
 	for (cpu = 0; cpu < handle->max_cpu; cpu++) {
@@ -2912,7 +2912,7 @@ int tracecmd_iterate_events_multi(struct tracecmd_input **handles,
 			records[next_cpu].record = tracecmd_peek_data(handle, cpu);
 		}
 
-	} while (next_cpu >= 0 && ret >= 0);
+	} while (next_cpu >= 0 && ret == 0);
 
 	/* Unlock and free the records */
 	for (cpu = 0; cpu < all_cpus; cpu++) {
-- 
2.39.2

