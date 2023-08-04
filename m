Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410C7C04A6A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Aug 2023 14:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjHDOzU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 10:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjHDOzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 10:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B62AC
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 07:55:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA3B86203C
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 14:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F38C433C7;
        Fri,  4 Aug 2023 14:55:17 +0000 (UTC)
Date:   Fri, 4 Aug 2023 10:55:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v2 3/5] histograms: Add traceeval release
Message-ID: <20230804105516.6b1364ee@gandalf.local.home>
In-Reply-To: <20230803225413.40697-4-stevie.6strings@gmail.com>
References: <20230803225413.40697-1-stevie.6strings@gmail.com>
        <20230803225413.40697-4-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  3 Aug 2023 18:54:01 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>
> 
> traceeval_release() deconstructs a given struct traceeval instance. It
> frees any data allocated to the heap within the entries to the histogram,
> and the names allocated for the struct traceeval_type key-value
> definitions.
> 

As this is referenced in the first patch, please fold this patch into the
first one. It's fine to add both the init and the releaese (alloc and free)
functions in one patch. In fact, they should be together because those
functions are tightly coupled.


The idea is that every patch should do "one thing", but an alloc should
always be accompanied by a free. As a whole, it's "one thing", and OK to be
in one patch/commit.

It also makes it easier to review. When they are separate patches, I can't
go and look to see if something allocated was later freed. Having them as
two patches makes it more likely to introduce an error.

> Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> ---
>  include/traceeval-hist.h |  2 +
>  src/histograms.c         | 84 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 86 insertions(+)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index 5bea025..cd74d3e 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -130,4 +130,6 @@ struct traceeval;
>  struct traceeval *traceeval_init(const struct traceeval_type *keys,
>  		const struct traceeval_type *vals);
>  
> +void traceeval_release(struct traceeval *teval);
> +
>  #endif /* __LIBTRACEEVAL_HIST_H__ */
> diff --git a/src/histograms.c b/src/histograms.c
> index be17b89..95243b0 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -221,3 +221,87 @@ fail_init_unalloced:
>  	print_err(err_msg);
>  	return NULL;
>  }
> +
> +/*
> + * Free any specified dynamic data in @data.
> + */
> +static void clean_data(union traceeval_data *data, struct traceeval_type *defs,
> +		size_t size)
> +{
> +	size_t i;
> +
> +	if (!data || !defs)
> +		return;

Perhaps the above should have:

	if (!data || !defs) {
		if (data)
			print_err("Data to be freed without accompanied types!");
	}


> +
> +	for (i = 0; i < size; i++) {
> +		switch (defs[i].type) {
> +		case TRACEEVAL_TYPE_STRING:
> +			free(data[i].string);
> +			break;
> +		case TRACEEVAL_TYPE_DYNAMIC:
> +			if (defs[i].dyn_release)
> +				defs[i].dyn_release(data[i].dyn_data, &defs[i]);

I just realized, you should make the release function define as:

typedef void (*traceeval_dyn_release_fn)(struct traceeval_type *,
					 struct traceeval_dynamic *);

As the function is really a method of the struct typeeval_type. And the
usually way is to have the "this" pointer as the first parameter of the
method function. The traceeval_type is the "this" in this case.

Also, for all functions, the parameters should line up with the open
parenthesis.

Instead of:

static size_t type_alloc(const struct traceeval_type *defs,
		struct traceeval_type **copy)

It should always be:

static size_t type_alloc(const struct traceeval_type *defs,
			 struct traceeval_type **copy)


See how easier it is to read the function name, and differentiate it from
the parameters.

Same for the typedef (notice how I lined it up above?). It makes it easier
to see what the name of the function type is.

-- Steve




> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +}
> +
> +/*
> + * Free all possible data stored within the entry.
> + */
> +static void clean_entry(struct entry *entry, struct traceeval *teval)
> +{
> +	if (!entry)
> +		return;
> +
> +	/* free dynamic traceeval_data */
> +	clean_data(entry->keys, teval->key_types, teval->nr_key_types);
> +	clean_data(entry->vals, teval->val_types, teval->nr_val_types);
> +	free(entry->keys);
> +	free(entry->vals);
> +}
> +
> +/*
> + * Free the hist_table allocated to a traceeval instance.
> + */
> +static void hist_table_release(struct traceeval *teval)
> +{
> +	struct hist_table *hist = teval->hist;
> +
> +	if (!hist)
> +		return;
> +
> +	for (size_t i = 0; i < hist->nr_entries; i++) {
> +		clean_entry(&hist->map[i], teval);
> +	}
> +
> +	free(hist->map);
> +	free(hist);
> +	teval->hist = NULL;
> +}
> +
> +/*
> + * traceeval_release - release a traceeval descriptor
> + * @teval: An instance of traceeval returned by traceeval_init()
> + *
> + * When the caller of traceeval_init() is done with the returned @teval,
> + * it must call traceeval_release().
> + *
> + * This frees all internally allocated data of @teval and will call the
> + * corresponding dyn_release() functions registered for keys and values of
> + * type TRACEEVAL_TYPE_DYNAMIC.
> + */
> +void traceeval_release(struct traceeval *teval)
> +{
> +	if (!teval)
> +		return;
> +
> +	hist_table_release(teval);
> +	type_release(teval->key_types, teval->nr_key_types);
> +	type_release(teval->val_types, teval->nr_val_types);
> +	teval->key_types = NULL;
> +	teval->val_types = NULL;
> +	free(teval);
> +}

