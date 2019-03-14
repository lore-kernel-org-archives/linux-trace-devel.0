Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175B7C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 21:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB62F2064C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 21:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfCNVkM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 17:40:12 -0400
Received: from s30320.gliwa.com ([148.251.52.238]:54784 "EHLO mail.gliwa.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbfCNVkM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 17:40:12 -0400
Received: by mail.gliwa.com (Postfix, from userid 992)
        id 800653411E4; Thu, 14 Mar 2019 22:40:10 +0100 (CET)
X-Virus-Checker-Version: ClamAV 0.101.1/25388/Thu Mar 14 10:10:01 2019
X-Virus-Status: OK
Received: from [192.168.2.102] (dslb-178-003-217-045.178.003.pools.vodafone-ip.de [178.3.217.45])
        by mail.gliwa.com (Postfix) with ESMTPSA id 3EEC93411DB;
        Thu, 14 Mar 2019 22:40:10 +0100 (CET)
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
 <5cfad70b-b823-e3ed-630e-d766cc53f6e5@gliwa.com>
 <20190314142034.35469af8@gandalf.local.home>
From:   Claudio <claudio.fontana@gliwa.com>
Message-ID: <82d5c999-f316-7da8-9347-2a8d0e19b78b@gliwa.com>
Date:   Thu, 14 Mar 2019 22:40:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190314142034.35469af8@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Evening Steve,

On 3/14/19 7:20 PM, Steven Rostedt wrote:
> On Thu, 14 Mar 2019 17:06:11 +0100
> Claudio <claudio.fontana@gliwa.com> wrote:
> 
>> Hi Steve,
>>
>> I have experimented with mainline, and then with mainline plus a patch to add the info for fork as well like this:
>>
>> diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
>> index e288168..c5339ed 100644
>> --- a/kernel/trace/trace_sched_switch.c
>> +++ b/kernel/trace/trace_sched_switch.c
>> @@ -47,6 +47,20 @@ probe_sched_wakeup(void *ignore, struct task_struct *wakee)
>>  	tracing_record_taskinfo(current, flags);
>>  }
>>  
>> +static void
>> +probe_sched_fork(void *ignore,
>> +		 struct task_struct *parent, struct task_struct *child)
>> +{
>> +	int flags;
>> +
>> +	flags = (RECORD_TGID * !!sched_tgid_ref) +
>> +		(RECORD_CMDLINE * !!sched_cmdline_ref);
>> +
>> +	if (!flags)
>> +		return;
>> +	tracing_record_taskinfo(child, flags);
>> +}
>> +
>>  static int tracing_sched_register(void)
>>  {
>>  	int ret;
>> @@ -72,7 +86,16 @@ static int tracing_sched_register(void)
>>  		goto fail_deprobe_wake_new;
>>  	}
>>  
>> +	ret = register_trace_sched_process_fork(probe_sched_fork, NULL);
>> +	if (ret) {
>> +		pr_info("sched trace: Couldn't activate tracepoint"
>> +			" probe to kernel_sched_process_fork\n");
>> +		goto fail_deprobe_switch;
>> +	}
>> +
>>  	return ret;
>> +fail_deprobe_switch:
>> +	unregister_trace_sched_switch(probe_sched_switch, NULL);
>>  fail_deprobe_wake_new:
>>  	unregister_trace_sched_wakeup_new(probe_sched_wakeup, NULL);
>>  fail_deprobe:
>> @@ -82,6 +105,7 @@ static int tracing_sched_register(void)
>>  
>>  static void tracing_sched_unregister(void)
>>  {
>> +	unregister_trace_sched_process_fork(probe_sched_fork, NULL);
>>  	unregister_trace_sched_switch(probe_sched_switch, NULL);
>>  	unregister_trace_sched_wakeup_new(probe_sched_wakeup, NULL);
>>  	unregister_trace_sched_wakeup(probe_sched_wakeup, NULL);
>>
>>
>> --
>>
>> It seems to work, but the model seems not to apply very well to my use case.
>>
>> saved_tgids cannot be reset, not even by disabling tracing completely
>>
>> echo 0 > tracing_on
>>
>> or 
>>
>> echo 0 > options/record-tgids
>>
>> and the list just keeps growing, no entries are ever removed when tasks are destroyed etc,
>> so my lookups become more and more expensive as the list grows.
>> I don't think this is suited to be looked up frequently for my tracing scenario.
>>
> 
> It shouldn't grow when you disable tracing though.
> 
> Hmm, we could add a reset if one writes to the saved_* files.
> 
>> Next I will experiment with:
>>
>> 1) kprobes, trying to generate an event before every sched class event carrying the tid to tgid mapping.
> 
> Just plop a kprobe on top of __schedule()
> 
> -- Steve

I seem to need a few of those; but it works.
However the userspace application becomes very tied to the specific kernel version and arch,
or am I missing something? Maybe there is something less tied to the kernel than the following example?

echo 'p:kprobes/wakeup_tgid ttwu_do_wakeup arg1=+2220($arg2):x32' > kprobe_events

>>
>> 2) if everything fails, revert to use /proc/PID/stat, which however can be slow and racy if the process does not exist anymore when I read back the ftrace buffers.

indeed it breaks easiy; If I just had a tgid inside the sched events format..

Anyway, will pick it up tomorrow.

Thank you, ciao,

Claudio

