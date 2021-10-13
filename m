Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323AEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 17:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A6BD61040
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 17:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhJMRTz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 13:19:55 -0400
Received: from linux.microsoft.com ([13.77.154.182]:37042 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhJMRTz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 13:19:55 -0400
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id AFA6620B9CF8;
        Wed, 13 Oct 2021 10:17:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AFA6620B9CF8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634145471;
        bh=6w7G9sjykt7RkTkpmi8YgipyaMWboWHG8s9GEMJ5XHY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GJI2PLUFSvM8L/EPA6LUiyY6XS4GuJ8Pe8FD0uQ6n96snSliezPU6GnaHTUo+aE2G
         9srWgkqXxD45HUWGkX2ZDSZ/WO8M7V/pFgO+2W/s8BsblZyKc5KaEN/13TMVcWqMmo
         xTcFH1SK6v1QCjEC/kAiMyVD4rLgydfnEph2nSdo=
Date:   Wed, 13 Oct 2021 10:17:47 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-ID: <20211013171747.GA1549@kbox>
References: <20211006175611.GA2995@kbox>
 <20211007231738.0626e348322dc09e7ebbf1d6@kernel.org>
 <20211007162204.GA30947@kbox>
 <20211008081249.8fbacc4f5d9fa7cf2e488d21@kernel.org>
 <20211008000540.GA31220@kbox>
 <20211008182258.6bf272e6691679d41e7971fc@kernel.org>
 <20211011162523.GA1542@kbox>
 <20211012211852.2bbf921b@oasis.local.home>
 <20211013165043.GA1427@kbox>
 <20211013131155.69fa0e11@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013131155.69fa0e11@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Oct 13, 2021 at 01:11:55PM -0400, Steven Rostedt wrote:
> On Wed, 13 Oct 2021 09:50:43 -0700
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > > Does it require RCU synchronization as the updates only happen from
> > > user space. But is this for the writing of the event? You want a
> > > separate fd for each event to write to, instead of saying you have
> > > another interface to write and just pass the given id?
> > >  
> > Yes, an example is a process creates the fd and registers some events.
> > Then the process forks and the child registers another event using the
> > same fd that was inherited.
> 
> Well, I was thinking simple locking could work too. But I guess RCU is like
> Batman. You know, "Always be yourself. Unless you can be Batman, then
> always be Batman!". So always use locking, unless you can use RCU,
> then always use RCU.
> 
LOL, I'm happy to use a rwlock_t instead. Not sure which is faster, to
me I care most about the write path not skewing clock times of the
events being emitted. It seems like the contention case will be low in
most cases, so these paths will be read-only most of the time.

It seems rwlock_t has the disadvantage of the writes blocking on the
realloc/free case during the resize. RCU can delay the free until
something has time to do so, so seems a good fit.

Thoughts?

Thanks,
-Beau
