Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242D7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 May 2022 18:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244696AbiEPSOq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 16 May 2022 14:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344682AbiEPSOi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 16 May 2022 14:14:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2C53DA79
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 May 2022 11:14:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81962B8149C
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 May 2022 18:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF82C385AA;
        Mon, 16 May 2022 18:14:33 +0000 (UTC)
Date:   Mon, 16 May 2022 14:14:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     christopher lee <christopher.lee.eu@gmail.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: how to register an event handler for the instance
Message-ID: <20220516141427.775cd70a@gandalf.local.home>
In-Reply-To: <fbb8049e2a9fcce07110d5d97f08458d27c977b4.camel@gmail.com>
References: <93fd065420c6a04141b5e8ba9c89dae1e7c9b6a0.camel@gmail.com>
        <CAPpZLN4A8tes3tnzDqLFBT7S2SvBixFwDW7GkYbSPeA+3e1yCQ@mail.gmail.com>
        <fbb8049e2a9fcce07110d5d97f08458d27c977b4.camel@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 11 May 2022 20:33:48 +0200
christopher lee <christopher.lee.eu@gmail.com> wrote:

> On Sat, 2022-05-07 at 08:02 +0300, Tzvetomir Stoyanov wrote:
> > On Fri, May 6, 2022 at 7:18 PM christopher lee
> > <christopher.lee.eu@gmail.com> wrote:  
> > > 
> > > Hi all,
> > > 
> > > I use libtraceevent in my trace tool to parse the event log. Now I
> > > allocated an instance, but no idea how to use
> > > tep_register_event_handler() to register a handler for the
> > > instance. Is
> > > it possilbe to register handler for the event in the instance?
> > >   
> > 
> > Hi Chrit,
> > All trace events are the same across all trace instances, thus the
> > handler registered with tep_register_event_handler() handles events
> > from all instances with a given id. That's why there are no
> > "instance"
> > oriented APIs in that library. I would suggest looking at the tracefs
> > library, which is instance aware. It can be used to allocate trace
> > instances and read events from a given instance.
> > 
> > https://trace-cmd.org/Documentation/libtracefs/
> >   
> 
> 
> Hi Tzvetomir Stoyanov,
> 
> Thanks,  instance event handlers work now, but I'm confused with these
> codes, do I have to read trace_pipe_raw? I found that if I didn't read

Are you only looking to reading some events or all of them?

> this file, the handler would not be able to get trace information.
> Becuase if I read this file, and also call tep_print_event() will
> consume lots of CPU resoruce. how can I parse the trace event info
> without reading this file?

The tep_print_event() is easier to use, but you can do things manually as
well. I'll need to write a tutorial to explain this more, but I can help
you here.

>  
> 
>         for (i = 0; ; i++) {                                          
>                 char *raw_buf;                                        
>                 char *cpu;                                            
>                                                                                                     
>                 ret = asprintf(&cpu, "%s/cpu%d", per_cpu, i);         
>                 if (ret < 0)                                          
>                         pdie("Could not allocate memory for cpu buffer
> %d name", i);                
>                                                                                                     
>                 ret = stat(cpu, &st);                                 
>                 if (ret < 0 || !S_ISDIR(st.st_mode)) {                
>                         free(cpu);                                    
>                         goto start;                                   
>                 }                                                     
>                                                                                                     
>                 ret = asprintf(&raw_buf, "%s/trace_pipe_raw", cpu);   
>                 if (ret < 0)                                          
>                         pdie("Could not allocate memory for cpu %d raw
> buffer name", i);            
>                                                                                                     
>                 read_raw_buffer(i, raw_buf);                          

This your own code?

There is a way to read it yourself and to pick and choose the evens you
want.

If you read the raw data, you'll need to read it in page size (found in the
header tep file) tep_get_page_size(). And read one page at a time. Then you
can use the kbuffer code (although I haven't finished the man pages for
them)

Look at the traceevent/kbuffer.h file supplied by libtraceevent.

You can do something like the following:

	unsigned long long ts; // time stamp of event
	struct tep_record record; // should probably be allocated

	/* For little endian 64 bit machines */
	kbuf = kbuffer_alloc(KBUFFER_LSIZE_8, KBUFFER_ENDIAN_LITTLE);

	read(fd, buf, page_size);

	kbuffer_load_subbuffer(kbuf, buf);

	data = kbuffer_read_event(kbuf, &ts);

	if (!data)
		return; // end of sub buffer.

	/* Move the kbuf cursor to the next event */
	kbuffer_next_event(kbuf, NULL);

	/* Now data has the record */

	record.ts = ts;
	record.size = kbuffer_event_size(kbuf);
	record.cpu = cpu; // CPU of the trace_pipe_raw file
	record.data = data;
	record.missed_events = kbuffer_missed_events(kbuf);

	/* Now you can use this record with the other libtraceevent logic */
	
-- Steve


>                 free(raw_buf);                                        
>                 free(cpu);                                            
>         } 
> 
> Best regards,
> Christ
> 
> >   

