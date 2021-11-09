Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A104FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 20:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8503261211
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 20:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244726AbhKIUsP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Nov 2021 15:48:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244658AbhKIUsK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 15:48:10 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48B8661207;
        Tue,  9 Nov 2021 20:45:23 +0000 (UTC)
Date:   Tue, 9 Nov 2021 15:45:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211109154520.11995e75@gandalf.local.home>
In-Reply-To: <20211109201432.GA1650@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
        <20211104170433.2206-3-beaub@linux.microsoft.com>
        <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
        <20211108171336.GA1690@kbox>
        <20211108131639.33a4f186@gandalf.local.home>
        <20211108202527.GA1862@kbox>
        <20211109115634.5fb6d984d7b4e701c740d5f3@kernel.org>
        <20211109190844.GA1529@kbox>
        <20211109142506.3c280469@gandalf.local.home>
        <20211109201432.GA1650@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 9 Nov 2021 12:14:32 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> The ftrace probe will have a blob even after optimization due to the copy
> into the ring buffer (assuming we can discard it if it violates a policy).

Yes it can be discarded. In fact, when filtering is enabled, it tries to
first use a temporary per cpu buffer to do the filtering and not write it
into the ring buffer. Only when it passes the filter does it get injected.

For user events that happen in user context, it will always use this temp
buffer. But since there's only buffer per CPU, if an interrupt comes in and
executes a filtered event, it will use the ring buffer itself, and discard
it if it does not match.

> 
> > That is, the reading of the trace file?
> >   
> 
> We really need to ensure that data can be analyzed on the machine
> directly (eBPF, ftrace, perf) as well as outside of the machine (ftrace, perf).
> 
> The priorities to us are fast recording speed with accurate reading of trace
> files and event data.

OK, then it probably isn't an issue to add checks to the parsing of the
dynamic arrays (including strings) that makes sure the string is within
bounds for the filtering.

-- Steve

