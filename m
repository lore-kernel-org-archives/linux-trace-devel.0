Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FEAC001B0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Aug 2023 18:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239503AbjHOSzS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 14:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239560AbjHOSy7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 14:54:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C61212A
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 11:54:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B11E611DA
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 18:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CACC433C7;
        Tue, 15 Aug 2023 18:53:47 +0000 (UTC)
Date:   Tue, 15 Aug 2023 14:53:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 05/17] libtraceeval histograms: Add traceeval struct
 to compare function
Message-ID: <20230815145348.672f60fc@gandalf.local.home>
In-Reply-To: <20230815165554.GB780024@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
        <20230811053940.1408424-6-rostedt@goodmis.org>
        <20230815165554.GB780024@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 15 Aug 2023 10:55:54 -0600
Ross Zwisler <zwisler@google.com> wrote:

> > --- a/src/histograms.c
> > +++ b/src/histograms.c
> > @@ -113,7 +113,8 @@ static int compare_traceeval_type(struct traceeval_type *orig,
> >   * Return 0 if @orig and @copy are the same, 1 if @orig is greater than @copy,
> >   * -1 for the other way around, and -2 on error.
> >   */
> > -static int compare_traceeval_data(union traceeval_data *orig,
> > +static int compare_traceeval_data(struct traceeval *teval,
> > +				  union traceeval_data *orig,
> >  				  const union traceeval_data *copy,
> >  				  struct traceeval_type *type)  
> 
> Nit: it would be nice if these had the same ordering as the args to
> traceeval_data_cmp_fn.
> 

Yeah, I noticed that to, but figured I can change it later, as it's not API.

I'll update it.

> Other than that you can add:
> 
> Reviewed-by: Ross Zwisler <zwisler@google.com>

Thanks Ross,

-- Steve

