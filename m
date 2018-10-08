Return-Path: <SRS0=f4gm=MU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from s30320.gliwa.com ([148.251.52.238]:52594 "EHLO mail.gliwa.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbeJICcH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Oct 2018 22:32:07 -0400
Subject: Re: ftrace global trace_pipe_raw
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, jens <jens.meier@gliwa.com>
References: <73e2f61e-7e7b-d8be-6c94-896cf94e7567@gliwa.com>
 <20180709113257.79152dd0@gandalf.local.home>
 <7dfce43c-afd3-52ee-4c58-ef6a3b1be5fd@gliwa.com>
 <20180724102316.41cdb8a1@gandalf.local.home>
 <20180724102506.42114a68@gandalf.local.home>
 <aa0799d4-6eaa-58fa-03fa-0b8a4f7a6890@gliwa.com>
 <20181008121618.0510159f@gandalf.local.home>
From: Claudio <claudio.fontana@gliwa.com>
Message-ID: <ac424b7c-5449-16fc-4d4f-64641bcc4964@gliwa.com>
Date: Mon, 8 Oct 2018 21:18:48 +0200
MIME-Version: 1.0
In-Reply-To: <20181008121618.0510159f@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Steven,

thank you for your answer,

On 10/08/2018 06:16 PM, Steven Rostedt wrote:
> On Mon, 8 Oct 2018 18:07:49 +0200
> Claudio <claudio.fontana@gliwa.com> wrote:
> 
>> Hello Steven,
>>
>> On 07/24/2018 04:25 PM, Steven Rostedt wrote:
>>> On Tue, 24 Jul 2018 10:23:16 -0400
>>> Steven Rostedt <rostedt@goodmis.org> wrote:
>>>   
>>>>>
>>>>> Would work in the direction of adding a global trace_pipe_raw be considered
>>>>> for inclusion?    
>>>>
>>>> The design of the lockless ring buffer requires not to be preempted,
>>>> and that the data cannot be written to from more than one location. To
>>>> do so, we make a per CPU buffer, and disable preemption when writing.
>>>> This means that we have only one writer at a time. It can handle
>>>> interrupts and NMIs, because they will finish before they return and
>>>> this doesn't break the algorithm. But having writers from multiple CPUs
>>>> would require locking or other heaving synchronization operations that
>>>> will greatly reduce the speed of writing to the buffers (not to mention
>>>> the cache thrashing).  
>>>
>>> And why would you need a single buffer? Note, we are working on making
>>> libtracecmd.so that will allow applications to read the buffers and the
>>> library will take care of the interleaving of the raw data. This should
>>> hopefully be ready in about three months or so.
>>>
>>> -- Steve
>>>   
>>
>> Is this something you will showcase in the linux tracing summit?
>> Is there a repo / branch I should be following?
> 
> We are preparing the code in tools/lib/traceevent of the Linux kernel
> to turn that into a library.
> 
> At the same time, we are looking at making libtracecmd or perhaps we'll
> call it libftrace? to implement all the trace-cmd code as a library as
> well. But that's happening in the main trace-cmd repo:
> 
>  git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git
> 

I think that the binary raw event streaming aspect will be part of this last component right?

libftrace is way better as a name I think.


>>
>> The reason why we need to end up with a single stream of events is to be
>> able to do "online" task state correlation and timing parameters calculations
>> for all task-related events independent of cores.
> 
> Well, all the events are timestamped, and you can pick different clocks
> to use, and a simple merge sort gives all the information you need.

Yes, we are about to do the merge sorting of the streams ourselves,
but if the library does it, even better ;-)

> Note, having per cpu buffers makes things much more efficient as you
> don't need to do synchronizing with atomics.
> 
> -- Steve
> 
>>
>> Currently we have this on QNX, and we are trying to enable it for Linux as well.
>>
>> Thank you,
>>
>> Claudio
> 

Thanks,

Claudio
