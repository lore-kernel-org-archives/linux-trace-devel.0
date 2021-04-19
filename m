Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F54C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C2966101E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240366AbhDSNqQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 09:46:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240184AbhDSNqP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 09:46:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 210756101E;
        Mon, 19 Apr 2021 13:45:45 +0000 (UTC)
Date:   Mon, 19 Apr 2021 09:45:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] trace-cmd library: Add check before applying
 tsc2nsec offset
Message-ID: <20210419094543.15c131c2@gandalf.local.home>
In-Reply-To: <CAPpZLN4K6H8p1zNuqHQd0LGDHatAgR+8SHRH1jTP8=Jb_bMZUw@mail.gmail.com>
References: <20210416103409.24597-1-tz.stoyanov@gmail.com>
        <20210416103409.24597-3-tz.stoyanov@gmail.com>
        <20210416161221.031d1f5d@gandalf.local.home>
        <CAPpZLN4K6H8p1zNuqHQd0LGDHatAgR+8SHRH1jTP8=Jb_bMZUw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 19 Apr 2021 11:08:04 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > We don't want all timestamps zero. We want to disable the starting event.
> >
> > By having this instead:
> >
> >                 } else {
> >                         tracecmd_warning("Timestamp %llu is before the initial offset %llu\n"
> >                                          "\tSetting offset to 0",
> >                                          ts, handle->tsc_calc.offset);
> >                         handle->tsc_calc.offset = 0;
> >                         ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
> >                 }
> >  
> 
> This will set the guest offset to 0, will not change the offsets of
> the other files. The result is that the files will not be displayed in
> sync, because of these few broken events. As this is only a sanity
> check, and should not happen if the patch "trace-cmd: Get the
> timestamp of the first recorded event as TSC offset" is applied, I
> would suggest to zero the broken timestamps and to advise the user to
> use "--raw-ts" option instead:
>  "Timestamp %llu is before the initial offset %llu, set it to 0.
> Display the files with --raw-ts option to see the original
> timestamps.\n"

I still don't like it, because a thousand events all with the same
timestamp will still screw up everything (including the output of
kernelshark, as you'll see a thousand events at time zero, and then the
rest of the events at some way off in the future time).

And as this is in the library, having a warning is only applicable to
trace-cmd, and not any other user case.

Actually, I think we are looking at the wrong place to do the check. All
event streams (CPUs) need to be in monotonic order, or it's just corrupted
to begin with.

The library should supply a check to see if each stream starts after the
offset, and if not, give a report back to the user (trace-cmd in this case,
or kernelsharks ftrace plugin). Then give the user a way to give another
offset to tell all the other streams to convert to.

That is:

	max = 0;
	for each stream:
		ret = read first event, compared to offset
		if (!ret) {
			/* ret will be how much off by offset */
			if (ret > max)
				max = ret;
		}
	if (max) {
		for each stream:
			Update offset by subtracting max
	}

Look at each stream, and have some callback give you how much ahead the
first event is from its given offset. Take the biggest value from reading
all the streams, then tell all the streams to subtract its offset by that
max value. The end result is that all streams now start at a positive value.

-- Steve


