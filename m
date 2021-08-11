Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D75DDC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9B4460F11
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhHKPXP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 11:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232821AbhHKPXP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 11:23:15 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BF2E6024A;
        Wed, 11 Aug 2021 15:22:51 +0000 (UTC)
Date:   Wed, 11 Aug 2021 11:22:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Subject: Re: [PATCH v4] [RFC] trace: Add kprobe on tracepoint
Message-ID: <20210811112249.555463f2@oasis.local.home>
In-Reply-To: <20210812000343.887f0084ff1c48de8c47ec90@kernel.org>
References: <20210811141433.1976072-1-tz.stoyanov@gmail.com>
        <20210812000343.887f0084ff1c48de8c47ec90@kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Aug 2021 00:03:43 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> On Wed, 11 Aug 2021 17:14:33 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> 
> > From: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > 
> > A new dynamic event is introduced: event probe. The event is attached
> > to an existing tracepoint and uses its fields as arguments. The user
> > can specify custom format string of the new event, select what tracepoint
> > arguments will be printed and how to print them.
> > An event probe is created by writing configuration string in
> > 'dynamic_events' ftrace file:
> >  e:GNAME/ENAME SYSTEM.EVENT [FETCHARGS]	- Set an event probe  
> 
> Hmm, this inconsistency looks not good to me.

Hi Masami,

Thanks for reviewing this.

> 
> "GNAME/ENAME" "SYSTEM.EVENT"
>  - GNAME is "group name" but SYSTEM is "system name" but both must point
>    same idea.
>  - Delimiter character is different.
> 
> Aren't these confusing users?

I agree. It was basically copying code from the histogram logic that
uses '.', and that's how it got mixed up. We should change it to be
more consistent.

> 
> One idea is adding a patch for kprobe and uprobe events to accept new
> delimiter '.'. This will give a consistency with hist triggers too.

I think the above is good. We can make it work with both '/' and '.'.

Would that work for you?


> 
> Also, you can add a note about that the system and group is same
> meaning in events.
> 
> >  -:GNAME/ENAME				- Delete an event probe
> > 
> > Where:
> >  GNAME	- Group name, if omitted 'eprobes' is used.  
> 
> If this is not mandatory, you should write it as 
> 
> e:[GNAME/]ENAME SYSTEM.EVENT [FETCHARGS]

Good point.

> 
> 
> >  ENAME	- Name of the new event in GNAME, mandatory.
> >  SYSTEM	- Name of the system, where the tracepoint is defined, mandatory.
> >  EVENT	- Name of the tracepoint event in SYSTEM, mandatory.
> >  FETCHARGS - Arguments:
> >   <name>=$<field>[:TYPE] - Fetch given filed of the tracepoint and print
> > 			   it as given TYPE with given name. Supported
> > 			   types are:
> > 	                    (u8/u16/u32/u64/s8/s16/s32/s64), basic type
> >         	            (x8/x16/x32/x64), hexadecimal types
> > 			    "string", "ustring" and bitfield.
> > 
> > Example, attach an event probe on openat system call and print name of the
> > file that will be opened:
> >  echo "e:esys/eopen syscalls.sys_enter_openat file=\$filename:string" >> dynamic_events
> > A new dynamic event is created in events/esys/eopen/ directory. It
> > can be deleted with:
> >  echo "-:esys/eopen" >> dynamic_events
> > 
> > Filters, triggers and histograms can be attached to the new event, it can
> > be matched in synthetic events. There is one limitation - no synthetic
> > events can be attached to an event probe.  
> 
> I'm not sure what the "no synthetic events can be attached to an event probe"
> means.
> Can you show an example command what this means?

Basically, we can not do:

  echo 'my_open pid_t pid; unsigned long file' > synthetic_events

  echo 'e:myopen_ret syscalls.sys_exit_open ret=$ret' > dynamic_events

  echo 'hist:keys=common_pid:file=filename' > events/syscalls/sys_enter_open/trigger
  echo 'hist:keys=common_pid:file=$file:onmatch(eprobes.myopen).trace(my_open,common_pid,$file)' > events/eprobes/myopen_ret

The above attaches a trace call to a synthetic event from the
myopen_ret event. The reason we do not allow it, is because we want
eprobes to attach to synthetic events (because they can convert the
types and do more to them), but we do not allow eprobes to attach to
eprobes. But if we allow synthetic events to attach to an eprobe, then
we can have:

 eprobe -> synthetic_event -> eprobe -> synthetic_event -> eprobe ...

Which can be dangerous, and hard to find loops.

Currently, we don't see any real use case to allow synthetic events to
attach to an eprobe, but if there is, we can change the code to allow
it, but we need to keep track of how many are attached, and limit them,
and we need to find a way to check for loops.

> 
> > 
> > Co-developed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> > Subject of the patch is still related to kprobe, though the design
> > no more depends on kprobe. I did not change it for consistency with
> > the first patch version.   
> 
> OK, thanks for moving onto the dynevent. Let me check the code in
> another mail.
> Anyway, I think this is good starting point. 
> 

Thanks for your time at looking at this. We greatly appreciate it!

-- Steve
