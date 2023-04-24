Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F66C7618E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Apr 2023 19:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjDXTme (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Apr 2023 15:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjDXTmd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Apr 2023 15:42:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D14E5B88
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Apr 2023 12:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99D4862883
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Apr 2023 19:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD63C433D2;
        Mon, 24 Apr 2023 19:42:30 +0000 (UTC)
Date:   Mon, 24 Apr 2023 15:42:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/3] libtracefs: New API to reset ftrace instance
Message-ID: <20230424154218.41f441f5@rorschach.local.home>
In-Reply-To: <20230328150308.34783-2-tz.stoyanov@gmail.com>
References: <20230328150308.34783-1-tz.stoyanov@gmail.com>
        <20230328150308.34783-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 28 Mar 2023 18:03:06 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Resetting a ftrace instance to its default state is not a trivial task.
> A lot of trace files have to be modified, with different syntaxes and
> in strict order. Although there is such functionality in "trace-cmd
> reset" command, it will be good to have it in the tracefs library as
> well.
> A new API tracefs_instance_reset() is introduced, which resets given
> ftrace instance to its default state. The logic and most of the helper
> functions from "trace-cmd reset" command are copied in the tracefs
> library.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/tracefs-local.h |   1 +
>  include/tracefs.h       |   1 +
>  src/tracefs-instance.c  | 196 ++++++++++++++++++++++++++++++++++++++++
>  src/tracefs-utils.c     |  20 ++++
>  4 files changed, 218 insertions(+)
> 
> diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> index 2007d26..da99a30 100644
> --- a/include/tracefs-local.h
> +++ b/include/tracefs-local.h
> @@ -64,6 +64,7 @@ int trace_get_instance(struct tracefs_instance *instance);
>  /* Can be overridden */
>  void tracefs_warning(const char *fmt, ...);
>  
> +char *strstrip(char *str);
>  int str_read_file(const char *file, char **buffer, bool warn);
>  char *trace_append_file(const char *dir, const char *name);
>  char *trace_find_tracing_dir(bool debugfs);
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 3547b5a..5e9d84b 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -23,6 +23,7 @@ int tracefs_tracing_dir_is_mounted(bool mount, const char **path);
>  struct tracefs_instance;
>  
>  void tracefs_instance_free(struct tracefs_instance *instance);
> +void tracefs_instance_reset(struct tracefs_instance *instance);
>  struct tracefs_instance *tracefs_instance_create(const char *name);
>  struct tracefs_instance *tracefs_instance_alloc(const char *tracing_dir,
>  						const char *name);
> diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
> index 57f5c7f..d3c6581 100644
> --- a/src/tracefs-instance.c
> +++ b/src/tracefs-instance.c
> @@ -1239,3 +1239,199 @@ char *tracefs_instance_get_affinity(struct tracefs_instance *instance)
>  
>  	return set;
>  }
> +
> +static int clear_trigger(const char *file)
> +{
> +	char trigger[BUFSIZ];
> +	char *save = NULL;
> +	char *line;
> +	char *buf;
> +	int size;
> +	int len;
> +	int ret;
> +
> +	size = str_read_file(file, &buf, true);

So this will warn if the file doesn't exist?

Note, this should still work without warning if the kernel is not
configured with triggers enabled. This should only warn if we
established that the trigger file existed before calling this function.

> +	if (size < 1)
> +		return 0;
> +
> +	trigger[0] = '!';
> +
> +	for (line = strtok_r(buf, "\n", &save); line; line = strtok_r(NULL, "\n", &save)) {
> +		if (line[0] == '#')
> +			continue;
> +		len = strlen(line);
> +		if (len > BUFSIZ - 2)
> +			len = BUFSIZ - 2;
> +		strncpy(trigger + 1, line, len);
> +		trigger[len + 1] = '\0';
> +		/* We don't want any filters or extra on the line */
> +		strtok(trigger, " ");
> +		write_file(file, trigger, O_WRONLY);
> +	}
> +
> +	free(buf);
> +
> +	/*
> +	 * Some triggers have an order in removing them.
> +	 * They will not be removed if done in the wrong order.
> +	 */
> +	size = str_read_file(file, &buf, true);
> +	if (size < 1)
> +		return 0;
> +
> +	ret = 0;
> +	for (line = strtok(buf, "\n"); line; line = strtok(NULL, "\n")) {
> +		if (line[0] == '#')
> +			continue;
> +		ret = 1;
> +		break;
> +	}
> +	free(buf);
> +	return ret;
> +}
> +
> +static void disable_func_stack_trace_instance(struct tracefs_instance *instance)
> +{
> +	char *content;
> +	char *cond;
> +	int size;
> +
> +	content = tracefs_instance_file_read(instance, "current_tracer", &size);
> +	if (!content)
> +		return;
> +	cond = strstrip(content);
> +	if (memcmp(cond, "function", size - (cond - content)) != 0)
> +		goto out;
> +
> +	tracefs_option_disable(instance, TRACEFS_OPTION_FUNC_STACKTRACE);
> + out:
> +	free(content);
> +}
> +
> +static void reset_cpu_mask(struct tracefs_instance *instance)
> +{
> +	int cpus = sysconf(_SC_NPROCESSORS_CONF);
> +	int fullwords = (cpus - 1) / 32;
> +	int bits = (cpus - 1) % 32 + 1;
> +	int len = (fullwords + 1) * 9;
> +	char buf[len + 1];
> +
> +	buf[0] = '\0';
> +	sprintf(buf, "%x", (unsigned int)((1ULL << bits) - 1));
> +	while (fullwords-- > 0)
> +		strcat(buf, ",ffffffff");
> +
> +	tracefs_instance_file_write(instance, "tracing_cpumask", buf);
> +}
> +
> +static void clear_func_filter(struct tracefs_instance *instance, const char *file)
> +{
> +	char filter[BUFSIZ];
> +	char *line;
> +	char *buf;
> +	char *p;
> +	int len;
> +
> +	buf = tracefs_instance_file_read(instance, file, NULL);
> +	if (!buf)
> +		return;
> +
> +	/* Now remove filters */
> +	filter[0] = '!';
> +
> +	/*
> +	 * To delete a filter, we need to write a '!filter'
> +	 * to the file for each filter.
> +	 */
> +	for (line = strtok(buf, "\n"); line; line = strtok(NULL, "\n")) {
> +		if (line[0] == '#')
> +			continue;
> +		len = strlen(line);
> +		if (len > BUFSIZ - 2)
> +			len = BUFSIZ - 2;
> +
> +		strncpy(filter + 1, line, len);
> +		filter[len + 1] = '\0';
> +		/*
> +		 * To remove "unlimited" filters, we must remove
> +		 * the ":unlimited" from what we write.
> +		 */
> +		p = strstr(filter, ":unlimited");
> +		if (p) {
> +			*p = '\0';
> +			len = p - filter;
> +		}
> +		/*
> +		 * The write to this file expects white space
> +		 * at the end :-p
> +		 */
> +		filter[len] = '\n';
> +		filter[len+1] = '\0';
> +		tracefs_instance_file_append(instance, file, filter);
> +	}
> +}
> +
> +static void clear_func_filters(struct tracefs_instance *instance)
> +{
> +	int i;
> +	const char * const files[] = { "set_ftrace_filter",
> +				       "set_ftrace_notrace",
> +				       "set_graph_function",
> +				       "set_graph_notrace",

Should also add "stack_trace_filter".

> +				       NULL };
> +
> +	for (i = 0; files[i]; i++)
> +		clear_func_filter(instance, files[i]);
> +}
> +
> +/**
> + * tracefs_instance_reset - Reset a ftrace instance to its default state
> + * @instance - a ftrace instance to be reseted
> + *
> + * The main logic and the helper functions are copied from
> + * trace-cmd/tracecmd/trace-record.c, trace_reset()
> + */
> +void tracefs_instance_reset(struct tracefs_instance *instance)
> +{
> +	char **systems;
> +	char **events;
> +	char *file;
> +	int i, j;
> +
> +	tracefs_trace_off(instance);
> +	disable_func_stack_trace_instance(instance);
> +	tracefs_tracer_clear(instance);
> +	tracefs_instance_file_write(instance, "events/enable", "0");
> +	tracefs_instance_file_write(instance, "set_ftrace_pid", "");
> +	tracefs_instance_file_clear(instance, "trace");
> +
> +	systems = tracefs_event_systems(NULL);
> +	if (systems) {
> +		for (i = 0; systems[i]; i++) {
> +			events = tracefs_system_events(NULL, systems[i]);
> +			if (!events)
> +				continue;
> +			for (j = 0; events[j]; j++) {
> +				file = tracefs_event_get_file(instance, systems[i],
> +							      events[j], "filter");
> +				write_file(file, "0", O_WRONLY | O_TRUNC);
> +				tracefs_put_tracing_file(file);
> +
> +				file = tracefs_event_get_file(instance, systems[i],
> +							      events[j], "trigger");

Here we can test if the file exists before calling clear_trigger().

-- Steve

> +				clear_trigger(file);
> +				tracefs_put_tracing_file(file);
> +			}
> +			tracefs_list_free(events);
> +		}
> +		tracefs_list_free(systems);
> +	}
> +
> +	tracefs_instance_file_write(instance, "error_log", " ");
> +	tracefs_instance_file_write(instance, "trace_clock", "local");
> +	tracefs_instance_file_write(instance, "set_event_pid", "");
> +	reset_cpu_mask(instance);
> +	clear_func_filters(instance);
> +	tracefs_instance_file_write(instance, "tracing_max_latency", "0");
> +	tracefs_trace_on(instance);
> +}
> diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
> index 9acf2ad..ef90677 100644
> --- a/src/tracefs-utils.c
> +++ b/src/tracefs-utils.c
> @@ -319,6 +319,26 @@ void tracefs_put_tracing_file(char *name)
>  	free(name);
>  }
>  
> +/* The function is copied from trace-cmd */
> +__hidden char *strstrip(char *str)
> +{
> +	char *s;
> +
> +	if (!str)
> +		return NULL;
> +
> +	s = str + strlen(str) - 1;
> +	while (s >= str && isspace(*s))
> +		s--;
> +	s++;
> +	*s = '\0';
> +
> +	for (s = str; *s && isspace(*s); s++)
> +		;
> +
> +	return s;
> +}
> +
>  __hidden int str_read_file(const char *file, char **buffer, bool warn)
>  {
>  	char stbuf[BUFSIZ];

