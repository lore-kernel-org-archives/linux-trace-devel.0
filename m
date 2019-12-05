Return-Path: <SRS0=a/08=Z3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC174C43603
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Dec 2019 00:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A57112077B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Dec 2019 00:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbfLEAqx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 19:46:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbfLEAqx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 19:46:53 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39FDD2077B;
        Thu,  5 Dec 2019 00:46:52 +0000 (UTC)
Date:   Wed, 4 Dec 2019 19:46:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v17 12/18] trace-cmd: Implement new option in trace.dat
 file: TRACECMD_OPTION_TIME_SHIFT
Message-ID: <20191204194650.7055bc1c@gandalf.local.home>
In-Reply-To: <20191203103522.482684-13-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
        <20191203103522.482684-13-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  3 Dec 2019 12:35:16 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> 
> The TRACECMD_OPTION_TIME_SHIFT is used when synchronizing trace time stamps between
> two trace.dat files. It contains multiple long long (time, offset) pairs, describing
> time stamps _offset_, measured in the given local _time_. The content of the option
> buffer is:
>  8 bytes - long long integer, ID of the tracing session
>  4 bytes - integer, count of timestamp offsets
>  long long array of size _count_, local time in which the offset is measured
>  long long array of size _count_, offset of the time stamps
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  include/trace-cmd/trace-cmd.h |   6 ++
>  lib/trace-cmd/trace-input.c   | 170 +++++++++++++++++++++++++++++++++-
>  2 files changed, 174 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 90fa146..1240b4a 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -87,6 +87,7 @@ enum {
>  	TRACECMD_OPTION_VERSION,
>  	TRACECMD_OPTION_PROCMAPS,
>  	TRACECMD_OPTION_TRACEID,
> +	TRACECMD_OPTION_TIME_SHIFT,
>  };
>  
>  enum {
> @@ -130,6 +131,11 @@ void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
>  void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
>  unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
>  unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle);
> +int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
> +			      unsigned long long trace_id,
> +			      char *name,
> +			      int *vcpu_count, int *cpu_pid);
> +unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle);
>  
>  void tracecmd_parse_trace_clock(struct tracecmd_input *handle, char *file, int size);
>  
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 40d9825..a6b675a 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -74,6 +74,18 @@ struct input_buffer_instance {
>  	size_t			offset;
>  };
>  
> +struct ts_offset_sample {
> +	long long	time;
> +	long long	offset;
> +};
> +
> +struct host_trace_info {
> +	bool			sync_enable;
> +	unsigned long long	trace_id;
> +	int			ts_samples_count;
> +	struct ts_offset_sample	*ts_samples;
> +};
> +
>  struct tracecmd_input {
>  	struct tep_handle	*pevent;
>  	struct tep_plugin_list	*plugin_list;
> @@ -92,6 +104,7 @@ struct tracecmd_input {
>  	bool			use_pipe;
>  	struct cpu_data 	*cpu_data;
>  	long long		ts_offset;
> +	struct host_trace_info	host;
>  	double			ts2secs;
>  	char *			cpustats;
>  	char *			uname;
> @@ -1072,6 +1085,67 @@ static void free_next(struct tracecmd_input *handle, int cpu)
>  	free_record(record);
>  }
>  
> +static inline unsigned long long
> +timestamp_correction_calc(unsigned long long ts, struct ts_offset_sample *min,
> +			  struct ts_offset_sample *max)
> +{
> +	long long tscor = min->offset +
> +			(((((long long)ts) - min->time)*
> +			(max->offset-min->offset))/(max->time-min->time));

When every I see a division like this, I'd like to think we should add:

	long long offset = ((long long)ts - min->time) *
			(max->offset - min->offset);
	long long delta = max->time - min->time;
	long long tscor = min->offset +
			(offset + delta / 2) / delta;

This handles rounding of delta instead of truncating. Also, it's best
to have spaces around operators, as it's hard to see where the variable
stops and the operation beings with max->time-min->time.

> +
> +	if (tscor < 0)
> +		return ts - llabs(tscor);

I'm curious to why the test and using llabs, instead of just returning:

	ts + tscor ?

Is there a difference between that when tscor is negative and using
llabs?

> +
> +	return ts + tscor;
> +}
> +
> +static unsigned long long timestamp_correct(unsigned long long ts,
> +					    struct tracecmd_input *handle)
> +{
> +	struct host_trace_info	*host = &handle->host;
> +	int min, mid, max;
> +
> +	if (handle->ts_offset)
> +		return ts + handle->ts_offset;
> +
> +	if (!host->sync_enable || !host->ts_samples_count || !host->ts_samples)
> +		return ts;

Hmm, perhaps we should make host->sync_enable false when
host->ts_samples_count or host->ts_samples are NULL and remove the
extra checks? (slight optimization)

> +
> +	/* We have one sample, nothing to calc here */
> +	if (host->ts_samples_count == 1)
> +		return ts + host->ts_samples[0].offset;
> +
> +	/* We have two samples, nothing to search here */
> +	if (host->ts_samples_count == 2)
> +		return timestamp_correction_calc(ts, &host->ts_samples[0],
> +						 &host->ts_samples[1]);
> +
> +	/* We have more than two samples */
> +	if (ts <= host->ts_samples[0].time)
> +		return timestamp_correction_calc(ts,
> +						 &host->ts_samples[0],
> +						 &host->ts_samples[1]);
> +	else if (ts >= host->ts_samples[host->ts_samples_count-1].time)
> +		return timestamp_correction_calc(ts,
> +						 &host->ts_samples[host->ts_samples_count-2],
> +						 &host->ts_samples[host->ts_samples_count-1]);
> +	min = 0;
> +	max = host->ts_samples_count-1;
> +	mid = (min + max)/2;
> +	while (min <= max) {
> +		if (ts < host->ts_samples[mid].time)
> +			max = mid - 1;
> +		else if (ts > host->ts_samples[mid].time)
> +			min = mid + 1;
> +		else
> +			break;
> +		mid = (min + max)/2;
> +	}

Hmm, probably should libc's bsearch() instead of open coding a binary
search.

> +
> +	return timestamp_correction_calc(ts, &host->ts_samples[mid],
> +					 &host->ts_samples[mid+1]);
> +}
> +
>  /*
>   * Page is mapped, now read in the page header info.
>   */
> @@ -1093,7 +1167,7 @@ static int update_page_info(struct tracecmd_input *handle, int cpu)
>  		    kbuffer_subbuffer_size(kbuf));
>  		return -1;
>  	}
> -	handle->cpu_data[cpu].timestamp = kbuffer_timestamp(kbuf) + handle->ts_offset;
> +	handle->cpu_data[cpu].timestamp = timestamp_correct(kbuffer_timestamp(kbuf), handle);
>  
>  	if (handle->ts2secs)
>  		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
> @@ -1820,7 +1894,7 @@ read_again:
>  		goto read_again;
>  	}
>  
> -	handle->cpu_data[cpu].timestamp = ts + handle->ts_offset;
> +	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, handle);
>  
>  	if (handle->ts2secs) {
>  		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
> @@ -2143,6 +2217,47 @@ void tracecmd_set_ts2secs(struct tracecmd_input *handle,
>  	handle->use_trace_clock = false;
>  }
>  
> +static int tsync_offset_cmp(const void *a, const void *b)
> +{
> +	struct ts_offset_sample *ts_a = (struct ts_offset_sample *)a;
> +	struct ts_offset_sample *ts_b = (struct ts_offset_sample *)b;
> +
> +	if (ts_a->time > ts_b->time)
> +		return 1;
> +	if (ts_a->time < ts_b->time)
> +		return -1;
> +	return 0;
> +}

We have the compare function for bsearch() here.

> +
> +static void tsync_offset_load(struct tracecmd_input *handle, char *buf)
> +{
> +	struct host_trace_info *host = &handle->host;
> +	long long *buf8 = (long long *)buf;
> +	int i, j;
> +
> +	for (i = 0; i < host->ts_samples_count; i++) {
> +		host->ts_samples[i].time = tep_read_number(handle->pevent,
> +							   buf8 + i, 8);
> +		host->ts_samples[i].offset = tep_read_number(handle->pevent,
> +						buf8 + host->ts_samples_count+i, 8);
> +	}
> +	qsort(host->ts_samples, host->ts_samples_count,
> +	      sizeof(struct ts_offset_sample), tsync_offset_cmp);
> +	/* Filter possible samples with equal time */
> +	for (i = 0, j = 0; i < host->ts_samples_count; i++) {
> +		if (i == 0 || host->ts_samples[i].time != host->ts_samples[i-1].time)
> +			host->ts_samples[j++] = host->ts_samples[i];
> +	}
> +	host->ts_samples_count = j;
> +	host->sync_enable = true;
> +}
> +
> +static void trace_tsync_offset_free(struct host_trace_info *host)
> +{
> +	free(host->ts_samples);
> +	host->ts_samples = NULL;
> +}
> +
>  static int trace_pid_map_cmp(const void *a, const void *b)
>  {
>  	struct tracecmd_proc_addr_map *m_a = (struct tracecmd_proc_addr_map *)a;
> @@ -2323,6 +2438,7 @@ static int handle_options(struct tracecmd_input *handle)
>  	struct input_buffer_instance *buffer;
>  	struct hook_list *hook;
>  	char *buf;
> +	int sampes_size;

"sampes"? Is this short for "samples"? Just use "samples_size" then.


>  	int cpus;
>  
>  	/* By default, use usecs, unless told otherwise */
> @@ -2370,6 +2486,28 @@ static int handle_options(struct tracecmd_input *handle)
>  			offset = strtoll(buf, NULL, 0);
>  			handle->ts_offset += offset;
>  			break;
> +		case TRACECMD_OPTION_TIME_SHIFT:
> +			/*
> +			 * long long int (8 bytes) trace session ID
> +			 * int (4 bytes) count of timestamp offsets.
> +			 * long long array of size [count] of times,
> +			 *      when the offsets were calculated.
> +			 * long long array of size [count] of timestamp offsets.
> +			 */
> +			if (size < 12 || handle->flags & TRACECMD_FL_IGNORE_DATE)
> +				break;
> +			handle->host.trace_id = tep_read_number(handle->pevent,
> +								buf, 8);
> +			handle->host.ts_samples_count = tep_read_number(handle->pevent,
> +									buf + 8, 4);
> +			sampes_size = (8 * handle->host.ts_samples_count);
> +			if (size != (12 + (2 * sampes_size)))
> +				break;
> +			handle->host.ts_samples = malloc(2 * sampes_size);
> +			if (!handle->host.ts_samples)
> +				return -ENOMEM;
> +			tsync_offset_load(handle, buf + 12);
> +			break;
>  		case TRACECMD_OPTION_CPUSTAT:
>  			buf[size-1] = '\n';
>  			cpustats = realloc(cpustats, cpustats_size + size + 1);
> @@ -3078,6 +3216,8 @@ void tracecmd_close(struct tracecmd_input *handle)
>  	trace_pid_map_free(handle->pid_maps);
>  	handle->pid_maps = NULL;
>  
> +	trace_tsync_offset_free(&handle->host);
> +
>  	if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
>  		tracecmd_close(handle->parent);
>  	else {
> @@ -3532,3 +3672,29 @@ unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle)
>  {
>  	return handle->trace_id;
>  }
> +
> +/**
> + * tracecmd_get_tsync_peer - get the trace session id of the peer host
> + * @handle: input handle for the trace.dat file
> + *
> + * Returns the trace id of the peer host, written in the trace file
> + *
> + * This information is stored in guest trace.dat file
> + */
> +unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle)
> +{
> +	return handle->host.trace_id;
> +}
> +
> +/**
> + * tracecmd_enable_tsync - enable / disable the timestamps correction
> + * @handle: input handle for the trace.dat file
> + * @enable: enable / disable the timestamps correction
> + *
> + * Enables or disables timestamps correction on file load, using the array of
> + * recorded time offsets
> + */
> +void tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable)
> +{

Perhaps here we should check if samples are allocated already, and only
allow it to be enabled if they are.

-- Steve


> +	handle->host.sync_enable = enable;
> +}

