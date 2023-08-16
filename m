Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE22C25B7F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Aug 2023 21:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241172AbjHPVfj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 17:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346593AbjHPVfW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 17:35:22 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BD52D7B
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 14:34:54 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 46e09a7af769-6bcd4b5ebbaso5996829a34.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 14:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692221693; x=1692826493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uXn5pXqOwh+6pIE4Wf5aLgidSww4P5ymmqnG1XT2DKg=;
        b=BAAc6ADojGBUm++PGPFaU3UGmvrxkqOa8olUub5UoEpZX5AI2twiphec107faWoa2L
         rVrQo6Y4plA5pgYVHYSfd/vYxIfZCP8kClc1e+tITV0Ng3zgxLONscF/yF90pOzxn1SG
         MEYyNhATE4I+rt0FBKWte5rPVX3ANCRl1/jvN7OqzdIIHKexFpxfUPl8K6zKydlCCr3b
         OS4fjwJ2iT0NFMhxq99nXQlV8PhUuswtq4l15IGOhJv5k1HohDzx7AFCE4gSblvUIGQy
         5WrunphcNgwgvURDZ7iM2sl4DCH/u1CyWXyGCfmM4DZrnMh1hRJAdg9USbcuC+3l/SI0
         gjGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692221693; x=1692826493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uXn5pXqOwh+6pIE4Wf5aLgidSww4P5ymmqnG1XT2DKg=;
        b=AHki6tSN5zwSc0OwenqDRKeMWmTRVpiyws9NMjgNCVvDMDLeONP6q64WROCnErnHkC
         temx4J2lL+QupEUAKOdTVLn0MR3XANlmiUjRud7aG5HvM3Hm2aoP2jWemRQNVOymV7NH
         p3zgxzPD1bfUBpAEsdSPdiPLSBw6NUMcZh0xV6a5BcVY2Z4J5oebNfbDruSWNq6881va
         z+vlDI5CGcGEuu1wH/8vEyN1EaGnq8jCWE8VpMSag+yZaORwihzosKfMOkOG/zABBIjE
         6HVt8s21EaTIh5Dv9VxwbzpXh3O6lupDq8diihsEOOrTugUQFBmsazF1kIRKTURYLBVl
         qukA==
X-Gm-Message-State: AOJu0YyqzxlZ+bs0pGom37ds5BreaITGQRxxRivV+nl+kqA+uQkJOqY3
        p8QBWnx8kZmQP/qX7gqp/v/4bA==
X-Google-Smtp-Source: AGHT+IEsLSjDoYS9Da4OcIPgNVbM9tUFlG44HbGsSwMbMyk7ODdB3WrPX4GsRsvo7ZePnbwt+y2YkQ==
X-Received: by 2002:a05:6830:d0:b0:6bc:8594:b16c with SMTP id x16-20020a05683000d000b006bc8594b16cmr3264492oto.10.1692221693386;
        Wed, 16 Aug 2023 14:34:53 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:55c4:49c7:23c3:7d80])
        by smtp.gmail.com with ESMTPSA id ep26-20020a0566384e1a00b0042b2959e6dcsm4652132jab.87.2023.08.16.14.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 14:34:52 -0700 (PDT)
Date:   Wed, 16 Aug 2023 15:34:49 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 11/17] libtraceeval histogram: Add iterator APIs
Message-ID: <20230816213449.GA3686281@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
 <20230811053940.1408424-12-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811053940.1408424-12-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Aug 11, 2023 at 01:39:34AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Provide an interface for the application to iterate over all the entries
