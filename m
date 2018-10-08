Return-Path: <SRS0=f4gm=MU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:54324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbeJIApX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Oct 2018 20:45:23 -0400
Date: Mon, 8 Oct 2018 14:32:24 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] tools/lib/traceevent, tools/perf: Move struct
 tep_handler definition in a local header file
Message-ID: <20181008173224.GP3541@kernel.org>
References: <20181005122225.522155df@gandalf.local.home>
 <20181005122846.4b974dbd@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005122846.4b974dbd@gandalf.local.home>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Em Fri, Oct 05, 2018 at 12:28:46PM -0400, Steven Rostedt escreveu:
> On Fri, 5 Oct 2018 12:22:25 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +/**
> > + * tep_get_first_event - returns the first event in the events array
> > + * @tep: a handle to the tep_handle
> > + *
> > + * This returns pointer to the first element of the events array
> > + * If @tep is NULL, NULL is returned.
> > + */
> > +struct tep_event_format *tep_get_first_event(struct tep_handle *tep)
> > +{
> > +	if(tep && tep->events)
> > +		return tep->events[0];
> > +
> > +	return NULL;
> > +}
> > +
> 
> Hold off on pulling this in. This patch has some whitespace issues that
> need to be cleaned up.

Ah, that if( thing? ?I can fix it here, holler if there is more than
that.
