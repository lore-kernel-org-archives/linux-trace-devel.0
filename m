Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D9CC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49FE46145E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 13:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhENNrF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 09:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbhENNrF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 09:47:05 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A96C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 06:45:54 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t15so7090402edr.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 06:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FT7xAOOytm9sb5zmwE8t/9eJXx5zLF+21Yj5ULENmRE=;
        b=n2rOQd0AUb0QQBtwH7Ay0OXa0fR4NiOfe7uD34monSmwrUlNXdnKrsZZ4KA+CJZ5Ub
         t+Vpb8jPKX2+KLUdDdDQPwPsPyqDTD25/ZodFbDeBs07oYwB4HGCRYoXQUhCiun6yXlm
         4GzhMEs0agodZ++M3bUgFDG5YWhcBZA49he3AqVj7Mco/xnDonbEVNhQu9UU7Fl8wsuB
         tIeEg59JztrYf/LmNImUbp7xQtslCYWzwpV9vTqbsJy/0viLmaLbJRdgYzZqVSRQYDgg
         thblKmkkQadicZahfYZiJ7CwWvBq4hgfmK8otPbXOoiBNDZDvSG6WAtPNlx5fNX1WJIp
         CxEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FT7xAOOytm9sb5zmwE8t/9eJXx5zLF+21Yj5ULENmRE=;
        b=mfQdNCmQCGOl0s/QxtxygwATi0IrtqAPm5PAaCmZUdYuDn702ib+7bvd7EMe7Cb+U8
         rO1jXVTmARjXI3Y6BjOtky1CQOJfGr0p8J2BxPEMvdRSkiYIPuHBs7kN+fnhedqm5IE9
         HrwHOj1o0avgudQPdSjjtXUAaelnq9AdwZkqtT6FiK+1jSQ7f/45+4PBI2uwycZHmL+c
         GEvgmpw2O5N8nNYTEUz9RrpuIQZDJwjm9meSavkIQ9s1rXFj1CXyXE0kR3KRhJjrQL3L
         3ytCVz7GOLycsYXIyNc5OnN1w+lJeA1thk8/Gnf9PVaOKJ3vncrqzHKlvkD48nq+hhMo
         E9/A==
X-Gm-Message-State: AOAM533wIa4BNtagrG3xvhanCvFMLdy83/P2XRahZ/aVdgdVirI1NOYq
        HCvN0doXe7ZdkaEKMmitEyQ+9vDVrYg=
X-Google-Smtp-Source: ABdhPJzC/oyN9IhqHWc1y3Ti+fcOCoVL42HuT8wJS5mzRjcNkKnR35gLgGdx860kOXT0p4ui5kaKXw==
X-Received: by 2002:a05:6402:350d:: with SMTP id b13mr56335278edd.21.1620999952694;
        Fri, 14 May 2021 06:45:52 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id h4sm4271056edv.97.2021.05.14.06.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 06:45:52 -0700 (PDT)
Subject: Re: [PATCH 6/7] kernel-shark: Check if "trace_seq" was destroyed
 before using it
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210514121826.161749-1-y.karadz@gmail.com>
 <20210514121826.161749-7-y.karadz@gmail.com>
 <20210514093133.504d1008@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <29e3a3e1-26fe-a7e2-fec0-605794e2f353@gmail.com>
Date:   Fri, 14 May 2021 16:45:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210514093133.504d1008@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 14.05.21 г. 16:31, Steven Rostedt wrote:
> On Fri, 14 May 2021 15:18:25 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> When closing a "tep" data stream we destroy the "trace_seq" object.
>> However, trace_seq_destroy() sets the buffer to "TRACE_SEQ_POISON"
>> which is different from NULL.
>>
>> It is unfortunate that TRACE_SEQ_POISON is an internal definition
>> of libtraceevent, so we have to redefine it here, but this can be
>> fixed in the future.
> 
> It's not unfortunate. It can change in the future without breaking API.
> 
> Redefining it here is not robust, and if trace-seq decides to do something
> different with that poison value, this will break, and it can't be blamed
> on API (using internal knowledge to implement code is not protected by
> being backward compatible).
> 
> The correct solution is to NULL the buffer after calling destroy.
> 
> 	if (seq.buffer) {
> 		trace_seq_destroy(&seq);
> 		seq.buffer = NULL;
> 	}

This was the first fix I did when I found the problem, but I don't like 
it because it looks like a hack the the user of the library is doing to 
trick the internal logic of the library.

Why not just moving the definition of TRACE_SEQ_POISON to the header or 
adding

book trace_seq_is_destroyed()

After this we can remove the clone from here.

Thanks!
Yordan

> 
> Just like you would do with a pointer you free but may use NULL as a value
> you are checking.
> 
> -- Steve
> 
> 
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   src/libkshark-tepdata.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
>> index bc5babb..4a84141 100644
>> --- a/src/libkshark-tepdata.c
>> +++ b/src/libkshark-tepdata.c
>> @@ -29,11 +29,17 @@
>>   #include "libkshark-plugin.h"
>>   #include "libkshark-tepdata.h"
>>   
>> +/**
>> + * The TEP_SEQ_POISON is to catch the use of
>> + * a trace_seq structure after it was destroyed.
>> + */
>> +#define TEP_SEQ_POISON	((void *)0xdeadbeef)
>> +
>>   static __thread struct trace_seq seq;
>>   
>>   static bool init_thread_seq(void)
>>   {
>> -	if (!seq.buffer)
>> +	if (!seq.buffer || seq.buffer == TEP_SEQ_POISON)
>>   		trace_seq_init(&seq);
>>   
>>   	return seq.buffer != NULL;
> 
