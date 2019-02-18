Return-Path: <SRS0=zcJY=QZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F723C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A18421900
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732229AbfBRO1E (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:27:04 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35951 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389866AbfBRO1A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Feb 2019 09:27:00 -0500
Received: by mail-wm1-f68.google.com with SMTP id j125so17343039wmj.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Feb 2019 06:26:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hoHEn/wqdhRSEOkdU3eiTXHmy2Gjt6IYLnHKJiPRQ7Q=;
        b=m54Ocsp6w4WriNGFXyO4LO99eXfgpvzw0nueMfHFm5dTm1zBX3wz0JWpbqztm8m1e+
         9FVsV3cYBtTKpe3sG8OKPUIJgqkSR2yLZhgqAmo186BmpX3MBWKbHyRjVNFtUQwoYRtv
         A2ATJpY+ZGeQRGB8A3zHE1JFrzG7UTMRUGsUMzIYFTjVyshbe4qSzU5gFoZuAb7Ep2Jf
         2AeM/812OmCkd3fCf4ex+xHa780HeYOFa+x5yaoiY+7FSfL6ZJ7iWnzUdhIQh0A/AliU
         JOmtl3k1UzvFcSRZ9IOHoiTKoAdhC4LRjqTf1OiaWeYUWq+xrDpzQrukkxcvxVlNGD+1
         jy4Q==
X-Gm-Message-State: AHQUAubuoKpPzGsbDEQGQ1DFxxrYSrXQQ6IWvc3iUgU+GQDPrAPe2VVb
        y8b2ek1H4/n8gKR/PMoPuA==
X-Google-Smtp-Source: AHgI3IZRMPGlc32mouIiVS1Q8WyO5RsxUTcJQoAWRCDDAYWrZvrbGjPDVALWXziU6RMmsuKxXR/43g==
X-Received: by 2002:a1c:f50a:: with SMTP id t10mr16429330wmh.126.1550500017200;
        Mon, 18 Feb 2019 06:26:57 -0800 (PST)
Received: from box ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id o64sm15110834wmo.47.2019.02.18.06.26.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 18 Feb 2019 06:26:56 -0800 (PST)
Date:   Mon, 18 Feb 2019 16:26:54 +0200
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v6 05/11] trace-cmd: Add VM kernel tracing over
 vsockets transport
Message-ID: <20190218142653.GB11734@box>
References: <20190214141335.28144-1-kaslevs@vmware.com>
 <20190214141335.28144-6-kaslevs@vmware.com>
 <20190214150348.0f44293e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190214150348.0f44293e@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 14, 2019 at 03:03:48PM -0500, Steven Rostedt wrote:
