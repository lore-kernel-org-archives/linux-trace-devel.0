Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D77C7113B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Aug 2023 20:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242141AbjHXUTi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 16:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237013AbjHXUTP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 16:19:15 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4FAE5E
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 13:19:11 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-792707f78b5so9035239f.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 13:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692908351; x=1693513151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GNxV2mHsRSI2d3LWMn+8Njl4F3G0kxpvVnsSfef2rcI=;
        b=PFRElQJgBEK7da1FGwI1iwQyQSYQMcXB9NzbOr9UJ7H43vdvDGHFqec32IP8R7kESb
         pCC+cBMJiPiXc6PjDqEXlfr016OdM734dMFDitf3hycvRtixyDlPGTJLURgquNscF9W1
         SbaG8kMKqZnxwDhXuCsNQVP9MgZ+vsuaZaOwvJdbHkoTDDeagb2LMDJkbF7u5dX5wkGM
         aD3JCtZS1oXqx8AyydEKPPUzKfbEF+KatAsMJ0qBQMP8BvSfKunulXPFyzje41kZOTLl
         GTWcnWXDiunEGlTuXSA+ttX8KzghcUE5URS8x0N22mjyxk9Ih+iz2/mnGPcSk/vsw3js
         VvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692908351; x=1693513151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GNxV2mHsRSI2d3LWMn+8Njl4F3G0kxpvVnsSfef2rcI=;
        b=T4P1tqqTW/B3mYFR5my35TqszT+ZcNSXVEQS0JvPvxwhFocSX+UJDr7b1Zb55GMu1U
         QVUokWIdRWvaprsceNZnJS4UQo8XSEGPv+3nWodBfjttophqET3CrPuaXmDI40K5Pwn8
         NcfyV6SzEXHM6dmQY3DppCJ4m9quiRX/UaXpe3JrT6tYoormOpW3acigmLYc/ztC+7gg
         4BS7OSOEPNGpEKCxEMUk2JxXwqKVA27sFfSY/W6xm7lf/E/+1GmgUmo4Sk+TGKlvbbRp
         VnYaS2pu+LvRLAqNLc3M5tmJoYZwCfxwK1r4KaozG3+s5X++mIlHqJiHHTQiEOLc7eH1
         NoPQ==
X-Gm-Message-State: AOJu0YxWLv5gneEAU03JDK3NVkQA91f1NXej+Q/9wp6BStkXC/8GkfzG
        KYpuTgXcQSOCm5iVitFYJagWDg==
X-Google-Smtp-Source: AGHT+IGFztNCNJG4UnFI3G3EBVieHwNplZhJYMJD4breUp0ehXEIpjwmU6Xb1WtsQ2kjn/MY6wmphw==
X-Received: by 2002:a5e:c810:0:b0:787:169a:927 with SMTP id y16-20020a5ec810000000b00787169a0927mr7318468iol.20.1692908350616;
        Thu, 24 Aug 2023 13:19:10 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:12f4:1fa1:277e:6e17])
        by smtp.gmail.com with ESMTPSA id l2-20020a5e8802000000b007871aa2f144sm22492ioj.16.2023.08.24.13.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 13:19:10 -0700 (PDT)
Date:   Thu, 24 Aug 2023 14:19:06 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 4/9] libtraceeval: Add traceeval_iterator_remove()
Message-ID: <20230824201906.GD110858@google.com>
References: <20230817222422.118568-1-rostedt@goodmis.org>
 <20230817222422.118568-5-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817222422.118568-5-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Aug 17, 2023 at 06:24:17PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Add an API traceeval_iterator_remove() that is safe to call in the
> traceeval_iterator_next() loop. Currently, traceeval_remove() can also be
> called "safely", but that may change in the future.
> 
> The main difference between traceeval_remove() and traceeval_iterator_remove()
> is that that traceeval_iterator_remove() will NULL out the entry in the
> sort array, and use this in the other iterator functions. If the entry is
> NULL, it will not be returned.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h |  1 +
>  src/histograms.c         | 48 ++++++++++++++++++++++++++++++++++++----
>  2 files changed, 45 insertions(+), 4 deletions(-)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index d511c9c5f14c..7d67673ce7e5 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -190,5 +190,6 @@ int traceeval_iterator_query(struct traceeval_iterator *iter,
>  			     const union traceeval_data **results);
>  struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
>  					       struct traceeval_type *type);
> +int traceeval_iterator_remove(struct traceeval_iterator *iter);
>  
>  #endif /* __LIBTRACEEVAL_HIST_H__ */
> diff --git a/src/histograms.c b/src/histograms.c
> index fddd0f3587e2..0fbd9e0a353e 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -1305,10 +1305,13 @@ int traceeval_iterator_next(struct traceeval_iterator *iter,
>  		iter->next = 0;
>  	}
>  
> -	if (iter->next >= iter->nr_entries)
> -		return 0;
> +	do {
> +		if (iter->next >= iter->nr_entries)
> +			return 0;
> +
> +		entry = iter->entries[iter->next++];
> +	} while (!entry);
>  
> -	entry = iter->entries[iter->next++];
>  	*keys = entry->keys;
>  	return 1;
>  }
> @@ -1338,6 +1341,9 @@ int traceeval_iterator_query(struct traceeval_iterator *iter,
>  		return 0;
>  
>  	entry = iter->entries[iter->next - 1];
> +	if (!entry)
> +		return 0;
> +
>  	*results = entry->vals;
>  
>  	return 1;
> @@ -1363,5 +1369,39 @@ struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
>  		return NULL;
>  
>  	entry = iter->entries[iter->next - 1];
> -	return &entry->val_stats[type->index];
> +	return entry ? &entry->val_stats[type->index] : NULL;
> +}
> +
> +/**
> + * traceeval_iterator_remove - remove the current iterator entry
> + * @iter: The iterator to remove the entry from
> + *
> + * This will remove the current entry from the histogram.
> + * This is useful if the current entry should be removed. It will not
> + * affect the traceeval_iterator_next().
> + *
> + * Returns 1 if it successfully removed the entry, 0 if for some reason
> + * there was no "current entry" (called before traceeval_iterator_next()).
> + * or -1 on error.
> + */
> +int traceeval_iterator_remove(struct traceeval_iterator *iter)
> +{
> +	struct traceeval *teval = iter->teval;
> +	struct hash_table *hist = teval->hist;
> +	struct entry *entry;
> +
> +	if (iter->next < 1 || iter->next > iter->nr_entries)
> +		return 0;
> +
> +	entry = iter->entries[iter->next - 1];
> +	if (!entry)
> +		return 0;
> +
> +	hash_remove(hist, &entry->hash);

Are we leaking 'entry' after we've removed it from the hash?

I think we need to call free_entry() in both traceeval_iterator_remove() as
well as traceeval_remove(), just like we do in the loop in
hist_table_release().

> +
> +	/* The entry no longer exists */
> +	iter->entries[iter->next - 1] = NULL;
> +	teval->update_counter++;
> +
> +	return 1;
>  }
> -- 
> 2.40.1
> 
