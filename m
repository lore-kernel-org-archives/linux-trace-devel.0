Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9222C433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 11:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81C0964E3B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 11:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhBJLYN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Feb 2021 06:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhBJLVv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Feb 2021 06:21:51 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECBCC0613D6
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Feb 2021 03:21:11 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id i9so1516829wmq.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Feb 2021 03:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pZ2lOhhp7f49tVbAR+Dtsh5OoXbTNMSyeigjok338EE=;
        b=MfzakXwxt4AJwUDYIVb3ykWWpSDBD/cMkBlJLEaBTBjdOowcoRv30y0TL9eTVRKgWC
         vec8Cp8U/aQslzc6V9f4t9E1DjdkqcJTp77w0vB9MwanIe2ks8BOx0QE4oVxQkxwY9E1
         III3UZWf6LrgZILb+nPattMu2tRRxXMyDWayOjHV6qD1ARWyG5tDW01epRbH5mHOTM/k
         3YDQaIE3TupLll4+t3QNwYNcR0qlIaGteLXcWfFvHJZlkaOVvQxeiy54qKWMWinxCpke
         J7EWmItlqbrBaZKtiKQLI6skD4H9jlpeq3V/T72YuvtkNq7jlV9kK9V+e11f7zgx963P
         7XQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pZ2lOhhp7f49tVbAR+Dtsh5OoXbTNMSyeigjok338EE=;
        b=M+TeARdArR5Re+9uz5tuZqTrlBjJvHonMXwh9Ac5/hVIlac5qzrxWSiima3DrfdDQ5
         B9ryzSJwaD2aPNI2zrOpq1sKKW9MCIGUJzfOj6UL40FrFLBIp3sbeLkHa1oFDChomRqb
         r530ke/r2baYDhvcLbpaVGbOXbVxOWFTFxOUcQa/1hAkCE9RiLM2W9k87w4av92TLeqd
         d8zBRkWVtcAXEwumjB/F2fxiS1QbL5IDE526zCxXHWscBtuBSpEKVdI/bR1S6HPR+pkT
         pTy7T3zSv9wG1oZ0N4lY1voMdO/FUYxWM0x5Qb4Y2GEMGzO36lFh1KtVRC9tmnqFwBmF
         BqEw==
X-Gm-Message-State: AOAM530hjGZiTJOS1d+OH6tclp/gQ428y3ameEYlU17wlVuhy8UlSr0G
        i8kJxxldiIPbW5JAQX73ui9MOXcw2n4=
X-Google-Smtp-Source: ABdhPJzUI4XIRYTh4EWkV1K5fsSqIEhbUDutJY3UMEWLBohI8WSU9VZPHm+o+n+KlO+NunY47ZZIkg==
X-Received: by 2002:a1c:1f4d:: with SMTP id f74mr2514718wmf.133.1612956069949;
        Wed, 10 Feb 2021 03:21:09 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id g62sm2014483wmf.46.2021.02.10.03.21.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 03:21:09 -0800 (PST)
Subject: Re: Kernelshark v2 all-black plots area
To:     Dario Faggioli <dfaggioli@suse.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <89dbef38a1050c31390ce263d51fff1f72a42164.camel@suse.com>
 <ce06b82f-6335-4653-0d27-e48a37ffb5aa@gmail.com>
 <e07be2e367576882d0cf84c33834ecafaba38136.camel@suse.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <38b5ea14-cea2-1268-13ef-539fe421e442@gmail.com>
Date:   Wed, 10 Feb 2021 13:21:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e07be2e367576882d0cf84c33834ecafaba38136.camel@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Dario,

On 9.02.21 г. 18:13 ч., Dario Faggioli wrote:
> Indeed it does, thanks a lot again.
> 
> Now, if I try "KVM Combo Plot":
> - I still see super weird results if I use the KVM clock from last
>    patch in Tzvetomir series (but I guess I'll report it there).

Can you share a screenshot of the one that looks weird. And please do 
some deeper zooming because it is very hard to judge about the quality 
of the sync from such a broad time window.

> - If I use PTP, that kind of works.
> 
> If I trace a `sleep 1` on the host, the result is like this:
> 
> http://xenbits.xen.org/people/dariof/kernelshark-v2-ptp.png

Is this a PTP synchronization?

> 
> So, there is ~ 1 sec of data from the guest, coming from trace-cmd
> agent. The host, however, went on and traced a little bit longer, even
> after closing the connection. It's not too terrible, I'm just curious
> whether this is known or it's something weird and it's only me seeing
> it.

I think this is normal.

But anyway Ceco (Tzvetomir) is the right person to answer questions 
about the timestamp synchronization. Unfortunately he is on vacation 
till the end of the week.

Thanks a lot!
Yordan

> 
> Evaluating the correctness and the accuracy of the synchronization is a
> little bit of a challenge, especially for me that I'm not used to it.
> And, at least in part, because I still don't have this change in the
> kernel I'm using right now, so some kvm_entry trace points are not
> recorded, which means it's tricky pairing VMEntries and VMExits:
> 
> https://lore.kernel.org/lkml/160873470698.11652.13483635328769030605.stgit@Wayrath/
> 
> It should come with 5.11, but I think I'll quickly apply it to the 5.10
> that I'm running, to try to understand better hat's going on.
