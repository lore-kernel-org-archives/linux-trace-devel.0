Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34AFEC433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 May 2021 13:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02B8561480
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 May 2021 13:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhEKNly (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 May 2021 09:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229921AbhEKNly (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 May 2021 09:41:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85AC76134F;
        Tue, 11 May 2021 13:40:47 +0000 (UTC)
Date:   Tue, 11 May 2021 09:40:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] kernel-shark: Add check for return of
 ksmodel_get_cpu_front()
Message-ID: <20210511094045.1673b76a@gandalf.local.home>
In-Reply-To: <2bc740d1-e093-17d1-a9ba-b4319e0ebbfa@gmail.com>
References: <20210507093848.72bf0bed@gandalf.local.home>
        <2bc740d1-e093-17d1-a9ba-b4319e0ebbfa@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 11 May 2021 16:25:35 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> > You can reproduce this with:
> > 
> >     http://rostedt.org/private/trace-no-map.tar.bz2
> > 
> > diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
> > index 225dc34..abef5f8 100644
> > --- a/src/KsPlotTools.cpp
> > +++ b/src/KsPlotTools.cpp
> > @@ -1280,7 +1280,7 @@ void Graph::fillTaskGraph(int sd, int pid)
> >   						 false,
> >   						 _collectionPtr,
> >   						 &index);  
> 
> I wonder why this fails? Is it because "pid" is negative? The fix below 
> is appropriate, however we should detect negative PIDs and abort 
> plotting much earlier.

I believe the issue is that we failed to map which host task goes with
which guest vCPUU, and just randomly picked one (or none).

I fixed trace-cmd to get the mappings when qemu is not found, and
KernelShark works fine on that case. This bug only appears when it can't
find the host thread that corresponds to the guest vCPU.

-- Steve
