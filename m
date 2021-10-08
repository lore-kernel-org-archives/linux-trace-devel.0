Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB3C5C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 16:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A91EA61038
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 16:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhJHQLL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 12:11:11 -0400
Received: from linux.microsoft.com ([13.77.154.182]:51166 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhJHQLK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 12:11:10 -0400
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5456A20B8008;
        Fri,  8 Oct 2021 09:09:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5456A20B8008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1633709355;
        bh=UnIrqPOKl+mkN/WGQw8GhmtxEafQP5RjL/P7+8xfxj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y3JOx0vuEVsFkXQg4qtz3DqH2GSrbAo5R5ONFgFuUlnlY9YEFP2heLgP9S5cDVnCO
         EEoJmuTUYQguoTF1AkOfPYKKAU39lD5H1k7wXfAnMENjx/Grisq1vT/SrZGNkItDIN
         SlnfqbWBhC6c3TByIYUQnXAdmWwfwhaqTwgYBzH8=
Date:   Fri, 8 Oct 2021 09:09:05 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Peter.Enderborg@sony.com
Cc:     rostedt@goodmis.org, mhiramat@kernel.org,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] user_events: Enable user processes to create and write
 to trace events
Message-ID: <20211008160853.GA31354@kbox>
References: <20211005224428.2551-1-beaub@linux.microsoft.com>
 <2a271ca6-1a01-25f5-1b32-9eb79e2d67ab@sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a271ca6-1a01-25f5-1b32-9eb79e2d67ab@sony.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Oct 08, 2021 at 01:11:59PM +0000, Peter.Enderborg@sony.com wrote:
> On 10/6/21 12:44 AM, Beau Belgrave wrote:
> > User mode processes that wish to use trace events to get data into
> > ftrace, perf, eBPF, etc are limited to uprobes today. The user events
> > features enables an ABI for user mode processes to create and write to
> > trace events that are isolated from kernel level trace events. This
> > enables a faster path for tracing from user mode data as well as opens
> > managed code to participate in trace events, where stub locations are
> > dynamic.
> 
> Is this not very much what the trace_marker do?
> 
At a very high level, yes, both get user data into ftrace.
This question has been brought up a few times, if you watch the LPC2021
Tracing MC session this came up and got answered.

Markers do not get user data into perf and eBPF, nor do they allow user mode
applications to know when to emit the trace_marker (we only want to trace
and incur the syscall cost when something requests that data).

We also want to be able to use all the bells and whistles of
ftrace/perf. This means supporting field labels so things like hist,
filter and triggers work on a per-event basis (IE: Durable identifier
such as the event name).

Thanks,
-Beau
