Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D67FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Feb 2022 17:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243867AbiBQRtY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Feb 2022 12:49:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243875AbiBQRtX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Feb 2022 12:49:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9B23291FB8
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Feb 2022 09:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645120147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rRIMKHhamSqp8VeNfr4XcAxWjxGDpns0iibC3SSvphI=;
        b=eF5BMzvyQXF1u5NIeF/5CXsEgqDc+dtAR+XBuVksjZzm3kQQkkWsUiuohvAms+WlfmGB0M
        LOfgSg6bQh/9FEzCJCBUr5Mbr2ImWF9rp6YPZNyGo9qKVqFt/XjjJZzNQ9Jcw4p3700128
        KXZ5uNp6nCY8Rqf3BRRYN38mX8PDZt4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-qRLZO9AjM5KPHEdxP5_2Vg-1; Thu, 17 Feb 2022 12:49:04 -0500
X-MC-Unique: qRLZO9AjM5KPHEdxP5_2Vg-1
Received: by mail-wr1-f72.google.com with SMTP id g11-20020adfa48b000000b001e57dfb3c38so2602845wrb.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Feb 2022 09:49:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rRIMKHhamSqp8VeNfr4XcAxWjxGDpns0iibC3SSvphI=;
        b=iK2c/Z/cJfOwllMw6OHC9Itqmj5rdk25Lt2Db2YSOLsz8LeW5u/s3XNlVrHq43IGHU
         iX7AGPz3rN/2sO2BYqrru1PPE1E4e+YWA4x5kHg5VjALhoKmu3UUYO0zr9alSN1SM6IF
         /KZVT5n7far8zDwyRSOSeIpB4rB/GgwVjtXWmKh2iOez1VF2EvrhwaAVHmci6LjdgItX
         gfI+tLK4ttQ4x9mr6TgOXpZoacrS6FKrY5azz6HLTY+0cwn3MmDb5IE1zqJkd/z+N4fX
         lB/FT4r4Z8dh1O6JzG0GGg0Q4gSkqqoQnpGcHo+erMsTP1Ha++yIh1m7TUgBvgFvzmtg
         4EkA==
X-Gm-Message-State: AOAM532qGV8p8rLTmyT1c8XOmwDeyBRIW4eYv8cAmSG3tdI5M5U4perd
        1spaNs7ElZJay7GKeWoZHJNGT7O9iXydSmD5iocwd0VHDoTKE1f8EtpBHqTd/B7cLvO+DkyOXBz
        rCmE1xIwR/FwJIX/XtrInlav3DbJpF+w=
X-Received: by 2002:a05:600c:35d1:b0:37c:d45c:af57 with SMTP id r17-20020a05600c35d100b0037cd45caf57mr7156024wmq.149.1645120143303;
        Thu, 17 Feb 2022 09:49:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZ9zXHZ9F/mtgzKSHmwW5LPeJBNm3yMLCV+v3cbCHhyApAmjEFStihyj3q0BuKaMTUhMKzIw==
X-Received: by 2002:a05:600c:35d1:b0:37c:d45c:af57 with SMTP id r17-20020a05600c35d100b0037cd45caf57mr7155996wmq.149.1645120143067;
        Thu, 17 Feb 2022 09:49:03 -0800 (PST)
Received: from ?IPV6:2001:b07:646c:22c6:db53:7a2b:ef3c:adb0? ([2001:b07:646c:22c6:db53:7a2b:ef3c:adb0])
        by smtp.gmail.com with ESMTPSA id 14sm8654293wrb.34.2022.02.17.09.49.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 09:49:02 -0800 (PST)
Message-ID: <6c6fc4fa-6464-2dbf-40da-e3c61f322d95@redhat.com>
Date:   Thu, 17 Feb 2022 18:49:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC V2 17/21] watchdog/dev: Add tracepoints
Content-Language: en-US
To:     Guenter Roeck <linux@roeck-us.net>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Peter.Enderborg@sony.com" <Peter.Enderborg@sony.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
References: <cover.1644830251.git.bristot@kernel.org>
 <e67874c8b676ea8dfe38679efa25363889bb1e76.1644830251.git.bristot@kernel.org>
 <96f418b4-0ba8-01fe-ead0-2028bfc42560@sony.com>
 <ba924008-c0ab-4800-aac4-d9d9ae930c32@kernel.org>
 <ef1b1d99-6172-2b4d-9612-7ecbe8fc6c8b@roeck-us.net>
From:   Gabriele Paoloni <gpaoloni@redhat.com>
In-Reply-To: <ef1b1d99-6172-2b4d-9612-7ecbe8fc6c8b@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 17/02/2022 18:27, Guenter Roeck wrote:
> On 2/17/22 08:27, Daniel Bristot de Oliveira wrote:
>> Hi Peter
>>
>> On 2/16/22 17:01, Peter.Enderborg@sony.com wrote:
>>> On 2/14/22 11:45, Daniel Bristot de Oliveira wrote:
>>>> Add a set of tracepoints, enabling the observability of the watchdog
>>>> device interactions with user-space.
>>>>
>>>> The events are:
>>>>     watchdog:watchdog_open
>>>>     watchdog:watchdog_close
>>>>     watchdog:watchdog_start
>>>>     watchdog:watchdog_stop
>>>>     watchdog:watchdog_set_timeout
>>>>     watchdog:watchdog_ping
>>>>     watchdog:watchdog_nowayout
>>>>     watchdog:watchdog_set_keep_alive
>>>>     watchdog:watchdog_keep_alive
>>>
>>> Some watchdogs have a bark functionality, I think it should be event
>>> for that too.
>>>
>>
>> I understand. The problems is that I do not see the bark abstraction
>> in the
>> watchdog_dev layer.
>>
> 
> I don't even know what "bark functionality" means. A new term for
> pretimeout ?
> Something else ?

From my understanding the bark timeout is actually the pretimeout
whereas the bite timeout is the actual timeout.
I think in the Kernel ftwdt010_wdt and qcom-wdt are bark/bite WTDs

Gab


> 
> Guenter
> 
>> In the case I am investigating (the safety_monitor/safety_app) the
>> bark is
>> outside of the "OS" view, it is an hardware action - like. shutdown.
>>
>> Am I missing something? Thoughts?
>>
>> -- Daniel
> 

