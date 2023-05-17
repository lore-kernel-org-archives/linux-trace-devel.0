Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6009C77B75
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 May 2023 18:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjEQSaS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 May 2023 14:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjEQSaR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 May 2023 14:30:17 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD7E83D8
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 May 2023 11:30:14 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-510a59ead3fso1711511a12.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 May 2023 11:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684348212; x=1686940212;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7PjQjwyenA2ydUVQbCzZozAq6aS3z6hC6mAOL5/BYuA=;
        b=e1omt5X2pzitcwO/JBM8kJ7ff7lxgxW4xnNDDC73uQpAsZLfG+ohy+QidmYngWFqY7
         0gzvFQkIm11+LEcqDdW5X01LHzGBp1vpx0jSgNRQbIT1Z8lGI1W1meQbhUG0pdGH6MHr
         ajhfnJm0+WjtgL6H0edY8rrBK55kB4T5Ioz5/zMgNLOkrCT7lHZh1xYx+Bb10PkYTrRP
         TOnPyum3SPvLHKYuZrnn+AjyrQCS84XhmsxnN9jVcaez+OgnjSE7R+k2was0+sP0fLuG
         FtWyYAcSqx3Iu8hykCqdagAZXoNq9f8bcMYHlGuq6eFmFpi8KsL0ySd6Afm/5tgn390v
         3kRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684348212; x=1686940212;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7PjQjwyenA2ydUVQbCzZozAq6aS3z6hC6mAOL5/BYuA=;
        b=EOXrFHNjyjUD6usn0n72O4Pd1oizB54aD2aDe9hPzVa62VTlgoJrfqX6KNkTrlWYbe
         acdsSP4D51ucS0Qa8wjF2AJpzVN75x9+Y/DvOaWz2abwn1K0yI2EXLcVfJVcJmJkL8sv
         eA22bEnJMgvn423rtwiUopAh6EEOfp7krFChG2T1mKrztzy3sLHdkDHs0dd7uhI4TBxJ
         gkQawz+9FNa3BgLw2U5Ah192IwypGxupRWBFyfHtV1+IdgeYeyU5sArxxrVNuWF5SGUi
         HZcJCtsTovQjZ8cK7RLkUOuXGsX1jvmcvRMBB9m+mOuuaTLipM8Awn+t5BkizT+dp1OP
         +x0A==
X-Gm-Message-State: AC+VfDxyci7T1hWpbRcC3FheYbeQJKPXNXt1tvPQO+cKVkWbSJl8OQ9h
        8PAG/I7qVNYpByDEYTJsvl9acRDuTsc=
X-Google-Smtp-Source: ACHHUZ4v4wshhOLLuIe2B/plGvgmXDqW7Tu4/R1ZiZ8zjXTnwcA456JMkltwiYBwnxoafaRn7p7soA==
X-Received: by 2002:aa7:d311:0:b0:504:b228:878d with SMTP id p17-20020aa7d311000000b00504b228878dmr2713171edq.25.1684348211989;
        Wed, 17 May 2023 11:30:11 -0700 (PDT)
Received: from [192.168.0.107] (78-154-14-41.ip.btc-net.bg. [78.154.14.41])
        by smtp.gmail.com with ESMTPSA id m26-20020a50ef1a000000b0050690bc07a3sm9848349eds.18.2023.05.17.11.30.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 11:30:11 -0700 (PDT)
Message-ID: <ec02e617-594e-2778-9126-61c78abb211b@gmail.com>
Date:   Wed, 17 May 2023 21:30:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] Fix segfault in libkshark-tepdata
Content-Language: en-US
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org
References: <20230517182410.216670-1-y.karadz@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20230517182410.216670-1-y.karadz@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Please ignore this one.
Thanks!
Y.

On 5/17/23 21:24, Yordan Karadzhov wrote:
> It turns out that the size of the info field of some events can be zero.
> 
> Fixing: 3146d0b (kernel-shark: Do not truncate multi-line events)
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217429
> Signed-off-by: Yordan Karadzhov <y.karadz@gmail.com>
> ---
>   src/libkshark-tepdata.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> index 2009ca6..b780957 100644
> --- a/src/libkshark-tepdata.c
> +++ b/src/libkshark-tepdata.c
> @@ -825,6 +825,8 @@ static char *get_info_str(struct kshark_data_stream *stream,
>   	tep_print_event(kshark_get_tep(stream), &seq, record,
>   			"%s", TEP_PRINT_INFO);
>   
> +	if (!seq.len)
> +		return NULL;
>   	/*
>   	 * The event info string contains a trailing newline.
>   	 * Remove this newline.
