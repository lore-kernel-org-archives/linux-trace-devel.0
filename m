Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05148C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 08:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5C0B61159
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 08:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhDSIKr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 04:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237477AbhDSIIu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 04:08:50 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87052C06174A
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Apr 2021 01:08:21 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id u11so13788822pjr.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Apr 2021 01:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Qac1JTu20U0H8SBfgZX0RezxZ/4s7UEzFKPwrqLjcM=;
        b=HSY2x51niI5qNG/aXVgfuDYmJ1TRVzKGXXCjh5GLwlIqJlrxv8WBwj4wQI2DvH4HCF
         kaTfqQ4Rtjfvd1D7fPwY67SPyejNvTXhv3dtCd4JQRQh//aY1LjRMWjzEgnB+RgiHIbp
         41HSHHCIDkGUYLO/ciXENTTU5bxkRHg2qEx78LVEUi5btOVwfCBJ9KAjvGloVG40DRpb
         DE6LnBO6NSPN+Tx3Ud34tPUyDGBn8z3LbY6EOZ/3N1kuBBvErKMDcghwCoXvEuxwua+d
         +FyUVRWlAY+9/H/qE3ESFflLPFueuu6Yu3zfHW50zc8wxyCw4B8JiVHa6bXTlmhHrxVF
         b9Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Qac1JTu20U0H8SBfgZX0RezxZ/4s7UEzFKPwrqLjcM=;
        b=g2dY0aFGVqHdogyeQxCBPXSsg+bJ2yP5lK3eOVl0Z6UL+tcnHcDZOC+JNjLGR7SfuY
         4HiW04mx5ZdEJFsJRO0E+ax94iJHlyBT4nVinU6cnG9QSrymGcDAeS/EwJpkkKEp0f97
         DOu4Z1vcVk+1g9JzCCqtp+tnP9lqvjF4KSePVQEG/NeOb8JkvgfBayej+genvwvYcgAj
         ryiTwKgwNh+CECCBQXJ4j1QiG+DdRGyS3stHKBQCpizw2M4QAmO7jF2GpUkdSFF1MDxm
         r+moI57wAuoatJC8uTuHhNoheeKYSODHOhPkcvnN34DPHC4bs1Un6gzqviwJS6TIpTJ/
         PtcQ==
X-Gm-Message-State: AOAM531F+7flbzBV2RRrBpx4WUUDCMvUzcZOOaWXIDU73ZOS2J22Fbx4
        RtxtpQ5o6v3WDdcMaR1nZH3xWCp/zPXWDhcSLtXRzgxXg9Q=
X-Google-Smtp-Source: ABdhPJy8eaZR4Og4T27wjs31iehqsnalEpMYUIGQDKbM/vKthxn/hK77E8YN46mZyYlz9rwDZeO307C2C+F7kOGp6AY=
X-Received: by 2002:a17:90b:3b43:: with SMTP id ot3mr23042920pjb.100.1618819701000;
 Mon, 19 Apr 2021 01:08:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210416103409.24597-1-tz.stoyanov@gmail.com> <20210416103409.24597-3-tz.stoyanov@gmail.com>
 <20210416161221.031d1f5d@gandalf.local.home>
