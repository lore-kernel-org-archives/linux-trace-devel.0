Return-Path: <SRS0=XW/z=Z2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F66C43603
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Dec 2019 16:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E7352081B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Dec 2019 16:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbfLDQRf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 11:17:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbfLDQRe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 11:17:34 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFAC32077B;
        Wed,  4 Dec 2019 16:17:32 +0000 (UTC)
Date:   Wed, 4 Dec 2019 11:17:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v17 04/18] trace-cmd: Add new library APIs for ftrace
 instances.
Message-ID: <20191204111731.7409abdc@gandalf.local.home>
In-Reply-To: <20191203103522.482684-5-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
        <20191203103522.482684-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  3 Dec 2019 12:35:08 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> 
> In order to reuse the code, the functionality related to
> ftrace instances is moved from trace-cmd application to
> libtracecmd. The following new library APIs are introduced:
> 
> library structure, representing a ftrace instance:
> 	struct tracecmd_instance {
>         	char    *name;
> 	        char    *clock;
> 	};
> 
> APIs for creating and deleting ftrace instances:
> 	struct tracecmd_instance *tracecmd_create_instance(const char *name);

It looks to me that tracecmd_create_instance() allocates the instance,
and tracecmd_free_instance() frees the memory. Let's rename this to
tracecmd_alloc_instance(), otherwise it becomes ambiguous to actually
creating the instance on file. When I first saw this, I thought this
would create the instance

  e.g. mkdir /sys/kernel/tracing/instances/foo


Which looks to be what tracecmd_make_instance() does.

> 	void tracecmd_free_instance(struct tracecmd_instance *instance);
> 	int tracecmd_make_instance(struct tracecmd_instance *instance);
> 	void tracecmd_remove_instance(struct tracecmd_instance *instance);
> 
> APIs for reading and writing ftrace files, instance aware:
> 	char *tracecmd_get_instance_file(struct tracecmd_instance *instance, const char *file);
> 	char *tracecmd_get_instance_dir(struct tracecmd_instance *instance);
> 	int tracecmd_write_instance_file(struct tracecmd_instance *instance,
> 	                                 const char *file, const char *str,
>         	                         const char *type);
> 	int tracecmd_write_file(const char *file, const char *str, const char *type);
> 	char *tracecmd_read_instance_file(struct tracecmd_instance *instance,
>         	                          char *file, int *psize);
> 
> API for setting ftrace clock, instance aware:
> 	void tracecmd_set_clock(struct tracecmd_instance *instance, char **old_clock);
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h           |  24 ++
>  lib/trace-cmd/Makefile                  |   1 +
>  lib/trace-cmd/include/trace-cmd-local.h |  33 +--
>  lib/trace-cmd/trace-instance.c          | 265 ++++++++++++++++++
>  lib/trace-cmd/trace-util.c              |  71 ++++-
>  tracecmd/include/trace-local.h          |   6 +-
>  tracecmd/trace-list.c                   |   2 +-
>  tracecmd/trace-record.c                 | 341 +++++++-----------------
>  tracecmd/trace-show.c                   |   2 +
>  tracecmd/trace-stat.c                   |  20 +-
>  10 files changed, 472 insertions(+), 293 deletions(-)
>  create mode 100644 lib/trace-cmd/trace-instance.c
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 7f9cb73..5287d23 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -356,6 +356,30 @@ int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
>  int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
>  				 int *nr_cpus, int *page_size,
>  				 unsigned int **ports, bool *use_fifos);
> +/* --- ftrace instances --- */
> +
> +struct tracecmd_instance {
> +	char	*name;
> +	char	*clock;
> +};

I wonder if we should keep this as a private structure. That is, only
declare the struct in the public header, but define the structure in a
private one. This will help with keeping people from using it directly,
and allowing for updating the structure without having to update the
library version.


