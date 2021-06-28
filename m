Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C9E8C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Jun 2021 13:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7399261C6B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Jun 2021 13:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbhF1NQS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Jun 2021 09:16:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232502AbhF1NQR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 09:16:17 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBC00619AB;
        Mon, 28 Jun 2021 13:13:51 +0000 (UTC)
Date:   Mon, 28 Jun 2021 09:13:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v5] libtracefs: Add APIs for data streaming
Message-ID: <20210628091350.1d03dbb0@oasis.local.home>
In-Reply-To: <e2032e1f-8b4b-2e7c-9d36-aa1bb3eb31ba@gmail.com>
References: <20210625142737.6c028a93@oasis.local.home>
        <e2032e1f-8b4b-2e7c-9d36-aa1bb3eb31ba@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 28 Jun 2021 11:58:10 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:
> > +
> > +static ssize_t read_trace_pipe(bool *keep_going, int in_fd, int out_fd)
> > +{
> > +	char buf[BUFSIZ];
> > +	ssize_t bread = 0;
> > +	int ret;
> > +
> > +	do {
> > +		ret = read(in_fd, buf, BUFSIZ);
> > +		if (ret > 0) {
> > +			ret = write(STDOUT_FILENO, buf, ret);  
> 
> this should be

Doh! I know I was hard coding that in some places for debugging, and
that may have been me not cleaning it up. Thanks, will fix.


> 			ret = write(in_fd, buf, ret);
> 
> > +			if (ret > 0)
> > +				bread += ret;
> > +		}
> > +	} while (ret > 0 && *(volatile bool *)keep_going);
> > +  
> 
> Nit: When looping you check the value of 'ret' 3 times.
>       The same can be done with only 2 checks.
> 
> 	while (*(volatile bool *)keep_going) {
> 		ret = read(in_fd, buf, BUFSIZ);
> 		if (ret <= 0)
> 			break;
> 
> 		ret = write(out_fd, buf, ret);
> 		if (ret <= 0)
> 			break;
> 
> 		bread += ret;
> 	}

Nice, I got you thinking about optimizations ;-)

I'll update it.


> 
> > +	if (ret < 0 && (errno == EAGAIN || errno == EINTR))
> > +		ret = 0;
> > +
> > +	return ret < 0 ? ret : bread;
> > +}
> > +
> > +static bool top_pipe_keep_going;
> > +
> > +/**
> > + * tracefs_trace_pipe_stream - redirect the stream of trace data to an output
> > + * file. The "splice" system call is used to moves the data without copying
> > + * between kernel address space and user address space. The user can interrupt
> > + * the streaming of the data by pressing Ctrl-c.
> > + * @fd: The file descriptor of the output file.
> > + * @instance: ftrace instance, can be NULL for top tracing instance.
> > + * @flags: flags to be passed to the "splice" system call.
> > + *
> > + * Returns -1 in case of an error or number of bytes transferred otherwise.
> > + */
> > +ssize_t tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance,
> > +				 int flags)
> > +{
> > +	bool *keep_going = instance ? &instance->pipe_keep_going :
> > +				      &top_pipe_keep_going;
> > +	const char *file = "trace_pipe";
> > +	int brass[2], in_fd, ret = -1;
> > +	int oflags = flags & SPLICE_F_NONBLOCK ? O_NONBLOCK: 0;
> > +	off_t data_size;
> > +	ssize_t bread = 0;
> > +
> > +	(*(volatile bool *)keep_going) = true;
> > +
> > +	in_fd = tracefs_instance_file_open(instance, file, O_RDONLY | oflags);
> > +	if (in_fd < 0) {
> > +		tracefs_warning("Failed to open 'trace_pipe'.");
> > +		return ret;
> > +	}
> > +
> > +	if(pipe(brass) < 0) {
> > +		tracefs_warning("Failed to open pipe.");
> > +		goto close_file;
> > +	}
> > +
> > +	data_size = fcntl(brass[0], F_GETPIPE_SZ);
> > +	if (data_size <= 0) {
> > +		tracefs_warning("Failed to open pipe (size=0).");
> > +		goto close_all;
> > +	}
> > +
> > +	/* Test if the output is splice safe */
> > +	if (!splice_safe(fd, brass[0])) {
> > +		close(brass[0]);
> > +		close(brass[1]);
> > +		return read_trace_pipe(keep_going, in_fd, fd);  
> 
> we must close 'in_fd' before returning.

Good catch. I was planning on closing it in read_trace_pipe() and
forgot. I'll close it here.

> 
> > +	}
> > +
> > +	errno = 0;
> > +
> > +	while (*(volatile bool *)keep_going) {
> > +		ret = splice(in_fd, NULL,
> > +			     brass[1], NULL,
> > +			     data_size, flags);
> > +		if (ret < 0)
> > +			break;
> > +
> > +		ret = splice(brass[0], NULL,
> > +			     fd, NULL,
> > +			     data_size, flags);
> > +		if (ret < 0)
> > +			break;
> > +		bread += ret;
> > +	}
> > +
> > +	/*
> > +	 * Do not return error in the case when the "splice" system call
> > +	 * was interrupted by the user (pressing Ctrl-c).
> > +	 * Or if NONBLOCK was specified.
> > +	 */
> > +	if (!keep_going || errno == EAGAIN || errno == EINTR)
> > +		ret = 0;
> > +
> > + close_all:
> > +	close(brass[0]);
> > +	close(brass[1]);
> > + close_file:
> > +	close(in_fd);
> > +
> > +	return ret ? ret : bread;
> > +}
> > +
> > +/**
> > + * tracefs_trace_pipe_print - redirect the stream of trace data to "stdout".
> > + * The "splice" system call is used to moves the data without copying
> > + * between kernel address space and user address space.
> > + * @instance: ftrace instance, can be NULL for top tracing instance.
> > + *
> > + * Returns -1 in case of an error or number of bytes transferred otherwise.
> > + */
> > +
> > +ssize_t tracefs_trace_pipe_print(struct tracefs_instance *instance)
> > +{
> > +	return tracefs_trace_pipe_stream(STDOUT_FILENO, instance,
> > +					 SPLICE_F_NONBLOCK);
> > +}
> > +  
> 
> In fact I want to use this function in "blocking" mode. I would like to keep listening for new trace data until the user 
> presses 'Ctrl-c'. Can we make this function to take a second parameter that will be the splice flags?

Yeah, I was going to ask you if you wanted this to have flags too.

I was also thinking that we should use the O_ flags and not the
SPLICE_F_ flags, as splice is more niche, and O_ is POSIX. We can check
the flags and change them for splice inside these functions.

Are you OK with that?

-- Steve


> 
> Thanks a lot!
> Yordan
> 
