Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F687C00528
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Aug 2023 21:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbjHBVH3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 17:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjHBVH2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 17:07:28 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5C426B6
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Aug 2023 14:07:27 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-34916d419a3so944545ab.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Aug 2023 14:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691010447; x=1691615247;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZE4v/f5iF+nunaXwGZrLEdK4BEBscEj4OHYFlomFuLk=;
        b=k4EGTbwGFLsMz8mUhGFW8hLG8jqvjqzuIP6GKyqqG63J7WCAt/ZW9mgs+vKGzBm79T
         l8xiZhr673ev098RPttKQf6Ttt6Px1YT9rMhRL5WGZGEangLfkmR6SWNORY8SRuAweih
         iTcHWDmJa1TaGshHwoxj3QO0zB0o56V3vty8SYqyRVprzkK0F4q7hT7kd+6g+w0wmKcK
         1ihgYOcTV0dzlqBoNHh3yyGbjOETi6uF5NeD09Fe/CRXpJPAqlXyuZqzPGAPD+D+kRUR
         OPi47FdzhfPshDRe4e5H/eXQcSbshjNYa0lI1S+7yLDanwNKdzsxZFIjL1d1D0ekwJft
         5rwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691010447; x=1691615247;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZE4v/f5iF+nunaXwGZrLEdK4BEBscEj4OHYFlomFuLk=;
        b=DMVu5H/LDKq6ochynY8BRUok+Vd5yxqC85L6VQy89ZYxrHx5Wy7GBYMUkZvX0fBKbM
         Y9QGZhEmpmzPCmwzwu6K8CPeALmiF8TFKScynFQyWr/VbleAR6crOTOEw6lKAqsn2Ycu
         q55nhXdgfTGpthUMrP8JHWgZr96fM77x+PMMhJnFf1zZP7Am9nm/CamkY7UfoCibqYYE
         0f+FXEnPWVVAnkA85PfEWt6gM5gY4Z7qetK6cZD/jq0DBgE0LckjIlCibeeRBkfdw0S3
         4dbGsD7ocos2C9uWqI32Tz3e2apdDA7dec8RHgAKMjh5Z/TwWW5kcQTbHYTbNx/pfdmT
         vvUw==
X-Gm-Message-State: AOJu0YzsNn1z0y1Q/xYEGMa10vEkaQCkls26DSsJdUJTqVMOinbE7kpZ
        j5lg/i12sj2hMNxbzfIP2alVaa3VNO75h2Rg2LcIIA==
X-Google-Smtp-Source: AGHT+IGmktRNL0Re9Cpwb/6FzmDR3sKEx0/Mf/OIw6t7961B8D8Hpmc8RmxFi0r9qVyBg1L6ruftYg==
X-Received: by 2002:a05:6e02:96c:b0:349:3e92:95df with SMTP id q12-20020a056e02096c00b003493e9295dfmr2029710ilt.9.1691010446599;
        Wed, 02 Aug 2023 14:07:26 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:ed66:72dd:1728:767d])
        by smtp.gmail.com with ESMTPSA id w2-20020a92c882000000b003420dad3121sm4679995ilo.75.2023.08.02.14.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 14:07:26 -0700 (PDT)
Date:   Wed, 2 Aug 2023 15:07:21 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/5] histograms: traceeval initialize
Message-ID: <20230802210721.GB2416079@google.com>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
 <20230728190515.23088-2-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728190515.23088-2-stevie.6strings@gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jul 28, 2023 at 03:04:37PM -0400, Stevie Alvarez wrote:
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
> +
> +/**
> + * Iterate over @keys, which should be an array of struct traceeval_type's,
> + * until reaching an instance of type TRACEEVAL_TYPE_NONE.
> + * @i should be a declared integer type.
> + */
> +#define for_each_key(i, keys)	\
> +	for (i = 0; (keys)[(i)].type != TRACEEVAL_TYPE_NONE; (i)++)
> +
> +/** A key-value pair */
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
> +	struct hist_table		*hist;
> +};

Should this be called something else?  'struct traceeval' is already defined
in src/trace-analysis.c in this same codebase, and the other def is used all
over the place in include/traceeval.h.

