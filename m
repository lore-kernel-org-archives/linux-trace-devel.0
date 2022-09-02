Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3EF8ECAAA1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Sep 2022 03:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbiIBDsG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Sep 2022 23:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiIBDsE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Sep 2022 23:48:04 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7747F65560
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Sep 2022 20:48:02 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 145so716135pfw.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 01 Sep 2022 20:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=vKD8TfmMqTBWdVFR1mJEtEV+5qFuJOssmhigvIglB5U=;
        b=NjpNf1kyoBMcrdYMQvCMrMRWPoWuUrlUrKFbJ+4Suxauf1dHXRgC5PKWjypK4vLNgr
         J1OHz9RhTzYG4fff2tG4RRc7jT8BsmEAJJHZkQkvpFiOWpOBukW0jmHlB9SeTrdWOHsP
         Q/2brnGBpzSlKtOg5R/JB8XciFQMeYvAItWq6Z9tunB+EVFzhNnDsAn1Ccg4edOLSeJ/
         v1S523eLud33y27j2AOjbmZztLPbYCQRcNN5XeV1KWawRxkV3cLW1IbkyQJ33MxsG4hz
         8ND9OphqBKAVbNW5VIdr7yEAclQ9OBfKwBhY2vjMyY6RdnRO9wzuycvsBljXlxtXK7Tx
         /7ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vKD8TfmMqTBWdVFR1mJEtEV+5qFuJOssmhigvIglB5U=;
        b=JLrzLVZKOZyCuhZYdOdhnukKtA6KD2554CQ29fINkH44C8rw8Mx8G+zQJLco6ipFRq
         6FQv0txluIsRCu7dqrnsgKdsQfeFOe1814DzsZurEq3SdvVR8aMM7s+YEQkEE7BuU3co
         QHSepVev3HJal/ry7hQQsQAWlCDPncajtiqhV46XfZVs9Pgms+KRROxSzyE3RRt3XtQ4
         10uSO9SekwQ0fyJrMYTu5dTJWfAk9yfdhCc2SwMxjPhXcpI6749Sl3DAfaowmIOXayU7
         5A57hpzK+KrMDH/SNCy6/GwNWzs7SEiBr8o5O0p/REPVnWuVHAHjx9vM+n9vYepj7dpB
         p8mg==
X-Gm-Message-State: ACgBeo1sCLdtZz7N/fRvKt9HuKvoxWs4+newwdOAPaCLdSWd3oq9iTj8
        d7kwyyA9NvY/rLa7WmKaYdY=
X-Google-Smtp-Source: AA6agR5GR8Db+xgSOjSfud9OcKBREVccJ59Bl53VopsGfi+kQWFlJcNPJm1WkSu6MWDa6tJfVYuuoQ==
X-Received: by 2002:a63:d857:0:b0:42b:424f:9c8c with SMTP id k23-20020a63d857000000b0042b424f9c8cmr29279054pgj.8.1662090481752;
        Thu, 01 Sep 2022 20:48:01 -0700 (PDT)
Received: from localhost ([58.34.94.196])
        by smtp.gmail.com with ESMTPSA id y22-20020aa79436000000b0052ea306a1e8sm411165pfo.210.2022.09.01.20.48.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 01 Sep 2022 20:48:01 -0700 (PDT)
Date:   Fri, 2 Sep 2022 11:47:58 +0800
From:   lijiazi <jqqlijiazi@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        "Jiazi.Li" <jiazi.li@transsion.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Add barrire in rb_move_tail
Message-ID: <20220902031717.GA27303@Jiazi.Li>
References: <20220830120854.7545-1-jiazi.li@transsion.com>
 <20220901111320.04b57cb7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901111320.04b57cb7@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Sep 01, 2022 at 11:13:20AM -0400, Steven Rostedt wrote:
