Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E95BC433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Oct 2022 03:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbiJZDw1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Oct 2022 23:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbiJZDwZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Oct 2022 23:52:25 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C3758060
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 20:52:23 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id bs21so8385018wrb.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 20:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y85VeqQEDhleCKKn3WahJdTCJLJ6TIyX19YIan4CI30=;
        b=eMjFKwluxrytKVdXvWNSsQiOx5UZW3j5LxkEcwddkoIub2jM1lCiFPZREruwKfn30W
         A3kCluwK9Na6YzinmMjcOna/5XOZwp+vfoKVnq16wtksWjFoLu737apOq4z2xtmKF3N2
         mr3vc2CLWTeeGZjeGvi/Bm9ScJvZPl6vkUC6On8uGZiMrU2whk5Fg0XMCsyBMdFkTU5m
         GFzmpIxLruuRPYQ4elV4/PTl5HdWQjy5Yx4EeEcVRrWXDhA/Mkl9LP/W0287H84FKDUT
         pT9gzlwkp/qYpJo68PDQaAf2QRAw+qidZNcaFhI/ljwwz9+HmdoUJxoFOHFz1vD9xgF6
         JSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y85VeqQEDhleCKKn3WahJdTCJLJ6TIyX19YIan4CI30=;
        b=hePl3dCqGo6JE83DXXZ13JCF2x9OQK+GFAdf4W2rkL2x+uEU0JElkNG33nJzfunB4T
         7T5l/V+9yx5Yp/CFHuzV9rYxgON+Ai8aTbgzvf0Ga7o6nZ2jMSM1yzpkQ9sa9V2Mt+da
         xn+Vg8heUrZSeK2ZCUWItDeQzZefPRn+P9gGG0O4MiCGrjW0J7wZmW5GyEXGxvcxdDXb
         wZnm2uzuIIy6A+iX4gCE7HhzhgnRmzhyBv+5uEfKm6oeU394zq6As+YSw+0DKd3N51qX
         V1lcW+7ILvGzAsUGlAa/adtndfII1d7dofOMFk5Dd879uk5K81JnSZaqKdn8lFMZ+zrp
         EFRg==
X-Gm-Message-State: ACrzQf3qfMKkP1yTnIRInBaHv23m0fO3zj13yHfRkDLODgr+bKeGkWLW
        vOaBFMRb/4NBE24YwJYL3WOERE4/4J64xHQ8mrv0NMHW7N8=
X-Google-Smtp-Source: AMsMyM6L+nnisoGx3AAaYfiMi+CFf2mLWgtlLAJDkcDG5y3f2Q1Nna/JOY5R1FhuDKsw//FHDGVa10LMcdWptcTDiOk=
X-Received: by 2002:a5d:59a4:0:b0:230:eaa4:88d7 with SMTP id
 p4-20020a5d59a4000000b00230eaa488d7mr28024970wrr.35.1666756342108; Tue, 25
 Oct 2022 20:52:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAJNi4rN7WkbEJkr9+vP1bOXQ_U=4eyDSaHb1aqJti_rTs2K7Hw@mail.gmail.com>
 <bad5e241-4fc4-df03-894e-3c0a6d0f5ff0@kernel.org>
In-Reply-To: <bad5e241-4fc4-df03-894e-3c0a6d0f5ff0@kernel.org>
From:   richard clark <richard.xnu.clark@gmail.com>
Date:   Wed, 26 Oct 2022 11:52:10 +0800
Message-ID: <CAJNi4rPwcWXUSx1_ALfWECezbPocXg++=i3eN9L-QW3x2vXaSQ@mail.gmail.com>
Subject: Re: About the output interpretation of the wip RV
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Daniel,

On Tue, Oct 25, 2022 at 3:16 PM Daniel Bristot de Oliveira
<bristot@kernel.org> wrote:
>
> Hi Richard!
>
> On 10/25/22 09:10, richard clark wrote:
> > Hi Daniel,
> > I got several dmsg outputs like this after I insmod the 'wip' into
> > system(with printk+dump_stack reactor, trivial changes for the wip):
>
> Which version of the monitor are you using? I make this question because the
> latest version of the monitor is not "loadable module" yet. So my guess is that
> you are using a version from the paper?

After switching to the builtin 'wip' monitor and enable it and the
'printk' reactor...
>
> > [78706.972957] event sched_waking not expected in the state preemptive
> > [78706.972963] CPU: 2 PID: 410 Comm: kworker/2:4 Tainted: G
> > OE     5.15.70-rt50 #1
> > [78706.972972] Workqueue: events igb_watchdog_task [igb]
> > [78706.973000] Call Trace:
> > [78706.973003]  <IRQ>
> > [78706.973006]  dump_stack_lvl+0x61/0x86
> > [78706.973016]  dump_stack+0x10/0x18
> > [78706.973022]  handle_sched_wakeup+0x92/0xd0 [rv_poc]
> > [78706.973028]  ttwu_do_wakeup+0xc3/0x1d0
> > [78706.973038]  ttwu_do_activate+0x6e/0x100
> > [78706.973044]  try_to_wake_up+0x209/0x700
> > [78706.973049]  ? hrtimer_interrupt+0x11f/0x230
> > [78706.973059]  wake_up_process+0x15/0x30
> > [78706.973065]  irq_exit_rcu+0x9b/0xe0
> > [78706.973074]  sysvec_apic_timer_interrupt+0x92/0xd0
> > [78706.973082]  </IRQ>
> > [78706.973083]  <TASK>
> > [78706.973084]  asm_sysvec_apic_timer_interrupt+0x1b/0x20
> >
> > Does that mean something is not unexpected in the system?
>
> Not necessarily, this monitor shows a limitation of tracing, as explained in
> the kernel documentation:

the dmesg shows below information with that enabled 'wip' monitor:

root@robotics:/sys/kernel/debug/tracing/rv/monitors# dmesg
...
[  332.834168] rv: monitor wip does not allow event sched_waking on
state preemptive
[  353.833699] rv: monitor wip does not allow event sched_waking on
state preemptive
[  354.833679] rv: monitor wip does not allow event sched_waking on
state preemptive
...
I took a look at the discussion at
https://lore.kernel.org/all/f2ca7336162b6dc45f413cfe4e0056e6aa32e7ed.1559051152.git.bristot@redhat.com/
seems that patch was trying to resolve the limitation of the tracing:
the __preempt_count_add() and its trace func is not atomic, does that
mean this issue is still in my system from the dmesg output above?
Another question is, except that the trace limitation, do we have some
specific examples to show that maybe an 'unexpected' event happens
against the current state?

Thanks!

>
> https://docs.kernel.org/trace/rv/monitor_wip.html
>
> Anyway, I suggest you using the upstream version of the monitors...
>
> -- Daniel
>
> > Thanks,
> > Richard
>
