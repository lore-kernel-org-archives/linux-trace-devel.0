Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F88C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 13:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49BA264EB8
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 13:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhBINBp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 08:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhBINBd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 08:01:33 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E66C061786
        for <linux-trace-devel@vger.kernel.org>; Tue,  9 Feb 2021 05:00:52 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id o21so11003379pgn.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Feb 2021 05:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MwUNlT7ZXP9ESJhP++Nu6Yq2qjB51RecSgsu85EZFjs=;
        b=RCFlQ+MVUmhvMTPcNgV/Rjq73FqYBiWsQGB5WAS/xXJLQwbXFW78PIW5JTDMhCNl9h
         tN64P4UhL4YJx12qMrbrBBDcQwrQJO+wBypazRdEe/Fpw8OOvSF/GL79NULyl+qJKT7U
         AWzuu2xFgWZRuQNYPnqKaxrqJ0pBJuALe/DxChIZ7o/6l5A+L/Xx+ALFSJKO23IU/7Is
         7alyVgeyifXkdWLxV9PCLtK2uxYigYI7A13CzVEUossjBy+NHMyBKtHOIQHxKoM18np/
         LyaAAqWeg+z94iOkZrnNr+eX2V/yPI4AYr6Df+Pl6lXDqnuRNdqNEVC/tIYQJ832EyII
         9mZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MwUNlT7ZXP9ESJhP++Nu6Yq2qjB51RecSgsu85EZFjs=;
        b=cGfOsZCQuETDNYjhPJxXqOrHhWfZcYy2oGdxybLCTYMzjxUyVhvO9PhyRTxxHzSF/N
         FS916p/jImExyZzbUIog+kO7VGVMCuKomNGz7cJw3upi2rCXUvJ7BgYcqLCOV2mX6Ndu
         qyZmQJWEzKgFa/0cwNebuhtIhxNLs72dCNLNUKk5wfq1GTY9fJm9aLMIGn+Zne/nqaAI
         EbsdOCbl56sVm2sR0hQ7byovb6iTdvxxpaP3xZS7B2CUbdhLPil/Ba/Fytco/zClj4Jb
         lX+0oDo2PrAd01pcTYIP0uypSEYQtX4MxkaOqULx2rdxbYb21aUkhO1JJCMo6EDEUzpr
         EQ4g==
X-Gm-Message-State: AOAM5305NrfyPYklVHFh9zi2qY7rMyk7NEjju8yamv15aiJNbQd+YwEa
        E9Cwq0tFPupf39LOgSJXeS360l78sR40Vq4McUM=
X-Google-Smtp-Source: ABdhPJx54URaJbQygnZY0gMaLTqSmLfl8f0vjHfqClEi6IIEqaT/Tv7XteTfPRboUch/qPW+wHEicJVJ2ljiVr+xlBg=
X-Received: by 2002:a63:221b:: with SMTP id i27mr21717673pgi.44.1612875652265;
 Tue, 09 Feb 2021 05:00:52 -0800 (PST)
MIME-Version: 1.0
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
 <bb09f02e5d1e14cf835c85c97ae7902976bdb408.camel@suse.com> <CAPpZLN5SQu=XwQ+XodbVWrXUb-qtcLjH-U79R6NBDJ4jwQSvsw@mail.gmail.com>
 <CAPpZLN7boZK+9921zJ+OvZ-yhT6DdAkWkj9+fgswV_g4PxsROg@mail.gmail.com>
 <f6a169322dde8038832371fa1d5856f74e2ab308.camel@suse.com> <CAPpZLN6wUD4wFLLODFL3529vz_khKgvK-PkHspOzA5zEwPeHjQ@mail.gmail.com>
 <acf6979c262a741b7ecb330bb3a1f2e1546385ef.camel@suse.com>
