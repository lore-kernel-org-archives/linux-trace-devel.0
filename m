Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C99C433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Mar 2021 14:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0321364E64
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Mar 2021 14:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhCROAP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Mar 2021 10:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229960AbhCRN7p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 09:59:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6C0464F6C;
        Thu, 18 Mar 2021 13:59:44 +0000 (UTC)
Date:   Thu, 18 Mar 2021 09:59:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 02/12] trace-cmd: Add logic for TSC to nanosecond
 conversion
Message-ID: <20210318095943.459bb16d@gandalf.local.home>
In-Reply-To: <CAPpZLN5aKmS8Jss=UzgwtcWHNTpw30hP1Bg75U1VMUfGYjwiEA@mail.gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
        <20210315061832.168495-3-tz.stoyanov@gmail.com>
        <20210316171749.105af2e7@gandalf.local.home>
        <CAPpZLN7cx_RswVorUCt+9xOG2C2JbS=SDrrgwMbuZBkrdK+ACQ@mail.gmail.com>
        <20210317174948.42d1ae3f@gandalf.local.home>
        <CAPpZLN5aKmS8Jss=UzgwtcWHNTpw30hP1Bg75U1VMUfGYjwiEA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 18 Mar 2021 05:42:47 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
> >
> > Your right. And I just tried this:
> >
> >  # trace-cmd record -C x86-tsc -e sched -B foo -C local -e sched sleep 1
> >
> > And it appears to ignore the -C local. Which I think is the right thing to
> > do ;-)  
> 
> According to the code, trace-cmd supports clock per instance. And it
> works, I tried this:
> 
> #trace-cmd record -C x86-tsc -e irq -B foo -C local -e sched sleep 1
> 
> and got different clocks:
>              <...>-290676 [006]1956659520918: softirq_exit:        ....
> foo:       zoom-10894 [004]112198623756671: sched_switch:  ....

Strange, I'll look at that again. It the report looked intermixed on my end
and seemed like it ignored the local clock.

> 
> although I cannot imagine a use case for this. It will be weird to
> visualise this by KerneShark.

Something I don't think we need to worry about now.

> 
> I think that we should introduce options per instance now,  as "-C
> tsc2nsec" cannot be implemented without it.
> I see two possible ways to implement it:
>  1. Break the current trace.dat file format by adding metadata for
> each instance.
>  2. Keep the current format and use nested options -  that's it, just
> another option "OPTION_INSTANCE". It will hold instance name and all
> options, specific for that instance, using the current options format.

Actually, we could simply extend the TRACECMD_OPTION_BUFFER. The way
options were designed was to be able to extend them. When an option is
read, it reads both the type and the size, and will skip over the size to
find the next option. If we extend the buffer option to include instance
options, all we need to do is check the size of the buffer option if it has
another item in it after the location of the buffer.

I'll look more into the code on this.

> 
> But there is one question, valid for both ways: What should be the
> scope for the global options ? Apply them only on the top instance, or
> they should be common for all instances ?

The way I usually handle this is, options are by default set for all
instances, and then the buffer instance can just override the defaults.

-- Steve
