Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57042C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 13:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3044A60F48
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 13:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345918AbhIXNTM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 09:19:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347215AbhIXNSD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 09:18:03 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 005B760F4C;
        Fri, 24 Sep 2021 13:16:28 +0000 (UTC)
Date:   Fri, 24 Sep 2021 09:16:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Eugene Syromyatnikov <evgsyr@gmail.com>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/2] tracing: Have trace_pid_list be a sparse array
Message-ID: <20210924091627.645a8fd3@gandalf.local.home>
In-Reply-To: <CACGkJdtsHWBstw_Gzb-Dq4Xs_eAW1jsARr5wbh0yE_=NsPA5bw@mail.gmail.com>
References: <20210924033547.939554938@goodmis.org>
        <20210924000717.310b492a@rorschach.local.home>
        <CACGkJdtsHWBstw_Gzb-Dq4Xs_eAW1jsARr5wbh0yE_=NsPA5bw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 24 Sep 2021 12:51:07 +0200
Eugene Syromyatnikov <evgsyr@gmail.com> wrote:

Hi Eugene,

> Note that there is only one top-level chunk (so its size doesn't
> matter much), (usually) about one middle-tier chunk (except for some
> heavy cases, since pids are allocated linearly), and quite some
> lower-tier bitset leaves.  So I'd optimise towards smaller leaves at
> the expense of middle-tier (and especially top-tier) chunk size
> (especially considering the fact that in the kernel, buddy allocator
> is used), like 12-8-12 or something like that, but I have no factual

What I really like about my 8 8 14 split I have, it makes everything 2K in
size on 64 bit machines (1K 1K 2K for 32 bit, but who cares ;-)

 1 << 8 * 8 bytes = 2K   // top tiers are pointers to lower tiers
 1 << 14 bits = 2K       // lower tier only cares about bits

This means they will likely all be allocated in the same slab.

I'm optimizing the top tiers for size, because they are likely to be empty.
Why add memory for something that will never be used, and can't be removed.
Note, the middle and lower tiers can be reused when they go empty, which is
a likely use case (at least when I test this using hackbench).

> basis for arguing about specific split.  Also, I cannot resist from
> noticing that this reminds me an awful lot of XArray and [1].  Maybe,
> some wrapper around XArray would do?
> 
> [1] https://gitlab.com/strace/strace/-/raw/master/src/trie.h
> 

I looked into xarray and it appears to be optimized for storing something,
where as I'm just interested in a sparse bitmask.

Thanks for the review.

Note, I'll be posting a v3 soon because I found if I echo 1<<30 into
set_event_pid, it adds 0 (because it only looks at the bottom 30 bits).
It should really return -EINVAL.

-- Steve
