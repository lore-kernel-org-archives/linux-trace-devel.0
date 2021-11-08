Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1D9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 21:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFE0F619E2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 21:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbhKHVDX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 16:03:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230126AbhKHVDO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 16:03:14 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 255AB61051;
        Mon,  8 Nov 2021 21:00:29 +0000 (UTC)
Date:   Mon, 8 Nov 2021 16:00:27 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211108160027.3b16c23d@gandalf.local.home>
In-Reply-To: <20211108202527.GA1862@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
        <20211104170433.2206-3-beaub@linux.microsoft.com>
        <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
        <20211108171336.GA1690@kbox>
        <20211108131639.33a4f186@gandalf.local.home>
        <20211108202527.GA1862@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 8 Nov 2021 12:25:27 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> It seems there are 2 concerns:
> 1. If data comes in and it's not in the size that is specified, it's
> suspicious and should either be truncated or ignored. Maybe under
> ignore, over truncate.
> 
> 2. If the data is more than specified, it must be checked to see if
> there are __data_loc / __rel_loc entries and they must be validated as
> within range of accepted limits. If there are no __data_loc / __rel_loc
> it should either be truncated or ignored.
> 
> Is there more that I may have missed?
> 
> I'd like to know if I do fix them that the features like filtering will still
> be available to user_events or if it's better to just add flags to disable
> kernel filtering?

If these are "user defined" then perhaps we add a wrapper to the filtering
that is called instead of the normal filtering for theses events that
verify the fields of the events being filtered are located on the ring
buffer. Although, strings and such are rare or just slow in filtering that
we could make sure the content is still on the buffer that is being
filtered.

> 
> I'm still unsure this is limited to just user_events.
> 
> For example, why doesn't filter_pred_strloc and filter_pred_pchar in
> trace_events_filter.c check the boundary it will be accessing?
> 
> It seems like tracepoints from kernel modules, while more trusted, can also
> cause this kind of thing due to bugs, etc.

Yes, it's the fact that the code is created in the kernel, and the only way
that the filtering could be out of bounds is if there's a bug in the
kernel. We rather not check for that if it slows down the tracing. But
perhaps if we can show that the checks are only done for dynamic strings
and arrays, that it doesn't cause noticeable overhead, it may be fine to
keep for all events.

-- Steve

