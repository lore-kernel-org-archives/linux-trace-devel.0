Return-Path: <SRS0=ZUfG=6F=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 189FFC54FCC
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Apr 2020 13:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0DFE2087E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Apr 2020 13:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgDUN0Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 Apr 2020 09:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:32920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728772AbgDUN0Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:26:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B80A12078C;
        Tue, 21 Apr 2020 13:26:15 +0000 (UTC)
Date:   Tue, 21 Apr 2020 09:26:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     bijan tabatabai <bijan311@gmail.com>
Cc:     Bijan Tabatabai <bijan311@yahoo.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Stop recording when processes traced with -P
 exit
Message-ID: <20200421092614.0f98b922@gandalf.local.home>
In-Reply-To: <CAMvvPS5riZw0HH3503XQfGstCv7w+-5vp4V3CfVze==njBr0hQ@mail.gmail.com>
References: <20200418163605.32461-1-bijan311.ref@yahoo.com>
        <20200418163605.32461-1-bijan311@yahoo.com>
        <20200420170706.0d813d96@gandalf.local.home>
        <CAMvvPS5eAoA6nsv9s7iA7wU1g3LKGXOusgg0Lfnyag25L0oTjQ@mail.gmail.com>
        <20200420223118.5a6db47f@oasis.local.home>
        <CAMvvPS5riZw0HH3503XQfGstCv7w+-5vp4V3CfVze==njBr0hQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 20 Apr 2020 22:16:09 -0500
bijan tabatabai <bijan311@gmail.com> wrote:

> > Perhaps using the new pidfd interface may work here.
> >
> >   https://lwn.net/Articles/794707/
> >
> > It was added in 5.4 (which is still rather new), but this would be a
> > new trace-cmd feature as well.
> >
> > -- Steve
> >  
> This is a stupid question, but what would be the best way to use the
> pidfd interface and also keep backwards compatibility with older
> kernel versions?
> Or is that not really a concern?

Not a stupid question at all.

The way to check is to call the system call and see if it works. If it
doesn't simply fall back to the original behavior (to have the user do the
Ctrl^C). A system call should error (errno) with -ENOSYS, if the kernel
does not support the system call.

As I stated, the pidfd is a new feature, but so is stopping trace-cmd when
the pids end. This wouldn't be a regression. It is just an enhancement if
the kernel supports it, which there's lots of other cases in trace-cmd that
does the same thing (add features depending on support of the kernel).

-- Steve