> +
> +/** Iterate over results of histogram */
> +struct traceeval_iterator {};  // TODO
> +
> +/**
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
> + * Resize a struct traceeval_type array to a size of @size + 1.
> + *
> + * Returns a pointer to the resized array, or NULL if the provided pointer was
> + * freed to due lack of memory.
> + */
> +static struct traceeval_type *type_realloc(struct traceeval_type *defs,

Probably should have been feedback for patch 1, but 'traceeval_type' also has
a collision.  'struct traceeval_type' is defined in include/histograms.h, and
'enum traceeval_type' is defined in include/libtraceeval.h.

IMO even if the compiler lets us do this, we shouldn't because it'll confuse
cscope/LSMs/grep and people reading the code.

> +		size_t size)
> +{
> +	struct traceeval_type *tmp_defs = NULL;
> +	tmp_defs = realloc(defs,
> +			(size + 1) * sizeof(struct traceeval_type));
> +	if (!tmp_defs)
> +		goto fail_type_realloc;
> +	return tmp_defs;
> +
> +fail_type_realloc:
> +	for (int i = 0; i < size; i++) {
> +		if (defs[i].name)
> +			free(defs[i].name);

Because the extra entries returned by realloc() are uninitialized, I think you
risk trying to free 'name' values that are non-NULL but not real pointers.

Should you instead try to iterate from 0 until you find an entry with type
TRACEEVAL_TYPE_NONE?  Or do you guarantee elsewhere that all 'name' pointers
are either valid or NULL?  If so, it might be good to do that initialization
in this function so the free path makes sense in the same context and so new
users of this function don't violate that assumption.

> +	}
> +	free(defs);
> +	return NULL;
> +}
> +
> +/**
> + * Clone traceeval_type array @defs to the heap. Must be terminated with
> + * an instance of type TRACEEVAL_TYPE_NONE.
> + * Returns NULL if @defs is NULL, or a name is not null terminated.

It actually returns an single entry TRACEEVAL_TYPE_NONE list if @defs is NULL

> + */
> +static struct traceeval_type *type_alloc(const struct traceeval_type *defs)
> +{
> +	struct traceeval_type *new_defs = NULL;
> +	char *name;
> +	size_t size = 0;
> +
> +	// Empty def is represented with single TRACEEVAL_TYPE_NONE
> +	if (defs == NULL) {
> +		if (!(new_defs = calloc(1, sizeof(struct traceeval_type))))
> +			goto fail_type_alloc;
> +		new_defs->type = TRACEEVAL_TYPE_NONE;
> +		return new_defs;
> +	}
> +
> +	for_each_key(size, defs) {
> +		// Resize heap defs and clone
> +		new_defs = type_realloc(new_defs, size);
> +		if (!new_defs)
> +			goto fail_type_alloc;
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
> +
> +	return new_defs;
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

These two error paths do the same actions (no extra frees or anything) and
just differ in text, so they can probably be collapsed into one.

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
> +	if (!teval) {
> +		err_msg = "failed to allocate memory for traceeval instance";
> +		goto fail_eval_init_unalloced;
> +	}
> +
> +	teval->def_keys = type_alloc(keys);
> +	if (!teval->def_keys) {
> +		err_msg = "failed to allocate user defined keys";
> +		goto fail_eval_init;
> +	}
> +
> +	// if vals is NULL, alloc single type NONE
> +	if (vals)
> +		teval->def_vals = type_alloc(vals);
> +	else
> +		teval->def_vals = type_alloc(&type);

Because type_alloc(NULL) returns a single TRACEEVAL_TYPE_NONE entry, you can
collapse these two cases into just 

  teval->def_vals = type_alloc(vals);

and get rid of the 'type' local variable.

> +
> +	if (!teval->def_vals) {
> +		err_msg = "failed to allocate user defined values";
> +		goto fail_eval_init;
> +	}
> +
> +	teval->hist = calloc(1, sizeof(struct hist_table));

nit: Steven mentioned this too, but I think it's better to say
"sizeof(*teval->hist)".  This prevents the types from getting out of sync, say
if for example we changed the type of teval->hist.

You can see examples of this in the kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/params.c#n639
I think this applies to all the places you are doing sizeof(struct X).

> +	if (!teval->hist) {
> +		err_msg = "failed to allocate memory for histogram";
> +		goto fail_eval_init;
> +	}
> +	teval->hist->nr_entries = 0;
> +
> +	return teval;
> +fail_eval_init:
> +	traceeval_release(teval);
> +	/* fall-through */
> +
> +fail_eval_init_unalloced:
> +	print_err(err_msg);
> +	return NULL;
> +}
