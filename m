Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DEEC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF27461181
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbhDHVRm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 17:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231862AbhDHVRm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 17:17:42 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72ABE61181;
        Thu,  8 Apr 2021 21:17:30 +0000 (UTC)
Date:   Thu, 8 Apr 2021 17:17:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Viktor Rosendahl <viktor.rosendahl@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: Adding latency tracking to trace-cmd
Message-ID: <20210408171728.5e2c0f3f@gandalf.local.home>
In-Reply-To: <2b107e3e-ea62-919f-dcbb-3c324f709806@gmail.com>
References: <20210224115408.1c76ee3f@gandalf.local.home>
        <e1c4952249578eea44817d092bffe27fd0e47645.camel@bmw.de>
        <20210406133806.0f3ab414@gandalf.local.home>
        <c85bd8239b17619cac002c3d4d820ec0d46a2362.camel@bmw.de>
        <20210406164244.602df538@gandalf.local.home>
        <2b107e3e-ea62-919f-dcbb-3c324f709806@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 8 Apr 2021 23:01:53 +0200
Viktor Rosendahl <viktor.rosendahl@gmail.com> wrote:

>  > Hmm, sounds more like "--various" would be better than "--random". Just
>  > because it appears you wont to try different timings. Having a --random
>  > option just doesn't sound like it's what you expect it to be.
>  >  
> 
> I guess that you are right that with --random many people may assume the 
> sleep time to be random. Perhaps --dizzy-sleep or --arbitrary-sleep 
> would be better?

I think "--various-sleep" may be better. Note, I'm currently doing my
income taxes, and when you sell a bunch of stocks that you bought at
different times, for the date, you enter "various". Which is why that word
is in my head ;-)

> 
> For the latency-collector, I used the name --random because the behavior 
> is based on the lrand48_r() call, seeded by /dev/urandom. In my thinking 
> it's the sleeping behavior that is random, not the sleep time.
> 
> I guess that a mathematical purist may say that the behavior is 
> arbitrary rather than random, because if the value N is different from 
> two, then there are unequal probabilities between the two choices.
> 
> At first when I developed the latency-collector, I thought that using a 
> random sleep time would be the right approach but I came to the 
> conclusion that it is not a good idea.
> 
> If we have the case with a burst of two latencies, where the first one 
> is 5 ms, , then if we for example sleep randomly between 0 and 500 ms, 
> we will only have a 1% chance to get the first latency. If we use the 
> random algorithm from the latency-collector, with N=2, then we have 50% 
> chance, which is much better. Even if we would have been paranoid to 
> initialize with N=5, in order to prepare for bursts sizes of up to 5, 
> then we would still have a 20% chance.
> 
> If we have a random sleep time then we would need to make assumptions on 
> how long the latencies are and how much time there is between them, and 
> there is no way to guess that beforehand.
> 
> With the random behavior, we only need to make an assumption about how 
> many latencies there are going to be in a burst, which is the value N. 
> This is also impossible to know with certainty but we can make some 
> educated guess about it. Also, as I already mentioned, if the 
> latency-collector ever encounters N latencies in a burst, then it will 
> automatically increment N.
> 
>  > There's already a "-s" option that takes a sleep interval between   
> wakeups,
>  > which sounds similar to what you have. Perhaps we can make "-1" a special
>  > value to do the "random" wakeup thing. "0" is already special to make it
>  > wake up when it detects data in the buffer.
>  >  
> 
> To me "-s -1" feels a bit too cryptic and non-descriptive. Also, I 
> wonder how many would read the description of the -s option carefully 
> enough to notice it.

It really comes to how well we make our documentation, and I want to create
a tutorial for most common operations. When there's good documentation (and
a simple and quick tutorial) cryptic solutions like the above can be useful.

> 
> On the other hand, trace-cmd record seems to already use most of the 
> alphabet as short options.

Yeah, it has suffered that :-/

> 
> Do you think it could be acceptable to add a new long option, such as 
> --dizzy-sleep?

I'm not really sure what you mean by "dizzy-sleep". To me, that means it is
unbalanced and not stable.

Where as --various-sleep is pretty much exactly what it is. It sleeps for
various amounts of time.

-- Steve
