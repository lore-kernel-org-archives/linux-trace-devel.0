Return-Path: <SRS0=aZMu=6W=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42452C38A2A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 14:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B4DB24956
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 14:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEHOLh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 May 2020 10:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgEHOLg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 May 2020 10:11:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2221424955;
        Fri,  8 May 2020 14:11:36 +0000 (UTC)
Date:   Fri, 8 May 2020 10:11:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Fix build with gcc-10
Message-ID: <20200508101134.1f957f0b@gandalf.local.home>
In-Reply-To: <CADVatmMaEd3jaT0UoGi2C2Xx7dNSaGmiaVcAk89SPCRAjEfGwg@mail.gmail.com>
References: <20200417203914.26358-1-sudipm.mukherjee@gmail.com>
        <20200420154325.6072d96b@gandalf.local.home>
        <20200420155320.55d3c3f2@gandalf.local.home>
        <CADVatmN4Xv00=VvWma9kRwYhsX=jzFn3t8052y1o54srEt6LfQ@mail.gmail.com>
        <CADVatmMaEd3jaT0UoGi2C2Xx7dNSaGmiaVcAk89SPCRAjEfGwg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 8 May 2020 13:46:19 +0100
Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:

> On Mon, Apr 20, 2020 at 11:37 PM Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
> >
> > On Mon, Apr 20, 2020 at 8:53 PM Steven Rostedt <rostedt@goodmis.org> wrote:  
> > >
> > > On Mon, 20 Apr 2020 15:43:25 -0400
> > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > >  
> > > > On Fri, 17 Apr 2020 21:39:14 +0100
> > > > Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> > > >  
> > > > > The build fails while building with gcc-10 with the error:
> > > > > multiple definition of `common_type_field'  
> > > >  
> > <snip>  
> > >
> > > OK, I'll take this patch, and may even enable a -fno-common to find other
> > > cases of this without having to wait till my distro adds gcc 10 by default.  
> 
> A gentle ping.
> 

Thanks for the reminder, I haven't forgotten about it, just had other
things added on top of my "todo" list.

I'll go apply this now.

Cheers!

-- Steve
