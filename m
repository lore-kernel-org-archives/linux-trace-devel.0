Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4263C433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B786023118
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbhAGQMw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:12:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbhAGQMw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 11:12:52 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6500522D01;
        Thu,  7 Jan 2021 16:12:11 +0000 (UTC)
Date:   Thu, 7 Jan 2021 11:12:09 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/6] libtracefs: New APIs for enable / disable tracing
Message-ID: <20210107111209.7df7cf02@gandalf.local.home>
In-Reply-To: <20210107083250.16295-3-tz.stoyanov@gmail.com>
References: <20210107083250.16295-1-tz.stoyanov@gmail.com>
        <20210107083250.16295-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  7 Jan 2021 10:32:46 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> These new APIs can be used to enable / disable tracing in given ftrace
> instance:
>   tracefs_trace_is_on();
>   tracefs_trace_on();
>   tracefs_trace_off();
>   tracefs_trace_on_fd();
>   tracefs_trace_off_fd();
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/tracefs.h   |   6 +++
>  src/Makefile        |   1 +
>  src/tracefs-tools.c | 123 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 130 insertions(+)
>  create mode 100644 src/tracefs-tools.c
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 460fa4c..bc799c7 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -40,6 +40,12 @@ bool tracefs_instance_exists(const char *name);
>  bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
>  bool tracefs_dir_exists(struct tracefs_instance *instance, char *name);
>  
> +int tracefs_trace_is_on(struct tracefs_instance *instance);
> +int tracefs_trace_on(struct tracefs_instance *instance);
> +int tracefs_trace_off(struct tracefs_instance *instance);
> +int tracefs_trace_on_fd(int fd);
> +int tracefs_trace_off_fd(int fd);
> +
>  /* events */
>  void tracefs_list_free(char **list);
>  char **tracefs_event_systems(const char *tracing_dir);
> diff --git a/src/Makefile b/src/Makefile
> index 3f64905..dabdbb4 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -6,6 +6,7 @@ OBJS =
>  OBJS += tracefs-utils.o
>  OBJS += tracefs-instance.o
>  OBJS += tracefs-events.o
> +OBJS += tracefs-tools.o
>  
>  OBJS := $(OBJS:%.o=$(bdir)/%.o)
>  DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> new file mode 100644
> index 0000000..89e2d6d
> --- /dev/null
> +++ b/src/tracefs-tools.c
> @@ -0,0 +1,123 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> + *
> + * Updates:
> + * Copyright (C) 2021, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> + *
> + */
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +
> +#include "tracefs.h"
> +#include "tracefs-local.h"
> +
> +#define TRACE_CTRL	"tracing_on"
> +
> +static int trace_on_off(int fd, bool on)
> +{
> +	int ret;
> +
> +	if (on)
> +		ret = write(fd, "1", 1);
> +	else
> +		ret = write(fd, "0", 1);

Instead of having both blocks of the if statement call write, it would be
simpler to have:

	const char *val = on ? "1" : "0";

	ret = write(fd, val, 1);

> +
> +	if (ret == 1)
> +		return 0;
> +
> +	return -1;
> +}
> +
> +static int trace_on_off_file(struct tracefs_instance *instance, bool on)
> +{
> +	int ret;
> +	int fd;
> +
> +	fd = tracefs_instance_file_open(instance, TRACE_CTRL, O_WRONLY);
> +	if (fd < 0)
> +		return -1;
> +	ret = trace_on_off(fd, on);
> +	close(fd);
> +
> +	return ret;
> +}
> +
> +/**
> + * tracefs_trace_is_on - Check if writing traces to the ring buffer is enabled
> + * @instance: ftrace instance, can be NULL for the top instance
> + *
> + * Returns -1 in case of an error, 0 if tracing is disable or 1 if tracing
> + * is enabled.
> + */
> +int tracefs_trace_is_on(struct tracefs_instance *instance)
> +{
> +	char buf[10];
> +	int ret;
> +	int fd;
> +
> +	fd = tracefs_instance_file_open(instance, TRACE_CTRL, O_RDONLY);
> +	if (fd < 0)
> +		return -1;
> +	ret = read(fd, buf, 10);
> +	if (ret > 0) {
> +		buf[9] = 0;
> +		ret = atoi(buf);
> +	} else {
> +		ret = -1;
> +	}
> +	close(fd);

Wouldn't the above be better to use tracefs_instance_file_read_number()?


	long long val;

	ret = tracefs_instance_file_read_number(instance, TRACE_CTRL, &val);
	if (ret < 0)
		return -1;

	return !!val;

-- Steve

> +
> +	return ret;
> +}
> +
> +/**
> + * tracefs_trace_on - Enable writing traces to the ring buffer of the given instance
> + * @instance: ftrace instance, can be NULL for the top instance
> + *
> + * Returns -1 in case of an error or 0 otherwise
> + */
> +int tracefs_trace_on(struct tracefs_instance *instance)
> +{
> +	return trace_on_off_file(instance, true);
> +}
> +
> +/**
> + * tracefs_trace_off - Disable writing traces to the ring buffer of the given instance
> + * @instance: ftrace instance, can be NULL for the top instance
> + *
> + * Returns -1 in case of an error or 0 otherwise
> + */
> +int tracefs_trace_off(struct tracefs_instance *instance)
> +{
> +	return trace_on_off_file(instance, false);
> +}
> +
> +/**
> + * tracefs_trace_on_fd - Enable writing traces to the ring buffer
> + * @fd: File descriptor to ftrace tracing_on file, previously opened for reading
> + *	with tracefs_instance_file_open()
> + *
> + * Returns -1 in case of an error or 0 otherwise
> + */
> +int tracefs_trace_on_fd(int fd)
> +{
> +	if (fd < 0)
> +		return -1;
> +	return trace_on_off(fd, true);
> +}
> +
> +/**
> + * tracefs_trace_off_fd - Disable writing traces to the ring buffer
> + * @fd: File descriptor to ftrace tracing_on file, previously opened for reading
> + *	with tracefs_instance_file_open()
> + *
> + * Returns -1 in case of an error or 0 otherwise
> + */
> +int tracefs_trace_off_fd(int fd)
> +{
> +	if (fd < 0)
> +		return -1;
> +	return trace_on_off(fd, false);
> +}

