Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3983C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C503E619F3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhCXBY5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Mar 2021 21:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231422AbhCXBYk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 21:24:40 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF19C619EC;
        Wed, 24 Mar 2021 01:24:39 +0000 (UTC)
Date:   Tue, 23 Mar 2021 21:24:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 04/18] trace-cmd: Add new trace-cmd clock tsc2nsec
Message-ID: <20210323212438.2453087c@oasis.local.home>
In-Reply-To: <20210322095945.259300-5-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
        <20210322095945.259300-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Mar 2021 11:59:31 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>  
> +static struct tep_handle *get_ftrace_tep(void)
> +{
> +	const char *systems[] = {"ftrace", NULL};
> +	struct tep_handle *tep;
> +	char *buf;
> +	int size;
> +	int ret;
> +
> +	tep = tracefs_local_events_system(NULL, systems);
> +	if (!tep)
> +		return NULL;
> +	tep_set_file_bigendian(tep, tracecmd_host_bigendian());
> +	buf = read_top_file("events/header_page", &size);
> +	if (!buf)
> +		goto error;
> +	ret = tep_parse_header_page(tep, buf, size, sizeof(unsigned long));
> +	free(buf);
> +	if (ret < 0)
> +		goto error;
> +
> +	return tep;
> +
> +error:
> +	tep_free(tep);
> +	return NULL;
> +}
> +
>  /*
>   * Try to write the date into the ftrace buffer and then
>   * read it back, mapping the timestamp to the date.
>   */
>  static char *get_date_to_ts(void)
>  {
> -	const char *systems[] = {"ftrace", NULL};
> +	struct tep_handle *tep;
>  	unsigned long long min = -1ULL;
>  	unsigned long long diff;
>  	unsigned long long stamp;
>  	unsigned long long min_stamp;
>  	unsigned long long min_ts;
>  	unsigned long long ts;
> -	struct tep_handle *tep;
>  	struct timespec start;
>  	struct timespec end;
>  	char *date2ts = NULL;
> -	char *path;
> -	char *buf;
> -	int size;
>  	int tfd;
> -	int ret;
>  	int i;
>  
>  	/* Set up a tep to read the raw format */
> -	tep = tracefs_local_events_system(NULL, systems);
> +	tep = get_ftrace_tep();
>  	if (!tep) {
>  		warning("failed to alloc tep, --date ignored");
>  		return NULL;
>  	}
> -
> -	tep_set_file_bigendian(tep, tracecmd_host_bigendian());
> -
> -	buf = read_top_file("events/header_page", &size);
> -	if (!buf)
> -		goto out_pevent;
> -	ret = tep_parse_header_page(tep, buf, size, sizeof(unsigned long));
> -	free(buf);
> -	if (ret < 0) {
> -		warning("Can't parse header page, --date ignored");
> -		goto out_pevent;
> -	}
> -
> -	path = tracefs_get_tracing_file("trace_marker");
> -	tfd = open(path, O_WRONLY);
> -	tracefs_put_tracing_file(path);
> +	tfd = tracefs_instance_file_open(NULL, "trace_marker", O_WRONLY);

The above looks like a clean up worthy of its own patch ;-)

