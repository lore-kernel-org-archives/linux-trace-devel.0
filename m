Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E119C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC6C660720
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 17:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbhKDRQc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 13:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233116AbhKDRQb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 13:16:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C104760720;
        Thu,  4 Nov 2021 17:13:52 +0000 (UTC)
Date:   Thu, 4 Nov 2021 13:13:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 08/10] libtracefs: Use the internal dynamic events
 API when creating synthetic events
Message-ID: <20211104131351.1110c122@gandalf.local.home>
In-Reply-To: <20211104111047.302660-9-tz.stoyanov@gmail.com>
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
        <20211104111047.302660-9-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  4 Nov 2021 13:10:45 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Synthetic events are type of ftrace dynamic events. The tracefs library
> has dedicated APIs to manage dynamic events of all types. In order the
> code to be consistent, the creation of synthetic events inside the
> library is reimplemented with these new dynamic events APIs.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  src/tracefs-hist.c | 103 +++++++++++++++++++++------------------------
>  1 file changed, 47 insertions(+), 56 deletions(-)
> 
> diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
> index 9009dba..08bb2da 100644
> --- a/src/tracefs-hist.c
> +++ b/src/tracefs-hist.c
> @@ -661,6 +661,7 @@ struct tracefs_synth {
>  	struct tep_event	*end_event;
>  	struct action		*actions;
>  	struct action		**next_action;
> +	struct tracefs_dynevent	*dyn_event;
>  	char			*name;
>  	char			**synthetic_fields;
>  	char			**synthetic_args;
> @@ -719,6 +720,7 @@ void tracefs_synth_free(struct tracefs_synth *synth)
>  		synth->actions = action->next;
>  		action_free(action);
>  	}
> +	tracefs_dynevent_free(synth->dyn_event);
>  
>  	free(synth);
>  }
> @@ -889,6 +891,28 @@ synth_init_from(struct tep_handle *tep, const char *start_system,
>  	return synth;
>  }
>  
> +static int alloc_synthetic_event(struct tracefs_synth *synth)
> +{
> +	char *synthetic_format;

Should we just call it "format". It's obviously for the synthetic event.

> +	const char *field;
> +	int i;
> +
> +	synthetic_format = strdup("");
> +	if (!synthetic_format)
> +		return -1;
> +
> +	for (i = 0; synth->synthetic_fields && synth->synthetic_fields[i]; i++) {
> +		field = synth->synthetic_fields[i];
> +		synthetic_format = append_string(synthetic_format, " ", field);

My OCD is bothering me that the first field has a space appended to it.

		format = append_string(format, i ? " " : NULL, field);


> +	}
> +
> +	synth->dyn_event = dynevent_alloc(TRACEFS_DYNEVENT_SYNTH, NULL,
> +					  synth->name, NULL, synthetic_format);
> +	free(synthetic_format);
> +
> +	return synth->dyn_event ? 0 : -1;
> +}
> +
>  /**
>   * tracefs_synth_alloc - create a new tracefs_synth instance
>   * @tep: The tep handle that holds the events to work on
> @@ -1609,38 +1633,6 @@ int tracefs_synth_save(struct tracefs_synth *synth,
>  	return 0;
>  }
>  
> -static char *create_synthetic_event(struct tracefs_synth *synth)
> -{
> -	char *synthetic_event;
> -	const char *field;
> -	int i;
> -
> -	synthetic_event = strdup(synth->name);
> -	if (!synthetic_event)
> -		return NULL;
> -
> -	for (i = 0; synth->synthetic_fields && synth->synthetic_fields[i]; i++) {
> -		field = synth->synthetic_fields[i];
> -		synthetic_event = append_string(synthetic_event, " ", field);
> -	}
> -
> -	return synthetic_event;
> -}
> -
> -static int remove_synthetic(const char *synthetic)
> -{
> -	char *str;
> -	int ret;
> -
> -	ret = asprintf(&str, "!%s", synthetic);
> -	if (ret < 0)
> -		return -1;
> -
> -	ret = tracefs_instance_file_append(NULL, "synthetic_events", str);
> -	free(str);
> -	return ret < 0 ? -1 : 0;
> -}
> -
>  static int remove_hist(struct tracefs_instance *instance,
>  		       struct tep_event *event, const char *hist)
>  {
> @@ -1919,7 +1911,6 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
>  int tracefs_synth_create(struct tracefs_instance *instance,
>  			 struct tracefs_synth *synth)

I think we should call this:

	tracefs_synth_create_raw()

that passes in the "instance".

Then we could have tracefs_synth_create() just use the top instance (no
instance passed to it), and we could decide later if we want to create an
internal instance or not to do the work to keep from modifying the top
instance.

That is, we would have:

int tracefs_synth_create(struct tracefs_synth *synth)
{
	return tracefs_synth_create_raw(synth->create_instance, synth);
}

Have synth->create_instance be defaulted to NULL on allocation, and would
get updated by another interface perhaps?

We could also add to the _raw() function:

	if (synth->create_instance && instance &&
	    synth->create_instance != instance) {
		errno = EINVAL;
		return -1
	}

	if (!synth->create_instance && instance) {
		syth->create_instance = instance;
		trace_get_instance(instance);
	}

Would need to have in the destructor:

	if (synth->create_instance)
		trace_put_instance(synth->create_instance);


Or something like that.


>  {
> -	char *synthetic_event;
>  	char *start_hist = NULL;
>  	char *end_hist = NULL;
>  	int ret;
> @@ -1937,14 +1928,10 @@ int tracefs_synth_create(struct tracefs_instance *instance,
>  	if (verify_state(synth) < 0)
>  		return -1;
>  
> -	synthetic_event = create_synthetic_event(synth);
> -	if (!synthetic_event)
> +	if (!synth->dyn_event && alloc_synthetic_event(synth))
> +		return -1;
> +	if (!tracefs_dynevent_create(synth->dyn_event))
>  		return -1;
> -
> -	ret = tracefs_instance_file_append(NULL, "synthetic_events",
> -					   synthetic_event);
> -	if (ret < 0)
> -		goto free_synthetic;
>  
>  	start_hist = create_hist(synth->start_keys, synth->start_vars);
>  	start_hist = append_filter(start_hist, synth->start_filter,
> @@ -1980,9 +1967,7 @@ int tracefs_synth_create(struct tracefs_instance *instance,
>   remove_synthetic:
>  	free(end_hist);
>  	free(start_hist);
> -	remove_synthetic(synthetic_event);
> - free_synthetic:
> -	free(synthetic_event);
> +	tracefs_dynevent_destroy(synth->dyn_event, false);
>  	return -1;
>  }
>  
> @@ -2007,7 +1992,6 @@ int tracefs_synth_create(struct tracefs_instance *instance,
>  int tracefs_synth_destroy(struct tracefs_instance *instance,
>  			  struct tracefs_synth *synth)
>  {
> -	char *synthetic_event;
>  	char *hist;
>  	int ret;
>  
> @@ -2041,11 +2025,7 @@ int tracefs_synth_destroy(struct tracefs_instance *instance,
>  	ret = remove_hist(instance, synth->start_event, hist);
>  	free(hist);
>  
> -	synthetic_event = create_synthetic_event(synth);
> -	if (!synthetic_event)
> -		return -1;
> -
> -	ret = remove_synthetic(synthetic_event);
> +	ret = tracefs_dynevent_destroy(synth->dyn_event, false);
>  
>  	return ret ? -1 : 0;
>  }
> @@ -2067,7 +2047,7 @@ int tracefs_synth_show(struct trace_seq *seq,
>  		       struct tracefs_instance *instance,
>  		       struct tracefs_synth *synth)
>  {
> -	char *synthetic_event = NULL;
> +	bool new_event = false;
>  	char *hist = NULL;
>  	char *path;
>  	int ret = -1;
> @@ -2082,16 +2062,19 @@ int tracefs_synth_show(struct trace_seq *seq,
>  		return -1;
>  	}
>  
> -	synthetic_event = create_synthetic_event(synth);
> -	if (!synthetic_event)
> -		return -1;
> +	if (!synth->dyn_event) {
> +		if (alloc_synthetic_event(synth))
> +			return -1;
> +		new_event = true;
> +	}

We should start looking at making this thread safe. Probably need to add
comments with /* TODO - make thread safe */ so we know where to look.

