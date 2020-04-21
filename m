Return-Path: <SRS0=ZUfG=6F=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5D7C38A30
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Apr 2020 02:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEA782084D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Apr 2020 02:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgDUCbU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 22:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgDUCbU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 22:31:20 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C31EA2078C;
        Tue, 21 Apr 2020 02:31:19 +0000 (UTC)
Date:   Mon, 20 Apr 2020 22:31:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     bijan tabatabai <bijan311@gmail.com>
Cc:     Bijan Tabatabai <bijan311@yahoo.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Stop recording when processes traced with -P
 exit
Message-ID: <20200420223118.5a6db47f@oasis.local.home>
In-Reply-To: <CAMvvPS5eAoA6nsv9s7iA7wU1g3LKGXOusgg0Lfnyag25L0oTjQ@mail.gmail.com>
References: <20200418163605.32461-1-bijan311.ref@yahoo.com>
        <20200418163605.32461-1-bijan311@yahoo.com>
        <20200420170706.0d813d96@gandalf.local.home>
        <CAMvvPS5eAoA6nsv9s7iA7wU1g3LKGXOusgg0Lfnyag25L0oTjQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 20 Apr 2020 21:01:00 -0500
bijan tabatabai <bijan311@gmail.com> wrote:

> Hi Steve,
> 
> > Won't that while loop just go into a spin?
> >
> > What about something like a fsnotify on a /proc/<pid>/ file?
> >
> > I rather have trace-cmd sleep and wake up when a task exits, than to do a
> > spin. Like it does for the -F option.  
> 
> I just tried doing this using the inotify API and hit a snag.
> It turns out inotify can't monitor pseudo-filesystems like /proc, so I
> don't think that suggestion will work.
> 
> What if I put a call to sleep in the loop?
> It's not the most elegant solution, but that way it wouldn't be too
> different from the current code that sleeps for 10 seconds after
> checking if finished is set to true.

Perhaps using the new pidfd interface may work here.

  https://lwn.net/Articles/794707/

It was added in 5.4 (which is still rather new), but this would be a
new trace-cmd feature as well.

-- Steve

