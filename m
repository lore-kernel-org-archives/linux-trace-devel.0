Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D817FC388F7
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Nov 2020 14:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6671F20897
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Nov 2020 14:49:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qy6evqOz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731881AbgKIOtn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Nov 2020 09:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731865AbgKIOtm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Nov 2020 09:49:42 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AD3C0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Nov 2020 06:49:42 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id k2so5586740wrx.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 09 Nov 2020 06:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NnoE0Ie9WZMprDti2eOpXUuJ/MPSFTzneHaQ9pMT+DU=;
        b=qy6evqOzO3AqLAZtPHqAky1e9J7Y2YC2bZ+VjpEiAq2xgGoRDSdstV7eCnu5o9f99o
         QLdLldwfmClKnoBJG3RN7Kpn7ho1z5jr0iXiUdB2Kc/r5bgjZ8RGQ4nSiN/KG2HFw3Sd
         JrdvJmM7WdvmhHozULZ+8bNSP0vBAbYFDgE9njzoqtnzNbNfoK4IaM0E/a9n7tt6kJ3W
         GdHS1jEA+kdS/0pTx5gK6b7qpJ2e1+bG/CZrD29R61ic2teecW1wKThhTOJmtgmCU3KH
         szra00l5SRmKM9lSa6cuPmXC3oBLDoMmQv1plonqUAVnm8ELaSWKme+lb33gWU3rDBS6
         LT0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NnoE0Ie9WZMprDti2eOpXUuJ/MPSFTzneHaQ9pMT+DU=;
        b=nmJZrIUirj023d9TDsXJ768PpfqW6ofiSSZKye8ak4mMVCYG2Sz3nLf9Pber1Lio/s
         BAn0Nbu2dQFcR33OLVZ1sfIcdILaUreU9TC8I/ya6rZx+aL+9FRsFLFef/RjPU7QDapm
         SOFJRMer9D7Qd1Cnyp0F1TEh6iMb5yFJonDwqUdLq2WnvLNlAqsbusa0Q89okfmWtZrd
         D5ccIojZbviCgzOJdCCdqmImlBt5I47Pv0DYsW/w0clH6ye040sGmTatTAu4A+yV9ZIO
         sQoVW5Kv0XMkeUGK0yi3ha/GeIuVR3YJJhdO9rTqiVYnTT8VfLWXPW88epaSSbMwknRO
         oEgA==
X-Gm-Message-State: AOAM533BmnZRJt0Gc6MNbj+g6gzgPk9UrfFA2uiCqTuC/Wv19tqZGDKG
        AewDVWo/qe3C+q0Wi4YThORD2umfZk4=
X-Google-Smtp-Source: ABdhPJxxow6avRdjSamF0+LiChIhFVEU5tpHKZTX+jWbm/QBG9x32g1sC1D4oWeIZYdTjyogSQSmXw==
X-Received: by 2002:adf:de12:: with SMTP id b18mr19054338wrm.187.1604933380824;
        Mon, 09 Nov 2020 06:49:40 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id z5sm13448589wrw.87.2020.11.09.06.49.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 06:49:40 -0800 (PST)
Subject: Re: [PATCH v2 10/20] kernel-shark: Start using data streams
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201012133523.469040-1-y.karadz@gmail.com>
 <20201012133523.469040-11-y.karadz@gmail.com>
 <20201014145627.675e3c70@gandalf.local.home>
 <b5569725-239f-3e5b-dfa0-97f7d51b5d01@gmail.com>
 <20201105131735.3d559bce@gandalf.local.home>
 <d88af9bb-1f15-04cf-230c-ea59b3239931@gmail.com>
 <20201106101818.77f94a0d@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <26f9bcfb-f873-2415-fb24-42cd488fb2f7@gmail.com>
