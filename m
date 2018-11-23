Return-Path: <SRS0=YO3e=OC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:45958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387726AbeKXDIE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Nov 2018 22:08:04 -0500
Date: Fri, 23 Nov 2018 11:23:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] tools/lib/traceevent: make libtraceevent thread safe
Message-ID: <20181123112309.73c38048@vmware.local.home>
In-Reply-To: <20181123134130.16566-1-tstoyanov@vmware.com>
References: <20181123134130.16566-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


I'm not officially working, but as my wife is not currently home, I
decided to sneak a peek at this patch ;-)

On Fri, 23 Nov 2018 13:41:40 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> This patch is a PoC about transforming libtraceevent
> into a thread safe library. It implements per thread local
> storage and internal APIs to access it. It covers only
> tep->last_event cache, but easily can be extended with all
> library's thread sensitive data.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tools/lib/traceevent/event-parse-local.h  | 17 ++++++++++---
>  tools/lib/traceevent/event-parse-thread.c | 29 +++++++++++++++++++++++
>  tools/lib/traceevent/event-parse.c        | 23 ++++++++++--------
>  3 files changed, 56 insertions(+), 13 deletions(-)
>  create mode 100644 tools/lib/traceevent/event-parse-thread.c
> 
> diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
> index 9a092dd4a86d..11f71ef8850b 100644
> --- a/tools/lib/traceevent/event-parse-local.h
> +++ b/tools/lib/traceevent/event-parse-local.h
> @@ -14,6 +14,17 @@ struct func_list;
>  struct event_handler;
>  struct func_resolver;
>  
> +/* cache */
> +struct tep_thread_data {
> +	struct tep_event *last_event;

We need to add a pointer to the tep handle itself. We don't want to use
the last event if it belonged to a different tep handle. Yes a thread
may have access to more than one tep handle at a time. Especially when
we start to do virt-server work.

> +};
> +
> +struct tep_thread_data_list {
> +	pid_t tid;
> +	struct tep_thread_data thr_data;
> +	struct tep_thread_data_pool *next;
> +};
> +

I'm thinking that we should not add the "tep_" prefix for anything
that's not exposed outside the library. This can help us know what's
local and what's not. I know there's some things currently like that,
but perhaps we should change them too.

>  struct tep_handle {
>  	int ref_count;
>  
> @@ -83,9 +94,6 @@ struct tep_handle {
>  	struct event_handler *handlers;
>  	struct tep_function_handler *func_handlers;
>  
> -	/* cache */
> -	struct tep_event *last_event;
> -
>  	char *trace_clock;
>  };
>  
> @@ -96,4 +104,7 @@ unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short data);
>  unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data);
>  unsigned long long tep_data2host8(struct tep_handle *pevent, unsigned long long data);
>  
> +struct tep_thread_data *tep_get_thread_local();
> +void tep_destroy_thread_local();
> +
>  #endif /* _PARSE_EVENTS_INT_H */
> diff --git a/tools/lib/traceevent/event-parse-thread.c b/tools/lib/traceevent/event-parse-thread.c
> new file mode 100644
> index 000000000000..775d953041ab
> --- /dev/null
> +++ b/tools/lib/traceevent/event-parse-thread.c
> @@ -0,0 +1,29 @@
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
> +struct tep_thread_data *tep_get_thread_local(struct tep_handle *tep __maybe_unused)
> +{
> +	if (tep_thread_local)
> +		return tep_thread_local;
> +
> +	tep_thread_local = calloc(1, sizeof(struct tep_thread_data));
> +	return tep_thread_local;
> +}
> +
> +
> +void tep_destroy_thread_local()
> +{
> +	free(tep_thread_local);
> +	tep_thread_local = NULL;
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
>  	/* Check cache first */
> -	if (pevent->last_event && pevent->last_event->id == id)
> -		return pevent->last_event;
> +
> +	if (local && local->last_event && local->last_event->id == id)

		&& local->tep == pevent &&

(but we should also rename pevent to tep, but that's another patch
series ;-)

> +		return local->last_event;
>  
>  	key.id = id;
>  
> @@ -3496,7 +3497,8 @@ struct tep_event *tep_find_event(struct tep_handle *pevent, int id)
>  			   sizeof(*pevent->events), events_id_cmp);
>  
>  	if (eventptr) {
> -		pevent->last_event = *eventptr;
> +		if (local)
 			{
> +			local->last_event = *eventptr;

			local->tep = pevent;
		}

>  		return *eventptr;
>  	}
>  
> @@ -3516,13 +3518,14 @@ struct tep_event *
>  tep_find_event_by_name(struct tep_handle *pevent,
>  		       const char *sys, const char *name)
>  {
> +	struct tep_thread_data *local = tep_get_thread_local(pevent);
>  	struct tep_event *event = NULL;
>  	int i;
>  
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

Same here.

-- Steve

>  	return event;
>  }
>  
