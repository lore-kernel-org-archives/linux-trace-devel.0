Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5AE1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 02:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354991AbhLBC6x (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 21:58:53 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:43438 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241048AbhLBC6p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 21:58:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6CC2ACE215E
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 02:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC8AC00446;
        Thu,  2 Dec 2021 02:55:14 +0000 (UTC)
Date:   Wed, 1 Dec 2021 21:55:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Michael Sartain <mikesart@fastmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd library: Add API to get information from
 trace file
Message-ID: <20211201215512.60124f14@oasis.local.home>
In-Reply-To: <20211202023655.4nva3roddesa5lfh@mikesart-tr3>
References: <20211201022431.64763-1-mikesart@fastmail.com>
        <20211201103322.24146cd5@gandalf.local.home>
        <20211202023655.4nva3roddesa5lfh@mikesart-tr3>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 1 Dec 2021 19:36:55 -0700
Michael Sartain <mikesart@fastmail.com> wrote:

> On Wed, Dec 01, 2021 at 10:33:22AM -0500, Steven Rostedt wrote:
> > On Tue, 30 Nov 2021 19:24:31 -0700
> > Michael Sartain <mikesart@fastmail.com> wrote:
> >  
> > > New APIs added to get trace cpustats, uname, version strings, and
> > > cpu file sizes and offsets.  
> 
> ...
> 
> > > +const char *tracecmd_get_cpustats(struct tracecmd_input *handle);
> > > +const char *tracecmd_get_uname(struct tracecmd_input *handle);
> > > +const char *tracecmd_get_version(struct tracecmd_input *handle);
> > > +unsigned long long tracecmd_get_cpu_file_offset(struct tracecmd_input *handle, int cpu);
> > > +unsigned long long tracecmd_get_cpu_file_size(struct tracecmd_input *handle, int cpu);  
> >
> > I wonder if we should follow normal standards here and return off64_t type
> > instead of unsigned long long? As that is what is returned by lseek64().  
> 
> Happy to make this change. Just to be clear, several ts and cursor
> functions already in trace-cmd-private.h take "long long" parameters for
> trace_ids, timestamps, offsets, time, etc. Do you have longer term plans
> of migrating other things to off64_t?

Not for the trace_ids or timestamps. But perhaps the offsets should
change. I noticed that this is for file size and offset, which off64_t
is commonly used for. I didn't mean it to be for all unsigned long long
conversions.

> 
> > For all APIs, we require a "kernel doc" style comment. That is:
> > And the rest of the functions also need a kernel doc.  
> 
> Sounds good, I'm on it.

Awesome.

> 
> > Not to mention, we would need to add a man page to describe these too. See
> > the Documentation/libtracecmd directory for examples.  
> 
> This code is all in include/private/trace-cmd-private.h and it doesn't
> look like any of the existing functions (like tracecmd_get_trace_clock)
> have man pages.

Ah, my mistake. For some reason I thought these were going into
include/trace-cmd/trace-cmd.h. Forget I mentioned it. Note, that the
include/private/trace-cmd-private.h *is* a stepping stone to make them
public. That is, everything in there will eventually move to
trace-cmd.h as a public API, in which we will need a man page for.
Since once it is in trace-cmd.h, it becomes a stable API (sketched in
stone), we want to make sure that it's at its final stage before moving
it there. APIs are hard :-p

> 
> Seems like the trace-cmd man pages all describe the trace-cmd
> executable?

Not the Documentation/libtracecmd/ directory.


> 
> For background, we're wanting to add these functions to this private
> header file since we're pulling trace-input.c, trace-hooks.c, and
> trace-util.c into our binary (along with libtracevent) to read events
> from trace.dat files. Right now tracecmd_input struct members (like
> uname) are local to trace-input.c and only externally visible via
> tracecmd_print_uname(). Which isn't useful to a gui app, natch.

Sounds like what you are doing is the perfect use case for us. We want
libtracecmd to become available for all tools (not just guis). So, yes
we are very interested in what you are doing.

But we are being very conservative about this, because the code was
done with a more specific use case, and to get the API correct, we need
a broader view. As stated before, once we release a library with an
API, it's going to be very difficult to change. I follow the Linux
mantra of "Don't break user space" where I believe libraries should
follow "Don't break users of the library".

> 
> But yeah, please let me know how you'd like to proceed. Happy to
> start a man page for trace-cmd-private.h but pretty sure I'm not the
> best person to document *all* the current functions in this file. :)

Forget I asked. I could have sworn you added to the public code.
Anyway, it will be needed once we start adding those functions into the
public header.

> 
> > > +unsigned long long tracecmd_get_cpu_file_offset(struct
> > > tracecmd_input *handle, int cpu)  
> >
> >    Should be "unsigned int cpu"  
> 
> There are a several existing functions that take an "int cpu"
> parameter.
> 
> Is this something where this new functions should use an unsigned int
> and then update the others later, or perhaps add a check in the code
> for negative cpu values and keep the "int cpu" parameter to stay
> consistent with the others?

I was more worried about a negative index into the array. It's fine to
have int cpu, as long as you have a test of:

	if (cpu < 0)
		return -1; // or whatever

I just didn't want out of bound accesses of arrays.

> 
> > Anyway, welcome to our community Michael!  
> 
> Thanks for the feedback and warm welcome Steven - much appreciated!

Looking forward to working with you some more.

-- Steve

