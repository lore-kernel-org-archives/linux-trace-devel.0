Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3503CC001B0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 23:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjHHXc4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 19:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjHHXc4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 19:32:56 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BDD1BC9
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 16:32:55 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-40fcc91258fso40906791cf.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Aug 2023 16:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691537574; x=1692142374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EKn7Yn5zvPN8fkNvrb5R3c541S1KFwbK5v+t/Ym0oQk=;
        b=H115vn8QOEQvoIMe2uJFQj42o3PxpV2f3+fqbPiY79oXk5ixP3NqU+qdQthjL/9W9n
         H9wRClmBLosEfMTCBCkhKNVxy6i68Jg6ir8EZ+BFynEYmzH9EZCBMRCfIu673mvYpbrf
         Weyp3gaOOkQfODQbHMFlw3pInxzkKNpXLVqN7ZuFecf3z+CRXXpwpvBJmS8Hw1oJvcJw
         YBO82VTEDf5hoeu1lCe0fu8lMZ3ttbjH5cAhpSBI42eCWTpGGCtyIukHoSLRw8yEJSGK
         QTHnAtRszDLmWzqClL0TK0hyT8nazakwZccK+GbkQ7xORBueHUo7SpkCQg/+PH9tK5k9
         w8hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691537574; x=1692142374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EKn7Yn5zvPN8fkNvrb5R3c541S1KFwbK5v+t/Ym0oQk=;
        b=OxBy0iGDN0HoqQX51PvYHVqSSnLAISox0ayxvDwrYJ4tBPpHq7hannr9w791kK1yhu
         Gt3GXkQvfGGashzGpO9CUH98VuIl2nrNwMvWAwEwNSEivHB0wHajjL2VnKS7FSLjLzUV
         862ejs5HHPR0ZJ3VhGMFUruDxjY4gyBSh4Nvgll2kxkeRM0b5ksVfL6PoRLB7zkIq0CQ
         Eyv6Pvwo/LzzZuMicCZcRg8kOy0no01mZAJWWgt9Z5GUFU3M60RDCym+k3LI/c/kpe6D
         5iKiV1Q6YdAQvYfropIzdZ59/hbNL/BZA3DttBRGBrHwcOHIlDkXqnPH5ZVUAHvumFSo
         PRsw==
X-Gm-Message-State: AOJu0YztbEojG8dcxE0C45ogP+mr45gK/WRntipbsIGW8fTeA9smu4/M
        uVKErQSfb+4ltSPRnezuKX5taSWM4xE=
X-Google-Smtp-Source: AGHT+IEBeO4H3mQmw9NobeDiKVooYCixtOLe+ACYVMUyGTlT/hafYybLaOLKomReKYCD9eA4UwLurg==
X-Received: by 2002:ac8:5c50:0:b0:410:443:221a with SMTP id j16-20020ac85c50000000b004100443221amr1664757qtj.1.1691537574403;
        Tue, 08 Aug 2023 16:32:54 -0700 (PDT)
Received: from 3xKetch ([2601:180:8300:500::6aa8])
        by smtp.gmail.com with ESMTPSA id y2-20020ac83e82000000b00403f1a7be90sm3705067qtf.88.2023.08.08.16.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 16:32:53 -0700 (PDT)
Date:   Tue, 8 Aug 2023 19:32:49 -0400
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 5/6] histograms: Add traceeval insert
Message-ID: <20230808233249.GA1266@3xKetch>
References: <20230808161204.5704-1-stevie.6strings@gmail.com>
 <20230808161204.5704-6-stevie.6strings@gmail.com>
 <20230808195927.GA755218@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808195927.GA755218@google.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Aug 08, 2023 at 01:59:27PM -0600, Ross Zwisler wrote:
