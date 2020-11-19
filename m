Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A2DC56201
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 17:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C041246A7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 17:48:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aSrubwM/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgKSRsf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 12:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgKSRsf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 12:48:35 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7116CC0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Nov 2020 09:48:33 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id f20so9124463ejz.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Nov 2020 09:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hk41K+Mm9S6El3NKfj+hoMmiOH7nmA9+Eg8Xv2FqYr4=;
        b=aSrubwM/J+6AvxBuoa/pWRD4MstvCym4s0f7bALvmi8hWqUFmJF6LQOWEoyb1JxoXF
         qVo+CLuyrHUdBM35G5TIp9eEfxHnCppCzDBnMZfeB8wqG9rhDaNjAFa397f1sRBu4q2c
         b5pmAHMNPjGnBRJcCYO0Jh6EindFdK/JtM8vbxNRxgg7xPAvDlIqtL44/tLBIXmhtmeK
         pN0LKaMFgvk+3nSxBkIo2e8OHBBKKI1D2BXtzO4i7fdDcCHjCkb5lEy+sTtH/yOpB6LU
         fMBQR7fVfor9fXy3cVDdy7MxRKSX4PTmm8vp/u+MO5WXUqDO3vqLfxY4NPmat71i4hD7
         3D6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hk41K+Mm9S6El3NKfj+hoMmiOH7nmA9+Eg8Xv2FqYr4=;
        b=nZ2CihoasBgLFnyjj3MVAGGiIkurJKE/uOr0guLjfrJ2JUhRzBspVwCSRe0VPBT51O
         rnFykfGwSOyQvZdEDunsqbllHzN6s2YlxGwVzquujpJRAbd/phyEMphRJfOBxHB93JaY
         c95Efabmh6u5wekLrI0xTCYkXWyz3dCn+fYqu+kEEyHusge9AcRse4GBZrGEMIAH31aj
         xh/1S2RYWMyoPPhZKDCzotV/QENn1Fw+U5SU2BHjAIFBhwA827sCvKpDZ3yMfdC1A7vi
         8JaUoB/UnBYWrhCYpal4AJ17X/68g3eYWLiJbq+7jwFHKwdiJGm911M/v+ofU9u2Sh9/
         5oPA==
X-Gm-Message-State: AOAM532RL+Zks5P4cCJQqBHgdgH93HskRphKLSa2r7H8u8tA8StbZv2n
        K+Cb5WIYsmgmMHLJlcUQafDdkJ+xLMs=
X-Google-Smtp-Source: ABdhPJxrNOI35XeyncTLpWDCoqKgVrFkM7eAsosoc1fNjRYbxXmiDtTIUkS6cX0qKMBpP1AmFC+QeQ==
X-Received: by 2002:a17:906:3644:: with SMTP id r4mr29336807ejb.517.1605808111999;
        Thu, 19 Nov 2020 09:48:31 -0800 (PST)
Received: from [192.168.0.108] ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id s12sm88104edu.28.2020.11.19.09.48.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 09:48:31 -0800 (PST)
Subject: Re: [PATCH v4 14/20] kernel-shark: Provide merging of multiple data
 streams
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201118145003.156542-1-y.karadz@gmail.com>
 <20201118145003.156542-15-y.karadz@gmail.com>
 <20201118210025.0bc6326b@oasis.local.home>
 <83fe0b27-f5cb-a1cf-6afd-bf48cd2f61bc@gmail.com>
 <20201119114337.01d5657a@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <5ed5fd96-4c8b-7fe8-56d4-47f09df9dce5@gmail.com>
Date:   Thu, 19 Nov 2020 19:48:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201119114337.01d5657a@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 19.11.20 г. 18:43 ч., Steven Rostedt wrote:
> On Thu, 19 Nov 2020 18:14:36 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>>>    
>>>> +
>>>> +	if (sd < 0) {
>>>> +		kshark_free(kshark_ctx);
>>>> +		return 1;
>>>> +	}
>>>> +
>>>> +	/* Initialize data streams for all buffers in this file. */
>>>> +	kshark_tep_init_all_buffers(kshark_ctx, sd);
>>
>> And here is the place where it opens in separate streams the other
>> buffers that are in the same file.
>>
> 
> Ah so it requires that the file have buffers recorded. OK, I'll try it out.

Hi Steven,
If you want to open a second file, just replace 
kshark_tep_init_all_buffers() with another call of kshark_open().

I will wait to see if you will find more problems before sending v5.
Thanks a lot!
Y.

> 
> -- Steve
> 
> 
