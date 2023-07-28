Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034A4EB64DD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jul 2023 22:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjG1WDa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 18:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjG1WD1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 18:03:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022E22D73
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 15:03:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 852A2621D8
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 22:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38C2C433C7;
        Fri, 28 Jul 2023 22:03:23 +0000 (UTC)
Date:   Fri, 28 Jul 2023 18:03:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH 2/5] histograms: traceeval initialize
Message-ID: <20230728180322.3bcc85e0@rorschach.local.home>
In-Reply-To: <20230728190515.23088-2-stevie.6strings@gmail.com>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
        <20230728190515.23088-2-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 28 Jul 2023 15:04:37 -0400
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
>  Makefile         |   2 +-
>  src/Makefile     |   1 +
>  src/histograms.c | 285 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 287 insertions(+), 1 deletion(-)
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
>  
>  test: force $(LIBRARY_STATIC)
>  ifneq ($(CUNIT_INSTALLED),1)
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
> index 0000000..13830e4
> --- /dev/null
> +++ b/src/histograms.c
> @@ -0,0 +1,285 @@
> +
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * libtraceeval histogram interface implementation.
> + *
> + * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
> + */
> +
> +#include <histograms.h>
> +#include <stdio.h>
> +#include <stdbool.h>
> +#include <string.h>
> +#include <stdarg.h>

Nit, I find it cleaner to have an upside down x-mas tree style of
header includes. This is more of a guideline than anything else.

#include <stdbool.h>
#include <string.h>
#include <strarg.h>
#include <stdio.h>

Just looks cleaner.

Oh, and for the header that is specific for this library, that goes
afterward. Sometimes with a space between it and the other includes.

#include <histograms.h>

And since "histograms" is such a generic term, and there may actually
be a library that has that name, let's make it:

#include <traceeval-hist.h>

for now (it may replace the normal one later).


> +
> +/**
> + * Iterate over @keys, which should be an array of struct traceeval_type's,
> + * until reaching an instance of type TRACEEVAL_TYPE_NONE.
> + * @i should be a declared integer type.
> + */
> +#define for_each_key(i, keys)	\
> +	for (i = 0; (keys)[(i)].type != TRACEEVAL_TYPE_NONE; (i)++)

Nit, the brackets in [(i)] make the parenthesis unneeded. That is, [i]
should always work. But I may be wrong ;-) I just can't think of
something that could make it fail.

> +
> +/** A key-value pair */

Again, just use "/* " and not "/** "

> +struct entry {
> +	union traceeval_data	*keys;
> +	union traceeval_data	*vals;
> +};
> +
> +/** A table of key-value entries */
> +struct hist_table {
> +	struct entry	*map;
> +	size_t		nr_entries;
> +};
> +
> +/** Histogram */
> +struct traceeval {
> +	struct traceeval_type		*def_keys;
> +	struct traceeval_type		*def_vals;

The "def" here keeps making me think it's "default" when it is
"defined". Let's call it "key_types" and "val_types".

That will make it much more obvious to what they are.

Also, I think it's a good idea that we keep track of the size. And then
we don't even need to keep the NONE around.

	size_t				nr_key_types;
	size_t				nr_val_types;

> +	struct hist_table		*hist;
> +};
> +
> +/** Iterate over results of histogram */
> +struct traceeval_iterator {};  // TODO

Looking at this series, it's better to not include these TODOs, and
just add the functions in the later patches.

If a function you add calls one of these function, then you can add the
stub functions. But you don't need to add the stubs if nothing is
referencing them.

> +
> +/**

If you use the kerneldoc comment format, do all the real formatting. That is:

/**
 * function_name - one line desrciption
 * @parameter1: Describe parameter 1
 * @parameter2: Describe parameter 2
 *
 * Description of the body.
 *
 * If it returns a value, say what it returns an the end.
 */

