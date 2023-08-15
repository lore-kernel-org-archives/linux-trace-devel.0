Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91FCC04A94
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Aug 2023 20:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbjHOUYL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 16:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbjHOUXg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 16:23:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FAEB10E9
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 13:23:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38DE064647
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 20:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30791C433C8;
        Tue, 15 Aug 2023 20:23:33 +0000 (UTC)
Date:   Tue, 15 Aug 2023 16:23:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 08/17] libtraceeval histograms: Move hash functions
 into their own file
Message-ID: <20230815162333.621b6d8b@gandalf.local.home>
In-Reply-To: <20230815193156.GD780024@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
        <20230811053940.1408424-9-rostedt@goodmis.org>
        <20230815193156.GD780024@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 15 Aug 2023 13:31:56 -0600
Ross Zwisler <zwisler@google.com> wrote:

> 
> > diff --git a/src/hash.c b/src/hash.c
> > new file mode 100644
> > index 000000000000..e4f2a983d39c
> > --- /dev/null
> > +++ b/src/hash.c
> > @@ -0,0 +1,119 @@
> > +/* SPDX-License-Identifier: MIT */
> > +/*
> > + * libtraceeval hashtable interface implementation.
> > + *
> > + * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
> > + */
> > +
> > +#include <traceeval-hist.h>
> > +
> > +#include "eval-local.h"
> > +
> > +__hidden struct hash_table *hash_alloc(void)
> > +{
> > +	struct hash_table *hash;
> > +
> > +	hash = calloc(1, sizeof(*hash));
> > +	if (!hash)
> > +		return NULL;
> > +
> > +	hash->bits = HASH_BITS;
> > +	hash->hash = calloc(HASH_SIZE(hash->bits), sizeof(*hash->hash));
> > +	if (!hash->hash) {
> > +		free(hash);
> > +		hash = NULL;
> > +	}
> > +
> > +	return hash;
> > +}
> > +
> > +__hidden void hash_free(struct hash_table *hash)
> > +{
> > +	free(hash->hash);
> > +	free(hash);
> > +}
> > +
> > +__hidden void hash_add(struct hash_table *hash, struct hash_item *item, unsigned key)
> > +{
> > +	key &= HASH_MASK(hash->bits);  
> 
> key should already be masked to HASH_MASK(hash->bits) via make_hash().  If
> those bits are set, we have a bug somewhere.
> 
> I think it's better to check to see if those bits are set and bail out loudly
> with an error.

I debated a bit about where to do the mask. I didn't want to put a
dependency that the bits were already masked, so I just did it twice. It's
a very fast operation.

I also don't want to make the dependency that key can only come from
mask_hash(). As it's critical that key is masked here (or we have a array
overflow), I just kept it in both places.

I can comment that here.

> 
> > +
> > +	item->next = hash->hash[key];
> > +	hash->hash[key] = item;
> > +	item->key = key;
> > +
> > +	hash->nr_items++;
> > +}
> > +
> > +__hidden int hash_remove(struct hash_table *hash, struct hash_item *item)
> > +{
> > +	struct hash_item **parent;
> > +
> > +	for (parent = &hash->hash[item->key]; *parent; parent = &(*parent)->next) {
> > +		if (*parent == item) {
> > +			*parent = item->next;
> > +			hash->nr_items--;
> > +			return 1;
> > +		}
> > +	}
> > +	return 0;
> > +}
> > +
> > +__hidden struct hash_iter *hash_iter_start(struct hash_table *hash)
> > +{
> > +	struct hash_iter *iter = &hash->iter;
> > +	size_t i;
> > +
> > +	for (i = 0; i < HASH_SIZE(hash->bits); i++) {
> > +		if (!hash->hash[i])
> > +			continue;
> > +		iter->next_item = hash->hash[i];  
> 
> I think we need to break here after we've found a populated bucket and set
> iter->next_item.  Right now this works only if we have a single populated
> bucket, because we'll set iter->next_item once and then keep iterating until
> i == HASH_SIZE(hash->bits).
> 
> This will mean that iter->current_bucket will always == HASH_SIZE(hash->bits),
> but we have a bug in hash_iter_next() that meant we weren't returning early
> with NULL when we hit this condition.

Nice catch, but I found this bug during my tests but fixed it in patch 11. :-p

I'll move that change here, as that's the proper place it belongs.

> 
> > +	}
> > +	iter->current_bucket = i;
> > +	return iter;
> > +}
> > +
> > +__hidden struct hash_item *hash_iter_next(struct hash_iter *iter)
> > +{
> > +	struct hash_table *hash = container_of(iter, struct
> > hash_table, iter);
> > +	struct hash_item *item;
> > +
> > +	if (iter->current_bucket > HASH_SIZE(hash->bits))  
> 
> 	if (iter->current_bucket >= HASH_SIZE(hash->bits))
> 
> Right now we're missing the exit case where
> iter->current_bucket == HASH_SIZE(hash->bits), which means we've run out
> of buckets with entries.

You are correct that it should be fixed, but it just happens that the rest
of the logic will still end up returning NULL when this happens. But the
above was suppose to be a "shortcut" that never gets hit (or why I fixed it
in patch 11)!

> 
> > +		return NULL;
> > +
> > +	item = iter->next_item;

In patch 11, I added:

	if (!item)
		return NULL;

That should be here too (along with the above off by one fix).

> > +
> > +	iter->next_item = item->next;
> > +	if (!iter->next_item) {
> > +		size_t i;
> > +
> > +		for (i = iter->current_bucket + 1; i <
> > HASH_SIZE(hash->bits); i++) {
> > +			if (!hash->hash[i])
> > +				continue;
> > +			iter->next_item = hash->hash[i];  
> 
> As in hash_iter_start(), we need to break when we find the next non-empty
> bucket and set iter->next_item.  This will let us set iter->current_bucket
> correctly as well.

And this too was fixed in patch 11.

> 
> > +		}
> > +		iter->current_bucket = i;
> > +	}
> > +	return item;
> > +}
> > +
> > +__hidden struct hash_iter *hash_iter_bucket(struct hash_table *hash,
> > unsigned key) +{
> > +	struct hash_iter *iter = &hash->iter;
> > +
> > +	key &= HASH_MASK(hash->bits);  
> 
> As with hash_add(), 'key' should already be masked and I think it'd be
> better to error out loudly if upper bits in 'key' are unexpectedly set.

Again, I don't want to add a dependency of where key was created. It may be
used for other purposes (and the upper bits may hold info later).  I think
it's just more robust to keep the extra masks. Again, they are very fast
operations.

Thanks Ross,

-- Steve

> 
> > +
> > +	iter->current_bucket = key;
> > +	iter->next_item = hash->hash[key];
> > +
> > +	return iter;
> > +}
> > +  

