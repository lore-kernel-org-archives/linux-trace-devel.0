Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06732C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Mar 2021 21:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB31864F97
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Mar 2021 21:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhCPVR4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Mar 2021 17:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232958AbhCPVRw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Mar 2021 17:17:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A599A64F91;
        Tue, 16 Mar 2021 21:17:51 +0000 (UTC)
Date:   Tue, 16 Mar 2021 17:17:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 02/12] trace-cmd: Add logic for TSC to nanosecond
 conversion
Message-ID: <20210316171749.105af2e7@gandalf.local.home>
In-Reply-To: <20210315061832.168495-3-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
        <20210315061832.168495-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 15 Mar 2021 08:18:22 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Added new logic to get multiplier and shift for converting TSC trace clock
> to nanoseconds, using perf kernel interface. The new logic is used only in
> host - guest tracing use case, when the user did not specify any tracing
> clock and KVM time sync plugin is available. Then the x86-tsc clock is
> auto selected for the current tracing session. There is one limitation -
> per CPU multiplier or shift is not supported.

I would break this up into two patches. One that adds the perf mult shift
logic, and even allow users to use it! As TSC clocks are still faster than
the local clock (as the local clock needs to do the multiplier and shift at
every event while recording). It would be a feature to have this:

 trace-cmd record --tsc2nsec ...

Where it would use -C x86-tsc clock (or perhaps this can work for other
architectures), and then use the perf multi/shift to determine the
nanoseconds.

I would get this working first, before trying to use that for guests and
hosts.


> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/include/trace-local.h |   7 ++
>  tracecmd/trace-record.c        | 124 ++++++++++++++++++++++++++-------
>  2 files changed, 107 insertions(+), 24 deletions(-)
> 
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index 6e39d27d..8a88ab9c 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -199,6 +199,12 @@ struct filter_pids {
>  	int exclude;
>  };
>  
> +struct tsc_nsec {
> +	int mult;
> +	int shift;
> +	int offset;

The above is twelve bytes in size (even on 64 bit machines).

> +};
> +
>  struct buffer_instance {
>  	struct buffer_instance	*next;
>  	char			*name;
> @@ -234,6 +240,7 @@ struct buffer_instance {
>  	int			get_procmap;
>  
>  	const char		*clock;
> +	struct tsc_nsec		tsc2nsec;
>  	unsigned int		*client_ports;

You put the twelve byte structure between two pointers. That's going to
guarantee a 4 byte hole on 64 bit machines.

You want to try to keep pointers together, and keep 4 byte in pairs such
that the other fields can line up on 8 byte alignment.


>  
>  	struct trace_seq	*s_save;
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index a0eb0385..117e4f17 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -57,6 +57,7 @@
>  #define MAX_LATENCY	"tracing_max_latency"
>  #define STAMP		"stamp"
>  #define FUNC_STACK_TRACE "func_stack_trace"
> +#define TSC_CLOCK	"x86-tsc"
>  
>  enum trace_type {
>  	TRACE_TYPE_RECORD	= 1,
> @@ -4104,6 +4105,7 @@ enum {
>  	DATA_FL_NONE		= 0,
>  	DATA_FL_DATE		= 1,
>  	DATA_FL_OFFSET		= 2,
> +	DATA_FL_GUEST		= 4,
>  };
>  
>  static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
> @@ -5676,6 +5678,100 @@ check_instance_die(struct buffer_instance *instance, char *param)
>  		    tracefs_instance_get_name(instance->tracefs), param);
>  }
>  
> +static int get_tsc_nsec(int *shift, int *mult, int *offset)
> +{
> +	int cpus = tracecmd_count_cpus();
> +	int cpu_shift, cpu_mult, cpu_offset;
> +	struct trace_perf perf;
> +	int ret;
> +	int i;
> +
> +	ret = trace_perf_init(&perf, 1, 0, getpid());
> +	if (!ret)
> +		ret = trace_perf_open(&perf);
> +	if (ret)
> +		return ret;
> +	cpu_shift = perf.mmap->time_shift;
> +	cpu_mult = perf.mmap->time_mult;
> +	/* ToDo set the offset, should we use perf.mmap->time_offset ? */
> +	cpu_offset = 0;

As discussed, may just be creating an instance, setting the clock to
x86-tsc (we'll need to make this arch independent when other archs have
similar functionality), write to the trace marker, then read it, and use
that timestamp as a starting point.

> +	for (i = 1; i < cpus; i++) {
> +		trace_perf_close(&perf);
> +		ret = trace_perf_init(&perf, 1, i, getpid());
> +		if (!ret)

I would just add:
		if (ret)
			break;

And not have the next call done in the if statement. That's awkward to read.

> +			ret = trace_perf_open(&perf);
> +		if (ret)
> +			break;
> +		if (perf.mmap->time_shift != cpu_shift ||
> +		    perf.mmap->time_mult != cpu_mult) {
> +			warning("Found different TSC multiplier and shift for CPU %d: %d;%d instead of %d;%d",
> +				i, perf.mmap->time_mult, perf.mmap->time_shift, cpu_mult, cpu_shift);
> +			break;
> +		}
> +	}
> +	trace_perf_close(&perf);
> +	if (i < cpus)
> +		return -1;
> +
> +	*shift = cpu_shift;
> +	*mult = cpu_mult;
> +	*offset = cpu_offset;
> +
> +	return 0;
> +}
> +
> +static void set_vsync_clock(void)
> +{
> +	const char *clock = top_instance.clock;
> +	struct buffer_instance *instance;
> +	bool tsc2nsec = false;
> +	int shift, mult, offset;
> +
> +	/*
> +	 * If no clock is specified for the top trace instance AND
> +	 * KVM time sync protocol is available AND
> +	 * TSC to nsec multiplier and shift are available:
> +	 * force using the x86-tsc clock for this host-guest tracing session
> +	 * and store TSC to nsec multiplier and shift.
> +	 */
> +	if (!clock && tsync_proto_is_supported("kvm") &&
> +	    !get_tsc_nsec(&shift, &mult, &offset) && mult) {
> +		top_instance.clock = strdup(TSC_CLOCK);
> +		if (!top_instance.clock)
> +			die("Could not allocate top instance clock");
> +		clock = top_instance.clock;

Why is this using the top_instance? What if the user had done:

 # trace-cmd record -B host -e kvm -e sched -A guest -e sched


-- Steve


> +		top_instance.tsc2nsec.mult = mult;
> +		top_instance.tsc2nsec.shift = shift;
> +		top_instance.tsc2nsec.offset = offset;
> +		tsc2nsec = true;
> +	}
> +
> +	if (!clock && !top_instance.tsync_loop_interval)
> +		return;
> +	for_all_instances(instance) {
> +		if (clock) {
> +			/* use the same clock in all tracing peers */
> +			if (is_guest(instance) &&
> +			    !(instance->flags & BUFFER_FL_HAS_CLOCK)) {
> +				add_argv(instance,
> +					 (char *)top_instance.clock, true);
> +				add_argv(instance, "-C", true);
> +				if (!instance->clock) {
> +					instance->clock = strdup((char *)top_instance.clock);
> +					if (!instance->clock)
> +						die("Could not allocate instance clock");
> +				}
> +				if (tsc2nsec) {
> +					instance->tsc2nsec.mult = mult;
> +					instance->tsc2nsec.shift = shift;
> +					instance->tsc2nsec.offset = offset;
> +				}
> +			}
> +		}
> +		instance->tsync_loop_interval = top_instance.tsync_loop_interval;
> +	}
> +}
> +
>  static void parse_record_options(int argc,
>  				 char **argv,
>  				 enum trace_cmd curr_cmd,
> @@ -5691,7 +5787,6 @@ static void parse_record_options(int argc,
>  	int name_counter = 0;
>  	int negative = 0;
>  	struct buffer_instance *instance, *del_list = NULL;
> -	bool guest_sync_set = false;
>  	int do_children = 0;
>  	int fpids_count = 0;
>  
> @@ -5825,6 +5920,7 @@ static void parse_record_options(int argc,
>  			ctx->instance->port = port;
>  			ctx->instance->name = name;
>  			add_instance(ctx->instance, 0);
> +			ctx->data_flags |= DATA_FL_GUEST;
>  			break;
>  		}
>  		case 'F':
> @@ -5872,8 +5968,6 @@ static void parse_record_options(int argc,
>  			check_instance_die(ctx->instance, "-C");
>  			ctx->instance->clock = optarg;
>  			ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
> -			if (is_top_instance(ctx->instance))
> -				guest_sync_set = true;
>  			break;
>  		case 'v':
>  			negative = 1;
> @@ -6118,7 +6212,6 @@ static void parse_record_options(int argc,
>  		case OPT_tsyncinterval:
>  			cmd_check_die(ctx, CMD_set, *(argv+1), "--tsync-interval");
>  			top_instance.tsync_loop_interval = atoi(optarg);
> -			guest_sync_set = true;
>  			break;
>  		case OPT_fork:
>  			if (!IS_START(ctx))
> @@ -6145,26 +6238,6 @@ static void parse_record_options(int argc,
>  				add_argv(instance, "--date", true);
>  		}
>  	}
> -	if (guest_sync_set) {
> -	/* If -C is specified, prepend clock to all guest VM flags */
> -		for_all_instances(instance) {
> -			if (top_instance.clock) {
> -				if (is_guest(instance) &&
> -				    !(instance->flags & BUFFER_FL_HAS_CLOCK)) {
> -					add_argv(instance,
> -						 (char *)top_instance.clock,
> -						 true);
> -					add_argv(instance, "-C", true);
> -					if (!instance->clock) {
> -						instance->clock = strdup((char *)top_instance.clock);
> -						if (!instance->clock)
> -							die("Could not allocate instance clock");
> -					}
> -				}
> -			}
> -			instance->tsync_loop_interval = top_instance.tsync_loop_interval;
> -		}
> -	}
>  
>  	if (!ctx->filtered && ctx->instance->filter_mod)
>  		add_func(&ctx->instance->filter_funcs,
> @@ -6301,6 +6374,9 @@ static void record_trace(int argc, char **argv,
>  	if (!ctx->output)
>  		ctx->output = DEFAULT_INPUT_FILE;
>  
> +	if (ctx->data_flags & DATA_FL_GUEST)
> +		set_vsync_clock();
> +
>  	make_instances();
>  
>  	/* Save the state of tracing_on before starting */

