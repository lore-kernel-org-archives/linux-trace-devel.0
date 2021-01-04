Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A8EC433E9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D713522482
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbhADREg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbhADREg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:04:36 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEBCC061574
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:03:56 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id g20so37772573ejb.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QrR7mU/foSGt5OsqExiI6qO8+q+bkAqN6Cbmg2WRcek=;
        b=tM1nktGdDDMKAh8Yt56p2PIIptmo3vmZG9+pvqcj1PNCnUItks0BNPW819VbOvXlB7
         gtcWkexCd4GVQZQt0u7iGfUnePkKYkBOyGt3aZ71HjFfdDiVuGt2PUBz0n8XBy1pPUxs
         U7UtULa0bkfhhHrF8E5yPFIA5lf53JSgNfBkls8rAaYf1w9IHwh7DMpEuMDbkEgNEI/U
         9q3i7GkhTUn5bCo0rzVCkPtLxIcbrE50F0pIkJcb0OqGRyfAE13YSjOyna9KXEbnOyt1
         V5I+Wn8Vgyuvleq3GABQ7/D7umtNkL2/etEv4qmq6yKtCiCeWy/gIuOtlJpktwUJJcFS
         dzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QrR7mU/foSGt5OsqExiI6qO8+q+bkAqN6Cbmg2WRcek=;
        b=MjaL9X5tIdshFGeGAKsBH4QeWhcy7TyIlVWJPX/xzCoXPLQu2+AOOfL9HZmGsBakNj
         caCQx579wTT8GxFej+CjwAzGh6PyzPkHZ44P6A3FKt9YQ1Q399dZkXEb34juMnK144Tx
         d3X7lIC+CHJfZpP2GcW+kv0zcwtPXzhF67xB6oFfSpcnIRWkIs25LCMN/3HFwzHtPno3
         FqDg0Z5c/7Cdqig+wQJfhqlGlReZb8QJliwMcTxqpUD1Rr0P6kPwIEC5kwjIwuAV9OWm
         jTlfm8TtKSEXq+FLj2gMjS4agPJU/GdUyVJRjA6fUZIPh8AOK71EnAqc2wlUgG8QcN0x
         z3MQ==
X-Gm-Message-State: AOAM530xERyL92P2YixcZtrQzrpExRtB70qkF6DvJdsi8OGfBex4BEiL
        uSqgwLdHqIUaKt6fKTKkdnRYz3nBMLiJQA==
X-Google-Smtp-Source: ABdhPJy5Nh1EYne8m7lfvroLvvEwmdwyJ+c/5q33PefP0Gc/YG6If/RL7PuUY5R0Hohvqg2iu6Dtqw==
X-Received: by 2002:a17:906:705:: with SMTP id y5mr65242539ejb.428.1609779834837;
        Mon, 04 Jan 2021 09:03:54 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id e19sm44653454edr.61.2021.01.04.09.03.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 09:03:54 -0800 (PST)
Subject: Re: [PATCH] kernelshark: Rename tracefs_get_tracing_dir() to the new
 tracefs_tracing_dir()
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
References: <20201221142458.5d5607c6@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <3d3e4601-6a0c-8e91-9e7d-9cc02d61b07f@gmail.com>
Date:   Mon, 4 Jan 2021 19:03:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201221142458.5d5607c6@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 21.12.20 г. 21:24 ч., Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> libtracefs is renaming tracefs_get_tracing_dir() to tracefs_tracing_dir() as
> there is no "tracefs_put_tracing_dir()" for this function. Since libtracefs
> has not been officially released, it is fine to break API, as it is with
> kernelshark v2.0 has not yet been official released that uses the old API.
> 
> Signen-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   src/KsCaptureDialog.cpp | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/KsCaptureDialog.cpp b/src/KsCaptureDialog.cpp
> index 63fd5d6..7253ab6 100644
> --- a/src/KsCaptureDialog.cpp
> +++ b/src/KsCaptureDialog.cpp
> @@ -26,7 +26,7 @@ extern "C" {
>   
>   static inline tep_handle *local_events()
>   {
> -	return tracefs_local_events(tracefs_get_tracing_dir());
> +	return tracefs_local_events(tracefs_tracing_dir());
>   }
>   
>   /**
> @@ -204,7 +204,7 @@ QStringList KsCaptureControl::_getPlugins()
>   	QStringList pluginList;
>   	char **all_plugins;
>   
> -	all_plugins = tracefs_tracers(tracefs_get_tracing_dir());
> +	all_plugins = tracefs_tracers(tracefs_tracing_dir());
>   
>   	if (!all_plugins)
>   		return pluginList;
> 

Thanks Steven!
I applied this one on my side before all KS 2.0 patches.

Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
