Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E9CC4320A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 21:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B00E60F8F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 21:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhHCVSC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 17:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231519AbhHCVSC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 17:18:02 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9965160C3F;
        Tue,  3 Aug 2021 21:17:50 +0000 (UTC)
Date:   Tue, 3 Aug 2021 17:17:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH] udiag - User mode to trace_event (ftrace, perf,
 eBPF) ABI
Message-ID: <20210803171743.36115d4c@oasis.local.home>
In-Reply-To: <20210727193535.10326-1-beaub@linux.microsoft.com>
References: <20210727193535.10326-1-beaub@linux.microsoft.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Hi Beau,

BTW, feel free to Cc LKML too (linux-kernel@vger.kernel.org)


On Tue, 27 Jul 2021 12:35:35 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> User mode processes that require emitting diagnostic data are currently
> limited to using uprobes to get data into trace_events. The udiag ABI
> offers a way for user mode processes to write diagnostic data to
> trace_events much faster than the uprobe die chain handler.
> 
> In addition a shared page is exposed out to registered user processes
> that is used to enable single branch checking for if the trace_event is
> being traced. This allows equivalent overhead as a uprobe site when
> tracing is not enabled.
> 
> User processes register a trace_event to use via a device exposed at
> /dev/udiag. System owners can write udev rules to decide the security
> boundary. udiag is limited to only a page size worth of trace_events
> that are isolated and put under the udiag subsystem. User processes
> write events out via /dev/udiag. This allows for many languages and
> processes to contribute the same events regardless of where in the code
> the event was generated. This allows common code to be shared and
> centrally processed on the machine within a eBPF program regardless how
> the code has evolved as long as the data within the event follows the
> same data format as before.
> 
> An example of this is common error conditions that can happen across a
> suite of processes. A single eBPF program can watch for the single event
> across all processes, regardless of binary location or language used to
> create the process. Once problems are found, additional eBPF programs
> can be launched to impose further tracing, run mitigations, etc.
> 
> Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
>

Can you provide user space code that would show a use case of this
implementation. Understanding exactly what is expected on the user side
will help tremendously with understanding the kernel side.

Thanks,

-- Steve
