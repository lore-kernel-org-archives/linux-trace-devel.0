Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FFAC433C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 18:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C76A761A2C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 18:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCYSBo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 14:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhCYSBS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 14:01:18 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A12C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 11:01:18 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id o16so3257137wrn.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Mar 2021 11:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=mhw+BEkVcca1d9o9U9z12eSChGBA041ti1j2u0RXVa0=;
        b=Fdo7k0p4pIlgLa/6jDUnOKKUnb2LyXq9z44Jbzq+EySTGsBj93WzCsEYSDNfDxJ2i3
         oLE1UymHgnDfpSsFbowtBaIYJfI7HVdSoowLKIeXazwEjif0sHdJvDJEZigxQB1/WIB8
         BhyYQSsGadbGRNW97ywSu2Vni0d8pCmqFF1rKOXLyCSJYXELQ2pU6WE7sMbkbI1e7lrG
         yscU7L6huN5zBVrHxO1GQNuqbvZFUm4x5e/qZcAM5p9Wya/tDwyTu0sFmLtwJjkTO713
         Hj8omdsMKw8sWTgaokF3J0X03rgmkugO+uA+CK2MjBVTIhkxhzf+GnyiESR2F2z3txeM
         0ecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mhw+BEkVcca1d9o9U9z12eSChGBA041ti1j2u0RXVa0=;
        b=LGPhAekAkXGEWUEziJUNgE5fXDfhGXGnjUkwoduqRih0ghCdsrOBM1nCdDhH2aGXSb
         Iwodydou4152hSXFuKtlHwoUlCEdhLb61k7NGC9doytavtoczmyfVTUI6AQgo48T6Akx
         JP3K9ZlrBmzb8RZvUsnj4LyrpZVTt39mAKdijOTTJbbq1nI6gGacTSEeTR//ymfD5lTh
         SZ3AjCp3xv+CuXcroWru/d8Hucr0+YhMpr8u7eXErhg1JgEYHLf38pbYtd4/ogU8xhUb
         TbPZZwrlJcay5tdzCqZaEuwS+SrYPw1BdNGl6QN0aOfW+mWAgN39dOSycu0YEuV2e6gS
         g/wA==
X-Gm-Message-State: AOAM532+8IQFiVvpp8GhY3QVkKRnP0CIYb2S9kUk3MwLrfv7YBnzCtoG
        Ii2EgTksWE/nohsAwbvHDbs=
X-Google-Smtp-Source: ABdhPJy39QR9V7zbgUWTey5fLvxOdP2AfDOOwxcCQmk2b9tBDRifV1EBYaE/Vx2RX0YBorAmVKWMPQ==
X-Received: by 2002:a5d:6b50:: with SMTP id x16mr10097689wrw.379.1616695273659;
        Thu, 25 Mar 2021 11:01:13 -0700 (PDT)
Received: from localhost.localdomain ([151.32.63.15])
        by smtp.gmail.com with ESMTPSA id k24sm6998628wmr.48.2021.03.25.11.01.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 11:01:13 -0700 (PDT)
Subject: Re: [PATCH v32 0/5]Timestamp synchronization of host - guest tracing
 session
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Dario Faggioli <dfaggioli@suse.com>
References: <20210315061857.168570-1-tz.stoyanov@gmail.com>
 <6796a75b-6a59-767f-08ec-ee0cbfd8c825@gmail.com>
 <CAPpZLN6LJWV_=BB5FgQOkN+SZt3dOeYjzqZVZ-FC4JTva8zn_Q@mail.gmail.com>
 <80486620-fe8f-49a5-cdac-05bb2b969984@gmail.com>
 <CAPpZLN4yn2qn7uqNLqkxdnHfM_5SdtkjPY41atY5m-FPG3rudA@mail.gmail.com>
 <0f6e158c-43a3-4117-2a17-5a13cd6a7970@gmail.com>
 <CAPpZLN5HcuFnN9_gMnS=JKeu3p9dEUWHmF6iwoh-mLPz=6WaiQ@mail.gmail.com>