> +
> +struct tracecmd_instance *tracecmd_create_instance(const char *name);
> +void tracecmd_free_instance(struct tracecmd_instance *instance);
> +int tracecmd_make_instance(struct tracecmd_instance *instance);
> +void tracecmd_remove_instance(struct tracecmd_instance *instance);
> +char *
> +tracecmd_get_instance_file(struct tracecmd_instance *instance, const char *file);
> +char *tracecmd_get_instance_dir(struct tracecmd_instance *instance);
> +int tracecmd_write_instance_file(struct tracecmd_instance *instance,
> +				 const char *file, const char *str,
> +				 const char *type);
> +
> +int tracecmd_write_file(const char *file, const char *str, const char *type);
> +char *tracecmd_read_instance_file(struct tracecmd_instance *instance,
> +				  char *file, int *psize);
> +
> +void tracecmd_set_clock(struct tracecmd_instance *instance, char **old_clock);
> +
>  
>  /* --- Plugin handling --- */
>  extern struct tep_plugin_option trace_ftrace_options[];
> diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
> index 3b4b5aa..18c7013 100644
> --- a/lib/trace-cmd/Makefile
> +++ b/lib/trace-cmd/Makefile
> @@ -13,6 +13,7 @@ OBJS += trace-input.o
>  OBJS += trace-output.o
>  OBJS += trace-recorder.o
>  OBJS += trace-util.o
> +OBJS += trace-instance.o
>  OBJS += trace-filter-hash.o
>  OBJS += trace-msg.o
>  
> diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
> index 09574db..eef4d39 100644
> --- a/lib/trace-cmd/include/trace-cmd-local.h
> +++ b/lib/trace-cmd/include/trace-cmd-local.h
> @@ -18,36 +18,7 @@
>  #define STR(x)	_STR(x)
>  #define FILE_VERSION_STRING STR(FILE_VERSION)
>  
> -static ssize_t __do_write(int fd, const void *data, size_t size)
> -{
> -	ssize_t tot = 0;
> -	ssize_t w;
> -
> -	do {
> -		w = write(fd, data + tot, size - tot);
> -		tot += w;
> -
> -		if (!w)
> -			break;
> -		if (w < 0)
> -			return w;
> -	} while (tot != size);
> -
> -	return tot;
> -}
> -
> -static ssize_t
> -__do_write_check(int fd, const void *data, size_t size)
> -{
> -	ssize_t ret;
> -
> -	ret = __do_write(fd, data, size);
> -	if (ret < 0)
> -		return ret;
> -	if (ret != size)
> -		return -1;
> -
> -	return 0;
> -}
> +ssize_t __do_write_check(int fd, const void *data, size_t size);
> +void __noreturn die(const char *fmt, ...); /* Can be overriden */
>  
>  #endif /* _TRACE_CMD_LOCAL_H */
> diff --git a/lib/trace-cmd/trace-instance.c b/lib/trace-cmd/trace-instance.c
> new file mode 100644
> index 0000000..1175b8c
> --- /dev/null
> +++ b/lib/trace-cmd/trace-instance.c
> @@ -0,0 +1,265 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2019, VMware, Tzvetomir Stoyanov tz.stoyanov@gmail.com>
> + *
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <fcntl.h>
> +#include <time.h>
> +#include <poll.h>
> +#include <unistd.h>
> +#include <errno.h>
> +#include <sys/stat.h>
> +
> +#include "trace-cmd.h"
> +#include "trace-cmd-local.h"
> +
> +/**
> + * tracecmd_put_tracing_file - Free tracing file / dir, created by
> + *		tracecmd_get_instance_dir() or tracecmd_get_instance_file()
> + *		APIs.
> + *@name: The name of the tracing file or dir
> + */
> +void tracecmd_put_tracing_file(char *name)
> +{
> +	free(name);
> +}
> +
> +/**
> + * tracecmd_create_instance - allocate a new ftrace instance
> + * @name: The name of the instance (instance will point to this)
> + *
> + * Returns a newly allocated instance. Note that @name will not be
> + * copied, and the instance buffer will point to the string itself.
> + */
> +struct tracecmd_instance *tracecmd_create_instance(const char *name)

Again, better name would be "_alloc_instance"

