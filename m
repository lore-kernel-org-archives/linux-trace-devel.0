Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516BBC3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 14:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F9FF22CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 14:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfH1O42 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 10:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726432AbfH1O41 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 10:56:27 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41DBC2189D;
        Wed, 28 Aug 2019 14:56:27 +0000 (UTC)
Date:   Wed, 28 Aug 2019 10:56:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     stephen@brennan.io, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] kernel-shark: Provide parsing for quotation marks in
 Record command line
Message-ID: <20190828105625.5910856c@gandalf.local.home>
In-Reply-To: <d86d746e-fe00-2d0c-5fef-4a7d1c09c245@gmail.com>
References: <20190827131418.18713-1-y.karadz@gmail.com>
        <20190828051018.GA5316@greed>
        <20190828090614.1372a9a8@gandalf.local.home>
        <d86d746e-fe00-2d0c-5fef-4a7d1c09c245@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Aug 2019 17:10:48 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> On 28.08.19 г. 16:06 ч., Steven Rostedt wrote:
> > On Tue, 27 Aug 2019 22:10:18 -0700
> > stephen@brennan.io wrote:
> >   
> >> It strikes me that this explicitly supports only a single set of quotes.
> >> This sort of behavior would be pretty surprising for people expecting shell
> >> quote support, and for people expecting just splitting on spaces.
> >>
> >> I looked and couldn't really find any Qt utility for properly parsing shell
> >> quoting (similar to python's shlex module). I totally get that it's a lot
> >> of work to implement a correct shell quoting parser.
> >>
> >> Maybe a compromise would be to add a checkbox to the capture dialog, which
> >> tells kernel-shark to pass the entire textbox contents, unmodified, to the
> >> shell implementation on the system. So, my example of:
> >>
> >>      python -c 'print("hello world")'
> >>
> >> Would get put into the third argument of the command:
> >>
> >>      /bin/sh -c INSERT_TEXTBOX_CONTENTS_HERE
> >>
> >> Then you could rely on /bin/sh doing the parsing for you. The downside is
> >> that it adds a whole new process. But you can't always get everything in
> >> life, right?
> >>  
> > 
> > I need to look at this a bit deeper. I've written lots of cases where I
> > had to capture single and double quotes and turn them into a single
> > command. This is definitely needed here.
> >   
> 
> Can you send me few of the of most trickier examples that comes to your 
> mind, so that I can use them to test the parsing?
> 

I was thinking of when we start adding synthetic event code, we will
definitely need to handle some of this. Like:

 --select 'irq_lat: lat=sched_waking.common_timestamp.usecs - hrtimer_start.common_timestamp.usecs, pid=sched_waking.pid
                    from timer.hrtimer_start join sched.sched_waking
                      on hrtimer_start.common_pid == sched_waking.common_pid
		    where hrtimer_start.function == 0xffffffff81200580 and
                          sched_waking.common_flags & 1'

 --select "wake_lat: lat=sched_switch.common_timestamp.usecs - irq_lat.common_timestamp.usecs, irqlat=irq_lat.lat, pid=sched_switch.next_pid
             from sched.sched_switch join irq_lat on sched_switch.next_pid == irq_lat.pip where next_comm == \"my-rt-code\""


Note, the above will be all on one single line!

-- Steve