> + * Print error message.
> + * Additional arguments are used with respect to fmt.
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
> +// TODO
> +int traceeval_compare(struct traceeval *orig, struct traceeval *copy)
> +{
> +	return -1;
> +}
> +
> +/**

Not, static functions do not need to have the kernel doc layout (unless
you want to write one). They can just be a brief description. But then
use "/* " and not "/** ".

> + * Resize a struct traceeval_type array to a size of @size + 1.
> + *
> + * Returns a pointer to the resized array, or NULL if the provided pointer was
> + * freed to due lack of memory.

I would stress that this frees @defs.

 * Returns the pointer to the resized array or NULL if it failed to
 * allocate. On failure, it will free @defs and its contents.

> + */
> +static struct traceeval_type *type_realloc(struct traceeval_type *defs,
> +		size_t size)
> +{
> +	struct traceeval_type *tmp_defs = NULL;

Do not need to initialize it to NULL if you assign it right afterward.

Add a space between the declarations and the code.

> +	tmp_defs = realloc(defs,
> +			(size + 1) * sizeof(struct traceeval_type));
> +	if (!tmp_defs)
> +		goto fail_type_realloc;
> +	return tmp_defs;

Since there's only one error condition and it's right before the
return, remove the label and just do:

	if (tmp_defs)
		return tmp_defs;

	/* Failure, clean up and free defs */

Although, to be safe, I think we should make sure that the newly
allocated memory is zeroed out.

	if (tmp_defs) {
		memset(&tmp_defs[size], 0, sizeof(tmp_defs[size]));
		return tmp_defs;
	}

> +
> +fail_type_realloc:
> +	for (int i = 0; i < size; i++) {

Just FYI, my personal preference is that I always add the "int i" at
the top of the function. But it has recently been declared in the Linux
kernel community that, declaring iterator variables in loops is now
deemed OK to do (as you did above). So I need to start getting use to
this. In other words, keep the above ;-)

> +		if (defs[i].name)
> +			free(defs[i].name);
> +	}
> +	free(defs);
> +	return NULL;
> +}
> +
> +/**
> + * Clone traceeval_type array @defs to the heap. Must be terminated with
> + * an instance of type TRACEEVAL_TYPE_NONE.
> + * Returns NULL if @defs is NULL, or a name is not null terminated.
> + */
> +static struct traceeval_type *type_alloc(const struct traceeval_type *defs)

Let's change this to:

ssize_t type_alloc(const struct traceeval_type *defs, struct traceeval_type **copy)

and return the number of elements and set copy to the copied types.

