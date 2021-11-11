Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 507D9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 22:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A5496124C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 22:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhKKWgZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 17:36:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:32892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhKKWgY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 17:36:24 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 994A5610F8;
        Thu, 11 Nov 2021 22:33:34 +0000 (UTC)
Date:   Thu, 11 Nov 2021 17:33:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 01/12] libtracefs: New APIs for dynamic events
Message-ID: <20211111173332.1aab03c5@gandalf.local.home>
In-Reply-To: <20211108080404.55814-2-tz.stoyanov@gmail.com>
References: <20211108080404.55814-1-tz.stoyanov@gmail.com>
        <20211108080404.55814-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

After applying these patches, I tested sqlhist and it's broken.

What I do is:

(as root)
 # mkdir /tmp/tracing
 # cp -a /sys/kernel/tracing/events /tmp/tracing

(as my user)
 $ ./sqlhist -t /tmp/tracing/ -n waking 'select start.pid,
    (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as delta from sched_waking as start join sched_switch as end on start.pid = end.next_pid'

Which prints nothing, but before applying the patches, I would have this:

echo 'waking s32 pid; u64 delta;' > /sys/kernel/tracing/synthetic_events
echo 'hist:keys=pid:__arg_15772_1=pid,__arg_15772_2=common_timestamp.usecs' > /sys/kernel/tracing/events/sched/sched_waking/trigger
echo 'hist:keys=next_pid:pid=$__arg_15772_1,delta=common_timestamp.usecs-$__arg_15772_2:onmatch(sched.sched_waking).trace(waking,$pid,$delta)' > /sys/kernel/tracing/events/sched/sched_switch/trigger

Debugging it, I found that it's due to this change.


On Mon,  8 Nov 2021 10:03:53 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +static void init_devent_desc(void)
> +{
> +	int i;
> +
> +	BUILD_BUG_ON(ARRAY_SIZE(dynevents) != EVENT_INDEX(TRACEFS_DYNEVENT_MAX));
> +
> +	/* Use  ftrace dynamic_events, if available */
> +	if (tracefs_file_exists(NULL, DYNEVENTS_EVENTS)) {

// fails due to permission denied.

> +		for (i = 0; i < EVENT_INDEX(TRACEFS_DYNEVENT_MAX); i++)
> +			dynevents[i].file = DYNEVENTS_EVENTS;
> +		return;
> +	}
> +
> +	if (tracefs_file_exists(NULL, KPROBE_EVENTS)) {

// fails due to permission denied.

> +		dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_KPROBE)].file = KPROBE_EVENTS;
> +		dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_KRETPROBE)].file = KPROBE_EVENTS;
> +	}
> +	if (tracefs_file_exists(NULL, UPROBE_EVENTS)) {

// fails due to permission denied.

> +		dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_UPROBE)].file = UPROBE_EVENTS;
> +		dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_URETPROBE)].file = UPROBE_EVENTS;
> +	}
> +	if (tracefs_file_exists(NULL, SYNTH_EVENTS)) {

// fails due to permission denied.

> +		dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_SYNTH)].file = SYNTH_EVENTS;
> +		dynevents[EVENT_INDEX(TRACEFS_DYNEVENT_SYNTH)].prefix = "";
> +	}
> +}
> +
> +static struct dyn_events_desc *get_devent_desc(enum tracefs_dynevent_type type)
> +{
> +
> +	static bool init;
> +
> +	if (type >= TRACEFS_DYNEVENT_MAX)
> +		return NULL;
> +
> +	if (!init) {
> +		init_devent_desc();
> +		init = true;
> +	}
> +
> +	return &dynevents[EVENT_INDEX(type)];
> +}
> +
> +/**
> + * dynevent_alloc - Allocate new dynamic event
> + * @type: Type of the dynamic event
> + * @system: The system name (NULL for the default dynamic)
> + * @event: Name of the event
> + * @addr: The function and offset (or address) to insert the probe
> + * @format: The format string to define the probe.
> + *
> + * Allocate a dynamic event context that will be in the @system group
> + * (or dynamic if @system is NULL). Have the name of @event and
> + * will be associated to @addr, if applicable for that event type
> + * (function name, with or without offset, or a address). And the @format will
> + * define the format of the kprobe.
> + * The dynamic event is not created in the system.
> + *
> + * Return a pointer to a dynamic event context on success, or NULL on error.
> + * The returned pointer must be freed with tracefs_dynevent_free()
> + *
> + * errno will be set to EINVAL if event is NULL.
> + */
> +__hidden struct tracefs_dynevent *
> +dynevent_alloc(enum tracefs_dynevent_type type, const char *system,
> +	       const char *event, const char *address, const char *format)
> +{
> +	struct tracefs_dynevent *devent;
> +	struct dyn_events_desc *desc;
> +
> +	if (!event) {
> +		errno = EINVAL;
> +		return NULL;
> +	}
> +
> +	desc = get_devent_desc(type);

desc->file is NULL.

> +	if (!desc || !desc->file) {
> +		errno = ENOTSUP;

Returns an error, when it use to work.

> +		return NULL;
> +	}

-- Steve
