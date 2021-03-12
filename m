Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F20C433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Mar 2021 13:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F10E64FF5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Mar 2021 13:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbhCLNDg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Mar 2021 08:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbhCLNDF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Mar 2021 08:03:05 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32CAC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Mar 2021 05:03:04 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id c10so53114635ejx.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Mar 2021 05:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GIj+NHB5cl/XvVneyOHUIM8LUy4woLPBC/u8KdOhflQ=;
        b=BuNQyXuAvwgdO2Z3tjtbBIbPyRWzp+Cdfp3i6yqDXPQ6StE830fiRGBJ+KrfqbjrmG
         Bft5PNkYoRgbXourizcvnL/rUtch9v1eZA7iAvcv5BSUl97bAHYVOaQ2ZrE7ry9eqy/5
         GxEBkwwWwuGqvZme/URmDsmUIS7FvZh8Evyw0BdNZvArI+KAnfPnDtK6yz3rqUxareW3
         PZ1se4yuyzgkXs5Aa4ptYejiolJ99GxNfsm2cZU3qfKTxxnWqucAKzQQ0wl7ih9zNg2Q
         KhtGz9dqap2lrfs+96K7vDQA18neV62QJIcelk2X4hfUTeR+Pmk0hESeUjKH5/xUJu6H
         Roow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GIj+NHB5cl/XvVneyOHUIM8LUy4woLPBC/u8KdOhflQ=;
        b=hTtT01JjN1tUbodOr0iFapYkfyRjfBVtLD2zvQ2VgQ86x9xcvDzN+Y+5XBUjVAVwVT
         QMXg5rUmRvFALHc1Owab0v09UhHEuyUGN/XpDCjrbCuzVSEugm7AT+gHSgqBKWx9w3H7
         CL1apPXWSHrYSCCSnHPIK6aEx5H4vhVk+FJoSHp/AgUeLd9UHy3Q84U6OvmY6eD4IEp/
         5ZE2XPGFNIzf+CIY1lrFuG6P+Pb9+N7CBFUEfn8mDsTfJQAI4WuE2ZKd7przyV3F/k0y
         f4F0ReBPZYzgL8d7xoAsmssi0VAEFnIatNynYIipqrtGuFS3TDnYEeDW5TRLLVf9Lg4t
         0/Eg==
X-Gm-Message-State: AOAM5331bbOQn31HuajczE97iwIcBvMr0FObtSfjitXGDc/Kv2r8zioa
        kWB8Bw/RKxQu/ojNxDJdLqrQh//Yor4dag==
X-Google-Smtp-Source: ABdhPJyhygCEZYDtu1iU+oyMJHZqsOZnu4Y2DQIpXwTUdHaf2fMdWYrUarckIeuyjhqDJiErCT3lyA==
X-Received: by 2002:a17:907:7651:: with SMTP id kj17mr8485909ejc.127.1615554183192;
        Fri, 12 Mar 2021 05:03:03 -0800 (PST)
Received: from [192.168.0.108] ([84.40.73.174])
        by smtp.gmail.com with ESMTPSA id o1sm2876794eds.26.2021.03.12.05.03.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 05:03:02 -0800 (PST)
Subject: Re: [PATCH v2] kernel-shark: Do not hardcode /usr prefix for polkit
 policies
To:     Dario Faggioli <dfaggioli@suse.com>,
        Michal Sojka <michal.sojka@cvut.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <87mtv97nlj.fsf@steelpick.2x.cz>
 <20210311145059.27147-1-michal.sojka@cvut.cz>
 <cf3243d3-65e0-18cd-0a20-81739552c105@gmail.com>
 <87k0qd7evn.fsf@steelpick.2x.cz>
 <1aaeb84b-2820-0818-4ab6-fcfd7b5fa52c@gmail.com>
 <58b5888bfe22ee3825362492fab34fe3d0d493d9.camel@suse.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <f0289bb7-1c80-bb6a-9f66-6cb08563ffa7@gmail.com>
Date:   Fri, 12 Mar 2021 15:02:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <58b5888bfe22ee3825362492fab34fe3d0d493d9.camel@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Dario and Michal,

On 12.03.21 г. 13:47, Dario Faggioli wrote:
> On Fri, 2021-03-12 at 08:46 +0200, Yordan Karadzhov (VMware) wrote:
>> Hi Michal,
>>
> Hey Michal! Nice to see you here too... well, it's a small world, I
> guess? :-P
> 
>> On 11.03.21 г. 19:57, Michal Sojka wrote:
>>> You're right. I looked at polkit sources and it really seems that
>>> only
>>> one location is supported. It is determined at configuration time
>>> so on
>>> some systems it may be different from /usr/share/... I'm talking
>>> specifically about NixOS, but it already has the patch I sent.
>>>
>>> So I leave it up to you whether to apply the patch or not. I think
>>> that
>>> supporting seamless installation into $HOME is useful if one wants
>>> to
>>> quickly use a newer version not available in their distribution.
>>
>> Building, installing as root and testing the latest version shouldn't
>> cause any problems/conflicts on your system. Note that there is a
>> script
>> in kernel-shark/build called "cmake_uninstall.sh". It is guaranteed
>> that
>> this script removes every single file that has been installed.
>>
> Not completely sure, but since NixOS is being mentioned, I think at
> least part of the point here is  making sure that a development/testing
> version of KS can be installed in those "special" systems that have
> read-only filesystems (or similar configurations).
> 
> In such a system, even if you are root, if the makefile tries to put
> stuff in a part of the fs which is not writable, it's pretty much
> game-over.
> 
> In fact, I don't know much about NixOS, but I'm on one of those
> "immutable" systems myself (openSUSE MicroOS, FTR) so I can relate. :-)

OK, now I see your problem. Please excuse my ignorance.

Here's the deal. What you want can be achieved with an almost trivial 
patch in kernelshark 2. Have a look here:

https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/tree/src/CMakeLists.txt#n129

and make the installation of the policy file to be a separate component.
Make the installation of "kshark-su-record" part of the new component as 
well since it relies on the policy file. I guess "kernelshark.desktop" 
must be there as well.

Then you can edit the helper script "install_gui.sh" and make it install 
your new component as well. You can also add another helper script that 
install only the part you want. Send me a patch and I will take it.

Thanks!
Yordan

> So, although it's definitely a niche use-case (for now!! :-P), I think
> that either this patch, or at least not making the above issue fatal
> (as you're saying yourself) would make the life of some users easier.
> 
> Regards
> 
