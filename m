Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D25C001E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Aug 2023 18:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbjHOSo7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 14:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239404AbjHOSo1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 14:44:27 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668DCF1
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 11:44:26 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-7911dfc9824so218047239f.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 11:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692125066; x=1692729866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YTF0O55mwSkLw0AYLEah7Q6SyPNb+NLr5dzSUGdxOYw=;
        b=fCjzR1lGyLVvNqLTIROdTAlDtD9kMZW4HCl24x63DlqiSDrVrHw9QI9WfggDM67JXr
         EaqFHMV/96Wt8dD1l8r7kxJ5Cw3irHmpLMPMiJvYVUmjcKaHUx0kUmG3IYQLUMu6czq2
         AKNe8VLZaYcG5k/hTT3LhthX5segR5PZfXZCRsjnvlOA607c2fDqPIUSJmwKMmJTHHWd
         VgT5923L3knnWOTk/SUfj8pBFyG0DIoRw+y+rhwFFv8sFFNOuGBlZKhBtvKlu6Wf2Vyl
         A+oy3NSZ2Lkf3pIGIOCRBAQGu+WM7I41Z4qd+pF1j5M5rFxkoEYA+L60xtu62IYxQoZk
         JYjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692125066; x=1692729866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YTF0O55mwSkLw0AYLEah7Q6SyPNb+NLr5dzSUGdxOYw=;
        b=TvhO6ka2yR9IgCm42pb5mxRS0fdJSqNjjVMfU1u4PHxeIWhcEz0loNZqOZWzIvqfPr
         OWRdmLSx1Ke4/d/ZELFwlJctFVwPTYFVUdMkKRAGomwh994MosotqFNIDCFW94cEQVZd
         1WrYWtYL7kGbjvxUboaev+UXpgy1sjdLFIwQqx9sKmSBJbxn2ik72WqCnSbmGwL0Twar
         XdDh9GTSghT4mYKrqQ16H3PKE+qfCA+6k3vY6YCK18RQTKSQ1eMjBoWoUfc0cjjtqlxU
         vqNoVAASNjEdviCOoM+h0YEHP264/a97DHPZBiGnIaeIgmQthjUfmqmGGlMtaNPubDtA
         jX+Q==
X-Gm-Message-State: AOJu0Yw0scv7oAs638MlkxqENwgiQOQCCY/xKwShjvapdakmwDx0plTr
        p+/ddgmklAiJ+mO67iws8O9Rlw==
X-Google-Smtp-Source: AGHT+IGF33UIXtgh3wmlEXSiVaR4Le8dn+yq3bgvOCcrfAbjEZz/i6hX+LafuJGPXoY0tkcfCXiB0w==
X-Received: by 2002:a05:6e02:1d05:b0:348:cd93:8c85 with SMTP id i5-20020a056e021d0500b00348cd938c85mr18497965ila.9.1692125065601;
        Tue, 15 Aug 2023 11:44:25 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:f77a:c0d7:f137:55fe])
        by smtp.gmail.com with ESMTPSA id f13-20020a056638118d00b0042b320c13aasm3921725jas.89.2023.08.15.11.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 11:44:24 -0700 (PDT)
Date:   Tue, 15 Aug 2023 12:44:21 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 07/17] libtraceeval: Convert hist array into a hash
 table
Message-ID: <20230815184421.GC780024@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
 <20230811053940.1408424-8-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811053940.1408424-8-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Aug 11, 2023 at 01:39:30AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The lookups need to be extremely fast. Instead of doing a linear search
> across all entries (which could be thousands), do a hash lookup instead.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h |   7 ++
>  src/histograms.c         | 172 +++++++++++++++++++++++++++++++++------
>  2 files changed, 153 insertions(+), 26 deletions(-)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index 412efdbe8681..4baed4237787 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
<>
> @@ -12,6 +13,14 @@
>  
>  #include <traceeval-hist.h>
>  
> +#define offset_of(type, field) (&(((type *)(NULL))->field))

This currently returns a pointer type, but the kernel implementation(s) have
this cast back to a size_t, which makes sense I think.

https://elixir.bootlin.com/linux/latest/source/tools/include/nolibc/types.h#L220

> +#define container_of(ptr, type, field) \
> +	(type *)((void *)(ptr) - (void *)offset_of(type, field))
> +
> +#define HASH_BITS 10	/* Start with 1K of buckets */
> +#define HASH_SIZE(bits)	(1 << (bits))
> +#define HASH_MASK(bits)	(HASH_SIZE(bits) - 1)
> +
>  /*
>   * Compare two integers of variable length.
>   *
<>
> @@ -365,16 +406,19 @@ static void clean_entry(struct entry *entry, struct traceeval *teval)
>   */
>  static void hist_table_release(struct traceeval *teval)

This probably wants to be 'hash_table_release()' now since 'hist_table' is
gone.

>  {
> -	struct hist_table *hist = teval->hist;
> +	struct hash_table *hist = teval->hist;
>  
>  	if (!hist)
>  		return;
>  
> -	for (size_t i = 0; i < hist->nr_entries; i++) {
> -		clean_entry(hist->map + i, teval);
> +	for (size_t i = 0; i < HASH_SIZE(hist->bits); i++) {
> +		if (!hist->hash[i])
> +			continue;
> +
> +		free_entries(teval, hist->hash[i]);
>  	}
>  
> -	free(hist->map);
> +	free(hist->hash);
>  	free(hist);
>  	teval->hist = NULL;
>  }
