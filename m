Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF0FC433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 13:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03D1D6113A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 13:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhDINMa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 09:12:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231127AbhDINMa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 09:12:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 096E8610FB;
        Fri,  9 Apr 2021 13:12:16 +0000 (UTC)
Date:   Fri, 9 Apr 2021 09:12:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3] libtracefs: Add new API for open trace marker file
Message-ID: <20210409091215.03ceca3d@gandalf.local.home>
In-Reply-To: <20210409042739.3179257-1-tz.stoyanov@gmail.com>
References: <20210409042739.3179257-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  9 Apr 2021 07:27:39 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Added new APIs for working with trace marker files of given instance.
> Write strings in the trace_marker file:
>  tracefs_print_init();
>  tracefs_printf();
>  tracefs_vprintf();
>  tracefs_print_close();
> Write binary data in trace_marker_raw file:
>  tracefs_binary_init();
>  tracefs_binary_write();
>  tracefs_binary_close();

Thanks Tzvetomir, this looks exactly like what I wanted.

A few nits with the code, but I may take this series as is and then add
these changes on top, since I want to get this library done this week. Let
me know if you have any issues with what I plan on changing, or just let me
know if you are OK with it.


> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
> v3 changes:
>  - Split the APIs in two groups - printing formated strings and writing binary data
> v2 changes:
>  - Added set of new APIs, instead of the previously proposed API for just
>    opening the file.
> 
>  include/tracefs-local.h |   2 +
>  include/tracefs.h       |  11 +++
>  src/Makefile            |   1 +
>  src/tracefs-instance.c  |   6 ++
>  src/tracefs-marker.c    | 175 ++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 195 insertions(+)
>  create mode 100644 src/tracefs-marker.c
> 
> diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> index 5a69ef7..d9bbf6e 100644
> --- a/include/tracefs-local.h
> +++ b/include/tracefs-local.h
> @@ -20,6 +20,8 @@ struct tracefs_instance {
>  	char	*name;
>  	int	flags;
>  	int	ftrace_filter_fd;
> +	int	ftrace_marker_fd;
> +	int	ftrace_marker_raw_fd;
>  };
>  
>  /* Can be overridden */
> diff --git a/include/tracefs.h b/include/tracefs.h
> index befcc48..7181b75 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -63,6 +63,17 @@ static inline int tracefs_trace_on_get_fd(struct tracefs_instance *instance)
>  	return tracefs_instance_file_open(instance, "tracing_on", O_RDWR);
>  }
>  
> +/* trace print string*/
> +int tracefs_print_init(struct tracefs_instance *instance);
> +int tracefs_printf(struct tracefs_instance *instance, const char *fmt, ...);
> +int tracefs_vprintf(struct tracefs_instance *instance, const char *fmt, va_list ap);
> +void tracefs_print_close(struct tracefs_instance *instance);
> +
> +/* trace write binary data*/
> +int tracefs_binary_init(struct tracefs_instance *instance);
> +int tracefs_binary_write(struct tracefs_instance *instance, void *data, int len);
> +void tracefs_binary_close(struct tracefs_instance *instance);
> +
>  /* events */
>  void tracefs_list_free(char **list);
>  char **tracefs_event_systems(const char *tracing_dir);
> diff --git a/src/Makefile b/src/Makefile
> index dabdbb4..b4cff07 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -7,6 +7,7 @@ OBJS += tracefs-utils.o
>  OBJS += tracefs-instance.o
>  OBJS += tracefs-events.o
>  OBJS += tracefs-tools.o
> +OBJS += tracefs-marker.o
>  
>  OBJS := $(OBJS:%.o=$(bdir)/%.o)
>  DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
> diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
> index e87b360..bedf000 100644
> --- a/src/tracefs-instance.c
> +++ b/src/tracefs-instance.c
> @@ -44,6 +44,8 @@ static struct tracefs_instance *instance_alloc(const char *trace_dir, const char
>  	}
>  
>  	instance->ftrace_filter_fd = -1;
> +	instance->ftrace_marker_fd = -1;
> +	instance->ftrace_marker_raw_fd = -1;
>  
>  	return instance;
>  
> @@ -68,6 +70,10 @@ void tracefs_instance_free(struct tracefs_instance *instance)
>  		return;
>  	free(instance->trace_dir);
>  	free(instance->name);
> +	if (instance->ftrace_marker_fd >= 0)
> +		close(instance->ftrace_marker_fd);
> +	if (instance->ftrace_marker_raw_fd >= 0)
> +		close(instance->ftrace_marker_raw_fd);
>  	free(instance);
>  }
>  
> diff --git a/src/tracefs-marker.c b/src/tracefs-marker.c
> new file mode 100644
> index 0000000..0dc72f6
> --- /dev/null
> +++ b/src/tracefs-marker.c
> @@ -0,0 +1,175 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2021, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> + *
> + */
> +
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <stdio.h>
> +
> +#include "tracefs.h"
> +#include "tracefs-local.h"
> +
> +/* File descriptors for Top level trace markers */
> +static int ftrace_marker_fd = -1;
> +static int ftrace_marker_raw_fd = -1;
> +
> +static inline int *get_marker_fd(struct tracefs_instance *instance, bool raw)
> +{
> +	if (raw)
> +		return instance ? &instance->ftrace_marker_raw_fd : &ftrace_marker_raw_fd;
> +	return instance ? &instance->ftrace_marker_fd : &ftrace_marker_fd;
> +}
> +
> +static int marker_init(struct tracefs_instance *instance, bool raw)
> +{
> +	int *fd = get_marker_fd(instance, raw);
> +
> +	if (*fd >= 0)
> +		return 0;
> +	if (raw)
> +		*fd = tracefs_instance_file_open(instance, "trace_marker_raw", O_WRONLY | O_CLOEXEC);
> +	else
> +		*fd = tracefs_instance_file_open(instance, "trace_marker", O_WRONLY | O_CLOEXEC);

I like to keep functionality out of if statements like the above if there's
a way to do so, and there is, with the following:

static int marker_init(struct tracefs_instance *instance, bool raw)
{
	const char *file = raw ? "trace_marker_raw" : "trace_marker";
	int *fd = get_marker_fd(instance, raw);

	if (*fd >= 0)
		return 0;
	*fd = tracefs_instance_file_open(instance, file, O_WRONLY | O_CLOEXEC);
> +
> +	return *fd < 0 ? -1 : 0;
> +}
> +
> +static void marker_close(struct tracefs_instance *instance, bool raw)
> +{
> +	int *fd = get_marker_fd(instance, raw);
> +
> +	if (*fd < 0)
> +		return;
> +	close(*fd);
> +	*fd = -1;

Both of the functions will need a mutex around them. But I can add that.

> +}
> +
> +static int marker_write(struct tracefs_instance *instance, bool raw, void *data, int len)
> +{
> +	int *fd = get_marker_fd(instance, raw);
> +	int ret;
> +
> +	if (!data || len < 1)
> +		return -1;
> +	if (*fd < 0) {
> +		ret = marker_init(instance, raw);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	ret = write(*fd, data, len);

I would say that we don't use a mutex around the above, because writes tend
to be crucial, and even though a mutex uses futex, where it does no system
call if there's no contention, I would just document that this could be
racy if one thread calls the close function while others are still using
it. But that's true with normal file handlers as well. The mutex is only
needed to keep this code from opening the file more than once.

> +
> +	return ret == len ? 0 : -1;
> +}
> +
> +/**
> + * tracefs_print_init - Open trace marker of selected instance for writing
> + * @instance: ftrace instance, can be NULL for top tracing instance.
> + *
> + * Returns 0 if the trace marker is opened successfully, or -1 in case of an error
> + */
> +int tracefs_print_init(struct tracefs_instance *instance)
> +{
> +	return marker_init(instance, false);
> +}
> +
> +/**
> + * tracefs_vprintf - Write a formatted string in the trace marker
> + * @instance: ftrace instance, can be NULL for top tracing instance.
> + * @fmt: pritnf formatted string
> + * @ap: list of arguments for the formatted string
> + *
> + * If the trace marker of the desired instance is not open already,
> + * this API will open it for writing. It will stay open until
> + * tracefs_print_close() is called.
> + *
> + * Returns 0 if the string is written correctly, or -1 in case of an error
> + */
> +int tracefs_vprintf(struct tracefs_instance *instance, const char *fmt, va_list ap)
> +{
> +	char *str = NULL;
> +	int ret;
> +
> +	ret = vasprintf(&str, fmt, ap);
> +	if (ret < 0)
> +		return ret;
> +	ret = marker_write(instance, false, str, strlen(str) + 1);

No need for the "+1", the kernel doesn't care about the nul (\0) character
being written. It will add one itself.

> +	free(str);
> +
> +	return ret;
> +}
> +
> +/**
> + * tracefs_printf - Write a formatted string in the trace marker
> + * @instance: ftrace instance, can be NULL for top tracing instance.
> + * @fmt: pritnf formatted string with variable arguments ...
> + *
> + * If the trace marker of the desired instance is not open already,
> + * this API will open it for writing. It will stay open until
> + * tracefs_print_close() is called.
> + *
> + * Returns 0 if the string is written correctly, or -1 in case of an error
> + */
> +int tracefs_printf(struct tracefs_instance *instance, const char *fmt, ...)
> +{
> +	va_list ap;
> +	int ret;
> +
> +	va_start(ap, fmt);
> +	ret = tracefs_vprintf(instance, fmt, ap);
> +	va_end(ap);
> +
> +	return ret;
> +}
> +
> +/**
> + * tracefs_print_close - Close trace marker of selected instance
> + * @instance: ftrace instance, can be NULL for top tracing instance.
> + *
> + * Closes the trace marker, previously opened with any of the other tracefs_print APIs
> + */
> +void tracefs_print_close(struct tracefs_instance *instance)
> +{
> +	marker_close(instance, false);
> +}
> +
> +/**
> + * tracefs_binary_init - Open raw trace marker of selected instance for writing
> + * @instance: ftrace instance, can be NULL for top tracing instance.
> + *
> + * Returns 0 if the raw trace marker is opened successfully, or -1 in case of an error
> + */
> +int tracefs_binary_init(struct tracefs_instance *instance)
> +{
> +	return marker_init(instance, true);
> +}
> +
> +/**
> + * tracefs_binary_write - Write binary data in the raw trace marker
> + * @instance: ftrace instance, can be NULL for top tracing instance.
> + * @data: binary data, that is going to be written in the trace marker
> + * @len: length of the @data
> + *
> + * If the raw trace marker of the desired instance is not open already,
> + * this API will open it for writing. It will stay open until
> + * tracefs_binary_close() is called.
> + *
> + * Returns 0 if the data is written correctly, or -1 in case of an error
> + */
> +int tracefs_binary_write(struct tracefs_instance *instance, void *data, int len)
> +{
> +	return marker_write(instance, true, data, len);
> +}
> +
> +/**
> + * tracefs_binary_close - Close raw trace marker of selected instance
> + * @instance: ftrace instance, can be NULL for top tracing instance.
> + *
> + * Closes the raw trace marker, previously opened with any of the other tracefs_binary APIs
> + */
> +void tracefs_binary_close(struct tracefs_instance *instance)
> +{
> +	marker_close(instance, true);
> +}

The rest looks great!

-- Steve
