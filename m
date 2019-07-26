Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3796DC7618B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 13:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BF3722ADA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 13:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfGZNME (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 09:12:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbfGZNME (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 09:12:04 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F2EE218D4;
        Fri, 26 Jul 2019 13:12:02 +0000 (UTC)
Date:   Fri, 26 Jul 2019 09:12:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andres Freund <andres@anarazel.de>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] tools/lib/traceevent, tools/perf: Move struct
 tep_handler definition in a local header file
Message-ID: <20190726091200.0d1e1f01@gandalf.local.home>
In-Reply-To: <20190726035829.4xcw5k2exx4omlvg@alap3.anarazel.de>
References: <20181005122225.522155df@gandalf.local.home>
        <20190726035829.4xcw5k2exx4omlvg@alap3.anarazel.de>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 25 Jul 2019 20:58:29 -0700
Andres Freund <andres@anarazel.de> wrote:

> Hi,
> 

Hi Andres,

> On 2018-10-05 12:22:25 -0400, Steven Rostedt wrote:
> > From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> >
> > As traceevent is going to be transferred into a proper library,
> > its local data should be protected from the library users.
> > This patch encapsulates struct tep_handler into a local header,
> > not visible outside of the library. It implements also a bunch
> > of new APIs, which library users can use to access tep_handler members.  
> 
> This commit appears to have broken perf script --gen-script /
> trace_find_next_event().  As far as I can tell:
> 
> @ -192,25 +193,29 @@ struct tep_event_format *trace_find_next_event(struct tep_handle *pevent,
> >  					       struct tep_event_format *event)
> >  {
> >  	static int idx;
> > +	int events_count;
> > +	struct tep_event_format *all_events;
> >
> > -	if (!pevent || !pevent->events)
> > +	all_events = tep_get_first_event(pevent);
> > +	events_count = tep_get_events_count(pevent);

> 
> Is just plain wrong, as:
> 
> > -		return pevent->events[idx];
> > +		return (all_events + idx);  
> 
> that's not a valid conversion. ->events isn't an array of tep_handle,
> it's an array of tep_handle* (and even if it were, the previous notation

You're right, it is wrong, but it's not tep_handle* but
tep_event_format*.

The tep_get_first_event() returns a pointer to the first event, but
that's not an array. We can't use that to index to other events.

> would have needed to dereference the value to make it comparable). What
> this does is look idx behind the individually allocated event. Which is
> incorrect.
> 
> 



> 
> The fix (in recent kernel versions) appears to just bee to use
> tep_get_event(), instead of the old pevent->events[...]. But it appears
> to me that
> commit 80c5526c8544ae76cba31fb9702ab8accac1f0f3
> Author: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> Date:   2019-04-01 12:43:12 -0400
> 
>     tools lib traceevent: Implement new traceevent APIs for accessing struct tep_handler fields
> 
> ommitted adding it to event-parse.h. It appears to be intended as public
> API however, given that it got documented in

And it appears that we missed to add it ;-)

> 
> commit 747e942c3925bb85e2865371664499a98fca83b0
> Author: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> Date:   2019-05-10 15:56:23 -0400
> 
>     tools lib traceevent: Man pages for libtraceevent event get APIs
> 
> 
> The following patch fixes this for me. I can polish it up, but I'm
> wondering if I'm missing something here?
> 
> diff --git i/tools/lib/traceevent/event-parse.h w/tools/lib/traceevent/event-parse.h
> index 642f68ab5fb2..7ebc9b5308d4 100644
> --- i/tools/lib/traceevent/event-parse.h
> +++ w/tools/lib/traceevent/event-parse.h
> @@ -517,6 +517,7 @@ int tep_read_number_field(struct tep_format_field *field, const void *data,
>  			  unsigned long long *value);
>  
>  struct tep_event *tep_get_first_event(struct tep_handle *tep);
> +struct tep_event *tep_get_event(struct tep_handle *tep, int index);

I was looking at the tep_get_event() code, and we should switch that to
"unsigned int index" otherwise passing in a negative number will return
an address outside the array.

>  int tep_get_events_count(struct tep_handle *tep);
>  struct tep_event *tep_find_event(struct tep_handle *tep, int id);
>  
> diff --git i/tools/perf/util/trace-event-parse.c w/tools/perf/util/trace-event-parse.c
> index 62bc61155dd1..6a035ffd58ac 100644
> --- i/tools/perf/util/trace-event-parse.c
> +++ w/tools/perf/util/trace-event-parse.c
> @@ -179,28 +179,26 @@ struct tep_event *trace_find_next_event(struct tep_handle *pevent,
>  {
>  	static int idx;
>  	int events_count;
> -	struct tep_event *all_events;
>  
> -	all_events = tep_get_first_event(pevent);
>  	events_count = tep_get_events_count(pevent);

I think we can get rid of the events_count and all its checks, as the
same check is done within tep_get_event().

> -	if (!pevent || !all_events || events_count < 1)
> +	if (!pevent || events_count < 1)

	if (!pevent)

>  		return NULL;
>  
>  	if (!event) {
>  		idx = 0;
> -		return all_events;
> +		return tep_get_event(pevent, 0);
>  	}
>  
> -	if (idx < events_count && event == (all_events + idx)) {
> +	if (idx < events_count && event == tep_get_event(pevent, idx)) {

	if (event == tep_get_event(pevent, idx))
		return tep_get_event(pevent, ++idx);

>  		idx++;
>  		if (idx == events_count)
>  			return NULL;
> -		return (all_events + idx);
> +		return tep_get_event(pevent, idx);
>  	}
>  

	struct tep_event_format *next_event;

	for (idx = 0; next_event = tep_get_event(pevent, idx); idx++)
		if (event == next_event)
			return tep_get_event(pevent, ++idx);

Also, I think setting the idx to 1 in the loop is wrong. Why? think of
this:

	first_event = trace_find_next_event(pevent, NULL);

	next_event = trace_find_next_event(pevent, first_event);
	for (i = 0; i < 5; i++)
		next_event = trace_find_next_event(pevent, next_event);

	second_event = trace_find_next_event(pevent, first_event);

second_event would become NULL.

Care to send a formal patch?

Thanks!

-- Steve


>  	for (idx = 1; idx < events_count; idx++) {
> -		if (event == (all_events + (idx - 1)))
> -			return (all_events + idx);
> +		if (event == tep_get_event(pevent, idx - 1))
> +			return tep_get_event(pevent, idx);
>  	}

>  	return NULL;
>  }
> 
> 
> 
> 
> Not related to this crash, but it also seems that the whole
> trace_find_next_event() API ought to be removed. Back when it was
> 
> -struct event *trace_find_next_event(struct event *event)
> -{
> -       if (!event)
> -               return event_list;
> -
> -       return event->next;
> -}
> 
> it made some sense, but the changes in
> 
> commit aaf045f72335653b24784d6042be8e4aee114403
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   2012-04-06 00:47:56 +0200
> 
>     perf: Have perf use the new libtraceevent.a library
> 
> seem to make the current API somewhat absurd, as evidenced by the
> complexity in trace_find_next_event(). I mean even just removing that
> function and changing the two callsites to simple for loops with
> tep_get_events_count() & tep_get_event() ought to be a lot better.
> 
> Greetings,
> 
> Andres Freund

