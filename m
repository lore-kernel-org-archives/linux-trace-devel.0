Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFD8C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 16:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B82102184C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 16:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfCNQGQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 12:06:16 -0400
Received: from s30320.gliwa.com ([148.251.52.238]:37758 "EHLO mail.gliwa.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfCNQGQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 12:06:16 -0400
Received: by mail.gliwa.com (Postfix, from userid 992)
        id C92E63411B4; Thu, 14 Mar 2019 17:06:12 +0100 (CET)
X-Virus-Checker-Version: ClamAV 0.101.1/25388/Thu Mar 14 10:10:01 2019
X-Virus-Status: OK
Received: from [192.168.2.102] (dslb-178-003-217-045.178.003.pools.vodafone-ip.de [178.3.217.45])
        by mail.gliwa.com (Postfix) with ESMTPSA id 9079D34119E;
        Thu, 14 Mar 2019 17:06:12 +0100 (CET)
Subject: Re: make TGID available also in binary ring buffer?
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     joel@joelfernandes.org,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>, Chunyu Hu <chuhu@redhat.com>
References: <6e61f5ff-5302-ad96-66d3-38347bf3cf69@gliwa.com>
 <20190304135147.5fcc243f@gandalf.local.home>
 <ac830875-ca55-9978-1ece-4614fd988d29@gliwa.com>
 <20190313094417.7ed14ee0@gandalf.local.home>
 <0ce98e8a-47b7-7890-500a-e0a2bc938b53@gliwa.com>
 <20190313105020.07bb8254@gandalf.local.home>
From:   Claudio <claudio.fontana@gliwa.com>
Message-ID: <5cfad70b-b823-e3ed-630e-d766cc53f6e5@gliwa.com>
Date:   Thu, 14 Mar 2019 17:06:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190313105020.07bb8254@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

On 3/13/19 3:50 PM, Steven Rostedt wrote:
> On Wed, 13 Mar 2019 15:03:35 +0100
> Claudio <claudio.fontana@gliwa.com> wrote:
> 
> 
>>>>
>>>> When I read an event for a new process or thread
>>>> (sched_process_fork), I need to know if it is a new thread or a
>>>> new process at that time, and collect the tgid of the child.  
>>>
>>> You are reading this at the time of tracing?  
>>
>> Yes, my requirements are for live tracing of the low level events,
>> and correlation of the events from all cores, in order to be able to
>> immediately respond to the events from the tracing application.
>>
>> Tracing is expected to be always on in the system (no expected
>> trace-first/analyze later pattern - everything related to the
>> analysis of the events is automated and occurs at runtime).
> 
> You could add a kprobe to find out the tgid as well.

I think I am going to try this next.


>>
>> This works fine for the real time timing analysis at the thread
>> level, but for the process level I need to know the tgid of the
>> thread at the time I see the event. 
>>>>
>>>> How can I get that information, if the update is done only at the
>>>> time of the first "child" context-switch?
>>>>
>>>> 3) Is the saved_tgids map in sync with the reader of
>>>> trace_pipe_raw, so that when reading an event from the pipe, the
>>>> saved_tgids represent the particular state of the tid to tgid maps
>>>> at the timestamp indicated in the event?  
>>>
>>> Currently, it's only taken at the end of the trace.  
>>
>> I wonder what the concept of the "end of the trace" is..
> 
> 
> I meant for "trace-cmd record", the saved_cmdlines are stored when the
> tracing is finished, not during the trace. But the saved_cmdlines is
> updated at each sched_switch, and so is the tgid.
> 
> Now, we could add that info to the fork part as well.
> 
> -- Steve
> 

I have experimented with mainline, and then with mainline plus a patch to add the info for fork as well like this:

diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index e288168..c5339ed 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -47,6 +47,20 @@ probe_sched_wakeup(void *ignore, struct task_struct *wakee)
 	tracing_record_taskinfo(current, flags);
 }
 
+static void
+probe_sched_fork(void *ignore,
+		 struct task_struct *parent, struct task_struct *child)
+{
+	int flags;
+
+	flags = (RECORD_TGID * !!sched_tgid_ref) +
+		(RECORD_CMDLINE * !!sched_cmdline_ref);
+
+	if (!flags)
+		return;
+	tracing_record_taskinfo(child, flags);
+}
+
 static int tracing_sched_register(void)
 {
 	int ret;
@@ -72,7 +86,16 @@ static int tracing_sched_register(void)
 		goto fail_deprobe_wake_new;
 	}
 
+	ret = register_trace_sched_process_fork(probe_sched_fork, NULL);
+	if (ret) {
+		pr_info("sched trace: Couldn't activate tracepoint"
+			" probe to kernel_sched_process_fork\n");
+		goto fail_deprobe_switch;
+	}
+
 	return ret;
+fail_deprobe_switch:
+	unregister_trace_sched_switch(probe_sched_switch, NULL);
 fail_deprobe_wake_new:
 	unregister_trace_sched_wakeup_new(probe_sched_wakeup, NULL);
 fail_deprobe:
@@ -82,6 +105,7 @@ static int tracing_sched_register(void)
 
 static void tracing_sched_unregister(void)
 {
+	unregister_trace_sched_process_fork(probe_sched_fork, NULL);
 	unregister_trace_sched_switch(probe_sched_switch, NULL);
 	unregister_trace_sched_wakeup_new(probe_sched_wakeup, NULL);
 	unregister_trace_sched_wakeup(probe_sched_wakeup, NULL);


--

It seems to work, but the model seems not to apply very well to my use case.

saved_tgids cannot be reset, not even by disabling tracing completely

echo 0 > tracing_on

or 

echo 0 > options/record-tgids

and the list just keeps growing, no entries are ever removed when tasks are destroyed etc,
so my lookups become more and more expensive as the list grows.
I don't think this is suited to be looked up frequently for my tracing scenario.

Next I will experiment with:

1) kprobes, trying to generate an event before every sched class event carrying the tid to tgid mapping.

2) if everything fails, revert to use /proc/PID/stat, which however can be slow and racy if the process does not exist anymore when I read back the ftrace buffers.

Thanks & ciao,

Claudio

