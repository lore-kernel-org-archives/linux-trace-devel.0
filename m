Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE6CC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 13:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E11202070B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 13:37:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JYooWtBO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfCZNhO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 09:37:14 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44811 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbfCZNhO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 09:37:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id y7so10269939wrn.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Mar 2019 06:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R0hw9iFNU7hfadbmBWH4e0FK484VWVo9aKWq15TwHB8=;
        b=JYooWtBOko3bh13fIgps5MYluPs+0tLoJRjDhP9PR4JzdCLsYmrqvoQPDikNIIuIY4
         bq2t8z+6aS8nJ+JzB2d+3hITDzButNaJ2RJEWZ0HmB23yySXvwYEwr2uNoaxCAohrRND
         s2JrVAAhzFlaX6hTJ6An0G10sX+iLv3AZa3KRQKSOuf2DHa3hyMUv6RdemCxVBLFlEuM
         wL0REK/vajA8JpkTdlwPAkeC17oa4i2TslUso/o69tOuqvUjn3b3DV305Jkf/H+xwOJQ
         nNXiztxovJroodlCkAoGkk5cYoB+qro1bGLQ6xuxgj/+rCb0x8DJKaK6dAwInDvz4adH
         JDaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R0hw9iFNU7hfadbmBWH4e0FK484VWVo9aKWq15TwHB8=;
        b=dSwRcZp7fpvYYQpD4TNlH72v/ca/A2groNXSTOa7mcyoXhe1fk6pNTwUaqI3dyhRwU
         mHk8XiYd9Da2fBtPqHdbWCZg13F0Lfiq1bLGW7J3cTPUaBhJzmuGj+duD4X791/Rz8Z5
         ZMXvs3BVmiB39ktPH+17Qz0xBnQKbS++DmFP6ogCA0Y3jfReh9kSoXeFBt1glCduC0CO
         z0CRaelUjfy0ctok/pIzSRo/nvFnkSGZq9kQqJfwuG8HqFOveWJNYQ6nTFCTgDYgV1Ue
         uteVtoa7WowjrOJh8pVMselOHIK69GZ6txMtIH7nS9KLyo5OdkuSEBNVJAyEp4F3WS1c
         0OpQ==
X-Gm-Message-State: APjAAAV5guAxiKeN7ZNLlNBkyWs4bwcXSoyEFYP5KUw3TD6iASvfHShz
        zkDfHZvzc9aDW2Fmi1rIZUuchn/2E1o=
X-Google-Smtp-Source: APXvYqwXHP51xPG0NfhHW0payvH5bCenhFM+TH5eMiiL0dRfvKmFE2xNEdBs1W6koTXOfrr0QRp+xg==
X-Received: by 2002:adf:e84b:: with SMTP id d11mr20832756wrn.289.1553607432852;
        Tue, 26 Mar 2019 06:37:12 -0700 (PDT)
Received: from [10.27.112.183] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o10sm16985938wru.54.2019.03.26.06.37.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Mar 2019 06:37:12 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] kernel-shark: Fix a bug in KsPluginManager
To:     Steven Rostedt <rostedt@goodmis.org>,
        Slavomir Kaslev <slavomir.kaslev@gmail.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
References: <20190307154316.19194-1-ykaradzhov@vmware.com>
 <20190307154316.19194-5-ykaradzhov@vmware.com>
 <CAE0o1NsXJCV65iRzCMTs_-R8H2ET1TiN4aY20EU5hvkTHOju5Q@mail.gmail.com>
 <351105f9-557d-5a2d-99f1-0f93db2848be@gmail.com>
 <CAE0o1Nv5g6wujxY8ey2mQ72kk977s7tCWq9Hcab1zfNU3rNOVg@mail.gmail.com>
 <f4a51b16-446a-a426-a8b4-71365b8829c4@gmail.com>
 <55A448CA-1F0F-4396-89D0-22515B630A28@goodmis.org>
 <20190325215846.31df78c7@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <84bef027-edaa-66f1-b77b-7229158687fb@gmail.com>
Date:   Tue, 26 Mar 2019 15:37:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190325215846.31df78c7@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 26.03.19 г. 3:58 ч., Steven Rostedt wrote:
> On Mon, 11 Mar 2019 11:15:40 -0700
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>>> Thanks a lot for investigating this!
>>> I think in this case it will be more appropriate if you sign the patch.
>>> cheers,
>>> Y.
>>>   
>>>> -- Slavi
>>>>    
>>>>>
>>>>> But anyway, your solution looks cleaner and safer.
>>>>> I will send another version of the patch.
>>>>> Thanks a lot!
>>
>>
>> Signing the patch means that the person either wrote the patch or handled it to be committed.
>>
>> I think you want Suggested-by:
>>
> 
> BTW, I'm confused. Does this patch need to be applied or was there another version coming?
> 

It is my fault. Looks like I forgot to send v3.
The patch is coming.
Thanks!
Y.


> -- Steve
> 
