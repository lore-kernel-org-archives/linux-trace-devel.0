Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B601C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jan 2022 10:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiAMK7J (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 05:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiAMK7I (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 05:59:08 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F4AC06173F
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 02:59:07 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id a18so21576700edj.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 02:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=TxvMwpOLor78NZKCHNLXOweDdKUjBmcZ6ud3Zh/lnCw=;
        b=QRkJNRDn/mqLH0nMVUkqlqdTUKSDa+XuRnJty3iogrCJQ36Sw//auHGGSkvyM1d/YO
         UfiCEbT066I4nPIOdP9FmP0OY2RG/KOAXGkPr5D/h+CJRuDE7fgv2lCPVer4l814V7/5
         3gemEh5BW1miO/MJV6nPC9zGcKt+E8luThKkJ9K8KcHuqdDc4DM1MTN8cUVUbUJnTRxo
         gvTvi+YKuYw/L8dYdArO0dnvcT7U8hG2DgWtvAFOgmjI7BQ5EW/VxsxD2pA0Gay97ayF
         DjjS5o7SBCqz1Y7MYxcFh/wDqf0eYRziWpr23lLSguFdNEkRHk7OkHA5TphnPXymjUXj
         SmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TxvMwpOLor78NZKCHNLXOweDdKUjBmcZ6ud3Zh/lnCw=;
        b=qDIEK7uaIfYdF2xMbURhP57kGMRMHUqNc/jpp+MefHbcEV18HkyeRnveKfQmnI7WHG
         LYZ7BKndlu4IuIqSnO3v01VLoemTI+1xQWF/LBb9DDL68ySWg7GRWSJRGm63ZIUWxt90
         HPMh9zGiV9qFn/g/Eb/Hb67SqBrLO9U5OVHjwWepzcgQmoLcHdqaHyVu76aj1yXKQFWX
         MJrjfgYJOu3PBcFOJjIoDo3npfxI3mFXddaFN/xKTWK8uRddojytURVZs/1w/7SaKTDg
         kGkBq79TSQwZK3u4ryxAlmH79oBKNq3lfQLYolqfYEW79RWVJfdEKiwadvij4btVpBoR
         JUag==
X-Gm-Message-State: AOAM533QoaRXp3Ha/atQVkPI3JzFaaNNK8g+7h0HGGQwubnB/kKbsblY
        zQM5AQra3MdqCp9FVnYzMcs=
X-Google-Smtp-Source: ABdhPJy+dzQY9omY3JrITzrdnQ1/KhMUk017kHGWt6BB/xlJR0oyWkM6xStR/LKVN9FOkSCoB1mGCw==
X-Received: by 2002:a17:906:bc97:: with SMTP id lv23mr3045326ejb.506.1642071546213;
        Thu, 13 Jan 2022 02:59:06 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id di5sm760850ejc.45.2022.01.13.02.59.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 02:59:05 -0800 (PST)
Message-ID: <05f09514-3455-0f8d-c577-f11e04b67df9@gmail.com>
Date:   Thu, 13 Jan 2022 12:59:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] kernelshark: Fix "undefined reference to `glutInit'" when
 using CMake 3.22.1
Content-Language: en-US
To:     Michal Sojka <michal.sojka@cvut.cz>,
        linux-trace-devel@vger.kernel.org,
        tzvetomir Stoyanov <tz.stoyanov@gmail.com>
References: <20220113004559.1624414-1-michal.sojka@cvut.cz>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220113004559.1624414-1-michal.sojka@cvut.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Michal,

It is cool that I received two fixes of this issue in the very same day.
I think this is a good vital sign for the KernelShark community :-)

I will take Tzvetomir's patch
https://lore.kernel.org/all/20220112153805.222437-1-tz.stoyanov@gmail.com/

since his solution does what Cmake recommends.

Anyway, thanks again.
Looking forward to see more KernelShark patches from you.

cheers,
Yordan


On 13.01.22 г. 2:45 ч., Michal Sojka wrote:
> When building with cmake 3.22.1, the build fails with the following
> errors:
> 
>      /bin/ld: dataplot.cpp:(.text+0x17): undefined reference to `glutInit'
>      /bin/ld: dataplot.cpp:(.text+0x62): undefined reference to `glutDisplayFunc'
>      /bin/ld: dataplot.cpp:(.text+0x6d): undefined reference to `glutMainLoop'
>      /bin/ld: ../../lib/libkshark-plot.so.2.0.2: undefined reference to `glutInitWindowPosition'
>      /bin/ld: ../../lib/libkshark-plot.so.2.0.2: undefined reference to `glutInitDisplayMode'
>      /bin/ld: ../../lib/libkshark-plot.so.2.0.2: undefined reference to `glutInitWindowSize'
>      /bin/ld: ../../lib/libkshark-plot.so.2.0.2: undefined reference to `glutCreateWindow'
>      /bin/ld: ../../lib/libkshark-plot.so.2.0.2: undefined reference to `glutSetOption'
> 
> The reason is this cmake commit:
> https://gitlab.kitware.com/cmake/cmake/-/commit/f90d15458a9a98180fcc95158f2ab5d2b1ad3152,
> which changes how the glut library is searched for. Specifically,
> pkg-config is newly tried before other methods.
> 
> When pkg-config finds the library it doesn't set GLUT_LIBRARY variable
> used by kernelshark, but only GLUT_LIBRARIES, as mentioned in the
> official documentation:
> 
>      https://cmake.org/cmake/help/v3.22/module/FindGLUT.html
> 
> Therefore, we should switch to using the documented variable.
> 
> I also tested this change with CMake 3.21.2 (before the mentioned
> commit) and it works.
> 
> Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>
> ---
>   src/CMakeLists.txt | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
> index babb9c1..e4cf78f 100644
> --- a/src/CMakeLists.txt
> +++ b/src/CMakeLists.txt
> @@ -59,7 +59,7 @@ if (OPENGL_FOUND)
>                                        KsPlugins.cpp)
>   
>       target_link_libraries(kshark-plot  kshark
> -                                       ${GLUT_LIBRARY}
> +                                       ${GLUT_LIBRARIES}
>                                          ${OPENGL_LIBRARIES})
>   
>       set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
> 
