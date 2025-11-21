Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0402F28E5;
	Fri, 21 Nov 2025 18:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763750710; cv=none; b=qKiXYaicHI7qVxKVHx+lxA6rpZGUCC4vZsaSSjlyywJkeNvAmui+yddwvybWe2Gt1Ls7XUDmK+1V/mm9UNjRtjkMh1rXVuuLPgOhmAKkLd4dQRacWi0rX1BGhC87mYfYnWfFEqEN1DdTVbNoCAEbnIjV/h16wuylKCirD51fQPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763750710; c=relaxed/simple;
	bh=leXik3mMOVfJPuoeVLaxiHo3sVxfgHTSCNgqjHcBcAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r6m8wNX7mrfAPp5dUaAQYVW9f/DEWCcZf/0Agr4OVuSVZDJSG97/8qJTIwGv3QleH5l7CkwbzUcxNQSgxzmjEXvSXXtfzKOqbCv1o50WX7Del4nQDBmHpodXOqJcUzP0dfD3oz3IElpMTVdchNu2wj9WEvIaLqwSMYcUnYQRLa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=Sci+K38R; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=nSaGTQYv; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="Sci+K38R";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="nSaGTQYv"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4dCkfn6hy8z9tY3;
	Fri, 21 Nov 2025 19:45:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1763750706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J2DzMBuQ9QN5hwxGioLU7lB3f/YQbZ1zz4gcnWHUE18=;
	b=Sci+K38REYJSu98SOWIzUieQaOTiPna046Tk0EHA46GLBWYuh3XSKrblZJfCDmFTjNtowY
	KCOUejxAosgbcmPXWLJkLqM7+8sGqyFEbE9uNagxYjkoGkcUXbJxlA9MlbPBGkc+BdXLyL
	TE60Ldrs6+G/aDV6TdqhvFVUbUhaNFSpy6dXZiORHxva7y+n5g5JLpCS75SqsWy2Dhedza
	iptc1sYI8+mqJ0CUsg76yvBCeivT92Cx5SdfnfzMtY2usgoJUcjmudvZs3T/J6CMT6Hl0h
	f8A+ggwzZQOOuz0dDA20mg0IsWsZrXTjyrq2Kdv5MbGPKSuGLGdpWR3IN1D4mw==
Message-ID: <3716cf61-b1cc-43c6-84e3-cb4c62495549@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1763750704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J2DzMBuQ9QN5hwxGioLU7lB3f/YQbZ1zz4gcnWHUE18=;
	b=nSaGTQYvLoIqSszLEmgyQVs8zP9XwM8W1zwRUkZa9Yy0m8H8eP4ba/lP9pdfaELlC1G8Sm
	k+o5C6yyWj10gpn5gFXvFFqqMMHgup/+pUtuOXZCoIbddcvIpa6sVrPacv0JVKv1e9aRXo
	/v+B9DPSJxcKeUsB4a0+gdSHpJKt8o8UaPkZOITtqBLl+rCVg2VOCFD00t2Z2aVBX8r++J
	FFS7DxnjNk0MSYYvGSm2ppVHgkY5zChRJyfp7vAAS892oG7h3o+XmiO9Pkf6TKGl6uCxwZ
	0t24mNe7QX1BxQedtNoxz/VtN7DhJ9WiF1oFVRagEcdRDHTWS88jKrE4J6U0IQ==
Date: Fri, 21 Nov 2025 19:45:01 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] tracing: Fix several comment spelling mistakes
To: rostedt@goodmis.org, mingo@redhat.com
Cc: bristot@kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-devel@vger.kernel.org, mhi@mailbox.org
References: <20251116210302.141405-1-mhi@mailbox.org>
Content-Language: en-US, de-DE
From: Maurice Hieronymus <mhi@mailbox.org>
In-Reply-To: <20251116210302.141405-1-mhi@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-MBO-RS-ID: d591f85ce9f6f41aa37
X-MBO-RS-META: p88zaw3hxbcxfmb8xkewuw5d9gxie1p5

Hi Steven, hi Ingo,

I've just realized, that I send my patch against trace/master whereas
the current development seems to happen on trace/for-next.

I'm new to the mailing list, so please bear with me. Two question arise
for me:

Are you even interested in spelling fixes like I did below?

And if yes, does all the new development happens in general on
trace/for-next?

Thanks a lot for a quick reply. If I get a positive answer from you I
will resend my patch on the correct branch.

Cheers,

Maurice

