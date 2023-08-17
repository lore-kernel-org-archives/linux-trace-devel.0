Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14AAC05052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 01:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347318AbjHQBDj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 21:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347396AbjHQBDa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 21:03:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5531BE8
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 18:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97AD5640AA
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 01:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAADC433C7;
        Thu, 17 Aug 2023 01:03:27 +0000 (UTC)
Date:   Wed, 16 Aug 2023 21:03:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ross Zwisler <zwisler@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 14/17] libtraceeval histogram: Use stack for old copy
 in update
Message-ID: <20230816210331.12a11083@gandalf.local.home>
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

> On Wed, 16 Aug 2023 16:37:54 -0600
> Ross Zwisler <zwisler@google.com> wrote:
> 
> > On Fri, Aug 11, 2023 at 01:39:37AM -0400, Steven Rostedt wrote:  
> > > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > > 
> > > In the update, instead of using the heap, use the stack to save the old
> > > values. This should save time where it does not need to allocate and then
> > > free the value list to do an update.
> > > 
> > > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > > ---
> > >  src/histograms.c | 48 ++++++++++++++++++++++++++++++++++--------------
> > >  1 file changed, 34 insertions(+), 14 deletions(-)
> > >     
> > <>  
> > > @@ -772,20 +778,34 @@ fail_entry:
> > >   *
> > >   * Frees the old vals field of @entry, unless an error occurs.
> > >   *
> > > - * Return 0 on success, -1 on error.
> > > + * Return 1 on success, -1 on error.    
> > 
> > The code is now returning 1, 0 and -1 in different cases, and all three of
> > these return values are percolating up to be returned by traceeval_insert(),
> > which is only supposed to return 0 or 1.
> >   
> 
> I didn't update the comments well. The idea is, return 1 if the element
> already existed, 0 if it did not, and -1 on error. I need to fix this.

Anyway, it this does not belong in this patch. The return value of
traceeval_insert() change should be a separate patch. One that I will add
in another series after this one.

-- Steve

