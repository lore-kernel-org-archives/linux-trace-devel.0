Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D730DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 19:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7C8461211
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 19:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243126AbhKIT14 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Nov 2021 14:27:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235259AbhKIT1z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 14:27:55 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB19F61208;
        Tue,  9 Nov 2021 19:25:07 +0000 (UTC)
Date:   Tue, 9 Nov 2021 14:25:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211109142506.3c280469@gandalf.local.home>
In-Reply-To: <20211109190844.GA1529@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
        <20211104170433.2206-3-beaub@linux.microsoft.com>
        <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
        <20211108171336.GA1690@kbox>
        <20211108131639.33a4f186@gandalf.local.home>
        <20211108202527.GA1862@kbox>
        <20211109115634.5fb6d984d7b4e701c740d5f3@kernel.org>
        <20211109190844.GA1529@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 9 Nov 2021 11:08:44 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> We need strings to be able to be emitted and recorded in eBPF, perf and
> ftrace. So I would rather go after a solution that lets us keep these in
> the ring buffers, even if it means a perf hit.
> 
> Guess what's left is to where the best place to check is, checking in
> the filter with unsafe flags would let us keep most of the perf (we just
> check the undersize case, 1 branch). When these unsafe types are
> filtered then a perf tax is imposed to keep things safe.
> 
> It sounded like Steven wanted to think about this a bit, so I'll wait a
> bit before poking again for consensus :)
> 
> Do you have any strong feelings about where it goes?

IIUC, the writing into the trace event is done via one big blob, correct?

That is this:

+	if (likely(atomic_read(&tp->key.enabled) > 0)) {
+		struct tracepoint_func *probe_func_ptr;
+		user_event_func_t probe_func;
+		void *tpdata;
+		void *kdata;
+		u32 datalen;
+
+		kdata = kmalloc(i->count, GFP_KERNEL);
+
+		if (unlikely(!kdata))
+			return -ENOMEM;
+
+		datalen = copy_from_iter(kdata, i->count, i);
+
+		rcu_read_lock_sched();
+
+		probe_func_ptr = rcu_dereference_sched(tp->funcs);
+
+		if (probe_func_ptr) {
+			do {
+				probe_func = probe_func_ptr->func;
+				tpdata = probe_func_ptr->data;
+				probe_func(user, kdata, datalen, tpdata);
+			} while ((++probe_func_ptr)->func);
+		}
+
+		rcu_read_unlock_sched();
+
+		kfree(kdata);

So we really are just interested in making sure that the output is correct?

That is, the reading of the trace file?

-- Steve
