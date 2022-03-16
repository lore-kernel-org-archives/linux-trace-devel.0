Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5753AC3527A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Mar 2022 14:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356792AbiCPOZo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 10:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356980AbiCPOW7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 10:22:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A60F2A733
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Mar 2022 07:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 971FAB81B7A
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Mar 2022 14:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E65C340E9;
        Wed, 16 Mar 2022 14:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440413;
        bh=HwE7orogBOMnYdIU8kJOHTbS/IaTshTFwTfQgcYLAvg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lOjy6kPejXtfdWa/xrxDU/GBPHFnsOSeOsLVCFsTbKAhMrfM+/bcpAMLToGpcvpgt
         KJsS0DheNcI8XuFKl7rMqTdRz1ef5HIsOEXY9DQA3zbsrFkU18Ge5boEO9tghDWPNe
         Q5kWKE5eddK+//bUY7dyX9FFhg3aLZj632ZBI09k0YrcM6lERRW7Ku5oGsc9xDSV9s
         gf5xfvDWLAgFrtGg90HcXH3y1xDJqNaNyOPGgb42BS9OUA9Dl71dNMyPz4B2xC+4IV
         MgUggkhn6sx3AhnkB/LQ73/FKog7tqZ8x+q54fJvoigYYAzLiYY5oVB0slUJeYVcQS
         wQ5ue8DfHeDtw==
Date:   Wed, 16 Mar 2022 23:20:09 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: Re: [RFC PATCH] tracing/user_events: Limit showing event names to
 CAP_SYS_ADMIN users
Message-Id: <20220316232009.7952988633787ef1003f13b0@kernel.org>
In-Reply-To: <20220314170610.GA1673@kbox>
References: <20220312010140.1880-1-beaub@linux.microsoft.com>
        <20220312010509.GA1931@kbox>
        <20220311210606.62d09579@rorschach.local.home>
        <20220312115719.996f8014b9a0aaf6f1cef52c@kernel.org>
        <20220314170610.GA1673@kbox>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 14 Mar 2022 10:06:10 -0700
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> On Sat, Mar 12, 2022 at 11:57:19AM +0900, Masami Hiramatsu wrote:
> > Hi Beau,
> > 
> > On Fri, 11 Mar 2022 21:06:06 -0500
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > 
> > > [ Added Kees Cook ]
> > > 
> > > On Fri, 11 Mar 2022 17:05:09 -0800
> > > Beau Belgrave <beaub@linux.microsoft.com> wrote:
> > > 
> > > > On Fri, Mar 11, 2022 at 05:01:40PM -0800, Beau Belgrave wrote:
> > > > > Show actual names only to CAP_SYS_ADMIN capable users.
> > > > > 
> > > > > When user_events are configured to have broader write access than
> > > > > default, this allows seeing names of events from other containers, etc.
> > > > > Limit who can see the actual names to prevent event squatting or
> > > > > information leakage.
> > > > > 
> > > > > Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> > > > > ---
> > > > >  kernel/trace/trace_events_user.c | 8 +++++++-
> > > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> > > > > index 2b5e9fdb63a0..fb9fb2071173 100644
> > > > > --- a/kernel/trace/trace_events_user.c
> > > > > +++ b/kernel/trace/trace_events_user.c
> > > > > @@ -1480,6 +1480,9 @@ static int user_seq_show(struct seq_file *m, void *p)
> > > > >  	struct user_event *user;
> > > > >  	char status;
> > > > >  	int i, active = 0, busy = 0, flags;
> > > > > +	bool show_names;
> > > > > +
> > > > > +	show_names = capable(CAP_SYS_ADMIN);
> > > > >  
> > > > >  	mutex_lock(&reg_mutex);
> > > > >  
> > > > > @@ -1487,7 +1490,10 @@ static int user_seq_show(struct seq_file *m, void *p)
> > > > >  		status = register_page_data[user->index];
> > > > >  		flags = user->flags;
> > > > >  
> > > > > -		seq_printf(m, "%d:%s", user->index, EVENT_NAME(user));
> > > > > +		if (show_names)
> > > > > +			seq_printf(m, "%d:%s", user->index, EVENT_NAME(user));
> > > > > +		else
> > > > > +			seq_printf(m, "%d:<hidden>", user->index);
> > > > >  
> > > > >  		if (flags != 0 || status != 0)
> > > > >  			seq_puts(m, " #");
> > > > > 
> > > > > base-commit: 864ea0e10cc90416a01b46f0d47a6f26dc020820
> > > > > -- 
> > > > > 2.17.1  
> > > > 
> > > > I wanted to get some comments on this.
> > 
> > I think this is a bit add-hoc. We may need more generic way to hide the
> > event name from someone (who?) Is it enough to hide only event name?
> > 
> 
> As a bare min level we don't want to expose out more information than
> required when low priv users are writing out events to user_events. This
> allows processes to do stuff like try to squat on the event (IE: Watch
> until it can be deleted, re-register with large values that makes it no
> longer work for others, etc.).

