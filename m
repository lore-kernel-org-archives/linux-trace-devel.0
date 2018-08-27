Return-Path: <SRS0=/uS6=LK=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:45274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbeH0RXF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Aug 2018 13:23:05 -0400
Date: Mon, 27 Aug 2018 09:36:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ceco <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 21/24] tools lib traceevent: Rename various pevent
 get/set/is APIs
Message-ID: <20180827093622.6763c6af@gandalf.local.home>
In-Reply-To: <CAPpZLN5KUoie1te+0NScA-6gGC9hh_oRozSxA07UP3mBu6=E+g@mail.gmail.com>
References: <20180827081759.17297-1-tz.stoyanov@gmail.com>
        <20180827081759.17297-22-tz.stoyanov@gmail.com>
        <20180827091754.3f832e87@gandalf.local.home>
        <CAPpZLN5KUoie1te+0NScA-6gGC9hh_oRozSxA07UP3mBu6=E+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 27 Aug 2018 16:31:06 +0300
Ceco <tz.stoyanov@gmail.com> wrote:

> На пн, 27.08.2018 г. в 16:17 ч. Steven Rostedt <rostedt@goodmis.org> написа:
> >
> > On Mon, 27 Aug 2018 11:17:56 +0300
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> >
> >  
> > > diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
> > > index 808b2f3..88870c1 100644
> > > --- a/kernel-shark/trace-graph.c
> > > +++ b/kernel-shark/trace-graph.c
> > > @@ -1133,7 +1133,7 @@ int trace_graph_check_sched_switch(struct graph_info *ginfo,
> > >                * First time through, register any missing
> > >                *  comm / pid mappings.
> > >                */
> > > -             if (!pevent_pid_is_registered(ginfo->pevent, *pid))
> > > +             if (!tep_find_event_by_record(ginfo->pevent, *pid))  
> >
> > Hmm, this isn't just a name change, but a change in function. Did you
> > mean this?  
> 
> This is very strange, I'm going to check all patches from the series again.
> 

Thanks. One thing you can do (and I'm doing this too), is after
applying all the patches, do a "git diff" against a branch with all the
patches applied and the root branch without the patches. This makes it
quicker than having to check each individual patch.

If this is the only patch affected, just reply back to this patch with
an updated patch with a "v3.5" version.


-- Steve
