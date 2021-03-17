Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7497C433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 21:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 802D464F30
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 21:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbhCQVt6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 17:49:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhCQVtu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 17:49:50 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1140A64F20;
        Wed, 17 Mar 2021 21:49:49 +0000 (UTC)
Date:   Wed, 17 Mar 2021 17:49:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 02/12] trace-cmd: Add logic for TSC to nanosecond
 conversion
Message-ID: <20210317174948.42d1ae3f@gandalf.local.home>
In-Reply-To: <CAPpZLN7cx_RswVorUCt+9xOG2C2JbS=SDrrgwMbuZBkrdK+ACQ@mail.gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
        <20210315061832.168495-3-tz.stoyanov@gmail.com>
        <20210316171749.105af2e7@gandalf.local.home>
        <CAPpZLN7cx_RswVorUCt+9xOG2C2JbS=SDrrgwMbuZBkrdK+ACQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 17 Mar 2021 11:57:31 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > I would break this up into two patches. One that adds the perf mult shift
> > logic, and even allow users to use it! As TSC clocks are still faster than
> > the local clock (as the local clock needs to do the multiplier and shift at
> > every event while recording). It would be a feature to have this:
> >
> >  trace-cmd record --tsc2nsec ...  
> 
> As the tracing clock is per instance, does it mean this flag should
> also be per instance ? I think the below commands should be valid:
>    trace-cmd record --tsc2nsec -B foo -C mono  <-- use tsc-x86 clock +
> tsc2nsec for the top instance and mono clock for instance foo
>    trace-cmd record -C mono -B foo --tsc2nsec  <-- use mono clock for
> the top instance and tsc-x86 clock + tsc2nsec clock for instance foo
> or even more confusing:
>    trace-cmd record -C x86-tsc -B foo --tsc2nsec  <-- use tsc-x86
> clock for the top instance and tsc-x86 clock + tsc2nsec clock for
> instance foo

I just remembered that I previously discussed making the "tsc2nsec" into a
clock type from the perspective of the user (not the trace file). That is,
not to have --tsc2nsec, but instead to have:

 trace-cmd record -C tsc2nsec

And see if there's a tsc clock and the perf interface is available with the
multiplier and shift, and if not, it would return an error just like if you
said "-C foo". I also remember saying that we should have trace-cmd list
show it as well if it is available.

 # trace-cmd list -C
[local] global counter uptime perf mono mono_raw boot x86-tsc tsc2nsec

That is, tack on at the end " tsc2nsec" if we find that it is available.

> This will require changes in the trace.dat file format. The problem is
> that tsc2nsec multiplier, shift and offset are stored as an option in
> the trace.dat file. Options are global, not per instance. When reading
> the file, how to determine events in which instance should be affected
> by this option ? We should either add options per instance, or somehow
> encode the instance scope of each option.

Your right. And I just tried this:

 # trace-cmd record -C x86-tsc -e sched -B foo -C local -e sched sleep 1

And it appears to ignore the -C local. Which I think is the right thing to
do ;-)

Yeah, we should only support one clock for all instances. And keep this as
a global option. We may in the future have instance options, but that will
come as a separate "option" :-)


> > > +static void set_vsync_clock(void)
> > > +{
> > > +     const char *clock = top_instance.clock;
> > > +     struct buffer_instance *instance;
> > > +     bool tsc2nsec = false;
> > > +     int shift, mult, offset;
> > > +
> > > +     /*
> > > +      * If no clock is specified for the top trace instance AND
> > > +      * KVM time sync protocol is available AND
> > > +      * TSC to nsec multiplier and shift are available:
> > > +      * force using the x86-tsc clock for this host-guest tracing session
> > > +      * and store TSC to nsec multiplier and shift.
> > > +      */
> > > +     if (!clock && tsync_proto_is_supported("kvm") &&
> > > +         !get_tsc_nsec(&shift, &mult, &offset) && mult) {
> > > +             top_instance.clock = strdup(TSC_CLOCK);
> > > +             if (!top_instance.clock)
> > > +                     die("Could not allocate top instance clock");
> > > +             clock = top_instance.clock;  
> >
> > Why is this using the top_instance? What if the user had done:
> >
> >  # trace-cmd record -B host -e kvm -e sched -A guest -e sched  
> 
> You are right, that command is valid. The problem is that guest
> timestamps can be synchronized with one clock only. If there are two
> instances on the host, each with a different clock, the
> synchronization will not work. That's why I look at the top instance
> clock only, which is wrong. I'll change that logic to take the first
> configured host trace clock, i.e. in case of multiple host instances
> with multiple trace clocks, the first wins.
> 


The code should just use the first instance available. Not about being
global, but because I want trace-cmd to not interfere with the top instance
if it is not specified on the command line. That way we can have this:

 # trace-cmd record -e all

in one window, and in another window:

 # trace-cmd record -B guest -e kvm -A guest -e all

and that recorder not do anything to bother the first one. That is, we
should only touch the top instance if it is explicitly specified.


-- Steve
