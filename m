Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E48C8C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 17:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C06A2610F9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 17:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhJMROC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 13:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:32818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhJMROC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 13:14:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A589610EA;
        Wed, 13 Oct 2021 17:11:58 +0000 (UTC)
Date:   Wed, 13 Oct 2021 13:11:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-ID: <20211013131155.69fa0e11@gandalf.local.home>
In-Reply-To: <20211013165043.GA1427@kbox>
References: <20211005224428.2551-1-beaub@linux.microsoft.com>
        <20211007012827.99cd5795140cbb0c932e1b5a@kernel.org>
        <20211006175611.GA2995@kbox>
        <20211007231738.0626e348322dc09e7ebbf1d6@kernel.org>
        <20211007162204.GA30947@kbox>
        <20211008081249.8fbacc4f5d9fa7cf2e488d21@kernel.org>
        <20211008000540.GA31220@kbox>
        <20211008182258.6bf272e6691679d41e7971fc@kernel.org>
        <20211011162523.GA1542@kbox>
        <20211012211852.2bbf921b@oasis.local.home>
        <20211013165043.GA1427@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 Oct 2021 09:50:43 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> > Does it require RCU synchronization as the updates only happen from
> > user space. But is this for the writing of the event? You want a
> > separate fd for each event to write to, instead of saying you have
> > another interface to write and just pass the given id?
> >  
> Yes, an example is a process creates the fd and registers some events.
> Then the process forks and the child registers another event using the
> same fd that was inherited.

Well, I was thinking simple locking could work too. But I guess RCU is like
Batman. You know, "Always be yourself. Unless you can be Batman, then
always be Batman!". So always use locking, unless you can use RCU,
then always use RCU.

> 
> If the original process writes while the child process registers at that
> point the FD array can get resized / moved, therefore we need RCU deref
> protection when resizing, etc.
> 
> I have a few gauntlet tools that try to crash user_events by writing,
> registering, unregistering at weird times to try to flush this stuff
> out.
> > > In our own use case this will be low due to the way we plan to use the
> > > events. However, I am not sure others will follow that :)  
> > 
> > I will say, whenever we say this will only have a "few", if it becomes
> > useful, it will end up having many.
> > 
> > -- Steve  
> Agree 100%, I've gone back and forth on which is better for a while. I'm
> happy to update to RCU and send out a V3. Want to make sure we have
> consensus of the right approach before spinning on it :)
> 

Sure, thanks.

-- Steve
