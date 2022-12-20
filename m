Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7094C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Dec 2022 16:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbiLTQdv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Dec 2022 11:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiLTQdu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Dec 2022 11:33:50 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6ED11169
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 08:33:47 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id n20so30610998ejh.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 08:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HMg1KVobCUinoq6HSpx59KmCXaqSOVuDocdo1dNtVYA=;
        b=XviFB3rzVQ74dJ/CnHNOr9w2aw76uHgfmPDUakRZ89+xw5cjUSbQvNIPvEWn3PfVfQ
         buReTLiOXqsQyKU/oHb90MVsZJD6hp+FFn9VLHRB9jUJxF51xxo+finSbMPuu7xNiYN1
         jBm5rnumGMAm4FIQzrbsU7uBeYYV6FpngtROEOe0Yhstt0NdNidFG809+7zPyUUHHtG0
         LtLcMg4fpA5MAw4REhg5i0cKF+N4UGS3UpBK+LSMSzZCepscte3DVEu6K0gwGiMWSKTr
         IQwXviyi0UMeC7HIWusB6BvqGOMyi7AgeA4i3LflTJ3n5urdHTIN0D0Ii7LRaYa6EM7p
         UFEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HMg1KVobCUinoq6HSpx59KmCXaqSOVuDocdo1dNtVYA=;
        b=Prrl+VodhI0+OrmpTGpUTcxQeKa1DNxNrF41puhBjafJLOAqcwQs5LvMJqv3E51EbU
         tceygJ8V9ay7omPkda4NB74qqTjawIBev6ZFVzBxmRiyNOgSf7Y9DK9uL2UFoavf9g4k
         pWrqObz5w6I5RU/rrfbOwgoieNMF/UamhmvsVbXixs4G7M/Ee/ti3ORUDiBKoV0T7cBp
         iroJuY4T9idd34ElecQu2++LY80Hq0Ju9yoA9gXJxYWgq0SsE3VdIeeqX+xrq/W9qJm7
         jVieKSDoHk4/Vxl1A3hs6kSU2JpmjEpegq8sozCy3trRDBSSqyRBiJuPJxCgWOj/Vya8
         Aggg==
X-Gm-Message-State: AFqh2kpkpb0SJwFTdaPMx9BvYi/a6gKg56Nj9WiBuJfqWOLxHJO+D07X
        6WR/7JLczcdmCdtdAC1hd2GKD7uyA/k=
X-Google-Smtp-Source: AMrXdXthvr7Bt70Ecd4gk2RKDotNs9o93qdiwaqs1WWhvWti3vUd/Ne9lmL9D4bCyJkUDnKs1FwAMg==
X-Received: by 2002:a17:907:9d17:b0:81b:fbff:a7cc with SMTP id kt23-20020a1709079d1700b0081bfbffa7ccmr8219560ejc.18.1671554025621;
        Tue, 20 Dec 2022 08:33:45 -0800 (PST)
Received: from [192.168.0.101] (78-154-14-113.ip.btc-net.bg. [78.154.14.113])
        by smtp.gmail.com with ESMTPSA id v18-20020a170906565200b007c10fe64c5dsm5868233ejr.86.2022.12.20.08.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 08:33:45 -0800 (PST)
Message-ID: <c1919b51-f030-ecf0-74a4-0894b177cb28@gmail.com>
Date:   Tue, 20 Dec 2022 18:33:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] kernel-shark: Do not truncate multi-line events
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20221214154404.5897fc23@gandalf.local.home>
Content-Language: en-US
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20221214154404.5897fc23@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 12/14/22 22:44, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Some events have more than one line. The libkshark-tepdata.c get_info
> function did a string search for the first occurrence of '\n' and set it
> to '\0', with the comment of removing trailing newlines. Unfortunately,
> it removed more than the trailing newline and removed most of the event.
> This is particularly true with stack traces.
> 
> Instead, use the trace_seq.len to check the last written character, and if
> that is a newline, remove it.
> 

Hi Steven,

Sorry for the delay of my replay.
This patch looks good to me. I am going to apply it.

Thanks!
Y.

> Fixes: 836ce858246b7 ("kernel-shark: Add stream interface for trace-cmd data")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>   src/libkshark-tepdata.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> index 08aca0989a59..58be934f7d20 100644
> --- a/src/libkshark-tepdata.c
> +++ b/src/libkshark-tepdata.c
> @@ -816,7 +816,7 @@ static char *get_info_str(struct kshark_data_stream *stream,
>   			  struct tep_record *record,
>   			  struct tep_event *event)
>   {
> -	char *pos, *buffer;
> +	char *buffer;
>   
>   	if (!init_thread_seq() || !record || !event)
>   		return NULL;
> @@ -829,8 +829,8 @@ static char *get_info_str(struct kshark_data_stream *stream,
>   	 * The event info string contains a trailing newline.
>   	 * Remove this newline.
>   	 */
> -	if ((pos = strchr(seq.buffer, '\n')) != NULL)
> -		*pos = '\0';
> +	if (seq.buffer[seq.len - 1] == '\n')
> +		seq.buffer[seq.len - 1] = '\0';
>   
>   	if (asprintf(&buffer, "%s", seq.buffer)  <= 0)
>   		return NULL;