> +{
> +	struct tracecmd_instance *instance;
> +
> +	instance = malloc(sizeof(*instance));
> +	if (!instance)
> +		return NULL;
> +	memset(instance, 0, sizeof(*instance));
> +	if (name)
> +		instance->name = strdup(name);
> +
> +	return instance;
> +}
> +
> +/**
> + * tracecmd_free_instance - Free an instance struct, previously allocated by
> + *			    tracecmd_create_instance().
> + *@instance: Pointer to the instance to be freed
> + *
> + */
> +void tracecmd_free_instance(struct tracecmd_instance *instance)
> +{
> +	if (!instance)
> +		return;
> +
> +	free(instance->name);
> +	free(instance);
> +}
> +
> +/**
> + * tracecmd_make_instance - Create a new ftrace instance
> + * @instance: Pointer to the instance to be created
> + *
> + * Returns -1 in case of an erro, or 0 otherwise.
> + */
> +int tracecmd_make_instance(struct tracecmd_instance *instance)
> +{
> +	struct stat st;
> +	char *path;
> +	int ret;
> +
> +	path = tracecmd_get_instance_dir(instance);
> +	ret = stat(path, &st);
> +	if (ret < 0) {
> +		ret = mkdir(path, 0777);
> +		if (ret < 0)
> +			return ret;
> +
> +	} else
> +		ret = 1;
> +	tracecmd_put_tracing_file(path);
> +	return ret;
> +}
> +
> +/**
> + * tracecmd_remove_instance - Remove a ftrace instance
> + * @instance: Pointer to the instance to be removed
> + *
> + */
> +void tracecmd_remove_instance(struct tracecmd_instance *instance)

Should return an int.

