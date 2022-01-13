Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25568C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jan 2022 05:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiAMFCP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 00:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiAMFCO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 00:02:14 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDF7C06173F
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Jan 2022 21:02:13 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so16940843pjf.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Jan 2022 21:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rJTNa4XFUOOjAYY3tULVTW2G4bm92LprHIZT6ywrBLY=;
        b=Nl1+wYbxwDuu3UzZ/XRyfmclI310utoPLWJfT8pCwaQMpj54chDCgBc2HVo+rowlC4
         kSgR3D3Pw1rVtiS2OJXprmQUjtJTi152yWLQAZoOujv6YgHDwFWD8tQllqJhxQ9PlkTD
         uN8mcdvNRvMe2fwTfVWEwI2TpFnArAYNNxvNByBtsIEMKYMIiJD0gFzh68xeR0lxko9z
         EM1UE7Nx6OQgcMWyYjjFxfQxTwJIEx8kfe9Lh/MZ3fEzJmy3AGzEJcqcKfjJ2u97km+Y
         B9GiRHwRiYfQM+BvCW+eAMY/zBBL/I61YsMYdQ0hucVzKUgGBKIdiJwzy2inQaFZMvP2
         69aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rJTNa4XFUOOjAYY3tULVTW2G4bm92LprHIZT6ywrBLY=;
        b=DFuyXyyLnhBeXPVL5bphtKk46xvtQgPSIFKLqbRfBJI1NL8JC1MuX4tqYtbOUtQbTk
         h396vGQWkdPr894RN3L+fJeSInBWk/w5YsSXLdtZOtf0mHzmnO+tOtOTCDeB5jSRnTgN
         dBuwNVPMkdHptaVnTtSvFpsj1RaLkkBAL5O+TbgQZJEARyEJ+mqm9bzQFpwrhKfWhB32
         fPDV3MmE4lZ1f+uHYMxcms5/Rbw+eqRawuaYfQ2sDahCJzRE6Uzxgfj7wrP0872vb6dZ
         cecfYcR0u847u2Q8G+ttnZy8jXji4KeSzti9f9jFdxhMt65o/zu3i1PlMwSiIHOj4Coj
         cvig==
X-Gm-Message-State: AOAM530+NGAC1OwUU+ZVnLSqdQCrb2lc6qyRd49NBGUFp+FsdFO0iL6c
        /9EfLZ97hMoSJ16SJyBY0NOpELAbrq16Xw1xoVs=
X-Google-Smtp-Source: ABdhPJwHkarns8hrGPjdTtehO1EVZkNOjkAjYlrhgt1QlcmA5TV1Y5SChUgD8XZMK9QOpyugJi/CRTt7fhnSsnth6BY=
X-Received: by 2002:a17:902:b78b:b0:14a:1f78:2739 with SMTP id
 e11-20020a170902b78b00b0014a1f782739mr2723483pls.45.1642050132506; Wed, 12
 Jan 2022 21:02:12 -0800 (PST)
MIME-Version: 1.0
References: <20220112163619.21762-1-y.karadz@gmail.com>
In-Reply-To: <20220112163619.21762-1-y.karadz@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 13 Jan 2022 07:01:56 +0200
Message-ID: <CAPpZLN7=q-DiOQWDmv5SdV7xyu9TCHHZNP_Cfq4Gdo2c2GMMPg@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: New API for getting synthetic event
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Jan 13, 2022 at 1:33 AM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
>
> A new API is proposed, to get tep event descriptor for given synthetic
> event:
>
> tracefs_synth_get_event ()
>
> The API implementation gets derived from the implementation of the
> existing API  tracefs_dynevent_get_event(). It can detect any newly
> created or removed synthetic events.
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

Looks like something forgotten.

> +struct tep_event pass:[*]*tracefs_synth_get_event*(struct tep_handle pass:[*]_tep_, struct tracefs_synth pass:[*]_synth_);

