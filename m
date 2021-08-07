Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2620C4338F
	for <linux-trace-devel@archiver.kernel.org>; Sat,  7 Aug 2021 03:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F10161184
	for <linux-trace-devel@archiver.kernel.org>; Sat,  7 Aug 2021 03:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhHGDyj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Aug 2021 23:54:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230144AbhHGDyj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Aug 2021 23:54:39 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E577E610CB;
        Sat,  7 Aug 2021 03:54:19 +0000 (UTC)
Date:   Fri, 6 Aug 2021 23:54:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [RFC] [RFC] trace: Add kprobe on tracepoint
Message-ID: <20210806235413.61c78c57@oasis.local.home>
In-Reply-To: <20210807102846.4d4f88b157deb26b9345fab5@kernel.org>
References: <20210806174928.847848-1-tz.stoyanov@gmail.com>
        <20210807102846.4d4f88b157deb26b9345fab5@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 7 Aug 2021 10:28:46 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Hmm, sorry, I rather like to use synthetic event with trigger action,
> since this is not a kprobe.

Correct, but I don't think it matches synthetic events either.

> Can you change your idea to use trigger action with synthetic event?
> 
> For example, if we have a "trace" action in the trigger action,
> 
> echo "eopen char filename[]" >> synthetic_events
> echo "trace:eopen,filename.ustring" >> events/syscalls/sys_enter_openat/trigger
> 
> A new action is,
>   trace:SYNTH_EVENT,PARAM(s) [if FILTER]
> and
>   .ustring/.string modifier for the PARAMS.
> 
> I think this matches the current dynamic event model, and can extend
> programmability of the ftrace, and keeps dynamic events simple.

But we want to follow all the features of kprobes. This isn't about
just taking existing fields. In fact, we want fields that are not
available from the event. Here's an idea of what we want to do:

  echo 'e:hr_nr_events timer.hrtimer_expire_entry nr_events=+0x58(+0(+0x30($hrtimer))):u32' > kprobe_events
  echo 1 > events/kprobes/enable
  cat trace
          <idle>-0       [002] d.h2   937.412239: hr_nr_events: (0) nr_events=38380
          <idle>-0       [000] d.h2   937.412239: hr_nr_events: (0) nr_events=930268
            bash-1409    [001] d.h1   937.412239: hr_nr_events: (0) nr_events=33874
          <idle>-0       [000] d.h2   937.413238: hr_nr_events: (0) nr_events=930269
          <idle>-0       [004] d.h2   937.413238: hr_nr_events: (0) nr_events=35263
          <idle>-0       [001] d.h2   937.413238: hr_nr_events: (0) nr_events=33875


Which gives me the nr_events from the hrtimer pointer passed to the
  timer.hrtimer_entry event via hrtimer->base->cpu_base->nr_events

The idea is that we can get trace events into places that the
maintainers have issues with (like the scheduler or vfs), where we may
be allow to add a trace event that only gives us access to a pointer
and nothing else that can become a limiting API.

Then we can attach an eprobe to it that can offset the pointer to a
structure and create dynamically all the fields we need.

Daniel has some work he's doing that will can be improved by this
feature.

Having it as a trigger, will make this rather complex.

Which is why we want this as a probe, and not a trigger. We are only
using the trigger to get the data from the field. What we are also
looking at is a way to create a "trace_probe" that can attach to a
tracepoint (before the event data is added). Which will not be using
the trigger code at all, but will be using the similar offset logic we
want to do here, but on the entry of the tracepoint, not the exit of it.

-- Steve
