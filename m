Return-Path: <SRS0=W4op=VX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271EEC7618F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 20:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1EB322BE8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Jul 2019 20:55:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=anarazel.de header.i=@anarazel.de header.b="QdiPjmxs";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DlWhKFAr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfGZUzs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 16:55:48 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48703 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726184AbfGZUzs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 16:55:48 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id E977A21EAE;
        Fri, 26 Jul 2019 16:55:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 26 Jul 2019 16:55:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=3L5jxBgHli5NohmalPaEx8ZRAtT
        /SmIItX3mL6gr7MA=; b=QdiPjmxs27MxtcyP1f3Lxsq3jK3yxVU2kBn+MNuUb96
        JmCQdjS8oK/O6GR8iLXM3jNE3EDBaNSoYfnlJt7eO5ctcqcTyWlXxEK5vjjlHZB/
        Ci2ZbboDqBRFVXdVeNMrpEP57Nvb3Ya9R5r2gwXHYvi0bUeMvXP8bvO50fRrlTWN
        WSZMGt4aO2xgEUKCrmgi62V8kX+zr2Rz9HiPCzklM/JbHMe6MKjjFBLzToOPGi1n
        bTdpw48Gax5ZCw4Y/xbz+mHJ2KXHZm/9VWfeFbAXZB5Av2J/vZDp5WRK/gF+m4v1
        9iBWM5wMKtkaBIoCGxpU/pMjYS06fdVJIdwK0D4oGTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3L5jxB
        gHli5NohmalPaEx8ZRAtT/SmIItX3mL6gr7MA=; b=DlWhKFAr6mE57F50kozdUE
        D8zZgsqOdtFXrRzpIIFGJyGFKDO9eRDamTapIjC9m+m9GcTRVBXsO/jBrju3/WuW
        iwHbbA+x3EwyhKMv7W/E32xO4reH9uK73xdQXfbAq0KIoMhf5Yg7+VSwm19J3Vh/
        nrxbfZNPYZ/GmG4iGRIphmf6bO1dHIVoR6yy3GPeaCy+5atySWsVBgwRqNzNNRBI
        ah1kYKlLB1evQQCHovftkxh9D48k9T3duoiMnrA7nchBx9aGQndHXx1L8lA3eKie
        N//ve8hXy+b6r/A8L71dnHgGT+83OrxRhXddi6h9Vq3lFeDF98rYfb/M6hkd1MIA
        ==
X-ME-Sender: <xms:0mg7XU7dzNCzzLySVeRZk1TIMGr2enVNGfJlQZ-kjKzxr2k42Ap3Qw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeeggdduheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucffohhmrg
    hinhepthhrrggtvgdqvghvvghnthdqphgrrhhsvgdrtgifnecukfhppeeijedrudeitddr
    vddukedrvdefjeenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrh
    griigvlhdruggvnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:0mg7XaN75Ecu9cSE82YC0afZYwHGjBaHw_6zNPK5fJAlZYYEJLT9zA>
    <xmx:0mg7XeUYBIlvfI6A6WfDj4G-3l6Uwmq5x_4JJIiNr7QH0GE3m-e7hA>
    <xmx:0mg7XUXvgi0kDt2laKUmPbI-gBybcPKpbUE0NWmrIimcHIix2hAWXg>
    <xmx:0mg7XTjTl81JKbueP5PHtYcWQoPGfGJ9LLmeXQ0MZ5WHwVmeFKjBEg>
Received: from intern.anarazel.de (c-67-160-218-237.hsd1.ca.comcast.net [67.160.218.237])
        by mail.messagingengine.com (Postfix) with ESMTPA id DECBF380076;
        Fri, 26 Jul 2019 16:55:45 -0400 (EDT)
Date:   Fri, 26 Jul 2019 13:55:44 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] tools/lib/traceevent, tools/perf: Move struct
 tep_handler definition in a local header file
Message-ID: <20190726205544.yffnsfsnji362jk7@alap3.anarazel.de>
References: <20181005122225.522155df@gandalf.local.home>
 <20190726035829.4xcw5k2exx4omlvg@alap3.anarazel.de>
 <20190726091200.0d1e1f01@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726091200.0d1e1f01@gandalf.local.home>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

