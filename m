Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B569BC001B0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Aug 2023 20:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236726AbjHOU0U (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 16:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236488AbjHOU0A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 16:26:00 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4649110E9
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 13:25:59 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e9e14a558f8ab-34992fd567bso12264185ab.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 13:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692131158; x=1692735958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hvCtYscFpgiRQq6MYihyc3+L5iy3wHOeFzKUw3MqObo=;
        b=13ylnIJXKb796sebY8Fb5Lnj3qYoXT2XFRyzzK+tbiq6zqcU1His2ipO3V9zj7kSiy
         Tvia2gmrRTtBdXo29EEUnkoyY4HPF0/A2eiClh8CttkSSc77mAnW78FC5LNuaPG9qM7Q
         R9pm7cuqY09n9Kiq8EwH2oOGgqUdYibmKK1bEQUpNNlg3xNUt42+hfaNHm7iL787KvX3
         FuaeVSBaGpVAgCEgPVMMCa+7T8jdcJO+A9VORLd6QIdVbs9jy5Wf3/TTuTfv36Oq7td9
         IYIWW2mCwxJi8Y3Uiq7vkH2gUHF76ctoyYUI/SpshIxxuLbjmSy60P1HSUc+rstu49p5
         VRhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692131158; x=1692735958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hvCtYscFpgiRQq6MYihyc3+L5iy3wHOeFzKUw3MqObo=;
        b=bnRwLkm8IDyxudAbh050+UNQQuxhr+ywMYNQ8RWMKShDG78SzdzTZJ+um/uDqmAh+f
         bt4ZYj6xP7d/cO97iC92if8wVZE/o3zeKih649nSoGuitUbaycrIvDPpL7BVzvazlIss
         kUTkTdCOlmr5ES0XswPrFIVRk01DXPF53UBBj6bX3AitQufkIWt1Utk02dch2AC1gH0c
         PI1ThWWEQX3RhU3j/IoUjdprBA/ted3p7Q7PVUYyfzFsXBr2xnwZOp4+E3M48xv+BwpF
         DjYhr2roplP9jSr8VV0sr2qUpwqqBWC+xgCGH/78+PiOHriI+N6nCH6cbRt6Wbiidr2K
         S1Yg==
X-Gm-Message-State: AOJu0YxO/8VCoZIZtKHavcMNRuT9PzZef9TyJ90D72FRWfUJogUQ784P
        7hIxhaagluEG0PHzBbDhxhTRoA==
X-Google-Smtp-Source: AGHT+IEhovam+4kVELpHxrMVe/zAry0MsHMrf+bngIg2B59Lx1nGOPNhJRvdDCpe9HaUEoFGZq23OQ==
X-Received: by 2002:a05:6e02:1aaa:b0:349:8ea:9bd1 with SMTP id l10-20020a056e021aaa00b0034908ea9bd1mr35906ilv.7.1692131158401;
        Tue, 15 Aug 2023 13:25:58 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:f77a:c0d7:f137:55fe])
        by smtp.gmail.com with ESMTPSA id z8-20020a029f08000000b0041fb2506011sm3875690jal.172.2023.08.15.13.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 13:25:57 -0700 (PDT)
Date:   Tue, 15 Aug 2023 14:25:54 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 10/17] libtraceeval histogram: Add updating of stats
Message-ID: <20230815202554.GF780024@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
 <20230811053940.1408424-11-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811053940.1408424-11-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Aug 11, 2023 at 01:39:33AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Whenever an entry is added that already exists (overwriting the values)
> keep track of the stats for the number values (max, min, total, count).
> 
> Also move the stat structure out of the public view. We may want to modify
> this structure in the future, and so it should not become an API.
> 
> Add accessor functions to get to the stat values.
> 
> Add traceeval_stat() to acquire a stat handle from a specific key for a
> specific value.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h |  17 ++--
>  src/eval-local.h         |   9 ++
>  src/histograms.c         | 182 +++++++++++++++++++++++++++++++++++----
>  3 files changed, 183 insertions(+), 25 deletions(-)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index 1c02f3039809..d061a4532b06 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -130,13 +130,7 @@ struct traceeval_type {
>  };
>  
>  /* Statistics about a given entry element */
> -struct traceeval_stat {
> -	unsigned long long	max;
> -	unsigned long long	min;
> -	unsigned long long	total;
> -	unsigned long long	avg;
> -	unsigned long long	std;
> -};
> +struct traceeval_stat;
>  
>  /* Iterator over aggregated data */
>  struct traceeval_iterator;
> @@ -160,4 +154,13 @@ int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
>  void traceeval_results_release(struct traceeval *teval,
>  			       union traceeval_data *results);
>  
> +struct traceeval_stat *traceeval_stat(struct traceeval *teval,
> +				      const union traceeval_data *keys,
> +				      struct traceeval_type *type);
> +
> +unsigned long long traceeval_stat_max(struct traceeval_stat *stat);
> +unsigned long long traceeval_stat_min(struct traceeval_stat *stat);
> +unsigned long long traceeval_stat_total(struct traceeval_stat *stat);
> +unsigned long long traceeval_stat_count(struct traceeval_stat *stat);
> +
>  #endif /* __LIBTRACEEVAL_HIST_H__ */
> diff --git a/src/eval-local.h b/src/eval-local.h
> index 820d7ad096e8..190b19db14d2 100644
> --- a/src/eval-local.h
> +++ b/src/eval-local.h
> @@ -45,11 +45,20 @@ struct hash_table {
>  	struct hash_iter	iter;
>  };
>  
> +struct traceeval_stat {
> +	unsigned long long	max;
> +	unsigned long long	min;
> +	unsigned long long	total;
> +	unsigned long long	std;
> +	size_t			count;
> +};
> +
>  /* A key-value pair */
>  struct entry {
>  	struct hash_item	hash;
>  	union traceeval_data	*keys;
>  	union traceeval_data	*vals;
> +	struct traceeval_stat	*val_stats;

I'm confused about why 'val_stats' is in 'struct entry', instead of in
'struct traceeval'?

I would think that we'd want to keep our stats on a per-histogram basis, where
we have an array of 'struct traceeval_stat' structs with the same size as our
'val_types' array, so that for a given compound value, say 

{ TRACEVAL_TYPE_NUMBER_64, TRACEEVAL_TYPE_NUMBER_16, TRACEEVAL_NUMBER_8}

we'd have stats for each of these entries, like min, max, average, etc.?

With the stats associated with each entry, I don't see how we keep all the
stats for all the entries up to date as we do insertions & removals.
