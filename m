Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BAC7C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 15:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38D96613B7
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 15:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237824AbhDEPBv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 11:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237631AbhDEPBv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 11:01:51 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29C5C061756
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 08:01:44 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id n2so10970085ejy.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 08:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=sO62Nuep1Zz/leBkuwPWtMSPuUIOEiOB0VZRtVSK04M=;
        b=uc11UsiPiaFWEQp3mllTp+Mq9egMfszJ63vco+phE9BLxgyqv/fZbeKmCfvjKSMI8g
         XarPLcRfzqvc8ZyEjMLzYT162/cOpLKFOyIeeSV5S72QoO5H1AB7L3jq0ctCRISl7QiV
         Sbcl0FymD2ENmcem8vrkzzb+gtVsdNFjqhz7fwKR/wYGyitNmKqBBXqnNg3j7R5oKqwk
         ojvd41lWOwO5nGE5JhN8hs+pt0YiaB5U2J7+uHIwcvfQCJGEEmV/tLWsqe3VD9BL8tsk
         /QnB+9Bx4Jue+03GDaxjl8KDRo3fZ9Zfn4ybq3CvirXIym6jFR/4myzcS10C36vJxiyE
         htkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sO62Nuep1Zz/leBkuwPWtMSPuUIOEiOB0VZRtVSK04M=;
        b=WCgvrYmpgRrf7nlaSKq5dj7ZY6A7+lG872EYAGRsu0DO4MhhOPjJrzx929BFZ2oVLo
         3snmL1vDoXnmaKHuiWt7Ivp/yT2h/p5362NevyjXJbJfYXef7UwVu1efpgXWzLQJcUo0
         0CSkWiCfFg44drlrrBMS5JqLj4gEVzX0ZY96bGKFNfPfpcR0rsJpFcvhFA6oVwaOiaFx
         /DlnqANehnY4AaNZgcaphfymdzrYWQrNnZ5CPJvH8sxpucWlojcy/ZpOI/RO17aHkHIq
         fVkbjKUV/wE04qeX2bj0YxskBAkalFERmNyJMDRMXhBAXgtBrQHBuV1InMJH3zc5AAdT
         i3Lw==
X-Gm-Message-State: AOAM533QkTkZKZT4bl+Qdtq3W7USt/vwWKkqNWvqrX2X69kEAv25XqPe
        iL93SIlv5MHhf8Fc31ahMgWS/V6Y2VRyAg==
X-Google-Smtp-Source: ABdhPJyHJUeKN6EvHAzPHNk1qSR45b4l5vLUCH+Oo94YZf/wSoLZDAkAdpn5yN9b/Dq/92UdsQLsRg==
X-Received: by 2002:a17:907:761c:: with SMTP id jx28mr29305475ejc.417.1617634903321;
        Mon, 05 Apr 2021 08:01:43 -0700 (PDT)
Received: from [192.168.0.106] ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id k12sm11361145edr.60.2021.04.05.08.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 08:01:42 -0700 (PDT)
Subject: Re: [PATCH 5/6] libtracefs: Option's bit masks to be owned by the
 instance
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20210402131947.346235-1-y.karadz@gmail.com>
 <20210402131947.346235-6-y.karadz@gmail.com>
 <CAPpZLN5rj-O+fzxf=AR1NbUUDtyjJUXw5Kn5O8nSuZiK554p4g@mail.gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <8b7346e2-2ce3-0d8b-caab-dd873f00dde6@gmail.com>
Date:   Mon, 5 Apr 2021 18:01:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAPpZLN5rj-O+fzxf=AR1NbUUDtyjJUXw5Kn5O8nSuZiK554p4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