On 2019-07-26 09:12:00 -0400, Steven Rostedt wrote:
> On Thu, 25 Jul 2019 20:58:29 -0700
> Andres Freund <andres@anarazel.de> wrote:
> > 
> > Is just plain wrong, as:
> > 
> > > -		return pevent->events[idx];
> > > +		return (all_events + idx);  
> > 
> > that's not a valid conversion. ->events isn't an array of tep_handle,
> > it's an array of tep_handle* (and even if it were, the previous notation
> 
> You're right, it is wrong, but it's not tep_handle* but
> tep_event_format*.

Err, yea. Typo.



> > diff --git i/tools/lib/traceevent/event-parse.h w/tools/lib/traceevent/event-parse.h
> > index 642f68ab5fb2..7ebc9b5308d4 100644
> > --- i/tools/lib/traceevent/event-parse.h
> > +++ w/tools/lib/traceevent/event-parse.h
> > @@ -517,6 +517,7 @@ int tep_read_number_field(struct tep_format_field *field, const void *data,
> >  			  unsigned long long *value);
> >  
> >  struct tep_event *tep_get_first_event(struct tep_handle *tep);
> > +struct tep_event *tep_get_event(struct tep_handle *tep, int index);
> 
> I was looking at the tep_get_event() code, and we should switch that to
> "unsigned int index" otherwise passing in a negative number will return
> an address outside the array.

Makes sense.


> >  int tep_get_events_count(struct tep_handle *tep);
> >  struct tep_event *tep_find_event(struct tep_handle *tep, int id);
> >  
> > diff --git i/tools/perf/util/trace-event-parse.c w/tools/perf/util/trace-event-parse.c
> > index 62bc61155dd1..6a035ffd58ac 100644
> > --- i/tools/perf/util/trace-event-parse.c
> > +++ w/tools/perf/util/trace-event-parse.c
> > @@ -179,28 +179,26 @@ struct tep_event *trace_find_next_event(struct tep_handle *pevent,
> >  {
> >  	static int idx;
> >  	int events_count;
> > -	struct tep_event *all_events;
> >  
> > -	all_events = tep_get_first_event(pevent);
> >  	events_count = tep_get_events_count(pevent);
> 
> I think we can get rid of the events_count and all its checks, as the
> same check is done within tep_get_event().

> > -	if (!pevent || !all_events || events_count < 1)
> > +	if (!pevent || events_count < 1)
> 
> 	if (!pevent)
> 
> >  		return NULL;
> >  
> >  	if (!event) {
> >  		idx = 0;
> > -		return all_events;
> > +		return tep_get_event(pevent, 0);
> >  	}
> >  
> > -	if (idx < events_count && event == (all_events + idx)) {
> > +	if (idx < events_count && event == tep_get_event(pevent, idx)) {
> 
> 	if (event == tep_get_event(pevent, idx))
> 		return tep_get_event(pevent, ++idx);
> 
> >  		idx++;
> >  		if (idx == events_count)
> >  			return NULL;
> > -		return (all_events + idx);
> > +		return tep_get_event(pevent, idx);
> >  	}
> >  
> 
> 	struct tep_event_format *next_event;
> 
> 	for (idx = 0; next_event = tep_get_event(pevent, idx); idx++)
> 		if (event == next_event)
> 			return tep_get_event(pevent, ++idx);
> 
> Also, I think setting the idx to 1 in the loop is wrong. Why? think of
> this:
> 
> 	first_event = trace_find_next_event(pevent, NULL);
> 
> 	next_event = trace_find_next_event(pevent, first_event);
> 	for (i = 0; i < 5; i++)
> 		next_event = trace_find_next_event(pevent, next_event);
> 
> 	second_event = trace_find_next_event(pevent, first_event);
> 
> second_event would become NULL.

How about my proposal to instead change the loops in
trace-event-{python,perl}.c, the only callers of trace_find_next_event,
to be something akin to

[idx_type_for_tep_get_event] event_count = tep_get_events_count(pevent);
for ([idx_type_for_tep_get_event] idx = 0; idx < event_count; idx++)
{
	struct tep_event *event = tep_get_events(...);

}

and just removing trace_find_next_event()? It's not a nice API imo, and
seems unnecessary given that the events aren't a linked list anymore.


> Care to send a formal patch?

Will do.

Greetings,

Andres Freund
