Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CC4C001DE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Aug 2023 17:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjHDR5X (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjHDR5W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 13:57:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF8A195
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 10:57:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E79FA620D6
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Aug 2023 17:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8310C433C8;
        Fri,  4 Aug 2023 17:57:19 +0000 (UTC)
Date:   Fri, 4 Aug 2023 13:57:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stevie Alvarez <stevie.6strings@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH v2 1/5] histograms: Initial histograms interface
Message-ID: <20230804135718.70dba76c@gandalf.local.home>
In-Reply-To: <20230804174159.GA2510@3xKetch>
References: <20230803225413.40697-1-stevie.6strings@gmail.com>
        <20230803225413.40697-2-stevie.6strings@gmail.com>
        <20230804095058.756fccb0@gandalf.local.home>
        <20230804174159.GA2510@3xKetch>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 4 Aug 2023 13:41:59 -0400
Stevie Alvarez <stevie.6strings@gmail.com> wrote:

> > > +struct traceeval_type {
> > > +	char				*name;
> > > +	traceeval_dyn_release_fn	dyn_release;
> > > +	traceeval_dyn_cmp_fn		dyn_cmp;
> > > +	enum traceeval_data_type	type;
> > > +	size_t				flags;
> > > +	size_t				id;  
> > 
> > Let's reorder this a little. Normally function pointers come at the end of
> > a structure. That's more of a guideline than a rule, but let's have it here.
> > 
> > struct traceeval_type {
> > 	char				*name;
> > 	enum traceeval_data_type	type;
> > 	size_t				flags;
> > 	size_t				id;
> > 	traceeval_dyn_release_fn	dyn_release;
> > 	traceeval_dyn_cmp_fn		dyn_cmp;
> > };
> > 
> > Especially since dynamic types are going to be rare, we don't want it in
> > the hot cache.  
> 
> Does the order of the fields in a struct definition not matter? I
> thought word-boundaries applied to struct definitions? Or does the
> compiler take care of this?

They do matter. Word bounders are important, but the compiler will just
make "holes" if needed. For example, let's say on 64 bit, everything above
is 64 bits but the type. I would have created a "hole". But because the
type is more important than the id, I kept it at the top.

struct traceeval_type {
	char				*name;			// offset 0
 	enum traceeval_data_type	type;			// offset 8

[ compiler adds 4 byte "hole" or "padding" ]

 	size_t				flags;			// offset 16
 	size_t				id;			// offset 24
 	traceeval_dyn_release_fn	dyn_release;		// offset 32
 	traceeval_dyn_cmp_fn		dyn_cmp;		// offset 40
};

If a cache line is 32 bytes (most is usually 128, but let's say on an older
architecture) I don't care if the the dyn_release and dyn_cmp are in the
same cache line as name.

-- Steve
