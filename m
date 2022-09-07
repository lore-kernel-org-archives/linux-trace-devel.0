Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4C6ECAAD5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Sep 2022 03:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiIGDFJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Sep 2022 23:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiIGDFI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Sep 2022 23:05:08 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820326068A
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Sep 2022 20:05:06 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id fv3so7089749pjb.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Sep 2022 20:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=3y5AOQjmoH7/hHGL1oz7HpMyF52DACM11wqLR3kuOFI=;
        b=A5YoAaRC9iPnbW4byjM/hycgiC95BS95bqSiN3xKaYeKrFNAT93nvDXF9iQSiUepMS
         Gczb66da0xEsZa85CQDiVLuVDs7EY52YCKPIhxtg7NkDV8boe0WARp8jpLgHPH3W0CFG
         VdQtPu3UpPOaKd+JwKgpm4zOBLJIldJlWg9FMumM3szJbEF7jYyNMkRYWkgvxiLAULug
         oXtcC3X6tYcUbpAYN+n18Kv5XtG5anTUvsQVKaP4cTNH0r8HBPW/lSS/el/j1N/LKO8+
         69vraTpkZCdVWFv/iDjBZ2Vd/mU5LTWxyuy+Hn10/kAWyQOsMvOaIEQW6louIT4eXTCw
         FVkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=3y5AOQjmoH7/hHGL1oz7HpMyF52DACM11wqLR3kuOFI=;
        b=H7e/N1NPUYfuHKaXcnAJTHXKy/o3ymiyQd3CiCNT8VbHuCcLDrY0GGVUEKETavy4ID
         JbYx/Ntegpa2+gXGCtxhWscXqwY3BI4YUYDVSCAb5jRgbSkF/eG9BPe/eSlwJ+fz1pZl
         J/LAxpK6E/MIIxXF7l2+4iQWQU5gEtZ2Wsi2Mg5fAU8LEubYdJSvzIcxcvjwNrshrt1N
         nHS8BxCLrd38lhi36d8ASBDlJqhQpKqbRK1zpjbAgwi3kSSGjRk3d+AgsIIP3EbI0t5T
         bAuEN9ZrCGJzCnaZ+ImAAWWziW4JEUniqvt6eBphtqwDjbEDMIslloqCSMNNkg4dFtvU
         CfIQ==
X-Gm-Message-State: ACgBeo2W3iCEJjLqICBjP3r54FOvLiDUALrOV70J49WP+MHExfMfhh4h
        5AfjxHrRAJeFSODIzxm6hPwzCJ5sPng=
X-Google-Smtp-Source: AA6agR78+8eb2JcDyUX91DCTCxmlahI3imhYmShDmxAVoLT75RqXkn23OTlJfk5GM3Rnw7SbhW2uBA==
X-Received: by 2002:a17:903:32d2:b0:172:66e4:ba68 with SMTP id i18-20020a17090332d200b0017266e4ba68mr1854158plr.116.1662519905965;
        Tue, 06 Sep 2022 20:05:05 -0700 (PDT)
Received: from localhost ([58.34.94.196])
        by smtp.gmail.com with ESMTPSA id q14-20020a17090311ce00b001743c51123esm10870932plh.72.2022.09.06.20.05.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Sep 2022 20:05:05 -0700 (PDT)
Date:   Wed, 7 Sep 2022 11:03:56 +0800
From:   lijiazi <jqqlijiazi@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        "Jiazi.Li" <jiazi.li@transsion.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] ring-buffer: Add barrire in rb_move_tail
Message-ID: <20220907024930.GA24124@Jiazi.Li>
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
Sure, I will test this patch.
Thanks!
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
