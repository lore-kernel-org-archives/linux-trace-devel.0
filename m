Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FFDDC04E69
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 19:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbjHHT6l (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 15:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbjHHT62 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 15:58:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F8B7A0CA
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 11:15:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 525A66297B
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 18:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543B1C433C8;
        Tue,  8 Aug 2023 18:15:51 +0000 (UTC)
Date:   Tue, 8 Aug 2023 14:15:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v3 2/6] histograms: Add traceeval initialize and release
Message-ID: <20230808141548.79eb48b1@gandalf.local.home>
In-Reply-To: <20230808161204.5704-3-stevie.6strings@gmail.com>
References: <20230808161204.5704-1-stevie.6strings@gmail.com>
        <20230808161204.5704-3-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  8 Aug 2023 12:11:55 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> diff --git a/src/histograms.c b/src/histograms.c
> new file mode 100644
> index 0000000..b85d1a8
> --- /dev/null
> +++ b/src/histograms.c
> @@ -0,0 +1,310 @@
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
> +/*
> + * print_err() - print an error message

Nit, for kerneldoc format, you don't need the parenthesis:

 * print_err - print an error message

is the way to write it. Same for the rest.

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
> + * On error, copy is set to point to NULL.
> + *
> + * The name field of each element of @defs (except for the terminating
> + * TRACEEVAL_TYPE_NONE) must be a NULL-terminated string. The validity of the
> + * name field is not checked, but errors are returned upon finding unset name
> + * fields and string duplication failures. It is guaranteed that all elements
> + * of the copy within the returned size have valid pointers in their name
> + * fields.
> + *
> + * Returns the size of the array pointed to by @copy, or -1 on error.
> + */
> +static size_t type_alloc(const struct traceeval_type *defs,
> +			 struct traceeval_type **copy)
> +{
> +	struct traceeval_type *new_defs = NULL;
> +	size_t size;
> +	size_t i;
> +

BTW, for something like this I would just start off with:

	*copy = NULL;

> +	if (!defs) {
> +		*copy = NULL;
> +		return 0;
> +	}

And the above can be:

	if (!defs)
		return 0;

> +
> +	for (size = 0; defs && defs[size].type != TRACEEVAL_TYPE_NONE; size++)
> +		;
> +
> +	if (size) {
> +		new_defs = calloc(size, sizeof(*new_defs));
> +	} else {
> +		*copy = NULL;
> +		return 0;
> +	}

and the above can be:

	if (!size)
		return 0;

	new_defs = calloc(size, sizeof(*new_defs));


> +
> +	for (i = 0; i < size; i++) {
> +		/* copy current def data to new_def */
> +		new_defs[i] = defs[i];
> +
> +		/* copy name to heap, ensures name copied */
> +		if (!defs[i].name)
> +			goto fail;
> +		new_defs[i].name = strdup(defs[i].name);
> +
> +		if (!new_defs[i].name)
> +			goto fail;
> +	}
> +
> +	*copy = new_defs;
> +	return size;
> +
> +fail:
> +	if (defs[i].name)
> +		print_err("Failed to allocate traceeval_type %zu", size);
> +	else
> +		print_err("traceeval_type list missing a name");
> +
> +	for (; i >=0; i--)
> +		free(new_defs[i].name);
> +	free(new_defs);

> +	*copy = NULL;

And no need for the *copy = NULL; as it was done at the beginning.

> +	return -1;
> +}
> +


-- Steve
