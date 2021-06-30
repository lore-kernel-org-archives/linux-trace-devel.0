Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B13BC11F65
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 18:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BA0F61419
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jun 2021 18:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbhF3SkW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 14:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbhF3SkW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 14:40:22 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBB4C061756
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jun 2021 11:37:52 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id l24so4613733edr.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jun 2021 11:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t/TecfW2q/2dcvTG2/EDlF/58oDVqvc96WzD4Kbjm+k=;
        b=RB2vjsP5sl8gCXptsBqnEzHMTQyWT6+NQbBjPumN5uy/R/l5UYUrtz/ybcTdFnBojR
         9mLorOtW/dKExiG/hW77rHTLsWPHUsctEZX45+J+hgxzbs0PCRJlKuap4kid51J9TroL
         WRfFPMg6wCNXS051R8k6de9y6HzKY0ood81yToZXu7yKKqFGipGSo3vRk5oc4+AzXbQ7
         0r8juv9UOrihjGp/tFb/GZgWlCrV7r2GAMQMdkm0LMugEyh764zFz1nwCBuXi8g7fCzk
         FZTZRT/5JOqm0ND5CB8fW2y4+gm+1Jh6DUG+Yb9D29isCuHJ4LpOGw4Nwwrqza4x6Yjv
         UuNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t/TecfW2q/2dcvTG2/EDlF/58oDVqvc96WzD4Kbjm+k=;
        b=akYwo7pYDn7ySYsLFkivCdT2cVXQkW2eDAIeEyQWWdr+zP0eswwCSCDucG88BM4kOp
         0NwPMDnrfuC0dNf+c8LBO1LxKz/SCagvFV1mngEuBgepu8Uqa8k9KmDaLUxpJkv/dhtI
         LTHc3muBNSYsKZugTzDAwMXyhkivQLrIucw0qlVhvnP16/pZJJaVxU9ermMQI1RVCB8Z
         smiuMjAJWAl/g2GQGVZ0o9PHqAFTVZoMCJIw1l5ba6GmYk5BcvSF9LW3BqxqOWe0WMZJ
         sOE9KPihuIxzCcQWWuQghA5l7QcX5eZNYrMlny5m5h/WAXoZr/OYtanopmLhlW2F/GgZ
         YrCw==
X-Gm-Message-State: AOAM533NZ433BXk5RCIUZEiYQajmfiUIPUX91fWRe6EXSdUqaIIR9kch
        UDtEQ/A0t6AAnzhR5A70zKdJBAsPqPs=
X-Google-Smtp-Source: ABdhPJxaCl8jjG7nP/hb29AuCoFIVIz+lXR2JqtRImhYeaZ8j6f+y9DRl/wDSeiO1Lmz5iK+tMR5Lw==
X-Received: by 2002:a05:6402:1c06:: with SMTP id ck6mr2841308edb.287.1625078270574;
        Wed, 30 Jun 2021 11:37:50 -0700 (PDT)
Received: from [192.168.0.109] ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id y1sm415052ejf.90.2021.06.30.11.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 11:37:50 -0700 (PDT)
Subject: Re: [PATCH] libtraceevent: Fix bug in tep_print_event()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210630141913.20675-1-y.karadz@gmail.com>
 <20210630110635.57411548@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <5af941a3-5760-3a3e-188a-6a6921d079d4@gmail.com>
Date:   Wed, 30 Jun 2021 21:37:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210630110635.57411548@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 30.06.21 г. 18:06, Steven Rostedt wrote:
> On Wed, 30 Jun 2021 17:19:13 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> {
>>   	struct print_event_type type;
>> -	char *format = strdup(fmt);
>> -	char *current = format;
>> -	char *str = format;
>> +	char *format, *current, *str;
> 
> Nit, but please keep the above each on a separate line.
> 
> 	char *current;
> 	char *format;
> 	char *str;
> 
> I try to avoid having pointers on a single line, it's just easier to
> manage when they are separate.

I am sorry!
I somehow forgot that we already discussed this before.
Should I send v2?

Thanks,
Y.

> 
> Thanks!
> 
> -- Steve
> 
>>   	int offset;
>>   	va_list args;
>>   	struct tep_event *event;
>>   
>> +	event = tep_find_event_by_record(tep, record);
>> +	if (!event) {
>> +		trace_seq_printf(s, "[UNKNOWN EVENT]");
>> +		return;
>> +	}
>> +
>> +	str = current = format = strdup(fmt);
>>   	if (!format)
>>   		return;
