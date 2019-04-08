Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEFAC10F13
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA1BD21473
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfDHPHn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:07:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39409 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbfDHPHn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 11:07:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id n25so15114398wmk.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 08:07:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pmltDgJU1ynSIbBKQ38X5XQJR9Ytqn9JXdPFgJEvO8s=;
        b=TYvGerUqb4rD2KSzwYd+dwCel/WB95ceWATAgRre0vrIbJ0HakEv2D3REmehNVAGqp
         09V8bnoggm02XRSBWnYvISMQnWZ6XE+witIuzT+yiIjxom9PaAS0GaFMdbTlmU9vXnzm
         MlMgQ7wh0Vvqq8v1HCl5xAL10WSJIorUkNqG0Wg/5a1WUDx93g9tFaVJs/LQYBhVrFcn
         bcI5Nh8MFar7n9P8Lif4EI93r4Q4LOgs0jI+IinlRbkOP4LnRRMjtIAh0eQY06XsmFsU
         zj0B6AsNf/W1qBga94smRh4QkHeocxl/KjaKZ9jS836PA1HuU8gLzWEGEhZRHYtJTyes
         hxtQ==
X-Gm-Message-State: APjAAAVoRw62Sau4hICAHj2keSBWtfYO7w1kEuInbwlj2s8JoiomVj4N
        gIrTk0kWm98FGVsTFU9u6+pYcUx+ew==
X-Google-Smtp-Source: APXvYqxZhN9JjJhOKrQHVnoB6NmNA/VvQNGATSorYdc5lYcZdlfgNKer711lSHOVBkH6chvN19N2Cw==
X-Received: by 2002:a05:600c:c4:: with SMTP id u4mr18592310wmm.80.1554736061536;
        Mon, 08 Apr 2019 08:07:41 -0700 (PDT)
Received: from box ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id j7sm42708705wrt.96.2019.04.08.08.07.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Apr 2019 08:07:40 -0700 (PDT)
Date:   Mon, 8 Apr 2019 18:07:38 +0300
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [RFC v2 1/6] kernel-shark: Add new dataloading method to be used
 by the NumPu interface
Message-ID: <20190408150737.GC6430@box>
References: <20190405101411.25466-1-ykaradzhov@vmware.com>
 <20190405101411.25466-2-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190405101411.25466-2-ykaradzhov@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 05, 2019 at 01:14:06PM +0300, Yordan Karadzhov wrote:
