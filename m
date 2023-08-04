Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA774C001DE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Aug 2023 19:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjHDTU4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 15:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjHDTUy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 15:20:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6242E7
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 12:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 444F0620F4
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 19:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340E9C433C8;
        Fri,  4 Aug 2023 19:20:52 +0000 (UTC)
Date:   Fri, 4 Aug 2023 15:20:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v2 2/5] histograms: Add traceeval initialize
Message-ID: <20230804152049.76965462@gandalf.local.home>
In-Reply-To: <20230804182311.GA4353@3xKetch>
References: <20230803225413.40697-1-stevie.6strings@gmail.com>
        <20230803225413.40697-3-stevie.6strings@gmail.com>
        <20230804104039.09c90e85@gandalf.local.home>
        <20230804182311.GA4353@3xKetch>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 4 Aug 2023 14:23:11 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> > > + * traceeval_init - create a traceeval descriptor
> > > + * @keys: Defines the keys to differentiate traceeval entries
> > > + * @vals: Defines values attached to entries differentiated by @keys.
> > > + *
> > > + * The @keys and @vals define how the traceeval instance will be populated.
> > > + * The @keys will be used by traceeval_query() to find an instance within
> > > + * the "histogram". Note, both the @keys and @vals array must end with:
> > > + * { .type = TRACEEVAL_TYPE_NONE }.
> > > + *
> > > + * The @keys and @vals passed in are copied for internal use.
> > > + *
> > > + * For any member of @keys or @vals that isn't of type TRACEEVAL_TYPE_NONE,
> > > + * the name field must be a null-terminated string. For members of type
> > > + * TRACEEVAL_TYPE_NONE, the name is ignored.
> > > + *
> > > + * @vals can be NULL or start with its type field as TRACEEVAL_TYPE_NONE to
> > > + * define the values of the histogram to be empty.
> > > + * @keys must be populated with at least one element that is not
> > > + * TRACEEVAL_TYPE_NONE.
> > > + *
> > > + * Returns the descriptor on success, or NULL on error.
> > > + */
> > > +struct traceeval *traceeval_init(const struct traceeval_type *keys,
> > > +				 const struct traceeval_type *vals)
> > > +{
> > > +	struct traceeval *teval;
> > > +	char *err_msg;
> > > +
> > > +	if (!keys)
> > > +		return NULL;
> > > +
> > > +	if (keys->type == TRACEEVAL_TYPE_NONE) {
> > > +		err_msg = "keys cannot start with type TRACEEVAL_TYPE_NONE";  
> > 
> > BTW, all the error messages should start with a capital letter.
> > 
> > 			"Keys cannot .."
> >   
> > > +		goto fail_init_unalloced;  
> > 
> > Just make this: goto fail;  
> 
> Having multiple of the same label segfaults my tests. I'm relatively new
> to using C labels, is that behavior expected? And if so is it acceptable
> for me to distingush the two fail labels by a single character?

labels must be unique per function. But I constantly use  the same label
multiple times per C file.

As I stated in the email, convert one to "fail:" and the other one to "fail_release:"

> 
> -- Stevie
> 
> >   
> > > +	}
> > > +
> > > +	/* alloc teval */
> > > +	teval = calloc(1, sizeof(*teval));
> > > +	if (!teval) {
> > > +		err_msg = "failed to allocate memory for traceeval instance";
> > > +		goto fail_init_unalloced;
> > > +	}
> > > +
> > > +	/* alloc key types */
> > > +	teval->nr_key_types = type_alloc(keys, &teval->key_types);
> > > +	if (teval->nr_key_types <= 0) {
> > > +		teval->nr_key_types *= -1;  
> > 
> > Get rid of the above setting.
> >   
> > > +		err_msg = "failed to allocate user defined keys";
> > > +		goto fail_init;  
> > 
> > and this: goto fail_release;
> >   
> > > +	}
> > > +
> > > +	/* alloc val types */
> > > +	teval->nr_val_types = type_alloc(vals, &teval->val_types);
> > > +	if (teval->nr_val_types < 0) {
> > > +		teval->nr_val_types *= -1;  
> > 
> > And git rid of the above too.
> >   
> > > +		err_msg = "failed to allocate user defined values";
> > > +		goto fail_init;
> > > +	}
> > > +
> > > +	/* alloc hist */
> > > +	teval->hist = calloc(1, sizeof(*teval->hist));
> > > +	if (!teval->hist) {
> > > +		err_msg = "failed to allocate memory for histogram";
> > > +		goto fail_init;
> > > +	}
> > > +
> > > +	return teval;
> > > +
> > > +fail_init:

This would be

 fail_release:

as it releases the teval.

> > > +	traceeval_release(teval);  
> > 
> > The above isn't defined. If you reference a function in a patch, it must be
> > at least defined.
> >   
> > > +
> > > +fail_init_unalloced:

and this one be

 fail:

As it is part of the fail path for both.

-- Steve


> > > +	print_err(err_msg);
> > > +	return NULL;
> > > +}  
> > 
