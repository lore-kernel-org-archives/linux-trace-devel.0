Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08CCFC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Feb 2021 10:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8EED64E59
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Feb 2021 10:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhBHKiv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Feb 2021 05:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbhBHKfq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Feb 2021 05:35:46 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F523C061793
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Feb 2021 02:34:45 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id r21so202459wrr.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Feb 2021 02:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cIQ+baAqSLZVhpjLs0NS/cxH/HSOIEHqyzmtaaWJVSQ=;
        b=HCN34SW06jZ7opZxv/zZO5wnvVv4qyq898HMaduj4FmURSoJKdoyi06syUCg5Zu7o6
         lJn/CvA2Kw1LsAdfsl3oI5yD8ZhiH50FDtAII/kli+ie6bFz05kTM3PxPLKZWTmH0rp0
         yHrQlR2FqkLAPveEMR4Os1NnqGHtOjoz513zcNbmF/6V7mf5+GPfbPLQFxQQWw/3gnpl
         vOfYcMgjGEgA9jLak1wuR1aDYY9+Ttg0pFlm0kpe1tCZJ1Xd7lfJHEoPpHe5fi5RgVs3
         /Aif+4xEZ+ylL8ye04EJO79tqqQyxg2dhxIAM+6/sWYDIa1kpTTQSPSfJqsvyIJivDEH
         2lww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cIQ+baAqSLZVhpjLs0NS/cxH/HSOIEHqyzmtaaWJVSQ=;
        b=S4p768fhye3Uk5ZDUKdSwhgKgCcdJty3s838JhvKdtYfgPeQk1/Jhkq+yyR6ypPbni
         jKd1+2AUGiOiJaGfHDdQk+6tqlTwswweXmW0XsWcRqzv7MhPais6GC612gyc4oSsxiRb
         FbJla+ua0813fEcRfXP1zXBEpuD1U2vWHaa1VQGYWr8c271Knm5lTuSuAfBmX8tD3Tz2
         pRJkkY2EDH7aX1/ZtYHmUA8T2w9oSw+kwujWwevASkpWHRpfXQuRsjakS9lExKk2YRe+
         J8HYmeq1HsFaGmPn+gkMd2qBveusX2IA7UJVQPylMNBMTijBXLwOonQ1Cvhcqdd/2Uhc
         hVjw==
X-Gm-Message-State: AOAM532euv9UrdWQqF7rB8QNYFH3cQX2fVESjUxCMGPgCoQyxh/nbeTJ
        O4Bgthr5RRHvyzB9m7JVgklhjc1hpMs=
X-Google-Smtp-Source: ABdhPJwQf3RPPWYlzyO3RGvGpcBQiPqSQ3yOpA99Ds5OgE7RzjhyL6k3PYCbt54t5W1ix8VVRLyLyA==
X-Received: by 2002:a05:6000:1565:: with SMTP id 5mr19607867wrz.109.1612780483654;
        Mon, 08 Feb 2021 02:34:43 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id n15sm27430438wrx.2.2021.02.08.02.34.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 02:34:42 -0800 (PST)
Subject: =?UTF-8?Q?Re=3a_=5bPATCH=5d_kernel-shark=3a_Fix_compile_error=3a_?=
 =?UTF-8?B?4oCYc3RyaW5n4oCZIGluIG5hbWVzcGFjZSDigJhzdGTigJkgZG9lcyBub3QgbmFt?=
 =?UTF-8?Q?e_a_type?=
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20210205111242.57557-1-tz.stoyanov@gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <358f4904-ace1-97d6-a325-9a257d36875d@gmail.com>
Date:   Mon, 8 Feb 2021 12:34:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210205111242.57557-1-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 5.02.21 г. 13:12 ч., Tzvetomir Stoyanov (VMware) wrote:
> From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> 
> There is a compilation error when compiling KernelShark on Fedora 33
> with c++ (GCC) 10.2.1:
> 
>    src/KsPlotTools.hpp:349:37: error: ‘string’ in namespace ‘std’ does not name a type
> 
> "string" should be included in that header file, as it is a direct
> dependency.
> 
> Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> ---
>   src/KsPlotTools.hpp | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
> index 1725926..68bd6f7 100644
> --- a/src/KsPlotTools.hpp
> +++ b/src/KsPlotTools.hpp
> @@ -15,6 +15,7 @@
>   // C++
>   #include <forward_list>
>   #include <unordered_map>
> +#include <string>
>   
>   // KernelShark
>   #include "libkshark.h"
> 

Thanks Ceco!

Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
