Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B80C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Dec 2021 21:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbhLAVIA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 16:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343846AbhLAVH7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 16:07:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88779C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed,  1 Dec 2021 13:04:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D465ECE2083
        for <linux-trace-devel@vger.kernel.org>; Wed,  1 Dec 2021 21:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7A8C53FCC;
        Wed,  1 Dec 2021 21:04:27 +0000 (UTC)
Date:   Wed, 1 Dec 2021 16:04:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/4] libtracefs: New API for getting dynamic event
Message-ID: <20211201160426.08d0c7d2@gandalf.local.home>
In-Reply-To: <20211130050057.336228-3-tz.stoyanov@gmail.com>
References: <20211130050057.336228-1-tz.stoyanov@gmail.com>
 <20211130050057.336228-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 30 Nov 2021 07:00:55 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> A new API is proposed, to get tep event describing given dynamic event:
[blank line]
> 	tracefs_dynevent_get_event()
[blank line]
> The API detects any newly created dynamic events, but does not detect
> the deletion.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  Documentation/libtracefs-dynevents.txt | 14 +++++++++++--
>  include/tracefs.h                      |  2 ++
>  src/tracefs-dynevents.c                | 29 ++++++++++++++++++++++++++
>  3 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/libtracefs-dynevents.txt b/Documentation/libtracefs-dynevents.txt
> index a374651..7de06be 100644
> --- a/Documentation/libtracefs-dynevents.txt
> +++ b/Documentation/libtracefs-dynevents.txt
> @@ -4,8 +4,8 @@ libtracefs(3)
>  NAME
>  ----
>  tracefs_dynevent_create, tracefs_dynevent_destroy, tracefs_dynevent_destroy_all,
> -tracefs_dynevent_free, tracefs_dynevent_list_free, tracefs_dynevent_get_all, tracefs_dynevent_info -
> -Create, destroy, free and get dynamic events.
> +tracefs_dynevent_free, tracefs_dynevent_list_free, tracefs_dynevent_get_all, tracefs_dynevent_info,
> +tracefs_dynevent_get_event - Create, destroy, free and get dynamic events.
>  
>  SYNOPSIS
>  --------
> @@ -23,6 +23,7 @@ void *tracefs_dynevent_list_free*(struct tracefs_dynevent pass:[*]pass:[*]_event
>  struct tracefs_dynevent pass:[*]*tracefs_dynevent_get*(enum tracefs_dynevent_type _type_, const char pass:[*]_system_, const char pass:[*]_event_);
>  struct tracefs_dynevent pass:[*]pass:[*]*tracefs_dynevent_get_all*(unsigned int _types_, const char pass:[*]_system_);
>  enum tracefs_dynevent_type *tracefs_dynevent_info*(struct tracefs_dynevent pass:[*]_dynevent_, char pass:[*]pass:[*]_system_, char pass:[*]pass:[*]_event_, char pass:[*]pass:[*]_prefix_, char pass:[*]pass:[*]_addr_, char pass:[*]pass:[*]_format_);
> +struct tep_event pass:[*]*tracefs_dynevent_get_event*(struct tep_handle pass:[*]_tep_, struct tracefs_dynevent pass:[*]_dynevent_);
>  --
>  
>  DESCRIPTION
> @@ -68,6 +69,11 @@ if relevant for this event type. If _format_ is non NULL, it will hold the forma
>  dynamic event. Note, that the content in _group_, _event_, _prefix_, _addr_, and _format_ must be
>  freed with free(3) if they are set.
>  
> +The *tracefs_dynevent_get_event*() function returns tep event, describing the given dynamic event.

					  "returns a tep event"

> +If the dynamic event is newly created and not yet loaded in the @tep, the dynamic event system is

            "loaded in @tep"

> +rescanned for any new events. The returned pointer to tep event is controlled by @tep and must not
> +be freed.


> +
>  RETURN VALUE
>  ------------
>  
> @@ -88,6 +94,10 @@ in case of an error or in case there are no events in the system. That array mus
>  on error. If _system_, _event_, _prefix_, _addr_, or _format_ are non NULL, they will contain
>  allocated strings that must be freed by free(3).
>  
> +The *tracefs_dynevent_get_event*() function returns pointer to tep event or NULL in case of an error

  "returns a pointer to a tep event'

> +or if the requested dynamic event is missing. The returned pointer to tep event is controlled by
> +@tep and must not be freed.
> +
>  ERRORS
>  ------
>  The following errors are for all the above calls:
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 9662603..fbd7d31 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -262,6 +262,8 @@ tracefs_dynevent_get(enum tracefs_dynevent_type type, const char *system, const
>  enum tracefs_dynevent_type
>  tracefs_dynevent_info(struct tracefs_dynevent *dynevent, char **system,
>  		      char **event, char **prefix, char **addr, char **format);
> +struct tep_event *
> +tracefs_dynevent_get_event(struct tep_handle *tep, struct tracefs_dynevent *dynevent);
>  
>  struct tracefs_dynevent *
>  tracefs_eprobe_alloc(const char *system, const char *event,
> diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
> index ea07d13..2ff3c87 100644
> --- a/src/tracefs-dynevents.c
> +++ b/src/tracefs-dynevents.c
> @@ -752,3 +752,32 @@ error:
>  
>  	return TRACEFS_DYNEVENT_UNKNOWN;
>  }
> +
> +/**
> + * tracefs_dynevent_get_event - return tep event, representing the given dynamic event

  remove the comma.

> + * @tep: a handle to the trace event parser context, that holds the events

  remove the comma.

> + * @dynevent: a dynamic event context, describing given dynamic event.

  remove the comma ;-)

> + *
> + * Returns pointer to tep event, describing the given dynamic event. The pointer

 "Returns a pointer to a tep event describing the given dynamic event".

> + * is managed by @tep handle and must not be freed. In case of an error, or in case

  "by the @tep handle"

> + * the requested dynamic event is missing in the @tep handler - NULL is returned.
> + */
> +struct tep_event *
> +tracefs_dynevent_get_event(struct tep_handle *tep, struct tracefs_dynevent *dynevent)
> +{
> +	struct tep_event *event;
> +
> +	if (!tep || !dynevent || !dynevent->event)
> +		return NULL;
> +
> +	/* If the dynamic event is already loaded in the tep, return it */
> +	event = tep_find_event_by_name(tep, dynevent->system, dynevent->event);
> +	if (event)
> +		return event;
> +
> +	/* Try to load any new events from the given system */
> +	if (trace_load_events(tep, NULL, dynevent->system))

Does this refresh, or does just append?

That is, if there are already dynamic events, wouldn't this re-add the
existing events that are already there?

Perhaps we need an interface in libtraceevent that rescans, and checks for
duplicates.

-- Steve

> +		return NULL;
> +
> +	return tep_find_event_by_name(tep, dynevent->system, dynevent->event);
> +}

