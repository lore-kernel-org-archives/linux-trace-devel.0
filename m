Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76324C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 21:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E8C3613E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 21:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236915AbhDVVPU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 17:15:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236851AbhDVVPU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 17:15:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F69F61264;
        Thu, 22 Apr 2021 21:14:45 +0000 (UTC)
Date:   Thu, 22 Apr 2021 17:14:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/2] trace-cmd list: Use tracefs to help find events for
 -e
Message-ID: <20210422171443.2d9521b2@gandalf.local.home>
In-Reply-To: <CAPpZLN6_NjZYmhDMfskxtKOaVrVm+6pa2ic-LrvoKGBN+h=QhQ@mail.gmail.com>
References: <20210416213018.3890036-1-rostedt@goodmis.org>
        <20210416213018.3890036-2-rostedt@goodmis.org>
        <CAPpZLN6_NjZYmhDMfskxtKOaVrVm+6pa2ic-LrvoKGBN+h=QhQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 19 Apr 2021 08:10:57 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > --- a/lib/trace-cmd/trace-input.c
> > +++ b/lib/trace-cmd/trace-input.c
> > @@ -1234,9 +1234,11 @@ static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
> >                         ts -= handle->tsc_calc.offset;
> >                         ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
> >                 } else {
> > -                       tracecmd_warning("Timestamp $llu is before the initial offset %llu, set it to 0",
> > +                       tracecmd_warning("Timestamp %llu is before the initial offset %llu\n"
> > +                                        "\tSetting offset to 0",
> >                                          ts, handle->tsc_calc.offset);
> > -                       ts = 0;
> > +                       handle->tsc_calc.offset = 0;
> > +                       ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);  
> 
> That looks like from a different patch? I'll send v3 from my patch set
> with these fixes.
> 
> >                 }
> >         }

Yes, that was leftover from another change that accidentally got committed
into this one. Thanks for noticing. I'll be sending out a v2.

-- Steve
