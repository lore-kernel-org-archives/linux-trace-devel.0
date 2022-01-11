Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3ECC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jan 2022 14:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240189AbiAKOiF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 09:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240088AbiAKOiE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 09:38:04 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C36DC06173F
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jan 2022 06:38:04 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id u25so68059584edf.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jan 2022 06:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9pieuN7rqbs2+2VSSrrnWnAVDKtCGQLB2wBUjLZXAJw=;
        b=nBPFyiNt/Xq+iy1gaqTRXZfy46Cq6v7aIM4ZxSOJAPIlw0FErEBSEuObrYw/Yqd8Gh
         QWIr46sHQUYP5LOHJoTrbAPuiejcl7MeLq5QUXea118hQwdDCvL4G3bVdkW9z3hANiyj
         iPQ0N8TqCkZtjAYKgHHJT5NhVfjYtWaAO8QRYp/YZn+qXQX0RK5J/luktGZtx5WSfE/R
         YKtrpvO0GKooj2l4NnjoV0bHLz8u9TIeLiIP7rzCs9eGQ6zEJwORiFsSAD81fSEwWP6u
         ploJPYigiK7U5ypgV0Wd7nE9tAjGpzUUbcBmOCb2Wieb++v5CI/J1zbmdOi3b+b/yCn9
         h0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9pieuN7rqbs2+2VSSrrnWnAVDKtCGQLB2wBUjLZXAJw=;
        b=vu5q4dHhMgB3o8v/0HIHYBctwtn6GD9Pq6re/qjn18WNCWbivRPN1aLUmVazT2iIcY
         6UWRrlwY33q79pDIW29vQF5jmgNMaUWmLe3QSgjo9pYpMBOJsCAUVUARo04rt5JqbdYy
         IzEBCVz1yrcuV2jKXOoITy181SXy90NGaa6RQcz5bwP/if2UY8gCGuvgBitT8vxtlBuu
         8ULQ3iqpe3T2ZTWIVVHfLzw80UPM12X3l6g66Zrd0eafotEAYpKsOr4TKmyoAwaGNVzf
         XMBhhnyiLAE55Do0+i37Awo+Uo2XW7X0jZhnMKvbqOd7+OZ+lfGgsY78YArSgWFP13xK
         gjuQ==
X-Gm-Message-State: AOAM5315btxEumMvQoUejnn/x2o1mHdhnEhNH7C33/yAZTvDQHXIkLZp
        mgHBiPTKvkNRvOpGb1uTwzw=
X-Google-Smtp-Source: ABdhPJyW35C7Qyx+NlX0K+9K2C2SUqlK1+cOwVPXAIiRSm1JkMABKXHfaDi9u4+GKY/j1iB5khuC4w==
X-Received: by 2002:a05:6402:524a:: with SMTP id t10mr4729507edd.42.1641911883031;
        Tue, 11 Jan 2022 06:38:03 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id y2sm821449eda.45.2022.01.11.06.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 06:38:02 -0800 (PST)
Message-ID: <0f79933c-6851-da46-8e2c-5606b35cfd03@gmail.com>
Date:   Tue, 11 Jan 2022 16:38:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] trace-cruncher: Add API to set tracing CPU affinity
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
References: <20211217182619.13db88f0@gandalf.local.home>
 <87b5f204-8132-a8dc-321a-f0928eef3710@gmail.com>
 <20220110102010.5c41b336@gandalf.local.home>
 <ddda1b3a-c626-8733-5d74-0d29d768e7a5@gmail.com>
 <20220111090035.3cf11479@rorschach.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220111090035.3cf11479@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 11.01.22 г. 16:00 ч., Steven Rostedt wrote:
>>>>> +PyObject *PyFtrace_set_affinity(PyObject *self, PyObject *args,
>>>>> +						PyObject *kwargs)
>>>>> +{
>>>>> +	struct tracefs_instance *instance;
>>>>> +	static char *kwlist[] = {"cpus", "instance", NULL};
>>>>> +	PyObject *py_cpus;
>>>>> +	PyObject *py_inst = NULL;
>>>>> +	const char *cpu_str;
>>>>> +	struct trace_seq seq;
>>>>> +	int ret;
>>>>> +
>>>>> +	if (!PyArg_ParseTupleAndKeywords(args,
>>>>> +					 kwargs,
>>>>> +					 "O|O",
>>>>> +					 kwlist,
>>>>> +					 &py_cpus,
>>>>> +					 &py_inst)) {
>>>>> +		return NULL;
>>>>> +	}
>>>>> +
>>>>> +	trace_seq_init(&seq);
>>>> There is a global trace_seq object that can be used here. Also you have to check for error.
>>>> Perhaps having:
>>>
>>> Don't we need mutex protection if we use a global object?
>> As far as I know Python is intrinsically single threaded.
>> Only one thread can execute Python code at once.
> Are you sure about that? A quick search produced this:
> 
>    https://realpython.com/intro-to-python-threading/
> 

Hmm, I am not 100% sure, but I still think this is the case.
In your link, if you go down a bit you have

"If you’re not sure if you want to use Python threading, asyncio, or multiprocessing, then you can check out Speed Up 
Your Python Program With Concurrency."

where " Speed Up Your Python Program With Concurrency" is a link to here:
https://realpython.com/python-concurrency/

and here if you scroll down to the first table, you will see that multiprocessing is the only real way to run Python on 
multiple CPUs.

You can have a look also here
https://docs.python.org/3/library/threading.html

"In CPython, due to the Global Interpreter Lock, only one thread can execute Python code at once (even though certain 
performance-oriented libraries might overcome this limitation). If you want your application to make better use of the 
computational resources of multi-core machines, you are advised to use multiprocessing or 
concurrent.futures.ProcessPoolExecutor. However, threading is still an appropriate model if you want to run multiple 
I/O-bound tasks simultaneously."

Thanks!
Y.


>> Multiprocessing is the only way to parallelize the execution.
>>
>>>
>>>    
>>>> 	if (!init_print_seq())
>>>> 		return NULL;
