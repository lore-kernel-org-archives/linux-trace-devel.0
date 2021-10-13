Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C16AAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 16:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B4B760EB4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 16:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhJMQww (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:52:52 -0400
Received: from linux.microsoft.com ([13.77.154.182]:33744 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbhJMQww (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 12:52:52 -0400
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7108120B9CE1;
        Wed, 13 Oct 2021 09:50:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7108120B9CE1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634143848;
        bh=5gfRdtuYHgQ1LuQf5SFk00XsiDnfBii0Avdbx+Ckngk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EWoKp8v6LwSCjyJ7A6yMk6fsZ3nL4oSWSWUmYAN0n8Ot/H30dXEq2Z+jcP0FhVwQA
         vx0/gw3H4wZCPWXHIpWucgGTT6BvxdV8Gy0qyc4OhiG9qBjXiDmN62qVg4yUI/sefq
         9pmMLOCpENL4xni/UEbyRTOg9MAAitK67HF+g4Hk=
Date:   Wed, 13 Oct 2021 09:50:43 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-ID: <20211013165043.GA1427@kbox>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012211852.2bbf921b@oasis.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Oct 12, 2021 at 09:18:52PM -0400, Steven Rostedt wrote:
> On Mon, 11 Oct 2021 09:25:23 -0700
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> > 
> > Yes, in my mind there are two options to avoid kernel memory usage
> > per-event.
> > 
> > 1.
> > We have a an array per file struct that is independently ref-counted.
> > This is required to ensure lifetime requirements and to ensure user code
> > cannot access other user events that might have been free'd outside of
> > the lifetime and cause a kernel crash.
> > 
> > This approach also requires 2 int's to be returned, 1 for the status
> > page the other a local index for the write into the above array per-file
> > struct.
> > 
> > This is likely the most complex method due to it's lifetime and RCU
> > synchronization requirements. However, it represents the least memory to
> > both kernel and user space.
> 
> Does it require RCU synchronization as the updates only happen from
> user space. But is this for the writing of the event? You want a
> separate fd for each event to write to, instead of saying you have
> another interface to write and just pass the given id?
>
Yes, an example is a process creates the fd and registers some events.
Then the process forks and the child registers another event using the
same fd that was inherited.

If the original process writes while the child process registers at that
point the FD array can get resized / moved, therefore we need RCU deref
protection when resizing, etc.

I have a few gauntlet tools that try to crash user_events by writing,
registering, unregistering at weird times to try to flush this stuff
out.
> > In our own use case this will be low due to the way we plan to use the
> > events. However, I am not sure others will follow that :)
> 
> I will say, whenever we say this will only have a "few", if it becomes
> useful, it will end up having many.
> 
> -- Steve
Agree 100%, I've gone back and forth on which is better for a while. I'm
happy to update to RCU and send out a V3. Want to make sure we have
consensus of the right approach before spinning on it :)

Thanks,
-Beau
