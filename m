Return-Path: <SRS0=uWkg=VB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373B4C06513
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Jul 2019 12:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BBE92082E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Jul 2019 12:39:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TIXGHiLf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfGDMjl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Jul 2019 08:39:41 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35461 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727632AbfGDMjl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Jul 2019 08:39:41 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so6020952wml.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Jul 2019 05:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xkzzGI9ABkOAv1YWtuAb02diTcnh1Ha6gA8mTEp2Vr0=;
        b=TIXGHiLfvhYtmfilUC6b1zld92orpZzbrzBSPHTUmLgnl6Ytk2lY9qysdlS35g41D6
         LCCXFD4KkbBBZMnrJ0k0z1mSwn4MjUv750ziJJlFemO0GE8oEoSmG7L0IH6GauDkXZTO
         sObIxbADLSFGMHlT0xico6CVBk+TRpOuO9jDuGYePviUz+djlcBj4IgnEchwA7I8qDtc
         iNn9v+Y0lSqHka8uRX+uYyD7KSVLQIxVkBTHpxSFVWgK3MlhlDYOrlsZZIo5mGV1p8uY
         r4d/P5MFM+Q3fvcpGyMdBT5kwmPh0qDnBQmmaFZyWkCxCKDnuPWoWR9kTRuqFc0pB1bC
         UToQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xkzzGI9ABkOAv1YWtuAb02diTcnh1Ha6gA8mTEp2Vr0=;
        b=Z6VYZ72AoESXLKSfbfCtiTk8Get3Y+Bd/nALZQtVixJA6V/3ntkc4MAw/kana7S4pK
         zEW3mqWk3Uc1/rxi1lMyP+xLXgRXG6c+N5+C5X8S5UXgWC6V2A/LR17jla6hHhTRR9F+
         afFBHyNazy8w4UQckHXpBV+xuhbikX0UZdE1Kb7yFWeojO1RhQeRRKB2xPUa8FwRcSTU
         +EP0leb7bUuZedpzyCJ+JjvOGivS9zyMifDn4S6Nd4tJ512MejKU8X1YPAabRk3Oe0QX
         muqFV8Sh5VA0p83k4mpoqYjz4aZYHcqlwKdeiC9PlYeRzLnZ1aVM4lL6XrHvmJMDmufM
         +2TQ==
X-Gm-Message-State: APjAAAWoQv2gS+Sa3FXFMwm3LXapjKhkeYqU+e8AGGhf2GQP58s8wMTM
        82xw1Kh5jMKbl/WYDJOMIrU2gC1i8yU=
X-Google-Smtp-Source: APXvYqza2NuPZl9NA0/r+oPgZRlG3Nd2B93K+DsG6+zeBDdyT6mNO3Q08+iGOi/e+f3ARzwZtAXGqw==
X-Received: by 2002:a05:600c:2218:: with SMTP id z24mr12548657wml.84.1562243980022;
        Thu, 04 Jul 2019 05:39:40 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b8sm781533wrv.78.2019.07.04.05.39.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 05:39:39 -0700 (PDT)
Subject: Re: [PATCH] trace-cmd: Fixed a potential problem with non-terminated
 string, returned by readlink()
To:     tz.stoyanov@gmail.com, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20190703121644.18680-1-tz.stoyanov@gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <513a3420-56da-f1b3-4798-e8aff2ee58c5@gmail.com>
Date:   Thu, 4 Jul 2019 15:39:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190703121644.18680-1-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 3.07.19 г. 15:16 ч., tz.stoyanov@gmail.com wrote:
> From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
> 
> The buffer, returned by readlink() API, is not guaranteed to be a null terminated string.
> Explicitly adding '\0' at the end of the buffer is recommended, to ensure the string is
> null terminated and to avoid possible buffer overruns.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   lib/trace-cmd/trace-util.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index 190cf74..7c74bae 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -1373,6 +1373,7 @@ static char *trace_util_get_source_plugins_dir(void)
>   	ret = readlink("/proc/self/exe", path, PATH_MAX);
>   	if (ret > PATH_MAX || ret < 0)
>   		return NULL;
> +	path[ret] = 0;
>   
>   	dirname(path);
>   	p = strrchr(path, '/');
> 

Thanks!

Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
Tested-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
