Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC4FECAAA1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Oct 2022 07:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiJ1HYz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Oct 2022 03:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiJ1HYy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Oct 2022 03:24:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5917D3ED6E
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Oct 2022 00:24:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E141B82898
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Oct 2022 07:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B260AC433D6;
        Fri, 28 Oct 2022 07:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666941890;
        bh=AchA/RStmwWLAoCHSALYHD7egqApkDotzQsL8yO5R4s=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=icSeuJRK2g20xAzDhUMz6PyJmZafKPlbNJJmSK0FhBJ7LZ+OeU1kLvM/jlYkVvRgj
         2eyzdANiTUWxwb5rx5QHTk2siORor/UkwF7D0oVQEn+f8cPwNTzkxemGCv9E/AusNH
         jUwQU2ZU+hfeKa2VCSuiZ6Yo6+tuEYi2Ceq2cRp77nysTRWP4SeO//FrwRIgRPwlbI
         he5PK3KhXpIaiAmeud/Qa8vyWvgMpbzsF36kB/IuL+iq0gSfw+wXVVA36QF5dhQ6Kb
         LrwCQqSe3jPfaK3fu7Dk/OKIvGAZDFJ/S16DzbhkyNs12SeOE+z0PSXaM9lHc9XQWH
         beSeyS9A+EPBA==
Message-ID: <1612f8c8-bf0c-6461-6ecf-d28e590b2e93@kernel.org>
Date:   Fri, 28 Oct 2022 09:24:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: About the output interpretation of the wip RV
To:     richard clark <richard.xnu.clark@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <CAJNi4rN7WkbEJkr9+vP1bOXQ_U=4eyDSaHb1aqJti_rTs2K7Hw@mail.gmail.com>
 <bad5e241-4fc4-df03-894e-3c0a6d0f5ff0@kernel.org>
 <CAJNi4rPwcWXUSx1_ALfWECezbPocXg++=i3eN9L-QW3x2vXaSQ@mail.gmail.com>
Content-Language: en-US
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <CAJNi4rPwcWXUSx1_ALfWECezbPocXg++=i3eN9L-QW3x2vXaSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10/26/22 05:52, richard clark wrote:
> Hi Daniel,
> 
> On Tue, Oct 25, 2022 at 3:16 PM Daniel Bristot de Oliveira
> <bristot@kernel.org> wrote:
>>
>> Hi Richard!
>>
>> On 10/25/22 09:10, richard clark wrote:
>>> Hi Daniel,
>>> I got several dmsg outputs like this after I insmod the 'wip' into
>>> system(with printk+dump_stack reactor, trivial changes for the wip):
>>
>> Which version of the monitor are you using? I make this question because the
>> latest version of the monitor is not "loadable module" yet. So my guess is that
>> you are using a version from the paper?
> 
> After switching to the builtin 'wip' monitor and enable it and the
> 'printk' reactor...
>>
>>> [78706.972957] event sched_waking not expected in the state preemptive
>>> [78706.972963] CPU: 2 PID: 410 Comm: kworker/2:4 Tainted: G
>>> OE     5.15.70-rt50 #1
>>> [78706.972972] Workqueue: events igb_watchdog_task [igb]
>>> [78706.973000] Call Trace:
>>> [78706.973003]  <IRQ>
>>> [78706.973006]  dump_stack_lvl+0x61/0x86
>>> [78706.973016]  dump_stack+0x10/0x18
>>> [78706.973022]  handle_sched_wakeup+0x92/0xd0 [rv_poc]
>>> [78706.973028]  ttwu_do_wakeup+0xc3/0x1d0
>>> [78706.973038]  ttwu_do_activate+0x6e/0x100
>>> [78706.973044]  try_to_wake_up+0x209/0x700
>>> [78706.973049]  ? hrtimer_interrupt+0x11f/0x230
>>> [78706.973059]  wake_up_process+0x15/0x30
>>> [78706.973065]  irq_exit_rcu+0x9b/0xe0
>>> [78706.973074]  sysvec_apic_timer_interrupt+0x92/0xd0
>>> [78706.973082]  </IRQ>
>>> [78706.973083]  <TASK>
>>> [78706.973084]  asm_sysvec_apic_timer_interrupt+0x1b/0x20
>>>
>>> Does that mean something is not unexpected in the system?
>>
>> Not necessarily, this monitor shows a limitation of tracing, as explained in
>> the kernel documentation:
> 
> the dmesg shows below information with that enabled 'wip' monitor:
> 
> root@robotics:/sys/kernel/debug/tracing/rv/monitors# dmesg
> ...
> [  332.834168] rv: monitor wip does not allow event sched_waking on
> state preemptive
> [  353.833699] rv: monitor wip does not allow event sched_waking on
> state preemptive
> [  354.833679] rv: monitor wip does not allow event sched_waking on
> state preemptive
> ...
> I took a look at the discussion at
> https://lore.kernel.org/all/f2ca7336162b6dc45f413cfe4e0056e6aa32e7ed.1559051152.git.bristot@redhat.com/
> seems that patch was trying to resolve the limitation of the tracing:
> the __preempt_count_add() and its trace func is not atomic, does that
> mean this issue is still in my system from the dmesg output above?

It is like this on all systems. It is expected to have printk.

> Another question is, except that the trace limitation, do we have some
> specific examples to show that maybe an 'unexpected' event happens
> against the current state?

With regard to this monitor or any other monitor? To this monitor, the answer is
not that I know about. But tracing is your friend, you can enable trace the
system and the monitor yourself, and figure out what is going on.

-- Daniel

> Thanks!
> 
>>
>> https://docs.kernel.org/trace/rv/monitor_wip.html
>>
>> Anyway, I suggest you using the upstream version of the monitors...
>>
>> -- Daniel
>>
>>> Thanks,
>>> Richard
>>

