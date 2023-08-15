Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 435B3C0015E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Aug 2023 20:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237757AbjHOUZQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 16:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbjHOUYp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 16:24:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F7210E9
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 13:24:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9D2D64B1E
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 20:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F4AC433C8;
        Tue, 15 Aug 2023 20:24:42 +0000 (UTC)
Date:   Tue, 15 Aug 2023 16:24:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 09/17] libtraceeval histogram: Label and check keys
 and values
Message-ID: <20230815162444.4a04da3e@gandalf.local.home>
In-Reply-To: <20230815194809.GE780024@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
        <20230811053940.1408424-10-rostedt@goodmis.org>
        <20230815194809.GE780024@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 15 Aug 2023 13:48:09 -0600
Ross Zwisler <zwisler@google.com> wrote:

> On Fri, Aug 11, 2023 at 01:39:32AM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > When initializing the traceeval descriptor, mark each key and value as
> > their type via the flags (keys get TRACEEVAL_FL_KEY and values get
> > TRACEEVAL_FL_VALUE) as well as adding the index of that key/value type of
> > the key/value data it represents. This will be used by the iterators for
> > sorting. The iterator will point to the key/value type and use that
> > information to know which key/value data to sort with.
> > 
> > The keys and values passed in will also be updated to have their flags
> > match the proper key/value type as well as the index. This will be useful
> > for traceeval_stat() that will take the type as a parameter, and use it to
> > figure out fast where the data is that is to be looked up.
> > 
> > All pointer and dynamic types in keys must have both a cmp and hash
> > function defined, otherwise they cannot be indexed or hashed. Add a check
> > to make sure all key types of pointer and dynamic have those functions.
> > 
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > ---
> >  include/traceeval-hist.h | 11 +++++---
> >  src/histograms.c         | 60 ++++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 64 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> > index 4baed4237787..1c02f3039809 100644
> > --- a/include/traceeval-hist.h
> > +++ b/include/traceeval-hist.h  
> <>
> > @@ -248,6 +292,16 @@ struct traceeval *traceeval_init(const struct traceeval_type *keys,
> >  		goto fail;
> >  	}
> >  
> > +	ret = check_keys(keys);
> > +	if (ret < 0)
> > +		goto fail;
> > +
> > +	if (vals) {
> > +		ret = check_vals(vals);
> > +		if (ret < 0)
> > +			goto fail;  
> 
> These two goto statements should both be to fail_release so we clean up
> 'teval', else we could do this check above the alloc.

Nice catch. Will fix.

-- Steve

> 
> > +	}
> > +
> >  	/* alloc key types */
> >  	teval->nr_key_types = type_alloc(keys, &teval->key_types);
> >  	if (teval->nr_key_types <= 0) {
> > -- 
> > 2.40.1
> >   

