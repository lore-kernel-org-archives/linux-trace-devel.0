Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8685C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 21:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D246A610A0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 21:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245149AbhKIVar (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Nov 2021 16:30:47 -0500
Received: from linux.microsoft.com ([13.77.154.182]:39884 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236933AbhKIVar (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 16:30:47 -0500
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id 90D4220C34F1;
        Tue,  9 Nov 2021 13:28:00 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 90D4220C34F1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636493280;
        bh=GRpd/oDBvncA0+dkIYF+gXWruVjL4DVSDIZQtRJZ+LI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ROLYTeKADIDt+CADjhZCcJD7FpSmgR4iLii6McgtvHrITZNiCqupEHJ0FIAyl5vN4
         n9tCtXSTwyjLOd6bIABLPV9j7UvblV/nRtpbz7psTN1Vmt3h+fArrl66IwVnHL/63l
         hBgdTzFFXEOOpBFLBaFDDFnH4eh2Me/1UhcVyKNo=
Date:   Tue, 9 Nov 2021 13:27:56 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211109212756.GA1741@kbox>
References: <20211104170433.2206-3-beaub@linux.microsoft.com>
 <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
 <20211108171336.GA1690@kbox>
 <20211108131639.33a4f186@gandalf.local.home>
 <20211108202527.GA1862@kbox>
 <20211109115634.5fb6d984d7b4e701c740d5f3@kernel.org>
 <20211109190844.GA1529@kbox>
 <20211109142506.3c280469@gandalf.local.home>
 <20211109201432.GA1650@kbox>
 <20211109154520.11995e75@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109154520.11995e75@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Nov 09, 2021 at 03:45:20PM -0500, Steven Rostedt wrote:
> On Tue, 9 Nov 2021 12:14:32 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > The ftrace probe will have a blob even after optimization due to the copy
> > into the ring buffer (assuming we can discard it if it violates a policy).
> 
> Yes it can be discarded. In fact, when filtering is enabled, it tries to
> first use a temporary per cpu buffer to do the filtering and not write it
> into the ring buffer. Only when it passes the filter does it get injected.
> 
> For user events that happen in user context, it will always use this temp
> buffer. But since there's only buffer per CPU, if an interrupt comes in and
> executes a filtered event, it will use the ring buffer itself, and discard
> it if it does not match.
> 
> > 
> > > That is, the reading of the trace file?
> > >   
> > 
> > We really need to ensure that data can be analyzed on the machine
> > directly (eBPF, ftrace, perf) as well as outside of the machine (ftrace, perf).
> > 
> > The priorities to us are fast recording speed with accurate reading of trace
> > files and event data.
> 
> OK, then it probably isn't an issue to add checks to the parsing of the
> dynamic arrays (including strings) that makes sure the string is within
> bounds for the filtering.
> 
> -- Steve

Where were you thinking the filtering would occur? In the filter /
histogram predicates or in user_events directly before buffer commit?

Thanks,
-Beau
