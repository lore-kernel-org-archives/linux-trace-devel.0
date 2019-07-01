Return-Path: <SRS0=mM2H=U6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB34AC0650E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jul 2019 12:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E75720881
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jul 2019 12:24:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dq8x7PrT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfGAMYB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 08:24:01 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33943 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727814AbfGAMYB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 08:24:01 -0400
Received: by mail-wm1-f67.google.com with SMTP id w9so14471166wmd.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Jul 2019 05:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3U7J2ZZpHHZxgZ9Nurh9C60mjogSYR41wDwe6z8Bc8M=;
        b=dq8x7PrTao6OUatb1UgcrBXj92Q9zW+Py/Ul2TptOXohV7ZLMrKDOKVLDYFb8DpR4O
         h+kOZTVEhqDn6E7N//MHd4SxlJW5U5K9GwNhqfpH5mZrksR2jR7TBiewyhx4axdlfcRw
         ltZ3/d8Dbt5FxnFH5/Nt8rjjm9AJ9J89PrtSwCkjhX8ZYP8RTxxLYLG9Yg5TflqAQ1CU
         EoZMKmJwZ+YFwOOFZR4BuAoziOCOayguVkEm1/YncHiSOupVtmWMSjy44tBG2GK9ofy/
         0NncSLZRvhGJqGyr9pwOoN8c2AcJobheoHeqswOKk3qQHXM5z07TX3fAO9MrL6PGi3O4
         nuUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3U7J2ZZpHHZxgZ9Nurh9C60mjogSYR41wDwe6z8Bc8M=;
        b=NPuBpQI9eoLnk+PgqT+4DAadVBvgZPPwdNu9ZOTQEjaNt8iC9SUHdwHjwlkRRQ9lvo
         Y9C/uHPTsWlW9i6kKhMOMXZ6sOnOR0Epa1ADU78fe+vYEg0LPQtf8eZUP1wP4OGfd6gR
         cjw9PGVeRk2vKOv/GTkq+/Np2KVK2C+f/Rmwp2dNbNStaA5x+J/GN6pQLuMkLFrrXv3Z
         uFYNgYQpzSjspR1nw5tdwTuOJLEOyx1WWdVz6EGT3BlffYTQ6m69rEdWeANBmNr+DKaE
         cKgFlM/l8jhBgF5re9bZ+FZs3kAKfyZkMkyc3h7orW/k5v4BnIWrEo51Fk5QgrxfYk/y
         A1jg==
X-Gm-Message-State: APjAAAUbR3VE7BQnY6gFahV3U01F+Y+mxa2MwQAxNaboF5xLRd/a4NpH
        H7RMMUa5AOx3xZGI9Wth8Ogxlk1W5Ts=
X-Google-Smtp-Source: APXvYqzBc6E70+VnC33NMkMWn5JQbhjOjkTdG8ctjgFOlCkg3gGTw8f16o8vvAW89wAoCrusUKLfPQ==
X-Received: by 2002:a1c:1d8d:: with SMTP id d135mr16067359wmd.54.1561983838587;
        Mon, 01 Jul 2019 05:23:58 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v204sm7806713wmb.15.2019.07.01.05.23.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 05:23:58 -0700 (PDT)
Subject: Re: [PATCH v2] trace-cmd: remove ununsed knuth_hash*() routines
To:     Greg Thelen <gthelen@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20190627121542.2dc0d328@gandalf.local.home>
 <20190629062752.204113-1-gthelen@google.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <79567c76-868f-edef-de1b-dd3f62a66f6a@gmail.com>
Date:   Mon, 1 Jul 2019 15:23:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190629062752.204113-1-gthelen@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 29.06.19 г. 9:27 ч., Greg Thelen wrote:
> Neither 16-bit knuth_hash16() nor the 32-bit knuth_hash() are used.
> Delete them both.
> 
> And rename the remaining function: knuth_hash8() => knuth_hash()
> 

Thanks!

Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>


> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>   kernel-shark/src/libkshark.c      | 12 +++++-----
>   lib/trace-cmd/trace-filter-hash.c | 40 +++++++------------------------
>   2 files changed, 14 insertions(+), 38 deletions(-)
> 
> diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
> index 0f0a1bab4d5c..d2764e813194 100644
> --- a/kernel-shark/src/libkshark.c
> +++ b/kernel-shark/src/libkshark.c
> @@ -252,13 +252,13 @@ void kshark_free(struct kshark_context *kshark_ctx)
>   	free(kshark_ctx);
>   }
>   
> -static inline uint8_t knuth_hash8(uint32_t val)
> +static inline uint8_t knuth_hash(uint32_t val)
>   {
>   	/*
> -	 * Hashing functions, based on Donald E. Knuth's Multiplicative
> -	 * hashing. See The Art of Computer Programming (TAOCP).
> -	 * Multiplication by the Prime number, closest to the golden
> -	 * ratio of 2^8.
> +	 * Small table hashing function adapted from Donald E. Knuth's 32 bit
> +	 * multiplicative hash.  See The Art of Computer Programming (TAOCP).
> +	 * Multiplication by the Prime number, closest to the golden ratio of
> +	 * 2^8.
>   	 */
>   	return UINT8_C(val) * UINT8_C(157);
>   }
> @@ -282,7 +282,7 @@ kshark_add_task(struct kshark_context *kshark_ctx, int pid)
>   	struct kshark_task_list *list;
>   	uint8_t key;
>   
> -	key = knuth_hash8(pid);
> +	key = knuth_hash(pid);
>   	list = kshark_find_task(kshark_ctx, key, pid);
>   	if (list)
>   		return list;
> diff --git a/lib/trace-cmd/trace-filter-hash.c b/lib/trace-cmd/trace-filter-hash.c
> index 39b28790e0bc..45ca68c2959e 100644
> --- a/lib/trace-cmd/trace-filter-hash.c
> +++ b/lib/trace-cmd/trace-filter-hash.c
> @@ -14,45 +14,21 @@
>   
>   #define FILTER_HASH_SIZE	256
>   
> -/*
> - * Hashing functions, based on Donald E. Knuth's Multiplicative hashing.
> - * See The Art of Computer Programming (TAOCP).
> - */
> -
> -static inline uint8_t knuth_hash8(uint32_t val)
> +static inline uint8_t knuth_hash(uint32_t val)
>   {
>   	/*
> -	 * Multiplicative hashing function.
> -	 * Multiplication by the Prime number, closest to the golden
> -	 * ratio of 2^8.
> +	 * Small table hashing function adapted from Donald E. Knuth's 32 bit
> +	 * multiplicative hash.  See The Art of Computer Programming (TAOCP).
> +	 * Multiplication by the Prime number, closest to the golden ratio of
> +	 * 2^8.
>   	 */
>   	return UINT8_C(val) * UINT8_C(157);
>   }
>   
> -static inline uint16_t knuth_hash16(uint32_t val)
> -{
> -	/*
> -	 * Multiplicative hashing function.
> -	 * Multiplication by the Prime number, closest to the golden
> -	 * ratio of 2^16.
> -	 */
> -	return UINT16_C(val) * UINT16_C(40507);
> -}
> -
> -static inline uint32_t knuth_hash(uint32_t val)
> -{
> -	/*
> -	 * Multiplicative hashing function.
> -	 * Multiplication by the Prime number, closest to the golden
> -	 * ratio of 2^32.
> -	 */
> -	return val * UINT32_C(2654435761);
> -}
> -
>   struct tracecmd_filter_id_item *
>   tracecmd_filter_id_find(struct tracecmd_filter_id *hash, int id)
>   {
> -	int key = knuth_hash8(id);
> +	int key = knuth_hash(id);
>   	struct tracecmd_filter_id_item *item = hash->hash[key];
>   
>   	while (item) {
> @@ -66,7 +42,7 @@ tracecmd_filter_id_find(struct tracecmd_filter_id *hash, int id)
>   
>   void tracecmd_filter_id_add(struct tracecmd_filter_id *hash, int id)
>   {
> -	int key = knuth_hash8(id);
> +	int key = knuth_hash(id);
>   	struct tracecmd_filter_id_item *item;
>   
>   	item = calloc(1, sizeof(*item));
> @@ -81,7 +57,7 @@ void tracecmd_filter_id_add(struct tracecmd_filter_id *hash, int id)
>   
>   void tracecmd_filter_id_remove(struct tracecmd_filter_id *hash, int id)
>   {
> -	int key = knuth_hash8(id);
> +	int key = knuth_hash(id);
>   	struct tracecmd_filter_id_item **next = &hash->hash[key];
>   	struct tracecmd_filter_id_item *item;
>   
> 
