Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC057C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 10:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A70AC60EFD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 10:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbhG2KZu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 06:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235155AbhG2KZs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 06:25:48 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1F6C061757
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Jul 2021 03:25:44 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id n12so6302178wrr.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Jul 2021 03:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yAk50ufmlrAwv+/iBOxwM/l/rXffDuJ6g4PqZ/rl3gM=;
        b=T5uWFnoS0xFFiq/ukGb9iZoc2cj2+ZPMnMY/AL1FkDX0zmBhtzICDXClpgd6GgVlf4
         7ALa7rywS52EFd5DbMfn1X9Fbl+9IC2If05TIBYKvlpKqLQzTHPe3Xw9Afwn8s5NeRST
         NRA98Qh6pf8ESH52Isyolork7QOKw9TgwbLnZUV14Yjb27QngEv/WGj9LT+GkzUJrz/6
         0Uuyw1o5+1Ez1jfZXxjYnwPQ1VSFgbW482L9uTHtktfdBbx3YbGup0wjmMPJB1NMok5B
         ndIRBLOttISNPM4wxU/R8ooRaVpmwQ6Tus3ez18o1hVOLd7pXTp9cS4gSMd7vh1xSouI
         TcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yAk50ufmlrAwv+/iBOxwM/l/rXffDuJ6g4PqZ/rl3gM=;
        b=G76mrzVGPnh4ycRr7CXAt81yabCOYMBr1pRWHGgxClFnLUpKJn3hGih7qa6GUGkbMm
         TvFHHnB2V1A85bPxMPEhMrBgNZxSYvE10Gzi/d4Ryp5gzvR8WczHDN+A9ep4GdntUoSS
         boxUFZ/NqAN/AproSdKhHXyNKtsIKVAxJi/8gtlnbQeYX2/hVbfu5QYlHRkTJwwYfikC
         rUuRHTQmcQEOKCQrtXRXscJd3f8yVWMwKXfKMD0fBRFrjE0ctWNyCRDfU1Qs/ePiMTFc
         KKaCT/85i5QWZAQkqyBesmy518XIGj9AFTpitNiOEJdGgEBZd0yTQMf5O2HefNsmJvke
         KvHQ==
X-Gm-Message-State: AOAM530G4AA4IWLpH3U7QtxKSMvlXSkWeBFncSkQeSZK5hnbcUYshxvl
        MSfyX3Wnsk3E16uy+irAr9hx0KcVQO8=
X-Google-Smtp-Source: ABdhPJy3o1PAdz8dX2GUygaXvfF39fLwI66oMtjqY82vaZYejNk2cEf8EQjZUlh379FLpqf8NfnYaQ==
X-Received: by 2002:a05:6000:10d:: with SMTP id o13mr4048208wrx.88.1627554341781;
        Thu, 29 Jul 2021 03:25:41 -0700 (PDT)
Received: from [10.93.98.252] ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id g16sm3523388wro.63.2021.07.29.03.25.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 03:25:41 -0700 (PDT)
Subject: Re: [PATCH 4/4] trace-cruncher: Allow for detachable kprobes
From:   Yordan Karadzhov <y.karadz@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
References: <20210712123242.223500-1-y.karadz@gmail.com>
 <20210712123242.223500-4-y.karadz@gmail.com>
 <20210722172435.3d8f434c@oasis.local.home>
 <cb908dc6-9ca8-7962-723a-a2388cebaf82@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Message-ID: <66070ff5-27cb-975e-198b-4f535b2c5999@gmail.com>
Date:   Thu, 29 Jul 2021 13:25:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cb908dc6-9ca8-7962-723a-a2388cebaf82@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 26.07.21 г. 12:07, Yordan Karadzhov (VMware) wrote:
> 
> 
> On 23.07.21 г. 0:24, Steven Rostedt wrote:
>> On Mon, 12 Jul 2021 15:32:42 +0300
>> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>>
>>
>>> @@ -1617,8 +1622,9 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
>>>           return NULL;
>>>       }
>>> -    if (!store_new_kprobe(event))
>>> -        return NULL;
>>> +    if (!detached)
>>> +        if (!store_new_kprobe(event))
>>> +            return NULL;
>>
>> I wonder if it would be more consistent and helpful if we created a
>> structure for kprobes like we do for instances, and this way we can
>> save the "detached" field in that structure, and not free it on destroy.
>>
>> This way, even though the kprobes are detached it may still be needed
>> in the future to list all kprobes that were created by the application,
>> regardless if they are detached or not.
> 
> Yes, this make sense.
> 
> BTW we should discuss what is the best data structure to store the kprobes that were created. In the case of the 
> instances we really need to use a binary tree, because we identify the instances only by name (string) so we are forced 
> to do a lot of searches. Initially I assumed that we will need to do searches for kprobes as well. However, so far we 
> only do listing.
> 
> Maybe, we should switch from tree to linked list? This will greatly simplify everything.
> 

I am deferring this patch together with the previous one ("Allow for detachable instances") for possible redesign.

Thanks,
Yordan

> Thanks!
> Yordan
> 



> 
>>
>> -- Steve
>>