Date:   Mon, 9 Nov 2020 16:49:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201106101818.77f94a0d@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 6.11.20 г. 17:18 ч., Steven Rostedt wrote:
> On Fri, 6 Nov 2020 16:31:58 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> Hi Steven,
>>
>> I am not sure I understand correctly your pseudo-code, so please correct
>> me if my interpretation is wrong.
> 
> Note, it's not really pseudo code. I didn't compile it, but it should work
> mostly unmodified.
> 
>>
>> In the normal case when a new stream is added the corresponding object
>> will be allocated and added to the array of pointers. Later if a stream
>> is removed, instead of freeing the memory we will just manipulate it
>> pointer so that it point to nowhere and this manipulation can be
>> detected by the kshark_is_valid_stream(). Now if we want to add stream
>> again, we will take the broken pointer, will restore its original value
>> and will reuse the object without a new allocations.
>>
>> And at the very end we will have to free all pointers (original or
>> manipulated).
>>
>> Is this what you are suggesting?
> 
> Hmm, let me explain it slightly different, as nothing is "restored".
> 
> We change the value of the array from pointer to an index. For ease of
> explanation, let's consider this a 32bit machine and we allow 256 streams
> (one byte). That is:
> 
> 
> sizeof(long) == sizeof(void *) == 4
> 
> #define NR_OF_BITS_FOR_STREAM 8
> 
> #define KSHARK_INDEX_MASK 0x000000FF
> #define KSHARK_INVALID_STREAM 0xFFFFFF00
> 
> Lets say we add 4 stream in a row. Each one will detect that free_stream is
> equal to n_streams, and just append them to the end of the array
> (reallocating the array if necessary). We end up with:
> 
> 
> free_stream = 4
> n_streams = 4
> 
> streams:
> 
>    0: 0x07123010   -> stream 1
>    1: 0x07123020   -> stream 2
>    2: 0x07123030   -> stream 3
>    3: 0x07123040   -> stream 4
> 
> 
> Now we free stream 3 (at location 2):
> 
> free_streams = 2
> n_streams = 4
> 
> streams:
>    0: 0x07123010   -> stream 1
>    1: 0x07123020   -> stream 2
>    2: 0xFFFFFF04	== (KSHARK_INVALID_MASK | orig:free_streams)
>    3: 0x07123040   -> stream 4
> 
> 
> Now we free stream 1 (at location 0):
> 
> free_streams = 0
> n_streams = 4
> 
> streams:
>    0: 0xFFFFFF02	== (KSHARK_INVALID_MASK | orig:free_streams)
>    1: 0x07123020   -> stream 2
>    2: 0xFFFFFF04	== (KSHARK_INVALID_MASK | 4)
>    3: 0x07123040   -> stream 4
> 
> 
> Now lets add stream 5:
> 
> free_streams = 2 == (streams[orig:free_streams] & KSHARK_INDEX_MASK)
> n_streams = 4
> 
> streams:
>    0: 0x07123050   -> stream 5
>    1: 0x07123020   -> stream 2
>    2: 0xFFFFFF04
>    3: 0x07123040   -> stream 4
> 
> We are just making a link list of free pointers within the array of
> streams. This is basically exactly how memory management systems work. The
> free memory list is stored inside the memory itself that is being allocated.
> 
> The 0xFFFFFF is so that if we want to loop over streams, we can skip the
> free slots, by checking: streams[i] & 0xFFFFFF00 != 0xFFFFFF00
> 
> Note, the free slots do not point any memory location. Think of the items
> in the stream array as:
> 
> union {
> 	struct kshark_stream 	*stream;
> 	unsigned long		index;
> };
> 
> You can differentiate without using typecasts with:
> 
> 	if (streams[i].index & 0xFFFFFF00 == 0xFFFFFF00)
> 		index = streams[i].index & 0xFF;
> 	else
> 		stream = streams[i].stream;
> 
> Does that make more sense?
> 


Yes, it makes a lot of sense. Thanks a lot!
I am implementing it. It requires to do some rebasing in the successive 
patches (the GUI code). I am almost ready to send v3.

thanks!
Yordan


> -- Steve
> 
