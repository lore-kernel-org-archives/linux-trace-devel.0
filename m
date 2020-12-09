Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9101AC4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 14:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 537D123B42
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 14:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732132AbgLIOPJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 09:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729786AbgLIOPI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 09:15:08 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB83C0613CF
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 06:14:28 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id x6so1898800wro.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 06:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6Lo+jQPhYg2SHUMj7c7W5hF9qqrP9AzYGkOH7kXPNFM=;
        b=g1iKH/uOeiw6cVde6XKzMtYu0CkRXBGtSjEOSL4kH570Misp65EWNAC1fO2p3gzBHq
         SgmGRsGuVSnL1VZ4tm1oyT3+ASONMH8DbBs1/ddKDFhcIgMyykYj8Sa4NUga+NoclTGi
         34vX1KfYOKl/GhEY4z8rr2TlxEXAZfWNVeV8Ps0hoYnNE1AKve7hCadHGuZad8GYn605
         fWfje0iNB6iqfCeg60yTOV7YNOVWnPMURvtPNxwV/AowL+BW2IiHKoH/QkQXpR+9a7+u
         VvDCSdP0NhU/g6zdbtjBgRQmQ9sm3XOb00LnvTPYeT+0PYkeUohGr/x0YnuoYk9JC2LC
         hLoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6Lo+jQPhYg2SHUMj7c7W5hF9qqrP9AzYGkOH7kXPNFM=;
        b=kt6KMQoLXZwvaqVVq+Mp/RFg3aK99qXSBqvjywCn++sjRKOCH7n/mpjouRRzfChjGT
         eEgJOVAJT79TD7nIFndMGCKGLti+E9B/YwDjsrOtzoIQLdD7KmmCc1JnLb4/LLi/7GjM
         gy8d7/k4UYE1sPHmgt1FhG4WbCUnSAXMvgfpg4YEdIua87Oxr2etYDJQso27ndY36IiL
         xr6tUd4pULc5Jxb7oPWRZqAufDa5ekXHhxkWLjBqSxG/D470/JNOei7eApErCTta8Drg
         blM6svENop2uX3KUmVMzWV2Ezpso0u387Rxy9Im7LZuwFWY6vXjUk9IUi59VrjZ7lu42
         tZkw==
X-Gm-Message-State: AOAM531EXQUXgQoudmEuUhlTggvvjikF4iolBbb4Oi2sllXuYDtQ3Cjd
        KrTEfsJeIL2oqgIyr6D8NyfDuTZ/SX0=
X-Google-Smtp-Source: ABdhPJyJnhAISLYEDy1QEk+lgmsyVHiEeimNYBYxm1yb8rB5laBKv218hrR6Wk7C+cYW1V/DNUgGwQ==
X-Received: by 2002:a5d:5643:: with SMTP id j3mr2862100wrw.43.1607523266940;
        Wed, 09 Dec 2020 06:14:26 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id t1sm3984472wro.27.2020.12.09.06.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 06:14:26 -0800 (PST)
Subject: Re: [PATCH 1/4] kernel-shark: Add support for drawing text
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201120095031.271735-1-y.karadz@gmail.com>
 <20201120095031.271735-2-y.karadz@gmail.com>
 <20201204183127.186a7f87@gandalf.local.home>
 <aebedfc4-1f00-11a0-7c20-61eb927d96e0@gmail.com>
Message-ID: <9ee14e92-3644-486a-6f6c-3f0dd4464426@gmail.com>
Date:   Wed, 9 Dec 2020 16:14:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <aebedfc4-1f00-11a0-7c20-61eb927d96e0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 9.12.20 г. 15:30 ч., Yordan Karadzhov (VMware) wrote:
>>
>>   #ifdef __cplusplus
>>   }
>>   #endif
>> diff --git a/src/stb_truetype.h b/src/stb_truetype.h
>> new file mode 100644
>> index 00000000..62595a15
>> --- /dev/null
>> +++ b/src/stb_truetype.h
> 
> I'm assuming the rest is what you took from public domain?

Yes, the rest is the public domain source code.
Thanks!
Y.

> 
>> @@ -0,0 +1,5011 @@
>> +// stb_truetype.h - v1.24 - public domain
>> +// authored from 2009-2020 by Sean Barrett / RAD Game Tools
>> +//
>> +// 
>> =======================================================================
>> +//
>> +//    NO SECURITY GUARANTEE -- DO NOT USE THIS ON UNTRUSTED FONT FILES
>> +//
>> +// This library does no range
