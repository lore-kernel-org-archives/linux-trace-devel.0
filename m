Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA077C001B0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 20:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbjHHUfa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 16:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjHHUfN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 16:35:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F0962D11
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 11:55:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3B3962A68
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 18:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7819C433C7;
        Tue,  8 Aug 2023 18:55:19 +0000 (UTC)
Date:   Tue, 8 Aug 2023 14:55:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v3 4/6] histograms: Add traceeval query
Message-ID: <20230808145517.4a1cd49a@gandalf.local.home>
In-Reply-To: <20230808161204.5704-5-stevie.6strings@gmail.com>
References: <20230808161204.5704-1-stevie.6strings@gmail.com>
        <20230808161204.5704-5-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  8 Aug 2023 12:11:57 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> 
> traceeval_query() fetches the values (aka results) of an entry with
> keys that match the array of keys provided. The results of a query can
> be useful for aggregating data between entries/trace events.
> 
> traceeval_results_release() frees the results fetched by the query. The
> user must free the results of a successful query.
> 
> Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> ---
>  include/traceeval-hist.h |   6 ++
>  src/histograms.c         | 163 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 169 insertions(+)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index 5203520..4923de1 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -134,4 +134,10 @@ struct traceeval *traceeval_init(const struct traceeval_type *keys,
>  
>  void traceeval_release(struct traceeval *teval);
>  
> +int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
> +		    union traceeval_data **results);
> +
> +void traceeval_results_release(struct traceeval *teval,
> +			       union traceeval_data *results);
> +
>  #endif /* __LIBTRACEEVAL_HIST_H__ */
> diff --git a/src/histograms.c b/src/histograms.c
> index 6fac205..47ff175 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -521,3 +521,166 @@ void traceeval_release(struct traceeval *teval)
>  	teval->val_types = NULL;
>  	free(teval);
>  }
> +
> +/*
> + * Find the entry that @keys corresponds to within @teval.
> + *
> + * Returns 0 on success, 1 if no match found, -1 on error.

Ideally, it would be 1 if found, 0 if not found and -1 on error.

But I guess you did it this way to short circuit the check below, but that
doesn't match either.

> + */
> +static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
> +		     struct entry **result)
> +{
> +	struct hist_table *hist;
> +	int i;
> +	int check;

Upside-down x-mas tree format :-)

	struct hist_table *hist;
	struct entry;
	int check = 0;
	int i;

There's a reason I set check to zero.

> +
> +	if (!teval || !keys)
> +		return -1;
> +
> +	hist = teval->hist;


> +	i = 0;
> +	for (struct entry *entry = hist->map; i < hist->nr_entries;

Do not declare complex variables in for loops. Makes them much harder to
read.

	for (i = 0, entry = hist->map; i < hist->nr_entries; entry = &hist->map[++i])

> +			entry = &hist->map[++i]) {

Probably want to optimize this with a hash anyway, especially since the
code will likely have hundreds of keys and do thousands of lookups.

> +		check = compare_traceeval_data_set(entry->keys, keys,

compare_traceeval_data_set() should return 1 on found, zero on not found
and -1 on error.

> +				teval->key_types, teval->nr_key_types);
> +

We can then have:

		if (!check)
			continue;

		break;

> +		/* return entry if keys match */
> +		if (!check) {
> +			*result = entry;
> +			return 0;
> +		} else if (check == 1) {
> +			continue;
> +		} else {
> +			return check;
> +		}
> +	}

	if (check > 0)
		*result = entry;

	return check;

> +
> +	return 1;
> +}
> +
> +/*
> + * Copy @orig to @copy with respect to @type.
> + *
> + * Return 0 on success, -1 on error.
> + */
> +static int copy_traceeval_data(struct traceeval_type *type,
> +				const union traceeval_data *orig,
> +				union traceeval_data *copy)
> +{
> +	*copy = *orig;
> +
> +	switch (type->type) {
> +	case TRACEEVAL_TYPE_STRING:
> +		copy->string = NULL;
> +		if (orig->string)
> +			copy->string = strdup(orig->string);
> +		if (!copy->string)
> +			return -1;
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Free @data with respect to @size and @type.
> + *
> + * Does not call dyn_release on type TRACEEVAL_TYPE_DYNAMIC.
> + */
> +static void data_release(size_t size, union traceeval_data **data,
> +				struct traceeval_type *type)
> +{
> +	for (size_t i = 0; i < size; i++) {
> +		if (type[i].type == TRACEEVAL_TYPE_STRING)
> +			free((*data)[i].string);
> +	}
> +	free(*data);
> +	*data = NULL;
> +}
> +
> +/*
> + * Copy @orig to @copy with respect to @size and @type.
> + *
> + * Returns 1 on success, -1 on error.
> + */
> +static int copy_traceeval_data_set(size_t size, struct traceeval_type *type,
> +				    const union traceeval_data *orig,
> +				    union traceeval_data **copy)
> +{
> +	size_t i;
> +
> +	*copy = calloc(size, sizeof(**copy));
> +	if (!*copy)
> +		return -1;
> +
> +	for (i = 0; i < size; i++) {
> +		if (copy_traceeval_data(type + i, orig + i, (*copy) + i))
> +			goto fail;
> +	}
> +
> +	return 1;
> +
> +fail:
> +	data_release(i, copy, type);
> +	return -1;
> +}
> +
> +
> +/*
> + * traceeval_query - find the last instance defined by the keys
> + * @teval: The descriptor to search from
> + * @keys: A list of data to look for
> + * @results: A pointer to where to place the results (if found)
> + *
> + * This does a lookup for an instance within the traceeval data.
> + * The @keys is an array defined by the keys declared in traceeval_init().
> + * The @keys will return an item that had the same keys when it was
> + * inserted by traceeval_insert(). The @keys here follow the same rules
> + * as the keys for traceeval_insert().
> + *
> + * Note, when the caller is done with @results, it must call
> + * traceeval_results_release() on it.
> + *
> + * Returns 1 if found, 0 if not found, and -1 on error.

The above is what I would agree on, but does not follow below.

> + */
> +int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
> +		    union traceeval_data **results)
> +{
> +	struct entry *entry;
> +	int check;
> +
> +	if (!teval || !keys || !results)
> +		return -1;
> +
> +	/* find key and copy its corresponding value pair */
> +	if ((check = get_entry(teval, keys, &entry)))

If get_entry() returns 1 on match and 0 if not, and -1 on error, I think we
want this to be:

	if ((check = get_entry(teval, keys, &entry) < 1)
> +		return check;

Right now it returns 1 on not found.

-- Steve

> +	return copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
> +			entry->vals, results);
> +}
> +
> +/*
> + * traceeval_results_release - release the results return by traceeval_query()
> + * @teval: The descriptor used in traceeval_query()
> + * @results: The results returned by traceeval_query()
> + *
> + * The @results returned by traceeval_query() is owned by @teval, and
> + * how it manages it is implementation specific. The caller should not
> + * worry about it. When the caller of traceeval_query() is done with
> + * the @results, it must call traceeval_results_release() on it to
> + * allow traceeval to clean up its references.
> + */
> +void traceeval_results_release(struct traceeval *teval,
> +			       union traceeval_data *results)
> +{
> +	if (!teval || !results) {
> +		if (!results)
> +			print_err("Results to be freed without accompanied traceeval instance!");
> +		return;
> +	}
> +
> +	data_release(teval->nr_val_types, &results, teval->val_types);
> +}

