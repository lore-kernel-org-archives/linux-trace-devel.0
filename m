Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C905C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jan 2022 11:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbiAMLAC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 06:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiAMLAB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 06:00:01 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2727BC06173F
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 03:00:01 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id z22so21555516edd.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 03:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lWBb/kF7HWlpEU+y2ZvK7HXzsCfMKdXsEHIYk8B3O70=;
        b=XPvAJhsK7BbSkNo8hvrkkoFiaKZPIlKLPoCVvviYxpg6FSycfeJ1w75XyEtP99tftm
         d3/gMOKAO6eQ123X/O0yuYpHC4E9tsRVZc88ZGNaKXUrIPfah+laaxOnaCQmfwYC53Yn
         gZHRNUID2rfLzJS0EJK04+haluKY2/M/onjt4KNIDq1ymIMJu5mj8gtKX0CFVb/zJf1H
         2UMBS0WMWzVhnMf0Bqb7c0FjJcPioIlayL6cy7JwdE4IQaVEYtyCodntxXu56ZXx8bA8
         eIw1poJgbHoRmI0P5DI0kxCoHX20h+hWbnn+Y8abLeqa9sr/cbFpEh8jdN4eZT2pQpxQ
         EiKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lWBb/kF7HWlpEU+y2ZvK7HXzsCfMKdXsEHIYk8B3O70=;
        b=SDCf5dcYQ3Etb/d9S5+PrDw8b1JjB3DAYZ1wwVs5bh4pbxsu/we78ZC8PMY/bWW4cY
         vYqQDw3+xw02aTk2efb/Bm829NpFL3fwVidF7nzK1qikBYF35xD6ILUhZ/Dgx0SXPUa1
         LGHP5VdCTCq8JvkYWj8R4lI7A37rmoXzoe314bNeVhMWvcblOVbJ5Yz10gqlv56c1oZZ
         vz+E5D4x++y6UgyBxhu0Ozasroa77sWt5XrBHpMd2a7oT3u5Ebayc65KZGa08QqbXBu6
         myeJWcUVubBJyuhu2t4AuNTMFSEcsiMFYyDwB41iUlaW9BB0AVqJZDTWWQK+eqPHrRbp
         1JFQ==
X-Gm-Message-State: AOAM5322Xn4vi4Z33ofQWYrkVHujnCFI3qqGfc8TS9PBesvchhPX4zh2
        vX6T/ZrRKvhv2Ra25eN6rwI=
X-Google-Smtp-Source: ABdhPJyBrAtPVYy53IHtP1qc5SpA1QdJHxDXxX0cVOnFIuU58Jne3OVr8I+MsN7EeG8K2RmOzLtCYQ==
X-Received: by 2002:a05:6402:7d0:: with SMTP id u16mr3538492edy.367.1642071599765;
        Thu, 13 Jan 2022 02:59:59 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id qk34sm747825ejc.143.2022.01.13.02.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 02:59:59 -0800 (PST)
Message-ID: <6c5f8923-4386-cfd9-3c79-6c2f2665f6cb@gmail.com>
Date:   Thu, 13 Jan 2022 12:59:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] kernel-shark: Use cmake imported targets instead of
 variables
Content-Language: en-US
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Michal Sojka <michal.sojka@cvut.cz>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220112153805.222437-1-tz.stoyanov@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220112153805.222437-1-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 12.01.22 г. 17:38 ч., Tzvetomir Stoyanov (VMware) wrote:
> Using cmake imported targets instead of package variables is
> recommended way to define package dependencies.
> 

Hi Ceco,

Please add to the commit message an explanation, clarifying that this patch actually fixes a build failure.
You may take as example the message of the patch sent by Michal
https://lore.kernel.org/all/20220113004559.1624414-1-michal.sojka@cvut.cz/

Michal and Ceco,
I will be happy to see this patch signed by both of you.

thanks,
Yordan

> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   src/CMakeLists.txt | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
> index babb9c1..9e0b4ae 100644
> --- a/src/CMakeLists.txt
> +++ b/src/CMakeLists.txt
> @@ -59,8 +59,8 @@ if (OPENGL_FOUND)
>                                        KsPlugins.cpp)
>   
>       target_link_libraries(kshark-plot  kshark
> -                                       ${GLUT_LIBRARY}
> -                                       ${OPENGL_LIBRARIES})
> +                                       GLUT::GLUT
> +                                       OpenGL::GLU)
>   
>       set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
>       install(TARGETS kshark-plot
> 
