Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA0B0C3A5A9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 19:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5267206C0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 19:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgEDTRu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 15:17:50 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:64880
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbgEDTRu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 15:17:50 -0400
X-IronPort-AV: E=Sophos;i="5.73,353,1583190000"; 
   d="scan'208";a="347707985"
Received: from abo-173-121-68.mrs.modulonet.fr (HELO hadrien) ([85.68.121.173])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2020 21:17:48 +0200
Date:   Mon, 4 May 2020 21:17:48 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel-shark: Add command line options for selecting
 plots to be shown
In-Reply-To: <20200504151335.6088dda5@gandalf.local.home>
Message-ID: <alpine.DEB.2.21.2005042117020.13990@hadrien>
References: <20200424132542.1620-1-y.karadz@gmail.com> <20200424132542.1620-3-y.karadz@gmail.com> <20200504151335.6088dda5@gandalf.local.home>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On Mon, 4 May 2020, Steven Rostedt wrote:

> On Fri, 24 Apr 2020 16:25:42 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>
> > Example:
> >   kernelshark -i mytrace.dat --cpu '1 4-7' --pid 11
>
> Can we change this to use a comma instead of a space. Then we don't need to
> worry about quotes.

This seems like a good idea.  I was away from it a few days, and my first
intuition was to use a comma.

julia

>
>   kernelshark -i mytrace.dat --cpu 1,4-7
>
> That's the common format for other unix command lines. See taskset for
> instance.
>
> -- Steve
>
>
> >
> > This will show CPUs: 1, 4, 5, 6, 7 and task(PID): 11.
> >
> > Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> > Suggested-by: Julia Lawall  <julia.lawall@inria.fr>
> > ---
> >  kernel-shark/src/KsUtils.cpp     | 24 ++++++++++++++++++++++++
> >  kernel-shark/src/KsUtils.hpp     |  2 ++
> >  kernel-shark/src/kernelshark.cpp | 32 +++++++++++++++++++++++++++++---
> >  3 files changed, 55 insertions(+), 3 deletions(-)
> >
> >
>
