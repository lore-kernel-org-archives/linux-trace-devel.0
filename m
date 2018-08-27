Return-Path: <SRS0=/uS6=LK=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:39430 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbeH0RR6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Aug 2018 13:17:58 -0400
Received: by mail-oi0-f67.google.com with SMTP id c190-v6so27228325oig.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Aug 2018 06:31:18 -0700 (PDT)
MIME-Version: 1.0
References: <20180827081759.17297-1-tz.stoyanov@gmail.com> <20180827081759.17297-22-tz.stoyanov@gmail.com>
 <20180827091754.3f832e87@gandalf.local.home>
In-Reply-To: <20180827091754.3f832e87@gandalf.local.home>
From: Ceco <tz.stoyanov@gmail.com>
Date: Mon, 27 Aug 2018 16:31:06 +0300
Message-ID: <CAPpZLN5KUoie1te+0NScA-6gGC9hh_oRozSxA07UP3mBu6=E+g@mail.gmail.com>
Subject: Re: [PATCH v3 21/24] tools lib traceevent: Rename various pevent
 get/set/is APIs
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

=D0=9D=D0=B0 =D0=BF=D0=BD, 27.08.2018 =D0=B3. =D0=B2 16:17 =D1=87. Steven R=
ostedt <rostedt@goodmis.org> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0:
>
> On Mon, 27 Aug 2018 11:17:56 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
>
> > diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
> > index 808b2f3..88870c1 100644
> > --- a/kernel-shark/trace-graph.c
> > +++ b/kernel-shark/trace-graph.c
> > @@ -1133,7 +1133,7 @@ int trace_graph_check_sched_switch(struct graph_i=
nfo *ginfo,
> >                * First time through, register any missing
> >                *  comm / pid mappings.
> >                */
> > -             if (!pevent_pid_is_registered(ginfo->pevent, *pid))
> > +             if (!tep_find_event_by_record(ginfo->pevent, *pid))
>
> Hmm, this isn't just a name change, but a change in function. Did you
> mean this?

This is very strange, I'm going to check all patches from the series again.

> -- Steve
>
> >                       tep_register_comm(ginfo->pevent,
> >                                         *comm, *pid);
> >       }
