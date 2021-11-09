Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A233C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 04:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BBC2611C0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 04:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhKIFAv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Nov 2021 00:00:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhKIFAv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 00:00:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0476F61179;
        Tue,  9 Nov 2021 04:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636433885;
        bh=ZrKPKgzZsAwNlX7/3JXYgD4rEihElzuohXk+XD9FA3M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z621DomU5ng3AAxpre9PPZwyof1cPXu/8U7Suu/xF6rBAiSY4PKrCWHZoAfmKHltc
         W0PRjvyY09kyR6C0ETX6Bg6YD+2FD6u6TsQrmcvQFFFaCjrh3T8xMaP8ay0fhBLGXE
         KK1tY2iZZmPjqu5fugJJC7D1QduUN4Et1Em/jpQgYuKxPLs87atv7ShJoVuya/3RO8
         DbO5GuScQYMin6xytGLjhHwbgn4+vf4sGYkkMqjtJxKx0V6bTbvx5hE0+ho3mnD2ec
         6x8Y+EW4mAhJyp1chBs6i3aQPoblCaeOnuC8E4Ehm/YjLWLTtccSelvcJ1SXKVjPZc
         bDm/gOYjGlEcw==
Date:   Tue, 9 Nov 2021 13:58:03 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-Id: <20211109135803.0ff26dc3f47d2119bc264045@kernel.org>
In-Reply-To: <20211108220945.GA2148@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
        <20211104170433.2206-3-beaub@linux.microsoft.com>
        <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
        <20211108171336.GA1690@kbox>
        <20211108131639.33a4f186@gandalf.local.home>
        <20211108202527.GA1862@kbox>
        <20211108160027.3b16c23d@gandalf.local.home>
        <20211108220945.GA2148@kbox>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 8 Nov 2021 14:09:45 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> On Mon, Nov 08, 2021 at 04:00:27PM -0500, Steven Rostedt wrote:
> > On Mon, 8 Nov 2021 12:25:27 -0800
> > Beau Belgrave <beaub@linux.microsoft.com> wrote:
> > 
> > > It seems there are 2 concerns:
> > > 1. If data comes in and it's not in the size that is specified, it's
> > > suspicious and should either be truncated or ignored. Maybe under
> > > ignore, over truncate.
> > > 
> > > 2. If the data is more than specified, it must be checked to see if
> > > there are __data_loc / __rel_loc entries and they must be validated as
> > > within range of accepted limits. If there are no __data_loc / __rel_loc
> > > it should either be truncated or ignored.
> > > 
> > > Is there more that I may have missed?
> > > 
> > > I'd like to know if I do fix them that the features like filtering will still
> > > be available to user_events or if it's better to just add flags to disable
> > > kernel filtering?
> > 
> > If these are "user defined" then perhaps we add a wrapper to the filtering
> > that is called instead of the normal filtering for theses events that
> > verify the fields of the events being filtered are located on the ring
> > buffer. Although, strings and such are rare or just slow in filtering that
> > we could make sure the content is still on the buffer that is being
> > filtered.
> > 
> 
> It seems like both histograms and filter both reference field flags to
> determine how to get the data.
> 
> How would you feel about another FILTER_* flag on fields, like:
> FILTER_DYN_STRING_SAFE
> FILTER_PTR_STRING_SAFE
> 
> user_events when parsing would instead of leaving FILTER_OTHER for
> __data_loc / __rel_loc switch to the above.
> 
> The predicate filter method would then switch based on those types to
> safer versions.
> 
> That way other parts could take advantage of this if needed beyond
> user_events.
> 
> If this is addressed at the filter/histogram level, would then the write
> callsites still check bounds per-write? Or maybe only care about the
> undersized data cases?

Even with the unsafe flags, I think the callsites still needs
the undersized check at least. It may have the maxsize and minsize
for the events. If the event defined with dynamic data
(__data_loc/__rel_loc), minsize is the sum of the field size and
maxsize will be the PAGE_SIZE (or smaller than that). If the event
has no dynamic data field, minsize == maxsize.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
