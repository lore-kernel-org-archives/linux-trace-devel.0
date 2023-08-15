Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D650C41513
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Aug 2023 18:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbjHOSyo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 14:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239514AbjHOSyR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 14:54:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF45D269E
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 11:53:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6BE865F6B
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 18:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82E8C433C7;
        Tue, 15 Aug 2023 18:52:24 +0000 (UTC)
Date:   Tue, 15 Aug 2023 14:52:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 04/17] libtraceeval histogram: Have cmp and release
 functions be generic
Message-ID: <20230815145225.14eeb03d@gandalf.local.home>
In-Reply-To: <20230815165028.GA780024@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
        <20230811053940.1408424-5-rostedt@goodmis.org>
        <20230815165028.GA780024@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 15 Aug 2023 10:50:28 -0600
Ross Zwisler <zwisler@google.com> wrote:

> > diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> > index f6c4e8efb2be..22e9029133d5 100644
> > --- a/include/traceeval-hist.h
> > +++ b/include/traceeval-hist.h
> > @@ -65,13 +65,13 @@ union traceeval_data {
> >  struct traceeval_type;
> >  
> >  /* struct traceeval_dynamic release function signature */  
> 
> You may want to update the comment here to make it clear that this is now for
> both dynamic and pointer types.  Ditto for the compare function signature.

Agreed, (I was tired and new I was going to miss some spots).

> 
> > -typedef void (*traceeval_dyn_release_fn)(struct traceeval_type *,
> > -					 struct traceeval_dynamic);
> > +typedef void (*traceeval_data_release_fn)(struct traceeval_type *,
> > +					  union traceeval_data *);
> >  
> >  /* struct traceeval_dynamic compare function signature */
> > -typedef int (*traceeval_dyn_cmp_fn)(struct traceeval_dynamic,
> > -				    struct traceeval_dynamic,
> > -				    struct traceeval_type *);
> > +typedef int (*traceeval_data_cmp_fn)(const union traceeval_data *,
> > +				     const union traceeval_data *,
> > +				     struct traceeval_type *);
> >  
> >  /*
> >   * struct traceeval_type - Describes the type of a traceevent_data instance  
> <>
> > @@ -588,7 +588,7 @@ static int copy_traceeval_data(struct traceeval_type *type,
> >  /*
> >   * Free @data with respect to @size and @type.
> >   *
> > - * Does not call dyn_release on type TRACEEVAL_TYPE_DYNAMIC.
> > + * Does not call release on type TRACEEVAL_TYPE_DYNAMIC.  
> 
> or for TRACEEVAL_TYPE_POINTER.

+1

> 
> >   */
> >  static void data_release(size_t size, union traceeval_data **data,
> >  				struct traceeval_type *type)
> > -- 
> > 2.40.1  
> 
> Aside from these two comment nits, you can add:
> 
> Reviewed-by: Ross Zwisler <zwisler@google.com>

Thanks Ross!

-- Steve
