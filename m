Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBDDC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 01:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C86560F23
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 01:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbhJMBU7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 21:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235775AbhJMBU6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 21:20:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2813D60EB4;
        Wed, 13 Oct 2021 01:18:55 +0000 (UTC)
Date:   Tue, 12 Oct 2021 21:18:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-ID: <20211012211852.2bbf921b@oasis.local.home>
In-Reply-To: <20211011162523.GA1542@kbox>
References: <20211005224428.2551-1-beaub@linux.microsoft.com>
        <20211007012827.99cd5795140cbb0c932e1b5a@kernel.org>
        <20211006175611.GA2995@kbox>
        <20211007231738.0626e348322dc09e7ebbf1d6@kernel.org>
        <20211007162204.GA30947@kbox>
        <20211008081249.8fbacc4f5d9fa7cf2e488d21@kernel.org>
        <20211008000540.GA31220@kbox>
        <20211008182258.6bf272e6691679d41e7971fc@kernel.org>
        <20211011162523.GA1542@kbox>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 11 Oct 2021 09:25:23 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> Yes, in my mind there are two options to avoid kernel memory usage
> per-event.
> 
> 1.
> We have a an array per file struct that is independently ref-counted.
> This is required to ensure lifetime requirements and to ensure user code
> cannot access other user events that might have been free'd outside of
> the lifetime and cause a kernel crash.
> 
> This approach also requires 2 int's to be returned, 1 for the status
> page the other a local index for the write into the above array per-file
> struct.
> 
> This is likely the most complex method due to it's lifetime and RCU
> synchronization requirements. However, it represents the least memory to
> both kernel and user space.

Does it require RCU synchronization as the updates only happen from
user space. But is this for the writing of the event? You want a
separate fd for each event to write to, instead of saying you have
another interface to write and just pass the given id?

> 
> 2.
> We have a anon_inode FD that gets installed into the user process and
> returned via the ioctl from user_events tracefs file. The file struct
> backing the FD is shared by all user mode processes for that event. Like
> having an inject/marker file per-event in the user_events subsystem.
> 
> This approach requires an FD returned and either an int for the status
> page or the returend FD could expose the ID via another IOCTL being
> issued.
> 
> This is the simplest method since the FD manages the lifetime, when FD
> is released so is the shared file struct. Kernel side memory is reduced
> to only unique events that are actively being used. There is no RCU or
> synchronization beyond the FD lifetime. The user mode processes does
> incur an FD per-event within their file description table. So they
> events charge against their FD per-process limit (not necessarily a bad
> thing).
> 
> This also seems to follow the pre-existing patterns of tracefs
> (trace_marker, inject, format, etc all have a shared file available to
> user-processes that have been granted access). For our case, we want
> that, but we want it on a access boundary to who all have access to the
> user_events_* tracefs files. We don't want to open up all of tracefs
> widely.
> 
> > > I want to make
> > > sure the complexity is worth it. Is the overhead of an FD per event in
> > > user space too much?  
> > 
> > It depends on the use case, how much events you wants to use with
> > the user-events. If there are hundreds of the evets, that will consume
> > kernel resources and /proc/*/fd/ will be filled with the event's fds.
> > But if there is a few events, I think no problem.
> >   
> In our own use case this will be low due to the way we plan to use the
> events. However, I am not sure others will follow that :)

I will say, whenever we say this will only have a "few", if it becomes
useful, it will end up having many.

-- Steve