On 11/16/25 22:03, Maurice Hieronymus wrote:
> Fix several spelling mistakes in comments in the trace subsystem.
> No functional changes. These fixes improve readability and correctness
> of comments in the tracing subsystem.
>
> Signed-off-by: Maurice Hieronymus <mhi@mailbox.org>
> ---
>  kernel/trace/Kconfig                 |  2 +-
>  kernel/trace/ring_buffer.c           |  2 +-
>  kernel/trace/ring_buffer_benchmark.c |  2 +-
>  kernel/trace/rv/Kconfig              |  2 +-
>  kernel/trace/rv/rv.c                 |  2 +-
>  kernel/trace/trace.c                 |  2 +-
>  kernel/trace/trace_events.c          |  2 +-
>  kernel/trace/trace_events_filter.c   |  2 +-
>  kernel/trace/trace_events_trigger.c  |  2 +-
>  kernel/trace/trace_events_user.c     |  4 ++--
>  kernel/trace/trace_osnoise.c         | 16 ++++++++--------
>  kernel/trace/trace_seq.c             |  2 +-
>  12 files changed, 20 insertions(+), 20 deletions(-)
>
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 1052126bdca2..87bc271c0b9d 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -918,7 +918,7 @@ config RING_BUFFER_RECORD_RECURSION
>  	default y
>  	help
>  	  The ring buffer has its own internal recursion. Although when
> -	  recursion happens it wont cause harm because of the protection,
> +	  recursion happens it won't cause harm because of the protection,
>  	  but it does cause an unwanted overhead. Enabling this option will
>  	  place where recursion was detected into the ftrace "recursed_functions"
>  	  file.
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index d59b6a328b7f..74f8143dda8a 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -5966,7 +5966,7 @@ static __init int test_ringbuffer(void)
>  	/*
>  	 * Show buffer is enabled before setting rb_test_started.
>  	 * Yes there's a small race window where events could be
> -	 * dropped and the thread wont catch it. But when a ring
> +	 * dropped and the thread won't catch it. But when a ring
>  	 * buffer gets enabled, there will always be some kind of
>  	 * delay before other CPUs see it. Thus, we don't care about
>  	 * those dropped events. We care about events dropped after
> diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
> index 78e576575b79..62a3d26e591e 100644
> --- a/kernel/trace/ring_buffer_benchmark.c
> +++ b/kernel/trace/ring_buffer_benchmark.c
> @@ -431,7 +431,7 @@ static int __init ring_buffer_benchmark_init(void)
>  {
>  	int ret;
>  
> -	/* make a one meg buffer in overwite mode */
> +	/* make a one meg buffer in overwrite mode */
>  	buffer = ring_buffer_alloc(1000000, RB_FL_OVERWRITE);
>  	if (!buffer)
>  		return -ENOMEM;
> diff --git a/kernel/trace/rv/Kconfig b/kernel/trace/rv/Kconfig
> index 831779607e84..b76ba1aad0a0 100644
> --- a/kernel/trace/rv/Kconfig
> +++ b/kernel/trace/rv/Kconfig
> @@ -45,7 +45,7 @@ config RV_MON_WWNR
>  	help
>  	  Enable wwnr (wakeup while not running) sample monitor, this is a
>  	  sample monitor that illustrates the usage of per-task monitor.
> -	  The model is borken on purpose: it serves to test reactors.
> +	  The model is broken on purpose: it serves to test reactors.
>  
>  	  For further information, see:
>  	    Documentation/trace/rv/monitor_wwnr.rst
> diff --git a/kernel/trace/rv/rv.c b/kernel/trace/rv/rv.c
> index 6c97cc2d754a..d523accb1cbd 100644
> --- a/kernel/trace/rv/rv.c
> +++ b/kernel/trace/rv/rv.c
> @@ -41,7 +41,7 @@
>   * per-task monitor, and so on), and the helper functions that glue the
>   * monitor to the system via trace. Generally, a monitor includes some form
>   * of trace output as a reaction for event parsing and exceptions,
> - * as depicted bellow:
> + * as depicted below:
>   *
>   * Linux  +----- RV Monitor ----------------------------------+ Formal
>   *  Realm |                                                   |  Realm
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index d3005279165d..55b99081ce4e 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -124,7 +124,7 @@ cpumask_var_t __read_mostly	tracing_buffer_mask;
>   * If there is an oops (or kernel panic) and the ftrace_dump_on_oops
>   * is set, then ftrace_dump is called. This will output the contents
>   * of the ftrace buffers to the console.  This is very useful for
> - * capturing traces that lead to crashes and outputing it to a
> + * capturing traces that lead to crashes and outputting it to a
>   * serial console.
>   *
>   * It is default off, but you can enable it with either specifying
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 0356cae0cf74..b7312247eaa6 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -611,7 +611,7 @@ static int __ftrace_event_enable_disable(struct trace_event_file *file,
>  		 *
>  		 * When soft_disable is not set but the SOFT_MODE flag is,
>  		 * we do nothing. Do not disable the tracepoint, otherwise
> -		 * "soft enable"s (clearing the SOFT_DISABLED bit) wont work.
> +		 * "soft enable"s (clearing the SOFT_DISABLED bit) won't work.
>  		 */
>  		if (soft_disable) {
>  			if (atomic_dec_return(&file->sm_ref) > 0)
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 4b1057ab9d96..cd67ce285fc4 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -92,7 +92,7 @@ static bool is_not(const char *str)
>  }
>  
>  /**
> - * prog_entry - a singe entry in the filter program
> + * prog_entry - a single entry in the filter program
>   * @target:	     Index to jump to on a branch (actually one minus the index)
>   * @when_to_branch:  The value of the result of the predicate to do a branch
>   * @pred:	     The predicate to execute.
> diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
> index 918730d74932..d6abd5fa8c93 100644
> --- a/kernel/trace/trace_events_trigger.c
> +++ b/kernel/trace/trace_events_trigger.c
> @@ -650,7 +650,7 @@ static void unregister_trigger(char *glob,
>   *   param             - text following cmd and ':' and stripped of filter
>   *   filter            - the optional filter text following (and including) 'if'
>   *
> - * To illustrate the use of these componenents, here are some concrete
> + * To illustrate the use of these components, here are some concrete
>   * examples. For the following triggers:
>   *
>   *   echo 'traceon:5 if pid == 0' > trigger
> diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
> index a6621c52ce45..f26f99c0ed21 100644
> --- a/kernel/trace/trace_events_user.c
> +++ b/kernel/trace/trace_events_user.c
> @@ -189,7 +189,7 @@ static int user_field_array_size(const char *type)
>  
>  static int user_field_size(const char *type)
>  {
> -	/* long is not allowed from a user, since it's ambigious in size */
> +	/* long is not allowed from a user, since it's ambiguous in size */
>  	if (strcmp(type, "s64") == 0)
>  		return sizeof(s64);
>  	if (strcmp(type, "u64") == 0)
> @@ -227,7 +227,7 @@ static int user_field_size(const char *type)
>  	if (str_has_prefix(type, "__rel_loc "))
>  		return sizeof(u32);
>  
> -	/* Uknown basic type, error */
> +	/* Unknown basic type, error */
>  	return -EINVAL;
>  }
>  
> diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
> index 313439920a8c..d66862ac2567 100644
> --- a/kernel/trace/trace_osnoise.c
> +++ b/kernel/trace/trace_osnoise.c
> @@ -326,7 +326,7 @@ static struct osnoise_data {
>  	u64	print_stack;		/* print IRQ stack if total > */
>  	int	timerlat_tracer;	/* timerlat tracer */
>  #endif
> -	bool	tainted;		/* infor users and developers about a problem */
> +	bool	tainted;		/* info users and developers about a problem */
>  } osnoise_data = {
>  	.sample_period			= DEFAULT_SAMPLE_PERIOD,
>  	.sample_runtime			= DEFAULT_SAMPLE_RUNTIME,
> @@ -737,7 +737,7 @@ cond_move_thread_delta_start(struct osnoise_variables *osn_var, u64 duration)
>  /*
>   * get_int_safe_duration - Get the duration of a window
>   *
> - * The irq, softirq and thread varaibles need to have its duration without
> + * The irq, softirq and thread variables need to have its duration without
>   * the interference from higher priority interrupts. Instead of keeping a
>   * variable to discount the interrupt interference from these variables, the
>   * starting time of these variables are pushed forward with the interrupt's
> @@ -1182,7 +1182,7 @@ trace_sched_switch_callback(void *data, bool preempt,
>  }
>  
>  /*
> - * hook_thread_events - Hook the insturmentation for thread noise
> + * hook_thread_events - Hook the instrumentation for thread noise
>   *
>   * Hook the osnoise tracer callbacks to handle the noise from other
>   * threads on the necessary kernel events.
> @@ -1199,9 +1199,9 @@ static int hook_thread_events(void)
>  }
>  
>  /*
> - * unhook_thread_events - *nhook the insturmentation for thread noise
> + * unhook_thread_events - Unhook the instrumentation for thread noise
>   *
> - * Unook the osnoise tracer callbacks to handle the noise from other
> + * Unhook the osnoise tracer callbacks to handle the noise from other
>   * threads on the necessary kernel events.
>   */
>  static void unhook_thread_events(void)
> @@ -1330,7 +1330,7 @@ static int run_osnoise(void)
>  	stop_in = osnoise_data.stop_tracing * NSEC_PER_USEC;
>  
>  	/*
> -	 * Start timestemp
> +	 * Start timestamp
>  	 */
>  	start = time_get();
>  
> @@ -1664,7 +1664,7 @@ static int timerlat_main(void *data)
>  	tlat->kthread = current;
>  	osn_var->pid = current->pid;
>  	/*
> -	 * Anotate the arrival time.
> +	 * Annotate the arrival time.
>  	 */
>  	tlat->abs_period = hrtimer_cb_get_time(&tlat->timer);
>  
> @@ -1734,7 +1734,7 @@ static void stop_per_cpu_kthreads(void)
>  }
>  
>  /*
> - * start_kthread - Start a workload tread
> + * start_kthread - Start a workload thread
>   */
>  static int start_kthread(unsigned int cpu)
>  {
> diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
> index 9c90b3a7dce2..ec63d0ae6a22 100644
> --- a/kernel/trace/trace_seq.c
> +++ b/kernel/trace/trace_seq.c
> @@ -18,7 +18,7 @@
>   *
>   * A write to the buffer will either succeed or fail. That is, unlike
>   * sprintf() there will not be a partial write (well it may write into
> - * the buffer but it wont update the pointers). This allows users to
> + * the buffer but it won't update the pointers). This allows users to
>   * try to write something into the trace_seq buffer and if it fails
>   * they can flush it and try again.
>   *
>
> base-commit: 70575e77839f4c5337ce2653b39b86bb365a870e

