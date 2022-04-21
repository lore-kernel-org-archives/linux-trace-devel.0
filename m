Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE30C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Apr 2022 12:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbiDUMTm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Apr 2022 08:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiDUMTl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Apr 2022 08:19:41 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7432D1DC
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Apr 2022 05:16:51 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso5780724wma.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Apr 2022 05:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=S2Bt4ASIqR69YMKG1OKQVBQVJHONm9KQ9R/P70/0hpg=;
        b=B4o6t7qPuvYzliohUUfN4nJhBgnhBftV6gEnjpaWAczWH0MquuF76tCF1biSVVojFM
         +1MZuCQ9570IWsuFAt8eru7F0Y5KdUJ1IBmjQhCIpkLSV7UqNzQ89v+YWKl9KfBNusxJ
         rW4QXmf/8xXI6wNVb16lAgpAtB7p9cILgkdl/t3Xc4S4YOwjjahxJZB95uG3bT0leAbc
         X5aQ7nI78CkZL2dikRNoUXaUr1eYKnc5EB59jiKX7YkeSfWXrdAvJvOIpC7LtBq0vdWQ
         RHyvTlaa8iq4MKuFHbuMsGoTiHUsqkjgxIgUvOhT2pz9oGc2g45Ubb4O2CVzygwig9nK
         jI/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S2Bt4ASIqR69YMKG1OKQVBQVJHONm9KQ9R/P70/0hpg=;
        b=1vrXLXAeb4+aQiXiEeuoJcaWwVJjgFizzvwhY4eDsLOJrSd2rCuF/5u1SZtZQ9pJ8q
         HmQDkqB+uGd7v1SZcR73Itkh0MJAjw3BQwoM9pFLsmD4FlDNlYOoXWKhkOq5/Dpt4oU+
         saSAcWt1fXj5jivtjmHP7UlND7f4SnH2FLBo8vPxHEeh+kr5ZZs/uP0Wc292qmSdxIUE
         RDGUzEkf5lIbRmTIF4GP6urOriiFep08zPIxvvLI/Cm6HYo3ynFYVctS7yTCBTuBOSMO
         jrT50tFlEEfXSvkGJxC+7hHFuGc5KIArM+H3PEm0DXuxPe654HtawgoQEReUhtlOO4mh
         NuZQ==
X-Gm-Message-State: AOAM531mGSJb9XiiSaE/+Kcd1eGufPKf8O8i9XvTwegeZ0TYAK3QHhhl
        Q6IEqQ4bUOOs9JSL5SwdRP4=
X-Google-Smtp-Source: ABdhPJxLATA7oieodMKF9/X2pdUOsKjDxgQO/EQ7YksPJmlHEhHgaaLaDhECyQctXXt0FyGViTZokg==
X-Received: by 2002:a05:600c:1550:b0:392:8de8:9df3 with SMTP id f16-20020a05600c155000b003928de89df3mr8693798wmg.9.1650543410149;
        Thu, 21 Apr 2022 05:16:50 -0700 (PDT)
Received: from [10.107.106.54] (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id 7-20020a056000156700b0020aa549d399sm2767594wrz.11.2022.04.21.05.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 05:16:49 -0700 (PDT)
Message-ID: <3a1b3caf-03fd-7a70-b91f-72565bb98de7@gmail.com>
Date:   Thu, 21 Apr 2022 15:16:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/2] kernel-shark: Allow FreeSans otf in addition to ttf
Content-Language: en-US
To:     Solomon Tan <wjsota@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <YmAkAE+5wy2mLncD@ArchDesktop>
 <20220420153827.637413-1-wjsota@gmail.com>
 <20220420153827.637413-2-wjsota@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220420153827.637413-2-wjsota@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Solomon,

I am taking this one.

Thanks!
Yordan

On 20.04.22 г. 18:38 ч., Solomon Tan wrote:
> FreeSans comes as otf rather than ttf in some cases. An example
> is the gnu-free-fonts on Arch. With this patch, both FreeSans.otf and
> FreeSans.ttf will be accepted to make kernelshark.
> 
> Signed-off-by: Solomon Tan <wjsota@gmail.com>
> ---
>   CMakeLists.txt | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index 5473bfa..3a48b0e 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -59,7 +59,7 @@ find_package(GLUT)
>   
>   set(KS_FONT FreeSans)
>   if (NOT TT_FONT_FILE)
> -    execute_process(COMMAND  bash "-c" "fc-list '${KS_FONT}' |grep ${KS_FONT}.ttf | cut -d':' -f 1 -z"
> +    execute_process(COMMAND  bash "-c" "fc-list '${KS_FONT}' |grep -E ${KS_FONT}'(\.otf|\.ttf)' | cut -d':' -f 1 -z"
>                       OUTPUT_VARIABLE TT_FONT_FILE)
>   endif (NOT TT_FONT_FILE)
>   
