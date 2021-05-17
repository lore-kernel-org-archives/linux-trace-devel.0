Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABABC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26CFE61261
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbhEQNGW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 09:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhEQNGW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 09:06:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C775961076;
        Mon, 17 May 2021 13:05:05 +0000 (UTC)
Date:   Mon, 17 May 2021 09:05:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin shaik <sameeross1994@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Add support for setting tracers
Message-ID: <20210517090504.431fe8fd@gandalf.local.home>
In-Reply-To: <1621243446-7402-1-git-send-email-sameeross1994@gmail.com>
References: <1621243446-7402-1-git-send-email-sameeross1994@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Hi Sameer,

Remember, when submitting a new patch, you should always use -v2 (or
whatever the next version is). That way it's obvious that this is a new
version of the patch.

On Mon, 17 May 2021 14:54:06 +0530
Sameeruddin shaik <sameeross1994@gmail.com> wrote:

> tracefs_set_tracer - set the tracer
> tracefs_stop_tracer - clear the tracer

Actually, let's change the names to be:

	tracefs_tracer_set()
	tracefs_tracer_clear()

The "tracefs_tracer_" keeps all the functions related to tracers stating
with the same text.

"stop" is misleading, because you are not really stopping the tracer, and
"stop" does not match with "set". "clear" better term, and you even used
that in your description of the trace above.


> 
> Signed-off-by: Sameeruddin shaik <sameeross1994@gmail.com>
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 55ee867..0270a9e 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -173,4 +173,23 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
>  int tracefs_function_notrace(struct tracefs_instance *instance, const char *filter,
>  			     const char *module, unsigned int flags);
>  
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
> index 6ef17f6..d772f93 100644
> --- a/src/tracefs-tools.c
> +++ b/src/tracefs-tools.c
> @@ -25,6 +25,30 @@ __hidden pthread_mutex_t toplevel_lock = PTHREAD_MUTEX_INITIALIZER;
>  #define TRACE_FILTER		"set_ftrace_filter"
>  #define TRACE_NOTRACE		"set_ftrace_notrace"
>  #define TRACE_FILTER_LIST	"available_filter_functions"
> +#define CUR_TRACER		"current_tracer"
> +
> +#define TRACERS \
> +	C(NOP,                  "nop"),			\
> +	C(FUNCTION,             "function"),            \
> +	C(FUNCTION_GRAPH,       "function_graph"),      \
> +	C(IRQSOFF,              "irqsoff"),             \
> +	C(PREEMPTOFF,           "preemptoff"),          \
> +	C(PREEMPTIRQSOFF,       "preemptirqsoff"),      \
> +	C(WAKEUP,               "wakeup"),              \
> +	C(WAKEUP_RT,            "wakeup_rt"),	\
> +	C(WAKEUP_DL,            "wakeup_dl"),           \
> +	C(MMIOTRACE,            "mmiotrace"),           \
> +	C(HWLAT,                "hwlat"),               \
> +	C(BRANCH,               "branch"),              \
> +	C(BLOCK,                "block")
> +
> +#undef C
> +#define C(a, b) b
> +const char *tracers[] = { TRACERS };
> +
> +#undef C
> +#define C(a, b) TRACEFS_TRACER_##a
> +const int tracer_enums[] = { TRACERS };
>  
>  /* File descriptor for Top level set_ftrace_filter  */
>  static int ftrace_filter_fd = -1;
> @@ -910,3 +934,68 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
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
> + * tracefs_set_tracer - function to set the tracer
> + * @instance: ftrace instance, can be NULL for top tracing instance
> + * @tracer: Tracer that has to be set, which can be integer from 0 - 13
> + * or enum value
> + */
> +
> +int tracefs_set_tracer(struct tracefs_instance *instance, enum tracefs_tracers tracer)
> +{
> +	char *tracer_path = NULL;
> +	const char *t = NULL;
> +	int ret = -1;
> +	int fd = -1;
> +	int i;
> +
> +	tracer_path = tracefs_instance_get_file(instance, CUR_TRACER);
> +	if (!tracer_path)
> +		return -1;
> +
> +	fd = open(tracer_path, O_WRONLY);
> +	if (fd < 0) {
> +		errno = -ENOENT;
> +		goto out;
> +	}
> +
> +	if (tracer < 0 || tracer > ARRAY_SIZE(tracers)) {
> +		errno = -ENODEV;
> +		goto out;
> +	}

Space needed here, as well as a comment.

> +	if (tracer == tracer_enums[tracer])
> +		t = tracers[tracer];
> +	else {
> +		for (i = 0; i < ARRAY_SIZE(tracer_enums); i++) {
> +			if (tracer == tracer_enums[i]) {
> +				t = tracers[i];
> +				break;
> +			}
> +		}
> +	}
> +	if (!t) {
> +		errno = -EINVAL;
> +		goto out;
> +	}
> +	ret = write_tracer(fd, t);
> + out:
> +	tracefs_put_tracing_file(tracer_path);
> +	close(fd);
> +	return ret;

BTW, when a reviewer of your code gives a code example of a better
implementation, you should express that in your change log. I usually use:

 Suggested-by: ...

So you should have:

 Suggested-by: Steven Rostedt <rostedt@goodmis.org>

as the above is pretty much exact copy of the code snippet I posted.

Here's an example of what I have done when I do the same:

 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.12-rc5&id=ceaaa12904df07d07ea8975abbf04c4d60e46956

-- Steve

> +}
> +
> +int  tracefs_stop_tracer(struct tracefs_instance *instance)
> +{
> +	return tracefs_set_tracer(instance, TRACEFS_TRACER_NOP);
> +}

