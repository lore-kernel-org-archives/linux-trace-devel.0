Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91436C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Dec 2021 22:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhLGWR0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 17:17:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35302 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbhLGWR0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 17:17:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B43DCB81E83
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Dec 2021 22:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BC6C341C3;
        Tue,  7 Dec 2021 22:13:52 +0000 (UTC)
Date:   Tue, 7 Dec 2021 17:13:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH] libtracefs: New APIs for getting the raw format of
 synth event
Message-ID: <20211207171351.2928503d@gandalf.local.home>
In-Reply-To: <20211206151352.361507-1-y.karadz@gmail.com>
References: <20211206151352.361507-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  6 Dec 2021 17:13:52 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The new APIs can be useful in the case whene the user wants to
> check what exactly gets passed to the kernel as definition of
> a synth event.

Please list the APIs.

> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  include/tracefs.h  |   4 ++
>  src/tracefs-hist.c | 102 +++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 88 insertions(+), 18 deletions(-)
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 804d738..9ad036c 100644
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
> @@ -553,6 +554,9 @@ int tracefs_synth_create(struct tracefs_synth *synth);
>  int tracefs_synth_destroy(struct tracefs_synth *synth);
>  void tracefs_synth_free(struct tracefs_synth *synth);
>  int tracefs_synth_echo_cmd(struct trace_seq *seq, struct tracefs_synth *synth);
> +const char *tracefs_synth_show_event_row(struct tracefs_synth *synth);
> +const char *tracefs_synth_show_start_hist_row(struct tracefs_synth *synth);
> +const char *tracefs_synth_show_end_hist_row(struct tracefs_synth *synth);
>  
>  struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
>  				  const char *sql_buffer, char **err);
> diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
> index 41c88d1..338249d 100644
> --- a/src/tracefs-hist.c
> +++ b/src/tracefs-hist.c
> @@ -717,6 +717,8 @@ struct tracefs_synth {
>  	struct action		*actions;
>  	struct action		**next_action;
>  	struct tracefs_dynevent	*dyn_event;
> +	char			*start_hist;
> +	char			*end_hist;
>  	char			*name;
>  	char			**synthetic_fields;
>  	char			**synthetic_args;
> @@ -771,6 +773,8 @@ void tracefs_synth_free(struct tracefs_synth *synth)
>  		return;
>  
>  	free(synth->name);
> +	free(synth->start_hist);
> +	free(synth->end_hist);
>  	tracefs_list_free(synth->synthetic_fields);
>  	tracefs_list_free(synth->synthetic_args);
>  	tracefs_list_free(synth->start_keys);
> @@ -1067,6 +1071,9 @@ struct tracefs_synth *tracefs_synth_alloc(struct tep_handle *tep,
>  		synth = NULL;
>  	}
>  
> +	synth->start_hist = NULL;
> +	synth->end_hist = NULL;
> +
>  	return synth;
>  }
>  
> @@ -1836,6 +1843,72 @@ static char *create_end_hist(struct tracefs_synth *synth)
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
> +int tracefs_synth_echo_fmt(struct trace_seq *seq,
> +			   struct tracefs_instance *instance,
> +			   struct tracefs_synth *synth)
> +{
> +	if (!synth->dyn_event)
> +		return -1;
> +
> +	trace_seq_printf(seq, "%s\n", synth->dyn_event->format);
> +	trace_seq_printf(seq, "%s\n", synth->start_hist);
> +	trace_seq_printf(seq, "%s\n", synth->end_hist);
> +
> +	return 0;
> +}
> +
> +/*
> + * tracefs_synth_show_event_row - show the dynamic event used by a synthetic
> + *				  event
> + * @synth: The synthetic event to read format from
> + *
> + * This shows the raw format of the dynamic event used by the synthetic event.
> + *
> + * Returns format string on succes or NULL on error.

Should probably state that the string returned belongs to the synth
descriptor.


> + */
> +const char *tracefs_synth_show_event_row(struct tracefs_synth *synth)
> +{
> +	return synth->dyn_event ? synth->dyn_event->format : NULL;
> +}
> +
> +/*
> + * tracefs_synth_show_start_hist_row - show the start histogram used by a
> + *				       synthetic event
> + * @synth: The synthetic event to read format from
> + *
> + * This shows the raw format of the start histogram used by the synthetic event.
> + *
> + * Returns format string on succes or NULL on error.

Here too. And typo in all the comments. "success"


> + */
> +const char *tracefs_synth_show_start_hist_row(struct tracefs_synth *synth)
> +{
> +	return synth->start_hist;
> +}
> +
> +/*
> + * tracefs_synth_show_end_hist_row - show the end histogram used by a
> + *				       synthetic event
> + * @synth: The synthetic event to read format from
> + *
> + * This shows the raw format of the end histogram used by the synthetic event.
> + *
> + * Returns format string on succes or NULL on error.

Same here.

> + */
> +const char *tracefs_synth_show_end_hist_row(struct tracefs_synth *synth)
> +{
> +	return synth->end_hist;
> +}
> +
>  static char *append_filter(char *hist, char *filter, unsigned int parens)
>  {
>  	int i;
> @@ -1974,8 +2047,6 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
>   */
>  int tracefs_synth_create(struct tracefs_synth *synth)
>  {
> -	char *start_hist = NULL;
> -	char *end_hist = NULL;
>  	int ret;
>  
>  	if (!synth) {
> @@ -1996,40 +2067,35 @@ int tracefs_synth_create(struct tracefs_synth *synth)
>  	if (tracefs_dynevent_create(synth->dyn_event))
>  		return -1;
>  
> -	start_hist = create_hist(synth->start_keys, synth->start_vars);
> -	start_hist = append_filter(start_hist, synth->start_filter,
> -				   synth->start_parens);
> -	if (!start_hist)
> +	synth->start_hist = create_hist(synth->start_keys, synth->start_vars);
> +	synth->start_hist = append_filter(synth->start_hist, synth->start_filter,
> +					  synth->start_parens);
> +	if (!synth->start_hist)
>  		goto remove_synthetic;
>  
> -	end_hist = create_end_hist(synth);
> -	end_hist = append_filter(end_hist, synth->end_filter,
> -				   synth->end_parens);
> -	if (!end_hist)
> +	synth->end_hist = create_end_hist(synth);
> +	synth->end_hist = append_filter(synth->end_hist, synth->end_filter,
> +					synth->end_parens);
> +	if (!synth->end_hist)
>  		goto remove_synthetic;
>  
>  	ret = tracefs_event_file_append(synth->instance, synth->start_event->system,
>  					synth->start_event->name,
> -					"trigger", start_hist);
> +					"trigger", synth->start_hist);
>  	if (ret < 0)
>  		goto remove_synthetic;
>  
>  	ret = tracefs_event_file_append(synth->instance, synth->end_event->system,
>  					synth->end_event->name,
> -					"trigger", end_hist);
> +					"trigger", synth->end_hist);
>  	if (ret < 0)
>  		goto remove_start_hist;
>  
> -	free(start_hist);
> -	free(end_hist);
> -
>  	return 0;
>  
>   remove_start_hist:
> -	remove_hist(synth->instance, synth->start_event, start_hist);
> +	remove_hist(synth->instance, synth->start_event, synth->start_hist);
>   remove_synthetic:
> -	free(end_hist);
> -	free(start_hist);
>  	tracefs_dynevent_destroy(synth->dyn_event, false);

I just realized that on error, we do not free the synthetic event
descriptor. So there is a memory leak.

Also, I'm thinking that the specific functions for destroying the synthetic
events and such, should live here, and trace-dynevents.c should call them.

Because all the management for synthetic events should live in this file
(or go to its own file).

-- Steve


>  	return -1;
>  }

