Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7757C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 23:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 906E864F03
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 23:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235585AbhBXXIy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 18:08:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235541AbhBXXIy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 18:08:54 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 474CE64F03;
        Wed, 24 Feb 2021 23:08:13 +0000 (UTC)
Date:   Wed, 24 Feb 2021 18:08:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] trace-cmd: Add validation for reading and
 writing trace.dat files
Message-ID: <20210224180811.4f5accd4@gandalf.local.home>
In-Reply-To: <CAPpZLN7Ghth=9uxpu2oYAPbAHO0N2SBYbw0502fEWedEyZPzQg@mail.gmail.com>
References: <20210219053156.2235035-1-tz.stoyanov@gmail.com>
        <20210219053156.2235035-2-tz.stoyanov@gmail.com>
        <20210223171819.3b42b9e8@gandalf.local.home>
        <CAPpZLN7Ghth=9uxpu2oYAPbAHO0N2SBYbw0502fEWedEyZPzQg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Feb 2021 07:22:09 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
> > > ---  
> >  
> > >  /* --- Opening and Reading the trace.dat file --- */
> > >
> > > +enum  {
> > > +     TRACECMD_FILE_INIT,
> > > +     TRACECMD_FILE_HEADERS,
> > > +     TRACECMD_FILE_FTRACE_EVENTS,
> > > +     TRACECMD_FILE_ALL_EVENTS,
> > > +     TRACECMD_FILE_KALLSYMS,
> > > +     TRACECMD_FILE_PRINTK,
> > > +     TRACECMD_FILE_CMD_LINES,
> > > +     TRACECMD_FILE_CPU_COUNT,
> > > +     TRACECMD_FILE_OPTIONS,
> > > +     TRACECMD_FILE_CPU_LATENCY,
> > > +     TRACECMD_FILE_CPU_FLYRECORD,  
> >
> > I still really don't think we want to make LATENCY and FLYRECORD states.
> > Because they are not a state of the trace.dat file, but a type.  
> 
> I considered these as states, as any of the previous states, that indicate
> what kind of data is currently in the file. We can replace both with a single
> TRACECMD_FILE_CPU_DATA state, and use the old TRACECMD_FL_
> flags to find what kind of tracing data is in the file.

I just realized that the flags were only used by trace-input and not
trace-output (which is what I was thinking it was). But I guess once you
get to the latency or flyrecord state, that would be the last state for
reading.

> 
> >
> > Unless we document here that they are the last states of the file, and once
> > reached, the state can not change.  
> 
> This is true for the current tarce.dat file format - they are the last states
> and as for the all other states - once reached, previously written data
> cannot be changed. May be I cannot understand your point here, may
> be you mean that once these final states are reached, the tracing data
> is still not written in the file (read from the file) ? In that case may be it
> is more logical to add additional state, to indicate that all trace data is
> in the file, regardless of its type (cpu / latency) ?

I think because the states are used for both reading and writing, I was
thinking the flags were too, but looking at the previous code, I see it's
not. My concern was for the writing of the file, and that appears to not be
an issue.

That said, there's some minor fixes in the patch I'll reply with a separate
email.

-- Steve



