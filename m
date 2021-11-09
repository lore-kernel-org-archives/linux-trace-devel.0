Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D43FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 19:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECE0961181
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 19:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242908AbhKITLh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Nov 2021 14:11:37 -0500
Received: from linux.microsoft.com ([13.77.154.182]:54602 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbhKITLf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 14:11:35 -0500
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id D8BA820C34C8;
        Tue,  9 Nov 2021 11:08:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D8BA820C34C8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636484928;
        bh=cknltwEoY7oklYnDkYTarvNvRaUsQp6joj++E4ZJNI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qYUpMG6WIRsGID8wWnKrWPD1ZyKKezAe6yrEjHmu+MPmP76rdriJbsJBnt7SKrBFV
         0M4cx1tZIV7GrtZo0PRTanUfvTkb1sw01teu6IdjVoo433wdhdFJTZTth27AfJ6Pib
         9rzy4XDjOGfD23uG0blAEg95epD1qXIwj0nqh5lw=
Date:   Tue, 9 Nov 2021 11:08:44 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211109190844.GA1529@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
 <20211104170433.2206-3-beaub@linux.microsoft.com>
 <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
 <20211108171336.GA1690@kbox>
 <20211108131639.33a4f186@gandalf.local.home>
 <20211108202527.GA1862@kbox>
 <20211109115634.5fb6d984d7b4e701c740d5f3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109115634.5fb6d984d7b4e701c740d5f3@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Nov 09, 2021 at 11:56:34AM +0900, Masami Hiramatsu wrote:
> On Mon, 8 Nov 2021 12:25:27 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > On Mon, Nov 08, 2021 at 01:16:39PM -0500, Steven Rostedt wrote:
> > > On Mon, 8 Nov 2021 09:13:36 -0800
> > > Beau Belgrave <beaub@linux.microsoft.com> wrote:
> > > 
> > > 
> > > > Does that mean the decoders in eprobes/histogram don't check event
> > > > record sizes before accessing the data? Shouldn't that get fix
> > > > centrally? That would mean a loaded module could do the same thing
> > > > (user_events only works if the user has access to tracefs, so it's not
> > > > like it's open to all users).
> > > 
> > > There's checks to make sure everything fits in eprobes and kprobes. If it
> > > doesn't then the event is simply dropped.
> > > 
> > > For example, if you look at __eprobe_trace_func() in trace_eprobe.c, you'll
> > > see that it calls get_eprobe_size(), which goes through and just reads what
> > > it is about to accept. Then it reserves the amount of data on the ring
> > > buffer, and then calls store_trace_args() which also passes in the size
> > > that it found, in case things change. If it's too big, it only records what
> > > it originally intended.
> > > 
> > > -- Steve
> > 
> > It seems there are 2 concerns:
> > 1. If data comes in and it's not in the size that is specified, it's
> > suspicious and should either be truncated or ignored. Maybe under
> > ignore, over truncate.
> 
> Yes, this is for the events which is defined with fixed-size
> parameters and what I suggested.
> 

Thanks.

> > 
> > 2. If the data is more than specified, it must be checked to see if
> > there are __data_loc / __rel_loc entries and they must be validated as
> > within range of accepted limits. If there are no __data_loc / __rel_loc
> > it should either be truncated or ignored.
> 
> Yes, this is for the events, which is defined with variable length
> parameters, like null-terminated string. In this case, along with the
> __data/__rel_loc validation, it needs a null termination check.
> 

Got it.

> > 
> > Is there more that I may have missed?
> > 
> > I'd like to know if I do fix them that the features like filtering will still
> > be available to user_events or if it's better to just add flags to disable
> > kernel filtering?
> 
> I would rather like that the filters will be available on the user_events.
> 
> My question is that you need to log the dynamic data or strings via user-
> events or not. Since the other user-events, like SDT doesn't support the
> string variables to trace, I guess that is not a high priority.
> 
> Moreover, since now we can use eprobes, if user event records the address of
> user-string, the eprobes can fetch it.
> 
> So, my suggestion is implmenting with fixed-size parameters as the first step
> and keep filter/histograms/eprobes available on the user-events.
> If you find any performance issue, you can expand the user-events to support
> dynamic (array) data and strings.
> 

We need strings to be able to be emitted and recorded in eBPF, perf and
ftrace. So I would rather go after a solution that lets us keep these in
the ring buffers, even if it means a perf hit.

Guess what's left is to where the best place to check is, checking in
the filter with unsafe flags would let us keep most of the perf (we just
check the undersize case, 1 branch). When these unsafe types are
filtered then a perf tax is imposed to keep things safe.

It sounded like Steven wanted to think about this a bit, so I'll wait a
bit before poking again for consensus :)

Do you have any strong feelings about where it goes?

Thanks,
-Beau
