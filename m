Return-Path: <SRS0=Uv3S=T6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E04AC28CC0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 May 2019 14:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAAE125ADB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 May 2019 14:25:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="itDrZQhu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbfE3OZ4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 May 2019 10:25:56 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:32818 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfE3OZ4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 May 2019 10:25:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so6090883wmh.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 May 2019 07:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pG6BNuFV4ElxvAgYqBt9GhpgVABbR0cI5zylCcXIuTM=;
        b=itDrZQhuwaI9ZqsjS331o0MfOr8EQimoQlrDfzJOHoMpDrxS4Dhz/wpDvMRQ2UOpx1
         FY+t7s2Gwchcsxk23lquP9GN43HjMBVuPaqFdmELHga0ZjbUTaPxbdxspT55nNGi0htW
         an9TKEWlqW0+OXdwFPW1pTBe48Q5zcaZ2x7XeedCNFUbqOjmGzQgLoGdxMWYf33h8fqO
         PtP+Ecfyhq74PBFzv3MNXUieT95GhRXg8FEs7swIHVQ9vkznLaBjAq7uTYiOI40YFUO3
         0F1hGWLbIyGRcPpUtctcn4mKp62TO0hDFpj9eYQoDFhcrRaDbAGxpB8ZsobIAy74I1fs
         kQzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pG6BNuFV4ElxvAgYqBt9GhpgVABbR0cI5zylCcXIuTM=;
        b=Zj4Px5Kb+64DFv71i+0B4o1iy2j9AjyNujb81Gy/zykGOnYRAJz0ujkEGQXsBK1pp9
         aECHGHkAedy2ZncjuGoEIrsoofZF861K14fiMm+0MJB9NCWRkaMBDHWf6ezdjLQ+iNM6
         FVEniB8Pa5m2Yop3PxLCBcbNA0YWNEqLdEvMeRxUUUvTbJB+aZIpo9jV0sH00MXi2/1W
         TN8PlLqjvC2wt6fby4uUeTZyPAoU2yqLvMEOl6zecrVbT95K0qVtYgzhLdo7qwK/D3SM
         161/GFvVu4h6azLCZKpYTsOwQr0QzK04vGNL6cz8yUDe/GT6rDrMXxPJ4LGZ0PgfINAi
         5qNA==
X-Gm-Message-State: APjAAAVmsDKVOONY2IolrLzh4p9mHH3AJqzqh/1VPcd2OPxGeVkKbsuA
        rRlZebz6Gmm/nrr46QCvbd6kVfh+
X-Google-Smtp-Source: APXvYqwfXmnaKxvcKA2gLZrgfV7HRFQg8kFQ4MdD+UHDDmQ0aJzy4gfSLNTmDYtKgFREn5cPplpUVg==
X-Received: by 2002:a1c:48c5:: with SMTP id v188mr2383632wma.175.1559226353168;
        Thu, 30 May 2019 07:25:53 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 197sm3074286wma.36.2019.05.30.07.25.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 07:25:52 -0700 (PDT)
Subject: Re: [PATCH 1/5] kernel-shark: Add new dataloading method to be used
 by the NumPu interface
To:     Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20190523151812.31391-1-ykaradzhov@vmware.com>
 <20190523151812.31391-2-ykaradzhov@vmware.com>
 <20190529133605.214b766f@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <c25067b7-2eac-863a-406d-9e3ede76cfb0@gmail.com>
