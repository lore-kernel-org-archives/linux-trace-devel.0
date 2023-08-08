Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEF0C001B0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 23:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjHHXvU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 19:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjHHXvT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 19:51:19 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA3C19A1
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 16:51:19 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-790b080f2a0so259502039f.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Aug 2023 16:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691538678; x=1692143478;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pk9s0f3YFzPIGqq3J0cdxDxdN+noFAdN11b+zbDYZrQ=;
        b=KXP3nUlaKg1MNZ4KxbEnYEqOKEuUTnR5IGYOu6DqD0UhEQbgWjpbd1bVICmFKxNWKV
         1oUNV3rB0r9P/HUC1bZt0eSbzfGz2p327YE+m8203DP/xZG2KopVK16X1AP79T44Pp5/
         wMKkWCy4vFPk8joyzuTpAD/EAU+7+TYv83zevYyUc2Ig8Q0WQ8qVZCTEHse/+BVIQeZM
         1vjiCrMtIfvCIVJ/qT+3SD9kYw7qR1toabvxVAkfc62WpCz4kuEWZIVOye8bLWlTY3ng
         UI+QfNMk2i6BzKABVo+iY/8hOoVVKZGvr3MualcniUGiNF0+z9G++SsI9Ygl7POv+1P0
         g8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691538678; x=1692143478;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pk9s0f3YFzPIGqq3J0cdxDxdN+noFAdN11b+zbDYZrQ=;
        b=jRwNABHGl5C6w2tW2XucSurhdr4Q3/0neJMkxKl+TNuLTkAbVyhmo+5VKwP43VviBJ
         1vrSMvC0MhRC7NfGw94pSP2cplZc2OPQ6F29g8Zg+cj/vSbTvUuhypVOh3amX44YO7IV
         8GuV1l9zAQiijBu6b0CcaefPpLcJaGbembbZuX1BS62XGYb0LceYn8kB8WKvmwOfAgoe
         nxtBJEM1EFoJODRH16SFPMLhqSCr62wQrjobLHqgT3hf4w7bEkB+hl4LcIyBC3m0/BBs
         HPCh7ocsa60/K6H0lf57UdR5U+BotNv3yiOGMIYH6ktqAKXK7TEAqmYSoxEg2Te3lYXx
         cJuA==
X-Gm-Message-State: AOJu0YyVUCXQjSnH5mNpGwGgD2QZBtPebrIOMAXFu0U8Dz+sFKbctFkV
        wlltJ6bREaBwV0IHfQpb0UJp6g==
X-Google-Smtp-Source: AGHT+IFbxmfJ6oyVPshopDvhZcei0BsCP75LTZvVsEa5YIDBaBpTuEKWnj+lrW7sOxEahGIN03Ws5Q==
X-Received: by 2002:a05:6e02:219c:b0:348:8576:15b5 with SMTP id j28-20020a056e02219c00b00348857615b5mr1610428ila.3.1691538678215;
        Tue, 08 Aug 2023 16:51:18 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:6bcd:e67:26f3:b49f])
        by smtp.gmail.com with ESMTPSA id u4-20020a92da84000000b0034587c5533fsm3757189iln.51.2023.08.08.16.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 16:51:17 -0700 (PDT)
Date:   Tue, 8 Aug 2023 17:51:14 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 5/6] histograms: Add traceeval insert
Message-ID: <20230808235114.GA2906989@google.com>
References: <20230808161204.5704-1-stevie.6strings@gmail.com>
 <20230808161204.5704-6-stevie.6strings@gmail.com>
 <20230808195927.GA755218@google.com>
 <20230808233249.GA1266@3xKetch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808233249.GA1266@3xKetch>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Aug 08, 2023 at 07:32:49PM -0400, Stevie Alvarez wrote:
> On Tue, Aug 08, 2023 at 01:59:27PM -0600, Ross Zwisler wrote:
> > On Tue, Aug 08, 2023 at 12:11:58PM -0400, Stevie Alvarez wrote:
> > > From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> > > 
> > > traceeval_insert() updates the provided struct traceeval's histogram.
> > > If an entry that exists with a keys field that match the keys argument,
> > > the entries vals field are updated with a copy of the vals argument.
> > > If such an entry does not exist, a new entry is added to the histogram,
> > > with respect to the keys and vals arguments.
> > > 
> > > Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> > > ---
> > >  include/traceeval-hist.h |   4 ++
> > >  src/histograms.c         | 106 +++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 110 insertions(+)
> > > 
> > > diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> > > index 4923de1..e713c70 100644
> > > --- a/include/traceeval-hist.h
> > > +++ b/include/traceeval-hist.h
<>
> > > +/*
> > > + * Update @entry's vals field with a copy of @vals, with respect to @teval.
> > > + *
> > > + * Return 0 on success, -1 on error.
> > > + */
> > > +static int update_entry(struct traceeval *teval, struct entry *entry,
> > > +			const union traceeval_data *vals)
> > > +{
> > > +	union traceeval_data *new_vals;
> > > +
> > > +	if (copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
> > > +				vals, &new_vals) == -1)
> > > +		return -1;
> > > +
> > > +	entry->vals = new_vals;
> > 
> > Are we leaking the old 'entry->vals', as we never free that memory anywhere? 
> 
> Thanks for catching this!
> > 
> > Should we just update in-place, instead of allocating a new one & freeing the
> > old?  The vals arrays should each be the same size because they have a
> > common 'teval->val_types'. 
> > 
> > I know 'vals' is owned by the caller, but we allocated and own 'entry->vals'
> > via a previous call to create_entry().
> > 
> > We'll have to free existing strings & allocate new ones (and do something
> > similar for dynamic types when they're supported), but the rest of
> > 'entry->vals' should be reusable I think.
> 
> My worry about doing this in place is we can't guarantee the operation
> to be atomic if an error occurs when trying to copy a string. Take the
> following traceeval instance for example...
> 
> 	teval->val_types = {
> 		{ .type = TRACEEVAL_TYPE_STRING },
> 		{ .type = TRACEEVAL_TYPE_STRING },
> 		{ .type = TRACEEVAL_TYPE_NONE }
> 	}
> 
> Say an entry is being updated, and we've freed the first string and
> placed a copy of the new string in its place. We then move on to the
> second string; we attempt to make a copy of the new string, but it
> fails, leaving the state changed.
> Of course, we can keep track of all the original strings and free them
> at the very end. Is that more efficient than copying the new vals,
> freeing entry->vals via clean_data(), and then assigning the new vals
> to entry->vals? My immediate response is that the in place approach is
> just as good as the later, but I could be thinking about this the wrong
> way. Is my logic here sound? Thoughts?

Sure, that concern makes sense to me.  Keeping track of all the original vals
seems complex, and I agree that just making a new 'vals' from scratch and then
freeing the old is fine.  This will let us re-use the free path we already
have in 'clean_data()' which is preferable to having 2 separate cleanup paths.
