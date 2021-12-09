Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08CE8C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Dec 2021 18:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237946AbhLIS2O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 13:28:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51464 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243269AbhLIS2N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 13:28:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3EB0B825F9
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Dec 2021 18:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1988FC004DD;
        Thu,  9 Dec 2021 18:24:36 +0000 (UTC)
Date:   Thu, 9 Dec 2021 13:24:35 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3] libtracefs: New APIs for getting the raw format of
 synth event
Message-ID: <20211209132435.187422a8@gandalf.local.home>
In-Reply-To: <20211209163815.16769-1-y.karadz@gmail.com>
References: <20211209163815.16769-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  9 Dec 2021 18:38:15 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The following APIs are added:
> int tracefs_synth_echo_fmt(struct trace_seq *, struct tracefs_synth *)
> const char *tracefs_synth_show_event(struct tracefs_synth *)
> const char *tracefs_synth_show_start_hist(struct tracefs_synth *)
> const char *tracefs_synth_show_end_hist(struct tracefs_synth *)
> 
> The new APIs can be useful in the case whene the user wants to

                                        "where"

> check what exactly gets passed to the kernel as definition of
> a synth event.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  Documentation/libtracefs-synth2.txt | 23 ++++++-
>  include/tracefs.h                   |  5 ++
>  src/tracefs-hist.c                  | 94 +++++++++++++++++++++++------
>  3 files changed, 102 insertions(+), 20 deletions(-)
> 
> diff --git a/Documentation/libtracefs-synth2.txt b/Documentation/libtracefs-synth2.txt
> index 569819a..e557bc9 100644
> --- a/Documentation/libtracefs-synth2.txt
> +++ b/Documentation/libtracefs-synth2.txt
> @@ -5,7 +5,8 @@ NAME
>  ----
>  tracefs_synth_create, tracefs_synth_destroy, tracefs_synth_echo_cmd, tracefs_synth_complete,
>  tracefs_synth_get_start_hist, tracefs_synth_trace, tracefs_synth_snapshot,
> -tracefs_synth_get_name - Creation of synthetic events
> +tracefs_synth_get_name, tracefs_synth_echo_fmt, tracefs_synth_show_event,
> +tracefs_synth_show_start_hist, tracefs_synth_show_end_hist - Creation of synthetic events
>  
>  SYNOPSIS
>  --------
> @@ -27,6 +28,11 @@ int tracefs_synth_save(struct tracefs_synth pass:[*]synth,
>  		       enum tracefs_synth_handler type, const char pass:[*]var,
>  		       char pass:[**]save_fields);
>  const char *tracefs_synth_get_name(struct tracefs_synth pass:[*]synth);
> +int tracefs_synth_echo_fmt(struct trace_seq pass:[*]seq, struct tracefs_synth pass:[*]synth);
> +const char *tracefs_synth_show_event(struct tracefs_synth pass:[*]synth);
> +const char *tracefs_synth_show_start_hist(struct tracefs_synth pass:[*]synth);
> +const char *tracefs_synth_show_end_hist(struct tracefs_synth pass:[*]synth);
> +
>  --
>  
>  DESCRIPTION
> @@ -93,9 +99,22 @@ _var_ changes. _var_ must be one of the _name_ elements used in *tracefs_synth_a
>  The returned string belongs to the synth event object and is freed with the event
>  by *tracefs_synth_free*().
>  
> +*tracefs_synth_show_event*() returns the format of the dynamic event used by the synthetic
> +event or NULL on error. The returned string belongs to the synth event object and is freed
> +with the event by *tracefs_synth_free*().
> +
> +*tracefs_synth_show_start_hist*() returns the format of the start histogram used by the
> +synthetic event or NULL on error. The returned string belongs to the synth event object
> +and is freed with the event by *tracefs_synth_free*().
> +
> +*tracefs_synth_show_end_hist*() returns the format of the end histogram used by the
> +synthetic event or NULL on error. The returned string belongs to the synth event object
> +and is freed with the event by *tracefs_synth_free*().
> +
>  RETURN VALUE
>  ------------
> -*tracefs_synth_get_name*() returns a string owned by the synth event object.
> +*tracefs_synth_get_name*(), *tracefs_synth_show_event*(), *tracefs_synth_show_start_hist*()
> +and *tracefs_synth_show_end_hist*()  return a string owned by the synth event object.
>  
>  All other functions return zero on success or -1 on error.
>  
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 967690f..b772f5a 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -250,6 +250,7 @@ enum tracefs_dynevent_type {
>  	TRACEFS_DYNEVENT_SYNTH		= 1 << 5,
>  	TRACEFS_DYNEVENT_MAX		= 1 << 6,
>  };
> +
>  int tracefs_dynevent_create(struct tracefs_dynevent *devent);
>  int tracefs_dynevent_destroy(struct tracefs_dynevent *devent, bool force);
>  int tracefs_dynevent_destroy_all(unsigned int types, bool force);
> @@ -550,6 +551,10 @@ int tracefs_synth_create(struct tracefs_synth *synth);
>  int tracefs_synth_destroy(struct tracefs_synth *synth);
>  void tracefs_synth_free(struct tracefs_synth *synth);
>  int tracefs_synth_echo_cmd(struct trace_seq *seq, struct tracefs_synth *synth);
> +int tracefs_synth_echo_fmt(struct trace_seq *seq, struct tracefs_synth *synth);
> +const char *tracefs_synth_show_event(struct tracefs_synth *synth);
> +const char *tracefs_synth_show_start_hist(struct tracefs_synth *synth);
> +const char *tracefs_synth_show_end_hist(struct tracefs_synth *synth);
>  
>  struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
>  				  const char *sql_buffer, char **err);
> diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
> index 6051ecc..f5359a5 100644
> --- a/src/tracefs-hist.c
> +++ b/src/tracefs-hist.c
> @@ -683,6 +683,8 @@ struct tracefs_synth {
>  	struct action		*actions;
>  	struct action		**next_action;
>  	struct tracefs_dynevent	*dyn_event;
> +	char			*start_hist;
> +	char			*end_hist;
>  	char			*name;
>  	char			**synthetic_fields;
>  	char			**synthetic_args;
> @@ -737,6 +739,8 @@ void tracefs_synth_free(struct tracefs_synth *synth)
>  		return;
>  
>  	free(synth->name);
> +	free(synth->start_hist);
> +	free(synth->end_hist);
>  	tracefs_list_free(synth->synthetic_fields);
>  	tracefs_list_free(synth->synthetic_args);
>  	tracefs_list_free(synth->start_keys);
> @@ -1802,6 +1806,67 @@ static char *create_end_hist(struct tracefs_synth *synth)
>  	return create_actions(end_hist, synth);
>  }
>  
> +/*
> + * tracefs_synth_echo_fmt - show the raw format of a synthetic event
> + * @seq: A trace_seq to store the format string
> + * @synth: The synthetic event to read format from
> + *
> + * This shows the raw format that describes the synthetic event, including
> + * the format of the dynamic event and the start / end histograms.
> + *
> + * Returns 0 on succes -1 on error.
> + */
> +int tracefs_synth_echo_fmt(struct trace_seq *seq, struct tracefs_synth *synth)


Sorry to nitpick on the naming again, but perhaps we should call this

  tracefs_synth_raw_fmt()

Because saying "echo_fmt" I would think it would include the "echo" command
in the output.


> +{
> +	if (!synth->dyn_event)
> +		return -1;
> +
> +	trace_seq_printf(seq, "%s", synth->dyn_event->format);
> +	trace_seq_printf(seq, "\n%s", synth->start_hist);
> +	trace_seq_printf(seq, "\n%s", synth->end_hist);

Hmm, shouldn't this end with a \n? Or is it to allow quoting?

-- Steve


> +
> +	return 0;
> +}
> +
