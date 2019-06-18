Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FF6C31E5B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 21:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F7532082C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 21:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbfFRV3g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 17:29:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730196AbfFRV3g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 17:29:36 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AA422082C;
        Tue, 18 Jun 2019 21:29:33 +0000 (UTC)
Date:   Tue, 18 Jun 2019 17:29:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     tz.stoyanov@gmail.com
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] trace-cmd: Save the tracee memory map into the
 trace.dat file.
Message-ID: <20190618172931.012c1317@gandalf.local.home>
In-Reply-To: <20190618143245.1377-1-tz.stoyanov@gmail.com>
References: <20190618143245.1377-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 18 Jun 2019 17:32:45 +0300
tz.stoyanov@gmail.com wrote:

> From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
> 
> [
>  v2 changes:
>    - Replaced usage of tracecmd_add_option_v() with tracecmd_add_option() API.
>    - Added checks to prevent buffer overflow when sscanf (... "%s", buf) is used.
>    - Return error in case memory allocation fails.
>    - Return error if option string is not in the expected format.
>    - Sort memory maps and use binary search to find matching library in the map.
> ]

Hi Tzvetomir!

Note, "v2 changes" text should be below the 3 lines after the SOB.

> 
> A new trace-cmd record option is added: "--mmap". When it is set with
> combination of -F or -P options, the memory map of the traced applications
> is stored in the trace.dat file. A new API tracecmd_search_tracee_mmap()
> can be used to look up into stored memory maps. The map is retrieved from
> /proc/<pid>/maps file.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---

  v2 changes:
    - Replaced usage of tracecmd_add_option_v() with
  tracecmd_add_option() API.
    - Added checks to prevent buffer overflow when sscanf (... "%s",
  buf) is used.
    - Return error in case memory allocation fails.
    - Return error if option string is not in the expected format.
    - Sort memory maps and use binary search to find matching library
  in the map.

This way a "git am" will ignore it. This is what the Linux kernel
community usually does.


