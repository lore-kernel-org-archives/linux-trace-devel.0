Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1133C282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 13:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C82EE21773
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 13:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732240AbfDQNTZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 09:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726800AbfDQNTZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 09:19:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76C3F206BA;
        Wed, 17 Apr 2019 13:19:24 +0000 (UTC)
Date:   Wed, 17 Apr 2019 09:19:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/2] trace-cmd: remove parsing_failures APIs from
 libtraceevent
Message-ID: <20190417091922.1e4c5f19@gandalf.local.home>
In-Reply-To: <CACqStoc1vyLp=8XavFoXBCrFQh7C5eruhhGoVLwqHS670TP06g@mail.gmail.com>
References: <20190415125823.4011-1-tstoyanov@vmware.com>
        <20190416184832.2bb69162@gandalf.local.home>
        <CACqStoc1vyLp=8XavFoXBCrFQh7C5eruhhGoVLwqHS670TP06g@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 17 Apr 2019 09:10:26 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

Let's not add this. Instead add a "parsing_failures" to the
> > tracecmd_input handle, and add:
> >
> > int tracecmd_get_parsing_failures(struct tracecmd_input *handle)
> > {
> >         return handle->parsing_failures;
> > }
> >  
> I hesitated if to add new API, or use additional parameter to the
> existing functions.
> The reason for this change is to remove "parsing_failures" from
> traceevent library,
> that's why I decided not to move it to trace-cmd library. Using new
> library API is nicer,
> I can reimplement it in this way, but we may have the same concerns
> when trace-cmd
> library comes out.
> 

That's a valid concern, but there is a difference between the
libtraceevent and libftrace (or whatever we decide to name it ;-)

The trace-cmd code will be a higher level library on top of
libtraceevent. The main difference is that the trace-cmd code has
algorithms that deal with the counter but the tep code did not. We
incorrectly added that counter to the tep code only because a higher
layer needed it. The tep layer did not understand the context of that
counter.

My concern with the counter in the tep code was that it was at the
wrong level. That is, the tep code had no processing for that counter.
To put it a different way, the tep code did not understand the context
of the counter. We had to add API to set and reset that counter, which
was a clear indication that the tep library shouldn't be the one to
store it.

Now at the trace-cmd code level (libftrace), it most definitely
understands the context of that counter. Thus the counter should be
stored at that level. We didn't need to add APIs to the trace-cmd code
to reset that counter, or increment it. Because the trace-cmd library
knows the context of the counter. That's how one knows if the library
should store the counter or not.

Let's make the parsing_failures part of the tracecmd_input handler and
it will simplify this patch quite a bit.

Does that make sense?

-- Steve


> > > +{
> > > +     return _tracecmd_read_headers(handle, parsing_failures);
> > > +}
> > > +  
> >
> > [..]
> >  
> > > diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
> > > index 52fa1bd..fe116cc 100644
> > > --- a/tracecmd/trace-read.c
> > > +++ b/tracecmd/trace-read.c
> > > @@ -1417,6 +1417,7 @@ void trace_report (int argc, char **argv)
> > >       unsigned long long tsoffset = 0;
> > >       unsigned long long ts2secs = 0;
> > >       unsigned long long ts2sc;
> > > +     int parsing_failures;
> > >       int show_stat = 0;
> > >       int show_funcs = 0;
> > >       int show_endian = 0;
> > > @@ -1714,10 +1715,10 @@ void trace_report (int argc, char **argv)
> > >                       tracecmd_print_events(handle, print_event);
> > >                       return;
> > >               }
> > > -
> > > -             ret = tracecmd_read_headers(handle);
> > > +             parsing_failures = 0;
> > > +             ret = tracecmd_read_headers_failures(handle, &parsing_failures);  
> >
> > Here we should do:
> >
> >                 ret = tracecmd_read_headers(handle);
> >  
> > >               if (check_event_parsing) {
> > > -                     if (ret || tep_get_parsing_failures(pevent))  
> >
> >                         if (ret || tracecmd_get_parsing_failures(handle))
> >
> > -- Steve
> >  
> > > +                     if (ret || parsing_failures)
> > >                               exit(EINVAL);
> > >                       else
> > >                               exit(0);  
> >  
> 
> 

