Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721AEC04FDF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Aug 2023 22:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjHBWWu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 18:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbjHBWW1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 18:22:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62864C1B
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Aug 2023 15:20:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC43561B6B
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Aug 2023 22:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A921CC433C8;
        Wed,  2 Aug 2023 22:20:04 +0000 (UTC)
Date:   Wed, 2 Aug 2023 18:20:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/5] histograms: traceeval release
Message-ID: <20230802182002.18436aea@gandalf.local.home>
In-Reply-To: <20230802215403.GC2416079@google.com>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
        <20230728190515.23088-3-stevie.6strings@gmail.com>
        <20230802215403.GC2416079@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 2 Aug 2023 15:54:03 -0600
Ross Zwisler <zwisler@google.com> wrote:

> > +/**
> > + * Deallocate all possible data stored within the entry.
> > + */
> > +static void clean_entry(struct entry *entry, struct traceeval *teval)
> > +{
> > +	if (!entry)   
> 
> Should we check for NULL 'teval' as well?

No, because teval can't be NULL here. As to get here, we need to go through
traceeval_release() which does the check for !teval.

-- Steve
> 
> > +		return;
> > +
> > +	// deallocate dynamic traceeval_data
> > +	clean_data(entry->keys, teval->def_keys);
> > +	clean_data(entry->vals, teval->def_vals);
> > +	free(entry->keys);
> > +	free(entry->vals);
> > +}
