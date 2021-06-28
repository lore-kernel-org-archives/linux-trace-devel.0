Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AE7C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Jun 2021 08:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9943B61C2E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Jun 2021 08:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhF1JAk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Jun 2021 05:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhF1JAj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 05:00:39 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993A4C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Jun 2021 01:58:13 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id hq39so28669031ejc.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Jun 2021 01:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h9XyLAa9sbajZEy8b1Jjy2bl1yoP+BuvjdE8UO9HR1g=;
        b=EbHt8c+Bi7CKNiXFFK/VvNZdBMUuB0YgBhkl95fJRNNY0zLszBCCTHZ4A4YvKkKh/j
         L7A99EkF1qLcxeVehNh+i70AaSBOijbkiEfNBSSy+zc+W0d1LHuDndljL2hIcbu7cdt5
         qGMBHExtAkDHWpVWT6T3uzLd1MT3+yc5/+K6cH/zoO/nIy5DKNT236AEZSZy2pzWQXl3
         DanWtHu0+8FOU2tLA4iRJi2VkY+038qxpN4cKhNsR5hGr631nLgHkE12d41WZN4DvSyC
         ZmyQ+LkwkNPq6Xnx7j1K/U0uWBqd+/2XEZ2Q9O/EUCAnGRxNDtX46W1outqitOgKNESS
         W+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h9XyLAa9sbajZEy8b1Jjy2bl1yoP+BuvjdE8UO9HR1g=;
        b=HHEUzFNBoHTTqWp7SbEgm+uARkGTqsam7sUYMxm2x2y0QyOHQYhSOuNYLvrjE+0EPp
         V+1Tv08vr5TYBKw2uukKWITedcUZA2ZOte5G5qgZofqMmQSa2YHk+BFE36ZNKXzVidmC
         DgsJ/dLvPiMCmDkRQrrtUO5b/EoRLRICiPZ4ZOYAptPIpAISoh2wgnHUNIiU2KhB4WzE
         wbc+HgQ6S+sriPeqMN1Zy4KPrd4V8M61jUbizk3a97S+PAHfs/xH0wsWuxL4qjZaFpN/
         LHoUyG5ols8oli4HuJ+u/8sHAKLl7rrGcILbUuN9EOZjCJIjIBlsLYKgiWWL4tXaUuXe
         b18A==
X-Gm-Message-State: AOAM53274yPxHauLxkOUBDPb8Uu1GeQzOHmYH5/oTJhxJulT7KhHsb3z
        DgH/LlLTX4K7v+ULcZVagnYmhEQkmVA=
X-Google-Smtp-Source: ABdhPJwS2ny1hUh0Gmmy7PcLCI5Tkt5g+intvLu55ALXV6N7l054A4gQ6/XZHg6Bzj7k4l3TiErQrA==
X-Received: by 2002:a17:907:62a5:: with SMTP id nd37mr23049035ejc.148.1624870691728;
        Mon, 28 Jun 2021 01:58:11 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id w24sm6586681ejk.58.2021.06.28.01.58.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 01:58:11 -0700 (PDT)
