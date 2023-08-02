Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58435C04FDF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Aug 2023 21:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbjHBVjT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 17:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbjHBVjS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 17:39:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681681FCF
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Aug 2023 14:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06A7660F8A
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Aug 2023 21:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01098C433C9;
        Wed,  2 Aug 2023 21:39:14 +0000 (UTC)
Date:   Wed, 2 Aug 2023 17:39:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/5] histograms: traceeval initialize
Message-ID: <20230802173913.2de6686d@gandalf.local.home>
In-Reply-To: <20230802210721.GB2416079@google.com>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
        <20230728190515.23088-2-stevie.6strings@gmail.com>
        <20230802210721.GB2416079@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 2 Aug 2023 15:07:21 -0600
Ross Zwisler <zwisler@google.com> wrote:

> > diff --git a/src/histograms.c b/src/histograms.c
> > new file mode 100644
> > index 0000000..13830e4
> > --- /dev/null
> > +++ b/src/histograms.c
> > @@ -0,0 +1,285 @@
> > +
> > +/* SPDX-License-Identifier: MIT */
> > +/*
> > + * libtraceeval histogram interface implementation.
> > + *
> > + * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
> > + */
> > +
> > +#include <histograms.h>
> > +#include <stdio.h>
> > +#include <stdbool.h>
> > +#include <string.h>
> > +#include <stdarg.h>
> > +
> > +/**
> > + * Iterate over @keys, which should be an array of struct traceeval_type's,
> > + * until reaching an instance of type TRACEEVAL_TYPE_NONE.
> > + * @i should be a declared integer type.
> > + */
> > +#define for_each_key(i, keys)	\
> > +	for (i = 0; (keys)[(i)].type != TRACEEVAL_TYPE_NONE; (i)++)
> > +
> > +/** A key-value pair */
> > +struct entry {
> > +	union traceeval_data	*keys;
> > +	union traceeval_data	*vals;
> > +};
> > +
> > +/** A table of key-value entries */
> > +struct hist_table {
> > +	struct entry	*map;
> > +	size_t		nr_entries;
> > +};
> > +
> > +/** Histogram */
> > +struct traceeval {
> > +	struct traceeval_type		*def_keys;
> > +	struct traceeval_type		*def_vals;
> > +	struct hist_table		*hist;
> > +};  
> 
> Should this be called something else?  'struct traceeval' is already defined
> in src/trace-analysis.c in this same codebase, and the other def is used all
> over the place in include/traceeval.h.

Yeah, we could call it something slightly different for now, but the goal
is that it will supersede the struct traceeval in trace-analysis.c, and the
code there will be removed.

We haven't hit version 1.0 yet because I hated the old API and until 1.0 is
reached, the API is allowed to change.

> 
> > +
> > +/** Iterate over results of histogram */
> > +struct traceeval_iterator {};  // TODO
> > +
> > +/**
> > + * Print error message.
> > + * Additional arguments are used with respect to fmt.
> > + */
> > +static void print_err(const char *fmt, ...)
> > +{
> > +	va_list ap;
> > +
> > +	va_start(ap, fmt);
> > +	vfprintf(stderr, fmt, ap);
> > +	va_end(ap);
> > +	fprintf(stderr, "\n");
> > +}
> > +
> > +// TODO
> > +int traceeval_compare(struct traceeval *orig, struct traceeval *copy)
> > +{
> > +	return -1;
> > +}
> > +
> > +/**
> > + * Resize a struct traceeval_type array to a size of @size + 1.
> > + *
> > + * Returns a pointer to the resized array, or NULL if the provided pointer was
> > + * freed to due lack of memory.
> > + */
> > +static struct traceeval_type *type_realloc(struct traceeval_type *defs,  
> 
> Probably should have been feedback for patch 1, but 'traceeval_type' also has
> a collision.  'struct traceeval_type' is defined in include/histograms.h, and
> 'enum traceeval_type' is defined in include/libtraceeval.h.
> 
> IMO even if the compiler lets us do this, we shouldn't because it'll confuse
> cscope/LSMs/grep and people reading the code.

Again, I think it may be fine, as we will eventually remove the old code.


> 
> > +		size_t size)
> > +{
> > +	struct traceeval_type *tmp_defs = NULL;
> > +	tmp_defs = realloc(defs,
> > +			(size + 1) * sizeof(struct traceeval_type));
> > +	if (!tmp_defs)
> > +		goto fail_type_realloc;
> > +	return tmp_defs;
> > +
> > +fail_type_realloc:
> > +	for (int i = 0; i < size; i++) {
> > +		if (defs[i].name)
> > +			free(defs[i].name);  
> 
> Because the extra entries returned by realloc() are uninitialized, I think you
> risk trying to free 'name' values that are non-NULL but not real pointers.
> 
> Should you instead try to iterate from 0 until you find an entry with type
> TRACEEVAL_TYPE_NONE?  Or do you guarantee elsewhere that all 'name' pointers
> are either valid or NULL?  If so, it might be good to do that initialization
> in this function so the free path makes sense in the same context and so new
> users of this function don't violate that assumption.

I believe I mentioned the same thing (or similar) in my reply.

-- Steve

> 
> > +	}
> > +	free(defs);
> > +	return NULL;
> > +}
> > +
> > +/**
> > + * Clone traceeval_type array @defs to the heap. Must be terminated with
> > + * an instance of type TRACEEVAL_TYPE_NONE.
> > + * Returns NULL if @defs is NULL, or a name is not null terminated.  
>