From:   Stefano De Venuto <stefano.devenuto99@gmail.com>
Message-ID: <f40089f0-a45d-5e8d-e0e6-5f7ab59c9992@gmail.com>
Date:   Thu, 25 Mar 2021 19:01:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAPpZLN5HcuFnN9_gMnS=JKeu3p9dEUWHmF6iwoh-mLPz=6WaiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 3/25/21 8:20 AM, Tzvetomir Stoyanov wrote:
> Hi Stefano,
>
> On Sat, Mar 20, 2021 at 6:17 PM Stefano De Venuto
> <stefano.devenuto99@gmail.com> wrote:
>>
>>
>> On 3/20/21 7:25 AM, Tzvetomir Stoyanov wrote:
>>> Hi Stefano,
>>>
>>> On Fri, Mar 19, 2021 at 7:44 PM Stefano De Venuto
>>> <stefano.devenuto99@gmail.com> wrote:
>>>>
>>>> On 3/19/21 12:55 PM, Tzvetomir Stoyanov wrote:
>>>>> Hi Stefano,
>>>>>
>>>>> On Fri, Mar 19, 2021 at 12:08 PM Stefano De Venuto
>>>>> <stefano.devenuto99@gmail.com> wrote:
>>>> Hi!
>>>>>> The commands used to record are:
>>>>>>
>>>>>> Host:
>>>>>> # trace-cmd record -C x86-tsc -e kvm:* -e msr:* -A tumbleweed:823 -e
>>>>>> msr:* -C x86-tsc sleep 1
>>>>> The guest trace clock is set automatically as the host, so this
>>>>> command should be enough:
>>>>> # trace-cmd record -C x86-tsc -e kvm:* -e msr:* -A tumbleweed:823 -e
>>>>> msr:*  sleep 1
>>>>>
>>>>>> Guest:
>>>>>> # echo x86-tsc > /sys/kernel/tracing/trace_clock
>>>>> There is no need to set manually the guest clock, it will be
>>>>> overwritten by trace-cmd agent.
>>>>>
>>>> Thanks so much for the proper way to do it, really appreciated.
>>>>>> If necessary, I can provide more info about my setup, or do more tests.
>>>>> Yes, please can you send me both host and guest trace files ?
>>>> Here are the trace files, host and guest respectively:
>>>>
>>>> - http://xenbits.xen.org/people/dariof/tracing-examples/kvm/sync-kvmclock/trace.dat
>>>> - http://xenbits.xen.org/people/dariof/tracing-examples/kvm/sync-kvmclock/trace-tumbleweed.dat
>>>>
>>>>> Also, it will be useful to send me the content of the KVM debug files:
>>>>>     /sys/kernel/debug/kvm/<guest ID>/vcpu<*>/tsc-offset
>>>> The guest has one vcpu (vcpu0) and the content of the file is:
>>>>
>>>> 255647917761327
>>> Looks like there is a scaling between host and guest clocks in your
>>> setup, not just a simple offset. We did not test yet our
>>> implementation with scaling, although both offset and scaling are part
>>> of the calculations. That makes your use case very valuable for us, as
>>> we have an opportunity to test it now. And yes, looks like we have a
>>> bug here.
>>> Please, when you have time, can you repeat again the tracing session
>>> and send again both trace files + the content of the KVM debug files:
>>>      /sys/kernel/debug/kvm/<guest ID>/vcpu0/tsc-offset
>>>      /sys/kernel/debug/kvm/<guest ID>/vcpu0/tsc-scaling-ratio
>>> I'm asking to do a new trace, as most probably these offset and
>>> scaling could be different now.
>> Yes, the trace files are attached to this mail.
>>
>> The content of tsc-offset is:
>> 453568564244284
>>
>> The content of tsc-scaling-ratio is:
>> 4294967296
>>
> Just submitted the v33 of the patch set, added a check for a
> non-default KVM scaling. Now it should work on your setup, as the KVM
> scaling there looks to be the default. I didn't test it, as we have no
> machine which supports KVM scaling. This is just a workaround, we have
> to implement support to KVM scaling in our algorithm.
> Please, can you test if it is OK ? Note, you have to apply  these
> patch sets also, as there are dependencies:
>    v2 Refactoring and improvements of time sync logic
>    v4 TSC trace clock to nanosecond conversion
>
> Thanks for testing this code!
I tested the patch series and now works properly on my setup!

Thanks,
Stefano
>
>> Thanks and Regards,
>>
>> Stefano
>>
>>> Thanks!
>>>
>>>>>> Thanks and Regards,
>>>>>>
>>>>>> Stefano
>>>>> Thanks for testing this code!
>>>>>
>>>> Thanks for your time,
>>>>
>>>> Stefano
>>>
>

