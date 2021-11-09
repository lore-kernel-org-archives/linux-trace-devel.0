Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1125AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 20:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEA2E6115A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 20:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244221AbhKIURZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Nov 2021 15:17:25 -0500
Received: from linux.microsoft.com ([13.77.154.182]:32858 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242293AbhKIURX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 15:17:23 -0500
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id ED19320C34DF;
        Tue,  9 Nov 2021 12:14:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ED19320C34DF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636488877;
        bh=f54cLIP+LVhC9e3MFKCNzYbFVIHdBqUgz+HD0cCsXZ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aCfYfB1y7+lvAiP3gNLbaDoIpcL1OUW6ltw3X9uAPmOyo9iscOLTU/2BCbe5fmrdS
         HJf8iThoW4MfWlRSPVgzi/u2mUrEi7IJtHtBdPdIMjH7OEa8glmyIg5QgRJkW3JLz6
         rHywJTFvGAsbrOYFu4cz9aLnBtpw9HJUkNJSH7iQ=
Date:   Tue, 9 Nov 2021 12:14:32 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211109201432.GA1650@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
 <20211104170433.2206-3-beaub@linux.microsoft.com>
 <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
 <20211108171336.GA1690@kbox>
 <20211108131639.33a4f186@gandalf.local.home>
 <20211108202527.GA1862@kbox>
 <20211109115634.5fb6d984d7b4e701c740d5f3@kernel.org>
 <20211109190844.GA1529@kbox>
 <20211109142506.3c280469@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109142506.3c280469@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Nov 09, 2021 at 02:25:06PM -0500, Steven Rostedt wrote:
> On Tue, 9 Nov 2021 11:08:44 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > We need strings to be able to be emitted and recorded in eBPF, perf and
> > ftrace. So I would rather go after a solution that lets us keep these in
> > the ring buffers, even if it means a perf hit.
> > 
> > Guess what's left is to where the best place to check is, checking in
> > the filter with unsafe flags would let us keep most of the perf (we just
> > check the undersize case, 1 branch). When these unsafe types are
> > filtered then a perf tax is imposed to keep things safe.
> > 
> > It sounded like Steven wanted to think about this a bit, so I'll wait a
> > bit before poking again for consensus :)
> > 
> > Do you have any strong feelings about where it goes?
> 
> IIUC, the writing into the trace event is done via one big blob, correct?
> 

Yes, the top 4 bytes get trimmed off as an index, then it's a big blob
to all places except eBPF (when asking for the iterator directly).

> That is this:
> 
> +	if (likely(atomic_read(&tp->key.enabled) > 0)) {
> +		struct tracepoint_func *probe_func_ptr;
> +		user_event_func_t probe_func;
> +		void *tpdata;
> +		void *kdata;
> +		u32 datalen;
> +
> +		kdata = kmalloc(i->count, GFP_KERNEL);
> +
> +		if (unlikely(!kdata))
> +			return -ENOMEM;
> +
> +		datalen = copy_from_iter(kdata, i->count, i);
> +
> +		rcu_read_lock_sched();
> +
> +		probe_func_ptr = rcu_dereference_sched(tp->funcs);
> +
> +		if (probe_func_ptr) {
> +			do {
> +				probe_func = probe_func_ptr->func;
> +				tpdata = probe_func_ptr->data;
> +				probe_func(user, kdata, datalen, tpdata);
> +			} while ((++probe_func_ptr)->func);
> +		}
> +
> +		rcu_read_unlock_sched();
> +
> +		kfree(kdata);
> 
> So we really are just interested in making sure that the output is correct?
> 

Largely, yes.

The optimization part of the patch moves the buffer copies into the
probes to remove a double copy. I believe however that output can be
checked either centrally before the probes or within each probe call if
need be.

For perf/eBPF we may not need to check things, however, for ftrace
we will due to the filters. So we may be able to isolate to just the
ftrace probe method.

The ftrace probe will have a blob even after optimization due to the copy
into the ring buffer (assuming we can discard it if it violates a policy).

> That is, the reading of the trace file?
> 

We really need to ensure that data can be analyzed on the machine
directly (eBPF, ftrace, perf) as well as outside of the machine (ftrace, perf).

The priorities to us are fast recording speed with accurate reading of trace
files and event data.

> -- Steve
