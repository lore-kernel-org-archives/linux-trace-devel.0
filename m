Return-Path: <SRS0=Vqi0=OU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:34588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbeLKR3T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Dec 2018 12:29:19 -0500
Date: Tue, 11 Dec 2018 12:29:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tools/lib/traceevent: make libtraceevent thread
 safe
Message-ID: <20181211122917.742b586e@gandalf.local.home>
In-Reply-To: <20181205092200.2291-2-tstoyanov@vmware.com>
References: <20181205092200.2291-1-tstoyanov@vmware.com>
        <20181205092200.2291-2-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 5 Dec 2018 09:22:12 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> @@ -3499,19 +3500,19 @@ struct tep_event *tep_find_event(struct tep_handle *pevent, int id)
>   * @sys. If @sys is NULL the first event with @name is returned.
>   */
>  struct tep_event *
> -tep_find_event_by_name(struct tep_handle *pevent,
> +tep_find_event_by_name(struct tep_handle *tep,
>  		       const char *sys, const char *name)
>  {
> -	struct tep_event *event;
>  	int i;
> +	struct tep_event *event = NULL;
> +	struct tep_event *event_cache = get_thread_local_event_by_name(tep, name, sys);

BTW, I modified this to keep with the "upside down christmas tree"
method. That is, instead of:

	int i;
	struct tep_event *event = NULL;
	struct tep_event *event_cache = get_thread_local_event_by_name(tep, name, sys);

I made it:

	struct tep_event *event_cache = get_thread_local_event_by_name(tep, name, sys);
	struct tep_event *event = NULL;
	int i;

to make it look better, and some kernel developers (as well as the perf
developers) require that for declarations.

-- Steve

>  
> -	if (pevent->last_event &&
> -	    strcmp(pevent->last_event->name, name) == 0 &&
> -	    (!sys || strcmp(pevent->last_event->system, sys) == 0))
> -		return pevent->last_event;
> +	/* Check cache first */
> +	if (event_cache)
> +		return event_cache;
>  
> -	for (i = 0; i < pevent->nr_events; i++) {
> -		event = pevent->events[i];
> +	for (i = 0; i < tep->nr_events; i++) {
> +		event = tep->events[i];
>  		if (strcmp(event->name, name) == 0) {
>  			if (!sys)
>  				break;
