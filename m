Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B26BC531DC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 19:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbjHQTm7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 15:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354777AbjHQTmu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 15:42:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2BE35BB
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 12:42:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B56B065451
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 19:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01AAC433C8;
        Thu, 17 Aug 2023 19:42:41 +0000 (UTC)
Date:   Thu, 17 Aug 2023 15:42:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v3 14/18] libtraceeval histogram: Use stack for old copy
 in update
Message-ID: <20230817154245.26b014e6@gandalf.local.home>
In-Reply-To: <20230817192926.GA73817@google.com>
References: <20230817013310.88582-1-rostedt@goodmis.org>
        <20230817013310.88582-15-rostedt@goodmis.org>
        <20230817192926.GA73817@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Aug 2023 13:29:26 -0600
Ross Zwisler <zwisler@google.com> wrote:

> > + fail:
> > +	/* Free the new values that were added */
> > +	data_release(i, copy, types);
> > +	/* Put back the old values */
> > +	for (i--; i >= 0; i--) {
> > +		copy_traceeval_data(types + i, NULL,
> > +				    copy + i, old + i);  
> 
> should be:                          old + i, copy + i);
> 
> Right now we're copying 'copy' into 'old', but we want to be doing it the
> other way around so we restore 'copy' back to its saved state in 'old'

I need to change the parameter names to "src" and "dst" as I can't think of
"orig" and "copy" as which direction they go. I looked at that three times,
and still am confused. And probably reverse them too to make it equivalent
to memcpy():

From memcpy() man page;

SYNOPSIS
       #include <string.h>

       void *memcpy(void *restrict dest, const void *restrict src, size_t n);

DESCRIPTION
       The memcpy() function copies n bytes from memory area src to memory
       area dest.  The memory areas must not overlap.  Use memmove(3) if
       the memory areas do overlap.

As most standard libraries have it "dst, src" I'm pretty much thinking that
way, and my "direction" is always dst = src --> dst, src. And that's
exactly what I was thinking above :-p

-- Steve

