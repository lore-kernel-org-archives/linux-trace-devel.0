Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293B3C001B0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Aug 2023 19:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239699AbjHOTcY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 15:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239839AbjHOTcF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 15:32:05 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A4E1737
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 12:32:02 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-790fc019c62so136801739f.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 12:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692127922; x=1692732722;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wVEqkBuChM8+L+3I9g8DRH+nGwFZzgx8rub5JmuzUmU=;
        b=p1dvyT++AqoZ5JEb+jCl4GcPTa3jKSB0Vi0/hNUzsHZ7lJ/UtR6w9mpw7BsL5co26O
         wYRRWcqssJnXz4tTJwQnPvY2H183drBhOXtng6nxanaNzYKGjggrNdasflU/19T73EsX
         xYC9UzHWdO0NSgFpLs6oGz2NCGgZQbKr5sX9lTs+HxgSRWZVP2/D9Ljvo3KIhguPGKg6
         CqBTQeUAVG18Cab6KR31YBThvINjZdXJq2Bo6EgWjAr6RbstHE7GIgEOQzOKu20ujm3I
         k/oYbSaSysvsUegSePF0A3J38vMUriTDLsPuENu7MqoDWa6Xme+H1YjCMir47u6clUnS
         ToEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692127922; x=1692732722;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVEqkBuChM8+L+3I9g8DRH+nGwFZzgx8rub5JmuzUmU=;
        b=YdYoVUpF4QWhub6mu/XcI23yAQbmBuA4/QQS7+DDsNxC+XnZY0WgPo1QcatN9AIU1V
         zF+KXN1+M8brgmJ/ZYlKfLGYxRRLSK4fxl7xi4KUBgUwxxZyrJ/mvDPb740wq4xPZ4/M
         ELxwtXKJTtpymkDrPAjhtp+dvx3kO+McTyN4hmZI0FDkwFj53srId3IJK8wPIOyNrtJP
         qYeXfuPpVfAtfsCFSxycXBwVxyeJ79ZElqeaUm8D7puVmY8r6xIbr/+mEo+gRgoJ6sfU
         RKXsRtqk9IGyMB9KesTO6lFH4gm6HH0DbObMeHZi2T5FumoB/TM+dtWtJS56/fi8hzbD
         7YuA==
X-Gm-Message-State: AOJu0Yz5L8cuBTqsvQzGgIFCLScORU1e2DaqI2t10j/FYnOUQzazf7vS
        idy5n01vKECQH9iSatM07aVx7Q==
X-Google-Smtp-Source: AGHT+IFvZBzMln6yrXVFeeXORR7dAKRAvou8bd5Hch1p1daDN7aj3C83r8iyp6VuWK1Fgaea7kjpDA==
X-Received: by 2002:a6b:f30f:0:b0:783:727a:8e15 with SMTP id m15-20020a6bf30f000000b00783727a8e15mr4197475ioh.6.1692127921754;
        Tue, 15 Aug 2023 12:32:01 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:f77a:c0d7:f137:55fe])
        by smtp.gmail.com with ESMTPSA id s15-20020a5e980f000000b00786fe5039b8sm4156405ioj.46.2023.08.15.12.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 12:32:01 -0700 (PDT)
Date:   Tue, 15 Aug 2023 13:31:56 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 08/17] libtraceeval histograms: Move hash functions
 into their own file
Message-ID: <20230815193156.GD780024@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
 <20230811053940.1408424-9-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811053940.1408424-9-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Aug 11, 2023 at 01:39:31AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Move the hash functions into their own file so that it does not clutter
> the histogram.c file. Functionality should be the same, but some code
> restructuring was done.
> 
> To keep the hash abstract, helper functions were introduced:
> 
>   hash_iter_start() - to start iterating over all items in the hash
>   hash_iter_next() - to get the next item in the hash
> 
>   hash_iter_bucket() - to start iterating over a single bucket in the hash
>   hash_iter_bucket_next() - to get the next item in the bucket
> 
>   hash_nr_items() - to get the number of items in the hash
> 
> Also implemented hash_remove() to remove an item from the hash.
> 
> Also created a eval-local.h header file to store the prototypes of the
> local functions as well as moved the structures there too.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  src/Makefile     |   1 +
>  src/eval-local.h | 103 ++++++++++++++++++++++++++++++++++++++
>  src/hash.c       | 119 ++++++++++++++++++++++++++++++++++++++++++++
>  src/histograms.c | 126 +++++++----------------------------------------
>  4 files changed, 240 insertions(+), 109 deletions(-)
>  create mode 100644 src/eval-local.h
>  create mode 100644 src/hash.c

