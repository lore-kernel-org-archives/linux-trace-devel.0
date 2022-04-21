Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 856C9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Apr 2022 12:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382859AbiDUMHp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Apr 2022 08:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiDUMHo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Apr 2022 08:07:44 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FB4B04
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Apr 2022 05:04:53 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ks6so9623341ejb.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Apr 2022 05:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=E4Wm0RFqA1S/4FuIcFwtidPSuJZnR5QfueRqrRJ7/Mo=;
        b=Ja0k5wkdXXkfIIuAKF6/LPo/vMDLOrnWhyf0P3eC2QiDsLWUCXHGDB1aijzZgW1t02
         C+OwON9kzsc68IaNFqkT6ceH2ZC1zjOF7G0lDtT+4U0jgaLFoZPN5i2isVwlkC76FAkz
         8quDquoD/pF8gGVw8Tdxdlbz6xT34Uw06q+MbxYnr38fu1kQJv/zRMFQ06gNa6pJ6MMT
         nK+0xgVR1wXH1me1jzerrjkvvJIPJMFW1jtP1WeE4OMUBEeJmPMIJgacCHl6Jwu25XHT
         lTYmfDPJWOj3aoD8T5JDktdCFdkThT5OkMT0iArVWaVdCKapNxSRXK0OAP8Lh3Hf5lnk
         F5/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=E4Wm0RFqA1S/4FuIcFwtidPSuJZnR5QfueRqrRJ7/Mo=;
        b=ma42E0ehw8CkXKihunquGlfs0GHPdNtyv/aACDEu8JkUil5j8Qef4qu7v6weifxQkA
         64U58Ri9X6P/ZMdbpbb+GRR1GQbRQ+szmf8vL7JKjoe7a3kyFulrfmOCE2IkY5KkyS64
         KHJOdeEt/HbD+0hdBAbhVVPsxScUtcZ3EWnRftlcfRGJe9lygM2ZGzdr+cgvYiO11blk
         JNsHTN72/7xAt3lxP85LyJmJqIqYc6pMRzSnSkLnLDymRSKruQrcGwvI4PGCUFQJX2o5
         U8Xw9gn06uhIwsqIyyHoN64xjAxzR0P+lUFhJ6AGs4k21Kb61NrBGEAYTFaaN4H6D4YD
         7ArA==
X-Gm-Message-State: AOAM530oyoRLhZbViuvhOSk6hno33PMisC+RPL9E/vPAe2gsaF6MVRG8
        nH6W4hD8FQZC8yHYckw8t2E6flS5xI4=
X-Google-Smtp-Source: ABdhPJwnnnWPGyscsUR0iqcBsEGUm6WF2RDsMfp1njWvms5tI9OgZXf8p5eoOV42iJ+1c0GtHSw2Ng==
X-Received: by 2002:a17:907:9958:b0:6e7:f67a:a1e7 with SMTP id kl24-20020a170907995800b006e7f67aa1e7mr21647496ejc.400.1650542691896;
        Thu, 21 Apr 2022 05:04:51 -0700 (PDT)
Received: from [10.107.106.54] (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id o5-20020a170906974500b006dfc781498dsm7776621ejy.37.2022.04.21.05.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 05:04:51 -0700 (PDT)
Message-ID: <04db0694-bb3b-3c9d-d2f0-09300f13a637@gmail.com>
Date:   Thu, 21 Apr 2022 15:04:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] kernel-shark: Make FreeSans a compulsory component
Content-Language: en-US
To:     Solomon Tan <wjsota@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <YmAkAE+5wy2mLncD@ArchDesktop>
 <20220420153827.637413-1-wjsota@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220420153827.637413-1-wjsota@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 20.04.22 г. 18:38 ч., Solomon Tan wrote:
> This patch is proposed for two reasons.
> 
> Firstly, with reference to
> https://lore.kernel.org/linux-trace-devel/Yl9WBztqKGD0PpmJ@ArchDesktop/
> when the CMake does not detect FreeSans, it should cease generating the
> Makefile since kernelshark requires FreeSans to output its graph
> properly.
> 
> Secondly, when the make instructions on the README are followed, even
> when FreeSans is not detected, `make` continues to compile and `make
> install` (or `install_gui`) would install without indicating an error.
> This gives the impression of a successful install, but `kernelshark`
> will be missing.
> 
> Therefore, making CMake quit with error when FreeSans is not installed
> solves these two issues.
> 
> Signed-off-by: Solomon Tan <wjsota@gmail.com>
> ---
>   CMakeLists.txt | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index e6a76d8..5473bfa 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -69,7 +69,7 @@ if (TT_FONT_FILE)
>   
>   else (TT_FONT_FILE)
>   
> -  message(WARNING "\nCould not find font ${KS_FONT}!\n")
> +  message(FATAL_ERROR "\nCould not find font ${KS_FONT}!\n")

Hi Solomon,

Having this message as warning instead of a fatal error is done on purpose. We have other projects, that are using the 
kernelshark library (libkshark) but do not need the kernelshark GUI. So the library have to be able to build even if the 
third party packages needed by the GUI are not installed.

On the other hand I understand your argument that this can be confusing for someone who wants to build the GUI and do 
not care about the library. My suggestion is to keep the warning, but to make the message more informative, so that the 
user will be aware that the GUI is not going build.

And please send your patch-sets as new email threads.

Thanks!
Yordan

>   
>   endif (TT_FONT_FILE)
>   
