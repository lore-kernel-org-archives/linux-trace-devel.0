Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 028FAC001DE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Aug 2023 17:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjHJRr4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 13:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234600AbjHJRrz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 13:47:55 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461692709
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 10:47:55 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-790970a8706so40343039f.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 10:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691689674; x=1692294474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rzDXLmD8AUE+9vOwLYmNUySDvnGumDuT1Cf572MKs3U=;
        b=oUksz1xHKxofyTVeD3eIdegh9740NIJ3Z+QvJEJLJ5ncC4iBWGvJx2S/GhZCQHHdtd
         4wc9prZz3WFMgf8LL9WGwEh13SbjkLXvsaRrYV/OA/xRp4DjvfOvbGbSuhyBGF5aNHYP
         imhiDNu3OfIoxDXhvIh+a+eQ3sFDUeAV0dUsb7olZQcU3tUFBCZrQ7P/9uXSD6KSZK/y
         ORdJ+CE5XotlQPZZ13e226rdSrOpZn4/lU2azM3di6wPiLJXY9X4y9dzpSKZtt7cEtjY
         EQHsUGyxou6xbTBKOBGWKe8J8qbMNijoErCY2+z22GC4hoAvKrV/gbIefrIRoM8nKYZa
         oaAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691689674; x=1692294474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rzDXLmD8AUE+9vOwLYmNUySDvnGumDuT1Cf572MKs3U=;
        b=Ygz1KRAwJH9KdYSN4GVu5m4fNegIUpyjS+RU1q4TnuUWL4uZ37qE5/Do5t2NxX2ZVY
         nomz2oQdfMaWWV4dbajks6yW+WOyMephFUwCtz5Gjj4f60duFMUecLaDoH3wDCRHqilt
         AxDO4tPQtXmq+MTahlY3uHdrc8bh2pgPbMphAIp0ZrVFKIVloRWWFdhRGU/e/KpVmvdL
         ZY4AiWjG/zUIfsc3yo6dYqiD4UAlPAsla5kYn3ar23SVwFFc/1A3yYquZfT2yPesP4rZ
         YNNmDho7EXi9oYG2GkM+6q983NAxr2CrRwSDeK7aNiFmG77tPKIzvt+PEYPTmaCEEFhr
         tUsQ==
X-Gm-Message-State: AOJu0Yz/S4QBoc9V9RI7eTbm1cLAHYZ1H45+6cQ6J0diNGH9O3uEDIEA
        ggYbobs0sKzdO/OQF4yp6WbJz7L6JyiPHhdvo9RwOg==
X-Google-Smtp-Source: AGHT+IHcmclldqNmhNHsLNcCckT3URMXnnoK1/i1D9ub7xGk/52+GpIzujW62ETRf/kia7pTUsyfwg==
X-Received: by 2002:a05:6602:2756:b0:791:8d:91de with SMTP id b22-20020a056602275600b00791008d91demr3841009ioe.13.1691689674483;
        Thu, 10 Aug 2023 10:47:54 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:b3b8:373d:6e9f:f058])
        by smtp.gmail.com with ESMTPSA id z11-20020a6b0a0b000000b007911db1e6f4sm610547ioi.44.2023.08.10.10.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 10:47:53 -0700 (PDT)
Date:   Thu, 10 Aug 2023 11:47:50 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 5/6] libtraceeval histogram: Fix the return value of
 traceeval_query()
Message-ID: <20230810174750.GA1961992@google.com>
References: <20230809031313.1298605-1-rostedt@goodmis.org>
 <20230809031313.1298605-6-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809031313.1298605-6-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Aug 08, 2023 at 11:13:12PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The comments state that traceeval_query() returns 1 if found, 0 if not,
> and -1 on error, but in reality it returns 0 if found and 1 if not found.

The comment currently says:

> /*
>  * Find the entry that @keys corresponds to within @teval.
>  *
>  * Returns 0 on success, 1 if no match found, -1 on error.
>  */

I think this needs to be updated to match the new logic (1=found, 0=not
found, -1=error)

> It makes more sense to have it return 1 if found and zero if not found as
> the comment states.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  src/histograms.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/src/histograms.c b/src/histograms.c
> index 3cf5c5389700..226c2792995c 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -551,7 +551,7 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
>  		/* return entry if keys match */
>  		if (!check) {
>  			*result = entry;
> -			return 0;
> +			return 1;
>  		} else if (check == 1) {
>  			continue;
>  		} else {
> @@ -559,7 +559,7 @@ static int get_entry(struct traceeval *teval, const union traceeval_data *keys,
>  		}
>  	}
>  
> -	return 1;
> +	return 0;
>  }
>  
>  /*
> @@ -660,7 +660,7 @@ int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
>  		return -1;
>  
>  	/* find key and copy its corresponding value pair */
> -	if ((check = get_entry(teval, keys, &entry)))
> +	if ((check = get_entry(teval, keys, &entry)) < 0)

should this be 
	if ((check = get_entry(teval, keys, &entry)) <= 0)

so we return 0 (not found) in that case, and avoid dropping into
copy_traceeval_data_set() when we have nothing to copy?

>  		return check;
>  	return copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
>  			entry->vals, results);
> -- 
> 2.40.1
> 

I think you also need to update the logic in traceeval_insert(), which right
now uses a return of 1 to mean "not found" and will do a create_entry() in
response.

For clarity maybe in all these consumers 'check' should be renamed 'found'?

Then the logic would read:

 found = get_entry(..);

 if (found == -1)
  error;

 if (found)
  update_entry();
 else /* ! found */
  create_entry();
