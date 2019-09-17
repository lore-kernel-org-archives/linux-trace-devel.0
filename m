Return-Path: <SRS0=9KLN=XM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 958ECC4CEC9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 15:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 463CC21852
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 15:03:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hm6KwXKz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbfIQPDK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 11:03:10 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38084 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbfIQPDJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 11:03:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id o184so3599058wme.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Sep 2019 08:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9q9ZDa9vHJF056NKJ8JqSW4QqwyoTOa4sW7V4lnpSq0=;
        b=hm6KwXKzzB7z8IpL99qHP0bXD+h9JXj1VAm/Vpmo7EOti0xTXaQ2uHHH5PrTazIn7q
         3wJpnTVgEiuLdfH1g7K11/i+04XylXtckhqhwhw2opD326r7tJ5h7qnydh+jLWA+gS1n
         p7t4o4V9ALwyqRV3PvYG8E3Ze1Zv+WgHHgzTEkL+aNyf/7+wMr3XDMhJQmJXkv8LCRAJ
         VDvhgRA8fWsOBfDgZOL7waS8r2dvLnhiqleAotM7SfIPayqYcH5uLuK/qgkZtJ2IoDZA
         k5kGzVa22owkuL2zjqKuitzZqvrQQ5mZwENd4B/CKknDHcPJXdNsOKaBHgwnyoy55AfG
         ivxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9q9ZDa9vHJF056NKJ8JqSW4QqwyoTOa4sW7V4lnpSq0=;
        b=HZwp0w6HOJJlrotlqZYwsHd0C8tSoGiIImNniFxevMGFzevHTNLcGqQMtC8wxtOAiu
         /HDsd6Km6iYvraZIZ2CCQIeq+RQm/70cqax9DbacxhR9iWdA4bIALF19wm9rFlwLml1P
         L15X/dVe1h7Gp+PsdsHEEwQu7bADYSjY4IjbczK5NRyV0mLj1UkMzEigbjZUqjWHyJA+
         Oibr4Z4IuepOdxM7SyHapVmxgLSbxdyokFP/ueZovWZSVb3w3RWxEdijfvmGluul4zIR
         vzJoviuy9Gahq0BJ1OGHIboIASHTNlnaN7ognpkdwuCsLummmAyPtTCR9reDAwEDIX9+
         begA==
X-Gm-Message-State: APjAAAUWXj+Exz8MOTsR8LUjBv4m46DDIOR+Gy2tdOAKv87tfL8ywmFb
        PntUktHMd0dZoOyER7KEahp61D67
X-Google-Smtp-Source: APXvYqzyPtqTi3eopd5L4gR9e6mJiKKVtcO747f7l5Q/9QaM6NxdN2MjiFpuoYoIC90ElFmDWe2QxQ==
X-Received: by 2002:a7b:c4d6:: with SMTP id g22mr3919753wmk.21.1568732587239;
        Tue, 17 Sep 2019 08:03:07 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h7sm3018054wrt.17.2019.09.17.08.03.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 08:03:05 -0700 (PDT)
Subject: Re: [PATCH] kernel-shark: Increase the size of the task hash
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20190828140016.3ce1be4f@gandalf.local.home>
 <b651e39a-6f32-fe59-36bf-224cad5bc649@gmail.com>
 <20190829114913.5df4ced9@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <516c567e-1ad4-8b76-f27a-7f04a60617de@gmail.com>
