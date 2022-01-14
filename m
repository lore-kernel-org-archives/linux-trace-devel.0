Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D471C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 Jan 2022 14:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242099AbiANO6D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 Jan 2022 09:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242086AbiANO6C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Jan 2022 09:58:02 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F233C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 06:58:02 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id q141-20020a1ca793000000b00347b48dfb53so6061617wme.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Jan 2022 06:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=b7UwYO8/wMRzYMOJPuADe2XfGiDKPFwV/xVqM3jqbPQ=;
        b=ahYnKwaX4ezL+XWj7EMKtly9bmlb74EK5gsNHgXP8uB92xWbtAaCvvuM90cqtzTvEZ
         Fhh4aE9lbYpY8v5zAarheaOOS5FLixxLKKlGDgx6OHNsBpUPwKpUxhYnM2ZKLRK+YVGR
         zZ/6v57Uhmt6cAh9iNOgJZ5UtbrZnARL9WIbGhRPAcLGasV6yKUhgWepdEixUFm38Bl4
         0TuDk2Rb0wbl9lZfdbXE2uPNy1+hevjsHIC48WFkQ2wa+KoLkJpci+hNJZTuhiyHKbNc
         9wbheRZ05+5sOgGrsudS3jZWW4ns0z1BvhHmNd4jGwpKqj8RFRlZF+nIMFTQA0pcyQu3
         92mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=b7UwYO8/wMRzYMOJPuADe2XfGiDKPFwV/xVqM3jqbPQ=;
        b=A5tHRO2J3MNIHbwqloXTqaYBNuAD3Z9nHpPeywV6bBqx8KbcvkQoyjgehxQF1QNjhh
         ikDNrTQcBZCGRUofEPDYwzZQHS/CFDkCJ3elytmC/7Q4HSZMvzfih9m/EUTOwzfOgepR
         HJ8mQjdBbAr//fb03FvjleKPGInKXOoHJVTyOmWFlC+AEbXPzLLKtMhu1g3/1R9QDYCe
         v4BlRW8lVk90Il9+X6XLGGkZubjWo8p9Gb348TkKbRJDlK/pFzltLgxCGmLQin25yNtT
         nPXuMKz9T0nzezrOfu+BN03wazgClxk48XFm1re0VYOtRT4DcaZrPljKJ13/Edp92QqM
         9cBg==
X-Gm-Message-State: AOAM533E68DFTZ9bpaMZYzDzVB6wMbOMI58cqzWqHt8uHzlv0Yjv0rCe
        Lo4uELwB4pW7QxLPd+YF23N8oh7bSk0=
X-Google-Smtp-Source: ABdhPJzH8+7d8My7uX6h+D72n4pmNf5RO4v0zcN/+HtroRM9TBsFRGu395AkVrfGCx3AhLy4qsTedQ==
X-Received: by 2002:a05:6402:486:: with SMTP id k6mr9399569edv.330.1642172281087;
        Fri, 14 Jan 2022 06:58:01 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id z19sm2494219edd.78.2022.01.14.06.58.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 06:58:00 -0800 (PST)
Message-ID: <bfd749a9-3c82-74e6-a4c4-a1dfd5f7f66d@gmail.com>
Date:   Fri, 14 Jan 2022 16:57:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2] libtracefs: New API for getting synthetic event
Content-Language: en-US
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20220113170059.82747-1-y.karadz@gmail.com>
 <CAPpZLN4ik3=Wp6W7auSUEE0t83SneWG+1njw5tHq_tp=xmOhEw@mail.gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <CAPpZLN4ik3=Wp6W7auSUEE0t83SneWG+1njw5tHq_tp=xmOhEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 14.01.22 г. 12:12 ч., Tzvetomir Stoyanov wrote:
> On Fri, Jan 14, 2022 at 10:17 AM Yordan Karadzhov (VMware)
> <y.karadz@gmail.com> wrote:
>>
>> A new API is proposed, to get tep event descriptor for given synthetic
>> event:
>>
>> tracefs_synth_get_event ()
>>
>> The API implementation gets derived from the implementation of the
>> existing API  tracefs_dynevent_get_event(). It can detect any newly
>> created or removed synthetic events.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   Documentation/libtracefs-synth2.txt | 13 +++++++++++--
>>   include/tracefs-local.h             |  2 ++
>>   include/tracefs.h                   |  2 ++
>>   src/tracefs-dynevents.c             | 17 +----------------
>>   src/tracefs-events.c                | 21 +++++++++++++++++++++
>>   src/tracefs-hist.c                  | 18 ++++++++++++++++++
>>   6 files changed, 55 insertions(+), 18 deletions(-)
>>
>> diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
>> index 8056ab8..444318c 100644
>> --- a/Documentation/libtracefs-synth2.txt
>> +++ b/Documentation/libtracefs-synth2.txt
>> @@ -6,7 +6,8 @@ NAME
>>   tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd, tracefs_synth_complete,
>>   tracefs_synth_get_start_hist, tracefs_synth_trace, tracefs_synth_snapshot,
>>   tracefs_synth_get_name, tracefs_synth_raw_fmt, tracefs_synth_show_event,
>> -tracefs_synth_show_start_hist, tracefs_synth_show_end_hist - Creation of synthetic events
>> +tracefs_synth_show_start_hist, tracefs_synth_show_end_hist, tracefs_synth_get_event
> 
> The new API should be added also in Documentation/libtracefs.txt, the
> main man page with all APIs. Forgot to mention that in the previous
> review.
> 

Hmm, I see absolutely no tracefs_synth_*() APIs in Documentation/libtracefs.txt.
Maybe this can be fixed in a separate patch.

thanks,
Yordan



> [ ...  ]
> 
> 
