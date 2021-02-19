Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B9CC433E6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 17:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 480A764EB2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 17:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhBSR56 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Feb 2021 12:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbhBSR54 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Feb 2021 12:57:56 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BBBC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Feb 2021 09:57:16 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y3so544309plg.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Feb 2021 09:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TRWzueIark5w1RbB3BTvf4hq5+f7RawB85/+IVcHL4E=;
        b=EjE5qXriR2upjhabDC4tgPrMzCyLYeH9/mJe6eJLuUYXIFwafDeqSfZ8LkTsKmN4FG
         PwAHN9KLfWEGMkEMqVSnVLq2a8+0LrEztuj/1D2heoOs4Z6/E0pPuDUgSjUFYXL6D2Nh
         Mwp+4jAdzTZxqSSs57k9hCedg1cK39j5qF6VCrRaVigosBhZQs+jhg/lhcyUN8QHuhFe
         zN1vdmVwRjQxd+WKEoXIBFpvLGp6DFe57XB/VojELw6P90mU6562DGas3/nFl8SkfaH3
         TmEZX+0lifd9yauFS70l2obvU/tCl6Sk+XJsy2PqnoGCGXhwDrT9MuUKPFjIcVBniMFP
         2kPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TRWzueIark5w1RbB3BTvf4hq5+f7RawB85/+IVcHL4E=;
        b=m/R0nn7eD/8Mh0McYgKcQ/y6AL4U2OH0nBsW7gkhEVEFsm33+4QgBYLIVC2kQgkO9k
         eivQzJ0iy4Jz9CNUxBQhRTavTBVz4JEYmz8k4Iu1qMmZHiah+IXLvIPGe1POlZdwF8GW
         7EB+wSNGYFBn1h9oYxfZQZ76vqwx4ZfzNsI+qQWCrvXoA8Oa7FFYAYAAH5sBvXQeJDZ9
         rUXOEL5y8ZH3E2F5XGdZFjoYMBxHClq5RKpMkcoLv5eqZeUKRGORjyAXQt2YKp486BTo
         BcU5LEOsGKwtKKamKVyUz78srtPHyzi1mLve5bh7gSNPzWkyTROnRpFlt/H//cS7FjRc
         h/DQ==
X-Gm-Message-State: AOAM532b0jGO1+8MT+aalmrx2EBipeQbuGSBEiqYAqtRxzTs/GE3pIw1
        d5Dj7Jsn5s5jI7jt0rPSdSXKkgmXH5ctWTmXlG/TgKUlO6c=
X-Google-Smtp-Source: ABdhPJyKOED42FPrzlKHuo/4GsW5QqilGNHlbI6qLT4Ut1RqtURqBPrqc/AuaJFjnKXPD2KPhlqr3m7BClJdujr5d8k=
X-Received: by 2002:a17:902:7402:b029:e3:95e7:b983 with SMTP id
 g2-20020a1709027402b02900e395e7b983mr2931096pll.58.1613757436109; Fri, 19 Feb
 2021 09:57:16 -0800 (PST)
MIME-Version: 1.0
References: <20201203060226.476475-1-tz.stoyanov@gmail.com>
 <20201203060226.476475-6-tz.stoyanov@gmail.com> <20210218210352.61470b93@oasis.local.home>
 <CAPpZLN6nPbJoDBHe0Fm8+BECfXHdpNjQFt9gK9mHGAQriiGjEw@mail.gmail.com> <20210219093623.6965e487@gandalf.local.home>
