Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5784C0015E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Aug 2023 22:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjHOW4T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 18:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240515AbjHOW4I (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 18:56:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD871737
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 15:56:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE00E61F1D
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 22:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36CAC433C8;
        Tue, 15 Aug 2023 22:56:03 +0000 (UTC)
Date:   Tue, 15 Aug 2023 18:56:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 08/17] libtraceeval histograms: Move hash functions
 into their own file
Message-ID: <20230815185605.42c1f2ab@gandalf.local.home>
In-Reply-To: <20230815162333.621b6d8b@gandalf.local.home>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
        <20230811053940.1408424-9-rostedt@goodmis.org>
        <20230815193156.GD780024@google.com>
        <20230815162333.621b6d8b@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 15 Aug 2023 16:23:33 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > > +__hidden void hash_add(struct hash_table *hash, struct hash_item *item, unsigned key)
> > > +{
> > > +	key &= HASH_MASK(hash->bits);    
> > 
> > key should already be masked to HASH_MASK(hash->bits) via make_hash().  If
> > those bits are set, we have a bug somewhere.
> > 
> > I think it's better to check to see if those bits are set and bail out loudly
> > with an error.  
> 
> I debated a bit about where to do the mask. I didn't want to put a
> dependency that the bits were already masked, so I just did it twice. It's
> a very fast operation.
> 
> I also don't want to make the dependency that key can only come from
> mask_hash(). As it's critical that key is masked here (or we have a array
> overflow), I just kept it in both places.
> 
> I can comment that here.

Thinking about this more, I'm not even sure I want HASH_MASK() in
make_hash(). In fact, I think I'm going to remove it. The hash size is
really internal to the hash code, and to maintain a proper abstraction,
other code should not assume how big the bucket array is.

-- Steve
