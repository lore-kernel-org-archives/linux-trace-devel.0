Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B403C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 03:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ED8B60FC1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 03:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhJ2DMR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 23:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231593AbhJ2DMQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 23:12:16 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D16E761056;
        Fri, 29 Oct 2021 03:09:48 +0000 (UTC)
Date:   Thu, 28 Oct 2021 23:09:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 01/12] libtracefs: Add new internal APIs for dynamic
 events
Message-ID: <20211028230947.38f423c9@rorschach.local.home>
In-Reply-To: <CAPpZLN6NEHLSvu0jZE=3E5mhLZCX=zw7Sg+G-_6CXb=M38p1HQ@mail.gmail.com>
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
        <20211028120907.101847-2-tz.stoyanov@gmail.com>
        <20211028174113.134ae7ce@gandalf.local.home>
        <CAPpZLN6NEHLSvu0jZE=3E5mhLZCX=zw7Sg+G-_6CXb=M38p1HQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 29 Oct 2021 05:46:42 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Fri, Oct 29, 2021 at 12:41 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Thu, 28 Oct 2021 15:08:56 +0300
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> >  
> [...]
> > > +
> > > +struct tracefs_dynevent *
> > > +dynevent_alloc(enum trace_dynevent_type type, const char *system,
> > > +            const char *event, const char *address, const char *format);
> > > +void dynevent_free(struct tracefs_dynevent *devent);
> > > +int dynevent_create(struct tracefs_dynevent *devent);
> > > +int dynevent_destroy(struct tracefs_dynevent *devent);
> > > +int dynevent_get_all(unsigned long type_mask, const char *system,
> > > +                  struct tracefs_dynevent ***ret_events);  
> >
> > I usually prefer to have a list returned, and NULL on error, instead of
> > passing it in by reference. The "***" gets a bit out of hand.
> >  
> 
> The ret_events argument is optional, that's why it is passed as a
> parameter. If ret_events is NULL, the API will return only the count
> of the requested events. No array with events will be allocated in
> that case.
> 

I would make a separate API for just the count, and not have this
function server two functionalities.

> >  
> > > +
> > >  #endif /* _TRACE_FS_LOCAL_H */
> > > diff --git a/include/tracefs.h b/include/tracefs.h
> > > index a2cda30..4020551 100644  
> [ ... ]
> > > +
> > > +static int dyn_generic_parse(struct dyn_events_desc *desc, const char *group,
> > > +                          char *line, struct tracefs_dynevent **ret_dyn)  
> >
> > Again, I prefer to have the pointer returned, and not assigned as a
> > parameter. All this returns is 0 on success or -1 on failure. That doesn't
> > give us anything more than having ret_dyn allocated or not. (return NULL or
> > non-NULL).
> >  
> 
> The ret_dyn is optional. If it is NULL, the function only checks if
> the line contains an event of the requested type, without allocating
> any memory.

I think we should make a separate API for that as well.

  dyn_generic_parse_check()?

> 
> > > +{
> > > +     struct tracefs_dynevent *dyn;
> > > +     char *address;
> > > +     char *system;
> > > +     char *format;
> > > +     char *event;
> > > +
> > > +     if (strncmp(line, desc->prefix, strlen(desc->prefix)))
> > > +             return -1;
> > > +
> > > +     system = strchr(line, ':');
> > > +     if (!system)
> > > +             return -1;
> > > +     event = strchr(line, '/');
> > > +     if (!event)
> > > +             return -1;
> > > +     address = strchr(line, ' ');
> > > +     if (!address)
> > > +             return -1;
> > > +     format = strchr(address+1, ' ');
> > > +
> > > +     *address = '\0';
> > > +     *event = '\0';  
> >
> >
> > The above should use strtok_r.
> >
> >         char *probe;
> >         char *sav;
> >
> >         probe = strtok_r(line, ":", &sav);
> >         system = strtok_r(NULL, "/", &sav);
> >         event = strtok_r(NULL, " ", &sav);
> >         address = strtok_r(NULL, " ", &sav);
> >         format = strtok_r(NULL, "\n", &sav);
> >  
> 
> I used strchr() instead of strtok_r() here, because my original idea
> was that this function should not modify the original line string, if
> the event is not of the requested type. When parsing the
> "dynamic_events" file, it contains events from any types. My initial
> design was to pass the same line string to all parse functions, until
> there is a match. But the design was changed, now a new copy of the
> file is used for each event type. I'll change that code to use
> strtok_r().
> 
> >
> >
> >  
> > > +
> > > +     /* KPROBEs and UPROBEs share the same prefix, check the format */
> > > +     if (desc->type == TRACE_DYNEVENT_UPROBE || desc->type == TRACE_DYNEVENT_URETPROBE) {
> > > +             if (!strchr(format, '/'))
> > > +                     return -1;
> > > +     }  
> [ ... ]
> > > +
> > > +static int get_all_type(enum trace_dynevent_type type, const char *system,
> > > +                     struct tracefs_dynevent ***ret_all)
> > > +{
> > > +     struct dyn_events_desc *desc;
> > > +     struct tracefs_dynevent *devent, **tmp, **all = NULL;
> > > +     char *content;
> > > +     int count = 0;
> > > +     char *line;
> > > +     char *next;
> > > +     int ret;
> > > +
> > > +     desc = get_devent_desc(type);
> > > +     if (!desc)
> > > +             return -1;
> > > +
> > > +     content = tracefs_instance_file_read(NULL, desc->file, NULL);
> > > +     if (!content)
> > > +             return -1;  
> >
> > space.
> >  
> > > +     line = content;
> > > +     do {
> > > +             next = strchr(line, '\n');
> > > +             if (next)
> > > +                     *next = '\0';
> > > +             ret = desc->dyn_events_parse(desc, system, line, ret_all ? &devent : NULL);  
> >
> > So if ret_all is NULL, then we allocate a bunch of devent and lose them?
> >  
> 
> Hm, no devents are allocated if ret_all is NULL. That's the idea of
> that API design - ret_all is an optional input parameter. Without it,
> the functions can be used only to get the count of the requested
> events, without any memory allocation. I would like to keep that
> functionality, even though it is not used at the moment.

Ah. But still, this is overly complex to try to have this server two
functionalities. It becomes confusing.


> 
> Thanks Steven! I'll address these comments in the next version, but I
> really want to keep the  dynevent_get_all() API more flexible - to
> have a way to get only the count, without allocating an array with the
> events.

I really think you should have that as two separate functions,
otherwise it becomes overly complex.

-- Steve

