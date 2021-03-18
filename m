Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3031C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Mar 2021 03:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 668D464F06
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Mar 2021 03:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhCRDnP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 23:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhCRDnE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 23:43:04 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502BFC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Mar 2021 20:43:04 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id n11so551766pgm.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Mar 2021 20:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9R8onw6XU9dOMWO6NJkboopqgYsy0ZkmdRBHamddHLo=;
        b=kyfB73M03LRRzDuwbCcChM4f/idGcrzvXmKwTiHX7gYLI8qNX8L2XQOFlV48LwsEAJ
         aTQT22AKvkZ+ZQVHkiW/meig88xIXiRrZUMFUUM5EBdNL1JaiLjHCKUe41MmAdS5ZOY1
         nCXO+EnUC11BhBWcQ6DJJdL/mYtI5zwZB1SBQ6CbhH7A+4dfvuVuYeKZknf+DXsoH/Mz
         2/PczaUQ1MMFREcy0E8UNJjGDb5ppeCTCVTd9vMHNa/aBDLVjSAOiUswAnUmdz9AKQc+
         sT9yWPTQXirtGPODtlEAHZ4WMXElnFXyv67/p7DpEN7F+yq7DapXwtAFK5tnZOSDGbBH
         6kSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9R8onw6XU9dOMWO6NJkboopqgYsy0ZkmdRBHamddHLo=;
        b=kCM1k4czBY3nnPUeTmfhqLuOgbXNUBjIwU7ffmjK8geAcbDpRuSsALBgfY9tEDOaW4
         gzlgnNAxDHfNYC8dx8fHs7iH10BBgGrZ+eVAsgLCHUtz6bpBTRaRu8PoKq4fncBZ/+zd
         a2CBERVKyjeFlS+U6jF3VcUNn81SUOHphwYGZ/2n4NtNf0BnGBrEtNlFI6//23eV+7KJ
         DlFYXsdqFkz2n73CACFdMqRRFYHXDWCvYtnA6yeRxL6lVjV0KLHd2GTOhIYRh2XWZukI
         5b9HVV3FLRN0iqvawT35Rf+qMr9Zz5i6NCvIa9EaberlZ07i6XQCDgFHs75bVZNTiQL6
         pDtw==
X-Gm-Message-State: AOAM531rkT+ANDPxV9XZIsA0IqbfC2uJJ6yJbqi1otZq1Zm5gEcgGBvz
        i73nKpa0GDbHrXygT0/QecvAKEqdm5XiLwyO/HM37m0SIrQ=
X-Google-Smtp-Source: ABdhPJyjdy7AZ6t5ONy++8g+TopkgH84sNRw3ImdEtkaA36R3NWcGGgr9nEYLCeX1AbhDNL9Vi/msWDkPexUEVRdOis=
X-Received: by 2002:aa7:9394:0:b029:1f4:2b30:4cdb with SMTP id
 t20-20020aa793940000b02901f42b304cdbmr2142684pfe.50.1616038983700; Wed, 17
 Mar 2021 20:43:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
 <20210315061832.168495-3-tz.stoyanov@gmail.com> <20210316171749.105af2e7@gandalf.local.home>
 <CAPpZLN7cx_RswVorUCt+9xOG2C2JbS=SDrrgwMbuZBkrdK+ACQ@mail.gmail.com> <20210317174948.42d1ae3f@gandalf.local.home>
