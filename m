Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D54C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 13:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40E3E61104
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 13:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhKJN7V (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Nov 2021 08:59:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231460AbhKJN7U (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 08:59:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77F36610FC;
        Wed, 10 Nov 2021 13:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636552593;
        bh=EuP/VlAeIDY5tLCRfz2qT/DBs8AmsePg/eemPlSyrPI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M/p7su7S8FuKiIxan6QlfSK8GuYJZTK3hFeF9sAKIpVJJ7/ybxVBlIWInry0WiDr/
         5l5ohbG7llY5/2ZoauaxqtV3SnNGrugpiwUkzasihhPAhCXKVSPLQI/en12Xux73/k
         ccHZQwkhv8eBdjBoWgbQnHHiTPUEmB0hQTQ9dj48AWKKQbhhwMSm9H70n0tTGY7ZzB
         fdOFaxpYmH+7xFeGV5r9ogxzj4jls6S7mSet39TJMwh6p2omSoercINtxigCeezKfa
         jL2a6xFcSl/6HoagSDqDwfF4UKHlZZ+53T+eloXjwRAu4FiNZ1eJIdoHlOyb4hnXx9
         pKzzueGJOy8jA==
Date:   Wed, 10 Nov 2021 22:56:30 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-Id: <20211110225630.babcd70ec85f97e369b0e446@kernel.org>
In-Reply-To: <20211109190844.GA1529@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
        <20211104170433.2206-3-beaub@linux.microsoft.com>
        <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
        <20211108171336.GA1690@kbox>
        <20211108131639.33a4f186@gandalf.local.home>
        <20211108202527.GA1862@kbox>
        <20211109115634.5fb6d984d7b4e701c740d5f3@kernel.org>
        <20211109190844.GA1529@kbox>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 9 Nov 2021 11:08:44 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> > > I'd like to know if I do fix them that the features like filtering will still
> > > be available to user_events or if it's better to just add flags to disable
> > > kernel filtering?
> > 
> > I would rather like that the filters will be available on the user_events.
> > 
> > My question is that you need to log the dynamic data or strings via user-
> > events or not. Since the other user-events, like SDT doesn't support the
> > string variables to trace, I guess that is not a high priority.
> > 
> > Moreover, since now we can use eprobes, if user event records the address of
> > user-string, the eprobes can fetch it.
> > 
> > So, my suggestion is implmenting with fixed-size parameters as the first step
> > and keep filter/histograms/eprobes available on the user-events.
> > If you find any performance issue, you can expand the user-events to support
> > dynamic (array) data and strings.
> > 
> 
> We need strings to be able to be emitted and recorded in eBPF, perf and
> ftrace. So I would rather go after a solution that lets us keep these in
> the ring buffers, even if it means a perf hit.

OK, my concern is based on the current implementation, so in that case
you can add some additional verification. That is good.

> Guess what's left is to where the best place to check is, checking in
> the filter with unsafe flags would let us keep most of the perf (we just
> check the undersize case, 1 branch). When these unsafe types are
> filtered then a perf tax is imposed to keep things safe.

I would like to keep verifying in writer side then we can ensure the
data on ring buffer (of perf and of ftrace) is sane. If you add the unsafe
flag, you have to change all the code which access the ring buffer, not only
the filter but also eprobes, histograms, perf-tools, and other user-space
tracing tools which reads the tracing buffer directly.

> It sounded like Steven wanted to think about this a bit, so I'll wait a
> bit before poking again for consensus :)
> 
> Do you have any strong feelings about where it goes?

I recommend you to start verifying the writer side, it should make the
change as small as possible. Unsafe flag idea may involve many other
tools. And it is not fundamentary required for user-events.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
