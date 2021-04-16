Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A496C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 21:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77B41610A8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 21:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245325AbhDPVdD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 17:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241945AbhDPVdC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 17:33:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 729E3610A6;
        Fri, 16 Apr 2021 21:32:37 +0000 (UTC)
Date:   Fri, 16 Apr 2021 17:32:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stefano De Venuto <stefano.devenuto99@gmail.com>
Cc:     Dario Faggioli <dfaggioli@suse.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [RFC] Simple tool for VMEnters/VMExits matching and trace
 validation
Message-ID: <20210416173235.11b0d1c0@gandalf.local.home>
In-Reply-To: <756cd31c-9dff-5f18-8daf-5fae5e62f947@gmail.com>
References: <20210416164653.2949-1-stefano.devenuto99@gmail.com>
        <70d698ef3074a50576da48587aaf4ce2eea9585f.camel@suse.com>
        <756cd31c-9dff-5f18-8daf-5fae5e62f947@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 16 Apr 2021 22:48:38 +0200
Stefano De Venuto <stefano.devenuto99@gmail.com> wrote:

> On 4/16/21 7:47 PM, Dario Faggioli wrote:
> > On Fri, 2021-04-16 at 18:46 +0200, Stefano De Venuto wrote:  
> >> Add a tool in examples/ that scans a merged host + guest trace and
> >> search for host events that are inside a vmentry/vmexit block (and
> >> vice-versa for guest events ouside the block) and report the found
> >> ones.
> >>
> >> It can be useful as a starting point for identifying issues of for
> >> checking the effectiveness of host/guest traces synchronization, or
> >> even for improving the placing of the tracepoints in the kernel.
> >>
> >> Signed-off-by: Stefano De Venuto <stefano.devenuto99@gmail.com>
> >>  
> > Just as an example, by using this tool we noticed that there are a
> > bunch of host events that, despite happening before a VMEnter (and
> > after a VMExit) were shown in the trace inside of a kvm_enter -
> > kvm_exit "block".
> > 
> > Stefano, do you still have an example of how the trace looks like? Can
> > you paste it here?
> >   
> 
> Yes. An example of those events is visible in this trace:
> 
> 	   trace.dat:        CPU 0/KVM-1567  [001]14320175367012: kvm_entry:            vcpu 0, rip 0xffffffff84a792b6
> 	   trace.dat:        CPU 0/KVM-1567  [001]14320175253942: write_msr:            c0011020, value 0
> trace-tumbleweed.dat:           <idle>-0     [000]14320175283462: hrtimer_cancel:       hrtimer=0xffff9002fdc21a00
> trace-tumbleweed.dat:           <idle>-0     [000]14320175291336: hrtimer_expire_entry: hrtimer=0xffff9002fdc21a00 function=tick_sched_timer now=3601121397289
> trace-tumbleweed.dat:           <idle>-0     [000]14320175317345: hrtimer_expire_exit:  hrtimer=0xffff9002fdc21a00
> trace-tumbleweed.dat:           <idle>-0     [000]14320175319329: hrtimer_start:        hrtimer=0xffff9002fdc21a00 function=tick_sched_timer expires=3601125253926 softexpires=3601125253926 mode=0x0
>            trace.dat:        CPU 0/KVM-1567  [001]14320175331517: write_msr:            c0011020, value 40000000000000
>            trace.dat:        CPU 0/KVM-1567  [001]14320175338548: kvm_wait_lapic_expire: vcpu 0: delta 534432 (late)
>            trace.dat:        CPU 0/KVM-1567  [001]14320175341750: kvm_eoi:              apicid 0 vector 236
>            trace.dat:        CPU 0/KVM-1567  [001]14320175343465: kvm_pv_eoi:           apicid 0 vector 236
>            trace.dat:        CPU 0/KVM-1567  [001]14320175345704: kvm_exit:             vcpu 0 reason msr rip 0xffffffff84a792b4 info1 0x0000000000000001 info2 0x0000000000000000 intr_info 0x00000000 error_code 0x00000000

Is the above with the time negotiations working fine?

We do not yet support the guest shift, as we found that it was broken (I
believe you reported that) and we do not have a machine available to that
has that feature :-/

-- Steve


> 
> > Stefano has also already developed the attached kernel patch. Which we
> > plan to submit upstream as soon as we've tested properly on Intel
> > hardware as well. But that's another story (although, feel free to
> > provide any feedback already, if interested).
> > 
> > Thanks and Regards
> >   

