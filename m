Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE78C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 19:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbiBUTQz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 14:16:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbiBUTQx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 14:16:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0343121E14
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 11:16:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6618560BAD
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 19:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A82C340E9;
        Mon, 21 Feb 2022 19:16:27 +0000 (UTC)
Date:   Mon, 21 Feb 2022 14:16:25 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] libtracefs: Add user_events to libtracefs
 sources
Message-ID: <20220221141625.60a7db50@rorschach.local.home>
In-Reply-To: <20220221175720.GA1738@kbox>
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
        <20220218225058.12701-2-beaub@linux.microsoft.com>
        <dba49d0e-cac5-5945-e02e-b45a6d751032@gmail.com>
        <20220221175720.GA1738@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 21 Feb 2022 09:57:20 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> > We've been trying to follow certain naming convention for the APIs and to
> > provide similar usage patterns for all types of trace events that are
> > supported by the library so far (dynamic, synthetic and histograms). If
> > 'XXX' is the type of the event ('user_event' in your case), the pattern
> > looks like this:
> > 
> > tracefs_XXX_alloc() - this constructor just allocates memory and initializes
> > the descriptor object without modifying anything on the system. We allow for
> > multiple constructor function, in the case when your objects has to many
> > possible configurations and it is hard to do everything in a single API.
> > Looking into your implementation, such constructor can do half of the work
> > done in 'tracefs_user_event_group_create()'
> > 
> > int tracefs_XXX_create(struct tracefs_XXX *evt) - This is the API that
> > actually adds your event on the system. Note that it takes just one argument
> > that is the object itself. Again, looking into your implementation, this
> > will combine the other half of tracefs_user_event_group_create() and
> > tracefs_user_event_register().  
> 
> Are you and Steven aligned on this convention?

I would say you are both correct ;-)

The problem is, this doesn't really match the other events. The other
events are created in the kernel, and become a normal event. The big
difference here is that the event is tested in user space. It will be
hard to make it match the same criteria as kprobes, dynamic events, and
eprobes.

> 
> The request looked slightly different:
> See https://lore.kernel.org/linux-trace-devel/20220121192833.GA3128@kbox/T/#m2bcf53c373fbeaba2c46d1a053b3174171167e4e
> 
> > 
> > int tracefs_XXX_destroy(struct tracefs_XXX *evt) This API removes your event
> > from the system. The first argument is again the object. If needed, here you
> > can use a second argument that is 'bool force'.
> > 
> > int tracefs_XXX_free(struct tracefs_XXX *evt) - just to free the memory
> > 
> >   
> > > +struct tracefs_user_event_group *tracefs_user_event_group_create(void);
> > > +
> > > +void tracefs_user_event_group_close(struct tracefs_user_event_group *group);
> > > +
> > > +int tracefs_user_event_delete(const char *name);
> > > +
> > > +struct tracefs_user_event *
> > > +tracefs_user_event_register(struct tracefs_user_event_group *group,
> > > +			    const char *name, enum tracefs_uevent_flags flags,
> > > +			    struct tracefs_uevent_item *items);
> > > +
> > > +bool tracefs_user_event_test(struct tracefs_user_event *event);  
> > 
> > And maybe "test" is redundant. You can do the check in tracefs_XXX_create() and return an error if it fails.
> >   
> 
> Test is required so user programs can tell when write should be called.
> Otherwise excessive calculations and stack data are pushed for no good
> reason.

This is the part I'm talking about.  The "user_event" here is actually
executed in the application, and this API is to handle it. This is
where the user events diverge from the other events.

The user events create the event like any other dynamic event (we could
look at keeping that part similar with the other APIs). But then
everything is different.

When the event is created, the application is given a location on a
special mmapped page that represents if the event is enabled or not.
Then the application is to read it *at the event site* to know if it
should record the event into the ring buffer or not.

That's what the test is. It's equivalent to the "static_branch" that
tracepoints use in the kernel, except this isn't a static branch
(although we could possibly do something like that in the future!).

The application will:

	if (tracefs_user_event_test(event)) {
		tracefs_user_event_write(event, ...);
	}

Where if the event is enabled (by an external program), then it is to
record the events. This is the API that does that.

And test is not redundant at all.

> 
> > > +
> > > +int tracefs_user_event_write(struct tracefs_user_event *event,
> > > +			     struct tracefs_uevent_item *items);  
> > 
> > The "write" is OK.
> > 
> > Maybe we can change 'tracefs_user_event' to 'tracefs_usrevent' since we already use 'tracefs_dynevent' for dynamic events.
> > 
> > What do you think?

Not really. This is closer to tracefs_printf(). But thinking about this
more, perhaps "write" is a bit confusing as we use it to write to
tracefs files.

What about:  tracefs_user_event_record() ?

As this is exactly what it is doing. It's recording the event.


> >   
> 
> I'm happy to do whatever, I just want to ensure you and Steven are
> aligned.

Thanks!

-- Steve
