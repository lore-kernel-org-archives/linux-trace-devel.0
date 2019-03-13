Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A88DCC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 08:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79EF92147C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 08:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfCMI0h (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 04:26:37 -0400
Received: from s30320.gliwa.com ([148.251.52.238]:51516 "EHLO mail.gliwa.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbfCMI0g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 04:26:36 -0400
Received: by mail.gliwa.com (Postfix, from userid 992)
        id 3EE36340FB8; Wed, 13 Mar 2019 09:26:34 +0100 (CET)
X-Virus-Checker-Version: ClamAV 0.101.1/25386/Tue Mar 12 09:15:09 2019
X-Virus-Status: OK
Received: from [192.168.2.102] (dslb-178-003-217-045.178.003.pools.vodafone-ip.de [178.3.217.45])
        by mail.gliwa.com (Postfix) with ESMTPSA id 09F36340A34;
        Wed, 13 Mar 2019 09:26:34 +0100 (CET)
Subject: Re: make TGID available also in binary ring buffer?
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     joel@joelfernandes.org,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>, Chunyu Hu <chuhu@redhat.com>
References: <6e61f5ff-5302-ad96-66d3-38347bf3cf69@gliwa.com>
 <20190304135147.5fcc243f@gandalf.local.home>
From:   Claudio <claudio.fontana@gliwa.com>
Message-ID: <ac830875-ca55-9978-1ece-4614fd988d29@gliwa.com>
Date:   Wed, 13 Mar 2019 09:26:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190304135147.5fcc243f@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 3/4/19 7:51 PM, Steven Rostedt wrote:
> On Mon, 4 Mar 2019 11:01:39 +0100
> Claudio <claudio.fontana@gliwa.com> wrote:
> 
>> Hello all,
>>
>> I am currently facing the issue of having to efficiently read the events
>> from a user-space application for tracing for programmatic use in automotive
>> (AUTOSAR AP).
>>
>> It is for programmatically reacting to events on the system,
>> and I am currently using the trace_pipe_raw to do that, to reduce the
>> overhead compared with parsing the textual output of trace_pipe.
>>
>> After merging the sorted streams from all cpus, in order to reconstruct
>> the task state, we are still way more CPU-efficient compared with using the
>> textual output.
>>
>> I would like to make use of the implemented support for recording tgids,
>>
>> commit d914ba37d714 ("tracing: Add support for recording tgid of tasks")
>> commit 441dae8f2f29 ("tracing: Add support for display of tgid in trace output")
>>
>> but it seems to me that, while for COMM recording there is explicit support in
>> the binary events for the information, it seems that tgid is not stored in the
>> binary format.
>>
>> Is such an extension of the binary format a possibility for sched-class
>> events, that takes into account backward compatibility, or is there some
>> better way to do it? Is this problem addressed by libtracevent / trace-cmd?
>>
>> Currently I was thinking to look into the NETLINK interface to get the task
>> information, however the issue is the race condition between the time of
>> tracing and the time of reading the trace, to be fully correct, but if
>> nothing else is possible I will have to accept the compromise.
>>
>> Thank you for any hints on this.
> 
> It looks to be outputted into /sys/kernel/debug/tracing/saved_tgids
> 
> Interesting, we should probably save that in trace-cmd as well.
> 
> -- Steve
> 

Hi Steve,

I have two questions regarding saved_tgids which are currently blocking and confusing me.

1) Are the saved_tgids not present in a tracing instance?
I am currently interacting with ftrace from the application doing everything in an instance,

tracefs on /usr/local/var/run/T1/tracing type tracefs (rw,relatime)

but the saved_tgids is not present in my instance directory.

2) Which state does "saved_tgids" represent, ie when is it updated?

The ftrace.rst doc says at each context switch, but wouldn't sched_process_fork / sched_process_free tracepoints be a better place to update?

When I read an event for a new process or thread (sched_process_fork),
I need to know if it is a new thread or a new process at that time, and collect the tgid of the child.

How can I get that information, if the update is done only at the time of the first "child" context-switch?

3) Is the saved_tgids map in sync with the reader of trace_pipe_raw,
so that when reading an event from the pipe, the saved_tgids represent the particular state of the tid to tgid maps at the timestamp indicated in the event?

Or is the saved_tgids map updated asynchronously with the reader?

Thank you for any advice on this..

Ciao,

Claudio
