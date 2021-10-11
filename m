Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10804C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 16:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC65C60EE2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 16:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhJKQ13 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 12:27:29 -0400
Received: from linux.microsoft.com ([13.77.154.182]:35042 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbhJKQ12 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 12:27:28 -0400
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7D5B120B8966;
        Mon, 11 Oct 2021 09:25:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7D5B120B8966
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1633969528;
        bh=knkFwK85QFrF0qOhjDycyvfu/WtNh39v6S3FyHmkg8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VQNiS8TggI4OrE08gnOAgARjkR2s1dlomhH0YSO0f9c3jR/RabfHbMrBjnNvzxq+o
         dysN1Zt8+ta57NJnRS8xENwdbOM0Lq6vduP30UPXmc6ukfyk4rqmrYSuopfm4UOoBg
         H40jSD5kRDIdbYLJIx3z8c2zD7mRc6u9DqxMqSqo=
Date:   Mon, 11 Oct 2021 09:25:23 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-ID: <20211011162523.GA1542@kbox>
References: <20211005224428.2551-1-beaub@linux.microsoft.com>
 <20211007012827.99cd5795140cbb0c932e1b5a@kernel.org>
 <20211006175611.GA2995@kbox>
 <20211007231738.0626e348322dc09e7ebbf1d6@kernel.org>
 <20211007162204.GA30947@kbox>
 <20211008081249.8fbacc4f5d9fa7cf2e488d21@kernel.org>
 <20211008000540.GA31220@kbox>
 <20211008182258.6bf272e6691679d41e7971fc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008182258.6bf272e6691679d41e7971fc@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Oct 08, 2021 at 06:22:58PM +0900, Masami Hiramatsu wrote:
> > > I'm not sure this point, you mean 1 fd == 1 event model?
> > > 
> > Yeah, I like the idea of not having an fd per event.
> 
> Ah, OK. I misunderstood the idea.
> per-FD model sounds like having events/user-events/*/marker file.
> 
Thanks for the back and forth, I appreciate your time on this.

Yes, in my mind there are two options to avoid kernel memory usage
per-event.

1.
We have a an array per file struct that is independently ref-counted.
This is required to ensure lifetime requirements and to ensure user code
cannot access other user events that might have been free'd outside of
the lifetime and cause a kernel crash.

This approach also requires 2 int's to be returned, 1 for the status
page the other a local index for the write into the above array per-file
struct.

This is likely the most complex method due to it's lifetime and RCU
synchronization requirements. However, it represents the least memory to
both kernel and user space.

2.
We have a anon_inode FD that gets installed into the user process and
returned via the ioctl from user_events tracefs file. The file struct
backing the FD is shared by all user mode processes for that event. Like
having an inject/marker file per-event in the user_events subsystem.

This approach requires an FD returned and either an int for the status
page or the returend FD could expose the ID via another IOCTL being
issued.

This is the simplest method since the FD manages the lifetime, when FD
is released so is the shared file struct. Kernel side memory is reduced
to only unique events that are actively being used. There is no RCU or
synchronization beyond the FD lifetime. The user mode processes does
incur an FD per-event within their file description table. So they
events charge against their FD per-process limit (not necessarily a bad
thing).

This also seems to follow the pre-existing patterns of tracefs
(trace_marker, inject, format, etc all have a shared file available to
user-processes that have been granted access). For our case, we want
that, but we want it on a access boundary to who all have access to the
user_events_* tracefs files. We don't want to open up all of tracefs
widely.

> > I want to make
> > sure the complexity is worth it. Is the overhead of an FD per event in
> > user space too much?
> 
> It depends on the use case, how much events you wants to use with
> the user-events. If there are hundreds of the evets, that will consume
> kernel resources and /proc/*/fd/ will be filled with the event's fds.
> But if there is a few events, I think no problem.
> 
In our own use case this will be low due to the way we plan to use the
events. However, I am not sure others will follow that :)

Thanks,
-Beau
