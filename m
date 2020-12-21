Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A62C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 04:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4040822CF7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 04:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbgLUEKy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 20 Dec 2020 23:10:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgLUEKy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 20 Dec 2020 23:10:54 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B911322CF7;
        Mon, 21 Dec 2020 04:10:13 +0000 (UTC)
Date:   Sun, 20 Dec 2020 23:10:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/9] libtracefs man pages: APIs for locating trace
 directory and files.
Message-ID: <20201220231011.0418e4ce@oasis.local.home>
In-Reply-To: <CAPpZLN5VZMGx9rpUktjSDFiKhOw8BUqSqdDdHOCGMF3O5c8TpA@mail.gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
        <20201217094626.1402191-4-tz.stoyanov@gmail.com>
        <20201218135519.2643e7cd@gandalf.local.home>
        <CAPpZLN5VZMGx9rpUktjSDFiKhOw8BUqSqdDdHOCGMF3O5c8TpA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 21 Dec 2020 05:44:45 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> > How should it be freed?
> I'll add " with free()" in the next version of the patch, but I was
> wondering if the
> user should use "tracefs_put_tracing_file()" instead ? These APIs are not
> consistent, may be they should be renamed.

Good point.

> Now we have:
> 
>    tracefs_get_tracing_file() / tracefs_put_tracing_file()
>    tracefs_get_tracing_dir() / returns static, must not be feed.
>    tracefs_find_tracing_dir() / free()

Perhaps we should change tracefs_get_tracing_dir() to simply:
tracefs_tracing_dir().


Hmm, what's the difference between "tracefs_find_tracing_dir() and
tracefs_get_tracing_dir() (or what we will call tracefs_tracing_dir())?

The only difference I see from the two descriptions is that one returns
a cached string and the other returns just an allocated string. Do we
even need tracefs_find_tracing_dir()?

> 
> 
> >
> > > +
> > > +The _tracefs_get_tracing_dir()_ function returns the full path to the
> > > +trace file system. In the first function call, the mount point of the
> > > +tracing file system is located, cached and returned. It will mount it,
> > > +if it is not minted. On any subsequent call the cached path is returned.

Just noticed the above typo. s/minted/mounted/

Although,  I wonder if a minted dir tastes good? ;-)

-- Steve

> > > +The return string must _not_ be freed.
> > > +
> > > +RETURN VALUE
> > > +------------
> > > +The _tracefs_get_tracing_file()_ function returns a string or NULL in case
> > > +of an error. The returned string must be freed with _tracefs_put_tracing_file()_.
> > > +
> > > +The _tracefs_find_tracing_dir()_ function returns a string or NULL in case
> > > +of an error. The returned string must be freed.
> >
> > Should state how it should be freed. tracefs_put_tracing_file() or free() ?
> >
> > If it is free(), then stating:
> >
> >  "The returned string must be freed with free()"
> >
> > is fine.
> >
> > > +
> > > +The _tracefs_get_tracing_dir()_ function returns a constant string or NULL
> > > +in case of an error. The returned string must _not_ be freed.
> > > +
> > > +EXAMPLE
> > > +-------
> > > +[source,c]
> > > +--
> > > +#include <tracefs.h>
> > > +...
> > > +char *trace_on = tracefs_get_tracing_file("tracing_on");
> > > +     if (trace_on) {
> > > +             ...
> > > +             tracefs_put_tracing_file(trace_on);
> > > +     }
> > > +...
> > > +char *trace_dir = tracefs_find_tracing_dir();
> > > +     if (trace_dir) {
> > > +             ...
> > > +             free(trace_dir);
> > > +     }
> > > +...
> > > +const char *trace_dir = tracefs_get_tracing_dir();
> > > +
> >
> > Not a very useful example ;-)  We we can fix examples at a later time. I
> > plan on writing a lot of example code to post, and some can make their way
> > into the man pages.
> >
> > -- Steve
> 
> 
> 

