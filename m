Return-Path: <SRS0=Jn1h=OF=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:39172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbeK0D6N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Nov 2018 22:58:13 -0500
Date: Mon, 26 Nov 2018 12:03:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2] tools/lib/traceevent: make libtraceevent thread safe
Message-ID: <20181126120328.509a3151@gandalf.local.home>
In-Reply-To: <20181126132245.19576-1-tstoyanov@vmware.com>
References: <20181126132245.19576-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 26 Nov 2018 13:22:59 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch is a PoC about transforming libtraceevent

FYI, when posting a proof of concept, you can add it to the subject:

 [POC][PATCH v2] tools/lib/traceevent: make libtraceevent thread safe

This lets people know that it's not something to be applied.

> into a thread safe library. It implements per thread local
> storage and internal APIs to access it. It covers only
> tep->last_event cache, but easily can be extended with all
> library's thread sensitive data.
> 
> [v2 - added local thread data per tep context]
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tools/lib/traceevent/event-parse-local.h  | 14 ++++--
>  tools/lib/traceevent/event-parse-thread.c | 57 +++++++++++++++++++++++
>  tools/lib/traceevent/event-parse.c        | 23 +++++----
>  3 files changed, 81 insertions(+), 13 deletions(-)
>  create mode 100644 tools/lib/traceevent/event-parse-thread.c
> 
> diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
> index 9a092dd4a86d..6fa0f05b29c3 100644
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
> @@ -96,4 +101,7 @@ unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short data);
>  unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data);
>  unsigned long long tep_data2host8(struct tep_handle *pevent, unsigned long long data);
>  
> +struct tep_thread_data *tep_get_thread_local(struct tep_handle *tep);
> +void tep_destroy_thread_local(struct tep_handle *tep);
> +
>  #endif /* _PARSE_EVENTS_INT_H */
> diff --git a/tools/lib/traceevent/event-parse-thread.c b/tools/lib/traceevent/event-parse-thread.c
> new file mode 100644
> index 000000000000..39350dc82c5d
> --- /dev/null
> +++ b/tools/lib/traceevent/event-parse-thread.c
> @@ -0,0 +1,57 @@
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
> +
> +struct tep_thread_data *tep_get_thread_local(struct tep_handle *tep)
> +{
> +	struct tep_thread_data *local = tep_thread_local;
> +
> +	while(local) {

I wouldn't do make it a list. I would either cache the last one, and if
the tep doesn't match, then return NULL (not a match).

> +		if (local->tep == tep)
> +			return local;
> +		local = local->next;
> +	}
> +
> +	local = calloc(1, sizeof(struct tep_thread_data));

Let's create a new function to create it:

tep_alloc_thread_local(tep, event);

> +	if(local) {
> +		local->tep = tep;
> +		local->next = tep_thread_local;
> +		tep_thread_local = local;
> +	}
> +	return local;
> +}
> +
> +
> +void tep_destroy_thread_local(struct tep_handle *tep)
> +{
> +	struct tep_thread_data **local, *del;
> +
> +	if(!tep_thread_local)
> +		return;
> +	local = &tep_thread_local;
> +
> +	while(*local) {
> +		if ((*local)->tep == tep) {
> +			tep_thread_local = (*local)->next;
> +			free(*local);
> +			return;
> +		}
> +		if ((*local)->next && (*local)->next->tep == tep) {
> +			del = (*local)->next;
> +			(*local)->next = (*local)->next->next;
> +			free(del);
> +			return;
> +		}
> +		local = &((*local)->next);
> +	}
> +}
> +
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index a5048c1b9bec..25f4ceab9a58 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -3485,10 +3485,11 @@ struct tep_event *tep_find_event(struct tep_handle *pevent, int id)
>  	struct tep_event **eventptr;
>  	struct tep_event key;
>  	struct tep_event *pkey = &key;
> -
> +	struct tep_thread_data *local = tep_get_thread_local(pevent);

Let's make this:

	local = tep_get_thread_local(pevent, id);

	if (local)
		return local->last_event;


>  	/* Check cache first */
> -	if (pevent->last_event && pevent->last_event->id == id)
> -		return pevent->last_event;
> +
> +	if (local && local->last_event && local->last_event->id == id)
> +		return local->last_event;
>  
>  	key.id = id;
>  
> @@ -3496,7 +3497,8 @@ struct tep_event *tep_find_event(struct tep_handle *pevent, int id)
>  			   sizeof(*pevent->events), events_id_cmp);
>  
>  	if (eventptr) {
> -		pevent->last_event = *eventptr;

		tep_alloc_thread_local(tep, *eventptr);

And have that function do the assignment if it got allocated.

> +		if (local)
> +			local->last_event = *eventptr;
>  		return *eventptr;
>  	}
>  
> @@ -3516,13 +3518,14 @@ struct tep_event *
>  tep_find_event_by_name(struct tep_handle *pevent,
>  		       const char *sys, const char *name)
>  {
> +	struct tep_thread_data *local = tep_get_thread_local(pevent);

Make it: local = tep_get_thread_local_name(pevent, name);

>  	struct tep_event *event = NULL;
>  	int i;
>  

	if (local)
		return local->last_event;

-- Steve

> -	if (pevent->last_event &&
> -	    strcmp(pevent->last_event->name, name) == 0 &&
> -	    (!sys || strcmp(pevent->last_event->system, sys) == 0))
> -		return pevent->last_event;
> +	if (local && local->last_event &&
> +	    strcmp(local->last_event->name, name) == 0 &&
> +	    (!sys || strcmp(local->last_event->system, sys) == 0))
> +		return local->last_event;
>  
>  	for (i = 0; i < pevent->nr_events; i++) {
>  		event = pevent->events[i];
> @@ -3535,8 +3538,8 @@ tep_find_event_by_name(struct tep_handle *pevent,
>  	}
>  	if (i == pevent->nr_events)
>  		event = NULL;
> -
> -	pevent->last_event = event;
> +	if (local)
> +		local->last_event = event;
>  	return event;
>  }
>  
