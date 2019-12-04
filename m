Return-Path: <SRS0=XW/z=Z2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 206C1C43603
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Dec 2019 15:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE9962084F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Dec 2019 15:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfLDPAB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 10:00:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbfLDPAB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 10:00:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96F9F2084F;
        Wed,  4 Dec 2019 15:00:00 +0000 (UTC)
Date:   Wed, 4 Dec 2019 09:59:59 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v14 01/19] trace-cmd: Implement new lib API:
 tracecmd_local_events_system()
Message-ID: <20191204095959.6cf18d0f@gandalf.local.home>
In-Reply-To: <20191127140247.258766-2-tz.stoyanov@gmail.com>
References: <20191127140247.258766-1-tz.stoyanov@gmail.com>
        <20191127140247.258766-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 27 Nov 2019 16:02:29 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> 
> The new tracecmd lib API tracecmd_local_events_system() creates
> a tep handler and initializes it with the events of the
> specified subsystems.
> 

This says what the patch does, not why. Why do we want this new lib
routine?

> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  include/trace-cmd/trace-cmd.h |   4 +-
>  lib/trace-cmd/trace-util.c    | 102 +++++++++++++++++++++++-----------
>  2 files changed, 72 insertions(+), 34 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 13afce7..9363a26 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -27,8 +27,10 @@ extern int tracecmd_disable_plugins;
>  char **tracecmd_event_systems(const char *tracing_dir);
>  char **tracecmd_system_events(const char *tracing_dir, const char *system);
>  struct tep_handle *tracecmd_local_events(const char *tracing_dir);
> +struct tep_handle *tracecmd_local_events_system(const char *tracing_dir,
> +						const char * const *sys_names);
>  int tracecmd_fill_local_events(const char *tracing_dir,
> -			       struct tep_handle *pevent, int *parsing_failures);
> +			       struct tep_handle *tep, int *parsing_failures);
>  char **tracecmd_local_plugins(const char *tracing_dir);
>  
>  char **tracecmd_add_list(char **list, const char *name, int len);
> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index 8aa3b6c..311f183 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -613,39 +613,20 @@ static int read_header(struct tep_handle *pevent, const char *events_dir)
>  	return ret;
>  }
>  
> -/**
> - * tracecmd_local_events - create a pevent from the events on system
> - * @tracing_dir: The directory that contains the events.
> - *
> - * Returns a pevent structure that contains the pevents local to
> - * the system.
> - */
> -struct tep_handle *tracecmd_local_events(const char *tracing_dir)
> +static bool contains(const char *name, const char * const *names)
>  {
> -	struct tep_handle *pevent = NULL;
> -
> -	pevent = tep_alloc();
> -	if (!pevent)
> -		return NULL;
> -
> -	if (tracecmd_fill_local_events(tracing_dir, pevent, NULL)) {
> -		tep_free(pevent);
> -		pevent = NULL;
> -	}
> -
> -	return pevent;
> +	if (!names)
> +		return false;
> +	for (; *names; names++)
> +		if (strcmp(name, *names) == 0)
> +			return true;
> +	return false;
>  }
>  
> -/**
> - * tracecmd_fill_local_events - Fill a pevent with the events on system
> - * @tracing_dir: The directory that contains the events.
> - * @pevent: Allocated pevent which will be filled
> - * @parsing_failures: return number of failures while parsing the event files
> - *
> - * Returns whether the operation succeeded
> - */
> -int tracecmd_fill_local_events(const char *tracing_dir,
> -			       struct tep_handle *pevent, int *parsing_failures)
> +static int tracecmd_fill_local_events_system(const char *tracing_dir,
> +					     struct tep_handle *tep,
> +					     const char * const *sys_names,
> +					     int *parsing_failures)
>  {
>  	struct dirent *dent;
>  	char *events_dir;
> @@ -674,7 +655,7 @@ int tracecmd_fill_local_events(const char *tracing_dir,
>  		goto out_free;
>  	}
>  
> -	ret = read_header(pevent, events_dir);
> +	ret = read_header(tep, events_dir);
>  	if (ret < 0) {
>  		ret = -1;
>  		goto out_free;
> @@ -687,7 +668,8 @@ int tracecmd_fill_local_events(const char *tracing_dir,
>  		if (strcmp(name, ".") == 0 ||
>  		    strcmp(name, "..") == 0)
>  			continue;
> -
> +		if (sys_names && !contains(name, sys_names))
> +			continue;
>  		sys = append_file(events_dir, name);
>  		ret = stat(sys, &st);
>  		if (ret < 0 || !S_ISDIR(st.st_mode)) {
> @@ -695,7 +677,7 @@ int tracecmd_fill_local_events(const char *tracing_dir,
>  			continue;
>  		}
>  
> -		ret = load_events(pevent, name, sys);
> +		ret = load_events(tep, name, sys);
>  
>  		free(sys);
>  
> @@ -713,6 +695,60 @@ int tracecmd_fill_local_events(const char *tracing_dir,
>  	return ret;
>  }
>  
> +/**
> + * tracecmd_local_events_system - create a tep from the events of the specified subsystem.

There should be no period at the end.

-- Steve

> + *
> + * @tracing_dir: The directory that contains the events.
> + * @sys_name: Array of system names, to load the events from.
> + * The last element from the array must be NULL
> + *
> + * Returns a tep structure that contains the tep local to
> + * the system.
> + */
> +struct tep_handle *tracecmd_local_events_system(const char *tracing_dir,
> +						const char * const *sys_names)
> +{
> +	struct tep_handle *tep = NULL;
> +
> +	tep = tep_alloc();
> +	if (!tep)
> +		return NULL;
> +
> +	if (tracecmd_fill_local_events_system(tracing_dir, tep, sys_names, NULL)) {
> +		tep_free(tep);
> +		tep = NULL;
> +	}
> +
> +	return tep;
> +}
> +
> +/**
> + * tracecmd_local_events - create a pevent from the events on system
> + * @tracing_dir: The directory that contains the events.
> + *
> + * Returns a pevent structure that contains the pevents local to
> + * the system.
> + */
> +struct tep_handle *tracecmd_local_events(const char *tracing_dir)
> +{
> +	return tracecmd_local_events_system(tracing_dir, NULL);
> +}
> +
> +/**
> + * tracecmd_fill_local_events - Fill a pevent with the events on system
> + * @tracing_dir: The directory that contains the events.
> + * @tep: Allocated tep handler which will be filled
> + * @parsing_failures: return number of failures while parsing the event files
> + *
> + * Returns whether the operation succeeded
> + */
> +int tracecmd_fill_local_events(const char *tracing_dir,
> +			       struct tep_handle *tep, int *parsing_failures)
> +{
> +	return tracecmd_fill_local_events_system(tracing_dir, tep,
> +						 NULL, parsing_failures);
> +}
> +
>  /**
>   * tracecmd_local_plugins - returns an array of available tracer plugins
>   * @tracing_dir: The directory that contains the tracing directory

