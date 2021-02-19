Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EDB3C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 07:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2457E64EC4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 07:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhBSHR0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Feb 2021 02:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhBSHRY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Feb 2021 02:17:24 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F001DC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Feb 2021 23:16:43 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id z21so3161334pgj.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Feb 2021 23:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TKnNExHQ9ZbNIpBmMKHQ8LlbR2WY2yfM3oWPhHuThsk=;
        b=f9HsmOJwCiEA8VhuDW9HWgijPUm+/Gx+5afyBxyuIa2oX1siWAFciPvgE8ohKje/9U
         wwvg5UFgG2uYYtKia5UOL/xh0gX0RkMYCZPd9Pdi3yV5YxC1etrU4ZuDx35LiHNApNLf
         f9wS0fXwxP+iDtAshlAvMy2B426luafrM+m/FhRcJqpIbt4wvobwqdX9KZ7SEWTrYsei
         3+B48dxGoBVUoGpX9WcVB4eR/pgE8ymVLfdvf243Yg8Gv2xYyJj2wflC7eWrzHGaizq+
         EGHAy1lrL6NCcRpW7aWgstVuntiazsYmg76AZ0eYHIMx5s52Sb67AmepUOMFDxnV53YA
         gcYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TKnNExHQ9ZbNIpBmMKHQ8LlbR2WY2yfM3oWPhHuThsk=;
        b=jnYU0YE9i0r2w9IJvgGXUDynT1xF8qYga1lLdNlSoEvEmFmnwTC4AGH3mQ0nLyQ04J
         jSmHKWP3f1rPCMjR7FW+thvF1n59pJEvafslz/0RuTHCXgo6nnrIpt9zuIKg28D9SC+N
         rGdSux2d7wzxZmADs1j4N3Syc6DYF81s5mTJ88VE5EcZIkiCsSl7aTBRiCawf99DSzz9
         E7r14on7yMqDekX8JLNFmhi7ny6vSOlIeLdCOtA32GAVxHETmvvP57cHd4Xrp2TrbSwI
         jG9fD5esA2T8aL6YD5HsSQSlHdMNkoGJ/72fXOhU7Q1bjyhrJzi9+BgJYqJkX2k/+z1I
         nwvQ==
X-Gm-Message-State: AOAM531rEDK9rZBLrQYs8ZsJpfNIyKegWX2+oijQx0+LJDuEdv1HVmYd
        Zm9Q9ojTPeHkHA5q2XOfOalaGEoAgmNyv7IlEfLTlVR73KRp1g==
X-Google-Smtp-Source: ABdhPJyDKycLXtSIEnPzB4YJmfippaWEi6++MLDHavSvZPYmz5aMOGnq0EU9bIQoeKwRmhke2vFLZjS7LdSxNCibeuo=
X-Received: by 2002:a05:6a00:148a:b029:1ae:6d20:fbb3 with SMTP id
 v10-20020a056a00148ab02901ae6d20fbb3mr7898803pfu.55.1613719003472; Thu, 18
 Feb 2021 23:16:43 -0800 (PST)
MIME-Version: 1.0
References: <20201203060226.476475-1-tz.stoyanov@gmail.com>
 <20201203060226.476475-6-tz.stoyanov@gmail.com> <20210218210352.61470b93@oasis.local.home>
In-Reply-To: <20210218210352.61470b93@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 19 Feb 2021 09:16:26 +0200
Message-ID: <CAPpZLN6nPbJoDBHe0Fm8+BECfXHdpNjQFt9gK9mHGAQriiGjEw@mail.gmail.com>
Subject: Re: [PATCH 5/5] [WIP] trace-cmd: Add new subcomand "trace-cmd perf"
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On Fri, Feb 19, 2021 at 4:03 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu,  3 Dec 2020 08:02:26 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > +static int perf_mmap(struct perf_cpu *perf)
> > +{
> > +     mmap_mask = NUM_PAGES * getpagesize() - 1;
> > +
> > +     /* associate a buffer with the file */
> > +     perf->mpage = mmap(NULL, (NUM_PAGES + 1) * getpagesize(),
> > +                     PROT_READ | PROT_WRITE, MAP_SHARED, perf->perf_fd, 0);
> > +     if (perf->mpage == MAP_FAILED)
> > +             return -1;
> > +     return 0;
> > +}
>
> BTW, I found that the above holds the conversions we need for the local
> clock!
>
>         printf("time_shift=%d\n", perf->mpage->time_shift);
>         printf("time_mult=%d\n", perf->mpage->time_mult);
>         printf("time_offset=%lld\n", perf->mpage->time_offset);
>
> Which gives me:
>
> time_shift=31
> time_mult=633046315
> time_offset=-115773323084683
>
> [ one for each CPU ]

