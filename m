Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BB1C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jan 2022 12:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbiAMMlU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 07:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbiAMMlR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 07:41:17 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21556C06173F
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 04:41:17 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id 30so22614855edv.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 04:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Z/L23QrtvTCL5cfiBFgked6t+mmLhewKy9Bni1VP8vI=;
        b=i65AqlbCKDXAur2fdf/n90A6rleumgtpg1x1LWLuJ76xEq1TIBvKmLFy/cZHoe8k/5
         oBQ67+cWVAgaZRJaUF9pIV/SFn0oikGfQT7Yq777f4cYqHs0VFWkGWKWDv2tYf2XX4Cf
         MGed3ON0o5qRXQCDOEawbV1l282bQbnoizeFluTeIeKQPpH6+sDgnC3ziFWUke38WvNz
         XpGn9S49vqb0URXgvgvyXMMUFETt2ZOyUJLZJdot8RvIgPRs/SmqFdjabgi5wj8gB5uo
         QFKPuo9Eszs6BqhHDqhOYJGJgobHWLRhT5IGhS11TS4v/Sg3enwyEDUqSUU8OzFJ765c
         hrsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z/L23QrtvTCL5cfiBFgked6t+mmLhewKy9Bni1VP8vI=;
        b=aayzqfIr/O+5sSVnVdL+nMMd6uk/LUpi/5eylGLH5vWcbusptcdQEpkIyiKP7qCp2s
         fnhZQQ3olK8Es88QfGFyVTTjth8EoVxfGFcwTAjubGIeyWMyk9YWNhvR3g3Y5AvO1T3H
         fFozNdPRQvZJ6SCsRAerDer/R3bgWyG00K2Im7tJGB0Tk/f4FGq1/pYPQFW3jWsY39Mc
         KCx4zxNNv7Jm5A35/VTd3FFWcEWl5jtT3QfmvzyV6nzvOcrGsBfVVhL/4/gjoSmgEFhx
         w9hC+R6sEiHMB/UXLTJkhWqJvR/3vE4pai0kbhHv9E8zPI4rjsXZ+ribUcl40wQBUOsh
         GeJg==
X-Gm-Message-State: AOAM531IHmUZDxsAEl8IEKBhzDBs1QaaF6AOLjSKUxeOtYRNO3p8b65g
        KJCjCZpzQihTUkQWeUlpiMk=
X-Google-Smtp-Source: ABdhPJwKhzdbM1qBfnjY++sYn/2kXJlItdQ8Zd+KhulhB5vfnvuIXN+PjNm4yww3yRhjb6zot02d8A==
X-Received: by 2002:a17:907:a41f:: with SMTP id sg31mr3351493ejc.640.1642077675691;
        Thu, 13 Jan 2022 04:41:15 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id j5sm842134ejo.171.2022.01.13.04.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 04:41:15 -0800 (PST)
Message-ID: <5891ee9c-ef5d-9f9e-c90a-2cdfe4f21cce@gmail.com>
Date:   Thu, 13 Jan 2022 14:41:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] libtracefs: New API for getting synthetic event
Content-Language: en-US
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20220112163619.21762-1-y.karadz@gmail.com>
 <CAPpZLN7=q-DiOQWDmv5SdV7xyu9TCHHZNP_Cfq4Gdo2c2GMMPg@mail.gmail.com>
 <38d4a2a8-5110-2c19-be01-53a820726383@gmail.com>
 <CAPpZLN7C7dBzzBuvtofz8zYh33utTzDC2x85MGPN2oGPvoksKA@mail.gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <CAPpZLN7C7dBzzBuvtofz8zYh33utTzDC2x85MGPN2oGPvoksKA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 13.01.22 г. 14:37 ч., Tzvetomir Stoyanov wrote:
> On Thu, Jan 13, 2022 at 12:26 PM Yordan Karadzhov <y.karadz@gmail.com> wrote:
>>
>>
>>
>> On 13.01.22 г. 7:01 ч., Tzvetomir Stoyanov wrote:
>>>> +struct tep_event pass:[*]*tracefs_synth_get_event*(struct tep_handle pass:[*]_tep_, struct tracefs_synth pass:[*]_synth_);
>>> The arguments of the other functions in this man page are not
>>> underlined, all should follow the same style. As in the other man
>>> pages of the library all arguments are underlined, this should be the
>>> default style.
>>> This could be addressed in a follow up patch - applying the same style
>>> of all tracefs man pages.
>>>
>>
>> So, do I have to change something on this particular line?
> 
> This line is OK, I'll submit a patch to unify the other man pages. The
> arguments should be underlined.
> 

OK, I will send v2, fixing the other problems you found in your review.
thanks,
Y.

>>
>> Thanks!
>> Yordan
> 
> 
> 
