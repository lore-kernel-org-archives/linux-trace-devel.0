Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A32C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 20:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E342761165
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 20:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhEJUTr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 16:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhEJUTq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 16:19:46 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC3CC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 May 2021 13:18:41 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id t4so26503025ejo.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 May 2021 13:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H+NTKAH/Hx1E5SwZlst9SGiVw2qEbCMEqIZ//Kb6wW4=;
        b=i/wGC+aSJgGgCY5CYnBBUz0dIGV+AChmKNgtmHEqA3C4wUgk/dWXZ/spD7t8UG7Uxp
         9sCGWUUGEbEBWpMzQh18Ox2kc77utGdPMhnJTKDbs2XHjoeTq85w7bsPPK0PsKN0ZmJo
         kJluJ0yuQrf1Mntv32Q7bRaE+YfLqwnAE/qTkTEz163yPfkdmhEDCW2qlbE1WtRqYUCT
         6D78jKYKfQt3Up0mnsGrk/iBhqqoGYQOymgB72vX4zRL6aFAQ0Xw3+VkHunHi6ZZdY/V
         De8L44TXs0GZgiItxq7LY7zH71rZ1WXQiisVDSJMceSwcVVInjyKLCprMQ2gdRD+nxSS
         VbPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H+NTKAH/Hx1E5SwZlst9SGiVw2qEbCMEqIZ//Kb6wW4=;
        b=Cas0A0q2uu5vfLBOZR7S8Jw2aXCmbNxppWz5thhj/3Q+Y5FzMOU/I0oYDj97YF2pMh
         h+4wx3r2XV6RO90p6KsLpO16bSm2Am2Eb/2+kmAqEjaxhdRmN2RXoyzeKCSGzDt3LJVp
         VLzxJvW4YWn+AF6uaH3qAc4vDJgbe+rq6UNyMSvT0XTeTU5eHuHKw0jChVDHimXmW8cL
         8/UOV6epR/BGcwcvxlp2oElaKubJQCS8YcFj8jT8POtVMwMb87AWIcnNWDdIgd2nvqR1
         rLkUZNdawR3aU7NKfKeKF7bedMB+Bk5Nhbm1PMot3H9L9IvCNBWr2ShsugdVOjxDM9qo
         qeVg==
X-Gm-Message-State: AOAM533oQfiCowAnBaUVJMckkDY56V4oX+PudQ1RYSSdeIaz5Azwiy2O
        Wb5Wms0LepnE7Nra8+lP7/wPZEZyg8A=
X-Google-Smtp-Source: ABdhPJwP1O7aIUF4BA1je8jXelU9PMoYH9jX21SFLUk4PjpeW86YDzNk5mLPvJPCNV7fOFyVOKSP5Q==
X-Received: by 2002:a17:906:8a78:: with SMTP id hy24mr28038187ejc.39.1620677920086;
        Mon, 10 May 2021 13:18:40 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id zo6sm10009459ejb.77.2021.05.10.13.18.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 13:18:39 -0700 (PDT)
Subject: Re: [PATCH v2 3/9] kernel-shark: Fix KS_DEFINE_PLUGIN_CONTEXT macro
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210428134730.187533-1-y.karadz@gmail.com>
 <20210428134730.187533-4-y.karadz@gmail.com>
 <20210506141151.2f31f263@gandalf.local.home>
 <6c352db2-1f2a-4442-1832-1810d4d6a1a2@gmail.com>
 <20210510142537.2628c47b@gandalf.local.home>
 <cc7b594f-194e-9d2e-81e2-49f60f6c6eab@gmail.com>
 <20210510152349.3de97b82@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <0dc10813-0fe9-2506-4c32-028892e17082@gmail.com>
Date:   Mon, 10 May 2021 23:18:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210510152349.3de97b82@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 10.05.21 г. 22:23, Steven Rostedt wrote:
> On Mon, 10 May 2021 21:50:57 +0300
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
>> On 10.05.21 г. 21:25, Steven Rostedt wrote:
>>> On Mon, 10 May 2021 14:53:08 +0300
>>> Yordan Karadzhov <y.karadz@gmail.com> wrote:
>>>    
>>>>> Can you show me how you see this error, because this solution does not make
>>>>> any sense.
>>>>
>>>> The problem is that some plugins can build from multiple source files.
>>>> For example in the case when part of the plugin is written in C and
>>>> another part in C++. In those cases we cannot have the functions being
>>>> static.
>>>
>>> So it's because its a mixture of C and C++ code? And you can't make them
>>> static?
>>
>> No, this has no direct connection with C++. The static functions are the
>> same in C++.
>> It became an issue if you have multiple source files. If this is the
>> case you have to put the macro in a header file, so that you can use the
>> functions defined in the macro in all your source files. But this does
>> not work, because the macro defines some global variables as well. To
>> solve this I defined second macro to be used only in the header, but
>> then the functions can't be static.
>>
> 
> Still does not make sense. Obviously, I'm missing something to connect the
> dots.
> 
> Can you show me the error message that you are fixing.

It is not an error message. It is a malfunctioning. Say you have a macro 
that looks like this:

#define KS_DEFINE_PLUGIN_CONTEXT(type)		\
static type **__context_handler;		\
static ssize_t __n_streams = -1;		\
static inline type *__get_context(int sd)	\
{						\
	if (sd < 0 || sd >= __n_streams)	\
		return NULL;			\
	return __context_handler[sd];		\
}
						\
and you want to use __get_context(int sd) in different source files.
If you just place the macro in a header, each source file will have its 
own "static __context_handler" variable which is not what I would like.
So this is a malfunctioning.

I can solve this problem by having a second macro that only declares 
"type *__get_context(int sd)" and place this macro in the header, while 
keeping the original macro in one of the source files, but then 
__get_context() cannot be static. If I go this way and I have multiple 
plugins using the same macro I will have multiple versions of the same 
function and this time the dynamic linking will start to misbehave.

Does that make sense?

Thanks!
Yordan

> 
> Thanks,
> 
> -- Steve
> 
