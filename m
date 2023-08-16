Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240C4C27C6E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Aug 2023 22:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346968AbjHPWiY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 18:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347003AbjHPWiA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 18:38:00 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5FC2701
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 15:37:59 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-79198e7d9bcso10249439f.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 15:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692225479; x=1692830279;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+HpYOE+xbFsalcZA8yAHl9x6Fr896TYTWcod3nLlL4E=;
        b=F2XPx9Cy/DFbtFyURgXX6aPQytx9B/x+x25XWwrThKaqzBjS38U+zo6kdPIXwz7kRr
         VeL4OFojqoIDWvwdMTNE2PTmFLwnOrwcSHDGEGX4CG3ww3uY9fSjVrmNpmC6tW8iRUxi
         79/WonksXsy8Z/5A29BR3jX10CGX8zBH/PZovud8icx4Hvc2DbbhCPLjVCcvgYCz20Vg
         Kclu14/1vpoTUu4I7q9d5LIbAbCGlY0Bsm8CWNaG9IP+kggf4jgv9YIH+lDUa3hT/oFt
         WI7bvm7UMw6C+eKun07ZgY13YDzPIgL/GA76BMbJ4FGG1nwfQmxEsXhitxEf+ev4C97k
         lYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692225479; x=1692830279;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+HpYOE+xbFsalcZA8yAHl9x6Fr896TYTWcod3nLlL4E=;
        b=QwtIIts9QB2zNX7Y67N48+CD2I7CcJQFWL2mn5dq0ZqH6UIZAPHVyaCh6fGFz5phl7
         8tXTRcoPwqTcW0cU7OmOWoe4kNlK2O3DImsBlwkQ1lnhPvgukLzdxkLhKtAjQCMEjr6a
         qZDrkRsGm4rES1Wp3NORermK/BYQYCNL4orhU5dAAHlcMj7cyaC3ex4b+cTG1fZWPXzh
         pxTaev6wgtYk77wrHr/vRtr4SzaX/JfKgpw7nFWX+XwgYpXx3HTErbtRmYGFpfLT6AAi
         t9zyEzOFDMQGsEzZq7V19JkxMV8jGyg203gYTXtyQPsOP4QZ3lwbwQtJE14ReIzYs7MF
         2i+A==
X-Gm-Message-State: AOJu0Yzc0R0t8v8hAfMOeT3MNDmTx+s58wiUP+sqKvMSlUCwVAdQ9etc
        oi8fXmCi0tsPcFXVv7WeciuNTwyw71zOx7huMVDFWw==
X-Google-Smtp-Source: AGHT+IHrcAcGf7dM7w4dFfXXCUz7PZdtWMOm/LfwnuE/fu8GDTdFSyg9Px/GCvKJGrAS3oLh5juc6w==
X-Received: by 2002:a05:6e02:1b04:b0:348:7f18:68be with SMTP id i4-20020a056e021b0400b003487f1868bemr1950088ilv.4.1692225478598;
        Wed, 16 Aug 2023 15:37:58 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:55c4:49c7:23c3:7d80])
        by smtp.gmail.com with ESMTPSA id h10-20020a92d08a000000b00348abdfad8esm4802160ilh.32.2023.08.16.15.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 15:37:58 -0700 (PDT)
Date:   Wed, 16 Aug 2023 16:37:54 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 14/17] libtraceeval histogram: Use stack for old copy
 in update
Message-ID: <20230816223754.GB3686281@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
 <20230811053940.1408424-15-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811053940.1408424-15-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Aug 11, 2023 at 01:39:37AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> In the update, instead of using the heap, use the stack to save the old
> values. This should save time where it does not need to allocate and then
> free the value list to do an update.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  src/histograms.c | 48 ++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 34 insertions(+), 14 deletions(-)
> 
<>
> @@ -772,20 +778,34 @@ fail_entry:
>   *
>   * Frees the old vals field of @entry, unless an error occurs.
>   *
> - * Return 0 on success, -1 on error.
> + * Return 1 on success, -1 on error.

The code is now returning 1, 0 and -1 in different cases, and all three of
these return values are percolating up to be returned by traceeval_insert(),
which is only supposed to return 0 or 1.

>   */
>  static int update_entry(struct traceeval *teval, struct entry *entry,
>  			const union traceeval_data *vals)
>  {
> -	union traceeval_data *new_vals;
> +	struct traceeval_stat *stats = entry->val_stats;
> +	struct traceeval_type *types = teval->val_types;
> +	union traceeval_data *copy = entry->vals;
> +	union traceeval_data old[teval->nr_val_types];
> +	size_t size = teval->nr_val_types;
> +	size_t i;
>  
> -	if (copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
> -				vals, entry->val_stats, &new_vals) == -1)
> -		return -1;
> +	if (!size)
> +		return 1;

If we try and copy a 0 length val, is it okay to just return 0 here and call
it success?

> +
> +	for (i = 0; i < size; i++) {
> +		old[i] = copy[i];
> +
> +		if (copy_traceeval_data(types + i, stats + i,
> +					vals + i, copy + i))
> +			goto fail;
> +	}

I think we still need to rip through old[] and free strings, and also call
.release on types that define it, probably via data_release().

I don't understand why data_release() only calls .release if a .copy function
isn't defined?  Are we saying that .copy() must also release the old data?  If
so that needs to be explicit, but I think we still need to free strings at a
minimum.

>  
> -	clean_data_set(entry->vals, teval->val_types, teval->nr_val_types);
> -	entry->vals = new_vals;
>  	return 0;
> +
> +fail:
> +	data_release(i, old, types);
> +	return -1;
>  }
>  
>  struct traceeval_stat *traceeval_stat(struct traceeval *teval,
> -- 
> 2.40.1
> 
