Return-Path: <SRS0=7UrD=DV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3BAC433E7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Oct 2020 23:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 876AF214D8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Oct 2020 23:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgJNXwy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 19:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbgJNXwy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 19:52:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C2B3208D5;
        Wed, 14 Oct 2020 23:52:51 +0000 (UTC)
Date:   Wed, 14 Oct 2020 19:52:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 13/20] kernel-shark: Complete the stream integration
Message-ID: <20201014195249.16929c28@gandalf.local.home>
In-Reply-To: <20201012133523.469040-14-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
        <20201012133523.469040-14-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


> diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
> index 30c383c8..d9d57843 100644
> --- a/src/libkshark-tepdata.c
> +++ b/src/libkshark-tepdata.c
> @@ -318,6 +318,9 @@ static ssize_t get_records(struct kshark_context *kshark_ctx,
>  
>  				pid = entry->pid;
>  
> +				/* Apply Id filtering. */
> +				kshark_apply_filters(kshark_ctx, stream, entry);
> +
>  				/* Apply advanced event filtering. */
>  				if (adv_filter && adv_filter->filters &&
>  				    tep_filter_match(adv_filter, rec) != FILTER_MATCH)
> @@ -1160,6 +1163,43 @@ out:
>  	return peer_handle;
>  }
>  
> +/** A list of built in default plugins for FTRACE (trace-cmd) data. */
> +const char *tep_plugin_names[] = {
> +	"sched_events",
> +	"missed_events",
> +	"kvm_combo",
> +};
> +
> +/**
> + * Register to the data stream all default plugins for FTRACE (trace-cmd) data.
> + */
> +int kshark_tep_handle_plugins(struct kshark_context *kshark_ctx, int sd)
> +{
> +	int i, n_tep_plugins = sizeof(tep_plugin_names) / sizeof (const char *);


Note, a safer way is:

	n_tep_plugins = sizeof(tep_plugins_names) / sizeof(tep_plugin_names[0]);

Or use the ARRAY_SIZE() macro from trace-cmd.git/include/trace-cmd/trace-cmd.h:

#define ARRAY_SIZE(_a) (sizeof(_a) / sizeof((_a)[0]))

	n_tep_plugins = ARRAY_SIZE(tep_plugins_names);

  ;-)


