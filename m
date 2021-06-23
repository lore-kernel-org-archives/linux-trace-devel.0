Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE2EC4743C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Jun 2021 13:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4107961075
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Jun 2021 13:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFWNE0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Jun 2021 09:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbhFWNEW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Jun 2021 09:04:22 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1709C061760
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Jun 2021 06:02:03 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h11so2566910wrx.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Jun 2021 06:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zRkYXgUvy0XCDWaJoJCq7XbzLGtWJzBNNz5gkJgbc4A=;
        b=kYdJjmhkZ8eHJ5PhrTNU/nXfUY5j/dW6a9HQEbTVnj0dBD5+ykF5OtoLFDSY/DsUuP
         lGnXNTyN1xj+F+Ss+T+44Lz4gyqzSFYtt9/4pAmJepxU/H2r6pl8YYetp2RKctXVFcT5
         O4pSzt0i1MRMqC0UE/qPBYJ2yEEbiP455Zl8XlJ2rLsqU67P0ltRjFrfv1fPSekxekgb
         Mvk+ag6iOLtc/ZpAVCRxecCb8VdtMZpCw4fmrmk/E5jNNudEYAp+eV0S1Okhi6eHsxkW
         cw+nhUO756UExPF/dffqT98iPMjq4LpP5TmsEZkmHo7KtqRmeeBHk52my8g89VoGBrm3
         ET7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zRkYXgUvy0XCDWaJoJCq7XbzLGtWJzBNNz5gkJgbc4A=;
        b=b1uFe69Mh5w7Pe2Ojfpmly6/1I4wD4QK7NyInHuVTdd5Yjcltrmo8UqbXZY1wK+qZ4
         +XP6uV5XnRE1PWMBjZ9axT5N5nPkpI0vG2NvKCKY5BiNxu3gEBDLAh/y2pDf3kmV26cF
         TPToJ3Vq+W+1J7I2Aa3ROH0xjhznjqXZcFHJG/tu7ufMxhjPQmt1/5Lpj25AhghY8T3h
         cELHNNg9PPb9oMt11HNQKzKAL5BYuPovE2m7SISa6Ix5xAqu3xUikmDt/gWv2uUwaGA5
         GY/4PeF3xHIF4d+o+Tl3YO+8KH/bS+K9/0jfmhmbPv+8W4S9ydF/fNsfzLoB3Gtg4sTN
         pRLQ==
X-Gm-Message-State: AOAM531wcE0iFcUpFB9TFutG2ahDncl7H2iizBau62Xs4cNJdA+Lvfa1
        f4Vn6tHCcX/awWpB93bpYUrK1RzsLu8=
X-Google-Smtp-Source: ABdhPJwP6KEigTDGJqGixikKg7CHtNq1QxkRmmnKoG7L6Bdni2DFZbB0lZ0ArfQDGet+b6CDNorllg==
X-Received: by 2002:adf:e110:: with SMTP id t16mr11415587wrz.359.1624453321473;
        Wed, 23 Jun 2021 06:02:01 -0700 (PDT)
Received: from [10.93.98.252] ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id w8sm2753464wre.70.2021.06.23.06.02.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 06:02:01 -0700 (PDT)
Subject: Re: [PATCH v2] libtracefs: Add APIs for data streaming
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210623120526.36623-1-y.karadz@gmail.com>
 <20210623084535.7a199813@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <481ebd67-050b-06bf-bcce-ae0febd79ab5@gmail.com>
