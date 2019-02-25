Return-Path: <SRS0=3M/k=RA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991C9C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Feb 2019 17:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D68D213A2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Feb 2019 17:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbfBYRMA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 12:12:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:34470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbfBYRMA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 12:12:00 -0500
Received: from vmware.local.home (unknown [208.91.3.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61AA720643;
        Mon, 25 Feb 2019 17:11:59 +0000 (UTC)
Date:   Mon, 25 Feb 2019 12:11:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: Multiple time offsets in trace.dat file
Message-ID: <20190225121157.1916067f@vmware.local.home>
In-Reply-To: <CACqStoeckAbvXp9ZzVBro1zzzQzi6C9ub9Hv_GtCZNmZ3skxTw@mail.gmail.com>
References: <CACqStoeckAbvXp9ZzVBro1zzzQzi6C9ub9Hv_GtCZNmZ3skxTw@mail.gmail.com>
X-Mailer: Claws Mail 3.15.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 25 Feb 2019 15:37:57 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Hi Steven,
> When tracing host and guest machines, in order to overcome the drift
> between the times in both contexts, we need to use multiple (at least
> 2) time offsets. In addition, we need the local time stamp, related to
> each offset:
>   (ts_offset1, ts_local1), (ts_offset2, ts_local2), ....
>  where ts_local1 is the time when the offset ts_offset1 was measured.
> This information should be stored somehow in trace.dat file, which
> currently supports only one TRACECMD_OPTION_OFFSET option.
> There are two possible approaches to do it, please suggest which one to choose:
> 
>  1. Use the existing TRACECMD_OPTION_OFFSET, written 2 times in the
> trace.dat file. Extract the ts_local1 and ts_local2 times from the
> file, as ts_local1 is the time of the first event and ts_local2 is the
> time of the last event. There are few  cons of this approach:
>         - we can use only 2 offsets, before and after the trace.
>         - mapping ts_local1 and ts_local2 to the times of the first
> and last event is not accurate, as these are not the actual times when
> the time stamps were calculated.
>          - Finding first and last event from the trace.dat file will
> require one extra parsing of the whole file, as the events there are
> not sorted.
> 
>  2. Introduce a new TRACECMD_OPTION_ option, which will hold all
> ts_offsets together with ts_local times.
> 

Option 2 is the right approach. The offset is just for the --date
operation by itself. This should be something new, and for older
trace-cmd reading this file, it can simply ignore it.

What about: TRACECMD_OPTION_TIME_SHIFT

does that sound good? I'm open for other suggestions.

-- Steve
