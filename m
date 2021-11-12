Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E4EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Nov 2021 05:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B47860F26
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Nov 2021 05:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhKLFHo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Nov 2021 00:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhKLFHn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Nov 2021 00:07:43 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8FAC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 21:04:53 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id b4so7041484pgh.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 21:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a2v4rC1yZHTMxsP5fH1pXhP165EeMdErIpgWOed7Azw=;
        b=m90jARnng7M98EwAAObPLWx2ohs9AF8ITU5sKShuOsdpbE9pCuojR7BImuBq4waBD4
         3yJWTKvWkZ1JwYoTENPr45awMv92+5lcMVUznZJKJIE+Y+UQelPtEZ8EpZpyK5XChhX4
         u/bL+FW8GTWJ4/rSZgMRwavVIQhqPIdGAKPkwUF4OFYdND4YrRP9VrIlQYNjx7NLN2ev
         oMCG0V91SWbD3Xw35TR3BtcurDIFFh/GoYh2/u4zZ9c4rqY/Z+6KnYYoZUUkcZsuBLxP
         O6yGqzK80NdL7pF8JQh2lJqjW9kX00YXMN2eE7kXwdLD748voLHGYOB3LcY8SgwpsBBk
         pPQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a2v4rC1yZHTMxsP5fH1pXhP165EeMdErIpgWOed7Azw=;
        b=2h5tBnqwDmydMhIxHHhbpphA+uPj/24ofa1//954gTGZKt7AxVKbrfh1rQJRZK/ct+
         xPy0+gqATNAmJLOp08es4YEAU62ZFN6uF1i42AA/fJ5l4Bo+UF0NhGNBNh4A2ERxNE7P
         UnjTZb0rh3KwmHe6IjnNM3lhTMZgGi1hM/PmC4sIOVzwExk+94rKS3uctn/cV13tGIqc
         Vv1wWfGTE2h1Xcg3tIifMm7zne71v3aUJ3JohxpISKfLvzo6AVZQ+ovTuBI4prgM0Aqk
         0cK3rlEDISI0Ozy+DCkUh5LXrDLp9p1XikRooyA1Ym94qKF9iA9kxpR/gu07Z7CZdagS
         y6OQ==
X-Gm-Message-State: AOAM5328GiGTsVJyBiH+W/y49FxQ1uDjM8w19UhyRbbkQkOrq6VjjBXR
        tzjgGv3kJjS+IV6CwCyXMewgXelFPfRKgfHFjO03jZzgq/oRrg==
X-Google-Smtp-Source: ABdhPJzwAA41EyVeNDZ4GyLNItHaEGBG0bLwVBj3r5Q0/KiKS6cLC+gRKIZyhpcUiPHjqeO7oh1V9LsMdYLiTW6xOyY=
X-Received: by 2002:a63:d74a:: with SMTP id w10mr8406625pgi.341.1636693493203;
 Thu, 11 Nov 2021 21:04:53 -0800 (PST)
MIME-Version: 1.0
References: <20211108080404.55814-1-tz.stoyanov@gmail.com> <20211108080404.55814-2-tz.stoyanov@gmail.com>
 <20211111173332.1aab03c5@gandalf.local.home>
