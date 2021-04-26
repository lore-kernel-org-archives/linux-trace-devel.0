Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDE7C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 14:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69F4861289
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 14:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbhDZOv4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 10:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233925AbhDZOvz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 10:51:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11E9061040;
        Mon, 26 Apr 2021 14:51:12 +0000 (UTC)
Date:   Mon, 26 Apr 2021 10:51:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Joel Fernandes <joelaf@google.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Instructions for clock sync for tracing host/guest
Message-ID: <20210426105111.288280bb@gandalf.local.home>
In-Reply-To: <af1e4b468e606be535227ae7fe8a1a17d4c019fb.camel@suse.com>
References: <CAJWu+opJEtyXyhYnKL1iNzhfSCYRZN4PD50igckVvQV8416HEQ@mail.gmail.com>
        <20210422153845.3e6e9304@gandalf.local.home>
        <CAJWu+ooTVfprhd49__0H_61Fz_rSQA53n-VM6e1eEr8cTZ5aYQ@mail.gmail.com>
        <20210422154830.52f3e4f5@gandalf.local.home>
        <CAJWu+oqYWv5OHTLrC+oa7Y+LOe7AHumhtyVP8TC2LkK2=_JjPA@mail.gmail.com>
        <20210422160313.2eee1f77@gandalf.local.home>
        <CAJWu+ooZ9UptDBdii7dj=ui7dhiseOqZJE1CqMhP-Zy98QueXA@mail.gmail.com>
        <CAJWu+opsWVBDA8R-wVhhn2G_6h1LsMwzRDE=gMruZpFG+AH5zQ@mail.gmail.com>
        <CAJWu+oo8W9TVexZhhOs4P-DW1bH5DSjAzuV8QZMxvt9XHbRnJg@mail.gmail.com>
        <CAPpZLN5J8OYy2e87ns5tbxhd_O6Sh-r3_JJiX72iimEHn_dzrg@mail.gmail.com>
        <CAJWu+orjdLAdcUJKWj6f8gUtXUzBcvJEPeKjtVZ7P+EpiptF0w@mail.gmail.com>
        <CAPpZLN5qWbsLhOfEa+o5raux39L1ua_F2i1M6Pi0tEfLZdwJmA@mail.gmail.com>
        <20210426084408.581364d9@gandalf.local.home>
        <CAPpZLN48S2M33sBR8tV4e1Wr1tHKj9rN0gb52nh3cbX_KBbGbw@mail.gmail.com>
        <af1e4b468e606be535227ae7fe8a1a17d4c019fb.camel@suse.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 26 Apr 2021 16:11:46 +0200
Dario Faggioli <dfaggioli@suse.com> wrote:

> I can't double check as I don't have a crossvm environment handy, but I
> guess it looks the same, and the PID is the one of whatever task in
> crossvm issues the KVM_CREATE_VM ioctl (and the fd returned by such
> call).
> 
> In QEMU, such process then creates one thread for each vCPU... Again, I

I'm sure all implementations will do the same. Anything else would not make
sense.

> don't really know for sure, but I guess it would be similar in crossvm?
> 
> If yes, AFAICT, kvm_entry events can tell us the PIDs of such threads.
> So the challenge here is getting from the PID of a thread to the PID of
> the process that created it.

As I stated in the other thread, we can find the thread that is running the
vCPU by following the wake ups. A vsock connection will trigger a series of
events that will eventually wake up a task that does a kvm_entry. Then you
know the thread.

Here's another run:

    vsock-client-160552 [001] 403952.847983: sched_wakeup:         vhost-128994:129046 [120] success=1 CPU:003

    vhost-128994-129046 [003] 403952.848030: sched_wakeup:         CPU 0/KVM:129042 [120] success=1 CPU:006

       CPU 0/KVM-129042 [006] 403952.848085: kvm_entry:            vcpu 0


We see that our process (PID 160552) wakes up 129046 which then wakes up
129042, which does a kvm_entry for vcpu 0. Since process 160552 is
communicating with the guest, we know that this series of events will wake
up the guest we want to map the thread and the vCPU of the guest with.

As it was thread 129042 that called kvm_entry, it's the thread that is
mapped to vcpu 0 of the guest we are tracing.

-- Steve