In-Reply-To: <20210416161221.031d1f5d@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 19 Apr 2021 11:08:04 +0300
Message-ID: <CAPpZLN4K6H8p1zNuqHQd0LGDHatAgR+8SHRH1jTP8=Jb_bMZUw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] trace-cmd library: Add check before applying
 tsc2nsec offset
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 16, 2021 at 11:12 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 16 Apr 2021 13:34:08 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > When converting TSC timestamps to nanoseconds, an offset is used. That
> > offset is subtracted from each TSC timestamp, before the conversion.
> > However, if the timestamp is lower that the offset this causes an
> > overflow, as both timestamp and offset are unsigned long integers. A
> > check is added to verify the subtraction will not cause an overflow. In
> > case of an overflow, the timestamp is set to 0 and a warning message is
> > printed.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  lib/trace-cmd/trace-input.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> > index 974879e8..991abd5f 100644
> > --- a/lib/trace-cmd/trace-input.c
> > +++ b/lib/trace-cmd/trace-input.c
> > @@ -1230,8 +1230,14 @@ static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
> >               ts *= handle->ts2secs;
> >       } else if (handle->tsc_calc.mult) {
> >               /* auto calculated TSC clock frequency */
> > -             ts -= handle->tsc_calc.offset;
> > -             ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
> > +             if (ts > handle->tsc_calc.offset) {
> > +                     ts -= handle->tsc_calc.offset;
> > +                     ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
> > +             } else {
> > +                     tracecmd_warning("Timestamp $llu is before the initial offset %llu, set it to 0",
>
>    $llu  ??
>
> Are you testing these? The bad trace files that I supplied triggers this.
>
>
> > +                                      ts, handle->tsc_calc.offset);
> > +                     ts = 0;
>
> We should turn off the offset and not just zero out the timestamps,
> otherwise we just have useless data:
>
>   Timestamp $llu is before the initial offset 20094822433105, set it to 0
>   Timestamp $llu is before the initial offset 20094822433105, set it to 0
>   Timestamp $llu is before the initial offset 20094822460994, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094822961507, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094822967292, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094823302351, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094823306954, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094824963751, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094824965723, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094824972124, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094824972697, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094828868305, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094828871264, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094828881104, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094828882014, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094831874377, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094831876734, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094831881252, set it to 0
> [..]
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094832060068, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094835262757, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094835265223, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094835270122, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094835273058, set it to 0
> libtracecmd: File exists
>   Timestamp $llu is before the initial offset 20094835273614, set it to 0
> cpus=2
>        trace-cmd-3196  [000]     0.000000: sched_stat_runtime:   comm=trace-cmd pid=3196 runtime=85576 [ns] vruntime=12853032342 [ns]
>        trace-cmd-3196  [000]     0.000000: sched_switch:         trace-cmd:3196 [120] S ==> trace-cmd:3199 [120]
>        trace-cmd-3199  [000]     0.000000: sched_stat_runtime:   comm=trace-cmd pid=3199 runtime=156103 [ns] vruntime=12857102867 [ns]
>        trace-cmd-3199  [000]     0.000000: sched_switch:         trace-cmd:3199 [120] S ==> trace-cmd:3198 [120]
>        trace-cmd-3198  [000]     0.000000: sched_stat_runtime:   comm=trace-cmd pid=3198 runtime=100540 [ns] vruntime=12858890364 [ns]
>        trace-cmd-3198  [000]     0.000000: sched_switch:         trace-cmd:3198 [120] S ==> swapper/0:0 [120]
>           <idle>-0     [000]     0.000000: hrtimer_cancel:       hrtimer=0xffff8cc5bd41f780
>           <idle>-0     [000]     0.000000: hrtimer_expire_entry: hrtimer=0xffff8cc5bd41f780 now=1444054745103 function=tick_sched_timer/0x0
>           <idle>-0     [000]     0.000000: hrtimer_expire_exit:  hrtimer=0xffff8cc5bd41f780
>           <idle>-0     [000]     0.000000: hrtimer_start:        hrtimer=0xffff8cc5bd41f780 function=tick_sched_timer/0x0 expires=1444055726117 softexpires=1444055726117
>           <idle>-0     [000]     0.000000: hrtimer_cancel:       hrtimer=0xffff8cc5bd41f780
>           <idle>-0     [000]     0.000000: hrtimer_expire_entry: hrtimer=0xffff8cc5bd41f780 now=1444055895819 function=tick_sched_timer/0x0
>           <idle>-0     [000]     0.000000: hrtimer_expire_exit:  hrtimer=0xffff8cc5bd41f780
>           <idle>-0     [000]     0.000000: hrtimer_start:        hrtimer=0xffff8cc5bd41f780 function=tick_sched_timer/0x0 expires=1444056726117 softexpires=1444056726117
>           <idle>-0     [000]     0.000000: hrtimer_cancel:       hrtimer=0xffff8cc5bd41f780
>           <idle>-0     [000]     0.000000: hrtimer_expire_entry: hrtimer=0xffff8cc5bd41f780 now=1444056782207 function=tick_sched_timer/0x0
>           <idle>-0     [000]     0.000000: softirq_raise:        vec=1 [action=TIMER]
>           <idle>-0     [000]     0.000000: hrtimer_expire_exit:  hrtimer=0xffff8cc5bd41f780
>           <idle>-0     [000]     0.000000: hrtimer_start:        hrtimer=0xffff8cc5bd41f780 function=tick_sched_timer/0x0 expires=1444057726117 softexpires=1444057726117
>           <idle>-0     [000]     0.000000: softirq_entry:        vec=1 [action=TIMER]
>           <idle>-0     [000]     0.000000: timer_cancel:         timer=0xffffa61a0006be40
>           <idle>-0     [000]     0.000000: timer_expire_entry:   timer=0xffffa61a0006be40 function=process_timeout now=4296111312 baseclk=4296111312
>           <idle>-0     [000]     0.000000: sched_waking:         comm=rcu_sched pid=12 prio=120 target_cpu=000
>
> We don't want all timestamps zero. We want to disable the starting event.
>
> By having this instead:
>
>                 } else {
>                         tracecmd_warning("Timestamp %llu is before the initial offset %llu\n"
>                                          "\tSetting offset to 0",
>                                          ts, handle->tsc_calc.offset);
>                         handle->tsc_calc.offset = 0;
>                         ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
>                 }
>

This will set the guest offset to 0, will not change the offsets of
the other files. The result is that the files will not be displayed in
sync, because of these few broken events. As this is only a sanity
check, and should not happen if the patch "trace-cmd: Get the
timestamp of the first recorded event as TSC offset" is applied, I
would suggest to zero the broken timestamps and to advise the user to
use "--raw-ts" option instead:
 "Timestamp %llu is before the initial offset %llu, set it to 0.
Display the files with --raw-ts option to see the original
timestamps.\n"


> We get this as output:
>
>   Timestamp 20094822433105 is before the initial offset 20159736262966
>         Setting offset to 0
> cpus=2
>        trace-cmd-3196  [000]  5923.651995: sched_stat_runtime:   comm=trace-cmd pid=3196 runtime=85576 [ns] vruntime=12853032342 [ns]
>        trace-cmd-3196  [000]  5923.652004: sched_switch:         trace-cmd:3196 [120] S ==> trace-cmd:3199 [120]
>        trace-cmd-3199  [000]  5923.652151: sched_stat_runtime:   comm=trace-cmd pid=3199 runtime=156103 [ns] vruntime=12857102867 [ns]
>        trace-cmd-3199  [000]  5923.652153: sched_switch:         trace-cmd:3199 [120] S ==> trace-cmd:3198 [120]
>        trace-cmd-3198  [000]  5923.652252: sched_stat_runtime:   comm=trace-cmd pid=3198 runtime=100540 [ns] vruntime=12858890364 [ns]
>        trace-cmd-3198  [000]  5923.652253: sched_switch:         trace-cmd:3198 [120] S ==> swapper/0:0 [120]
>           <idle>-0     [000]  5923.652741: hrtimer_cancel:       hrtimer=0xffff8cc5bd41f780
>           <idle>-0     [000]  5923.652742: hrtimer_expire_entry: hrtimer=0xffff8cc5bd41f780 now=1444054745103 function=tick_sched_timer/0x0
>           <idle>-0     [000]  5923.652744: hrtimer_expire_exit:  hrtimer=0xffff8cc5bd41f780
>           <idle>-0     [000]  5923.652744: hrtimer_start:        hrtimer=0xffff8cc5bd41f780 function=tick_sched_timer/0x0 expires=1444055726117 softexpires=1444055726117
>           <idle>-0     [000]  5923.653892: hrtimer_cancel:       hrtimer=0xffff8cc5bd41f780
>
> Much more usable.
>
> -- Steve
>
>
> > +             }
> >       }
> >
> >       /* User specified time offset with --ts-offset or --date options */
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
