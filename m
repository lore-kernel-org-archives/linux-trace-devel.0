Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602BDC5ACA0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 20:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346430AbjHQUMh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354821AbjHQUMN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:12:13 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCDC30DF
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:12:08 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-34ba9d6561aso686245ab.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692303128; x=1692907928;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eaudOPaP5kyW7akpBDYGlcG5z1zM8zBLMXgVUE4eGW4=;
        b=Rz0m2BwszO1puFmxj1hKq2HQ8sPzP3IFY/Sme11EUg3CscBNiTA8YjueKOQaQXoQ5y
         3dk+1IzLG8dshISi7wJfvWmLIXZWoq+Zoo2BlQMpcoCU17hCfPDupuKNTHCNvz7kbkcD
         0CclGO7Sr1E+7GX51GO6UYy7AS0cOZPYe9p8pyWcTV33wj74TCBCk4cm8tgLCGKyFevZ
         hngD0XpYIr2m4xS5JeYH/QfgpnAquEuiHCyjt4rJqX+qX+mAu0go0ypLmZ3PhwSgyKhh
         fcuozFSpxBqEOh4773vN7wIpsmBvb/kba/e6AB9HMBt4+Ao2IVfSueqfUEMQClrEp3OT
         8AQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692303128; x=1692907928;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eaudOPaP5kyW7akpBDYGlcG5z1zM8zBLMXgVUE4eGW4=;
        b=bFIwCMtRLz+agDkrFU7vqMflil2fI0MJB3BKUMuVVOgGuorEKEgnAfDgmZnza4moZe
         w2TQPMLnjYwoiLUQMCxNSeWFRQw9FFOrTjnNb6Z4fWhQZK70j21gupzTFk+Um45bl4sL
         b4cBGhxbk06HGq0ciVSnH6RlSx61kEF7SyN3TTwQAGuPk3r/CPt0YUbOOHBNv+zsoj9Q
         yriS5aoO60IrW0Hz1vp/HX/cRXDCLTjOxZYczyY2wiTcZGkDd0Y3L0t4Ua8zaJC7DHrQ
         TRYS2L/VRPIFQodmskBVd55f0pnipwrTWZoGy1mHjYqwYoWokNAkP+D+5ljhCkGUujqM
         afsg==
X-Gm-Message-State: AOJu0YwvJVVk3bts4hgjU/hUilBXRZ5Wq6+iLkuBFFBQ5JkfR3R8D6bP
        67MF/RUhIicOpBlQ1mBr3B5LKmrvNZtBSSeJDVEsaQ==
X-Google-Smtp-Source: AGHT+IHyzwTxy6MT666DCUyWsbd/s49367WAM4wLN/CJGbM3Ix+tuyk9o0NoWyA3ev/nCJRMP0LKRg==
X-Received: by 2002:a05:6e02:f48:b0:349:849d:bdf7 with SMTP id y8-20020a056e020f4800b00349849dbdf7mr668352ilj.17.1692303127762;
        Thu, 17 Aug 2023 13:12:07 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:b4cc:633b:f35:be2e])
        by smtp.gmail.com with ESMTPSA id s18-20020a92cbd2000000b0034912793df5sm74429ilq.41.2023.08.17.13.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 13:12:07 -0700 (PDT)
Date:   Thu, 17 Aug 2023 14:12:03 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v3 18/18] libtraceeval: Add traceeval_remove()
Message-ID: <20230817201203.GC73817@google.com>
References: <20230817013310.88582-1-rostedt@goodmis.org>
 <20230817013310.88582-19-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817013310.88582-19-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Aug 16, 2023 at 09:33:10PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Add a way to remove an entry that's in the traceeval. Currently there's
> only ways to add entries, but there also needs to be a way to remove them
> too.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h |  3 +++
>  src/histograms.c         | 29 +++++++++++++++++++++++++++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index 37147d626fbb..8e5a6451f399 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -160,6 +160,9 @@ int traceeval_insert(struct traceeval *teval,
>  		     const union traceeval_data *keys,
>  		     const union traceeval_data *vals);
>  
> +int traceeval_remove(struct traceeval *teval,
> +		     const union traceeval_data *keys);
> +
>  int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
>  		    const union traceeval_data **results);
>  
> diff --git a/src/histograms.c b/src/histograms.c
> index c16b8866b84a..f35d1b2e583d 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -934,6 +934,35 @@ int traceeval_insert(struct traceeval *teval,
>  		return update_entry(teval, entry, vals);
>  }
>  
> +/**
> + * traceeval_remove - remove an item from the traceeval descriptor
> + * @teval: The descriptor to insert into
                                remove from

Aside from that one nit you can add:

Reviewed-by: Ross Zwisler <zwisler@google.com>

> + * @keys: The list of keys that defines what is being removed
> + *
> + * This is the opposite of traceeval_insert(). Instead of inserting
> + * an item into the traceeval historgram, it removes it.
> + *
> + * Returns 1 if it found and removed an item,
> + *         0 if it did not find an time matching @keys
> + *        -1 if there was an error.
> + */
> +int traceeval_remove(struct traceeval *teval,
> +		     const union traceeval_data *keys)
> +{
> +	struct hash_table *hist = teval->hist;
> +	struct entry *entry;
> +	int check;
> +
> +	entry = NULL;
> +	check = get_entry(teval, keys, &entry);
> +
> +	if (check < 1)
> +		return check;
> +
> +	hash_remove(hist, &entry->hash);
> +	return 1;
> +}
> +
>  /**
>   * traceeval_iterator_put - release a given iterator
>   * @iter: The iterartor to release
> -- 
> 2.40.1
> 