>  include/trace-cmd/trace-cmd.h  |   4 +
>  lib/trace-cmd/trace-input.c    | 140 ++++++++++++++++++++++++++++++++-
>  tracecmd/include/trace-local.h |  16 ++++
>  tracecmd/trace-record.c        | 137 ++++++++++++++++++++++++++++++++
>  4 files changed, 294 insertions(+), 3 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 6f62ab9..210be03 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -82,6 +82,7 @@ enum {
>  	TRACECMD_OPTION_OFFSET,
>  	TRACECMD_OPTION_CPUCOUNT,
>  	TRACECMD_OPTION_VERSION,
> +	TRACECMD_OPTION_PIDMMAPS,
>  };
>  
>  enum {
> @@ -208,6 +209,9 @@ unsigned long long tracecmd_page_ts(struct tracecmd_input *handle,
>  unsigned int tracecmd_record_ts_delta(struct tracecmd_input *handle,
>  				      struct tep_record *record);
>  
> +char *tracecmd_get_tracee_lib(struct tracecmd_input *handle,
> +			      int pid, unsigned long addr);

Hmm, I rather not call it "tracee", that's a bit slang.

Perhaps just call it "task"

  tracecmd_get_task_lib()


> +
>  #ifndef SWIG
>  /* hack for function graph work around */
>  extern __thread struct tracecmd_input *tracecmd_curr_thread_handle;
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 61566ba..e2a06a8 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -101,6 +101,7 @@ struct tracecmd_input {
>  	struct tracecmd_ftrace	finfo;
>  
>  	struct hook_list	*hooks;
> +	struct pid_mem_maps	*pid_mmaps;
>  	/* file information */
>  	size_t			header_files_start;
>  	size_t			ftrace_files_start;
> @@ -2134,6 +2135,138 @@ void tracecmd_set_ts2secs(struct tracecmd_input *handle,
>  	handle->use_trace_clock = false;
>  }
>  
> +static int trace_pid_mmap_cmp(const void *a, const void *b)
> +{
> +	struct lib_mem_map *map_a = (struct lib_mem_map *)a;
> +	struct lib_mem_map *map_b = (struct lib_mem_map *)b;
> +
> +	if (map_a->start > map_b->start)
> +		return 1;
> +	if (map_a->start < map_b->start)
> +		return -1;
> +	return 0;
> +}
> +
> +#define STR_MMAP_LINE_MAX	(PATH_MAX+34)
> +static int trace_pid_mmap_load(struct tracecmd_input *handle, char *buf)
> +{
> +	struct pid_mem_maps *maps = NULL;
> +	char mapname[STR_MMAP_LINE_MAX];
> +	char *line;
> +	int ret;
> +	int i;
> +
> +	maps = calloc(1, sizeof(*maps));
> +	if (!maps)
> +		return -ENOMEM;
> +
> +	line = strchr(buf, '\n');
> +	if (!line) {
> +		free(maps);
> +		return -EINVAL;
> +	}
> +	*line = '\0';
> +	if (strlen(buf) > STR_MMAP_LINE_MAX) {
> +		free(maps);
> +		return -EINVAL;
> +	}
> +	ret = sscanf(buf, "%x %x %s", &maps->pid, &maps->nr_lib_maps, mapname);
> +	if (ret != 3) {
> +		free(maps);
> +		return -EINVAL;
> +	}
> +	maps->proc_name = strdup(mapname);
> +	if (!maps->proc_name) {
> +		free(maps);
> +		return -ENOMEM;
> +	}
> +	maps->lib_maps = calloc(maps->nr_lib_maps, sizeof(struct lib_mem_map));
> +	if (!maps->lib_maps) {
> +		free(maps->proc_name);
> +		free(maps);
> +		return -ENOMEM;
> +	}


BTW, when you have a lot failure paths like this, you can make do the
following:

	ret = -EINVAL;

	line = strchr(buf, '\n');
	if (!line)
		goto out_fail;

	[..]
	if (strlen(buf) > STR_MMAP_LINE_MAX)
		goto out_fail;
	[..]

	if (ret != 3)
		goto out_fail;

	ret = -ENOMEM;

	maps->proc_name = strdup(mapname);
	if (!maps->proc_name)
		goto out_fail;

	[..]
	if (!maps->lib_maps)
		goto out_fail;




> +	maps->next = handle->pid_mmaps;
> +	handle->pid_mmaps = maps;
> +	buf = line+1;
> +	line = strchr(buf, '\n');
> +	for (i = 0; i < maps->nr_lib_maps; i++) {
> +		if (!line)
> +			break;
> +		*line = '\0';
> +		if (strlen(buf) > STR_MMAP_LINE_MAX)
> +			break;
> +		ret = sscanf(buf, "%llx %llx %s", &maps->lib_maps[i].start,
> +			     &maps->lib_maps[i].end, mapname);
> +		if (ret == 3) {
> +			maps->lib_maps[i].lib_name = strdup(mapname);
> +			if (!maps->lib_maps[i].lib_name)
> +				return -ENOMEM;

Hmm, perhaps we should wait to update handle->pid_maps until after
this, and have this goto out_fail as well.

> +		}
> +		buf = line+1;
> +		line = strchr(buf, '\n');
> +	}
> +
> +	if (i != maps->nr_lib_maps)

Here too.

> +		return -EINVAL;
> +
> +	qsort(maps->lib_maps, maps->nr_lib_maps,
> +	      sizeof(*maps->lib_maps), trace_pid_mmap_cmp);

Here we should update handle->pid_mmaps = maps;

> +
> +	return 0;

Here we have:

 out_fail:
	free(maps->lib_maps);
	free(maps->proc_name);
	free(maps);

	return ret;

	
> +}
> +
> +static int trace_pid_mmap_search(const void *a, const void *b)
> +{
> +	struct lib_mem_map *key = (struct lib_mem_map *)a;
> +	struct lib_mem_map *map = (struct lib_mem_map *)b;
> +
> +	if (key->start > map->end)
> +		return 1;
> +	if (key->start < map->start)
> +		return -1;
> +	return 0;
> +}
> +
> +/**
> + * tracecmd_search_tracee_mmap - Search tracee memory address map

Probably want to call this tracecmd_search_task_mmap().

> + * @handle: input handle to the trace.dat file
> + * @pid: pid of the tracee

  of the task

> + * @addr: address from the tracee memory space.
> + *
> + * Map of the tracee memory can be saved in the trace.dat file, using the option
> + * "--mmap". If there is such information, this API can be used to look up into
> + * this memory map to find library is loaded at the given @addr.
> + *
> + * The name of the library at given tracee @addr is returned.
> + */
> +char *tracecmd_search_tracee_mmap(struct tracecmd_input *handle,
> +				  int pid, unsigned long long addr)
> +{
> +	struct pid_mem_maps *maps;
> +	struct lib_mem_map *lib;
> +	struct lib_mem_map key;
> +
> +	if (!handle || !handle->pid_mmaps)
> +		return NULL;
> +
> +	maps = handle->pid_mmaps;
> +	while (maps) {
> +		if (maps->pid == pid)
> +			break;
> +		maps = maps->next;
> +	}
> +	if (!maps || !maps->nr_lib_maps || !maps->lib_maps)
> +		return NULL;
> +	key.start = addr;
> +	lib = bsearch(&key, maps->lib_maps, maps->nr_lib_maps,
> +		      sizeof(*maps->lib_maps), trace_pid_mmap_search);
> +	if (lib)
> +		return lib->lib_name;
> +
> +	return NULL;
> +}
> +
>  static int handle_options(struct tracecmd_input *handle)
>  {
>  	unsigned long long offset;
> @@ -2221,9 +2354,6 @@ static int handle_options(struct tracecmd_input *handle)
>  		case TRACECMD_OPTION_UNAME:
>  			handle->uname = strdup(buf);
>  			break;
> -		case TRACECMD_OPTION_VERSION:
> -			handle->version = strdup(buf);
> -			break;
>  		case TRACECMD_OPTION_HOOK:
>  			hook = tracecmd_create_event_hook(buf);
>  			hook->next = handle->hooks;
> @@ -2233,6 +2363,10 @@ static int handle_options(struct tracecmd_input *handle)
>  			cpus = *(int *)buf;
>  			handle->cpus = tep_read_number(handle->pevent, &cpus, 4);
>  			break;
> +		case TRACECMD_OPTION_PIDMMAPS:
> +			if (buf[size] == '\0')
> +				trace_pid_mmap_load(handle, buf);
> +			break;
>  		default:
>  			warning("unknown option %d", option);
>  			break;
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index 1cad3cc..dc4dc03 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -157,6 +157,20 @@ struct func_list {
>  	const char *mod;
>  };
>  
> +struct lib_mem_map {
> +	unsigned long long	start;
> +	unsigned long long	end;
> +	char			*lib_name;
> +};
> +
> +struct pid_mem_maps {
> +	struct pid_mem_maps	*next;
> +	struct lib_mem_map	*lib_maps;
> +	unsigned int		nr_lib_maps;
> +	char			*proc_name;
> +	int			pid;
> +};
> +
>  struct buffer_instance {
>  	struct buffer_instance	*next;
>  	const char		*name;
> @@ -183,6 +197,8 @@ struct buffer_instance {
>  	struct tracecmd_msg_handle *msg_handle;
>  	struct tracecmd_output *network_handle;
>  
> +	struct pid_mem_maps	*mem_maps;
> +
>  	char			*max_graph_depth;
>  
>  	int			flags;
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 5dc6f17..a938ce3 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -84,6 +84,7 @@ static int max_kb;
>  static bool use_tcp;
>  
>  static int do_ptrace;
> +static int get_mmap;
>  
>  static int filter_task;
>  static int filter_pid = -1;
> @@ -1062,6 +1063,98 @@ static char *make_pid_filter(char *curr_filter, const char *field)
>  	return filter;
>  }
>  
> +static int get_pid_mmaps(int pid)
> +{
> +	struct buffer_instance *instance = &top_instance;
> +	struct pid_mem_maps *maps = instance->mem_maps;
> +	unsigned long long begin, end, inode, tmp;
> +	struct lib_mem_map *map;
> +	char mapname[PATH_MAX+1];
> +	char fname[PATH_MAX+1];
> +	char buf[PATH_MAX+100];
> +	char perm[5];
> +	char dev[6];
> +	FILE *f;
> +	int ret;
> +	int res;
> +	int i;
> +
> +	while (maps) {
> +		if (pid == maps->pid)
> +			break;
> +		maps = maps->next;
> +	}

BTW, each time I look at this code, I think this is a bug because you
don't check for (!maps) at the end of this loop. But then notice below
you do. Let's move this while loop to just before the:

	if (!maps) {

As it makes more sense to keep them together, and less likely that we
think maps is used as NULL.


> +
> +	sprintf(fname, "/proc/%d/exe", pid);
> +	ret = readlink(fname, mapname, PATH_MAX);
> +	if (ret >= PATH_MAX || ret < 0)
> +		return -ENOENT;
> +
> +	sprintf(fname, "/proc/%d/maps", pid);
> +	f = fopen(fname, "r");
> +	if (!f)
> +		return -ENOENT;
> +
> +	if (!maps) {
> +		maps = calloc(1, sizeof(*maps));
> +		if (!maps)
> +			return -ENOMEM;
> +		maps->pid = pid;
> +		maps->next = instance->mem_maps;
> +		instance->mem_maps = maps;
> +	} else {
> +		for (i = 0; i < maps->nr_lib_maps; i++)
> +			free(maps->lib_maps[i].lib_name);
> +		free(maps->lib_maps);
> +		maps->lib_maps = NULL;
> +		maps->nr_lib_maps = 0;
> +		free(maps->proc_name);
> +	}
> +
> +	maps->proc_name = strdup(mapname);
> +	if (!maps->proc_name)
> +		return -ENOMEM;

We need to close 'f' before we return an error. Let's do:

	ret = -ENOMEM;
	maps->proc_name = strdup(mapname);
	if (!maps->proc_name)
		goto out;

> +
> +	ret = 0;
> +	while (fgets(buf, sizeof(buf), f)) {
> +		mapname[0] = '\0';
> +		res = sscanf(buf, "%llx-%llx %4s %llx %5s %lld %s",
> +			     &begin, &end, perm, &tmp, dev, &inode, mapname);
> +		if (res == 7 && mapname[0] != '\0') {
> +			map = realloc(maps->lib_maps,
> +				      (maps->nr_lib_maps+1)*sizeof(*map));
> +			if (!map) {
> +				ret = -ENOMEM;
> +				break;
> +			}
> +			map[maps->nr_lib_maps].end = end;
> +			map[maps->nr_lib_maps].start = begin;
> +			map[maps->nr_lib_maps].lib_name = strdup(mapname);
> +			if (!map[maps->nr_lib_maps].lib_name) {
> +				ret = -ENOMEM;
> +				free(map);
> +				break;

I'm thinking on error, we goto "out_fail" and remove all maps.

> +			}
> +			maps->lib_maps = map;
> +			maps->nr_lib_maps++;
> +		}
> +	}

 out:

> +	fclose(f);
> +
> +	return ret;

out_fail:

	for (i = 0; i < maps->nr_lib_maps; i++) {
		free(maps->lib_maps[i].lib_name);
	free(maps->lib_maps);

But we would also need to remove it from the instance->mem_maps list.

-- Steve

> +}
> +
> +static void get_filter_pid_mmaps(void)
> +{
> +	struct filter_pids *p;
> +
> +	for (p = filter_pids; p; p = p->next) {
> +		if (p->exclude)
> +			continue;
> +		get_pid_mmaps(p->pid);
> +	}
> +}
> +
>  static void update_task_filter(void)
>  {
>  	struct buffer_instance *instance;
> @@ -1070,6 +1163,9 @@ static void update_task_filter(void)
>  	if (no_filter)
>  		return;
>  
> +	if (get_mmap && filter_pids)
> +		get_filter_pid_mmaps();
> +
>  	if (filter_task)
>  		add_filter_pid(pid, 0);
>  
> @@ -1264,6 +1360,8 @@ static void ptrace_wait(enum trace_type type, int main_pid)
>  				break;
>  
>  			case PTRACE_EVENT_EXIT:
> +				if (get_mmap)
> +					get_pid_mmaps(main_pid);
>  				ptrace(PTRACE_GETEVENTMSG, pid, NULL, &cstatus);
>  				ptrace(PTRACE_DETACH, pid, NULL, NULL);
>  				break;
> @@ -3094,6 +3192,33 @@ static void append_buffer(struct tracecmd_output *handle,
>  	}
>  }
>  
> +
> +static void
> +add_pid_mem_maps(struct tracecmd_output *handle, struct buffer_instance *instance)
> +{
> +	struct pid_mem_maps *maps = instance->mem_maps;
> +	struct trace_seq s;
> +	int i;
> +
> +	trace_seq_init(&s);
> +	while (maps) {
> +		if (!maps->nr_lib_maps)
> +			continue;
> +		trace_seq_reset(&s);
> +		trace_seq_printf(&s, "%x %x %s\n",
> +				 maps->pid, maps->nr_lib_maps, maps->proc_name);
> +		for (i = 0; i < maps->nr_lib_maps; i++)
> +			trace_seq_printf(&s, "%llx %llx %s\n",
> +					maps->lib_maps[i].start,
> +					maps->lib_maps[i].end,
> +					maps->lib_maps[i].lib_name);
> +		tracecmd_add_option(handle, TRACECMD_OPTION_PIDMMAPS,
> +				    s.len+1, s.buffer);
> +		maps = maps->next;
> +	}
> +	trace_seq_destroy(&s);
> +}
> +
>  static void
>  add_buffer_stat(struct tracecmd_output *handle, struct buffer_instance *instance)
>  {
> @@ -3287,6 +3412,10 @@ static void record_data(struct common_record_context *ctx)
>  		if (!no_top_instance() && !top_instance.msg_handle)
>  			print_stat(&top_instance);
>  
> +		for_all_instances(instance) {
> +			add_pid_mem_maps(handle, instance);
> +		}
> +
>  		tracecmd_append_cpu_data(handle, local_cpu_count, temp_files);
>  
>  		for (i = 0; i < max_cpu_count; i++)
> @@ -4397,6 +4526,7 @@ void update_first_instance(struct buffer_instance *instance, int topt)
>  }
>  
>  enum {
> +	OPT_mmap		= 244,
>  	OPT_quiet		= 245,
>  	OPT_debug		= 246,
>  	OPT_no_filter		= 247,
> @@ -4627,6 +4757,7 @@ static void parse_record_options(int argc,
>  			{"debug", no_argument, NULL, OPT_debug},
>  			{"quiet", no_argument, NULL, OPT_quiet},
>  			{"help", no_argument, NULL, '?'},
> +			{"mmap", no_argument, NULL, OPT_mmap},
>  			{"module", required_argument, NULL, OPT_module},
>  			{NULL, 0, NULL, 0}
>  		};
> @@ -4858,6 +4989,9 @@ static void parse_record_options(int argc,
>  		case 'i':
>  			ignore_event_not_found = 1;
>  			break;
> +		case OPT_mmap:
> +			get_mmap = 1;
> +			break;
>  		case OPT_date:
>  			ctx->date = 1;
>  			if (ctx->data_flags & DATA_FL_OFFSET)
> @@ -4924,6 +5058,9 @@ static void parse_record_options(int argc,
>  		add_func(&ctx->instance->filter_funcs,
>  			 ctx->instance->filter_mod, "*");
>  
> +	if (filter_task && get_mmap)
> +		do_ptrace = 1;
> +
>  	if (do_ptrace && !filter_task && (filter_pid < 0))
>  		die(" -c can only be used with -F (or -P with event-fork support)");
>  	if (ctx->do_child && !filter_task &&! filter_pid)

