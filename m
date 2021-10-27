Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C5EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Oct 2021 18:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F0D5610A6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Oct 2021 18:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhJ0SNK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 14:13:10 -0400
Received: from out0.migadu.com ([94.23.1.103]:50212 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233243AbhJ0SNJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 14:13:09 -0400
Date:   Thu, 28 Oct 2021 02:11:24 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1635358242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dl3cVaqjWM9LnqfKLc6iTszd6L/h9XviuRFHViQuAbw=;
        b=tgG6RkNp6EKfIsFPq4s9KQcPeMmN/kDRAcImc8ht4rBU93HXSbgesn1VQbgXiKKEBdT0y4
        61qomOijayTsUUQ2i0hfkPBMClGnIy5NYugFuvscZ6Tg+BbEH8a4FQkSmUXU3BNsYBWWpC
        h9x4kIsUP3fhG3hhVhCWPmhfzZmtQ6M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Tao Zhou <tao.zhou@linux.dev>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tao Zhou <tao.zhou@linux.dev>
Subject: Re: [PATCH V6 11/20] rtla/osnoise: Add the hist mode
Message-ID: <YXmWTOXHYXFduayt@geo.homenetwork>
References: <cover.1635284863.git.bristot@kernel.org>
 <fede3c3805cb7a70bd7c8d60ba2c5ce290cc6e1e.1635284863.git.bristot@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fede3c3805cb7a70bd7c8d60ba2c5ce290cc6e1e.1635284863.git.bristot@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: tao.zhou@linux.dev
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Oct 27, 2021 at 12:06:22AM +0200, Daniel Bristot de Oliveira wrote:

> The rtla osnoise hist tool collects all osnoise:sample_threshold
> occurrence in a histogram, displaying the results in a user-friendly
> way. The tool also allows many configurations of the osnoise tracer
> and the collection of the tracer output.
> 
> Here is one example of the rtla osnoise hist tool output:
>   ---------- %< ----------
>  [root@f34 ~]# rtla osnoise hist --bucket-size 10 --entries 100 -c 0-8 -d 1M -r 9000 -P F:1
>  # RTLA osnoise histogram
>  # Time unit is microseconds (us)
>  # Duration:   0 00:01:00
>  Index   CPU-000   CPU-001   CPU-002   CPU-003   CPU-004   CPU-005   CPU-006   CPU-007   CPU-008
>  0           430       434       352       455       440       463       467       436       484
>  10           88        88        92       141       120       100       126       166       100
>  20           19         7        12        22         8         8        13        13        16
>  30            6         0         2         0         1         2         2         1         0
>  50            0         0         0         0         0         0         1         0         0
>  over:         0         0         0         0         0         0         0         0         0
>  count:      543       529       458       618       569       573       609       616       600
>  min:          0         0         0         0         0         0         0         0         0
>  avg:          0         0         0         0         0         0         0         0         0
>  max:         30        20        30        20        30        30        50        30        20
>   ---------- >% ----------
> 
> Running
>  - rtla osnoise hist --help
> 
> provides information about the available options.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Tom Zanussi <zanussi@kernel.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Clark Williams <williams@redhat.com>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
> Cc: linux-rt-users@vger.kernel.org
> Cc: linux-trace-devel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
> ---
>  tools/tracing/rtla/src/osnoise.c      |   6 +-
>  tools/tracing/rtla/src/osnoise.h      |   1 +
>  tools/tracing/rtla/src/osnoise_hist.c | 793 ++++++++++++++++++++++++++
>  3 files changed, 799 insertions(+), 1 deletion(-)
>  create mode 100644 tools/tracing/rtla/src/osnoise_hist.c
> 
> diff --git a/tools/tracing/rtla/src/osnoise.c b/tools/tracing/rtla/src/osnoise.c
> index b9866dfdda66..6c6358ebf66f 100644
> --- a/tools/tracing/rtla/src/osnoise.c
> +++ b/tools/tracing/rtla/src/osnoise.c
> @@ -790,7 +790,8 @@ static void osnoise_usage(void)
>  		"  usage: [rtla] osnoise [MODE] ...",
>  		"",
>  		"  modes:",
> -		"     top  - prints the summary from osnoise tracer",
> +		"     top   - prints the summary from osnoise tracer",
> +		"     hist  - prints a histogram of osnoise samples",
>  		"",
>  		"if no MODE is given, the top mode is called, passing the arguments",
>  		NULL,
> @@ -825,6 +826,9 @@ int osnoise_main(int argc, char *argv[])
>  	} else if (strcmp(argv[1], "top") == 0) {
>  		osnoise_top_main(argc-1, &argv[1]);
>  		exit(0);
> +	} else if (strcmp(argv[1], "hist") == 0) {
> +		osnoise_hist_main(argc-1, &argv[1]);
> +		exit(0);
>  	}
>  
>  usage:
> diff --git a/tools/tracing/rtla/src/osnoise.h b/tools/tracing/rtla/src/osnoise.h
> index 4882ee275ea0..dbaad7a162a2 100644
> --- a/tools/tracing/rtla/src/osnoise.h
> +++ b/tools/tracing/rtla/src/osnoise.h
> @@ -82,5 +82,6 @@ void osnoise_destroy_tool(struct osnoise_tool *top);
>  struct osnoise_tool *osnoise_init_tool(char *tool_name);
>  struct osnoise_tool *osnoise_init_trace_tool(char *tracer);
>  
> +int osnoise_hist_main(int argc, char *argv[]);
>  int osnoise_top_main(int argc, char **argv);
>  int osnoise_main(int argc, char **argv);
> diff --git a/tools/tracing/rtla/src/osnoise_hist.c b/tools/tracing/rtla/src/osnoise_hist.c
> new file mode 100644
> index 000000000000..c93f30d69795
> --- /dev/null
> +++ b/tools/tracing/rtla/src/osnoise_hist.c
> @@ -0,0 +1,793 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2021 Red Hat Inc, Daniel Bristot de Oliveira <bristot@kernel.org>
> + */
> +
> +#include <getopt.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <signal.h>
> +#include <unistd.h>
> +#include <errno.h>
> +#include <stdio.h>
> +#include <time.h>
> +
> +#include "utils.h"
> +#include "osnoise.h"
> +
> +struct osnoise_hist_params {
> +	char			*cpus;
> +	char			*monitored_cpus;
> +	char			*trace_output;
> +	unsigned long long	runtime;
> +	unsigned long long	period;
> +	long long		stop_us;
> +	long long		stop_total_us;
> +	int			sleep_time;
> +	int			duration;
> +	int			set_sched;
> +	int			output_divisor;
> +	struct sched_attr	sched_param;
> +
> +	char			no_header;
> +	char			no_summary;
> +	char			no_index;
> +	char			with_zeros;
> +	int			bucket_size;
> +	int			entries;
> +};
> +
> +struct osnoise_hist_cpu {
> +	int			*samples;
> +	int			*thread;
> +
> +	int			count;
> +	int			thread_count;
> +
> +	unsigned long long	min_sample;
> +	unsigned long long	sum_sample;
> +	unsigned long long	max_sample;
> +
> +	unsigned long long	min_thread;
> +	unsigned long long	sum_thread;
> +	unsigned long long	max_thread;
> +};
> +
> +struct osnoise_hist_data {
> +	struct tracefs_hist	*trace_hist;
> +	struct osnoise_hist_cpu	*hist;
> +	int			entries;
> +	int			bucket_size;
> +	int			nr_cpus;
> +};
> +
> +/*
> + * osnoise_free_histogram - free runtime data
> + */
> +static void
> +osnoise_free_histogram(struct osnoise_hist_data *data)
> +{
> +	int cpu;
> +
> +	/* one histogram for IRQ and one for thread, per CPU */
> +	for (cpu = 0; cpu < data->nr_cpus; cpu++) {
> +		if (data->hist[cpu].samples)
> +			free(data->hist[cpu].samples);
> +
> +		if (data->hist[cpu].thread)
> +			free(data->hist[cpu].thread);
> +	}
> +
> +	/* one set of histograms per CPU */
> +	if (data->hist)
> +		free(data->hist);
> +
> +	free(data);
> +}
> +
> +/*
> + * osnoise_alloc_histogram - alloc runtime data
> + */
> +static struct osnoise_hist_data
> +*osnoise_alloc_histogram(int nr_cpus, int entries, int bucket_size)
> +{
> +	struct osnoise_hist_data *data;
> +	int cpu;
> +
> +	data = calloc(1, sizeof(*data));
> +	if (!data)
> +		return NULL;
> +
> +	data->entries = entries;
> +	data->bucket_size = bucket_size;
> +	data->nr_cpus = nr_cpus;
> +
> +	/* one set of histograms per CPU */
> +	data->hist = calloc(1, sizeof(*data->hist) * nr_cpus);
> +	if (!data->hist)
> +		goto cleanup;
> +
> +	/* one histogram for IRQ and one for thread, per cpu */
> +	for (cpu = 0; cpu < nr_cpus; cpu++) {
> +		data->hist[cpu].samples = calloc(1, sizeof(*data->hist) * (entries + 1));

@samples is a pointer to int and used for int array. The "sizeof(*data->hist)"
should be "sizeof(int)" or am I totally wrong.

The same in PATCH 13.



Thanks,
Tao
