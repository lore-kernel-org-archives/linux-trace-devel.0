Return-Path: <SRS0=NeNm=6X=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850E5C28CBC
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 May 2020 18:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77C1221582
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 May 2020 18:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgEISs4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 9 May 2020 14:48:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728162AbgEISsz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 9 May 2020 14:48:55 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E84421473;
        Sat,  9 May 2020 18:48:55 +0000 (UTC)
Date:   Sat, 9 May 2020 14:48:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Fix build with gcc-10
Message-ID: <20200509144853.081f4a70@oasis.local.home>
In-Reply-To: <CADVatmN=Z0ASVXUBTyAu6F_TWoWiKiKsgm404rOx7Oh-a6LiQg@mail.gmail.com>
References: <20200417203914.26358-1-sudipm.mukherjee@gmail.com>
        <20200420154325.6072d96b@gandalf.local.home>
        <20200420155320.55d3c3f2@gandalf.local.home>
        <CADVatmN4Xv00=VvWma9kRwYhsX=jzFn3t8052y1o54srEt6LfQ@mail.gmail.com>
        <CADVatmMaEd3jaT0UoGi2C2Xx7dNSaGmiaVcAk89SPCRAjEfGwg@mail.gmail.com>
        <20200508101134.1f957f0b@gandalf.local.home>
        <CADVatmN=Z0ASVXUBTyAu6F_TWoWiKiKsgm404rOx7Oh-a6LiQg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 9 May 2020 19:30:38 +0100
Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
>
> > Thanks for the reminder, I haven't forgotten about it, just had other
> > things added on top of my "todo" list.
> >
> > I'll go apply this now.  
> 
> Thanks. And now kernelshark fails. :(
> 

Have you tried doing a make clean and building again? Sometimes the
updates leave objects in place that need to be recompiled, but the
dependencies may miss them.

-- Steve
