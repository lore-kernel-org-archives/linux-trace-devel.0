Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ACB2EB64DD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jul 2023 22:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjG1WHi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 18:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjG1WHh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 18:07:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B37E2D73
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 15:07:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1974E6219A
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 22:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541A6C433C7;
        Fri, 28 Jul 2023 22:07:35 +0000 (UTC)
Date:   Fri, 28 Jul 2023 18:07:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH 3/5] histograms: traceeval release
Message-ID: <20230728180733.2720ae8c@rorschach.local.home>
In-Reply-To: <20230728190515.23088-3-stevie.6strings@gmail.com>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
        <20230728190515.23088-3-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 28 Jul 2023 15:04:38 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>
> 
> traceeval_release() deconstructs a given struct traceeval instance. It
> frees any data allocated to the heap within the union traceeval_data
> arrays of entries to the histogram, and the names allocated for the
> struct traceeval_type key-value definitions.
> 
> Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> ---
>  src/histograms.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 85 insertions(+), 2 deletions(-)
> 
> diff --git a/src/histograms.c b/src/histograms.c
> index 13830e4..f46a0e0 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -209,10 +209,93 @@ fail_eval_init_unalloced:
>  	return NULL;
>  }
>  
> -// TODO
> -void traceeval_release(struct traceeval *teval)
> +/**
> + * Deallocate array of traceeval_type's, which must be terminated by
> + * TRACEEVAL_TYPE_NONE.
> + */
> +static void type_release(struct traceeval_type *defs)

So if we keep track of the number of defs, we should just pass in the
size. And ignore the NONE.

>  {
> +	size_t i = 0;
> +
> +	if (!defs)
> +		return;
> +
> +	for_each_key(i, defs) {
> +		if (defs[i].name)
> +			free(defs[i].name);
> +	}
> +
> +	free(defs);
> +}
> +
> +/**
> + * Deallocate any specified dynamic data in @data.
> + */
> +static void clean_data(union traceeval_data *data, struct traceeval_type *def) +{
> +	size_t i = 0;
> +
> +	if (!data || !def)
> +		return;
> +
> +	for_each_key(i, def) {
> +		switch (def[i].type) {
> +		case TRACEEVAL_TYPE_STRING:
> +			if (data[i].string)
> +				free(data[i].string);
> +			break;
> +		case TRACEEVAL_TYPE_DYNAMIC:
> +			def[i].dyn_release(data[i].dyn_data, &def[i]);

Note, it should be OK if the dynamic event does not have a release
function. This should be:

			if (def[i].dyn_release)
				def[i].dyn_release(data[i].dyn_data, &def[i]);

> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +}
>  
> +/**
> + * Deallocate all possible data stored within the entry.

Use the word "Free" and not "Deallocate". This goes for all other
places.

-- Steve

> + */
> +static void clean_entry(struct entry *entry, struct traceeval *teval)
> +{
> +	if (!entry)
> +		return;
> +
> +	// deallocate dynamic traceeval_data
> +	clean_data(entry->keys, teval->def_keys);
> +	clean_data(entry->vals, teval->def_vals);
> +	free(entry->keys);
> +	free(entry->vals);
> +}
> +
> +/**
> + * Deallocate the hist_table allocated to a traceeval instance.
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
> +	free(hist->map);
> +	free(hist);
> +}
> +
> +/**
> + * Deallocate a traceeval instance.
> + */
> +void traceeval_release(struct traceeval *teval)
> +{
> +	if (teval) {
> +		hist_table_release(teval);
> +		type_release(teval->def_keys);
> +		type_release(teval->def_vals);
> +		free(teval);
> +	}
>  }
>  
>  // TODO