> +{
> +	char *path;
> +
> +	path = tracecmd_get_instance_dir(instance);
> +	rmdir(path);

We should check the return status of rmdir, and return that.

> +	tracecmd_put_tracing_file(path);
> +}
> +
> +/**
> + * tracecmd_get_instance_file - return the path to a instance file.

Note, none of the one line descriptions should end in a period. There's
a few sprinkled around.

> + * @instance: buffer instance for the file, can be NULL for the top instance
> + * @file: name of file to return
> + *
> + * Returns the path name of the @file for the given @instance.
> + *
> + * Must use tracecmd_put_tracing_file() to free the returned string.
> + */
> +char *
> +tracecmd_get_instance_file(struct tracecmd_instance *instance, const char *file)
> +{
> +	char *path;
> +	char *buf;
> +	int ret;
> +
> +	if (instance && instance->name) {
> +		ret = asprintf(&buf, "instances/%s/%s", instance->name, file);
> +		if (ret < 0)
> +			die("Failed to allocate name for %s/%s", instance->name, file);
> +		path = tracecmd_get_tracing_file(buf);
> +		free(buf);
> +	} else
> +		path = tracecmd_get_tracing_file(file);
> +
> +	return path;
> +}
> +
> +/**
> + * tracecmd_get_instance_file - return the path to a instance file.
> + * @instance: buffer instance for the file, can be NULL for the top instance
> + * @file: name of file to return
> + *
> + * Returns the path name of the @file for the given @instance.
> + *
> + * Must use tracecmd_put_tracing_file() to free the returned string.
> + */
> +char *tracecmd_get_instance_dir(struct tracecmd_instance *instance)
> +{
> +	char *buf;
> +	char *path;
> +	int ret;
> +
> +	if (instance->name) {
> +		ret = asprintf(&buf, "instances/%s", instance->name);
> +		if (ret < 0)
> +			die("Failed to allocate for instance %s", instance->name);
> +		path = tracecmd_get_tracing_file(buf);
> +		free(buf);
> +	} else
> +		path = tracecmd_find_tracing_dir();
> +
> +	return path;
> +}
> +
> +/**
> + * tracecmd_write_instance_file - Write in trace file of specific instance.
> + * @instance: buffer instance for the file, can be NULL for the top instance
> + * @file: name of the file
> + * @str: Null terminated string, that will be written in the file.
> + * @type: Null terminated string, describing the current write operation.

BTW, the correct term is "nul terminated string", as NULL is a pointer,
and "nul" is '\0'.

> + *	  Used for logging purposes.
> + *
> + * Returns the number of written bytes, or -1 in case of an error
> + */
> +int tracecmd_write_instance_file(struct tracecmd_instance *instance,
> +				 const char *file, const char *str,
> +				 const char *type)
> +{
> +	struct stat st;
> +	char *path;
> +	int ret;
> +
> +	path = tracecmd_get_instance_file(instance, file);
> +	ret = stat(path, &st);
> +	if (ret == 0)
> +		ret = tracecmd_write_file(path, str, type);
> +	tracecmd_put_tracing_file(path);
> +
> +	return ret;
> +}
> +
> +/**
> + * tracecmd_read_instance_file - Read from a trace file of specific instance.
> + * @instance: buffer instance for the file, can be NULL for the top instance
> + * @file: name of the file
> + * @psize: Returns the number of bytes read.
> + *
> + * Returns a pointer to a NULL terminated string, read from the file, or NULL in

Again, 'a nul terminated string'

> + * case of an error.

We should also state that the returned string needs to be freed via
free().

> + */
> +char *tracecmd_read_instance_file(struct tracecmd_instance *instance,
> +				  char *file, int *psize)
> +{
> +	char buffer[BUFSIZ];
> +	int size = 0;
> +	char *path;
> +	char *buf;
> +	int fd;
> +	int r;
> +
> +	path = tracecmd_get_instance_file(instance, file);
> +	fd = open(path, O_RDONLY);
> +	tracecmd_put_tracing_file(path);
> +	if (fd < 0) {
> +		warning("File %s not found", file);
> +		return NULL;
> +	}

Probably should add an empty line here.

> +	do {
> +		r = read(fd, buffer, BUFSIZ);
> +		if (r <= 0)
> +			continue;
> +		if (size)
> +			buf = realloc(buf, size+r+1);
> +		else
> +			buf = malloc(r+1);

I know this is only cut and pasted from what the original was, but we
should probably (either in this patch, or perhaps a separate one) fix
the above. As realloc(NULL, x) is equivalent to malloc(x), we can just
have:

		buf = realloc(buf, size+r+1);


> +		if (!buf)
> +			die("Failed to allocate instance file buffer");

As this is becoming a library function, we should remove "die()", as
that is only allowed in the application. Not library calls.

That would also mean we need to clean up anything we allocated on
failure, and that the realloc would need to be:

		new_buf = realloc(buf, size + r + 1);

		if (!new_buf) {
			free(buf);
			return NULL;

All the functions that are being moved into the library needs to have
their die() calls removed. This is OK to do in a separate patch.

Preferably right after this patch (so reviewers know it's happening).


> +		memcpy(buf+size, buffer, r);
> +		size += r;
> +	} while (r);
> +
> +	buf[size] = '\0';
> +	if (psize)
> +		*psize = size;
> +	return buf;
> +}
> +
> +/**
> + * tracecmd_set_clock - Set the clock of ftrace event's timestamps, per instance.
> + * @instance: Pointer to ftrace instance, containing the desired clock.
> + * @old_clock: Optional, return the newly allocated string with the old clock.

This looks to be just a copy of the old code and forced into a library
function. As a library function, it should return an "int" and be
passed the clock name directly. Not via the instance->clock.

-- Steve

> + *
> + */
> +void tracecmd_set_clock(struct tracecmd_instance *instance, char **old_clock)
> +{
> +	char *content;
> +	char *str;
> +
> +	if (!instance->clock)
> +		return;
> +
> +	/* The current clock is in brackets, reset it when we are done */
> +	content = tracecmd_read_instance_file(instance, "trace_clock", NULL);
> +
> +	/* check if first clock is set */
> +	if (*content == '[')
> +		str = strtok(content+1, "]");
> +	else {
> +		str = strtok(content, "[");
> +		if (!str)
> +			die("Can not find clock in trace_clock");
> +		str = strtok(NULL, "]");
> +	}
> +	if (old_clock)
> +		*old_clock = strdup(str);
> +
> +	free(content);
> +	tracecmd_write_instance_file(instance,
> +				     "trace_clock", instance->clock, "clock");
> +}
>
