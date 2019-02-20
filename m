Return-Path: <SRS0=okv7=Q3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BED7C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Feb 2019 15:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0BFC20880
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Feb 2019 15:29:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M7T0WXts"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfBTP3m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Feb 2019 10:29:42 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54690 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbfBTP3m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Feb 2019 10:29:42 -0500
Received: by mail-wm1-f65.google.com with SMTP id a62so7109775wmh.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Feb 2019 07:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YozEGr07hWQvQmF0T7Wjej/I9t/t+lJB814CKawhTl8=;
        b=M7T0WXtsnlwK3hKlC3hUUfkvu+/OREJLQ3bVzE6d4Y4B59y4to/glNC/ADeKMnDTW5
         ZtkBrrFCwXPFdbiHopH6AHG40/nbOHndUXZV8CSCOZVTj9i5xmZ4+wudV+9v/C7RTHpP
         MOJwxsHBTUpsN/eNGF2gaPwHknh95bdfQmhRvciIxfOXghcslUwCjGubb6evz43S12bQ
         KD/MG/6N1KhuhawDbJkiJzKeVLKws8DaepYQY+xUkzK58fQUEXJbw8x5jZdElWb0Z1u3
         TfwwoikuPO9z8h3ExllUlm2t0J14pxz4NxF20g0PXmiazII36uFumJqtxH6ttTBshR2V
         dsZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YozEGr07hWQvQmF0T7Wjej/I9t/t+lJB814CKawhTl8=;
        b=ajPtWHtpTvfYwSeUKR4cS9MJGAEHsQ7IoEEpdiNZgnX5WzkUmM2bNz8jTe8sty1gub
         dykmWXRM4Y/g8wg3u1idwmb3hQPLJeITdQrnEecpXohTp2/Cpq3tK5eGV7MKEv83yhHG
         uZ/tReNxRrbt+ZPqAuSSuQvPcHD0MXCno2Hjmg+DCyDC3iJrfHAcUTNn/T+vcc1xv9Rs
         oyoY1tzTOQQqApWstMqeAWgTOgxU6uKlu6x5UQu4wGG8QvJvICJKtj1Ym8EJ1a/zAVoI
         bXiEXzccxyczXxNy/bv3pAPAyIE/BxmCuowTb40BtUMxsmmysMq0bi6vBhwVlYydWLQW
         4rmA==
X-Gm-Message-State: AHQUAuaVHYPy3hkonOMQijsRV+AnvgwDZp224R5Dx85FuH2S2koUMfA0
        hiO1/NIIbaUlNn3KJNyykddIUqbR
X-Google-Smtp-Source: AHgI3IaC+tYKGPpT31PtV3M6yjvRztp2xQpy3YEOkFVRDBzvUDFROKqGj7S90VMCKVjNkIND8PduUw==
X-Received: by 2002:a7b:c14a:: with SMTP id z10mr6473870wmi.99.1550676579720;
        Wed, 20 Feb 2019 07:29:39 -0800 (PST)
Received: from [192.168.0.106] ([95.87.244.34])
        by smtp.gmail.com with ESMTPSA id o7sm4995125wmc.13.2019.02.20.07.29.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Feb 2019 07:29:39 -0800 (PST)
Subject: Re: [PATCH] kernel-shark: Fixing the fix of ksmodel_shif_forward
 method()
To:     Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20190220091610.10699-1-ykaradzhov@vmware.com>
 <20190220095152.0ec78bda@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <ee313bc5-5d83-84bd-3578-8a5618fcc48c@gmail.com>
Date:   Wed, 20 Feb 2019 17:29:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190220095152.0ec78bda@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 20.02.19 г. 16:51 ч., Steven Rostedt wrote:
> On Wed, 20 Feb 2019 11:16:10 +0200
> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> 
>> As explaned in the change log of
>>
>> e54616484 ("Do not copy the Upper Overflow bin when shifting forward"),
>>
>> the lower edge of the Upper Overflow bin is unusual (shift + 1). Because
>> of this, the content of the Upper Overflow bin cannot be copied, when
>> shifting the visible area forward. It has to be recalculated instead.
>> However, this is not enough to fix the bug. The last bin of the old histo
>> cannot be copied as well. This is because its upper edge is shifted
>> too (+1).
>>
>> Reported-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
>> Fixes: e54616484 ("Do not copy the Upper Overflow bin when shifting forward")
>> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
>> ---
>>   kernel-shark/src/libkshark-model.c | 17 ++++++++++++-----
>>   1 file changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
>> index b71a9b8..b80f71e 100644
>> --- a/kernel-shark/src/libkshark-model.c
>> +++ b/kernel-shark/src/libkshark-model.c
>> @@ -488,23 +488,30 @@ void ksmodel_shift_forward(struct kshark_trace_histo *histo, size_t n)
>>   	ksmodel_set_lower_edge(histo);
>>   
>>   	/*
>> -	 * Copy the the mapping indexes of all overlaping bins starting from
>> -	 * bin "0" of the new histo. Note that the number of overlaping bins
>> -	 * is histo->n_bins - n.
>>   	 * We will do a sanity check. ksmodel_set_lower_edge() sets map[0]
>>   	 * index of the new histo. This index should then be equal to map[n]
>>   	 * index of the old histo.
>>   	 */
>>   	assert (histo->map[0] == histo->map[n]);
>> +
>> +	/*
>> +	 * Copy the mapping indexes of all overlaping bins starting from
>> +	 * bin "0" of the new histo. Note that the number of overlaping bins
>> +	 * is histo->n_bins - n. However, the last bin of the models is
>> +	 * unusual. Its size has been increased by "1" in order make sure that
>> +	 * the last entry of the dataset will fall into it (see the comment in
>> +	 * ksmodel_set_next_bin_edge()). Because of this, we do not want to
>> +	 * copy the very last bin of the old histo. We are going to recalculate
>> +	 * its content instead. */
>>   	memmove(&histo->map[0], &histo->map[n],
>> -		sizeof(histo->map[0]) * (histo->n_bins - n));
>> +		sizeof(histo->map[0]) * (histo->n_bins - n - 1));
>>   
>>   	/*
>>   	 * Calculate only the content of the new (non-overlapping) bins.
>>   	 * Start from the last copied bin and set the edge of each consecutive
>>   	 * bin.
>>   	 */
>> -	bin = histo->n_bins - n - 1;
>> +	bin = histo->n_bins - n - 2;
> 
> Is it possible that we could have histo->n_bins == n - 1?

This is not possible.
Several lines above in the code we have


	if (n >= histo->n_bins) {
		/*
		 * No overlap between the new and the old ranges. Recalculate
		 * all bins from scratch. First calculate the new range.
		 */
		ksmodel_set_bining(histo, histo->n_bins, histo->min,
							 histo->max);

		ksmodel_fill(histo, histo->data, histo->data_size);
		return;
	}

Thanks!
Yordan

> 
> -- Steve
> 
>>   	for (; bin < histo->n_bins; ++bin) {
>>   		ksmodel_set_next_bin_edge(histo, bin, last_row);
>>   		if (histo->map[bin + 1] > 0)
> 
