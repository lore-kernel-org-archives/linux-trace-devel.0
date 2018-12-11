Return-Path: <SRS0=Vqi0=OU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:41912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbeLKRoe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Dec 2018 12:44:34 -0500
Date: Tue, 11 Dec 2018 12:44:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] tools lib traceevent, perf tools: Move struct
 tep_handler definition in a local header file
Message-ID: <20181211124430.4d60a6da@gandalf.local.home>
In-Reply-To: <20181010105105.826-1-tstoyanov@vmware.com>
References: <20181010105105.826-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 10 Oct 2018 10:51:17 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> @@ -0,0 +1,401 @@
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
> + * tep_get_event - returns the event with the given index
> + * @tep: a handle to the tep_handle
> + * @index: index of the requested event, in the range 0 .. nr_events
> + *
> + * This returns pointer to the element of the events array with the given index
> + * If @tep is NULL, or @index is not in the range 0 .. nr_events, NULL is returned.
> + */
> +struct tep_event_format *tep_get_event(struct tep_handle *tep, int index)
> +{
> +	if (tep && tep->events && index < tep->nr_events)
> +		return tep->events[index];
> +
> +	return NULL;
> +}
> +

I just noticed that this is different than what we submitted to
Linux tools directory.

I'll send an update to fix this because we need to keep trace-cmd and
Linux tools libtraceevent need to stay totally in sync.

-- Steve
