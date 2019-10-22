Return-Path: <SRS0=a4XR=YP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A0EBCA9EBA
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Oct 2019 16:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEFA320B7C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Oct 2019 16:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389471AbfJVQeE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 12:34:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389468AbfJVQeE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 12:34:04 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C904820B7C;
        Tue, 22 Oct 2019 16:34:02 +0000 (UTC)
Date:   Tue, 22 Oct 2019 12:34:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v12 1/9] trace-cmd: Implemented new lib API:
 tracecmd_local_events_system()
Message-ID: <20191022123401.4e2b1ab6@gandalf.local.home>
In-Reply-To: <20190828085746.26231-2-tz.stoyanov@gmail.com>
References: <20190828085746.26231-1-tz.stoyanov@gmail.com>
        <20190828085746.26231-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Aug 2019 11:57:38 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Hi Ceco,

Nit on the subject. s/Implemented/Implement/. Same for all the other
patches.

> 
> The new tracecmd lib API tracecmd_local_events_system() creates
> a tep handler and initializes it with the events of the
> specified subsystems.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  include/trace-cmd/trace-cmd.h |  2 +
>  lib/trace-cmd/trace-util.c    | 98 ++++++++++++++++++++++++-----------
>  2 files changed, 69 insertions(+), 31 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 9a984c1..da29d53 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -32,6 +32,8 @@ void tracecmd_unload_plugins(struct tep_plugin_list *list, struct tep_handle *pe
>  char **tracecmd_event_systems(const char *tracing_dir);
>  char **tracecmd_system_events(const char *tracing_dir, const char *system);
>  struct tep_handle *tracecmd_local_events(const char *tracing_dir);
> +struct tep_handle *tracecmd_local_events_system(const char *tracing_dir,
> +						const char * const *sys_names);
>  int tracecmd_fill_local_events(const char *tracing_dir,
>  			       struct tep_handle *pevent, int *parsing_failures);
>  char **tracecmd_local_plugins(const char *tracing_dir);
> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index d3bb333..9ccf3b3 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -1120,39 +1120,20 @@ static int read_header(struct tep_handle *pevent, const char *events_dir)
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

OK, if name is NULL, then we return false.

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
> +					     struct tep_handle *pevent,
> +					     const char * const *sys_names,
> +					     int *parsing_failures)
>  {
>  	struct dirent *dent;
>  	char *events_dir;
> @@ -1194,7 +1175,8 @@ int tracecmd_fill_local_events(const char *tracing_dir,
>  		if (strcmp(name, ".") == 0 ||
>  		    strcmp(name, "..") == 0)
>  			continue;
> -
> +		if (!contains(name, sys_names))
> +			continue;

Hmm, doesn't this mean that when we pass in NULL for sys_names, we
don't list anything?


>  		sys = append_file(events_dir, name);
>  		ret = stat(sys, &st);
>  		if (ret < 0 || !S_ISDIR(st.st_mode)) {
> @@ -1220,6 +1202,60 @@ int tracecmd_fill_local_events(const char *tracing_dir,
>  	return ret;
>  }
>  
> +/**
> + * tracecmd_local_events_system - create a tep from the events of the specified subsystem.
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
> + * @pevent: Allocated pevent which will be filled
> + * @parsing_failures: return number of failures while parsing the event files
> + *
> + * Returns whether the operation succeeded
> + */
> +int tracecmd_fill_local_events(const char *tracing_dir,
> +			       struct tep_handle *pevent, int *parsing_failures)

When we touch a function, we should s/pevent/tep/

> +{
> +	return tracecmd_fill_local_events_system(tracing_dir, pevent,
> +						 NULL, parsing_failures);

Won't this return no events?

-- Steve

> +}
> +
>  /**
>   * tracecmd_local_plugins - returns an array of available tracer plugins
>   * @tracing_dir: The directory that contains the tracing directory

