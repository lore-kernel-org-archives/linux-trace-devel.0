Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F680EE49A4
	for <linux-trace-devel@archiver.kernel.org>; Sun, 20 Aug 2023 18:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbjHTSWL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 20 Aug 2023 14:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjHTSWK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 20 Aug 2023 14:22:10 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65DD30D8
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Aug 2023 11:18:08 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-64a8826dde2so15431816d6.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Aug 2023 11:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692555487; x=1693160287;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EvhUm+LJ/lImtWq/1XS7plyubKt88ic6ISjLy5HwDjk=;
        b=Ej/6VjNZ3YiZFY75kW2NT+yNR2KMV8rGMYS995cIeEGvKeJDMBmxd1oXm+e+enDiwK
         D5P4ip4RKvlhczYOWNXI2Mm+xSZ7ObLtR8PpUFVLItpjByHmoBpeelQZShjTGyHnzVNG
         XDVkn0DpPNLC3AATPgrev0Z/RiAyUQKdgNsRM4T8kseaktfAb7xf0RuZuD2idshtdN7r
         Cs2SPsGVDfFNlCIozEGLMKxGUT4bsiwPGRDRxIHKRehqd44MRwK4OmYs13z4olLwTf9F
         Z89q1iGcn35Aq4XsFp3iUlnoMpQmwhtSiygovdxY+Dmj6Ed54d7Mw7wcUgex7zkEuBw1
         2AUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692555487; x=1693160287;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EvhUm+LJ/lImtWq/1XS7plyubKt88ic6ISjLy5HwDjk=;
        b=Y8iqVrJE2VA0q46A4zgE5vdrqnyJzCuNX0SHHK/Y2UAQTmWW1FdVd+SBU2w/BfnKCp
         RCCNpgNj9OBPYcofqw8nMPyLEIiTBfzH+SleCHqU5BlffAJc1s0ZaKErj8o35NmAs4Ic
         zOmGwtXxEJfqw3PltJFj/LNcHA4ebMOJN5mDPWkzhTew2bERNWRMmTLJ6ioLMZkXKwpt
         lsUU6KQrlPeFdlUHxUrPzWeV7fwDWuWUKaHma6deTPUcvbKlc45W6RrL7riLtqYXHqSV
         WnEAAXOTC5nsoTlgQ55eibh9rrRko8+dfuLFFyopQLEWvZEbCUskQ/v3pjZp+dmKXlLJ
         6YDQ==
X-Gm-Message-State: AOJu0YwfjaLPu0g3DLkHI+5y9MJib5SfO7ga1ihuYaeM0NgW3FTbm02C
        tVd8SQobsclo0UtkdDPaIpI=
X-Google-Smtp-Source: AGHT+IFMvMtRGMShF+pG8b36L3SRiBv/VYjDawXmbZSaJhkOmKnZV+qsisTUmGHlIepZht8TtSL0pA==
X-Received: by 2002:a0c:a9d3:0:b0:64a:b025:6a0 with SMTP id c19-20020a0ca9d3000000b0064ab02506a0mr5549619qvb.41.1692555486782;
        Sun, 20 Aug 2023 11:18:06 -0700 (PDT)
Received: from 3xKetch ([2601:180:8300:500::f6b1])
        by smtp.gmail.com with ESMTPSA id d24-20020a0caa18000000b00623839cba8csm1910520qvb.44.2023.08.20.11.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Aug 2023 11:18:06 -0700 (PDT)
Date:   Sun, 20 Aug 2023 14:18:01 -0400
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH 2/9] libtraceeval: Add traceeval_iterator_query()
Message-ID: <20230820181801.GA5956@3xKetch>
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

Nit, 'last entry' made me think you were referring to the *last* entry.
Maybe say previous entry instead?

-- Stevie

> + * @iter: The iterator to retrieve the entry results from
> + * @results: The returned results of the last entry (if exists)
> + *
> + * This returns the @results of the values from the last instance of
> + * traceeval_iterator_next(). It is equivalent of calling:
> + *
> + * traceeval_query_size() with the keys returned by traceeval_iterator_next().
> + *
> + * Except that it will always quickly return the last entry, whereas the
> + * traceeval_query_size() will reset the cached next_entry and do a full
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
