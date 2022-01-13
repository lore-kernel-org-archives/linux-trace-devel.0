Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12479C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jan 2022 19:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237868AbiAMTRt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 14:17:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54950 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237866AbiAMTRt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 14:17:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02B2661D93
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 19:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AC3C36AEB;
        Thu, 13 Jan 2022 19:17:47 +0000 (UTC)
Date:   Thu, 13 Jan 2022 14:17:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: New API for getting synthetic event
Message-ID: <20220113141746.70fe48eb@gandalf.local.home>
In-Reply-To: <20220112163619.21762-1-y.karadz@gmail.com>
References: <20220112163619.21762-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 12 Jan 2022 18:36:19 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> A new API is proposed, to get tep event descriptor for given synthetic
> event:
> 
> tracefs_synth_get_event ()
> 
> The API implementation gets derived from the implementation of the
> existing API  tracefs_dynevent_get_event(). It can detect any newly
> created or removed synthetic events.

Hi Yordan,

> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  Documentation/libtracefs-synth2.txt | 14 ++++++++++++--
>  include/tracefs-local.h             |  2 ++
>  include/tracefs.h                   |  2 ++
>  src/tracefs-dynevents.c             | 17 +----------------
>  src/tracefs-events.c                | 21 +++++++++++++++++++++
>  src/tracefs-hist.c                  | 18 ++++++++++++++++++
>  6 files changed, 56 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
> index 8056ab8..fac155b 100644
> --- a/Documentation/libtracefs-synth2.txt
> +++ b/Documentation/libtracefs-synth2.txt
> @@ -6,7 +6,8 @@ NAME
>  tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd, tracefs_synth_complete,
>  tracefs_synth_get_start_hist, tracefs_synth_trace, tracefs_synth_snapshot,
>  tracefs_synth_get_name, tracefs_synth_raw_fmt, tracefs_synth_show_event,
> -tracefs_synth_show_start_hist, tracefs_synth_show_end_hist - Creation of synthetic events
> +tracefs_synth_show_start_hist, tracefs_synth_show_end_hist, tracefs_synth_get_event
> +- Creation of synthetic events
>  
>  SYNOPSIS
>  --------
> @@ -32,7 +33,8 @@ int tracefs_synth_raw_fmt(struct trace_seq pass:[*]seq, struct tracefs_synth pas
>  const char *tracefs_synth_show_event(struct tracefs_synth pass:[*]synth);
>  const char *tracefs_synth_show_start_hist(struct tracefs_synth pass:[*]synth);
>  const char *tracefs_synth_show_end_hist(struct tracefs_synth pass:[*]synth);
> -
> +tracefs_synth_get_event
> +struct tep_event pass:[*]*tracefs_synth_get_event*(struct tep_handle pass:[*]_tep_, struct tracefs_synth pass:[*]_synth_);
>  --
>  
>  DESCRIPTION
> @@ -114,11 +116,19 @@ and is freed with the event by *tracefs_synth_free*().
>  synthetic event or NULL on error. The returned string belongs to the synth event object
>  and is freed with the event by *tracefs_synth_free*().
>  
> +The *tracefs_synth_get_event*() function returns a tep event, describing the given synthetic
> +event. The API detects any newly created or removed dynamic events. The returned pointer to
> +tep event is controlled by @tep and must not be freed.
> +
>  RETURN VALUE
>  ------------
>  *tracefs_synth_get_name*(), *tracefs_synth_show_event*(), *tracefs_synth_show_start_hist*()
>  and *tracefs_synth_show_end_hist*()  return a string owned by the synth event object.
>  
> +The *tracefs_synth_get_event*() function returns a pointer to a tep event or NULL in case of an
> +error or if the requested synthetic event is missing. The returned pointer to tep event is
> +controlled by @tep and must not be freed.
> +
>  All other functions return zero on success or -1 on error.
>  
>  ERRORS
> diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> index daea5da..fc0a2c5 100644
> --- a/include/tracefs-local.h
> +++ b/include/tracefs-local.h
> @@ -116,5 +116,7 @@ int trace_load_events(struct tep_handle *tep,
>  		      const char *tracing_dir, const char *system);
>  int trace_rescan_events(struct tep_handle *tep,
>  			const char *tracing_dir, const char *system);
> +__hidden struct tep_event *get_tep_event(struct tep_handle *tep,
> +					 const char *system, const char *name);
>  
>  #endif /* _TRACE_FS_LOCAL_H */
> diff --git a/include/tracefs.h b/include/tracefs.h
> index bd758dc..9c53b84 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -564,5 +564,7 @@ const char *tracefs_synth_show_end_hist(struct tracefs_synth *synth);
>  
>  struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
>  				  const char *sql_buffer, char **err);
> +struct tep_event *
> +tracefs_synth_get_event(struct tep_handle *tep, struct tracefs_synth *synth);
>  
>  #endif /* _TRACE_FS_H */
> diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
> index d089d02..ddebb6b 100644
> --- a/src/tracefs-dynevents.c
> +++ b/src/tracefs-dynevents.c
> @@ -765,23 +765,8 @@ error:
>  struct tep_event *
>  tracefs_dynevent_get_event(struct tep_handle *tep, struct tracefs_dynevent *dynevent)
>  {
> -	struct tep_event *event;
> -
>  	if (!tep || !dynevent || !dynevent->event)
>  		return NULL;
>  
> -	/* Check if event exists in the system */
> -	if (!tracefs_event_file_exists(NULL, dynevent->system, dynevent->event, "format"))
> -		return NULL;
> -
> -	/* If the dynamic event is already loaded in the tep, return it */
> -	event = tep_find_event_by_name(tep, dynevent->system, dynevent->event);
> -	if (event)
> -		return event;
> -
> -	/* Try to load any new events from the given system */
> -	if (trace_rescan_events(tep, NULL, dynevent->system))
> -		return NULL;
> -
> -	return tep_find_event_by_name(tep, dynevent->system, dynevent->event);
> +	return get_tep_event(tep, dynevent->system, dynevent->event);
>  }
> diff --git a/src/tracefs-events.c b/src/tracefs-events.c
> index 067f6e0..30e80ce 100644
> --- a/src/tracefs-events.c
> +++ b/src/tracefs-events.c
> @@ -752,6 +752,27 @@ __hidden int trace_load_events(struct tep_handle *tep,
>  	return load_events(tep, tracing_dir, system, false);
>  }
>  
> +__hidden struct tep_event *get_tep_event(struct tep_handle *tep,
> +					 const char *system, const char *name)
> +{
> +	struct tep_event *event;
> +
> +	/* Check if event exists in the system */
> +	if (!tracefs_event_file_exists(NULL, system, name, "format"))
> +		return NULL;
> +
> +	/* If the dynamic event is already loaded in the tep, return it */

As this was moved out of the tracefs_dynevent_get_event() function, we
probably should update the comments too ;-)

	/* If the event is already loaded in the tep handler, return it */

-- Steve

> +	event = tep_find_event_by_name(tep, system, name);
> +	if (event)
> +		return event;
> +
> +	/* Try to load any new events from the given system */
> +	if (trace_rescan_events(tep, NULL, system))
> +		return NULL;
> +
> +	return tep_find_event_by_name(tep, system, name);
> +}
> +
