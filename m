Return-Path: <SRS0=eAkL=SL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99597C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 12:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A83F20833
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 12:02:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YqtZyzlQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbfDIMCB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 08:02:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33523 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfDIMCA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 08:02:00 -0400
Received: by mail-wr1-f65.google.com with SMTP id q1so20574467wrp.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Apr 2019 05:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RZkoGlVaJ3hrcc/ev4X90RJDTigNrk9sCyeHexw7rks=;
        b=YqtZyzlQQrHOfHMNhOTSgQTRveqppW0/oZa7bZeH0ZjeBrjzc1b2vNgrggWwsdx1le
         DyFk8GMrSNGVun6rDXE7eS2+Vy+3z48f1nVlQoHMTZRx/YMiZHaD5oPIl1ehzFT/5nwY
         l1BRO1WDK+CMHbudlJAyBMobLtM+KFkTPM2qa7ksGRsWg65dTC7IN4Kyc18iM9xPCw/e
         KkkkghtLkKNtHJ/jk4XoZEoww2h5lzQKU+/Q2KmmkjD+174LxtTi4Bh3/G3CmwoSFADj
         ouYyknKh5QvdC/I31BlL3Tb7a2t4sTwjxDzTrdA/iEAtIwzaM99oXXRr1BdW81HhzFeG
         T1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RZkoGlVaJ3hrcc/ev4X90RJDTigNrk9sCyeHexw7rks=;
        b=nIO2PHEeZfSr5Gs8snUYK2+wep5PH5gHlMzw6nA9/51Mi8dH7TgDlaOAog/PHAmUad
         tip9cHI0sYzVJ1i9xRIzs/Oi1F0JqbaTA9ARB3NoLrQiIh7tJP6sEElLXfLyPbOtQhwx
         HsT8/zyykHl1qUtLSw03bJA0MDoV9p7e1q/PzDv0EbYYl51jJioST6X744+jJ8rUxyaj
         Pb+OJ5MTaQNMEwq8mVIs/MRupEIa57H1Vo7HjXEvW4FpHtlPKKuSkr6GRrs/inM/hvPT
         0uXO+V/coeIFY8mYVz83tZh0ci9qm72iRbXNgb5FH1KoPcJfx+EcjhMTDC2FWMNarfJG
         QrEg==
X-Gm-Message-State: APjAAAWeECX/qSGsAus/WYAGzZ3Vjgna6fK93bMsbK45UI+d4fEozjCD
        3gbHFQNmyEkO6M0l43TEbQkaPMWk3AU=
X-Google-Smtp-Source: APXvYqz7att1U0OXRxbVkAguRP8DRKGn1T03VxqoEukAid8k/fKmVWeLNkf68f5eM0VooDFZNnv5qA==
X-Received: by 2002:adf:afee:: with SMTP id y46mr22245553wrd.217.1554811318556;
        Tue, 09 Apr 2019 05:01:58 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a126sm13483623wmh.4.2019.04.09.05.01.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2019 05:01:58 -0700 (PDT)
Subject: Re: [RFC v2 1/6] kernel-shark: Add new dataloading method to be used
 by the NumPu interface
To:     Slavomir Kaslev <kaslevs@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
References: <20190405101411.25466-1-ykaradzhov@vmware.com>
 <20190405101411.25466-2-ykaradzhov@vmware.com> <20190408150737.GC6430@box>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <1d220a7b-12da-9771-ba26-b81c8ef04a79@gmail.com>
