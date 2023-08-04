Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5161C001DB
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Aug 2023 15:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbjHDP0O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 11:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjHDPZ5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 11:25:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3AC5253
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 08:25:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F56662076
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 15:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E5AC433C7;
        Fri,  4 Aug 2023 15:24:52 +0000 (UTC)
Date:   Fri, 4 Aug 2023 11:24:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v2 4/5] histograms: Add traceeval compare
Message-ID: <20230804112450.335f711b@gandalf.local.home>
In-Reply-To: <20230803225413.40697-5-stevie.6strings@gmail.com>
References: <20230803225413.40697-1-stevie.6strings@gmail.com>
        <20230803225413.40697-5-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  3 Aug 2023 18:54:02 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>
> 
> traceeval_compare() compares two struct traceeval instances for
> equality. This suite of comparitors was made for testing purposes.
> 
> Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> ---
>  include/traceeval-test.h |  16 +++
>  src/histograms.c         | 221 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 234 insertions(+), 3 deletions(-)
>  create mode 100644 include/traceeval-test.h
> 
> diff --git a/include/traceeval-test.h b/include/traceeval-test.h
> new file mode 100644
> index 0000000..bb8092a
> --- /dev/null
> +++ b/include/traceeval-test.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * libtraceeval interface for unit testing.
> + *
> + * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>

I noticed that you deleted the above line in the next patch, it just
shouldn't be added in this one.

Also, it shouldn't be in the include/ directory, as we don't want to add
this to the system on install.

This is just for testing, let's keep the function in the utest/ directory,
as well as the header file.

Feel free to add a file there to store this.

-- Steve



> + * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
> + */
> +
> +#ifndef __LIBTRACEEVAL_TEST_H__
> +#define __LIBTRACEEVAL_TEST_H__
> +
> +#include <traceeval-hist.h>
> +
> +int traceeval_compare(struct traceeval *orig, struct traceeval *copy);
> +
> +#endif /* __LIBTRACEEVAL_TEST_H__ */
> diff --git a/src/histograms.c b/src/histograms.c
> index 95243b0..8094678 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -11,6 +11,20 @@
>  #include <stdio.h>
>  
>  #include <traceeval-hist.h>
> +#include <traceeval-test.h>
> +
> +/*
> + * Compare two integers of variable length.
> + *
> + * Return 0 if @a and @b are the same, 1 if @a is greater than @b, and -1
> + * if @b is greater than @a.
> + */
> +#define compare_numbers_return(a, b)	\
> +do {					\
> +	if ((a) < (b))			\
> +		return -1;		\
> +	return (a) != (b);		\
> +} while (0)				\
>  
>  /* A key-value pair */
>  struct entry {
> @@ -158,12 +172,13 @@ fail_type_name:
>   * The @keys and @vals passed in are copied for internal use.
>   *
>   * For any member of @keys or @vals that isn't of type TRACEEVAL_TYPE_NONE,
> - * the name field must be a null-terminated string. For members of type
> - * TRACEEVAL_TYPE_NONE, the name is ignored.
> + * the name field must be a null-terminated string. Members of type
> + * TRACEEVAL_TYPE_NONE are used to terminate the array, therefore their other
> + * fields are ignored.
>   *
>   * @vals can be NULL or start with its type field as TRACEEVAL_TYPE_NONE to
>   * define the values of the histogram to be empty.
> - * @keys must be populated with at least one element that is not
> + * @keys must be populated with at least one element that is not of type
>   * TRACEEVAL_TYPE_NONE.
>   *
>   * Returns the descriptor on success, or NULL on error.
> @@ -305,3 +320,203 @@ void traceeval_release(struct traceeval *teval)
>  	teval->val_types = NULL;
>  	free(teval);
>  }
> +
> +/*
> + * Compare traceeval_type instances for equality.
> + *
> + * Return 0 if @orig and @copy are the same, 1 otherwise.
> + */
> +static int compare_traceeval_type(struct traceeval_type *orig,
> +		struct traceeval_type *copy, size_t orig_size, size_t copy_size)
> +{
> +	size_t i;
> +
> +	/* same memory/NULL */
> +	if (orig == copy)
> +		return 0;
> +	if (!!orig != !!copy)
> +		return 1;
> +
> +	if (orig_size != copy_size)
> +		return 1;
> +
> +	for (i = 0; i < orig_size; i++) {
> +		if (orig[i].type != copy[i].type)
> +			return 1;
> +		if (orig[i].flags != copy[i].flags)
> +			return 1;
> +		if (orig[i].id != copy[i].id)
> +			return 1;
> +		if (orig[i].dyn_release != copy[i].dyn_release)
> +			return 1;
> +		if (orig[i].dyn_cmp != copy[i].dyn_cmp)
> +			return 1;
> +
> +		// make sure both names are same type
> +		if (!!orig[i].name != !!copy[i].name)
> +			return 1;
> +		if (!orig[i].name)
> +			continue;
> +		if (strcmp(orig[i].name, copy[i].name) != 0)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Compare traceeval_data instances.
> + *
> + * Return 0 if @orig and @copy are the same, 1 if @orig is greater than @copy,
> + * -1 for the other way around, and -2 on error.
> + */
> +static int compare_traceeval_data(union traceeval_data *orig,
> +		const union traceeval_data *copy, struct traceeval_type *type)
> +{
> +	int i;
> +
> +	if (orig == copy)
> +		return 0;
> +
> +	if (!orig)
> +		return -1;
> +
> +	if (!copy)
> +		return 1;
> +
> +	switch (type->type) {
> +	case TRACEEVAL_TYPE_STRING:
> +		i = strcmp(orig->string, copy->string);
> +		compare_numbers_return(i, 0);
> +
> +	case TRACEEVAL_TYPE_NUMBER:
> +		compare_numbers_return(orig->number, copy->number);
> +
> +	case TRACEEVAL_TYPE_NUMBER_64:
> +		compare_numbers_return(orig->number_64, copy->number_64);
> +
> +	case TRACEEVAL_TYPE_NUMBER_32:
> +		compare_numbers_return(orig->number_32, copy->number_32);
> +
> +	case TRACEEVAL_TYPE_NUMBER_16:
> +		compare_numbers_return(orig->number_16, copy->number_16);
> +
> +	case TRACEEVAL_TYPE_NUMBER_8:
> +		compare_numbers_return(orig->number_8, copy->number_8);
> +
> +	case TRACEEVAL_TYPE_DYNAMIC:
> +		if (type->dyn_cmp)
> +			return type->dyn_cmp(orig->dyn_data, copy->dyn_data, type);
> +		return 0;
> +
> +	default:
> +		print_err("%d is an invalid enum traceeval_data_type member",
> +				type->type);
> +		return -2;
> +	}
> +}
> +
> +/*
> + * Compare arrays of union traceeval_data's with respect to @def.
> + *
> + * Return 0 if @orig and @copy are the same, 1 if not, and -1 on error.
> + */
> +static int compare_traceeval_data_set(union traceeval_data *orig,
> +		const union traceeval_data *copy, struct traceeval_type *defs,
> +		size_t size)
> +{
> +	int check;
> +	size_t i;
> +
> +	/* compare data arrays */
> +	for (i = 0; i < size; i++) {
> +		if ((check = compare_traceeval_data(&orig[i], &copy[i], &defs[i])))
> +			goto fail_c_set;
> +	}
> +
> +	return 0;
> +
> +fail_c_set:
> +	return check == -2 ? -1 : 1;
> +}
> +
> +/*
> + * Return 0 if @orig and @copy are the same, 1 if not, and -1 on error.
> + */
> +static int compare_entries(struct entry *orig, struct entry *copy,
> +		struct traceeval *teval)
> +{
> +	int check;
> +
> +	/* compare keys */
> +	check = compare_traceeval_data_set(orig->keys, copy->keys,
> +			teval->key_types, teval->nr_key_types);
> +	if (check)
> +		return check;
> +
> +	/* compare values */
> +	check = compare_traceeval_data_set(orig->vals, copy->vals,
> +			teval->val_types, teval->nr_val_types);
> +	return check;
> +}
> +
> +/*
> + * Compares the hist fields of @orig and @copy for equality.
> + *
> + * Assumes all other aspects of @orig and @copy are the same.
> + *
> + * Return 0 if struct hist_table of @orig and @copy are the same, 1 if not,
> + * and -1 on error.
> + */
> +static int compare_hist(struct traceeval *orig, struct traceeval *copy)
> +{
> +	struct hist_table *o_hist;
> +	struct hist_table *c_hist;
> +	int c;
> +
> +	o_hist = orig->hist;
> +	c_hist = copy->hist;
> +
> +	if (o_hist->nr_entries != c_hist->nr_entries)
> +		return 1;
> +
> +	for (size_t i = 0; i < o_hist->nr_entries; i++) {
> +		if ((c = compare_entries(&o_hist->map[i], &c_hist->map[i], orig)))
> +			return c;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * traceeval_compare - Check equality between two traceeval instances
> + * @orig: The first traceeval instance
> + * @copy: The second traceeval instance
> + *
> + * This compares the values of the key definitions, value definitions, and
> + * inserted data between @orig and @copy in order. It does not compare
> + * by memory address, except for struct traceeval_type's dyn_release() and
> + * dyn_cmp() fields.
> + *
> + * Returns 0 if @orig and @copy are the same, 1 if not, and -1 on error.
> + */
> + int traceeval_compare(struct traceeval *orig, struct traceeval *copy)
> +{
> +	int keys;
> +	int vals;
> +	int hists;
> +
> +	if (!orig || !copy)
> +		return -1;
> +
> +	keys = compare_traceeval_type(orig->key_types, copy->key_types,
> +			orig->nr_key_types, copy->nr_key_types);
> +	vals = compare_traceeval_type(orig->val_types, copy->val_types,
> +			orig->nr_val_types, copy->nr_val_types);
> +	hists = compare_hist(orig, copy);
> +
> +	if (hists == -1)
> +		return -1;
> +
> +	return keys || vals || hists;
> +}

