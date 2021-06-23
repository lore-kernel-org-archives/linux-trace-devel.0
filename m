Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5296C48BE5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Jun 2021 12:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 999B96108E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Jun 2021 12:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhFWMry (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Jun 2021 08:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhFWMry (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Jun 2021 08:47:54 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9973E61076;
        Wed, 23 Jun 2021 12:45:36 +0000 (UTC)
Date:   Wed, 23 Jun 2021 08:45:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] libtracefs: Add APIs for data streaming
Message-ID: <20210623084535.7a199813@gandalf.local.home>
In-Reply-To: <20210623120526.36623-1-y.karadz@gmail.com>
References: <20210623120526.36623-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 23 Jun 2021 15:05:26 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The new APIs can be used to dump the content of "trace_pipe" into a
> file or directly to "stdout". The "splice" system call is used to
> moves the data without copying. The new functionality is essentially
> identical to what 'trace-cmd show -p' does.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
> 
> Changes in v2:
>   - The setting of the signal disposition is removed from the library
>     and is now responsibility of the caller. This in fact gives more
>     options for the user.
>   - The example provided in the documentation is updated accordingly.
> 
>  Documentation/libtracefs-stream.txt | 106 ++++++++++++++++++++++++++++
>  include/tracefs-local.h             |   1 +
>  include/tracefs.h                   |   5 ++
>  src/tracefs-tools.c                 |  98 +++++++++++++++++++++++++
>  4 files changed, 210 insertions(+)
>  create mode 100644 Documentation/libtracefs-stream.txt
> 
> diff --git a/Documentation/libtracefs-stream.txt b/Documentation/libtracefs-stream.txt
> new file mode 100644
> index 0000000..24c2e47
> --- /dev/null
> +++ b/Documentation/libtracefs-stream.txt
> @@ -0,0 +1,106 @@
> +libtracefs(3)
> +=============
> +
> +NAME
> +----
> +tracefs_trace_pipe_stream, tracefs_trace_pipe_print -
> +redirect the stream of trace data to an output or stdout.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <tracefs.h>*
> +
> +int tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
> +int tracefs_trace_pipe_print(struct tracefs_instance *instance);
> +
> +--
> +
> +DESCRIPTION
> +-----------
> +If NULL is passed as _instance_, the top trace instance is used.
> +The user can interrupt the streaming of the data by pressing Ctrl-c.
> +
> +The _tracefs_trace_pipe_stream()_ function redirects the stream of trace data to an output
> +file. The "splice" system call is used to moves the data without copying between kernel
> +address space and user address space. The _fd_ is the file descriptor of the output file
> +and _flags_ is a bit mask of flags to be passed to the "splice" system call.
> +
> +The _tracefs_trace_pipe_print()_ function is similar to _tracefs_trace_pipe_stream()_, but
> +the stream of trace data is redirected to stdout.
> +
> +
> +RETURN VALUE
> +------------
> +The _tracefs_trace_pipe_stream()_, and _tracefs_trace_pipe_print()_ functions return 0 if the operation is
> +successful, or -1 in case of an error.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <unistd.h>
> +#include <signal.h>
> +
> +#include <tracefs.h>
> +
> +void stop(int sig)
> +{
> +	tracefs_trace_pipe_stop(NULL);
> +}
> +
> +int main()
> +{
> +	mode_t mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
> +	const char *filename = "trace.txt";
> +	int fd = creat(filename, mode);
> +	int ret;
> +
> +	signal(SIGINT, stop);
> +	ret = tracefs_trace_pipe_stream(fd, NULL, 0);
> +	close(fd);
> +
> +	return ret;
> +}
> +--
> +FILES
> +-----
> +[verse]
> +--
> +*tracefs.h*
> +	Header file to include in order to have access to the library APIs.
> +*-ltracefs*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtracefs(3)_,
> +_libtraceevent(3)_,
> +_trace-cmd(1)_,
> +Documentation/trace/ftrace.rst from the Linux kernel tree
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtracefs is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
> +
> +COPYING
> +-------
> +Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
> +the terms of the GNU Public License (GPL).
> diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> index 9e3aa18..833f136 100644
> --- a/include/tracefs-local.h
> +++ b/include/tracefs-local.h
> @@ -30,6 +30,7 @@ struct tracefs_instance {
>  	int				ftrace_notrace_fd;
>  	int				ftrace_marker_fd;
>  	int				ftrace_marker_raw_fd;
> +	int				pipe_keep_going;
>  };
>  
>  extern pthread_mutex_t toplevel_lock;
> diff --git a/include/tracefs.h b/include/tracefs.h
> index e29b550..3c6741b 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -184,4 +184,9 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
>  /* Control library logs */
>  void tracefs_set_loglevel(enum tep_loglevel level);
>  
> +int tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
> +int tracefs_trace_pipe_print(struct tracefs_instance *instance);
> +void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
> +
> +
>  #endif /* _TRACE_FS_H */
> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> index 0cbb56d..0c0c44f 100644
> --- a/src/tracefs-tools.c
> +++ b/src/tracefs-tools.c
> @@ -912,3 +912,101 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
>  	tracefs_put_tracing_file(filter_path);
>  	return ret;
>  }
> +
> +static int top_pipe_keep_going;
> +
> +/**
> + * tracefs_trace_pipe_stream - redirect the stream of trace data to an output
> + * file. The "splice" system call is used to moves the data without copying
> + * between kernel address space and user address space. The user can interrupt
> + * the streaming of the data by pressing Ctrl-c.
> + * @fd: The file descriptor of the output file.
> + * @instance: ftrace instance, can be NULL for top tracing instance.
> + * @flags: flags to be passed to the "splice" system call.
> + *
> + * Returns -1 in case of an error or 0 otherwise.
> + */
> +int tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance,
> +			      int flags)
> +{
> +	int *keep_going = instance ? &instance->pipe_keep_going :
> +				     &top_pipe_keep_going;

I'm thinking we should invert the above. That is, have a stop instead of
"keep_going", where it is false by default (when the instance is created).

That's because, if we start here, and the SIGINT comes in before we get
here, it keep_going might get set to false, and missed.

> +	const char *file = "trace_pipe";
> +	int brass[2], in_fd, ret = -1;
> +	off_t data_size;
> +
> +	in_fd = tracefs_instance_file_open(instance, file, O_RDONLY);
> +	if (in_fd < 0) {
> +		tracefs_warning("Failed to open 'trace_pipe'.");
> +		return ret;
> +	}
> +
> +	if(pipe(brass) < 0) {
> +		tracefs_warning("Failed to open pipe.");
> +		goto close_file;
> +	}
> +
> +	data_size = fcntl(brass[0], F_GETPIPE_SZ);
> +	if (data_size <= 0) {
> +		tracefs_warning("Failed to open pipe (size=0).");
> +		goto close_all;
> +	}
> +
> +	*keep_going = true;

Then we get here and we set it back to true.

Perhaps we should have a:

	instance->pipe_stop

flag that gets set by the user.

And instead of setting the variable here, add a,

   tracefs_trace_pipe_start(instance)

to match the tracefs_trace_pipe_stop().

If the user stops it, we should make it so that they need to start it again.

-- Steve


> +	while (*keep_going) {
> +		ret = splice(in_fd, NULL,
> +			     brass[1], NULL,
> +			     data_size, flags);
> +		if (ret < 0)
> +			break;
> +
> +		ret = splice(brass[0], NULL,
> +			     fd, NULL,
> +			     data_size, flags);
> +		if (ret < 0)
> +			break;
> +	}
> +
> +	/*
> +	 * Do not return error in the case when the "splice" system call
> +	 * was interrupted by the user (pressing Ctrl-c).
> +	 */
> +	if (!keep_going)
> +		ret = 0;
> +
> + close_all:
> +	close(brass[0]);
> +	close(brass[1]);
> + close_file:
> +	close(in_fd);
> +
> +	return ret;
> +}
> +
> +/**
> + * tracefs_trace_pipe_print - redirect the stream of trace data to "stdout".
> + * The "splice" system call is used to moves the data without copying
> + * between kernel address space and user address space.
> + * @instance: ftrace instance, can be NULL for top tracing instance.
> + *
> + * Returns -1 in case of an error or 0 otherwise.
> + */
> +
> +int tracefs_trace_pipe_print(struct tracefs_instance *instance)
> +{
> +   return tracefs_trace_pipe_stream(STDOUT_FILENO,
> +				    instance,
> +				    SPLICE_F_MORE | SPLICE_F_MOVE);
> +}
> +
> +/**
> + * tracefs_trace_pipe_stop - stop the streaming of trace data.
> + * @instance: ftrace instance, can be NULL for top tracing instance.
> + */
> +void tracefs_trace_pipe_stop(struct tracefs_instance *instance)
> +{
> +	if (instance)
> +		instance->pipe_keep_going = false;
> +	else
> +		top_pipe_keep_going = false;
> +}

