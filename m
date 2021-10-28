Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977C8C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 02:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 758EF6112E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 02:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhJ1CxV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 22:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhJ1CxV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 22:53:21 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F33B61100;
        Thu, 28 Oct 2021 02:50:53 +0000 (UTC)
Date:   Wed, 27 Oct 2021 22:50:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Tao Zhou <tao.zhou@linux.dev>, Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V6 06/20] trace/osnoise: Allow multiple instances of the
 same tracer
Message-ID: <20211027225051.20ffef90@rorschach.local.home>
In-Reply-To: <69cbbd98cce2515c84127c8827d733dc87b04823.1635284863.git.bristot@kernel.org>
References: <cover.1635284863.git.bristot@kernel.org>
        <69cbbd98cce2515c84127c8827d733dc87b04823.1635284863.git.bristot@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 27 Oct 2021 00:06:17 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

>  static int osnoise_tracer_init(struct trace_array *tr)
>  {
> -
> -	/* Only allow one instance to enable this */
> -	if (osnoise_has_registered_instances())
> +	/*
> +	 * Only allow osnoise tracer if timerlat tracer is not running
> +	 * already.
> +	 */
> +	if (osnoise_data.timerlat_tracer)
>  		return -EBUSY;
>  

This fails to build when timerlat is not enabled:

/work/git/linux-trace.git/kernel/trace/trace_osnoise.c: In function ‘osnoise_tracer_init’:
/work/git/linux-trace.git/kernel/trace/trace_osnoise.c:2161:18: error: ‘struct osnoise_data’ has no member named ‘timerlat_tracer’
 2161 |  if (osnoise_data.timerlat_tracer)
      |                  ^
make[3]: *** [/work/git/linux-trace.git/scripts/Makefile.build:277: kernel/trace/trace_osnoise.o] Error 1


Also, I hate all the #ifdef muckery in this file. What you need is:

static struct osnoise_data {
	u64	sample_period;		/* total sampling period */
	u64	sample_runtime;		/* active sampling portion of period */
	u64	stop_tracing;		/* stop trace in the internal operation (loop/irq) */
	u64	stop_tracing_total;	/* stop trace in the final operation (report/thread) */
#ifdef CONFIG_TIMERLAT_TRACER
	u64	timerlat_period;	/* timerlat period */
	u64	print_stack;		/* print IRQ stack if total > */
	int	timerlat_tracer;	/* timerlat tracer */
#endif
	bool	tainted;		/* infor users and developers about a problem */
} osnoise_data = {
	.sample_period			= DEFAULT_SAMPLE_PERIOD,
	.sample_runtime			= DEFAULT_SAMPLE_RUNTIME,
	.stop_tracing			= 0,
	.stop_tracing_total		= 0,
#ifdef CONFIG_TIMERLAT_TRACER
	.print_stack			= 0,
	.timerlat_period		= DEFAULT_TIMERLAT_PERIOD,
	.timerlat_tracer		= 0,
#endif
};


#ifdef CONFIG_TIMERLAT_TRACER
static bool timerlat_enbabled()
{
	return osnoise_data.timerlat_tracer;
}
static void timerlat_softirq_exit(void)
{
	struct timerlat_variables *tlat_var;
	tlat_var = this_cpu_tmr_var();
	if (!tlat_var->tracing_thread) {
		osn_var->softirq.arrival_time = 0;
		osn_var->softirq.delta_start = 0;
	}
}
#else
static inline bool timerlat_enbabled()
{
	return false;
}
static void timerlat_softirq_exit(void) { }
#endif

Then in places like trace_softirq_exit_callback() you can have:

	if (unlikely(timerlat_enabled())
		timerlat_softirq_exit();

And this will help in making mistakes like you did with the compile
failure.

So there should be no #ifdef in any functions (it's fine to wrap
functions).

-- Steve
