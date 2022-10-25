Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B31C04A95
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Oct 2022 07:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiJYHQv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Oct 2022 03:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiJYHQt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Oct 2022 03:16:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D587646205
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 00:16:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 758B361770
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 07:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDA9C433D7;
        Tue, 25 Oct 2022 07:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666682207;
        bh=pj+7IZhN/3dKv3MONTbhASn40cCTK6TNKYlAFxegSEM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=dYfdCPmw/of1bPPwDXqBFO+eRnDoYgvJJ6iSF3tbZDwdtsPzJMOiZeS9J8eIaHDla
         jo1bMHZN6K98OD+NmjfaDvpKr6hl6mGx3UNI/oexvqNKHN1nnbiiVHeiyFbjJYkDqJ
         pg2RRcA4u1NIYlvZ5KDIo9hJ0A4GiCC5TNF8uE0EDYCNLWANxsWrhokb/zzGRXmpSZ
         FEMHESA875wDcCc65QKMQMuEse6RjLLbrf21aRRc5uIDc+NlAG1LQ9Ov/vwSslGdMG
         u19W4zyLzVwsrz5+U0dz1b31ZH+VQT8oR1VlA7B2ARlGJYmJE4iXnWitKtgoH3/lwB
         Cwt+ST/Utr6jw==
Message-ID: <bad5e241-4fc4-df03-894e-3c0a6d0f5ff0@kernel.org>
Date:   Tue, 25 Oct 2022 09:16:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: About the output interpretation of the wip RV
Content-Language: en-US
To:     richard clark <richard.xnu.clark@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <CAJNi4rN7WkbEJkr9+vP1bOXQ_U=4eyDSaHb1aqJti_rTs2K7Hw@mail.gmail.com>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <CAJNi4rN7WkbEJkr9+vP1bOXQ_U=4eyDSaHb1aqJti_rTs2K7Hw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Richard!

On 10/25/22 09:10, richard clark wrote:
> Hi Daniel,
> I got several dmsg outputs like this after I insmod the 'wip' into
> system(with printk+dump_stack reactor, trivial changes for the wip):

Which version of the monitor are you using? I make this question because the
latest version of the monitor is not "loadable module" yet. So my guess is that
you are using a version from the paper?

> [78706.972957] event sched_waking not expected in the state preemptive
> [78706.972963] CPU: 2 PID: 410 Comm: kworker/2:4 Tainted: G
> OE     5.15.70-rt50 #1
> [78706.972972] Workqueue: events igb_watchdog_task [igb]
> [78706.973000] Call Trace:
> [78706.973003]  <IRQ>
> [78706.973006]  dump_stack_lvl+0x61/0x86
> [78706.973016]  dump_stack+0x10/0x18
> [78706.973022]  handle_sched_wakeup+0x92/0xd0 [rv_poc]
> [78706.973028]  ttwu_do_wakeup+0xc3/0x1d0
> [78706.973038]  ttwu_do_activate+0x6e/0x100
> [78706.973044]  try_to_wake_up+0x209/0x700
> [78706.973049]  ? hrtimer_interrupt+0x11f/0x230
> [78706.973059]  wake_up_process+0x15/0x30
> [78706.973065]  irq_exit_rcu+0x9b/0xe0
> [78706.973074]  sysvec_apic_timer_interrupt+0x92/0xd0
> [78706.973082]  </IRQ>
> [78706.973083]  <TASK>
> [78706.973084]  asm_sysvec_apic_timer_interrupt+0x1b/0x20
> 
> Does that mean something is not unexpected in the system?

Not necessarily, this monitor shows a limitation of tracing, as explained in
the kernel documentation:

https://docs.kernel.org/trace/rv/monitor_wip.html

Anyway, I suggest you using the upstream version of the monitors...

-- Daniel

> Thanks,
> Richard

