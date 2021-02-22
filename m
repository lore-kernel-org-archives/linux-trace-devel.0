Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52932C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Feb 2021 14:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 069CE64E34
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Feb 2021 14:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhBVOwq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Feb 2021 09:52:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:52040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230260AbhBVOwq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Feb 2021 09:52:46 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45A8264E00;
        Mon, 22 Feb 2021 14:52:04 +0000 (UTC)
Date:   Mon, 22 Feb 2021 09:52:02 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: New API to trace only specific functions by
 instance
Message-ID: <20210222095202.6b2e066e@gandalf.local.home>
In-Reply-To: <1613996661-6525-1-git-send-email-sameeruddin.shaik8@gmail.com>
References: <[PATCH][WIP]libtracefs:New API to enable the filtering of functions>
        <1613996661-6525-1-git-send-email-sameeruddin.shaik8@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Feb 2021 17:54:21 +0530
Sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:

> This new API can be used to set the specific functions to be traced.
> 
> tracefs_function_filter
> 
> Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
> 
> diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> index 187870e..e8ad1f9 100644
> --- a/include/tracefs-local.h
> +++ b/include/tracefs-local.h
> @@ -20,6 +20,7 @@ void warning(const char *fmt, ...);
>  int str_read_file(const char *file, char **buffer);
>  char *trace_append_file(const char *dir, const char *name);
>  char *trace_find_tracing_dir(void);
> +int controlled_write(const char *path, const char* const *filter, bool reset);

Note, we've been using the standard that all functions local to the library
starts with "trace_" if they are not static.

But I'm not sure why this function needs to be in the utilities, where else
do you plan on using it? If there's only one user, keep it local to that
file. The tracefs-utils.c file should only contain functions that have
multiple use cases.

>  
>  #ifndef ACCESSPERMS
>  #define ACCESSPERMS (S_IRWXU|S_IRWXG|S_IRWXO) /* 0777 */
> diff --git a/include/tracefs.h b/include/tracefs.h
> index f3eec62..37eab87 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -50,6 +50,7 @@ int tracefs_trace_on(struct tracefs_instance *instance);
>  int tracefs_trace_off(struct tracefs_instance *instance);
>  int tracefs_trace_on_fd(int fd);
>  int tracefs_trace_off_fd(int fd);
> +int tracefs_function_filter(struct tracefs_instance *instance, const char* const *filter, bool reset);
>  
>  /**
>   * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> index e2dfc7b..709f1e7 100644
> --- a/src/tracefs-tools.c
> +++ b/src/tracefs-tools.c
> @@ -18,6 +18,7 @@
>  #include "tracefs-local.h"
>  
>  #define TRACE_CTRL	"tracing_on"
> +#define TRACE_FILTER      "set_ftrace_filter"
>  
>  static const char * const options_map[] = {
>  	"unknown",
> @@ -387,3 +388,28 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
>  	if (options && id > TRACEFS_OPTION_INVALID)
>  		options->mask &= ~(1ULL << (id - 1));
>  }
> +
> +/**
> + * tracefs_function_filter - write to set_ftrace_filter file to trace particular functions
> + * @instance: ftrace instance, can be NULL for top tracing instnace

 typo "instnace".

> + * @filter: const pointer to an array of const function names

The description should not have its type, we can see that from the
prototype. It should be what it is.

 * @filter: An array of function names or regex expressions, ending with a NULL pointer.

> + * @reset: Boolean value to reset the file

 * @reset: Set to true to reset the filter before applying @filter.

then in the body of the description (here), you can explain more.

 * The @filter is an array of strings, where each string will be use to set
 * a function or functions to be traced. They can be function names, a glob
 * expression, or a regex expressions, and all the functions that match
 * each filter will be enabled.
 *
 * If @reset is true, then all functions in the filter are cleared before
 * adding functions from @filter. Otherwise, the functions set by @filter
 * will be appended to the filter.

Something like the above. That is, explain why things are happening not the
what, as people can figure out the what from the code.

> + */
> +int tracefs_function_filter(struct tracefs_instance *instance, const char * const *filters, bool reset)
> +{
> +	char *ftrace_filter_path;
> +	int ret;
> +
> +	if (!filters)
> +		return -1;
> +	ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
> +
> +	if (!ftrace_filter_path)
> +		goto gracefully_free;
> +
> +	ret = controlled_write(ftrace_filter_path, filters, reset);

This can be a helper function for this and perhaps for the
set_ftrace_notrace, but it should be local to this file. Especially, since
this function should also look at the list of available filter functions as
well. In fact, I'm thinking we may not even bother with the glob
expressions and do the search of available filter functions instead (if the
kernel accepts indexes).

> +
> + gracefully_free:
> +	tracefs_put_tracing_file(ftrace_filter_path);
> +	return ret;
> +}
> diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
> index 0e96f8e..1cd98a2 100644
> --- a/src/tracefs-utils.c
> +++ b/src/tracefs-utils.c
> @@ -228,3 +228,23 @@ __hidden int str_read_file(const char *file, char **buffer)
>  
>  	return size;
>  }
> +
> +__hidden int controlled_write(const char *filter_path, const char * const *filters, bool reset)
> +{
> +	int size = 0;
> +	int fd;
> +	int i;
> +
> +	if (!filters)
> +		return -1;
> +	if (reset)
> +		fd = open(filter_path, O_WRONLY | O_APPEND | O_TRUNC);
> +	else
> +		fd = open(filter_path, O_WRONLY | O_APPEND);
> +	if (fd < 0)
> +		return -1;
> +	for (i = 0; filters[i] != NULL ; i++)
> +		size += write(fd, *(filters + i), strlen(*(filters + i)));

The kernel expects a delimiter between function names, and it is not broken
up by individual writes. You need to add a space before writing in another
function name.

-- Steve


> +	close(fd);
> +	return size;
> +}