On 5.04.21 г. 13:50, Tzvetomir Stoyanov wrote:
> On Fri, Apr 2, 2021 at 4:20 PM Yordan Karadzhov (VMware)
> <y.karadz@gmail.com> wrote:
>> If the instance owns two mask objects, we no longer need to
>> dynamically allocate memory in tracefs_options_get_supported() and
>> tracefs_options_get_enabled(). This will simplify the code on the
>> caller side, since the user is no longer responsible for freeing
>> those masks.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   Documentation/libtracefs-option-get.txt |  4 +---
>>   include/tracefs.h                       |  6 +++---
>>   src/tracefs-instance.c                  | 24 ++++++++++++------------
>>   3 files changed, 16 insertions(+), 18 deletions(-)
>>
>> diff --git a/Documentation/libtracefs-option-get.txt b/Documentation/libtracefs-option-get.txt
>> index 9b3cb56..3290f24 100644
>> --- a/Documentation/libtracefs-option-get.txt
>> +++ b/Documentation/libtracefs-option-get.txt
>> @@ -52,14 +52,13 @@ EXAMPLE
>>   --
>>   #include <tracefs.h>
>>   ...
>> -struct tracefs_options_mask *options;
>> +const struct tracefs_options_mask *options;
>>   ...
>>   options = tracefs_options_get_supported(NULL);
>>   if (!options) {
>>          /* Failed to get supported options */
>>   } else {
>>          ...
>> -       free(options);
>>   }
>>   ..
> The description of the return value of tracefs_options_get_supported()
> and tracefs_options_get_enabled() should be changed also, as it
> suggests to free the return value;
>
>>   options = tracefs_options_get_enabled(NULL);
>> @@ -67,7 +66,6 @@ if (!options) {
>>          /* Failed to get options, enabled in the top instance */
>>   } else {
>>          ...
>> -       free(options);
>>   }
>>   ...
>>
>> diff --git a/include/tracefs.h b/include/tracefs.h
>> index 0665e8d..9efa91a 100644
>> --- a/include/tracefs.h
>> +++ b/include/tracefs.h
>> @@ -132,11 +132,11 @@ enum tracefs_option_id {
>>   #define TRACEFS_OPTION_MAX (TRACEFS_OPTION_VERBOSE + 1)
>>
>>   struct tracefs_options_mask;
>> -bool tracefs_option_is_set(struct tracefs_options_mask *options,
>> +bool tracefs_option_is_set(const struct tracefs_options_mask *options,
>>                             enum tracefs_option_id id);
>> -struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
>> +const struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
>>   bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs_option_id id);
>> -struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
>> +const struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
>>   bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_option_id id);
>>   int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
>>   int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
>> diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
>> index 49645eb..9cb4b6d 100644
>> --- a/src/tracefs-instance.c
>> +++ b/src/tracefs-instance.c
>> @@ -27,6 +27,8 @@ struct tracefs_instance {
>>          char    *trace_dir;
>>          char    *name;
>>          int     flags;
>> +       struct tracefs_options_mask     supported_opts;
>> +       struct tracefs_options_mask     enabled_opts;
>>   };
>>
>>   /**
>> @@ -695,9 +697,8 @@ static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *i
>>          DIR *dir = NULL;
>>          long long val;
>>
>> -       bitmask = calloc(1, sizeof(struct tracefs_options_mask));
>> -       if (!bitmask)
>> -               return NULL;
>> +       bitmask = enabled? &instance->enabled_opts : &instance->supported_opts;
> This makes the API not thread safe. There should be no problem with
> supported options, as they cannot be changed at runtime. I think it is
> OK to limit the APIs , as I see no use case to call them from multiple
> threads on the same instance, but this should be described in the
> documentation.

Discussing is this API is thread safe or not is not really relevant. 
Even if you make tracefs_options_get_enabled() thread safe, this does 
not change anything since the options can be already changed by the time 
when you examine the bits of the mask.


>
>> +
>>          dname = tracefs_instance_get_file(instance, "options");
>>          if (!dname)
>>                  goto error;
>> @@ -727,7 +728,6 @@ error:
>>          if (dir)
>>                  closedir(dir);
>>          tracefs_put_tracing_file(dname);
>> -       free(bitmask);
>>          return NULL;
>>   }
>>
>> @@ -735,10 +735,10 @@ error:
>>    * tracefs_options_get_supported - Get all supported trace options in given instance
>>    * @instance: ftrace instance, can be NULL for the top instance
>>    *
>> - * Returns allocated bitmask structure with all trace options, supported in given
>> - * instance, or NULL in case of an error. The returned structure must be freed with free()
>> + * Returns bitmask structure with all trace options, supported in given instance,
>> + * or NULL in case of an error.
>>    */
>> -struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance)
>> +const struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance)
>>   {
>>          return trace_get_options(instance, false);
> As supported options cannot be changed at runtime, they can be read
> only once. The next calls can return the already initialised bitmask
> with supported options.

If you already have the mask, you do not need to call this function 
second time.

May be if the user intentionally calls the function again, we should 
allow him to regenerate the mask.

What do you think?

Thanks!

Yordan

>
>>   }
>> @@ -747,10 +747,10 @@ struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instan
>>    * tracefs_options_get_enabled - Get all currently enabled trace options in given instance
>>    * @instance: ftrace instance, can be NULL for the top instance
>>    *
>> - * Returns allocated bitmask structure with all trace options, enabled in given
>> - * instance, or NULL in case of an error. The returned structure must be freed with free()
>> + * Returns allocated bitmask structure with all trace options, enabled in given instance,
>> + * or NULL in case of an error.
>>    */
>> -struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance)
>> +const struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance)
>>   {
>>          return trace_get_options(instance, true);
>>   }
>> @@ -758,7 +758,7 @@ struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance
>>   static int trace_config_option(struct tracefs_instance *instance,
>>                                 enum tracefs_option_id id, bool set)
>>   {
>> -       char *set_str = set ? "1" : "0";
>> +       const char *set_str = set ? "1" : "0";
>>          char file[PATH_MAX];
>>          const char *name;
>>
>> @@ -846,7 +846,7 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
>>    * Returns true if an option with given id is set in the bitmask,
>>    * false if it is not set.
>>    */
>> -bool tracefs_option_is_set(struct tracefs_options_mask *options,
>> +bool tracefs_option_is_set(const struct tracefs_options_mask *options,
>>                             enum tracefs_option_id id)
>>   {
>>          if (id > TRACEFS_OPTION_INVALID)
>> --
>> 2.27.0
>>
>
