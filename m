Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138ABC4363F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 13:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C47B761480
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 13:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhEJNau (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 09:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244348AbhEJL6y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 07:58:54 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D74DC06134F
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 May 2021 04:53:12 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id s20so18548174ejr.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 May 2021 04:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WMuNrrbpp7H9saOpTtuVR1wvdivK0uuh4s9y03YQiyg=;
        b=EXqfj8xNw4sAaE+Vt5cs7XhOCVX5wVMWxAOVVwbjxiGnhtHKZbFNq5D56oDrrTKixo
         BF9UxeYmBz9VZzhBbRpecSWFGXp5kwxEJZKEjrjo97BXcTbkY9etwOCXLP4RkuNkI6Gv
         5pLiBEGfCvpivnCIYbofLf1GddXYoOlHuSlwUG3gO9wd5Dzi/RiHp+Ua7XbUYahD6kDO
         NVQ0tI2eMIHb09Ni0kDzbdQNYRl6oVqmOlvpxz8B1O7yoitJDvuJ77aL5fva/qd44mni
         rZtQNMtfAOB9MByMIflSitapKZDU2gEYeT/sFx60neQQhByXjz8UrzEaGDncWgO3ukbL
         CYpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WMuNrrbpp7H9saOpTtuVR1wvdivK0uuh4s9y03YQiyg=;
        b=ANkf+6BOrsyrvIlZORJ7a26rAzJZfFjwFZqMBAKq+siHs3Re/EolC8eSA2clwXa+GS
         2Sxz2ralkB2H9+gSp0qmrn9Vy3C5mGaEAEQUGDIxKS/+AN4+YO5xNTs0KSYkTHF2SDWq
         7tkyFMAGxPgjUpiOGpHRz/mBn6EqyHw28kBv2Pd8mNC9xeAprIdZXM2lr5+IYX3m6lL7
         rLuIdodc1bJVUlDFEx9m5FlN6pcnIPXW79N4/bga5VTNv/U/myUE9K76QUNBKlzRJfTn
         TWXPZpx0LzDrtQbu/4bQ2ovG6f7gkRZEv3KZI7OBQTFUv54xFPrziGAaRPL4mvKbnebB
         iQpA==
X-Gm-Message-State: AOAM531JpMyiUx+ySm8Lb5TzBnycNpyjX2I793kdTCaWj+7hVaxcI5hR
        B9vQc07aqPb/7FC002bPFqO8+ZCmoeo=
X-Google-Smtp-Source: ABdhPJyWUdKrL+7hefthvKxOdDntEPp2ttNRTOMUlJaaDiRbunPtlvpI5aAjMdksH2u/FUunabdHDg==
X-Received: by 2002:a17:906:6b8d:: with SMTP id l13mr24923753ejr.169.1620647590529;
        Mon, 10 May 2021 04:53:10 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id ca20sm9123496ejb.84.2021.05.10.04.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 04:53:10 -0700 (PDT)
Subject: Re: [PATCH v2 3/9] kernel-shark: Fix KS_DEFINE_PLUGIN_CONTEXT macro
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210428134730.187533-1-y.karadz@gmail.com>
 <20210428134730.187533-4-y.karadz@gmail.com>
 <20210506141151.2f31f263@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <6c352db2-1f2a-4442-1832-1810d4d6a1a2@gmail.com>
Date:   Mon, 10 May 2021 14:53:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210506141151.2f31f263@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 6.05.21 г. 21:11, Steven Rostedt wrote:
> On Wed, 28 Apr 2021 16:47:24 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> The KS_DEFINE_PLUGIN_CONTEXT macro implements methods that are used
>> to deal with plugin-specific context objects. However, when this macro
>> is used in multiple plugins and those plugins are loaded together
>> the symbol resolving fails, resulting in undefined behavior. Namely,
>> version of the function from one plugin, being called by another
>> plugin. Here we make sure that the methods defined in
>> KS_DEFINE_PLUGIN_CONTEXT are not visible outside of the corresponding
>> plugin.
>>
>> Fixing: 15df009 (kernel-shark: Add KS_DEFINE_PLUGIN_CONTEXT macro)
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   src/libkshark-plugin.h     | 22 ++++++++++++++++++----
>>   src/plugins/sched_events.c |  3 +++
>>   src/plugins/sched_events.h |  3 +--
>>   3 files changed, 22 insertions(+), 6 deletions(-)
>>
>> diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
>> index c110616..752dbeb 100644
>> --- a/src/libkshark-plugin.h
>> +++ b/src/libkshark-plugin.h
>> @@ -24,6 +24,8 @@ extern "C" {
>>   /* Quiet warnings over documenting simple structures */
>>   //! @cond Doxygen_Suppress
>>   
>> +#define __hidden __attribute__((visibility ("hidden")))
>> +
>>   #define _MAKE_STR(x)	#x
>>   
>>   #define MAKE_STR(x)	_MAKE_STR(x)
>> @@ -364,11 +366,14 @@ int kshark_handle_all_dpis(struct kshark_data_stream *stream,
>>   	__ok;								\
>>   })									\
>>   
>> -/** General purpose macro defining methods for adding plugin context. */
>> +/**
>> + * General purpose macro defining methods for adding plugin context.
>> + * Do not use this macro in header files.
>> + */
>>   #define KS_DEFINE_PLUGIN_CONTEXT(type)					\
>>   static type **__context_handler;					\
>>   static ssize_t __n_streams = -1;					\
>> -static inline type *__init(int sd)					\
>> +__hidden type *__init(int sd)						\
> 
> This is strange, because static inline should never be a problem in this
> regard (otherwise things will break elsewhere too).
> 
> static is never exported (it's stronger than "hidden").
> 
> Can you show me how you see this error, because this solution does not make
> any sense.

The problem is that some plugins can build from multiple source files. 
For example in the case when part of the plugin is written in C and 
another part in C++. In those cases we cannot have the functions being 
static.

Thanks!
Yordan


> 
> -- Steve
> 
