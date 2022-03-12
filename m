Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D03C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Mar 2022 02:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiCLCHP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Mar 2022 21:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCLCHO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Mar 2022 21:07:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E27CB7CD
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Mar 2022 18:06:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DACA361708
        for <linux-trace-devel@vger.kernel.org>; Sat, 12 Mar 2022 02:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8244EC340E9;
        Sat, 12 Mar 2022 02:06:08 +0000 (UTC)
Date:   Fri, 11 Mar 2022 21:06:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: Re: [RFC PATCH] tracing/user_events: Limit showing event names to
 CAP_SYS_ADMIN users
Message-ID: <20220311210606.62d09579@rorschach.local.home>
In-Reply-To: <20220312010509.GA1931@kbox>
References: <20220312010140.1880-1-beaub@linux.microsoft.com>
        <20220312010509.GA1931@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


[ Added Kees Cook ]

On Fri, 11 Mar 2022 17:05:09 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> On Fri, Mar 11, 2022 at 05:01:40PM -0800, Beau Belgrave wrote:
> > Show actual names only to CAP_SYS_ADMIN capable users.
> > 
> > When user_events are configured to have broader write access than
> > default, this allows seeing names of events from other containers, etc.
> > Limit who can see the actual names to prevent event squatting or
> > information leakage.
> > 
> > Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> > ---
> >  kernel/trace/trace_events_user.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> > index 2b5e9fdb63a0..fb9fb2071173 100644
> > --- a/kernel/trace/trace_events_user.c
> > +++ b/kernel/trace/trace_events_user.c
> > @@ -1480,6 +1480,9 @@ static int user_seq_show(struct seq_file *m, void *p)
> >  	struct user_event *user;
> >  	char status;
> >  	int i, active = 0, busy = 0, flags;
> > +	bool show_names;
> > +
> > +	show_names = capable(CAP_SYS_ADMIN);
> >  
> >  	mutex_lock(&reg_mutex);
> >  
> > @@ -1487,7 +1490,10 @@ static int user_seq_show(struct seq_file *m, void *p)
> >  		status = register_page_data[user->index];
> >  		flags = user->flags;
> >  
> > -		seq_printf(m, "%d:%s", user->index, EVENT_NAME(user));
> > +		if (show_names)
> > +			seq_printf(m, "%d:%s", user->index, EVENT_NAME(user));
> > +		else
> > +			seq_printf(m, "%d:<hidden>", user->index);
> >  
> >  		if (flags != 0 || status != 0)
> >  			seq_puts(m, " #");
> > 
> > base-commit: 864ea0e10cc90416a01b46f0d47a6f26dc020820
> > -- 
> > 2.17.1  
> 
> I wanted to get some comments on this. I think for scenarios where
> user_events is used in a heavy cgroup environment, that we need to have
> some tracing cgroup awareness.
> 
> Has this come up before? I would like to only show user_events that have
> been created in the current cgroup (and below) like perf_events do for
> capturing.

I added Kees because he had issues with capabilities in the past wrt
tracing. Talking with him was one of the reasons I decided to push the
file permissions for who has what access.

> 
> I would also like to get to a point where we can limit how many events
> each cgroup can register under user_events.
> 
> To me, this sounds like a large feature that requires some alignment for
> getting tracing cgroup aware.

At the moment I do not have a use case in mind to evaluate the
situation. But understanding more about how this will be used by a
broader audience would be useful.

-- Steve
