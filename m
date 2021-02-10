Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5641DC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 22:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F9EE64E66
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 22:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbhBJV77 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Feb 2021 16:59:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231642AbhBJV7v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Feb 2021 16:59:51 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CABC764E26;
        Wed, 10 Feb 2021 21:59:10 +0000 (UTC)
Date:   Wed, 10 Feb 2021 16:59:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v28 0/8] Timestamp synchronization of host - guest
 tracing session
Message-ID: <20210210165909.692edea3@gandalf.local.home>
In-Reply-To: <acf6979c262a741b7ecb330bb3a1f2e1546385ef.camel@suse.com>
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
        <bb09f02e5d1e14cf835c85c97ae7902976bdb408.camel@suse.com>
        <CAPpZLN5SQu=XwQ+XodbVWrXUb-qtcLjH-U79R6NBDJ4jwQSvsw@mail.gmail.com>
        <CAPpZLN7boZK+9921zJ+OvZ-yhT6DdAkWkj9+fgswV_g4PxsROg@mail.gmail.com>
        <f6a169322dde8038832371fa1d5856f74e2ab308.camel@suse.com>
        <CAPpZLN6wUD4wFLLODFL3529vz_khKgvK-PkHspOzA5zEwPeHjQ@mail.gmail.com>
        <acf6979c262a741b7ecb330bb3a1f2e1546385ef.camel@suse.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 09 Feb 2021 13:24:23 +0100
Dario Faggioli <dfaggioli@suse.com> wrote:
> 
> BTW, if I can pester you a little bit more, now that it works I'm
> trying to use this, and here's what I'm doing.
> 
> == VM:
> # echo tsc > /sys/devices/system/clocksource/clocksource0/current_clocksource
> # echo x86-tsc > /sys/kernel/tracing/trace_clock
> # trace-cmd agent
> 
> == Host:
> # echo x86-tsc > /sys/kernel/tracing/trace_clock
> # trace-cmd record -p nop -e sched:* -e kvm:* -e timer:hrtimer* -A tumbleweed-jeos:823 -e sched:* -e syscalls:*_clock_nanosleep -e timer:hrtimer* sleep 1
>

Note you can use -C x86-tsc on the command line which would handle the
clocks for you. I believe it may update the agent as well, but if not, you
can add it to the agent as well. Also "-p nop" shouldn't be needed, as that
would happen automatically if "-p" is left off.

 trace-cmd record -e sched -e kvm -e 'hrtimer*' -C x86-tsc \
   -A tumbleweed-jeos:823 -e sched -e '*_clock_nanosleep' -e 'hrtimer*' \
   sleep 1

should be equivalent. You may need to add '-C x86-tsc' after the -A, but I
think we made it match the host if a clock was supplied.
 
> And I do end up with the two files: trace.dat for the host and trace-
> (null).dat (oh, well :-D) for the guest.

I believe my latest push should fix that ;-)

-- Steve
