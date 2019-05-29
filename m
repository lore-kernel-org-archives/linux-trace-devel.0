Return-Path: <SRS0=Fo1J=T5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC707C28CC0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 May 2019 17:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A485E23FA4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 29 May 2019 17:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfE2RgJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 29 May 2019 13:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfE2RgJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 May 2019 13:36:09 -0400
Received: from oasis.local.home (unknown [12.156.218.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2392B22CDB;
        Wed, 29 May 2019 17:36:08 +0000 (UTC)
Date:   Wed, 29 May 2019 13:36:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: Re: [PATCH 1/5] kernel-shark: Add new dataloading method to be used
 by the NumPu interface
Message-ID: <20190529133605.214b766f@oasis.local.home>
In-Reply-To: <20190523151812.31391-2-ykaradzhov@vmware.com>
References: <20190523151812.31391-1-ykaradzhov@vmware.com>
        <20190523151812.31391-2-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 23 May 2019 18:18:08 +0300
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> The new function loads the content of the trace data file into a
> table / matrix, made of columns / arrays of data having various integer
> types. Later those arrays will be wrapped as NumPy arrays.
> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/libkshark.c | 155 +++++++++++++++++++++++++++++++++++
>  kernel-shark/src/libkshark.h |   7 ++
>  2 files changed, 162 insertions(+)
> 
> diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
> index 175279c..ac634fd 100644
> --- a/kernel-shark/src/libkshark.c
> +++ b/kernel-shark/src/libkshark.c
> @@ -957,6 +957,161 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
>  	return -ENOMEM;
>  }
>  
> +static bool data_matrix_alloc(size_t n_rows, uint64_t **offset_array,
> +					     uint8_t **cpu_array,
> +					     uint64_t **ts_array,
> +					     uint16_t **pid_array,
> +					     int **event_array)
> +{
> +	if (offset_array)
> +		*offset_array = NULL;
> +
> +	if (cpu_array)
> +		*cpu_array = NULL;
> +
> +	if (ts_array)
> +		*ts_array = NULL;
> +
> +	if (pid_array)
> +		*pid_array = NULL;
> +
> +	if (event_array)
> +		*event_array = NULL;
> +
> +	if (offset_array) {

The way you can do this, is remove the above and have:

> +		*offset_array = calloc(n_rows, sizeof(**offset_array));
> +		if (!*offset_array)

			return false;

> +			goto free_all;
> +	}
> +
> +	if (cpu_array) {
> +		*cpu_array = calloc(n_rows, sizeof(**cpu_array));
> +		if (!*cpu_array)

			goto free_offset;

> +			goto free_all;
> +	}
> +
> +	if (ts_array) {
> +		*ts_array = calloc(n_rows, sizeof(**ts_array));
> +		if (!*ts_array)

			goto free_cpu;

> +			goto free_all;
> +	}
> +
> +	if (pid_array) {
> +		*pid_array = calloc(n_rows, sizeof(**pid_array));
> +		if (!*pid_array)

			goto free_ts;

> +			goto free_all;
> +	}
> +
> +	if (event_array) {
> +		*event_array = calloc(n_rows, sizeof(**event_array));
> +		if (!*event_array)

			goto free_pid;

> +			goto free_all;
> +	}
> +
> +	return true;
> +

We can have a helper function:

static inline void free_ptr(void *ptr)
{
	if (ptr)
		free(*(void **)ptr);
}

free_pid:
	free_ptr(pid_array);
free_ts:
	free_ptr(ts_array);
free_cpu:
	free_ptr(cpu_array);
free_offset:
	free_ptr(offset_array);

Then have the print here.

> + free_all:
> +	fprintf(stderr, "Failed to allocate memory during data loading.\n");

	return false;

This is the way it's usually done in the Linux kernel.

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
> +	n_cpus = tracecmd_cpus(kshark_ctx->handle);
> +
> +	status = data_matrix_alloc(total, offset_array,
> +					  cpu_array,
> +					  ts_array,
> +					  pid_array,
> +					  event_array);

BTW, have you looked into how much memory this takes up in a large
trace?

> +	if (!status)
> +		goto fail_free;
> +
> +	for (count = 0; count < total; count++) {
> +		int next_cpu;
> +
> +		next_cpu = pick_next_cpu(rec_list, n_cpus, type);
> +		if (next_cpu >= 0) {
> +			struct kshark_entry *e = &rec_list[next_cpu]->entry;

Hmm, this looks like we are taking an address of a field and then
freeing it down below. Looking at the definition of rec_list, this is
currently OK. But this coding style is not robust because of the tight
dependency to how rec_list is defined. If that ever changes it will be
hard to find code like this to update it.

A more robust way to do this is:

			struct rec_list *rec = rec_list[next_cpu];
			struct kshark_entry *e = &rec->entry;

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

Then here:

			free(rec);

That way there's not a dependency here with the data structure layout
of rec_list and the freeing of the entry.

-- Steve


> +			free(e);
> +		}
> +	}
> +
> +	/* There should be no entries left in rec_list. */
> +	free_rec_list(rec_list, n_cpus, type);
> +	return total;
> +
> + fail_free:
> +	free_rec_list(rec_list, n_cpus, type);
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory during data
> loading.\n");
> +	return -ENOMEM;
> +}
> +
>  static const char *kshark_get_latency(struct tep_handle *pe,
>  				      struct tep_record *record)
>  {
> diff --git a/kernel-shark/src/libkshark.h
> b/kernel-shark/src/libkshark.h index c218b61..92ade41 100644
> --- a/kernel-shark/src/libkshark.h
> +++ b/kernel-shark/src/libkshark.h
> @@ -149,6 +149,13 @@ ssize_t kshark_load_data_entries(struct
> kshark_context *kshark_ctx, ssize_t kshark_load_data_records(struct
> kshark_context *kshark_ctx, struct tep_record ***data_rows);
>  
> +size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
> +			       uint64_t **offset_array,
> +			       uint8_t **cpu_array,
> +			       uint64_t **ts_array,
> +			       uint16_t **pid_array,
> +			       int **event_array);
> +
>  ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int
> **pids); 
>  void kshark_close(struct kshark_context *kshark_ctx);

