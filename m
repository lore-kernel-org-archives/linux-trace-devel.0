Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BDB7C27C40
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Aug 2023 20:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbjHXUX7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 16:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243475AbjHXUXb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 16:23:31 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77666E6D
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 13:23:29 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-77a62a84855so8669539f.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Aug 2023 13:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692908608; x=1693513408;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tyjIWbHaoXrOBzq+lpOojqD8HILgGM0X190gL1t1uQ8=;
        b=DLWv0LVXt/aUXKeqHJ+CaXXS7uzUcWub630gdOVVNCTGsKWpN8YT0SMIOr59wJfCRI
         8A9yWVxa+1RCcIX0OAbhbYcct+doxctx7YBXmIBNLdFhbRFQMvuc8ZyI8kfRINBXfXHa
         DTR3S7+t+sdG/dlE/f37X8J9vPpeXf0bAeOnV5L5kYOh0mSBapVCx3HnnEzZANMzzZd5
         VKBRvs8UIQQcydxWjlwVqY4dyNbUkmmZ/+sWbEjYg3ayiUy9gDPS44zfbF8qGXaXDUZb
         ttBO9CSPptWgoWhqJj7eVlcXcdwN11k+uL1fnu70oo9oj7Y0eoJYsQ89WjDquh81UiIE
         yABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692908608; x=1693513408;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tyjIWbHaoXrOBzq+lpOojqD8HILgGM0X190gL1t1uQ8=;
        b=hSYJWok5RR13gTHuBC2xTn+k7vPkB3TmaxnlfIg+rU3lNLRbnU2Jr4ZO44rAN6nBlA
         OXg92sJsHRGGcvEWtNM9mw+A1ytvzcxhrqQvPwdXgdxbdmJnfwLZ8ucDu3Ndrv1r9nRD
         w9gcf8fxI5U6yjXWPE10z5n2xKm8ArLLnZdtG6R429nXVnM9UyN5OB8Hoz1QmpP9cTml
         6EIRNjckiFMnbBi+/zfWDrQw5skOc2uof/bRaL2EjdPV4AvUTubNnW0t6lvZxNQFffuI
         X4QAoHV/GwMNyU0wNLMzmbeck5zBCiRohsqbTlYtiRIgOLnXSGgYqUHBGmTzQiGhgDhu
         IWiA==
X-Gm-Message-State: AOJu0Yxdtenw1piez7QbAWg4Kto5LJcT2Hji1zg5+M7prmsndSJgmUIG
        ch2mdQkoVMhH37ZF/6TCBo224A==
X-Google-Smtp-Source: AGHT+IGQZ35GgGQoBCdAorf6UezNdPUCBDgT83Co48dInWCVNoXNux3tMoQFWecWPmf08tjDcmMgAg==
X-Received: by 2002:a5e:d90a:0:b0:783:49ec:8115 with SMTP id n10-20020a5ed90a000000b0078349ec8115mr7179670iop.5.1692908608577;
        Thu, 24 Aug 2023 13:23:28 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:12f4:1fa1:277e:6e17])
        by smtp.gmail.com with ESMTPSA id ep25-20020a0566384e1900b00430245071ddsm64814jab.176.2023.08.24.13.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 13:23:27 -0700 (PDT)
Date:   Thu, 24 Aug 2023 14:23:24 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH 4/9] libtraceeval: Add traceeval_iterator_remove()
Message-ID: <20230824202324.GE110858@google.com>
References: <20230817222422.118568-1-rostedt@goodmis.org>
 <20230817222422.118568-5-rostedt@goodmis.org>
 <20230824201906.GD110858@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824201906.GD110858@google.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Aug 24, 2023 at 02:19:06PM -0600, Ross Zwisler wrote:
