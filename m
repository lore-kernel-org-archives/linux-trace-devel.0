Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E83AC433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 May 2021 13:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55D3361288
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 May 2021 13:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhEKN0r (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 May 2021 09:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhEKN0q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 May 2021 09:26:46 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727D6C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 06:25:38 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id n25so22861329edr.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 06:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P6GJR+lqrti9qO7jJRQAYOojc9k+crKLDWrhRR0XfnQ=;
        b=XebmCmIeJ3AGASNTcJQyLrLlvuNYrJfbO5fjlwAXdIyu3dmq5LnbJt94146yXvhHRY
         ABmAMokiLAo969rYuGg4ZQyrqnXwuFiKCDWFoXRfdr6ZgGXspmPrmFQAbsgDOyRt5/cb
         S44GRGOfZUWIZ8f5c5DIycdGK405X0kR6gS6JrK8wJJ/pjZHRNTsTr3zthH6p5lk3v85
         c42j28oXcpD/rjX2uOJ/TPr+Rn0mt8FVMR0+YxpNjM10MHUZB25kl7MIIrGi00+ox/4s
         TXx7L0KK97CWLfDyEx2wfTn2oh0EX+twDe9ak7dQ/NuuXhmYajpITTykR08aElr1ZB1w
         aTJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P6GJR+lqrti9qO7jJRQAYOojc9k+crKLDWrhRR0XfnQ=;
        b=NhUiMEoIJ4nkHaeLsgYo6jCNVRehh0uCODtqy2ngCo4T0VrOI+029pxsbOXG+v+rzu
         hu89Bsb57zKeR6zembb38aWSaDWIKzKOdmgxq2XcnEUu9aI+kjti/gcRs03G3Je4IoMD
         RrkuS0nflRYz9uuRI+bGRViE3EaYWhmo8g6trBSI+eBKJzGchgkOxZn2R5T/u/QNVGmC
         +QUazepBQCx7mhO2uuyY8gy5EGsKOC56ZPVU+GEiBkQEPcc7/8A0XD9pgFhBo5+IZl3N
         CLgzH6BpTil8THJhPfF1f4eiW7z7lAJZC9Dz6CGOLPbZFIoQI0QBP10jmIH0IDsCtASy
         5vDQ==
X-Gm-Message-State: AOAM531KqsmJJ23hKjaz9CjsH9n0s4QVNM5ULbYtd6pG1+vf3pZ6WgAS
        0AzGsfucM2sNh+8tasqyV4XWmipBEFI=
X-Google-Smtp-Source: ABdhPJztWdHnjFoWq+wz8WW5NxQEmxM5SV/3kjqK9uvzW3R1Umbzdw9xUm8OrSRg6MLhjWHazIPjgg==
X-Received: by 2002:a50:eb47:: with SMTP id z7mr36785349edp.68.1620739536939;
        Tue, 11 May 2021 06:25:36 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id y9sm56625ejc.36.2021.05.11.06.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 06:25:36 -0700 (PDT)
Subject: Re: [PATCH] kernel-shark: Add check for return of
 ksmodel_get_cpu_front()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20210507093848.72bf0bed@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <2bc740d1-e093-17d1-a9ba-b4319e0ebbfa@gmail.com>
Date:   Tue, 11 May 2021 16:25:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210507093848.72bf0bed@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On 7.05.21 г. 16:38, Steven Rostedt wrote:
> From: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> When I loaded two trace.dat files (host and guest), but the mapping of
> which host thread is associated to which guest vCPU was missing from the
> file, it caused a SEGFAULT. That's because in fillTaskGraph(), the
> lamGetPidCPU() calls ksmodule_get_cpu_front() which returns a negative
> number and does not set index. But the next line checks data[index] where
> index is some random number, and the application crashes.
> 
> By checking the return of ksmodule_get_cpu_front(), and if it is negative
> do not reference data[index] and just let eFront be nullptr, the
> application shows no mapping, but at least it does not crash.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
> You can reproduce this with:
> 
>     http://rostedt.org/private/trace-no-map.tar.bz2
> 
> diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
> index 225dc34..abef5f8 100644
> --- a/src/KsPlotTools.cpp
> +++ b/src/KsPlotTools.cpp
> @@ -1280,7 +1280,7 @@ void Graph::fillTaskGraph(int sd, int pid)
>   						 false,
>   						 _collectionPtr,
>   						 &index);

I wonder why this fails? Is it because "pid" is negative? The fix below 
is appropriate, however we should detect negative PIDs and abort 
plotting much earlier.

Thanks!
Yordan

> -		if (index >= 0)
> +		if (cpuFront >= 0 && index >= 0)
>   			eFront = _histoPtr->data[index];
>   
>   		cpuBack = ksmodel_get_cpu_back(_histoPtr, bin,
> 