Hmm, this sounds like more than container. You may want per-application
namespace for the user events. Is that correct?

> > > > I think for scenarios where
> > > > user_events is used in a heavy cgroup environment, that we need to have
> > > > some tracing cgroup awareness.
> > 
> > Would you mean to hide the event name from other cgroups or you need a
> > filter depends on cgroup/namespace?
> > 
> 
> That's the conversation bit, how perf_events did this is have a
> perf_events cgroup and all buffers auto filter. That's fine for
> reading/collecting, we need this for registering/writing. I'll add
> scenarios at the bottom here.

OK. I need to check the perf_event cgroup but does that involve
dynamic event generation? Filtering static fixed events generated
inside a process group can fit to cgroups, but hiding the new dynamic
events from others sounds like namespace.


> > As far as I know, current ftrace interface doesn't care about namespace
> > nor cgroups. It expects to be used outside of cgroups/namespace because
> > most of the events are for tracing kernel.(except for uprobe events until
> > user-events is introduced)
> > 
> > I think the easiest option is to introduce a new event filter rule based
> > on the container (cgroup path or namespace inode). With such filter
> > you can trace one container application from *outside* of the container.
> > 
> > For tracing from inside a container, I think you may need a mount option
> > to expose only 'container-local' events and buffer.
> > If you want only limits the buffer, it will be something like this;
> > 
> > container$ mount -o instance=foo tracefs /sys/kernel/trace
> > 
> > (Note that this may expose the *kernel* events to the containers.
> >  we should hide those by default)
> > 
> > But limits (and hide) the user-defined events, we have to consider about
> > namespace confliction. Maybe we can assign a random group name for user
> > events when mounting the tracefs.
> > 
> 
> Ideally we don't want the event name to change, this causes a lot of
> issues for tools that want to listen to these events. Now these tools
> must be cgroup aware of the random group names, etc. When new cgroups
> are created these tools must now watch for new groups names to show up.
> That model would have cascading complexities.

Yeah, I think we don't need to change the event name itself, but I think
we can use different group name for each group.
(Here, I talked about the 'event' and 'group' in the ftrace etc.)

> 
> > > > Has this come up before? I would like to only show user_events that have
> > > > been created in the current cgroup (and below) like perf_events do for
> > > > capturing.
> > > 
> > > I added Kees because he had issues with capabilities in the past wrt
> > > tracing. Talking with him was one of the reasons I decided to push the
> > > file permissions for who has what access.
> > > 
> > > > 
> > > > I would also like to get to a point where we can limit how many events
> > > > each cgroup can register under user_events.
> > 
> > I think that requires to extend cgroups itself, something like trace-cgroup,
> > because it is a bit odd to limit resouces by ftrace itself based on cgroups.
> > (cgroup is the resouce control group)
> > 
> 
> Yes, I agree, it seems like a tracing cgroup is required that allows for
> some control over these types of things.
> 
> > > > 
> > > > To me, this sounds like a large feature that requires some alignment for
> > > > getting tracing cgroup aware.
> > > 
> > > At the moment I do not have a use case in mind to evaluate the
> > > situation. But understanding more about how this will be used by a
> > > broader audience would be useful.
> > 
> > Yeah, this is a good & interesting discussion topic :-)
> > 
> 
> Often we have environments that host many different cgroups for
> isolation purposes (e.g. Kubernetes).

