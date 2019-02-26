Return-Path: <SRS0=LjSD=RB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50327C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Feb 2019 18:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20A3B217F9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Feb 2019 18:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbfBZSP6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 13:15:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728791AbfBZSP5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 13:15:57 -0500
Received: from vmware.local.home (unknown [208.91.3.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8DB9217F5;
        Tue, 26 Feb 2019 18:15:56 +0000 (UTC)
Date:   Tue, 26 Feb 2019 13:15:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: Re: Can't use kvm_exit for the host side time stamp
Message-ID: <20190226131554.37e0b7b5@vmware.local.home>
In-Reply-To: <CACqStoe6XzreeB=19AmvcwGUmCs351vk+shMAm95PYnj5e8vWA@mail.gmail.com>
References: <20190226112406.7abab75a@vmware.local.home>
        <CACqStoe6XzreeB=19AmvcwGUmCs351vk+shMAm95PYnj5e8vWA@mail.gmail.com>
X-Mailer: Claws Mail 3.15.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 26 Feb 2019 18:02:48 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> We performed a lot of tests with the current implementation (relying
> on the kvm_exit event),
> and the results are very accurate and consistent. Of course, there are
> probes with huge
> deviation, but these can be easily filtered.

At least we now know why there were huge deviations :-)

> 
> > kvm_enter is fine, but the reason that kvm_exit is not, is because, in
> > order to record the reason for the exit, it needs to call into either
> > the Intel or AMD code (as they are different), and that is done after
> > interrupts and preemption are enabled.
> >
> > Instead, we can trace the function kvm_read_l1_tsc, which happens while
> > interrupts are still enabled.
> >
> > Would you be able to test with that function instead of using kvm_exit?
> > Also, if you still see a drift, try setting both trace clocks to
> > x86-tsc, and see if you still get a drift.  
> 
> Yes, I'll test with the kvm_read_l1_tsc function tomorrow.  Is it
> related to x86-tsc
> clock only, or it should work with any clock ? I noticed that the
> drift does not depend
> on the clock, x86-tsc also drifts.
>

No, it shouldn't be related, you can do them differently.

Is it only your machine that has an drift, or do you see it on other
machines? We looked at Yordan's laptop, and it had shifts, but not a
drift. That is, it was off for a bit but then goes back. Not a drift,
but a shift between two deltas. Not sure why.

The fact that it drifts with x86-tsc clock bothers me, because the
guest and the host are using the same crystal. For there to be a drift,
the tsc of the guest needs to be using a different crystal than the
host. That is, two different clock sources for the TSC depending on if
the CPU is in the VM or in the host context.

BTW, is your box Intel or AMD?

Thanks,

-- Steve
