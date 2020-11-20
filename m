Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997A8C56201
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 14:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AFB22236F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 14:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgKTOIb convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 09:08:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgKTOIa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 09:08:30 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1AC02223F;
        Fri, 20 Nov 2020 14:08:29 +0000 (UTC)
Date:   Fri, 20 Nov 2020 09:08:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: Accuracy of traces sync [Was: Re: [PATCH] Fix `make -jN
 trace-cmd gui`]
Message-ID: <20201120090828.4b62d4b7@gandalf.local.home>
In-Reply-To: <849f846631f3014c3eff7f37a7d61493e2af66a9.camel@suse.com>
References: <160564780533.18208.2518938894299815863.stgit@toolbox-dario-user-work>
        <20201119220910.1a8ec625@oasis.local.home>
        <64d58c3297d6915362678c5799bd3d363489bda3.camel@suse.com>
        <02672da2-8b62-a573-786d-1cb8f5970e85@gmail.com>
        <849f846631f3014c3eff7f37a7d61493e2af66a9.camel@suse.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 20 Nov 2020 14:43:21 +0100
Dario Faggioli <dfaggioli@suse.com> wrote:

> On Fri, 2020-11-20 at 14:32 +0200, Yordan Karadzhov (VMware) wrote:
> > On 20.11.20 г. 14:06 ч., Dario Faggioli wrote:  
> > > >   
> > > Yep, sure! I followed the talks you've been giving about it at
> > > events, and I even played a little with what you have here:
> > > 
> > > https://github.com/yordan-karadzhov/kernel-shark-2.alpha
> > > 
> > > The host-guest tracing part, as I think you can guess.  
> > 
> > Ciao Dario,
> >  
> Hey!
> 
> > I am very happy to hear that. The timestamp synchronization patches
> > for 
> > trace-cmd are almost ready to go upstream.
> >   
> Yes, I tried those patches!
> 
> In fact, now that I have you here, do you mind if I change the subject
> and ask a quick question about them?
> 
> So, you often say that "the accuracy of the synchronization protocol is
> XX ms". Now, I guess that means that an event in the guest and the

Note, we are usually microsecond (us) apart, not millisecond (ms) ;-)

> corresponding event in the host (or vice versa) are XX ms apart. And
> that's even after the synchronization of the two traces, is that right?

At plumbers we talked with Thomas Gleixner and he suggested ideas of how to
get to the actual shifts used in the hardware that should give us exact
timestamp offsets. We are currently working on that. But in the mean time,
the P2P is giving us somewhere between 5 and 10 us accuracy. And that's
simply because the jitter of the vsock connection (which is used for the
synchronization at start and end of the traces) has a 5 to 10 us jitter,
and it's not possible to get a more accurate than the medium that is being
used.

> 
> Question is, how do you measure that? Sure, I can look manually for an
> occurrence of the pattern that I described above: i.e., an event in the
> guest, then the corresponding one in the host and compute the
> difference between the timestamps.

You mean, how we measure the accuracy? It's usually done by seeing when we
have events from the guest showing up when we should be in the host (it's
like seeing events from userspace when you are in the kernel).

> 
> But do you have a way to do so automatically, or with a script/program,
> etc?

We have talked about having something scan to find cases where the guest
event happens in kernel and do some post processing shifting, but haven't
gotten there yet. If the hardware settings can work, then there will be no
need to do so.

-- Steve

> 
> I saw that the series included a patch which was meant at debugging and
> profiling PTP, but even with that one applied and having it generate
> the graphs, I have not been able to get that info without manual
> inspection.
> 
> > And we are currently reviewing a beta version of KernelShark_2 that
> > will 
> > include the guest/host visualization.
> > As Steven said: stay tuned!
> >   
> You bet I will. :-P
> 
> Thanks and Regards

