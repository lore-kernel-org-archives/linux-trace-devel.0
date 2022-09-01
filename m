Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1116ECAAD1
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Sep 2022 15:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbiIAPMz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Sep 2022 11:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiIAPMy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Sep 2022 11:12:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86DA85F96
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Sep 2022 08:12:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86545B82793
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Sep 2022 15:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4929C433D6;
        Thu,  1 Sep 2022 15:12:49 +0000 (UTC)
Date:   Thu, 1 Sep 2022 11:13:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Jiazi.Li" <jqqlijiazi@gmail.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        "Jiazi.Li" <jiazi.li@transsion.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Add barrire in rb_move_tail
Message-ID: <20220901111320.04b57cb7@gandalf.local.home>
In-Reply-To: <20220830120854.7545-1-jiazi.li@transsion.com>
References: <20220830120854.7545-1-jiazi.li@transsion.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 30 Aug 2022 20:08:54 +0800
"Jiazi.Li" <jqqlijiazi@gmail.com> wrote:

> The following crash issue was encountered several times when read
> trace_pipe:
> 
> 1. in ring_buffer_event_data, found event's type is bigger than
> RINGBUF_TYPE_DATA_TYPE_LEN_MAX, print WARNING:
> [249033.677658]WARNING: CPU: 1 PID: 9975 at ring_buffer_event_data+0x38/0x48
> 
> 2. trace_read_pipe print this event resulting in crash issue:
> [249033.806200] die+0xac/0x37c
> [249033.806891] die_kernel_fault+0x60/0x70
> [249033.807710] die_kernel_fault+0x0/0x70
> [249033.808518] do_bad_area+0x30/0x130
> [249033.809296] do_translation_fault+0x34/0x40
> [249033.810158] do_mem_abort+0x4c/0xf8
> [249033.810935] el1_da+0x1c/0xac
> [249033.811647] string+0x38/0x74
> [249033.812357] vsnprintf+0x430/0x65c
> [249033.813122] seq_buf_vprintf+0x64/0xcc
> [249033.813934] trace_seq_printf+0x70/0xd8
> [249033.814755] trace_raw_output_ipi_handler+0x40/0x54
> [249033.815705] print_trace_line+0x3ec/0x424
> [249033.816547] tracing_read_pipe+0x28c/0x3ec
> [249033.817402] __vfs_read+0x44/0x13c
> [249033.818166] vfs_read+0xb8/0x150
> [249033.818908] ksys_read+0x6c/0xcc
> [249033.819651] __arm64_sys_read+0x18/0x20
> [249033.820470] el0_svc_common+0x98/0x160
> [249033.821278] el0_svc_handler+0x60/0x78
> [249033.822086] el0_svc+0x8/0x300
> 
> ipi event is not enable in my device, the event tracing_read_pipe

The ipi event is *not* enabled? So you are saying that it translated the
extra data at the end that was suppose to be PADDING?

> want to print is a PADDING event generated in rb_move_tail.
> array[0] of this event is 0x18, ipi entry trace event's type value
> is 0x18 too in my device.
> so trace_read_pipe call trace_raw_output_ipi_handler to print this
> event, eventually, system crash because illegal pointers.
> 
> In ring_buffer_peek, PADDING type event will not return to caller.
> So at least when ring_buffer_peek is called, this event has not
> been set to PADDING.
> 
> My reader task poll on trace_pipe and other files, wakeup
> by other files and found that trace ring_buffer is not empty
> because of read != commit.
> But maybe because of cpu out-of-order execution, new event has not
> been set to PADDING type, and leads to above issue.
> 
> Can we fix this issue by add a barrier between rb_reset_tail
> and rb_end_commit?
> Or are there other bugs that cause this issue?

I rather not add a barrier in the writer because that will slow down the
tracing.

> 
> Signed-off-by: Jiazi.Li <jiazi.li@transsion.com>
> ---
>  kernel/trace/ring_buffer.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index d59b6a328b7f..20f3ef839467 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -2717,6 +2717,11 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
>  
>  	rb_reset_tail(cpu_buffer, tail, info);
>  
> +	/*
> +	 * Add barrier to make sure tail event be set to
> +	 * PADDING type before update commit.
> +	 */
> +	smp_mb();

Hmm, I'm thinking this may be a bigger race than a memory barrier. I'm
thinking that the reader has full access to this information at this
moment, as soon as the tail page moved forward. I unfortunately do not have
the time right now to do a full investigation, but thank you for reporting
this.

I think your mb() solution is just making the race window smaller and not
actually fixing the race.

-- Steve

>  	/* Commit what we have for now. */
>  	rb_end_commit(cpu_buffer);
>  	/* rb_end_commit() decs committing */

