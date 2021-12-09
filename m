Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD0CDC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Dec 2021 14:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbhLIO4H (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 09:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239003AbhLIO4F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 09:56:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95DFC061746
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Dec 2021 06:52:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F1B60CE261A
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Dec 2021 14:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AC9C004DD;
        Thu,  9 Dec 2021 14:52:27 +0000 (UTC)
Date:   Thu, 9 Dec 2021 09:52:26 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] libtracefs: New APIs for getting the raw format
 of synth event
Message-ID: <20211209095226.688679a7@gandalf.local.home>
In-Reply-To: <20211209104524.5354-4-y.karadz@gmail.com>
References: <20211209104524.5354-1-y.karadz@gmail.com>
        <20211209104524.5354-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  9 Dec 2021 12:45:24 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The following APIs are added:
> int tracefs_synth_echo_fmt(struct trace_seq *, struct tracefs_synth *)
> const char *tracefs_synth_show_event_row(struct tracefs_synth *)
> const char *tracefs_synth_show_start_hist_row(struct tracefs_synth *)
> const char *tracefs_synth_show_end_hist_row(struct tracefs_synth *)

OK, I'm going to do a little bikeshedding here ;-)

The word "row" seems off. I wonder if it would be better to just drop it.

	tracefs_synth_show_event()
	tracefs_synth_show_start_hist()
	tracefs_synth_show_end_hist()

As to me "row" means this is a table and related somehow to the
tracefs_sql() that can create a synthetic event. But these have nothing to
do with the rows of those tables.

> 
> The new APIs can be useful in the case whene the user wants to
> check what exactly gets passed to the kernel as definition of
> a synth event.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  include/tracefs.h  |  5 +++
>  src/tracefs-hist.c | 97 +++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 84 insertions(+), 18 deletions(-)
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 967690f..0482b0a 100644
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
> +const char *tracefs_synth_show_event_row(struct tracefs_synth *synth);
> +const char *tracefs_synth_show_start_hist_row(struct tracefs_synth *synth);
> +const char *tracefs_synth_show_end_hist_row(struct tracefs_synth *synth);
>  
>  struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
>  				  const char *sql_buffer, char **err);
> diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
> index 6051ecc..ad9648f 100644
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
> @@ -1802,6 +1806,70 @@ static char *create_end_hist(struct tracefs_synth *synth)
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
> +{
> +	if (!synth->dyn_event)
> +		return -1;
> +
> +	trace_seq_printf(seq, "%s", synth->dyn_event->format);
> +	trace_seq_printf(seq, "\n%s", synth->start_hist);
> +	trace_seq_printf(seq, "\n%s", synth->end_hist);
> +
> +	return 0;
> +}
> +
> +/*
> + * tracefs_synth_show_event_row - show the dynamic event used by a synthetic
> + *				  event

FYI, this should be on a single line. A "kernel-doc" starts with "a one
line description". Either shorten it, or just keep it on one line. Linux
has extended the "max line chars" to 100 from 80.

> + * @synth: The synthetic event to read format from
> + *
> + * This shows the raw format of the dynamic event used by the synthetic event.
> + *
> + * Returns format string owned by @synth on success, or NULL on error.
> + */
> +const char *tracefs_synth_show_event_row(struct tracefs_synth *synth)
> +{
> +	return synth->dyn_event ? synth->dyn_event->format : NULL;
> +}
> +
> +/*
> + * tracefs_synth_show_start_hist_row - show the start histogram used by a
> + *				       synthetic event

Here too.

And if we get rid of "_row" it should make it shorter anyway.

-- Steve


> + * @synth: The synthetic event to read format from
> + *
> + * This shows the raw format of the start histogram used by the synthetic event.
> + *
> + * Returns format string owned by @synth on success, or NULL on error.
> + */
> +const char *tracefs_synth_show_start_hist_row(struct tracefs_synth *synth)
> +{
> +	return synth->start_hist;
> +}
> +
