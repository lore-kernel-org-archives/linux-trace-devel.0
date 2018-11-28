Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:41656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbeK2BX2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 20:23:28 -0500
Date: Wed, 28 Nov 2018 09:21:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2] tools/lib/traceevent: make libtraceevent thread safe
Message-ID: <20181128092137.58a8b028@gandalf.local.home>
In-Reply-To: <CACqStodWHb=aeSAp1Fu0LeZkA6WAPKxQjBUGVtJ-M6Vz+QiUhw@mail.gmail.com>
References: <20181126132245.19576-1-tstoyanov@vmware.com>
        <20181126120328.509a3151@gandalf.local.home>
        <CACqStodWHb=aeSAp1Fu0LeZkA6WAPKxQjBUGVtJ-M6Vz+QiUhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 28 Nov 2018 10:59:18 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Hi Steven

Hi Tzvetomir,

Can you make sure that your replies have HTML turned off. As it doesn't
seem to do inlined replies well (my responses don't have a ">" in front
of them thus it's hard to know which is your reply or my old one).



> > diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> > index a5048c1b9bec..25f4ceab9a58 100644
> > --- a/tools/lib/traceevent/event-parse.c
> > +++ b/tools/lib/traceevent/event-parse.c
> > @@ -3485,10 +3485,11 @@ struct tep_event *tep_find_event(struct tep_handle *pevent, int id)
> >       struct tep_event **eventptr;
> >       struct tep_event key;
> >       struct tep_event *pkey = &key;
> > -
> > +     struct tep_thread_data *local = tep_get_thread_local(pevent);  
> 
> Let's make this:
> 
>         local = tep_get_thread_local(pevent, id);
> 
>         if (local)
>                 return local->last_event;
> 
> 

> I got the idea, but have one comment about naming of the new functions.
> My initial idea was tep_get_thread_local() to access all tread specific data, not only
> last_event cache. That's why I named it this way, and make it to not depend on an event.
> As these are internal APIs, we are not going to expose them to the users, we can assume
> that the callers are aware of  "struct tep_thread_data" and can access it directly.
> As I understand,  your idea is to hide "struct tep_thread_data", and to implement APIs to
> access only specific tread local data, as "last_event cache" at the first stage. When we add
> more into "struct tep_thread_data", new APIs will be implemented. I'm ok with this
> approach, but in this case we should name the new APIs to follow the name of thread local item,
> something like this:

>     tep_find_event_by_id_cache(struct tep_handle *, int);
>     tep_find_event_by_name_cache(struct tep_handle *, const char *);
>     tep_set_serach_event_cache(struct tep_handle *, struct tep_event *);
> 

No, I don't think the cached should be visible to the user. That's too
much implementation details. But we can have several thread caches. We
probably want to drop the "tep_" prefix too, as these functions
shouldn't be exposed.

We could have:

  get_thread_local_event_by_id(tep, id);
  get_thread_local_event_by_name(tep, name);

and such.

The point is, the cache is suppose to be a fast access where code might
be accessing the same event over and over. A loop searching for a cache
item defeats that purpose. The last access either matches or it
doesn't. If it is bouncing between multiple tep handlers, then it will
flush the cache of the previous one.

-- Steve
