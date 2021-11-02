Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C625AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 07:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A127360EB9
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 07:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhKBHqI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 03:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhKBHqH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 03:46:07 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4202C061714
        for <linux-trace-devel@vger.kernel.org>; Tue,  2 Nov 2021 00:43:32 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g14so10688419edz.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Nov 2021 00:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wLZU8LIRIPDAZCJBIjQGxwSd/kTec22YPD9k4nJZnOo=;
        b=kmMXGS0iVlAmWvHFyjTlAbnZU3HnDjSdDD93FHHANWQAA4GmzDQczruhP60hKjm58d
         M6mZ98UQaFMWh3oXf/NSUqOHNMql0SP9CHaevmrLxNtDZHKVkeG4M4z9pA7vDXA8+wAU
         Rm21FZS7TW9J3J3C4rBOJ5BYx+4jlzXpU41UZHWhg2W7fFLuqB9Pkgw2VKEc4J30xt39
         bHNdImOCGl6AWeadEz+/J2dnANTA722eLeeOhe2ttYWF5k2wAWg8cDC1XHpIMEweifks
         gYaq6r/C8aa78221mw6Qo1558fVL+jjEZwnXsQ5oWJlj0qpWDbQHJOQgmllou02n5fUS
         lPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wLZU8LIRIPDAZCJBIjQGxwSd/kTec22YPD9k4nJZnOo=;
        b=UbWMHjQIFy6LZkK0pi4QUlDCq82jXODRG0eMDnXWc4mN9fkXLdbbKKIMzsWJb3y4f0
         olNNcP9J4fNn4ou6gDT1ObwafGg3ImumLMzusr8SzgW13mMlrE414plr0LMlmJ2Fw8iF
         c9Nb0I9NWEAY3pB5pqx6bwtM9MnVOLsyQT47yopt2LSbL1XBG9VlZZxn9SmkEXtWAH0I
         +Tge7UiPlpGiEaaxa+hqw16lriEWcA+odbBVovV14aT4ElBuWKmg3ZoE1TofaY2GKDGT
         6r99zptQbL1RUyui2Ky8aSdcz7maYs4EuwwGai5+o25PhFmi1YSt++1sDEtpqKzRrsRv
         ZXEg==
X-Gm-Message-State: AOAM530WtseFxJSoMgsdiV5aYgnUeFm/xaCi/32zdbRavJVVZCRHWKrJ
        sMkzkFwDui7/5hRKQqxB5KoA0/gF9f/ABw==
X-Google-Smtp-Source: ABdhPJw7eV6+C0kgQ5HTEYHqP3xOsyX5MPU68B20+DbjUsqHa2bETaadCQjI10lohK09Nj2IyozCgg==
X-Received: by 2002:a05:6402:42cd:: with SMTP id i13mr49147932edc.396.1635839011261;
        Tue, 02 Nov 2021 00:43:31 -0700 (PDT)
Received: from [192.168.1.6] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id hc15sm7716552ejc.73.2021.11.02.00.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 00:43:30 -0700 (PDT)
Subject: Re: [PATCH v2 03/12] libtracefs: New kprobes APIs
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20211101090904.81454-1-tz.stoyanov@gmail.com>
 <20211101090904.81454-4-tz.stoyanov@gmail.com>
 <78703fa1-f811-a50c-6b5d-db68f6dbf21c@gmail.com>
 <CAPpZLN4iJvmz-_EZV0TY6cGTSDDf=6V7DVPEEUAOaMjsGyaoUA@mail.gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <98a9177a-a255-8d35-a647-943c31c316cd@gmail.com>
Date:   Tue, 2 Nov 2021 09:43:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAPpZLN4iJvmz-_EZV0TY6cGTSDDf=6V7DVPEEUAOaMjsGyaoUA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 2.11.21 г. 6:58, Tzvetomir Stoyanov wrote:
> On Mon, Nov 1, 2021 at 7:22 PM Yordan Karadzhov <y.karadz@gmail.com> wrote:
>>
>>
> [ ... ]
>>> +/**
>>> + * tracefs_kprobe_create - Create a kprobe or kretprobe in the system
>>> + * @kprobe: Pointer to a kprobe context, describing the probe
>>> + *
>>> + * Return 0 on success, or -1 on error.
>>> + */
>>> +int tracefs_kprobe_create(struct tracefs_dynevent *kprobe)
>>> +{
>>> +     return dynevent_create(kprobe);
>>> +}
>>> +
>>
>> hmm, what will happen if if you have a code like this:
>>
>>
>> struct tracefs_dynevent *synth = tracefs_synth_alloc(...)
>>
>> int ret = tracefs_kprobe_create(synth);
>>
>>
>> Are you just giving several additional fake names to the same function ('dynevent_create()')?
>>
>>
> 
> Yes, that will work. All dynamic events - kprobes, uprobes, eprobes
> and synthetic events have almost the same configuration logic, which
> is handled by these dynevent_... internal APIs. That makes the code
> more consistent and reusable.
> I see three possible approaches to handle that:
>   1. Create structures like that:
>        struct tracefs_kprobe {
>           struct tracefs_dynevent dynevent;
>        };
>     and use only that type in krpobe specific APIs:
>       int tracefs_kprobe_create(struct tracefs_kprobe *kprobe)
>       {
>           return dynevent_create(&kprobe->dynevent);
>       }
> 
> 2. Expose the dynevent_... APIs directly:
>      struct tracefs_dynevent *synth =
> tracefs_dynevent_alloc(TRACE_DYNEVENT_SYNTH, ...);

I would prefer taking this approach. It is OK to also have several helper constructors like tracefs_kprobe_alloc(), 
tracefs_synth_alloc(), etc. that will call internally dynevent_alloc().

In principle having multiple constructors is OK.


>      struct tracefs_dynevent *kprobe =
> tracefs_dynevent_alloc(TRACE_DYNEVENT_KPROBE, ...);
> 
>      ret = tracefs_dynevent_create(synth);
>      ret = tracefs_dynevent_create(kprobe);
> 

Yes, this is OK as well.

We only have a single type (struct tracefs_dynevent) so there must be a single create. And what is even more important: 
there must be ONLY ONE destructor.

Think about the usecase of the APIs. You create an object using one of the constructors. Later at some point you want to 
use the objects and after this finally you want to destroy it. If we have multiple/specialized "create" and "destroy" 
versions for the same object type, the user must somehow keep its own record of which constructor had been used trough 
the entire live of the object in order to know which is the proper destructor to call at the end.

Thanks!
Yordan


>   The problem here is that there are some small differences between
> dynamic events - some parameters are mandatory for one event and
> optional for another. That can be handled in the
> tracefs_dynevent_alloc() API, but could be confusing for the library
> users.
> 
> 3. Mixed between 1) and 2), the current approach.
> 
> The first one adds a lot of overhead, a different set of APIs for each
> type of dynamic event - but maybe it is more clear for the library
> users. The second is straightforward for implementation, less APIs -
> but that could be confusing for the users.
> 
>>> +/**
>>> + * tracefs_kprobe_free - Free a kprobe context
>>> + * @kprobe: Pointer to a kprobe context
>>> + *
>>> + * The kprobe/kretprobe, described by this context, is not
>>> + * removed from the system by this API. It only frees the memory.
>>> + */
>>> +void tracefs_kprobe_free(struct tracefs_dynevent *kprobe)
>>> +{
>>> +     dynevent_free(kprobe);
>>> +}
>>> +
>>
>> The same argument applys here.
>>
>> Thanks!
>> Yordan
>>
> 
> Thanks for the review!
> 