> On Tue, 30 Aug 2022 20:08:54 +0800
> "Jiazi.Li" <jqqlijiazi@gmail.com> wrote:
> 
> > The following crash issue was encountered several times when read
> > trace_pipe:
> > 
> > 1. in ring_buffer_event_data, found event's type is bigger than
> > RINGBUF_TYPE_DATA_TYPE_LEN_MAX, print WARNING:
> > [249033.677658]WARNING: CPU: 1 PID: 9975 at ring_buffer_event_data+0x38/0x48
> > 
> > 2. trace_read_pipe print this event resulting in crash issue:
> > [249033.806200] die+0xac/0x37c
> > [249033.806891] die_kernel_fault+0x60/0x70
> > [249033.807710] die_kernel_fault+0x0/0x70
> > [249033.808518] do_bad_area+0x30/0x130
> > [249033.809296] do_translation_fault+0x34/0x40
> > [249033.810158] do_mem_abort+0x4c/0xf8
> > [249033.810935] el1_da+0x1c/0xac
> > [249033.811647] string+0x38/0x74
> > [249033.812357] vsnprintf+0x430/0x65c
> > [249033.813122] seq_buf_vprintf+0x64/0xcc
> > [249033.813934] trace_seq_printf+0x70/0xd8
> > [249033.814755] trace_raw_output_ipi_handler+0x40/0x54
> > [249033.815705] print_trace_line+0x3ec/0x424
> > [249033.816547] tracing_read_pipe+0x28c/0x3ec
> > [249033.817402] __vfs_read+0x44/0x13c
> > [249033.818166] vfs_read+0xb8/0x150
> > [249033.818908] ksys_read+0x6c/0xcc
> > [249033.819651] __arm64_sys_read+0x18/0x20
> > [249033.820470] el0_svc_common+0x98/0x160
> > [249033.821278] el0_svc_handler+0x60/0x78
> > [249033.822086] el0_svc+0x8/0x300
> > 
> > ipi event is not enable in my device, the event tracing_read_pipe
> 
> The ipi event is *not* enabled? So you are saying that it translated the
> extra data at the end that was suppose to be PADDING?
> 

Yes, in my tracing instance, I only enable four events:
signal_generate, signal_deliver, sched_process_fork and
sched_process_exit.
I also not enable any filter on these events.
Since these four events not trigger frequently, so reader comsume
speed is bigger than event write, and there is no overwrite.

Reader mistook this extra data to ipi_entry event.

> > want to print is a PADDING event generated in rb_move_tail.
> > array[0] of this event is 0x18, ipi entry trace event's type value
> > is 0x18 too in my device.
> > so trace_read_pipe call trace_raw_output_ipi_handler to print this
> > event, eventually, system crash because illegal pointers.
> > 
> > In ring_buffer_peek, PADDING type event will not return to caller.
> > So at least when ring_buffer_peek is called, this event has not
> > been set to PADDING.
> > 
> > My reader task poll on trace_pipe and other files, wakeup
> > by other files and found that trace ring_buffer is not empty
> > because of read != commit.
> > But maybe because of cpu out-of-order execution, new event has not
> > been set to PADDING type, and leads to above issue.
> > 
> > Can we fix this issue by add a barrier between rb_reset_tail
> > and rb_end_commit?
> > Or are there other bugs that cause this issue?
> 
> I rather not add a barrier in the writer because that will slow down the
> tracing.
> 
> > 
> > Signed-off-by: Jiazi.Li <jiazi.li@transsion.com>
> > ---
> >  kernel/trace/ring_buffer.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> > index d59b6a328b7f..20f3ef839467 100644
> > --- a/kernel/trace/ring_buffer.c
> > +++ b/kernel/trace/ring_buffer.c
> > @@ -2717,6 +2717,11 @@ rb_move_tail(struct ring_buffer_per_cpu *cpu_buffer,
> >  
> >  	rb_reset_tail(cpu_buffer, tail, info);
> >  
> > +	/*
> > +	 * Add barrier to make sure tail event be set to
> > +	 * PADDING type before update commit.
> > +	 */
> > +	smp_mb();
> 
> Hmm, I'm thinking this may be a bigger race than a memory barrier. I'm
> thinking that the reader has full access to this information at this
> moment, as soon as the tail page moved forward. I unfortunately do not have
> the time right now to do a full investigation, but thank you for reporting
> this.
> 
> I think your mb() solution is just making the race window smaller and not
> actually fixing the race.
> 
> -- Steve
> 

Yes, I'm thinking this may be a race issue too.
But I didn't find race point through code review.
I have tried the following two methods to investigation this issue:
1. add log in rb_reset_tail, ring_buffer_peek, rb_per_cpu_empty
2. do not add log in these functions, just get timestamp and store to
ring_buffer struct for debug.
But All these changes make issue no longer reproduce, maybe because
these changes also make race window smaller.
Do you have any suggestions?

We now have found more than 20 similar issues, all are reader peek a
PADDING event.
Compared with ordinary data event, the time between write
RING_BUF_PADDING to memory and update commit is very short, because
rb_reset_tail and rb_end_commit are inline functions.
We do not found reader peek a ordinary data event with expired data,
So I think maybe add a barrier could fix this issue.

> >  	/* Commit what we have for now. */
> >  	rb_end_commit(cpu_buffer);
> >  	/* rb_end_commit() decs committing */
> 
