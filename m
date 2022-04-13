Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520B4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Apr 2022 12:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiDMMti (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Apr 2022 08:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiDMMti (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Apr 2022 08:49:38 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BF2DF1E
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Apr 2022 05:47:17 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id u3so2472207wrg.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Apr 2022 05:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZifGF6FfFEgmy2WY54jaqdhppmAiYW9Ms/iWjDTFO9E=;
        b=IKqbtge78EIBQXHcKkXHGRu9emEBcfiWjCu+9Te5tanxgXM9Q6eSPvy4YvY8wY37Ph
         qRAdYdvvF/avLRix07uDP+0vh9pZqZpF0Acl/uT5oxnUPqCHdW5qswwd0guFhcFvUHUD
         7V0ltZVMcbUUxBeZVb8hcPLxf3DLqv66KpNWox53UTUXFMo5mT4oq1w3YtNfq7jKoxS2
         SKMr0LjABwGOdVb3JVLM6FRnmwMItJ0w188YN3Je9EXzlqKOME/YR82xqc5fs1rlkSIr
         NA+QgBT4sVfUuusbbj8ggI+7BeUK+AEBybP2wPeUfOrbFGNQfjQOMS74raXOTrSpPf6m
         PJog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZifGF6FfFEgmy2WY54jaqdhppmAiYW9Ms/iWjDTFO9E=;
        b=nj/237NxS1/7PJ+18kLLnVk1U3x3i1r6Wxbd7UzIYWwcQ1US+BKzb2sZsI8iGSjaUX
         oPRozdQqJOYvxEDy8W/YavMcl7diWEhasHs/86v0SE+c6LwxVKMcGWLC2h7CaOkpl3Lb
         7bmQHGEXGkB1uzbqndPz/2K9tjIEBUFgLiliVhDxioXYQaRLrMIXRXAc3i/9Bl/rovqq
         C4a+ei311grmZBvuDOWOJ7BrTzyv3tkTAvFLp19Rbfjb8AXbJGhaEJAhuNTUB4qiRSEl
         Xa5BII3tYexep3cgqtiq3aGBBj1O8LvZhUK+pyeVI3YAmtTBCwUPFIBfiZwsrQBzn4C0
         Ihyw==
X-Gm-Message-State: AOAM532hsZwrCcGtFcSh9snKbsL2NavYc6MolDpGv+zyef0AVhfifrKE
        w89u6z4/7DAfRgS9xneGdAqYc92Bxeg=
X-Google-Smtp-Source: ABdhPJzLDpLXzOZ1XtW1xQz9IlKHoRUhU8RgOgS79631iT9pB5OGa6qCHOnW2xlFl7X4tJvyf16j4Q==
X-Received: by 2002:adf:f98e:0:b0:207:9eed:60d8 with SMTP id f14-20020adff98e000000b002079eed60d8mr16677842wrr.566.1649854035856;
        Wed, 13 Apr 2022 05:47:15 -0700 (PDT)
Received: from [10.107.106.54] (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id d20-20020a05600c34d400b0038caf684679sm2723300wmq.0.2022.04.13.05.47.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 05:47:14 -0700 (PDT)
Message-ID: <54a182cf-3452-ea7a-7f9f-947a877b9212@gmail.com>
Date:   Wed, 13 Apr 2022 15:47:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] kernel-shark: Add instroduction of external Xenomai
 plugin
Content-Language: en-US
To:     Hongzhan Chen <hongzhan.chen@intel.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220411020339.363-1-hongzhan.chen@intel.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220411020339.363-1-hongzhan.chen@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Applied.

Thanks Hongzhan!
Yordan

On 11.04.22 г. 5:03 ч., Hongzhan Chen wrote:
> introduce external Xenomai plugin in README as a reference to
> implement and build stand-alone plugin.
> 
> Signed-off-by: Hongzhan Chen <hongzhan.chen@intel.com>
> 
> diff --git a/README b/README
> index 37ccd95..d3bceaa 100644
> --- a/README
> +++ b/README
> @@ -114,6 +114,14 @@ CMake examples:
>   
>       cmake -DCMAKE_BUILD_TYPE=Package -DCMAKE_C_FLAGS_PACKAGE="-O3 -pedantic"  ../
>   
> +External plugin example:
> +------------------------------------------------------------
> +    KernelShark also supports stand-alone plugin except for build-in. There is
> +    a real example under https://source.denx.de/Xenomai/xenomai/-/tree/next/tracing/kernelshark/,
> +    which is to visualize out-of-band state of realtime task with hollow cobalt
> +    blue box mainly when there is cobalt context switches in Xenomai. As its
> +    implemention mainly refers to build-in plugin-sched_events, it shares common
> +    plugin features such as clickable shapes.
>   
>   Contributions:
>   ------------------------------------------------------------
