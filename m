Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A8C0C4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 15:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A82860FDA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 15:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240472AbhHTPGT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Aug 2021 11:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240951AbhHTPGT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 11:06:19 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E5DC061756
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Aug 2021 08:05:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id gr13so20887672ejb.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Aug 2021 08:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j0hRiznkZuD8P1mNr6HyGEql6ig0shF2CAXFaxkLfRY=;
        b=qJKNJrvDyFANLzQjqRrl8P0gK9G+QL1XTeafcpD/a4XXxFXD6d0iszm3ssWxuapebE
         jGPbLwreVfKH/diduf4/PiSUrF621FGBMvczItQPoU/xnwSQAOxjwJ21wBvkFFP1UgQ/
         C3RmIvTu4zJ9TwktRZiOjiCko6UloLvAID6z1waZTnudE1q4VMH5Yjh1Wc5ZjHR0ezA/
         5jYTDsElzQh9DU2i3K6ZKQo4zU8B2h6O9fU6gTW0M9v/Ue2O0C4addM/BNC0grRfWRkw
         2YoGP9HrbXzuoEGPRmTp6VJcqFveNH9XB0mMGx+yRHInOv2b3x0X5LT+hZT4PllH4d5e
         UoUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j0hRiznkZuD8P1mNr6HyGEql6ig0shF2CAXFaxkLfRY=;
        b=EWJrHkA4XEURvFk3juOkNwgZoLUd/tPwI/bDzs977aeERip9bi5bdNhqPE+DIwA6Vc
         SnD/RnJZrD+PStLLcqTut7cIRiTbOsvWNLYEGKJ34c/g4TtmoKM1Icpo8hLHOf+xPNte
         ijuEzhme+UFhXBAMUGDjHJy+Z9hBVyjDqIH1D0xfiKR5M9SF6hlEVxWNAw+xQXX1lWVF
         zpkHGtF17aDYFjzD+cYuERt2GdEP3/0JmpVvpsaONWBPG069dqUOBSwiKTO3c7kO1up3
         AOaRnVPpZuPV02BxYIM9w1w2h3KSGVcpOcQRzzglKkoSthWL8PGRiInQ768DMXPpQMw3
         222w==
X-Gm-Message-State: AOAM532dycvJvwaf2y8vO/R5UubDwfc7wJg4jDGZF/0naHzRV12wWY2o
        cAZETOAAByRHEmEAMbF6jV8WzlgWbYs=
X-Google-Smtp-Source: ABdhPJz7TkSJgQ0HghZ2kzzr7a+9zFP79srIjYBSag0Y19I5/v+avY8mNo0wtvDFTyiTU3Lc6fejvg==
X-Received: by 2002:a17:906:e291:: with SMTP id gg17mr22514760ejb.477.1629471939015;
        Fri, 20 Aug 2021 08:05:39 -0700 (PDT)
Received: from [192.168.0.108] ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id ne22sm1917952ejc.113.2021.08.20.08.05.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 08:05:38 -0700 (PDT)
Subject: Re: [PATCH v6 5/5] libtraceevent: Add tep_print_selected_fields()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210812085929.54832-1-y.karadz@gmail.com>
 <20210812085929.54832-6-y.karadz@gmail.com>
 <20210819125510.0b0b04c2@oasis.local.home>
 <a15c7f5f-aa16-7e34-f2fe-bf05a13069e5@gmail.com>
 <20210820103510.6125dda1@oasis.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <f4169550-33ec-46a0-ff25-3b05217d312b@gmail.com>
Date:   Fri, 20 Aug 2021 18:05:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210820103510.6125dda1@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 20.08.21 г. 17:35, Steven Rostedt wrote:
> On Fri, 20 Aug 2021 16:36:12 +0300
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 		if (field_mask & ignore_mask)
>>>> +			continue;
>>>> +
>>>>    		trace_seq_printf(s, " %s=", field->name);
>>>>    		_tep_print_field(s, data, field, &parse);
>>>> -		field = field->next;
>>>>    	}
>>>>    }
>>>>    
>>>> +void tep_print_selected_fields(struct trace_seq *s, void *data,
>>>
>>> As the above is an API, it needs a kernel doc type comment, and also an
>>> addition to the man pages. The man page may be a separate patch.
>>>    
>>
>> I was thinking of maybe changing the second argument of the function to
>>
>> void tep_print_selected_fields(struct trace_seq *s,
>> 			       struct tep_record *record,
>> 			       struct tep_event *event,
>> 			       unsigned long long ignore_mask)
>>
>>
>>> -- Steve
>>>
>>>    
>>>> +			       struct tep_event *event,
>>>> +			       unsigned long long ignore_mask)
>>>> +{
>>>> +	print_selected_fields(s, data, event, ignore_mask);
>>
>> respectively here we will have
>>
>> 	print_selected_fields(s, record->data, event, ignore_mask);
>>>> +}
>>
>> This way the call will look cleaner.
>>
>> 	tep_print_selected_fields(s, record, event, mask);
>>
>> instead of
>>
>> 	tep_print_selected_fields(s, record->data, event, mask);
>>
>> But on the other hand, this will make the new API inconsistent with the existing
>> "tep_print_fields()" API bellow.
> 
> I think we rushed the libtraceevent APIs :-(
> 
> There's a lot of them I hate, and I agree, passing record would have made more sense.
> 
> I've been thinking of reworking a lot of them, but we need to add new APIs.
> 
> tep_print_record_fields()
> tep_print_record_selected_fields()


OK I can add those two.
Thanks!
Y.


> 
> ??
> 
> -- Steve
> 
