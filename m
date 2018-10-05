Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:45766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725761AbeJFEOT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 6 Oct 2018 00:14:19 -0400
Date: Fri, 5 Oct 2018 17:13:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: tzvmware@gmail.com
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: Re: [PATCH v2] tools/lib/traceevent, tools/perf: Move struct
 tep_handler definition in a local header file
Message-ID: <20181005171347.5e5f9341@gandalf.local.home>
In-Reply-To: <20181005123125.7cbcaf84@gandalf.local.home>
References: <20181005091709.2bd7abe8@gandalf.local.home>
        <20181005133109.18740-1-tzvmware@gmail.com>
        <20181005123125.7cbcaf84@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 5 Oct 2018 12:31:25 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > +/**
> > + * tep_get_events_count - get the number of defined events
> > + * @pevent: a handle to the tep_handle
> > + *
> > + * This returns number of elements in event array
> > + * If @pevent is NULL, 0 is returned.  
> 
> Here too with the pevent/tep.
> 
> > + */
> > +int tep_get_events_count(struct tep_handle *tep)
> > +{
> > +	if(tep)
> > +		return tep->nr_events;
> > +	return 0;
> > +}
> > +
> > +/**
> > + * tep_set_flag - set event parser flag
> > + * @pevent: a handle to the tep_handle
> > + * @flag: flag, or combination of flags to be set
> > + * can be any combination from enum tep_flag  
> 
> Ditto.

I never committed these changes :-p

So they are not updated. Please fix this on v3.

Thanks!

-- Steve
