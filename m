Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B325C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 22:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D671619A6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 22:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240650AbhKHWdl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 17:33:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239746AbhKHWdk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 17:33:40 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44991604D7;
        Mon,  8 Nov 2021 22:30:55 +0000 (UTC)
Date:   Mon, 8 Nov 2021 17:30:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211108173053.4b37a1b8@gandalf.local.home>
In-Reply-To: <20211108220945.GA2148@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
        <20211104170433.2206-3-beaub@linux.microsoft.com>
        <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
        <20211108171336.GA1690@kbox>
        <20211108131639.33a4f186@gandalf.local.home>
        <20211108202527.GA1862@kbox>
        <20211108160027.3b16c23d@gandalf.local.home>
        <20211108220945.GA2148@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 8 Nov 2021 14:09:45 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> It seems like both histograms and filter both reference field flags to
> determine how to get the data.
> 
> How would you feel about another FILTER_* flag on fields, like:
> FILTER_DYN_STRING_SAFE
> FILTER_PTR_STRING_SAFE

You mean "UNSAFE" ?

> 
> user_events when parsing would instead of leaving FILTER_OTHER for
> __data_loc / __rel_loc switch to the above.
> 
> The predicate filter method would then switch based on those types to
> safer versions.
> 
> That way other parts could take advantage of this if needed beyond
> user_events.
> 
> If this is addressed at the filter/histogram level, would then the write
> callsites still check bounds per-write? Or maybe only care about the
> undersized data cases?

I'd have to look at the implementation of this. There's too many variables
running around in my head right now.

-- Steve