>  	if (tfd < 0) {
>  		warning("Can not open 'trace_marker', --date ignored");
>  		goto out_pevent;
> @@ -4520,7 +4531,7 @@ static char *get_date_to_ts(void)
>  		clock_gettime(CLOCK_REALTIME, &end);
>  
>  		tracecmd_disable_tracing();
> -		ts = find_time_stamp(tep);
> +		ts = find_time_stamp(tep, NULL);
>  		if (!ts)
>  			continue;
>  
> @@ -5381,6 +5392,7 @@ void init_top_instance(void)
>  }
>  
>  enum {
> +	OPT_tsc2nsec		= 240,
>  	OPT_fork		= 241,
>  	OPT_tsyncinterval	= 242,
>  	OPT_user		= 243,
> @@ -5676,6 +5688,78 @@ check_instance_die(struct buffer_instance *instance, char *param)
>  		    tracefs_instance_get_name(instance->tracefs), param);
>  }
>  
> +static bool clock_is_supported(struct tracefs_instance *instance, char *clock)
> +{
> +	char *all_clocks = NULL;
> +	char *ret = NULL;
> +
> +	all_clocks  = tracefs_instance_file_read(instance, "trace_clock", NULL);
> +	if (!all_clocks)
> +		return false;
> +
> +	ret = strstr(all_clocks, clock);

I think you want to check to make sure that the clock is really a
match. Otherwise if we have a clock called "x86" and another called
"x86-tsc", If you search for "x86" it will say it's a match because it
matched x86-tsc. I think you need to add:

	if (ret &&
	    (ret == all_clocks ||
	     ret[-1] == ' ' ||
	     ret[-1] == '[')) {
		switch (ret[strlen(clock)]) {
		case ' ':
		case '\0':
		case ']':
			break;
		default:
			ret = NULL;
		}
	} else {
		ret = NULL;
	}


> +	free(all_clocks);
> +
> +	if (ret)
> +		return true;
> +	return false;

the above can also be written as:

	return ret != NULL;

> +}
> +
> +#ifdef PERF
> +static int get_tsc_nsec(int *shift, int *mult)
> +{
> +	static int cpu_shift, cpu_mult;
> +	static int supported;
> +	int cpus = tracecmd_count_cpus();
> +	struct trace_perf perf;
> +	int i;
> +
> +	if (supported)
> +		goto out;
> +
> +	supported = -1;
> +	if (trace_perf_init(&perf, 1, 0, getpid()))
> +		return -1;
> +	if (trace_perf_open(&perf))
> +		return -1;
> +	cpu_shift = perf.mmap->time_shift;
> +	cpu_mult = perf.mmap->time_mult;
> +	for (i = 1; i < cpus; i++) {
> +		trace_perf_close(&perf);
> +		if (trace_perf_init(&perf, 1, i, getpid()))
> +			break;
> +		if (trace_perf_open(&perf))
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
> +	supported = 1;
> +out:
> +	if (supported < 0)
> +		return -1;
> +
> +	if (shift)
> +		*shift = cpu_shift;
> +	if (mult)
> +		*mult = cpu_mult;
> +
> +	return 0;
> +}
> +#else
> +static int get_tsc_nsec(int *shift, int *mult)
> +{
> +	return -1;
> +}
> +#endif
> +
>  static void parse_record_options(int argc,
>  				 char **argv,
>  				 enum trace_cmd curr_cmd,
> @@ -5725,6 +5809,7 @@ static void parse_record_options(int argc,
>  			{"module", required_argument, NULL, OPT_module},
>  			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
>  			{"fork", no_argument, NULL, OPT_fork},
> +			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
>  			{NULL, 0, NULL, 0}
>  		};
>  
> @@ -5870,7 +5955,15 @@ static void parse_record_options(int argc,
>  			break;
>  		case 'C':
>  			check_instance_die(ctx->instance, "-C");
> -			ctx->instance->clock = optarg;
> +			if (!strncmp(optarg, TSCNSEC_CLOCK, strlen(TSCNSEC_CLOCK))) {
> +				ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
> +						   &ctx->tsc2nsec.mult);
> +				if (ret || !clock_is_supported(NULL, TSC_CLOCK))
> +					die("Clock %s is not supported", optarg);
> +				ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
> +				ctx->instance->clock = strdup(TSC_CLOCK);
> +			} else
> +				ctx->instance->clock = optarg;

Clock is supported check should also be a separate patch, as it is
unrelated to the tsc2nsec code. That is, it holds its own as a
separate change.

>  			ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
>  			if (is_top_instance(ctx->instance))
>  				guest_sync_set = true;
> @@ -6125,6 +6218,13 @@ static void parse_record_options(int argc,
>  				die("--fork option used for 'start' command only");
>  			fork_process = true;
>  			break;
> +		case OPT_tsc2nsec:
> +			ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
> +					   &ctx->tsc2nsec.mult);
> +			if (ret)
> +				die("TSC to nanosecond is not supported");
> +			ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
> +			break;
>  		case OPT_quiet:
>  		case 'q':
>  			quiet = true;
> @@ -6272,6 +6372,66 @@ static bool has_local_instances(void)
>  	return false;
>  }
>  
> +/*
> + * Get the current clock value
> + */
> +#define CLOCK_INST_NAME	"_clock_instance_"
> +static unsigned long long get_clock_now(const char *clock)
> +{
> +	struct tracefs_instance *ts_instance = NULL;
> +	unsigned long long ts = 0;
> +	struct tep_handle *tep;
> +	int tfd = -1;
> +	int ret;
> +
> +	/* Set up a tep to read the raw format */
> +	tep = get_ftrace_tep();
> +	if (!tep)
> +		return 0;
> +	ts_instance = tracefs_instance_create(CLOCK_INST_NAME);
> +	if (!ts_instance)
> +		goto out;
> +	if (clock) {
> +		ret = tracefs_instance_file_write(ts_instance, "trace_clock", clock);
> +		if (ret < strlen(clock))
> +			goto out;
> +	}
> +	tfd = tracefs_instance_file_open(ts_instance, "trace_marker", O_WRONLY);
> +	if (tfd < 0)
> +		goto out;
> +	tracefs_trace_on(ts_instance);
> +	ret = write(tfd, STAMP, 5);

If we had the tracefs_print code, we could use that here :-)


> +	tracefs_trace_off(ts_instance);
> +	ts = find_time_stamp(tep, ts_instance);
> +
> +out:
> +	if (tfd >= 0)
> +		close(tfd);

tfd is always < 0 on all jumps to out. The logic works the same as:

	close(tfd);
 out:

And you don't have to initialize tfd to -1 in the beginning either.


> +	if (ts_instance) {
> +		if (tracefs_instance_is_new(ts_instance))
> +			tracefs_instance_destroy(ts_instance);
> +		tracefs_instance_free(ts_instance);
> +	}
> +	tep_free(tep);
> +

Another method for goto's so you don't need the "if (ts_instance)" is to have:

	ts_instance = tracefs_instance_create(CLOCK_INST_NAME);
	if (!ts_instance)
		goto out_free;

	[..]

out:
	if (tracefs_instance_is_new(ts_instance))
		tracefs_instance_destroy(ts_instance);
	tracefs_instance_free(ts_instaence);
out_free:
	tep_free(tep);

The above is done often in the kernel.

-- Steve

> +	return ts;
> +}
> +
> +static void get_tsc_offset(struct common_record_context *ctx)
> +{
> +	struct buffer_instance *instance;
> +
> +	for_all_instances(instance) {
> +		if (is_guest(instance) || !instance->clock)
> +			return;
> +
> +		ctx->tsc2nsec.offset = get_clock_now(instance->clock);
> +		return;
> +	}
> +
> +	ctx->tsc2nsec.offset = get_clock_now(NULL);
> +}
> +
>  /*
>   * This function contains common code for the following commands:
>   * record, start, stream, profile.
> @@ -6330,6 +6490,9 @@ static void record_trace(int argc, char **argv,
>  	for_all_instances(instance)
>  		set_clock(instance);
>  
> +	if (ctx->tsc2nsec.mult)
> +		get_tsc_offset(ctx);
> +
>  	/* Record records the date first */
>  	if (ctx->date &&
>  	    ((IS_RECORD(ctx) && has_local_instances()) || IS_RECORD_AGENT(ctx)))

