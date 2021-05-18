Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55831C433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 May 2021 12:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3029561209
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 May 2021 12:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbhERNAQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 May 2021 09:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbhERNAQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 May 2021 09:00:16 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106E0C061573
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 May 2021 05:58:58 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id lg14so14382184ejb.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 May 2021 05:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QbKZplSpLV5bxZvrRcXgiWjgUy6blyKEBtN0XueIo/Y=;
        b=g6CMRtUfonvCr9oQERbAWS30dqiKTcB8UtGmIklFQ8Lg/4xw+YJ37L21BhnC139IZM
         BDB7kIY4dEpxHUQseYUbK3rZhmJuqz1pNGc6W/njWf1+mzYLiBt1NJGIeX+rj+IJYhnR
         viOs15/F4SFm/sMEcICcCb0kGHu614BmI0D/WLmQgJH0Q07rvAenAjVxJfgtX9hXD4v7
         nwHAuaE2LSveNclouRH0YI9vOb4ly73Ld5RaKEe07PNROsWg1CygjOBRaYAahi2/vnzh
         DIflUvi6Sx6CAOwiyUlDrr1BI57wChY5yhWUmcJ7O8Dtw3Z4RCmcXYnl7fte3hTkMUaS
         tfEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QbKZplSpLV5bxZvrRcXgiWjgUy6blyKEBtN0XueIo/Y=;
        b=EKMCqWe3sNMJx7F5xkEvOT5ZqPh+FmR4UgyrKW4rr5Oyk4mKEcD9TQKuZGzPy920tz
         2cOtMTaB9y1NsB2bdyTtzNBXoGKVh3I9f743IY1doiNTFuUED43U41DbZxrSnWdo71ya
         lhQDF5MHGOhTl+BJI2IOOX395ry5HTErqcHkC2LeyKfy0pE+GnuKOfwu0rqKy7Lvzrg8
         2mAzHeXDJpT5CZlMyTajzXWFak6TUccbb0fOnN9AUb3a1M975uyPy2Jnbuq/2oflvnni
         NTnkkdRRclgIOZxk9L/5q0zHLcaDXSfYEdR0fUwZpwll6bzg2VBwBxVkVjyEodo/Wxw3
         ThvA==
X-Gm-Message-State: AOAM533MkdZw57DYFxWMD6IGyzGyJLgU7HQONJZCgANnEoXVQD45xk/G
        u6qZ2IJfWYHOmwWuAYZSmsGuAnaqqs4=
X-Google-Smtp-Source: ABdhPJw7k4g8HGQiaL8/af2AUi0ytWyM8QC8zmEhiBVHPUcoxTLWusmAoU1Z4cmJmYM4qQ1eRWQjEw==
X-Received: by 2002:a17:907:78c5:: with SMTP id kv5mr5969378ejc.146.1621342736575;
        Tue, 18 May 2021 05:58:56 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.151])
        by smtp.gmail.com with ESMTPSA id e23sm11774467edr.80.2021.05.18.05.58.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 05:58:56 -0700 (PDT)
Subject: Re: [PATCH v2 0/7] Final fixes before KS 2.0
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210517142140.286153-1-y.karadz@gmail.com>
 <20210517192104.0272eb84@gandalf.local.home>
 <80aafcf7-2ef5-01bd-b417-626e6b10b293@gmail.com>
 <20210518084607.7617ecab@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <1bc8936b-6ec1-52bd-b292-52464d4ae315@gmail.com>
Date:   Tue, 18 May 2021 15:58:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210518084607.7617ecab@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 18.05.21 г. 15:46, Steven Rostedt wrote:
>> Unfortunately I am not able to reproduce the crash. maybe it has
>> something to do with the particular data files you use.
> BTW, sometimes I need to do it twice. That is, I hit "Restore Last Session"
> twice.
> 

I restored the session 20 times in a row without having a crash.


> As this is a memory corruption issue, it will behave differently on
> different machines. Also, I do get the message:
> 
>    "Usage of trace_seq after it was destroyed"
> 
>>> Looks to be something is freed and then reused, because when I ran it under
>>> gdb, it crashed in allocation of memory (asprintf). That usually means that
>>> something was freed twice, someplace else. Or freed and then used.
>> Is it possible to send me a backtrace of the stack?
> Here's the backtrace from gdb:
> 
> (gdb) bt
> #0  0x00007ffff63cb02a in __strlen_sse2 () from /lib64/libc.so.6
> #1  0x00007ffff63994f8 in __vfprintf_internal () from /lib64/libc.so.6
> #2  0x00007ffff63aa015 in __vasprintf_internal () from /lib64/libc.so.6
> #3  0x00007ffff63844fa in asprintf () from /lib64/libc.so.6
> #4  0x00007ffff7ec88f9 in tepdata_get_latency (entry=<optimized out>,

This backtrace is very suspicious. It is exactly the same crash I had 
before applying [PATCH v2 6/7] kernel-shark: Fix the checking if 
"trace_seq" was destroyed.

I guess because of some reason it still fails to detect that the 
trace_seq was destroyed and needs to be initialized again.

Thanks!
Yordan
