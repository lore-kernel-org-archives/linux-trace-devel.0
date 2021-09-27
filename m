Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEFCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Sep 2021 09:57:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37BAA60F43
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Sep 2021 09:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhI0J6k (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Sep 2021 05:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbhI0J6j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Sep 2021 05:58:39 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C9EC061575
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Sep 2021 02:57:01 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id i23so50844780wrb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Sep 2021 02:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fuvb9f5k3Zh+WbuSYnsJAv5BeULXRseuuUO+fHIesls=;
        b=DGJ3FXCpzBZlGgiYTLgK66YtXHVUrF1BKSzXUp4wcTY2ClgwNm5X/X5xVvOeTd4DdM
         E7gexg6DCZKhCiRjKGo96we2G00l7E6nGE6YVRxQgcoFO4u9vrFAumafC3kIvVU8d0rG
         81rPx2RnKmzT/xAVqyWPIhG6Va5s6d67qU76P91njZi/uSH7Sb/G++owRAVA7J6Wmp6L
         wKN+bUS3z//bcpXG6GOG/GKKW+syJx2+IxRqK1y2eWBbPzfChpQvUU5S81s7M6hiOLMG
         drgPH1geuQILIz05U5XDSrCdkO5N1CkAwMB9Oq4+/EKdJNj1VTKqTK8L8px9+o/258OT
         gMog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fuvb9f5k3Zh+WbuSYnsJAv5BeULXRseuuUO+fHIesls=;
        b=02v9VNKoRFlLjID+VKEea0cGQjhOvY5V//obag5YoxRx653bq7H0UPTzoLDYvoXWyn
         ww3r3f7/Tdd50Y4gXhyqHmIykTxc3R58hwarrHIG3XCL/ZNB2v0AFsU0jpH2gGzamKPd
         aIn4jrPHZgEivx2Aib92UAtlTSfgVuU6B+mSF/+HtdfHpxZuwlMc1TsByQNLv3IqccZT
         Paz38CqkLH8cqnjqO0ZrCYO1KOdrH71XUtMe4ma8IcL6HN9kaudCXf675S2OiDC09gfn
         +5FUTdpILPq1CMWFBw/rGhC18eEfuoyYXRo70c62SBlrCD/pE7F6i5vuANOyNuEvRbgj
         cc1g==
X-Gm-Message-State: AOAM532nHNfDIyW7SLVfBpYTNRYSTGnPc6FIBSXqsnGWbOoEniiYDvJ1
        R15V3PNIVFdPSF6zrs4US8IgxKZ9Hjc=
X-Google-Smtp-Source: ABdhPJzz+JthbUJDpRFs/IIFWWSGPjQ43HqVNPZWPqO4UHX4icow+2A6w1SivXh9mvcqaPjCPMXmaA==
X-Received: by 2002:a05:6000:243:: with SMTP id m3mr57521wrz.328.1632736618854;
        Mon, 27 Sep 2021 02:56:58 -0700 (PDT)
Received: from [10.93.98.252] ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id w18sm749474wrt.79.2021.09.27.02.56.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 02:56:58 -0700 (PDT)
From:   Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH] kernel-shark: Handle traces with sched_wakeup but not
 sched_waking
To:     John Keeping <john@metanate.com>, linux-trace-devel@vger.kernel.org
References: <20210923140643.3975473-1-john@metanate.com>
Message-ID: <3d74a4da-623e-d22f-58e2-ee6617a8c465@gmail.com>
Date:   Mon, 27 Sep 2021 12:56:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210923140643.3975473-1-john@metanate.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 23.09.21 г. 17:06, John Keeping wrote:
> If sched_wakeup or sched_wakeup_new is avaiable but sched_waking is not,
> then define_wakeup_event() returns true even though waking_event_ptr is
> null.
> 
> Change find_wakeup_event() to avoid overwriting the output parameter on
> error so that the define_wakeup_event() returns true iff
> *waking_event_ptr is non-null.
> 
> Signed-off-by: John Keeping <john@metanate.com>

Thanks a lot for helping us to improve KernelShark!

It seems that you are interested in analyzing wakeup latency and you are keen of digging into code, so I would like to 
point you to something new that may be interesting for you.

We are trying to develop Python bindings for the tracing libraries, including libkshark. Here is one very simple example 
script that plots the distribution of the latency and generates a description of a KernelShark session directly showing 
the largest latency:
https://github.com/vmware/trace-cruncher/blob/master/examples/sched_wakeup.py

Note that this example is supposed to demonstrate the Python APIs, not to do something that is particularly useful on 
its own. But you should be able to easily adapt it to your own needs. The installation of the Python module is very 
simple. See the README here:
https://github.com/vmware/trace-cruncher

Please let me know if this is something interesting for you. I will be vary happy to receive patches from you for this 
project as well. I am pretty sure you will find bugs ;-)

Once again, thanks a lot for the KernelShark patches!
Cheers,
Yordan


> ---
>   src/libkshark-tepdata.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> index 865ca82..9740ed9 100644
> --- a/src/libkshark-tepdata.c
> +++ b/src/libkshark-tepdata.c
> @@ -1868,9 +1868,14 @@ int kshark_tep_find_top_stream(struct kshark_context *kshark_ctx,
>   static bool find_wakeup_event(struct tep_handle *tep, const char *wakeup_name,
>   			      struct tep_event **waking_event_ptr)
>   {
> -	*waking_event_ptr = tep_find_event_by_name(tep, "sched", wakeup_name);
> +	struct tep_event *event;
> +
> +	event = tep_find_event_by_name(tep, "sched", wakeup_name);
> +
> +	if (event)
> +		*waking_event_ptr = event;
>   
> -	return (*waking_event_ptr)? true : false;
> +	return !!event;
>   }
>   
>   /**
> 
