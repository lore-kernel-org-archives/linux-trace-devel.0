Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C722ECAAD3
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Sep 2022 08:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiIGIOn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Sep 2022 04:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiIGIOl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Sep 2022 04:14:41 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3852C11155
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Sep 2022 01:14:34 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m3so3163636pjo.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Sep 2022 01:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=LmuykuLx1+z/6z5i+5gmKNyIWUWQm/tvJcDFJ0sisIs=;
        b=dAQ2hbG1quPW+Clt8KQ2a++xvnlvn5BAi0dA3Rh3xsoWDP8fxV9Mdt7sThCo2gc8AS
         F2rZ7PpT9GEjE/qWG4kU74vc7QpFkhaQFI5wnLfyIOMSj4o/uInsGN0lkbSfz2I/s1dm
         xGbv0uQDXxTuOxJRkFclO69USIEzhPq2qebYW4pBK9QqiTQPVbdBIlMvlhRhUl+44Pjg
         uppCMgcrlZKVD/mxBSiJYaXuVllbnb597K/HaV7wAPmdz43y7K4brdJ+Cil5xJWDbr1s
         jiedVkAGpBNMVUiDGkgCQRy/OpYTB7XdJ/cEkDARX/RYN9DqNTkzh5yTrjmb6Cy3X2nK
         e3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=LmuykuLx1+z/6z5i+5gmKNyIWUWQm/tvJcDFJ0sisIs=;
        b=rSe+G+Nn1d9hZrEU694qq7kM+N/dgBRCYPBX7PUbJ64N347QFQrqid0SaP9zoHA2PH
         nCvK4VEZtpadyv+56GF9wztvNbDYXWCSV44ul0qLIQrQG/Lt7ynYgSRTVJDFXlOD16td
         St/PUU+bdbsWIAo4tnnZ7Cip5fVVhm7iaTGxKYYCNW2wo/eoOenbzA2flpNdgpVH9F8e
         ozZkRrLLC1SHuVx1Av306Tnnu70qUqTdsmBdVa9uLQe1FWvyQKmeb+TkDttLH+iJOKIy
         K337fjsle7dts1Fqa8pIiXsJWLvk4VW+xDTuzn2SKpgpQpPEmooV7OD464igbXJcrR4N
         DIiA==
X-Gm-Message-State: ACgBeo1MLWtS2jNieoW/2iYE12JhgNGjZEVOOZQwq/4P9dLuymtZ2Oc6
        Rp2MrNC6kEZ34YEd0bCNCyk=
X-Google-Smtp-Source: AA6agR5nyQlMorFrtUdDLZ5ZpaIA3qu73C27Vw71UuAC9/q3pz6yfP3czD4Prdl93jngiqc+OvaulQ==
X-Received: by 2002:a17:902:b606:b0:176:cde5:431a with SMTP id b6-20020a170902b60600b00176cde5431amr2589069pls.109.1662538473872;
        Wed, 07 Sep 2022 01:14:33 -0700 (PDT)
Received: from localhost ([58.34.94.196])
        by smtp.gmail.com with ESMTPSA id c8-20020a621c08000000b0053e4296e1d3sm2959302pfc.198.2022.09.07.01.14.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 07 Sep 2022 01:14:33 -0700 (PDT)
Date:   Wed, 7 Sep 2022 16:13:58 +0800
From:   lijiazi <jqqlijiazi@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        "Jiazi.Li" <jiazi.li@transsion.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Add barrire in rb_move_tail
Message-ID: <20220907081358.GB24124@Jiazi.Li>
References: <20220830120854.7545-1-jiazi.li@transsion.com>
 <20220901111320.04b57cb7@gandalf.local.home>
 <20220902031717.GA27303@Jiazi.Li>
 <20220902085641.32ba1651@gandalf.local.home>
 <20220905030209.GA5577@Jiazi.Li>
 <20220906122542.1bab4663@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906122542.1bab4663@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Sep 06, 2022 at 12:25:42PM -0400, Steven Rostedt wrote:
