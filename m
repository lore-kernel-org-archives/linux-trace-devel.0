Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7816C27C42
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Aug 2023 21:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346655AbjHPVtm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 17:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346734AbjHPVtf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 17:49:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD992D4E
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 14:49:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60B746492F
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 21:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD6DC433C8;
        Wed, 16 Aug 2023 21:49:23 +0000 (UTC)
Date:   Wed, 16 Aug 2023 17:49:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 11/17] libtraceeval histogram: Add iterator APIs
Message-ID: <20230816174927.55777a95@gandalf.local.home>
In-Reply-To: <20230816213449.GA3686281@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
        <20230811053940.1408424-12-rostedt@goodmis.org>
        <20230816213449.GA3686281@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Aug 2023 15:34:49 -0600
Ross Zwisler <zwisler@google.com> wrote:

> > +
> > +/**
> > + * traceeval_iterator_put - release a given iterator
> > + * @iter: The iterartor to release
> > + *
> > + * Frees the resources of an @iter that was created by
> > + * traceeval_iterator_get().
> > + */
> > +void traceeval_iterator_put(struct traceeval_iterator *iter)
> > +{
> > +	if (!iter)
> > +		return;
> > +
> > +	free(iter->entries);  
> 
> I think we also need to free **sort and *direction, which are both allocated
> in traceeval_iterator_sort().    Probably need to update the function comment
> as well to include allocs from that function.

Yes, thanks.

> 
> > +	free(iter);
> > +}  
> <>
> > +/**
> > + * traceeval_iterator_sort - sort the entries that an iterator will return
> > + * @iter: The iterator to specify the sort order of the entries
> > + * @sort_field: The name of the key or value to sort with.
> > + * @level: The level of sorting (0 for first order, 1 for second, ...)
> > + * @ascending: If the sort should go forward or backward.
> > + *
> > + * The iterator has a list of entries to produce with traceeval_iterator_next().
> > + * This function specifies what the order of the output of that function will
> > + * be. Note, whenever this function is called, it resets the @iter so that
> > + * the traceveal_iterator_next() will start from the beginning again.
> > + *
> > + * In other words, be very careful to ever call this function in a middle
> > + * of a loop that is using traceeval_iterator_next(), otherwise you may end
> > + * up in an infinite loop!
> > + *
> > + * The @level specifies the level of sorting. That is, for @level = 0,
> > + * it will decide the main sorting of the @iter. For @level = 1, it will
> > + * be the tie breaker for two entries that are equal for the @level = 0
> > + * sort. @level = 2, will be the tie breaker for @level = 1, and so on.
> > + *
> > + * Note, if traceeval_iterator_next() is called, and there's a missing @level,
> > + * it will fail. That is, if this function is called once with @level = 0 and
> > + * againg with @level = 2, but never with @level = 1, the call to
> > + * traceeval_iterator_next() will fail.
> > + *
> > + * If this function is called multiple times with the same @level, then the
> > + * last call will define the what that @level will do.
> > + *
> > + * The @ascending will determine if "smaller" items go first if true, and
> > + * "larger" items go first if false.
> > + *
> > + * Return 0 on success and -1 on failure.
> > + */
> > +int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_field,
> > +			    int level, bool ascending)
> > +{
> > +	bool *direction = iter->direction;
> > +	struct traceeval_type **sort = iter->sort;
> > +	struct traceeval_type *type;
> > +
> > +	type = find_sort_type(iter->teval, sort_field);
> > +	if (!type)
> > +		return -1;
> > +
> > +	/* pointer and dynamic types must have a cmp function */
> > +	switch (type->type) {
> > +	case TRACEEVAL_TYPE_POINTER:
> > +	case TRACEEVAL_TYPE_DYNAMIC:
> > +		if (!type->cmp)
> > +			return -1;
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +  
> 
> nit: It'd probably help with readability to have:
> 
>   int num_levels = level + 1;
> 
> and use that instead of (level + 1).

Sure, I'm just so use to the (level + 1), that it comes natural for me now.
But I do agree, from a readability standpoint, having a "num_levels" would
be better.

> 
> > +	if ((level + 1) > iter->nr_sort) {
> > +		sort = realloc(sort, sizeof(*sort) * (level + 1));
> > +		if (!sort)
> > +			return -1;
> > +
> > +		iter->sort = sort;
> > +
> > +		direction = realloc(direction, sizeof(*direction) * (level + 1));
> > +		if (!direction)
> > +			return -1;
> > +
> > +		iter->direction = direction;
> > +
> > +		/* Make sure the newly allocated contain NULL */
> > +		for (int i = iter->nr_sort; i < (level + 1); i++)
> > +			sort[i] = NULL;
> > +
> > +		iter->nr_sort = level + 1;
> > +	}
> > +
> > +	sort[level] = type;
> > +	direction[level] = ascending;
> > +	iter->needs_sort = true;
> > +	return 0;
> > +}  
> <>
> > +static int sort_iter(struct traceeval_iterator *iter)
> > +{
> > +	int i;
> > +
> > +	/* Make sure all levels are filled */
> > +	for (i = 0; i < iter->nr_sort; i++) {
> > +		if (!iter->sort[i])
> > +			return -1;
> > +	}
> > +
> > +	qsort_r(iter->entries, iter->nr_entries, sizeof(*iter->entries),
> > +		iter_cmp, iter);
> > +
> > +	iter->needs_sort = false;
> > +	iter->next = 0;
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * traceeval_iterator_next - retrieve the next entry from an iterator
> > + * @iter: The iterator to retrieve the next entry from
> > + * @keys: The returned keys of the next entry (if exists)
> > + *
> > + * This returns the keys for the next entry in the traceeval being
> > + * iterated over by @iter. If there are no more entries, 0 is returned
> > + * and @keys are untouched.
> > + *
> > + * Returns 1 if another entry is returned, or 0 if not (or negative on error)
> > + */
> > +int traceeval_iterator_next(struct traceeval_iterator *iter,
> > +			    const union traceeval_data **keys)
> > +{
> > +	struct entry *entry;
> > +	int ret;
> > +
> > +	if (iter->needs_sort) {
> > +		ret = sort_iter(iter);
> > +		if (ret < 0)
> > +			return ret;
> > +		iter->next = 0;  
> 
> This is already done in sort_iter().


Yep, I know. But I love redundancy ;-)

I actually added it to both at the same time because I didn't know which
one was better to have it. I compromised, and just said "OK do it in both!"

-- Steve

> 
> > +	}
> > +
> > +	if (iter->next >= iter->nr_entries)
> > +		return 0;
> > +
> > +	entry = iter->entries[iter->next++];
> > +	*keys = entry->keys;
> > +	return 1;
> > +}
> > -- 
> > 2.40.1
> >   