Don't need to do it for this patch set, but we need to remember. The
comment might help for now (that is, add the comment to the next series).

-- Steve

>  
>  	path = trace_find_tracing_dir();
>  	if (!path)
>  		goto out_free;
>  
> -	trace_seq_printf(seq, "echo '%s' > %s/synthetic_events\n",
> -			 synthetic_event, path);
> +	trace_seq_printf(seq, "echo '%s%s %s' > %s/%s\n",
> +			 synth->dyn_event->prefix, synth->dyn_event->event,
> +			 synth->dyn_event->format, path, synth->dyn_event->trace_file);
>  
>  	tracefs_put_tracing_file(path);
>  	path = tracefs_instance_get_dir(instance);
> @@ -2116,10 +2099,18 @@ int tracefs_synth_show(struct trace_seq *seq,
>  			 hist, path, synth->end_event->system,
>  			 synth->end_event->name);
>  
> +	if (new_event) {
> +		tracefs_dynevent_free(synth->dyn_event);
> +		synth->dyn_event = NULL;
> +	}
> +
>  	ret = 0;
>   out_free:
> -	free(synthetic_event);
>  	free(hist);
>  	tracefs_put_tracing_file(path);
> +	if (new_event) {
> +		tracefs_dynevent_free(synth->dyn_event);
> +		synth->dyn_event = NULL;
> +	}
>  	return ret;
>  }