> in the traceeval histogram.
> 
>  traceeval_iterator_get() - acquire an iterator for the given traceeval
>  traceveal_iterator_put() - release the iterator
>  traceeval_iterator_sort() - sort the iterator for a given key/value
>  traceeval_iterator_next() - return the keys of the next entry in the
>                              traceeval
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h |   7 ++
>  src/eval-local.h         |  11 ++
>  src/hash.c               |   4 +
>  src/histograms.c         | 255 ++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 276 insertions(+), 1 deletion(-)
> 
<>
> diff --git a/src/histograms.c b/src/histograms.c
> index 9a8ec4d85301..2b823ad5c26d 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -37,7 +37,7 @@ static void print_err(const char *fmt, ...)
>   * -1 for the other way around, and -2 on error.
>   */
>  static int compare_traceeval_data(struct traceeval *teval,
> -				  union traceeval_data *orig,
> +				  const union traceeval_data *orig,
>  				  const union traceeval_data *copy,
>  				  struct traceeval_type *type)
>  {
> @@ -904,3 +904,256 @@ int traceeval_insert(struct traceeval *teval,
>  	else
>  		return update_entry(teval, entry, vals);
>  }
> +
> +/**
> + * traceeval_iterator_put - release a given iterator
> + * @iter: The iterartor to release
> + *
> + * Frees the resources of an @iter that was created by
> + * traceeval_iterator_get().
> + */
> +void traceeval_iterator_put(struct traceeval_iterator *iter)
> +{
> +	if (!iter)
> +		return;
> +
> +	free(iter->entries);

I think we also need to free **sort and *direction, which are both allocated
in traceeval_iterator_sort().    Probably need to update the function comment
as well to include allocs from that function.

> +	free(iter);
> +}
<>
> +/**
> + * traceeval_iterator_sort - sort the entries that an iterator will return
> + * @iter: The iterator to specify the sort order of the entries
> + * @sort_field: The name of the key or value to sort with.
> + * @level: The level of sorting (0 for first order, 1 for second, ...)
> + * @ascending: If the sort should go forward or backward.
> + *
> + * The iterator has a list of entries to produce with traceeval_iterator_next().
> + * This function specifies what the order of the output of that function will
> + * be. Note, whenever this function is called, it resets the @iter so that
> + * the traceveal_iterator_next() will start from the beginning again.
> + *
> + * In other words, be very careful to ever call this function in a middle
> + * of a loop that is using traceeval_iterator_next(), otherwise you may end
> + * up in an infinite loop!
> + *
> + * The @level specifies the level of sorting. That is, for @level = 0,
> + * it will decide the main sorting of the @iter. For @level = 1, it will
> + * be the tie breaker for two entries that are equal for the @level = 0
> + * sort. @level = 2, will be the tie breaker for @level = 1, and so on.
> + *
> + * Note, if traceeval_iterator_next() is called, and there's a missing @level,
> + * it will fail. That is, if this function is called once with @level = 0 and
> + * againg with @level = 2, but never with @level = 1, the call to
> + * traceeval_iterator_next() will fail.
> + *
> + * If this function is called multiple times with the same @level, then the
> + * last call will define the what that @level will do.
> + *
> + * The @ascending will determine if "smaller" items go first if true, and
> + * "larger" items go first if false.
> + *
> + * Return 0 on success and -1 on failure.
> + */
> +int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_field,
> +			    int level, bool ascending)
> +{
> +	bool *direction = iter->direction;
> +	struct traceeval_type **sort = iter->sort;
> +	struct traceeval_type *type;
> +
> +	type = find_sort_type(iter->teval, sort_field);
> +	if (!type)
> +		return -1;
> +
> +	/* pointer and dynamic types must have a cmp function */
> +	switch (type->type) {
> +	case TRACEEVAL_TYPE_POINTER:
> +	case TRACEEVAL_TYPE_DYNAMIC:
> +		if (!type->cmp)
> +			return -1;
> +		break;
> +	default:
> +		break;
> +	}
> +

nit: It'd probably help with readability to have:

  int num_levels = level + 1;

and use that instead of (level + 1).

> +	if ((level + 1) > iter->nr_sort) {
> +		sort = realloc(sort, sizeof(*sort) * (level + 1));
> +		if (!sort)
> +			return -1;
> +
> +		iter->sort = sort;
> +
> +		direction = realloc(direction, sizeof(*direction) * (level + 1));
> +		if (!direction)
> +			return -1;
> +
> +		iter->direction = direction;
> +
> +		/* Make sure the newly allocated contain NULL */
> +		for (int i = iter->nr_sort; i < (level + 1); i++)
> +			sort[i] = NULL;
> +
> +		iter->nr_sort = level + 1;
> +	}
> +
> +	sort[level] = type;
> +	direction[level] = ascending;
> +	iter->needs_sort = true;
> +	return 0;
> +}
<>
> +static int sort_iter(struct traceeval_iterator *iter)
> +{
> +	int i;
> +
> +	/* Make sure all levels are filled */
> +	for (i = 0; i < iter->nr_sort; i++) {
> +		if (!iter->sort[i])
> +			return -1;
> +	}
> +
> +	qsort_r(iter->entries, iter->nr_entries, sizeof(*iter->entries),
> +		iter_cmp, iter);
> +
> +	iter->needs_sort = false;
> +	iter->next = 0;
> +
> +	return 0;
> +}
> +
> +/**
> + * traceeval_iterator_next - retrieve the next entry from an iterator
> + * @iter: The iterator to retrieve the next entry from
> + * @keys: The returned keys of the next entry (if exists)
> + *
> + * This returns the keys for the next entry in the traceeval being
> + * iterated over by @iter. If there are no more entries, 0 is returned
> + * and @keys are untouched.
> + *
> + * Returns 1 if another entry is returned, or 0 if not (or negative on error)
> + */
> +int traceeval_iterator_next(struct traceeval_iterator *iter,
> +			    const union traceeval_data **keys)
> +{
> +	struct entry *entry;
> +	int ret;
> +
> +	if (iter->needs_sort) {
> +		ret = sort_iter(iter);
> +		if (ret < 0)
> +			return ret;
> +		iter->next = 0;

This is already done in sort_iter().

> +	}
> +
> +	if (iter->next >= iter->nr_entries)
> +		return 0;
> +
> +	entry = iter->entries[iter->next++];
> +	*keys = entry->keys;
> +	return 1;
> +}
> -- 
> 2.40.1
> 
