Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36684C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Sep 2021 12:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1983B60F0F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Sep 2021 12:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbhIHMJp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Sep 2021 08:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234758AbhIHMJo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Sep 2021 08:09:44 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DFEC061575
        for <linux-trace-devel@vger.kernel.org>; Wed,  8 Sep 2021 05:08:36 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id bt14so3718427ejb.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 08 Sep 2021 05:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aPmnAmvXKzD8X8BF8C0+2/qvREStJgt5EHoe4fDo32g=;
        b=EQROA4rilFvfU7ek8Rf67dVT+L35ANVIJAMdONyU3+cuy2A9XeYwhI8KdsgKzfggL2
         4H4Ta7AWP9n2OZvZHhMKifYkbmsUHUTuWo+kP83ja1E6PzZmas1zqZin8szihmKJAHkb
         1dYSjdbe9w1Wh0LJQlMwjMMOQjLnBDzmKHoYMIxTMjW+1iYGOrAiMaXIlClZMBA+jRKV
         WIH5gfImLqa5H/yD/xo/83Fbzm5xuPtQ5nFPGAqUXZyJgaF/VvzfHfT+BhLIKZeROjRt
         DfC3Xx9jg1l8DAUMZkxIv3elcr1humM12LpLTnMwmrXUEY4+brmm9q1xYkAGGhUNf/NG
         Yinw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aPmnAmvXKzD8X8BF8C0+2/qvREStJgt5EHoe4fDo32g=;
        b=JV9W7TKoYst+cIybdBrEBunhoqTAQRqY0OR2asGfhoD1Oi4mnUvzjKVSeM8/S2/pTg
         wDAxT0bh5WIdipYZp8ySbXiw4R/6bh9wGCtqLmy16bzDSWlyNaKCQryHMHj3hkIZRanB
         vi7ZtJXHFBZslmrXEVwiixR18PiHSOPmN6EkvGoV1iMCmcheZ+xRPaZhyytnlaG5ZnJa
         gd2wK79Ne7j2eF9qSLQGC3orJk2smxKK35HjWm10Xn4JbaSYNGNXfOecPHsqQ9wp89vx
         aM7YeeQ10i31sAlme9IpL4nk9y2zCYi+iaytZKqIAe/qumJzvzZgmjFr6N2ISQNTTpwj
         u3yg==
X-Gm-Message-State: AOAM532eL2UohYBKrdnyRVPqgcNJCOHNXRb8gDc9twgZw50eNoNsqctS
        QBNoULJbVVFO01wV3xNPxDzEoeCYFkM=
X-Google-Smtp-Source: ABdhPJxzioJxUcrkWzQQY1VTn8AVXP9RDmvPhDv3uJhZMKvnhRbd78Lhz+fCPqhD5OtmWuCiVoTIWg==
X-Received: by 2002:a17:906:c7d0:: with SMTP id dc16mr3738980ejb.555.1631102914522;
        Wed, 08 Sep 2021 05:08:34 -0700 (PDT)
Received: from [192.168.0.108] ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id h25sm941539eji.108.2021.09.08.05.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 05:08:34 -0700 (PDT)
Subject: Re: [PATCH] kernel-shark: Handle traces with sched_switch and no
 sched_waking
To:     John Keeping <john@metanate.com>, linux-trace-devel@vger.kernel.org
References: <20210906185005.3130298-1-john@metanate.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <ebe70744-3ab9-60be-b90c-84d0ad36a03f@gmail.com>
Date:   Wed, 8 Sep 2021 15:08:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210906185005.3130298-1-john@metanate.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 6.09.21 г. 21:50, John Keeping wrote:
> plugin_sched_init_context() is careful to make the sched_waking (or
> sched_wakeup{,_new}) event optional but the initializer blindly
> dereferences plugin_ctx->sched_waking_event which is null if no waking
> event is found.
> 
> Add the necessary checks to avoid segfaults when (de)initializing the
> plugin.
> 

Very well spotted. Thanks a lot!
Yordan


> Signed-off-by: John Keeping <john@metanate.com>
> ---
>   src/plugins/sched_events.c | 16 ++++++++++------
>   1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
> index 83c2520..198ed49 100644
> --- a/src/plugins/sched_events.c
> +++ b/src/plugins/sched_events.c
> @@ -193,9 +193,11 @@ int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
>   				      plugin_ctx->sched_switch_event->id,
>   				      plugin_sched_swith_action);
>   
> -	kshark_register_event_handler(stream,
> -				      plugin_ctx->sched_waking_event->id,
> -				      plugin_sched_wakeup_action);
> +	if (plugin_ctx->sched_waking_event) {
> +		kshark_register_event_handler(stream,
> +					      plugin_ctx->sched_waking_event->id,
> +					      plugin_sched_wakeup_action);
> +	}
>   
>   	kshark_register_draw_handler(stream, plugin_draw);
>   
> @@ -213,9 +215,11 @@ int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
>   						plugin_ctx->sched_switch_event->id,
>   						plugin_sched_swith_action);
>   
> -		kshark_unregister_event_handler(stream,
> -						plugin_ctx->sched_waking_event->id,
> -						plugin_sched_wakeup_action);
> +		if (plugin_ctx->sched_waking_event) {
> +			kshark_unregister_event_handler(stream,
> +							plugin_ctx->sched_waking_event->id,
> +							plugin_sched_wakeup_action);
> +		}
>   
>   		kshark_unregister_draw_handler(stream, plugin_draw);
>   
> 
