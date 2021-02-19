Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E7BC433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 14:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE5CB64EB3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 14:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbhBSOhU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Feb 2021 09:37:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231268AbhBSOhG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Feb 2021 09:37:06 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE88E64D9A;
        Fri, 19 Feb 2021 14:36:24 +0000 (UTC)
Date:   Fri, 19 Feb 2021 09:36:23 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 5/5] [WIP] trace-cmd: Add new subcomand "trace-cmd perf"
Message-ID: <20210219093623.6965e487@gandalf.local.home>
In-Reply-To: <CAPpZLN6nPbJoDBHe0Fm8+BECfXHdpNjQFt9gK9mHGAQriiGjEw@mail.gmail.com>
References: <20201203060226.476475-1-tz.stoyanov@gmail.com>
        <20201203060226.476475-6-tz.stoyanov@gmail.com>
        <20210218210352.61470b93@oasis.local.home>
        <CAPpZLN6nPbJoDBHe0Fm8+BECfXHdpNjQFt9gK9mHGAQriiGjEw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Feb 2021 09:16:26 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> Hi Steven,
> 
> On Fri, Feb 19, 2021 at 4:03 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Thu,  3 Dec 2020 08:02:26 +0200
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> >  
> > > +static int perf_mmap(struct perf_cpu *perf)
> > > +{
> > > +     mmap_mask = NUM_PAGES * getpagesize() - 1;
> > > +
> > > +     /* associate a buffer with the file */
> > > +     perf->mpage = mmap(NULL, (NUM_PAGES + 1) * getpagesize(),
> > > +                     PROT_READ | PROT_WRITE, MAP_SHARED, perf->perf_fd, 0);
> > > +     if (perf->mpage == MAP_FAILED)
> > > +             return -1;
> > > +     return 0;
> > > +}  
> >
> > BTW, I found that the above holds the conversions we need for the local
> > clock!
> >
> >         printf("time_shift=%d\n", perf->mpage->time_shift);
> >         printf("time_mult=%d\n", perf->mpage->time_mult);
> >         printf("time_offset=%lld\n", perf->mpage->time_offset);
> >
> > Which gives me:
> >
> > time_shift=31
> > time_mult=633046315
> > time_offset=-115773323084683
> >
> > [ one for each CPU ]  
> 
> This will give us time shift/mult/offset for each host CPU, right ? Is
> the local trace clock
> different for each CPU ? 

It can be. Note, the above offset is basically useless. That injects the
current time into the value and we can't rely on it. But the shift and mult
is needed.

But, usually, the shift and offset are identical on most systems across
CPUs, but there's no guarantee that it will always be the case.

>Currently, the time offset is calculated per
> VCPU, assuming
> that the host CPU on which this VCPU runs has no impact on the
> timestamp synchronization.
> If the local clock depends on the CPU, then we should calculate the
> time offset of each guest
> event individually, depending on host CPU and VCPU the event happened
> - as the host task which runs
> the VCPU can migrate between CPUs at any time. So, we need to:
>   1. Add timesync information for each host CPU in the trace.dat file.
>   2. Track the migration between CPUs of each task that runs VCPU and
> save that information
>     in the trace.dat file.

I was thinking about this too. And perhaps we can hold off until we find
systems that have different values for mult and shift.

That said, we can easily add this information by recording the sched_switch
events in a separate buffer. And I've been thinking about doing this by
default anyway. More below.

>   2. When calculating the new timestamp of each guest event
> (individually) - somehow find out on
>      which host CPU that guest event happened ?
> 
> Points 1 and 2 are doable, but will break the current trace.dat file
> option that holds the timesync information.

I don't think we need to have it in the timesync option. I think we can
create another option to hold guest event data.

> Point 3 is not clear to me, how we can get such information before the
> host and guest events are synchronised ?
> 


My thoughts about this is. When we enable tracing of a guest (-A), we then
create an instance on the host that records only kvm enter / exit events as
well as sched switch events. Basically, enable all the events that we need
to synchronize and show entering and exiting of the guest.

The synchronization logic already shows us what host thread controls each
guest VCPU. If we record the kvm enter/exit and sched_switch events in a
separate buffer, we can see when a host thread that runs a guest VCPU
migrates to another CPU. Since the timestamps of those events are recorded
in the meta events themselves (sched_switch), we know exactly where we need
to use the new mult and shift values for the guest events.

Make sense?

-- Steve
