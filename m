Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19030C38A02
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Oct 2022 03:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbiJ1DhY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Oct 2022 23:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbiJ1DhW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Oct 2022 23:37:22 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C701CD01AC
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Oct 2022 20:37:21 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id bs21so5308056wrb.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Oct 2022 20:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7bB8fnf95hFrqbaN9AON1t4cNhC4UDGuZ6ALXfMiPTI=;
        b=OAfTZdZFgbvvlQmJe83thcaXQoe4k63CFF5EUfwCWwZ0HbdzNtPxosiHbHT12BTnUj
         jgGvgOImpEzCOWP30aowUelQ12E2Wwb+ohIRrFLfcfP4F0S+iQ1ESIc/CTljEvDTfmYg
         zCqVFxJiwCEcAqgw7dl+pYffW9/8v00kQwG5fPmiPNwq8W9f50fwXZb0GJti9POCaoUO
         USk0558kvfdStojD6cG3JQPsE5YOI9zj4nMxNSc0ngkwA9jF3gl0XkEchlS1d31UnUJD
         Q4fPvrtuAIe3TpibrDvAjA8YQ+S0yqnmSxvik7cjpA+th8Y68q44V627A+Fkyzo2AAaz
         qTHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7bB8fnf95hFrqbaN9AON1t4cNhC4UDGuZ6ALXfMiPTI=;
        b=CBThWilA6AkOR0Y6lCkMTogjuxnIRX3IIMz1SFp/hkGo3JjU/z4waKVynFn7+iui99
         73aj7QzqAsbZ3mcvG0wh8M/2LHMoqKBftwSc1mVnpXVRgMV4KygAInxLE62Ysnf4KY7c
         v2W60v3Oe9v7znwAVNlHkei5iXkwraGby2cTh/h6gfT+oQDmXXtigun6eTZEx7y48C1I
         UrVniuWDOBnImFSOfUjLopJx6RDGZrGFr2H3SCKP0VpZzYUnWELj21w4ab/sok+VrBJT
         mMU//S+uoGNuULSNxOpBaEKOD0VPnBjekRl5Flb5v/E/atcTTleCCpa+dzHdgqsrnR4Y
         KJEw==
X-Gm-Message-State: ACrzQf1QH03RamS1rBD9+3x/dTQZzHh84tAk3r2oSCNzxgx2EPqtysqN
        1zJstR76SlOBTSzTmgTk83MYvon4y1tG2MiVuVXoweJp
X-Google-Smtp-Source: AMsMyM6Xq5KI2ejeWmuIs29/FF0KxX8QdlL42w95R4C97pRpTszxeTDAuLLAv/JH7JIB+pt6wCKyZky48WAU/NbxKQs=
X-Received: by 2002:a5d:59a4:0:b0:230:eaa4:88d7 with SMTP id
 p4-20020a5d59a4000000b00230eaa488d7mr34630117wrr.35.1666928240303; Thu, 27
 Oct 2022 20:37:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAJNi4rN7WkbEJkr9+vP1bOXQ_U=4eyDSaHb1aqJti_rTs2K7Hw@mail.gmail.com>
 <bad5e241-4fc4-df03-894e-3c0a6d0f5ff0@kernel.org> <CAJNi4rPwcWXUSx1_ALfWECezbPocXg++=i3eN9L-QW3x2vXaSQ@mail.gmail.com>
In-Reply-To: <CAJNi4rPwcWXUSx1_ALfWECezbPocXg++=i3eN9L-QW3x2vXaSQ@mail.gmail.com>
From:   richard clark <richard.xnu.clark@gmail.com>
Date:   Fri, 28 Oct 2022 11:37:09 +0800
Message-ID: <CAJNi4rMsk8Q=xDQc1Jo416sJmdi0YXWD=KhHeLLta+wg8pieiw@mail.gmail.com>
Subject: Re: About the output interpretation of the wip RV
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Daniel,

Any comments for this thread?

On Wed, Oct 26, 2022 at 11:52 AM richard clark
<richard.xnu.clark@gmail.com> wrote:
>
> Hi Daniel,
>
> On Tue, Oct 25, 2022 at 3:16 PM Daniel Bristot de Oliveira
> <bristot@kernel.org> wrote:
> >
> > Hi Richard!
> >
> > On 10/25/22 09:10, richard clark wrote:
> > > Hi Daniel,
> > > I got several dmsg outputs like this after I insmod the 'wip' into
> > > system(with printk+dump_stack reactor, trivial changes for the wip):
> >
> > Which version of the monitor are you using? I make this question because the
> > latest version of the monitor is not "loadable module" yet. So my guess is that
> > you are using a version from the paper?
>
> After switching to the builtin 'wip' monitor and enable it and the
> 'printk' reactor...
> >
> > > [78706.972957] event sched_waking not expected in the state preemptive
> > > [78706.972963] CPU: 2 PID: 410 Comm: kworker/2:4 Tainted: G
> > > OE     5.15.70-rt50 #1
> > > [78706.972972] Workqueue: events igb_watchdog_task [igb]
> > > [78706.973000] Call Trace:
> > > [78706.973003]  <IRQ>
> > > [78706.973006]  dump_stack_lvl+0x61/0x86
> > > [78706.973016]  dump_stack+0x10/0x18
> > > [78706.973022]  handle_sched_wakeup+0x92/0xd0 [rv_poc]
> > > [78706.973028]  ttwu_do_wakeup+0xc3/0x1d0
> > > [78706.973038]  ttwu_do_activate+0x6e/0x100
> > > [78706.973044]  try_to_wake_up+0x209/0x700
> > > [78706.973049]  ? hrtimer_interrupt+0x11f/0x230
> > > [78706.973059]  wake_up_process+0x15/0x30
> > > [78706.973065]  irq_exit_rcu+0x9b/0xe0
> > > [78706.973074]  sysvec_apic_timer_interrupt+0x92/0xd0
> > > [78706.973082]  </IRQ>
> > > [78706.973083]  <TASK>
> > > [78706.973084]  asm_sysvec_apic_timer_interrupt+0x1b/0x20
> > >
> > > Does that mean something is not unexpected in the system?
> >
> > Not necessarily, this monitor shows a limitation of tracing, as explained in
> > the kernel documentation:
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
> Another question is, except that the trace limitation, do we have some
> specific examples to show that maybe an 'unexpected' event happens
> against the current state?
>
> Thanks!
>
> >
> > https://docs.kernel.org/trace/rv/monitor_wip.html
> >
> > Anyway, I suggest you using the upstream version of the monitors...
> >
> > -- Daniel
> >
> > > Thanks,
> > > Richard
> >
