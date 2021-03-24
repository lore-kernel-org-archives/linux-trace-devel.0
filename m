Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03EEC433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 18:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3E2A61A25
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 18:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237454AbhCXSPD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237471AbhCXSOx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 14:14:53 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD5C961A1B
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 18:14:52 +0000 (UTC)
Date:   Wed, 24 Mar 2021 14:14:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Allow for decimal time stamps less than zero
Message-ID: <20210324141451.0b4af13b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: Steven Rostedt (VMware) <rostedt@goodmis.org>

The time parsing of the time stamp should not care if the divisor is less
than the time to decide to print a decimal output or not. If it does, then
we can get output that looks like this:

       trace-cmd-4332  [006]       997355: lock_acquire:         0xffffffffb4a7ee00 fs_reclaim
       trace-cmd-4332  [006]       997356: lock_acquire:         0xffffffffb4a81480 mmu_notifier_invalidate_range_start
       trace-cmd-4332  [006]       997357: lock_release:         0xffffffffb4a81480 mmu_notifier_invalidate_range_start
       trace-cmd-4332  [006]       997357: lock_release:         0xffffffffb4a7ee00 fs_reclaim
       trace-cmd-4332  [006]       997358: kmalloc:              (tracing_buffers_splice_read+0x233) call_site=tracing_buffers_splice_read+0x233 
       trace-cmd-4240  [007]     1.000684: lock_acquire:         0xffffffffb4a3ae48 read tk_core.seq.seqcount
       trace-cmd-4240  [007]     1.000684: lock_release:         0xffffffffb4a3ae48 tk_core.seq.seqcount
       trace-cmd-4240  [007]     1.000684: irq_enable:           caller=ktime_get_coarse_real_ts64+0xc8 parent=0x0
       trace-cmd-4240  [007]     1.000685: ext4_da_write_begin:  dev 253,2 ino 4724578 pos 24150016 len 4096 flags 0

Which is obviously incorrect.

Should be:

       trace-cmd-4332  [006]     0.997355: lock_acquire:         0xffffffffb4a7ee00 fs_reclaim
       trace-cmd-4332  [006]     0.997356: lock_acquire:         0xffffffffb4a81480 mmu_notifier_invalidate_range_start
       trace-cmd-4332  [006]     0.997357: lock_release:         0xffffffffb4a81480 mmu_notifier_invalidate_range_start
       trace-cmd-4332  [006]     0.997357: lock_release:         0xffffffffb4a7ee00 fs_reclaim
       trace-cmd-4332  [006]     0.997358: kmalloc:              (tracing_buffers_splice_read+0x233) call_site=tracing_buffers_splice_read+0x233
       trace-cmd-4240  [007]     1.000684: lock_acquire:         0xffffffffb4a3ae48 read tk_core.seq.seqcount
       trace-cmd-4240  [007]     1.000684: lock_release:         0xffffffffb4a3ae48 tk_core.seq.seqcount
       trace-cmd-4240  [007]     1.000684: irq_enable:           caller=ktime_get_coarse_real_ts64+0xc8 parent=0x0
       trace-cmd-4240  [007]     1.000685: ext4_da_write_begin:  dev 253,2 ino 4724578 pos 24150016 len 4096 flags 0


Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
diff --git a/src/event-parse.c b/src/event-parse.c
index 2a10c2e..e2a7278 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -6110,7 +6110,7 @@ static void print_event_time(struct tep_handle *tep, struct trace_seq *s,
 	while (pr--)
 		p10 *= 10;
 
-	if (p10 > 1 && p10 < time)
+	if (p10 > 1)
 		trace_seq_printf(s, "%5llu.%0*llu", time / p10, prec, time % p10);
 	else
 		trace_seq_printf(s, "%12llu", time);
