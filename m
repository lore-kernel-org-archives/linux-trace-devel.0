Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74002C56201
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 22:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B86B20866
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 22:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389063AbgKXWLd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Nov 2020 17:11:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389012AbgKXWLc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 17:11:32 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEFAC20715;
        Tue, 24 Nov 2020 22:11:31 +0000 (UTC)
Date:   Tue, 24 Nov 2020 17:11:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: Install kbuffer.h from the install_lib
 make target
Message-ID: <20201124171130.4545101c@oasis.local.home>
In-Reply-To: <20201124170258.4d6ac78e@oasis.local.home>
References: <20201124172755.31795-1-marcelo827@gmail.com>
        <CA+saATWWh9jvNHxyzuKEtrzybJXQS+wWTo9W6-SJNATmEt1bSw@mail.gmail.com>
        <20201124170258.4d6ac78e@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 24 Nov 2020 17:02:58 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 24 Nov 2020 12:30:28 -0500
> Marcelo Diop-Gonzalez <marcelo827@gmail.com> wrote:
> 
> > I figured I'd send this because it might have been left out by mistake
> > given that it's included in the library in the kernel tree, and I've
> > been working on a program that uses kbuffer.h, so thought other people
> > might find it useful, too. Feel free to ignore if it was left out on
> > purpose, though
> >   
> 
> Thanks! This was definitely an oversight on my part. I'll add your
> patch next week as I'm not starting my turkey vacation ;-)
> 

I took a quick look before my vacation, and noticed that kbuffer.h is
already there. Then I noticed that this is for the trace-cmd.git tree.

The code in trace-cmd.git is now obsolete, and will not be updated for
libtraceevent work.

libtraceevent.git now lives at:

  https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/

And we are also moving out libtracefs.git:

  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/

Sorry for the confusion. We are trying to clean things up, and probably
sometime next year, I'll be removing the libtraceevent and libtracefs
code from trace-cmd.git, and it will then depend on these as separate
packages.

Please feel free to look at those repositories. The libtraceevent is
pretty much stable (but will probably be updated as the kernel gets
updated), but the libtracefs has a lot more to expand on. It is going
to be the API to communicate with the /sys/kernel/tracing directory.

Cheers!

--- Steve
