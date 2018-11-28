Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:42774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727726AbeK2B3N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 20:29:13 -0500
Date: Wed, 28 Nov 2018 09:27:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3] tools/lib/traceevent: make libtraceevent thread safe
Message-ID: <20181128092721.17368705@gandalf.local.home>
In-Reply-To: <20181128133119.13149-1-tstoyanov@vmware.com>
References: <20181128133119.13149-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


On Wed, 28 Nov 2018 13:31:31 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch is a PoC about transforming libtraceevent

Hi Tzvetomir,

You may want to talk with Yordan about how to send patches with a
subject like:

[POC][PATCH v3] tools/lib/traceevent: make libtraceevent thread safe

As the subject should state that this is a proof of concept patch.

> into a thread safe library. It implements per thread local
> storage and internal APIs to access it. It covers only
> tep->last_event cache, but easily can be extended with all
> library's thread sensitive data.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
> v2: Added local thread data per tep context
> v3: Implemented APIs to access specific tread local data,
>     instead of the whole struct tep_thread_data.
> ---
>  tools/lib/traceevent/event-parse-local.h  |  18 ++-
>  tools/lib/traceevent/event-parse-thread.c | 131 ++++++++++++++++++++++
>  tools/lib/traceevent/event-parse.c        |  21 ++--
>  3 files changed, 158 insertions(+), 12 deletions(-)
>  create mode 100644 tools/lib/traceevent/event-parse-thread.c
> 
> diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
> index 9a092dd4a86d..aa9418fdefd0 100644
> --- a/tools/lib/traceevent/event-parse-local.h
> +++ b/tools/lib/traceevent/event-parse-local.h
> @@ -14,6 +14,14 @@ struct func_list;
>  struct event_handler;
>  struct func_resolver;
>  
> +/* cache */
> +struct tep_thread_data {
> +	struct tep_handle *tep;
> +	struct tep_thread_data *next;
> +
> +	struct tep_event *last_event;
> +};
> +
>  struct tep_handle {
>  	int ref_count;
>  
> @@ -83,9 +91,6 @@ struct tep_handle {
>  	struct event_handler *handlers;
>  	struct tep_function_handler *func_handlers;
>  
> -	/* cache */
> -	struct tep_event *last_event;
> -
>  	char *trace_clock;
>  };
>  
> @@ -96,4 +101,11 @@ unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short data);
>  unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data);
>  unsigned long long tep_data2host8(struct tep_handle *pevent, unsigned long long data);
>  
> +/* tep cache per thread */
> +struct tep_event *tep_find_event_by_id_cache(struct tep_handle *tep, int id);
> +struct tep_event *
> +tep_find_event_by_name_cache(struct tep_handle *tep, const char *name, const char *sys);
> +void tep_set_serach_event_cache(struct tep_handle *tep, struct tep_event *event);
> +void tep_destroy_thread_local(struct tep_handle *tep);
> +
>  #endif /* _PARSE_EVENTS_INT_H */
> diff --git a/tools/lib/traceevent/event-parse-thread.c b/tools/lib/traceevent/event-parse-thread.c
> new file mode 100644
> index 000000000000..84707c24ac6b
> --- /dev/null
> +++ b/tools/lib/traceevent/event-parse-thread.c
> @@ -0,0 +1,131 @@
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
> +static __thread struct tep_thread_data *tep_thread_local;
> +
> +static struct tep_thread_data *tep_alloc_thread_local(struct tep_handle *tep)
> +{
> +	struct tep_thread_data *local;
> +
> +	local = calloc(1, sizeof(struct tep_thread_data));
> +	if (local) {
> +		local->tep = tep;
> +		local->next = tep_thread_local;

I really don't want a loop. We should have one thread cache. Heck, then
we don't even need to allocate it.

-- Steve


> +		tep_thread_local = local;
> +	}
> +	return local;
> +}
> +