Subject: Re: [PATCH v5] libtracefs: Add APIs for data streaming
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
References: <20210625142737.6c028a93@oasis.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <e2032e1f-8b4b-2e7c-9d36-aa1bb3eb31ba@gmail.com>
Date:   Mon, 28 Jun 2021 11:58:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625142737.6c028a93@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 25.06.21 г. 21:27, Steven Rostedt wrote:
> From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
> 
> The new APIs can be used to dump the content of "trace_pipe" into a
> file or directly to "stdout". The "splice" system call is used to
> moves the data without copying. The new functionality is essentially
> identical to what 'trace-cmd show -p' does.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> [ Updated to fix writing to STDOUT ]
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
> Changes since v4:
> 
>   - Simplified. Have tracefs_trace_pipe_stream() test the output file
>     descriptor if it is safe to splice to. If it is, then it splices to
>     the output. If not, it then simply reads the trace and writes it.
> 
>   - The tracefs_trace_pipe_print() goes back to just calling
>     tracefs_trace_pipe_stream().
> 
>   Documentation/libtracefs-stream.txt | 106 +++++++++++++++++++++
>   include/tracefs-local.h             |   1 +
>   include/tracefs.h                   |   5 +
>   src/tracefs-tools.c                 | 143 ++++++++++++++++++++++++++++
>   4 files changed, 255 insertions(+)
>   create mode 100644 Documentation/libtracefs-stream.txt
> 
> diff --git a/Documentation/libtracefs-stream.txt b/Documentation/libtracefs-stream.txt
> new file mode 100644
> index 0000000..b9692e3
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
> +ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
> +ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance);
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
> +The _tracefs_trace_pipe_stream()_, and _tracefs_trace_pipe_print()_ functions return the
> +number of bytes transfered if the operation is successful, or -1 in case of an error.
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
> +	ret = tracefs_trace_pipe_stream(fd, NULL, SPLICE_F_NONBLOCK);
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
> index 9e3aa18..73698e8 100644
> --- a/include/tracefs-local.h
> +++ b/include/tracefs-local.h
> @@ -30,6 +30,7 @@ struct tracefs_instance {
>   	int				ftrace_notrace_fd;
>   	int				ftrace_marker_fd;
>   	int				ftrace_marker_raw_fd;
> +	bool				pipe_keep_going;
>   };
>   
>   extern pthread_mutex_t toplevel_lock;
> diff --git a/include/tracefs.h b/include/tracefs.h
> index e29b550..23a3c7d 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -184,4 +184,9 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
>   /* Control library logs */
>   void tracefs_set_loglevel(enum tep_loglevel level);
>   
> +ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
> +ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance);
> +void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
> +
> +
>   #endif /* _TRACE_FS_H */
> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> index 0cbb56d..48ef928 100644
> --- a/src/tracefs-tools.c
> +++ b/src/tracefs-tools.c
> @@ -912,3 +912,146 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
>   	tracefs_put_tracing_file(filter_path);
>   	return ret;
>   }
> +
> +static bool splice_safe(int fd, int pfd)
> +{
> +	int ret;
> +
> +	errno = 0;
> +	ret = splice(pfd, NULL, fd, NULL,
> +		     10, SPLICE_F_NONBLOCK | SPLICE_F_MOVE);
> +
> +	return !ret || (ret < 0 && errno == EAGAIN);
> +}
> +
> +static ssize_t read_trace_pipe(bool *keep_going, int in_fd, int out_fd)
> +{
> +	char buf[BUFSIZ];
> +	ssize_t bread = 0;
> +	int ret;
> +
> +	do {
> +		ret = read(in_fd, buf, BUFSIZ);
> +		if (ret > 0) {
> +			ret = write(STDOUT_FILENO, buf, ret);

this should be
			ret = write(in_fd, buf, ret);

> +			if (ret > 0)
> +				bread += ret;
> +		}
> +	} while (ret > 0 && *(volatile bool *)keep_going);
> +

Nit: When looping you check the value of 'ret' 3 times.
      The same can be done with only 2 checks.

	while (*(volatile bool *)keep_going) {
		ret = read(in_fd, buf, BUFSIZ);
		if (ret <= 0)
			break;

		ret = write(out_fd, buf, ret);
		if (ret <= 0)
			break;

		bread += ret;
	}

> +	if (ret < 0 && (errno == EAGAIN || errno == EINTR))
> +		ret = 0;
> +
> +	return ret < 0 ? ret : bread;
> +}
> +
> +static bool top_pipe_keep_going;
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
> + * Returns -1 in case of an error or number of bytes transferred otherwise.
> + */
> +ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance,
> +				 int flags)
> +{
> +	bool *keep_going = instance ? &instance->pipe_keep_going :
> +				      &top_pipe_keep_going;
> +	const char *file = "trace_pipe";
> +	int brass[2], in_fd, ret = -1;
> +	int oflags = flags & SPLICE_F_NONBLOCK ? O_NONBLOCK: 0;
> +	off_t data_size;
> +	ssize_t bread = 0;
> +
> +	(*(volatile bool *)keep_going) = true;
> +
> +	in_fd = tracefs_instance_file_open(instance, file, O_RDONLY | oflags);
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
> +	/* Test if the output is splice safe */
> +	if (!splice_safe(fd, brass[0])) {
> +		close(brass[0]);
> +		close(brass[1]);
> +		return read_trace_pipe(keep_going, in_fd, fd);

we must close 'in_fd' before returning.

> +	}
> +
> +	errno = 0;
> +
> +	while (*(volatile bool *)keep_going) {
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
> +		bread += ret;
> +	}
> +
> +	/*
> +	 * Do not return error in the case when the "splice" system call
> +	 * was interrupted by the user (pressing Ctrl-c).
> +	 * Or if NONBLOCK was specified.
> +	 */
> +	if (!keep_going || errno == EAGAIN || errno == EINTR)
> +		ret = 0;
> +
> + close_all:
> +	close(brass[0]);
> +	close(brass[1]);
> + close_file:
> +	close(in_fd);
> +
> +	return ret ? ret : bread;
> +}
> +
> +/**
> + * tracefs_trace_pipe_print - redirect the stream of trace data to "stdout".
> + * The "splice" system call is used to moves the data without copying
> + * between kernel address space and user address space.
> + * @instance: ftrace instance, can be NULL for top tracing instance.
> + *
> + * Returns -1 in case of an error or number of bytes transferred otherwise.
> + */
> +
> +ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance)
> +{
> +	return tracefs_trace_pipe_stream(STDOUT_FILENO, instance,
> +					 SPLICE_F_NONBLOCK);
> +}
> +

In fact I want to use this function in "blocking" mode. I would like to keep listening for new trace data until the user 
presses 'Ctrl-c'. Can we make this function to take a second parameter that will be the splice flags?

Thanks a lot!
Yordan

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
> 
