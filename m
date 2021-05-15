Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B46C433B4
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 May 2021 16:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB72961221
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 May 2021 16:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhEOQlV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 May 2021 12:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230330AbhEOQlU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 May 2021 12:41:20 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48B3A61221;
        Sat, 15 May 2021 16:40:07 +0000 (UTC)
Date:   Sat, 15 May 2021 12:40:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin shaik <sameeross1994@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Add support for setting tracers
Message-ID: <20210515124005.20f8dab3@oasis.local.home>
In-Reply-To: <1621177159-28156-1-git-send-email-sameeross1994@gmail.com>
References: <1621177159-28156-1-git-send-email-sameeross1994@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Hi Sameer,


On Sun, 16 May 2021 20:29:19 +0530
Sameeruddin shaik <sameeross1994@gmail.com> wrote:

> tracefs_set_tracer - set the tracer
> tracefs_stop_tracer - clear the tracer
> 
> Signed-off-by: Sameeruddin shaik <sameeross1994@gmail.com>
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 55ee867..47d3282 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -173,4 +173,26 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
>  int tracefs_function_notrace(struct tracefs_instance *instance, const char *filter,
>  			     const char *module, unsigned int flags);
>  
> +/*
> + * Tracers
> + */
> +enum tracefs_tracers {
> +	TRACEFS_TRACER_NOP = 0,
> +	TRACEFS_TRACER_FUNCTION,
> +	TRACEFS_TRACER_FUNCTION_GRAPH,
> +	TRACEFS_TRACER_IRQSOFF,
> +	TRACEFS_TRACER_PREEMPTOFF,
> +	TRACEFS_TRACER_PREEMPTIRQSOFF,
> +	TRACEFS_TRACER_WAKEUP,
> +	TRACEFS_TRACER_WAKEUP_RT,
> +	TRACEFS_TRACER_WAKEUP_DL,
> +	TRACEFS_TRACER_MMIOTRACE,
> +	TRACEFS_TRACER_HWLAT,
> +	TRACEFS_TRACER_BRANCH,
> +	TRACEFS_TRACER_BLOCK,
> +};
> +
> +int tracefs_set_tracer(struct tracefs_instance *instance, enum tracefs_tracers tracer);
> +
> +int tracefs_stop_tracer(struct tracefs_instance *instance);
>  #endif /* _TRACE_FS_H */
> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> index 6ef17f6..ceddeda 100644
> --- a/src/tracefs-tools.c
> +++ b/src/tracefs-tools.c
> @@ -25,6 +25,7 @@ __hidden pthread_mutex_t toplevel_lock = PTHREAD_MUTEX_INITIALIZER;
>  #define TRACE_FILTER		"set_ftrace_filter"
>  #define TRACE_NOTRACE		"set_ftrace_notrace"
>  #define TRACE_FILTER_LIST	"available_filter_functions"
> +#define TRACER			"current_tracer"
>  
>  /* File descriptor for Top level set_ftrace_filter  */
>  static int ftrace_filter_fd = -1;
> @@ -910,3 +911,88 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
>  	tracefs_put_tracing_file(filter_path);
>  	return ret;
>  }
> +
> +int write_tracer(int fd, const char *tracer)
> +{
> +	int ret;
> +
> +	ret = write(fd, tracer, strlen(tracer));
> +	if (ret < strlen(tracer))
> +		return -1;
> +	return ret;
> +}
> +
> +/**
> +* tracefs_set_tracer - fucntion to set the tracer
> +* @instance: ftrace instance, can be NULL for top tracing instance
> +* @tracer: Tracer that has to be set, which can be integer from 0 - 13
> +* or and enum value
> +*/
> +
> +int tracefs_set_tracer(struct tracefs_instance *instance, enum tracefs_tracers tracer)
> +{
> +	char *tracer_path;
> +	int ret = -1;
> +	int fd = -1;
> +
> +	tracer_path = tracefs_instance_get_file(instance, TRACER);
> +	if (!tracer_path)
> +		return -1;
> +
> +	fd = open(tracer_path, O_WRONLY);
> +	if (fd < 0)
> +		goto out;
> +
> +	switch(tracer) {
> +	case 0:
> +		ret = write_tracer(fd , "nop");
> +		break;
> +	case 1:
> +		ret = write_tracer(fd, "function");
> +		break;
> +	case 2:
> +		ret = write_tracer(fd, "function_graph");
> +		break;
> +	case 3:
> +		ret = write_tracer(fd, "irqsoff");
> +		break;
> +	case 4:
> +		ret = write_tracer(fd, "preemptoff");
> +		break;
> +	case 5:
> +		ret = write_tracer(fd, "preemptirqsoff");
> +		break;
> +	case 6:
> +		ret = write_tracer(fd, "wakeup");
> +		break;
> +	case 7:
> +		ret = write_tracer(fd, "wakeup_rt");
> +		break;
> +	case 8:
> +		ret = write_tracer(fd, "wakeup_dl");
> +		break;
> +	case 9:
> +		ret = write_tracer(fd, "mmiotrace");
> +		break;
> +	case 10:
> +		ret = write_tracer(fd, "hwlat");
> +		break;
> +	case 11:
> +		ret = write_tracer(fd, "branch");
> +		break;
> +	case 12:
> +		ret = write_tracer(fd, "blk");
> +		break;
> +	default:

Note, hardcoded numbers above is frowned upon in computer science in
general. But you already have the enums, why didn't you use them?

But besides the point, you don't even need a switch statement.

#define TRACERS \
	C(NOP,			"nop"),			\
	C(FUNCTION,		"function"),		\
	C(FUNCTION_GRAPH,	"function_graph"),	\
	C(IRQSOFF,		"irqsoff"),		\
	C(PREEMPTOFF,		"preemptoff"),		\
	C(PREEMPTIQRSOFF,	"preemptirqsoff"),	\
	C(WAKEUP,		"wakeup"),		\
	C(WAKEUP_RT,		"wakeup_rt")'		\
	C(WAKEUP_DL,		"wakeup_dl"),		\
	C(MMIOTRACE,		"mmiotrace"),		\
	C(HWLAT,		"hwlat"),		\
	C(BRANCH,		"branch"),		\
	C(BLOCK,		"block")

#undef C
#define C(a,b) b

const char *tracers[] = { TRACERS };

#undef C
#define C(a,b) TRACEFS_TRACER_##a

const int *tracer_enums[] = { TRACERS };

#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))

{
	const char *t = NULL;
	[..]

	if (tracer < 0 || tracer >= ARRAY_SIZE(tracers)) {
		errno = -ENODEV;
		return -1;
	}

	/* if we didn't make a mistake in our mapping */
	if (tracer == tracer_enums[tracer]) {
		t = tracers[tracer];
	} else {
		for (i = 0; i < ARRAY_SIZE(tracer_enums)) {
			if (tracer == tracer_enums[tracer]) {
				t = tracers[i];
				break;
			}
		}
	}

	if (!t) {
		/* Something went horribly wrong */
		errno = -EINVAL;
		return -1;
	}

	ret = write_tracer(fd, t);

Or something like the above. Much more robust, much more maintainable.

-- Steve



> +		ret = -1;
> +	}
> +
> + out:
> +	tracefs_put_tracing_file(tracer_path);
> +	return ret;
> +}
> +
> +int  tracefs_stop_tracer(struct tracefs_instance *instance)
> +{
> +	return tracefs_set_tracer(instance, TRACEFS_TRACER_NOP);
> +}

