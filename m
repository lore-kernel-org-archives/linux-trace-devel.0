Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7659C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 15:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BBED23118
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 15:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbhAGP7f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 10:59:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:37870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbhAGP7f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 10:59:35 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34C0023118;
        Thu,  7 Jan 2021 15:58:54 +0000 (UTC)
Date:   Thu, 7 Jan 2021 10:58:52 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/6] libtracefs: New APIs for opening and reading ftrace
 files
Message-ID: <20210107105852.649b1d44@gandalf.local.home>
In-Reply-To: <20210107083250.16295-2-tz.stoyanov@gmail.com>
References: <20210107083250.16295-1-tz.stoyanov@gmail.com>
        <20210107083250.16295-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  7 Jan 2021 10:32:45 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> These new APIs can be used to read integer from frtace file and to open
> ftrace file:
>   tracefs_instance_file_read_int();
>   tracefs_instance_file_open();
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/tracefs.h      |  6 ++++-
>  src/tracefs-instance.c | 59 ++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 62 insertions(+), 3 deletions(-)
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 3d70aca..460fa4c 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -29,7 +29,11 @@ char *tracefs_instance_get_dir(struct tracefs_instance *instance);
>  int tracefs_instance_file_write(struct tracefs_instance *instance,
>  				const char *file, const char *str);
>  char *tracefs_instance_file_read(struct tracefs_instance *instance,
> -				 char *file, int *psize);
> +				 const char *file, int *psize);
> +int tracefs_instance_file_read_int(struct tracefs_instance *instance,
> +				   const char *file, long long *res);
> +int tracefs_instance_file_open(struct tracefs_instance *instance,
> +			       const char *file, int mode);
>  int tracefs_instances_walk(int (*callback)(const char *, void *), void *context);
>  
>  bool tracefs_instance_exists(const char *name);
> diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
> index bf3de7c..27b9e99 100644
> --- a/src/tracefs-instance.c
> +++ b/src/tracefs-instance.c
> @@ -14,7 +14,7 @@
>  #include <sys/stat.h>
>  #include <fcntl.h>
>  #include <dirent.h>
> -#include <linux/limits.h>
> +#include <limits.h>
>  #include "tracefs.h"
>  #include "tracefs-local.h"
>  
> @@ -282,7 +282,7 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
>   * The return string must be freed by free()
>   */
>  char *tracefs_instance_file_read(struct tracefs_instance *instance,
> -				  char *file, int *psize)
> +				 const char *file, int *psize)

The above is more of a clean up and should be a separate patch.

>  {
>  	char *buf = NULL;
>  	int size = 0;
> @@ -301,6 +301,61 @@ char *tracefs_instance_file_read(struct tracefs_instance *instance,
>  	return buf;
>  }
>  
> +/**
> + * tracefs_instance_file_read_int - Read an integer from a trace file.
> + * @instance: ftrace instance, can be NULL for the top instance
> + * @file: name of the file
> + * @res: The integer from the file.
> + *
> + * Returns 0 if the reading is successful and the result is stored in res, -1
> + * in case of an error.
> + */
> +int tracefs_instance_file_read_int(struct tracefs_instance *instance,
> +				   const char *file, long long *res)

Let's call this "tracefs_instance_file_number()" as "int" may be confusing
as it really returns "long long".

> +{
> +	long long ret = LLONG_MAX;
> +	int size = 0;
> +	char *str;
> +
> +	str = tracefs_instance_file_read(instance, file, &size);
> +	if (size && str)
> +		ret = strtoll(str, NULL, 0);
> +	free(str);
> +
> +	if (LLONG_MIN == ret || LLONG_MAX == ret)
> +		return -1;

As it is possible that the file could read LLONG_MIN or LLONG_MAX, we
should follow the man page and use errno to detect an error:

	if (!size || !str)
		return -1;

	errno = 0;
	ret = strtoll(str, NULL, 0);
	if (errno)
		return -1;


-- Steve

> +	*res = ret;
> +	return 0;
> +}
> +
> +/**
> + * tracefs_instance_file_open - Open a trace file for reading and writing
> + * @instance: ftrace instance, can be NULL for the top instance
> + * @file: name of the file
> + * @mode: file open flags, -1 for default O_RDWR
> + *
> + * Returns -1 in case of an error, or a valid file descriptor otherwise.
> + * The returned FD must be closed with close()
> + */
> +int tracefs_instance_file_open(struct tracefs_instance *instance,
> +			       const char *file, int mode)
> +{
> +	int flags = O_RDWR;
> +	int fd = -1;
> +	char *path;
> +
> +	path = tracefs_instance_get_file(instance, file);
> +	if (!path)
> +		return -1;
> +
> +	if (mode >= 0)
> +		flags = mode;
> +	fd = open(path, flags);
> +	tracefs_put_tracing_file(path);
> +
> +	return fd;
> +}
> +
>  static bool check_file_exists(struct tracefs_instance *instance,
>  			     char *name, bool dir)
>  {

