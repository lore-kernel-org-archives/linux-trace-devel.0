Return-Path: <SRS0=FNt8=EM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE81C5517A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Nov 2020 14:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 956922100A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Nov 2020 14:32:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LqO2TXk2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgKFOcD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Nov 2020 09:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbgKFOcD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Nov 2020 09:32:03 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA886C0613CF
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 Nov 2020 06:32:02 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id h2so1627500wmm.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 06 Nov 2020 06:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hDyiZqQ+UKwbktaXuQ/uHSTLeeMPTQQuvSBpVMygJ3c=;
        b=LqO2TXk2HT19NtZnWOXyPH/zb4QwIy0CmbitxRr8i3a4QXpBrOw7iQqhQukWgcFHDC
         IP9a+uEZN0sIPwRqiLHLqh4GNKTU6WO49x1eYyRBJ78eHLtBNcB9jzfDD3FSTi4iYsOZ
         EfSPibY3Z/mqpZeQUPtzHw/U+3v7qoTLr1r+8BkC36cFZI+hfi140iqPBDPBbnqYNHEA
         wnvhMrW0L9KpXstUCcUZDQE+r9opmpIv0sBkYE8XCfhc+46+mIWgKF8vUZyyEsLuTf0V
         JvDJRRpLq0Qst+cPde4DaxZ9GLYxhdAXPuGpQGJy+dv0wk3Jlo+f1iVr1aOUk5h3yEbO
         cKGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hDyiZqQ+UKwbktaXuQ/uHSTLeeMPTQQuvSBpVMygJ3c=;
        b=mfCVitbcF+kN1An4VTnELvFQhCo3DUqXfYTHIFmrfuCAcuMS61yCqm6KEeSPGCKeu3
         TBlJIy6lYUl0fp5rWpglgpEbfP7AeMBX/9HAK1km/GkoaMc5MRYiqqEQSM/sBv7/QJE8
         CqC4R6Z/hpC/QCyuMQ6CguNwSjDkXA2RJybUnqG++VtgLbaVtBF4g8nJbR4WaqERezXY
         9ZVUhNCYBzFTlCMoYKYXHTGawH9BRa9g7LEl8MZVjgdESaonLDETiSeTDXRU7mLraNfd
         Wh/AnbnYOv0lHyuguucKe6rjZh1TbjXLg8I53oiDHYLe1nW8eXrLlBPXj4hUCBspnKEO
         6Eyw==
X-Gm-Message-State: AOAM531SEJm+GrNnvzj9IX2V5/0tzjsIMrSdbjtgw0o5oWEdJCYCqZNv
        xYxlp4rps2jhimjYBhFoBtcJUuc+B0g=
X-Google-Smtp-Source: ABdhPJx+sZgZrd/NRR6TnVOKCzkvy0sAllTx90o2Uz/oaO6LqLbetpc0a1Jpi4Z2/Chn3ioLcuRU3Q==
X-Received: by 2002:a1c:205:: with SMTP id 5mr2730374wmc.7.1604673120885;
        Fri, 06 Nov 2020 06:32:00 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id b8sm2482130wmj.9.2020.11.06.06.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 06:32:00 -0800 (PST)
Subject: Re: [PATCH v2 10/20] kernel-shark: Start using data streams
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201012133523.469040-1-y.karadz@gmail.com>
 <20201012133523.469040-11-y.karadz@gmail.com>
 <20201014145627.675e3c70@gandalf.local.home>
 <b5569725-239f-3e5b-dfa0-97f7d51b5d01@gmail.com>
 <20201105131735.3d559bce@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <d88af9bb-1f15-04cf-230c-ea59b3239931@gmail.com>
Date:   Fri, 6 Nov 2020 16:31:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201105131735.3d559bce@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 5.11.20 г. 20:17 ч., Steven Rostedt wrote:
> On Thu, 5 Nov 2020 16:58:51 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> I see the problem. This is definitely wrong.
>>
>> What if in addition to "n_streams" I add another counter called
>> "last_stream_added" and initialize this counter to -1?
>>
>> Then I can add streams like this:
>>
>> 	kshark_ctx->stream[++kshark_ctx->last_stream_added] = stream;
>> 	++kshark_ctx->n_streams;
>>
>>> You may want to do instead:
> 
> I'm thinking of doing something like this:
> 
> struct kshark_ctx {
> 	[..]
> 	unsigned int free_stream;
> 	[..]
> };
> 
> 
> 	if (kshark_ctx->free_stream >= kshark_ctx->n_streams) {
> 		kshark_ctx->stream[++kshark_ctx->n_streams] = stream;
> 		kshark_ctx->free_stream = kshark_ctx->n_streams;
> 
> /* BTW, the stream array should be allocated to the n_streams, and
>     reallocated when it grows.  I don't think we want a huge stream array to
>     handle all the bits when not used. */
> 
> 	} else {
> 		int new_stream = kshark_ctx->free_stream;
> 
> 		kshark_ctx->free_stream = kshark_index(kshark_ctx->stream[new_stream]);
> 		kshark_ctx->stream[new_stream] = stream;
> 	}
> 
> 
> For freeing (index i):
> 
> 	kshark_ctx->stream[i] = kshark_ptr(kshark_ctx->free_stream);
> 	kshark_ctx->free_stream = i;
> 
> 
> We could define the following (note, I just used these names for the
> functions, they could be named something else):
> 
> 
> #define KSHARK_INDEX_MASK ((1 << NR_OF_BITS_FOR_STREAM) - 1)
> 
> #define KSHARK_INVALID_STREAM (~((1UL << NR_OF_BITS_FOR_STREAM) - 1))
> 
> static inline int kshark_index(void *ptr)
> {
> 	unsigned long index = (unsigned long)ptr;
> 
> 	return (int)(index & KSHARK_INDEX_MASK);
> }
> 
> static inline void *kshark_ptr(unsigned int index)
> {
> 	unsigned long p;
> 
> 	p = KSHARK_INVALID_STREAM | index;
> 
> 	return (void *)p;
> }
> 
> The KSHARK_INVALID_STREAM and KSHARK_INDEX_MASK, would allow us to do
> something like this if we wanted to loop through all streams:
> 
> static inline bool kshark_is_valid_stream(void *ptr)
> {
> 	unsigned long p = (unsigned long)ptr;
> 
> 	return (p & KSHARK_INVALID_STREAM) == KSHARK_INVALID_STREAM;
> }
> 
> The above works because the address of setting all those bits, would put
> the address into the kernel space (illegal user space address).
> 
> 
> 	for (i = 0; i < kshark_ctx->n_streams; i++) {
> 		if (!kshark_is_valid_stream(kshark_ctx->stream[i]))
> 			continue;
> 		/* process valid stream */
> 	}
>

Hi Steven,

I am not sure I understand correctly your pseudo-code, so please correct 
me if my interpretation is wrong.

In the normal case when a new stream is added the corresponding object 
will be allocated and added to the array of pointers. Later if a stream 
is removed, instead of freeing the memory we will just manipulate it 
pointer so that it point to nowhere and this manipulation can be 
detected by the kshark_is_valid_stream(). Now if we want to add stream 
again, we will take the broken pointer, will restore its original value 
and will reuse the object without a new allocations.

And at the very end we will have to free all pointers (original or 
manipulated).

Is this what you are suggesting?

Thanks!
Y.


> -- Steve
> 
