Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83FAC54EE9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Sep 2022 14:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbiI1Oxj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 10:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbiI1Oxf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 10:53:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B70913E05
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 07:53:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BADEC61ED1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 14:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0D7C433C1;
        Wed, 28 Sep 2022 14:53:32 +0000 (UTC)
Date:   Wed, 28 Sep 2022 10:54:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     lijiazi <jqqlijiazi@gmail.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        "Jiazi.Li" <jiazi.li@transsion.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Add barrire in rb_move_tail
Message-ID: <20220928105443.1e7e4555@gandalf.local.home>
In-Reply-To: <20220915081414.GA12602@Jiazi.Li>
References: <20220830120854.7545-1-jiazi.li@transsion.com>
        <20220901111320.04b57cb7@gandalf.local.home>
        <20220902031717.GA27303@Jiazi.Li>
        <20220902085641.32ba1651@gandalf.local.home>
        <20220905030209.GA5577@Jiazi.Li>
        <20220906122542.1bab4663@gandalf.local.home>
        <20220907081358.GB24124@Jiazi.Li>
        <20220915081414.GA12602@Jiazi.Li>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Finally got around to looking at this again!

On Thu, 15 Sep 2022 16:25:50 +0800
lijiazi <jqqlijiazi@gmail.com> wrote:

> On Wed, Sep 07, 2022 at 04:13:58PM +0800, lijiazi wrote:
> > > 
> > > Ah, it's not an issue with the commit value but the write value.
> > > 
> > > Can you test this patch.
> > > 
> > > -- Steve
> > > 
> > > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> > > index d59b6a328b7f..6bf7706bb33b 100644
> > > --- a/kernel/trace/ring_buffer.c
> > > +++ b/kernel/trace/ring_buffer.c
> > > @@ -2608,6 +2608,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
> > >  		/* Mark the rest of the page with padding */
> > >  		rb_event_set_padding(event);
> > >  
> > > +		/* Make sure the padding is visible before the write update */
> > > +		smp_wmb();
> > > +  
> > 
> > I checked several ramdumps, most of the padding event that caused crash not be
> > written here. Because its corresponding ring_buffer_event->time_delta is
> > not 0, take one of them as an example:  
> > crash> struct ring_buffer_event ffffffd10b553fe4  
> > struct ring_buffer_event {
> >   type_len = 29,
> >   time_delta = 1,
> >   array = 0xffffffd10b553fe8
> > }
> > and array[0] is 0x18:  
> > crash> rd ffffffd10b553fe8  
> > ffffffd10b553fe8:  0000000500000018                    ........
> > 0x18 = 0xff0 - 0xfd4 - 0x4
> > 0xfd4 is end address of last data event in reader page.
> > 
> > The available space size is 0x18 bytes, and next event want to write is
> > signal_deliver, this event need 0x28 bytes:  
> > crash> trace_event_raw_signal_deliver -x  
> > struct trace_event_raw_signal_deliver {
> >     struct trace_entry ent;
> >     int sig;
> >     int errno;
> >     int code;
> >     unsigned long sa_handler;
> >     unsigned long sa_flags;
> >     char __data[0];
> > }
> > SIZE: 0x28


> > So trigger rb move tail, tail value in rb_reset_tail is 0xfd4, the
> > following if condition is false:
> > if (tail > (BUF_PAGE_SIZE - RB_EVNT_MIN_SIZE))  
> > >  		/* Set the write back to the previous setting */
> > >  		local_sub(length, &tail_page->write);
> > >  		return;

OK. But that memory barrier should still be in place there, as the error is
still at that point as well. But we are missing a memory barrier here:

@@ -2654,6 +2657,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
        /* time delta must be non zero */
        event->time_delta = 1;
 
+       /* Make sure the padding is visible before the tail_page->write update */
+       smp_wmb();
+
        /* Set write to end of buffer */
        length = (tail + length) - BUF_PAGE_SIZE;
        local_sub(length, &tail_page->write);


> > > @@ -4580,6 +4583,13 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
> > >  	goto again;
> > >  
> > >   out:
> > > +	/* If the write is past the end of page, a writer is still updating it */
> > > +	if (reader && reader->write > BUF_PAGE_SIZE)  
> 
> Maybe should use rb_page_write(reeader) to filter out RB_WRITE_INTCNT?

Sure, I'll update that. But missing the filtering out, it would just cause
it to return NULL more than it needs to, and still be able to prevent the
race from happening.

Will reply with an updated patch.

Thanks!

-- Steve

> > > +		reader = NULL;
> > > +
> > > +	/* Make sure we see any padding after the write update */
> > > +	smp_rmb();
> > > +
> > >  	/* Update the read_stamp on the first event */
> > >  	if (reader && reader->read == 0)
> > >  		cpu_buffer->read_stamp = reader->page->time_stamp;  

