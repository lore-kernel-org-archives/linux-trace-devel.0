Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C76C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 09:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2690460F5E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 09:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbhJHJY5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 05:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229853AbhJHJY4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 05:24:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC73760F58;
        Fri,  8 Oct 2021 09:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633684981;
        bh=afJ64eNhnvavZ4I6YtLXQhV692BpYep7GRS5CsVwOKo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SwzOJlF8KULFjM4rprR6hovLxqKYQgZC6BmwmDtSRXvHaOSGaVj7wTAXv+fZKzRJb
         gvVv9d1L7f5PMwiLpCgTzq06bB+lPy7hHd5L2w2vjM8LRa5nDVL5ZKoSvyFWe6NNFc
         cFMEQimhPjwcqb9kiGpFz5VuoOu7Lz2DBUjFRQqOAemyUzOx3IGMl0jkF6NcmYlzYU
         1D8MQkWNUifKB9/OTDXwaGXy3kV26NoJ6h0DwuAifzh9wTIpriY8Dwa9p/tLNwnVTw
         AoTJepF0cGzbseB4GuMx2TM9U4wPMgRSX+0bj9lMr/Ig6nYnLEy/ZmOBCK4hssZZnS
         Wsl/GHBSXvRDA==
Date:   Fri, 8 Oct 2021 18:22:58 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-Id: <20211008182258.6bf272e6691679d41e7971fc@kernel.org>
In-Reply-To: <20211008000540.GA31220@kbox>
References: <20211005224428.2551-1-beaub@linux.microsoft.com>
        <20211007012827.99cd5795140cbb0c932e1b5a@kernel.org>
        <20211006175611.GA2995@kbox>
        <20211007231738.0626e348322dc09e7ebbf1d6@kernel.org>
        <20211007162204.GA30947@kbox>
        <20211008081249.8fbacc4f5d9fa7cf2e488d21@kernel.org>
        <20211008000540.GA31220@kbox>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 7 Oct 2021 17:05:40 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> > > > > The other thing is we need ref counting to know if the event is busy.
> > > > > Having the ID in the packet avoids having a fd per-event, but it also
> > > > > makes ref counting process lifetime of each event quite hard.
> > > > 
> > > > Hmm, I don't think so. You can use an array of the pointer to
> > > > events on the private data of the struct file.
> > > > When you add (or start using) an event (this is identified by ioctl),
> > > > you can increment the event refcount and add it to the array.
> > > > When the file is closed (in exiting process), it will loop on the
> > > > array and decrement the refcount for each event.
> > > > Then, after all tracers disabled the event, ftrace can remove the
> > > > event in background (unless it is defined through 'dynamic_events' or
> > > > 'user_events').
> > > > 
> > > Yes, I didn't say it's impossible :) It's quite hard and takes a lot
> > > more management. I don't see a clear benefit to that approach, why is it
> > > better than an fd lifetime? Not trying to be difficult, just trying to
> > > be pragmatic about what approach is best.
> > 
> > I'm not sure this point, you mean 1 fd == 1 event model?
> > 
> Yeah, I like the idea of not having an fd per event.

Ah, OK. I misunderstood the idea.
per-FD model sounds like having events/user-events/*/marker file.

> I want to make
> sure the complexity is worth it. Is the overhead of an FD per event in
> user space too much?

It depends on the use case, how much events you wants to use with
the user-events. If there are hundreds of the evets, that will consume
kernel resources and /proc/*/fd/ will be filled with the event's fds.
But if there is a few events, I think no problem.

> What happens to the first 4 bytes (ID)? Does it not
> show up in the buffer?

You can add the 'ID' field commonly in the user-event by default
if you need it. Or, just skip the ID as it is a header of the packet.
(since the ID is process local number, that will not important for
the tracers who trace the events by name)

> This would be fine as long as the rel_loc idea
> gets into ftrace, etc.
> 
> This would require a global array as well as a local per-FD array. I'm
> wondering if the per-FD array becoming large mitigates the gain by
> simply having an FD per-event.

OK, I got it. I hope no one adds hundreds of events at once for
trace.

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
