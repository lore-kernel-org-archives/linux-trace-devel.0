Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27C6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Mar 2022 02:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiCLC6a (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Mar 2022 21:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCLC63 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Mar 2022 21:58:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C1124F78E
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Mar 2022 18:57:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77F8D6188D
        for <linux-trace-devel@vger.kernel.org>; Sat, 12 Mar 2022 02:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C3EC340E9;
        Sat, 12 Mar 2022 02:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647053843;
        bh=ln59I/+o8orDgwenXVVnK7wF7VC1zsh3rjcxEEupLnQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bIta2UhfVViG1a1n7cjLe6LDZfYZedoeZWCpRiCtt6N8VXHKmJRcxCOhmJHSZD/cM
         26cg+ixZs0rOaeGWzWPgq0g/euq5TQc+pVv22IzW5luhus63mq7J6wYIgcDytkC8Zl
         niV9GZ3/MMKsz59ZLoI7GZZDTl/4k9lploukP/YZ78eiqVkODy9WQaBS1l7uaqCHMS
         JnUmfyCnVsI61HqFxqj+ouAAgAOhEm7NKmK7Ox3SOVBG0MflUNAVwYK8FPlFfZwYWH
         zBdr6S2dgcYke6VZK1Wnns0BePukesuUuQDWE33tlblUuvRxK74pHndKI0YR/+iKnv
         mig87tk3s3X5w==
Date:   Sat, 12 Mar 2022 11:57:19 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>, mhiramat@kernel.org,
        linux-trace-devel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: Re: [RFC PATCH] tracing/user_events: Limit showing event names to
 CAP_SYS_ADMIN users
Message-Id: <20220312115719.996f8014b9a0aaf6f1cef52c@kernel.org>
In-Reply-To: <20220311210606.62d09579@rorschach.local.home>
References: <20220312010140.1880-1-beaub@linux.microsoft.com>
        <20220312010509.GA1931@kbox>
        <20220311210606.62d09579@rorschach.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Beau,

On Fri, 11 Mar 2022 21:06:06 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> [ Added Kees Cook ]
> 
> On Fri, 11 Mar 2022 17:05:09 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > On Fri, Mar 11, 2022 at 05:01:40PM -0800, Beau Belgrave wrote:
> > > Show actual names only to CAP_SYS_ADMIN capable users.
> > > 
> > > When user_events are configured to have broader write access than
> > > default, this allows seeing names of events from other containers, etc.
> > > Limit who can see the actual names to prevent event squatting or
> > > information leakage.
> > > 
> > > Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> > > ---
> > >  kernel/trace/trace_events_user.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> > > index 2b5e9fdb63a0..fb9fb2071173 100644
> > > --- a/kernel/trace/trace_events_user.c
> > > +++ b/kernel/trace/trace_events_user.c
> > > @@ -1480,6 +1480,9 @@ static int user_seq_show(struct seq_file *m, void *p)
> > >  	struct user_event *user;
> > >  	char status;
> > >  	int i, active = 0, busy = 0, flags;
> > > +	bool show_names;
> > > +
> > > +	show_names = capable(CAP_SYS_ADMIN);
> > >  
> > >  	mutex_lock(&reg_mutex);
> > >  
> > > @@ -1487,7 +1490,10 @@ static int user_seq_show(struct seq_file *m, void *p)
> > >  		status = register_page_data[user->index];
> > >  		flags = user->flags;
> > >  
> > > -		seq_printf(m, "%d:%s", user->index, EVENT_NAME(user));
> > > +		if (show_names)
> > > +			seq_printf(m, "%d:%s", user->index, EVENT_NAME(user));
> > > +		else
> > > +			seq_printf(m, "%d:<hidden>", user->index);
> > >  
> > >  		if (flags != 0 || status != 0)
> > >  			seq_puts(m, " #");
> > > 
> > > base-commit: 864ea0e10cc90416a01b46f0d47a6f26dc020820
> > > -- 
> > > 2.17.1  
> > 
> > I wanted to get some comments on this.

I think this is a bit add-hoc. We may need more generic way to hide the
event name from someone (who?) Is it enough to hide only event name?

> > I think for scenarios where
> > user_events is used in a heavy cgroup environment, that we need to have
> > some tracing cgroup awareness.

Would you mean to hide the event name from other cgroups or you need a
filter depends on cgroup/namespace?

As far as I know, current ftrace interface doesn't care about namespace
nor cgroups. It expects to be used outside of cgroups/namespace because
most of the events are for tracing kernel.(except for uprobe events until
user-events is introduced)

I think the easiest option is to introduce a new event filter rule based
on the container (cgroup path or namespace inode). With such filter
you can trace one container application from *outside* of the container.

For tracing from inside a container, I think you may need a mount option
to expose only 'container-local' events and buffer.
If you want only limits the buffer, it will be something like this;

container$ mount -o instance=foo tracefs /sys/kernel/trace

(Note that this may expose the *kernel* events to the containers.
 we should hide those by default)

But limits (and hide) the user-defined events, we have to consider about
namespace confliction. Maybe we can assign a random group name for user
events when mounting the tracefs.

> > Has this come up before? I would like to only show user_events that have
> > been created in the current cgroup (and below) like perf_events do for
> > capturing.
> 
> I added Kees because he had issues with capabilities in the past wrt
> tracing. Talking with him was one of the reasons I decided to push the
> file permissions for who has what access.
> 
> > 
> > I would also like to get to a point where we can limit how many events
> > each cgroup can register under user_events.

I think that requires to extend cgroups itself, something like trace-cgroup,
because it is a bit odd to limit resouces by ftrace itself based on cgroups.
(cgroup is the resouce control group)

> > 
> > To me, this sounds like a large feature that requires some alignment for
> > getting tracing cgroup aware.
> 
> At the moment I do not have a use case in mind to evaluate the
> situation. But understanding more about how this will be used by a
> broader audience would be useful.

Yeah, this is a good & interesting discussion topic :-)

Thank you,


> 
> -- Steve


-- 
Masami Hiramatsu <mhiramat@kernel.org>
