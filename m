Return-Path: <SRS0=fBth=A4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA03C433DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 13:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A6A82067D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 13:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgGQNbU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 09:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgGQNbT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 09:31:19 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF3FD2067D;
        Fri, 17 Jul 2020 13:31:18 +0000 (UTC)
Date:   Fri, 17 Jul 2020 09:31:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace-cmd: Enhance "trace-cmd clear" to be instance
 aware
Message-ID: <20200717093117.04fb74ac@oasis.local.home>
In-Reply-To: <20200717080326.82151-3-tz.stoyanov@gmail.com>
References: <20200717080326.82151-1-tz.stoyanov@gmail.com>
        <20200717080326.82151-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 17 Jul 2020 11:03:26 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Added new options "trace-cmd clear -B <name> -a" which allow the command
> to work per ftrace instance:
> -B clear the given buffer (may specify multiple -B)
> -a clear all existing buffers, including the top level one
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  Documentation/trace-cmd-clear.1.txt |  13 ++-
>  tracecmd/Makefile                   |   1 +
>  tracecmd/trace-clear.c              | 124 ++++++++++++++++++++++++++++
>  tracecmd/trace-record.c             |  24 ------
>  tracecmd/trace-usage.c              |   4 +-
>  5 files changed, 140 insertions(+), 26 deletions(-)
>  create mode 100644 tracecmd/trace-clear.c
> 
> diff --git a/Documentation/trace-cmd-clear.1.txt b/Documentation/trace-cmd-clear.1.txt
> index 67e5851a..a0ae36e9 100644
> --- a/Documentation/trace-cmd-clear.1.txt
> +++ b/Documentation/trace-cmd-clear.1.txt
> @@ -7,12 +7,23 @@ trace-cmd-clear - clear the Ftrace buffer.
>  
>  SYNOPSIS
>  --------
> -*trace-cmd clear*
> +*trace-cmd clear* ['OPTIONS']
>  
>  DESCRIPTION
>  -----------
>  The *trace-cmd(1) clear* clears the content of the Ftrace ring buffer.
>  
> +OPTIONS
> +-------
> +*-B* 'buffer-name'::
> +    If the kernel supports multiple buffers, this will clear only the given
> +    buffer. It does not affect any other buffers. This may be used multiple
> +    times to specify different buffers. The top level buffer will not be
> +    clearded if this option is given.

We should give a special name for the top buffer. I think "/" would be
good, as that can not be in the name of any instance.

That way if you have three buffers (top and two instances, say "foo"
and "bar") we could do something like:

  trace-cmd clear -B / -B foo

And it will clear the top buffer and "foo", but leave "bar" alone.


> +
> +*-a*::
> +    Clear all existing buffers, including the top level one.
> +
>  SEE ALSO
>  --------
>  trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
> diff --git a/tracecmd/Makefile b/tracecmd/Makefile
> index 5e59adf8..01f36c61 100644
> --- a/tracecmd/Makefile
> +++ b/tracecmd/Makefile
> @@ -31,6 +31,7 @@ TRACE_CMD_OBJS += trace-show.o
>  TRACE_CMD_OBJS += trace-list.o
>  TRACE_CMD_OBJS += trace-usage.o
>  TRACE_CMD_OBJS += trace-dump.o
> +TRACE_CMD_OBJS += trace-clear.o
>  ifeq ($(VSOCK_DEFINED), 1)
>  TRACE_CMD_OBJS += trace-tsync.o
>  endif
> diff --git a/tracecmd/trace-clear.c b/tracecmd/trace-clear.c
> new file mode 100644
> index 00000000..f1b4f309
> --- /dev/null
> +++ b/tracecmd/trace-clear.c

Thinking about this more, the functionality of this entire file should
be in libtracefs.  This is specific to the tracefs functionality and
not to trace-cmd in general.

We should have:

 tracefs_clear(instance_name);


Where: tracefs_clear(NULL) clears the top level.
       tracefs_clear("foo") clears the instance named "foo".

And a tracefs_clear_all(bool top);

Where: tracefs_clear_all(false)
   clear's all instances but leaves the top instance untouched.

       tracefs_clear_all(true)
    clears the top level and all instances.

-- Steve


