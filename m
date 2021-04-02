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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F078EC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 16:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF1AC6115A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 16:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbhDBQBb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 12:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236392AbhDBQBb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 12:01:31 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C509AC0613E6
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Apr 2021 09:01:29 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id hq27so7983347ejc.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Apr 2021 09:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=bkyURLR4A4W1yNney3SFQFGw0VXBTpM0W0jnqPB/8kY=;
        b=ngocgpMszIipRhQJhzrQfUNHiTMglFw4vGPl5La3TWgmp/S6JcKIKBV6AYdBIG6+JY
         uf3lqjdb2REphE/9kMIom7ewpoqDRt1RWpNjni5vMT9F1e5pbvSxx+4kfhGhEfHL50tF
         4/DhNbjhg8ZWR5IMvJZndTEYtmwMVSgEYik80dy+9iSDkh21FYzjudBmmw+ZiGpawTae
         lVg4SCjauaEUOy7uBATMDQxrPA+SwduXlKtk+oWkPTRMpsI1pwj9Ji6+4+k7P4NFv5aC
         FqLunipaRJa0H8w6LNYE4IoSvuW3oPqwOsXJ1jrhoLiSF1jhyM3nwkjQ8SXn6tYX6fsz
         Tx7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=bkyURLR4A4W1yNney3SFQFGw0VXBTpM0W0jnqPB/8kY=;
        b=SDYXOhnmnJWg4vCD2UfDNAS/d5OYmpkhsiFchv/NesEePe7UzdknwSxWjiiKR8TlfN
         qxLg5SFvvbR51OUdhUhTvmcU+9y9tqdZJgjL8Rk7wTlseKRX6jVBIo/oSEQPL7xPVQ2P
         G2QMoUQOzoVEjzul84zSyUSxr6nPd/5BXBx3BmlQTeJlcmVctyAncgrcIBwPQfW9K4dp
         hVUPxp35+MEoHo9D7LY+Rwrd6iSG4bCG02VI5Js8/WGnyVM11/4MRObSF12KY5rCL+S4
         13lzUc5Ab8KChGE4wffgL0b3yQHsJcn166PWw8J7TAY7JWHXijDs+z3W5fcHoqURt3+4
         yECg==
X-Gm-Message-State: AOAM532Hh4p/mHqJcVEeMIZjrgq7qeUrpm59+0kUygCbqQMq1VEHZ88Q
        KdRyEWw9z8BjwfBR/AIADMU=
X-Google-Smtp-Source: ABdhPJwGcXQ2UidvCw1GQayPD5WI4xYVS0Xcx7ZSZEf5L/7smXRWkoUTJPShz3zXz9+liPXrHN0onw==
X-Received: by 2002:a17:906:c9d0:: with SMTP id hk16mr14798624ejb.512.1617379288494;
        Fri, 02 Apr 2021 09:01:28 -0700 (PDT)
Received: from [192.168.0.106] ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id gj13sm4317022ejb.118.2021.04.02.09.01.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 09:01:28 -0700 (PDT)
Subject: Re: [PATCH 4/6] libtracefs: Move the "options" code to
 tracefs-instance.c
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
References: <20210402131947.346235-1-y.karadz@gmail.com>
 <20210402131947.346235-5-y.karadz@gmail.com>
 <20210402101756.36879d49@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <d039bfbc-6465-9151-65a1-6c727c0b6ebe@gmail.com>
Date:   Fri, 2 Apr 2021 19:01:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210402101756.36879d49@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


On 2.04.21 г. 17:17, Steven Rostedt wrote:
> On Fri,  2 Apr 2021 16:19:45 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>
>> We would like the instance object to own two bit masks (struct
>> tracefs_options_mask) associated with all supported and all enabled
>> options. However, the definition of the instance itself is not public,
>> hence the code implementing the "options" related APIs has to in the
>> same source file as the definition of the instance.
> The above is not true. We can keep the code in tracefs-tools.c and make it
> "public" for the internal use of the library, but not part of the API. To
> do so, you place shared structures and functions in include/tracefs-local.h,
> and mark all non static functions with "__hidden" which will keep it from
> being used outside the library.
>
> Do you still feel that the moving of this code is needed?

Hi Steven,

Thanks a lot for the review!

I wasn't sure if it is OK to move the "tracefs_instance" struct to 
"include/tracefs-local.h". If this is the case, then I will drop this 
patch and send v2.

cheers,

Yordan






>
> -- Steve
>
>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   src/tracefs-instance.c | 266 +++++++++++++++++++++++++++++++++++++++++
>>   src/tracefs-tools.c    | 266 -----------------------------------------
>>   2 files changed, 266 insertions(+), 266 deletions(-)
