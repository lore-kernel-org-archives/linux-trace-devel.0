Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B76C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Nov 2022 20:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbiKOUgX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Nov 2022 15:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiKOUgG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Nov 2022 15:36:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2F414006
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 12:34:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D93C2619FE
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 20:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B568C433D6
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Nov 2022 20:34:20 +0000 (UTC)
Date:   Tue, 15 Nov 2022 15:35:02 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record: Fix -m option
Message-ID: <20221115153502.5253871c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The -m option limits the size of each per-cpu buffer to the value
specified in kbs (or actually pages). That is, if -m 1000 is specified,
then the size per cpu buffer should not be more that 1000 kbs. Since it is
implemented in halfs, it is usually between half and the full amount.

But since the buffer reads can use pipes, the increment of the page count
needs to take that into consideration. Currently, it just increments the
page count every time the count goes over the page size. But due to pipes,
the size increment can be multiple pages (65k in fact), and this distorts
the size.

Have the page count increment via the actually size read and not just by
one even if several pages were read at one go.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-recorder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 20deb31c0897..f387091f5177 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -287,8 +287,8 @@ static inline void update_fd(struct tracecmd_recorder *recorder, int size)
 	recorder->count += size;
 
 	if (recorder->count >= recorder->page_size) {
+		recorder->pages += recorder->count / recorder->page_size;
 		recorder->count = 0;
-		recorder->pages++;
 	}
 
 	if (recorder->pages < recorder->max)
-- 
2.35.1