This will give us time shift/mult/offset for each host CPU, right ? Is
the local trace clock
different for each CPU ? Currently, the time offset is calculated per
VCPU, assuming
that the host CPU on which this VCPU runs has no impact on the
timestamp synchronization.
If the local clock depends on the CPU, then we should calculate the
time offset of each guest
event individually, depending on host CPU and VCPU the event happened
- as the host task which runs
the VCPU can migrate between CPUs at any time. So, we need to:
  1. Add timesync information for each host CPU in the trace.dat file.
  2. Track the migration between CPUs of each task that runs VCPU and
save that information
    in the trace.dat file.
  2. When calculating the new timestamp of each guest event
(individually) - somehow find out on
     which host CPU that guest event happened ?

Points 1 and 2 are doable, but will break the current trace.dat file
option that holds the timesync information.
Point 3 is not clear to me, how we can get such information before the
host and guest events are synchronised ?

>
> The ftrace local clock is defined by:
>
> u64 notrace trace_clock_local(void)
> {
>         u64 clock;
>         preempt_disable_notrace();
>         clock = sched_clock();
>         preempt_enable_notrace();
>         return clock;
> }
>
> Where
>
> u64 sched_clock(void)
> {
>         if (static_branch_likely(&__use_tsc)) { // true
>                 u64 tsc_now = rdtsc();
>
>                 /* return the value in ns */
>                 return cycles_2_ns(tsc_now);
>         }
>
> and
>
> static __always_inline unsigned long long cycles_2_ns(unsigned long long cyc)
> {
>         struct cyc2ns_data data;
>         unsigned long long ns;
>
>         cyc2ns_read_begin(&data); // <- this is where the data comes from
>
>         ns = data.cyc2ns_offset;
>         ns += mul_u64_u32_shr(cyc, data.cyc2ns_mul, data.cyc2ns_shift);
>
>         cyc2ns_read_end();
>
>         return ns;
> }
>
> __always_inline void cyc2ns_read_begin(struct cyc2ns_data *data)
> {
>         int seq, idx;
>
>         preempt_disable_notrace();
>
>         do {
>                 seq = this_cpu_read(cyc2ns.seq.seqcount.sequence);
>                 idx = seq & 1;
>
>                 data->cyc2ns_offset = this_cpu_read(cyc2ns.data[idx].cyc2ns_offset);
>                 data->cyc2ns_mul    = this_cpu_read(cyc2ns.data[idx].cyc2ns_mul);
>                 data->cyc2ns_shift  = this_cpu_read(cyc2ns.data[idx].cyc2ns_shift);
>
>         } while (unlikely(seq != this_cpu_read(cyc2ns.seq.seqcount.sequence)));
> }
>
> The offset, multiplier and shift are from the cyc2ns.data[idx] (per
> cpu) is what determines the conversion from x86 cycles to nanoseconds.
>
> Does user space have access to that? Yes! Via perf!
>
> void arch_perf_update_userpage(struct perf_event *event,
>                                struct perf_event_mmap_page *userpg, u64 now)
> {
> [..]
>         cyc2ns_read_begin(&data);
>
>         offset = data.cyc2ns_offset + __sched_clock_offset;
>
>         /*
>          * Internal timekeeping for enabled/running/stopped times
>          * is always in the local_clock domain.
>          */
>         userpg->cap_user_time = 1;
>         userpg->time_mult = data.cyc2ns_mul;
>         userpg->time_shift = data.cyc2ns_shift;
>         userpg->time_offset = offset - now;
>
> Those above values are the ones I printed at the beginning of this
> email.
>
> Hence, we can use x86-tsc as the clock for both the host and guest, and
> then using perf find out how to convert that to what the 'local' clock
> would produce. At least the multiplier and the shfit.
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
