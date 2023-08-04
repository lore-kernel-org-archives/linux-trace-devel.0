Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE9FC001DF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Aug 2023 14:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjHDOks (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 10:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjHDOkq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 10:40:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA73B49C6
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 07:40:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 506D462042
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 14:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4C2C433C7;
        Fri,  4 Aug 2023 14:40:41 +0000 (UTC)
Date:   Fri, 4 Aug 2023 10:40:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v2 2/5] histograms: Add traceeval initialize
Message-ID: <20230804104039.09c90e85@gandalf.local.home>
In-Reply-To: <20230803225413.40697-3-stevie.6strings@gmail.com>
References: <20230803225413.40697-1-stevie.6strings@gmail.com>
        <20230803225413.40697-3-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  3 Aug 2023 18:54:00 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>
> 
> traceeval_init() creates a new struct traceeval instance with regards
> to the struct traceeval_type array arguments keys and vals. These arrays
> define the structure of the histogram, with each describing the expected
> structure of inserted arrays of union traceeval_data. The keys and vals
> arguments are copied on the heap to ensure that the struct traceeval
> instance has access to the definition regardless of how the user
> initialized keys and vals.
> 
> Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> ---
>  Makefile                 |   2 +-
>  include/traceeval-hist.h |   5 +
>  src/Makefile             |   1 +
>  src/histograms.c         | 223 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 230 insertions(+), 1 deletion(-)
>  create mode 100644 src/histograms.c
> 
> diff --git a/Makefile b/Makefile
> index 4a24d5a..3ea051c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -172,7 +172,7 @@ libs: $(LIBRARY_A) $(LIBRARY_SO)
>  
>  VALGRIND = $(shell which valgrind)
>  UTEST_DIR = utest
> -UTEST_BINARY = trace-utest
> +UTEST_BINARY = eval-utest

This seems like it doesn't belong in this patch.

>  
>  test: force $(LIBRARY_STATIC)
>  ifneq ($(CUNIT_INSTALLED),1)
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index 4664974..5bea025 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -125,4 +125,9 @@ struct traceeval_iterator;
>  
>  struct traceeval;
>  
> +/* Histogram interfaces */
> +
> +struct traceeval *traceeval_init(const struct traceeval_type *keys,
> +		const struct traceeval_type *vals);
> +
>  #endif /* __LIBTRACEEVAL_HIST_H__ */
> diff --git a/src/Makefile b/src/Makefile
> index b4b6e52..b32a389 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -4,6 +4,7 @@ include $(src)/scripts/utils.mk
>  
>  OBJS =
>  OBJS += trace-analysis.o
> +OBJS += histograms.o
>  
>  OBJS := $(OBJS:%.o=$(bdir)/%.o)
>  
> diff --git a/src/histograms.c b/src/histograms.c
> new file mode 100644
> index 0000000..be17b89
> --- /dev/null
> +++ b/src/histograms.c
> @@ -0,0 +1,223 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * libtraceeval histogram interface implementation.
> + *
> + * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
> + */
> +
> +#include <stdbool.h>
> +#include <string.h>
> +#include <stdarg.h>
> +#include <stdio.h>
> +
> +#include <traceeval-hist.h>
> +
> +/* A key-value pair */
> +struct entry {
> +	union traceeval_data	*keys;
> +	union traceeval_data	*vals;
> +};
> +
> +/* A table of key-value entries */
> +struct hist_table {
> +	struct entry	*map;
> +	size_t		nr_entries;
> +};
> +
> +/* Histogram */
> +struct traceeval {
> +	struct traceeval_type		*key_types;
> +	struct traceeval_type		*val_types;
> +	struct hist_table		*hist;
> +	size_t				nr_key_types;
> +	size_t				nr_val_types;
> +};
> +
> +/* Iterate over results of histogram */
> +struct traceeval_iterator {};

Add the traceeval_iterator struct when it is used.

It's not relevant to this patch.

> +
> +/*
> + * print_err() - print an error message
> + * @fmt: String format
> + * @...: (optional) Additional arguments to print in conjunction with @format
> + */
> +static void print_err(const char *fmt, ...)
> +{
> +	va_list ap;
> +
> +	va_start(ap, fmt);
> +	vfprintf(stderr, fmt, ap);
> +	va_end(ap);
> +	fprintf(stderr, "\n");
> +}
> +
> +/*
> + * type_release() - free a struct traceeval_type array
> + * @defs: The array to release
> + * @len: The length of @defs
> + *
> + * It is assumed that all elements of @defs, within the length of @len, have
> + * name fields initialized to valid pointers.
> + *
> + * This function was designed to be used on an array allocated by type_alloc().
> + * Note that type_alloc() initializes all name fields of elements within the
> + * returned size.
> + */
> +static void type_release(struct traceeval_type *defs, size_t len)

You added this but did not add traceeval_release().

traceeval_release() should be added in this patch to clean up everything
that traceeval_init() creates.

