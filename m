Return-Path: <SRS0=JN9e=RH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DF2C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Mar 2019 18:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C722320823
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Mar 2019 18:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfCDSvu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Mar 2019 13:51:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:33826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbfCDSvu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Mar 2019 13:51:50 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 297E6206BA;
        Mon,  4 Mar 2019 18:51:49 +0000 (UTC)
Date:   Mon, 4 Mar 2019 13:51:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Claudio <claudio.fontana@gliwa.com>
Cc:     joel@joelfernandes.org,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>, Chunyu Hu <chuhu@redhat.com>
Subject: Re: make TGID available also in binary ring buffer?
Message-ID: <20190304135147.5fcc243f@gandalf.local.home>
In-Reply-To: <6e61f5ff-5302-ad96-66d3-38347bf3cf69@gliwa.com>
References: <6e61f5ff-5302-ad96-66d3-38347bf3cf69@gliwa.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 4 Mar 2019 11:01:39 +0100
Claudio <claudio.fontana@gliwa.com> wrote:

> Hello all,
> 
> I am currently facing the issue of having to efficiently read the events
> from a user-space application for tracing for programmatic use in automotive
> (AUTOSAR AP).
> 
> It is for programmatically reacting to events on the system,
> and I am currently using the trace_pipe_raw to do that, to reduce the
> overhead compared with parsing the textual output of trace_pipe.
> 
> After merging the sorted streams from all cpus, in order to reconstruct
> the task state, we are still way more CPU-efficient compared with using the
> textual output.
> 
> I would like to make use of the implemented support for recording tgids,
> 
> commit d914ba37d714 ("tracing: Add support for recording tgid of tasks")
> commit 441dae8f2f29 ("tracing: Add support for display of tgid in trace output")
> 
> but it seems to me that, while for COMM recording there is explicit support in
> the binary events for the information, it seems that tgid is not stored in the
> binary format.
> 
> Is such an extension of the binary format a possibility for sched-class
> events, that takes into account backward compatibility, or is there some
> better way to do it? Is this problem addressed by libtracevent / trace-cmd?
> 
> Currently I was thinking to look into the NETLINK interface to get the task
> information, however the issue is the race condition between the time of
> tracing and the time of reading the trace, to be fully correct, but if
> nothing else is possible I will have to accept the compromise.
> 
> Thank you for any hints on this.

It looks to be outputted into /sys/kernel/debug/tracing/saved_tgids

Interesting, we should probably save that in trace-cmd as well.

-- Steve
