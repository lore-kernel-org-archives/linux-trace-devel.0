Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D309C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 15:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BBE22070B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 15:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfBVPvM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 10:51:12 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54408 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfBVPvM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 10:51:12 -0500
Received: by mail-wm1-f66.google.com with SMTP id a62so2395664wmh.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 07:51:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ByDOzknRnfNq1zTV1bzq+PWszxOdxfZUR+6DC3OTlYw=;
        b=GsD8CRWgJAZQPr9aJDqLOsdoLomIZ6k4FMWQZCgW5zoNs/hfAwAPBZM9Rym3U5XmMl
         ABsC6M5grhdneBTrl9WTBfUNKUqb7Uk42OzlgLpJTl32qCXFgYrGIS9Y8hg/e2vFRckL
         2zcY3zxCtpv7k8vXMosaqYnKM05urgIMlxJJ2d31sVPN3pl0kp4XivkT2eRVOKr54//H
         EjXG5Lx8S5ei1HgOrko2xY6bOiMGCODQeHRI8nYDz7r2lgsY/DzHroa687zMVKcXqI9n
         XMu4WH/FEklTwaZfpur1BM8R9kB8T8Al+36+yMTYKhOeIwvrKK1WtYvv7dtYJcMTY3mb
         oWQQ==
X-Gm-Message-State: AHQUAuZvQp191cWADuszITktznMM5UTB9fMYuKdL+sA1tis5A4MV9h0e
        QYB2FJEGQUTObvkoVtzlrg==
X-Google-Smtp-Source: AHgI3Ibeurvh/2PyzpoXW3BTE80HVj0NXhpuBFeOMoEo8Fhuav3eNgrRvTOY0fxmpi6WcYMWGNCQPw==
X-Received: by 2002:a1c:700a:: with SMTP id l10mr3162843wmc.13.1550850670458;
        Fri, 22 Feb 2019 07:51:10 -0800 (PST)
Received: from box ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id 65sm2516162wrb.62.2019.02.22.07.51.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 22 Feb 2019 07:51:09 -0800 (PST)
Date:   Fri, 22 Feb 2019 17:51:04 +0200
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 1/7] trace-cmd: Implemented new lib API:
 tracecmd_local_events_system()
Message-ID: <20190222155100.GA14440@box>
References: <20190222142836.12596-1-tstoyanov@vmware.com>
 <20190222142836.12596-2-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190222142836.12596-2-tstoyanov@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Feb 22, 2019 at 04:28:30PM +0200, Tzvetomir Stoyanov wrote:
> The new tracecmd lib API tracecmd_local_events_system() creates
> a tep handler and initializes it with the events of the
> specified subsystems.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  include/trace-cmd/trace-cmd.h |  2 +
>  lib/trace-cmd/trace-util.c    | 99 +++++++++++++++++++++++------------
>  2 files changed, 68 insertions(+), 33 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 27ba89d..0067882 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -32,6 +32,8 @@ void tracecmd_unload_plugins(struct tep_plugin_list *list, struct tep_handle *pe
>  char **tracecmd_event_systems(const char *tracing_dir);
>  char **tracecmd_system_events(const char *tracing_dir, const char *system);
>  struct tep_handle *tracecmd_local_events(const char *tracing_dir);
> +struct tep_handle *tracecmd_local_events_system(const char *tracing_dir,
> +						char **sys_names);

Can we have sys_names be `const char **` to imply that it's not getting modified
in here?

>  int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *pevent);
>  char **tracecmd_local_plugins(const char *tracing_dir);
>  
> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index b5aea39..0e925ed 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -1119,43 +1119,15 @@ static int read_header(struct tep_handle *pevent, const char *events_dir)
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
> -{
> -	struct tep_handle *pevent = NULL;
> -
> -	pevent = tep_alloc();
> -	if (!pevent)
> -		return NULL;
> -
> -	if (tracecmd_fill_local_events(tracing_dir, pevent)) {
> -		tep_free(pevent);
> -		pevent = NULL;
> -	}
> -
> -	return pevent;
> -}
> -
> -/**
> - * tracecmd_fill_local_events - Fill a pevent with the events on system
> - * @tracing_dir: The directory that contains the events.
> - * @pevent: Allocated pevent which will be filled
> - *
> - * Returns whether the operation succeeded
> - */
> -int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *pevent)
> +static int tracecmd_fill_local_events_system(const char *tracing_dir,
> +					     struct tep_handle *pevent,
> +					     char **sys_names)
>  {
> +	int ret, i, failure = 0;
>  	struct dirent *dent;
>  	char *events_dir;
>  	struct stat st;
>  	DIR *dir;
> -	int ret, failure = 0;
>  
>  	if (!tracing_dir)
>  		return -1;
> @@ -1189,7 +1161,16 @@ int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *peven
>  		if (strcmp(name, ".") == 0 ||
>  		    strcmp(name, "..") == 0)
>  			continue;
> -
> +		if (sys_names) {
> +			i = 0;
> +			while (sys_names[i]) {
> +				if (strcmp(name, sys_names[i]) == 0)
> +					break;
> +				i++;
> +			}
> +			if (sys_names[i] == NULL)
> +				continue;
> +		}

I think this would be better done in a separate function, say:

static bool contains(const char *name, const char **names)
{
	while (*names) {
		if (strcmp(name, *names++) == 0)
			return true;
	}
	return false;
}

and then simply have

if (sys_names && !contains(name, sys_names))
	continue;

here.

>  		sys = append_file(events_dir, name);
>  		ret = stat(sys, &st);
>  		if (ret < 0 || !S_ISDIR(st.st_mode)) {
> @@ -1217,6 +1198,58 @@ int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *peven
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
> +						char **sys_names)
> +{
> +	struct tep_handle *tep = NULL;
> +
> +	tep = tep_alloc();
> +	if (!tep)
> +		return NULL;
> +
> +	if (tracecmd_fill_local_events_system(tracing_dir, tep, sys_names)) {
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
> + *
> + * Returns whether the operation succeeded
> + */
> +int tracecmd_fill_local_events(const char *tracing_dir,
> +			       struct tep_handle *pevent)
> +{
> +	return tracecmd_fill_local_events_system(tracing_dir, pevent, NULL);
> +}
> +
>  /**
>   * tracecmd_local_plugins - returns an array of available tracer plugins
>   * @tracing_dir: The directory that contains the tracing directory
> -- 
> 2.20.1
> 
