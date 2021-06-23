Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D874C49EA5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Jun 2021 13:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 483B8610C7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Jun 2021 13:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhFWNZz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Jun 2021 09:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbhFWNZy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Jun 2021 09:25:54 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82223C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Jun 2021 06:23:36 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id a11so2613851wrt.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Jun 2021 06:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sNX6Wi8hSgRFKLIAh02c8NwwoBZ3NAGZQ7660txFc/I=;
        b=TqcmpFKnPGs34Vdtnxuiv2Maa/jIgcf88wP0bxAtazaTZ63xDBOjZCf9TCMcU9VtpN
         nfkM4zk7FDFcj7nzm5IsA+/vAIzwvZ5jnUD3QLycPeHtw+qU6Z0lNQNz8TrLLpbBR46r
         X+aMkiZjEpejqUuPBmuJObrT+WCiBoDhoDcB9ier8PiEIKEaQRe4iJbYcbnm3fF74jjL
         YfAhqSGNmw8FV3xBetLYq0QRwsLA4TGLRuCYYkK5Ybf6+YROwMIPStABgEoJnojGmmVj
         N5M0DuL/toCSE3AXwK24BMRJQv4nXeMSI1XFn6QgbRL4h0bUpRGbM5uO+ViW/RHpVod0
         MzWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sNX6Wi8hSgRFKLIAh02c8NwwoBZ3NAGZQ7660txFc/I=;
        b=pKvLw4XqrdoCm6jCUirRMiZKb7M62RWHPcMS/EjWzQEmj9lZq2GJmbsTvehnsaGT7X
         rMg7xPYAhL36/ZOHk/RHQcbrGiNMJgrxcGK7rV7JzKREe44aYt8FPq6hyZTVnBkr0L39
         d8mO56F8GqstlWHG2UNdCmtvTyOu8jXXbld0uetPJDsOuGFwu6DITBHHqiFetIAKmqyW
         h0DvOadZAg2XEqKXcyIEGiesHeNR7StQaV5aSyN9Zgjfkv0qKhddPb/AoeUUhwnqP5k/
         y353hrzYB5wiU16LOIwGoPJc384/j07/1tjctWZFuRq3olCuo1OkB/QkSh52aGpvVutE
         3Z4A==
X-Gm-Message-State: AOAM533OxjK9FSPYjIy6Pjxx2AOtbC55ydX0u3DTijoFRM43D8bTbQ/j
        Bp7QAyoG38NHzaa8owRP4eHEDquGd9U=
X-Google-Smtp-Source: ABdhPJzztmvcJka0+mKrgbhMqr9NnmZDyGLgCJSMRBwoRoU2PODp4dKVjzAAHi8wi2cJmmzYj+I+sg==
X-Received: by 2002:a5d:4b92:: with SMTP id b18mr4584wrt.124.1624454614971;
        Wed, 23 Jun 2021 06:23:34 -0700 (PDT)
Received: from [10.93.98.252] ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id i3sm5884467wmb.15.2021.06.23.06.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 06:23:34 -0700 (PDT)
Subject: Re: [PATCH v2] libtracefs: Add APIs for data streaming
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210623120526.36623-1-y.karadz@gmail.com>
 <20210623084535.7a199813@gandalf.local.home>
 <481ebd67-050b-06bf-bcce-ae0febd79ab5@gmail.com>
 <20210623091951.7eed6b50@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <1c038eff-954a-ac8f-8f1b-bcff439f2d41@gmail.com>
Date:   Wed, 23 Jun 2021 16:23:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210623091951.7eed6b50@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 23.06.21 г. 16:19, Steven Rostedt wrote:
> On Wed, 23 Jun 2021 16:02:00 +0300
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
>>> I'm thinking we should invert the above. That is, have a stop instead of
>>> "keep_going", where it is false by default (when the instance is created).
>>>
>>> That's because, if we start here, and the SIGINT comes in before we get
>>> here, it keep_going might get set to false, and missed.
>>
>> I intentionally tried to avoid having any dependency of the initialization value of the "keep_going" flag. We have to
>> consider the case when the user creates one instance and then calls this function multiple times in a row.
> 
> If anything then, make it the first thing that gets done, and not just
> before the loop.
> 
> That is:
> 
> 
> +int tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance,
> +			      int flags)
> +{
> +	int *keep_going = instance ? &instance->pipe_keep_going :
> +				     &top_pipe_keep_going;
> +	const char *file = "trace_pipe";
> +	int brass[2], in_fd, ret = -1;
> +	off_t data_size;
> 
> 	*keep_going = true;
> 
> +
> +	in_fd = tracefs_instance_file_open(instance, file, O_RDONLY);
> +	if (in_fd < 0) {
> +		tracefs_warning("Failed to open 'trace_pipe'.");
> +		return ret;
> +	}
> +
> +	if(pipe(brass) < 0) {
> +		tracefs_warning("Failed to open pipe.");
> +		goto close_file;
> +	}
> +
> +	data_size = fcntl(brass[0], F_GETPIPE_SZ);
> +	if (data_size <= 0) {
> +		tracefs_warning("Failed to open pipe (size=0).");
> +		goto close_all;
> +	}
> +
> +	*keep_going = true;
> 
> And not here.
> 
> +	while (*keep_going) {
> +		ret = splice(in_fd, NULL,
> +			     brass[1], NULL,
> +			     data_size, flags);
> +		if (ret < 0)
> +			break;
> +
> +		ret = splice(brass[0], NULL,
> +			     fd, NULL,
> +			     data_size, flags);
> +		if (ret < 0)
> +			break;
> +	}
> 
> 
> And I think we need to make it volatile, otherwise the compiler is free to
> ignore it. Because the compiler does not need to know about threads.
> 
> 	*keep_going = true;
> 	while (*keep_going) {
> 		[ do something ]
> 	}
> 
> To the compiler that is the same as:
> 
> 	while (1) {
> 		[ do something ]
> 	}
> 
> And is free to make that change when optimizing.
> 
> What needs to be done is:
> 
> 	(*(volatile bool *)keep_going) = true;
> 
> and
> 
> 	while (*(volatile bool *)keep_going) {
> 
> That way the compiler knows that the value can change from outside its
> knowledge.
> 

OK, I will make the changes and will send v3.

Thanks a lot!
Yordan

> -- Steve
> 
