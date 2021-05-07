Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F9EAC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 11:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DDF161443
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 11:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbhEGL7g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 07:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235519AbhEGL7f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 07:59:35 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C43C361431;
        Fri,  7 May 2021 11:58:35 +0000 (UTC)
Date:   Fri, 7 May 2021 07:58:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Dario Faggioli <dfaggioli@suse.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2] trace-cmd: Find PID of host-guest task from tracing
 vsock connection
Message-ID: <20210507075834.43497e77@gandalf.local.home>
In-Reply-To: <CAPpZLN48irG2cuPZi4+RAORbkxpnHudNf1wdXBdjYDmr4e8bhw@mail.gmail.com>
References: <20210506171400.7c00b731@gandalf.local.home>
        <f4c372f2138151299588b702567827a61954f775.camel@suse.com>
        <20210506214012.741cbbd7@oasis.local.home>
        <CAPpZLN48irG2cuPZi4+RAORbkxpnHudNf1wdXBdjYDmr4e8bhw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 7 May 2021 07:20:15 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> As Dario said, we can get the guest from the /proc/{kvm_exit task
> ID}/status - the Tgid written there is the guest, the host task which
> runs that guest.

Maybe I'm not understanding the question.

> Doesn't a VMExit always happen in the thread that runs the vCPU anyway?

The problem is that we do not know what Tgid we are looking for. If you
have 10 guests, you have 10 different Tgid's that are running those guests.
How do you know which guest is attached to the cid you are looking for?
There's currently no way to find that mapping. In fact, that's why I posted
this patch:


  https://lore.kernel.org/kvm/20210505163855.32dad8e7@gandalf.local.home/


So you trace the kvm exit, and all 10 guests were active at that time, and
you have 100 threads that called kvm exit. Now how do you find the pid of
the task that owns the cid you are looking for, especially if each guest
has their own cid?

Oh, and the guest is run by a fork of qemu that has some other name! So you
can not rely on looking at the thread's cmdline.

If you look at the code I have, I use the wake ups to find the thread of
the task that is woken up by the current task.

 my-task:

    start tracing kvm_exit and sched_waking

    connect to cid I want.
    my_task -> wakes up vhost-worker
    vhost-worker -> wakes up guest thread with cid I want
    guest-thread -> does kvm_exit

    stop tracing.

    Follow the wake ups to find that guest-thread pid

    Now look at /proc/guest-thread-pid/status
    and get the Tgid of the task in /debug/kvm.

That's what this patch does.

Again, how else can you map the cid to the guest thread? That's the missing
link that following the wake ups give you.

-- Steve
