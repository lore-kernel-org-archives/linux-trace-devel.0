Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B28EC41513
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Aug 2023 22:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347039AbjHPW5e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 18:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347049AbjHPW5Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 18:57:25 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7455269E
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 15:57:20 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-349974537f5so27437215ab.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 15:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692226640; x=1692831440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qpevKFHO7iv0TMw8ahNuHtnBO5VMehZqNGP6ZVekthg=;
        b=mpjFD0Uv2nXq3C6biQh0my4zW3lDbt9iaQfGYXLvoCB6HX1/QX/gxfSUAtspM6xc1X
         miILPhKH33yMMUYC2751kCgPWsHR4kpAjYmqSiOaxeYgg+3BytUWVVcVsqCzCDbP/OuL
         7a7bWA1ZVNt6yfffRYPhhJAc85m2dwwYSxGuaVTCfIIEKYnIrwcURye4Fa0f3qKg22dJ
         rqLCNq2R4zSRBe4i5vjWA4M3TkxCPuDlR9XwsXkePgnXUyjJnGzR/qcu+s1fGO/J/Q9S
         6CIPwqJJYz9edSNXXRazwyEuwa050gh3eNOGkF4tEY4yr85FtFJV+ivrcp0CutIJeejx
         6q8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692226640; x=1692831440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qpevKFHO7iv0TMw8ahNuHtnBO5VMehZqNGP6ZVekthg=;
        b=PZR5Jd/TpYlfgSm7dRVCQHSW/quiqnCy0JOi009+5uEs1m3oGisJ7a+zzcSMSZMTpF
         7VD1t7/x5s5Oyk7pCyCFxRBllIwsAU2cZT2MEcVRaiJwK5qCMZfTWLiMkb9L9pnDUFRH
         HloY6L/iZKDLW9pfRNOi5i+EVZ8DE7PAU9bdCMALKvXHCRL01Lkbkbl+ywrNf4aBzhof
         QQdzkvgtUTPqAXoVzSkQoGzopGJ4UA3aEZV3pHehVZqdx2uOQ55qpK12FgYHpy/sRDWq
         mtYpUKF+rpmAAprmTCy2joA7EjbiybTCCKWA57MCcX7vnxDQ9V+VJww2ny6yHWXAVxO8
         0REA==
X-Gm-Message-State: AOJu0Yw9GOtmyMipigyevWaDJ0fP1690jYNLvkzh8xHZgMSr9B5bavEf
        HYGO9cYwZEtOFPxzldzfnBeg9RUYDHMWW5Ssh9bQ7Q==
X-Google-Smtp-Source: AGHT+IEbBnq3m0hej/P00pehrey+ZhK574l+VbGQOt/W+qnIC4IFL+zDMffSenLDOw9JQHhPkiXO7g==
X-Received: by 2002:a05:6e02:1201:b0:349:9993:f223 with SMTP id a1-20020a056e02120100b003499993f223mr3992352ilq.23.1692226639860;
        Wed, 16 Aug 2023 15:57:19 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:55c4:49c7:23c3:7d80])
        by smtp.gmail.com with ESMTPSA id a14-20020a92c70e000000b0033e23a5c730sm4869308ilp.88.2023.08.16.15.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 15:57:19 -0700 (PDT)
Date:   Wed, 16 Aug 2023 16:57:16 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 15/17] libtraceeval histogram: Add
 traceeval_iterator_sort_custom()
Message-ID: <20230816225716.GC3686281@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
 <20230811053940.1408424-16-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811053940.1408424-16-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Aug 11, 2023 at 01:39:38AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Add an iterator where the application can supply the sort algorithm where
> it gets the teval descriptor along with the keys and values of both of the
> entries to compare against. Also, allow it to submit its own data to the
> compare function:
> 
> int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
> 				   traceeval_cmp_fn sort_fn, void *data);
> 
> with
> 
> typedef int (*traceeval_cmp_fn)(struct traceeval *teval,
> 				const union traceeval_data *Akeys,
> 				const union traceeval_data *Avals,
> 				const union traceeval_data *Bkeys,
> 				const union traceeval_data *Bvals,
> 				void *data);
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h |  9 +++++++++
>  src/histograms.c         | 34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index 1a24d6117b93..839f63630897 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -86,6 +86,13 @@ typedef int (*traceeval_data_copy_fn)(const struct traceeval_type *type,
>  				      union traceeval_data *copy,
>  				      const union traceeval_data *origin);
>  
> +typedef int (*traceeval_cmp_fn)(struct traceeval *teval,
> +				const union traceeval_data *Akeys,
> +				const union traceeval_data *Avals,
> +				const union traceeval_data *Bkeys,
> +				const union traceeval_data *Bvals,
> +				void *data);
> +
>  /*
>   * struct traceeval_type - Describes the type of a traceevent_data instance
>   * @type: The enum type that describes the traceeval_data
> @@ -172,6 +179,8 @@ struct traceeval_iterator *traceeval_iterator_get(struct traceeval *teval);
>  void traceeval_iterator_put(struct traceeval_iterator *iter);
>  int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_field,
>  			    int level, bool ascending);
> +int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
> +				   traceeval_cmp_fn sort_fn, void *data);
>  int traceeval_iterator_next(struct traceeval_iterator *iter,
>  			    const union traceeval_data **keys);
>  
> diff --git a/src/histograms.c b/src/histograms.c
> index 643a550422f6..33c87644d468 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -1153,6 +1153,40 @@ static int sort_iter(struct traceeval_iterator *iter)
>  	return 0;
>  }
>  
> +struct iter_custom_data {
> +	struct traceeval_iterator *iter;
> +	traceeval_cmp_fn sort_fn;
> +	void *data;
> +};
> +
> +static int iter_custom_cmp(const void *A, const void *B, void *data)
> +{
> +	struct iter_custom_data *cust_data = data;
> +	struct traceeval_iterator *iter = cust_data->iter;
> +	struct traceeval *teval = iter->teval;
> +	const struct entry *a = *((const struct entry **)A);
> +	const struct entry *b = *((const struct entry **)B);
> +
> +	return cust_data->sort_fn(teval, a->keys, a->vals, b->keys, b->vals,
> +				  cust_data->data);
> +}
> +
> +int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
> +				   traceeval_cmp_fn sort_fn, void *data)
> +{
> +	struct iter_custom_data cust_data = {
> +		.iter = iter,
> +		.sort_fn = sort_fn,
> +		.data = data
> +	};
> +
> +	qsort_r(iter->entries, iter->nr_entries, sizeof(*iter->entries),
> +		iter_custom_cmp, &cust_data);

I guess I don't yet see what this gives us over the existing sorting and
iterators?  Does this do the same thing, we just pass in the sort function
instead of calling traceeval_iterator_sort() one or more times?

> +
> +	iter->needs_sort = false;

Also probably need to set
  iter->next = 0;

> +	return 0;
> +}
> +
>  /**
>   * traceeval_iterator_next - retrieve the next entry from an iterator
>   * @iter: The iterator to retrieve the next entry from
> -- 
> 2.40.1
> 
