Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04056C43461
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 12:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF16B6100C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Apr 2021 12:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhDZMo4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 08:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232364AbhDZMov (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 08:44:51 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A89E6611C1;
        Mon, 26 Apr 2021 12:44:09 +0000 (UTC)
Date:   Mon, 26 Apr 2021 08:44:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Joel Fernandes <joelaf@google.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Instructions for clock sync for tracing host/guest
Message-ID: <20210426084408.581364d9@gandalf.local.home>
In-Reply-To: <CAPpZLN5qWbsLhOfEa+o5raux39L1ua_F2i1M6Pi0tEfLZdwJmA@mail.gmail.com>
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
        <CAJWu+orjdLAdcUJKWj6f8gUtXUzBcvJEPeKjtVZ7P+EpiptF0w@mail.gmail.com>
        <CAPpZLN5qWbsLhOfEa+o5raux39L1ua_F2i1M6Pi0tEfLZdwJmA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 26 Apr 2021 13:58:18 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Fri, Apr 23, 2021 at 11:37 AM Joel Fernandes <joelaf@google.com> wrote:
> >
> > Apologies for the top post as I'm on Gmail mobile and only half awake at 4.30am.  I should check but can we just scrape the crosvm PIDs from the host trace itself ? The vCPU threads are in scheduler events in the host trace. Of course that wouldn't work if we don't have events. Let me know if that works for you or if I should find another way.
> >
> > By the way if sync is supposed to fall back to the ptp algo, why did it not fallback for me?  
> 
> Because of a bug in the code. It assumes if KVM is detected, then qemu
> is used to run the VMs.
> 

We need to find a way to do this without qemu. It's only the thread mapping
that is missing here, nothing else. And KVM sync should still work.

> >
> > Other thoughts:
> > - it would be cool if trace cmd agent was run by the host directly on the guest. That might eliminate a step. I can try to see if that's possible with crosvm but it's not super high priority.  
> 
> That will require to have some already established communication
> channel between host and guest. We can use ssh for example, but the
> user must set up in advance ssh server and pass credentials to
> tracec-cmd on the host.
> 
> >
> > Yes thanks for sending me any patches and happy to try.  
> 
> Just sent a patch that should fix the problem. Please, test it when
> you have time. The PTP-like algorithm will be used for trace
> timestamps synchronization, the best accuracy can be achieved using
> mono_raw trace clock:
>    host# trace-cmd record -e <host events> -C mono_raw -A test@32:823
> -e <guest events>
> 
> Steven, may be mono_raw clock should be the default in this case, when
> PTP is used for the synchronization ?

I think local is probably the safest.

> 
> >
> >
> > On Fri, Apr 23, 2021, 4:17 AM Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:  

And by the way, Tzvetomir, PLEASE crop the end of your email if you don't
have any more comments or at least add a signature in your last comment.
It is annoying to scroll through the rest of the email to find nothing else
was stated. This is a big pet peeve of many kernel developers.

-- Steve


> >>
> >> Hi Joel,
> >>
> >> On Fri, Apr 23, 2021 at 1:50 AM Joel Fernandes <joelaf@google.com> wrote:  
> >> >
> >> > Looks like my trace.dat files bounced from goodmis.org so I uploaded them here:
> >> > https://drive.google.com/file/d/16wGsVo4PJ0kYQGAy195dfBW0RHSWVkx0/view?usp=sharing
> >> >
> >> > ---------- Forwarded message ---------
> >> > From: Joel Fernandes <joelaf@google.com>
> >> > Date: Thu, Apr 22, 2021 at 6:46 PM
> >> > Subject: Re: Instructions for clock sync for tracing host/guest
> >> > To: Steven Rostedt <rostedt@goodmis.org>, Yordan Karadzhov (VMware)
> >> > <y.karadz@gmail.com>
> >> > Cc: Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> >> >
> >> >
> >> > On Thu, Apr 22, 2021 at 5:12 PM Joel Fernandes <joelaf@google.com> wrote:  
> >> > >
> >> > > On Thu, Apr 22, 2021 at 4:03 PM Steven Rostedt <rostedt@goodmis.org> wrote:  
> >> > > >
> >> > > > On Thu, 22 Apr 2021 15:49:21 -0400
> >> > > > Joel Fernandes <joelaf@google.com> wrote:
> >> > > >  
> >> > > > > On Thu, Apr 22, 2021 at 3:48 PM Steven Rostedt <rostedt@goodmis.org> wrote:  
> >> > > > > >
> >> > > > > > On Thu, 22 Apr 2021 15:43:37 -0400
> >> > > > > > Joel Fernandes <joelaf@google.com> wrote:
> >> > > > > >  
> >> > > > > > > >  # trace-cmd record -e irq -e sched -e kvm -A test@32:823 -e sched  
> >> > > > > > >
> >> > > > > > > OMG, that worked, thank you Steve and Tzvetomir !!!!!  
> >> > > > > >
> >> > > > > > Technically, you can probably leave off "-e irq", but I do find it rather
> >> > > > > > useful. But then, I add "-e irq" to the guest as well. It lets me see how
> >> > > > > > interrupts transpire from the host to the guest.  
> >> > > > >
> >> > > > > Got it thanks for the tip. Will report back any issues I see.  
> >> > > >
> >> > > > And you know you can pull this up into KernelShark as well, right?
> >> > > >
> >> > > > Checkout the development version from Yordan's repository:
> >> > > >
> >> > > >
> >> > > >  $ git clone https://github.com/yordan-karadzhov/kernel-shark.git
> >> > > >  $ cd kernel-shark
> >> > > >  $ git checkout origin/yordan_devel
> >> > > >  $ cmake .
> >> > > >  $ make
> >> > > >  $ sudo make install
> >> > > >
> >> > > > Then run kernelshark with:
> >> > > >
> >> > > >  $ kernelshark trace-host.dat -a trace-guest.dat
> >> > > >
> >> > > > (obviously, using the actual names of the trace.dat files for the host and
> >> > > > the guest)
> >> > > >
> >> > > > Then you can select: Plots -> KVM Combo Plots
> >> > > >
> >> > > > Then select the "all" box, and then apply. Then you get something like this:
> >> > > >
> >> > > >   http://rostedt.org/private/ks-host-guest.png
> >> > > >
> >> > > > Where you see how the tasks mapping to the host and guest are aligned.
> >> > > >
> >> > > > That is, if everything works fine.  
> >> > >
> >> > > Yes, I sort of knew KernelShark had this support, but so glad you sent
> >> > > me more details on how to do it, I'll try it out. I am also wondering
> >> > > how the bars of the vCPUs will look like because you can have vCPU
> >> > > threads migrated to different physical CPUs. I will go try it out and
> >> > > see what comes up :-)  
> >> >
> >> > Hi all, Just wanted to report my progress today:
> >> >
> >> > When I try to open the guest+host trace with the yordan_devel branch and command
> >> > kernelshark ~/vm-host-trace/trace.dat -a ~/vm-host-trace/trace-test.dat
> >> >
> >> > I get the following in the console: https://pastebin.com/raw/EmbsyuB8
> >> >
> >> > And the GUI looks like the attached picture, I don't see any mention
> >> > of KVM like Steve sees in
> >> > http://rostedt.org/private/ks-host-guest.png . What am I missing?
> >> >
> >> > I also zipped and attached my trace files to this email. Could you
> >> > take a look at them?  
> >>
> >> Looks like there is a gap in our implementation, affecting your use
> >> case. We rely too much on the quemu guest information that we gather,
> >> which is missing on your setup. As this information is not mandatory,
> >> the implementation should not rely on it. What we need:
> >>  - PID of the process, running the guest VM. In case of KVM, we use
> >> this PID to get the KVM guest TSC clock parameters, needed for better
> >> host and guest trace timestamps synchronization. Without this PID, KVM
> >> cannot be used for timestamps synchronization. The logic should fail
> >> back to a PTP-like algorithm, which is more generic, works in all
> >> environments, but is less accurate than KVM logic.
> >>  - PIDs of each thread, running a guest virtual CPU. This is not
> >> required for the tracing, but for better trace visualisation in
> >> KernelShark. It helps to map the host task to a vCPU and to visualise
> >> them together.
> >>
> >> Currently we collect that information from quemu, is there a way to
> >> get it from crosvm ? If yes, a crosvm support can be implemented in
> >> trace-cmd. But as I said, it is not mandatory to have it for the
> >> trace, I can send you a patch next week addressing this gap in the
> >> implementation.
> >>
> >> Thanks for testing this code!
> >>  
> >> >
> >> > My kernelshark HEAD commit is: 070d657 ("kernel-shark: Add KVMCombo
> >> > plugin") . Let me know if I should be building some other commit sha.
> >> >
> >> > Adding Yordan to this email as well.
> >> >
> >> > Thanks a lot!
> >> > -Joel  
> >>
> >>
> >>
> >> --
> >> Tzvetomir (Ceco) Stoyanov
> >> VMware Open Source Technology Center  
> 
> 
> 