In-Reply-To: <20211111173332.1aab03c5@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 12 Nov 2021 07:04:36 +0200
Message-ID: <CAPpZLN5qS=Og8gJJi8xuL-VTUNT3kUC-m8JjVn_DQmQo+MdC=Q@mail.gmail.com>
Subject: Re: [PATCH v6 01/12] libtracefs: New APIs for dynamic events
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On Fri, Nov 12, 2021 at 12:33 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> After applying these patches, I tested sqlhist and it's broken.
>
> What I do is:
>
> (as root)
>  # mkdir /tmp/tracing
>  # cp -a /sys/kernel/tracing/events /tmp/tracing
>
> (as my user)
>  $ ./sqlhist -t /tmp/tracing/ -n waking 'select start.pid,
>     (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as delta from sched_waking as start join sched_switch as end on start.pid = end.next_pid'
>
> Which prints nothing, but before applying the patches, I would have this:
>
> echo 'waking s32 pid; u64 delta;' > /sys/kernel/tracing/synthetic_events
> echo 'hist:keys=pid:__arg_15772_1=pid,__arg_15772_2=common_timestamp.usecs' > /sys/kernel/tracing/events/sched/sched_waking/trigger
> echo 'hist:keys=next_pid:pid=$__arg_15772_1,delta=common_timestamp.usecs-$__arg_15772_2:onmatch(sched.sched_waking).trace(waking,$pid,$delta)' > /sys/kernel/tracing/events/sched/sched_switch/trigger
>
> Debugging it, I found that it's due to this change.
>

I totally missed the custom trace dir use case. The dynevents APIs
should be extended with additional parameter, to handle that use case.
I see two ways to do this:
 1. Passing a tracefs_instance* parameter to those APIs. This can be
NULL for top instance in default tracing directory, or allocated with:
    tracefs_instance_alloc("/tmp/tracing/", NULL) - for the instance
in a custom tracing directory.
   This approach adds flexibility to work with any non default
instance. It also resolves that question with the instance needed by
the histograms configuration.
 2. Passing a string parameter with custom trace directory path, or
NULL for default system trace directory.

Those APIs should be extended with that additional parameter:
   tracefs_dynevent_get_all()
   tracefs_dynevent_destroy_all()
   tracefs_kprobe_alloc()
   tracefs_kretprobe_alloc()
   tracefs_kprobe_raw()
   tracefs_kretprobe_raw()
   tracefs_synth_alloc()
   tracefs_sql()

>
> On Mon,  8 Nov 2021 10:03:53 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > +static void init_devent_desc(void)
> > +{
> > +     int i;
> > +
> > +     BUILD_BUG_ON(ARRAY_SIZE(dynevents) != EVENT_INDEX(TRACEFS_DYNEVENT_MAX));
> > +
> > +     /* Use  ftrace dynamic_events, if available */
> > +     if (tracefs_file_exists(NULL, DYNEVENTS_EVENTS)) {
>
> // fails due to permission denied.
>
> > +             for (i = 0; i < EVENT_INDEX(TRACEFS_DYNEVENT_MAX); i++)
> > +                     dynevents[i].file = DYNEVENTS_EVENTS;
> > +             return;
> > +     }
> > +
> > +     if (tracefs_file_exists(NULL, KPROBE_EVENTS)) {
>
> // fails due to permission denied.
>
> > +             dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_KPROBE)].file = KPROBE_EVENTS;
> > +             dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_KRETPROBE)].file = KPROBE_EVENTS;
> > +     }
> > +     if (tracefs_file_exists(NULL, UPROBE_EVENTS)) {
>
> // fails due to permission denied.
>
> > +             dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_UPROBE)].file = UPROBE_EVENTS;
> > +             dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_URETPROBE)].file = UPROBE_EVENTS;
> > +     }
> > +     if (tracefs_file_exists(NULL, SYNTH_EVENTS)) {
>
> // fails due to permission denied.
>
> > +             dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_SYNTH)].file = SYNTH_EVENTS;
> > +             dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_SYNTH)].prefix = "";
> > +     }
> > +}
> > +
> > +static struct dyn_events_desc *get_devent_desc(enum tracefs_dynevent_type type)
> > +{
> > +
> > +     static bool init;
> > +
> > +     if (type >= TRACEFS_DYNEVENT_MAX)
> > +             return NULL;
> > +
> > +     if (!init) {
> > +             init_devent_desc();
> > +             init = true;
> > +     }
> > +
> > +     return &dynevents[EVENT_INDEX(type)];
> > +}
> > +
> > +/**
> > + * dynevent_alloc - Allocate new dynamic event
> > + * @type: Type of the dynamic event
> > + * @system: The system name (NULL for the default dynamic)
> > + * @event: Name of the event
> > + * @addr: The function and offset (or address) to insert the probe
> > + * @format: The format string to define the probe.
> > + *
> > + * Allocate a dynamic event context that will be in the @system group
> > + * (or dynamic if @system is NULL). Have the name of @event and
> > + * will be associated to @addr, if applicable for that event type
> > + * (function name, with or without offset, or a address). And the @format will
> > + * define the format of the kprobe.
> > + * The dynamic event is not created in the system.
> > + *
> > + * Return a pointer to a dynamic event context on success, or NULL on error.
> > + * The returned pointer must be freed with tracefs_dynevent_free()
> > + *
> > + * errno will be set to EINVAL if event is NULL.
> > + */
> > +__hidden struct tracefs_dynevent *
> > +dynevent_alloc(enum tracefs_dynevent_type type, const char *system,
> > +            const char *event, const char *address, const char *format)
> > +{
> > +     struct tracefs_dynevent *devent;
> > +     struct dyn_events_desc *desc;
> > +
> > +     if (!event) {
> > +             errno = EINVAL;
> > +             return NULL;
> > +     }
> > +
> > +     desc = get_devent_desc(type);
>
> desc->file is NULL.
>
> > +     if (!desc || !desc->file) {
> > +             errno = ENOTSUP;
>
> Returns an error, when it use to work.
>
> > +             return NULL;
> > +     }
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
