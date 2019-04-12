Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF3FC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 15:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99B4121872
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 15:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfDLPmD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 11:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbfDLPmD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 11:42:03 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C60A92082E;
        Fri, 12 Apr 2019 15:42:01 +0000 (UTC)
Date:   Fri, 12 Apr 2019 11:42:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Raul Rangel <rrangel@chromium.org>
Cc:     linux-trace-devel@vger.kernel.org, linux-mmc@vger.kernel.org,
        djkurtz@chromium.org, zwisler@chromium.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v1 1/4] trace_events: Add trace_print_register to print
 register fields
Message-ID: <20190412114200.6c1a8593@gandalf.local.home>
In-Reply-To: <20190412153036.GB101407@google.com>
References: <20190411220822.81845-1-rrangel@chromium.org>
        <20190411220822.81845-2-rrangel@chromium.org>
        <20190411183934.28e6ad65@gandalf.local.home>
        <20190412153036.GB101407@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 09:30:36 -0600
Raul Rangel <rrangel@chromium.org> wrote:

> Ah, I wasn't aware that the format was exposed via sysfs. That makes
> sense why the macros are used. I was using xhci-trace as my reference
> point which just calls arbitrary functions.
> 
> cat /sys/kernel/debug/tracing/events/xhci-hcd/xhci_handle_event/format
> print fmt: "%s: %s",
> xhci_ring_type_string(REC->type),
> xhci_decode_trb(REC->field0, REC->field1, REC->field2, REC->field3)
> 
> I'm guessing calling out to a function is not the way the framework was
> intended to be used. Does this mean that every TRB type in xhci_decode_trb
> should be its own trace event so the printf format isn't hidden inside
> the code?

You can add plugins to handle this. See tools/lib/traceevent/plugin_*.c

> 
> > 
> > How does perf or trace-cmd parse this? To add something like this, you
> > need them to have the same output as what is displayed by the trace
> > file otherwise NAK.  
> 
> So for the short term I can remove __print_register. The SDHCI tracing
> doesn't use it, but instead calls out to a method that calls
> trace_print_register directly. Or I could move trace_print_register
> into the sdhci-trace module.

For the short term yeah. And you can add a plugin to the libtraceevent
to teach trace-cmd and perf how to parse it.
See "tep_register_print_function()"

> 
> cat /sys/kernel/debug/tracing/events/sdhci/sdhci_read/format
> 
> print fmt: "%s: %#x [%s] => %#x: %s",
>   __get_str(name),
>   REC->reg,
>   __print_symbolic(REC->reg & ~3UL, {0x00, "DMA_ADDRESS"}, ...),
>   REC->val,
>   sdhci_decode_register( p, REC->reg, REC->val, REC->mask )
> 
> The format prints out the raw value, so using perf or trace-cmd
> will still have value, you just won't get the pretty print.
> 
> For the long term I could make event-parser handle __print_register. I'm
> assuming it just needs to handle the additional case?
> https://github.com/torvalds/linux/blob/master/tools/lib/traceevent/event-parse.c#L3040
> 

Yes, I'm fine with adding new generic functions that can parse the code
properly to libtraceevent. Anything added to the trace_event code
should have a corresponding routine added to libtraceevent. Just
remember, that those *are* user API, and once made, they can not change.

Thanks!

-- Steve