> +	struct kshark_plugin_list *plugin;
> +	struct kshark_data_stream *stream;
> +
> +	stream = kshark_get_data_stream(kshark_ctx, sd);
> +	if (!stream)
> +		return -EEXIST;
> +
> +	for (i = 0; i < n_tep_plugins; ++i) {
> +		plugin = kshark_find_plugin_by_name(kshark_ctx->plugins,
> +						    tep_plugin_names[i]);
> +
> +		if (plugin && plugin->process_interface) {
> +			kshark_register_plugin_to_stream(stream,
> +							 plugin->process_interface,
> +							 true);
> +		} else {
> +			fprintf(stderr, "Plugin \"%s\" not found.\n",
> +				tep_plugin_names[i]);
> +		}
> +	}
> +
> +	return kshark_handle_all_dpis(stream, KSHARK_PLUGIN_INIT);
> +}
> +
>  /** The Process Id of the Idle tasks is zero. */
>  #define LINUX_IDLE_TASK_PID	0
>  
> @@ -1210,6 +1250,172 @@ static int kshark_tep_stream_init(struct kshark_data_stream *stream,
>  	return -EFAULT;
>  }
>  
> +static struct tracecmd_input *get_top_input(struct kshark_context *kshark_ctx,
> +					    int sd)
> +{
> +	struct kshark_data_stream *top_stream;
> +
> +	top_stream = kshark_get_data_stream(kshark_ctx, sd);
> +	if (!top_stream)
> +		return NULL;
> +
> +	return kshark_get_tep_input(top_stream);
> +}
> +
> +/**
> + * @brief Get an array containing the names of all buffers in FTRACE data
> + *	  file.
> + *
> + * @param kshark_ctx: Input location for context pointer.
> + * @param sd: Data stream identifier of the top buffers in the FTRACE data
> + *	  file.
> + * @param n_buffers: Output location for the size of the outputted array,
> + *	    or a negative error code on failure.
> + *
> + * @returns Array of strings on success, or NULL on failure. The user is
> + *	    responsible for freeing the elements of the outputted array.
> + */
> +char **kshark_tep_get_buffer_names(struct kshark_context *kshark_ctx, int sd,
> +				   int *n_buffers)
> +{
> +	struct tracecmd_input *top_input;
> +	char **buffer_names;
> +	int i, n;
> +
> +	top_input = get_top_input(kshark_ctx, sd);
> +	if (!top_input) {
> +		*n_buffers = -EFAULT;
> +		return NULL;
> +	}
> +
> +	n = tracecmd_buffer_instances(top_input);
> +	buffer_names = malloc(n * sizeof(char *));

Need to check buffer_names.

> +
> +	for (i = 0; i < n; ++i)
> +		buffer_names[i] =
> +			strdup(tracecmd_buffer_instance_name(top_input, i));
> +

And each buffer_names[i].

> +	*n_buffers = n;
> +	return buffer_names;
> +}
> +
> +static void set_stream_fields(struct tracecmd_input *top_input, int i,
> +			      const char *file,
> +			      const char *name,
> +			      struct kshark_data_stream *buffer_stream,
> +			      struct tracecmd_input **buffer_input)
> +{
> +	*buffer_input = tracecmd_buffer_instance_handle(top_input, i);
> +
> +	buffer_stream->name = strdup(name);
> +	buffer_stream->file = strdup(file);

And the ->name and ->file.

> +	buffer_stream->format = KS_TEP_DATA;
> +}
> +
> +/**
> + * @brief Open a given buffers in FTRACE (trace-cmd) data file.
> + *
> + * @param kshark_ctx: Input location for context pointer.
> + * @param sd: Data stream identifier of the top buffers in the FTRACE data
> + *	  file.
> + * @param buffer_name: The name of the buffer to open.
> + *
> + * @returns Data stream identifier of the buffer on success. Otherwise a
> + *	    negative error code.
> + */
> +int kshark_tep_open_buffer(struct kshark_context *kshark_ctx, int sd,
> +			   const char *buffer_name)
> +{
> +	struct kshark_data_stream *top_stream, *buffer_stream;
> +	struct tracecmd_input *top_input, *buffer_input;
> +	int i, sd_buffer, n_buffers, ret = -ENODATA;
> +	char **names;
> +
> +	top_stream = kshark_get_data_stream(kshark_ctx, sd);
> +	if (!top_stream)
> +		return -EFAULT;
> +
> +	top_input = kshark_get_tep_input(top_stream);
> +	if (!top_input)
> +		return -EFAULT;
> +
> +	names = kshark_tep_get_buffer_names(kshark_ctx, sd, &n_buffers);
> +
> +	sd_buffer = kshark_add_stream(kshark_ctx);
> +	buffer_stream = kshark_get_data_stream(kshark_ctx, sd_buffer);
> +	if (!buffer_stream)
> +		return -EFAULT;
> +
> +	for (i = 0; i < n_buffers; ++i) {
> +		if (strcmp(buffer_name, names[i]) == 0) {
> +			set_stream_fields(top_input, i,
> +					  top_stream->file,
> +					  buffer_name,
> +					  buffer_stream,
> +					  &buffer_input);
> +
> +			ret = kshark_tep_stream_init(buffer_stream,
> +						     buffer_input);
> +			break;
> +		}
> +	}
> +
> +	for (i = 0; i < n_buffers; ++i)
> +		free(names[i]);
> +	free(names);
> +
> +	return (ret < 0)? ret : buffer_stream->stream_id;
> +}
> +
> +/**
> + * @brief Initialize data streams for all buffers in a FTRACE (trace-cmd) data
> + *	  file.
> + *
> + * @param kshark_ctx: Input location for context pointer.
> + * @param sd: Data stream identifier of the top buffers in the FTRACE data
> + *	  file.
> + *
> + * @returns The total number of data streams initialized on success. Otherwise
> + *	    a negative error code.
> + */
> +int kshark_tep_init_all_buffers(struct kshark_context *kshark_ctx,
> +				int sd)
> +{
> +	struct kshark_data_stream *top_stream, *buffer_stream;
> +	struct tracecmd_input *buffer_input;
> +	struct tracecmd_input *top_input;
> +	int i, n_buffers, sd_buffer, ret;
> +
> +	top_stream = kshark_get_data_stream(kshark_ctx, sd);
> +	if (!top_stream)
> +		return -EFAULT;
> +
> +	top_input = kshark_get_tep_input(top_stream);
> +	if (!top_input)
> +		return -EFAULT;
> +
> +	n_buffers = tracecmd_buffer_instances(top_input);
> +	for (i = 0; i < n_buffers; ++i) {
> +		sd_buffer = kshark_add_stream(kshark_ctx);
> +		if (sd_buffer < 0)
> +			return -EFAULT;
> +
> +		buffer_stream = kshark_ctx->stream[sd_buffer];
> +
> +		set_stream_fields(top_input, i,
> +				  top_stream->file,
> +				  tracecmd_buffer_instance_name(top_input, i),
> +				  buffer_stream,
> +				  &buffer_input);
> +
> +		ret = kshark_tep_stream_init(buffer_stream, buffer_input);
> +		if (ret != 0)
> +			return -EFAULT;
> +	}
> +
> +	return n_buffers;
> +}
> +
>  /** Initialize the FTRACE data input (from file). */
>  int kshark_tep_init_input(struct kshark_data_stream *stream,
>  			  const char *file)
> @@ -1389,3 +1595,149 @@ char **kshark_tracecmd_local_plugins()
>  {
>  	return tracefs_tracers(tracefs_get_tracing_dir());
>  }
> +
> +/**
> + * @brief Free an array, allocated by kshark_tracecmd_get_hostguest_mapping() API
> + *
> + *
> + * @param map: Array, allocated by kshark_tracecmd_get_hostguest_mapping() API
> + * @param count: Number of entries in the array
> + *
> + */
> +void kshark_tracecmd_free_hostguest_map(struct kshark_host_guest_map *map, int count)
> +{
> +	int i;
> +
> +	if (!map)
> +		return;
> +	for (i = 0; i < count; i++) {
> +		free(map[i].guest_name);
> +		free(map[i].cpu_pid);
> +		memset(&map[i], 0, sizeof(*map));
> +	}
> +	free(map);
> +}
> +
> +/**
> + * @brief Get mapping of guest VCPU to host task, running that VCPU.
> + *	  Array of mappings for each guest is allocated and returned
> + *	  in map input parameter.
> + *
> + *
> + * @param map: Returns allocated array of kshark_host_guest_map structures, each
> + *	       one describing VCPUs mapping of one guest.
> + *
> + * @return The number of entries in the *map array, or a negative error code on
> + *	   failure.
> + */
> +int kshark_tracecmd_get_hostguest_mapping(struct kshark_host_guest_map **map)
> +{
> +	struct kshark_host_guest_map *gmap = NULL;
> +	struct tracecmd_input *peer_handle = NULL;
> +	struct kshark_data_stream *peer_stream;
> +	struct tracecmd_input *guest_handle = NULL;
> +	struct kshark_data_stream *guest_stream;
> +	struct kshark_context *kshark_ctx = NULL;
> +	unsigned long long trace_id;
> +	const char *name;
> +	int vcpu_count;
> +	const int *cpu_pid;
> +	int *stream_ids;
> +	int i, j, k;
> +	int count = 0;
> +	int ret;
> +
> +	if (!map || !kshark_instance(&kshark_ctx))
> +		return -EFAULT;
> +	if (*map)
> +		return -EEXIST;
> +
> +	stream_ids = kshark_all_streams(kshark_ctx);
> +	for (i = 0; i < kshark_ctx->n_streams; i++) {
> +		guest_stream = kshark_get_data_stream(kshark_ctx, stream_ids[i]);
> +		if (!guest_stream || guest_stream->format != KS_TEP_DATA)
> +			continue;
> +		guest_handle = kshark_get_tep_input(guest_stream);
> +		if (!guest_handle)
> +			continue;
> +		trace_id = tracecmd_get_traceid(guest_handle);
> +		if (!trace_id)
> +			continue;
> +		for (j = 0; j < kshark_ctx->n_streams; j++) {
> +			if (stream_ids[i] == stream_ids[j])
> +				continue;
> +			peer_stream = kshark_get_data_stream(kshark_ctx, stream_ids[j]);
> +			if (!peer_stream || peer_stream->format != KS_TEP_DATA)
> +				continue;
> +			peer_handle = kshark_get_tep_input(peer_stream);
> +			if (!peer_handle)
> +				continue;
> +			ret = tracecmd_get_guest_cpumap(peer_handle, trace_id,
> +							&name, &vcpu_count, &cpu_pid);
> +			if (!ret && vcpu_count) {
> +				gmap = realloc(*map,
> +					       (count + 1) * sizeof(struct kshark_host_guest_map));
> +				if (!gmap)
> +					goto mem_error;
> +				*map = gmap;
> +				memset(&gmap[count], 0, sizeof(struct kshark_host_guest_map));
> +				count++;
> +				gmap[count - 1].guest_id = stream_ids[i];
> +				gmap[count - 1].host_id = stream_ids[j];
> +				gmap[count - 1].guest_name = strdup(name);
> +				if (!gmap[count - 1].guest_name)
> +					goto mem_error;
> +				gmap[count - 1].vcpu_count = vcpu_count;
> +				gmap[count - 1].cpu_pid = malloc(sizeof(int) * vcpu_count);
> +				if (!gmap[count - 1].cpu_pid)
> +					goto mem_error;
> +				for (k = 0; k < vcpu_count; k++)
> +					gmap[count - 1].cpu_pid[k] = cpu_pid[k];
> +				break;
> +			}
> +		}
> +	}
> +
> +	free(stream_ids);
> +	return count;
> +
> +mem_error:
> +	free(stream_ids);
> +	if (*map) {
> +		kshark_tracecmd_free_hostguest_map(*map, count);
> +		*map = NULL;
> +	}
> +
> +	return -ENOMEM;
> +}
> +
> +/**
> + * @brief Find the data stream corresponding the top buffer of a FTRACE
> + *	  (trace-cmd) data file.
> + *
> + * @param kshark_ctx: Input location for context pointer.
> + * @param file: The name of the file.
> + *
> + * @returns Data stream identifier of the top buffers in the FTRACE data
> + *	    fileon success. Otherwise a negative error code.
> + */
> +int kshark_tep_find_top_stream(struct kshark_context *kshark_ctx,
> +			       const char *file)
> +{
> +	struct kshark_data_stream *top_stream = NULL, *stream;
> +	int i, *stream_ids = kshark_all_streams(kshark_ctx);
> +
> +	for (i = 0; i < kshark_ctx->n_streams; ++i) {
> +		stream = kshark_ctx->stream[stream_ids[i]];
> +		if (strcmp(stream->file, file) == 0 &&
> +		    strcmp(stream->name, "top") == 0)

I noticed that you hardcode the top_stream name as "top". A couple of
comments. One, good software practice is not to have any open constants.
That is, always use a macro, as it makes it easier to go global changes
later on. Also, don't call it "top". What happens if I make an instance
called "top". Will it confuse this?

Maybe make it a non printable character:

const char top_name[] = { 0x1b, 0x00 }; // Non printable character
#define TOP_NAME	(char *)&top_name

Or something like this.


> +			top_stream = stream;
> +	}
> +
> +	free(stream_ids);
> +
> +	if (!top_stream)
> +		return -EEXIST;
> +
> +	return top_stream->stream_id;
> +}
> diff --git a/src/libkshark-tepdata.h b/src/libkshark-tepdata.h
> index a2bd211e..b6c9439e 100644
> --- a/src/libkshark-tepdata.h
> +++ b/src/libkshark-tepdata.h
> @@ -41,9 +41,58 @@ void kshark_tep_filter_reset(struct kshark_data_stream *stream);
>  
>  char **kshark_tracecmd_local_plugins();
>  
> +struct tep_handle;
> +
> +struct tep_handle *kshark_get_tep(struct kshark_data_stream *stream);
> +
> +struct tracecmd_input;
> +
> +struct tracecmd_input *kshark_get_tep_input(struct kshark_data_stream *stream);
> +
> +struct tep_record;
> +
>  ssize_t kshark_load_tep_records(struct kshark_context *kshark_ctx, int sd,
>  				struct tep_record ***data_rows);
>  
> +/**
> + * Structure representing the mapping between the virtual CPUs and their
> + * corresponding processes in the host.
> + */
> +struct kshark_host_guest_map {
> +	/** ID of guest stream */
> +	int guest_id;
> +
> +	/** ID of host stream */
> +	int host_id;
> +
> +	/** Guest name */
> +	char *guest_name;
> +
> +	/** Number of guest's CPUs in *cpu_pid array */
> +	int vcpu_count;
> +
> +	/** Array of host task PIDs, index is the VCPU id */
> +	int *cpu_pid;
> +};
> +
> +void kshark_tracecmd_free_hostguest_map(struct kshark_host_guest_map *map,
> +					int count);
> +
> +int kshark_tracecmd_get_hostguest_mapping(struct kshark_host_guest_map **map);
> +
> +char **kshark_tep_get_buffer_names(struct kshark_context *kshark_ctx, int sd,
> +				   int *n_buffers);
> +
> +int kshark_tep_open_buffer(struct kshark_context *kshark_ctx, int sd,
> +			   const char *buffer_name);
> +
> +int kshark_tep_init_all_buffers(struct kshark_context *kshark_ctx, int sd);
> +
> +int kshark_tep_handle_plugins(struct kshark_context *kshark_ctx, int sd);
> +
> +int kshark_tep_find_top_stream(struct kshark_context *kshark_ctx,
> +			       const char *file);
> +
>  #ifdef __cplusplus
>  }
>  #endif
> diff --git a/src/libkshark.c b/src/libkshark.c
> index bd2e4cc0..6ce7b6ba 100644
> --- a/src/libkshark.c
> +++ b/src/libkshark.c
> @@ -1,7 +1,7 @@
>  // SPDX-License-Identifier: LGPL-2.1
>  
>  /*
> - * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>   */
>  
>   /**
> @@ -9,8 +9,10 @@
>   *  @brief   API for processing of tracing data.
>   */
>  
> +#ifndef _GNU_SOURCE
>  /** Use GNU C Library. */
> -#define _GNU_SOURCE 1
> +#define _GNU_SOURCE
> +#endif // _GNU_SOURCE
>  
>  // C
>  #include <stdlib.h>
> @@ -36,16 +38,6 @@ static bool kshark_default_context(struct kshark_context **context)
>  				    sizeof(*kshark_ctx->stream));
>  
>  	kshark_ctx->collections = NULL;
> -	kshark_ctx->plugins = NULL;
> -
> -	kshark_ctx->show_task_filter = tracecmd_filter_id_hash_alloc();
> -	kshark_ctx->hide_task_filter = tracecmd_filter_id_hash_alloc();
> -
> -	kshark_ctx->show_event_filter = tracecmd_filter_id_hash_alloc();
> -	kshark_ctx->hide_event_filter = tracecmd_filter_id_hash_alloc();
> -
> -	kshark_ctx->show_cpu_filter = tracecmd_filter_id_hash_alloc();
> -	kshark_ctx->hide_cpu_filter = tracecmd_filter_id_hash_alloc();
>  
>  	kshark_ctx->filter_mask = 0x0;
>  
> @@ -386,6 +378,12 @@ void kshark_close(struct kshark_context *kshark_ctx, int sd)
>  	if (!stream)
>  		return;
>  
> +	/*
> +	 * All data collections are file specific. Make sure that collections
> +	 * from this file are not going to be used with another file.
> +	 */
> +	kshark_unregister_stream_collections(&kshark_ctx->collections, sd);
> +
>  	/* Close all active plugins for this stream. */
>  	if (stream->plugins) {
>  		kshark_handle_all_dpis(stream, KSHARK_PLUGIN_CLOSE);
> @@ -530,103 +528,134 @@ ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int sd,
>  	return stream->tasks->count;
>  }
>  
> -static bool filter_find(struct tracecmd_filter_id *filter, int pid,
> +static bool filter_find(struct kshark_hash_id *filter, int pid,
>  			bool test)
>  {
>  	return !filter || !filter->count ||
> -		!!(unsigned long)tracecmd_filter_id_find(filter, pid) == test;
> +	       kshark_hash_id_find(filter, pid) == test;
>  }
>  
> -static bool kshark_show_task(struct kshark_context *kshark_ctx, int pid)
> +static bool kshark_show_task(struct kshark_data_stream *stream, int pid)
>  {
> -	return filter_find(kshark_ctx->show_task_filter, pid, true) &&
> -	       filter_find(kshark_ctx->hide_task_filter, pid, false);
> +	return filter_find(stream->show_task_filter, pid, true) &&
> +	       filter_find(stream->hide_task_filter, pid, false);
>  }
>  
> -static bool kshark_show_event(struct kshark_context *kshark_ctx, int pid)
> +static bool kshark_show_event(struct kshark_data_stream *stream, int pid)
>  {
> -	return filter_find(kshark_ctx->show_event_filter, pid, true) &&
> -	       filter_find(kshark_ctx->hide_event_filter, pid, false);
> +	return filter_find(stream->show_event_filter, pid, true) &&
> +	       filter_find(stream->hide_event_filter, pid, false);
>  }
>  
> -static bool kshark_show_cpu(struct kshark_context *kshark_ctx, int cpu)
> +static bool kshark_show_cpu(struct kshark_data_stream *stream, int cpu)
>  {
> -	return filter_find(kshark_ctx->show_cpu_filter, cpu, true) &&
> -	       filter_find(kshark_ctx->hide_cpu_filter, cpu, false);
> +	return filter_find(stream->show_cpu_filter, cpu, true) &&
> +	       filter_find(stream->hide_cpu_filter, cpu, false);
> +}
> +
> +static struct kshark_hash_id *get_filter(struct kshark_context *kshark_ctx,
> +					 int sd,
> +					 enum kshark_filter_type filter_id)
> +{
> +	struct kshark_data_stream *stream;
> +
> +	stream = kshark_get_data_stream(kshark_ctx, sd);
> +	if (!stream)
> +		return NULL;
> +
> +	return kshark_get_filter(stream, filter_id);
>  }
>  
>  /**
> - * @brief Add an Id value to the filster specified by "filter_id".
> + * @brief Get an Id Filter.
> + *
> + * @param stream: Input location for a Trace data stream pointer.
> + * @param filter_id: Identifier of the filter.
> + */
> +struct kshark_hash_id *
> +kshark_get_filter(struct kshark_data_stream *stream,
> +		  enum kshark_filter_type filter_id)
> +{
> +	switch (filter_id) {
> +	case KS_SHOW_CPU_FILTER:
> +		return stream->show_cpu_filter;
> +	case KS_HIDE_CPU_FILTER:
> +		return stream->hide_cpu_filter;
> +	case KS_SHOW_EVENT_FILTER:
> +		return stream->show_event_filter;
> +	case KS_HIDE_EVENT_FILTER:
> +		return stream->hide_event_filter;
> +	case KS_SHOW_TASK_FILTER:
> +		return stream->show_task_filter;
> +	case KS_HIDE_TASK_FILTER:
> +		return stream->hide_task_filter;
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +/**
> + * @brief Add an Id value to the filter specified by "filter_id".
>   *
>   * @param kshark_ctx: Input location for the session context pointer.
> + * @param sd: Data stream identifier.
>   * @param filter_id: Identifier of the filter.
>   * @param id: Id value to be added to the filter.
>   */
> -void kshark_filter_add_id(struct kshark_context *kshark_ctx,
> +void kshark_filter_add_id(struct kshark_context *kshark_ctx, int sd,
>  			  int filter_id, int id)
>  {
> -	struct tracecmd_filter_id *filter;
> +	struct kshark_hash_id *filter;
>  
> -	switch (filter_id) {
> -		case KS_SHOW_CPU_FILTER:
> -			filter = kshark_ctx->show_cpu_filter;
> -			break;
> -		case KS_HIDE_CPU_FILTER:
> -			filter = kshark_ctx->hide_cpu_filter;
> -			break;
> -		case KS_SHOW_EVENT_FILTER:
> -			filter = kshark_ctx->show_event_filter;
> -			break;
> -		case KS_HIDE_EVENT_FILTER:
> -			filter = kshark_ctx->hide_event_filter;
> -			break;
> -		case KS_SHOW_TASK_FILTER:
> -			filter = kshark_ctx->show_task_filter;
> -			break;
> -		case KS_HIDE_TASK_FILTER:
> -			filter = kshark_ctx->hide_task_filter;
> -			break;
> -		default:
> -			return;
> +	filter = get_filter(kshark_ctx, sd, filter_id);
> +	if (filter)
> +		kshark_hash_id_add(filter, id);
> +}
> +
> +/**
> + * @brief Get an array containing all Ids associated with a given Id Filter.
> + *
> + * @param kshark_ctx: Input location for context pointer.
> + * @param sd: Data stream identifier.
> + * @param filter_id: Identifier of the filter.
> + * @param n: Output location for the size of the returned array.
> + *
> + * @return The user is responsible for freeing the array.
> + */
> +int *kshark_get_filter_ids(struct kshark_context *kshark_ctx, int sd,
> +			   int filter_id, int *n)
> +{
> +	struct kshark_hash_id *filter;
> +
> +	filter = get_filter(kshark_ctx, sd, filter_id);
> +	if (filter) {
> +		if (n)
> +			*n = filter->count;
> +
> +		return kshark_hash_ids(filter);
>  	}
>  
> -	tracecmd_filter_id_add(filter, id);
> +	if (n)
> +		*n = 0;
> +
> +	return NULL;
>  }
>  
>  /**
> - * @brief Clear (reset) the filster specified by "filter_id".
> + * @brief Clear (reset) the filter specified by "filter_id".
>   *
>   * @param kshark_ctx: Input location for the session context pointer.
> + * @param sd: Data stream identifier.
>   * @param filter_id: Identifier of the filter.
>   */
> -void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id)
> +void kshark_filter_clear(struct kshark_context *kshark_ctx, int sd,
> +			 int filter_id)
>  {
> -	struct tracecmd_filter_id *filter;
> -
> -	switch (filter_id) {
> -		case KS_SHOW_CPU_FILTER:
> -			filter = kshark_ctx->show_cpu_filter;
> -			break;
> -		case KS_HIDE_CPU_FILTER:
> -			filter = kshark_ctx->hide_cpu_filter;
> -			break;
> -		case KS_SHOW_EVENT_FILTER:
> -			filter = kshark_ctx->show_event_filter;
> -			break;
> -		case KS_HIDE_EVENT_FILTER:
> -			filter = kshark_ctx->hide_event_filter;
> -			break;
> -		case KS_SHOW_TASK_FILTER:
> -			filter = kshark_ctx->show_task_filter;
> -			break;
> -		case KS_HIDE_TASK_FILTER:
> -			filter = kshark_ctx->hide_task_filter;
> -			break;
> -		default:
> -			return;
> -	}
> +	struct kshark_hash_id *filter;
>  
> -	tracecmd_filter_id_clear(filter);
> +	filter = get_filter(kshark_ctx, sd, filter_id);
> +	if (filter)
> +		kshark_hash_id_clear(filter);
>  }
>  
>  /**
> @@ -636,7 +665,7 @@ void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id)
>   *
>   * @returns True if the Id filter is set, otherwise False.
>   */
> -bool kshark_this_filter_is_set(struct tracecmd_filter_id *filter)
> +bool kshark_this_filter_is_set(struct kshark_hash_id *filter)
>  {
>  	return filter && filter->count;
>  }
> @@ -645,17 +674,49 @@ bool kshark_this_filter_is_set(struct tracecmd_filter_id *filter)
>   * @brief Check if an Id filter is set.
>   *
>   * @param kshark_ctx: Input location for the session context pointer.
> + * @param sd: Data stream identifier.
>   *
> - * @returns True if at least one Id filter is set, otherwise False.
> + * @returns True if at least one Id filter of the stream is set, otherwise
> + *	    False.
>   */
> -bool kshark_filter_is_set(struct kshark_context *kshark_ctx)
> +bool kshark_filter_is_set(struct kshark_context *kshark_ctx, int sd)
>  {
> -	return kshark_this_filter_is_set(kshark_ctx->show_task_filter) ||
> --              kshark_this_filter_is_set(kshark_ctx->hide_task_filter) ||
> --              kshark_this_filter_is_set(kshark_ctx->show_cpu_filter) ||
> --              kshark_this_filter_is_set(kshark_ctx->hide_cpu_filter) ||
> --              kshark_this_filter_is_set(kshark_ctx->show_event_filter) ||
> --              kshark_this_filter_is_set(kshark_ctx->hide_event_filter);
> +	struct kshark_data_stream *stream;
> +
> +	stream = kshark_get_data_stream(kshark_ctx, sd);
> +	if (!stream)
> +		return false;
> +
> +	return kshark_this_filter_is_set(stream->show_task_filter) ||
> +	       kshark_this_filter_is_set(stream->hide_task_filter)  ||
> +	       kshark_this_filter_is_set(stream->show_cpu_filter)   ||
> +	       kshark_this_filter_is_set(stream->hide_cpu_filter)   ||
> +	       kshark_this_filter_is_set(stream->show_event_filter) ||
> +	       kshark_this_filter_is_set(stream->hide_event_filter);
> +}
> +
> +/**
> + * @brief Apply filters to a given entry.
> + *
> + * @param kshark_ctx: Input location for the session context pointer.
> + * @param stream: Input location for a Trace data stream pointer.
> + * @param entry: Input location for entry.
> + */
> +void kshark_apply_filters(struct kshark_context *kshark_ctx,
> +			  struct kshark_data_stream *stream,
> +			  struct kshark_entry *entry)
> +{
> +	/* Apply event filtering. */
> +	if (!kshark_show_event(stream, entry->event_id))
> +		unset_event_filter_flag(kshark_ctx, entry);
> +
> +	/* Apply CPU filtering. */
> +	if (!kshark_show_cpu(stream, entry->cpu))
> +		entry->visible &= ~kshark_ctx->filter_mask;
> +
> +	/* Apply task filtering. */
> +	if (!kshark_show_task(stream, entry->pid))
> +		entry->visible &= ~kshark_ctx->filter_mask;
>  }
>  
>  static void set_all_visible(uint8_t *v) {
> @@ -663,56 +724,100 @@ static void set_all_visible(uint8_t *v) {
>  	*v |= 0xFF & ~KS_PLUGIN_UNTOUCHED_MASK;
>  }
>  
> +static void filter_entries(struct kshark_context *kshark_ctx, int sd,
> +			   struct kshark_entry **data, size_t n_entries)
> +{
> +	struct kshark_data_stream *stream = NULL;
> +	size_t i;
> +
> +	/* Sanity checks before starting. */
> +	if (sd >= 0) {
> +		/* We will filter particular Data stream. */
> +		stream = kshark_get_data_stream(kshark_ctx, sd);
> +		if (!stream)
> +			return;
> +
> +		if (stream->format == KS_TEP_DATA &&
> +		    kshark_tep_filter_is_set(stream)) {
> +			/* The advanced filter is set. */
> +			fprintf(stderr,
> +				"Failed to filter (sd = %i)!\n", sd);
> +			fprintf(stderr,
> +				"Reset the Advanced filter or reload the data.\n");
> +
> +			return;
> +		}
> +
> +		if (!kshark_filter_is_set(kshark_ctx, sd))
> +			return;
> +	}
> +
> +	/* Apply only the Id filters. */
> +	for (i = 0; i < n_entries; ++i) {
> +		if (sd >= 0) {
> +			/*
> +			 * We only filter particular stream. Chack is the entry
> +			 * belongs to this stream.
> +			 */
> +			if (data[i]->stream_id != sd)
> +				continue;
> +		} else {
> +			/* We filter all streams. */
> +			stream = kshark_ctx->stream[data[i]->stream_id];

Like we have discussed, we should be able to get a stream from the
kshark_ctx and the content of data[i], if we make data[i] point to a
pointer to an entry.

-- Steve


> +		}
> +
> +		/* Start with and entry which is visible everywhere. */
> +		set_all_visible(&data[i]->visible);
> +
> +		/* Apply Id filtering. */
> +		kshark_apply_filters(kshark_ctx, stream, data[i]);
> +	}
> +}
> +
