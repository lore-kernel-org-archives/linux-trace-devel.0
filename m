Return-Path: <SRS0=APAm=Q4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698E7C00319
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Feb 2019 08:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3322C20818
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Feb 2019 08:22:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ep08FDiL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbfBUIWO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Feb 2019 03:22:14 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45270 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbfBUIWN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Feb 2019 03:22:13 -0500
Received: by mail-wr1-f65.google.com with SMTP id w17so28845289wrn.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Feb 2019 00:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VDg6SpVVRmUPottIMwcmyBGqWUqaVXvFV5p6q21/y+Y=;
        b=Ep08FDiLkdVYZievzNh3KSVB8awsQcr1xjcBPFK48cO88AX/4L3VXh4CSGYZsSYYsb
         Y546+T2XhjPkMGG7NvLyRrky66poKh+aTVbxWM5aWt3cd2HLt6sL6PPM86eKzWZnyAcW
         CUv1Zla7QjwCGvsSVq51S6nOpn3xDRwnZ7zd3g+VbCvo0rgUUHNbgCv9rNVVV/9xrfbw
         3osHf6gNb0bAbK3mHPYI+hn5Fz6/TsV3a1Mql0CSLig1aGP5TXEjipIputKmNeFtVbkM
         Yw4LUQk2AGPhz/AQn1oT7eUl7xhOZC2DQjOzThOBbeDoEiZiIFVJ5htGuNSjd4ecS48D
         zBwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VDg6SpVVRmUPottIMwcmyBGqWUqaVXvFV5p6q21/y+Y=;
        b=lYWaEfLL76zZxZs2RpP3eEFi+s5jYONUARPPDw4t6jENcFZQxxrZSDceROR87/7o7v
         8uBE2gaau7mBKNDG3p4u7qrsXrjWJ0MDo2Y1CTQMJK5Uea5TaSzeTHCyTuBkzbS1o5pp
         l3vLT5lHFnmeUqr6xL2AQUYGm01ANfD96mFvxa9HGCX13PMSr1bN2Bfu82MlD8xybvgZ
         RQnsV8aYn9E3ebXLuKCnEk8NYDE8m05V3WemW/a5vOc5CuOfbgjWiCF79fHKD3cDlkBD
         vQb9F++vU2IxN2eM2ZkUY2VU8sKWb4JguVk7tpAuScjRlm7n1+4++Ct3+1gE6PfuoiBz
         Nwsg==
X-Gm-Message-State: AHQUAuZx8YQfr7oh8Cci30tsRINxtj9OdKONcyS7I+geSnmWLoRYWOVc
        5FpbyE9lPXl+hVkOC9rr3ZgYug0B
X-Google-Smtp-Source: AHgI3IZWK4oTycI+tmxK/5BiwCsrlFyd68pOqd3ZooPEPWFvDakiOp2OZzBgfbNes+11czm1JYCb7Q==
X-Received: by 2002:adf:fa51:: with SMTP id y17mr28880054wrr.233.1550737331439;
        Thu, 21 Feb 2019 00:22:11 -0800 (PST)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v4sm7922943wmg.1.2019.02.21.00.22.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 00:22:10 -0800 (PST)
Subject: Re: [PATCH] kernel-shark: Fixing the fix of ksmodel_shif_forward
 method()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
References: <20190220091610.10699-1-ykaradzhov@vmware.com>
 <20190220095152.0ec78bda@gandalf.local.home>
 <ee313bc5-5d83-84bd-3578-8a5618fcc48c@gmail.com>
 <20190220113728.09ff2c65@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <1bef656a-3966-0cff-57af-dbb0c186dec0@gmail.com>
