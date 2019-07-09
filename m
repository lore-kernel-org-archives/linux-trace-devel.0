Return-Path: <SRS0=uJAW=VG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E85C73C46
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 13:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 760C62173E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 13:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfGINJV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 09:09:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbfGINJV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 09:09:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21C42214AF;
        Tue,  9 Jul 2019 13:09:19 +0000 (UTC)
Date:   Tue, 9 Jul 2019 09:09:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Josef Bacik <jbacik@fb.com>
Cc:     <kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 04/11] trace-cmd: add global functions for live tracing
Message-ID: <20190709090917.7705c1da@gandalf.local.home>
In-Reply-To: <1448053053-24188-5-git-send-email-jbacik@fb.com>
References: <1448053053-24188-1-git-send-email-jbacik@fb.com>
        <1448053053-24188-5-git-send-email-jbacik@fb.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 20 Nov 2015 15:57:26 -0500
Josef Bacik <jbacik@fb.com> wrote:

> We need a few functions to disable/enable tracing as well as add events to be
> enabled on the first instance, this patch turns a couple of these local
> functions into library functions.  Thanks,

Hi Josef,

Not sure you still use this, as it's not really a library function
anymore. But we are currently cleaning up the trace-cmd code to create
a real library, and doing it in baby steps. The
tracecmd_enable_events() function is causing some issues and it was
added by you. Are you OK if we remove it. At least temporarily until we
separate out the "enabling" part into the library?

Thanks!

-- Steve


> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  trace-cmd.h    |  5 +++++
>  trace-record.c | 45 +++++++++++++++++++++++++++------------------
>  2 files changed, 32 insertions(+), 18 deletions(-)
> 
> diff --git a/trace-cmd.h b/trace-cmd.h
> index b4fa7fd..9a9ca30 100644
> --- a/trace-cmd.h
> +++ b/trace-cmd.h
> @@ -268,6 +268,11 @@ int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long s
>  void tracecmd_stop_recording(struct tracecmd_recorder *recorder);
>  void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
>  long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
> +int tracecmd_add_event(const char *event_str, int stack);
> +void tracecmd_enable_events(void);
> +void tracecmd_disable_all_tracing(int disable_tracer);
> +void tracecmd_disable_tracing(void);
> +void tracecmd_enable_tracing(void);
>  
>  /* --- Plugin handling --- */
>  extern struct pevent_plugin_option trace_ftrace_options[];
> diff --git a/trace-record.c b/trace-record.c
> index 417b701..7c471ab 100644
> --- a/trace-record.c
> +++ b/trace-record.c
> @@ -841,7 +841,6 @@ static void update_ftrace_pids(int reset)
>  
>  static void update_event_filters(struct buffer_instance *instance);
>  static void update_pid_event_filters(struct buffer_instance *instance);
> -static void enable_tracing(void);
>  
>  /**
>   * make_pid_filter - create a filter string to all pids against @field
> @@ -1106,7 +1105,7 @@ static void run_cmd(enum trace_type type, int argc, char **argv)
>  	if (!pid) {
>  		/* child */
>  		update_task_filter();
> -		enable_tracing();
> +		tracecmd_enable_tracing();
>  		enable_ptrace();
>  		/*
>  		 * If we are using stderr for stdout, switch
> @@ -1795,7 +1794,7 @@ static int read_tracing_on(struct buffer_instance *instance)
>  	return ret;
>  }
>  
> -static void enable_tracing(void)
> +void tracecmd_enable_tracing(void)
>  {
>  	struct buffer_instance *instance;
>  
> @@ -1808,7 +1807,7 @@ static void enable_tracing(void)
>  		reset_max_latency();
>  }
>  
> -static void disable_tracing(void)
> +void tracecmd_disable_tracing(void)
>  {
>  	struct buffer_instance *instance;
>  
> @@ -1816,9 +1815,9 @@ static void disable_tracing(void)
>  		write_tracing_on(instance, 0);
>  }
>  
> -static void disable_all(int disable_tracer)
> +void tracecmd_disable_all_tracing(int disable_tracer)
>  {
> -	disable_tracing();
> +	tracecmd_disable_tracing();
>  
>  	if (disable_tracer) {
>  		disable_func_stack_trace();
> @@ -1991,6 +1990,11 @@ static void enable_events(struct buffer_instance *instance)
>  	}
>  }
>  
> +void tracecmd_enable_events(void)
> +{
> +	enable_events(first_instance);
> +}
> +
>  static void set_clock(struct buffer_instance *instance)
>  {
>  	char *path;
> @@ -3074,15 +3078,15 @@ static char *get_date_to_ts(void)
>  	}
>  
>  	for (i = 0; i < date2ts_tries; i++) {
> -		disable_tracing();
> +		tracecmd_disable_tracing();
>  		clear_trace();
> -		enable_tracing();
> +		tracecmd_enable_tracing();
>  
>  		gettimeofday(&start, NULL);
>  		write(tfd, STAMP, 5);
>  		gettimeofday(&end, NULL);
>  
> -		disable_tracing();
> +		tracecmd_disable_tracing();
>  		ts = find_time_stamp(pevent);
>  		if (!ts)
>  			continue;
> @@ -3699,6 +3703,11 @@ profile_add_event(struct buffer_instance *instance, const char *event_str, int s
>  	return 0;
>  }
>  
> +int tracecmd_add_event(const char *event_str, int stack)
> +{
> +	return profile_add_event(first_instance, event_str, stack);
> +}
> +
>  static void enable_profile(struct buffer_instance *instance)
>  {
>  	int stacktrace = 0;
> @@ -3891,7 +3900,7 @@ void trace_record (int argc, char **argv)
>  
>  		}
>  		update_first_instance(instance, topt);
> -		disable_tracing();
> +		tracecmd_disable_tracing();
>  		exit(0);
>  	} else if (strcmp(argv[1], "restart") == 0) {
>  		for (;;) {
> @@ -3922,7 +3931,7 @@ void trace_record (int argc, char **argv)
>  
>  		}
>  		update_first_instance(instance, topt);
> -		enable_tracing();
> +		tracecmd_enable_tracing();
>  		exit(0);
>  	} else if (strcmp(argv[1], "reset") == 0) {
>  		/* if last arg is -a, then -b and -d apply to all instances */
> @@ -3984,7 +3993,7 @@ void trace_record (int argc, char **argv)
>  			}
>  		}
>  		update_first_instance(instance, topt);
> -		disable_all(1);
> +		tracecmd_disable_all_tracing(1);
>  		set_buffer_size();
>  		clear_filters();
>  		clear_triggers();
> @@ -4314,7 +4323,7 @@ void trace_record (int argc, char **argv)
>  
>  	if (!extract) {
>  		fset = set_ftrace(!disable, total_disable);
> -		disable_all(1);
> +		tracecmd_disable_all_tracing(1);
>  
>  		for_all_instances(instance)
>  			set_clock(instance);
> @@ -4365,7 +4374,7 @@ void trace_record (int argc, char **argv)
>  	} else {
>  		if (!(type & (TRACE_TYPE_RECORD | TRACE_TYPE_STREAM))) {
>  			update_task_filter();
> -			enable_tracing();
> +			tracecmd_enable_tracing();
>  			exit(0);
>  		}
>  
> @@ -4373,7 +4382,7 @@ void trace_record (int argc, char **argv)
>  			run_cmd(type, (argc - optind) - 1, &argv[optind + 1]);
>  		else {
>  			update_task_filter();
> -			enable_tracing();
> +			tracecmd_enable_tracing();
>  			/* We don't ptrace ourself */
>  			if (do_ptrace && filter_pid >= 0)
>  				ptrace_attach(filter_pid);
> @@ -4383,7 +4392,7 @@ void trace_record (int argc, char **argv)
>  				trace_or_sleep(type);
>  		}
>  
> -		disable_tracing();
> +		tracecmd_disable_tracing();
>  		if (!latency)
>  			stop_threads(type);
>  	}
> @@ -4391,7 +4400,7 @@ void trace_record (int argc, char **argv)
>  	record_stats();
>  
>  	if (!keep)
> -		disable_all(0);
> +		tracecmd_disable_all_tracing(0);
>  
>  	/* extract records the date after extraction */
>  	if (extract && date) {
> @@ -4399,7 +4408,7 @@ void trace_record (int argc, char **argv)
>  		 * We need to start tracing, don't let other traces
>  		 * screw with our trace_marker.
>  		 */
> -		disable_all(1);
> +		tracecmd_disable_all_tracing(1);
>  		date2ts = get_date_to_ts();
>  	}
>  

