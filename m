Return-Path: <SRS0=4yZ8=US=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1E8C31E49
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jun 2019 14:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DF9A2064A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jun 2019 14:19:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rnoAQLEf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbfFSOTh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 10:19:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44620 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729179AbfFSOTh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 10:19:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id r16so427260wrl.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jun 2019 07:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L9Dl++9PvtIxB+iQUDQF5MtmgSZBW5SdiqjCZFU7CoU=;
        b=rnoAQLEfSl/ApGqpxGX/9QAOO6hAOEP/igKBHjhKAiXPi7vC9SaQxcKBScKQOjjQD8
         n/0E2SFrteJPSnBv1iIzpmpyby7NlZ45paLPvemGMKTSbgIDgjQTnyZHMaAztgBJ9MQG
         LbkqtETo0Lg+BR49HaaoIrxBsHJTCg+9YHJl190SbZczzMkzAd60f3mVQYjA4ewST+xm
         7RLJ5HZP6kPzcAtPyb4cMIePDNIF8RxvVkwQEDWvysQEGLaAyhA8eBTcUZA+MeXPDVGy
         eM2KZxkVstumJafOFKKZ1VIJ9MP5YAAtz9VSrpYQyARkMcPk92vybFgDZMfM/IE5+OLR
         LiYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L9Dl++9PvtIxB+iQUDQF5MtmgSZBW5SdiqjCZFU7CoU=;
        b=LrXr2t3Sr4ClVWQ0xHamvD3pzZEvNb0rXXoz+DwdeDi9T8Ke8L/3xxh2b5dFN/CZBz
         Pnn5xs5wWBtEC9RVmxcfaqsY1XWeCXPTXXF75X81JGo4tAM8Q49HddeJBdNNdUmA34bl
         rtYJ3Su+ejmgE02zftvJzlswq9KdhwiHZ89au/v9Wi3V7m6JuER9OOBLAzZfmnZUMVPr
         853nN9zqKeLlxg0Ovf4RyOoTifLxDa8RZVfgn9Wutkk0Q2KwzrLF4D8cIIWuwSoyBjvD
         8LdaWUR0ntAMaGA9T53d8bKNSe8+3S3ccuzXWbQOHuXFLqPa2zCCbmJe3d1HGIZnvk7P
         2t7w==
X-Gm-Message-State: APjAAAXztDuwHP7UriF3b6Z7yyDwbhNXss01zfgxZEZjWXWyszSCv2Uj
        CePusOh6dBRqBcqQjJ0uW9iKlyVYb6E=
X-Google-Smtp-Source: APXvYqwO/HP4xmhGQzcfja2cBHhIit/BHY3sS4NbxcJ+qOpG/DabtD89sQwDM0R1LVQ7+hZc2zEzjw==
X-Received: by 2002:adf:ec0f:: with SMTP id x15mr87742059wrn.165.1560953973920;
        Wed, 19 Jun 2019 07:19:33 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q12sm15064308wrp.50.2019.06.19.07.19.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 07:19:33 -0700 (PDT)
Subject: Re: [PATCH v3] trace-cmd: Save the tracee memory map into the
 trace.dat file.
To:     tz.stoyanov@gmail.com, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20190619083915.2049-1-tz.stoyanov@gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <3ac13d53-1407-2c4b-4d6c-d2f9ee9ce2af@gmail.com>
Date:   Wed, 19 Jun 2019 17:19:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190619083915.2049-1-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 19.06.19 г. 11:39 ч., tz.stoyanov@gmail.com wrote:
> From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
> 
> A new trace-cmd record option is added: "--mmap". When it is set with
> combination of -F or -P options, the memory map of the traced applications
> is stored in the trace.dat file. A new API tracecmd_search_task_mmap()
> can be used to look up into stored memory maps. The map is retrieved from
> /proc/<pid>/maps file.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
> [
>   v3 changes:
>     - Changed tracecmd_search_task_mmap() API to return not only the library
>       name, but also the start and end memory addresses.
>     - Renamed *tracee* to *task*
>     - Improved resources cleanup, in case of an error.
>     - Removed (this) changelog from the commit message.
> 
>   v2 changes:
>     - Replaced usage of tracecmd_add_option_v() with tracecmd_add_option() API.
>     - Added checks to prevent buffer overflow when sscanf (... "%s", buf) is used.
>     - Return error in case memory allocation fails.
>     - Return error if option string is not in the expected format.
>     - Sort memory maps and use binary search to find matching library in the map.
> ]
> 
>   include/trace-cmd/trace-cmd.h  |   9 ++
>   lib/trace-cmd/trace-input.c    | 149 ++++++++++++++++++++++++++++++-
>   tracecmd/include/trace-local.h |  10 +++
>   tracecmd/trace-record.c        | 158 +++++++++++++++++++++++++++++++++
>   4 files changed, 323 insertions(+), 3 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 6f62ab9..17edb9d 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -82,6 +82,7 @@ enum {
>   	TRACECMD_OPTION_OFFSET,
>   	TRACECMD_OPTION_CPUCOUNT,
>   	TRACECMD_OPTION_VERSION,
> +	TRACECMD_OPTION_PIDMMAPS,
>   };

...

