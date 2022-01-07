Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74984C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jan 2022 12:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiAGMbA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 Jan 2022 07:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiAGMa7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 Jan 2022 07:30:59 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C63BC061245
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 Jan 2022 04:30:58 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id a5so6833313wrh.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 Jan 2022 04:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ftSPQFBEvDhhliSg+KG3AFN9/l3Ji1vuTCkj9roMqnc=;
        b=C15S24Ha1FGMcaZfD1YqHnRGCOKpiem0WDaexJGoSFNYI8ktpyYbE8B5rqBE7xsij2
         lCSEPBg1+sUYzxhY6qbRO1PDlAC0yIZEx+pb7ZOPjNzzHPUFv59QIsDPY6v50XHovQ7h
         Tw7Vnm1qqtQrp8KJCw+22pp92yttorpxpL/paqWHnNuunJxZaRrqmbm+0wTeee6Se6Ha
         wongNeDiSpommHVBIKBT+8KGW9g6t85IuuEb8OsTzJVVIeB9mzWdnT9PsXjdQ2U4Y8vw
         BAwFGZ4zg44gwvvWB3ijJA2Rl418eKaPJ5rzWvBzfD/SYTqxGMHMqpEt2cxmmi9bwpi1
         JXFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ftSPQFBEvDhhliSg+KG3AFN9/l3Ji1vuTCkj9roMqnc=;
        b=6iWJwUfcmyOuDJYa1+u2jO/8wzIjT+4gpfqfSsjvFz3vcYyCO6oKoMQkexMpvBdQOI
         EcyjGlDMUd1yQ7pR1ONC0eXzeXym9vRieCYcnizNTmnidDPIQclfcCaN94lWXx1feG0t
         qNzyBCCPquyNkSmnwlyJcmyKRt9/Uv087QjlwjfApwVwdWcfNlEibqNK1AE0FYq5CPll
         4RI0BZ/zxTw0htNC2QDBighBOGUj9hZjUhOrw25jbhnKggS1hSa5XstypUy0fQavGZDg
         jFUxwtVGq6zE637oVkIamqbPySkmemf79V3wIi2nY58XRb3qpPttgieMkvPuNaeppcIp
         eiZA==
X-Gm-Message-State: AOAM533HNLibMLcrhys3PeOlRPqKOmpMUwoS2eO8AYPwmEs4YSFAxhZl
        vIobIY5zKtSU3RQnYFTv8l7bYNZ88P4=
X-Google-Smtp-Source: ABdhPJxQRnAJr0+BbH2JqRpvO5rocGO+fcQipnrbNf0nikbWjQoMsh2apgK7Prdmk0mlI84Hf3cngQ==
X-Received: by 2002:a5d:590e:: with SMTP id v14mr54478075wrd.208.1641558657119;
        Fri, 07 Jan 2022 04:30:57 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id y11sm4614007wrp.86.2022.01.07.04.30.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 04:30:56 -0800 (PST)
Message-ID: <2698d05c-786c-ab37-2637-8dabdcf3a52d@gmail.com>
Date:   Fri, 7 Jan 2022 14:30:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 2/2] kernel-shark: Add plugin for handling Xenomai
 cobalt_context_switch
Content-Language: en-US
To:     Jan Kiszka <jan.kiszka@siemens.com>,
        Hongzhan Chen <hongzhan.chen@intel.com>,
        linux-trace-devel@vger.kernel.org
References: <20220107021846.893-1-hongzhan.chen@intel.com>
 <20220107021846.893-2-hongzhan.chen@intel.com>
 <9e84f570-f9f0-fcdb-e6e8-7b08fcb2932c@gmail.com>
 <059411fb-b691-7bb1-9acb-7d4b005f1bc0@siemens.com>
 <50c5932c-d35b-3739-0277-508c69be9a7d@gmail.com>
 <1e49fdf9-5720-7703-778c-625a010700e8@siemens.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <1e49fdf9-5720-7703-778c-625a010700e8@siemens.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 7.01.22 г. 14:27 ч., Jan Kiszka wrote:
>> The whole idea behind the design of this interface is to be friendly for
>> external plugins.
>>
> OK, that sound motivating to look into the external path. I suppose only
> the auto-loading topic should be improved then.
> 

Sounds like a plan.
Y.
