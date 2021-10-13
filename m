Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D40ADC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 15:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8598610A0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 15:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhJMPmk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 11:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbhJMPmk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 11:42:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E4BE610A0;
        Wed, 13 Oct 2021 15:40:36 +0000 (UTC)
Date:   Wed, 13 Oct 2021 11:40:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-ID: <20211013114034.13daac32@gandalf.local.home>
In-Reply-To: <20211014002132.ee7668a4790ea75b0f7a9ceb@kernel.org>
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
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 Oct 2021 00:21:32 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> > This approach requires an FD returned and either an int for the status
> > page or the returend FD could expose the ID via another IOCTL being
> > issued.  
> 
> OK, I would like to suggest you to add events/user-events/*/marker file
> (which returns that shared file struct backed FD) so that some simple
> user scripts can also send the events (these may not use ioctl, just
> write the events.) But this can be done afterwards anyway.
> 

I'd prefer we avoid this. It will break some of the semantics of the events
directory. One, only "user-events" will have this "marker" file. Although
it will be very similar to the "inject" file, but that's only for debugging
anyway.

All the files in the events directory is starting to add a bunch of
overhead, as they are typically copied into the instances. Although, when
we get the eventfs directory created, maybe that will not be as big of a
deal. But that still doesn't fix the semantics issue.

-- Steve

