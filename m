Return-Path: <SRS0=s3Jp=26=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF5DC33CA2
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 02:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C72B720705
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 02:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgAICdB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jan 2020 21:33:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgAICdB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 21:33:01 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1211020705;
        Thu,  9 Jan 2020 02:32:59 +0000 (UTC)
Date:   Wed, 8 Jan 2020 21:32:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] trace-cmd,kernel-shark: New libtracefs APIs for
 ftrace events and systems
Message-ID: <20200108213258.58661595@rorschach.local.home>
In-Reply-To: <20200106154058.60660-5-tz.stoyanov@gmail.com>
References: <20200106154058.60660-1-tz.stoyanov@gmail.com>
        <20200106154058.60660-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  6 Jan 2020 17:40:57 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +static char **add_list_string(char **list, const char *name, int len)
> +{
> +	if (!list)
> +		list = malloc(sizeof(*list) * 2);
> +	else
> +		list = realloc(list, sizeof(*list) * (len + 2));

I know this was copied from my old code, but this is to document that
we need to add another patch (separate patch, to keep this patch as
more of a move), but the above really should just be:

	list = realloc(list, sizeof(*list) * (len + 2));

as realloc is malloc when the first parameter is NULL.


> +	if (!list)
> +		return NULL;
> +
> +	list[len] = strdup(name);
> +	if (!list[len])
> +		return NULL;
> +
> +	list[len + 1] = NULL;
> +
> +	return list;
> +}
> +
> +static char *append_file(const char *dir, const char *name)
> +{
> +	char *file;
> +	int ret;
> +
> +	ret = asprintf(&file, "%s/%s", dir, name);
> +
> +	return ret < 0 ? NULL : file;
> +}
> +
> +/**
> + * tracefs_event_systems - return list of systems for tracing
> + * @tracing_dir: directory holding the "events" directory
> + *		 if NULL, top tracing directory is used
> + *
> + * Returns an allocated list of system names. Both the names and
> + * the list must be freed with free()
> + * The list returned ends with a "NULL" pointer

We really should have a helper function to free this list. Perhaps we
should call it: tracefs_list_free()?

> + */
> +char **tracefs_event_systems(const char *tracing_dir)
> +{
> +	struct dirent *dent;
> +	char **systems = NULL;
> +	char *events_dir;
> +	struct stat st;
> +	DIR *dir;
> +	int len = 0;
> +	int ret;
> +
> +	if (!tracing_dir)
> +		tracing_dir = tracefs_get_tracing_dir();
> +
> +	if (!tracing_dir)
> +		return NULL;
> +
> +	events_dir = append_file(tracing_dir, "events");
> +	if (!events_dir)
> +		return NULL;
> +
> +	/*
> +	 * Search all the directories in the events directory,
> +	 * and collect the ones that have the "enable" file.
> +	 */
> +	ret = stat(events_dir, &st);
> +	if (ret < 0 || !S_ISDIR(st.st_mode))
> +		goto out_free;
> +
> +	dir = opendir(events_dir);
> +	if (!dir)
> +		goto out_free;
> +
> +	while ((dent = readdir(dir))) {
> +		const char *name = dent->d_name;
> +		char *enable;
> +		char *sys;
> +
> +		if (strcmp(name, ".") == 0 ||
> +		    strcmp(name, "..") == 0)
> +			continue;
> +
> +		sys = append_file(events_dir, name);
> +		ret = stat(sys, &st);
> +		if (ret < 0 || !S_ISDIR(st.st_mode)) {
> +			free(sys);
> +			continue;
> +		}
> +
> +		enable = append_file(sys, "enable");
> +
> +		ret = stat(enable, &st);
> +		if (ret >= 0)
> +			systems = add_list_string(systems, name, len++);
> +
> +		free(enable);
> +		free(sys);
> +	}
> +
> +	closedir(dir);
> +
> + out_free:
> +	free(events_dir);
> +	return systems;
> +}
> +
> +/**
> + * tracefs_system_events - return list of events for system
> + * @tracing_dir: directory holding the "events" directory
> + * @system: the system to return the events for
> + *
> + * Returns an allocated list of event names. Both the names and
> + * the list must be freed with free()
> + * The list returned ends with a "NULL" pointer

And have this free with tracefs_list_free() too.

> + */
> +char **tracefs_system_events(const char *tracing_dir, const char *system)
> +{
> +	struct dirent *dent;
> +	char **events = NULL;
> +	char *system_dir = NULL;
> +	struct stat st;
> +	DIR *dir;
> +	int len = 0;
> +	int ret;
> +
> +	if (!tracing_dir)
> +		tracing_dir = tracefs_get_tracing_dir();
> +
> +	if (!tracing_dir || !system)
> +		return NULL;
> +
> +	asprintf(&system_dir, "%s/events/%s", tracing_dir, system);
> +	if (!system_dir)
> +		return NULL;
> +
> +	ret = stat(system_dir, &st);
> +	if (ret < 0 || !S_ISDIR(st.st_mode))
> +		goto out_free;
> +
> +	dir = opendir(system_dir);
> +	if (!dir)
> +		goto out_free;
> +
> +	while ((dent = readdir(dir))) {
> +		const char *name = dent->d_name;
> +		char *enable;
> +		char *event;
> +
> +		if (strcmp(name, ".") == 0 ||
> +		    strcmp(name, "..") == 0)
> +			continue;
> +
> +		event = append_file(system_dir, name);
> +		ret = stat(event, &st);
> +		if (ret < 0 || !S_ISDIR(st.st_mode)) {
> +			free(event);
> +			continue;
> +		}
> +
> +		enable = append_file(event, "enable");
> +
> +		ret = stat(enable, &st);
> +		if (ret >= 0)
> +			events = add_list_string(events, name, len++);
> +
> +		free(enable);
> +		free(event);
> +	}
> +
> +	closedir(dir);
> +
> + out_free:
> +	free(system_dir);
> +
> +	return events;
> +}
> +
> +/**
> + * tracefs_local_plugins - returns an array of available tracer plugins

Let's not call this "local_plugins" as the name is a misnomer (what
they were called back in 2010, but are no longer called that). Let's
change this to their real name:

	tracefs_tracers()


-- Steve

> + * @tracing_dir: The directory that contains the tracing directory
> + *
> + * Returns an allocate list of plugins. The array ends with NULL
> + * Both the plugin names and array must be freed with free()
> + */
> +char **tracefs_local_plugins(const char *tracing_dir)
> +{
> +	char *available_tracers;
> +	struct stat st;
> +	char **plugins = NULL;
> +	char *buf;
> +	char *str, *saveptr;
> +	char *plugin;
> +	int slen;
> +	int len;
> +	int ret;
> +
> +	if (!tracing_dir)
> +		return NULL;
> +
> +	available_tracers = append_file(tracing_dir, "available_tracers");
> +	if (!available_tracers)
> +		return NULL;
> +
> +	ret = stat(available_tracers, &st);
> +	if (ret < 0)
> +		goto out_free;
> +
> +	len = str_read_file(available_tracers, &buf);
> +	if (len < 0)
> +		goto out_free;
> +
> +	len = 0;
> +	for (str = buf; ; str = NULL) {
> +		plugin = strtok_r(str, " ", &saveptr);
> +		if (!plugin)
> +			break;
> +		slen = strlen(plugin);
> +		if (!slen)
> +			continue;
> +
> +		/* chop off any newlines */
> +		if (plugin[slen - 1] == '\n')
> +			plugin[slen - 1] = '\0';
> +
> +		/* Skip the non tracers */
> +		if (strcmp(plugin, "nop") == 0 ||
> +		    strcmp(plugin, "none") == 0)
> +			continue;
> +
> +		plugins = add_list_string(plugins, plugin, len++);
> +	}
> +	free(buf);
> +
> + out_free:
> +	free(available_tracers);
> +
> +	return plugins;
> +}
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 62f67d5..1d91e87 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -4178,7 +4178,7 @@ find_ts_in_page(struct tep_handle *pevent, void *page, int size)
>  		return 0;
>  
>  	while (!ts) {
> -		record = tracecmd_read_page_record(pevent, page, size,
> +		record = tracefs_read_page_record(pevent, page, size,
>  						   last_record);
>  		if (!record)
>  			break;

