Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BABE0C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 20:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84F4F619E2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 20:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbhKHU2R (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 15:28:17 -0500
Received: from linux.microsoft.com ([13.77.154.182]:56542 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbhKHU2Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 15:28:16 -0500
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id CF63C20B416B;
        Mon,  8 Nov 2021 12:25:31 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CF63C20B416B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636403131;
        bh=YH2VeHXU1UeUcY3R8CfekvT7nVw4MlF6RZFh6JZYAQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fhkLW0PlWcmizwhZCnFNDxRe0q3WGRSmPGOxKzkjEl027fRwNuA5Da1Z71aJnzXNV
         p93Hp5NR98j8tayO2WZeP8KLAWXuHpjvAop3WvoUDLkRynAvVL6a8sv8eC8dB/WZxP
         G7IqGr2KTM5nTbzsuMjNhas+vAiGVk3ooAzUCCLU=
Date:   Mon, 8 Nov 2021 12:25:27 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211108202527.GA1862@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
 <20211104170433.2206-3-beaub@linux.microsoft.com>
 <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
 <20211108171336.GA1690@kbox>
 <20211108131639.33a4f186@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108131639.33a4f186@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Nov 08, 2021 at 01:16:39PM -0500, Steven Rostedt wrote:
> On Mon, 8 Nov 2021 09:13:36 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> 
> > Does that mean the decoders in eprobes/histogram don't check event
> > record sizes before accessing the data? Shouldn't that get fix
> > centrally? That would mean a loaded module could do the same thing
> > (user_events only works if the user has access to tracefs, so it's not
> > like it's open to all users).
> 
> There's checks to make sure everything fits in eprobes and kprobes. If it
> doesn't then the event is simply dropped.
> 
> For example, if you look at __eprobe_trace_func() in trace_eprobe.c, you'll
> see that it calls get_eprobe_size(), which goes through and just reads what
> it is about to accept. Then it reserves the amount of data on the ring
> buffer, and then calls store_trace_args() which also passes in the size
> that it found, in case things change. If it's too big, it only records what
> it originally intended.
> 
> -- Steve

It seems there are 2 concerns:
1. If data comes in and it's not in the size that is specified, it's
suspicious and should either be truncated or ignored. Maybe under
ignore, over truncate.

2. If the data is more than specified, it must be checked to see if
there are __data_loc / __rel_loc entries and they must be validated as
within range of accepted limits. If there are no __data_loc / __rel_loc
it should either be truncated or ignored.

Is there more that I may have missed?

I'd like to know if I do fix them that the features like filtering will still
be available to user_events or if it's better to just add flags to disable
kernel filtering?

I'm still unsure this is limited to just user_events.

For example, why doesn't filter_pred_strloc and filter_pred_pchar in
trace_events_filter.c check the boundary it will be accessing?

It seems like tracepoints from kernel modules, while more trusted, can also
cause this kind of thing due to bugs, etc.

Thanks,
-Beau
