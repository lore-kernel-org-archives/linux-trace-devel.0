Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DA3C7113B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Aug 2023 21:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243740AbjHXVhg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 17:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243699AbjHXVhF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 17:37:05 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E0FE4B
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 14:37:04 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-34b4b2608e3so1074555ab.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 14:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692913023; x=1693517823;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/79ZTEiqBEklNnFQLaNbZjyODnu4hN3ncmd4EwjGhI=;
        b=DB9Teu1JAbL1dUwEcRT9yprtWf5Ai8fXauACcXtcCavyJx2VOU9YW/SRR5OW2vOKvC
         O+LnUSntn2GIx9C0Xs/jHNftirtHFucyN7Q1aU93dmPNaoZG/DmVCKodZpL9V1FFWfEt
         GJtZQxJReUwLU9U5FKXgJcBga4kvMBNF+Nt02kE1sK0+66eKzO2ROvIszKXNBiAQjOja
         6AWU5cUhOign0i2/PHXz7rRtZ/l53oAwT2HGtfjtjbYeEMla78Wv9Ipql1HqI/kzZscj
         sT1stFg9hb2rS1eKc8fF9m1bY13idWsae6IE82YWAm8baj/44UgYv3VhH48wyZl8t/ad
         8dKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692913023; x=1693517823;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z/79ZTEiqBEklNnFQLaNbZjyODnu4hN3ncmd4EwjGhI=;
        b=fPwHaiZ9GWmtLgm8pTgqWcpmmqgw3JsTQRN1Di6mVCXLTP6p9l97kp1lX9EwT4wWCS
         TUKYGRmzobfKC4Fq0eHFBIjoa/m/eUz1Mhc23jpGmYg7ZSSEAr2lx4jf/BEJyyp6cltF
         oXX6u/vIIrcAt+vmYXI6kaJxTpD6VAcIc7GH7sKk2SQq/jz4+NfOi2Kcz0fT1BUbSjva
         BrSqRpWMVq/qxQT3SceUtSzkarNLNfCW6D2AZFbi9HO38LR7WW9ItctQvCzUhGHFLJ4q
         FnEqGxZpqON/rdeerK2ZfgT+CQzOXmfbRvIJSZjCfxFwylFw9O7Gi1wUIgyFMAVqS4wM
         EjRw==
X-Gm-Message-State: AOJu0YynPhY6q9OipK+DU3+Smr7y2OlZM1jrkR8Q4Nz9LzQBnE8KdQKi
        y9uj9UPtRXW0Grxsebcj2AgUHQ==
X-Google-Smtp-Source: AGHT+IFNhauBc9zkkWV6BfCKz2/cKv+42gkqDU4EYKy7f54aW7CfwDAnMhXaJMpgiy87kiVi4Xf0VQ==
X-Received: by 2002:a05:6e02:1b8a:b0:348:999b:2c44 with SMTP id h10-20020a056e021b8a00b00348999b2c44mr8594021ili.26.1692913023369;
        Thu, 24 Aug 2023 14:37:03 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:12f4:1fa1:277e:6e17])
        by smtp.gmail.com with ESMTPSA id ft18-20020a056638661200b004311d1cdef1sm98022jab.169.2023.08.24.14.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 14:37:02 -0700 (PDT)
Date:   Thu, 24 Aug 2023 15:36:58 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 8/9] libtraceeval: Add checks to traceeval_insert() and
 query()
Message-ID: <20230824213658.GA159078@google.com>
References: <20230817222422.118568-1-rostedt@goodmis.org>
 <20230817222422.118568-9-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817222422.118568-9-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Aug 17, 2023 at 06:24:21PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Now that there are size functions for traceeval_insert() and
> traceveal_query(), add checks to make sure that the size being passed in
> is actually the size expected.

This looks fine, but I think it should be squashed with the previous commit so
we pass in the size and check it in the same patch.

Reviewed-by: Ross Zwisler <zwisler@google.com>

> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  src/histograms.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/src/histograms.c b/src/histograms.c
> index 5e2e9200cbf6..973bf3ad279c 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -684,6 +684,9 @@ int traceeval_query_size(struct traceeval *teval, const struct traceeval_data *k
>  	if (!teval || !keys || !results)
>  		return -1;
>  
> +	if (nr_keys != teval->nr_key_types)
> +		return -1;
> +
>  	/* find key and copy its corresponding value pair */
>  	if ((check = get_entry(teval, keys, &entry)) < 1)
>  		return check;
> @@ -936,6 +939,9 @@ int traceeval_insert_size(struct traceeval *teval,
>  	int check;
>  	int i;
>  
> +	if (nr_keys != teval->nr_key_types || nr_vals != teval->nr_val_types)
> +		return -1;
> +
>  	entry = NULL;
>  	check = get_entry(teval, keys, &entry);
>  
> -- 
> 2.40.1
> 
