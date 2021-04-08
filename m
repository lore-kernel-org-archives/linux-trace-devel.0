Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71CD8C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48D8F61181
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhDHVCJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 17:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhDHVCI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 17:02:08 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03533C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 14:01:57 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id f12so3572360wro.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 14:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=edXy5kqjb06Wo5Bbn9vZ0DzbMEFzmJTnMyzQBnNoGWE=;
        b=NFck+tfjoACX1K2yt1KE3v7k8roZdHZLiv93fabB2Hp8t8YXJWv+yGkkz52JPnoPix
         S19e4K4GYovhs7vg51FE17M0XTn/na0gQ6n1AihcS7kASTYqtYg1yAEVP6zQ1hWospuT
         bIAnQSinPmYHHCbQOsrrj1w7nSLN06gYAZmyoNJc+rjgiaH4eq8YXG2RERXyHzXmmV9h
         pCaUFB09P+R49GlPeS9SJPmJ9B9zX5yGONGsiLK1IzKZXVPTTnEajUAlQUJLM18Yg4sn
         9GOEMgj4iKEBv9jtuSiG+ZP2pYNw6tyq5xTFDVhlC5Jrgq98m9noAq0XYcSZ+L2ffF7R
         iWMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=edXy5kqjb06Wo5Bbn9vZ0DzbMEFzmJTnMyzQBnNoGWE=;
        b=Jm3paJt9p6kgkyskjs9wQyLAuuhf18vYTQff/wIe31pXGHVCmC9C2ajhfKykDuRRp9
         +kVJnnn0pb652UyS3gIJJojVLmzFTW6UGo3WMQCLwNCPnQlJGLX+q+UU/CjGerAk1lzA
         RMyN3CJGfXsS9BUvWCLKejqnvIO+l/xf7iCjUxNZT035PpEoEJoWeQZwdesGEgW5JwMN
         a13B7Uuvwxr8U9ac201zDuuI2RSRnVY4vfc7aSaTvy4SkpsBQsJUwMMY+vkYIedYbHMH
         CpB+rwykiLXFOq4F5XRtXhD0Ir80bu0/Lx9cyJHU+gqZZGh7j3udt83MLOfBjVVtEyNm
         8xUA==
X-Gm-Message-State: AOAM533bx7eZb0LEr202SZfc5G/kD7KUZDCrI9u4bkXSQJhb0JgZKOId
        OHum+2Csxo+t7irsq5luwscN78xltneB
X-Google-Smtp-Source: ABdhPJxENyxcJnSWXfPRpi14BJ/s4ZrVgC/MdjokjUpbQLbry2LOHdXCznE2XV7H2hcmHiGb6WkFCQ==
X-Received: by 2002:a05:6000:544:: with SMTP id b4mr14599054wrf.352.1617915715703;
        Thu, 08 Apr 2021 14:01:55 -0700 (PDT)
Received: from [192.168.1.99] (i5C75AE09.versanet.de. [92.117.174.9])
        by smtp.googlemail.com with ESMTPSA id k131sm553834wmf.39.2021.04.08.14.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 14:01:55 -0700 (PDT)
Subject: Re: Adding latency tracking to trace-cmd
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210224115408.1c76ee3f@gandalf.local.home>
 <e1c4952249578eea44817d092bffe27fd0e47645.camel@bmw.de>
 <20210406133806.0f3ab414@gandalf.local.home>
 <c85bd8239b17619cac002c3d4d820ec0d46a2362.camel@bmw.de>
 <20210406164244.602df538@gandalf.local.home>
From:   Viktor Rosendahl <viktor.rosendahl@gmail.com>
Message-ID: <2b107e3e-ea62-919f-dcbb-3c324f709806@gmail.com>
Date:   Thu, 8 Apr 2021 23:01:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210406164244.602df538@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 2021-04-06 at 16:42 -0400, Steven Rostedt wrote:
 > On Tue, 6 Apr 2021 20:03:46 +0000
 > <Viktor.Rosendahl@bmw.de> wrote:
 >
