Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29672C4338F
	for <linux-trace-devel@archiver.kernel.org>; Sun,  8 Aug 2021 03:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DED9860FF2
	for <linux-trace-devel@archiver.kernel.org>; Sun,  8 Aug 2021 03:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhHHDPl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 7 Aug 2021 23:15:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229977AbhHHDPj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 7 Aug 2021 23:15:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 167CF60EE0;
        Sun,  8 Aug 2021 03:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628392521;
        bh=w19enKfB9dnwyuqBuCZMGpHad+uHzbJFcbY+Xnrm2OU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MiGnUdLIBOGID09yuhD9S8gH517kZVGcAAUCxqed6PSnmOQG2BJbY+FT6I7S+M5N1
         vihXYzRAu5Pdt+eWvQ/xP+EYU7bI0TymTrM9aOYyxk04h+nZgAJNa0IUh2LvzoDan5
         LFF4IkoV5Cr872QO/8qwMfpG/Pm6MEzES3zwiso6UBOZx96I83PaP1GKlyHbo3p370
         OXzoc5ObJSoEf2Rcg3kPF2z4HEw2KgoC282sEa9Mc99REB/WBoXcl5s4rqPTYJNPY8
         IU9huxHqnfJrIZA3Xh6QR5xTRORzCGQEzO6HxP8qqkVp8TWQCxhmk14FM0t3YofMOT
         cqM4a5I3bQ23g==
Date:   Sun, 8 Aug 2021 12:15:18 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [RFC] [RFC] trace: Add kprobe on tracepoint
Message-Id: <20210808121518.69ccc87ad9f76cabb80c5267@kernel.org>
In-Reply-To: <20210806235413.61c78c57@oasis.local.home>
References: <20210806174928.847848-1-tz.stoyanov@gmail.com>
        <20210807102846.4d4f88b157deb26b9345fab5@kernel.org>
        <20210806235413.61c78c57@oasis.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 6 Aug 2021 23:54:13 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 7 Aug 2021 10:28:46 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > Hmm, sorry, I rather like to use synthetic event with trigger action,
> > since this is not a kprobe.
> 
> Correct, but I don't think it matches synthetic events either.
> 
> > Can you change your idea to use trigger action with synthetic event?
> > 
> > For example, if we have a "trace" action in the trigger action,
> > 
> > echo "eopen char filename[]" >> synthetic_events
> > echo "trace:eopen,filename.ustring" >> events/syscalls/sys_enter_openat/trigger
> > 
> > A new action is,
> >   trace:SYNTH_EVENT,PARAM(s) [if FILTER]
> > and
> >   .ustring/.string modifier for the PARAMS.
> > 
> > I think this matches the current dynamic event model, and can extend
> > programmability of the ftrace, and keeps dynamic events simple.
> 
> But we want to follow all the features of kprobes. This isn't about
> just taking existing fields. In fact, we want fields that are not
> available from the event. Here's an idea of what we want to do:
> 
>   echo 'e:hr_nr_events timer.hrtimer_expire_entry nr_events=+0x58(+0(+0x30($hrtimer))):u32' > kprobe_events
>   echo 1 > events/kprobes/enable
>   cat trace
>           <idle>-0       [002] d.h2   937.412239: hr_nr_events: (0) nr_events=38380
>           <idle>-0       [000] d.h2   937.412239: hr_nr_events: (0) nr_events=930268
>             bash-1409    [001] d.h1   937.412239: hr_nr_events: (0) nr_events=33874
>           <idle>-0       [000] d.h2   937.413238: hr_nr_events: (0) nr_events=930269
>           <idle>-0       [004] d.h2   937.413238: hr_nr_events: (0) nr_events=35263
>           <idle>-0       [001] d.h2   937.413238: hr_nr_events: (0) nr_events=33875
> 
> 
> Which gives me the nr_events from the hrtimer pointer passed to the
>   timer.hrtimer_entry event via hrtimer->base->cpu_base->nr_events
> 
> The idea is that we can get trace events into places that the
> maintainers have issues with (like the scheduler or vfs), where we may
> be allow to add a trace event that only gives us access to a pointer
> and nothing else that can become a limiting API.
> 
> Then we can attach an eprobe to it that can offset the pointer to a
> structure and create dynamically all the fields we need.
> 
> Daniel has some work he's doing that will can be improved by this
> feature.

OK, that's a good reason why you need it. However, the desgin is still
be a bit wrong. You should make it as another probe event, because

1. eprobe is not a kprobe but an event converter (reusing fetchargs)
2. we already have dynevent framework for expanding new dynamic events.
3. what you need is the "fetch args", that is shared with uprobe-event
   there is no reason we can't share it with one more probe-event. :)

Thus, I recommend you to introduce a new dynevent, you don't need
to add "eprobe_events" file but you can use "dynamic_events" interface.

> 
> Having it as a trigger, will make this rather complex.

OK, for the dereference feature, it may need more careful
implementation. (and maybe need a different parser)

> 
> Which is why we want this as a probe, and not a trigger. We are only
> using the trigger to get the data from the field. What we are also
> looking at is a way to create a "trace_probe" that can attach to a
> tracepoint (before the event data is added). Which will not be using
> the trigger code at all, but will be using the similar offset logic we
> want to do here, but on the entry of the tracepoint, not the exit of it.

OK, but I want you to create another dynevent, not extending kprobe_events
for non-kprobe things. That will make things much harder to be maintained.

So maybe what you need is trace_eprobe.c, instead of modifying trace_kprobe.c.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