> On Thu, 14 Feb 2019 16:13:29 +0200
> Slavomir Kaslev <kaslevs@vmware.com> wrote:
> 
> >  void start_threads(enum trace_type type, struct common_record_context *ctx)
> >  {
> >  	struct buffer_instance *instance;
> > -	int *brass = NULL;
> >  	int total_cpu_count = 0;
> >  	int i = 0;
> >  	int ret;
> >  
> > -	for_all_instances(instance)
> > +	for_all_instances(instance) {
> > +		/* Start the connection now to find out how many CPUs we need */
> > +		if (instance->flags & BUFFER_FL_GUEST)
> > +			connect_to_agent(instance);
> >  		total_cpu_count += instance->cpu_count;
> > +	}
> >  
> >  	/* make a thread for every CPU we have */
> > -	pids = malloc(sizeof(*pids) * total_cpu_count * (buffers + 1));
> > +	pids = calloc(total_cpu_count * (buffers + 1), sizeof(*pids));
> >  	if (!pids)
> > -		die("Failed to allocat pids for %d cpus", total_cpu_count);
> > -
> > -	memset(pids, 0, sizeof(*pids) * total_cpu_count * (buffers + 1));
> > +		die("Failed to allocate pids for %d cpus", total_cpu_count);
> >  
> >  	for_all_instances(instance) {
> > +		int *brass = NULL;
> >  		int x, pid;
> >  
> > -		if (host) {
> > +		if (instance->flags & BUFFER_FL_AGENT) {
> > +			setup_agent(instance, ctx);
> > +		} else if (instance->flags & BUFFER_FL_GUEST) {
> > +			setup_guest(instance);
> > +		} else if (host) {
> >  			instance->msg_handle = setup_connection(instance, ctx);
> >  			if (!instance->msg_handle)
> >  				die("Failed to make connection");
> > @@ -3139,13 +3444,14 @@ static void print_stat(struct buffer_instance *instance)
> >  {
> >  	int cpu;
> >  
> > +	if (quiet)
> > +		return;
> 
> Hmm, this looks unrelated to this patch, and looks like it should have
> been in a patch by itself. As a clean up.

OK, I split two such unrelated cleanups as separate patches at the beginning of
the next iteration so that they can be merged independently of the remaining
vsockets work.

> 
> > +
> >  	if (!is_top_instance(instance))
> > -		if (!quiet)
> > -			printf("\nBuffer: %s\n\n", instance->name);
> > +		printf("\nBuffer: %s\n\n", instance->name);
> >  
> >  	for (cpu = 0; cpu < instance->cpu_count; cpu++)
> > -		if (!quiet)
> > -			trace_seq_do_printf(&instance->s_print[cpu]);
> > +		trace_seq_do_printf(&instance->s_print[cpu]);
> >  }
> >  
> >  enum {
> > @@ -3171,7 +3477,44 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
> >  	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
> >  	add_option_hooks(handle);
> >  	add_uname(handle);
> > +}
> > +
> > +static void write_guest_file(struct buffer_instance *instance)
> > +{
> > +	struct tracecmd_output *handle;
> > +	int cpu_count = instance->cpu_count;
> > +	char *file;
> > +	char **temp_files;
> > +	int i, fd;
> > +
> > +	file = get_guest_file(output_file, instance->name);
> > +	fd = open(file, O_RDWR);
> > +	if (fd < 0)
> > +		die("error opening %s", file);
> > +	put_temp_file(file);
> > +
> > +	handle = tracecmd_get_output_handle_fd(fd);
> > +	if (!handle)
> > +		die("error writing to %s", file);
> >  
> > +	temp_files = malloc(sizeof(*temp_files) * cpu_count);
> > +	if (!temp_files)
> > +		die("failed to allocate temp_files for %d cpus",
> > +		    cpu_count);
> > +
> > +	for (i = 0; i < cpu_count; i++) {
> > +		temp_files[i] = get_temp_file(instance, i);
> > +		if (!temp_files[i])
> > +			die("failed to allocate memory");
> > +	}
> > +
> > +	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files) < 0)
> > +		die("failed to write CPU data");
> > +	tracecmd_output_close(handle);
> > +
> > +	for (i = 0; i < cpu_count; i++)
> > +		put_temp_file(temp_files[i]);
> > +	free(temp_files);
> >  }
> >  
> >  static void record_data(struct common_record_context *ctx)
> > @@ -3185,7 +3528,9 @@ static void record_data(struct common_record_context *ctx)
> >  	int i;
> >  
> >  	for_all_instances(instance) {
> > -		if (instance->msg_handle)
> > +		if (instance->flags & BUFFER_FL_GUEST)
> > +			write_guest_file(instance);
> > +		else if (host && instance->msg_handle)
> >  			finish_network(instance->msg_handle);
> >  		else
> >  			local = true;
> > @@ -4404,6 +4749,7 @@ void trace_stop(int argc, char **argv)
> >  		c = getopt(argc-1, argv+1, "hatB:");
> >  		if (c == -1)
> >  			break;
> > +
> >  		switch (c) {
> >  		case 'h':
> >  			usage(argv);
> > @@ -4566,6 +4912,63 @@ static void init_common_record_context(struct common_record_context *ctx,
> >  #define IS_STREAM(ctx) ((ctx)->curr_cmd == CMD_stream)
> >  #define IS_PROFILE(ctx) ((ctx)->curr_cmd == CMD_profile)
> >  #define IS_RECORD(ctx) ((ctx)->curr_cmd == CMD_record)
> > +#define IS_AGENT(ctx) ((ctx)->curr_cmd == CMD_record_agent)
> > +
> > +static void add_argv(struct buffer_instance *instance, char *arg, bool prepend)
> > +{
> > +	instance->argv = realloc(instance->argv,
> > +				 (instance->argc + 1) * sizeof(char *));
> > +	if (!instance->argv)
> > +		die("Can not allocate instance args");
> > +	if (prepend) {
> > +		memmove(instance->argv + 1, instance->argv,
> > +			instance->argc * sizeof(*instance->argv));
> > +		instance->argv[0] = arg;
> > +	} else {
> > +		instance->argv[instance->argc] = arg;
> > +	}
> > +	instance->argc++;
> > +}
> > +
> > +static void add_arg(struct buffer_instance *instance,
> > +		    int c, const char *opts,
> > +		    struct option *long_options, char *optarg)
> > +{
> > +	char *ptr;
> > +	char *arg;
> > +	int ret;
> > +	int i;
> > +
> > +	/* Short or long arg */
> > +	if (!(c & 0x80)) {
> > +		ret = asprintf(&arg, "-%c", c);
> > +		if (ret < 0)
> > +			die("Can not allocate argument");
> > +		ptr = strstr(opts, arg+1);
> > +		if (!ptr)
> > +			return; /* Not found? */
> 
> This leaks arg, as arg was allocated with asprintf(). Need a
> "free(arg)" here.
> 
> 
> > +		add_argv(instance, arg, false);
> > +		if (ptr[1] == ':')
> > +			add_argv(instance, optarg, false);
> > +		return;
> > +	}
> > +	for (i = 0; long_options[i].name; i++) {
> > +		if (c == long_options[i].val) {
> > +			ret = asprintf(&arg, "--%s", long_options[i].name);
> > +			if (ret < 0)
> > +				die("Can not allocate argument");
> > +			add_argv(instance, arg, false);
> > +			if (long_options[i].has_arg) {
> > +				arg = strdup(optarg);
> > +				if (!arg)
> > +					die("Can not allocate arguments");
> > +				add_argv(instance, arg, false);
> > +				return;
> > +			}
> > +		}
> > +	}
> > +	/* Not found? */
> > +}
> >  
> >  static void parse_record_options(int argc,
> >  				 char **argv,
> > @@ -4607,10 +5010,20 @@ static void parse_record_options(int argc,
> >  		if (IS_EXTRACT(ctx))
> >  			opts = "+haf:Fp:co:O:sr:g:l:n:P:N:tb:B:ksiT";
> >  		else
> > -			opts = "+hae:f:Fp:cC:dDGo:O:s:r:vg:l:n:P:N:tb:R:B:ksSiTm:M:H:q";
> > +			opts = "+hae:f:FA:p:cC:dDGo:O:s:r:vg:l:n:P:N:tb:R:B:ksSiTm:M:H:q";
> >  		c = getopt_long (argc-1, argv+1, opts, long_options, &option_index);
> >  		if (c == -1)
> >  			break;
> > +
> > +		/*
> > +		 * If the current instance is to record a guest, then save
> > +		 * all the arguments for this instance.
> > +		 */
> > +		if (c != 'B' && c != 'A' && ctx->instance->flags & BUFFER_FL_GUEST) {
> > +			add_arg(ctx->instance, c, opts, long_options, optarg);
> > +			continue;
> > +		}
> > +
> >  		switch (c) {
> >  		case 'h':
> >  			usage(argv);
> > @@ -4663,6 +5076,26 @@ static void parse_record_options(int argc,
> >  			add_trigger(event, optarg);
> >  			break;
> >  
> > +		case 'A': {
> > +			char *name = NULL;
> > +			int cid = -1, port = -1;
> > +
> > +			if (!IS_RECORD(ctx))
> > +				die("-A is only allowed for record operations");
> > +
> > +			name = parse_guest_name(optarg, &cid, &port);
> > +			if (!name || cid == -1)
> > +				die("guest %s not found", optarg);
> > +			if (port == -1)
> > +				port = TRACE_AGENT_DEFAULT_PORT;
> > +
> > +			ctx->instance = create_instance(name);
> > +			ctx->instance->flags |= BUFFER_FL_GUEST;
> > +			ctx->instance->cid = cid;
> > +			ctx->instance->port = port;
> > +			add_instance(ctx->instance, 0);
> > +			break;
> > +		}
> >  		case 'F':
> >  			test_set_event_pid();
> >  			filter_task = 1;
> > @@ -4733,6 +5166,8 @@ static void parse_record_options(int argc,
> >  			ctx->disable = 1;
> >  			break;
> >  		case 'o':
> > +			if (IS_AGENT(ctx))
> > +				die("-o incompatible with agent recording");
> >  			if (host)
> >  				die("-o incompatible with -N");
> >  			if (IS_START(ctx))
> > @@ -4794,6 +5229,8 @@ static void parse_record_options(int argc,
> >  		case 'N':
> >  			if (!IS_RECORD(ctx))
> >  				die("-N only available with record");
> > +			if (IS_AGENT(ctx))
> > +				die("-N incompatible with agent recording");
> >  			if (ctx->output)
> >  				die("-N incompatible with -o");
> >  			host = optarg;
> > @@ -4890,6 +5327,16 @@ static void parse_record_options(int argc,
> >  		}
> >  	}
> >  
> > +	/* If --date is specified, prepend it to all guest VM flags */
> > +	if (ctx->date) {
> > +		struct buffer_instance *instance;
> > +
> > +		for_all_instances(instance) {
> > +			if (instance->flags & BUFFER_FL_GUEST)
> > +				add_argv(instance, "--date", true);
> > +		}
> > +	}
> > +
> >  	if (!ctx->filtered && ctx->instance->filter_mod)
> >  		add_func(&ctx->instance->filter_funcs,
> >  			 ctx->instance->filter_mod, "*");
> > @@ -4920,7 +5367,8 @@ static enum trace_type get_trace_cmd_type(enum trace_cmd cmd)
> >  		{CMD_stream, TRACE_TYPE_STREAM},
> >  		{CMD_extract, TRACE_TYPE_EXTRACT},
> >  		{CMD_profile, TRACE_TYPE_STREAM},
> > -		{CMD_start, TRACE_TYPE_START}
> > +		{CMD_start, TRACE_TYPE_START},
> > +		{CMD_record_agent, TRACE_TYPE_RECORD}
> >  	};
> >  
> >  	for (int i = 0; i < ARRAY_SIZE(trace_type_per_command); i++) {
> > @@ -4952,12 +5400,28 @@ static void finalize_record_trace(struct common_record_context *ctx)
> >  		if (instance->flags & BUFFER_FL_KEEP)
> >  			write_tracing_on(instance,
> >  					 instance->tracing_on_init_val);
> > +		if (instance->flags & BUFFER_FL_AGENT)
> > +			tracecmd_output_close(instance->network_handle);
> >  	}
> >  
> >  	if (host)
> >  		tracecmd_output_close(ctx->instance->network_handle);
> >  }
> >  
> > +static bool has_local_instances(void)
> > +{
> > +	struct buffer_instance *instance;
> > +
> > +	for_all_instances(instance) {
> > +		if (instance->flags & BUFFER_FL_GUEST)
> > +			continue;
> > +		if (host && instance->msg_handle)
> > +			continue;
> > +		return true;
> > +	}
> > +	return false;
> > +}
> > +
> >  /*
> >   * This function contains common code for the following commands:
> >   * record, start, stream, profile.
> > @@ -4986,7 +5450,6 @@ static void record_trace(int argc, char **argv,
> >  
> >  	/* Save the state of tracing_on before starting */
> >  	for_all_instances(instance) {
> > -
> >  		if (!ctx->manual && instance->flags & BUFFER_FL_PROFILE)
> >  			enable_profile(instance);
> >  
> > @@ -5003,14 +5466,16 @@ static void record_trace(int argc, char **argv,
> >  
> >  	page_size = getpagesize();
> >  
> > -	fset = set_ftrace(!ctx->disable, ctx->total_disable);
> > +	if (!(ctx->instance->flags & BUFFER_FL_GUEST))
> > +		fset = set_ftrace(!ctx->disable, ctx->total_disable);
> >  	tracecmd_disable_all_tracing(1);
> >  
> >  	for_all_instances(instance)
> >  		set_clock(instance);
> >  
> >  	/* Record records the date first */
> > -	if (IS_RECORD(ctx) && ctx->date)
> > +	if (ctx->date &&
> > +	    ((IS_RECORD(ctx) && has_local_instances()) || IS_AGENT(ctx)))
> >  		ctx->date2ts = get_date_to_ts();
> >  
> >  	for_all_instances(instance) {
> > @@ -5045,9 +5510,13 @@ static void record_trace(int argc, char **argv,
> >  		exit(0);
> >  	}
> >  
> > -	if (ctx->run_command)
> > +	if (ctx->run_command) {
> >  		run_cmd(type, (argc - optind) - 1, &argv[optind + 1]);
> > -	else {
> > +	} else if (ctx->instance && (ctx->instance->flags & BUFFER_FL_AGENT)) {
> > +		update_task_filter();
> > +		tracecmd_enable_tracing();
> > +		tracecmd_msg_wait_close(ctx->instance->msg_handle);
> > +	} else {
> >  		update_task_filter();
> >  		tracecmd_enable_tracing();
> >  		/* We don't ptrace ourself */
> > @@ -5057,6 +5526,8 @@ static void record_trace(int argc, char **argv,
> >  		printf("Hit Ctrl^C to stop recording\n");
> >  		while (!finished)
> >  			trace_or_sleep(type);
> > +
> > +		tell_guests_to_stop();
> >  	}
> >  
> >  	tracecmd_disable_tracing();
> > @@ -5068,6 +5539,9 @@ static void record_trace(int argc, char **argv,
> >  	if (!keep)
> >  		tracecmd_disable_all_tracing(0);
> >  
> > +	if (!latency)
> > +		wait_threads();
> > +
> >  	if (IS_RECORD(ctx)) {
> >  		record_data(ctx);
> >  		delete_thread_data();
> > @@ -5202,3 +5676,40 @@ void trace_record(int argc, char **argv)
> >  	record_trace(argc, argv, &ctx);
> >  	exit(0);
> >  }
> > +
> > +int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
> > +		       int cpus, int *fds,
> > +		       int argc, char **argv)
> > +{
> > +	struct common_record_context ctx;
> > +	char **argv_plus;
> > +
> > +	/* Reset optind for getopt_long */
> > +	optind = 1;
> > +	/*
> > +	 * argc is the number of elements in argv, but we need to convert
> > +	 * argc and argv into "trace-cmd", "record", argv.
> > +	 * where argc needs to grow by two.
> > +	 */
> > +	argv_plus = calloc(argc + 2, sizeof(char *));
> > +	if (!argv_plus)
> > +		return -ENOMEM;
> > +
> > +	argv_plus[0] = "trace-cmd";
> > +	argv_plus[1] = "record";
> > +	memmove(argv_plus + 2, argv, argc * sizeof(char *));
> > +	argc += 2;
> > +
> > +	parse_record_options(argc, argv_plus, CMD_record_agent, &ctx);
> > +	if (ctx.run_command)
> > +		return -EINVAL;
> > +
> > +	ctx.instance->fds = fds;
> > +	ctx.instance->flags |= BUFFER_FL_AGENT;
> > +	ctx.instance->msg_handle = msg_handle;
> > +	msg_handle->version = V3_PROTOCOL;
> > +	record_trace(argc, argv, &ctx);
> > +
> > +	free(argv_plus);
> > +	return 0;
> > +}
> > diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> > index 9ea1906..e845f50 100644
> > --- a/tracecmd/trace-usage.c
> > +++ b/tracecmd/trace-usage.c
> > @@ -231,11 +231,22 @@ static struct usage_help usage_help[] = {
> >  		"listen on a network socket for trace clients",
> >  		" %s listen -p port[-D][-o file][-d dir][-l logfile]\n"
> >  		"          Creates a socket to listen for clients.\n"
> > -		"          -D create it in daemon mode.\n"
> > +		"          -p port number to listen on.\n"
> > +		"          -D run in daemon mode.\n"
> >  		"          -o file name to use for clients.\n"
> >  		"          -d directory to store client files.\n"
> >  		"          -l logfile to write messages to.\n"
> >  	},
> > +#ifdef VSOCK
> > +	{
> > +		"agent",
> 
> In the future, it would be nice to allow agents to work with networks
> as well (in case vsock isn't available, but also across machines, where
> we would do a p2p to synchronize time stamps.
> 
> -- Steve
> 
> > +		"listen on a vsocket for trace clients",
> > +		" %s agent -p port[-D]\n"
> > +		"          Creates a vsocket to listen for clients.\n"
> > +		"          -p port number to listen on.\n"
> > +		"          -D run in daemon mode.\n"
> > +	},
> > +#endif
> >  	{
> >  		"list",
> >  		"list the available events, plugins or options",
> 
