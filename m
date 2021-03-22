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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F4BC433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 17:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 980BD61998
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 17:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhCVRAM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 13:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbhCVQ7q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 12:59:46 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367AAC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 09:59:46 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id w3so22465794ejc.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 09:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2zWDGH3fpC720hg1Yy9sLQw/xkx0esVsj356YMQ9aEs=;
        b=tOVIkTe8/SFEsmZank2vRP1qysFHIsW4OOsSKJogjw3vg0cDxFgZcSEp06cZpvq3Ti
         D5GUktDhK7WS2BQX2LHCGMwrWS958DioqRyEUMmQgg/2sZVTOGz9CYoXijPgYBrOzdxt
         qi0I4MaOA58DGxMJPUx52rtQhQ8gv1yJtj5gFLMR+hNnMjVuRRTF6GZytqbBhCTJ1VU2
         q8M0i5BoyvbvMQy1a5+/yuEZh+xKHYkCf/CRYZwnzDRTSdJV/oNCulT2F0bVuKe/rh6s
         yZos2tvuOIzl86YUUmET7pzhNfC9i1HqfpHmgxVvnTP7hhfwCF3ueyLnGR5mswe+60Dr
         49Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2zWDGH3fpC720hg1Yy9sLQw/xkx0esVsj356YMQ9aEs=;
        b=loFs2BERq53kxJj1sG51vw84J6Rqdx9aSOtdLVkwfuv1HPoNLU2M1N0GSL2vLHUzZE
         77yDp+byu/o5pM2I746liiHzxNizmdf++KQzThais36lylVIENAVui3C6607gV9nMX2n
         SNeCyEevUA4AmIjObWVMhaHr2Go4oQBFPP6bDfAfkfkh0j+ns5pbj1a7/77y1Xsf9k3S
         JkwWLwe/SRu3XKlrToDxDS+CuYF+xP0hVw19pEn/8L9znrVr4v102FySvwQKRzYkyhgb
         irSNyD84yi/rOCssO4vuUfsAIi+Q9CN0z4is6H3pIbbpTNzDU05p9uyTwXy+oYzwcT2e
         Ncgw==
X-Gm-Message-State: AOAM532A1vN1NzunqCsc2aHZnfHNRFYjc9ejqJ33IjOTAze2zSrRia1g
        JIyUM06ZXiu0QWe6C3cyzzZd6GzuZwkSIg==
X-Google-Smtp-Source: ABdhPJx+4gPS+QoksBcEvmSJ+Pqk5nHAk8dK2ckgfAaBPGtYwjM9OCakeVdKk1pkjP4Y5VUT63WJ5A==
X-Received: by 2002:a17:906:b20b:: with SMTP id p11mr824733ejz.0.1616432384811;
        Mon, 22 Mar 2021 09:59:44 -0700 (PDT)
Received: from [192.168.0.108] ([95.87.199.22])
        by smtp.gmail.com with ESMTPSA id nd36sm9752014ejc.21.2021.03.22.09.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 09:59:44 -0700 (PDT)
Subject: Re: [PATCH] libtracefs: Prefer using const pointer arguments
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210322142912.26521-1-y.karadz@gmail.com>
 <20210322114721.118c83ae@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <64861357-e2ef-e2aa-239c-9b8a96a5bf9b@gmail.com>
Date:   Mon, 22 Mar 2021 18:59:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210322114721.118c83ae@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 22.03.21 г. 17:47, Steven Rostedt wrote:
> On Mon, 22 Mar 2021 16:29:12 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> All functions should receive const pointer arguments, except in the
>> cases when the argument object itself needs to be modified.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   include/tracefs.h      | 15 ++++++++-------
>>   src/tracefs-instance.c | 17 +++++++++--------
>>   2 files changed, 17 insertions(+), 15 deletions(-)
>>
>> diff --git a/include/tracefs.h b/include/tracefs.h
>> index f3eec62..e54f791 100644
>> --- a/include/tracefs.h
>> +++ b/include/tracefs.h
>> @@ -25,12 +25,13 @@ struct tracefs_instance *tracefs_instance_create(const char *name);
>>   struct tracefs_instance *tracefs_instance_alloc(const char *tracing_dir,
>>   						const char *name);
>>   int tracefs_instance_destroy(struct tracefs_instance *instance);
>> -bool tracefs_instance_is_new(struct tracefs_instance *instance);
>> -const char *tracefs_instance_get_name(struct tracefs_instance *instance);
>> -const char *tracefs_instance_get_trace_dir(struct tracefs_instance *instance);
>> +bool tracefs_instance_is_new(const struct tracefs_instance *instance);
>> +const char *tracefs_instance_get_name(const struct tracefs_instance *instance);
>> +const char *tracefs_instance_get_trace_dir(const struct tracefs_instance *instance);
>>   char *
>> -tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
>> -char *tracefs_instance_get_dir(struct tracefs_instance *instance);
>> +tracefs_instance_get_file(const struct tracefs_instance *instance,
>> +			  const char *file);
>> +char *tracefs_instance_get_dir(const struct tracefs_instance *instance);
>>   int tracefs_instance_file_write(struct tracefs_instance *instance,
>>   				const char *file, const char *str);
>>   char *tracefs_instance_file_read(struct tracefs_instance *instance,
>> @@ -42,8 +43,8 @@ int tracefs_instance_file_open(struct tracefs_instance *instance,
>>   int tracefs_instances_walk(int (*callback)(const char *, void *), void *context);
>>   
>>   bool tracefs_instance_exists(const char *name);
>> -bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
>> -bool tracefs_dir_exists(struct tracefs_instance *instance, char *name);
>> +bool tracefs_file_exists(struct tracefs_instance *instance, const char *name);
>> +bool tracefs_dir_exists(struct tracefs_instance *instance, const char *name);
>>   
>>   int tracefs_trace_is_on(struct tracefs_instance *instance);
>>   int tracefs_trace_on(struct tracefs_instance *instance);
>>
> 
> My fear about doing the above is that when dealing with complex structures
> like tracefs_instance, which is opaque (private) to the caller that it now
> prevents us from ever modifying the instance in one of those APIs. It may
> not modify it now, but that does not mean it wont be modified in the
> future. We could add ref counters, or something else.
> 

Hi Steven,

I understand your preference to keep the flexibility of those API, 
however generally spiking those are "getter" functions and they are not 
supposed to modify the encapsulated object. If we allow the "getters" of 
the API to modify the encapsulated object (tracefs_instancein this case) 
this will be a bit of hacking stile of programing. At least for me, 
having a firm and intuitive design of the API is more valuable than the 
inconvenience that this reduced flexibility can potentially bring.

Thanks!
Yordan


> What's the reason to make them constant? The caller does not have access to
> the internals of what those are pointing to. It's just an abstract object.
> Why would they care if its const or not?
> 
> -- Steve
> 
