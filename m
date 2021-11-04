Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA4FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 14:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C2BF611C3
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 14:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhKDO51 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 10:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229920AbhKDO51 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 10:57:27 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD492611C3;
        Thu,  4 Nov 2021 14:54:48 +0000 (UTC)
Date:   Thu, 4 Nov 2021 10:54:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 01/10] libtracefs: New APIs for dynamic events
Message-ID: <20211104105447.5ea6a0ea@gandalf.local.home>
In-Reply-To: <20211104111047.302660-2-tz.stoyanov@gmail.com>
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
        <20211104111047.302660-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  4 Nov 2021 13:10:38 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:


>  
> +/* Dynamic events */
> +struct tracefs_dynevent;
> +enum tracefs_dynevent_type {
> +	TRACEFS_DYNEVENT_KPROBE		= 1 << 0,
> +	TRACEFS_DYNEVENT_KRETPROBE	= 1 << 1,
> +	TRACEFS_DYNEVENT_UPROBE		= 1 << 2,
> +	TRACEFS_DYNEVENT_URETPROBE	= 1 << 3,
> +	TRACEFS_DYNEVENT_EPROBE		= 1 << 4,
> +	TRACEFS_DYNEVENT_SYNTH		= 1 << 5,
> +	TRACEFS_DYNEVENT_MAX		= 1 << 6,
> +};

[..]

> +
> +static struct dyn_events_desc *get_devent_desc(int index)

This should take the enum tracefs_dynevent_type.

> +{
> +	static bool init;
> +	static int max;

Why the max variable? It's always set to a constant defined at compile time.

> +
> +	if (index < 0)
> +		return NULL;

This should never happen as this is a static function, and is not needed if
we take the enum as the argument.

> +
> +	if (!init) {
> +		init_devent_desc();
> +		max = bit_index(TRACEFS_DYNEVENT_MAX);
> +		init = true;
> +	}
> +

Here we can have the bit_index:

	/* One bit has to be set */
	if (!index)
		return NULL;

And since we only expect one bit set, we can have:

	/* Only one bit must be set */
	if (index & (index - 1))
		return NULL;

Because the above is true iff index is not a power of two.

Since now we know that index has only a single bit set, we can compare to
max:

	/* Is it a valid value? */
	if (index >= TRACEFS_DYNEVENT_MAX)
		return NULL;

Then we use bit_index here:

	return &dynevents[bit_index(index)];

And remove having to use bit_index in the below callers.

> +	if (index < 0 || index >= max)
> +		return NULL;
> +
> +	return &dynevents[index];
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
> +	desc = get_devent_desc(bit_index(type));

	desc = get_devent_desc(type);

> +	if (!desc || !desc->file) {
> +		errno = ENOTSUP;
> +		return NULL;
> +	}
> +
> +	devent = calloc(1, sizeof(*devent));
> +	if (!devent)
> +		return NULL;
> +
> +	devent->type = type;
> +	devent->trace_file = strdup(desc->file);
> +	if (!devent->trace_file)
> +		goto err;
> +
> +	if (!system)
> +		system = DYNEVENTS_DEFAULT_GROUP;
> +	devent->system = strdup(system);
> +	if (!devent->system)
> +		goto err;
> +
> +	devent->event = strdup(event);
> +	if (!devent->event)
> +		goto err;
> +
> +	devent->prefix = strdup(desc->prefix);
> +	if (!devent->prefix)
> +		goto err;
> +
> +	if (address) {
> +		devent->address = strdup(address);
> +		if (!devent->address)
> +			goto err;
> +	}
> +	if (format) {
> +		devent->format = strdup(format);
> +		if (!devent->format)
> +			goto err;
> +	}
> +
> +	return devent;
> +err:
> +	tracefs_dynevent_free(devent);
> +	return NULL;
> +}
> +



> +/**
> + * tracefs_dynevent_destroy - Remove a dynamic event from the system
> + * @devent: A dynamic event context, describing the dynamic event that will be deleted.
> + * @force: Will attempt to disable all events before removing them.
> + *
> + * The dynamic event context is not freed by this API. It only removes the event from the system.
> + * If there are any enabled events, and @force is not set, then it will error with -1 and errno
> + * to be EBUSY.
> + *
> + * Return 0 on success, or -1 on error.
> + */
> +int tracefs_dynevent_destroy(struct tracefs_dynevent *devent, bool force)
> +{
> +	struct dyn_events_desc *desc;
> +	char **instance_list;
> +
> +	if (!devent)
> +		return -1;
> +
> +	if (force) {
> +		instance_list = tracefs_instances(NULL);
> +		disable_events(devent->system, devent->event, instance_list);
> +		tracefs_list_free(instance_list);
> +	}
> +
> +	desc = get_devent_desc(bit_index(devent->type));

	desc = get_devent_desc(devent->type);

> +	if (!desc)
> +		return -1;
> +
> +	return desc->del(desc, devent);
> +}
> +
> +static int get_all_dynevents(int index, const char *system,
> +			     struct tracefs_dynevent ***ret_all)

This too should be passed in the enum, because you changed the caller to
it below, where you are passing in the mask and not the index.

