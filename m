Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17025C001DF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Aug 2023 01:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjHABZs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 31 Jul 2023 21:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjHABZr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 31 Jul 2023 21:25:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0786810D
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Jul 2023 18:25:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62CB161384
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Aug 2023 01:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472D9C433C8;
        Tue,  1 Aug 2023 01:25:44 +0000 (UTC)
Date:   Mon, 31 Jul 2023 21:25:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/5] histograms: initial histograms interface
Message-ID: <20230731212542.3fb668b1@gandalf.local.home>
In-Reply-To: <20230801003624.GA2304479@google.com>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
        <20230801003624.GA2304479@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 31 Jul 2023 18:36:24 -0600
Ross Zwisler <zwisler@google.com> wrote:

> On Fri, Jul 28, 2023 at 03:04:36PM -0400, Stevie Alvarez wrote:

> > +/**
> > + * traceeval_query - Find the last instance defined by the keys
> > + * @teval: The descriptor to search from
> > + * @keys: A list of data to look for
> > + * @results: A pointer to where to place the results (if found)
> > + *
> > + * This does a lookup for an instance within the traceeval data.
> > + * The @keys is an array defined by the keys declared in traceeval_init().
> > + * The @keys will return an item that had the same keys when it was
> > + * inserted by traceeval_insert(). The @keys here follow the same rules
> > + * as the keys for traceeval_insert().
> > + *
> > + * Note, when the caller is done with @results, it must call
> > + * traceeval_results_release() on it.
> > + *
> > + * Returns 1 if found, 0 if not found, and -1 on error.
> > + */
> > +int traceeval_query(struct traceeval *teval,
> > +		const union traceeval_data *keys,
> > +		union traceeval_data * const *results);  
> 
> I don't think this 'union traceeval_data * const *results' will give you what
> you want.  This will pass in an immutable pointer to 'results', and you need
> to modify the 'results' pointer.

That's my fault. I had it it that way in the code I had him base this off
of. In fact, in Boulder I said I need to check that because it may be
wrong. It was ;-)

Yes, Ross is right, it should be "const union traceeval_data **results".

Thanks Ross.

> 
> I think you actually want 'const union traceeval_data **results' because you
> want a mutable pointer (results) to immutable results data.  This is similar
> to the 'const union traceeval_data **keys' arg given to
> 
> > int traceeval_iterator_next(struct traceeval_iterator *iter,
> > 		const union traceeval_data **keys);  
> 
> and will match the const placement on the 'results' argument to 
> 
> > void traceeval_results_release(struct traceeval *teval,
> > 		const union traceeval_data *results);  
> 
> With the current code there is no way to get results back out of this
> function, because 'results' is const and you won't be able to set the pointer.
> 
> Here is a quick example I made to make sure I understood the various
> placements of const in this arg list. :)

I was going to do this too while in Boulder, but we got distracted :-p

-- Steve