> The new function loads the content of the trace data file into a
> table / matrix, made of columns / arrays of data having various integer
> types. Later those arrays will be wrapped as NumPy arrays.
> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/libkshark.c | 136 +++++++++++++++++++++++++++++++++++
>  kernel-shark/src/libkshark.h |   7 ++
>  2 files changed, 143 insertions(+)
> 
> diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
> index a886f80..98086a9 100644
> --- a/kernel-shark/src/libkshark.c
> +++ b/kernel-shark/src/libkshark.c
> @@ -959,6 +959,142 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
>  	return -ENOMEM;
>  }
>  
> +static bool data_matrix_alloc(size_t n_rows, uint64_t **offset_array,
> +					     uint8_t **cpu_array,
> +					     uint64_t **ts_array,
> +					     uint16_t **pid_array,
> +					     int **event_array)
> +{
> +	if (offset_array) {
> +		*offset_array = calloc(n_rows, sizeof(**offset_array));
> +		if (!offset_array)

This should be

		if (!*offset_array)

and ditto for the rest.

-- Slavi

> +			goto free_all;
> +	}
> +
> +	if (cpu_array) {
> +		*cpu_array = calloc(n_rows, sizeof(**cpu_array));
> +		if (!cpu_array)
> +			goto free_all;
> +	}
> +
> +	if (ts_array) {
> +		*ts_array = calloc(n_rows, sizeof(**ts_array));
> +		if (!ts_array)
> +			goto free_all;
> +	}
> +
> +	if (pid_array) {
> +		*pid_array = calloc(n_rows, sizeof(**pid_array));
> +		if (!pid_array)
> +			goto free_all;
> +	}
> +
> +	if (event_array) {
> +		*event_array = calloc(n_rows, sizeof(**event_array));
> +		if (!event_array)
> +			goto free_all;
> +	}
> +
> +	return true;
> +
> + free_all:
> +	fprintf(stderr, "Failed to allocate memory during data loading.\n");
> +
> +	if (offset_array)
> +		free(*offset_array);
> +
> +	if (cpu_array)
> +		free(*cpu_array);
> +
> +	if (ts_array)
> +		free(*ts_array);
> +
> +	if (pid_array)
> +		free(*pid_array);
> +
> +	if (event_array)
> +		free(*event_array);
> +
> +	return false;
> +}
> +
> +/**
> + * @brief Load the content of the trace data file into a table / matrix made
> + *	  of columns / arrays of data. The user is responsible for freeing the
> + *	  elements of the outputted array
> + *
> + * @param kshark_ctx: Input location for the session context pointer.
> + * @param offset_array: Output location for the array of record offsets.
> + * @param cpu_array: Output location for the array of CPU Ids.
> + * @param ts_array: Output location for the array of timestamps.
> + * @param pid_array: Output location for the array of Process Ids.
> + * @param event_array: Output location for the array of Event Ids.
> + *
> + * @returns The size of the outputted arrays in the case of success, or a
> + *	    negative error code on failure.
> + */
> +size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
> +			       uint64_t **offset_array,
> +			       uint8_t **cpu_array,
> +			       uint64_t **ts_array,
> +			       uint16_t **pid_array,
> +			       int **event_array)
> +{
> +	enum rec_type type = REC_ENTRY;
> +	struct rec_list **rec_list;
> +	size_t count, total = 0;
> +	bool status;
> +	int n_cpus;
> +
> +	total = get_records(kshark_ctx, &rec_list, type);
> +	if (total < 0)
> +		goto fail;
> +
> +	status = data_matrix_alloc(total, offset_array,
> +					  cpu_array,
> +					  ts_array,
> +					  pid_array,
> +					  event_array);
> +	if (!status)
> +		goto fail;
> +
> +	n_cpus = tracecmd_cpus(kshark_ctx->handle);
> +
> +	for (count = 0; count < total; count++) {
> +		int next_cpu;
> +
> +		next_cpu = pick_next_cpu(rec_list, n_cpus, type);
> +		if (next_cpu >= 0) {
> +			struct kshark_entry *e = &rec_list[next_cpu]->entry;
> +
> +			if (offset_array)
> +				(*offset_array)[count] = e->offset;
> +
> +			if (cpu_array)
> +				(*cpu_array)[count] = e->cpu;
> +
> +			if (ts_array)
> +				(*ts_array)[count] = e->ts;
> +
> +			if (pid_array)
> +				(*pid_array)[count] = e->pid;
> +
> +			if (event_array)
> +				(*event_array)[count] = e->event_id;
> +
> +			rec_list[next_cpu] = rec_list[next_cpu]->next;
> +			free(e);
> +		}
> +	}
> +
> +	free_rec_list(rec_list, n_cpus, type);
> +	return total;
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory during data loading.\n");
> +	return -ENOMEM;
> +}
> +
>  static const char *kshark_get_latency(struct tep_handle *pe,
>  				      struct tep_record *record)
>  {
> diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
> index c218b61..92ade41 100644
> --- a/kernel-shark/src/libkshark.h
> +++ b/kernel-shark/src/libkshark.h
> @@ -149,6 +149,13 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
>  ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
>  				 struct tep_record ***data_rows);
>  
> +size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
> +			       uint64_t **offset_array,
> +			       uint8_t **cpu_array,
> +			       uint64_t **ts_array,
> +			       uint16_t **pid_array,
> +			       int **event_array);
> +
>  ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids);
>  
>  void kshark_close(struct kshark_context *kshark_ctx);
> -- 
> 2.19.1
> 
