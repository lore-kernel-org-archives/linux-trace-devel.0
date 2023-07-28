Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D37AEB64DD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jul 2023 22:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjG1WZc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 18:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjG1WZb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 18:25:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6084B448A
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 15:25:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E94CD6220B
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 22:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215C2C433C8;
        Fri, 28 Jul 2023 22:25:29 +0000 (UTC)
Date:   Fri, 28 Jul 2023 18:25:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH 4/5] histograms: traceeval compare
Message-ID: <20230728182527.4713014a@rorschach.local.home>
In-Reply-To: <20230728190515.23088-4-stevie.6strings@gmail.com>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
        <20230728190515.23088-4-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 28 Jul 2023 15:04:39 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:
> +/**
> + * Return 0 if @orig and @copy are the same, 1 otherwise.
> + */
> +static int compare_traceeval_type(struct traceeval_type *orig,
> +		struct traceeval_type *copy)
> +{
> +	int o_name_null;
> +	int c_name_null;
> +
> +	// same memory/null
> +	if (orig == copy)
> +		return 0;

You say memory/null, so I'm assuming one can be NULL. Then you need to add;

	if (!!orig != !!copy)
		return 1;

Little C trick above ;-)

> +
> +	size_t i = 0;
> +	do {
> +		if (orig[i].type != copy[i].type)
> +			return 1;
> +		if (orig[i].type == TRACEEVAL_TYPE_NONE)
> +			return 0;
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
> +		o_name_null = !orig[i].name;
> +		c_name_null = !copy[i].name;
> +		if (o_name_null != c_name_null)
> +			return 1;
> +		if (o_name_null)
> +			continue;

You can replace the above with:

		if (!!orig[i].name != !!copy[i].name)
			return 1;
		if (!orig[i].name)
			continue;

And get rid of the o_name_null and c_name_null variables.

> +		if (strcmp(orig[i].name, copy[i].name) != 0)
> +			return 1;
> +	} while (orig[i++].type != TRACEEVAL_TYPE_NONE);
> +
> +	return 0;
> +}
> +
> +/**
> + * Return 0 if @orig and @copy are the same, 1 if @orig is greater than @copy,
> + * -1 for the other way around, and -2 on error.
> + */
> +static int compare_traceeval_data(union traceeval_data *orig,
> +		const union traceeval_data *copy, struct traceeval_type *type)
> +{
> +	if (!orig || !copy)
> +		return 1;

So if either is NULL then you return 1?

> +
> +	switch (type->type) {
> +	case TRACEEVAL_TYPE_NONE:
> +		/* There is no corresponding traceeval_data for TRACEEVAL_TYPE_NONE */
> +		return -2;
> +
> +	case TRACEEVAL_TYPE_STRING:
> +		int i = strcmp(orig->string, copy->string);

I do prefer the "int i" above for this case.


> +		if (!i)
> +			return 0;
> +		if (i > 0)
> +			return 1;
> +		return -1;

Again, the above can be replaced with:

		if (i < 0)
			return -1;

		return i > 0;
or even:
		return !!i;


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
> +		return type->dyn_cmp(orig->dyn_data, copy->dyn_data, type);
> +
> +	default:
> +		print_err("%d is out of range of enum traceeval_data_type", type->type);
> +		return -2;
> +	}
> +}
> +
> +/**
> + * Compare arrays fo union traceeval_data's with respect to @def.

   "fo"?

> + *
> + * Return 0 if @orig and @copy are the same, 1 if not, and -1 on error.
> + */
> +static int compare_traceeval_data_set(union traceeval_data *orig,
> +		const union traceeval_data *copy, struct traceeval_type *def)
> +{
> +	int i = 0;
> +	int check;
> +
> +	// compare data arrays
> +	for_each_key(i, def) {
> +		if ((check = compare_traceeval_data(&orig[i], &copy[i], &def[i])))
> +			goto fail_compare_data_set;

Let's make the labels less verbose.

> +	}
> +
> +	return 0;
> +fail_compare_data_set:
> +	if (check == -2)
> +		return -1;
> +	return 1;

	return check == -2 ? -1; 1;

> +}
> +
> +/**
> + * Return 0 if @orig and @copy are the same, 1 if not, and -1 on error.
> + */
> +static int compare_entries(struct entry *orig, struct entry *copy,
> +		struct traceeval *teval)
> +{
> +	int check;
> +
> +	// compare keys
> +	check = compare_traceeval_data_set(orig->keys, copy->keys,
> +			teval->def_keys);
> +	if (check)
> +		return check;
> +
> +	// compare values
> +	check = compare_traceeval_data_set(orig->vals, copy->vals,
> +			teval->def_vals);
> +	return check;
> +}
> +
> +/**
> + * Return 0 if struct hist_table of @orig and @copy are the same, 1 if not,
> + * and -1 on error.
> + */
> +static int compare_hist(struct traceeval *orig, struct traceeval *copy)
> +{
> +	struct hist_table *o_hist = orig->hist;
> +	struct hist_table *c_hist = copy->hist;
> +	int cnt = !(o_hist->nr_entries == c_hist->nr_entries);

Add space between declarations and code.

> +	if (cnt)
> +		return 1;

Why the cnt variable?

	if (o_hist->nr_entries != c_hist->nr_entries)
		return 1;

> +
> +	for (size_t i = 0; i < o_hist->nr_entries; i++) {
> +		// cmp each entry

The above comment is as useful as: /* add one to x */ x++;

No need for it.

> +		compare_entries(&o_hist->map[i], &c_hist->map[i], orig);
> +	}
> +	return 0;	

White space attached to the end of the above line.

If you do a git show of each of your commits, it should show you white
space errors like that with a block red color.

> +}
> +
> +/**
> + * Return 0 if @orig and @copy are the same, 1 if not, -1 if error.
> + */
>  int traceeval_compare(struct traceeval *orig, struct traceeval *copy)
>  {
> -	return -1;
> +	if ((!orig) || (!copy))
> +		return -1;
> +
> +	int keys = compare_traceeval_type(orig->def_keys, copy->def_keys);
> +	int vals = compare_traceeval_type(orig->def_vals, copy->def_vals);
> +	int hists = compare_hist(orig, copy);

First, you need to add the above as declarations. Following Linux
kernel styling, only variables for "for" loops may be declared locally
like that. Otherwise, we prefer old style C.

Also, can't any of the above return an error? The below doesn't catch
that.

	if (keys < 0 || vals < 0 || hists < 0)
		return -1;

 ?

> +
> +	return (keys || vals || hists);

return is not a function. No need for the parenthesis.

	return keys || vals || hists;

>  }
>  
>  /**

-- Steve
