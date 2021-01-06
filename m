Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A50CC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 17:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2939B22CA2
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 17:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbhAFRjc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Jan 2021 12:39:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727410AbhAFRjc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Jan 2021 12:39:32 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E97F22CA2;
        Wed,  6 Jan 2021 17:38:51 +0000 (UTC)
Date:   Wed, 6 Jan 2021 12:38:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/6] kernel-shark: Add kshark_data_container to
 libkshark
Message-ID: <20210106123850.07f20658@gandalf.local.home>
In-Reply-To: <20210106161120.119085-3-y.karadz@gmail.com>
References: <20210106161120.119085-1-y.karadz@gmail.com>
        <20210106161120.119085-3-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  6 Jan 2021 18:11:16 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> We add an infrastructure for recording the data from a particular trace
> event field during data loading. The goal is to avoid the use of the
> expensive "read_event_field" operation in the case when the value of the
> field is needed during the visualization processing (in a plugins for

			"in plugins for example"

> example).
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/libkshark.c           | 147 ++++++++++++++++++++++++++++++++++++++
>  src/libkshark.h           |  43 +++++++++++
>  tests/libkshark-tests.cpp |  34 +++++++++
>  3 files changed, 224 insertions(+)
> 
> diff --git a/src/libkshark.c b/src/libkshark.c
> index 3aa3fa2..8722794 100644
> --- a/src/libkshark.c
> +++ b/src/libkshark.c
> @@ -2116,3 +2116,150 @@ kshark_merge_data_matrices(struct kshark_matrix_data_set *buffers, int n_buffers
>   end:
>  	return merged_data;
>  }
> +
> +/** @brief Allocate memory for kshark_data_container. */
> +struct kshark_data_container *kshark_init_data_container()
> +{
> +	struct kshark_data_container *container;
> +
> +	container = calloc(1, sizeof(*container));
> +	if (!container)
> +		goto fail;

Note, we goto fail on failed allocation.

> +
> +	container->data = calloc(KS_CONTAINER_DEFAULT_SIZE,
> +				  sizeof(*container->data));
> +
> +	if (!container->data)
> +		goto fail;
> +
> +	container->capacity = KS_CONTAINER_DEFAULT_SIZE;
> +	container->sorted = false;
> +
> +	return container;
> +
> + fail:
> +	fprintf(stderr, "Failed to allocate memory for data container.\n");
> +	kshark_free_data_container(container);

We call kshark_free_data_container(container) where container could equal
NULL.

> +	return NULL;
> +}
> +
> +/**
> + * @brief Free the memory allocated for a kshark_data_container
> + * @param container: Intput location for the kshark_data_container object.
> + */
> +void kshark_free_data_container(struct kshark_data_container *container)
> +{

Need a check here of:

	if (!container)
		return;

> +	for (ssize_t i = 0; i < container->size; ++i)

Otherwise, the above will crash.

> +		free(container->data[i]);
> +
> +	free(container->data);
> +	free(container);
> +}
> +
> +/**
> + * @brief Append data field value to a kshark_data_container
> + * @param container: Intput location for the kshark_data_container object.

                        "Input"

> + * @param entry: The entry that needs addition data field value.
> + * @param field: The value of data field to be added.
> + *
> + * @returns The size of the container after the addition.
> + */
> +ssize_t kshark_data_container_append(struct kshark_data_container *container,
> +				     struct kshark_entry *entry, int64_t field)
> +{
> +	if (container->capacity == container->size) {
> +		bool ok;
> +
> +		KS_DOUBLE_SIZE(struct kshark_data_field_int64 *,
> +			       container->data,
> +			       &container->capacity,
> +			       &ok);
> +
> +		if (!ok)
> +			return -ENOMEM;

By changing the KS_DOUBLE_SIZE to what I recommended, you could shorten the
above to just:

		if (!KS_DOUBLE_SIZE(container->data, container->capacity)
			return -ENOMEM;

> +	}
> +
> +	container->data[container->size] = malloc(sizeof(container->data));

			sizeof(container->data[0]) ?

> +	container->data[container->size]->entry = entry;
> +	container->data[container->size++]->field = field;
> +
> +	return container->size;
> +}
> +
> +static int compare_time_dc(const void* a, const void* b)
> +{
> +	const struct kshark_data_field_int64 *field_a, *field_b;
> +
> +	field_a = *(const struct kshark_data_field_int64 **) a;
> +	field_b = *(const struct kshark_data_field_int64 **) b;
> +
> +	if (field_a->entry->ts > field_b->entry->ts)
> +		return 1;
> +
> +	if (field_a->entry->ts < field_b->entry->ts)
> +		return -1;
> +
> +	return 0;
> +}
> +
> +/**
> + * @brief Sort in time the records in kshark_data_container. The container is
> + *	  resized in order to free the unused memory capacity.
> + *
> + * @param container: Intput location for the kshark_data_container object.
> + */
> +void kshark_data_container_sort(struct kshark_data_container *container)
> +{
> +	struct kshark_data_field_int64	**data_tmp;
> +
> +	qsort(container->data, container->size,
> +	      sizeof(struct kshark_data_field_int64 *),

I always like using the variable in sizeof, just in case things change:
		sizeof(*container->data)

-- Steve

> +	      compare_time_dc);
> +
> +	container->sorted = true;
> +
> +	data_tmp = realloc(container->data,
> +			   container->size * sizeof(*container->data));
> +
> +	if (!data_tmp)
> +		return;
> +
> +	container->data = data_tmp;
> +	container->capacity = container->size;
> +}
> +
> +/**
> + * @brief Binary search inside a time-sorted array of kshark_data_field_int64.
> + *
> + * @param time: The value of time to search for.
> + * @param data: Input location for the data.
> + * @param l: Array index specifying the lower edge of the range to search in.
> + * @param h: Array index specifying the upper edge of the range to search in.
> + *
> + * @returns On success, the index of the first kshark_data_field_int64 inside
> + *	    the range, having a timestamp equal or bigger than "time".
> + *	    If all fields inside the range have timestamps greater than "time"
> + *	    the function returns BSEARCH_ALL_GREATER (negative value).
> + *	    If all fields inside the range have timestamps smaller than "time"
> + *	    the function returns BSEARCH_ALL_SMALLER (negative value).
> + */
> +ssize_t kshark_find_entry_field_by_time(int64_t time,
> +					struct kshark_data_field_int64 **data,
> +					size_t l, size_t h)
> +{
> +	size_t mid;
> +
> +	if (data[l]->entry->ts > time)
> +		return BSEARCH_ALL_GREATER;
> +
> +	if (data[h]->entry->ts < time)
> +		return BSEARCH_ALL_SMALLER;
> +
> +	/*
> +	 * After executing the BSEARCH macro, "l" will be the index of the last
> +	 * entry having timestamp < time and "h" will be the index of the first
> +	 * entry having timestamp >= time.
> +	 */
> +	BSEARCH(h, l, data[mid]->entry->ts < time);
> +	return h;
> +}