> +{
> +	struct dyn_events_desc *desc;
> +	struct tracefs_dynevent *devent, **tmp, **all = NULL;
> +	char *content;
> +	int count = 0;
> +	char *line;
> +	char *next;
> +	int ret;
> +
> +	desc = get_devent_desc(index);
> +	if (!desc)
> +		return -1;
> +
> +	content = tracefs_instance_file_read(NULL, desc->file, NULL);
> +	if (!content)
> +		return -1;
> +
> +	line = content;
> +	do {
> +		next = strchr(line, '\n');
> +		if (next)
> +			*next = '\0';
> +		ret = desc->parse(desc, system, line, ret_all ? &devent : NULL);
> +		if (!ret) {
> +			if (ret_all) {
> +				tmp = realloc(all, (count + 1) * sizeof(*tmp));
> +				if (!tmp)
> +					goto error;
> +				all = tmp;
> +				all[count] = devent;
> +			}
> +			count++;
> +		}
> +		line = next + 1;
> +	} while (next);
> +
> +	free(content);
> +	if (ret_all)
> +		*ret_all = all;
> +	return count;
> +
> +error:
> +	free(content);
> +	free(all);
> +	return -1;
> +}
> +

> +
> +/**
> + * tracefs_dynevent_get_all - return an array of pointers to dynamic events of given types
> + * @types: Dynamic event type, or bitmask of dynamic event types. If 0 is passed, all types
> + *	   are considered.
> + * @system: Get events from that system only. If @system is NULL, events from all systems
> + *	    are returned.
> + *
> + * Returns an array of pointers to dynamic events of given types that exist in the system.
> + * The array must be freed with tracefs_dynevent_list_free(). If there are no events a NULL
> + * pointer is returned.
> + */
> +struct tracefs_dynevent **
> +tracefs_dynevent_get_all(enum tracefs_dynevent_type types, const char *system)
> +{
> +	struct tracefs_dynevent **events, **tmp, **all_events = NULL;
> +	int count, all = 0;
> +	int i;
> +
> +	for (i = 1; i < TRACEFS_DYNEVENT_MAX; i <<= 1) {
> +		if (types) {
> +			if (i > types)
> +				break;
> +			if (!(types & i))
> +				continue;
> +		}
> +		count = get_all_dynevents(i - 1, system, &events);

I'm confused at what you are trying to do above. As i is the bitmask, and
you are calling get_all_dynevents for all types below it, and doing it for
each mask? I think you want to just pass in i, as  that's the bitmask you
want.


> +		if (count > 0) {
> +			tmp = realloc(all_events, (all + count + 1) * sizeof(*tmp));
> +			if (!tmp)
> +				goto error;
> +			all_events = tmp;
> +			memcpy(all_events + all, events, count * sizeof(*events));
> +			all += count;
> +			/* Add a NULL pointer at the end */
> +			all_events[all] = NULL;
> +		}
> +	}
> +
> +	return all_events;
> +
> +error:
> +	if (all_events) {
> +		for (i = 0; i < all; i++)
> +			free(all_events[i]);
> +		free(all_events);
> +	}
> +	return NULL;
> +}
> +
> +/**
> + * tracefs_dynevent_destroy_all - removes all dynamic events of given types from the system
> + * @types: Dynamic event type, or bitmask of dynamic event types. If 0 is passed, all types
> + *	   are considered.
> + * @force: Will attempt to disable all events before removing them.
> + *
> + * Will remove all dynamic events of the given types from the system. If there are any enabled
> + * events, and @force is not set, then the removal of these will fail. If @force is set, then
> + * it will attempt to disable all the events in all instances before removing them.
> + *
> + * Returns zero if all requested events are removed successfully, or -1 if some of them are not
> + * removed.
> + */
> +int tracefs_dynevent_destroy_all(enum tracefs_dynevent_type types, bool force)

This too needs to be an int, and not the enum, because more than one type
is no longer a valid enum tracefs_dynevent_type.


> +{
> +	struct tracefs_dynevent **all;
> +	int ret = 0;
> +	int i;
> +
> +	all = tracefs_dynevent_get_all(types, NULL);
> +	if (!all)
> +		return 0;
> +
> +	for (i = 0; all[i]; i++) {
> +		if (tracefs_dynevent_destroy(all[i], force))
> +			ret = -1;
> +	}
> +
> +	tracefs_dynevent_list_free(all);
> +
> +	return ret;
> +}
> +
> +/**
> + * dynevent_get_count - Count dynamic events of given types and system
> + * @types: Dynamic event type, or bitmask of dynamic event types. If 0 is passed, all types
> + *	   are considered.
> + * @system: Count events from that system only. If @system is NULL, events from all systems
> + *	    are counted.
> + *
> + * Return the count of requested dynamic events
> + */
> +__hidden int dynevent_get_count(enum tracefs_dynevent_type types, const char *system)
> +{
> +	int count, all = 0;
> +	int i;
> +
> +	for (i = 1; i < TRACEFS_DYNEVENT_MAX; i <<= 1) {
> +		if (types) {
> +			if (i > types)
> +				break;
> +			if (!(types & i))
> +				continue;
> +		}
> +		count = get_all_dynevents(i - 1, system, NULL);

Same here.

-- Steve

> +		if (count > 0)
> +			all += count;
> +	}
> +
> +	return all;
> +}

