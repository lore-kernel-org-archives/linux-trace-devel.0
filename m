Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 426EDC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 14:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4B4020811
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 14:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfCMODi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 10:03:38 -0400
Received: from s30320.gliwa.com ([148.251.52.238]:52276 "EHLO mail.gliwa.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbfCMODi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 10:03:38 -0400
Received: by mail.gliwa.com (Postfix, from userid 992)
        id 2DBA0341031; Wed, 13 Mar 2019 15:03:36 +0100 (CET)
X-Virus-Checker-Version: ClamAV 0.101.1/25387/Wed Mar 13 12:24:46 2019
X-Virus-Status: OK
Received: from [192.168.2.102] (dslb-178-003-217-045.178.003.pools.vodafone-ip.de [178.3.217.45])
        by mail.gliwa.com (Postfix) with ESMTPSA id DD090341005;
        Wed, 13 Mar 2019 15:03:35 +0100 (CET)
Subject: Re: make TGID available also in binary ring buffer?
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     joel@joelfernandes.org,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>, Chunyu Hu <chuhu@redhat.com>
References: <6e61f5ff-5302-ad96-66d3-38347bf3cf69@gliwa.com>
 <20190304135147.5fcc243f@gandalf.local.home>
 <ac830875-ca55-9978-1ece-4614fd988d29@gliwa.com>
 <20190313094417.7ed14ee0@gandalf.local.home>
From:   Claudio <claudio.fontana@gliwa.com>
Message-ID: <0ce98e8a-47b7-7890-500a-e0a2bc938b53@gliwa.com>
Date:   Wed, 13 Mar 2019 15:03:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190313094417.7ed14ee0@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

thank you for your answer,

On 3/13/19 2:44 PM, Steven Rostedt wrote:
> On Wed, 13 Mar 2019 09:26:33 +0100
> Claudio <claudio.fontana@gliwa.com> wrote:
> 
> 
>> 1) Are the saved_tgids not present in a tracing instance?
>> I am currently interacting with ftrace from the application doing everything in an instance,
> 
> Currently save_cmdlines and saved_tgids are only in the top level
> tracing directory, and are global for all tracing.
> 
> Thinking about this a bit more, it does make sense to make this an
> instance file, as we don't want instance tracing to remove the top
> level cached cmdlines.
> 
>>
>> tracefs on /usr/local/var/run/T1/tracing type tracefs (rw,relatime)
>>
>> but the saved_tgids is not present in my instance directory.
>>
>> 2) Which state does "saved_tgids" represent, ie when is it updated?
>>
>> The ftrace.rst doc says at each context switch, but wouldn't sched_process_fork / sched_process_free tracepoints be a better place to update?
> 
> Well, forks and free can happen after tracing, and they are only
> updated during the trace. We mostly want to see the tasks when they
> run, and the sched_switch is the best place to save them.
> 
>>
>> When I read an event for a new process or thread (sched_process_fork),
>> I need to know if it is a new thread or a new process at that time, and collect the tgid of the child.
> 
> You are reading this at the time of tracing?

Yes, my requirements are for live tracing of the low level events, and correlation of the events from all cores, in order to be able to immediately respond to the events from the tracing application.

Tracing is expected to be always on in the system (no expected trace-first/analyze later pattern - everything related to the analysis of the events is automated and occurs at runtime).

This works fine for the real time timing analysis at the thread level, but for the process level I need to know the tgid of the thread at the time I see the event.
 
>>
>> How can I get that information, if the update is done only at the time of the first "child" context-switch?
>>
>> 3) Is the saved_tgids map in sync with the reader of trace_pipe_raw,
>> so that when reading an event from the pipe, the saved_tgids represent the particular state of the tid to tgid maps at the timestamp indicated in the event?
> 
> Currently, it's only taken at the end of the trace.

I wonder what the concept of the "end of the trace" is..

> 
> -- Steve

Thank you very much,

Claudio


