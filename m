Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE05C3A5A2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 689212086A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="barz7o5u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404007AbfITPrb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 11:47:31 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45059 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403863AbfITPrb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 11:47:31 -0400
Received: by mail-wr1-f67.google.com with SMTP id r5so7206743wrm.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2019 08:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zLJqnXAVH/RGjouTLgIRVeI35SmpPWDyvX0/k7TbzH4=;
        b=barz7o5uKWm7pKDnbvT9pzjK/N59qCSjx7PtdU71N521jUNHMjjF7KkRS2FO1yF6SN
         jaUTqFDXpoMFWFsr2QU0t02weQdugDZEZtCdujhwsYLc6C8GslnVSXAfD14QYFYHHiW6
         L6+J0CvehzbKtbHvaZuhRJDe1pJciscofSPg70sG4JMgK347AhsxcG5OzVGybidp8deQ
         +ei+FNHI9qeoEkDgsAU4qVlJqvUFT7MphHdN6AUULnG0MtL4Ro11tAyFJ2IjFpZWgZ5I
         8xUub4wCTOi0zii1DNlpYNIz+22pN1QH6sIFtdP4G5Qy//FF1oqNRlugcXtuzKNnT8bg
         Nj+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zLJqnXAVH/RGjouTLgIRVeI35SmpPWDyvX0/k7TbzH4=;
        b=LJDxPfiRgURVmNNUHe3dITgNRu3+N2nhT1YIjmUz2w+BnHNWuuoOdQXbMcOwTgsLPK
         +x/Pv9Atz8cejek/g1uXjiYtFACIsq9yxGVQe+bzZjlCuuiXBX9FK45w2Ryv09Gdndke
         t52x89OqJGVL84tFy8cRVvC688IVbtiGdbPwJcDnyj1MDOxWTHFRPLOGOgT/1rct/vSY
         Gb4T3Sf3RZMQTjlt2mDGNmN30f++pX7p+c5CL6mGxieOVfxUbcLSd6z5/+URxJmZhn7S
         DnB6hlkRtBzBpvTf2pJVh1IoM+ymJ9AMqWI5r6XMVLZJdko75rzHramZ4L/SLWlpTIns
         npWg==
X-Gm-Message-State: APjAAAWWFEfO1XWIoQ5xsscgMc1Lj/v102Yddu6VMyDoUzMUpqMhHpFn
        DI3RJ0u39YZS+pBYlbRPnMkZff0H
X-Google-Smtp-Source: APXvYqzpmn2mf2FnqM5IzbIOpZFOAsF/UnWhJwYPrnsQowiusJZNK4M/lmKAICzHUTQGYToWoy0tSw==
X-Received: by 2002:adf:9dd1:: with SMTP id q17mr11666301wre.176.1568994448131;
        Fri, 20 Sep 2019 08:47:28 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r28sm5093433wrr.94.2019.09.20.08.47.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2019 08:47:27 -0700 (PDT)
Subject: Re: [PATCH 2/2] kernel-shark: Increase the size of the task hash
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20190920151526.528126066@goodmis.org>
 <20190920152024.729716704@goodmis.org>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <41fb23fa-6ae7-7e85-7e9d-6939830b26be@gmail.com>
Date:   Fri, 20 Sep 2019 18:47:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920152024.729716704@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 20.09.19 г. 18:15 ч., Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> When loading a data file that contained 100,000s of tasks, using a 256
> bucket size hash crippled it. By increasing the hash to 2^16 (65536) it
> solves the issue (still small enough not to waste too much memory).
> 
> Also switched to the tracecmd_quick_hash() which is basically the same
> as the local knuth_hash() function in libkshark.c.
> 
> Link: http://lore.kernel.org/linux-trace-devel/20190828140016.3ce1be4f@gandalf.local.home
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   kernel-shark/src/libkshark.c | 18 ++++--------------
>   kernel-shark/src/libkshark.h |  3 ++-
>   2 files changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
> index 4207ae6ffdb2..a36157835ce0 100644
> --- a/kernel-shark/src/libkshark.c
> +++ b/kernel-shark/src/libkshark.c
> @@ -252,19 +252,8 @@ void kshark_free(struct kshark_context *kshark_ctx)
>   	free(kshark_ctx);
>   }
>   
> -static inline uint8_t knuth_hash(uint32_t val)
> -{
> -	/*
> -	 * Small table hashing function adapted from Donald E. Knuth's 32 bit
> -	 * multiplicative hash.  See The Art of Computer Programming (TAOCP).
> -	 * Multiplication by the Prime number, closest to the golden ratio of
> -	 * 2^8.
> -	 */
> -	return UINT8_C(val) * UINT8_C(157);
> -}
> -
>   static struct kshark_task_list *
> -kshark_find_task(struct kshark_context *kshark_ctx, uint8_t key, int pid)
> +kshark_find_task(struct kshark_context *kshark_ctx, uint32_t key, int pid)
>   {
>   	struct kshark_task_list *list;
>   
> @@ -280,9 +269,10 @@ static struct kshark_task_list *
>   kshark_add_task(struct kshark_context *kshark_ctx, int pid)
>   {
>   	struct kshark_task_list *list;
> -	uint8_t key;
> +	uint32_t key;
> +
> +	key = tracecmd_quick_hash(pid, KS_TASK_HASH_SHIFT);
>   
> -	key = knuth_hash(pid);
>   	list = kshark_find_task(kshark_ctx, key, pid);
>   	if (list)
>   		return list;
> diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
> index 04e9cbfc71df..3407db197320 100644
> --- a/kernel-shark/src/libkshark.h
> +++ b/kernel-shark/src/libkshark.h
> @@ -72,7 +72,8 @@ struct kshark_entry {
>   };
>   
>   /** Size of the task's hash table. */
> -#define KS_TASK_HASH_SIZE 256
> +#define KS_TASK_HASH_SHIFT 16
> +#define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
>   
>   /** Linked list of tasks. */
>   struct kshark_task_list {
> 

Both patches look good to me.
Thanks!


Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
