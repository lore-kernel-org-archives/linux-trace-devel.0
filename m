Return-Path: <SRS0=Ns+A=OK=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:60650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbeLAPKG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 1 Dec 2018 10:10:06 -0500
Date: Fri, 30 Nov 2018 22:58:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 14/15] tools/lib/traceevent: Change description of
 few APIs
Message-ID: <20181130225832.39b2a90d@vmware.local.home>
In-Reply-To: <20181130224301.1828d3b1@vmware.local.home>
References: <20181128090711.17792-1-tstoyanov@vmware.com>
        <20181128090711.17792-15-tstoyanov@vmware.com>
        <20181130224301.1828d3b1@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 30 Nov 2018 22:43:01 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> > index 7b26b9e3a4ba..aed098f29b66 100644
> > --- a/tools/lib/traceevent/event-parse.c
> > +++ b/tools/lib/traceevent/event-parse.c
> > @@ -6441,7 +6441,7 @@ int tep_get_any_field_val(struct trace_seq *s, struct tep_event *event,
> >   * @record: The record with the field name.
> >   * @err: print default error if failed.
> >   *
> > - * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
> > + * Returns: 1 on success, -1 field not found, or 0 if buffer is full.  
> 
> Actually, it looks like it returns the length written on success.

And this actually changed by your update to trace_seq_printf() in patch
11.

Luckily, it appears that the only use cases just check for the -1. :-)

-- Steve

> 
> >   */
> >  int tep_print_num_field(struct trace_seq *s, const char *fmt,
> >  			struct tep_event *event, const char *name,
> > @@ -6473,7 +6473,7 @@ int tep_print_num_field(struct trace_seq *s, const char *fmt,
> >   * @record: The record with the field name.
> >   * @err: print default error if failed.
> >   *
> > - * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
> > + * Returns: 1 on success, -1 field not found, or 0 if buffer is full.  
> 
> This too.