So Kubernetes doesn't change mount namespace? If it change the mount
namespace, we can mount the tracefs with different identifiers.

> A simple example to model around is a process in the root namespace
> (pid, mnt, etc) creates a new namespace/cgroup for isolation. A new
> process is then started in the new namespace/cgroup. The process in the
> root namespace will be monitoring events across the root cgroup and
> the isolated cgroup via perf_event/eBPF/ftrace. We want to know if
> something is having issues in that isolated namespace from the root.
> 
> This new process can now only see itself (and what it spawns) via /proc,
> since it has a new pid and mnt namespace.

Yeah, so I think the user-events should have a namespace too.
But since we have only 1-level event group, we need a random or
expected group name prefix. e.g. events/user.<INODE>/<EVENT>.

> Imagine we expose tracefs to this new cgroup, with only execute on
> /sys/kernel/tracing and read/write on /sys/kernel/user_events_*. The
> process can now trace, but it can also open /sys/kernel/user_events_status
> and see all the event names on the system that have come from user_events.
> This includes user_events that were registered in the root namespace.

What would you think about seeing the events defined in the root namespace?
I think the user events which is defined in the root namespace should
not be seen in the child namespace because it can leak the root-namespace
information into the child namespace.

> 
> The new cgroup can now delete and re-register these events since they
> now know their names (if they can find a time when other processes
> don't have the events open). This part of the problem is the easier one
> to address (we just don't show the names to low priv processes). Yes,
> they could always guess it correctly, but that's much harder.

If you change the group name, the low priv processes can not even guess
the event name, because it doesn't make any collision :-)

> 
> The more challenging problem is if the process in the new cgroup wants
> to be mean and register as many user_events as it can (all
> 4096/page_size worth). We now have a system where no more user_events
> can be registered because a single process either had a bug or decided
> to be mean.

If we can have status page per-group, and the process in the container
will only see the events in one group, it may help.

> 
> Now scale the above scenario up where we have 10 different isolation
> cgroup/namespaces in addition to the root cgroup/namespace. Things can
> get a bit wild in terms of ensuring a proper balance of user_events to
> go around for all these places.
> 
> I have two different directions in my mind about the above scenario:
> 1. Have different status pages per-cgroup (IE: user_events/tracing cgroup
> type) which naturally will limit each cgroup to at most a page_size of
> events. The isolated cgroups cannot see any events that didn't originate
> within themselves via the user_events_status file. Name conflicts might
> happen, but they can also happen within the same cgroup, so I'm not as
> concerned about that.

Yeah, this is in my mind too, but if we split the event by group, name
conflicts doesn't happen.

> 
> 2. Have some sort of hierarchy across trace_events that is per-cgroup
> (IE: tracing cgroup type). This seems to have very broad implications
> and could have side effects in various tools. However, this would open
> up the potential to address naming conflicts (IE: Event named foo in
> cgroup A has a different format file than Event named foo in cgroup B).

So as I said, there is a "group name" for each event, and we can choose
the different group name for the events in different cgroups. Is this
close to what you called the hierarchy here? :-)


Thank you,

> 
> My personal preference would be to do something like #1 and see how well
> it may translate to something like #2 in the future after ironing out
> the wrinkles that user_events hits.
> 
> > Thank you,
> > 
> > 
> > > 
> > > -- Steve
> > 
> > 
> > -- 
> > Masami Hiramatsu <mhiramat@kernel.org>
> 
> Thanks,
> -Beau


-- 
Masami Hiramatsu <mhiramat@kernel.org>
