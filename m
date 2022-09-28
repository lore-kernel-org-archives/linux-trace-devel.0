Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD42C32771
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Sep 2022 20:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiI1U2S (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 16:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234264AbiI1U2E (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 16:28:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12395AB4E1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 13:27:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C34A61FC9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 20:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181BDC4347C;
        Wed, 28 Sep 2022 20:27:56 +0000 (UTC)
Date:   Wed, 28 Sep 2022 16:29:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     lijiazi <jqqlijiazi@gmail.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        "Jiazi.Li" <jiazi.li@transsion.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Add barrire in rb_move_tail
Message-ID: <20220928162908.07b12250@gandalf.local.home>
In-Reply-To: <20220928105935.578b72b6@gandalf.local.home>
References: <20220830120854.7545-1-jiazi.li@transsion.com>
        <20220901111320.04b57cb7@gandalf.local.home>
        <20220902031717.GA27303@Jiazi.Li>
        <20220902085641.32ba1651@gandalf.local.home>
        <20220905030209.GA5577@Jiazi.Li>
        <20220906122542.1bab4663@gandalf.local.home>
        <20220907081358.GB24124@Jiazi.Li>
        <20220915081414.GA12602@Jiazi.Li>
        <20220928105443.1e7e4555@gandalf.local.home>
        <20220928105935.578b72b6@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Sep 2022 10:59:35 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > Will reply with an updated patch.  
> 
> Can you try this patch?

Actually, that failed my testing (for other reasons), can you try this one?

-- Steve

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 3046deacf7b3..46b6f4107428 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2648,6 +2648,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 		/* Mark the rest of the page with padding */
 		rb_event_set_padding(event);
 
+		/* Make sure the padding is visible before the write update */
+		smp_wmb();
+
 		/* Set the write back to the previous setting */
 		local_sub(length, &tail_page->write);
 		return;
@@ -2659,6 +2662,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
 	/* time delta must be non zero */
 	event->time_delta = 1;
 
+	/* Make sure the padding is visible before the tail_page->write update */
+	smp_wmb();
+
 	/* Set write to end of buffer */
 	length = (tail + length) - BUF_PAGE_SIZE;
 	local_sub(length, &tail_page->write);
@@ -4627,6 +4633,29 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
 	arch_spin_unlock(&cpu_buffer->lock);
 	local_irq_restore(flags);
 
+	/* The writer has preempt disable, wait for it. But not forever */
+        for (nr_loops = 0; nr_loops < 1000; nr_loops++) {
+		/* If the write is past the end of page, a writer is still updating it */
+		if (likely(!reader || rb_page_write(reader) <= BUF_PAGE_SIZE))
+			break;
+
+		udelay(1);
+
+		/* Get the latest version of the reader write value */
+		smp_rmb();
+	}
+
+	/* The writer is not moving forward? Something is wrong */
+	if (RB_WARN_ON(cpu_buffer, nr_loops == 1000))
+		reader = NULL;
+
+	/*
+	 * Make sure we see any padding after the write update
+	 * (see rb_reset_tail())
+	 */
+	smp_rmb();
+
+
 	return reader;
 }
 
