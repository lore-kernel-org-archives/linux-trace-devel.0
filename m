Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6C6C04A95
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Oct 2022 09:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiJYJX2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Oct 2022 05:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiJYJWr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Oct 2022 05:22:47 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1306BDF24
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 02:18:31 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id y16so9300903wrt.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 02:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7uDmPEK+HE8D9r7/xjlTCFwKpUsRRdvpTaX0hmQZXEg=;
        b=mvr84XU5IB8VcMwA/n/EpUunw3zNOZPFYPR0J+8OxZ+OZo/2cp98UW2tZ3YmKj3+54
         6ttEu2muwFoWLMHSDOmW9Eo81qS2xdhyTtM+2DpoFUv92D+FI7uTwX+Do7OdxddvyMmz
         IRRwb/1yUygsoR9OhQsJaQn9qZnA4cIuxVVNcOiPAEEXUBLYJq6kOS1SlTni/zal1+z9
         hGkP7Fmma45OAYJ5czUDDY0bi179ZMgKrY0Wu5GERpgyIewCIW/LY+MnvOIfo3+T2nSV
         F9QUxld2o3UeguqpaI/+O764OCG+BlgIhHjsS7QkekR1q+fxCaP3DpQQrhHuZYIPWMOp
         WB2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7uDmPEK+HE8D9r7/xjlTCFwKpUsRRdvpTaX0hmQZXEg=;
        b=FU+kNx1d8q+tZFXpD56SxhT9lCPyrtn1gjzTlFXo1stnAA7y21Jo+W1HIGs3OaiVop
         gw/vpZbxmsC6OF6eeiZkpzzDycD/kz93LhFosajqo0cbL7DETwtiY5KLKa+A0gV2i9Fs
         j30Ukf/120LxJ1vYhcQHXjDItyO0Z28P80ESaDGa0jTjfaa9CQCpQeBWNK0iepjCNyHK
         Ra1toRXBeqsUArDzTfCIYphzZC2U07MKvLvTiCDdxyJEN+cXPSMPEK/e8KiUpcCWe+/W
         GwOJm2LyAH11fib2AItgqFgad4r/+nmP1i3WdvNgZvMGpeMWsq3SvfA+DbTQX3aXetrh
         mS1Q==
X-Gm-Message-State: ACrzQf2jNakCfKDLgCBXPi33npbDK5XclV0yu2hiAnnWrhkfY1KsK5eA
        58m62FbJKs+PXjDyXHWMILoP6IsiX/tA0SEKDyr0yatt
X-Google-Smtp-Source: AMsMyM5OXxR1bwzz3KzilP70iKGeO7gbVj7bAbJMjVoyg4SvrQH/Ouf0lboOWQimSltHdjFcBXytrofKhuKRV6gfslQ=
X-Received: by 2002:a5d:6901:0:b0:22f:b097:7de6 with SMTP id
 t1-20020a5d6901000000b0022fb0977de6mr25547881wru.373.1666689510154; Tue, 25
 Oct 2022 02:18:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAJNi4rN7WkbEJkr9+vP1bOXQ_U=4eyDSaHb1aqJti_rTs2K7Hw@mail.gmail.com>
 <bad5e241-4fc4-df03-894e-3c0a6d0f5ff0@kernel.org>
In-Reply-To: <bad5e241-4fc4-df03-894e-3c0a6d0f5ff0@kernel.org>
From:   richard clark <richard.xnu.clark@gmail.com>
Date:   Tue, 25 Oct 2022 17:18:18 +0800
Message-ID: <CAJNi4rMo9EjY19QX_6TK9RVzfT+DAMKG7Vbf9-XM7DSkWG6xzQ@mail.gmail.com>
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
>
Right, from the paper...

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
>
> https://docs.kernel.org/trace/rv/monitor_wip.html
>
> Anyway, I suggest you using the upstream version of the monitors...

OK, I'll use the upstream version, happens has 6.0.1 kernel version
installed, will be back to you if any question.. Thanks~

>
> -- Daniel
>
> > Thanks,
> > Richard
>