> On Mon, 5 Sep 2022 11:23:14 +0800
> lijiazi <jqqlijiazi@gmail.com> wrote:
> 
> > >From ramdump, current reader page's commit is 0xff0, not bigger than  
> > BUF_PAGE_SIZE:
> > crash> struct buffer_page 0xffffffd10b599580 -x  
> > struct buffer_page {
> >   list = {
> >     next = 0xffffffd10b599500,
> >     prev = 0xffffffd10b599680
> >   },
> >   write = {
> >     a = {
> >       counter = 0x100ff0
> >     }
> >   },
> >   read = 0xfd4,
> >   entries = {
> >     a = {
> >       counter = 0x100053
> >     }
> >   },
> >   real_end = 0xfd4,
> >   page = 0xffffffd10b553000
> > }
> > crash> struct buffer_data_page 0xffffffd10b553000 -x  
> > struct buffer_data_page {
> >   time_stamp = 0xe2679ca0cd3d,
> >   commit = {
> >     a = {
> >       counter = 0xff0
> >     }
> >   },
> >   data = 0xffffffd10b553010 "\b"
> > }
> > I also can extrace trace log from ramdump by crash-trace extension tool:
> > bsp: <...>-32191 [006] 249032.606401: signal_generate:      sig=17 errno=0 code=1 comm=WifiDiagnostics pid=1535 grp=1 res=1
> > bsp: <...>-32183 [006] 249032.625192: sched_process_exit:   comm=osi_bin pid=32183 prio=120
> > bsp: <...>-32196 [006] 249033.677333: sched_process_exit:   comm=ip pid=32196 prio=120
> > bsp: <...>-32196 [006] 249033.677562: signal_generate:      sig=17 errno=0 code=1 comm=sh pid=32195 grp=1 res=0
> > Above logs is on reader page, reader task try to read PADDING event
> > after this event and lead to crash.
> 
> Ah, it's not an issue with the commit value but the write value.
> 
> Can you test this patch.
> 
> -- Steve
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index d59b6a328b7f..6bf7706bb33b 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -2608,6 +2608,9 @@ rb_reset_tail(struct ring_buffer_per_cpu *cpu_buffer,
>  		/* Mark the rest of the page with padding */
>  		rb_event_set_padding(event);
>  
> +		/* Make sure the padding is visible before the write update */
> +		smp_wmb();
> +

I checked several ramdumps, most of the padding event that caused crash not be
written here. Because its corresponding ring_buffer_event->time_delta is
not 0, take one of them as an example:
crash> struct ring_buffer_event ffffffd10b553fe4
struct ring_buffer_event {
  type_len = 29,
  time_delta = 1,
  array = 0xffffffd10b553fe8
}
and array[0] is 0x18:
crash> rd ffffffd10b553fe8
ffffffd10b553fe8:  0000000500000018                    ........
0x18 = 0xff0 - 0xfd4 - 0x4
0xfd4 is end address of last data event in reader page.

The available space size is 0x18 bytes, and next event want to write is
signal_deliver, this event need 0x28 bytes:
crash> trace_event_raw_signal_deliver -x
struct trace_event_raw_signal_deliver {
    struct trace_entry ent;
    int sig;
    int errno;
    int code;
    unsigned long sa_handler;
    unsigned long sa_flags;
    char __data[0];
}
SIZE: 0x28
So trigger rb move tail, tail value in rb_reset_tail is 0xfd4, the
following if condition is false:
if (tail > (BUF_PAGE_SIZE - RB_EVNT_MIN_SIZE))
>  		/* Set the write back to the previous setting */
>  		local_sub(length, &tail_page->write);
>  		return;
> @@ -4580,6 +4583,13 @@ rb_get_reader_page(struct ring_buffer_per_cpu *cpu_buffer)
>  	goto again;
>  
>   out:
> +	/* If the write is past the end of page, a writer is still updating it */
> +	if (reader && reader->write > BUF_PAGE_SIZE)
> +		reader = NULL;
> +
> +	/* Make sure we see any padding after the write update */
> +	smp_rmb();
> +
>  	/* Update the read_stamp on the first event */
>  	if (reader && reader->read == 0)
>  		cpu_buffer->read_stamp = reader->page->time_stamp;
