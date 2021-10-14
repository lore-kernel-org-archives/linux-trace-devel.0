Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2846DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Oct 2021 12:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08EA861130
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Oct 2021 12:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhJNMXK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Oct 2021 08:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhJNMXJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Oct 2021 08:23:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3165D610D2;
        Thu, 14 Oct 2021 12:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634214064;
        bh=6MYhIBKkvZclfN4psLIYQ4kVgjVd2GVmYFz+UPiZ/Pg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WbayizYk7WzsrBZN3HfEWfYgVrARkIds9C9nf24q7826IeXPtMwbZN4UA9hD/5tc7
         b/raJcYzkouJUdf4POelIDT9Hgwj/oLkLEm6R6wxp56Egb1HQKv4hkalAvtrsRw5E6
         BpU+8EwrgZQO3GJRbU/KAWRVCdKEfzSMRDZsGlFxQHnAH02A2iw26EAstuC4F1Tm+X
         Nadwl2uxo+UVH2QwkP3Pq73vy/NosE6GUXaCVzuvLyHlqsmGZYmERx3u/vQxTwDZmN
         2EFgyPcm0FLurfC7bHj+EJ8CaxE2gW6hNogcRnNZXj5pettC0MwmMuYBybLO9L9AAE
         A2SDRirGfN1sQ==
Date:   Thu, 14 Oct 2021 21:21:01 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-Id: <20211014212101.d6bddbac7206cba0401c8675@kernel.org>
In-Reply-To: <20211013114034.13daac32@gandalf.local.home>
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
        <20211013114034.13daac32@gandalf.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 Oct 2021 11:40:34 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 14 Oct 2021 00:21:32 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > > This approach requires an FD returned and either an int for the status
> > > page or the returend FD could expose the ID via another IOCTL being
> > > issued.  
> > 
> > OK, I would like to suggest you to add events/user-events/*/marker file
> > (which returns that shared file struct backed FD) so that some simple
> > user scripts can also send the events (these may not use ioctl, just
> > write the events.) But this can be done afterwards anyway.
> > 
> 
> I'd prefer we avoid this. It will break some of the semantics of the events
> directory. One, only "user-events" will have this "marker" file.

Yes, it is only for the user-events.

> Although
> it will be very similar to the "inject" file, but that's only for debugging
> anyway.

Oh, do we already the "inject" file?

> All the files in the events directory is starting to add a bunch of
> overhead, as they are typically copied into the instances. Although, when
> we get the eventfs directory created, maybe that will not be as big of a
> deal. But that still doesn't fix the semantics issue.

Indeed. OK, making "marker" file for each instances may confuse user because
the written event itself must be delivered to any instance but the file
seems to belong to one of them. Please ignore it.

Thank you,

> 
> -- Steve
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
