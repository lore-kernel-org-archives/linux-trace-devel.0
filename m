Return-Path: <SRS0=kCFW=WZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56629C3A5A6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 12:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BC522339E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 12:46:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pDlP07l9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfH2Mq3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Aug 2019 08:46:29 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35000 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbfH2Mq3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 08:46:29 -0400
Received: by mail-wm1-f65.google.com with SMTP id l2so3741009wmg.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Aug 2019 05:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ARkEVQIWG9mqP/9tF4oB32K+MFSqhYUhDuDb8NrTaCI=;
        b=pDlP07l9oBwfn10vvjDULBZfU4qpPSFvOzoACoxPjIu57ebeMUfp2+fHkyn7qvroiZ
         WvYDLSJ3tNQzTsmzJEovKoo84BhH8sPUa1ffffeJlnZlOiDyBjj+q+o1tUeAi8GriL51
         KmKJoe0HInEqBJu7MzM5wtUNhIJWbp9YmIRWZnW3EHFRRMGco8Z/e+RLF4ttAhXeH9qZ
         dIl5lPIAWe86Fy0jXhPmDJbvzY5QKhW3jUX788vOLr8fGaJrIVYisN3kmIhO+ruQkEj0
         1ZKTLY58d9gGAy//7aIks5ajFGwp9o4jzI/q6KdGogep6j4E+SNyZHw8/VpUpQj3FZ5t
         txyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ARkEVQIWG9mqP/9tF4oB32K+MFSqhYUhDuDb8NrTaCI=;
        b=eAI8h0kM+m9zvjrO2+Rhlq6K6qFSDy1WIPVPMzUwWytSUJiSQt/XdgixN2xSZGjRFp
         AA58vFllVLw4cdfiwhVtP0spFWPf8VOp8Ia44FvNw/wLPHZYfdG2FJ8kria01B3NI6kb
         K1FYHUsM+GIa1Igg6VtdGeBX/vai8twPuhxjad0gEVRiss85BeLG8zO3X2gWr8FRFqaa
         TqDNONK9+GHfqWfa7+Puxeyeor5DFB1p5ETma1yjQqsC8OHxjikXb3xhqDLwwDQrHNZt
         ckYji8hHLrNL/qgIRXcGF0hEY5VQ43W2dWE57vC5n7S8nPSr4r9zNaHP24YL6pf8iSqn
         vD3Q==
X-Gm-Message-State: APjAAAWC2y2LFz4NAiuU0CFJ5wfah0PJ8DcUbbI417pENl6GvJCgKAPJ
        prP2YTfF5gAHqNt70T1sh8ViHpXAq6M=
X-Google-Smtp-Source: APXvYqwEOQUdwT4Q2Q8ipo4bq3F8D3r4bbSUV22RyJMaTPtNBBl1DpSicHJsNjOq/FHHksMhJWRxFA==
X-Received: by 2002:a7b:c453:: with SMTP id l19mr11102790wmi.106.1567082787982;
        Thu, 29 Aug 2019 05:46:27 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id j18sm2521881wrr.20.2019.08.29.05.46.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 05:46:27 -0700 (PDT)
Subject: Re: [PATCH] kernel-shark: Increase the size of the task hash
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20190828140016.3ce1be4f@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <b651e39a-6f32-fe59-36bf-224cad5bc649@gmail.com>
Date:   Thu, 29 Aug 2019 15:46:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190828140016.3ce1be4f@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 28.08.19 г. 21:00 ч., Steven Rostedt wrote:
> From: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> When loading a data file that contained 100,000s of tasks, using a 256
> bucket size hash crippled it. By increasing the hash to 2^16 (65536) it
> solves the issue (still small enough not to waste too much memory).
> 
> In the process, I changed the knuth_hash() in libkshark.c to use the 32
> bit version and just have the key use what it needs:

If the size the hash table is 65536 then the multiplicative hashing 
function has to multiply the key by a prime number which is closer to 
65536 / 1.61803398875 (the so called "golden ratio" of the size).
It makes no sense to multiply by a number that is several orders of 
magnitude bigger than the size of the hash table.

> 
>    key = knuth_hash();
>    key += knuth_hash >> SHIFT;
>    key &= (1 << SHIFT) - 1;
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
> diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
> index 4201fa02..41572e18 100644
> --- a/kernel-shark/src/libkshark.c
> +++ b/kernel-shark/src/libkshark.c
> @@ -252,19 +252,19 @@ void kshark_free(struct kshark_context *kshark_ctx)
>   	free(kshark_ctx);
>   }
>   
> -static inline uint8_t knuth_hash(uint32_t val)
> +static inline uint32_t knuth_hash(uint32_t val)
>   {
>   	/*
> -	 * Small table hashing function adapted from Donald E. Knuth's 32 bit
> +	 * Hashing function adapted from Donald E. Knuth's 32 bit
>   	 * multiplicative hash.  See The Art of Computer Programming (TAOCP).
>   	 * Multiplication by the Prime number, closest to the golden ratio of
> -	 * 2^8.
> +	 * 2^32.
>   	 */
> -	return UINT8_C(val) * UINT8_C(157);
> +	return val * UINT32_C(2654435761);

So according to my understanding of the idea in the book, this line 
should look look this:

	return UINT16_C(val) * UINT8_16(65537);

and you do not need to do any additional manipulation of the key (PID).
Also the function has to return uint16_t.

Thanks!
Yordan

>   }
>   
>   static struct kshark_task_list *
> -kshark_find_task(struct kshark_context *kshark_ctx, uint8_t key, int pid)
> +kshark_find_task(struct kshark_context *kshark_ctx, uint32_t key, int pid)
>   {
>   	struct kshark_task_list *list;
>   
> @@ -280,9 +280,12 @@ static struct kshark_task_list *
>   kshark_add_task(struct kshark_context *kshark_ctx, int pid)
>   {
>   	struct kshark_task_list *list;
> -	uint8_t key;
> +	uint32_t key;
>   
>   	key = knuth_hash(pid);
> +	key += key >> KS_TASK_HASH_SHIFT;
> +	key &= (1 << KS_TASK_HASH_SHIFT) - 1;
> +
>   	list = kshark_find_task(kshark_ctx, key, pid);
>   	if (list)
>   		return list;
> diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
> index 04e9cbfc..3407db19 100644
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
