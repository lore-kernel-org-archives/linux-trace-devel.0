Return-Path: <SRS0=k4No=JM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:41876 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965359AbeFZOrQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Jun 2018 10:47:16 -0400
Received: by mail-wr0-f194.google.com with SMTP id h10-v6so17536903wrq.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Jun 2018 07:47:16 -0700 (PDT)
Subject: Re: [PATCH 3/7] kernel-shark-qt: Add API for loading trace.dat files
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180625150121.14291-1-y.karadz@gmail.com>
 <20180625150121.14291-4-y.karadz@gmail.com>
 <20180625143006.6b2cbad3@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <aaaaab86-51c0-506e-939e-1604274e09fc@gmail.com>
Date: Tue, 26 Jun 2018 17:47:13 +0300
MIME-Version: 1.0
In-Reply-To: <20180625143006.6b2cbad3@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 25.06.2018 21:30, Steven Rostedt wrote:
>> +/** Linked list of tasks. */
> Note, the Linux kernel doc way of doing these types of comments is like
> this:
> 
> /**
>   * kshark_task_list - Linked list of tasks
>   * @next:	Pointer to the text task's PID
>   * @pid:	PID of a task.
>   */
> 

If we want to be able to produce Doxygen documentation for the code we 
have to stick to the Doxygen syntax for comments.

>> +struct kshark_task_list {
>> +	/** Pointer to the next task's PID. */
>> +	struct kshark_task_list	*next;
>> +
>> +	/** PID of a task. */
>> +	int			 pid;
>> +};
>> +
>> +/** Structure representing a kshark session. */
>> +struct kshark_context {
>> +	/** Input handle for the trace data file. */
>> +	struct tracecmd_input	*handle;
>> +
>> +	/** Page event used to parse the page. */
>> +	struct pevent		*pevt;
>> +
>> +	/** List of task's PIDs. */
>> +	struct kshark_task_list	*tasks;
>> +
>> +	/** A mutex, used to protect the access to the input file. */
>> +	pthread_mutex_t input_mutex;
>> +};
>> +
>> +/**
>> + * @brief Initialize a kshark session. This function must be called before calling any
>> + * other kshark function. If the session has been initialized, this function can be used
>> + * to obtain the session's context.
>> + * @param kshark_ctx: Optional input/output location for context pointer. Only valid on
>> + * return true.
>> + * @returns true on success, or false on failure.
> Looks like you have a different set of commands for the doxygen
> comments than the kernel uses. Of course, the kernel may be using
> "kernel doc" format. I'm not an expert on this. But I would prefer to
> keep it more like what the kernel does.
> 
> How hard would it be to switch over?

I have no experience with "kernel doc", so I have no idea if it will be 
easy or hard. I can try to investigate, but this will take some time.
I this the way to go?

Thanks!
Yordan