In-Reply-To: <20210219093623.6965e487@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 19 Feb 2021 19:56:59 +0200
Message-ID: <CAPpZLN6OuoFnAtc6ERAKQwncL6FQ2pTpm6Sao0RUSyCg7W4cSg@mail.gmail.com>
Subject: Re: [PATCH 5/5] [WIP] trace-cmd: Add new subcomand "trace-cmd perf"
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Feb 19, 2021 at 4:36 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 19 Feb 2021 09:16:26 +0200
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > Hi Steven,
> >
> > On Fri, Feb 19, 2021 at 4:03 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > On Thu,  3 Dec 2020 08:02:26 +0200
> > > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> > >
> > > > +static int perf_mmap(struct perf_cpu *perf)
> > > > +{
> > > > +     mmap_mask = NUM_PAGES * getpagesize() - 1;
> > > > +
> > > > +     /* associate a buffer with the file */
> > > > +     perf->mpage = mmap(NULL, (NUM_PAGES + 1) * getpagesize(),
> > > > +                     PROT_READ | PROT_WRITE, MAP_SHARED, perf->perf_fd, 0);
> > > > +     if (perf->mpage == MAP_FAILED)
> > > > +             return -1;
> > > > +     return 0;
> > > > +}
> > >
> > > BTW, I found that the above holds the conversions we need for the local
> > > clock!
> > >
> > >         printf("time_shift=%d\n", perf->mpage->time_shift);
> > >         printf("time_mult=%d\n", perf->mpage->time_mult);
> > >         printf("time_offset=%lld\n", perf->mpage->time_offset);
> > >
> > > Which gives me:
> > >
> > > time_shift=31
> > > time_mult=633046315
> > > time_offset=-115773323084683
> > >
> > > [ one for each CPU ]
> >
> > This will give us time shift/mult/offset for each host CPU, right ? Is
> > the local trace clock
> > different for each CPU ?
>
> It can be. Note, the above offset is basically useless. That injects the
> current time into the value and we can't rely on it. But the shift and mult
> is needed.
>
> But, usually, the shift and offset are identical on most systems across
> CPUs, but there's no guarantee that it will always be the case.
>
> >Currently, the time offset is calculated per
> > VCPU, assuming
> > that the host CPU on which this VCPU runs has no impact on the
> > timestamp synchronization.
> > If the local clock depends on the CPU, then we should calculate the
> > time offset of each guest
> > event individually, depending on host CPU and VCPU the event happened
> > - as the host task which runs
> > the VCPU can migrate between CPUs at any time. So, we need to:
> >   1. Add timesync information for each host CPU in the trace.dat file.
> >   2. Track the migration between CPUs of each task that runs VCPU and
> > save that information
> >     in the trace.dat file.
>
> I was thinking about this too. And perhaps we can hold off until we find
> systems that have different values for mult and shift.
>
> That said, we can easily add this information by recording the sched_switch
> events in a separate buffer. And I've been thinking about doing this by
> default anyway. More below.
>
> >   2. When calculating the new timestamp of each guest event
> > (individually) - somehow find out on
> >      which host CPU that guest event happened ?
> >
> > Points 1 and 2 are doable, but will break the current trace.dat file
> > option that holds the timesync information.
>
> I don't think we need to have it in the timesync option. I think we can
> create another option to hold guest event data.
>
> > Point 3 is not clear to me, how we can get such information before the
> > host and guest events are synchronised ?
> >
>
>
> My thoughts about this is. When we enable tracing of a guest (-A), we then
> create an instance on the host that records only kvm enter / exit events as
> well as sched switch events. Basically, enable all the events that we need
> to synchronize and show entering and exiting of the guest.
>
> The synchronization logic already shows us what host thread controls each
> guest VCPU. If we record the kvm enter/exit and sched_switch events in a
> separate buffer, we can see when a host thread that runs a guest VCPU
> migrates to another CPU. Since the timestamps of those events are recorded
> in the meta events themselves (sched_switch), we know exactly where we need
> to use the new mult and shift values for the guest events.
>
> Make sense?
Yes, but I have two concerns:
 1. Recording kvm enter / exit events will make this implementation
KVM specific,
     how about other hypervisors ?
 2. The problem with finding guest event -> host CPU relation. We now only the
      timestamp of the guest event, not yet synchronized with the host
time. How will
      find on what host CPU that guest event happened, as the host
task CPU migration
      mapping is recorded with host time ?
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
