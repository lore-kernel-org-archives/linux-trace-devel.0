Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2AF7C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Apr 2021 22:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C78BC6117A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Apr 2021 22:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhDNWZt convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Apr 2021 18:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231207AbhDNWZt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Apr 2021 18:25:49 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD7EC600CD;
        Wed, 14 Apr 2021 22:25:26 +0000 (UTC)
Date:   Wed, 14 Apr 2021 18:25:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Giuseppe Eletto <giuseppe.eletto@edu.unito.it>,
        linux-trace-devel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Enrico Bini <enrico.bini@unito.it>
Subject: Re: A KernelShark plugin for Xen traces analysis
Message-ID: <20210414182524.0e51a520@gandalf.local.home>
In-Reply-To: <28ac9c046cc521cbaef9c2ff56911cd7b3100ac4.camel@suse.com>
References: <CALTQNB5X1+G33Qoh5nNxttQe_GkzKvJFLfEXQszsc6XYr+NgUA@mail.gmail.com>
        <20210413114614.4971caff@gandalf.local.home>
        <28ac9c046cc521cbaef9c2ff56911cd7b3100ac4.camel@suse.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 15 Apr 2021 00:11:32 +0200
Dario Faggioli <dfaggioli@suse.com> wrote:

 
> Yes, basically, we can say that a Xen system has "its own trace-cmd".
> It's called `xentrace`, you run it from Dom0 and you get a (binary)
> file which contains a bunch of events.
> 
> Not that differently from a trace-cmd's "trace.dat" file, but the
> events in there comes from tracepoints within the hypervisor (which, of
> course, use a different tracing mechanism than ftrace).

Right, that's exactly what the ESX trace did as well.

> > Perhaps we can update trace-cmd agent to work with
> > Xen as well. Does xen implement vsock or some other way to
> > communicate
> > between the guests and the Dom0 kernel? 
> >  
> Not vsock, AFAIK. But we probably can use something else/come up with
> something new.
> 

Yeah, we would like to have trace-cmd agent work with more than just vsock.
Heck, we could just use networking as well. It's just a bit more overhead.


> > And then on KernelShark,
> > we have a KVM plugin in development that does this. But you can do
> > the same
> > with Xen.
> >   
> I think that one of the trickiest aspects would be synchronizing the
> timestamps in the 3 traces.
> 
> *I guess* that the dom0 trace and the guest traces could at least use
> the PTP algorithm that is currently implemented in the trace-cmd
> patches (but not KVM specific one). For synch'ing the Xen trace with
> them, well, I don't really know... We'd have to think about it. :-P

Really, TSC is the way to go. All you would need to do is to have a way to
map all the TSCs together. Assuming the xen trace has a unmodified TSC, and
you can retrieve all the multipliers and shifts used for each guest, you
then will have a synchronized TSC. Then only one guest or the xen HV needs
to calculate the TSC to nanoseconds, and then have all use that. Probably
would need to be the xen HV as it would be the one without a modified TSC.

-- Steve
