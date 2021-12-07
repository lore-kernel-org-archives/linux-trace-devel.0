Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 425F9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Dec 2021 22:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241665AbhLGWF7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 17:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhLGWF5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 17:05:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AABC061574
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Dec 2021 14:02:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 621C1B81E7F
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Dec 2021 22:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE77C341C1;
        Tue,  7 Dec 2021 22:02:23 +0000 (UTC)
Date:   Tue, 7 Dec 2021 17:02:22 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] libtracefs: Rename the 'tracefs_get_hist_*()' APIs
Message-ID: <20211207170222.575015bf@gandalf.local.home>
In-Reply-To: <20211206150855.361202-3-y.karadz@gmail.com>
References: <20211206150855.361202-1-y.karadz@gmail.com>
        <20211206150855.361202-3-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  6 Dec 2021 17:08:54 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

Please specify what is being renamed and to what it's new name is.

> The APIs are renamed in order to match the naming convention used in
> the library. The patch adds documentation add well.

     "as well".

> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  Documentation/libtracefs-hist.txt | 15 ++++++++++++++-
>  include/tracefs.h                 |  6 +++---
>  src/tracefs-hist.c                | 24 +++++++++++++++++++++---
>  3 files changed, 38 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
> index c8230e5..e3145c9 100644
> --- a/Documentation/libtracefs-hist.txt
> +++ b/Documentation/libtracefs-hist.txt
> @@ -5,7 +5,8 @@ NAME
>  ----
>  tracefs_hist_alloc, tracefs_hist_free, tracefs_hist_add_key, tracefs_hist_add_value, tracefs_hist_add_name, tracefs_hist_start,
>  tracefs_hist_destory, tracefs_hist_add_sort_key, tracefs_hist_set_sort_key, tracefs_hist_sort_key_direction
> -tracefs_hist_echo_cmd, tracefs_hist_echo_fmt - Create and update event histograms
> +tracefs_hist_echo_cmd, tracefs_hist_echo_fmt, tracefs_hist_get_name, tracefs_hist_get_event,
> +tracefs_hist_get_system - Create, update and describe event histograms
>  
>  SYNOPSIS
>  --------
> @@ -73,6 +74,12 @@ int tracefs_hist_command(struct tracefs_instance pass:[*]instance,
>  int tracefs_hist_echo_fmt(struct trace_seq pass:[*]s, struct tracefs_instance pass:[*]instance,
>  			  struct tracefs_hist pass:[*]hist);
>  
> +tracefs_hist_get_name(struct tracefs_hist pass:[*]hist);
> +
> +tracefs_hist_get_event(struct tracefs_hist pass:[*]hist);
> +
> +tracefs_hist_get_system(struct tracefs_hist pass:[*]hist);
> +

The above three need to also show the return value.

>  --
>  
>  DESCRIPTION
> @@ -190,6 +197,12 @@ that would be done by *tracefs_hist_command*(3).
>  *tracefs_hist_echo_fmt*() prints the raw format that describes the state of the
>  histogram in the given _instance_, or NULL for the top level, into the _seq_.
>  
> +*tracefs_hist_get_name*() prints the name of the histogram.

It doesn't print anything. It returns the name, and it needs to be stated
that the returned string belongs to the histogram and is freed with the
histogram. That is, its scope is the same as the histogram, and the
returned string should not be freed.

> +
> +*tracefs_hist_get_event*() prints the event name of the histogram.
> +
> +*tracefs_hist_get_system*() prints the system name of the histogram.

Same for these two.

> +
>  *tracefs_hist_command*() is called to process a command on the histogram
>  _hist_ for its event in the given _instance_, or NULL for the top level.
>  The _cmd_ can be one of:
> diff --git a/include/tracefs.h b/include/tracefs.h
> index c2a6db7..7c03086 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -354,9 +354,9 @@ struct tracefs_hist *
>  tracefs_hist_alloc_nd(struct tep_handle *tep,
>  		      const char *system, const char *event_name,
>  		      struct tracefs_hist_axis *axes);
> -const char *tracefs_get_hist_name(struct tracefs_hist *hist);
> -const char *tracefs_get_hist_event(struct tracefs_hist *hist);
> -const char *tracefs_get_hist_system(struct tracefs_hist *hist);
> +const char *tracefs_hist_get_name(struct tracefs_hist *hist);
> +const char *tracefs_hist_get_event(struct tracefs_hist *hist);
> +const char *tracefs_hist_get_system(struct tracefs_hist *hist);
>  int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
>  			 enum tracefs_hist_key_type type);
>  int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
> diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
> index 9beafe0..837d4e1 100644
> --- a/src/tracefs-hist.c
> +++ b/src/tracefs-hist.c
> @@ -41,17 +41,35 @@ struct tracefs_hist {
>  	unsigned int		filter_state;
>  };
>  
> -const char *tracefs_get_hist_name(struct tracefs_hist *hist)
> +/*
> + * tracefs_hist_get_name - get the name of the histogram
> + * @hist: The histogram to get the name for
> + *
> + * Returns name string on succes or NULL on error.

Should state that the name returned belongs to the histogram and should not
be freed.


> + */
> +const char *tracefs_hist_get_name(struct tracefs_hist *hist)
>  {
>  	return hist ? hist->name : NULL;
>  }
>  
> -const char *tracefs_get_hist_event(struct tracefs_hist *hist)
> +/*
> + * tracefs_hist_get_event - get the event name of the histogram
> + * @hist: The histogram to get the event name for
> + *
> + * Returns event name string on succes or NULL on error.
> + */
> +const char *tracefs_hist_get_event(struct tracefs_hist *hist)
>  {
>  	return hist ? hist->event_name : NULL;
>  }
>  
> -const char *tracefs_get_hist_system(struct tracefs_hist *hist)
> +/*
> + * tracefs_hist_get_system - get the system name of the histogram
> + * @hist: The histogram to get the system name for
> + *
> + * Returns system name string on succes or NULL on error.

Same for these as well.

-- Steve

> + */
> +const char *tracefs_hist_get_system(struct tracefs_hist *hist)
>  {
>  	return hist ? hist->system : NULL;
>  }

