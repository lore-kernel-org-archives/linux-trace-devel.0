Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA3BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 23 Oct 2021 02:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4151C6101C
	for <linux-trace-devel@archiver.kernel.org>; Sat, 23 Oct 2021 02:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhJWCZX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Oct 2021 22:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhJWCZX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Oct 2021 22:25:23 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D35960FF2;
        Sat, 23 Oct 2021 02:23:03 +0000 (UTC)
Date:   Fri, 22 Oct 2021 22:23:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
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
Subject: Re: [PATCH V4 01/19] trace/osnoise: Do not follow tracing_cpumask
Message-ID: <20211022222301.32c2d869@rorschach.local.home>
In-Reply-To: <e5382c01f1330bf4c3d094fbb87059ef82761aa0.1634820694.git.bristot@kernel.org>
References: <cover.1634820694.git.bristot@kernel.org>
        <e5382c01f1330bf4c3d094fbb87059ef82761aa0.1634820694.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 21 Oct 2021 14:56:39 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> In preparation to support multiple instances, decople the

    "decouple"

> osnoise/timelat workload from instance specific tracing_cpumask.
> 
> Different instances can have conflicing cpumasks, making osnoise

   "conflicting"

May I suggest a spell check for your commit logs? ;-)

> workload management needlessly complex. Osnoise already have its
> global cpu mask.
> 
> I also thought about using the first instance mask, but the
> "first" instance could be removed before the others.
> 
> This also fixes the problem that changing the tracing_mask was not
> re-starting the trace.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Tom Zanussi <zanussi@kernel.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Clark Williams <williams@redhat.com>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
> Cc: linux-rt-users@vger.kernel.org
> Cc: linux-trace-devel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
> ---
>  kernel/trace/trace_osnoise.c | 25 +++++++------------------
>  1 file changed, 7 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
> index ce053619f289..7b1f8187764c 100644
> --- a/kernel/trace/trace_osnoise.c
> +++ b/kernel/trace/trace_osnoise.c
> @@ -1553,13 +1553,10 @@ static int start_per_cpu_kthreads(struct trace_array *tr)
>  
>  	cpus_read_lock();
>  	/*
> -	 * Run only on CPUs in which trace and osnoise are allowed to run.
> +	 * Run only on online CPUs in which trace and osnoise are allowed to

  which trace and osnise? I thought we were removing "trace"?

-- Steve

> +	 * run.
>  	 */
> -	cpumask_and(current_mask, tr->tracing_cpumask, &osnoise_cpumask);
> -	/*
> -	 * And the CPU is online.
> -	 */
> -	cpumask_and(current_mask, cpu_online_mask, current_mask);
> +	cpumask_and(current_mask, cpu_online_mask, &osnoise_cpumask);
>  
>  	for_each_possible_cpu(cpu)
>  		per_cpu(per_cpu_osnoise_var, cpu).kthread = NULL;
> @@ -1580,10 +1577,8 @@ static int start_per_cpu_kthreads(struct trace_array *tr)
>  #ifdef CONFIG_HOTPLUG_CPU
>  static void osnoise_hotplug_workfn(struct work_struct *dummy)
>  {
> -	struct trace_array *tr = osnoise_trace;
>  	unsigned int cpu = smp_processor_id();
>  
> -
>  	mutex_lock(&trace_types_lock);
>  
>  	if (!osnoise_busy)
> @@ -1595,9 +1590,6 @@ static void osnoise_hotplug_workfn(struct work_struct *dummy)
>  	if (!cpumask_test_cpu(cpu, &osnoise_cpumask))
>  		goto out_unlock;
>  
> -	if (!cpumask_test_cpu(cpu, tr->tracing_cpumask))
> -		goto out_unlock;
> -
>  	start_kthread(cpu);
>  
>  out_unlock:
> @@ -1700,13 +1692,10 @@ static void osnoise_tracer_stop(struct trace_array *tr);
>   * interface to the osnoise trace. By default, it lists all  CPUs,
>   * in this way, allowing osnoise threads to run on any online CPU
>   * of the system. It serves to restrict the execution of osnoise to the
> - * set of CPUs writing via this interface. Note that osnoise also
> - * respects the "tracing_cpumask." Hence, osnoise threads will run only
> - * on the set of CPUs allowed here AND on "tracing_cpumask." Why not
> - * have just "tracing_cpumask?" Because the user might be interested
> - * in tracing what is running on other CPUs. For instance, one might
> - * run osnoise in one HT CPU while observing what is running on the
> - * sibling HT CPU.
> + * set of CPUs writing via this interface. Why not use "tracing_cpumask"?
> + * Because the user might be interested in tracing what is running on
> + * other CPUs. For instance, one might run osnoise in one HT CPU
> + * while observing what is running on the sibling HT CPU.
>   */
>  static ssize_t
>  osnoise_cpus_write(struct file *filp, const char __user *ubuf, size_t count,