The arguments of the other functions in this man page are not
underlined, all should follow the same style. As in the other man
pages of the library all arguments are underlined, this should be the
default style.
This could be addressed in a follow up patch - applying the same style
of all tracefs man pages.

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
>                       const char *tracing_dir, const char *system);
>  int trace_rescan_events(struct tep_handle *tep,
>                         const char *tracing_dir, const char *system);
> +__hidden struct tep_event *get_tep_event(struct tep_handle *tep,
> +                                        const char *system, const char *name);

"__hidden" is not needed here, in the header file. All functions in
tracefs-local.h are hidden and this is specified in their
implementation.

>
>  #endif /* _TRACE_FS_LOCAL_H */
> diff --git a/include/tracefs.h b/include/tracefs.h
> index bd758dc..9c53b84 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -564,5 +564,7 @@ const char *tracefs_synth_show_end_hist(struct tracefs_synth *synth);
>
>  struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
>                                   const char *sql_buffer, char **err);
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
> -       struct tep_event *event;
> -
>         if (!tep || !dynevent || !dynevent->event)
>                 return NULL;
>
> -       /* Check if event exists in the system */
> -       if (!tracefs_event_file_exists(NULL, dynevent->system, dynevent->event, "format"))
> -               return NULL;
> -
> -       /* If the dynamic event is already loaded in the tep, return it */
> -       event = tep_find_event_by_name(tep, dynevent->system, dynevent->event);
> -       if (event)
> -               return event;
> -
> -       /* Try to load any new events from the given system */
> -       if (trace_rescan_events(tep, NULL, dynevent->system))
> -               return NULL;
> -
> -       return tep_find_event_by_name(tep, dynevent->system, dynevent->event);
> +       return get_tep_event(tep, dynevent->system, dynevent->event);
>  }
> diff --git a/src/tracefs-events.c b/src/tracefs-events.c
> index 067f6e0..30e80ce 100644
> --- a/src/tracefs-events.c
> +++ b/src/tracefs-events.c
> @@ -752,6 +752,27 @@ __hidden int trace_load_events(struct tep_handle *tep,
>         return load_events(tep, tracing_dir, system, false);
>  }
>
> +__hidden struct tep_event *get_tep_event(struct tep_handle *tep,
> +                                        const char *system, const char *name)
> +{
> +       struct tep_event *event;
> +
> +       /* Check if event exists in the system */
> +       if (!tracefs_event_file_exists(NULL, system, name, "format"))
> +               return NULL;
> +
> +       /* If the dynamic event is already loaded in the tep, return it */
> +       event = tep_find_event_by_name(tep, system, name);
> +       if (event)
> +               return event;
> +
> +       /* Try to load any new events from the given system */
> +       if (trace_rescan_events(tep, NULL, system))
> +               return NULL;
> +
> +       return tep_find_event_by_name(tep, system, name);
> +}
> +
>  static int read_header(struct tep_handle *tep, const char *tracing_dir)
>  {
>         struct stat st;
> diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
> index 7146fc1..8d99492 100644
> --- a/src/tracefs-hist.c
> +++ b/src/tracefs-hist.c
> @@ -2197,3 +2197,21 @@ int tracefs_synth_echo_cmd(struct trace_seq *seq,
>         }
>         return ret;
>  }
> +
> +/**
> + * tracefs_synth_get_event - return tep event representing the given synthetic event
> + * @tep: a handle to the trace event parser context that holds the events
> + * @synth: a synthetic event context, describing given synthetic event.
> + *
> + * Returns a pointer to a tep event describing the given synthetic event. The pointer
> + * is managed by the @tep handle and must not be freed. In case of an error, or in case
> + * the requested synthetic event is missing in the @tep handler - NULL is returned.
> + */
> +struct tep_event *
> +tracefs_synth_get_event(struct tep_handle *tep, struct tracefs_synth *synth)
> +{
> +       if (!tep || !synth || !synth->name)
> +               return NULL;
> +
> +       return get_tep_event(tep, SYNTHETIC_GROUP, synth->name);
> +}
> --
> 2.32.0
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
