Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F910C5519F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 12:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8F8B2151B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 12:33:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RGAmygTc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgKTMdD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 07:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgKTMdD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 07:33:03 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895E0C0613CF
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 04:33:01 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id a16so12652844ejj.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 04:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/IwEIXyQRfNhSWUyQNSSdreI9FpREPjJEx1BkA1A9Sw=;
        b=RGAmygTccsMgkStvkb3oj3kRqfpDWKsAhzO9Q6o48Ky0IFXYJVuu/PNxWDQHHJV+0T
         M37OesAcBtm1zMssW6qmc4lI1n6Yybd8iqL6WH5GE71z9Kttjpfs+Rn+HGMu8/INViI5
         W1ioxMk9kFbhZPvYoN1memlZKS3JOpsNM5O39ZMss0P8c6JmhWaEZtZgrbxR+ONsy5wa
         kzpSXMuUlLk0pUeOCEbipTwWeFIjo2bW9OFQ9jovADVxdLxlaRd0I6h5lZTsFRTcsnxj
         xMdchUMZ6pRLR5KSpo4pOYDUGh/idhLC74IpXJ5NFc1YyXW7FNiKIGS9ptXqfP2vdoQG
         mw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/IwEIXyQRfNhSWUyQNSSdreI9FpREPjJEx1BkA1A9Sw=;
        b=ROx+6bY9I3l0N0epoElSynPXFczN0DJHD2NJQa0ljkfOv2BKe3ag/PL0u6TdFBTDdv
         0790cWiIk+z6ceJkfNOHPm22IZAjqarfJCHTBCbbS4P0T6ZThRf0Vjl7srTi2UXBmHG/
         vXh0GpAfXFH2Mc5uszRut57hw74RWsN7DKmKZjT043IGpbJ9U/j6U1LG3biFDSZ0vFoL
         D0vc8OS66AH1cG01kIuPRJWHaYZ3BaeaCwv3igNadqMp92ooam9kG9oLpfI8oIkfkpMN
         qhnvyaW/A8iiJsKXGqTkoVMarsG2TI/Tpd7YEhn38uofHjJCI9d+ZgJHirLGnLU8i8PQ
         /wDg==
X-Gm-Message-State: AOAM532BdYL6mBbGP0WuZvA+XhJgd2VGhGs+TMuwCJcAEnJMhkFJOgqC
        xGYTReSsizV1eOQ0dYuo9loQokGZ0Cg=
X-Google-Smtp-Source: ABdhPJwmPDGE43VwpCMCO+dKuQIsTQt+3vqg5PIRV0z3GIyA9GkG+x4Uu/Igih7uGfexihQTFm8IUg==
X-Received: by 2002:a17:906:174f:: with SMTP id d15mr16890811eje.15.1605875580125;
        Fri, 20 Nov 2020 04:33:00 -0800 (PST)
Received: from [192.168.0.108] ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id ba7sm255082edb.55.2020.11.20.04.32.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 04:32:59 -0800 (PST)
Subject: Re: [PATCH] Fix `make -jN trace-cmd gui`
To:     Dario Faggioli <dfaggioli@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <160564780533.18208.2518938894299815863.stgit@toolbox-dario-user-work>
 <20201119220910.1a8ec625@oasis.local.home>
 <64d58c3297d6915362678c5799bd3d363489bda3.camel@suse.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <02672da2-8b62-a573-786d-1cb8f5970e85@gmail.com>
Date:   Fri, 20 Nov 2020 14:32:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <64d58c3297d6915362678c5799bd3d363489bda3.camel@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 20.11.20 г. 14:06 ч., Dario Faggioli wrote:
> On Thu, 2020-11-19 at 22:09 -0500, Steven Rostedt wrote:
>> On Tue, 17 Nov 2020 21:16:45 +0000
>> Dario Faggioli <dfaggioli@suse.com> wrote:
>>>
>>> Signed-off-by: Dario Faggioli <dfaggioli@suse.com>
>>
>> Thanks Dario,
>>
> Hi!
> 
>> I applied it.
>>
> Great! Thanks... This will help me, because I want to do:
> 
>    %build
>    make %{?_smp_mflags} prefix=%{_prefix} trace-cmd gui
> 
> in the openSUSE package for KernelShark (see the spec file here:
> https://build.opensuse.org/package/show/openSUSE:Factory/kernelshark )
> which is now packaging version 1.2
> 
>> But note, we will be releasing kernelshark soon in its
>> own repository (a new and improved version!)
>>
> Yep, sure! I did followed the talks you've been giving about it at
> events, and I even played a little with what you have here:
> 
> https://github.com/yordan-karadzhov/kernel-shark-2.alpha
> 
> The host-guest tracing part, as I think you can guess.

Ciao Dario,
I am very happy to hear that. The timestamp synchronization patches for 
trace-cmd are almost ready to go upstream.

And we are currently reviewing a beta version of KernelShark_2 that will 
include the guest/host visualization.
As Steven said: stay tuned!

cheers,
Yordan

> 
>> Stay tuned!
>>
> Looking forward to it!
> 
> Thanks again and Regards
> 
