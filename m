Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F5FC4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 22:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 217B460525
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 22:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhHCWwR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 18:52:17 -0400
Received: from linux.microsoft.com ([13.77.154.182]:37120 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbhHCWwR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 18:52:17 -0400
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id A5D0A2096B72;
        Tue,  3 Aug 2021 15:52:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A5D0A2096B72
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1628031125;
        bh=lsrJadPryzSz8V+os+spzFp4XGnyDpDIe/2Nd4qTJlk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hP+pP0qKjJKJo+eXXmn5KpXr3nWPNjq9Ss7SBmddLoqggo3YMUy4IK3eMyQIfhT3d
         +l7RruSnudk6QlEKtxPPbHnhZgAskdAgGrJthVBs69MwaA0WNfcJdoJa0e/TRwmaFp
         Ja7pZu8zZbRfJxAm27qe1anEqAbdkHUBLsZPA9MY=
Date:   Tue, 3 Aug 2021 15:52:00 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH] udiag - User mode to trace_event (ftrace, perf,
 eBPF) ABI
Message-ID: <20210803225200.GA2792@kbox>
References: <20210727193535.10326-1-beaub@linux.microsoft.com>
 <20210803171743.36115d4c@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803171743.36115d4c@oasis.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Aug 03, 2021 at 05:17:43PM -0400, Steven Rostedt wrote:
> 
> Hi Beau,
> 
> BTW, feel free to Cc LKML too (linux-kernel@vger.kernel.org)
> 
> 
> On Tue, 27 Jul 2021 12:35:35 -0700
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > User mode processes that require emitting diagnostic data are currently
> > limited to using uprobes to get data into trace_events. The udiag ABI
> > offers a way for user mode processes to write diagnostic data to
> > trace_events much faster than the uprobe die chain handler.
> > 
> > In addition a shared page is exposed out to registered user processes
> > that is used to enable single branch checking for if the trace_event is
> > being traced. This allows equivalent overhead as a uprobe site when
> > tracing is not enabled.
> > 
> > User processes register a trace_event to use via a device exposed at
> > /dev/udiag. System owners can write udev rules to decide the security
> > boundary. udiag is limited to only a page size worth of trace_events
> > that are isolated and put under the udiag subsystem. User processes
> > write events out via /dev/udiag. This allows for many languages and
> > processes to contribute the same events regardless of where in the code
> > the event was generated. This allows common code to be shared and
> > centrally processed on the machine within a eBPF program regardless how
> > the code has evolved as long as the data within the event follows the
> > same data format as before.
> > 
> > An example of this is common error conditions that can happen across a
> > suite of processes. A single eBPF program can watch for the single event
> > across all processes, regardless of binary location or language used to
> > create the process. Once problems are found, additional eBPF programs
> > can be launched to impose further tracing, run mitigations, etc.
> > 
> > Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> >
> 
> Can you provide user space code that would show a use case of this
> implementation. Understanding exactly what is expected on the user side
> will help tremendously with understanding the kernel side.
> 
> Thanks,
> 
> -- Steve
Sure thing, and thanks for the reply! I appreciate it.

For clarity, would you like a resend with the user mode code in the
description or would you like an in-thread example?

Thanks,
-Beau
