Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A971C001E0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Aug 2023 21:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjHBVyK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 17:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjHBVyK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 17:54:10 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC03C119
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Aug 2023 14:54:08 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-3492e8fb906so1085085ab.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Aug 2023 14:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691013248; x=1691618048;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EZG2rEJ65dUpOv6iO421kuOWjbSbbajF9utq83Hg15Y=;
        b=GJtybwkwo/fXsj2PLH/O0h4FaLAzPJdI/GT8myWkqsGFXPGJ1kWJATAoISFc5X4H2U
         KCmfT/5/g/TGB2vmFyODNJPwWB30tUcuPfdlPvn6qISo/rCOrcjzujgHJLNh12AKTqlM
         cYG8rnc5pp1VWMpj+TXD7Vt5E0FKm8WkblZTUsmQ0+bHVIGfXJcEFYBRxavUaeK4WUTd
         BXZA37TVDMKF7rP622aWW1lxhIRN4w1SpqmBKV+7VKzE4EoCMyzuMNEW07zxEARVBfza
         W3xspIM+Rbn+LnMK0u+mCcEIfwh9Z9ttItHb2Tu9THbE1dwdIWO8wFxitVEJR850EqBh
         hPvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691013248; x=1691618048;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EZG2rEJ65dUpOv6iO421kuOWjbSbbajF9utq83Hg15Y=;
        b=lyzbGrQ6fLBBc7RXQsuZIGmeH8uqYlFiaGV/QVKYPL/AkylZWZM1TtFtu9XGULee/K
         qiGl4oKVy9ZCmNQiVkcZtRZG906QM4B1is6fxT1rpueGwpzQt4Lgx9tNrj4eAG5DpPIC
         Lxj/+aYD4yhtkjBqECUbMycCW8zphW+k5nc+oPhm1AvD8rjdQ4Gm2QvMMnW+gnvmf1S2
         Ua8kvcNR2JRjqfyxWQVokEvqsUr4KvMoB6VyKG8KYzgW03T/h0VM7CS4//yCqRZzPYVS
         gW8iJz3BaNyLSJfeUnXu3OxAFKHOd1LfMR+PjAb0M1RFcJd/o6Dk+7XVC6Pfz8NepFo0
         saqQ==
X-Gm-Message-State: ABy/qLZ9giB3+O4dJl6aVA/VHwbG0m+gMjXclNfBqOL2JaLM+3jaSNec
        GaRwug93GJjev+hr14b02TtaFsERXgH+F0EtvDPtFw==
X-Google-Smtp-Source: APBJJlGqU4MhEEV3dghZwQjh9h/crjyJHpbHy9K7vGUHh7Vdr44FilucHrW6EcLeSwegRN7EwmoT9A==
X-Received: by 2002:a05:6e02:1748:b0:348:90c2:ba0a with SMTP id y8-20020a056e02174800b0034890c2ba0amr19010745ill.32.1691013248153;
        Wed, 02 Aug 2023 14:54:08 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:ed66:72dd:1728:767d])
        by smtp.gmail.com with ESMTPSA id j12-20020a02cb0c000000b004290985a1efsm4629456jap.43.2023.08.02.14.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 14:54:07 -0700 (PDT)
Date:   Wed, 2 Aug 2023 15:54:03 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/5] histograms: traceeval release
Message-ID: <20230802215403.GC2416079@google.com>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
 <20230728190515.23088-3-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728190515.23088-3-stevie.6strings@gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jul 28, 2023 at 03:04:38PM -0400, Stevie Alvarez wrote:
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
> +static void clean_data(union traceeval_data *data, struct traceeval_type *def)
> +{
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
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +}
>  
> +/**
> + * Deallocate all possible data stored within the entry.
> + */
> +static void clean_entry(struct entry *entry, struct traceeval *teval)
> +{
> +	if (!entry) 

Should we check for NULL 'teval' as well?

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

Probably good to set 'teval->hist = NULL' just for good hygiene.  This keeps
later users from accidentally having a use-after-free.

