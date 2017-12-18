Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mx1.redhat.com ([209.132.183.28]:40290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934847AbdLRQX0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Dec 2017 11:23:26 -0500
Subject: Re: [PATCH v1] trace-cmd: introduce --initital-delay for record
 command
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20171218112412.11898-1-david@redhat.com>
 <20171218104158.22519a7e@gandalf.local.home>
From: David Hildenbrand <david@redhat.com>
Message-ID: <7b89f63f-3a6f-4182-c26a-934514ba5670@redhat.com>
Date: Mon, 18 Dec 2017 17:23:24 +0100
MIME-Version: 1.0
In-Reply-To: <20171218104158.22519a7e@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On 18.12.2017 16:41, Steven Rostedt wrote:
> On Mon, 18 Dec 2017 12:24:12 +0100
> David Hildenbrand <david@redhat.com> wrote:
> 
>> If recording a big number of events to a big buffer, one might want to
>> minimize the trace-cmd activity for a certain period in time.
>> Especially, don't see any trace-cmd activity for some time. If there are
>> a lot of events, the loop might actually never sleep, resulting in the
>> "-s" option never becomming active.
>>
>> E.g. I am using scheduler events to trace thread activity per CPU. Esp.
>> sched:sched_wakeup and sched:sched_stat_runtime. Even when setting the
>> sleep time to something huge like 30 seconds, I can see constant activity
>> from the trace-cmd tasks.
> 
> Thanks for reporting this. Honestly, I believe this is fixing a symptom
> of a real problem. I'd like to investigate why trace-cmd is running
> with a sleep time of 30 seconds. I think that should be fixed.
> 

The problem seems to be that we only sleep if we haven't read something
in the last iteration (!read), hindering us to sleep if there are many
events. Especially on the first run.

If tracing e.g. the scheduler, after each iteration there will already
be new data to pick up in the buffer, resulting in the thread never
going to sleep.

What I need: Start tracing and flush all buffers when exiting. (e.g.
after 30 seconds). Never wakeup in between, so the real trace overhead
in that period of time is purely storing the tracepoints to the buffer
in the kernel. Of course we could implement something like that ("copy
from the buffer only when exiting") or try to see if we can fix the
existing "-s" flag in a way that allows it.

Thanks!

> -- Steve
> 


-- 

Thanks,

David / dhildenb
