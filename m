Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97598C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 31 Jan 2022 11:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240961AbiAaLkS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359775AbiAaLgI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 31 Jan 2022 06:36:08 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77BBC0797AC
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Jan 2022 03:24:20 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id m14so24506583wrg.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Jan 2022 03:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZjFfCgWxth5LK6r0lmGfpEwZS7NXmEc5AkoXOE/GVGU=;
        b=KC48q8siliQfTSMaayZYPPbivCgDa8DTDQc9gO8N+5o4XZqiypd2mpOCMbpHKsFUb8
         upwnRmcw3mtKP00K+Hjpcq8C2bS+ca+koAGcpxFjNgpS+z9uTQng1JXHbs1lla2sOWJ1
         ez2ebgfLo8YwTAwp+LNUgeqq3jQ+4JWkU9IThXVJEmFmeEF4cEwX8qioVy5vxAotrIXl
         deIRoi7W0df7ZFVJ9CaTebr9s/4F66CYHe2cOJfuIhb9gzoy0y/VFHnYqH4jl+DzVE7W
         I3B0ekcDl3qjjSYzXkhfl/Evu6OCWp5WxOcyCTCS8qSkySKBJPM62yHITGm1VCFp6sK6
         Bsyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZjFfCgWxth5LK6r0lmGfpEwZS7NXmEc5AkoXOE/GVGU=;
        b=eKiwch7QpJapCUu0fTa83r8ETT603SEWKulXAVMGq7tiQWNJ/pM6FILcKrS77/bsaY
         q6SdqrZmCpCD2372DBzEJ/WuNGX2cWA7eniNYJm6Hrk4/ClB2Ez0hXsj9MFSUtQ0Y/zS
         ow7EEoBa2dEgg9RVj1tVqCnOb+fKwDHnXVQVo1gHljvXBTIUcQOMCdqAEPZZ6f5lxE65
         AkD0gprRY7osq294D3tn8K5Na2zBykfzcLNHRp+4d8AFm++BgtNdbL/qBq/wXt48MGNm
         Kj7uzuHQHDIQ1avtf7TlZQVJwVhel5Ojh21afarTL4wfSpPi4o36RmNYovlNYc1yyHSR
         ihtQ==
X-Gm-Message-State: AOAM5307Rngzw+qRHAwvi47yjRV2p3MSaYYIZSnwH7GAs1ADBvWkoY0A
        UJ2TcoxuCYS1WRZEO/cdegc=
X-Google-Smtp-Source: ABdhPJzs9Q0tZiTqQwDvUk5nuJyggA5ZEpedR7MNdGhfmA76c7R3vjrs/NnM8kgqLuAWxHnBGc2V8w==
X-Received: by 2002:a05:6000:1acc:: with SMTP id i12mr16721215wry.413.1643628259357;
        Mon, 31 Jan 2022 03:24:19 -0800 (PST)
Received: from [10.93.98.252] ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id i6sm8695987wma.22.2022.01.31.03.24.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 03:24:18 -0800 (PST)
Message-ID: <3c613828-89b1-f801-81d5-779418b045c3@gmail.com>
Date:   Mon, 31 Jan 2022 13:24:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] trace-cruncher: Add a .gitignore file
Content-Language: en-US
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220128140950.86562-1-tz.stoyanov@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220128140950.86562-1-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Applied.

Thanks Ceco!
Yordan


On 28.01.22 г. 16:09 ч., Tzvetomir Stoyanov (VMware) wrote:
> Some files are generated during trace-cruncher compilation,
> testing and development process. These files should be ignored by git.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   .gitignore | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/.gitignore b/.gitignore
> index e69de29..9fb86e5 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -0,0 +1,11 @@
> +*.so
> +*.a
> +.*.d
> +*~
> +*.pyc
> +*.swp
> +build/
> +tracecruncher.egg-info/
> +dist/
> +src/npdatawrapper.c
> +install_manifest.txt