In-Reply-To: <acf6979c262a741b7ecb330bb3a1f2e1546385ef.camel@suse.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 9 Feb 2021 15:00:35 +0200
Message-ID: <CAPpZLN6oQnzgemo2hxqurzOvAdmjvgQkjjx4o1V8Uo3eM_8Ahg@mail.gmail.com>
Subject: Re: [PATCH v28 0/8] Timestamp synchronization of host - guest tracing session
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Feb 9, 2021 at 2:24 PM Dario Faggioli <dfaggioli@suse.com> wrote:
>
> On Tue, 2021-02-09 at 13:44 +0200, Tzvetomir Stoyanov wrote:
> > Hi Dario,
> >
> Hi again,
>
> > On Tue, Feb 9, 2021 at 9:28 AM Dario Faggioli <dfaggioli@suse.com>
> > wrote:
> > >
> > > Or at least, host and guest talk, and I see this: "Negotiated kvm
> > > time
> > > sync protocol with guest (null)" (is that "(null)" ok/intentional?
> > > I
> > > guess I can check the code... :-))
> >
> > That null looks like an error, the name of the guest VM should be
> > printed there.
> >
> Yep, in fact, as I said, I tired this before and --now that I think
> about it-- I do remember that the guest "name" was what was there.
>
> BTW, if I can pester you a little bit more, now that it works I'm
> trying to use this, and here's what I'm doing.
>
> == VM:
> # echo tsc > /sys/devices/system/clocksource/clocksource0/current_clocksource
> # echo x86-tsc > /sys/kernel/tracing/trace_clock
> # trace-cmd agent
>
> == Host:
> # echo x86-tsc > /sys/kernel/tracing/trace_clock
> # trace-cmd record -p nop -e sched:* -e kvm:* -e timer:hrtimer* -A tumbleweed-jeos:823 -e sched:* -e syscalls:*_clock_nanosleep -e timer:hrtimer* sleep 1
>
> And I do end up with the two files: trace.dat for the host and trace-
> (null).dat (oh, well :-D) for the guest.
>
> Now, just `trace-cmd report`-ing them, I get this (just some small
> fragments, of course).
>
> == Host (trace.dat):
>            <...>-24791 [001]308219686938467: sched_switch:         prev_comm=sleep prev_pid=24791 prev_prio=120 prev_state=S ==> next_comm=swapper/1 next_pid=0 next_prio=120
>           <idle>-0     [001]308219691836595: hrtimer_cancel:       hrtimer=0xffff96694faec710
>           <idle>-0     [001]308219691837544: hrtimer_expire_entry: hrtimer=0xffff96694faec710 function=apic_timer_fn now=76856318840891
>           <idle>-0     [001]308219691840271: sched_waking:         comm=CPU 0/KVM pid=9196 prio=120 target_cpu=001
>           <idle>-0     [001]308219691849474: sched_wakeup:         comm=CPU 0/KVM pid=9196 prio=120 target_cpu=001
>           <idle>-0     [001]308219691850914: hrtimer_expire_exit:  hrtimer=0xffff96694faec710
>           <idle>-0     [001]308219691856548: sched_switch:         prev_comm=swapper/1 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=CPU 0/KVM next_pid=9196 next_prio=120
>        CPU 0/KVM-9196  [001]308219691876512: kvm_vcpu_wakeup:      wait time 2352265 ns, polling valid
>        CPU 0/KVM-9196  [001]308219691880170: kvm_apic_accept_irq:  apicid 0 vec 236 (Fixed|edge)
>        CPU 0/KVM-9196  [001]308219691884210: kvm_pv_tlb_flush:     vcpu 0 need_flush_tlb false
>
>
>  == Guest (trace-(null).dat):
>            <...>-12068 [000]118613084443085: sched_stat_runtime:   comm=trace-cmd pid=12068 runtime=97403 [ns] vruntime=5101562006274 [ns]
>            <...>-12068 [000]118613084451479: sched_switch:         prev_comm=trace-cmd prev_pid=12068 prev_prio=120 prev_state=S ==> next_comm=trace-cmd next_pid=12070 next_prio=120
>            <...>-12070 [000]118613084662730: sched_stat_runtime:   comm=trace-cmd pid=12070 runtime=55912 [ns] vruntime=5101564964781 [ns]
>            <...>-12070 [000]118613084665219: sched_switch:         prev_comm=trace-cmd prev_pid=12070 prev_prio=120 prev_state=S ==> next_comm=swapper/0 next_pid=0 next_prio=120
>           <idle>-0     [000]118613085002791: sched_waking:         comm=kworker/0:0 pid=10458 prio=120 target_cpu=000
>           <idle>-0     [000]118613085006567: sched_wakeup:         comm=kworker/0:0 pid=10458 prio=120 target_cpu=000
>           <idle>-0     [000]118613085011740: sched_switch:         prev_comm=swapper/0 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=kworker/0:0 next_pid=10458 next_prio=120
>      kworker/0:0-10458 [000]118613085023034: sched_waking:         comm=trace-cmd pid=12070 prio=120 target_cpu=000
>      kworker/0:0-10458 [000]118613085023774: sched_stat_runtime:   comm=kworker/0:0 pid=10458 runtime=4848 [ns] vruntime=5101561969629 [ns]
>      kworker/0:0-10458 [000]118613085025356: sched_wakeup:         comm=trace-cmd pid=12070 prio=120 target_cpu=000
>
> So, the timestamps seems still a bit apart to me. Is this fine, and
> hence there is some more post-processing that I should do (and, if yes,
> what?). Or should they be already in sync?

