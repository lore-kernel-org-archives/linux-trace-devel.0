Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D2EAC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 12:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9EA561003
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 12:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhDZM5i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 08:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233428AbhDZM5i (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 08:57:38 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 478CB6101C;
        Mon, 26 Apr 2021 12:56:56 +0000 (UTC)
Date:   Mon, 26 Apr 2021 08:56:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Joel Fernandes <joelaf@google.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Instructions for clock sync for tracing host/guest
Message-ID: <20210426085654.5a47e7e5@gandalf.local.home>
In-Reply-To: <CAPpZLN7hhypY6+s5R+JX1u2e9Typ-1O1yC9mDoEcRYKLHYGFNw@mail.gmail.com>
References: <CAJWu+opJEtyXyhYnKL1iNzhfSCYRZN4PD50igckVvQV8416HEQ@mail.gmail.com>
        <CAJWu+orm+tm3C=MSF=p9eC1qgfE_pXzA2B0CiXgVXFemVRiVtA@mail.gmail.com>
        <CAJWu+opzT20OprG-8L_Lvv2DaJzF-ROaKnEWX8wjrbagPpwVzA@mail.gmail.com>
        <CAJWu+oqJk+BE2q=CjtAZJko-kJCS0Kyqwor_FVM3fu-X-rRRkg@mail.gmail.com>
        <20210422153845.3e6e9304@gandalf.local.home>
        <CAJWu+ooTVfprhd49__0H_61Fz_rSQA53n-VM6e1eEr8cTZ5aYQ@mail.gmail.com>
        <20210422154830.52f3e4f5@gandalf.local.home>
        <CAJWu+oqYWv5OHTLrC+oa7Y+LOe7AHumhtyVP8TC2LkK2=_JjPA@mail.gmail.com>
        <20210422160313.2eee1f77@gandalf.local.home>
        <CAJWu+ooZ9UptDBdii7dj=ui7dhiseOqZJE1CqMhP-Zy98QueXA@mail.gmail.com>
        <CAJWu+opsWVBDA8R-wVhhn2G_6h1LsMwzRDE=gMruZpFG+AH5zQ@mail.gmail.com>
        <CAJWu+oo8W9TVexZhhOs4P-DW1bH5DSjAzuV8QZMxvt9XHbRnJg@mail.gmail.com>
        <CAPpZLN5J8OYy2e87ns5tbxhd_O6Sh-r3_JJiX72iimEHn_dzrg@mail.gmail.com>
        <20210425142935.52078301@rorschach.local.home>
        <CAPpZLN7hhypY6+s5R+JX1u2e9Typ-1O1yC9mDoEcRYKLHYGFNw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 26 Apr 2021 13:39:32 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> >  # trace-cmd record -e kvm_entry ssh guest taskset -c 0 ls \; taskset -c 1 cat /etc/passwd
> >  # trace-cmd report
> > [..]
> >            <...>-129042 [004]1122452427093922: kvm_entry:            vcpu 0
> >            <...>-129043 [005]1122452427148178: kvm_entry:            vcpu 1
> >            <...>-129042 [004]1122452427150380: kvm_entry:            vcpu 0
> >            <...>-129043 [005]1122452427201498: kvm_entry:            vcpu 1
> >
> > There, I see the guest vcpu 0 is controlled by the host thread with pid
> > 129042 and vcpu 1 is controlled by host thread pid 129043.  
> 
> It works only in case of one VM, if there are more than one - cannot
> map kvm_entry event to specific VM.

Deja vu!

Yes, we had this conversation a long time ago ;-)

I was thinking of doing this during the synchronization phase. We should be
able to figure out the guest host mapping. I have a vsock-client program
that uses the vsockets to talk with the guest (like netcat). And traced it
this way:

 # trace-cmd record -e sched_wakeup -e kvm_entry

And have this:

    vsock-client-159876 [000]1346877108580652: sched_wakeup:         vhost-128994:129046 [120] success=1 CPU:006

    vhost-128994-129046 [006]1346877108678708: sched_wakeup:         CPU 0/KVM:129042 [120] success=1 CPU:007

       CPU 0/KVM-129042 [007]1346877109290044: kvm_entry:            vcpu 0


Instead of looking at vsock-client, look at the current pid and see what
"vhost" it wakes up, then see what what thread it wakes up, and then see if
it calls kvm_entry. we don't even need to know if it is a vhost. Just trace
everything that our current thread wakes up and what those wake up until
something calls kvm_entry.

We have our mapping right there! And with the new libtracefs APIs,
implementing the above walk through is trivial.

-- Steve