<clip>
 > > Without the --random option, I would at this point need to start 
another
 > > test
 > > campaign, only then would I start seeing the longer latencies from 
bar().
 > >
 > > On the other hand, if I use the --random option with the 
latency-collector,
 > > then
 > > what will happen is that sometimes the latency-collector will open 
the trace
 > > file immediately and other times it will sleep and wait for up to 
one second
 > > before doing so. If it opens the file immediately, we will get the 
first
 > > latency. If based on that random toin coss function decides to 
sleep, then
 > > we
 > > will get the second.
 > >
 > > If a long test camaping is exectuted, and foobar() is called 
several times
 > > during that campaign, then there is a good probability that we will 
capture
 > > both
 > > the latency from foo() and the one from bar().
 > > Now --random is a bit more complicated because it actually tosses 
the coin
 > > again
 > > if another latency occurs when it is sleeping before opening the 
file. The
 > > probability of that coin toss function are chosen so that if we 
assume that
 > > there is a maximum of N closely occuring latencies, we will get 
each of them
 > > with probability 1/N. If the latency-collector detects a situation 
were it
 > > actually has detected N closely occuring latencies, it will 
automatically
 > > increase N to N + 1 and update the probablities of the coin toss
 > > accordingly.
 > >
 > > So basically the idea is that by acting randomly, we will not 
systematically
 > > lose a particular latency. It will also not make matters worse if 
we never
 > > get
 > > latencies that occur close to each other; the only drawback is that we
 > > sometimes
 > > wait for one second before opening the trace file and that doesn't 
really
 > > matter
 > > if there aren't any closely occuring latencies.
 >
 > Hmm, sounds more like "--various" would be better than "--random". Just
 > because it appears you wont to try different timings. Having a --random
 > option just doesn't sound like it's what you expect it to be.
 >

I guess that you are right that with --random many people may assume the 
sleep time to be random. Perhaps --dizzy-sleep or --arbitrary-sleep 
would be better?

For the latency-collector, I used the name --random because the behavior 
is based on the lrand48_r() call, seeded by /dev/urandom. In my thinking 
it's the sleeping behavior that is random, not the sleep time.

I guess that a mathematical purist may say that the behavior is 
arbitrary rather than random, because if the value N is different from 
two, then there are unequal probabilities between the two choices.

At first when I developed the latency-collector, I thought that using a 
random sleep time would be the right approach but I came to the 
conclusion that it is not a good idea.

If we have the case with a burst of two latencies, where the first one 
is 5 ms, , then if we for example sleep randomly between 0 and 500 ms, 
we will only have a 1% chance to get the first latency. If we use the 
random algorithm from the latency-collector, with N=2, then we have 50% 
chance, which is much better. Even if we would have been paranoid to 
initialize with N=5, in order to prepare for bursts sizes of up to 5, 
then we would still have a 20% chance.

If we have a random sleep time then we would need to make assumptions on 
how long the latencies are and how much time there is between them, and 
there is no way to guess that beforehand.

With the random behavior, we only need to make an assumption about how 
many latencies there are going to be in a burst, which is the value N. 
This is also impossible to know with certainty but we can make some 
educated guess about it. Also, as I already mentioned, if the 
latency-collector ever encounters N latencies in a burst, then it will 
automatically increment N.

 > There's already a "-s" option that takes a sleep interval between 
wakeups,
 > which sounds similar to what you have. Perhaps we can make "-1" a special
 > value to do the "random" wakeup thing. "0" is already special to make it
 > wake up when it detects data in the buffer.
 >

To me "-s -1" feels a bit too cryptic and non-descriptive. Also, I 
wonder how many would read the description of the -s option carefully 
enough to notice it.

On the other hand, trace-cmd record seems to already use most of the 
alphabet as short options.

Do you think it could be acceptable to add a new long option, such as 
--dizzy-sleep?

best regards,

Viktor