<>

> diff --git a/src/hash.c b/src/hash.c
> new file mode 100644
> index 000000000000..e4f2a983d39c
> --- /dev/null
> +++ b/src/hash.c
> @@ -0,0 +1,119 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * libtraceeval hashtable interface implementation.
> + *
> + * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
> + */
> +
> +#include <traceeval-hist.h>
> +
> +#include "eval-local.h"
> +
> +__hidden struct hash_table *hash_alloc(void)
> +{
> +	struct hash_table *hash;
> +
> +	hash = calloc(1, sizeof(*hash));
> +	if (!hash)
> +		return NULL;
> +
> +	hash->bits = HASH_BITS;
> +	hash->hash = calloc(HASH_SIZE(hash->bits), sizeof(*hash->hash));
> +	if (!hash->hash) {
> +		free(hash);
> +		hash = NULL;
> +	}
> +
> +	return hash;
> +}
> +
> +__hidden void hash_free(struct hash_table *hash)
> +{
> +	free(hash->hash);
> +	free(hash);
> +}
> +
> +__hidden void hash_add(struct hash_table *hash, struct hash_item *item, unsigned key)
> +{
> +	key &= HASH_MASK(hash->bits);

key should already be masked to HASH_MASK(hash->bits) via make_hash().  If
those bits are set, we have a bug somewhere.

I think it's better to check to see if those bits are set and bail out loudly
with an error.

> +
> +	item->next = hash->hash[key];
> +	hash->hash[key] = item;
> +	item->key = key;
> +
> +	hash->nr_items++;
> +}
> +
> +__hidden int hash_remove(struct hash_table *hash, struct hash_item *item)
> +{
> +	struct hash_item **parent;
> +
> +	for (parent = &hash->hash[item->key]; *parent; parent = &(*parent)->next) {
> +		if (*parent == item) {
> +			*parent = item->next;
> +			hash->nr_items--;
> +			return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
> +__hidden struct hash_iter *hash_iter_start(struct hash_table *hash)
> +{
> +	struct hash_iter *iter = &hash->iter;
> +	size_t i;
> +
> +	for (i = 0; i < HASH_SIZE(hash->bits); i++) {
> +		if (!hash->hash[i])
> +			continue;
> +		iter->next_item = hash->hash[i];

I think we need to break here after we've found a populated bucket and set
iter->next_item.  Right now this works only if we have a single populated
bucket, because we'll set iter->next_item once and then keep iterating until
i == HASH_SIZE(hash->bits).

This will mean that iter->current_bucket will always == HASH_SIZE(hash->bits),
but we have a bug in hash_iter_next() that meant we weren't returning early
with NULL when we hit this condition.

> +	}
> +	iter->current_bucket = i;
> +	return iter;
> +}
> +
> +__hidden struct hash_item *hash_iter_next(struct hash_iter *iter)
> +{
> +	struct hash_table *hash = container_of(iter, struct hash_table, iter);
> +	struct hash_item *item;
> +
> +	if (iter->current_bucket > HASH_SIZE(hash->bits))

	if (iter->current_bucket >= HASH_SIZE(hash->bits))

Right now we're missing the exit case where
iter->current_bucket == HASH_SIZE(hash->bits), which means we've run out of
buckets with entries.

> +		return NULL;
> +
> +	item = iter->next_item;
> +
> +	iter->next_item = item->next;
> +	if (!iter->next_item) {
> +		size_t i;
> +
> +		for (i = iter->current_bucket + 1; i < HASH_SIZE(hash->bits); i++) {
> +			if (!hash->hash[i])
> +				continue;
> +			iter->next_item = hash->hash[i];

As in hash_iter_start(), we need to break when we find the next non-empty
bucket and set iter->next_item.  This will let us set iter->current_bucket
correctly as well.

> +		}
> +		iter->current_bucket = i;
> +	}
> +	return item;
> +}
> +
> +__hidden struct hash_iter *hash_iter_bucket(struct hash_table *hash, unsigned key)
> +{
> +	struct hash_iter *iter = &hash->iter;
> +
> +	key &= HASH_MASK(hash->bits);

As with hash_add(), 'key' should already be masked and I think it'd be better
to error out loudly if upper bits in 'key' are unexpectedly set.

> +
> +	iter->current_bucket = key;
> +	iter->next_item = hash->hash[key];
> +
> +	return iter;
> +}
> +