The timestamps, recorded in both files are not synchronised. That's
why you are seeing the original timestamps. The offsets between both
clocks are recorded in the metadata of the guest trace file. You can verify
this using "trace-cmd dump --options trace-guest.dat" and
"trace-cmd dump --options trace.dat"
When both files are opened together, then that metadata is used to align
guest's timestamps to the host time. Currently trace-cmd report does not
have support for opening more trace files as a session, yet. This is in our
short todo list.

>
> I've also tried to open trace.dat in kernelshark2, and then append
> trace-(null).dat but from the few that I see (as said in my other
> email, kernelshark2 is not fully functional for me) the events from the
> two traces are still completely separated.

Currently using KernelShark2-beta is the only way to display host and
guests tracing files, as a session. There is logic for synchronising timestamps,
using metadata from the files. What repo are you using for getting the
KernelShark2-beta ?
Yordan can give more details on that.

>
> I also tried with the following, but it's still the same:
> # echo kvm-clock > /sys/devices/[...]/current_clocksource in the guest
>
> Then, I've removed the last patch of the series, the one for "KVM
> clock", after which, I was correctly (I think) seeing:
>
> "Negotiated ptp time sync protocol with guest (null)"

That "null" really bothers me, as I cannot reproduce it. The logic for
getting the
guest name, cid and port uses "/proc/<qemu pid>/cmdline". Please, can you send
me that string, from /proc/... or just "ps afx | grep qemu", to see
what is wrong with
our parsing logic.
Also, if you have any ideas how to get name, cid and port of running
libvirt VMs -
please share. The current approach parsing the qemu command line is a work
around, not a final solution.

Thanks!

>
> But then again:
>
> == Host:
>        CPU 0/KVM-9196  [001]249509851092735: kvm_exit:             vcpu 0 reason PREEMPTION_TIMER rip 0x7f0da050b357 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
>        CPU 0/KVM-9196  [001]249509851096316: kvm_apic_accept_irq:  apicid 0 vec 236 (Fixed|edge)
>        CPU 0/KVM-9196  [001]249509851112525: kvm_exit:             vcpu 0 reason MSR_WRITE rip 0xffffffffac475164 info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000
>        CPU 0/KVM-9196  [001]249509851114034: kvm_hv_timer_state:   vcpu_id 0 hv_timer 1
>        CPU 0/KVM-9196  [001]249509851115032: kvm_msr:              msr_write 6e0 = 0x367b512478b0
>            sleep-26457 [000]249509851765258: sched_process_exec:   filename=/usr/bin/sleep pid=26457 old_pid=26457
>        CPU 0/KVM-9196  [001]249509853247850: kvm_exit:             vcpu 0 reason EXTERNAL_INTERRUPT rip 0xffffffffad00015d info1 0x0000000000000000 info2 0x0000000000000000 intr_info 0x800000ec error_code 0x00000000
>        CPU 0/KVM-9196  [001]249509853250399: hrtimer_cancel:       hrtimer=0xffff96709fc61980
>
> == Guest:
>            <...>-12891 [000]125778006088605: sched_stat_runtime:   comm=trace-cmd pid=12891 runtime=84358 [ns] vruntime=5110265291610 [ns]
>            <...>-12891 [000]125778006095698: sched_switch:         prev_comm=trace-cmd prev_pid=12891 prev_prio=120 prev_state=S ==> next_comm=trace-cmd next_pid=12893 next_prio=120
>            <...>-12893 [000]125778006320003: sched_stat_runtime:   comm=trace-cmd pid=12893 runtime=58448 [ns] vruntime=5110268246764 [ns]
>            <...>-12893 [000]125778006322729: sched_switch:         prev_comm=trace-cmd prev_pid=12893 prev_prio=120 prev_state=S ==> next_comm=swapper/0 next_pid=0 next_prio=120
>           <idle>-0     [000]125778021774505: hrtimer_cancel:       hrtimer=0xffff99d67bc21980
>           <idle>-0     [000]125778021776481: hrtimer_expire_entry: hrtimer=0xffff99d67bc21980 function=tick_sched_timer now=31370890644808
>           <idle>-0     [000]125778021782895: hrtimer_expire_exit:  hrtimer=0xffff99d67bc21980
>
> So, what am I missing? :-)
>
> And, of course, thanks a lot again!
> --
> Dario Faggioli, Ph.D
> http://about.me/dario.faggioli
> Virtualization Software Engineer
> SUSE Labs, SUSE https://www.suse.com/
> -------------------------------------------------------------------
> <<This happens because _I_ choose it to happen!>> (Raistlin Majere)



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
