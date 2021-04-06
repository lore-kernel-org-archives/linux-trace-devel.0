Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CE8C433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 20:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CEF9613D5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 20:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245534AbhDFUmz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 16:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235692AbhDFUmy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 16:42:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61A2461369;
        Tue,  6 Apr 2021 20:42:46 +0000 (UTC)
Date:   Tue, 6 Apr 2021 16:42:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <Viktor.Rosendahl@bmw.de>
Cc:     <linux-trace-devel@vger.kernel.org>
Subject: Re: Adding latency tracking to trace-cmd
Message-ID: <20210406164244.602df538@gandalf.local.home>
In-Reply-To: <c85bd8239b17619cac002c3d4d820ec0d46a2362.camel@bmw.de>
References: <20210224115408.1c76ee3f@gandalf.local.home>
        <e1c4952249578eea44817d092bffe27fd0e47645.camel@bmw.de>
        <20210406133806.0f3ab414@gandalf.local.home>
        <c85bd8239b17619cac002c3d4d820ec0d46a2362.camel@bmw.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 6 Apr 2021 20:03:46 +0000
<Viktor.Rosendahl@bmw.de> wrote:

> Hi Steve,
> 
> The management was agreeable to it but I haven't had any spare time to work on
> it. 

Awesome.

> 
> To be honest, I could have worked on it during my Easter holidays but I just
> happened to busy myself with other private interests :)

I wouldn't expect you to use your Easter holidays on this anyway ;-)

I was just clearing out my INBOX and noticed that it's been a while, and
decided to ping you so we don't forget.

>> > > 
> > > Would you allow the hackish random algorithm to be used in trace-cmd?
> > > I mean the "--random" option in latency-collector.
> > >   
> > 
> > If you feel it is useful, sure. Although a definition of what it exactly
> > does needs to be a bit more explained. I'm not really sure what use the
> > --random option is for the latency tracer.
> >   
> 
> The usefulness lies in the case where you have latencies that systematically
> occur very close to each other.

[..]

> 
> Without the --random option, I would at this point need to start another test
> campaign, only then would I start seeing the longer latencies from bar().
> 
> On the other hand, if I use the --random option with the latency-collector, then
> what will happen is that sometimes the latency-collector will open the trace
> file immediately and other times it will sleep and wait for up to one second
> before doing so. If it opens the file immediately, we will get the first
> latency. If based on that random toin coss function decides to sleep, then we
> will get the second.
> 
> If a long test camaping is exectuted, and foobar() is called several times
> during that campaign, then there is a good probability that we will capture both
> the latency from foo() and the one from bar().
> Now --random is a bit more complicated because it actually tosses the coin again
> if another latency occurs when it is sleeping before opening the file. The
> probability of that coin toss function are chosen so that if we assume that
> there is a maximum of N closely occuring latencies, we will get each of them
> with probability 1/N. If the latency-collector detects a situation were it
> actually has detected N closely occuring latencies, it will automatically
> increase N to N + 1 and update the probablities of the coin toss accordingly.
> 
> So basically the idea is that by acting randomly, we will not systematically
> lose a particular latency. It will also not make matters worse if we never get
> latencies that occur close to each other; the only drawback is that we sometimes
> wait for one second before opening the trace file and that doesn't really matter
> if there aren't any closely occuring latencies.


Hmm, sounds more like "--various" would be better than "--random". Just
because it appears you wont to try different timings. Having a --random
option just doesn't sound like it's what you expect it to be.

There's already a "-s" option that takes a sleep interval between wakeups,
which sounds similar to what you have. Perhaps we can make "-1" a special
value to do the "random" wakeup thing. "0" is already special to make it
wake up when it detects data in the buffer.

-- Steve
