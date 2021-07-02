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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F796C11F68
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21EAB613F4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 11:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhGBLU1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 07:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbhGBLU1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 07:20:27 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C2AC061762
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jul 2021 04:17:55 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id w13so6428275wmc.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Jul 2021 04:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=APyfl8Uf7/ooNxd7zsCrwPh5jQXuyNGY1UcoIcJslo8=;
        b=nZWxqwfds0dh6DlziJaKAtAcWlI6acFC7USVIU0D6Ie1MMu8vcjffT5i2CVH/BFu5s
         ROM4SXjrbQGdiYorttIZNidblkQIKsDtCorSZBvKNliMU/w8Qkb20BX2I/tOpKhdngXy
         tsMLpPYh2Z1zPTbd6Fbm+RoxgzorYZiSMEKfJBGnWpTBn9CkrsJDAdLLYGvLyGZQJ3/q
         XCr4TdMu9G2l3UsFiHy5g8A56CAj9mAXst1lGgQs4Kd5K7UuQZY9Sny2Eqm/dMcEOMcm
         EQQtSBsepxzvTe/WWwUj4ueYTauaiUts7cVhBBTX7Ab3ZZqjand+PhUG3A4S/gFkw3Hm
         7eqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=APyfl8Uf7/ooNxd7zsCrwPh5jQXuyNGY1UcoIcJslo8=;
        b=daKSPfxZ/BpjuxdduIOIT1uNWAQIG8tS6NmUjsqKKqTioc+MNLK7pIxBM/6II0vnho
         OQCcYM8HZhHKYA3vLiz4alYUViGgvTKuJ3ZBJfNjz23H3XWvgAqqWhXsl0MzlMdJtfyh
         uHQSCKyePs62G7njCAtSNs59iQLHS//GoL0P1Un22APXpeX3Z4rWl2tW94yLp+DAjwZJ
         9ppTywrvVruWWEjnO+zI71uT1msR2mSlgqjoMVlBarDR8jYlfn902n50Ug1oQ6XUZ2j1
         M2Lm7DtD0EqZuFLoELgb5Qz2+jAx1BGWMxn2YlNFFIc3ANchjEteKlagD8f72L/WhBSG
         CCBg==
X-Gm-Message-State: AOAM532isv39PWWKRIYj0EZ4lwU5a97yiRDgAi/YECqiTqpkAZleqk+f
        Pb3BADziqGTbMy8wOeSMoqnr3lSpGtw=
X-Google-Smtp-Source: ABdhPJys0chnQ6sYLy7sABbiZUiXfPSwKW9pHI4KqhHy7ZUyLp4APaLV+/lbwI+OPKnpjc90eg863w==
X-Received: by 2002:a1c:a704:: with SMTP id q4mr4863543wme.112.1625224673786;
        Fri, 02 Jul 2021 04:17:53 -0700 (PDT)
Received: from [10.93.171.151] ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id y20sm12088561wmi.31.2021.07.02.04.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 04:17:53 -0700 (PDT)
Subject: Re: [PATCH] libtracefs: Fix tracefs_event_enable/disable() to not
 have open regex
To:     Steven Rostedt <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
References: <20210629164046.48f8b323@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <48ad3a02-f4bf-1579-df6a-f4dc206a7e4e@gmail.com>
Date:   Fri, 2 Jul 2021 14:17:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210629164046.48f8b323@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 29.06.21 г. 23:40, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Found that calling tracefs_event_enable/disable() will match all content
> of the passed in strings and not just what is passed in.
> 
> That is, if you have two events, "open" and "open2", and call
> 
>   tracefs_event_enable(NULL, NULL, "open");
> 
> it will match both the "open" event as well as the "open2" event. This is
> because the regex is open ended.
> 
> To fix this, add a '^' to the beginning of the match and a '$' to the end
> (if they do not already exist).
> 
> Fixes: fc94d1a8 ("libtracefs: Add tracefs_event_enable/disable() API")
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   src/tracefs-events.c | 23 ++++++++++++++++++++++-
>   1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/src/tracefs-events.c b/src/tracefs-events.c
> index 0fef64f..b6d3136 100644
> --- a/src/tracefs-events.c
> +++ b/src/tracefs-events.c
> @@ -828,6 +828,26 @@ static int enable_disable_all(struct tracefs_instance *instance,
>   	return ret < 0 ? ret : 0;
>   }
>   
> +static int make_regex(regex_t *re, const char *match)
> +{
> +	int len = strlen(match);
> +	char str[len + 3];
> +	char *p = &str[0];
> +
> +	if (!len || match[0] != '^')
> +		*(p++) = '^';
> +
> +	strcpy(p, match);
> +	p += len;
> +
> +	if (!len || match[len-1] != '$')
> +		*(p++) = '$';
> +
> +	*p = '\0';
> +
> +	return regcomp(re, str, REG_ICASE|REG_NOSUB);
> +}
> +
>   static int event_enable_disable(struct tracefs_instance *instance,
>   				const char *system, const char *event,
>   				bool enable)
> @@ -847,12 +867,13 @@ static int event_enable_disable(struct tracefs_instance *instance,
>   		goto out_free;
>   
>   	if (system) {
> +		ret = make_regex(&system_re, system);
>   		ret = regcomp(&system_re, system, REG_ICASE|REG_NOSUB);

I think we forgot to remove the line above.
Thanks!
Y.

>   		if (ret < 0)
>   			goto out_free;
>   	}
>   	if (event) {
> -		ret = regcomp(&event_re, event, REG_ICASE|REG_NOSUB);
> +		ret = make_regex(&event_re, event);
>   		if (ret < 0) {
>   			if (system)
>   				regfree(&system_re);
> 
