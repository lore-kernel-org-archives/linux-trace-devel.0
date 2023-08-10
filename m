Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823FDC001B0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Aug 2023 02:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjHJC5I (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 22:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbjHJC5H (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 22:57:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799841702
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 19:57:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09C3C6354C
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 02:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C5FC433C7;
        Thu, 10 Aug 2023 02:57:04 +0000 (UTC)
Date:   Wed, 9 Aug 2023 22:57:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v4 5/5] histograms: Add traceeval insert
Message-ID: <20230809225701.6b7f66f1@gandalf.local.home>
In-Reply-To: <20230809175340.3066-6-stevie.6strings@gmail.com>
References: <20230809175340.3066-1-stevie.6strings@gmail.com>
        <20230809175340.3066-6-stevie.6strings@gmail.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  9 Aug 2023 13:53:38 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> +++ b/src/histograms.c
> @@ -688,3 +688,117 @@ void traceeval_results_release(struct traceeval *teval,
>  
>  	data_release(teval->nr_val_types, &results, teval->val_types);
>  }
> +
> +/*
> + * Create a new entry in @teval with respect to @keys and @vals.
> + *
> + * Returns 0 on success, -1 on error.
> + */
> +static int create_entry(struct traceeval *teval,
> +			const union traceeval_data *keys,
> +			const union traceeval_data *vals)
> +{
> +	union traceeval_data *new_keys;
> +	union traceeval_data *new_vals;
> +	struct entry *tmp_map;
> +	struct hist_table *hist = teval->hist;
> +
> +	/* copy keys */
> +	if (copy_traceeval_data_set(teval->nr_key_types, teval->key_types,
> +				keys, &new_keys) == -1)
> +		return -1;
> +
> +	/* copy vals */
> +	if (copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
> +				vals, &new_vals) == -1)
> +		goto fail_vals;
> +
> +	/* create new entry */
> +	tmp_map = realloc(hist->map, ++hist->nr_entries * sizeof(*tmp_map));

The "++hist->nr_entries" is called a side effect. Where the allocation is
adding more functionality than expected. I try to avoid this even though it
may seem to be clever. One reason is they tend to introduce bugs. For
example, if the allocation fails, the nr_entries now has more entries
then what exists.

I only would update nr_entries on a allocation success.

-- Steve


> +	if (!tmp_map)
> +		goto fail;
> +	tmp_map->keys = new_keys;
> +	tmp_map->vals = new_vals;
> +	hist->map = tmp_map;
> +
> +	return 0;
> +
> +fail:
> +	data_release(teval->nr_val_types, &new_vals, teval->val_types);
> +
> +fail_vals:
> +	data_release(teval->nr_key_types, &new_keys, teval->key_types);
> +	return -1;
> +}
> +