> @@ -0,0 +1,124 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2008, 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> + *
> + * Updates:
> + * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
> + *
> + */
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <getopt.h>
> +
> +#include "tracefs.h"
> +#include "trace-local.h"
> +
> +struct instances_list {
> +	struct instances_list *next;
> +	struct tracefs_instance *instance;
> +};
> +
> +static int add_new_instance(struct instances_list **list, char *name)
> +{
> +	struct instances_list *new;
> +
> +	new = calloc(1, sizeof(*new));
> +	if (!new)
> +		return -1;
> +	new->instance = tracefs_instance_alloc(name);
> +	if (!new->instance) {
> +		free(new);
> +		return -1;
> +	}
> +
> +	new->next = *list;
> +	*list = new;
> +	return 0;
> +}
> +
> +static int add_instance_walk(const char *name, void *data)
> +{
> +	return add_new_instance((struct instances_list **)data, (char *)name);
> +}
> +
> +static void clear_list(struct instances_list *list)
> +{
> +	struct instances_list *del;
> +
> +	while (list) {
> +		del = list;
> +		list = list->next;
> +		tracefs_instance_free(del->instance);
> +		free(del);
> +	}
> +}
> +
> +static void clear_instance_trace(struct tracefs_instance *instance)
> +{
> +	FILE *fp;
> +	char *path;
> +
> +	/* reset the trace */
> +	path = tracefs_instance_get_file(instance, "trace");
> +	fp = fopen(path, "w");
> +	if (!fp)
> +		die("writing to '%s'", path);
> +	tracefs_put_tracing_file(path);
> +	fwrite("0", 1, 1, fp);
> +	fclose(fp);
> +}
> +
> +static void clear_trace(struct instances_list *instances)
> +{
> +	if (instances) {
> +		while (instances) {
> +			clear_instance_trace(instances->instance);
> +			instances = instances->next;
> +		}
> +	} else
> +		clear_instance_trace(NULL);
> +}
> +
> +void trace_clear(int argc, char **argv)
> +{
> +	struct instances_list *instances = NULL;
> +	bool all = false;
> +	int c;
> +
> +	for (;;) {
> +		int option_index = 0;
> +		static struct option long_options[] = {
> +			{"all", no_argument, NULL, 'a'},
> +			{"help", no_argument, NULL, '?'},
> +			{NULL, 0, NULL, 0}
> +		};
> +
> +		c = getopt_long (argc-1, argv+1, "+haB:",
> +				 long_options, &option_index);
> +		if (c == -1)
> +			break;
> +		switch (c) {
> +		case 'B':
> +			if (add_new_instance(&instances, optarg))
> +				die("Failed to allocate instance %s", optarg);
> +			break;
> +		case 'a':
> +			all = true;
> +			if (tracefs_instances_walk(add_instance_walk, &instances))
> +				die("Failed to add all instances");
> +			break;
> +		case 'h':
> +		case '?':
> +		default:
> +			usage(argv);
> +			break;
> +		}
> +	}
> +
> +	clear_trace(instances);
> +	if (all)
> +		clear_trace(NULL);
> +	clear_list(instances);
> +	exit(0);
> +}
> +
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index bd004574..5009eaa1 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -835,21 +835,6 @@ static void clear_trace_instances(void)
>  		__clear_trace(instance);
>  }
>  
> -static void clear_trace(void)
> -{
> -	FILE *fp;
> -	char *path;
> -
> -	/* reset the trace */
> -	path = tracefs_get_tracing_file("trace");
> -	fp = fopen(path, "w");
> -	if (!fp)
> -		die("writing to '%s'", path);
> -	tracefs_put_tracing_file(path);
> -	fwrite("0", 1, 1, fp);
> -	fclose(fp);
> -}
> -
>  static void reset_max_latency(struct buffer_instance *instance)
>  {
>  	tracefs_instance_file_write(instance->tracefs,
> @@ -6704,15 +6689,6 @@ void trace_profile(int argc, char **argv)
>  	exit(0);
>  }
>  
> -void trace_clear(int argc, char **argv)
> -{
> -	if (argc > 2)
> -		usage(argv);
> -	else
> -		clear_trace();
> -	exit(0);
> -}
> -
>  void trace_record(int argc, char **argv)
>  {
>  	struct common_record_context ctx;
> diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
> index 3f0b2d07..79610bd3 100644
> --- a/tracecmd/trace-usage.c
> +++ b/tracecmd/trace-usage.c
> @@ -180,7 +180,9 @@ static struct usage_help usage_help[] = {
>  	{
>  		"clear",
>  		"clear the trace buffers",
> -		" %s clear\n"
> +		" %s clear [-B buf][-a]\n"
> +		"          -B clear the given buffer (may specify multiple -B)\n"
> +		"          -a clear all existing buffers, including the top level one\n"
>  	},
>  	{
>  		"report",

