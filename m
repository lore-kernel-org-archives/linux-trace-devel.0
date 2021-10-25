Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12863C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Oct 2021 07:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCA1F60E05
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Oct 2021 07:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhJYHuw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Oct 2021 03:50:52 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.159]:23400 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231967AbhJYHuv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 03:50:51 -0400
X-Greylist: delayed 1323 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Oct 2021 03:50:51 EDT
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 98A9B400D3D45
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Oct 2021 02:26:25 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id euNFmJ09lgm2UeuNFmCaVP; Mon, 25 Oct 2021 02:26:25 -0500
X-Authority-Reason: nr=8
Received: from host-79-18-63-114.retail.telecomitalia.it ([79.18.63.114]:60726 helo=[10.0.0.35])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1meuNE-003kSD-Cc; Mon, 25 Oct 2021 02:26:24 -0500
Message-ID: <caf1defa-94b7-22fe-c0cc-f5a5a2e8ee79@kernel.org>
Date:   Mon, 25 Oct 2021 09:26:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH V4 01/19] trace/osnoise: Do not follow tracing_cpumask
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>, Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1634820694.git.bristot@kernel.org>
 <e5382c01f1330bf4c3d094fbb87059ef82761aa0.1634820694.git.bristot@kernel.org>
 <20211022222301.32c2d869@rorschach.local.home>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20211022222301.32c2d869@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 79.18.63.114
X-Source-L: No
X-Exim-ID: 1meuNE-003kSD-Cc
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-18-63-114.retail.telecomitalia.it ([10.0.0.35]) [79.18.63.114]:60726
X-Source-Auth: kernel@bristot.me
X-Email-Count: 2
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10/23/21 04:23, Steven Rostedt wrote:
> On Thu, 21 Oct 2021 14:56:39 +0200
> Daniel Bristot de Oliveira <bristot@kernel.org> wrote:
> 
>> In preparation to support multiple instances, decople the
> 
>     "decouple"
> 
>> osnoise/timelat workload from instance specific tracing_cpumask.
>>
>> Different instances can have conflicing cpumasks, making osnoise
> 
>    "conflicting"
> 
> May I suggest a spell check for your commit logs? ;-)



Ooops, I will fix them. I use Grammarly on most of my texts, but sometimes I
forget to re-check.

>> workload management needlessly complex. Osnoise already have its
>> global cpu mask.
>>
>> I also thought about using the first instance mask, but the
>> "first" instance could be removed before the others.
>>
>> This also fixes the problem that changing the tracing_mask was not
>> re-starting the trace.
>>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Tom Zanussi <zanussi@kernel.org>
>> Cc: Masami Hiramatsu <mhiramat@kernel.org>
>> Cc: Juri Lelli <juri.lelli@redhat.com>
>> Cc: Clark Williams <williams@redhat.com>
>> Cc: John Kacur <jkacur@redhat.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
>> Cc: linux-rt-users@vger.kernel.org
>> Cc: linux-trace-devel@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
>> ---
>>  kernel/trace/trace_osnoise.c | 25 +++++++------------------
>>  1 file changed, 7 insertions(+), 18 deletions(-)
>>
>> diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
>> index ce053619f289..7b1f8187764c 100644
>> --- a/kernel/trace/trace_osnoise.c
>> +++ b/kernel/trace/trace_osnoise.c
>> @@ -1553,13 +1553,10 @@ static int start_per_cpu_kthreads(struct trace_array *tr)
>>  
>>  	cpus_read_lock();
>>  	/*
>> -	 * Run only on CPUs in which trace and osnoise are allowed to run.
>> +	 * Run only on online CPUs in which trace and osnoise are allowed to
> 
>   which trace and osnise? I thought we were removing "trace"?


You are correct, I will remove the trace from the comment.

Thanks!
-- Daniel

> -- Steve
> 
>> +	 * run.
>>  	 */
>> -	cpumask_and(current_mask, tr->tracing_cpumask, &osnoise_cpumask);
>> -	/*
>> -	 * And the CPU is online.
>> -	 */
>> -	cpumask_and(current_mask, cpu_online_mask, current_mask);
>> +	cpumask_and(current_mask, cpu_online_mask, &osnoise_cpumask);
>>  
>>  	for_each_possible_cpu(cpu)
>>  		per_cpu(per_cpu_osnoise_var, cpu).kthread = NULL;
>> @@ -1580,10 +1577,8 @@ static int start_per_cpu_kthreads(struct trace_array *tr)
>>  #ifdef CONFIG_HOTPLUG_CPU
>>  static void osnoise_hotplug_workfn(struct work_struct *dummy)
>>  {
>> -	struct trace_array *tr = osnoise_trace;
>>  	unsigned int cpu = smp_processor_id();
>>  
>> -
>>  	mutex_lock(&trace_types_lock);
>>  
>>  	if (!osnoise_busy)
>> @@ -1595,9 +1590,6 @@ static void osnoise_hotplug_workfn(struct work_struct *dummy)
>>  	if (!cpumask_test_cpu(cpu, &osnoise_cpumask))
>>  		goto out_unlock;
>>  
>> -	if (!cpumask_test_cpu(cpu, tr->tracing_cpumask))
>> -		goto out_unlock;
>> -
>>  	start_kthread(cpu);
>>  
>>  out_unlock:
>> @@ -1700,13 +1692,10 @@ static void osnoise_tracer_stop(struct trace_array *tr);
>>   * interface to the osnoise trace. By default, it lists all  CPUs,
>>   * in this way, allowing osnoise threads to run on any online CPU
>>   * of the system. It serves to restrict the execution of osnoise to the
>> - * set of CPUs writing via this interface. Note that osnoise also
>> - * respects the "tracing_cpumask." Hence, osnoise threads will run only
>> - * on the set of CPUs allowed here AND on "tracing_cpumask." Why not
>> - * have just "tracing_cpumask?" Because the user might be interested
>> - * in tracing what is running on other CPUs. For instance, one might
>> - * run osnoise in one HT CPU while observing what is running on the
>> - * sibling HT CPU.
>> + * set of CPUs writing via this interface. Why not use "tracing_cpumask"?
>> + * Because the user might be interested in tracing what is running on
>> + * other CPUs. For instance, one might run osnoise in one HT CPU
>> + * while observing what is running on the sibling HT CPU.
>>   */
>>  static ssize_t
>>  osnoise_cpus_write(struct file *filp, const char __user *ubuf, size_t count,
> 

