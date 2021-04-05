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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58832C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 15:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27975613B1
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 15:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241383AbhDEPDa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 11:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237631AbhDEPDa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 11:03:30 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004D3C061756
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 08:03:23 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id e14so17203933ejz.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 08:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=yE4m4nWxT0dTcPTpQeWgeLYg52F0fWp7VS8NLhmm1pw=;
        b=bmTer/bI76qReyqlFulQIyh9joYbAHLYucoyRhT6uqkuUNsta485MhpU0vmN+UgmW0
         M9Wa1p2WLy3yxTt614t6zdiwpXSdd/1CHr0lMl8gBiqS733RK6tqX4dMu5mETeRk75z6
         heXibX+SOGpi/ftl1bvfM57st9mddP06c8kQmihI9/VPm40/+vYCi4PkSB4T663SfqDR
         muL6xP6Q8eT8kpoX1b3Bet31MshpfEjN0emdb2raUiWMwE95r8vAZgjghsaCQuQizOae
         4O6c3rzwxqVA9TzVC8enDAbgRNDLLO1uchmtMwI879OJWQI2/eNQuPiEnwvdlcwEgO7S
         EzQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=yE4m4nWxT0dTcPTpQeWgeLYg52F0fWp7VS8NLhmm1pw=;
        b=iySTpqcPwyGW00BjdBj+58qnWY+O1g2w8A/O9p8SkYRZ0AJ7w5Tx0HM4qufD+USOsE
         PkAW0R7qyGRmseS0cFZSRxvo1WDxm/Vmv+EPk9SP3d61V2cwLJOEONv+RyMzmk9CfAIo
         erirHE/Uf5Mx+hi/fGzkXgzyySn61s8wpb+mV4aCizz43YNyQwjn3yWjEkZPPZ9ZMTsm
         IbLsZikiK7C08LUVtZFtzY0U+fTVI+wYp4vOnGf7ROkDrTjDzUsAjuMEOxwjlHQwaO8s
         cjDf1jXYEXqzrs7I4DXj27/DfR0tbrzp4/RjA8QmeI+FFo4PHu9RzWin4Q2VeSWkMpzZ
         yKCQ==
X-Gm-Message-State: AOAM533EZdigQ+b+ZAfIegE0vNQCXVffUK8grGnbj0+IF466gRhGZc1k
        6hHp71ApgszXl1/XnmPxoxm3SfgT5obGNA==
X-Google-Smtp-Source: ABdhPJzILnR5UzMqh3LNr+6EgEdLrsBOEs1sqGNGNq7RQuWzzg6xUGQefJNQR7uLBH5jTVnw6SeTrw==
X-Received: by 2002:a17:906:7db:: with SMTP id m27mr29130584ejc.484.1617635002476;
        Mon, 05 Apr 2021 08:03:22 -0700 (PDT)
Received: from [192.168.0.106] ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id d8sm3311913edy.83.2021.04.05.08.03.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 08:03:22 -0700 (PDT)
Subject: Re: [PATCH 5/6] libtracefs: Option's bit masks to be owned by the
 instance
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20210402131947.346235-1-y.karadz@gmail.com>
 <20210402131947.346235-6-y.karadz@gmail.com>
 <CAPpZLN5J7GM00DsqEiaq7yK+7fd2UENWH54xwKUWaYoYyRN30Q@mail.gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <e88cdde6-65b2-fdbb-99aa-ba649277b2f8@gmail.com>
Date:   Mon, 5 Apr 2021 18:03:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAPpZLN5J7GM00DsqEiaq7yK+7fd2UENWH54xwKUWaYoYyRN30Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


On 5.04.21 г. 13:56, Tzvetomir Stoyanov wrote:
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
>>   ...
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
> The "instance" argument can be NULL, for the top instance. There
> should be global enabled_opts and supported_opts, to be used in that
> case.

Yes, this is a bug and I have it in v2 as well. Seems like I will need 
to send v3.

Thanks a lot!

Y.



>
> [..]
>
>
