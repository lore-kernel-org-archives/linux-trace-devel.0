Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64EA4ECAAA1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Sep 2022 08:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiIOIZ5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Sep 2022 04:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiIOIZ4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Sep 2022 04:25:56 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13E05E656
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Sep 2022 01:25:53 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 207so8244635pgc.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Sep 2022 01:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=RjFqi3cKeNRGji8ui0pqqHzLyfeTSiVJCgWGplsaAZQ=;
        b=M90nNcjaXFgKxRm8qh2vTuyT9406Chqlc4NE0lTeFRrOrPOQLhMpA5ommzTrbzgaRB
         9CFCEDMsHWFH4zz9Pdg0/TFi/00UZvwKfXuh1h1/Jad0oeg0a9FNkW5lVqGnK7f304Vf
         x+5kD82LrzPSMKN142jhL15/2yigNnPWedd/bhZQlLl+HY3tHjwZoJrYjPTitDNWtN0B
         y+EQbuLRhxPUIWKeO/MUX77spVgZpMDQVAYoMVV/1Ruh50MH+9Y3G6jHRLp+nEx/6c+v
         +fHSwQpmPzZ5zvj5+F8DmDjjiU+qQLdaYRt4A4khGMaP0y33Z2Y7yNsqRHddyhnk8x0I
         t+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=RjFqi3cKeNRGji8ui0pqqHzLyfeTSiVJCgWGplsaAZQ=;
        b=F6ye356rx71WWAji4NF/u7/kMF8EdqOFZO99AWxoOWy3TprfcUAP40mzCJXuunXrUd
         QbV0ZT1THG1fMxD7GxujMnVmoj5ojkhpfS7U+QeWXszwXwF/0MSX1nhB7f98EpWpzez0
         qcaYbnvXs1RgHgk+C0T9dn3L3EKddgwo8fP7WkV2PYktD46Z9jJ72tBQQecBuoytaEsH
         xaJjB2rQBQnPELZD2zvGKCpCXhLDOUgttJMjTLggO9zQwTq5V3mepEB5A90iRTGELGUa
         q72NljAPl1txRKFzJwzmVOGJMZHMjqCp4NnZHxx/MHWELViBmzuE5pPlwAGMVb3Yj35v
         XilA==
X-Gm-Message-State: ACgBeo2lCPPnShEaQyv19YN7ppykbd/PWUb6jTs4cslE5IyUGz1ov2A0
        2+amHbcX2Ab0SqEx72ZnCg4=
X-Google-Smtp-Source: AA6agR4i1zOXh9qTQ1h4MMvD9sfpmcNo/G1ggh9rG09HaHQqL3xZ21Oqmo8qSk8e2sfmvywPGRjtow==
X-Received: by 2002:a05:6a00:b8b:b0:536:71f7:4ce3 with SMTP id g11-20020a056a000b8b00b0053671f74ce3mr41251232pfj.74.1663230353255;
        Thu, 15 Sep 2022 01:25:53 -0700 (PDT)
Received: from localhost ([58.34.94.196])
        by smtp.gmail.com with ESMTPSA id 16-20020a17090a0e9000b0020087d7e778sm1044456pjx.37.2022.09.15.01.25.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Sep 2022 01:25:52 -0700 (PDT)
Date:   Thu, 15 Sep 2022 16:25:50 +0800
From:   lijiazi <jqqlijiazi@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        "Jiazi.Li" <jiazi.li@transsion.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Add barrire in rb_move_tail
Message-ID: <20220915081414.GA12602@Jiazi.Li>
References: <20220830120854.7545-1-jiazi.li@transsion.com>
 <20220901111320.04b57cb7@gandalf.local.home>
 <20220902031717.GA27303@Jiazi.Li>
 <20220902085641.32ba1651@gandalf.local.home>
 <20220905030209.GA5577@Jiazi.Li>
 <20220906122542.1bab4663@gandalf.local.home>
 <20220907081358.GB24124@Jiazi.Li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907081358.GB24124@Jiazi.Li>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Sep 07, 2022 at 04:13:58PM +0800, lijiazi wrote:
> > 
> > Ah, it's not an issue with the commit value but the write value.
> > 
> > Can you test this patch.
> > 
> > -- Steve
> > 
> > diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> > index d59b6a328b7f..6bf7706bb33b 100644
> > --- a/kernel/trace/ring_buffer.c
> > +++ b/kernel/trace/ring_buffer.c
> > @@ -2608,6 +2608,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
> >  		/* Mark the rest of the page with padding */
> >  		rb_event_set_padding(event);
> >  
> > +		/* Make sure the padding is visible before the write update */
> > +		smp_wmb();
> > +
> 
> I checked several ramdumps, most of the padding event that caused crash not be
> written here. Because its corresponding ring_buffer_event->time_delta is
> not 0, take one of them as an example:
> crash> struct ring_buffer_event ffffffd10b553fe4
> struct ring_buffer_event {
>   type_len = 29,
>   time_delta = 1,
>   array = 0xffffffd10b553fe8
> }
> and array[0] is 0x18:
> crash> rd ffffffd10b553fe8
> ffffffd10b553fe8:  0000000500000018                    ........
> 0x18 = 0xff0 - 0xfd4 - 0x4
> 0xfd4 is end address of last data event in reader page.
> 
> The available space size is 0x18 bytes, and next event want to write is
> signal_deliver, this event need 0x28 bytes:
> crash> trace_event_raw_signal_deliver -x
> struct trace_event_raw_signal_deliver {
>     struct trace_entry ent;
>     int sig;
>     int errno;
>     int code;
>     unsigned long sa_handler;
>     unsigned long sa_flags;
>     char __data[0];
> }
> SIZE: 0x28
> So trigger rb move tail, tail value in rb_reset_tail is 0xfd4, the
> following if condition is false:
> if (tail > (BUF_PAGE_SIZE - RB_EVNT_MIN_SIZE))
> >  		/* Set the write back to the previous setting */
> >  		local_sub(length, &tail_page->write);
> >  		return;
> > @@ -4580,6 +4583,13 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
> >  	goto again;
> >  
> >   out:
> > +	/* If the write is past the end of page, a writer is still updating it */
> > +	if (reader && reader->write > BUF_PAGE_SIZE)

Maybe should use rb_page_write(reeader) to filter out RB_WRITE_INTCNT?
Thanks!
> > +		reader = NULL;
> > +
> > +	/* Make sure we see any padding after the write update */
> > +	smp_rmb();
> > +
> >  	/* Update the read_stamp on the first event */
> >  	if (reader && reader->read == 0)
> >  		cpu_buffer->read_stamp = reader->page->time_stamp;
