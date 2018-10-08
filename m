Return-Path: <SRS0=f4gm=MU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:42292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbeJIDGV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Oct 2018 23:06:21 -0400
Date: Mon, 8 Oct 2018 15:52:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: tzvmware@gmail.com
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov" <tstoyanov@vmware.com>
Subject: Re: [PATCH v3] tools/lib/traceevent, tools/perf: Move struct
 tep_handler definition in a local header file
Message-ID: <20181008155255.0ea2ef49@gandalf.local.home>
In-Reply-To: <20181008125500.8349-1-tzvmware@gmail.com>
References: <20181005171347.5e5f9341@gandalf.local.home>
        <20181008125500.8349-1-tzvmware@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon,  8 Oct 2018 15:55:00 +0300
tzvmware@gmail.com wrote:

> +++ b/tools/lib/traceevent/event-parse-api.c
> @@ -0,0 +1,275 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> + *
> + */
> +
> +#include "event-parse.h"
> +#include "event-parse-local.h"
> +#include "event-utils.h"
> +
> +/**
> + * tep_get_first_event - returns the first event in the events array
> + * @pevent: a handle to the tep_handle

I'm fixing up the @pevent to @tep here and below.

> + *
> + * This returns pointer to the first element of the events array
> + * If @pevent is NULL, NULL is returned.
> + */
> +struct tep_event_format *tep_get_first_event(struct tep_handle *tep)
> +{
> +	if (tep && tep->events)
> +		return tep->events[0];
> +
> +	return NULL;
> +}
> +
> +/**
> + * tep_get_events_count - get the number of defined events
> + * @pevent: a handle to the tep_handle
> + *
> + * This returns number of elements in event array
> + * If @pevent is NULL, 0 is returned.
> + */
> +int tep_get_events_count(struct tep_handle *tep)
> +{
> +	if (tep)
> +		return tep->nr_events;
> +	return 0;
> +}
> +
> +/**
> + * tep_set_flag - set event parser flag
> + * @pevent: a handle to the tep_handle
> + * @flag: flag, or combination of flags to be set
> + * can be any combination from enum tep_flag
> + *
> + * This sets a flag or mbination of flags  from enum tep_flag
> + */
> +void tep_set_flag(struct tep_handle *tep, int flag)
> +{
> +	if (tep)
> +		tep->flags |= flag;
> +}
> +
> +unsigned short __tep_data2host2(struct tep_handle *pevent, unsigned short data)
> +{
> +	unsigned short swap;
> +
> +	if (!pevent || pevent->host_bigendian == pevent->file_bigendian)
> +		return data;
> +
> +	swap = ((data & 0xffULL) << 8) |
> +		((data & (0xffULL << 8)) >> 8);
> +
> +	return swap;
> +}
> +



> -#define tep_data2host2(pevent, ptr)		__tep_data2host2(pevent, *(unsigned short *)(ptr))
> -#define tep_data2host4(pevent, ptr)		__tep_data2host4(pevent, *(unsigned int *)(ptr))
> -#define tep_data2host8(pevent, ptr)					\
> +#define tep_data2host2(pevent, ptr)	\
> +	__tep_data2host2(pevent, *(unsigned short *)(ptr))
> +#define tep_data2host4(pevent, ptr)	\
> +	__tep_data2host4(pevent, *(unsigned int *)(ptr))

One thing I hate about checkpatch.pl is it's authoritarian "over 80
chars".

Most of the time I ignore it. I think to myself, "does it look better
with or without that line break" and if I think the line break just
makes it worse to read, I ignore it.

I'm putting these back to single lines.

Note, this is the one reason I haven't pushed using checkpatch.pl,
because some of the suggestions are just wrong.

-- Steve
