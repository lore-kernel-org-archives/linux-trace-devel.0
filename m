Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EC6C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 May 2021 07:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCB5E6117A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 May 2021 07:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbhERHcE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 May 2021 03:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240235AbhERHcD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 May 2021 03:32:03 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3732DC061573
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 May 2021 00:30:45 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id a25so9831531edr.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 May 2021 00:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xiM9gCEJMEtsOdcIFpx+JnwTpZ+vgooNvxuuubaN6dM=;
        b=qRTZub8SKEIkY1KPdSJkclWwPRmVNOE83U8dqzFlclCZ2BEM9gebw+ZhHWMwd70sFK
         /qz9qOpNJEg3i11v8bunc1ltczYOmsTcHQWC/HGtq+MWq2U46lJM/NOW9GruMTYKi0ky
         a9mY0xaEqO/bJ6MQbEdu+90Kzj0lt+oHLGc7lWj4Fp7l5JhTjTxb4/VikXCL1tXjvSlE
         oHbHA5eThtiBQfjTDOk6c7ropIvbIyw0Q/UFaiijJvVVNbAIRm5jMOrLXyOHz0J23/29
         cpQROk6UgnZnKxr9wf7ReGcwhkbB3xO/tT8ggjtR2YosWpozl+10YDDvtAoq8SAH/1Uh
         Od/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xiM9gCEJMEtsOdcIFpx+JnwTpZ+vgooNvxuuubaN6dM=;
        b=sNRMSFSTsO1+b32tMaKZM3odMkiUbnh29dlNmp+3MI+3A6vmtvs7FZ1LB7LWz0mMQ7
         S04KtStK1oaqbhgJ8Hn6ToGwAmXqIRGLQ5dvEpYgG7Q5wFbE4zHMJLCAPDfF786gRm0Y
         yuA2+rE2rTVtCULHrK7l9tIpIazLyDb8NMtHE01RQz6q3suNLEIfBm09A+i6izgXBTec
         gP4UcinGfyjEfmfCqQupBaz2XnvEyaeSbeWpsiyRIsmM1RC68RjNbz31IR7WzS8DPC0K
         YHhjGE0llFidK2OEO7sWavcbv8zNdfql13q8OZlcMGoBu5CoTsGqf5vC0MLEBwu+2doP
         7JIQ==
X-Gm-Message-State: AOAM530NpG2gBE4yA3Q6LzGXl1nm9jWEgK6c6fL3DKH67bXTjbcRkago
        pZQOJZYj31RxcYo9svU4U7iVYDqSyak=
X-Google-Smtp-Source: ABdhPJzjuUI2s5cPH4f0omOzpRPPz0+uZyfQDF6tPjW5cQ7tb50EXWqmC3nLFhnZJUzDClQZrzFUCg==
X-Received: by 2002:a05:6402:2788:: with SMTP id b8mr5527487ede.140.1621323043619;
        Tue, 18 May 2021 00:30:43 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.151])
        by smtp.gmail.com with ESMTPSA id g4sm12719002edw.8.2021.05.18.00.30.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 00:30:43 -0700 (PDT)
Subject: Re: [PATCH v2 0/7] Final fixes before KS 2.0
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210517142140.286153-1-y.karadz@gmail.com>
 <20210517192104.0272eb84@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <80aafcf7-2ef5-01bd-b417-626e6b10b293@gmail.com>
Date:   Tue, 18 May 2021 10:30:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210517192104.0272eb84@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 18.05.21 г. 2:21, Steven Rostedt wrote:
> On Mon, 17 May 2021 17:21:33 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> v2 changes:
>>   - Still showing all CPU plots from the new trace file when
>>     appending [PATCH kernel-shark: Preserve open graphs when
>>     appending data].
>>   - Setting "seq.buffer" to NULL after calling trace_seq_destroy()
>>     in [PATCH kernel-shark: Fix the checking if "trace_seq" was destroyed]
>>   - [PATCH kernel-shark: No slash at the end of KS_PLUGIN_INSTALL_PREFIX]
>>     is new.
> 
> Hi Yordan,
> 
> I was playing a bit with kernelshark, and found that if I load a file and
> append one, exit, load them again, then click:
> 
>    File -> Sessions -> Restore Last Session
> 
> It crashes.

Unfortunately I am not able to reproduce the crash. maybe it has 
something to do with the particular data files you use.

> 
> Looks to be something is freed and then reused, because when I ran it under
> gdb, it crashed in allocation of memory (asprintf). That usually means that
> something was freed twice, someplace else. Or freed and then used.

Is it possible to send me a backtrace of the stack?

Thanks!
Yordan

> 
> -- Steve
> 