Date:   Thu, 30 May 2019 17:25:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190529133605.214b766f@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 29.05.19 г. 20:36 ч., Steven Rostedt wrote:
> On Thu, 23 May 2019 18:18:08 +0300
> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> 
>> The new function loads the content of the trace data file into a
>> table / matrix, made of columns / arrays of data having various integer
>> types. Later those arrays will be wrapped as NumPy arrays.
>>
>> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
>> ---
>>   kernel-shark/src/libkshark.c | 155 +++++++++++++++++++++++++++++++++++
>>   kernel-shark/src/libkshark.h |   7 ++
>>   2 files changed, 162 insertions(+)
>>
>> diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
>> index 175279c..ac634fd 100644
>> --- a/kernel-shark/src/libkshark.c
>> +++ b/kernel-shark/src/libkshark.c
>> @@ -957,6 +957,161 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
>>   	return -ENOMEM;
>>   }
>>   
>> +static bool data_matrix_alloc(size_t n_rows, uint64_t **offset_array,
>> +					     uint8_t **cpu_array,
>> +					     uint64_t **ts_array,
>> +					     uint16_t **pid_array,
>> +					     int **event_array)
>> +{
>> +	if (offset_array)
>> +		*offset_array = NULL;
>> +
>> +	if (cpu_array)
>> +		*cpu_array = NULL;
>> +
>> +	if (ts_array)
>> +		*ts_array = NULL;
>> +
>> +	if (pid_array)
>> +		*pid_array = NULL;
>> +
>> +	if (event_array)
>> +		*event_array = NULL;
>> +
>> +	if (offset_array) {
> 
> The way you can do this, is remove the above and have:
> 
>> +		*offset_array = calloc(n_rows, sizeof(**offset_array));
>> +		if (!*offset_array)
> 
> 			return false;
> 
>> +			goto free_all;
>> +	}
>> +
>> +	if (cpu_array) {
>> +		*cpu_array = calloc(n_rows, sizeof(**cpu_array));
>> +		if (!*cpu_array)
> 
> 			goto free_offset;
> 
>> +			goto free_all;
>> +	}
>> +
>> +	if (ts_array) {
>> +		*ts_array = calloc(n_rows, sizeof(**ts_array));
>> +		if (!*ts_array)
> 
> 			goto free_cpu;
> 
>> +			goto free_all;
>> +	}
>> +
>> +	if (pid_array) {
>> +		*pid_array = calloc(n_rows, sizeof(**pid_array));
>> +		if (!*pid_array)
> 
> 			goto free_ts;
> 
>> +			goto free_all;
>> +	}
>> +
>> +	if (event_array) {
>> +		*event_array = calloc(n_rows, sizeof(**event_array));
>> +		if (!*event_array)
> 
> 			goto free_pid;
> 
>> +			goto free_all;
>> +	}
>> +
>> +	return true;
>> +
> 
> We can have a helper function:
> 
> static inline void free_ptr(void *ptr)
> {
> 	if (ptr)
> 		free(*(void **)ptr);
> }
> 
> free_pid:
> 	free_ptr(pid_array);
> free_ts:
> 	free_ptr(ts_array);
> free_cpu:
> 	free_ptr(cpu_array);
> free_offset:
> 	free_ptr(offset_array);
> 
> Then have the print here.
> 
>> + free_all:
>> +	fprintf(stderr, "Failed to allocate memory during data loading.\n");
> 
> 	return false;
> 
> This is the way it's usually done in the Linux kernel.
> 

Great! Really elegant solution.


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
>> +	n_cpus = tracecmd_cpus(kshark_ctx->handle);
>> +
>> +	status = data_matrix_alloc(total, offset_array,
>> +					  cpu_array,
>> +					  ts_array,
>> +					  pid_array,
>> +					  event_array);
> 
> BTW, have you looked into how much memory this takes up in a large
> trace?

One record takes 24 bytes. So it will allocate total*24 bytes (or less 
if some of the input arguments is NULL).


> 
>> +	if (!status)
>> +		goto fail_free;
>> +
>> +	for (count = 0; count < total; count++) {
>> +		int next_cpu;
>> +
>> +		next_cpu = pick_next_cpu(rec_list, n_cpus, type);
>> +		if (next_cpu >= 0) {
>> +			struct kshark_entry *e = &rec_list[next_cpu]->entry;
> 
> Hmm, this looks like we are taking an address of a field and then
> freeing it down below. Looking at the definition of rec_list, this is
> currently OK. But this coding style is not robust because of the tight
> dependency to how rec_list is defined. If that ever changes it will be
> hard to find code like this to update it.
> 
> A more robust way to do this is:
> 
> 			struct rec_list *rec = rec_list[next_cpu];
> 			struct kshark_entry *e = &rec->entry;
> 
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
> 
> Then here:
> 
> 			free(rec);
> 
> That way there's not a dependency here with the data structure layout
> of rec_list and the freeing of the entry.
> 
> -- Steve
> 

Thanks a lot! Sending updated version.
Y.

> 
>> +			free(e);
>> +		}
>> +	}
>> +
>> +	/* There should be no entries left in rec_list. */
>> +	free_rec_list(rec_list, n_cpus, type);
>> +	return total;
>> +
>> + fail_free:
>> +	free_rec_list(rec_list, n_cpus, type);
>> +
>> + fail:
>> +	fprintf(stderr, "Failed to allocate memory during data
>> loading.\n");
>> +	return -ENOMEM;
>> +}
>> +
>>   static const char *kshark_get_latency(struct tep_handle *pe,
>>   				      struct tep_record *record)
>>   {
>> diff --git a/kernel-shark/src/libkshark.h
>> b/kernel-shark/src/libkshark.h index c218b61..92ade41 100644
>> --- a/kernel-shark/src/libkshark.h
>> +++ b/kernel-shark/src/libkshark.h
>> @@ -149,6 +149,13 @@ ssize_t kshark_load_data_entries(struct
>> kshark_context *kshark_ctx, ssize_t kshark_load_data_records(struct
>> kshark_context *kshark_ctx, struct tep_record ***data_rows);
>>   
>> +size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
>> +			       uint64_t **offset_array,
>> +			       uint8_t **cpu_array,
>> +			       uint64_t **ts_array,
>> +			       uint16_t **pid_array,
>> +			       int **event_array);
>> +
>>   ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int
>> **pids);
>>   void kshark_close(struct kshark_context *kshark_ctx);
> 