Date:   Wed, 23 Jun 2021 16:02:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210623084535.7a199813@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 23.06.21 г. 15:45, Steven Rostedt wrote:
> On Wed, 23 Jun 2021 15:05:26 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> The new APIs can be used to dump the content of "trace_pipe" into a
>> file or directly to "stdout". The "splice" system call is used to
>> moves the data without copying. The new functionality is essentially
>> identical to what 'trace-cmd show -p' does.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>
>> Changes in v2:
>>    - The setting of the signal disposition is removed from the library
>>      and is now responsibility of the caller. This in fact gives more
>>      options for the user.
>>    - The example provided in the documentation is updated accordingly.
>>
>>   Documentation/libtracefs-stream.txt | 106 ++++++++++++++++++++++++++++
>>   include/tracefs-local.h             |   1 +
>>   include/tracefs.h                   |   5 ++
>>   src/tracefs-tools.c                 |  98 +++++++++++++++++++++++++
>>   4 files changed, 210 insertions(+)
>>   create mode 100644 Documentation/libtracefs-stream.txt
>>
>> diff --git a/Documentation/libtracefs-stream.txt b/Documentation/libtracefs-stream.txt
>> new file mode 100644
>> index 0000000..24c2e47
>> --- /dev/null
>> +++ b/Documentation/libtracefs-stream.txt
>> @@ -0,0 +1,106 @@
>> +libtracefs(3)
>> +=============
>> +
>> +NAME
>> +----
>> +tracefs_trace_pipe_stream, tracefs_trace_pipe_print -
>> +redirect the stream of trace data to an output or stdout.
>> +
>> +SYNOPSIS
>> +--------
>> +[verse]
>> +--
>> +*#include <tracefs.h>*
>> +
>> +int tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
>> +int tracefs_trace_pipe_print(struct tracefs_instance *instance);
>> +
>> +--
>> +
>> +DESCRIPTION
>> +-----------
>> +If NULL is passed as _instance_, the top trace instance is used.
>> +The user can interrupt the streaming of the data by pressing Ctrl-c.
>> +
>> +The _tracefs_trace_pipe_stream()_ function redirects the stream of trace data to an output
>> +file. The "splice" system call is used to moves the data without copying between kernel
>> +address space and user address space. The _fd_ is the file descriptor of the output file
>> +and _flags_ is a bit mask of flags to be passed to the "splice" system call.
>> +
>> +The _tracefs_trace_pipe_print()_ function is similar to _tracefs_trace_pipe_stream()_, but
>> +the stream of trace data is redirected to stdout.
>> +
>> +
>> +RETURN VALUE
>> +------------
>> +The _tracefs_trace_pipe_stream()_, and _tracefs_trace_pipe_print()_ functions return 0 if the operation is
>> +successful, or -1 in case of an error.
>> +
>> +EXAMPLE
>> +-------
>> +[source,c]
>> +--
>> +#include <unistd.h>
>> +#include <signal.h>
>> +
>> +#include <tracefs.h>
>> +
>> +void stop(int sig)
>> +{
>> +	tracefs_trace_pipe_stop(NULL);
>> +}
>> +
>> +int main()
>> +{
>> +	mode_t mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
>> +	const char *filename = "trace.txt";
>> +	int fd = creat(filename, mode);
>> +	int ret;
>> +
>> +	signal(SIGINT, stop);
>> +	ret = tracefs_trace_pipe_stream(fd, NULL, 0);
>> +	close(fd);
>> +
>> +	return ret;
>> +}
>> +--
>> +FILES
>> +-----
>> +[verse]
>> +--
>> +*tracefs.h*
>> +	Header file to include in order to have access to the library APIs.
>> +*-ltracefs*
>> +	Linker switch to add when building a program that uses the library.
>> +--
>> +
>> +SEE ALSO
>> +--------
>> +_libtracefs(3)_,
>> +_libtraceevent(3)_,
>> +_trace-cmd(1)_,
>> +Documentation/trace/ftrace.rst from the Linux kernel tree
>> +
>> +AUTHOR
>> +------
>> +[verse]
>> +--
>> +*Steven Rostedt* <rostedt@goodmis.org>
>> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
>> +--
>> +REPORTING BUGS
>> +--------------
>> +Report bugs to  <linux-trace-devel@vger.kernel.org>
>> +
>> +LICENSE
>> +-------
>> +libtracefs is Free Software licensed under the GNU LGPL 2.1
>> +
>> +RESOURCES
>> +---------
>> +https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
>> +
>> +COPYING
>> +-------
>> +Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
>> +the terms of the GNU Public License (GPL).
>> diff --git a/include/tracefs-local.h b/include/tracefs-local.h
>> index 9e3aa18..833f136 100644
>> --- a/include/tracefs-local.h
>> +++ b/include/tracefs-local.h
>> @@ -30,6 +30,7 @@ struct tracefs_instance {
>>   	int				ftrace_notrace_fd;
>>   	int				ftrace_marker_fd;
>>   	int				ftrace_marker_raw_fd;
>> +	int				pipe_keep_going;
>>   };
>>   
>>   extern pthread_mutex_t toplevel_lock;
>> diff --git a/include/tracefs.h b/include/tracefs.h
>> index e29b550..3c6741b 100644
>> --- a/include/tracefs.h
>> +++ b/include/tracefs.h
>> @@ -184,4 +184,9 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
>>   /* Control library logs */
>>   void tracefs_set_loglevel(enum tep_loglevel level);
>>   
>> +int tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance, int flags);
>> +int tracefs_trace_pipe_print(struct tracefs_instance *instance);
>> +void tracefs_trace_pipe_stop(struct tracefs_instance *instance);
>> +
>> +
>>   #endif /* _TRACE_FS_H */
>> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
>> index 0cbb56d..0c0c44f 100644
>> --- a/src/tracefs-tools.c
>> +++ b/src/tracefs-tools.c
>> @@ -912,3 +912,101 @@ int tracefs_function_notrace(struct tracefs_instance *instance, const char *filt
>>   	tracefs_put_tracing_file(filter_path);
>>   	return ret;
>>   }
>> +
>> +static int top_pipe_keep_going;
>> +
>> +/**
>> + * tracefs_trace_pipe_stream - redirect the stream of trace data to an output
>> + * file. The "splice" system call is used to moves the data without copying
>> + * between kernel address space and user address space. The user can interrupt
>> + * the streaming of the data by pressing Ctrl-c.
>> + * @fd: The file descriptor of the output file.
>> + * @instance: ftrace instance, can be NULL for top tracing instance.
>> + * @flags: flags to be passed to the "splice" system call.
>> + *
>> + * Returns -1 in case of an error or 0 otherwise.
>> + */
>> +int tracefs_trace_pipe_stream(int fd, struct tracefs_instance *instance,
>> +			      int flags)
>> +{
>> +	int *keep_going = instance ? &instance->pipe_keep_going :
>> +				     &top_pipe_keep_going;
> 
> I'm thinking we should invert the above. That is, have a stop instead of
> "keep_going", where it is false by default (when the instance is created).
> 
> That's because, if we start here, and the SIGINT comes in before we get
> here, it keep_going might get set to false, and missed.

I intentionally tried to avoid having any dependency of the initialization value of the "keep_going" flag. We have to 
consider the case when the user creates one instance and then calls this function multiple times in a row.


> 
>> +	const char *file = "trace_pipe";
>> +	int brass[2], in_fd, ret = -1;
>> +	off_t data_size;
>> +
>> +	in_fd = tracefs_instance_file_open(instance, file, O_RDONLY);
>> +	if (in_fd < 0) {
>> +		tracefs_warning("Failed to open 'trace_pipe'.");
>> +		return ret;
>> +	}
>> +
>> +	if(pipe(brass) < 0) {
>> +		tracefs_warning("Failed to open pipe.");
>> +		goto close_file;
>> +	}
>> +
>> +	data_size = fcntl(brass[0], F_GETPIPE_SZ);
>> +	if (data_size <= 0) {
>> +		tracefs_warning("Failed to open pipe (size=0).");
>> +		goto close_all;
>> +	}
>> +
>> +	*keep_going = true;
> 
> Then we get here and we set it back to true.
> 
> Perhaps we should have a:
> 
> 	instance->pipe_stop
> 
> flag that gets set by the user.
> 
> And instead of setting the variable here, add a,
> 
>     tracefs_trace_pipe_start(instance)
> 
> to match the tracefs_trace_pipe_stop().
> 
> If the user stops it, we should make it so that they need to start it again.

I do not understand your point with the "start" function. tracefs_trace_pipe_stream() itself is the start.

Thanks!
Yordan


> 
> -- Steve
> 
> 
>> +	while (*keep_going) {
>> +		ret = splice(in_fd, NULL,
>> +			     brass[1], NULL,
>> +			     data_size, flags);
>> +		if (ret < 0)
>> +			break;
>> +
>> +		ret = splice(brass[0], NULL,
>> +			     fd, NULL,
>> +			     data_size, flags);
>> +		if (ret < 0)
>> +			break;
>> +	}
>> +
>> +	/*
>> +	 * Do not return error in the case when the "splice" system call
>> +	 * was interrupted by the user (pressing Ctrl-c).
>> +	 */
>> +	if (!keep_going)
>> +		ret = 0;
>> +
>> + close_all:
>> +	close(brass[0]);
>> +	close(brass[1]);
>> + close_file:
>> +	close(in_fd);
>> +
>> +	return ret;
>> +}
>> +
>> +/**
>> + * tracefs_trace_pipe_print - redirect the stream of trace data to "stdout".
>> + * The "splice" system call is used to moves the data without copying
>> + * between kernel address space and user address space.
>> + * @instance: ftrace instance, can be NULL for top tracing instance.
>> + *
>> + * Returns -1 in case of an error or 0 otherwise.
>> + */
>> +
>> +int tracefs_trace_pipe_print(struct tracefs_instance *instance)
>> +{
>> +   return tracefs_trace_pipe_stream(STDOUT_FILENO,
>> +				    instance,
>> +				    SPLICE_F_MORE | SPLICE_F_MOVE);
>> +}
>> +
>> +/**
>> + * tracefs_trace_pipe_stop - stop the streaming of trace data.
>> + * @instance: ftrace instance, can be NULL for top tracing instance.
>> + */
>> +void tracefs_trace_pipe_stop(struct tracefs_instance *instance)
>> +{
>> +	if (instance)
>> +		instance->pipe_keep_going = false;
>> +	else
>> +		top_pipe_keep_going = false;
>> +}
> 