> On Thu, Aug 17, 2023 at 06:24:17PM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > Add an API traceeval_iterator_remove() that is safe to call in the
> > traceeval_iterator_next() loop. Currently, traceeval_remove() can also be
> > called "safely", but that may change in the future.
> > 
> > The main difference between traceeval_remove() and traceeval_iterator_remove()
> > is that that traceeval_iterator_remove() will NULL out the entry in the
> > sort array, and use this in the other iterator functions. If the entry is
> > NULL, it will not be returned.
> > 
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > ---
> >  include/traceeval-hist.h |  1 +
> >  src/histograms.c         | 48 ++++++++++++++++++++++++++++++++++++----
> >  2 files changed, 45 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> > index d511c9c5f14c..7d67673ce7e5 100644
> > --- a/include/traceeval-hist.h
> > +++ b/include/traceeval-hist.h
> > @@ -190,5 +190,6 @@ int traceeval_iterator_query(struct traceeval_iterator *iter,
> >  			     const union traceeval_data **results);
> >  struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
> >  					       struct traceeval_type *type);
> > +int traceeval_iterator_remove(struct traceeval_iterator *iter);
> >  
> >  #endif /* __LIBTRACEEVAL_HIST_H__ */
> > diff --git a/src/histograms.c b/src/histograms.c
> > index fddd0f3587e2..0fbd9e0a353e 100644
> > --- a/src/histograms.c
> > +++ b/src/histograms.c
> > @@ -1305,10 +1305,13 @@ int traceeval_iterator_next(struct traceeval_iterator *iter,
> >  		iter->next = 0;
> >  	}
> >  
> > -	if (iter->next >= iter->nr_entries)
> > -		return 0;
> > +	do {
> > +		if (iter->next >= iter->nr_entries)
> > +			return 0;
> > +
> > +		entry = iter->entries[iter->next++];
> > +	} while (!entry);
> >  
> > -	entry = iter->entries[iter->next++];
> >  	*keys = entry->keys;
> >  	return 1;
> >  }
> > @@ -1338,6 +1341,9 @@ int traceeval_iterator_query(struct traceeval_iterator *iter,
> >  		return 0;
> >  
> >  	entry = iter->entries[iter->next - 1];
> > +	if (!entry)
> > +		return 0;
> > +
> >  	*results = entry->vals;
> >  
> >  	return 1;
> > @@ -1363,5 +1369,39 @@ struct traceeval_stat *traceeval_iterator_stat(struct traceeval_iterator *iter,
> >  		return NULL;
> >  
> >  	entry = iter->entries[iter->next - 1];
> > -	return &entry->val_stats[type->index];
> > +	return entry ? &entry->val_stats[type->index] : NULL;
> > +}
> > +
> > +/**
> > + * traceeval_iterator_remove - remove the current iterator entry
> > + * @iter: The iterator to remove the entry from
> > + *
> > + * This will remove the current entry from the histogram.
> > + * This is useful if the current entry should be removed. It will not
> > + * affect the traceeval_iterator_next().
> > + *
> > + * Returns 1 if it successfully removed the entry, 0 if for some reason
> > + * there was no "current entry" (called before traceeval_iterator_next()).
> > + * or -1 on error.

Nit: we never actually return -1.  Only 1 and 0.

> > + */
> > +int traceeval_iterator_remove(struct traceeval_iterator *iter)
> > +{
> > +	struct traceeval *teval = iter->teval;
> > +	struct hash_table *hist = teval->hist;
> > +	struct entry *entry;
> > +
> > +	if (iter->next < 1 || iter->next > iter->nr_entries)
> > +		return 0;
> > +
> > +	entry = iter->entries[iter->next - 1];
> > +	if (!entry)
> > +		return 0;
> > +
> > +	hash_remove(hist, &entry->hash);
> 
> Are we leaking 'entry' after we've removed it from the hash?
> 
> I think we need to call free_entry() in both traceeval_iterator_remove() as
> well as traceeval_remove(), just like we do in the loop in
> hist_table_release().
> 
> > +
> > +	/* The entry no longer exists */
> > +	iter->entries[iter->next - 1] = NULL;
> > +	teval->update_counter++;
> > +
> > +	return 1;
> >  }
> > -- 
> > 2.40.1
> > 