Date:   Tue, 17 Sep 2019 18:03:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829114913.5df4ced9@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 29.08.19 г. 16:49 ч., Steven Rostedt wrote:
> On Thu, 29 Aug 2019 15:46:24 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> On 28.08.19 г. 21:00 ч., Steven Rostedt wrote:
>>> From: Steven Rostedt (VMware) <rostedt@goodmis.org>
>>>
>>> When loading a data file that contained 100,000s of tasks, using a 256
>>> bucket size hash crippled it. By increasing the hash to 2^16 (65536) it
>>> solves the issue (still small enough not to waste too much memory).
>>>
>>> In the process, I changed the knuth_hash() in libkshark.c to use the 32
>>> bit version and just have the key use what it needs:
>>
>> If the size the hash table is 65536 then the multiplicative hashing
>> function has to multiply the key by a prime number which is closer to
>> 65536 / 1.61803398875 (the so called "golden ratio" of the size).
>> It makes no sense to multiply by a number that is several orders of
>> magnitude bigger than the size of the hash table.
>>
>>>
>>>     key = knuth_hash();
>>>     key += knuth_hash >> SHIFT;
>>>     key &= (1 << SHIFT) - 1;
>>>
>>> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>>> ---
>>> diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
>>> index 4201fa02..41572e18 100644
>>> --- a/kernel-shark/src/libkshark.c
>>> +++ b/kernel-shark/src/libkshark.c
>>> @@ -252,19 +252,19 @@ void kshark_free(struct kshark_context *kshark_ctx)
>>>    	free(kshark_ctx);
>>>    }
>>>    
>>> -static inline uint8_t knuth_hash(uint32_t val)
>>> +static inline uint32_t knuth_hash(uint32_t val)
>>>    {
>>>    	/*
>>> -	 * Small table hashing function adapted from Donald E. Knuth's 32 bit
>>> +	 * Hashing function adapted from Donald E. Knuth's 32 bit
>>>    	 * multiplicative hash.  See The Art of Computer Programming (TAOCP).
>>>    	 * Multiplication by the Prime number, closest to the golden ratio of
>>> -	 * 2^8.
>>> +	 * 2^32.
>>>    	 */
>>> -	return UINT8_C(val) * UINT8_C(157);
>>> +	return val * UINT32_C(2654435761);

 From my tests it seems that the old and the new version of the hashing 
function are performing exactly the same however your version will be 
much easier to maintain, so I like this modification.


>>
>> So according to my understanding of the idea in the book, this line
>> should look look this:
>>
>> 	return UINT16_C(val) * UINT8_16(65537);
> 
> I just tested this (see attached patches, to try it yourself, I added
> the two libtraceevent fixes too). The results are *exactly* the same!
> 
> It's the prime number multiplication that is important.
> 
> They both give:
> 
> max=15441999 min=435 total=139895258 avg=2134 std2=55927
> 
> (since I didn't feel like adding a math library, the std2 is the square
> of the standard deviation. To get the real std you need to take the
> square root of it).
> 
> Note, its only the same if I remove the key += key >> shift part. With
> that still in, it becomes a little different:
> 
> max=15440573 min=334 total=139895258 avg=2134 std2=19938
> 
> It actually does better!
> 
>   std 141.201 (sqrt(19938)) vs 236.488 (sqrt(55927))
> 
> Thus, are you OK if I keep this patch as is?
> 
> -- Steve
> 
>>
>> and you do not need to do any additional manipulation of the key (PID).
>> Also the function has to return uint16_t.
>>
>> Thanks!
>> Yordan
>>
>>>    }
>>>    
>>>    static struct kshark_task_list *
>>> -kshark_find_task(struct kshark_context *kshark_ctx, uint8_t key, int pid)
>>> +kshark_find_task(struct kshark_context *kshark_ctx, uint32_t key, int pid)
>>>    {
>>>    	struct kshark_task_list *list;
>>>    
>>> @@ -280,9 +280,12 @@ static struct kshark_task_list *
>>>    kshark_add_task(struct kshark_context *kshark_ctx, int pid)
>>>    {
>>>    	struct kshark_task_list *list;
>>> -	uint8_t key;
>>> +	uint32_t key;
>>>    
>>>    	key = knuth_hash(pid);
>>> +	key += key >> KS_TASK_HASH_SHIFT;
 From my tests this so called "entropy" line makes the spread of the 
table worst. I would prefer to remove it.

>>> +	key &= (1 << KS_TASK_HASH_SHIFT) - 1;
The masking must stay but maybe it can be moved inside the hashing function.

Thanks a lot!
Yordan



>>> +
>>>    	list = kshark_find_task(kshark_ctx, key, pid);
>>>    	if (list)
>>>    		return list;
>>> diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
>>> index 04e9cbfc..3407db19 100644
>>> --- a/kernel-shark/src/libkshark.h
>>> +++ b/kernel-shark/src/libkshark.h
>>> @@ -72,7 +72,8 @@ struct kshark_entry {
>>>    };
>>>    
>>>    /** Size of the task's hash table. */
>>> -#define KS_TASK_HASH_SIZE 256
>>> +#define KS_TASK_HASH_SHIFT 16
>>> +#define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
>>>    
>>>    /** Linked list of tasks. */
>>>    struct kshark_task_list {
>>>    
> 
