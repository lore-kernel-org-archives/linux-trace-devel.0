Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54365C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Oct 2021 16:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D4B260FBF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Oct 2021 16:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbhJ0Qb6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 12:31:58 -0400
Received: from out0.migadu.com ([94.23.1.103]:18866 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234648AbhJ0Qb6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 12:31:58 -0400
Date:   Thu, 28 Oct 2021 00:30:10 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1635352171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iJygunIDQUImXBdKA9TgZJIUtzm0QeOg+IW+54VjIXs=;
        b=vTpSIFIvkgdIInH49wzw5EeO1jmYzzF3G0QMBpM/U6p78ak8Y4/XFdQeVfZDpJTdbg3GKN
        NHR/kfMtVM4MDFd4QFqBudEb+CtQot7a8sPRRKYg86H5KJyav6mj9hmi/CeedmZXeIv0Qs
        zDn+JsNo91xykL6zZHXegD5sPvxJ5qk=
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
Subject: Re: [PATCH V6 09/20] rtla: Add osnoise tool
Message-ID: <YXl+krtOjd5CzDRc@geo.homenetwork>
References: <cover.1635284863.git.bristot@kernel.org>
 <a389dec45805f3221fe1a8e86c725ae24d16ec82.1635284863.git.bristot@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a389dec45805f3221fe1a8e86c725ae24d16ec82.1635284863.git.bristot@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: tao.zhou@linux.dev
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Oct 27, 2021 at 12:06:20AM +0200, Daniel Bristot de Oliveira wrote:

> +/*
> + * osnoise_set_cpus - configure osnoise to run on *cpus
> + *
> + * "osnoise/cpus" file is used to set the cpus in which osnoise/timerlat
> + * will run. This function opens this file, saves the current value,
> + * and set the cpus passed as argument.
> + */
> +int osnoise_set_cpus(struct osnoise_context *context, char *cpus)
> +{
> +	char *osnoise_cpus = tracefs_get_tracing_file("osnoise/cpus");
> +	char curr_cpus[1024];
> +	int retval;
> +
> +	context->cpus_fd = open(osnoise_cpus, O_RDWR);
> +	if (!context->cpus_fd)
> +		goto out_err;

The above check should be "context->cpus_fd < 0".

> +	retval = read(context->cpus_fd, &curr_cpus, sizeof(curr_cpus));
> +	if (!retval)
> +		goto out_close;
> +	context->orig_cpus = strdup(curr_cpus);
> +	if (!context->orig_cpus)
> +		goto out_err;

Need to close ->cpus_fd;

  if (!context->orig_cpus)
    goto out_close;

> +	retval = write(context->cpus_fd, cpus, strlen(cpus) + 1);
> +	if (!retval)
> +		goto out_err;

Same as above. Use "goto out_close" instead.

> +	tracefs_put_tracing_file(osnoise_cpus);
> +
> +	return 0;
> +
> +out_close:
> +	close(context->cpus_fd);
> +	context->cpus_fd = -1;
> +out_err:
> +	tracefs_put_tracing_file(osnoise_cpus);
> +	return 1;
> +}
> +
> +/*
> + * osnoise_restore_cpus - restore the original "osnoise/cpus"
> + *
> + * osnoise_set_cpus() saves the original data for the "osnoise/cpus"
> + * file. This function restore the original config it was previously
> + * modified.
> + */
> +void osnoise_restore_cpus(struct osnoise_context *context)
> +{
> +	int retval;
> +
> +	if (!context->orig_cpus)
> +		return;
> +
> +	retval = write(context->cpus_fd, context->orig_cpus, strlen(context->orig_cpus));

__osnoise_write_runtime() check "context->cpus_fd == -1".
Is it possible here we need to check "context->cpus_fd == -1".

> +	if (!retval)
> +		err_msg("could not restore original osnoise cpus\n");
> +
> +	free(context->orig_cpus);
> +}
> +
> +/*
> + * osnoise_get_runtime - return the original "osnoise/runtime_us" value
> + *
> + * It also saves the value to be restored.
> + */
> +unsigned long long osnoise_get_runtime(struct osnoise_context *context)
> +{
> +	char buffer[BUFF_U64_STR_SIZE];
> +	char *runtime_path;
> +	int retval;
> +
> +	if (context->runtime_us)
> +		return context->runtime_us;
> +
> +	runtime_path = tracefs_get_tracing_file("osnoise/runtime_us");
> +
> +	context->runtime_fd = open(runtime_path, O_RDWR);
> +	if (!context->runtime_fd)
> +		goto out_err;

To check context->runtime_fd < 0.

> +	retval = read(context->runtime_fd, &buffer, sizeof(buffer));
> +	if (!retval)
> +		goto out_close;
> +
> +	context->runtime_us = get_long_from_str(buffer);
> +	if (!context->runtime_us)
> +		goto out_close;
> +
> +	context->orig_runtime_us = context->runtime_us;
> +
> +	tracefs_put_tracing_file(runtime_path);
> +
> +	return context->runtime_us;
> +
> +out_close:
> +	close(context->runtime_fd);
> +	context->runtime_fd = -1;
> +out_err:
> +	tracefs_put_tracing_file(runtime_path);
> +	return 0;
> +}
> +
> +/*
> + * osnoise_get_period - return the original "osnoise/period_us" value
> + *
> + * It also saves the value to be restored.
> + */
> +unsigned long long osnoise_get_period(struct osnoise_context *context)
> +{
> +	char buffer[BUFF_U64_STR_SIZE];
> +	char *period_path;
> +	int retval;
> +
> +	if (context->period_us)
> +		return context->period_us;
> +
> +	period_path = tracefs_get_tracing_file("osnoise/period_us");
> +
> +	context->period_fd = open(period_path, O_RDWR);
> +	if (!context->period_fd)
> +		goto out_err;

To check context->period_fd < 0.

> +	retval = read(context->period_fd, &buffer, sizeof(buffer));
> +	if (!retval)
> +		goto out_close;
> +
> +	context->period_us = get_long_from_str(buffer);
> +	if (!context->period_us)
> +		goto out_close;
> +
> +	context->orig_period_us = context->period_us;
> +
> +	tracefs_put_tracing_file(period_path);
> +
> +	return context->period_us;
> +
> +out_close:
> +	close(context->period_fd);
> +	context->period_fd = -1;
> +out_err:
> +	tracefs_put_tracing_file(period_path);
> +	return 0;
> +}
> +
> +static int __osnoise_write_runtime(struct osnoise_context *context,
> +				   unsigned long long runtime)
> +{
> +	char buffer[BUFF_U64_STR_SIZE];
> +	int retval;
> +
> +	if (context->runtime_fd == -1) {
> +		err_msg("tried to write osnoise runtime before getting it\n");
> +		return 0;
> +	}
> +
> +	snprintf(buffer, sizeof(buffer), "%llu\n", runtime);
> +
> +	retval = write(context->runtime_fd, buffer, strlen(buffer) + 1);
> +	if (retval < 0)
> +		return -1;
> +
> +	context->runtime_us = runtime;
> +	return 0;
> +}
> +
> +static int __osnoise_write_period(struct osnoise_context *context,
> +				  unsigned long long period)
> +{
> +	char buffer[BUFF_U64_STR_SIZE];
> +	int retval;
> +
> +	if (context->period_fd == -1)
> +		return 0;
> +
> +	snprintf(buffer, sizeof(buffer), "%llu\n", period);
> +
> +	retval = write(context->period_fd, buffer, strlen(buffer) + 1);
> +	if (retval < 0)
> +		return -1;
> +
> +	context->period_us = period;
> +	return 0;
> +}
> +
> +/*
> + * osnoise_set_runtime_period - set osnoise runtime and period
> + *
> + * Osnoise's runtime and period are related as runtime <= period.
> + * Thus, this function saves the original values, and then tries
> + * to set the runtime and period if they are != 0.
> + */
> +int osnoise_set_runtime_period(struct osnoise_context *context,
> +			       unsigned long long runtime,
> +			       unsigned long long period)
> +{
> +	unsigned long long curr_runtime_us;
> +	unsigned long long curr_period_us;
> +	int retval;
> +
> +	if (!period && !runtime)
> +		return 0;
> +
> +	curr_runtime_us = osnoise_get_runtime(context);
> +	curr_period_us = osnoise_get_period(context);
> +
> +	if (!curr_period_us || !curr_runtime_us)
> +		return -1;
> +
> +	if (!period) {
> +		if (runtime > curr_period_us)
> +			return -1;
> +		return __osnoise_write_runtime(context, runtime);
> +	} else if (!runtime) {
> +		if (period < curr_runtime_us)
> +			return -1;
> +		return __osnoise_write_period(context, period);
> +	}
> +
> +	if (runtime > curr_period_us) {
> +		retval = __osnoise_write_period(context, period);
> +		if (retval)
> +			return -1;
> +		retval = __osnoise_write_runtime(context, runtime);
> +		if (retval)
> +			return -1;
> +	} else {
> +		retval = __osnoise_write_runtime(context, runtime);
> +		if (retval)
> +			return -1;
> +		retval = __osnoise_write_period(context, period);
> +		if (retval)
> +			return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * osnoise_restore_runtime_period - restore the original runtime and period
> + */
> +void osnoise_restore_runtime_period(struct osnoise_context *context)
> +{
> +	unsigned long long runtime = context->orig_runtime_us;
> +	unsigned long long period = context->orig_period_us;
> +	int retval;
> +
> +	if (context->runtime_fd < 0 && context->period_fd < 0)
> +		return;
> +
> +	retval = osnoise_set_runtime_period(context, runtime, period);
> +	if (retval)
> +		err_msg("Could not restore original osnoise runtime/period\n");
> +}
> +
> +/*
> + * osnoise_get_stop_us - read and save the original "stop_tracing_us"
> + */
> +static long long
> +osnoise_get_stop_us(struct osnoise_context *context)
> +{
> +	char buffer[BUFF_U64_STR_SIZE];
> +	char *stop_path;
> +	int retval;
> +
> +	if (context->stop_us_fd > 0)
> +		return context->stop_us;
> +
> +	stop_path = tracefs_get_tracing_file("osnoise/stop_tracing_us");
> +
> +	context->stop_us_fd = open(stop_path, O_RDWR);
> +	if (!context->stop_us_fd)
> +		goto out_err;

To check "context->stop_us_fd < 0".

> +	retval = read(context->stop_us_fd, &buffer, sizeof(buffer));
> +	if (!retval)
> +		goto out_close;
> +
> +	context->stop_us = get_long_from_str(buffer);
> +	context->orig_stop_us = context->stop_us;
> +
> +	tracefs_put_tracing_file(stop_path);
> +
> +	return context->stop_us;
> +
> +out_close:
> +	close(context->stop_us_fd);
> +	context->stop_us_fd = -1;
> +out_err:
> +	tracefs_put_tracing_file(stop_path);
> +	return -1;
> +}
> +
> +/*
> + * osnoise_set_stop_us - set "stop_tracing_us"
> + */
> +int osnoise_set_stop_us(struct osnoise_context *context, long long stop_us)
> +{
> +	long long curr_stop_us = osnoise_get_stop_us(context);
> +	char buffer[BUFF_U64_STR_SIZE];
> +	int retval;
> +
> +	if (curr_stop_us < 0)
> +		return -1;
> +
> +	snprintf(buffer, BUFF_U64_STR_SIZE, "%lld\n", stop_us);
> +
> +	retval = write(context->stop_us_fd, buffer, strlen(buffer) + 1);
> +	if (retval < 0)
> +		return -1;
> +
> +	context->stop_us = stop_us;
> +
> +	return 0;
> +}
> +
> +/*
> + * osnoise_restore_stop_us - restore the original stop_tracing_us
> + */
> +void osnoise_restore_stop_us(struct osnoise_context *context)
> +{
> +	char buffer[BUFF_U64_STR_SIZE];
> +	int retval;
> +
> +	if (context->stop_us_fd < 0)
> +		return;
> +
> +	if (context->orig_stop_us == context->stop_us)
> +		return;
> +
> +	snprintf(buffer, BUFF_U64_STR_SIZE, "%lld\n", context->orig_stop_us);
> +
> +	retval = write(context->stop_us_fd, buffer, strlen(buffer) + 1);
> +	if (retval < 0)
> +		err_msg("Could not restore original osnoise stop_us\n");
> +}
> +
> +/*
> + * osnoise_get_stop_us - read and save the original "stop_tracing_total_us"

osnoise_get_stop_total_us is this function name. Use it in comment.

> + */
> +static long long
> +osnoise_get_stop_total_us(struct osnoise_context *context)
> +{
> +	char buffer[BUFF_U64_STR_SIZE];
> +	char *stop_path;
> +	int retval;
> +
> +	if (context->stop_total_us_fd > 0)
> +		return context->stop_total_us;
> +
> +	stop_path = tracefs_get_tracing_file("osnoise/stop_tracing_total_us");
> +
> +	context->stop_total_us_fd = open(stop_path, O_RDWR);
> +	if (!context->stop_total_us_fd)
> +		goto out_err;

Should check "context->stop_total_us_fd < 0".
All these fd check is checking it is not zero. But if error happens,
it should return -1. Or am I wrong.

> +	retval = read(context->stop_total_us_fd, &buffer, sizeof(buffer));
> +	if (!retval)
> +		goto out_close;
> +
> +	context->stop_total_us = get_long_from_str(buffer);
> +	context->orig_stop_total_us = context->stop_total_us;
> +
> +	tracefs_put_tracing_file(stop_path);
> +
> +	return context->stop_total_us;
> +
> +out_close:
> +	close(context->stop_total_us_fd);
> +	context->stop_total_us_fd = -1;
> +out_err:
> +	tracefs_put_tracing_file(stop_path);
> +	return -1;
> +}
> +
> +/*
> + * osnoise_set_stop_us - set "stop_tracing_total_us"

Use function name osnoise_set_stop_total_us instead.

> + */
> +int osnoise_set_stop_total_us(struct osnoise_context *context, long long stop_total_us)
> +{
> +	long long curr_stop_total_us = osnoise_get_stop_total_us(context);
> +	char buffer[BUFF_U64_STR_SIZE];
> +	int retval;
> +
> +	if (curr_stop_total_us < 0)
> +		return -1;
> +
> +	snprintf(buffer, BUFF_U64_STR_SIZE, "%lld\n", stop_total_us);
> +
> +	retval = write(context->stop_total_us_fd, buffer, strlen(buffer) + 1);
> +	if (retval < 0)
> +		return -1;
> +
> +	context->stop_total_us = stop_total_us;
> +
> +	return 0;
> +}
> +
> +/*
> + * osnoise_restore_stop_us - restore the original stop_tracing_us

The function name is osnoise_restore_stop_total_us, use it in the comment.

> + */
> +void osnoise_restore_stop_total_us(struct osnoise_context *context)
> +{
> +	char buffer[BUFF_U64_STR_SIZE];
> +	int retval;
> +
> +	if (context->stop_total_us_fd < 0)
> +		return;
> +
> +	if (context->orig_stop_total_us == context->stop_total_us)
> +		return;
> +
> +	snprintf(buffer, BUFF_U64_STR_SIZE, "%lld\n", context->orig_stop_total_us);
> +
> +	retval = write(context->stop_total_us_fd, buffer, strlen(buffer) + 1);
> +	if (retval < 0)
> +		err_msg("Could not restore original osnoise stop_total_us\n");
> +}
> +
> +/*
> + * osnoise_get_timerlat_period_us - read and save the original "timerlat_period_us"
> + */
> +static long long
> +osnoise_get_timerlat_period_us(struct osnoise_context *context)
> +{
> +	char buffer[BUFF_U64_STR_SIZE];
> +	char *stop_path;
> +	int retval;
> +
> +	if (context->timerlat_period_us_fd > 0)
> +		return context->timerlat_period_us;
> +
> +	stop_path = tracefs_get_tracing_file("osnoise/timerlat_period_us");
> +
> +	context->timerlat_period_us_fd = open(stop_path, O_RDWR);
> +	if (!context->timerlat_period_us_fd)
> +		goto out_err;

Same as above. To check "context->timerlat_period_us_fd < 0".

> +	retval = read(context->timerlat_period_us_fd, &buffer, sizeof(buffer));
> +	if (!retval)
> +		goto out_close;
> +
> +	context->timerlat_period_us = get_long_from_str(buffer);
> +	context->orig_timerlat_period_us = context->timerlat_period_us;
> +
> +	tracefs_put_tracing_file(stop_path);
> +
> +	return context->timerlat_period_us;
> +
> +out_close:
> +	close(context->timerlat_period_us_fd);
> +	context->timerlat_period_us_fd = -1;
> +out_err:
> +	tracefs_put_tracing_file(stop_path);
> +	return -1;
> +}
> +
> +/*
> + * osnoise_set_timerlat_period_us - set "timerlat_period_us"
> + */
> +int osnoise_set_timerlat_period_us(struct osnoise_context *context, long long timerlat_period_us)
> +{
> +	long long curr_timerlat_period_us = osnoise_get_timerlat_period_us(context);
> +	char buffer[BUFF_U64_STR_SIZE];
> +	int retval;
> +
> +	if (curr_timerlat_period_us < 0)
> +		return -1;
> +
> +	snprintf(buffer, BUFF_U64_STR_SIZE, "%lld\n", timerlat_period_us);
> +
> +	retval = write(context->timerlat_period_us_fd, buffer, strlen(buffer) + 1);
> +	if (retval < 0)
> +		return -1;
> +
> +	context->timerlat_period_us = timerlat_period_us;
> +
> +	return 0;
> +}
> +
> +/*
> + * osnoise_restore_timerlat_period_us - restore "timerlat_period_us"
> + */
> +void osnoise_restore_timerlat_period_us(struct osnoise_context *context)
> +{
> +	char buffer[BUFF_U64_STR_SIZE];
> +	int retval;
> +
> +	if (context->timerlat_period_us_fd < 0)
> +		return;
> +
> +	if (context->orig_timerlat_period_us == context->timerlat_period_us)
> +		return;
> +
> +	snprintf(buffer, BUFF_U64_STR_SIZE, "%lld\n", context->orig_timerlat_period_us);
> +
> +	retval = write(context->timerlat_period_us_fd, buffer, strlen(buffer) + 1);
> +	if (retval < 0)
> +		err_msg("Could not restore original osnoise timerlat_period_us\n");
> +}
> +
> +/*
> + * osnoise_get_print_stack - read and save the original "print_stack"
> + */
> +static long long
> +osnoise_get_print_stack(struct osnoise_context *context)
> +{
> +	char buffer[BUFF_U64_STR_SIZE];
> +	char *stop_path;
> +	int retval;
> +
> +	if (context->print_stack_fd > 0)
> +		return context->print_stack;
> +
> +	stop_path = tracefs_get_tracing_file("osnoise/print_stack");
> +
> +	context->print_stack_fd = open(stop_path, O_RDWR);
> +	if (!context->print_stack_fd)
> +		goto out_err;

Same as above, to check "context->print_stack_fd < 0".

> +	retval = read(context->print_stack_fd, &buffer, sizeof(buffer));
> +	if (!retval)
> +		goto out_close;
> +
> +	context->print_stack = get_long_from_str(buffer);
> +	context->orig_print_stack = context->print_stack;
> +
> +	tracefs_put_tracing_file(stop_path);
> +
> +	return context->print_stack;
> +
> +out_close:
> +	close(context->print_stack_fd);
> +	context->print_stack_fd = -1;
> +out_err:
> +	tracefs_put_tracing_file(stop_path);
> +	return -1;
> +}
> +
> +/*
> + * osnoise_set_print_stack - set "print_stack"
> + */
> +int osnoise_set_print_stack(struct osnoise_context *context, long long print_stack)
> +{
> +	long long curr_print_stack = osnoise_get_print_stack(context);
> +	char buffer[BUFF_U64_STR_SIZE];
> +	int retval;
> +
> +	if (curr_print_stack < 0)
> +		return -1;
> +
> +	snprintf(buffer, BUFF_U64_STR_SIZE, "%lld\n", print_stack);
> +
> +	retval = write(context->print_stack_fd, buffer, strlen(buffer) + 1);
> +	if (retval < 0)
> +		return -1;

Do all the osnoise_set_* function need to check "context->*_fd >= 0" ?



Thanks,
Tao
