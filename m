Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F1DDC001DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 20:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbjHHUeL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 16:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbjHHUd7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 16:33:59 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A159E6A74
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 12:59:34 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-791071b9a5eso134278539f.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Aug 2023 12:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691524774; x=1692129574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m/ckBVYaHcSo/NEADut9hM7eOxuo2hXEqccouwG5cOk=;
        b=l3H6m/Q8gOpGmvLfLW6oiNBpzsTG5hR4+i4p7s8AXtaXIFbLiSUXA84wQDhmurU07k
         PoSNKkgsX7NDHOEJ1n2BOHUZ9fftVxabjcYuJWQld31Xr5itFARz1dM9hGOlHRhTpAYy
         jTISpuQwwmp+Hc3V8Lp+sM8bif/ybId+GeZ9sE3Snxpve9WtqaWEMGk+MOvQSs2XeuZc
         hGiA0rBGjg9FDS6PKWidxUT0RACoMoxgwDDEn9sVLZXzpki7IVGXRAEpHgMteiPjxGSs
         HSsLbOmhmpmlbLK5wRY6G/6fvkN7FVqteUyJPHVF3iFLjPrXmYttGTyxujUJMBWt1aBy
         UKPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691524774; x=1692129574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m/ckBVYaHcSo/NEADut9hM7eOxuo2hXEqccouwG5cOk=;
        b=BsPta0i9DYys1Wqf6azG4uBvoe7tOrZhGJX114h6L2oW5Cb+bV9ALjT8c607++VRAk
         N7ck1PqE2mn7X0Cd4XBGER0j/ziucBXPTonV0/7EfKaJ2PBV6BeAqvxQz1y/tpnVIhxs
         pU5SmwsSY+KEF0APIsgRy6hS4VBQQXRFcd77qg1mKix7btYQySXg64ITEe7OI+LP8tZw
         6JohH1wQpsNbRiZjv0MqAA+803YBIBee6qseufQbOfOmuZr+p4vFZoMl5P1Q9roNVbdb
         8A5szlNyWTHXtRCP0wlEyHNCgaxKtXvY9RqiEzHTT8clc2KZ727xwKr+VYLvwQ7AqlEW
         lrlg==
X-Gm-Message-State: AOJu0Yw6fxSJwOaz1m0Ryztvos58s9pPfQYqG1RcYGXa/WFApeEV17Jk
        6+8O1wF+GLYPNfpMDTcfB2U92Z0lWk1xMKB8JiMiXQ==
X-Google-Smtp-Source: AGHT+IE9hAIqGEXXh94C6XCtjfO2ksxFkFdh19EkBShd1Q3xBvS6Ni1WZanU5lekfdfScYuWs+Pw0Q==
X-Received: by 2002:a6b:e210:0:b0:787:ff98:c38c with SMTP id z16-20020a6be210000000b00787ff98c38cmr757866ioc.10.1691524773833;
        Tue, 08 Aug 2023 12:59:33 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:6bcd:e67:26f3:b49f])
        by smtp.gmail.com with ESMTPSA id y19-20020a5ec813000000b0077a1b6f73b9sm3792130iol.41.2023.08.08.12.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 12:59:33 -0700 (PDT)
Date:   Tue, 8 Aug 2023 13:59:27 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 5/6] histograms: Add traceeval insert
Message-ID: <20230808195927.GA755218@google.com>
References: <20230808161204.5704-1-stevie.6strings@gmail.com>
 <20230808161204.5704-6-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808161204.5704-6-stevie.6strings@gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Aug 08, 2023 at 12:11:58PM -0400, Stevie Alvarez wrote:
> From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> 
> traceeval_insert() updates the provided struct traceeval's histogram.
> If an entry that exists with a keys field that match the keys argument,
> the entries vals field are updated with a copy of the vals argument.
> If such an entry does not exist, a new entry is added to the histogram,
> with respect to the keys and vals arguments.
> 
> Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> ---
>  include/traceeval-hist.h |   4 ++
>  src/histograms.c         | 106 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 110 insertions(+)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index 4923de1..e713c70 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -134,6 +134,10 @@ struct traceeval *traceeval_init(const struct traceeval_type *keys,
>  
>  void traceeval_release(struct traceeval *teval);
>  
> +int traceeval_insert(struct traceeval *teval,
> +		     const union traceeval_data *keys,
> +		     const union traceeval_data *vals);
> +
>  int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
>  		    union traceeval_data **results);
>  
> diff --git a/src/histograms.c b/src/histograms.c
> index 47ff175..a59542a 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -684,3 +684,109 @@ void traceeval_results_release(struct traceeval *teval,
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
> +/*
> + * Update @entry's vals field with a copy of @vals, with respect to @teval.
> + *
> + * Return 0 on success, -1 on error.
> + */
> +static int update_entry(struct traceeval *teval, struct entry *entry,
> +			const union traceeval_data *vals)
> +{
> +	union traceeval_data *new_vals;
> +
> +	if (copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
> +				vals, &new_vals) == -1)
> +		return -1;
> +
> +	entry->vals = new_vals;

Are we leaking the old 'entry->vals', as we never free that memory anywhere? 

Should we just update in-place, instead of allocating a new one & freeing the
old?  The vals arrays should each be the same size because they have a
common 'teval->val_types'. 

I know 'vals' is owned by the caller, but we allocated and own 'entry->vals'
via a previous call to create_entry().

We'll have to free existing strings & allocate new ones (and do something
similar for dynamic types when they're supported), but the rest of
'entry->vals' should be reusable I think.

> +	return 0;
> +}
> +
> +/*
> + * traceeval_insert - insert an item into the traceeval descriptor
> + * @teval: The descriptor to insert into
> + * @keys: The list of keys that defines what is being inserted.
> + * @vals: The list of values that defines what is being inserted.
> + *
> + * The @keys is an array that holds the data in the order of the keys
> + * passed into traceeval_init(). That is, if traceeval_init() had
> + * keys = { { .type = TRACEEVAL_STRING }, { .type = TRACEEVAL_NUMBER_8 },
> + * { .type = TRACEEVAL_NONE } }; then the @keys array passed in must
> + * be a string (char *) followed by a 8 byte number (char).
> + *
> + * The @keys and @vals are only examined to where it expects data. That is,
> + * if the traceeval_init() keys had 3 items where the first two was defining
> + * data, and the last one was the TRACEEVAL_TYPE_NONE, then the @keys
> + * here only needs to be an array of 2, inserting the two items defined
> + * by traceeval_init(). The same goes for @vals.
> + *
> + * For all elements of @keys and @vals that correspond to a struct
> + * traceeval_type of type TRACEEVAL_TYPE_STRING, the string field must be set
> + * a valid pointer or NULL.
> + *
> + * On error, @teval is left unchanged.
> + *
> + * Returns 0 on success, and -1 on error.
> + */
> +int traceeval_insert(struct traceeval *teval,
> +		     const union traceeval_data *keys,
> +		     const union traceeval_data *vals)
> +{
> +	struct entry *entry;
> +	int check;
> +
> +	entry = NULL;
> +	check = get_entry(teval, keys, &entry);
> +
> +	if (check == -1)
> +		return check;
> +
> +	/* insert key-value pair */
> +	if (check)
> +		return create_entry(teval, keys, vals);
> +	else
> +		return update_entry(teval, entry, vals);
> +}
> -- 
> 2.41.0
> 
