Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B6F4C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Apr 2022 06:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244628AbiD1HAX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Apr 2022 03:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235345AbiD1HAW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Apr 2022 03:00:22 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E005562C4
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Apr 2022 23:57:08 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i27so7609053ejd.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Apr 2022 23:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kdx2XTPETD/mCtbVT/R5ycUPQdhIAs2bn3XLRHKSxuw=;
        b=EVrykqokY42XwT+kDD5X9iPRSOVeVgoQxAA0pDb0vFDKdcYxtjSHLPx0Uo6+WDvjyn
         6y7l2jHVRsOBdEofx0Ox/YNnND+KzzUJeuN4DNR4jTv8ocmDDyWU4RLfSEBhziJRl/aB
         H+T2jK9cX8TdQFA42LEMgac+JdXssIkieuNYWYosbfvp97AhidH7jorl4G3WzrTlt2JS
         8a1Ol0tlJrY52BUUJ2n0zZm6/l0X/FD/HSYwDvpICA0VjNnWCN4UecEQ3YSuGg+FMqn5
         61wMT8znQFkArpalajjzyEHaFy4DGmTYYW7eP8ekNru+5e/DVVsANMwrjBqrIDv7bNMz
         axvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kdx2XTPETD/mCtbVT/R5ycUPQdhIAs2bn3XLRHKSxuw=;
        b=kubvF1vg+JuLxIU7b/OAQs9GTQqNfzTIkFGRfONfrUuqDFjCBYgD/+l3YNUy/Ow2yY
         XhcyC1OThuwx0zBXcPSho7dH1Cp2XWXSp2iz1w8IbtcPzkC6R7ch3a6Wld/8VcnVv9Kh
         dpHRom07x2Hq5MDst7NTWn/tcZ6ZFjJDc0bmnVEhSPCKyhSdOFi3Tlr79mv9OHs7AcVy
         lweTrylVlUqiWXmM+0ZIfQs98qBGSXvZPATBHmn1jEpX8lZiV8fX6mUUIbLZ0AUcujaM
         NekuseIExjUL0sXO37PcIguwCP50x7Q5LKEdV/e68TOyNzzmKZrrv8dFVjTxjwQebn2B
         EGig==
X-Gm-Message-State: AOAM5319LoUn+7BKbMVSIbSZsvxHuXNR/JseuiGhaQstD3r674/5vlxr
        N0Gkk2JPr9rllUcB3sGNWaAdBcmLDws=
X-Google-Smtp-Source: ABdhPJzNxJdT+M9F5i1VUMBIm7kJGLC7KO4jzVKqyO9w+MMghSieV0cUTn4Z928b7ysC5bhAF3VEYg==
X-Received: by 2002:a17:907:8689:b0:6f3:de80:dc02 with SMTP id qa9-20020a170907868900b006f3de80dc02mr1802581ejc.331.1651129026632;
        Wed, 27 Apr 2022 23:57:06 -0700 (PDT)
Received: from [10.107.106.54] (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id h19-20020a170906855300b006f3cfd20aa7sm1769839ejy.1.2022.04.27.23.57.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 23:57:06 -0700 (PDT)
Message-ID: <466ffa7d-39c6-9008-9a13-829966f12987@gmail.com>
Date:   Thu, 28 Apr 2022 09:57:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] kernel-shark: Modify FreeSans warning msg for GUI
Content-Language: en-US
To:     Solomon Tan <wjsota@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220422114259.4162-1-wjsota@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220422114259.4162-1-wjsota@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Applied.

Thanks Solomon!
Y.

On 22.04.22 г. 14:43 ч., Solomon Tan wrote:
> Make the warning point out that the FreeSans font is required for the
> kernelshark GUI. This is to alert the user that the GUI will not be made
> when cmake does not detect FreeSans.
> 
> Signed-off-by: Solomon Tan <wjsota@gmail.com>
> ---
>   CMakeLists.txt | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index 9dd160e..390c7f5 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -69,7 +69,7 @@ if (TT_FONT_FILE)
>   
>   else (TT_FONT_FILE)
>   
> -  message(WARNING "\nCould not find font ${KS_FONT}!\n")
> +  message(WARNING "\nCould not find font ${KS_FONT}! Kernelshark GUI requires font ${KS_FONT}!\n")
>   
>   endif (TT_FONT_FILE)
>   
