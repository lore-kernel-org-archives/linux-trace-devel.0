Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46163C05052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 01:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347447AbjHQBNa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 21:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347478AbjHQBN3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 21:13:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F6E1987
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 18:13:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA7226433E
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 01:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29B3C433C7;
        Thu, 17 Aug 2023 01:13:26 +0000 (UTC)
Date:   Wed, 16 Aug 2023 21:13:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 14/17] libtraceeval histogram: Use stack for old copy
 in update
Message-ID: <20230816211330.7f6e2cb3@gandalf.local.home>
In-Reply-To: <20230816191225.7e3e7d85@gandalf.local.home>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
        <20230811053940.1408424-15-rostedt@goodmis.org>
        <20230816223754.GB3686281@google.com>
        <20230816191225.7e3e7d85@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Aug 2023 19:12:25 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > > +
> > > +	for (i = 0; i < size; i++) {
> > > +		old[i] = copy[i];
> > > +
> > > +		if (copy_traceeval_data(types + i, stats + i,
> > > +					vals + i, copy + i))
> > > +			goto fail;
> > > +	}    
> > 
> > I think we still need to rip through old[] and free strings, and also call  
> 
> Yes, I forgot to add that :-p 
> 
> > .release on types that define it, probably via data_release().
> > 

I realized I actually had this kind of backwards. On failure, we want to put
back old and remove the data added to vals (aka copy).

Here's what I'm doing:

	for (i = 0; i < size; i++) {
		old[i] = copy[i];

		if (copy_traceeval_data(types + i, stats + i,
					vals + i, copy + i))
			goto fail;
	}
	data_release(size, old, types);
	return 0;
 fail:
	/* Free the new values that were added */
	data_release(i, copy, types);
	/* Put back the old values */
	for (i--; i >= 0; i--) {
		copy_traceeval_data(types + i, NULL,
				    copy + i, old + i);
	}
	return -1;

-- Steve
