Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACD9C00140
	for <linux-trace-devel@archiver.kernel.org>; Sun, 31 Jul 2022 16:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiGaQHM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 31 Jul 2022 12:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiGaQHM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 31 Jul 2022 12:07:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CE5DE85
        for <linux-trace-devel@vger.kernel.org>; Sun, 31 Jul 2022 09:07:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1525B80CF2
        for <linux-trace-devel@vger.kernel.org>; Sun, 31 Jul 2022 16:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D30C433C1
        for <linux-trace-devel@vger.kernel.org>; Sun, 31 Jul 2022 16:07:08 +0000 (UTC)
Date:   Sun, 31 Jul 2022 12:07:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: PATCH] libtraceevent: Remove double assignment of val in 
 eval_num_arg()
Message-ID: <20220731120702.522724bd@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The val variable is set twice in a row, remove one of them.

Fixes: b1504f78 ("libtraceevent: Add dynamic_offset()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---

Added on top of: https://lore.kernel.org/all/20220731015928.7ab3a154@rorschach.local.home/

 src/event-parse.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index b3caff6..980e980 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -4314,7 +4314,6 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 			val = (unsigned long)data;
 			break;
 		}
-		val = (unsigned long long)((unsigned long)data + offset);
 		val = (unsigned long)data + offset;
 		break;
 	default: /* not sure what to do there */
-- 
2.35.1