> On Tue, Aug 08, 2023 at 12:11:58PM -0400, Stevie Alvarez wrote:
> > From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> > 
> > traceeval_insert() updates the provided struct traceeval's histogram.
> > If an entry that exists with a keys field that match the keys argument,
> > the entries vals field are updated with a copy of the vals argument.
> > If such an entry does not exist, a new entry is added to the histogram,
> > with respect to the keys and vals arguments.
> > 
> > Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
> > ---
> >  include/traceeval-hist.h |   4 ++
> >  src/histograms.c         | 106 +++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 110 insertions(+)
> > 
> > diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> > index 4923de1..e713c70 100644
> > --- a/include/traceeval-hist.h
> > +++ b/include/traceeval-hist.h
> > @@ -134,6 +134,10 @@ struct traceeval *traceeval_init(const struct traceeval_type *keys,
> >  
> >  void traceeval_release(struct traceeval *teval);
> >  
> > +int traceeval_insert(struct traceeval *teval,
> > +		     const union traceeval_data *keys,
> > +		     const union traceeval_data *vals);
> > +
> >  int traceeval_query(struct traceeval *teval, const union traceeval_data *keys,
> >  		    union traceeval_data **results);
> >  
> > diff --git a/src/histograms.c b/src/histograms.c
> > index 47ff175..a59542a 100644
> > --- a/src/histograms.c
> > +++ b/src/histograms.c
> > @@ -684,3 +684,109 @@ void traceeval_results_release(struct traceeval *teval,
> >  
> >  	data_release(teval->nr_val_types, &results, teval->val_types);
> >  }
> > +
> > +/*
> > + * Create a new entry in @teval with respect to @keys and @vals.
> > + *
> > + * Returns 0 on success, -1 on error.
> > + */
> > +static int create_entry(struct traceeval *teval,
> > +			const union traceeval_data *keys,
> > +			const union traceeval_data *vals)
> > +{
> > +	union traceeval_data *new_keys;
> > +	union traceeval_data *new_vals;
> > +	struct entry *tmp_map;
> > +	struct hist_table *hist = teval->hist;
> > +
> > +	/* copy keys */
> > +	if (copy_traceeval_data_set(teval->nr_key_types, teval->key_types,
> > +				keys, &new_keys) == -1)
> > +		return -1;
> > +
> > +	/* copy vals */
> > +	if (copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
> > +				vals, &new_vals) == -1)
> > +		goto fail_vals;
> > +
> > +	/* create new entry */
> > +	tmp_map = realloc(hist->map, ++hist->nr_entries * sizeof(*tmp_map));
> > +	if (!tmp_map)
> > +		goto fail;
> > +	tmp_map->keys = new_keys;
> > +	tmp_map->vals = new_vals;
> > +	hist->map = tmp_map;
> > +
> > +	return 0;
> > +
> > +fail:
> > +	data_release(teval->nr_val_types, &new_vals, teval->val_types);
> > +
> > +fail_vals:
> > +	data_release(teval->nr_key_types, &new_keys, teval->key_types);
> > +	return -1;
> > +}
> > +
> > +/*
> > + * Update @entry's vals field with a copy of @vals, with respect to @teval.
> > + *
> > + * Return 0 on success, -1 on error.
> > + */
> > +static int update_entry(struct traceeval *teval, struct entry *entry,
> > +			const union traceeval_data *vals)
> > +{
> > +	union traceeval_data *new_vals;
> > +
> > +	if (copy_traceeval_data_set(teval->nr_val_types, teval->val_types,
> > +				vals, &new_vals) == -1)
> > +		return -1;
> > +
> > +	entry->vals = new_vals;
> 
> Are we leaking the old 'entry->vals', as we never free that memory anywhere? 

Thanks for catching this!
> 
> Should we just update in-place, instead of allocating a new one & freeing the
> old?  The vals arrays should each be the same size because they have a
> common 'teval->val_types'. 
> 
> I know 'vals' is owned by the caller, but we allocated and own 'entry->vals'
> via a previous call to create_entry().
> 
> We'll have to free existing strings & allocate new ones (and do something
> similar for dynamic types when they're supported), but the rest of
> 'entry->vals' should be reusable I think.

My worry about doing this in place is we can't guarantee the operation
to be atomic if an error occurs when trying to copy a string. Take the
following traceeval instance for example...

	teval->val_types = {
		{ .type = TRACEEVAL_TYPE_STRING },
		{ .type = TRACEEVAL_TYPE_STRING },
		{ .type = TRACEEVAL_TYPE_NONE }
	}

Say an entry is being updated, and we've freed the first string and
placed a copy of the new string in its place. We then move on to the
second string; we attempt to make a copy of the new string, but it
fails, leaving the state changed.
Of course, we can keep track of all the original strings and free them
at the very end. Is that more efficient than copying the new vals,
freeing entry->vals via clean_data(), and then assigning the new vals
to entry->vals? My immediate response is that the in place approach is
just as good as the later, but I could be thinking about this the wrong
way. Is my logic here sound? Thoughts?

-- Stevie
> 
> > +	return 0;
> > +}
> > +
> > +/*
> > + * traceeval_insert - insert an item into the traceeval descriptor
> > + * @teval: The descriptor to insert into
> > + * @keys: The list of keys that defines what is being inserted.
> > + * @vals: The list of values that defines what is being inserted.
> > + *
> > + * The @keys is an array that holds the data in the order of the keys
> > + * passed into traceeval_init(). That is, if traceeval_init() had
> > + * keys = { { .type = TRACEEVAL_STRING }, { .type = TRACEEVAL_NUMBER_8 },
> > + * { .type = TRACEEVAL_NONE } }; then the @keys array passed in must
> > + * be a string (char *) followed by a 8 byte number (char).
> > + *
> > + * The @keys and @vals are only examined to where it expects data. That is,
> > + * if the traceeval_init() keys had 3 items where the first two was defining
> > + * data, and the last one was the TRACEEVAL_TYPE_NONE, then the @keys
> > + * here only needs to be an array of 2, inserting the two items defined
> > + * by traceeval_init(). The same goes for @vals.
> > + *
> > + * For all elements of @keys and @vals that correspond to a struct
> > + * traceeval_type of type TRACEEVAL_TYPE_STRING, the string field must be set
> > + * a valid pointer or NULL.
> > + *
> > + * On error, @teval is left unchanged.
> > + *
> > + * Returns 0 on success, and -1 on error.
> > + */
> > +int traceeval_insert(struct traceeval *teval,
> > +		     const union traceeval_data *keys,
> > +		     const union traceeval_data *vals)
> > +{
> > +	struct entry *entry;
> > +	int check;
> > +
> > +	entry = NULL;
> > +	check = get_entry(teval, keys, &entry);
> > +
> > +	if (check == -1)
> > +		return check;
> > +
> > +	/* insert key-value pair */
> > +	if (check)
> > +		return create_entry(teval, keys, vals);
> > +	else
> > +		return update_entry(teval, entry, vals);
> > +}
> > -- 
> > 2.41.0
> > 
