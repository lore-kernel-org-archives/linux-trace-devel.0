Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39169C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 May 2022 09:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiECJ3P (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 May 2022 05:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbiECJ3O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 May 2022 05:29:14 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8425D24F08
        for <linux-trace-devel@vger.kernel.org>; Tue,  3 May 2022 02:25:41 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id l7so32330845ejn.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 May 2022 02:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vd8kmIfGakas31gBbLGGUvZvOBZIRBIngHN3e3jsAzs=;
        b=NNelJC5g9/a1KrDpBeGBiXyPANaTnS1+C1ICEjS4MVuKiI4PQoT5BpFO4bHQxY9MCv
         aZ27SFVATpLqwuMAt6WMD3MTczVzmzOzVlgm/Wt2y5LnpabgNQ28uDbINCw4yWlcSJtE
         Bh1A9LE8nMnFAagMb7y7Xh6gzsyhbhY5l3xVQgP/4ttBJC6vjSF2vJxhXMD5oH0X+cmL
         C7r7HwRk2iqMAzKoCtiVULmmE7YaQEreqWGj4lsgzJBa0Q1PU7l5KXP40XNF9aJR9+u9
         vk6cu9HEhmW+q2boV1zE+m03cpdtSoKQVU/oBCZXsyiCVn/2tAYyBAt3zBhryj6mdWCS
         RxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vd8kmIfGakas31gBbLGGUvZvOBZIRBIngHN3e3jsAzs=;
        b=dAov41SnIxb/TCDUhIfLLG03we0XG1uMj5KDW5TvRlFGWt0YibUQFbqO3PBmRZoziE
         zETfTFGirVKRtVFtYYgVzv1b/M1nl445N3Tnd7pM/XXgSMzkYKe0atvojNL5u1HoXivB
         P5CSRZk4guw4Q1kKWv7idBJuPH9/7M6VvKDuXGArixlx6SfV+k6X6bhbr6xEaPdpLQAM
         P2JKgrMJE56fm6z5Hkc/bYJWvr+MGCYS6vzwHpbPvHXWEYnBS3tQjwJYL5gsok/FSutp
         326HNloIePGUk3+37kJRoWvXNzoaas0GPd9OaF6kTGS/BHrkL9pb2bzuql4JNsl09PR4
         wEmA==
X-Gm-Message-State: AOAM532LlSt+gRckS6vdXsDI268yQTcBRex3BeQ+n0qhW3hSg40D/tG8
        FvgzFlPOmo8E6nYGB/xU6PrDbGaXwjs=
X-Google-Smtp-Source: ABdhPJwln55iaCT2mOMwJ/oaELT2Q/uny/WSmP1j9d2RqZ6R/C1rDlOoUDGPm1fGZBG4Pn/fdlxYbw==
X-Received: by 2002:a17:906:fad6:b0:6f3:9ea7:1d49 with SMTP id lu22-20020a170906fad600b006f39ea71d49mr14692215ejb.635.1651569939926;
        Tue, 03 May 2022 02:25:39 -0700 (PDT)
Received: from [10.107.141.106] (78-154-14-53.ip.btc-net.bg. [78.154.14.53])
        by smtp.gmail.com with ESMTPSA id jl26-20020a17090775da00b006f3ef214dbdsm4392172ejc.35.2022.05.03.02.25.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 02:25:39 -0700 (PDT)
Message-ID: <0f47c8a7-1d42-fdf4-962a-cb15b8edb424@gmail.com>
Date:   Tue, 3 May 2022 12:25:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/3] trace-cruncher: Update github workflows
Content-Language: en-US
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220503064857.260937-1-tz.stoyanov@gmail.com>
 <20220503064857.260937-3-tz.stoyanov@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220503064857.260937-3-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 3.05.22 г. 9:48 ч., Tzvetomir Stoyanov (VMware) wrote:
> Recent commits add functionality for function name to address resolving,
> using bfd library. This breaks the github action, used for
> trace-cruncher CI, as it does not have bfd development files. Updated
> the workflow with bfd development package.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   .github/workflows/main.yml | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/.github/workflows/main.yml b/.github/workflows/main.yml
> index a9520e7..0d72bbf 100644
> --- a/.github/workflows/main.yml
> +++ b/.github/workflows/main.yml
> @@ -17,7 +17,7 @@ jobs:
>         shell: bash
>         run: |
>           sudo apt-get update
> -        sudo apt-get install build-essential git cmake libjson-c-dev -y
> +        sudo apt-get install build-essential git cmake libjson-c-dev binutils-dev -y

This must be added to the install instructions in README as well.
Probably in a separate patch.

Everything else looks good to me.

Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

>           sudo apt-get install libpython3-dev cython3 python3-numpy -y
>           sudo apt install python3-pip
>           sudo pip3 install --system pkgconfig GitPython
