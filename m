Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF6FC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 08:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65B6461058
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Aug 2021 08:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhHLIf0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbhHLIf0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 04:35:26 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DD0C061765;
        Thu, 12 Aug 2021 01:35:00 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q10so7139312wro.2;
        Thu, 12 Aug 2021 01:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IlVHQ4NWaPMoyZiZeUHFFSjdijcpn35tVIpp97UXz2I=;
        b=bAR32Ri+YVJoVq0m9nNzrp9/x4D65+rClhf0TjoZOp8pzY4J5lOWkJHTtZWiSq1Xa6
         iSUvxd+KwBcTF/TaT8d/7MAb48PpnTpvznbV++XTu4pB7WdNe7m4AZZZBjo6YMV9q4KP
         MDlSeR6l0fw8zOuML5l+kSfTC70JoPFwqhIOp6oUWORF8Y1pcDw76H1DUZNnSI/ygsiG
         pGJ+N9q7/afDNdc64ly7MeTsJJMsaUI9Ayu1f6utUTwwcDCpij1QrgfKse8YZePInBwi
         by93qC8csEbthakzDgNomNze3Qisjw4GYrFuc746z0H3Bi0+kzDSIgQ5zoqwtww6MEZj
         B1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IlVHQ4NWaPMoyZiZeUHFFSjdijcpn35tVIpp97UXz2I=;
        b=hAXI2iGAyBFMSedFVCxwIH9zfOfct1LAchp8Q8WgegZF/FAfJUeEu6W/RbOBTuIFJx
         QDBgbozXZAefBFxVuCLqg7umQzS5d8Ey7wEpluX4yNGFjCbDhxdfcIYP3PG6e4UUgv9q
         ILSr6DhMNEn5yoU9+FBVwcyH0mVL2/NyzLmLe+YD0dCPlvU9BJdq1YZSG+MbkA0688RW
         xmF9unlCG6SC7oNigb/0SJLYRsX6ezx0XTQZXvPF6gXEUEeneGXtSjwI4CaIVPb22gHb
         0Wx6J2l80xcqTwPzy0gUJw2P5S980BNQvxglP63EV9h2moBDBGTbC377BPAYF3F+ixmI
         7iuQ==
X-Gm-Message-State: AOAM533LPW9mVOcHgyEy9+ZgWJhIJVJkAR5+ExrL6la2qkWOlYje/vst
        2OnJ9RcppictP5obPuJCbYQ=
X-Google-Smtp-Source: ABdhPJyBpU3/dkP7DajBYIwsvAWejcTCpyfDWRc1+MkZQ5pe6dm7TKik3vn6xcNjxqml+/VskFmMuA==
X-Received: by 2002:adf:e0c8:: with SMTP id m8mr2651493wri.261.1628757299321;
        Thu, 12 Aug 2021 01:34:59 -0700 (PDT)
Received: from [10.93.98.252] ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id s12sm2110210wru.41.2021.08.12.01.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 01:34:58 -0700 (PDT)
Subject: Re: [PATCH 1/2] libtracefs: Add random number to keep synthetic
 variables unique
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
References: <20210812005546.910833-1-rostedt@goodmis.org>
 <20210812005546.910833-2-rostedt@goodmis.org>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <13bed3a6-7e39-eec2-2421-a80081302a81@gmail.com>
Date:   Thu, 12 Aug 2021 11:34:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210812005546.910833-2-rostedt@goodmis.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 12.08.21 г. 3:55, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> The 'hist' triggers expect that all variables are unique. If two synthetic
> events are created, it is possible that they will use the same variable
> names, and this can break the logic for synthetic events. Add a random
> number to the argument names that will help prevent that from happening.
> There's no guarantee that there wont be collisions, but the chances of
> that happening is 1 in 65535. If this is a problem, we could possibly look
> for variables that are already in use.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   src/tracefs-hist.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
> index 7f9cf3820611..8783ef4364bd 100644
> --- a/src/tracefs-hist.c
> +++ b/src/tracefs-hist.c
> @@ -13,6 +13,8 @@
>   #include <errno.h>
>   #include <fcntl.h>
>   #include <limits.h>
> +#include <time.h>
> +#include <sys/types.h>
>   
>   #include "tracefs.h"
>   #include "tracefs-local.h"
> @@ -558,6 +560,7 @@ struct tracefs_synth {
>   	unsigned int		end_parens;
>   	unsigned int		end_state;
>   	int			*start_type;
> +	char			arg_name[16];
>   	int			arg_cnt;
>   };
>   
> @@ -957,7 +960,15 @@ static char *new_arg(struct tracefs_synth *synth)
>   	char *arg;
>   	int ret;
>   
> -	ret = asprintf(&arg, "__arg__%d", cnt);
> +	/* Create a unique argument name */
> +	if (!synth->arg_name[0]) {
> +		srand(time(NULL));

Nit: Have in mind that time(NULL) has 1 second resolution. Fast consecutive calls (within a second) of this function can 
generate identical random numbers.
This can be mitigated if we do something like this:

		struct timeval now;

		gettimeofday(&now, NULL);
		srand(now.tv_usec);


-- Yordan

> +		ret = rand() + gettid();
> +		/* Truncate so that ret is at most 65535 (total 13 bytes) */
> +		ret &= (1 << 16) - 1;
> +		sprintf(synth->arg_name, "__arg_%d_", ret);
> +	}
> +	ret = asprintf(&arg, "%s%d", synth->arg_name, cnt);
>   	if (ret < 0)
>   		return NULL;
>   
> 