Date:   Tue, 9 Apr 2019 15:01:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190408150737.GC6430@box>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 8.04.19 г. 18:07 ч., Slavomir Kaslev wrote:
> On Fri, Apr 05, 2019 at 01:14:06PM +0300, Yordan Karadzhov wrote:
>> The new function loads the content of the trace data file into a
>> table / matrix, made of columns / arrays of data having various integer
>> types. Later those arrays will be wrapped as NumPy arrays.
>>
>> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
>> ---
>>   kernel-shark/src/libkshark.c | 136 +++++++++++++++++++++++++++++++++++
>>   kernel-shark/src/libkshark.h |   7 ++
>>   2 files changed, 143 insertions(+)
>>
>> diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
>> index a886f80..98086a9 100644
>> --- a/kernel-shark/src/libkshark.c
>> +++ b/kernel-shark/src/libkshark.c
>> @@ -959,6 +959,142 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
>>   	return -ENOMEM;
>>   }
>>   
>> +static bool data_matrix_alloc(size_t n_rows, uint64_t **offset_array,
>> +					     uint8_t **cpu_array,
>> +					     uint64_t **ts_array,
>> +					     uint16_t **pid_array,
>> +					     int **event_array)
>> +{
>> +	if (offset_array) {
>> +		*offset_array = calloc(n_rows, sizeof(**offset_array));
>> +		if (!offset_array)
> 
> This should be
> 
> 		if (!*offset_array)
> 
> and ditto for the rest.
> 

You are right. The whole function is a mess. I will try to fix it in the 
flowing version.

Thanks!
Yordan



> -- Slavi
> 
>> +			goto free_all;
>> +	}
>> +
>> +	if (cpu_array) {
>> +		*cpu_array = calloc(n_rows, sizeof(**cpu_array));
>> +		if (!cpu_array)
>> +			goto free_all;
>> +	}
>> +
>> +	if (ts_array) {
>> +		*ts_array = calloc(n_rows, sizeof(**ts_array));
>> +		if (!ts_array)
>> +			goto free_all;
>> +	}
>> +
>> +	if (pid_array) {
>> +		*pid_array = calloc(n_rows, sizeof(**pid_array));
>> +		if (!pid_array)
>> +			goto free_all;
>> +	}
>> +
>> +	if (event_array) {
>> +		*event_array = calloc(n_rows, sizeof(**event_array));
>> +		if (!event_array)
>> +			goto free_all;
>> +	}
>> +
>> +	return true;
>> +
>> + free_all:
>> +	fprintf(stderr, "Failed to allocate memory during data loading.\n");
>> +
>> +	if (offset_array)
>> +		free(*offset_array);
>> +
>> +	if (cpu_array)
>> +		free(*cpu_array);
>> +
>> +	if (ts_array)
>> +		free(*ts_array);
>> +
>> +	if (pid_array)
>> +		free(*pid_array);
>> +
>> +	if (event_array)
>> +		free(*event_array);
>> +
>> +	return false;
>> +}
>> +
>> +/**
>> + * @brief Load the content of the trace data file into a table / matrix made
>> + *	  of columns / arrays of data. The user is responsible for freeing the
>> + *	  elements of the outputted array
>> + *
>> + * @param kshark_ctx: Input location for the session context pointer.
>> + * @param offset_array: Output location for the array of record offsets.
>> + * @param cpu_array: Output location for the array of CPU Ids.
>> + * @param ts_array: Output location for the array of timestamps.
>> + * @param pid_array: Output location for the array of Process Ids.
>> + * @param event_array: Output location for the array of Event Ids.
>> + *
>> + * @returns The size of the outputted arrays in the case of success, or a
>> + *	    negative error code on failure.
>> + */
>> +size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
>> +			       uint64_t **offset_array,
>> +			       uint8_t **cpu_array,
>> +			       uint64_t **ts_array,
>> +			       uint16_t **pid_array,
>> +			       int **event_array)
>> +{
>> +	enum rec_type type = REC_ENTRY;
>> +	struct rec_list **rec_list;
>> +	size_t count, total = 0;
>> +	bool status;
>> +	int n_cpus;
>> +
>> +	total = get_records(kshark_ctx, &rec_list, type);
>> +	if (total < 0)
>> +		goto fail;
>> +
>> +	status = data_matrix_alloc(total, offset_array,
>> +					  cpu_array,
>> +					  ts_array,
>> +					  pid_array,
>> +					  event_array);
>> +	if (!status)
>> +		goto fail;
>> +
>> +	n_cpus = tracecmd_cpus(kshark_ctx->handle);
>> +
>> +	for (count = 0; count < total; count++) {
>> +		int next_cpu;
>> +
>> +		next_cpu = pick_next_cpu(rec_list, n_cpus, type);
>> +		if (next_cpu >= 0) {
>> +			struct kshark_entry *e = &rec_list[next_cpu]->entry;
>> +
>> +			if (offset_array)
>> +				(*offset_array)[count] = e->offset;
>> +
>> +			if (cpu_array)
>> +				(*cpu_array)[count] = e->cpu;
>> +
>> +			if (ts_array)
>> +				(*ts_array)[count] = e->ts;
>> +
>> +			if (pid_array)
>> +				(*pid_array)[count] = e->pid;
>> +
>> +			if (event_array)
>> +				(*event_array)[count] = e->event_id;
>> +
>> +			rec_list[next_cpu] = rec_list[next_cpu]->next;
>> +			free(e);
>> +		}
>> +	}
>> +
>> +	free_rec_list(rec_list, n_cpus, type);
>> +	return total;
>> +
>> + fail:
>> +	fprintf(stderr, "Failed to allocate memory during data loading.\n");
>> +	return -ENOMEM;
>> +}
>> +
>>   static const char *kshark_get_latency(struct tep_handle *pe,
>>   				      struct tep_record *record)
>>   {
>> diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
>> index c218b61..92ade41 100644
>> --- a/kernel-shark/src/libkshark.h
>> +++ b/kernel-shark/src/libkshark.h
>> @@ -149,6 +149,13 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
>>   ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
>>   				 struct tep_record ***data_rows);
>>   
>> +size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
>> +			       uint64_t **offset_array,
>> +			       uint8_t **cpu_array,
>> +			       uint64_t **ts_array,
>> +			       uint16_t **pid_array,
>> +			       int **event_array);
>> +
>>   ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids);
>>   
>>   void kshark_close(struct kshark_context *kshark_ctx);
>> -- 
>> 2.19.1
>>
