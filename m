Return-Path: <SRS0=fBth=A4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F18C433E2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 14:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C8B122B49
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 14:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgGQOGI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 10:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726715AbgGQOGH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 10:06:07 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0369207EA;
        Fri, 17 Jul 2020 14:06:06 +0000 (UTC)
Date:   Fri, 17 Jul 2020 10:06:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace-cmd: Enhance "trace-cmd clear" to be instance
 aware
Message-ID: <20200717100605.3540f840@oasis.local.home>
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
> --- /dev/null
> +++ b/tracecmd/trace-clear.c
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

BTW, why create this list? (see below).

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

All you need to do is set the flag, and don't create the list here.

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

Then here, you would just do:

		tracefs_instances_iterate(clear_instance_iter, NULL);

Where we have:

static int clear_instance_iter(const char *name, void *data)
{
	tracefs_clear(name);
}

No need for the creating of the list.

-- Steve


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