In-Reply-To: <20210317174948.42d1ae3f@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 18 Mar 2021 05:42:47 +0200
Message-ID: <CAPpZLN5aKmS8Jss=UzgwtcWHNTpw30hP1Bg75U1VMUfGYjwiEA@mail.gmail.com>
Subject: Re: [PATCH 02/12] trace-cmd: Add logic for TSC to nanosecond conversion
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 17, 2021 at 11:49 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 17 Mar 2021 11:57:31 +0200
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > > I would break this up into two patches. One that adds the perf mult shift
> > > logic, and even allow users to use it! As TSC clocks are still faster than
> > > the local clock (as the local clock needs to do the multiplier and shift at
> > > every event while recording). It would be a feature to have this:
> > >
> > >  trace-cmd record --tsc2nsec ...
> >
> > As the tracing clock is per instance, does it mean this flag should
> > also be per instance ? I think the below commands should be valid:
> >    trace-cmd record --tsc2nsec -B foo -C mono  <-- use tsc-x86 clock +
> > tsc2nsec for the top instance and mono clock for instance foo
> >    trace-cmd record -C mono -B foo --tsc2nsec  <-- use mono clock for
> > the top instance and tsc-x86 clock + tsc2nsec clock for instance foo
> > or even more confusing:
> >    trace-cmd record -C x86-tsc -B foo --tsc2nsec  <-- use tsc-x86
> > clock for the top instance and tsc-x86 clock + tsc2nsec clock for
> > instance foo
>
> I just remembered that I previously discussed making the "tsc2nsec" into a
> clock type from the perspective of the user (not the trace file). That is,
> not to have --tsc2nsec, but instead to have:
>
>  trace-cmd record -C tsc2nsec
>
> And see if there's a tsc clock and the perf interface is available with the
> multiplier and shift, and if not, it would return an error just like if you
> said "-C foo". I also remember saying that we should have trace-cmd list
> show it as well if it is available.
>
>  # trace-cmd list -C
> [local] global counter uptime perf mono mono_raw boot x86-tsc tsc2nsec
>
> That is, tack on at the end " tsc2nsec" if we find that it is available.
>
> > This will require changes in the trace.dat file format. The problem is
> > that tsc2nsec multiplier, shift and offset are stored as an option in
> > the trace.dat file. Options are global, not per instance. When reading
> > the file, how to determine events in which instance should be affected
> > by this option ? We should either add options per instance, or somehow
> > encode the instance scope of each option.
>
> Your right. And I just tried this:
>
>  # trace-cmd record -C x86-tsc -e sched -B foo -C local -e sched sleep 1
>
> And it appears to ignore the -C local. Which I think is the right thing to
> do ;-)

According to the code, trace-cmd supports clock per instance. And it
works, I tried this:

#trace-cmd record -C x86-tsc -e irq -B foo -C local -e sched sleep 1

and got different clocks:
             <...>-290676 [006]1956659520918: softirq_exit:        ....
foo:       zoom-10894 [004]112198623756671: sched_switch:  ....

although I cannot imagine a use case for this. It will be weird to
visualise this by KerneShark.

I think that we should introduce options per instance now,  as "-C
tsc2nsec" cannot be implemented without it.
I see two possible ways to implement it:
 1. Break the current trace.dat file format by adding metadata for
each instance.
 2. Keep the current format and use nested options -  that's it, just
another option "OPTION_INSTANCE". It will hold instance name and all
options, specific for that instance, using the current options format.

But there is one question, valid for both ways: What should be the
scope for the global options ? Apply them only on the top instance, or
they should be common for all instances ?

>
> Yeah, we should only support one clock for all instances. And keep this as
> a global option. We may in the future have instance options, but that will
> come as a separate "option" :-)
>
>
> > > > +static void set_vsync_clock(void)
> > > > +{
> > > > +     const char *clock = top_instance.clock;
> > > > +     struct buffer_instance *instance;
> > > > +     bool tsc2nsec = false;
> > > > +     int shift, mult, offset;
> > > > +
> > > > +     /*
> > > > +      * If no clock is specified for the top trace instance AND
> > > > +      * KVM time sync protocol is available AND
> > > > +      * TSC to nsec multiplier and shift are available:
> > > > +      * force using the x86-tsc clock for this host-guest tracing session
> > > > +      * and store TSC to nsec multiplier and shift.
> > > > +      */
> > > > +     if (!clock && tsync_proto_is_supported("kvm") &&
> > > > +         !get_tsc_nsec(&shift, &mult, &offset) && mult) {
> > > > +             top_instance.clock = strdup(TSC_CLOCK);
> > > > +             if (!top_instance.clock)
> > > > +                     die("Could not allocate top instance clock");
> > > > +             clock = top_instance.clock;
> > >
> > > Why is this using the top_instance? What if the user had done:
> > >
> > >  # trace-cmd record -B host -e kvm -e sched -A guest -e sched
> >
> > You are right, that command is valid. The problem is that guest
> > timestamps can be synchronized with one clock only. If there are two
> > instances on the host, each with a different clock, the
> > synchronization will not work. That's why I look at the top instance
> > clock only, which is wrong. I'll change that logic to take the first
> > configured host trace clock, i.e. in case of multiple host instances
> > with multiple trace clocks, the first wins.
> >
>
>
> The code should just use the first instance available. Not about being
> global, but because I want trace-cmd to not interfere with the top instance
> if it is not specified on the command line. That way we can have this:
>
>  # trace-cmd record -e all
>
> in one window, and in another window:
>
>  # trace-cmd record -B guest -e kvm -A guest -e all
>
> and that recorder not do anything to bother the first one. That is, we
> should only touch the top instance if it is explicitly specified.
>
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
