Return-Path: <SRS0=xXu/=7N=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE1CC433DF
	for <linux-trace-devel@archiver.kernel.org>; Sun, 31 May 2020 21:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 831EF206C3
	for <linux-trace-devel@archiver.kernel.org>; Sun, 31 May 2020 21:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgEaVwp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 31 May 2020 17:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727084AbgEaVwo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 31 May 2020 17:52:44 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2DC8206C3;
        Sun, 31 May 2020 21:52:43 +0000 (UTC)
Date:   Sun, 31 May 2020 17:52:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] trace-cmd: Add new subcommand "set"
Message-ID: <20200531175242.26e56f26@oasis.local.home>
In-Reply-To: <20200529070220.482278-1-tz.stoyanov@gmail.com>
References: <20200529070220.482278-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 29 May 2020 10:02:19 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

>  
> +static void set_cmd_check(struct common_record_context *ctx, char *param)
> +{
> +	if (IS_CMDSET(ctx)) {
> +		die("%s has no effect with set command\n"
> +		    "Did you mean 'record'?", param);
> +	}
> +}
> +
>  static void parse_record_options(int argc,
>  				 char **argv,
>  				 enum trace_cmd curr_cmd,
> @@ -5803,6 +5814,9 @@ static void parse_record_options(int argc,
>  
>  	init_common_record_context(ctx, curr_cmd);
>  
> +	if (IS_CMDSET(ctx))
> +		keep = 1;
> +
>  	for (;;) {
>  		int option_index = 0;
>  		int ret;
> @@ -5854,6 +5868,7 @@ static void parse_record_options(int argc,
>  			usage(argv);
>  			break;
>  		case 'a':
> +			set_cmd_check(ctx, "-a");
>  			if (IS_EXTRACT(ctx)) {
>  				add_all_instances();
>  			} else {
> @@ -5927,10 +5942,12 @@ static void parse_record_options(int argc,
>  			break;
>  		}
>  		case 'F':
> +			set_cmd_check(ctx, "-F");
>  			test_set_event_pid(ctx->instance);
>  			filter_task = 1;
>  			break;

I was thinking that perhaps we should have -F stay, and that way
anything we add can be filtered with the command. I think the same
should be allowed for start too. There's been several times I wanted
the code to just trace a command (not record it though), but couldn't
do it with trace-cmd.

>  		case 'G':
> +			set_cmd_check(ctx, "-G");

Hmm, I just realized that we don't have -G documented.


>  			ctx->global = 1;
>  			break;
>  		case 'P':
> @@ -6006,6 +6023,7 @@ static void parse_record_options(int argc,
>  			ctx->disable = 1;
>  			break;
>  		case 'o':
> +			set_cmd_check(ctx, "-o");
>  			if (IS_RECORD_AGENT(ctx))
>  				die("-o incompatible with agent recording");
>  			if (host)
> @@ -6043,10 +6061,12 @@ static void parse_record_options(int argc,
>  			save_option(ctx->instance, "stacktrace");
>  			break;
>  		case 'H':
> +			set_cmd_check(ctx, "-H");
>  			add_hook(ctx->instance, optarg);
>  			ctx->events = 1;
>  			break;
>  		case 's':
> +			set_cmd_check(ctx, "-s");
>  			if (IS_EXTRACT(ctx)) {
>  				if (optarg)
>  					usage(argv);
> @@ -6058,15 +6078,18 @@ static void parse_record_options(int argc,
>  			sleep_time = atoi(optarg);
>  			break;
>  		case 'S':
> +			set_cmd_check(ctx, "-S");
>  			ctx->manual = 1;
>  			/* User sets events for profiling */
>  			if (!event)
>  				ctx->events = 0;
>  			break;
>  		case 'r':
> +			set_cmd_check(ctx, "-r");
>  			rt_prio = atoi(optarg);
>  			break;
>  		case 'N':
> +			set_cmd_check(ctx, "-N");
>  			if (!IS_RECORD(ctx))
>  				die("-N only available with record");
>  			if (IS_RECORD_AGENT(ctx))
> @@ -6086,6 +6109,7 @@ static void parse_record_options(int argc,
>  			ctx->instance->cpumask = alloc_mask_from_hex(ctx->instance, optarg);
>  			break;
>  		case 't':
> +			set_cmd_check(ctx, "-t");
>  			if (IS_EXTRACT(ctx))
>  				ctx->topt = 1; /* Extract top instance also */
>  			else
> @@ -6103,20 +6127,24 @@ static void parse_record_options(int argc,
>  				ctx->instance->flags |= BUFFER_FL_PROFILE;
>  			break;
>  		case 'k':
> +			set_cmd_check(ctx, "-k");
>  			keep = 1;
>  			break;
>  		case 'i':
>  			ignore_event_not_found = 1;
>  			break;
>  		case OPT_user:
> +			set_cmd_check(ctx, "--user");

If we allow commands, then perhaps we can keep this too.

>  			ctx->user = strdup(optarg);
>  			if (!ctx->user)
>  				die("Failed to allocate user name");
>  			break;
>  		case OPT_procmap:
> +			set_cmd_check(ctx, "--proc-map");
>  			ctx->instance->get_procmap = 1;
>  			break;
>  		case OPT_date:
> +			set_cmd_check(ctx, "--date");
>  			ctx->date = 1;
>  			if (ctx->data_flags & DATA_FL_OFFSET)
>  				die("Can not use both --date and --ts-offset");
> @@ -6126,12 +6154,15 @@ static void parse_record_options(int argc,
>  			func_stack = 1;
>  			break;
>  		case OPT_nosplice:
> +			set_cmd_check(ctx, "--nosplice");
>  			recorder_flags |= TRACECMD_RECORD_NOSPLICE;
>  			break;
>  		case OPT_nofifos:
> +			set_cmd_check(ctx, "--nofifos");
>  			no_fifos = true;
>  			break;
>  		case OPT_profile:
> +			set_cmd_check(ctx, "--profile");
>  			handle_init = trace_init_profile;
>  			ctx->instance->flags |= BUFFER_FL_PROFILE;
>  			ctx->events = 1;
> @@ -6145,9 +6176,11 @@ static void parse_record_options(int argc,
>  			dup2(2, 1);
>  			break;
>  		case OPT_bycomm:
> +			set_cmd_check(ctx, "--by-comm");
>  			trace_profile_set_merge_like_comms();
>  			break;
>  		case OPT_tsoffset:
> +			set_cmd_check(ctx, "--ts-offset");
>  			ctx->date2ts = strdup(optarg);
>  			if (ctx->data_flags & DATA_FL_DATE)
>  				die("Can not use both --date and --ts-offset");
> @@ -6160,9 +6193,11 @@ static void parse_record_options(int argc,
>  				die("Could not allocate option");
>  			break;
>  		case OPT_cmdlines_size:
> +			set_cmd_check(ctx, "--cmdlines-size");

--cmdlines-size is something we definitely want to keep here. It's a
file in the tracefs directory, and something that we should allow
trace-cmd set to modify.


>  			ctx->saved_cmdlines_size = atoi(optarg);
>  			break;
>  		case OPT_no_filter:
> +			set_cmd_check(ctx, "--no-filter");
>  			no_filter = true;
>  			break;
>  		case OPT_debug:
> @@ -6176,6 +6211,7 @@ static void parse_record_options(int argc,
>  			ctx->filtered = 0;
>  			break;
>  		case OPT_tsyncinterval:
> +			set_cmd_check(ctx, "--tsync-interval");
>  			top_instance.tsync.loop_interval = atoi(optarg);
>  			guest_sync_set = true;
>  			break;
> @@ -6221,8 +6257,8 @@ static void parse_record_options(int argc,
>  		die(" -c can only be used with -F (or -P with event-fork support)");
>  
>  	if ((argc - optind) >= 2) {
> -		if (IS_START(ctx))
> -			die("Command start does not take any commands\n"
> +		if (IS_START(ctx) || IS_CMDSET(ctx))
> +			die("Commands start and set do not take any commands\n"

Perhaps we should add a patch first that lets trace-cmd start run commands?

-- Steve

>  			    "Did you mean 'record'?");
>  		if (IS_EXTRACT(ctx))
>  			die("Command extract does not take any commands\n"
> @@ -6265,7 +6301,8 @@ static enum trace_type get_trace_cmd_type(enum trace_cmd cmd)
>  		{CMD_extract, TRACE_TYPE_EXTRACT},
>  		{CMD_profile, TRACE_TYPE_STREAM},
>  		{CMD_start, TRACE_TYPE_START},
> -		{CMD_record_agent, TRACE_TYPE_RECORD}
> +		{CMD_record_agent, TRACE_TYPE_RECORD},
> +		{CMD_set, TRACE_TYPE_SET}
>  	};
>  
>  	for (int i = 0; i < ARRAY_SIZE(trace_type_per_command); i++) {
> @@ -6342,8 +6379,10 @@ static void record_trace(int argc, char **argv,
>  		ctx->topt = 1;
>  
>  	update_first_instance(ctx->instance, ctx->topt);
> -	check_doing_something();
> -	check_function_plugin();
> +	if (!IS_CMDSET(ctx)) {
> +		check_doing_something();
> +		check_function_plugin();
> +	}
>  
>  	if (!ctx->output)
>  		ctx->output = DEFAULT_INPUT_FILE;
> @@ -6371,7 +6410,8 @@ static void record_trace(int argc, char **argv,
>  
>  	if (!is_guest(ctx->instance))
>  		fset = set_ftrace(!ctx->disable, ctx->total_disable);
> -	tracecmd_disable_all_tracing(1);
> +	if (!IS_CMDSET(ctx))
> +		tracecmd_disable_all_tracing(1);
>  
>  	for_all_instances(instance)
>  		set_clock(instance);
> @@ -6412,7 +6452,8 @@ static void record_trace(int argc, char **argv,
>  			start_threads(type, ctx);
>  	} else {
>  		update_task_filter();
> -		tracecmd_enable_tracing();
> +		if (!IS_CMDSET(ctx))
> +			tracecmd_enable_tracing();
>  		exit(0);
>  	}
>  
> @@ -6486,6 +6527,15 @@ void trace_start(int argc, char **argv)
>  	exit(0);
>  }
>  
