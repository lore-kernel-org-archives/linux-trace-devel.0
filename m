Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C098C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 17:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C5CC610CC
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 17:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhJMRaA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 13:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229915AbhJMR37 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 13:29:59 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C565610CC;
        Wed, 13 Oct 2021 17:27:55 +0000 (UTC)
Date:   Wed, 13 Oct 2021 13:27:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-ID: <20211013132753.63ea60b2@gandalf.local.home>
In-Reply-To: <20211013171747.GA1549@kbox>
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
        <20211013171747.GA1549@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 Oct 2021 10:17:47 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> On Wed, Oct 13, 2021 at 01:11:55PM -0400, Steven Rostedt wrote:
> > On Wed, 13 Oct 2021 09:50:43 -0700
> > Beau Belgrave <beaub@linux.microsoft.com> wrote:
> >   
> > > > Does it require RCU synchronization as the updates only happen from
> > > > user space. But is this for the writing of the event? You want a
> > > > separate fd for each event to write to, instead of saying you have
> > > > another interface to write and just pass the given id?
> > > >    
> > > Yes, an example is a process creates the fd and registers some events.
> > > Then the process forks and the child registers another event using the
> > > same fd that was inherited.  
> > 
> > Well, I was thinking simple locking could work too. But I guess RCU is like
> > Batman. You know, "Always be yourself. Unless you can be Batman, then
> > always be Batman!". So always use locking, unless you can use RCU,
> > then always use RCU.
> >   
> LOL, I'm happy to use a rwlock_t instead. Not sure which is faster, to
> me I care most about the write path not skewing clock times of the
> events being emitted. It seems like the contention case will be low in
> most cases, so these paths will be read-only most of the time.
> 
> It seems rwlock_t has the disadvantage of the writes blocking on the
> realloc/free case during the resize. RCU can delay the free until
> something has time to do so, so seems a good fit.
> 
> Thoughts?

You can always do the allocation and free outside the rwlock_t.

	new_data = alloc();
	lock();
	update new_data with old_data
	ptr = new_data;
	unlock();
	free old_data

And is the preferred method, as we don't want allocation or freeing done
inside the locking (especially on RT, where rwlocks are not "special").

The main concern is cache contention with the updates, even among readers.
That is, readers may not block on each other, but the accessing of the same
lock will cause cache contention.

And writers will block. I don't remember if rwlocks are fair or not (when a
writer blocks, all new readers block too.) I think it is.

For RCU, it's how you free it. You can push it off to a queue, if you have
a field in the data structure that can be added to the rcu link list that
wont affect the readers.

If you are concerned about the contention between readers, then RCU is the
way to go, as it doesn't have that issue.

-- Steve
