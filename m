Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93795C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Dec 2021 19:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245428AbhLAT7Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 14:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhLAT6w (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 14:58:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00896C061574
        for <linux-trace-devel@vger.kernel.org>; Wed,  1 Dec 2021 11:55:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3B100CE20ED
        for <linux-trace-devel@vger.kernel.org>; Wed,  1 Dec 2021 19:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0398AC53FCC;
        Wed,  1 Dec 2021 19:55:24 +0000 (UTC)
Date:   Wed, 1 Dec 2021 14:55:23 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 4/4] libtracefs: New API for applying filter on event.
Message-ID: <20211201145523.6731a87d@gandalf.local.home>
In-Reply-To: <20211130050057.336228-5-tz.stoyanov@gmail.com>
References: <20211130050057.336228-1-tz.stoyanov@gmail.com>
        <20211130050057.336228-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Note, the subject should not have a period.

On Tue, 30 Nov 2021 07:00:57 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> There is no API for applying a filter string on event. Existing APIs

"on an event."

> only constructs and verifies the filter string. Even though the actual

  "only construct and verify"

> applying is just writing into the event's filter file, it is good to
> have a dedicated API for that:

[ add empty line here ]

> 	tracefs_event_apply_filter()
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  Documentation/libtracefs-filter.txt | 11 ++++++++++-
>  include/tracefs.h                   |  3 +++
>  src/tracefs-filter.c                | 19 +++++++++++++++++++
>  3 files changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/libtracefs-filter.txt b/Documentation/libtracefs-filter.txt
> index 7e167bc..7532c96 100644
> --- a/Documentation/libtracefs-filter.txt
> +++ b/Documentation/libtracefs-filter.txt
> @@ -3,7 +3,8 @@ libtracefs(3)
>  
>  NAME
>  ----
> -tracefs_event_append_filter, tracefs_event_verify_filter - Add and verify event filters
> +tracefs_event_append_filter, tracefs_event_verify_filter tracefs_event_apply_filter -

Missing comma (and you also need to rebase with the updates).


> +Add, verify and apply event filters
>  
>  SYNOPSIS
>  --------
> @@ -15,6 +16,7 @@ int tracefs_event_append_filter(struct tep_event pass:[*]event, char pass:[**] f
>  				 struct tracefs_filter type, const char pass:[*]field,
>  				 enum tracefs_synth_compare compare, const char pass:[*]val);
>  int tracefs_event_verify_filter(struct tep_event pass:[*]event, const char pass:[*]filter, char pass:[**]err);

I renamed the above, because it doesn't really affect the event.

> +int tracefs_event_apply_filter(struct tracefs_instance pass:[*]instance, struct tep_event pass:[*]event, const char pass:[*]filter);

But you can keep this name, as it makes sense to call this
"tracefs_event_.."

>  
>  --
>  
> @@ -66,6 +68,8 @@ error in the syntax, and _err_ is not NULL, then it will be allocated with an
>  error message stating what was found wrong with the filter. _err_ must be freed
>  with *free*().
>  
> +*tracefs_event_apply_filter*() applies given _filter_ string on _event_ in given _instance_.
> +
>  RETURN VALUE
>  ------------
>  *tracefs_event_append_filter*() returns 0 on success and -1 on error.
> @@ -75,6 +79,8 @@ is an error, and _errno_ is not *ENOMEM*, then _err_ is allocated and will
>  contain a string describing what was found wrong with _filter_. _err_ must be
>  freed with *free*().
>  
> +*tracefs_event_apply_filter*() returns 0 on success and -1 on error.
> +
>  EXAMPLE
>  -------
>  [source,c]
> @@ -269,6 +275,9 @@ int main (int argc, char **argv)
>  		}
>  	}
>  
> +	if (tracefs_event_apply_filter(NULL, event, new_filter))
> +		fprintf(stderr, "Failed to apply filter on event");
> +
>  	tep_free(tep);
>  
>  	printf("Created new filter: '%s'\n", new_filter);
> diff --git a/include/tracefs.h b/include/tracefs.h
> index fbd7d31..8ac9694 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -475,6 +475,9 @@ int tracefs_event_append_filter(struct tep_event *event, char **filter,
>  				const char *val);
>  int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
>  				char **err);
> +int tracefs_event_apply_filter(struct tracefs_instance *instance,
> +			       struct tep_event *event, const char *filter);
> +
>  
>  #define TRACEFS_TIMESTAMP "common_timestamp"
>  #define TRACEFS_TIMESTAMP_USECS "common_timestamp.usecs"
> diff --git a/src/tracefs-filter.c b/src/tracefs-filter.c
> index def8f68..43683d0 100644
> --- a/src/tracefs-filter.c
> +++ b/src/tracefs-filter.c
> @@ -745,3 +745,22 @@ int tracefs_event_verify_filter(struct tep_event *event, const char *filter,
>  	free(str);
>  	return 0;
>  }
> +
> +/**
> + * tracefs_event_apply_filter - apply given filter on event in given instance
> + * @instance: The instance in which the filter will be applied (NULL for toplevel).
> + * @event: The event to apply the filter on.
> + * @filter: The filter to apply.
> + *
> + * Apply the @filter to given @event in givem @instance. The @filter string
> + * should be created with tracefs_event_append_filter().

The name of the function has been renamed.

> + *
> + * Returns 0 on succes and -1 on error.
> + */
> +int tracefs_event_apply_filter(struct tracefs_instance *instance,
> +			       struct tep_event *event, const char *filter)
> +{
> +	return tracefs_event_file_append(instance, event->system, event->name,
> +					 "filter", filter);

I think we want this to be tracefs_event_file_write(), as it should replace
the filter, not add on to it.

> +}
> +

Note, I moved the old deprecated names at the end of the file. Make sure
they stay at the end. In other words, this goes before them.

-- Steve