Date:   Thu, 21 Feb 2019 10:22:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190220113728.09ff2c65@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 20.02.19 г. 18:37 ч., Steven Rostedt wrote:
> On Wed, 20 Feb 2019 17:29:34 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> On 20.02.19 г. 16:51 ч., Steven Rostedt wrote:
>>> On Wed, 20 Feb 2019 11:16:10 +0200
>>> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>>>    
>>>> As explaned in the change log of
>>>>
>>>> e54616484 ("Do not copy the Upper Overflow bin when shifting forward"),
>>>>
>>>> the lower edge of the Upper Overflow bin is unusual (shift + 1). Because
>>>> of this, the content of the Upper Overflow bin cannot be copied, when
>>>> shifting the visible area forward. It has to be recalculated instead.
>>>> However, this is not enough to fix the bug. The last bin of the old histo
>>>> cannot be copied as well. This is because its upper edge is shifted
>>>> too (+1).
>>>>
>>>> Reported-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
>>>> Fixes: e54616484 ("Do not copy the Upper Overflow bin when shifting forward")
>>>> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
>>>> ---
>>>>    kernel-shark/src/libkshark-model.c | 17 ++++++++++++-----
>>>>    1 file changed, 12 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
>>>> index b71a9b8..b80f71e 100644
>>>> --- a/kernel-shark/src/libkshark-model.c
>>>> +++ b/kernel-shark/src/libkshark-model.c
>>>> @@ -488,23 +488,30 @@ void ksmodel_shift_forward(struct kshark_trace_histo *histo, size_t n)
>>>>    	ksmodel_set_lower_edge(histo);
>>>>    
>>>>    	/*
>>>> -	 * Copy the the mapping indexes of all overlaping bins starting from
>>>> -	 * bin "0" of the new histo. Note that the number of overlaping bins
>>>> -	 * is histo->n_bins - n.
>>>>    	 * We will do a sanity check. ksmodel_set_lower_edge() sets map[0]
>>>>    	 * index of the new histo. This index should then be equal to map[n]
>>>>    	 * index of the old histo.
>>>>    	 */
>>>>    	assert (histo->map[0] == histo->map[n]);
>>>> +
>>>> +	/*
>>>> +	 * Copy the mapping indexes of all overlaping bins starting from
>>>> +	 * bin "0" of the new histo. Note that the number of overlaping bins
>>>> +	 * is histo->n_bins - n. However, the last bin of the models is
>>>> +	 * unusual. Its size has been increased by "1" in order make sure that
>>>> +	 * the last entry of the dataset will fall into it (see the comment in
>>>> +	 * ksmodel_set_next_bin_edge()). Because of this, we do not want to
>>>> +	 * copy the very last bin of the old histo. We are going to recalculate
>>>> +	 * its content instead. */
>>>>    	memmove(&histo->map[0], &histo->map[n],
>>>> -		sizeof(histo->map[0]) * (histo->n_bins - n));
>>>> +		sizeof(histo->map[0]) * (histo->n_bins - n - 1));
>>>>    
>>>>    	/*
>>>>    	 * Calculate only the content of the new (non-overlapping) bins.
>>>>    	 * Start from the last copied bin and set the edge of each consecutive
>>>>    	 * bin.
>>>>    	 */
>>>> -	bin = histo->n_bins - n - 1;
>>>> +	bin = histo->n_bins - n - 2;
>>>
>>> Is it possible that we could have histo->n_bins == n - 1?
> 
> Sorry, I meant n + 1.
> 
> histo->n_bins = 5, n = 4.
> 
> 	bin = (5) - (4) - 2 = -1.
>

Hi Steven,

Sometimes I am just lucky ;)
I am glad that you found this mistake because in fact the whole patch is 
crap.
I misinterpreted the symptoms of the problem, reported by Ceco.
Alternative solution (patches) are coming.

Thanks a lot!
Yordan

> -- Steve
> 
>>
>> This is not possible.
>> Several lines above in the code we have
>>
>>
>> 	if (n >= histo->n_bins) {
>> 		/*
>> 		 * No overlap between the new and the old ranges. Recalculate
>> 		 * all bins from scratch. First calculate the new range.
>> 		 */
>> 		ksmodel_set_bining(histo, histo->n_bins, histo->min,
>> 							 histo->max);
>>
>> 		ksmodel_fill(histo, histo->data, histo->data_size);
>> 		return;
>> 	}
