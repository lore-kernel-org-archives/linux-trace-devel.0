Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50FAC433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 18:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B723F614A7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 18:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhEJSwG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 14:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhEJSwF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 14:52:05 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9FDC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 May 2021 11:51:00 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g14so19958553edy.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 May 2021 11:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pWCKQaYqKQ6By+5moM/wMs6GmRjfuJxFMvFhogAxKIQ=;
        b=IELm9hkDWk73G/Nvx7ld2zX2YYbZ9B3wM8HFuSetIPTkVp8XEWG3eoNcQ0GRn7ALxO
         sbCwD8EYjN57/adhkKXa7Q0cy/6THKNC/56ZkMW4mmwzBqrwfNqMH22h3596kQp12hr0
         Wl+t0Gr8WvzavK3PY3EGVEF+LJApkriiugJjwAj0GoKH/N7uTw+U/HtAQeCCxRHXZX7b
         n7ka2PoQM5UkeFdEr+GAPeWA79L55w9XvMqiMKM91h2Jp/nM7ZcgnSd8QNF6pPinzkM8
         fHM8TUzm4qXA8katHu3RItDsQ/4b4TkKsJKq71qljsfTgqziSW8YtqTmOqYbsUqoG1mn
         BD1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pWCKQaYqKQ6By+5moM/wMs6GmRjfuJxFMvFhogAxKIQ=;
        b=Suukcp8cdQY7Ul4k8CoY4xzLW+AifY9MOXLymC4V/NmV9bXntz0hZyWXWNHZlU22ec
         gLsVir38L7sGcxQi6FIq2hi/ti1H239yEiLHpZaBww3UJBx1tDdvsL7tvpLsizG6bgKe
         PGafbDC1uGvoKLkXvlQnHMweJxPUMJUQxAlsT6CooD0ouihUemav170KiiVhg3/FUOTY
         AXpZZ893x34hMEAdL4eaOQhCqqdcAWcGzALrFfRQMw3zxv0hzA7XJeomIOskqULnteLG
         HEsSvt/pjKF0fL3MiJ5t9WuYsWfztXtl7SvsAWXoA/94QFW5HRujdN/sxjtNd6bd53UV
         b0Rw==
X-Gm-Message-State: AOAM530qwBZOPZMnJTzag4DSHbyzvmf4wYsvYUN2mb4fyBiJKQaGamKt
        lylc1rwH1HS6ElDJbTCeZcxRvZ2hxGY=
X-Google-Smtp-Source: ABdhPJxRI5XZZH03MBdSRJ50C18oMRBK6XcADiG+PqOwjaxOQHT58L6K0nZXYIVqJeJ85DIQU7b8mA==
X-Received: by 2002:aa7:de8b:: with SMTP id j11mr31568499edv.363.1620672659043;
        Mon, 10 May 2021 11:50:59 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id j8sm11982651edq.67.2021.05.10.11.50.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 11:50:58 -0700 (PDT)
Subject: Re: [PATCH v2 3/9] kernel-shark: Fix KS_DEFINE_PLUGIN_CONTEXT macro
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210428134730.187533-1-y.karadz@gmail.com>
 <20210428134730.187533-4-y.karadz@gmail.com>
 <20210506141151.2f31f263@gandalf.local.home>
 <6c352db2-1f2a-4442-1832-1810d4d6a1a2@gmail.com>
 <20210510142537.2628c47b@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <cc7b594f-194e-9d2e-81e2-49f60f6c6eab@gmail.com>
Date:   Mon, 10 May 2021 21:50:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210510142537.2628c47b@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 10.05.21 г. 21:25, Steven Rostedt wrote:
> On Mon, 10 May 2021 14:53:08 +0300
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
>>> Can you show me how you see this error, because this solution does not make
>>> any sense.
>>
>> The problem is that some plugins can build from multiple source files.
>> For example in the case when part of the plugin is written in C and
>> another part in C++. In those cases we cannot have the functions being
>> static.
> 
> So it's because its a mixture of C and C++ code? And you can't make them
> static?

No, this has no direct connection with C++. The static functions are the 
same in C++.
It became an issue if you have multiple source files. If this is the 
case you have to put the macro in a header file, so that you can use the 
functions defined in the macro in all your source files. But this does 
not work, because the macro defines some global variables as well. To 
solve this I defined second macro to be used only in the header, but 
then the functions can't be static.

Thanks!
Yordan

> 
> So this isn't a name resolution issue, it's a C to C++ issue where static
> doesn't work? If that is the case then the change log is misleading.
> 
> -- Steve
> 
