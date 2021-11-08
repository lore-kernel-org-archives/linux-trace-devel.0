Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE1DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 22:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4D2361506
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 22:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237771AbhKHWMf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 17:12:35 -0500
Received: from linux.microsoft.com ([13.77.154.182]:38890 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238013AbhKHWMe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 17:12:34 -0500
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8A90620B9D57;
        Mon,  8 Nov 2021 14:09:49 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8A90620B9D57
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636409389;
        bh=QHksv/J2fZ+/kB0QwvcRHr2z2JohTfl/QSUzGYNw74s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d75wc4EMY0XzaLmApwSty2ZpU8PjLdAH8c/EzpaxY3nhKgjlaMCUoRoO2PNnr/7Ba
         ggejr6CiFxkhxGhNnihvbh2mELiMfbcjQxaVYUcCS7BV1st9PmMQgkyDmUXEia+q+L
         O4isToeI3gNP8hCM/3iglb9BCCZzMWBVqMcqgq+g=
Date:   Mon, 8 Nov 2021 14:09:45 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211108220945.GA2148@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
 <20211104170433.2206-3-beaub@linux.microsoft.com>
 <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
 <20211108171336.GA1690@kbox>
 <20211108131639.33a4f186@gandalf.local.home>
 <20211108202527.GA1862@kbox>
 <20211108160027.3b16c23d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108160027.3b16c23d@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 08, 2021 at 04:00:27PM -0500, Steven Rostedt wrote:
> On Mon, 8 Nov 2021 12:25:27 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > It seems there are 2 concerns:
> > 1. If data comes in and it's not in the size that is specified, it's
> > suspicious and should either be truncated or ignored. Maybe under
> > ignore, over truncate.
> > 
> > 2. If the data is more than specified, it must be checked to see if
> > there are __data_loc / __rel_loc entries and they must be validated as
> > within range of accepted limits. If there are no __data_loc / __rel_loc
> > it should either be truncated or ignored.
> > 
> > Is there more that I may have missed?
> > 
> > I'd like to know if I do fix them that the features like filtering will still
> > be available to user_events or if it's better to just add flags to disable
> > kernel filtering?
> 
> If these are "user defined" then perhaps we add a wrapper to the filtering
> that is called instead of the normal filtering for theses events that
> verify the fields of the events being filtered are located on the ring
> buffer. Although, strings and such are rare or just slow in filtering that
> we could make sure the content is still on the buffer that is being
> filtered.
> 

It seems like both histograms and filter both reference field flags to
determine how to get the data.

How would you feel about another FILTER_* flag on fields, like:
FILTER_DYN_STRING_SAFE
FILTER_PTR_STRING_SAFE

user_events when parsing would instead of leaving FILTER_OTHER for
__data_loc / __rel_loc switch to the above.

The predicate filter method would then switch based on those types to
safer versions.

That way other parts could take advantage of this if needed beyond
user_events.

If this is addressed at the filter/histogram level, would then the write
callsites still check bounds per-write? Or maybe only care about the
undersized data cases?

> > 
> > I'm still unsure this is limited to just user_events.
> > 
> > For example, why doesn't filter_pred_strloc and filter_pred_pchar in
> > trace_events_filter.c check the boundary it will be accessing?
> > 
> > It seems like tracepoints from kernel modules, while more trusted, can also
> > cause this kind of thing due to bugs, etc.
> 
> Yes, it's the fact that the code is created in the kernel, and the only way
> that the filtering could be out of bounds is if there's a bug in the
> kernel. We rather not check for that if it slows down the tracing. But
> perhaps if we can show that the checks are only done for dynamic strings
> and arrays, that it doesn't cause noticeable overhead, it may be fine to
> keep for all events.
> 
> -- Steve

Thanks,
-Beau
