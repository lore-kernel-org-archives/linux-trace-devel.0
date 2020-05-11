Return-Path: <SRS0=tfm2=6Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6048CC54E8D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 May 2020 13:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CC2A207FF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 May 2020 13:52:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IC6Jzqgj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbgEKNwM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 May 2020 09:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729555AbgEKNwL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 May 2020 09:52:11 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606C7C061A0C
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 May 2020 06:52:11 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 8so4863104lfp.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 May 2020 06:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=caMs2OKKOxzD+zR1Guw5jCaLcREqk2vN2JnYS/PeF5s=;
        b=IC6Jzqgjr8oa1FZ8ffbPS6hZlQffSVEcCHh46tAS7ECbl0NNk4WKNf+0hKgXL41pEn
         ZJYMiVLFwrRQZzZvLGfQGynRacPgDy4NvwnSsDpW1jV16cn3wuapYW7eWtz0KXSCgAvA
         SmSZZxFEunthxa28ZvIVScVZ3SA8fRFwalh7l2fBoXac2YWSyuEpEf6kQxkUYoNuOJb6
         U+2jiXL4kHXWzYWqC5kS8DziaI1R2AU83TtDXd9TMeas+yoVZTzDqMIivX6dGsOYWq5M
         5JVXeA+fzJgt989Zbzlx0+pcZiZbbupHq55auR1YTdwiU/S2aHdTOpOgkIS4+eCXrlMP
         UMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=caMs2OKKOxzD+zR1Guw5jCaLcREqk2vN2JnYS/PeF5s=;
        b=mv4Axo7bb9InQ1d8DVqWXtMVVdOuiNPHpYEuQz5iVu55e2rQ6hfdXsfWqd89UxdxJW
         q3FU4R+pe6LD1AyDFTg3MbHBjYc/G73oSpaOtNVSHj1aUE57wAXClc/3gH3dQ7OmG80b
         hKrNtIDaTF5LOsssbiBB04417UrLVTiH039Hv5zg/jlZem243Hl9DZMJnFAJ3zuKLExH
         LnhaxPAfqjnsN6m6HfGKkAQrAXjor+vo0C3bVWwOHrLGlK2vVmsyq+bGfNzBqp1CTued
         mW5xlcvc4DcD4xkZ9rKUPo/qSVEEVOiPevqY8vOSUnsKYRYuCVVQYSlp9J3UXWWmP3Gy
         +p+w==
X-Gm-Message-State: AOAM532+6N8ITw8vdqlX948kOIXZgXCMHlVbwY6W32jgem27d64QwMEQ
        NgfJAVDTxHViLpXYm8MY5vc=
X-Google-Smtp-Source: ABdhPJw+07BSLtPpkxz/bfJ3xINeaHHm+0gNy6Pno5umyP0MHOiSfQubByz6YV/DZXTlwPcAywF/7A==
X-Received: by 2002:a19:f70f:: with SMTP id z15mr11079192lfe.53.1589205129879;
        Mon, 11 May 2020 06:52:09 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id d8sm11092376lfl.51.2020.05.11.06.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 06:52:09 -0700 (PDT)
Subject: Re: [PATCH] kernelshark: Make fontHeight() and stringWidth() static
To:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
References: <20200510111720.2e041431@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <3bf272bc-38f4-e283-1657-df08c124f9e1@gmail.com>
Date:   Mon, 11 May 2020 16:52:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200510111720.2e041431@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 10.05.20 г. 18:17 ч., Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Gcc 10 is much more picky about globals being defined in multiple objects
> even if they are the same function. The functions fontHeight() and
> stringWidth() are defined in a header file which places them in multiple
> objects. They need to be static otherwise gcc 10 will not be able to build.
> 
> Link: https://lore.kernel.org/linux-trace-devel/CADVatmN=Z0ASVXUBTyAu6F_TWoWiKiKsgm404rOx7Oh-a6LiQg@mail.gmail.com/
> 
> Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Hi Sudip and Steven,

Thanks a lot for reporting and fixing the problem!
Yordan


Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

> ---
>   kernel-shark/src/KsUtils.hpp | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
> index f44139bb..272a27d1 100644
> --- a/kernel-shark/src/KsUtils.hpp
> +++ b/kernel-shark/src/KsUtils.hpp
> @@ -32,7 +32,7 @@
>   
>   //! @cond Doxygen_Suppress
>   
> -auto fontHeight = []()
> +static auto fontHeight = []()
>   {
>   	QFont font;
>   	QFontMetrics fm(font);
> @@ -40,7 +40,7 @@ auto fontHeight = []()
>   	return fm.height();
>   };
>   
> -auto stringWidth = [](QString s)
> +static auto stringWidth = [](QString s)
>   {
>   	QFont font;
>   	QFontMetrics fm(font);
> 
