Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D24C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 02:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3DA461284
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 02:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbhKIC7X (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:59:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:59116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235446AbhKIC7W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 21:59:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E516161208;
        Tue,  9 Nov 2021 02:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636426597;
        bh=nA69mhZC7gKm2W+3rTZLdSNhkbCmnshUWRaZqMPLjdE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SsUwV/XcSS/SQbcfAhEVQAm+axV7wl6lecGQOS+5Aj9LeGYuo6ZVA+KK7jk7Aco5N
         tupDyAVBTZJwsP3k0bTLPZJYCtWPBGuKre6zriLJsNs0B+tykmYzwExsVIdE2rfdvX
         SbxfoDX7j/KMqDaTatO2LT4hCCzAkcwXjQ5Crh7T4HzLdeK51WOXgohFgCDyj38Co8
         b65FVi9CnKAkiChnFMTacg56bFe5GrZvOsTNi3l8AjCTyg5RYoVfu91yQWMKTVoQNk
         ZclaGhmpByVZpj2okLBg12V/VHmhUL9yqoqgdVGFFz7SX3p9oG4ts18d0M07CVZH1q
         PdEKxkRVcgQTQ==
Date:   Tue, 9 Nov 2021 11:56:34 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-Id: <20211109115634.5fb6d984d7b4e701c740d5f3@kernel.org>
In-Reply-To: <20211108202527.GA1862@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
        <20211104170433.2206-3-beaub@linux.microsoft.com>
        <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
        <20211108171336.GA1690@kbox>
        <20211108131639.33a4f186@gandalf.local.home>
        <20211108202527.GA1862@kbox>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 8 Nov 2021 12:25:27 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> On Mon, Nov 08, 2021 at 01:16:39PM -0500, Steven Rostedt wrote:
> > On Mon, 8 Nov 2021 09:13:36 -0800
> > Beau Belgrave <beaub@linux.microsoft.com> wrote:
> > 
> > 
> > > Does that mean the decoders in eprobes/histogram don't check event
> > > record sizes before accessing the data? Shouldn't that get fix
> > > centrally? That would mean a loaded module could do the same thing
> > > (user_events only works if the user has access to tracefs, so it's not
> > > like it's open to all users).
> > 
> > There's checks to make sure everything fits in eprobes and kprobes. If it
> > doesn't then the event is simply dropped.
> > 
> > For example, if you look at __eprobe_trace_func() in trace_eprobe.c, you'll
> > see that it calls get_eprobe_size(), which goes through and just reads what
> > it is about to accept. Then it reserves the amount of data on the ring
> > buffer, and then calls store_trace_args() which also passes in the size
> > that it found, in case things change. If it's too big, it only records what
> > it originally intended.
> > 
> > -- Steve
> 
> It seems there are 2 concerns:
> 1. If data comes in and it's not in the size that is specified, it's
> suspicious and should either be truncated or ignored. Maybe under
> ignore, over truncate.

Yes, this is for the events which is defined with fixed-size
parameters and what I suggested.

> 
> 2. If the data is more than specified, it must be checked to see if
> there are __data_loc / __rel_loc entries and they must be validated as
> within range of accepted limits. If there are no __data_loc / __rel_loc
> it should either be truncated or ignored.

Yes, this is for the events, which is defined with variable length
parameters, like null-terminated string. In this case, along with the
__data/__rel_loc validation, it needs a null termination check.

> 
> Is there more that I may have missed?
> 
> I'd like to know if I do fix them that the features like filtering will still
> be available to user_events or if it's better to just add flags to disable
> kernel filtering?

I would rather like that the filters will be available on the user_events.

My question is that you need to log the dynamic data or strings via user-
events or not. Since the other user-events, like SDT doesn't support the
string variables to trace, I guess that is not a high priority.

Moreover, since now we can use eprobes, if user event records the address of
user-string, the eprobes can fetch it.

So, my suggestion is implmenting with fixed-size parameters as the first step
and keep filter/histograms/eprobes available on the user-events.
If you find any performance issue, you can expand the user-events to support
dynamic (array) data and strings.

> 
> I'm still unsure this is limited to just user_events.
> 
> For example, why doesn't filter_pred_strloc and filter_pred_pchar in
> trace_events_filter.c check the boundary it will be accessing?

Because all data is written from the kernel code. We can trust the data
exists on the buffer. (If not, there is an actual BUG in the kenrel)
We can add a verifieer for the debug purpose.

> 
> It seems like tracepoints from kernel modules, while more trusted, can also
> cause this kind of thing due to bugs, etc.

Of course, and that must be fixed. And, the tracepoints (traceevents) should
be automatically generated code, that is more trusted than the events crafted
by user.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
