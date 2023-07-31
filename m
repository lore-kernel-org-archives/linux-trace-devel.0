Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C7ACC04A94
	for <linux-trace-devel@archiver.kernel.org>; Mon, 31 Jul 2023 21:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjGaVEm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 31 Jul 2023 17:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbjGaVEk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 31 Jul 2023 17:04:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C35A1BE9
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Jul 2023 14:04:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93806612A4
        for <linux-trace-devel@vger.kernel.org>; Mon, 31 Jul 2023 21:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9137FC433C7;
        Mon, 31 Jul 2023 21:04:23 +0000 (UTC)
Date:   Mon, 31 Jul 2023 17:04:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH 1/5] histograms: initial histograms interface
Message-ID: <20230731170420.24ecef29@gandalf.local.home>
In-Reply-To: <20230731205353.GA7912@3xKetch>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
        <20230728162500.244f7996@rorschach.local.home>
        <20230731205353.GA7912@3xKetch>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 31 Jul 2023 16:53:53 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> >   
> > > +enum traceeval_flags {
> > > +	TRACEEVAL_FL_SIGNED	= (1 << 0),
> > > +	TRACEEVAL_FL_STATS	= (1 << 1)  
> > 
> > As I think about this more, I think we should just do "stats" for all
> > numbered values. It doesn't really make sense for keys.  
> 
> So get rid of the "stats" flag altogether and do it by default for numbered
> values? And what do you mean when you say it doesn't make sense for keys? A
> key could be a numeric value too, but you might be meaning something else; I'm
> not quite following.

We don't need to keep the stats (max, min, total, count) for keys because
they are unique instances. Each instance should be the same. That is, the
stats are being kept for an instance of the histogram. And an instance is
defined by a unique key. If we keep stats on keys, the max and min will be
the same, and the total will just be max * hitcount.

I would also not keep stats if something is marked as a TIMESTAMP, as a
TIMESTAMP is just a place in time and not something that we need to keep
max min on. Hmm, I guess we could do it, and that would give us the time of
the first and last hit of that particular instance. Yeah, let's keep the
stats even on TIMESTAMPS. Doesn't hurt (even if total doesn't make sense).

> 
> > 
> > But we should still have TRACEEVAL_FL_TIMESTAMP (see traceeval_insert()
> > below)
> >   
> > > +};
> > > +
> > > +/**  
> > 

[..]

> >  * This function will insert an entry defined by @keys and @vals into
> >  * the traceeval instance. The array of @keys and @vals must match that
> >  * of what was added to the corresponding parameters of
> >  * traceeval_init() that created @teval. No checking is performed, if
> >  * there is a mismatch in array length, it will result in undefined behavior.
> >  * The types of the @keys and @vals must also match the types used for
> >  * the corresponding parameters to traceeval_init().
> >  *
> >  * If an entry already exists that matches the @keys, then strings and
> >  * values will be overwritten by the current values and the old values
> >  * will be discarded. For number values, the max, min, total and count
> >  * will be recorded. If an entry in @vals has TRACEEVAL_FL_TIMESTAMP
> >  * set in its corresponding traceeval_type descriptor, then it will be
> >  * used to timestamp the max and min values.  
> 
> So only values can be a timestamp? Or at least timestamp metrics can
> only be gathered for values? This goes back to my comment above about
> the flags.

Yeah, I think it only makes sense for a timestamp to be a value. As keys
are all shown, and we only keep track of a bit of a value. A timestamp is
used to know when a particular key was hit, so it doesn't make sense to be
a key.

-- Steve