> +{
> +	struct traceeval_type *new_defs = NULL;
> +	char *name;
> +	size_t size = 0;

Note, use upside-down x-mas tree format for the above too:

	struct traceeval_type *new_defs = NULL;
	size_t size = 0;
	char *name;

I'm thinking we should just scan the array first to get the size. Then
we don't even need the above realloc. We just allocate once after we
know the size.

Again, we should just ignore the NONE type. No need to copy it.

> +
> +	// Empty def is represented with single TRACEEVAL_TYPE_NONE
> +	if (defs == NULL) {
> +		if (!(new_defs = calloc(1, sizeof(struct traceeval_type))))
> +			goto fail_type_alloc;
> +		new_defs->type = TRACEEVAL_TYPE_NONE;
> +		return new_defs;
> +	}

That is, we can do:

	for (size = 0; defs && defs[size].type != TRACEEVAL_TYE_NONE; size++)
		;

	if (size)
		new_defs = calloc(size, sizeof(*new_defs));

Then do the below loop with;

	for (int i; i < size; i++) {


> +
> +	for_each_key(size, defs) {

I just realized if we keep track of the number of keys/vals, we don't
need the for_each_key() macro.

> +		// Resize heap defs and clone
> +		new_defs = type_realloc(new_defs, size);
> +		if (!new_defs)
> +			goto fail_type_alloc;

So we could get rid of the above realloc.

> +
> +		// copy current def data to new_def
> +		new_defs[size] = defs[size];
> +		new_defs[size].name = NULL;
> +		// copy name to heap if it's not NULL or type NONE
> +		if (defs[size].type != TRACEEVAL_TYPE_NONE) {
> +			name = NULL;
> +			if (!defs[size].name)
> +				goto fail_type_alloc_name;
> +
> +			name = strdup(defs[size].name);
> +			if (!name)
> +				goto fail_type_alloc_name;
> +			new_defs[size].name = name;
> +		}
> +	}
> +
> +	// append array terminator
> +	new_defs = type_realloc(new_defs, size);
> +	if (!new_defs)
> +		goto fail_type_alloc;
> +	new_defs[size].type = TRACEEVAL_TYPE_NONE;

And we can get rid of the above too.

> +
> +	return new_defs;

Add a space between returns and failure labels.

> +fail_type_alloc:
> +	if (defs[size].name)
> +		print_err("failed to allocate memory for traceeval_type %s", defs[size].name);
> +	print_err("failed to allocate memory for traceeval_type index %zu", size);
> +	return NULL;
> +
> +fail_type_alloc_name:
> +	if (defs[size].name)
> +		print_err("failed to allocate name for traceeval_type %s", defs[size].name);
> +
> +	print_err("failed to allocate name for traceeval_type index %zu", size);
> +	return NULL;
> +}
> +
> +/**
> + * Create a new histogram over the given keys and values.
> + */
> +struct traceeval *traceeval_init(const struct traceeval_type *keys,
> +				 const struct traceeval_type *vals)
> +{
> +	struct traceeval *teval;
> +	char *err_msg;
> +	struct traceeval_type type = {
> +		.type = TRACEEVAL_TYPE_NONE
> +	};

Note, the above ordering is fine, as the upside-down x-mas tree format
does not apply to arrays that are defined.

Also, let's change the above to:

	struct traceeval_type none_type[] = {
		{ .type = TRACEEVAL_TYPE_NONE }
	};


Both the name change to "none_type" to be more descriptive of what it
is, and also make it an array so we don't need to pass the address
below. But it's really moot if we decide to not add NONE types.

> +
> +	if (!keys)
> +		return NULL;
> +
> +	if (keys->type == TRACEEVAL_TYPE_NONE) {
> +		err_msg = "keys cannot start with type TRACEEVAL_TYPE_NONE";
> +		goto fail_eval_init_unalloced;
> +	}
> +
> +	teval = calloc(1, sizeof(struct traceeval));

My personal preference is to use the variable for the size. I just find
it to be more robust and less error prone, especially if you
accidentally pick the wrong type.

	teval = calloc(1, sizeof(*teval));

> +	if (!teval) {
> +		err_msg = "failed to allocate memory for traceeval instance";
> +		goto fail_eval_init_unalloced;

BTW, you don't need to make the labels so verbose.

		goto fail_nofree;

would be good enough.

> +	}
> +
> +	teval->def_keys = type_alloc(keys);
> +	if (!teval->def_keys) {
> +		err_msg = "failed to allocate user defined keys";
> +		goto fail_eval_init;

and this just:

		goto fail;

> +	}
> +
> +	// if vals is NULL, alloc single type NONE

BTW, since I follow Linux kernel style, // comments are usually looked
down upon. It's better to use

	/* if vals is NULL then just alloc a single NONE type */

> +	if (vals)
> +		teval->def_vals = type_alloc(vals);
> +	else
> +		teval->def_vals = type_alloc(&type);

		teval->def_vals = type_alloc(none_type);

But here we would really just do:

		teval->nr_val_types = 0;

> +
> +	if (!teval->def_vals) {
> +		err_msg = "failed to allocate user defined values";
> +		goto fail_eval_init;
> +	}
> +
> +	teval->hist = calloc(1, sizeof(struct hist_table));
> +	if (!teval->hist) {
> +		err_msg = "failed to allocate memory for histogram";
> +		goto fail_eval_init;
> +	}
> +	teval->hist->nr_entries = 0;

The calloc() above makes the clearing of nr_entries redundant.

> +
> +	return teval;
> +fail_eval_init:
> +	traceeval_release(teval);
> +	/* fall-through */

This isn't a switch statement, no need for the above comment.

> +
> +fail_eval_init_unalloced:
> +	print_err(err_msg);
> +	return NULL;
> +}

Let's nuke all the below functions for this patch and just add the
functions in the later patches.

-- Steve


> +
> +// TODO
> +void traceeval_release(struct traceeval *teval)
> +{
> +
> +}
> +
> +// TODO
> +int traceeval_insert(struct traceeval *teval,
> +		     const union traceeval_data *keys,
> +		     const union traceeval_data *vals)
> +{
> +	return -1;
> +}
> +
> +// TODO
> +int traceeval_query(struct traceeval *teval,
> +		    const union traceeval_data *keys,
> +		    union traceeval_data * const *results)
> +{
> +	return 0;
> +}
> +
> +// TODO
> +int traceeval_find_key(struct traceeval *teval, const char *field)
> +{
> +	return -1;
> +}
> +
> +// TODO
> +int traceeval_find_val(struct traceeval *teval, const char *field)
> +{
> +	return -1;
> +}
> +
> +// TODO
> +void traceeval_results_release(struct traceeval *teval,
> +			       const union traceeval_data *results)
> +{
> +
> +}
> +
> +// TODO
> +struct traceeval_iterator *traceeval_iterator_get(struct traceeval *teval)
> +{
> +	return NULL;
> +}
> +
> +// TODO
> +int traceeval_iterator_sort(struct traceeval_iterator *iter,
> +			    const char *sort_field, int level, bool ascending)
> +{
> +	return -1;
> +}
> +
> +// TODO
> +int traceeval_iterator_next(struct traceeval_iterator *iter,
> +			    const union traceeval_data **keys)
> +{
> +	return 0;
> +}
> +
> +// TODO
> +void traceeval_keys_release(struct traceeval_iterator *iter,
> +			    const union traceeval_data *keys)
> +{
> +
> +}
> +
> +// TODO
> +int traceeval_stat(struct traceeval *teval, const union traceeval_data *keys,
> +		   const char *field, struct traceeval_stat *stat)
> +{
> +	return -1;
> +}

