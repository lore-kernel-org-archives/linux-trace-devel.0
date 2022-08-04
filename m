Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB608C19F2B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Aug 2022 11:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239422AbiHDLGH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Aug 2022 07:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239039AbiHDLGF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Aug 2022 07:06:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1849954C85
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Aug 2022 04:06:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A72A2B8119C
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Aug 2022 11:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE2BC433C1
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Aug 2022 11:06:01 +0000 (UTC)
Date:   Thu, 4 Aug 2022 07:05:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add missed_events to record
Message-ID: <20220804070559.36e6e6fc@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When iterating over the events in the ring buffer, make sure to set the
"missed_events" value of the record. This is very important for the
callers to know that events were dropped.

Fixes: 3add2d75192e0 ("libtracefs: Iterate over raw events in sorted order")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 61a1c122e74e..d870241e127f 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -46,6 +46,7 @@ static int read_kbuf_record(struct cpu_iterate *cpu)
 	cpu->record.ts = ts;
 	cpu->record.size = kbuffer_event_size(cpu->kbuf);
 	cpu->record.record_size = kbuffer_curr_size(cpu->kbuf);
+	cpu->record.missed_events = kbuffer_missed_events(cpu->kbuf);
 	cpu->record.cpu = cpu->cpu;
 	cpu->record.data = ptr;
 	cpu->record.ref_count = 1;
-- 
2.35.1