> 
> --- >8 ---  
> #include <stdio.h>
> #include <stdlib.h>
> #include <histogram.h>
> 
> int traceeval_query(struct traceeval *teval,
> 		const union traceeval_data *keys,
> 		const union traceeval_data **results)
> {
> 	union traceeval_data *r = malloc(sizeof r);
> 	*results = r;
> 	r->string = "foo";
> }
> 
> void main()
> {
> 	const union traceeval_data *results;
> 
> 	traceeval_query(NULL, NULL, &results);
> 	printf("results->name:'%s'\n", results->string);
> 
>         // This next line would fail because the results data itself is
>         // read-only.
> //	results->name = "bar";
> }
> --- >8 ---  
> 
> > +
> > +/** Field name/descriptor for number of hits */
> > +#define TRACEEVAL_VAL_HITS ((const char *)(-1UL))
> > +
> > +/**
> > + * traceeval_find_key - find the index of a key
> > + * @teval: The descriptor to find the key for
> > + * @field: The name of the key to return the index for
> > + *
> > + * As the order of how keys are defined by traceeval_init(), it
> > + * is important to know what index they are for when dealing with
> > + * the other functions.
> > + *
> > + * Returns the index of the key with @field as the name.
> > + * Return -1 if not found.
> > + */
> > +int traceeval_find_key(struct traceeval *teval, const char *field);
> > +
> > +/**
> > + * traceeval_find_val - find the index of a value
> > + * @teval: The descriptor to find the value for
> > + * @field: The name of the value to return the index for
> > + *
> > + * As the order of how values are defined by traceeval_init(), it
> > + * is important to know what index they are for when dealing with
> > + * the results array from traceeval_query(). In order to facilitate
> > + * this, traceeval_find_val() will return the index for a given
> > + * @field so that the caller does not have to keep track of it.
> > + *
> > + * Returns the index of the value with @field as the name that can be
> > + * used to index the @results array from traceeval_query().
> > + * Return -1 if not found.
> > + */
> > +int traceeval_find_val(struct traceeval *teval, const char *field);
> > +
> > +/**
> > + * traceeval_results_release - Release the results return by traceeval_query()
> > + * @teval: The descriptor used in traceeval_query()
> > + * @results: The results returned by traceeval_query()
> > + *
> > + * The @results returned by traceeval_query() is owned by @teval, and
> > + * how it manages it is implementation specific. The caller should not
> > + * worry about it. When the caller of traceeval_query() is done with
> > + * the @results, it must call traceeval_results_release() on it to
> > + * allow traceeval to clean up its references.
> > + */
> > +void traceeval_results_release(struct traceeval *teval,
> > +		const union traceeval_data *results);
> > +
> > +// Result iterator/histogram dump interfaces
> > +
> > +/** Iterator over aggregated data */
> > +struct traceeval_iterator;
> > +
> > +/**
> > + * traceeval_iterator_get - get an iterator to read the data from traceeval
> > + * @teval: The descriptor to read from
> > + *
> > + * This returns a descriptor that can be used to interate through all the
> > + * data within @teval.
> > + *
> > + * Returns the iterator on success, NULL on error.
> > + */
> > +struct traceeval_iterator *traceeval_iterator_get(struct traceeval *teval);
> > +
> > +/**
> > + * traceeval_iterator_sort - Set how the iterator is sorted
> > + * @iter: The iterator to set the sorting
> > + * @sort_field: The field (defined by traceeval_init) to sort by.
> > + * @level: The level of sorting.
> > + * @ascending: Set to true to sort ascending order, or false to descending
> > + *
> > + * Sets how the iterator shall be sorted. @sort_field is the field to sort
> > + * by and may be the name of either a key or a value.
> > + *
> > + * The @level should be zero the first time this is called to define the main sort
> > + * field. If secondary sorting is to be done, then this function should be called
> > + * again with @level as 1. For more levels of sorting just call this function
> > + * for each level incrementing level each time. Note, if a level is missed,
> > + * then this will return an error and sorting will not be done for that level.
> > + *
> > + * Returns 0 on success, -1 or error (including missing a level).
> > + */
> > +int traceeval_iterator_sort(struct traceeval_iterator *iter,
> > +		const char *sort_field, int level, bool ascending);
> > +
> > +/**
> > + * traceeval_iterator_next - Iterate through the data of a traceeval descriptor
> > + * @iter: The iterator that holds the location and sorting of the data
> > + * @keys: The current set of keys of the traceeval the @iter is sorting through
> > + *
> > + * This will iterate through all the data of the traceeval descriptor held
> > + * by @iter in the sort pattern defined by traceeval_iterator_sort().
> > + * The @keys return is same as the data used to populate the data passed into
> > + * traceveal_insert(). When the caller is done with @keys, it should be passed
> > + * into traceeval_keys_release().
> > + *
> > + * Returns 1 if it returned an item, 0 if there's no more data to return,
> > + * and -1 on error.
> > + */
> > +int traceeval_iterator_next(struct traceeval_iterator *iter,
> > +		const union traceeval_data **keys);
> > +
> > +/**
> > + * traceeval_keys_release - Release the keys return by traceeval_iterator_next()
> > + * @iter: The iterator used in traceeval_iterator_next().
> > + * @keys: The results returned by traceeval_iterator_next()
> > + *
> > + * The @keys returned by traceeval_iterator_next() is owned by @iter, and
> > + * how it manages it is implementation specific. The caller should not
> > + * worry about it. When the caller of traceeval_iterator_next() is done with
> > + * the @keys, it must call traceeval_keys_release() on it to
> > + * allow traceeval to clean up its references.
> > + */
> > +void traceeval_keys_release(struct traceeval_iterator *iter,
> > +		const union traceeval_data *keys);
> > +
> > +// Statistic extraction
> > +
> > +/** Statistics about a given field */
> > +struct traceeval_stat {
> > +	unsigned long long	max;
> > +	unsigned long long	min;
> > +	unsigned long long	total;
> > +	unsigned long long	avg;
> > +	unsigned long long	std;
> > +};
> > +
> > +/**
> > + * traceeval_stat - Extract stats from a field marke a TRACEEVAL_FL_STATS
> > + * @teval: The descriptor holding the traceeval information
> > + * @keys: The list of keys to find the instance to get the stats on
> > + * @field: The field to retreive the stats for
> > + * @stats: A structure to place the stats into.
> > + *
> > + * This returns the stats of the the given @field. Note, if @field was
> > + * not marked for recording stats with the TRACEEVAL_FL_STATS flag, or
> > + * if no instance is found that has @keys, this will return an error.
> > + *
> > + * Returns 0 on success, -1 on error.
> > + */
> > +int traceeval_stat(struct traceeval *teval, const union traceeval_data *keys,
> > +		const char *field, struct traceeval_stat *stat);
> > +
> > +#endif /* __LIBTRACEEVAL_HIST_H__ */
> > +
> > -- 
> > 2.41.0
> >   