> +{
> +	if (!defs)
> +		return;
> +
> +	for (size_t i = 0; i < len; i++) {
> +		free(defs[i].name);
> +	}
> +
> +	free(defs);
> +}
> +
> +/*
> + * type_alloc() - clone a struct traceeval_type array
> + * @defs: The original array
> + * @copy: A pointer to where to place the @defs copy
> + *
> + * Clone traceeval_type array @defs to the heap, and place in @copy.
> + * @defs must be terminated with an instance of type TRACEEVAL_TYPE_NONE.
> + *
> + * The size of the copy pointed to by @copy is returned. It counts all elements
> + * in @defs excluding the terminating TRACEEVAL_TYPE_NONE traceeval_type.
> + * The copy contains everything from @defs excluding the TRACEEVAL_TYPE_NONE
> + * traceeval_type.
> + *
> + * The name field of each element of @defs (except for the terminating
> + * TRACEEVAL_TYPE_NONE) must be a NULL-terminated string. The validity of the
> + * name field is not checked, but errors are returned upon finding unset name
> + * fields and string duplication failures. It is guaranteed that all elements
> + * of the copy within the returned size have valid pointers in their name
> + * fields.
> + *
> + * Returns the size of the array pointed to by @copy, or, if an error occurs,
> + * the negative of the size of what's been allocated so far.
> + * If the return value is negative, the user is responsible for freeing
> + * -1 * return value number of elements from @copy.
> + */
> +static size_t type_alloc(const struct traceeval_type *defs,
> +		struct traceeval_type **copy)
> +{
> +	struct traceeval_type *new_defs = NULL;
> +	size_t size;
> +	size_t i;
> +
> +	if (!defs) {
> +		*copy = NULL;
> +		return 0;
> +	}
> +
> +	for (size = 0; defs && defs[size].type != TRACEEVAL_TYPE_NONE; size++);

For loops like the above, please do:

	for (size = 0; defs && defs[size].type != TRACEEVAL_TYPE_NONE; size++)
		;

This makes it obvious that it's an empty loop and we don't think it's
looping over the line below it.

> +
> +	if (size) {
> +		new_defs = calloc(size, sizeof(*new_defs));
> +	} else {
> +		*copy = NULL;
> +		return 0;
> +	}
> +
> +	for (i = 0; i < size; i++) {
> +		/* copy current def data to new_def */
> +		new_defs[i] = defs[i];
> +
> +		/* copy name to heap, ensures name copied */
> +		if (!defs[i].name)
> +			goto fail_type_name;

No need to be so verbose in the labels.

			goto fail;

is good enough ;-)

> +		new_defs[i].name = strdup(defs[i].name);
> +
> +		if (!new_defs[i].name)
> +			goto fail_type_name;
> +	}
> +
> +	*copy = new_defs;
> +	return size;
> +
> +fail_type_name:
> +	if (defs[size].name)
> +		print_err("failed to allocate name for traceeval_type %s", defs[size].name);
> +	print_err("failed to allocate name for traceeval_type index %zu", size);

I would change the above to:

	if (defs[i].name)
		print_err("Failed to allocate traceveal_type %zu", size);
	else
		print_err("traceeval_type list missing a name");

> +	*copy = new_defs;
> +	return i * -1;

Also, we need to clean up here and not pass that info back to the caller.

// need to make i: ssize_t i;

	for (; i >= 0; i--)
		free(new_defs[i].name);
	free(new_defs);
	*copy = NULL;
	return -1;


> +}
> +
> +/*
> + * traceeval_init - create a traceeval descriptor
> + * @keys: Defines the keys to differentiate traceeval entries
> + * @vals: Defines values attached to entries differentiated by @keys.
> + *
> + * The @keys and @vals define how the traceeval instance will be populated.
> + * The @keys will be used by traceeval_query() to find an instance within
> + * the "histogram". Note, both the @keys and @vals array must end with:
> + * { .type = TRACEEVAL_TYPE_NONE }.
> + *
> + * The @keys and @vals passed in are copied for internal use.
> + *
> + * For any member of @keys or @vals that isn't of type TRACEEVAL_TYPE_NONE,
> + * the name field must be a null-terminated string. For members of type
> + * TRACEEVAL_TYPE_NONE, the name is ignored.
> + *
> + * @vals can be NULL or start with its type field as TRACEEVAL_TYPE_NONE to
> + * define the values of the histogram to be empty.
> + * @keys must be populated with at least one element that is not
> + * TRACEEVAL_TYPE_NONE.
> + *
> + * Returns the descriptor on success, or NULL on error.
> + */
> +struct traceeval *traceeval_init(const struct traceeval_type *keys,
> +				 const struct traceeval_type *vals)
> +{
> +	struct traceeval *teval;
> +	char *err_msg;
> +
> +	if (!keys)
> +		return NULL;
> +
> +	if (keys->type == TRACEEVAL_TYPE_NONE) {
> +		err_msg = "keys cannot start with type TRACEEVAL_TYPE_NONE";

BTW, all the error messages should start with a capital letter.

			"Keys cannot .."

> +		goto fail_init_unalloced;

Just make this: goto fail;

> +	}
> +
> +	/* alloc teval */
> +	teval = calloc(1, sizeof(*teval));
> +	if (!teval) {
> +		err_msg = "failed to allocate memory for traceeval instance";
> +		goto fail_init_unalloced;
> +	}
> +
> +	/* alloc key types */
> +	teval->nr_key_types = type_alloc(keys, &teval->key_types);
> +	if (teval->nr_key_types <= 0) {
> +		teval->nr_key_types *= -1;

Get rid of the above setting.

> +		err_msg = "failed to allocate user defined keys";
> +		goto fail_init;

and this: goto fail_release;

> +	}
> +
> +	/* alloc val types */
> +	teval->nr_val_types = type_alloc(vals, &teval->val_types);
> +	if (teval->nr_val_types < 0) {
> +		teval->nr_val_types *= -1;

And git rid of the above too.

> +		err_msg = "failed to allocate user defined values";
> +		goto fail_init;
> +	}
> +
> +	/* alloc hist */
> +	teval->hist = calloc(1, sizeof(*teval->hist));
> +	if (!teval->hist) {
> +		err_msg = "failed to allocate memory for histogram";
> +		goto fail_init;
> +	}
> +
> +	return teval;
> +
> +fail_init:
> +	traceeval_release(teval);

The above isn't defined. If you reference a function in a patch, it must be
at least defined.

> +
> +fail_init_unalloced:
> +	print_err(err_msg);
> +	return NULL;
> +}

-- Steve
