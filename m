Return-Path: <SRS0=entZ=EE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFAAC2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 10:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 944DC2076E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 10:08:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xf4Af6l4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbgJ2KI2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgJ2KI2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 06:08:28 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D30BC0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 03:08:26 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id c16so1845198wmd.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 03:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h/YmW9hLf54hcdEBbDjehcadyyVw9bt+9qjzpk01BwI=;
        b=Xf4Af6l46PyqM/mK0XO37od84JKM6mSED7TaOff8du/oRsfgMIozL1MSYJMa5rMv2Q
         KLfNKQ9dyQFs/aT8oM5F3UFvtSVjuCI+4X1Zdq4a7cBl+cz3MMWbwUQW426Wp8gxPGCj
         O3e5ycFqbPSH7IES8CLMiGXPS32erG3P9WiLZG2GXVR82vB/vpH9hNHvTJpg8DrZrbQg
         QXzN69q+VOO/TUIO2QaosgcwBDh0/W+pUmgsG35Hv5FYVdliH4vjRmq8uud65qVvmHzi
         pAX0mw6jdIanVd5aQLnbJ/xB5tfVwSUR1kDXne/QkHuBVCGp/njVovm88XpQ0J4qb8n/
         QcHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h/YmW9hLf54hcdEBbDjehcadyyVw9bt+9qjzpk01BwI=;
        b=LYURoXG/KgspAWltHzupPQBavhjh/ihT1b+bKAq7bPJnBy/WNoWzVwPgO+2GRI/hsD
         cyH+cYQnovN66TaV3HE22uBh3I7Vy5DpYJKKOIdOa9QsPAhTXPVH0Jw5eEvmMU2EyNXE
         yuGm8BgG6+5pHe3rmMqBazA3bbWRNjSXmPXee8HhzBep3Zys8c1e+gLVnUWWXsSGgDOr
         5X8celdxRVZpV131KzI91oJggqQTFeIco6QvgmPpXXEq9LoqwFKGngdjXceF53QKUm3r
         m6HJwvZpQTA+XreiTVv6w9s3wFSYrRG4qOypAuJTO4nB30mPuiAtZt7dxZ60Pdqshxi4
         PVsQ==
X-Gm-Message-State: AOAM531oS90GuWyoQpHqcGKlrqUo7gAHH0DicNidz0oGc8OGXQMHxahU
        krGaL6kZ4yYBm0WsQf/EPK7N14JYq18=
X-Google-Smtp-Source: ABdhPJwdC2IMlKBml0AR4p7JOanu/em3NDLSjCajTa3oWBuZEEQqe+51aRAt1+WnZt7mOMD9OFgYPg==
X-Received: by 2002:a1c:7dc5:: with SMTP id y188mr3405836wmc.37.1603966102010;
        Thu, 29 Oct 2020 03:08:22 -0700 (PDT)
Received: from [192.168.0.108] ([84.40.73.62])
        by smtp.gmail.com with ESMTPSA id e2sm4458037wrr.85.2020.10.29.03.08.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 03:08:21 -0700 (PDT)
Subject: Re: [PATCH v2 05/20] kernel-shark: Add stream_id to kshark_entry
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201012133523.469040-1-y.karadz@gmail.com>
 <20201012133523.469040-6-y.karadz@gmail.com>
 <20201012200544.03d67163@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <5f9cca7b-301c-d9f7-86ce-dbdb62dc9b12@gmail.com>
Date:   Thu, 29 Oct 2020 12:08:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201012200544.03d67163@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 13.10.20 г. 3:05 ч., Steven Rostedt wrote:
> On Mon, 12 Oct 2020 16:35:08 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> kshark_entry contains all information from one trace record, needed
>> in order to visualize the time-series of trace records. Here we
>> reorganize data fields to kshark_entry in order to make room for
>> the unique identifier of the Data stream this entry belongs to.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   src/libkshark.c |  2 +-
>>   src/libkshark.h | 12 +++++++++---
>>   2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/src/libkshark.c b/src/libkshark.c
>> index 52aacd30..92e2450c 100644
>> --- a/src/libkshark.c
>> +++ b/src/libkshark.c
>> @@ -489,7 +489,7 @@ static inline void unset_event_filter_flag(struct kshark_context *kshark_ctx,
>>   	e->visible &= ~event_mask;
>>   }
>>   
>> -static void set_all_visible(uint16_t *v) {
>> +static void set_all_visible(uint8_t *v) {
>>   	/*  Keep the original value of the PLUGIN_UNTOUCHED bit flag. */
>>   	*v |= 0xFF & ~KS_PLUGIN_UNTOUCHED_MASK;
>>   }
>> diff --git a/src/libkshark.h b/src/libkshark.h
>> index 1165c512..fe0ba7f2 100644
>> --- a/src/libkshark.h
>> +++ b/src/libkshark.h
>> @@ -1,7 +1,7 @@
>>   /* SPDX-License-Identifier: LGPL-2.1 */
>>   
>>   /*
>> - * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
>> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>>    */
>>   
>>    /**
>> @@ -49,7 +49,10 @@ struct kshark_entry {
>>   	 * kshark_filter_masks to check the level of visibility/invisibility
>>   	 * of the entry.
>>   	 */
>> -	uint16_t	visible;
>> +	uint8_t		visible;
> 
> Why did the visible variable turn from 16bits to 8 bits?
> 
> That should be stated in the change log.
> 

After further discussing this on a call with Steven we decided to keep 
the "visible" field 16 bit and to define the "stream_id" to be a 16 bit 
integer as well. Those 16 bit will be taken from the event_id. This is 
OK because the Id of the trace event is coded with only 16 bit in the 
kernel anyway.

>> +
>> +	/** Data stream identifier. */
>> +	int8_t		stream_id;
>>   
>>   	/** The CPU core of the record. */
>>   	int16_t		cpu;
>> @@ -57,7 +60,7 @@ struct kshark_entry {
>>   	/** The PID of the task the record was generated. */
>>   	int32_t		pid;
>>   
>> -	/** Unique Id ot the trace event type. */
>> +	/** Unique Id of the trace event type. */
>>   	int32_t		event_id;
>>   
>>   	/** The offset into the trace file, used to find the record. */
>> @@ -319,6 +322,9 @@ struct kshark_data_stream {
>>   	struct kshark_data_stream_interface	interface;
>>   };
>>   
>> +/** Hard-coded maximum number of data stream. */
>> +#define KS_MAX_NUM_STREAMS	127
> 
> Will this become a variable?
> 
> Let's say we have a really powerful machine with a lot of memory. And
> we have a data file with 500 CPUs traced, and we want to look at all of
> them? Will this be a hard limit to change in the future without recompiling.
> 
> I've been hit by restrictions like this in code in the past, and know
> that things like this can stay in the code for a long time, to a point
> where they are no longer reasonable. I just want to make sure that we
> don't get stuck with that. I've learned to look at all hard limits with
> extra care, knowing that they are always a pain point in the future.


Now when we have 16 bit available for coding the stream Id, we no longer 
need to enforce such a small limit for the total number of streams loaded.

Thanks Steven!

Yordan

> 
> -- Steve
> 
> 
>> +
>>   /** Size of the task's hash table. */
>>   #define KS_TASK_HASH_SHIFT 16
>>   #define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
> 
