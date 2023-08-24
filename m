Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1249C7113B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Aug 2023 19:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243364AbjHXT5c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 15:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243229AbjHXT53 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 15:57:29 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B371BE6
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 12:57:27 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-7926b7f8636so7796339f.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 12:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692907047; x=1693511847;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=daDE7lRgmnU7FWhbEBUvvUe+ITw92MHswzG2Lt3ZSNs=;
        b=254ix0dyD2C8JOMdK9bLWlVB4WeRYWt5LZtgSbGbN2tlPU77euMybrfqgnilgucNE6
         TFxh31paNAUH95ikMLvHJdwWTYHEBiyio7phqW5mFLaAs/CthH7hKZKRY7j39iZsOd2B
         8UCAES5wI+PWge/JllrudL5of7jHO2Yst6V31W42tnOM5ZiDB8dmjReZ+ybjwyT+b2Mn
         k7gQYdXcTySihZAKVOVPQSpXWRarup9ZtsJNX9oXZ00QJhAqJgtxboO8DRyCpTsau0vp
         myJMFtQq9tnFEJ1Kh8q2hPB6MJ8VkXBVmogWFTKIiPKHnUR1hsN+Mj0HpXI+0pP8GYDC
         WVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692907047; x=1693511847;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=daDE7lRgmnU7FWhbEBUvvUe+ITw92MHswzG2Lt3ZSNs=;
        b=izlyKW07mIiNYldaRX9/qa7KNeW6FFshCA/IhvWEgsTED/mljERJWJhlLHfzpuGgyv
         5rYj9eIV3/Uj2Kw+TGiUmtRvsZCUe+Yg/aMWmtmJt5KqCZ7koYHMUk3H4Cu3y8Eso+3k
         lXpFrAzlmaE/u1Wep8OHS+fD8lvTdyEJwDQpIhJwzTBt6ozHAvbTxVIO8MagQsW4uNmI
         CR77OH/gNUJizCMBemQZ4BSIDHe3dFz3a5a8b4miy/aDIzMGvnvM+nCflb3imO97HjXo
         Ecckm1O/E4BGTluaQbO8448ohl8fAxqvMiBnHH9Lh74XpGZaf0sLMS7nS52ZViv2sdwb
         ZnEw==
X-Gm-Message-State: AOJu0YzJjNqYJWkjK8stP2+PH+KGPVhH/nzxsS2M0xfGQXp9GEKF+d5+
        gMLVq6uYkG88MnecOyoviD9lZoN2k5FEvlnWIEWMrA==
X-Google-Smtp-Source: AGHT+IFWbO7SgLR/EBZj4syZ7Tg+2yDQmPul4sSmgH2MiXE/vPxTURbPcMUdtJBI1gciOsNukMjy4A==
X-Received: by 2002:a05:6e02:ec7:b0:349:345b:6580 with SMTP id i7-20020a056e020ec700b00349345b6580mr5548465ilk.10.1692907047128;
        Thu, 24 Aug 2023 12:57:27 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:12f4:1fa1:277e:6e17])
        by smtp.gmail.com with ESMTPSA id o13-20020a92d4cd000000b0034989674ad7sm49976ilm.52.2023.08.24.12.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 12:57:26 -0700 (PDT)
Date:   Thu, 24 Aug 2023 13:57:22 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 2/9] libtraceeval: Add traceeval_iterator_query()
Message-ID: <20230824195722.GB110858@google.com>
References: <20230817222422.118568-1-rostedt@goodmis.org>
 <20230817222422.118568-3-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817222422.118568-3-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Aug 17, 2023 at 06:24:15PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Add a query to the iterator that will return the values of the last entry
> that matches the keys returned by the last call of traceeval_iterator_next().
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h |  2 ++
>  samples/task-eval.c      |  2 +-
>  src/histograms.c         | 30 ++++++++++++++++++++++++++++++
>  3 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index 0cee9bcbeb83..837a74f61a66 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -186,5 +186,7 @@ int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
>  				   traceeval_cmp_fn sort_fn, void *data);
>  int traceeval_iterator_next(struct traceeval_iterator *iter,
>  			    const union traceeval_data **keys);
> +int traceeval_iterator_query(struct traceeval_iterator *iter,
> +			     const union traceeval_data **results);
>  
>  #endif /* __LIBTRACEEVAL_HIST_H__ */
> diff --git a/samples/task-eval.c b/samples/task-eval.c
> index 66d0c40dc0c8..18e07f44e11e 100644
> --- a/samples/task-eval.c
> +++ b/samples/task-eval.c
> @@ -836,7 +836,7 @@ static void display_processes(struct traceeval *teval,
>  		struct process_data *pdata = NULL;
>  		const char *comm = keys[0].cstring;
>  
> -		ret = traceeval_query(teval_data, keys, &results);
> +		ret = traceeval_iterator_query(iter, &results);
>  		if (ret < 0)
>  			pdie("Could not query iterator");
>  		if (ret < 1)
> diff --git a/src/histograms.c b/src/histograms.c
> index 66bdc1769985..4f603ce36c8c 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -1306,3 +1306,33 @@ int traceeval_iterator_next(struct traceeval_iterator *iter,
>  	*keys = entry->keys;
>  	return 1;
>  }
> +
> +/**
> + * traceeval_iterator_query - return the results of the last entry in the iterator
> + * @iter: The iterator to retrieve the entry results from
> + * @results: The returned results of the last entry (if exists)
> + *
> + * This returns the @results of the values from the last instance of
> + * traceeval_iterator_next(). It is equivalent of calling:
> + *
> + * traceeval_query_size() with the keys returned by traceeval_iterator_next().

      traceeval_query()

> + *
> + * Except that it will always quickly return the last entry, whereas the
> + * traceeval_query_size() will reset the cached next_entry and do a full

      traceeval_query()

Aside from these you can add:

Reviewed-by: Ross Zwisler <zwisler@google.com>

I do agree that having a dedicated traceeval_iterator_results_release() would
be nice.

> + * lookup again.
> + *
> + * Returns 1 if another entry is returned, or 0 if not (or negative on error)
> + */
> +int traceeval_iterator_query(struct traceeval_iterator *iter,
> +			     const union traceeval_data **results)
> +{
> +	struct entry *entry;
> +
> +	if (iter->next < 1 || iter->next > iter->nr_entries)
> +		return 0;
> +
> +	entry = iter->entries[iter->next - 1];
> +	*results = entry->vals;
> +
> +	return 1;
> +}
> -- 
> 2.40.1
> 
