Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CEBC433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 17:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F28A613D3
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 17:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244809AbhDFRiR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 13:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240500AbhDFRiQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 13:38:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D245D613CB;
        Tue,  6 Apr 2021 17:38:07 +0000 (UTC)
Date:   Tue, 6 Apr 2021 13:38:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <Viktor.Rosendahl@bmw.de>
Cc:     <linux-trace-devel@vger.kernel.org>
Subject: Re: Adding latency tracking to trace-cmd
Message-ID: <20210406133806.0f3ab414@gandalf.local.home>
In-Reply-To: <e1c4952249578eea44817d092bffe27fd0e47645.camel@bmw.de>
References: <20210224115408.1c76ee3f@gandalf.local.home>
        <e1c4952249578eea44817d092bffe27fd0e47645.camel@bmw.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Feb 2021 19:22:48 +0000
<Viktor.Rosendahl@bmw.de> wrote:
> > 
> > My question to you is, would you like to work on adding that feature to
> > trace-cmd?  
> 
> I would be interested to work on the feature but I would probably need
> permission from my employer, also in case I do it as a spare time project.
> 
> For this reason, I will need some time come to a decision. I will get back to
> you when I know the answer.

Hi Viktor,

Any word on if your employer would let you work on trace-cmd?

> 
> > 
> >   git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git
> > 
> > (which requires the libtracefs and libtracevent libraries).
> > 
> > I'm thinking if someone were to do:
> > 
> >  trace-cmd record -p wakeup_rt 
> > 
> > It would then act just like the latency-collector and record every new
> > instance of a latency into the trace.dat file, where:
> > 
> >  trace-cmd report
> > 
> > would then nicely format that data for the user.
> > 
> > Thoughts?  
> 
> It seems like trace-cmd is mostly GPL-2.0. The latency-collector is also GPL-
> 2.0, so I guess that it would be possible to take snippets of code and
> inspiration from it.
> 
> Would you allow the hackish random algorithm to be used in trace-cmd?
> I mean the "--random" option in latency-collector.
> 

If you feel it is useful, sure. Although a definition of what it exactly
does needs to be a bit more explained. I'm not really sure what use the
--random option is for the latency tracer.

-- Steve