>   
> +static int get_pid_mmaps(int pid)
> +{
> +	struct buffer_instance *instance = &top_instance;
> +	struct pid_mem_maps *maps = instance->mem_maps;
> +	struct pid_mem_maps *m;
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
> +	while (maps) {
> +		if (pid == maps->pid)
> +			break;
> +		maps = maps->next;
> +	}
> +
> +	ret = -ENOMEM;
> +	if (!maps) {
> +		maps = calloc(1, sizeof(*maps));
> +		if (!maps)
> +			goto out_fail;
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
> +		goto out;
> +
> +	while (fgets(buf, sizeof(buf), f)) {
> +		mapname[0] = '\0';
> +		res = sscanf(buf, "%llx-%llx %4s %llx %5s %lld %s",

We tried testing the patch and we found that the memory map file is not 
properly parsed. The problem seems to get solved if we replace the line 
above with
		res = sscanf(buf, "%llx-%llx %4s %llx %s %lld %s",

Thanks!
Yordan

> +			     &begin, &end, perm, &tmp, dev, &inode, mapname);
> +		if (res == 7 && mapname[0] != '\0') {
> +			map = realloc(maps->lib_maps,
> +				      (maps->nr_lib_maps+1)*sizeof(*map));
> +			if (!map)
> +				goto out_fail;
> +			map[maps->nr_lib_maps].end = end;
> +			map[maps->nr_lib_maps].start = begin;
> +			map[maps->nr_lib_maps].lib_name = strdup(mapname);
> +			if (!map[maps->nr_lib_maps].lib_name)
> +				goto out_fail;
> +			maps->lib_maps = map;
> +			maps->nr_lib_maps++;
> +		}
> +	}
> +out:
> +	fclose(f);
> +	return 0;
> +
> +out_fail:
> +	fclose(f);
> +	if (maps) {
> +		for (i = 0; i < maps->nr_lib_maps; i++)
> +			free(maps->lib_maps[i].lib_name);
> +		if (instance->mem_maps != maps) {
> +			m = instance->mem_maps;
> +			while (m) {
> +				if (m->next == maps) {
> +					m->next = maps->next;
> +					break;
> +				}
> +				m = m->next;
> +			}
> +		} else
> +			instance->mem_maps = maps->next;
> +		free(maps->lib_maps);
> +		maps->lib_maps = NULL;
> +		maps->nr_lib_maps = 0;
> +		free(maps->proc_name);
> +		maps->proc_name = NULL;
> +		free(maps);
> +	}
> +	return ret;
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
>   static void update_task_filter(void)
>   {
>   	struct buffer_instance *instance;
> @@ -1070,6 +1184,9 @@ static void update_task_filter(void)
>   	if (no_filter)
>   		return;
>   
> +	if (get_mmap && filter_pids)
> +		get_filter_pid_mmaps();
> +
>   	if (filter_task)
>   		add_filter_pid(pid, 0);
>   
> @@ -1264,6 +1381,8 @@ static void ptrace_wait(enum trace_type type, int main_pid)
>   				break;
>   
>   			case PTRACE_EVENT_EXIT:
> +				if (get_mmap)
> +					get_pid_mmaps(main_pid);
>   				ptrace(PTRACE_GETEVENTMSG, pid, NULL, &cstatus);
>   				ptrace(PTRACE_DETACH, pid, NULL, NULL);
>   				break;
> @@ -3094,6 +3213,33 @@ static void append_buffer(struct tracecmd_output *handle,
>   	}
>   }
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
>   static void
>   add_buffer_stat(struct tracecmd_output *handle, struct buffer_instance *instance)
>   {
> @@ -3287,6 +3433,10 @@ static void record_data(struct common_record_context *ctx)
>   		if (!no_top_instance() && !top_instance.msg_handle)
>   			print_stat(&top_instance);
>   
> +		for_all_instances(instance) {
> +			add_pid_mem_maps(handle, instance);
> +		}
> +
>   		tracecmd_append_cpu_data(handle, local_cpu_count, temp_files);
>   
>   		for (i = 0; i < max_cpu_count; i++)
> @@ -4397,6 +4547,7 @@ void update_first_instance(struct buffer_instance *instance, int topt)
>   }
>   
>   enum {
> +	OPT_mmap		= 244,
>   	OPT_quiet		= 245,
>   	OPT_debug		= 246,
>   	OPT_no_filter		= 247,
> @@ -4627,6 +4778,7 @@ static void parse_record_options(int argc,
>   			{"debug", no_argument, NULL, OPT_debug},
>   			{"quiet", no_argument, NULL, OPT_quiet},
>   			{"help", no_argument, NULL, '?'},
> +			{"mmap", no_argument, NULL, OPT_mmap},
>   			{"module", required_argument, NULL, OPT_module},
>   			{NULL, 0, NULL, 0}
>   		};
> @@ -4858,6 +5010,9 @@ static void parse_record_options(int argc,
>   		case 'i':
>   			ignore_event_not_found = 1;
>   			break;
> +		case OPT_mmap:
> +			get_mmap = 1;
> +			break;
>   		case OPT_date:
>   			ctx->date = 1;
>   			if (ctx->data_flags & DATA_FL_OFFSET)
> @@ -4924,6 +5079,9 @@ static void parse_record_options(int argc,
>   		add_func(&ctx->instance->filter_funcs,
>   			 ctx->instance->filter_mod, "*");
>   
> +	if (filter_task && get_mmap)
> +		do_ptrace = 1;
> +
>   	if (do_ptrace && !filter_task && (filter_pid < 0))
>   		die(" -c can only be used with -F (or -P with event-fork support)");
>   	if (ctx->do_child && !filter_task &&! filter_pid)
> 
