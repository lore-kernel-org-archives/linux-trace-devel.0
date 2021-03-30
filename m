Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15329C433C1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 14:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E14CA619D6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 14:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhC3OxQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232023AbhC3Oww (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 10:52:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11947619CF;
        Tue, 30 Mar 2021 14:52:51 +0000 (UTC)
Date:   Tue, 30 Mar 2021 10:52:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: Re: [PATCH 13/13 v2] libtracefs: Add CONTINUE to
 tracefs_function_filter()
Message-ID: <20210330105250.0a7105a1@gandalf.local.home>
In-Reply-To: <CAPpZLN57JrvSNTCGJTe7A9_x9Z4rSsH54jQu5C8wqodii=np4w@mail.gmail.com>
References: <20210330005123.151740983@goodmis.org>
        <20210330005249.118764252@goodmis.org>
        <CAPpZLN57JrvSNTCGJTe7A9_x9Z4rSsH54jQu5C8wqodii=np4w@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 30 Mar 2021 17:29:57 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Tue, Mar 30, 2021 at 3:54 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> >
> > Add the TRACEFS_FL_CONTINUE flag to the tracefs_function_filter() API that
> > will allow it to return without closing the set_ftrace_filter file. When
> > the set_ftrace_filter file is closed, all the changes to it take place,
> > but not before hand. In the case that multiple modules need to be set in
> > one activation, the tracefs_function_filter() would need to be called
> > multiple times without closing the file descriptor.
> >
> > Note, the next call to tracefs_function_filter() after it was called with
> > the CONTINUE flag set, the RESET flag is ignored, as the RESET flag only
> > takes effect on opening the file. The next call to
> > tracefs_function_filter() after it was called with the CONTINUE flag (on
> > the same instance) does not reopen the file, and thus will not reset the
> > file.  
> 
> I think it is better to not maintain a state in the API context. Let's
> make it simple and allow the user to take care of the calling order
> and flags.
>    If RESET is set - close the file (if it is opened already) and open
> it with the TRUNC flag.

In the use cases I've played with, it was simple to do:

	for (i = 0; filters[i]; i++)
		tracefs_function_filter(instance, filters[i], module,
				TRACEFS_FL_RESET | TRACEFS_FL_CONTINUE);

And not worry about keeping track of the RESET flag. This is the reason I
did it this way. Otherwise I would need to be:

	int reset = TRACEFS_FL_RESET;
	for (i = 0; filters[i]; i++) {
		tracefs_function_filter(instance, filters[i], module,
				reset | TRACEFS_FL_CONTINUE);
		reset = 0;
	}

Or something else. But I'm looking to simplify the most common case.

And closing the file can cause issues. If we were to go this way, I would
make it that if the file is open and RESET is set, it would return an error
EBUSY.

But no, closing the file just because RESET is set is dangerous.

>    If CONTINUE is set - do not close the file.
> Also, allow calling the API with no filters and any combination of
> flags, just to have resting and committing currently written filters.
> For example:
>  tracefs_function_filter(NULL, NULL, NULL, TRACEFS_FL_RESET, NULL); //
> Close the file (if it is opened already), open it with the TRUNC flag
> and close it.
>  tracefs_function_filter(NULL, NULL, NULL, TRACEFS_FL_CONTINUE, NULL);
> //  Open the file with APPEND (if it is not opened already) and do not
> close it.
>  tracefs_function_filter(NULL, NULL, NULL, TRACEFS_FL_RESET |
> TRACEFS_FL_CONTINUE, NULL);  // Close the file (if it is opened
> already), open it with the TRUNC flag and do not close it.

Yes, I had already planned on adding a patch to allow NULL filter when
these flags are set. I just didn't get there yet.

-- Steve

> 
> 
> >
> > If the file is opened, calling tracefs_function_filter() with no filters
> > and the continue flag not set, will simply close the set_ftrace_filter
> > file.
> >
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > ---
