Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087A5C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 16:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2DC261056
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 16:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhJMQ6U (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:58:20 -0400
Received: from linux.microsoft.com ([13.77.154.182]:34404 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhJMQ6U (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 12:58:20 -0400
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7C33A20B9CF8;
        Wed, 13 Oct 2021 09:56:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7C33A20B9CF8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634144176;
        bh=xS5AQ3mYRCJttgJrPt4KreqAtK6W6Oaj4v/1pQxb0Mc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZqJ6Y07jorOGbn40EXt/y4kZlmbL3Gy7n5N4zVHRX2Y0qjQUruSeVnEc5nAuDXo7I
         1oFTN/Ma3cXLbWRp35+v/XasNuuYr+AhJNOO8UbQBnQunqMbaMtTN7RlOTOBprMGjZ
         wL5B16eEsUO3c8qvqievA1ETvf2MmM+NQAXX+h+8=
Date:   Wed, 13 Oct 2021 09:56:14 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-ID: <20211013165614.GB1427@kbox>
References: <20211005224428.2551-1-beaub@linux.microsoft.com>
 <20211007012827.99cd5795140cbb0c932e1b5a@kernel.org>
 <20211006175611.GA2995@kbox>
 <20211007231738.0626e348322dc09e7ebbf1d6@kernel.org>
 <20211007162204.GA30947@kbox>
 <20211008081249.8fbacc4f5d9fa7cf2e488d21@kernel.org>
 <20211008000540.GA31220@kbox>
 <20211008182258.6bf272e6691679d41e7971fc@kernel.org>
 <20211011162523.GA1542@kbox>
 <20211014002132.ee7668a4790ea75b0f7a9ceb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014002132.ee7668a4790ea75b0f7a9ceb@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Oct 14, 2021 at 12:21:32AM +0900, Masami Hiramatsu wrote:
> On Mon, 11 Oct 2021 09:25:23 -0700
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > On Fri, Oct 08, 2021 at 06:22:58PM +0900, Masami Hiramatsu wrote:
> > > > > I'm not sure this point, you mean 1 fd == 1 event model?
> > > > > 
> > > > Yeah, I like the idea of not having an fd per event.
> > > 
> > > Ah, OK. I misunderstood the idea.
> > > per-FD model sounds like having events/user-events/*/marker file.
> > > 
> > 2.
> > We have a anon_inode FD that gets installed into the user process and
> > returned via the ioctl from user_events tracefs file. The file struct
> > backing the FD is shared by all user mode processes for that event. Like
> > having an inject/marker file per-event in the user_events subsystem.
> 
> Is it safe to share the same file structure among all processes?
> (sharing FD via ipc may do same thing?)
> 
I believe so, perf_event_open syscall uses this approach. I think
sharing among processes would only be a problem if the file_operations
methods assumed some synchronization. I don't see how this would be
different than a fork inheriting a pre-existing FD.
> > > > I want to make
> > > > sure the complexity is worth it. Is the overhead of an FD per event in
> > > > user space too much?
> > > 
> > > It depends on the use case, how much events you wants to use with
> > > the user-events. If there are hundreds of the evets, that will consume
> > > kernel resources and /proc/*/fd/ will be filled with the event's fds.
> > > But if there is a few events, I think no problem.
> > > 
> > In our own use case this will be low due to the way we plan to use the
> > events. However, I am not sure others will follow that :)
> 
> I just concerned if qemu consider to use this interface for their event
> log :) 
> 
Yep, agree. It sounds like taking an index'd approach as you first
suggested is worth the complexity. I want to make sure you and Steven
agree before attempting.

Thanks,
-Beau
