Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E5CC001E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Aug 2023 19:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239776AbjHOTJm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 15:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239462AbjHOTJK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 15:09:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190B52116
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 12:08:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CF4962C50
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 19:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266F9C433C8;
        Tue, 15 Aug 2023 19:05:45 +0000 (UTC)
Date:   Tue, 15 Aug 2023 15:05:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 07/17] libtraceeval: Convert hist array into a hash
 table
Message-ID: <20230815150546.07174f7c@gandalf.local.home>
In-Reply-To: <20230815184421.GC780024@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
        <20230811053940.1408424-8-rostedt@goodmis.org>
        <20230815184421.GC780024@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 15 Aug 2023 12:44:21 -0600
Ross Zwisler <zwisler@google.com> wrote:

> On Fri, Aug 11, 2023 at 01:39:30AM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > The lookups need to be extremely fast. Instead of doing a linear search
> > across all entries (which could be thousands), do a hash lookup instead.
> > 
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > ---
> >  include/traceeval-hist.h |   7 ++
> >  src/histograms.c         | 172 +++++++++++++++++++++++++++++++++------
> >  2 files changed, 153 insertions(+), 26 deletions(-)
> > 
> > diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> > index 412efdbe8681..4baed4237787 100644
> > --- a/include/traceeval-hist.h
> > +++ b/include/traceeval-hist.h  
> <>
> > @@ -12,6 +13,14 @@
> >  
> >  #include <traceeval-hist.h>
> >  
> > +#define offset_of(type, field) (&(((type *)(NULL))->field))  
> 
> This currently returns a pointer type, but the kernel implementation(s) have
> this cast back to a size_t, which makes sense I think.
> 
> https://elixir.bootlin.com/linux/latest/source/tools/include/nolibc/types.h#L220

As this is under an MIT license, I created this without looking at the GPL version.

It's really too small and common to be licensed, but still. I'll make the update.


> 
> > +#define container_of(ptr, type, field) \
> > +	(type *)((void *)(ptr) - (void *)offset_of(type, field))
> > +
> > +#define HASH_BITS 10	/* Start with 1K of buckets */
> > +#define HASH_SIZE(bits)	(1 << (bits))
> > +#define HASH_MASK(bits)	(HASH_SIZE(bits) - 1)
> > +
> >  /*
> >   * Compare two integers of variable length.
> >   *  
> <>
> > @@ -365,16 +406,19 @@ static void clean_entry(struct entry *entry, struct traceeval *teval)
> >   */
> >  static void hist_table_release(struct traceeval *teval)  
> 
> This probably wants to be 'hash_table_release()' now since 'hist_table' is
> gone.

I actually purposely kept the "hist" name (teval->hist) for this local file.

Just because that's what Stevie called it ;-)

-- Steve

> 
> >  {
> > -	struct hist_table *hist = teval->hist;
> > +	struct hash_table *hist = teval->hist;
> >  
> >  	if (!hist)
> >  		return;
> >  
> > -	for (size_t i = 0; i < hist->nr_entries; i++) {
> > -		clean_entry(hist->map + i, teval);
> > +	for (size_t i = 0; i < HASH_SIZE(hist->bits); i++) {
> > +		if (!hist->hash[i])
> > +			continue;
> > +
> > +		free_entries(teval, hist->hash[i]);
> >  	}
> >  
> > -	free(hist->map);
> > +	free(hist->hash);
> >  	free(hist);
> >  	teval->hist = NULL;
> >  }  

